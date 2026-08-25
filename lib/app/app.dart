import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/daily_progress_provider.dart';
import '../providers/guest_access_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/onboarding_provider.dart';
import '../providers/saved_provider.dart';
import '../providers/reading_progress_provider.dart';
import '../providers/chapter_rating_provider.dart';
import '../providers/chapter_completion_provider.dart';
import '../providers/streak_provider.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_gradients.dart';
import 'theme/app_theme.dart';

class SanatanScrollApp extends StatelessWidget {
  const SanatanScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => DailyProgressProvider()),
        ChangeNotifierProvider(create: (_) => GuestAccessProvider()),
      ],
      child: MaterialApp(
        title: 'Sanatan Scroll',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppPages.generateRoute,
        builder: (context, child) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppGradients.screenBackground,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
