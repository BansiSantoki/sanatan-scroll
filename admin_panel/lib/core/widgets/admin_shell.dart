import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/admin_colors.dart';
import 'sidebar.dart';
import 'topbar.dart';
import '../../providers/admin_navigation_provider.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/books/screens/books_screen.dart';
import '../../features/chapters/screens/chapters_screen.dart';
import '../../features/verses/screens/verses_screen.dart';
import '../../features/daily_readings/screens/daily_readings_screen.dart';
import '../../features/media/screens/media_screen.dart';
import '../../features/users/screens/users_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/analytics/screens/analytics_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildBody(AdminNavItem item) {
    switch (item) {
      case AdminNavItem.dashboard:
        return const DashboardScreen();
      case AdminNavItem.books:
        return const BooksScreen();
      case AdminNavItem.chapters:
        return const ChaptersScreen();
      case AdminNavItem.verses:
        return const VersesScreen();
      case AdminNavItem.dailyReadings:
        return const DailyReadingsScreen();
      case AdminNavItem.media:
        return const MediaScreen();
      case AdminNavItem.users:
        return const UsersScreen();
      case AdminNavItem.notifications:
        return const NotificationsScreen();
      case AdminNavItem.analytics:
        return const AnalyticsScreen();
      case AdminNavItem.settings:
        return const SettingsScreen();
      case AdminNavItem.profile:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AdminNavigationProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AdminColors.bgCream,
      drawer: isDesktop ? null : const Drawer(child: Sidebar()),
      body: Row(
        children: [
          if (isDesktop) const Sidebar(),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  onOpenDrawer: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Expanded(
                  child: Container(
                    color: AdminColors.bgCream,
                    child: _buildBody(navProvider.currentItem),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
