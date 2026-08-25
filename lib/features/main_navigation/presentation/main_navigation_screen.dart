import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../providers/navigation_provider.dart';

import '../../feed/presentation/feed_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../saved/presentation/saved_screen.dart';
import '../../streak/presentation/streak_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const _screens = [
    FeedScreen(),
    StreakScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: IndexedStack(
            index: nav.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: const _BottomNavigationWrapper(),
        );
      },
    );
  }
}

class _BottomNavigationWrapper extends StatelessWidget {
  const _BottomNavigationWrapper();

  static const List<Color> _backgroundColors = [
    Color.fromARGB(255, 165, 118, 37),
    Color.fromARGB(255, 233, 202, 155),
    Color.fromARGB(255, 212, 169, 109),
    Color.fromARGB(255, 192, 162, 117),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: _backgroundColors,
              stops: [0.0, 0.35, 0.68, 1.0],
            ),
          ),
          child: SafeArea(
            top: false,
            child: CustomBottomNavigation(
              currentIndex: nav.currentIndex,
              onTap: nav.setIndex,
            ),
          ),
        );
      },
    );
  }
}
