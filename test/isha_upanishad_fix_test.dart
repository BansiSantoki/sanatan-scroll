import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/data/upanishads_data.dart';
import 'package:sanatan_scroll/data/sacred_books_repository.dart';

void main() {
  group('Isha Upanishad Complete Fix Test Suite', () {
    test('1. Isha Upanishad data model contains exactly 18 mantras', () {
      final book = UpanishadsData.buildUpanishadsBook();

      expect(book.id, equals('upanishads'));
      expect(book.title, equals('Isha Upanishad'));
      expect(book.subtitle, equals('18 Mantras'));
      expect(book.totalChapters, equals(18));
      expect(book.chapters.length, equals(18));

      for (int i = 0; i < 18; i++) {
        final chapter = book.chapters[i];
        final num = i + 1;
        expect(chapter.chapterNumber, equals(num));
        expect(chapter.title, equals('Mantra $num'));
        expect(chapter.verses.length, equals(1));

        final verse = chapter.verses.first;
        expect(verse.verseNumber, equals(num));
        expect(verse.sanskrit, isNotEmpty, reason: 'Mantra $num must have Sanskrit');
        expect(verse.english, isNotEmpty, reason: 'Mantra $num must have English translation');
        expect(verse.hindi, isNotEmpty, reason: 'Mantra $num must have Hindi translation');
        expect(verse.gujarati, isNotEmpty, reason: 'Mantra $num must have Gujarati translation');
      }
    });

    test('2. Verify deterministic IDs and reference numbers for all 18 mantras', () {
      expect(UpanishadsData.passages.length, equals(18));

      for (int i = 0; i < 18; i++) {
        final passage = UpanishadsData.passages[i];
        final num = i + 1;
        final expectedPad = num.toString().padLeft(3, '0');
        final expectedRefPad = num.toString().padLeft(2, '0');

        expect(passage.id, equals('ISHA-K-$expectedPad'));
        expect(passage.referenceNo, equals('ISHA-K-$expectedRefPad'));
      }
    });

    test('3. Verify exact Mantra 1 and Mantra 18 content integrity', () {
      final mantra1 = UpanishadsData.passages[0];
      expect(mantra1.sanskrit, contains('ईशावास्यमिदं सर्वं'));
      expect(mantra1.english, contains('All this—whatever moves'));
      expect(mantra1.hindi, contains('इस समस्त जगत में'));
      expect(mantra1.gujarati, contains('આ સમગ્ર જગતમાં'));

      final mantra18 = UpanishadsData.passages[17];
      expect(mantra18.sanskrit, contains('अग्ने नय सुपथा राये'));
      expect(mantra18.english, contains('O Agni, lead us by the good path'));
      expect(mantra18.hindi, contains('हे अग्ने, हमें शुभ मार्ग'));
      expect(mantra18.gujarati, contains('હે અગ્નિ, અમને શુભ માર્ગે'));
    });

    test('4. SacredBooksRepository fallback streams all 18 mantras cleanly', () async {
      final book = await SacredBooksRepository.streamBookWithChapterVerses(
        bookId: 'upanishads',
        chapterNumber: 1,
      ).first;

      expect(book, isNotNull);
      expect(book!.chapters.length, equals(18));
      expect(book.chapters.first.title, equals('Mantra 1'));
      expect(book.chapters.last.title, equals('Mantra 18'));
    });

    test('5. Mahabharata is excluded from main streamAllBooks metadata', () async {
      final books = await SacredBooksRepository.streamAllBooks().first;
      final hasMahabharata = books.any((b) => b.id.toLowerCase() == 'mahabharata');

      expect(hasMahabharata, isFalse, reason: 'Mahabharata must be excluded from active app book lists');
    });
  });
}
