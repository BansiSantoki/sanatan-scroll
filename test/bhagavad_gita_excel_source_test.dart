import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/data/bhagavad_gita_data.dart';
import 'package:sanatan_scroll/data/bhagavad_gita_excel_source_of_truth.dart';
import 'package:sanatan_scroll/data/sacred_books_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bhagavad Gita Excel Source of Truth Verification', () {
    test('Source dataset contains exactly 701 records', () {
      expect(bhagavadGitaExcelSourceData.length, equals(701));
    });

    test('BhagavadGitaData.buildGitaBook builds exactly 18 chapters', () {
      final book = BhagavadGitaData.buildGitaBook();
      expect(book.id, equals('bhagavad_gita'));
      expect(book.chapters.length, equals(18));
      expect(book.totalChapters, equals(18));

      for (int i = 0; i < 18; i++) {
        expect(book.chapters[i].chapterNumber, equals(i + 1));
      }
    });

    test('Each chapter appears exactly once with no duplicates', () {
      final book = BhagavadGitaData.buildGitaBook();
      final chapterNumbers = book.chapters.map((c) => c.chapterNumber).toList();
      final uniqueNumbers = chapterNumbers.toSet();
      expect(uniqueNumbers.length, equals(18));
      expect(chapterNumbers, equals(List.generate(18, (i) => i + 1)));
    });

    test('Total verses across all 18 chapters sum to exactly 701', () {
      final book = BhagavadGitaData.buildGitaBook();
      final totalVerses = book.chapters.fold<int>(0, (sum, chap) => sum + chap.verses.length);
      expect(totalVerses, equals(701));
    });

    test('Every verse has non-empty Sanskrit, Translation, Context, and Reflection in EN, HI, GU', () {
      final book = BhagavadGitaData.buildGitaBook();
      for (final chapter in book.chapters) {
        for (final verse in chapter.verses) {
          expect(verse.sanskrit.trim().isNotEmpty, isTrue, reason: 'Empty Sanskrit in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');

          expect(verse.english.trim().isNotEmpty, isTrue, reason: 'Empty EN translation in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
          expect(verse.hindi?.trim().isNotEmpty, isTrue, reason: 'Empty HI translation in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
          expect(verse.gujarati.trim().isNotEmpty, isTrue, reason: 'Empty GU translation in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');

          expect(verse.getContextText('en').trim().isNotEmpty, isTrue, reason: 'Empty EN context in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
          expect(verse.getContextText('hi').trim().isNotEmpty, isTrue, reason: 'Empty HI context in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
          expect(verse.getContextText('gu').trim().isNotEmpty, isTrue, reason: 'Empty GU context in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');

          expect(verse.getReflectionFullText('en').trim().isNotEmpty, isTrue, reason: 'Empty EN reflection in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
          expect(verse.getReflectionFullText('hi').trim().isNotEmpty, isTrue, reason: 'Empty HI reflection in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
          expect(verse.getReflectionFullText('gu').trim().isNotEmpty, isTrue, reason: 'Empty GU reflection in Ch ${chapter.chapterNumber} V ${verse.verseNumber}');
        }
      }
    });

    test('Verify BG-01-001 content accuracy', () {
      final book = BhagavadGitaData.buildGitaBook();
      final ch1 = book.getChapter(1)!;
      expect(ch1.title, equals('Arjuna Vishada Yoga'));

      final v1 = ch1.verses.first;
      expect(v1.verseNumber, equals(1));
      expect(v1.sanskrit, contains('धर्मक्षेत्रे कुरुक्षेत्रे'));
      expect(v1.getLocalizedTranslation('en'), contains('Dhritarashtra said: O Sanjaya'));
      expect(v1.getLocalizedTranslation('hi'), contains('धृतराष्ट्र ने कहा: हे संजय'));
      expect(v1.getLocalizedTranslation('gu'), contains('ધૃતરાષ્ટ્રે કહ્યું: હે સંજય'));

      expect(v1.getContextText('en'), contains('Dhritarashtra opens the Gita'));
      expect(v1.getContextText('hi'), contains('धृतराष्ट्र गीता की शुरुआत'));
      expect(v1.getContextText('gu'), contains('ધૃતરાષ્ટ્ર ગીતા ની શરૂઆત'));

      expect(v1.getReflectionFullText('en'), contains('The conflict begins before a weapon is raised'));
      expect(v1.getReflectionFullText('hi'), contains('संघर्ष शस्त्र उठने से पहले ही'));
      expect(v1.getReflectionFullText('gu'), contains('સંઘર્ષ શસ્ત્ર ઉઠે તે પહેલાં જ'));
    });

    test('SacredBooksRepository streams Bhagavad Gita directly without network dependency', () async {
      final bookStream = SacredBooksRepository.streamBookById('bhagavad_gita');
      final book = await bookStream.first;
      expect(book, isNotNull);
      expect(book!.chapters.length, equals(18));
      expect(book.chapters.first.verses.length, equals(47));
    });
  });
}
