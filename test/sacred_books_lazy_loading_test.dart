import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/data/sacred_books_repository.dart';
import 'package:sanatan_scroll/models/sacred_book_model.dart';

void main() {
  group('Mobile Sacred Books Lazy Loading & Performance Test Suite', () {
    test('1. streamAllBooks emits lightweight book metadata instantly without deep verse fetch', () async {
      final stopwatch = Stopwatch()..start();
      final stream = SacredBooksRepository.streamAllBooks();
      final List<SacredBookModel> books = await stream.first;
      stopwatch.stop();

      print('=== STREAM ALL BOOKS PERFORMANCE ===');
      print('Emitted ${books.length} books in ${stopwatch.elapsedMilliseconds}ms');
      for (final book in books) {
        print('Book ID: ${book.id} | Title: ${book.title} | Chapters: ${book.totalChapters} | Preloaded Chapters List length: ${book.chapters.length}');
      }

      expect(books, isNotEmpty);
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(books.any((b) => b.id == 'bhagavad_gita'), isTrue);
      expect(books.any((b) => b.id == 'ramayana'), isTrue);
    });

    test('2. streamBookById lazy loads chapters for requested book', () async {
      final stream = SacredBooksRepository.streamBookById('bhagavad_gita');
      final book = await stream.first;

      expect(book, isNotNull);
      expect(book!.id, equals('bhagavad_gita'));
      expect(book.totalChapters, equals(18));
    });

    test('3. streamBookWithChapterVerses streams book metadata when offline', () async {
      final stream = SacredBooksRepository.streamBookWithChapterVerses(
        bookId: 'bhagavad_gita',
        chapterNumber: 1,
      );
      final book = await stream.first;

      expect(book, isNotNull);
      expect(book!.id, equals('bhagavad_gita'));
      expect(book.totalChapters, equals(18));
    });

    test('4. streamBookWithChapterVerses for upanishads populates verses for all 18 mantras', () async {
      final stream = SacredBooksRepository.streamBookWithChapterVerses(
        bookId: 'upanishads',
        chapterNumber: 1,
      );
      final book = await stream.first;

      expect(book, isNotNull);
      expect(book!.chapters.length, equals(18));
      for (final chap in book.chapters) {
        expect(chap.verses, isNotEmpty, reason: 'Chapter ${chap.chapterNumber} must have shloka verses populated');
        expect(chap.verses.first.sanskrit, isNotEmpty);
      }
    });
  });
}
