import 'package:flutter/material.dart';
import 'package:sanatan_scroll/features/authentication/presentation/auth_screen.dart';
import 'package:sanatan_scroll/features/explore/presentation/sacred_chapter_list_screen.dart';
import 'package:sanatan_scroll/features/explore/presentation/sacred_text_detail_screen.dart';
import 'package:sanatan_scroll/features/explore/presentation/sacred_text_reader_screen.dart';
import 'package:sanatan_scroll/features/explore/presentation/sacred_texts_screen.dart';
import 'package:sanatan_scroll/features/feed/presentation/daily_reading_screen.dart';
import 'package:sanatan_scroll/features/main_navigation/presentation/main_navigation_screen.dart';
import 'package:sanatan_scroll/features/onboarding/presentation/begin_journey_screen.dart';
import 'package:sanatan_scroll/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sanatan_scroll/features/splash/presentation/splash_screen.dart';
import 'package:sanatan_scroll/features/profile/presentation/settings_screen.dart';
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
        final dynamic args = settings.arguments;
        String bookId = 'bhagavad_gita';

        if (args is String) {
          bookId = args;
        } else if (args is Map) {
          final value = args['bookId'] ?? args['textId'];
          if (value is String && value.isNotEmpty) {
            bookId = value;
          }
        }

        return _slideRoute(
          SacredTextDetailScreen(bookId: bookId),
          settings,
        );

      case AppRoutes.sacredChapterList:
        final dynamic args = settings.arguments;
        String textId = 'bhagavad_gita';
        int? kandaNumber;

        if (args is String) {
          textId = args;
        } else if (args is Map) {
          final value = args['bookId'] ?? args['textId'];
          if (value is String && value.isNotEmpty) {
            textId = value;
          }
          final kVal = args['kandaNumber'] ?? args['kanda'];
          if (kVal is int) {
            kandaNumber = kVal;
          } else if (kVal is String) {
            kandaNumber = int.tryParse(kVal);
          }
        }

        return _slideRoute(
          SacredChapterListScreen(
            textId: textId,
            initialKandaNumber: kandaNumber,
          ),
          settings,
        );

      // Sacred Text Reader Screen
      case AppRoutes.sacredTextReading:
        final dynamic args = settings.arguments;
        String textId = 'bhagavad_gita';
        int initialChapterNumber = 1;
        int? initialKandaNumber;
        int? initialSargaNumber;
        int? initialVerseNumber;
        int? initialMantraNumber;
        String? initialVerseId;
        String? initialPassageId;
        int? initialPageIndex;

        if (args is String) {
          textId = args;
        } else if (args is Map) {
          final mapTextId = args['textId'] ?? args['bookId'];
          if (mapTextId is String && mapTextId.isNotEmpty) {
            textId = mapTextId;
          }

          final chapVal = args['chapterNumber'] ?? args['chapter'];
          if (chapVal is int && chapVal > 0) {
            initialChapterNumber = chapVal;
          } else if (chapVal is String) {
            initialChapterNumber = int.tryParse(chapVal) ?? 1;
          }

          final kandaVal = args['kandaNumber'] ?? args['kanda'];
          if (kandaVal is int) {
            initialKandaNumber = kandaVal;
          } else if (kandaVal is String) {
            initialKandaNumber = int.tryParse(kandaVal);
          }

          final sargaVal = args['sargaNumber'] ?? args['sarga'];
          if (sargaVal is int) {
            initialSargaNumber = sargaVal;
          } else if (sargaVal is String) {
            initialSargaNumber = int.tryParse(sargaVal);
          }

          final verseVal = args['verseNumber'] ?? args['verse'];
          if (verseVal is int) {
            initialVerseNumber = verseVal;
          } else if (verseVal is String) {
            initialVerseNumber = int.tryParse(verseVal);
          }

          final mantraVal = args['mantraNumber'] ?? args['mantra'];
          if (mantraVal is int) {
            initialMantraNumber = mantraVal;
          } else if (mantraVal is String) {
            initialMantraNumber = int.tryParse(mantraVal);
          }

          if (args['verseId'] != null) {
            initialVerseId = args['verseId'].toString();
          }
          if (args['passageId'] != null) {
            initialPassageId = args['passageId'].toString();
          }

          final pageIdxVal = args['pageIndex'];
          if (pageIdxVal is int) {
            initialPageIndex = pageIdxVal;
          } else if (pageIdxVal is String) {
            initialPageIndex = int.tryParse(pageIdxVal);
          }
        }

        return _slideRoute(
          SacredTextReaderScreen(
            textId: textId,
            initialChapterNumber: initialChapterNumber,
            initialKandaNumber: initialKandaNumber,
            initialSargaNumber: initialSargaNumber,
            initialVerseNumber: initialVerseNumber,
            initialMantraNumber: initialMantraNumber,
            initialVerseId: initialVerseId,
            initialPassageId: initialPassageId,
            initialPageIndex: initialPageIndex,
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
