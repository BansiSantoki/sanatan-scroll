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

  static Future<List<SacredBookModel>> fetchAllBooks({bool forceRefresh = false}) async {
    try {
      final snapshot = await _firestore
          .collection('sacred_books')
          .orderBy('order')
          .get();

      if (snapshot.docs.isEmpty) {
        return SacredBooksData.all;
      }

      final books = <SacredBookModel>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['published'] == false || data['archived'] == true) continue;
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

  static Future<SacredBookModel?> fetchBookById(
    String bookId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.containsKey(bookId)) {
      return _cache[bookId];
    }

    try {
      final bookDoc =
          await _firestore.collection('sacred_books').doc(bookId).get();

      if (!bookDoc.exists || bookDoc.data() == null) {
        return _fallbackBook(bookId);
      }

      final bookData = bookDoc.data()!;
      final chaptersSnapshot = await _firestore
          .collection('sacred_books')
          .doc(bookId)
          .collection('chapters')
          .orderBy('chapterNumber')
          .get();

      final chapters = <SacredChapterModel>[];

      for (final chapterDoc in chaptersSnapshot.docs) {
        final chapterData = chapterDoc.data();
        if (chapterData['published'] == false || chapterData['archived'] == true) continue;

        final versesSnapshot = await chapterDoc.reference
            .collection('verses')
            .orderBy('verseNumber')
            .get();

        final verses = versesSnapshot.docs
            .map((verseDoc) => verseDoc.data())
            .where((data) => data['published'] != false && data['archived'] != true)
            .map((data) => SacredVerseModel.fromMap(data))
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
      final chapterDoc = await _firestore
          .collection('sacred_books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterNumber.toString())
          .get();

      if (!chapterDoc.exists || chapterDoc.data() == null) {
        return _fallbackBook(bookId)?.getChapter(chapterNumber);
      }

      final chapterData = chapterDoc.data()!;
      if (chapterData['published'] == false || chapterData['archived'] == true) return null;

      final versesSnapshot = await chapterDoc.reference
          .collection('verses')
          .orderBy('verseNumber')
          .get();

      final verses = versesSnapshot.docs
          .map((verseDoc) => verseDoc.data())
          .where((data) => data['published'] != false && data['archived'] != true)
          .map((data) => SacredVerseModel.fromMap(data))
          .toList();

      return SacredChapterModel(
        chapterNumber:
            _asInt(chapterData['chapterNumber'], fallback: chapterNumber),
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
      );
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
