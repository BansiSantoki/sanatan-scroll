import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Sanatan Scroll',
      'home': 'Home',
      'streak': 'Streak',
      'saved': 'Saved',
      'feed': 'Feed',
      'profile': 'Profile',
      'namaste': 'Namaste',
      'daysStreak': '{count} Days',
      'language': 'Language',
      'selectLanguage': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी',
      'gujarati': 'ગુજરાતી',
      'dailyWisdom': 'DAILY WISDOM',
      'continueYourJourney': 'Continue Your Journey',
      'pickUpWhereYouLeftOff': 'Pick up where you left off',
      'startReading': 'Start Reading',
      'resumeReading': 'Resume Reading',
      'exploreScriptures': 'EXPLORE SCRIPTURES',
      'diveIntoTimelessWisdom': 'Dive into timeless wisdom',
      'gita': 'Gita',
      'gitaSubtitle': 'The Song of the Divine',
      'bhagavadGita': 'Bhagavad Gita',
      'ramayana': 'Ramayana',
      'ramayanaSubtitle': 'The Epic of Duty',
      'upanishads': 'Upanishads',
      'upanishadsSubtitle': 'Wisdom of the Self',
      'mahabharata': 'Mahabharata',
      'mahabharataSubtitle': 'The Great Epic',
      'chapter': 'Chapter',
      'chapters': 'Chapters',
      'verse': 'Verse',
      'verses': 'Verses',
      'meaning': 'Meaning',
      'sanskrit': 'Sanskrit',
      'transliteration': 'Transliteration',
      'explanation': 'Explanation',
      'markAsRead': 'Mark as Read',
      'completed': 'Completed',
      'readChapter': 'Read Chapter',
      'nextChapter': 'Next Chapter',
      'previousChapter': 'Previous Chapter',
      'currentStreak': 'Current Streak',
      'longestStreak': 'Longest Streak',
      'totalDays': 'Total Days',
      'wisdomCollected': 'Wisdom Collected',
      'savedWisdom': 'Saved Wisdom',
      'noSavedItemsYet': 'No saved items yet',
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'signOut': 'Sign Out',
      'continueAsGuest': 'Continue as Guest',
      'welcomeMessage': 'Wisdom for your journey',
      'beginYourJourney': 'Begin Your Journey',
      'settings': 'Settings',
      'accountDetails': 'Account Details',
      'appVersion': 'Version 1.0.0',
    },
    'gu': {
      'appName': 'સનાતન સ્ક્રોલ',
      'home': 'હોમ',
      'streak': 'સ્ટ્રીક',
      'saved': 'સેવ્ડ',
      'feed': 'ફીડ',
      'profile': 'પ્રોફાઇલ',
      'namaste': 'નમસ્તે',
      'daysStreak': '{count} દિવસ',
      'language': 'ભાષા',
      'selectLanguage': 'ભાષા પસંદ કરો',
      'english': 'English',
      'hindi': 'हिंदी',
      'gujarati': 'ગુજરાતી',
      'dailyWisdom': 'દૈનિક જ્ઞાન',
      'continueYourJourney': 'તમારી યાત્રા શરૂ રાખો',
      'pickUpWhereYouLeftOff': 'જ્યાંથી છોડ્યું હતું ત્યાંથી શરૂ કરો',
      'startReading': 'વાંચવાનું શરૂ કરો',
      'resumeReading': 'ફરીથી વાંચવાનું શરૂ કરો',
      'exploreScriptures': 'શાસ્ત્રોનું અન્વેષણ કરો',
      'diveIntoTimelessWisdom': 'શાશ્વત જ્ઞાનમાં ડૂબકી લગાવો',
      'gita': 'ગીતા',
      'gitaSubtitle': 'દિવ્ય સંગીત',
      'bhagavadGita': 'ભગવદ્ ગીતા',
      'ramayana': 'રામાયણ',
      'ramayanaSubtitle': 'કર્તવ્યની મહાગાથા',
      'upanishads': 'ઉપનિષદ',
      'upanishadsSubtitle': 'આત્મજ્ઞાન',
      'mahabharata': 'મહાભારત',
      'mahabharataSubtitle': 'મહાન મહાકાવ્ય',
      'chapter': 'અધ્યાય',
      'chapters': 'અધ્યાયો',
      'verse': 'શ્લોક',
      'verses': 'શ્લોકો',
      'meaning': 'અર્થ',
      'sanskrit': 'સંસ્કૃત',
      'transliteration': 'લિપ્યંતરણ',
      'explanation': 'સરળ અર્થ',
      'markAsRead': 'વાંચેલું ચિહ્નિત કરો',
      'completed': 'પૂર્ણ થયું',
      'readChapter': 'અધ્યાય વાંચો',
      'nextChapter': 'આગળનો અધ્યાય',
      'previousChapter': 'પાછળનો અધ્યાય',
      'currentStreak': 'વર્તમાન સ્ટ્રીક',
      'longestStreak': 'સૌથી લાંબી સ્ટ્રીક',
      'totalDays': 'કુલ દિવસો',
      'wisdomCollected': 'એકત્રિત જ્ઞાન',
      'savedWisdom': 'સાચવેલ જ્ઞાન',
      'noSavedItemsYet': 'હજી સુધી કોઈ સેવ કરેલી વસ્તુઓ નથી',
      'signIn': 'સાઇન ઇન કરો',
      'signUp': 'સાઇન અપ કરો',
      'signOut': 'સાઇન આઉટ કરો',
      'continueAsGuest': 'મહેમાન તરીકે આગળ વધો',
      'welcomeMessage': 'તમારી યાત્રા માટે જ્ઞાન',
      'beginYourJourney': 'તમારી અંતરંગ યાત્રા શરૂ કરો',
      'settings': 'સેટિંગ્સ',
      'accountDetails': 'ખાતાની વિગતો',
      'appVersion': 'આવૃત્તિ 1.0.0',
    },
    'hi': {
      'appName': 'सनातन स्क्रॉल',
      'home': 'होम',
      'streak': 'स्ट्रिक',
      'saved': 'सेव्ड',
      'feed': 'फीड',
      'profile': 'प्रोफाइल',
      'namaste': 'नमस्ते',
      'daysStreak': '{count} दिन',
      'language': 'भाषा',
      'selectLanguage': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी',
      'gujarati': 'ગુજરાતી',
      'dailyWisdom': 'दैनिक ज्ञान',
      'continueYourJourney': 'अपनी यात्रा जारी रखें',
      'pickUpWhereYouLeftOff': 'जहां से छोड़ा था वहीं से शुरू करें',
      'startReading': 'पढ़ना शुरू करें',
      'resumeReading': 'पुनः पढ़ना शुरू करें',
      'exploreScriptures': 'शास्त्रों का अन्वेषण करें',
      'diveIntoTimelessWisdom': 'शाश्वत ज्ञान में गोता लगाएं',
      'gita': 'गीता',
      'gitaSubtitle': 'दिव्य गीत',
      'bhagavadGita': 'भगवद गीता',
      'ramayana': 'रामायण',
      'ramayanaSubtitle': 'कर्तव्य की महागाथा',
      'upanishads': 'उपनिषद',
      'upanishadsSubtitle': 'आत्मज्ञान',
      'mahabharata': 'महाभारत',
      'mahabharataSubtitle': 'महान महाकाव्य',
      'chapter': 'अध्याय',
      'chapters': 'अध्याय',
      'verse': 'श्लोक',
      'verses': 'श्लोक',
      'meaning': 'अर्थ',
      'sanskrit': 'संस्कृत',
      'transliteration': 'लिप्यांतरण',
      'explanation': 'व्याख्या',
      'markAsRead': 'पढ़ा हुआ चिह्नित करें',
      'completed': 'पूर्ण हुआ',
      'readChapter': 'अध्याय पढ़ें',
      'nextChapter': 'अगला अध्याय',
      'previousChapter': 'पिछला अध्याय',
      'currentStreak': 'वर्तमान स्ट्रिक',
      'longestStreak': 'सर्वश्रेष्ठ स्ट्रिक',
      'totalDays': 'कुल दिन',
      'wisdomCollected': 'संग्रहित ज्ञान',
      'savedWisdom': 'संग्रहित ज्ञान',
      'noSavedItemsYet': 'अभी तक कोई सहेजी गई सामग्री नहीं है',
      'signIn': 'साइन इन करें',
      'signUp': 'साइन अप करें',
      'signOut': 'साइन आउट करें',
      'continueAsGuest': 'अतिथि के रूप में जारी रखें',
      'welcomeMessage': 'आपकी यात्रा के लिए ज्ञान',
      'beginYourJourney': 'अपनी यात्रा शुरू करें',
      'settings': 'सेटिंग्स',
      'accountDetails': 'खाता विवरण',
      'appVersion': 'संस्करण 1.0.0',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    final currentLangMap = _localizedValues[langCode];
    if (currentLangMap != null && currentLangMap.containsKey(key) && currentLangMap[key]!.isNotEmpty) {
      return currentLangMap[key]!;
    }
    // Fallback to English
    final fallbackMap = _localizedValues['en']!;
    return fallbackMap[key] ?? key;
  }

  String daysStreak(int count) {
    final pattern = translate('daysStreak');
    return pattern.replaceAll('{count}', count.toString());
  }

  String get appName => translate('appName');
  String get home => translate('home');
  String get streak => translate('streak');
  String get saved => translate('saved');
  String get feed => translate('feed');
  String get profile => translate('profile');
  String get namaste => translate('namaste');
  String get language => translate('language');
  String get selectLanguage => translate('selectLanguage');
  String get english => translate('english');
  String get hindi => translate('hindi');
  String get gujarati => translate('gujarati');
  String get dailyWisdom => translate('dailyWisdom');
  String get continueYourJourney => translate('continueYourJourney');
  String get pickUpWhereYouLeftOff => translate('pickUpWhereYouLeftOff');
  String get startReading => translate('startReading');
  String get resumeReading => translate('resumeReading');
  String get exploreScriptures => translate('exploreScriptures');
  String get diveIntoTimelessWisdom => translate('diveIntoTimelessWisdom');
  String get gita => translate('gita');
  String get gitaSubtitle => translate('gitaSubtitle');
  String get bhagavadGita => translate('bhagavadGita');
  String get ramayana => translate('ramayana');
  String get ramayanaSubtitle => translate('ramayanaSubtitle');
  String get upanishads => translate('upanishads');
  String get upanishadsSubtitle => translate('upanishadsSubtitle');
  String get mahabharata => translate('mahabharata');
  String get mahabharataSubtitle => translate('mahabharataSubtitle');
  String get chapter => translate('chapter');
  String get chapters => translate('chapters');
  String get verse => translate('verse');
  String get verses => translate('verses');
  String get meaning => translate('meaning');
  String get sanskrit => translate('sanskrit');
  String get transliteration => translate('transliteration');
  String get explanation => translate('explanation');
  String get markAsRead => translate('markAsRead');
  String get completed => translate('completed');
  String get readChapter => translate('readChapter');
  String get nextChapter => translate('nextChapter');
  String get previousChapter => translate('previousChapter');
  String get currentStreak => translate('currentStreak');
  String get longestStreak => translate('longestStreak');
  String get totalDays => translate('totalDays');
  String get wisdomCollected => translate('wisdomCollected');
  String get savedWisdom => translate('savedWisdom');
  String get noSavedItemsYet => translate('noSavedItemsYet');
  String get signIn => translate('signIn');
  String get signUp => translate('signUp');
  String get signOut => translate('signOut');
  String get continueAsGuest => translate('continueAsGuest');
  String get welcomeMessage => translate('welcomeMessage');
  String get beginYourJourney => translate('beginYourJourney');
  String get settings => translate('settings');
  String get accountDetails => translate('accountDetails');
  String get appVersion => translate('appVersion');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'gu', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
