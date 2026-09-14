import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanatan_scroll/data/sacred_books_data.dart';
import 'activity_logs_service.dart';

class MigrationProgress {
  final int booksDone;
  final int totalBooks;
  final int chaptersDone;
  final int totalChapters;
  final int versesDone;
  final int totalVerses;
  final String currentItem;

  const MigrationProgress({
    required this.booksDone,
    required this.totalBooks,
    required this.chaptersDone,
    required this.totalChapters,
    required this.versesDone,
    required this.totalVerses,
    required this.currentItem,
  });

  double get progressPercentage {
    final total = totalBooks + totalChapters + totalVerses;
    if (total == 0) return 1.0;
    final done = booksDone + chaptersDone + versesDone;
    return (done / total).clamp(0.0, 1.0);
  }
}

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ActivityLogsService _logsService = ActivityLogsService();

  Future<int> syncExistingMobileContentToFirestore({
    bool force = false,
    void Function(MigrationProgress progress)? onProgress,
  }) async {
    try {
      final booksSnapshot = await _firestore.collection('sacred_books').get();

      // If books already exist in Firestore and force is false, skip migration
      if (!force && booksSnapshot.docs.isNotEmpty) {
        return booksSnapshot.docs.length;
      }

      final existingBooks = SacredBooksData.all;
      int totalBooks = existingBooks.length;
      int totalChapters = 0;
      int totalVerses = 0;

      for (final book in existingBooks) {
        totalChapters += book.chapters.length;
        for (final chapter in book.chapters) {
          totalVerses += chapter.verses.length;
        }
      }

      int booksDone = 0;
      int chaptersDone = 0;
      int versesDone = 0;

      WriteBatch batch = _firestore.batch();
      int opCount = 0;

      void notify(String currentItem) {
        onProgress?.call(
          MigrationProgress(
            booksDone: booksDone,
            totalBooks: totalBooks,
            chaptersDone: chaptersDone,
            totalChapters: totalChapters,
            versesDone: versesDone,
            totalVerses: totalVerses,
            currentItem: currentItem,
          ),
        );
      }

      notify('Preparing migration...');

      for (int i = 0; i < existingBooks.length; i++) {
        final book = existingBooks[i];
        final bookDocRef = _firestore.collection('sacred_books').doc(book.id);

        final bookMap = {
          'id': book.id,
          'title': book.title,
          'subtitle': book.subtitle,
          'title_en': book.titleEn ?? book.title,
          'title_gu': book.titleGu,
          'title_hi': book.titleHi,
          'subtitle_en': book.subtitleEn ?? book.subtitle,
          'subtitle_gu': book.subtitleGu,
          'subtitle_hi': book.subtitleHi,
          'iconEmoji': book.iconEmoji,
          'totalChapters': book.chapters.isNotEmpty ? book.chapters.length : book.totalChapters,
          'order': _getBookOrder(book.id, defaultOrder: i + 1),
          'published': true,
          'archived': false,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        batch.set(bookDocRef, bookMap, SetOptions(merge: true));
        opCount++;
        booksDone++;

        if (opCount >= 400) {
          await batch.commit();
          batch = _firestore.batch();
          opCount = 0;
          notify('Migrating Book: ${book.title}...');
        }

        for (final chapter in book.chapters) {
          final chapterDocRef = bookDocRef.collection('chapters').doc(chapter.chapterNumber.toString());

          final chapterMap = {
            'chapterNumber': chapter.chapterNumber,
            'title': chapter.title,
            'subtitle': chapter.subtitle,
            'title_en': chapter.titleEn ?? chapter.title,
            'title_gu': chapter.titleGu,
            'title_hi': chapter.titleHi,
            'subtitle_en': chapter.subtitleEn ?? chapter.subtitle,
            'subtitle_gu': chapter.subtitleGu,
            'subtitle_hi': chapter.subtitleHi,
            'descriptionEnglish': chapter.descriptionEnglish,
            'descriptionGujarati': chapter.descriptionGujarati,
            'descriptionHindi': chapter.descriptionHindi,
            'totalVerses': chapter.verses.length,
            'order': chapter.chapterNumber,
            'published': true,
            'archived': false,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          batch.set(chapterDocRef, chapterMap, SetOptions(merge: true));
          opCount++;
          chaptersDone++;

          if (opCount >= 400) {
            await batch.commit();
            batch = _firestore.batch();
            opCount = 0;
            notify('Migrating ${book.title} - Chapter ${chapter.chapterNumber}...');
          }

          for (final verse in chapter.verses) {
            final verseDocRef = chapterDocRef.collection('verses').doc(verse.verseNumber.toString());

            final verseMap = {
              'verseNumber': verse.verseNumber,
              'sanskrit': verse.sanskrit,
              'english': verse.english,
              'gujarati': verse.gujarati,
              'hindi': verse.hindi,
              'meaningEnglish': verse.meaningEnglish,
              'meaningGujarati': verse.meaningGujarati,
              'meaningHindi': verse.meaningHindi,
              'transliteration': verse.transliteration,
              'quote': verse.quote,
              'quote_hi': verse.quoteHi,
              'quote_gu': verse.quoteGu,
              'contextText': verse.contextText,
              'context_text_hi': verse.contextTextHi,
              'context_text_gu': verse.contextTextGu,
              'whyItMatters': verse.whyItMatters,
              'why_it_matters_hi': verse.whyItMattersHi,
              'why_it_matters_gu': verse.whyItMattersGu,
              'reflectionPreview': verse.reflectionPreview,
              'reflection_preview_hi': verse.reflectionPreviewHi,
              'reflection_preview_gu': verse.reflectionPreviewGu,
              'reflectionFull': verse.reflectionFull,
              'reflection_full_hi': verse.reflectionFullHi,
              'reflection_full_gu': verse.reflectionFullGu,
              'oneThingToNotice': verse.oneThingToNotice,
              'one_thing_to_notice_hi': verse.oneThingToNoticeHi,
              'one_thing_to_notice_gu': verse.oneThingToNoticeGu,
              'tryThis': verse.tryThis,
              'try_this_hi': verse.tryThisHi,
              'try_this_gu': verse.tryThisGu,
              'carryThisWithYou': verse.carryThisWithYou,
              'carry_this_with_you_hi': verse.carryThisWithYouHi,
              'carry_this_with_you_gu': verse.carryThisWithYouGu,
              'audioUrl': verse.audioUrl,
              'published': true,
              'archived': false,
              'updatedAt': FieldValue.serverTimestamp(),
            };

            batch.set(verseDocRef, verseMap, SetOptions(merge: true));
            opCount++;
            versesDone++;

            if (opCount >= 400) {
              await batch.commit();
              batch = _firestore.batch();
              opCount = 0;
              notify('Migrating ${book.title} Ch ${chapter.chapterNumber} Verse ${verse.verseNumber}...');
            }
          }
        }
      }

      if (opCount > 0) {
        await batch.commit();
        opCount = 0;
      }

      notify('Migration completed successfully.');

      await _logsService.logAction(
        action: 'Migrated Mobile App Content',
        target: 'Firestore sacred_books',
        details: 'Seeded $totalBooks books, $totalChapters chapters, $totalVerses verses to Firestore',
      );

      return totalBooks;
    } catch (e) {
      rethrow;
    }
  }

  int _getBookOrder(String bookId, {required int defaultOrder}) {
    switch (bookId) {
      case 'bhagavad_gita':
        return 1;
      case 'ramayana':
        return 2;
      case 'upanishads':
        return 3;
      case 'mahabharata':
        return 4;
      case 'vedas':
        return 5;
      case 'puranas':
        return 6;
      case 'yoga_sutras':
        return 7;
      case 'arthashastra':
        return 8;
      default:
        return defaultOrder;
    }
  }
}
