import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/admin_colors.dart';
import '../../providers/admin_navigation_provider.dart';
import '../../providers/admin_auth_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AdminNavigationProvider>();
    final currentItem = navProvider.currentItem;

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AdminColors.primaryDark,
        border: Border(
          right: BorderSide(color: Color(0xFF2E4537), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header / Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2E4537), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AdminColors.saffron,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '📜',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SANATAN SCROLL',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ADMIN CONSOLE',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AdminColors.saffron,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: [
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.dashboard,
                  activeItem: currentItem,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.books,
                  activeItem: currentItem,
                  icon: Icons.menu_book_outlined,
                  label: 'Sacred Books',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.chapters,
                  activeItem: currentItem,
                  icon: Icons.collections_bookmark_outlined,
                  label: 'Chapters',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.verses,
                  activeItem: currentItem,
                  icon: Icons.format_quote_outlined,
                  label: 'Verses',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.dailyReadings,
                  activeItem: currentItem,
                  icon: Icons.today_outlined,
                  label: 'Daily Readings',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.importContent,
                  activeItem: currentItem,
                  icon: Icons.cloud_upload_outlined,
                  label: 'Content Import',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.media,
                  activeItem: currentItem,
                  icon: Icons.perm_media_outlined,
                  label: 'Media Storage',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Divider(color: Color(0xFF2E4537), height: 1),
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.users,
                  activeItem: currentItem,
                  icon: Icons.people_outline,
                  label: 'Users',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.notifications,
                  activeItem: currentItem,
                  icon: Icons.notifications_none_outlined,
                  label: 'Notifications',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.analytics,
                  activeItem: currentItem,
                  icon: Icons.analytics_outlined,
                  label: 'Analytics',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.settings,
                  activeItem: currentItem,
                  icon: Icons.settings_outlined,
                  label: 'App Settings',
                ),
                _buildNavItem(
                  context: context,
                  item: AdminNavItem.profile,
                  activeItem: currentItem,
                  icon: Icons.person_outline,
                  label: 'Admin Profile',
                ),
              ],
            ),
          ),

          // Logout Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF2E4537), width: 1),
              ),
            ),
            child: InkWell(
              onTap: () {
                context.read<AdminAuthProvider>().signOut();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.white70, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required AdminNavItem item,
    required AdminNavItem activeItem,
    required IconData icon,
    required String label,
  }) {
    final isSelected = item == activeItem;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<AdminNavigationProvider>().navigateTo(item);
          },
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AdminColors.saffron : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
