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

      // Always clean up legacy static Ramayana chapter documents ('1'..'7') if present
      await cleanupOldStaticRamayanaDocs();

      // Ensure exact Ramayana 1.2.15 verse ("Ma Nishada...") is upserted in Firestore
      await upsertRamayanaMaNishadaVerse();

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

  /// Deletes the old static 7 Ramayana chapter documents ('1'..'7') and their subcollections
  /// from Firestore sacred_books/ramayana/chapters/ if present.
  Future<void> cleanupOldStaticRamayanaDocs() async {
    try {
      final ramayanaRef = _firestore.collection('sacred_books').doc('ramayana');
      final chaptersRef = ramayanaRef.collection('chapters');

      const staticIds = ['1', '2', '3', '4', '5', '6', '7'];
      for (final docId in staticIds) {
        final chapDocRef = chaptersRef.doc(docId);
        final chapSnap = await chapDocRef.get();
        if (chapSnap.exists) {
          final versesSnap = await chapDocRef.collection('verses').get();
          final batch = _firestore.batch();
          for (final vDoc in versesSnap.docs) {
            batch.delete(vDoc.reference);
          }
          batch.delete(chapDocRef);
          await batch.commit();
        }
      }

      await _logsService.logAction(
        action: 'Cleaned Up Legacy Ramayana Data',
        target: 'Firestore sacred_books/ramayana/chapters',
        details: 'Purged old static chapter documents (1..7)',
      );
    } catch (e) {
      print('Error during legacy Ramayana cleanup: $e');
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

  /// Ensures Ramayana 1.2.15 ("Ma Nishada...") verse exists in Firestore
  /// under sacred_books/ramayana/chapters/{balaKandaChapterId}/verses/{verseId}.
  Future<void> upsertRamayanaMaNishadaVerse() async {
    try {
      final ramayanaRef = _firestore.collection('sacred_books').doc('ramayana');

      // Ensure 'ramayana' book document exists
      await ramayanaRef.set({
        'id': 'ramayana',
        'title': 'Ramayana',
        'subtitle': 'The Epic of Duty',
        'title_en': 'Ramayana',
        'iconEmoji': '🏹',
        'order': 2,
        'published': true,
        'archived': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final chaptersRef = ramayanaRef.collection('chapters');
      final chaptersSnap = await chaptersRef.get();

      final exactVerseMap = {
        'book_id': 'ramayana',
        'book_name': 'Ramayana',
        'kanda_number': 1,
        'kanda_name': 'Bala Kanda',
        'sarga_number': 2,
        'verse_number': 15,
        'verseNumber': 15,
        'sanskrit': 'मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: । यत्क्रौञ्चमिथुनादेकमवधी: काममोहितम् ।।1.2.15।।',
        'english': 'O niṣāda, may you not attain enduring standing for endless years, because you killed one of the krauñca pair while it was overcome by desire.',
        'hindi': 'हे निषाद, तू दीर्घकाल तक प्रतिष्ठा प्राप्त न करे, क्योंकि तूने काम-मोहित क्रौञ्च-युगल में से एक को मार डाला।',
        'gujarati': 'હે નિષાદ, તું દીર્ઘકાળ સુધી પ્રતિષ્ઠા પ્રાપ્ત ન કરે, કારણ કે તું કામમોહિત ક્રૌંચ-યુગલમાંથી એકને મારી નાખ્યો.',
        'meaningEnglish': 'O niṣāda, may you not attain enduring standing for endless years, because you killed one of the krauñca pair while it was overcome by desire.',
        'meaningHindi': 'हे निषाद, तू दीर्घकाल तक प्रतिष्ठा प्राप्त न करे, क्योंकि तूने काम-मोहित क्रौञ्च-युगल में से एक को मार डाला।',
        'meaningGujarati': 'હે નિષાદ, તું દીર્ઘકાળ સુધી પ્રતિષ્ઠા પ્રાપ્ત ન કરે, કારણ કે તું કામમોહિત ક્રૌંચ-યુગલમાંથી એકને મારી નાખ્યો.',
        'published': true,
        'archived': false,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Collect target chapter references (e.g. kanda_1_sarga_2, 1002, 1, etc.)
      final List<DocumentReference> targetChapterRefs = [];

      for (final doc in chaptersSnap.docs) {
        final data = doc.data();
        final kNum = data['kanda_number'] ?? data['chapterNumber'];
        final sNum = data['sarga_number'] ?? data['order'];
        final title = (data['title'] ?? '').toString().toLowerCase();

        if (doc.id == '1002' || doc.id == 'kanda_1_sarga_2' || (kNum == 1 && sNum == 2) || (kNum == 1002 || title.contains('bala'))) {
          targetChapterRefs.add(doc.reference);
        }
      }

      if (targetChapterRefs.isEmpty) {
        final newChapRef = chaptersRef.doc('kanda_1_sarga_2');
        await newChapRef.set({
          'chapterNumber': 1,
          'kanda_number': 1,
          'sarga_number': 2,
          'kanda_name': 'Bala Kanda',
          'title': 'Bala Kanda',
          'subtitle': 'Sarga 2',
          'published': true,
          'archived': false,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        targetChapterRefs.add(newChapRef);
      }

      for (final chapRef in targetChapterRefs) {
        final versesRef = chapRef.collection('verses');
        final versesSnap = await versesRef.get();

        DocumentReference? targetVerseRef;
        for (final vDoc in versesSnap.docs) {
          final vData = vDoc.data();
          final vNum = vData['verseNumber'] ?? vData['verse_number'];
          final sNum = vData['sarga_number'] ?? vData['sargaNumber'];

          if (vNum == 15) {
            if (sNum == null || sNum == 2) {
              targetVerseRef = vDoc.reference;
              break;
            }
          }
        }

        targetVerseRef ??= versesRef.doc('RAM-01-002-015');
        await targetVerseRef.set(exactVerseMap, SetOptions(merge: true));
      }

      await _logsService.logAction(
        action: 'Upserted Ramayana 1.2.15 Verse',
        target: 'Firestore sacred_books/ramayana/chapters/*/verses/RAM-01-002-015',
        details: 'Saved exact Ma Nishada shloka content in Sanskrit, English, Hindi, and Gujarati',
      );
    } catch (e) {
      print('Error upserting Ramayana 1.2.15 verse: $e');
    }
  }
}
