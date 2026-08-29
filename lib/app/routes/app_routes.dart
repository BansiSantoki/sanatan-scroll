
class AppRoutes {
  AppRoutes._();

  // ------------------------------------------------------------
  // App entry / authentication
  // ------------------------------------------------------------

  static const String splash = '/';

  static const String auth = '/auth';

  static const String onboarding = '/onboarding';

  static const String beginJourney = '/begin-journey';

  // ------------------------------------------------------------
  // Main application
  // ------------------------------------------------------------

  static const String main = '/main';

  static const String dailyReading = '/daily-reading';

  // ------------------------------------------------------------
  // Sacred Text
  // ------------------------------------------------------------

  /// Sacred text detail page.
  ///
  /// Example:
  /// Navigator.pushNamed(
  ///   context,
  ///   AppRoutes.sacredTextDetail,
  ///   arguments: 'bhagavad_gita',
  /// );
  static const String sacredTextDetail = '/sacred-text-detail';

  /// Chapter list page.
  ///
  /// Example:
  /// Navigator.pushNamed(
  ///   context,
  ///   AppRoutes.sacredChapterList,
  ///   arguments: 'bhagavad_gita',
  /// );
  static const String sacredChapterList = '/sacred-chapter-list';

  /// All sacred texts page.
  static const String allSacredTexts = '/all-sacred-texts';

  /// Dynamic reading page.
  ///
  /// Example:
  /// Navigator.pushNamed(
  ///   context,
  ///   AppRoutes.sacredTextReading,
  ///   arguments: {
  ///     'textId': 'bhagavad_gita',
  ///     'chapterNumber': 1,
  ///   },
  /// );
  static const String sacredTextReading = '/sacred-text-reading';

  // ------------------------------------------------------------
  // Profile / Settings
  // ------------------------------------------------------------

  static const String settings = '/settings';
}

