import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/data/sacred_books_data.dart';
import 'package:sanatan_scroll/models/sacred_chapter_model.dart';
import 'package:sanatan_scroll/models/sacred_verse_model.dart';

void main() {
  group('Bhagavad Gita localization', () {
    test('chapter metadata is loaded dynamically from Firestore document models', () {
      final book = SacredBooksData.findById('bhagavad_gita');

      expect(book, isNotNull);
      expect(book!.totalChapters, 18);
      expect(book.chapters.length, 18);

      final firestoreChapMap = {
        'chapterNumber': 1,
        'title': 'Chapter 1',
        'title_en': 'Chapter 1',
        'title_gu': 'અધ્યાય ૧',
        'title_hi': 'अध्याय १',
        'subtitle': 'Bhagavad Gita Chapter 1',
        'subtitle_en': 'Bhagavad Gita Chapter 1',
        'subtitle_gu': 'ભગવદ્ ગીતા અધ્યાય ૧',
        'subtitle_hi': 'भगवद् गीता अध्याय १',
      };

      final chap = SacredChapterModel.fromMap(firestoreChapMap);
      expect(chap.chapterNumber, 1);
      expect(chap.getLocalizedTitle('en'), 'Chapter 1');
      expect(chap.getLocalizedTitle('gu'), 'અધ્યાય ૧');
      expect(chap.getLocalizedTitle('hi'), 'अध्याय १');

      expect(chap.getLocalizedSubtitle('en'), 'Bhagavad Gita Chapter 1');
      expect(chap.getLocalizedSubtitle('gu'), 'ભગવદ્ ગીતા અધ્યાય ૧');
      expect(chap.getLocalizedSubtitle('hi'), 'भगवद् गीता अध्याय १');
    });

    test('SacredVerseModel resolves localized translation correctly', () {
      final verse = SacredVerseModel(
        verseNumber: 1,
        sanskrit: 'धृतराष्ट्र उवाच ।\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।',
        english: 'Dhritarashtra said: O Sanjaya...',
        gujarati: 'ધૃતરાષ્ટ્ર બોલ્યા: હે સંજય...',
        meaningEnglish: 'Dhritarashtra asks Sanjaya...',
        meaningGujarati: 'ધૃતરાષ્ટ્ર સંજયને પૂછે છે...',
      );

      expect(verse.sanskrit.contains('धृतराष्ट्र'), isTrue);
      expect(verse.getLocalizedTranslation('en'), 'Dhritarashtra said: O Sanjaya...');
      expect(verse.getLocalizedTranslation('gu'), 'ધૃતરાષ્ટ્ર બોલ્યા: હે સંજય...');
      expect(verse.getLocalizedTranslation('hi').contains('धृतराष्ट्र'), isTrue);

      // Sanskrit remains Sanskrit regardless of locale
      expect(verse.sanskrit, 'धृतराष्ट्र उवाच ।\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।');
    });

    test('SacredVerseModel parses aliases from Firestore doc maps correctly', () {
      final map = {
        'verseNumber': 1,
        'sanskrit_text': 'धृतराष्ट्र उवाच',
        'translation_en': 'English text via alias',
        'translation_gu': 'Gujarati text via alias',
        'translation_hi': 'Hindi text via alias',
      };

      final verse = SacredVerseModel.fromMap(map);
      expect(verse.getLocalizedTranslation('en'), 'English text via alias');
      expect(verse.getLocalizedTranslation('gu'), 'Gujarati text via alias');
      expect(verse.getLocalizedTranslation('hi'), 'Hindi text via alias');
    });
  });
}
