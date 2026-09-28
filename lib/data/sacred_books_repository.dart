import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import '../models/sacred_verse_model.dart';
import 'sacred_books_data.dart';

class SacredBooksRepository {
  SacredBooksRepository._();

  static FirebaseFirestore? _firestoreInstance;
  static FirebaseFirestore? get _firestore {
    try {
      return _firestoreInstance ??= FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  static final Map<String, SacredBookModel> _booksCache = {};
  static final Map<String, List<SacredChapterModel>> _chaptersCache = {};
  static final Map<String, List<SacredVerseModel>> _versesCache = {};

  static void clearCache() {
    _booksCache.clear();
    _chaptersCache.clear();
    _versesCache.clear();
  }

  // ============================================================
  // 1. HOME SCREEN: LIGHTWEIGHT BOOK METADATA STREAM (0ms DEEP FETCH)
  // ============================================================

  /// Live Stream of Book metadata ONLY for Home Screen and Explore cards.
  /// Does NOT download chapters or verses over the network.
  static Stream<List<SacredBookModel>> streamAllBooks() {
    late StreamController<List<SacredBookModel>> controller;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sub;

    controller = StreamController<List<SacredBookModel>>.broadcast(
      onListen: () {
        debugPrint('[PERF LOG] BOOK_QUERY_START: Subscribing to sacred_books collection metadata...');
        final stopwatch = Stopwatch()..start();

        // 1. Emit cached books immediately if available for 0ms delay
        final initialBooks = _getCachedOrFallbackBooks();
        controller.add(initialBooks);

        final db = _firestore;
        if (db == null) {
          stopwatch.stop();
          debugPrint('[PERF LOG] Firestore offline or unit test mode. Emitting fallback books in ${stopwatch.elapsedMilliseconds}ms.');
          return;
        }

        // 2. Listen to Firestore sacred_books metadata updates
        sub = db
            .collection('sacred_books')
            .snapshots()
            .listen(
          (snapshot) {
            stopwatch.stop();
            debugPrint('[PERF LOG] BOOK_QUERY_END: Received ${snapshot.docs.length} book documents in ${stopwatch.elapsedMilliseconds}ms.');

            if (snapshot.docs.isEmpty) {
              controller.add(SacredBooksData.all);
              return;
            }

            final List<SacredBookModel> books = [];
            for (final doc in snapshot.docs) {
              final data = Map<String, dynamic>.from(doc.data());
              data['id'] = doc.id;

              final isPub = data['published'] as bool? ?? data['is_published'] as bool? ?? (data['status'] == 'published' || data['status'] == null);
              final isArc = data['archived'] as bool? ?? (data['status'] == 'archived');

              if (isPub && !isArc) {
                final book = SacredBookModel.fromMap(data);
                books.add(book);
                _booksCache[book.id] = book;
              }
            }

            books.sort((a, b) => a.order.compareTo(b.order));
            controller.add(books.isNotEmpty ? books : SacredBooksData.all);
          },
          onError: (err) {
            debugPrint('[PERF LOG] BOOK_QUERY_ERROR: $err. Falling back to cached data.');
            controller.add(_getCachedOrFallbackBooks());
          },
        );
      },
      onCancel: () {
        sub?.cancel();
      },
    );

    return controller.stream;
  }

  static List<SacredBookModel> _getCachedOrFallbackBooks() {
    if (_booksCache.isNotEmpty) {
      final cached = _booksCache.values.where((b) => b.published && !b.archived).toList();
      cached.sort((a, b) => a.order.compareTo(b.order));
      if (cached.isNotEmpty) return cached;
    }
    return SacredBooksData.all;
  }

  // ============================================================
  // 2. BOOK DETAIL SCREEN: LAZY CHAPTER METADATA STREAM
  // ============================================================

  /// Stream a single book with lazily loaded chapters (no verses downloaded).
  static Stream<SacredBookModel?> streamBookById(String bookId) {
    late StreamController<SacredBookModel?> controller;
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? bookSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chapterSub;

    controller = StreamController<SacredBookModel?>.broadcast(
      onListen: () {
        debugPrint('[MOBILE BOOK] MOBILE BOOK: $bookId | FIRESTORE BOOK: $bookId');
        debugPrint('[PERF LOG] CHAPTER_QUERY_START: Subscribing to chapters for bookId=$bookId...');

        // Return initial cached version if present
        final cached = _booksCache[bookId] ?? _fallbackBook(bookId);
        controller.add(cached);

        final db = _firestore;
        if (db == null) return;

        final bookRef = db.collection('sacred_books').doc(bookId);

        bookSub = bookRef.snapshots().listen((bookSnap) {
          if (!bookSnap.exists || bookSnap.data() == null) {
            final fb = _fallbackBook(bookId);
            controller.add(fb);
            return;
          }

          final bookData = Map<String, dynamic>.from(bookSnap.data()!);
          bookData['id'] = bookSnap.id;
          final baseBook = SacredBookModel.fromMap(bookData);

          chapterSub?.cancel();
          chapterSub = bookRef.collection('chapters').snapshots().listen((chapSnap) {
            final List<SacredChapterModel> chapters = [];

            if (chapSnap.docs.isNotEmpty) {
              final activeChapDocs = chapSnap.docs.where((doc) {
                final d = doc.data();
                final isPub = d['published'] as bool? ?? d['is_published'] as bool? ?? (d['status'] == 'published' || d['status'] == null);
                final isArc = d['archived'] as bool? ?? (d['status'] == 'archived');
                if (!isPub || isArc) return false;

                if (bookId == 'ramayana') {
                  final docId = doc.id;
                  const staticIds = {'1', '2', '3', '4', '5', '6', '7'};
                  if (staticIds.contains(docId)) {
                    final hasDynamicDocs = chapSnap.docs.any((otherDoc) => !staticIds.contains(otherDoc.id));
                    if (hasDynamicDocs) {
                      return false;
                    }
                  }
                }

                return true;
              }).toList();

              activeChapDocs.sort((a, b) {
                final numA = _asInt(a.data()['chapterNumber'] ?? a.data()['chapter_number'], fallback: 1);
                final numB = _asInt(b.data()['chapterNumber'] ?? b.data()['chapter_number'], fallback: 1);
                return numA.compareTo(numB);
              });

              for (final cDoc in activeChapDocs) {
                final cData = Map<String, dynamic>.from(cDoc.data());
                chapters.add(
                  SacredChapterModel(
                    chapterNumber: _asInt(cData['chapterNumber'] ?? cData['chapter_number'], fallback: 1),
                    title: (cData['title'] ?? '').toString(),
                    subtitle: (cData['subtitle'] ?? '').toString(),
                    titleEn: cData['title_en']?.toString(),
                    titleGu: cData['title_gu']?.toString(),
                    titleHi: cData['title_hi']?.toString(),
                    subtitleEn: cData['subtitle_en']?.toString(),
                    subtitleGu: cData['subtitle_gu']?.toString(),
                    subtitleHi: cData['subtitle_hi']?.toString(),
                    descriptionEnglish: (cData['descriptionEnglish'] ?? cData['description_en'] ?? '').toString(),
                    descriptionGujarati: (cData['descriptionGujarati'] ?? cData['description_gu'] ?? '').toString(),
                    descriptionHindi: cData['descriptionHindi']?.toString() ?? cData['description_hi']?.toString(),
                    verses: const [], // Verses are lazy loaded in reader screen!
                  ),
                );
              }
            }

            final finalChapters = chapters.isNotEmpty
                ? chapters
                : (baseBook.chapters.isNotEmpty ? baseBook.chapters : (_fallbackBook(bookId)?.chapters ?? []));

            final completeBook = baseBook.copyWith(
              chapters: finalChapters,
              totalChapters: finalChapters.isNotEmpty ? finalChapters.length : baseBook.totalChapters,
            );

            _booksCache[bookId] = completeBook;
            controller.add(completeBook);
          }, onError: (_) {
            controller.add(_fallbackBook(bookId));
          });
        }, onError: (_) {
          controller.add(_fallbackBook(bookId));
        });
      },
      onCancel: () {
        bookSub?.cancel();
        chapterSub?.cancel();
      },
    );

    return controller.stream;
  }

  // ============================================================
  // 3. READER SCREEN: LAZY VERSE QUERY FOR SPECIFIC CHAPTER
  // ============================================================

  /// Stream a single book with populated verses ONLY for the active chapterNumber.
  static Stream<SacredBookModel?> streamBookWithChapterVerses({
    required String bookId,
    required int chapterNumber,
  }) {
    late StreamController<SacredBookModel?> controller;
    StreamSubscription<SacredBookModel?>? baseBookSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? verseSub;

    controller = StreamController<SacredBookModel?>.broadcast(
      onListen: () {
        debugPrint('[MOBILE BOOK] MOBILE BOOK: $bookId | FIRESTORE BOOK: $bookId');
        debugPrint('[PERF LOG] VERSE_QUERY_START: Subscribing to verses for bookId=$bookId, chapter=$chapterNumber...');

        baseBookSub = streamBookById(bookId).listen((book) async {
          if (book == null) {
            controller.add(_fallbackBook(bookId));
            return;
          }

          final targetChapter = book.getChapter(chapterNumber);
          if (targetChapter == null) {
            controller.add(book);
            return;
          }

          final db = _firestore;
          if (db == null) {
            controller.add(book);
            return;
          }

          final bookRef = db.collection('sacred_books').doc(bookId);
          final chaptersSnap = await bookRef.collection('chapters').get();

          final List<DocumentReference<Map<String, dynamic>>> matchedChapRefs = [];
          for (final doc in chaptersSnap.docs) {
            if (bookId == 'ramayana') {
              const staticIds = {'1', '2', '3', '4', '5', '6', '7'};
              final hasDynamicDocs = chaptersSnap.docs.any((otherDoc) => !staticIds.contains(otherDoc.id));
              if (hasDynamicDocs && staticIds.contains(doc.id)) {
                continue;
              }
            }
            final cNum = _asInt(doc.data()['chapterNumber'] ?? doc.data()['chapter_number'], fallback: -1);
            final kNum = _asInt(doc.data()['kanda_number'], fallback: -1);
            if (cNum == chapterNumber || kNum == chapterNumber) {
              matchedChapRefs.add(doc.reference);
            }
          }

          if (matchedChapRefs.isEmpty) {
            matchedChapRefs.add(bookRef.collection('chapters').doc('chapter_$chapterNumber'));
          }

          verseSub?.cancel();

          if (matchedChapRefs.length == 1) {
            verseSub = matchedChapRefs.first.collection('verses').snapshots().listen((verseSnap) {
              final List<SacredVerseModel> verses = [];

              if (verseSnap.docs.isNotEmpty) {
                final activeVerseDocs = verseSnap.docs.where((v) {
                  final d = v.data();
                  final isPub = d['published'] as bool? ?? d['is_published'] as bool? ?? (d['status'] == 'published' || d['status'] == null);
                  final isArc = d['archived'] as bool? ?? (d['status'] == 'archived');
                  return isPub && !isArc;
                }).toList();

                activeVerseDocs.sort((a, b) {
                  final sargaA = _asInt(a.data()['sarga_number'] ?? a.data()['sargaNumber'], fallback: 1);
                  final sargaB = _asInt(b.data()['sarga_number'] ?? b.data()['sargaNumber'], fallback: 1);
                  if (sargaA != sargaB) {
                    return sargaA.compareTo(sargaB);
                  }
                  final numA = _asInt(a.data()['verseNumber'] ?? a.data()['verse_number'], fallback: 1);
                  final numB = _asInt(b.data()['verseNumber'] ?? b.data()['verse_number'], fallback: 1);
                  return numA.compareTo(numB);
                });

                for (final vDoc in activeVerseDocs) {
                  verses.add(SacredVerseModel.fromMap(vDoc.data()));
                }
              }

              _emitUpdatedBook(book, chapterNumber, targetChapter, verses, controller, bookId);
            }, onError: (_) {
              controller.add(book);
            });
          } else {
            // Multi-doc chapter group (e.g. multiple Sarga docs for 1 Kanda)
            final List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = matchedChapRefs
                .map((ref) => ref.collection('verses').snapshots())
                .toList();

            verseSub = StreamGroup.merge(streams).listen((_) async {
              final List<SacredVerseModel> combinedVerses = [];
              for (final ref in matchedChapRefs) {
                final snap = await ref.collection('verses').get();
                for (final doc in snap.docs) {
                  final d = doc.data();
                  final isPub = d['published'] as bool? ?? d['is_published'] as bool? ?? (d['status'] == 'published' || d['status'] == null);
                  final isArc = d['archived'] as bool? ?? (d['status'] == 'archived');
                  if (isPub && !isArc) {
                    combinedVerses.add(SacredVerseModel.fromMap(d));
                  }
                }
              }

              combinedVerses.sort((a, b) {
                final sargaA = a.sargaNumber ?? 1;
                final sargaB = b.sargaNumber ?? 1;
                if (sargaA != sargaB) return sargaA.compareTo(sargaB);
                return a.verseNumber.compareTo(b.verseNumber);
              });

              _emitUpdatedBook(book, chapterNumber, targetChapter, combinedVerses, controller, bookId);
            }, onError: (_) {
              controller.add(book);
            });
          }
        }, onError: (_) {
          controller.add(_fallbackBook(bookId));
        });
      },
      onCancel: () {
        baseBookSub?.cancel();
        verseSub?.cancel();
      },
    );

    return controller.stream;
  }

  static void _emitUpdatedBook(
    SacredBookModel book,
    int chapterNumber,
    SacredChapterModel targetChapter,
    List<SacredVerseModel> verses,
    StreamController<SacredBookModel?> controller,
    String bookId,
  ) {
    final finalVerses = verses.isNotEmpty
        ? verses
        : targetChapter.verses.isNotEmpty
            ? targetChapter.verses
            : (_fallbackBook(bookId)?.getChapter(chapterNumber)?.verses ?? []);

    final updatedChapters = book.chapters.map((ch) {
      if (ch.chapterNumber == chapterNumber) {
        return SacredChapterModel(
          chapterNumber: ch.chapterNumber,
          title: ch.title,
          subtitle: ch.subtitle,
          titleEn: ch.titleEn,
          titleGu: ch.titleGu,
          titleHi: ch.titleHi,
          subtitleEn: ch.subtitleEn,
          subtitleGu: ch.subtitleGu,
          subtitleHi: ch.subtitleHi,
          descriptionEnglish: ch.descriptionEnglish,
          descriptionGujarati: ch.descriptionGujarati,
          descriptionHindi: ch.descriptionHindi,
          verses: finalVerses,
        );
      }
      return ch;
    }).toList();

    final completeBook = book.copyWith(chapters: updatedChapters);
    controller.add(completeBook);
  }

  // ============================================================
  // 4. ONE-SHOT FETCH HANDLERS & FALLBACKS
  // ============================================================

  static Future<List<SacredBookModel>> fetchAllBooks({bool forceRefresh = false}) async {
    if (!forceRefresh && _booksCache.isNotEmpty) {
      return _getCachedOrFallbackBooks();
    }

    final db = _firestore;
    if (db == null) return _getCachedOrFallbackBooks();

    try {
      final snapshot = await db.collection('sacred_books').get();
      if (snapshot.docs.isEmpty) {
        return SacredBooksData.all;
      }

      final books = <SacredBookModel>[];
      for (final doc in snapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        final isPub = data['published'] as bool? ?? data['is_published'] as bool? ?? (data['status'] == 'published' || data['status'] == null);
        final isArc = data['archived'] as bool? ?? (data['status'] == 'archived');

        if (isPub && !isArc) {
          final book = SacredBookModel.fromMap(data);
          books.add(book);
          _booksCache[book.id] = book;
        }
      }

      books.sort((a, b) => a.order.compareTo(b.order));
      return books.isNotEmpty ? books : SacredBooksData.all;
    } catch (_) {
      return _getCachedOrFallbackBooks();
    }
  }

  static Future<SacredBookModel?> fetchBookById(
    String bookId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _booksCache.containsKey(bookId) && _booksCache[bookId]!.chapters.isNotEmpty) {
      return _booksCache[bookId];
    }
    return _fallbackBook(bookId);
  }

  static SacredBookModel? _fallbackBook(String bookId) {
    final normalizedId = (bookId == 'gita') ? 'bhagavad_gita' : bookId;
    final fallback = SacredBooksData.findById(normalizedId);
    if (fallback != null) {
      _booksCache[bookId] = fallback;
      _booksCache[normalizedId] = fallback;
    }
    return fallback;
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
