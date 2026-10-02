import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../providers/navigation_provider.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../saved/presentation/saved_screen.dart';
import '../../streak/presentation/streak_screen.dart';

import '../../home/presentation/home_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static final _screens = [
    const HomePageWidget(),
    const StreakScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        final currentIndex = nav.currentIndex.clamp(0, _screens.length - 1);

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF0E4),
          body: IndexedStack(
            index: currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: currentIndex,
            onTap: nav.setIndex,
          ),
        );
      },
    );
  }
}
