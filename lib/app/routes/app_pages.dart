import 'package:flutter/material.dart';
import '../../features/authentication/presentation/auth_screen.dart';
import '../../features/explore/presentation/sacred_chapter_list_screen.dart';
import '../../features/explore/presentation/sacred_text_detail_screen.dart';
import '../../features/explore/presentation/sacred_text_reader_screen.dart';
import '../../features/explore/presentation/sacred_texts_screen.dart';
import '../../features/feed/presentation/daily_reading_screen.dart';
import '../../features/main_navigation/presentation/main_navigation_screen.dart';
import '../../features/onboarding/presentation/begin_journey_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fadeRoute(const SplashScreen(), settings);

      case AppRoutes.auth:
        return _slideRoute(const AuthScreen(), settings);

      case AppRoutes.onboarding:
        return _slideRoute(const OnboardingScreen(), settings);

      case AppRoutes.beginJourney:
        return _slideRoute(const BeginJourneyScreen(), settings);

      case AppRoutes.main:
        return _fadeRoute(const MainNavigationScreen(), settings);

      case AppRoutes.dailyReading:
        return _slideRoute(const DailyReadingScreen(), settings);

      // Sacred Text Detail Screen
      case AppRoutes.sacredTextDetail:
        final textId = settings.arguments as String? ?? 'bhagavad_gita';

        return _slideRoute(
          SacredTextDetailScreen(textId: textId),
          settings,
        );

      case AppRoutes.sacredChapterList:
        final textId = settings.arguments as String? ?? 'bhagavad_gita';

        return _slideRoute(
          SacredChapterListScreen(textId: textId),
          settings,
        );

      // Sacred Text Reader Screen
      case AppRoutes.sacredTextReading:
        final dynamic args = settings.arguments;
        String textId = 'bhagavad_gita';
        int initialChapterNumber = 1;

        if (args is String) {
          textId = args;
        } else if (args is Map) {
          final mapTextId = args['textId'];
          final mapChapter = args['chapterNumber'];

          if (mapTextId is String && mapTextId.isNotEmpty) {
            textId = mapTextId;
          }

          if (mapChapter is int && mapChapter > 0) {
            initialChapterNumber = mapChapter;
          }
        }

        return _slideRoute(
          SacredTextReaderScreen(
            textId: textId,
            initialChapterNumber: initialChapterNumber,
          ),
          settings,
        );

      case AppRoutes.settings:
        return _slideRoute(const SettingsScreen(), settings);

      case AppRoutes.allSacredTexts:
        return _slideRoute(const SacredTextsScreen(), settings);

      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder _slideRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).chain(
          CurveTween(
            curve: Curves.easeOutCubic,
          ),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
