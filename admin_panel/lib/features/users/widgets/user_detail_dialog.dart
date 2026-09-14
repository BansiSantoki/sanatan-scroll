import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../models/user_admin_model.dart';
import '../../../providers/users_provider.dart';

class UserDetailDialog extends StatelessWidget {
  final UserAdminModel user;

  const UserDetailDialog({super.key, required this.user});

  static Future<void> show(BuildContext context, UserAdminModel user) {
    return showDialog(
      context: context,
      builder: (ctx) => UserDetailDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<UsersProvider>();
    final isRoleAdmin = user.role == 'admin';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AdminColors.primaryDark,
                  child: Text(
                    user.email.isNotEmpty ? user.email[0].toUpperCase() : 'U',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Seeker Account',
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'UID: ${user.uid}',
                        style: GoogleFonts.inter(fontSize: 11, color: AdminColors.textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 28),

            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Current Streak',
                    value: '${user.currentStreak} Days',
                    icon: Icons.local_fire_department,
                    color: AdminColors.saffron,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Saved Verses',
                    value: '${user.savedItemsCount} Items',
                    icon: Icons.bookmark_outline,
                    color: AdminColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Completed Chapters',
                    value: '${user.completedChaptersCount} Ch',
                    icon: Icons.check_circle_outline,
                    color: AdminColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Details List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AdminColors.bgSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Sign-In Method', user.signInProvider.toUpperCase()),
                  const Divider(),
                  _buildDetailRow(
                    'Created At',
                    user.createdAt != null
                        ? user.createdAt.toString().substring(0, 16)
                        : 'Unknown',
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Last Active Login',
                    user.lastLoginAt != null
                        ? user.lastLoginAt.toString().substring(0, 16)
                        : 'Never',
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('System Authorization Role', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              user.role.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isRoleAdmin ? Colors.white : AdminColors.textPrimary,
                              ),
                            ),
                            backgroundColor: isRoleAdmin ? AdminColors.primaryDark : AdminColors.border,
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            onSelected: (newRole) {
                              usersProvider.updateUserRole(user.uid, newRole);
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(value: 'user', child: Text('Set Role: User')),
                              const PopupMenuItem(value: 'admin', child: Text('Set Role: Admin')),
                            ],
                            child: const Icon(Icons.arrow_drop_down_circle_outlined, color: AdminColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AdminColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AdminColors.textPrimary)),
      ],
    );
  }
}
