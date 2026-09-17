import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/admin_colors.dart';
import '../../providers/admin_navigation_provider.dart';
import '../../providers/admin_auth_provider.dart';

class TopBar extends StatelessWidget {
  final VoidCallback? onOpenDrawer;

  const TopBar({super.key, this.onOpenDrawer});

  String _getPageTitle(AdminNavItem item) {
    switch (item) {
      case AdminNavItem.dashboard:
        return 'Dashboard Overview';
      case AdminNavItem.books:
        return 'Sacred Books CMS';
      case AdminNavItem.chapters:
        return 'Chapter Management';
      case AdminNavItem.verses:
        return 'Verse Content Editor';
      case AdminNavItem.dailyReadings:
        return 'Daily Readings Manager';
      case AdminNavItem.importContent:
        return 'Ramayana & Content Importer';
      case AdminNavItem.media:
        return 'Firebase Storage Media';
      case AdminNavItem.users:
        return 'App Users & Activity';
      case AdminNavItem.notifications:
        return 'Push Notifications Queue';
      case AdminNavItem.analytics:
        return 'Analytics & Activity Audit';
      case AdminNavItem.settings:
        return 'Global App Settings';
      case AdminNavItem.profile:
        return 'Administrator Profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<AdminNavigationProvider>();
    final authProvider = context.watch<AdminAuthProvider>();
    final user = authProvider.user;
    final isMobile = MediaQuery.of(context).size.width < 1024;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AdminColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (isMobile && onOpenDrawer != null)
            IconButton(
              icon: const Icon(Icons.menu, color: AdminColors.primaryDark),
              onPressed: onOpenDrawer,
            ),

          Text(
            _getPageTitle(navProvider.currentItem),
            style: GoogleFonts.cinzel(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AdminColors.primaryDark,
            ),
          ),

          const Spacer(),

          // Production Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AdminColors.successBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.success.withAlpha(100)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AdminColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Production Live',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Admin User Chip
          InkWell(
            onTap: () {
              navProvider.navigateTo(AdminNavItem.profile);
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AdminColors.primary,
                    child: Text(
                      user?.email?.isNotEmpty == true
                          ? user!.email![0].toUpperCase()
                          : 'A',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isMobile)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user?.email ?? 'Administrator',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Super Admin',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AdminColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
