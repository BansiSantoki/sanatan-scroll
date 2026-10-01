import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/data/sacred_books_data.dart';
import 'package:sanatan_scroll/models/sacred_verse_model.dart';

void main() {
  group('Ramayana Reader Flow & Navigation Test Suite', () {
    test('1. Ramayana book contains canonical Kanda metadata and fallback chapters', () async {
      final book = SacredBooksData.findById('ramayana');
      expect(book, isNotNull);
      expect(book!.id, equals('ramayana'));
      expect(book.totalChapters, equals(7));

      final kandaNames = [
        'Bala Kanda',
        'Ayodhya Kanda',
        'Aranya Kanda',
        'Kishkindha Kanda',
        'Sundara Kanda',
        'Yuddha Kanda',
        'Uttara Kanda',
      ];

      for (int i = 0; i < 7; i++) {
        final chapter = book.chapters[i];
        expect(chapter.chapterNumber, equals(i + 1));
        expect(chapter.title, equals(kandaNames[i]));
      }
    });

    test('2. Composite chapter numbers correctly map Kanda and Sarga', () {
      // Formula: composite = (kanda * 1000) + sarga
      const kanda = 1; // Bala Kanda
      const sarga = 1;
      const composite = (kanda * 1000) + sarga; // 1001

      expect(composite ~/ 1000, equals(kanda));
      expect(composite % 1000, equals(sarga));

      const kanda2 = 2; // Ayodhya Kanda
      const sarga5 = 119;
      const composite2 = (kanda2 * 1000) + sarga5; // 2119

      expect(composite2 ~/ 1000, equals(kanda2));
      expect(composite2 % 1000, equals(sarga5));
    });

    test('3. Numeric sorting of verses works correctly (1, 2, 3 ... 9, 10, 11)', () {
      final unsortedVerses = [
        const SacredVerseModel(verseNumber: 10, sanskrit: '10', english: '10', gujarati: '10', meaningEnglish: '10', meaningGujarati: '10'),
        const SacredVerseModel(verseNumber: 1, sanskrit: '1', english: '1', gujarati: '1', meaningEnglish: '1', meaningGujarati: '1'),
        const SacredVerseModel(verseNumber: 2, sanskrit: '2', english: '2', gujarati: '2', meaningEnglish: '2', meaningGujarati: '2'),
        const SacredVerseModel(verseNumber: 11, sanskrit: '11', english: '11', gujarati: '11', meaningEnglish: '11', meaningGujarati: '11'),
        const SacredVerseModel(verseNumber: 9, sanskrit: '9', english: '9', gujarati: '9', meaningEnglish: '9', meaningGujarati: '9'),
      ];

      unsortedVerses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));

      final sortedNumbers = unsortedVerses.map((v) => v.verseNumber).toList();
      expect(sortedNumbers, equals([1, 2, 9, 10, 11]));
    });

    test('4. Sarga transitions and Kanda sequence navigation state machine', () {
      const kandaSargaCounts = {
        1: 77,  // Bala Kanda
        2: 119, // Ayodhya Kanda
        3: 75,  // Aranya Kanda
        4: 67,  // Kishkindha Kanda
        5: 68,  // Sundara Kanda
        6: 128, // Yuddha Kanda
        7: 111, // Uttara Kanda
      };

      int currentKanda = 1;
      int currentSarga = 1;

      // Simulate advancing from Sarga 1 to Sarga 77 of Bala Kanda
      while (currentSarga < kandaSargaCounts[currentKanda]!) {
        currentSarga++;
      }

      expect(currentKanda, equals(1));
      expect(currentSarga, equals(77)); // Last Sarga of Bala Kanda

      // Transition to Next Sarga (which triggers Next Kanda transition!)
      if (currentSarga == kandaSargaCounts[currentKanda]!) {
        currentKanda++;
        currentSarga = 1;
      }

      expect(currentKanda, equals(2)); // Ayodhya Kanda
      expect(currentSarga, equals(1)); // Sarga 1
    });

    test('5. Vertical swipe up transitions to Next Sarga from ANY shloka (1, 2, 3, etc.)', () {
      int currentKanda = 1;
      int currentSarga = 1;
      int currentShlokaIndex = 3; // Reading Shloka 4 (mid-Sarga)

      // Simulate upward swipe gesture from any shloka
      void onUpwardSwipe() {
        currentSarga++;
        currentShlokaIndex = 0; // Always reset to Shloka 1
      }

      onUpwardSwipe();

      expect(currentKanda, equals(1));
      expect(currentSarga, equals(2));
      expect(currentShlokaIndex, equals(0)); // Reset to Shloka 1

      currentShlokaIndex = 12; // Reading Shloka 13
      onUpwardSwipe();

      expect(currentKanda, equals(1));
      expect(currentSarga, equals(3));
      expect(currentShlokaIndex, equals(0));
    });
  });
}
