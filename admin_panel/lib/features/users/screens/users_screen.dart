import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../providers/users_provider.dart';
import '../widgets/user_detail_dialog.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<UsersProvider>();

    if (usersProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Seekers & Users from Firestore...');
    }

    final users = usersProvider.users;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Control Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => usersProvider.setSearchQuery(val),
                  decoration: const InputDecoration(
                    hintText: 'Search seekers by email address, display name or UID...',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Chip(
                label: Text('Total Registered: ${usersProvider.totalUsers}'),
                backgroundColor: AdminColors.primaryDark,
                labelStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Table / List
          Expanded(
            child: users.isEmpty
                ? EmptyStateWidget(
                    title: 'No Users Found',
                    message: usersProvider.searchQuery.isNotEmpty
                        ? 'No seekers matching "${usersProvider.searchQuery}"'
                        : 'Seeker user profiles will appear here when users register on the mobile app.',
                  )
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 56,
                        dataRowMaxHeight: 72,
                        columns: [
                          DataColumn(label: Text('User Profile', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Auth Provider', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Role', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Registered Date', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                        ],
                        rows: users.map((u) {
                          final isAdmin = u.role == 'admin';
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AdminColors.primary,
                                      child: Text(
                                        u.email.isNotEmpty ? u.email[0].toUpperCase() : 'U',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          u.displayName ?? u.email.split('@').first,
                                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          u.email,
                                          style: GoogleFonts.inter(fontSize: 11, color: AdminColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(u.signInProvider.toUpperCase()),
                                  backgroundColor: AdminColors.bgSubtle,
                                  side: BorderSide.none,
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(
                                    u.role.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isAdmin ? Colors.white : AdminColors.textPrimary,
                                    ),
                                  ),
                                  backgroundColor: isAdmin ? AdminColors.primaryDark : AdminColors.border,
                                ),
                              ),
                              DataCell(
                                Text(
                                  u.createdAt != null
                                      ? u.createdAt.toString().substring(0, 10)
                                      : 'Recently',
                                  style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary),
                                ),
                              ),
                              DataCell(
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AdminColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  onPressed: () async {
                                    await usersProvider.fetchUserDetail(u.uid);
                                    if (context.mounted && usersProvider.selectedUserDetail != null) {
                                      UserDetailDialog.show(context, usersProvider.selectedUserDetail!);
                                    }
                                  },
                                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                                  label: const Text('View Profile'),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
