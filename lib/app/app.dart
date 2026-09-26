import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/chapter_completion_provider.dart';
import '../providers/chapter_rating_provider.dart';
import '../providers/daily_progress_provider.dart';
import '../providers/guest_access_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/onboarding_provider.dart';
import '../providers/reading_progress_provider.dart';
import '../providers/saved_provider.dart';
import '../providers/streak_provider.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_gradients.dart';
import 'theme/app_theme.dart';

import '../providers/theme_provider.dart';

class SanatanScrollApp extends StatelessWidget {
  const SanatanScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProxyProvider<AuthProvider, SavedProvider>(
          create: (_) => SavedProvider(),
          update: (_, auth, savedProvider) {
            final provider = savedProvider ?? SavedProvider();
            provider.bindUser(auth.userId);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReadingProgressProvider>(
          create: (_) => ReadingProgressProvider(),
          update: (_, auth, progressProvider) {
            final provider = progressProvider ?? ReadingProgressProvider();
            provider.bindUser(auth.userId);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChapterRatingProvider>(
          create: (_) => ChapterRatingProvider(),
          update: (_, auth, ratings) {
            final provider = ratings ?? ChapterRatingProvider();
            provider.bindUser(auth.userId);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChapterCompletionProvider>(
          create: (_) => ChapterCompletionProvider(),
          update: (_, auth, completion) {
            final provider = completion ?? ChapterCompletionProvider();
            provider.bindUser(auth.userId);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, StreakProvider>(
          create: (_) => StreakProvider(),
          update: (_, auth, streakProvider) {
            final provider = streakProvider ?? StreakProvider();
            provider.bindUser(auth.userId);
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => DailyProgressProvider()),
        ChangeNotifierProvider(create: (_) => GuestAccessProvider()),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Sanatan Scroll',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeForLocale(localeProvider.locale, isDark: false),
            darkTheme: AppTheme.getThemeForLocale(localeProvider.locale, isDark: true),
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppPages.generateRoute,
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isDark ? AppGradients.darkScreenBackground : AppGradients.screenBackground,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
