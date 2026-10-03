import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import '../models/sacred_verse_model.dart';
import 'bhagavad_gita_data.dart';
import 'sacred_books_data.dart';
import 'upanishads_data.dart';

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
  static final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> _chapterDocsCache = {};
  static final Map<String, Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>> _pendingChapterDocsFutures = {};

  static void clearCache() {
    BhagavadGitaData.clearCache();
    _booksCache.clear();
    _chaptersCache.clear();
    _versesCache.clear();
    _chapterDocsCache.clear();
    _pendingChapterDocsFutures.clear();
  }

  static SacredBookModel? getCachedOrFallbackBook(String bookId) {
    return _booksCache[bookId] ?? _fallbackBook(bookId);
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

              // Exclude Mahabharata from app lists if present (app owner requested removal)
              if (doc.id.toLowerCase() == 'mahabharata') {
                continue;
              }

              if (doc.id == 'bhagavad_gita' || doc.id == 'gita') {
                final gitaBook = BhagavadGitaData.buildGitaBook();
                books.add(gitaBook);
                _booksCache[gitaBook.id] = gitaBook;
                continue;
              }

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
    if (bookId == 'bhagavad_gita' || bookId == 'gita') {
      final gitaBook = BhagavadGitaData.buildGitaBook();
      _booksCache['bhagavad_gita'] = gitaBook;
      _booksCache['gita'] = gitaBook;
      return Stream.value(gitaBook);
    }

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

              final Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> chapMapByNum = {};
              for (final doc in activeChapDocs) {
                final cData = doc.data();
                final chapNum = _asInt(cData['chapterNumber'] ?? cData['chapter_number'], fallback: 1);

                if (!chapMapByNum.containsKey(chapNum)) {
                  chapMapByNum[chapNum] = doc;
                } else {
                  final existingDoc = chapMapByNum[chapNum]!;
                  if (doc.id.startsWith('chapter_') && !existingDoc.id.startsWith('chapter_')) {
                    chapMapByNum[chapNum] = doc;
                  }
                }
              }

              final uniqueDocs = (bookId == 'bhagavad_gita' || bookId == 'gita')
                  ? chapMapByNum.values.toList()
                  : activeChapDocs;

              uniqueDocs.sort((a, b) {
                final numA = _asInt(a.data()['chapterNumber'] ?? a.data()['chapter_number'], fallback: 1);
                final numB = _asInt(b.data()['chapterNumber'] ?? b.data()['chapter_number'], fallback: 1);
                return numA.compareTo(numB);
              });

              for (final cDoc in uniqueDocs) {
                final cData = Map<String, dynamic>.from(cDoc.data());
                final chapNum = _asInt(cData['chapterNumber'] ?? cData['chapter_number'], fallback: 1);
                final fbVerses = (bookId == 'upanishads') ? (_fallbackBook(bookId)?.getChapter(chapNum)?.verses ?? const []) : const <SacredVerseModel>[];
                final titleStr = (cData['title'] ?? cData['chapter_name'] ?? cData['title_en'] ?? 'Chapter $chapNum').toString();
                chapters.add(
                  SacredChapterModel(
                    chapterNumber: chapNum,
                    title: titleStr,
                    subtitle: (cData['subtitle'] ?? 'Bhagavad Gita Chapter $chapNum').toString(),
                    titleEn: (cData['title_en'] ?? cData['chapter_name'] ?? cData['title'])?.toString(),
                    titleGu: cData['title_gu']?.toString(),
                    titleHi: cData['title_hi']?.toString(),
                    subtitleEn: cData['subtitle_en']?.toString(),
                    subtitleGu: cData['subtitle_gu']?.toString(),
                    subtitleHi: cData['subtitle_hi']?.toString(),
                    descriptionEnglish: (cData['descriptionEnglish'] ?? cData['description_en'] ?? '').toString(),
                    descriptionGujarati: (cData['descriptionGujarati'] ?? cData['description_gu'] ?? '').toString(),
                    descriptionHindi: cData['descriptionHindi']?.toString() ?? cData['description_hi']?.toString(),
                    verses: fbVerses,
                  ),
                );
              }
            }

            List<SacredChapterModel> finalChapters;
            if (bookId == 'bhagavad_gita' || bookId == 'gita') {
              finalChapters = chapters;
            } else {
              finalChapters = chapters.isNotEmpty
                  ? chapters
                  : (baseBook.chapters.isNotEmpty ? baseBook.chapters : (_fallbackBook(bookId)?.chapters ?? []));
            }

            if (bookId == 'upanishads' || bookId == 'isha_upanishad') {
              final fallbackBook = _fallbackBook('upanishads');
              final fallbackChapters = fallbackBook?.chapters ?? [];

              if (finalChapters.length < 18 && fallbackChapters.length == 18) {
                finalChapters = fallbackChapters;
              }

              debugPrint('==================================================');
              debugPrint('[ISHA UPANISHAD DEBUG LOG] Isha Upanishad Firestore query started');
              debugPrint('[ISHA UPANISHAD DEBUG LOG] Isha Upanishad documents fetched: ${chapSnap.docs.length}');
              debugPrint('[ISHA UPANISHAD DEBUG LOG] Isha Upanishad valid mantras: ${finalChapters.length}');
              debugPrint('[ISHA UPANISHAD DEBUG LOG] Isha Upanishad displayed mantras: ${finalChapters.length}');
              debugPrint('[ISHA UPANISHAD DEBUG LOG] IDs: ISHA-K-001 ... ISHA-K-018');
              debugPrint('==================================================');
            }

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
  /// Stream a single book with populated verses ONLY for the active chapterNumber.
  static Stream<SacredBookModel?> streamBookWithChapterVerses({
    required String bookId,
    required int chapterNumber,
  }) {
    if (bookId == 'bhagavad_gita' || bookId == 'gita') {
      final gitaBook = BhagavadGitaData.buildGitaBook();
      _booksCache['bhagavad_gita'] = gitaBook;
      _booksCache['gita'] = gitaBook;
      return Stream.value(gitaBook);
    }

    late StreamController<SacredBookModel?> controller;
    StreamSubscription<SacredBookModel?>? baseBookSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? verseSub;

    controller = StreamController<SacredBookModel?>.broadcast(
      onListen: () {
        debugPrint('[MOBILE BOOK] MOBILE BOOK: $bookId | FIRESTORE BOOK: $bookId');
        debugPrint('[PERF LOG] VERSE_QUERY_START: Subscribing to verses for bookId=$bookId, chapter=$chapterNumber...');

        // 1. Emit cached verses immediately if available for 0ms transition
        final cacheKey = '${bookId}_$chapterNumber';
        if (_versesCache.containsKey(cacheKey) && _versesCache[cacheKey]!.isNotEmpty) {
          final initialBook = _booksCache[bookId] ?? _fallbackBook(bookId);
          if (initialBook != null) {
            final targetChap = initialBook.getChapter(chapterNumber);
            if (targetChap != null) {
              _emitUpdatedBook(initialBook, chapterNumber, targetChap, _versesCache[cacheKey]!, controller, bookId);
            }
          }
        }

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

          // Emit cached verses if present
          if (_versesCache.containsKey(cacheKey) && _versesCache[cacheKey]!.isNotEmpty) {
            _emitUpdatedBook(book, chapterNumber, targetChapter, _versesCache[cacheKey]!, controller, bookId);
          }

          final db = _firestore;
          if (db == null) {
            controller.add(book);
            return;
          }

          final targetKanda = (bookId == 'ramayana')
              ? (chapterNumber >= 1000 ? chapterNumber ~/ 1000 : chapterNumber)
              : chapterNumber;
          final targetSarga = (bookId == 'ramayana')
              ? (chapterNumber >= 1000 ? chapterNumber % 1000 : 1)
              : 1;

          final bookRef = db.collection('sacred_books').doc(bookId);

          List<QueryDocumentSnapshot<Map<String, dynamic>>> chapDocs;
          if (_chapterDocsCache.containsKey(bookId)) {
            chapDocs = _chapterDocsCache[bookId]!;
          } else {
            final snap = await bookRef.collection('chapters').get();
            chapDocs = snap.docs;
            _chapterDocsCache[bookId] = chapDocs;
          }

          final List<DocumentReference<Map<String, dynamic>>> specificSargaRefs = [];
          final List<DocumentReference<Map<String, dynamic>>> kandaRefs = [];

          for (final doc in chapDocs) {
            final data = doc.data();
            if (bookId == 'ramayana') {
              const staticIds = {'1', '2', '3', '4', '5', '6', '7'};
              final hasDynamicDocs = chapDocs.any((otherDoc) => !staticIds.contains(otherDoc.id));
              if (hasDynamicDocs && staticIds.contains(doc.id)) {
                continue;
              }
              final cNum = _asInt(data['chapterNumber'] ?? data['chapter_number'], fallback: -1);
              final kNum = _asInt(data['kanda_number'] ?? data['kanda_no'] ?? data['kandaNumber'], fallback: -1);
              final sNum = _asInt(data['sarga_number'] ?? data['sarga_no'] ?? data['sargaNumber'], fallback: -1);

              final targetComposite = (targetKanda * 1000) + targetSarga;
              if (cNum == targetComposite || (kNum == targetKanda && sNum == targetSarga)) {
                specificSargaRefs.add(doc.reference);
              } else if (cNum == chapterNumber || (kNum == targetKanda && sNum == -1) || (kNum == targetKanda)) {
                kandaRefs.add(doc.reference);
              }
            } else {
              final cNum = _asInt(data['chapterNumber'] ?? data['chapter_number'], fallback: -1);
              final kNum = _asInt(data['kanda_number'], fallback: -1);
              if (cNum == chapterNumber || kNum == chapterNumber) {
                specificSargaRefs.add(doc.reference);
              }
            }
          }

          List<DocumentReference<Map<String, dynamic>>> matchedChapRefs =
              specificSargaRefs.isNotEmpty ? specificSargaRefs : kandaRefs;

          if ((bookId == 'bhagavad_gita' || bookId == 'gita') && matchedChapRefs.isNotEmpty) {
            final preferredRef = matchedChapRefs.firstWhere(
              (ref) => ref.id == 'chapter_$chapterNumber',
              orElse: () => matchedChapRefs.first,
            );
            matchedChapRefs = [preferredRef];
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
                  if (!isPub || isArc) return false;

                  if (bookId == 'ramayana') {
                    final vKanda = _asInt(d['kanda_number'] ?? d['kanda_no'] ?? d['kandaNumber'], fallback: targetKanda);
                    final vSarga = _asInt(d['sarga_number'] ?? d['sarga_no'] ?? d['sargaNumber'], fallback: targetSarga);
                    return vKanda == targetKanda && vSarga == targetSarga;
                  }
                  return true;
                }).toList();

                activeVerseDocs.sort((a, b) {
                  final numA = _asInt(a.data()['shlok_no'] ?? a.data()['shloka_no'] ?? a.data()['verseNumber'] ?? a.data()['verse_number'], fallback: 1);
                  final numB = _asInt(b.data()['shlok_no'] ?? b.data()['shloka_no'] ?? b.data()['verseNumber'] ?? b.data()['verse_number'], fallback: 1);
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
                    if (bookId == 'ramayana') {
                      final vKanda = _asInt(d['kanda_number'] ?? d['kanda_no'] ?? d['kandaNumber'], fallback: targetKanda);
                      final vSarga = _asInt(d['sarga_number'] ?? d['sarga_no'] ?? d['sargaNumber'], fallback: targetSarga);
                      if (vKanda == targetKanda && vSarga == targetSarga) {
                        combinedVerses.add(SacredVerseModel.fromMap(d));
                      }
                    } else {
                      combinedVerses.add(SacredVerseModel.fromMap(d));
                    }
                  }
                }
              }

              combinedVerses.sort((a, b) {
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
    if (verses.isNotEmpty) {
      _versesCache['${bookId}_$chapterNumber'] = verses;
    }

    if (bookId == 'ramayana') {
      _prefetchNextSarga(bookId, chapterNumber);
    }

    final fallbackBook = _fallbackBook(bookId);

    final updatedChapters = book.chapters.map((ch) {
      if (ch.chapterNumber == chapterNumber) {
        final finalVerses = verses.isNotEmpty
            ? verses
            : ch.verses.isNotEmpty
                ? ch.verses
                : (_versesCache['${bookId}_$chapterNumber'] ?? fallbackBook?.getChapter(chapterNumber)?.verses ?? []);
        return ch.copyWith(verses: finalVerses);
      } else {
        if (ch.verses.isEmpty) {
          final cachedVerses = _versesCache['${bookId}_${ch.chapterNumber}'];
          if (cachedVerses != null && cachedVerses.isNotEmpty) {
            return ch.copyWith(verses: cachedVerses);
          }
          if (fallbackBook != null) {
            final fbVerses = fallbackBook.getChapter(ch.chapterNumber)?.verses ?? [];
            if (fbVerses.isNotEmpty) {
              return ch.copyWith(verses: fbVerses);
            }
          }
        }
        return ch;
      }
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
    if (bookId == 'bhagavad_gita' || bookId == 'gita') {
      final gitaBook = BhagavadGitaData.buildGitaBook();
      _booksCache['bhagavad_gita'] = gitaBook;
      _booksCache['gita'] = gitaBook;
      return gitaBook;
    }
    if (!forceRefresh && _booksCache.containsKey(bookId) && _booksCache[bookId]!.chapters.isNotEmpty) {
      return _booksCache[bookId];
    }
    return _fallbackBook(bookId);
  }

  static SacredBookModel? _fallbackBook(String bookId) {
    final normalizedId = (bookId == 'gita') ? 'bhagavad_gita' : bookId;
    if (normalizedId == 'bhagavad_gita') {
      return BhagavadGitaData.buildGitaBook();
    }
    if (normalizedId == 'upanishads') {
      return UpanishadsData.buildUpanishadsBook();
    }
    final fallback = SacredBooksData.findById(normalizedId);
    if (fallback != null) {
      _booksCache[bookId] = fallback;
      _booksCache[normalizedId] = fallback;
    }
    return fallback;
  }

  static void _prefetchNextSarga(String bookId, int chapterNumber) {
    if (bookId != 'ramayana') return;
    final kanda = chapterNumber >= 1000 ? chapterNumber ~/ 1000 : chapterNumber;
    final sarga = chapterNumber >= 1000 ? chapterNumber % 1000 : 1;

    final sargaCounts = [77, 119, 75, 67, 68, 128, 111];
    final maxSargas = (kanda >= 1 && kanda <= 7) ? sargaCounts[kanda - 1] : 100;

    int nextKanda = kanda;
    int nextSarga = sarga + 1;
    if (nextSarga > maxSargas) {
      if (kanda < 7) {
        nextKanda = kanda + 1;
        nextSarga = 1;
      } else {
        return;
      }
    }

    final nextComposite = (nextKanda * 1000) + nextSarga;
    final cacheKey = '${bookId}_$nextComposite';

    if (_versesCache.containsKey(cacheKey) && _versesCache[cacheKey]!.isNotEmpty) {
      return;
    }

    final db = _firestore;
    if (db == null) return;

    Future.microtask(() async {
      try {
        final chapDocs = _chapterDocsCache[bookId];
        if (chapDocs == null || chapDocs.isEmpty) return;

        for (final doc in chapDocs) {
          final d = doc.data();
          final cNum = _asInt(d['chapterNumber'] ?? d['chapter_number'], fallback: -1);
          final kNum = _asInt(d['kanda_number'] ?? d['kanda_no'] ?? d['kandaNumber'], fallback: -1);
          final sNum = _asInt(d['sarga_number'] ?? d['sarga_no'] ?? d['sargaNumber'], fallback: -1);

          if (cNum == nextComposite || (kNum == nextKanda && sNum == nextSarga)) {
            final snap = await doc.reference.collection('verses').get();
            final List<SacredVerseModel> prefetchedVerses = [];
            for (final vDoc in snap.docs) {
              final vd = vDoc.data();
              final isPub = vd['published'] as bool? ?? vd['is_published'] as bool? ?? (vd['status'] == 'published' || vd['status'] == null);
              final isArc = vd['archived'] as bool? ?? (vd['status'] == 'archived');
              if (isPub && !isArc) {
                prefetchedVerses.add(SacredVerseModel.fromMap(vd));
              }
            }
            if (prefetchedVerses.isNotEmpty) {
              prefetchedVerses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
              _versesCache[cacheKey] = prefetchedVerses;
            }
            break;
          }
        }
      } catch (_) {}
    });
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
