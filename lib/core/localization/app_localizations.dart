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
      'sanskrit': 'SANSKRIT',
      'translation': 'TRANSLATION',
      'transliteration': 'Transliteration',
      'explanation': 'Explanation',
      'wisdom': 'WISDOM',
      'context': 'CONTEXT',
      'whyThisMattersNow': 'WHY THIS MATTERS NOW',
      'reflectionPreview': 'REFLECTION PREVIEW',
      'tapForFullReflection': 'Tap for full reflection',
      'reflection': 'REFLECTION',
      'oneThingToNoticeToday': 'ONE THING TO NOTICE TODAY',
      'tryThis': 'TRY THIS',
      'carryThisWithYou': 'CARRY THIS WITH YOU',
      'listenToAudio': 'Listen to Audio',
      'swipeUpForMore': 'Swipe up for more',
      'save': 'Save',
      'savedAction': 'Saved',
      'setWallpaper': 'Set Wallpaper',
      'share': 'Share',
      'audioNotAvailable': 'Audio is not available for this language.',
      'wallpaperSet': 'Wallpaper setting feature triggered!',
      'noSavedWisdomYet': 'No saved wisdom yet',
      'saveVersesPrompt': 'Save verses, reflections, and wisdom that inspire you.',
      'yourJourney': 'Your Journey',
      'smallStepsText': 'Small steps, deeper transformation.',
      'tracker': 'Tracker',
      'currentDailyStreak': 'Current Daily Streak',
      'keepSpiritualJourneyGoing': 'Keep your spiritual journey going.',
      'trackDailyProgress': 'Track your daily progress',
      'thisWeek': 'This Week',
      'viewAll': 'View all',
      'daysProgress': '{count} / 7 Days',
      'keepGoingHabit': 'Keep going, you\'re building a beautiful habit.',
      'milestones': 'Milestones',
      'milestoneBeginning': 'Beginning',
      'milestoneSteady': 'Steady',
      'milestonePracticed': 'Practiced',
      'milestoneDevoted': 'Devoted',
      'myProfile': 'My Profile',
      'yourAccountYourJourney': 'Your account, your journey.',
      'milestonesAndAchievements': 'Milestones & Achievements',
      'milestonesSubtitle': 'Track your growth and celebrate.',
      'settings': 'Settings',
      'settingsSubtitle': 'Manage your preferences.',
      'helpAndSupport': 'Help & Support',
      'helpSubtitle': 'We\'re here to help you.',
      'syncedAcrossDevices': 'Synced across devices',
      'syncedSubtitle': 'Your account is connected and your journey can be synced across devices.',
      'accountConnected': 'Account Connected',
      'signOut': 'Sign Out',
      'signOutSubtitle': 'Log out of your account.',
      'signOutConfirmTitle': 'Sign Out',
      'signOutConfirmMessage': 'Are you sure you want to sign out of your account?',
      'cancel': 'Cancel',
      'editProfile': 'Edit Profile',
      'displayName': 'Display name',
      'photoUrl': 'Photo URL',
      'close': 'Close',
      'googleVerified': 'Google Verified',
      'allSacredTexts': 'Sacred Texts',
      'seeAll': 'See All',
      'searchHint': 'Search wisdom, topics, scriptures...',
      'exploreWisdom': 'Explore Wisdom',
      'discoverTimelessTeachings': 'Discover timeless teachings',
      'scriptureNotFound': 'Scripture not found',
      'noVersesAvailable': 'No verses available for this chapter.',
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
      'continueAsGuest': 'Continue as Guest',
      'welcomeMessage': 'Wisdom for your journey',
      'beginYourJourney': 'Begin Your Journey',
      'accountDetails': 'Account Details',
      'appVersion': 'Version 1.0.0',
      'day': 'Day',
      'days': 'Days',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
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
      'translation': 'અનુવાદ',
      'transliteration': 'લિપ્યંતરણ',
      'explanation': 'સરળ અર્થ',
      'wisdom': 'જ્ઞાન',
      'context': 'સંદર્ભ',
      'whyThisMattersNow': 'આ શા માટે મહત્વનું છે',
      'reflectionPreview': 'ચિંતન પૂર્વાવલોકન',
      'tapForFullReflection': 'પૂર્ણ ચિંતન માટે ટેપ કરો',
      'reflection': 'ચિંતન',
      'oneThingToNoticeToday': 'આજે ધ્યાન આપવા જેવી બાબત',
      'tryThis': 'આ અજમાવો',
      'carryThisWithYou': 'આ તમારી સાથે રાખો',
      'listenToAudio': 'ઓડિયો સાંભળો',
      'swipeUpForMore': 'વધુ માટે ઉપર સ્વાઇપ કરો',
      'save': 'સાચવો',
      'savedAction': 'સાચવ્યું',
      'setWallpaper': 'વોલપેપર સેટ કરો',
      'share': 'શેર કરો',
      'audioNotAvailable': 'આ ભાષા માટે ઓડિયો ઉપલબ્ધ નથી.',
      'wallpaperSet': 'વોલપેપર સેટિંગ સુવિધા સક્રિય થઈ!',
      'noSavedWisdomYet': 'હજી સુધી કોઈ સાચવેલ જ્ઞાન નથી',
      'saveVersesPrompt': 'તમને પ્રેરણા આપતા શ્લોકો અને ચિંતન સાચવો.',
      'yourJourney': 'તમારી અંતરંગ યાત્રા',
      'smallStepsText': 'નાના પગલાં, ઊંડું રૂપાંતર.',
      'tracker': 'ટ્રેકર',
      'currentDailyStreak': 'વર્તમાન દૈનિક સ્ટ્રીક',
      'keepSpiritualJourneyGoing': 'તમારી આધ્યાત્મિક યાત્રા ચાલુ રાખો.',
      'trackDailyProgress': 'તમારી દૈનિક પ્રગતિ ટ્રેક કરો',
      'thisWeek': 'આ અઠવાડિયે',
      'viewAll': 'બધું જુઓ',
      'daysProgress': '{count} / ૭ દિવસ',
      'keepGoingHabit': 'આગળ વધો, તમે એક સુંદર ટેવ બનાવી રહ્યા છો.',
      'milestones': 'સિદ્ધિઓ',
      'milestoneBeginning': 'પ્રારંભ',
      'milestoneSteady': 'સ્થિર',
      'milestonePracticed': 'અભ્યાસુ',
      'milestoneDevoted': 'સમર્પિત',
      'myProfile': 'મારી પ્રોફાઇલ',
      'yourAccountYourJourney': 'તમારું ખાતું, તમારી યાત્રા.',
      'milestonesAndAchievements': 'સિદ્ધિઓ અને સફળતાઓ',
      'milestonesSubtitle': 'તમારી વૃદ્ધિ ટ્રેક કરો.',
      'settings': 'સેટિંગ્સ',
      'settingsSubtitle': 'તમારી પસંદગીઓ સંચાલિત કરો.',
      'helpAndSupport': 'મદદ અને સપોર્ટ',
      'helpSubtitle': 'અમે તમને મદદ કરવા તૈયાર છીએ.',
      'syncedAcrossDevices': 'બધા ઉપકરણો સાથે સમકાલિન',
      'syncedSubtitle': 'તમારું ખાતું જોડાયેલું છે અને યાત્રા સમકાલિન થાય છે.',
      'accountConnected': 'ખાતું જોડાયેલ છે',
      'signOut': 'સાઇન આઉટ કરો',
      'signOutSubtitle': 'તમારા ખાતામાંથી બહાર નીકળો.',
      'signOutConfirmTitle': 'સાઇન આઉટ',
      'signOutConfirmMessage': 'શું તમે ખાતામાંથી બહાર નીકળવા માંગો છો?',
      'cancel': 'રદ કરો',
      'editProfile': 'પ્રોફાઇલ એડિટ કરો',
      'displayName': 'નામ',
      'photoUrl': 'ફોટો URL',
      'close': 'બંધ કરો',
      'googleVerified': 'Google દ્વારા પ્રમાણિત',
      'allSacredTexts': 'પવિત્ર ગ્રંથો',
      'seeAll': 'બધા જુઓ',
      'searchHint': 'જ્ઞાન, વિષયો અને શાસ્ત્રો શોધો...',
      'exploreWisdom': 'જ્ઞાનનું અન્વેષણ કરો',
      'discoverTimelessTeachings': 'શાશ્વત ઉપદેશો શોધો',
      'scriptureNotFound': 'શાસ્ત્ર મળ્યું નથી',
      'noVersesAvailable': 'આ અધ્યાય માટે કોઈ શ્લોક ઉપલબ્ધ નથી.',
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
      'continueAsGuest': 'મહેમાન તરીકે આગળ વધો',
      'welcomeMessage': 'તમારી યાત્રા માટે જ્ઞાન',
      'beginYourJourney': 'તમારી અંતરંગ યાત્રા શરૂ કરો',
      'accountDetails': 'ખાતાની વિગતો',
      'appVersion': 'આવૃત્તિ 1.0.0',
      'day': 'દિવસ',
      'days': 'દિવસો',
      'mon': 'સોમ',
      'tue': 'મંગળ',
      'wed': 'બુધ',
      'thu': 'ગુરુ',
      'fri': 'શુક્ર',
      'sat': 'શનિ',
      'sun': 'રવિ',
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
      'translation': 'अनुवाद',
      'transliteration': 'लिप्यांतरण',
      'explanation': 'व्याख्या',
      'wisdom': 'विजडम',
      'context': 'संदर्भ',
      'whyThisMattersNow': 'यह अब क्यों मायने रखता है',
      'reflectionPreview': 'चिंतन पूर्वावलोकन',
      'tapForFullReflection': 'पूर्ण चिंतन के लिए टैप करें',
      'reflection': 'चिंतन',
      'oneThingToNoticeToday': 'आज ध्यान देने योग्य बात',
      'tryThis': 'इसे आजमाएं',
      'carryThisWithYou': 'इसे अपने साथ रखें',
      'listenToAudio': 'ऑडियो सुनें',
      'swipeUpForMore': 'अधिक के लिए ऊपर स्वाइप करें',
      'save': 'सहेजें',
      'savedAction': 'सहेजा गया',
      'setWallpaper': 'वॉलपेपर सेट करें',
      'share': 'शेयर करें',
      'audioNotAvailable': 'इस भाषा के लिए ऑडियो उपलब्ध नहीं है।',
      'wallpaperSet': 'वॉलपेपर सेटिंग सुविधा सक्रिय!',
      'noSavedWisdomYet': 'अभी तक कोई सहेजी गई सामग्री नहीं है',
      'saveVersesPrompt': 'आपको प्रेरित करने वाले श्लोक और चिंतन सहेजें।',
      'yourJourney': 'आपकी यात्रा',
      'smallStepsText': 'छोटे कदम, गहरा रूपांतरण।',
      'tracker': 'ट्रैकर',
      'currentDailyStreak': 'वर्तमान दैनिक स्ट्रिक',
      'keepSpiritualJourneyGoing': 'अपनी आध्यात्मिक यात्रा जारी रखें।',
      'trackDailyProgress': 'अपनी दैनिक प्रगति ट्रैक करें',
      'thisWeek': 'इस सप्ताह',
      'viewAll': 'सभी देखें',
      'daysProgress': '{count} / 7 दिन',
      'keepGoingHabit': 'जारी रखें, आप एक सुंदर आदत बना रहे हैं।',
      'milestones': 'उपलब्धियां',
      'milestoneBeginning': 'आरंभ',
      'milestoneSteady': 'स्थिर',
      'milestonePracticed': 'अभ्यस्त',
      'milestoneDevoted': 'समर्पित',
      'myProfile': 'मेरी प्रोफाइल',
      'yourAccountYourJourney': 'आपका खाता, आपकी यात्रा।',
      'milestonesAndAchievements': 'उपलब्धियां एवं सफलताएं',
      'milestonesSubtitle': 'अपनी प्रगति ट्रैक करें।',
      'settings': 'सेटिंग्स',
      'settingsSubtitle': 'अपनी प्राथमिकताएं प्रबंधित करें।',
      'helpAndSupport': 'सहायता और सहायता',
      'helpSubtitle': 'हम आपकी सहायता के लिए यहां हैं।',
      'syncedAcrossDevices': 'सभी उपकरणों पर सिंक किया गया',
      'syncedSubtitle': 'आपका खाता जुड़ा हुआ है और आपकी यात्रा सिंक हो सकती है।',
      'accountConnected': 'खाता जुड़ा हुआ है',
      'signOut': 'साइन आउट करें',
      'signOutSubtitle': 'अपने खाते से लॉग आउट करें।',
      'signOutConfirmTitle': 'साइन आउट',
      'signOutConfirmMessage': 'क्या आप अपने खाते से साइन आउट करना चाहते हैं?',
      'cancel': 'रद्द करें',
      'editProfile': 'प्रोफाइल संपादित करें',
      'displayName': 'प्रदर्शन नाम',
      'photoUrl': 'फोटो URL',
      'close': 'बंद करें',
      'googleVerified': 'Google द्वारा सत्यापित',
      'allSacredTexts': 'पवित्र ग्रंथ',
      'seeAll': 'सभी देखें',
      'searchHint': 'ज्ञान, विषय और शास्त्र खोजें...',
      'exploreWisdom': 'ज्ञान का अन्वेषण करें',
      'discoverTimelessTeachings': 'शाश्वत शिक्षाओं की खोज करें',
      'scriptureNotFound': 'शास्त्र नहीं मिला',
      'noVersesAvailable': 'इस अध्याय के लिए कोई श्लोक उपलब्ध नहीं है।',
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
      'continueAsGuest': 'अतिथि के रूप में जारी रखें',
      'welcomeMessage': 'आपकी यात्रा के लिए ज्ञान',
      'beginYourJourney': 'अपनी यात्रा शुरू करें',
      'accountDetails': 'खाता विवरण',
      'appVersion': 'संस्करण 1.0.0',
      'day': 'दिन',
      'days': 'दिन',
      'mon': 'सोम',
      'tue': 'मंगल',
      'wed': 'बुध',
      'thu': 'गुरु',
      'fri': 'शुक्र',
      'sat': 'शनि',
      'sun': 'रवि',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    final currentLangMap = _localizedValues[langCode];
    if (currentLangMap != null &&
        currentLangMap.containsKey(key) &&
        currentLangMap[key]!.isNotEmpty) {
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

  String daysProgress(int count) {
    final pattern = translate('daysProgress');
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
  String get translation => translate('translation');
  String get transliteration => translate('transliteration');
  String get explanation => translate('explanation');
  String get wisdom => translate('wisdom');
  String get context => translate('context');
  String get whyThisMattersNow => translate('whyThisMattersNow');
  String get reflectionPreview => translate('reflectionPreview');
  String get tapForFullReflection => translate('tapForFullReflection');
  String get reflection => translate('reflection');
  String get oneThingToNoticeToday => translate('oneThingToNoticeToday');
  String get tryThis => translate('tryThis');
  String get carryThisWithYou => translate('carryThisWithYou');
  String get listenToAudio => translate('listenToAudio');
  String get swipeUpForMore => translate('swipeUpForMore');
  String get save => translate('save');
  String get savedAction => translate('saved');
  String get setWallpaper => translate('setWallpaper');
  String get share => translate('share');
  String get audioNotAvailable => translate('audioNotAvailable');
  String get wallpaperSet => translate('wallpaperSet');
  String get noSavedWisdomYet => translate('noSavedWisdomYet');
  String get saveVersesPrompt => translate('saveVersesPrompt');
  String get yourJourney => translate('yourJourney');
  String get smallStepsText => translate('smallStepsText');
  String get tracker => translate('tracker');
  String get currentDailyStreak => translate('currentDailyStreak');
  String get keepSpiritualJourneyGoing => translate('keepSpiritualJourneyGoing');
  String get trackDailyProgress => translate('trackDailyProgress');
  String get thisWeek => translate('thisWeek');
  String get viewAll => translate('viewAll');
  String get keepGoingHabit => translate('keepGoingHabit');
  String get milestones => translate('milestones');
  String get milestoneBeginning => translate('milestoneBeginning');
  String get milestoneSteady => translate('milestoneSteady');
  String get milestonePracticed => translate('milestonePracticed');
  String get milestoneDevoted => translate('milestoneDevoted');
  String get myProfile => translate('myProfile');
  String get yourAccountYourJourney => translate('yourAccountYourJourney');
  String get milestonesAndAchievements => translate('milestonesAndAchievements');
  String get milestonesSubtitle => translate('milestonesSubtitle');
  String get settings => translate('settings');
  String get settingsSubtitle => translate('settingsSubtitle');
  String get helpAndSupport => translate('helpAndSupport');
  String get helpSubtitle => translate('helpSubtitle');
  String get syncedAcrossDevices => translate('syncedAcrossDevices');
  String get syncedSubtitle => translate('syncedSubtitle');
  String get accountConnected => translate('accountConnected');
  String get signOut => translate('signOut');
  String get signOutSubtitle => translate('signOutSubtitle');
  String get signOutConfirmTitle => translate('signOutConfirmTitle');
  String get signOutConfirmMessage => translate('signOutConfirmMessage');
  String get cancel => translate('cancel');
  String get editProfile => translate('editProfile');
  String get displayName => translate('displayName');
  String get photoUrl => translate('photoUrl');
  String get close => translate('close');
  String get googleVerified => translate('googleVerified');
  String get allSacredTexts => translate('allSacredTexts');
  String get seeAll => translate('seeAll');
  String get searchHint => translate('searchHint');
  String get exploreWisdom => translate('exploreWisdom');
  String get discoverTimelessTeachings => translate('discoverTimelessTeachings');
  String get scriptureNotFound => translate('scriptureNotFound');
  String get noVersesAvailable => translate('noVersesAvailable');
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
  String get continueAsGuest => translate('continueAsGuest');
  String get welcomeMessage => translate('welcomeMessage');
  String get beginYourJourney => translate('beginYourJourney');
  String get accountDetails => translate('accountDetails');
  String get appVersion => translate('appVersion');
  String get day => translate('day');
  String get days => translate('days');
  String get mon => translate('mon');
  String get tue => translate('tue');
  String get wed => translate('wed');
  String get thu => translate('thu');
  String get fri => translate('fri');
  String get sat => translate('sat');
  String get sun => translate('sun');
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

