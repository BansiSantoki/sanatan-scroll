import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../providers/analytics_provider.dart';
import '../../../providers/users_provider.dart';
import '../../../providers/books_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsProvider = context.watch<AnalyticsProvider>();
    final usersProvider = context.watch<UsersProvider>();
    final booksProvider = context.watch<BooksProvider>();

    if (analyticsProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Analytics & Audit Logs...');
    }

    final logs = analyticsProvider.activityLogs;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Overview
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Active Registered Users',
                  value: usersProvider.totalUsers.toString(),
                  icon: Icons.people,
                  iconColor: AdminColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Published Sacred Books',
                  value: booksProvider.publishedBooks.toString(),
                  icon: Icons.menu_book,
                  iconColor: AdminColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Audit Log Entries',
                  value: logs.length.toString(),
                  icon: Icons.history,
                  iconColor: AdminColors.saffron,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Audit Log Table
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Administrator Activity Audit Trail (Firestore Log)',
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.primaryDark,
                          ),
                        ),
                        Chip(
                          label: Text('${logs.length} Actions Logged'),
                          backgroundColor: AdminColors.bgSubtle,
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    Expanded(
                      child: logs.isEmpty
                          ? const EmptyStateWidget(
                              title: 'No Activity Logs Yet',
                              message: 'Actions taken in the Admin Panel will be recorded here.',
                            )
                          : SingleChildScrollView(
                              child: DataTable(
                                headingRowHeight: 48,
                                columns: [
                                  DataColumn(label: Text('Timestamp', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Admin User', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Action Performed', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Target Resource', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Details', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                                ],
                                rows: logs.map((log) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          log.timestamp.toString().substring(0, 16),
                                          style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textMuted),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          log.adminEmail,
                                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      DataCell(
                                        Chip(
                                          label: Text(log.action),
                                          backgroundColor: AdminColors.bgSubtle,
                                          side: BorderSide.none,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          log.target,
                                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AdminColors.primaryDark),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          log.details ?? '-',
                                          style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textSecondary),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
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
}
