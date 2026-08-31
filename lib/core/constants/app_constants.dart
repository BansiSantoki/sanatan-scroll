import 'package:flutter/material.dart';

class AppNavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
class AppConstants {
  AppConstants._();


  static const String appName = 'Sanatan Scroll';
  static const String tagline = 'Wisdom for your journey';
  static const String splashFooter = 'Begin your journey inward';

  static const int splashDurationMs = 2500;
  static const int authLoadingMs = 1200;

  static const String userName = 'Ananya Sharma';
  static const String userGreeting = 'Good Morning, Ananya';
  static const String userSubtitle = 'On a journey inward';

  static const List<AppNavigationItem> bottomNavigationItems = [
    AppNavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    AppNavigationItem(
      icon: Icons.local_fire_department_outlined,
      activeIcon: Icons.local_fire_department_rounded,
      label: 'Streak',
    ),
    AppNavigationItem(
      icon: Icons.bookmark_outline_rounded,
      activeIcon: Icons.bookmark_rounded,
      label: 'Saved',
    ),
    AppNavigationItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      label: 'Feed',
    ),
    AppNavigationItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  static const List<String> interestOptions = [
    'Understand Hindu scriptures',
    'Learn about my roots',
    'Deal with overthinking',
    'Build a spiritual habit',
    'Find greater peace',
    'Find purpose',
    'Learn Bhagavad Gita',
    'Practice mindfulness',
  ];

  static const List<String> exploreCategories = [
    'All',
    'Bhagavad Gita',
    'Upanishads',
    'Meditation',
    'Dharma',
    'Karma',
    'Bhakti',
  ];

  static const List<String> savedFilters = [
    'All',
    'Bhagavad Gita',
    'Ramayana',
    'Upanishads',
    'Mahabharata',
  ];
}
