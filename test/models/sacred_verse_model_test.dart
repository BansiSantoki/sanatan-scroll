import 'package:flutter_test/flutter_test.dart';
import 'package:sanatan_scroll/models/sacred_verse_model.dart';

void main() {
  group('SacredVerseModel Ramayana Translation System Verification', () {
    test('1. Canonical Verse Identity & Map Binding', () {
      final mapData = {
        'passage_id': 'RAM-01-002-015',
        'canonical_reference': '1.2.15',
        'kanda_no': 1,
        'sarga_no': 2,
        'shlok_no': 15,
        'sanskrit': 'मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।',
        'english': 'O hunter, may you not attain fame for endless years.',
        'hindi': 'हे निषाद, तुम अनंत वर्षों तक प्रतिष्ठा प्राप्त न करो।',
        'gujarati': 'હે નિષાદ, તું અનંત વર્ષો સુધી પ્રતિષ્ઠા પ્રાપ્ત ન કર.',
      };

      final verse = SacredVerseModel.fromMap(mapData);

      expect(verse.verseNumber, equals(15));
      expect(verse.kandaNumber, equals(1));
      expect(verse.sargaNumber, equals(2));
      expect(verse.sanskrit, equals('मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।'));
      expect(verse.english, equals('O hunter, may you not attain fame for endless years.'));
      expect(verse.hindi, equals('हे निषाद, तुम अनंत वर्षों तक प्रतिष्ठा प्राप्त न करो।'));
      expect(verse.gujarati, equals('હે નિષાદ, તું અનંત વર્ષો સુધી પ્રતિષ્ઠા પ્રાપ્ત ન કર.'));
    });

    test('2. Live Language Switching for Same Verse Object', () {
      final mapData = {
        'passage_id': 'RAM-01-002-015',
        'canonical_reference': '1.2.15',
        'kanda_no': 1,
        'sarga_no': 2,
        'shlok_no': 15,
        'sanskrit': 'मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।',
        'english': 'English translation for 1.2.15',
        'hindi': 'Hindi translation for 1.2.15',
        'gujarati': 'Gujarati translation for 1.2.15',
      };

      final verse = SacredVerseModel.fromMap(mapData);

      // Verify English selection
      expect(verse.getLocalizedTranslation('en'), equals('English translation for 1.2.15'));
      expect(verse.sanskrit, equals('मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।'));
      expect(verse.verseNumber, equals(15));

      // Verify Hindi selection
      expect(verse.getLocalizedTranslation('hi'), equals('Hindi translation for 1.2.15'));
      expect(verse.sanskrit, equals('मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।'));
      expect(verse.verseNumber, equals(15));

      // Verify Gujarati selection
      expect(verse.getLocalizedTranslation('gu'), equals('Gujarati translation for 1.2.15'));
      expect(verse.sanskrit, equals('मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।'));
      expect(verse.verseNumber, equals(15));

      // Verify repeated switching back to English
      expect(verse.getLocalizedTranslation('en'), equals('English translation for 1.2.15'));
    });

    test('3. Missing Translation Safety (No Cross-Language Fallback)', () {
      final mapDataOnlyEnglish = {
        'passage_id': 'RAM-01-002-016',
        'canonical_reference': '1.2.16',
        'kanda_no': 1,
        'sarga_no': 2,
        'shlok_no': 16,
        'sanskrit': 'तस्यैवं ब्रुवतः कार्यात्कारुण्योद्वेगजा मतिः ।',
        'english': 'English translation for 1.2.16',
        'hindi': '',
        'gujarati': '',
      };

      final verse = SacredVerseModel.fromMap(mapDataOnlyEnglish);

      expect(verse.getLocalizedTranslation('en'), equals('English translation for 1.2.16'));
      expect(verse.getLocalizedTranslation('hi'), equals('अनुवाद उपलब्ध नहीं है।'));
      expect(verse.getLocalizedTranslation('gu'), equals('અનુવાદ ઉપલબ્ધ નથી.'));
    });

    test('4. Dynamic Content (No Hardcoded Translation Overrides)', () {
      final emptyFirestoreMap = {
        'passage_id': 'RAM-01-002-015',
        'canonical_reference': '1.2.15',
        'kanda_no': 1,
        'sarga_no': 2,
        'shlok_no': 15,
        'sanskrit': 'मा निषाद प्रतिष्ठां त्वमगमश्शाश्वतीस्समा: ।',
        'english': '',
        'hindi': '',
        'gujarati': '',
      };

      final verse = SacredVerseModel.fromMap(emptyFirestoreMap);

      // Verify no hardcoded Ma Nishada string is injected inside Flutter code
      expect(verse.getLocalizedTranslation('en'), equals('Translation not available.'));
      expect(verse.getLocalizedTranslation('hi'), equals('अनुवाद उपलब्ध नहीं है।'));
      expect(verse.getLocalizedTranslation('gu'), equals('અનુવાદ ઉપલબ્ધ નથી.'));
    });

    test('5. Bhagavad Gita Hardcoded Model Translation Resolution in en, hi, gu', () {
      const gitaVerse = SacredVerseModel(
        verseNumber: 1,
        sanskrit: 'धृतराष्ट्र उवाच ।\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ॥१॥',
        english: 'Dhritarashtra said: O Sanjaya, what did my sons and the sons of Pandu do when they assembled on the holy field of Kurukshetra, eager to fight?',
        gujarati: 'ધૃતરાષ્ટ્ર બોલ્યા: હે સંજય! ધર્મભૂમિ કુરુક્ષેત્રમાં યુદ્ધ કરવાની ઇચ્છાથી ભેગા થયેલા મારા પુત્રો અને પાંડુના પુત્રોએ શું કર્યું?',
        meaningEnglish: 'Dhritarashtra asks Sanjaya what happened when the Kauravas and Pandavas gathered at Kurukshetra for battle.',
        meaningGujarati: 'ધૃતરાષ્ટ્ર સંજયને પૂછે છે કે ધર્મક્ષેત્ર કુરુક્ષેત્રમાં યુદ્ધ માટે ભેગા થયેલા કૌરવો અને પાંડવો શું કરી રહ્યા છે.',
      );

      // 1. English mode returns English translation
      expect(gitaVerse.getLocalizedTranslation('en'), contains('Dhritarashtra said'));

      // 2. Gujarati mode returns Gujarati translation
      expect(gitaVerse.getLocalizedTranslation('gu'), contains('ધૃતરાષ્ટ્ર બોલ્યા'));

      // 3. Hindi mode returns Hindi translation in Devanagari script (never falls back to English)
      final hindiText = gitaVerse.getLocalizedTranslation('hi');
      expect(hindiText, contains('धृतराष्ट्र'));
      expect(hindiText.contains('Dhritarashtra said'), isFalse, reason: 'Must NOT fall back to English when Hindi is selected');

      // 4. Case-insensitive / locale code normalization ('hi-IN', 'gu-IN', 'en-US')
      expect(gitaVerse.getLocalizedTranslation('hi-IN'), equals(hindiText));
      expect(gitaVerse.getLocalizedTranslation('gu-IN'), equals(gitaVerse.getLocalizedTranslation('gu')));
      expect(gitaVerse.getLocalizedTranslation('en-US'), equals(gitaVerse.getLocalizedTranslation('en')));
    });
  });
}
