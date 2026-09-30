import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/data/sacred_books_data.dart';

void main() {
  group('Bhagavad Gita localization', () {
    test('chapter metadata uses localizable chapter names and subtitles in English and Gujarati', () {
      final book = SacredBooksData.findById('bhagavad_gita');

      expect(book, isNotNull);
      expect(book!.chapters.length, 18);

      final first = book.chapters.first;
      expect(first.chapterNumber, 1);
      expect(first.title, 'Arjuna Vishada Yoga');

      final second = book.chapters[1];
      expect(second.chapterNumber, 2);
      expect(second.title, 'Sankhya Yoga');
    });
  });
}
