import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sanatan Scroll'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @namaste.
  ///
  /// In en, this message translates to:
  /// **'Namaste'**
  String get namaste;

  /// No description provided for @daysStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String daysStreak(int count);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી'**
  String get gujarati;

  /// No description provided for @dailyWisdom.
  ///
  /// In en, this message translates to:
  /// **'DAILY WISDOM'**
  String get dailyWisdom;

  /// No description provided for @continueYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Continue Your Journey'**
  String get continueYourJourney;

  /// No description provided for @pickUpWhereYouLeftOff.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off'**
  String get pickUpWhereYouLeftOff;

  /// No description provided for @startReading.
  ///
  /// In en, this message translates to:
  /// **'Start Reading'**
  String get startReading;

  /// No description provided for @resumeReading.
  ///
  /// In en, this message translates to:
  /// **'Resume Reading'**
  String get resumeReading;

  /// No description provided for @exploreScriptures.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE SCRIPTURES'**
  String get exploreScriptures;

  /// No description provided for @diveIntoTimelessWisdom.
  ///
  /// In en, this message translates to:
  /// **'Dive into timeless wisdom'**
  String get diveIntoTimelessWisdom;

  /// No description provided for @gita.
  ///
  /// In en, this message translates to:
  /// **'Gita'**
  String get gita;

  /// No description provided for @gitaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Song of the Divine'**
  String get gitaSubtitle;

  /// No description provided for @bhagavadGita.
  ///
  /// In en, this message translates to:
  /// **'Bhagavad Gita'**
  String get bhagavadGita;

  /// No description provided for @ramayana.
  ///
  /// In en, this message translates to:
  /// **'Ramayana'**
  String get ramayana;

  /// No description provided for @ramayanaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Epic of Duty'**
  String get ramayanaSubtitle;

  /// No description provided for @upanishads.
  ///
  /// In en, this message translates to:
  /// **'Upanishads'**
  String get upanishads;

  /// No description provided for @upanishadsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wisdom of the Self'**
  String get upanishadsSubtitle;

  /// No description provided for @mahabharata.
  ///
  /// In en, this message translates to:
  /// **'Mahabharata'**
  String get mahabharata;

  /// No description provided for @mahabharataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Great Epic'**
  String get mahabharataSubtitle;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @verse.
  ///
  /// In en, this message translates to:
  /// **'Verse'**
  String get verse;

  /// No description provided for @verses.
  ///
  /// In en, this message translates to:
  /// **'Verses'**
  String get verses;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaning;

  /// No description provided for @sanskrit.
  ///
  /// In en, this message translates to:
  /// **'Sanskrit'**
  String get sanskrit;

  /// No description provided for @transliteration.
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get transliteration;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @readChapter.
  ///
  /// In en, this message translates to:
  /// **'Read Chapter'**
  String get readChapter;

  /// No description provided for @nextChapter.
  ///
  /// In en, this message translates to:
  /// **'Next Chapter'**
  String get nextChapter;

  /// No description provided for @previousChapter.
  ///
  /// In en, this message translates to:
  /// **'Previous Chapter'**
  String get previousChapter;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// No description provided for @wisdomCollected.
  ///
  /// In en, this message translates to:
  /// **'Wisdom Collected'**
  String get wisdomCollected;

  /// No description provided for @savedWisdom.
  ///
  /// In en, this message translates to:
  /// **'Saved Wisdom'**
  String get savedWisdom;

  /// No description provided for @noSavedItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No saved items yet'**
  String get noSavedItemsYet;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Wisdom for your journey'**
  String get welcomeMessage;

  /// No description provided for @beginYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Begin Your Journey'**
  String get beginYourJourney;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get appVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
