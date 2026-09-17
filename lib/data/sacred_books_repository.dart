import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import '../models/sacred_verse_model.dart';
import 'sacred_books_data.dart';

class SacredBooksRepository {
  SacredBooksRepository._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Map<String, SacredBookModel> _cache = {};

  static void clearCache() {
    _cache.clear();
  }

  /// Live Firestore Stream of all published, non-archived Sacred Books
  static Stream<List<SacredBookModel>> streamAllBooks() {
    return _firestore
        .collection('sacred_books')
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        return SacredBooksData.all;
      }

      final activeDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['published'] != false && data['archived'] != true;
      }).toList();

      activeDocs.sort((a, b) {
        final orderA = _asInt(a.data()['order'], fallback: 1);
        final orderB = _asInt(b.data()['order'], fallback: 1);
        return orderA.compareTo(orderB);
      });

      final books = <SacredBookModel>[];
      for (final doc in activeDocs) {
        final book = await fetchBookById(doc.id, forceRefresh: true);
        if (book != null) {
          books.add(book);
        }
      }

      return books.isNotEmpty ? books : SacredBooksData.all;
    });
  }

  /// Live Stream for a specific Book ID including chapters & verses
  static Stream<SacredBookModel?> streamBookById(String bookId) {
    return _firestore
        .collection('sacred_books')
        .doc(bookId)
        .snapshots()
        .asyncMap((doc) async {
      if (!doc.exists || doc.data() == null) {
        return _fallbackBook(bookId);
      }
      return fetchBookById(bookId, forceRefresh: true);
    });
  }

  /// Fetch all published books once
  static Future<List<SacredBookModel>> fetchAllBooks({bool forceRefresh = false}) async {
    try {
      final snapshot = await _firestore.collection('sacred_books').get();

      if (snapshot.docs.isEmpty) {
        return SacredBooksData.all;
      }

      final activeDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['published'] != false && data['archived'] != true;
      }).toList();

      activeDocs.sort((a, b) {
        final orderA = _asInt(a.data()['order'], fallback: 1);
        final orderB = _asInt(b.data()['order'], fallback: 1);
        return orderA.compareTo(orderB);
      });

      final books = <SacredBookModel>[];
      for (final doc in activeDocs) {
        final book = await fetchBookById(doc.id, forceRefresh: forceRefresh);
        if (book != null) {
          books.add(book);
        }
      }
      return books.isNotEmpty ? books : SacredBooksData.all;
    } catch (_) {
      return SacredBooksData.all;
    }
  }

  /// Fetch a single book by ID with chapters and verses from Firestore
  static Future<SacredBookModel?> fetchBookById(
    String bookId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.containsKey(bookId)) {
      return _cache[bookId];
    }

    try {
      final bookDoc = await _firestore.collection('sacred_books').doc(bookId).get();

      if (!bookDoc.exists || bookDoc.data() == null) {
        return _fallbackBook(bookId);
      }

      final bookData = bookDoc.data()!;
      if (bookData['published'] == false || bookData['archived'] == true) {
        return null;
      }

      final chaptersSnapshot = await _firestore
          .collection('sacred_books')
          .doc(bookId)
          .collection('chapters')
          .get();

      final chapters = <SacredChapterModel>[];
      final chapterDocs = chaptersSnapshot.docs
          .where((doc) => doc.data()['published'] != false && doc.data()['archived'] != true)
          .toList();

      chapterDocs.sort((a, b) {
        final numA = _asInt(a.data()['chapterNumber'], fallback: 1);
        final numB = _asInt(b.data()['chapterNumber'], fallback: 1);
        return numA.compareTo(numB);
      });

      for (final chapterDoc in chapterDocs) {
        final chapterData = chapterDoc.data();
        final versesSnapshot = await chapterDoc.reference
            .collection('verses')
            .get();

        final verseDocs = versesSnapshot.docs
            .where((v) => v.data()['published'] != false && v.data()['archived'] != true)
            .toList();

        verseDocs.sort((a, b) {
          final numA = _asInt(a.data()['verseNumber'], fallback: 1);
          final numB = _asInt(a.data()['verseNumber'], fallback: 1);
          return numA.compareTo(numB);
        });

        final verses = verseDocs
            .map((v) => SacredVerseModel.fromMap(v.data()))
            .toList();

        chapters.add(
          SacredChapterModel(
            chapterNumber: _asInt(chapterData['chapterNumber'], fallback: 1),
            title: (chapterData['title'] ?? '').toString(),
            subtitle: (chapterData['subtitle'] ?? '').toString(),
            titleEn: chapterData['title_en']?.toString(),
            titleGu: chapterData['title_gu']?.toString(),
            titleHi: chapterData['title_hi']?.toString(),
            subtitleEn: chapterData['subtitle_en']?.toString(),
            subtitleGu: chapterData['subtitle_gu']?.toString(),
            subtitleHi: chapterData['subtitle_hi']?.toString(),
            descriptionEnglish:
                (chapterData['descriptionEnglish'] ?? chapterData['description_en'] ?? '').toString(),
            descriptionGujarati:
                (chapterData['descriptionGujarati'] ?? chapterData['description_gu'] ?? '').toString(),
            descriptionHindi: chapterData['descriptionHindi']?.toString() ?? chapterData['description_hi']?.toString(),
            verses: verses,
          ),
        );
      }

      final book = SacredBookModel(
        id: bookId,
        title: (bookData['title'] ?? 'Sacred Text').toString(),
        subtitle: (bookData['subtitle'] ?? '').toString(),
        titleEn: bookData['title_en']?.toString(),
        titleGu: bookData['title_gu']?.toString(),
        titleHi: bookData['title_hi']?.toString(),
        subtitleEn: bookData['subtitle_en']?.toString(),
        subtitleGu: bookData['subtitle_gu']?.toString(),
        subtitleHi: bookData['subtitle_hi']?.toString(),
        iconEmoji: (bookData['iconEmoji'] ?? '📜').toString(),
        coverUrl: bookData['coverUrl']?.toString() ?? bookData['cover_url']?.toString(),
        description: (bookData['description'] ?? bookData['about'] ?? '').toString(),
        order: _asInt(bookData['order'], fallback: 1),
        published: bookData['published'] as bool? ?? true,
        archived: bookData['archived'] as bool? ?? false,
        totalChapters: _asInt(
          bookData['totalChapters'],
          fallback: chapters.isNotEmpty ? chapters.length : 1,
        ),
        chapters: chapters,
      );

      _cache[bookId] = book;
      return book;
    } catch (_) {
      return _fallbackBook(bookId);
    }
  }

  static Future<SacredChapterModel?> fetchChapter({
    required String bookId,
    required int chapterNumber,
    bool forceRefresh = false,
  }) async {
    try {
      final book = await fetchBookById(bookId, forceRefresh: forceRefresh);
      if (book != null) {
        final chap = book.getChapter(chapterNumber);
        if (chap != null) return chap;
      }
      return _fallbackBook(bookId)?.getChapter(chapterNumber);
    } catch (_) {
      return _fallbackBook(bookId)?.getChapter(chapterNumber);
    }
  }

  static SacredBookModel? _fallbackBook(String bookId) {
    final fallback = SacredBooksData.findById(bookId);
    if (fallback != null) {
      _cache[bookId] = fallback;
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
