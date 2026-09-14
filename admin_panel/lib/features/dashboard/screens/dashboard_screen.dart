import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/publish_status_badge.dart';
import '../../../models/import_history_admin_model.dart';
import '../../../services/bulk_import_service.dart';
import '../../../providers/books_provider.dart';
import '../../../providers/daily_readings_provider.dart';
import '../../../providers/users_provider.dart';
import '../../../providers/analytics_provider.dart';
import '../../../providers/admin_navigation_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = context.watch<BooksProvider>();
    final usersProvider = context.watch<UsersProvider>();
    final readingsProvider = context.watch<DailyReadingsProvider>();
    final analyticsProvider = context.watch<AnalyticsProvider>();
    final navProvider = context.read<AdminNavigationProvider>();

    final books = booksProvider.rawBooks;
    final totalBooks = books.length;
    final publishedBooks = booksProvider.publishedBooks;
    final draftBooks = booksProvider.draftBooks;
    final totalUsers = usersProvider.totalUsers;

    // Aggregate total chapters
    int totalChapters = 0;
    for (var b in books) {
      totalChapters += b.totalChapters;
    }

    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final todayReading = readingsProvider.readings.firstWhere(
      (r) => r.dateString == todayStr,
      orElse: () => readingsProvider.readings.isNotEmpty
          ? readingsProvider.readings.first
          : throw Exception('No reading'),
    );
    String todayReadingStatus = 'Not set for today';
    try {
      if (todayReading.dateString == todayStr) {
        todayReadingStatus = todayReading.title;
      }
    } catch (_) {}

    final importService = BulkImportService();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Greeting
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AdminColors.primaryDark, AdminColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Sanatan Scroll CMS',
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Real-time Cloud Firestore & Firebase Storage synchronization connected to live seeker mobile clients.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    navProvider.navigateTo(AdminNavItem.verses);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.saffron,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                  label: const Text('Bulk Import Scripture Data'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100
                  ? 4
                  : constraints.maxWidth > 700
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 2.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    title: 'Total Users',
                    value: totalUsers.toString(),
                    icon: Icons.people_outline,
                    iconColor: AdminColors.info,
                    subtitle: 'Registered Seekers',
                    onTap: () => navProvider.navigateTo(AdminNavItem.users),
                  ),
                  StatCard(
                    title: 'Sacred Scripture Books',
                    value: totalBooks.toString(),
                    icon: Icons.menu_book_outlined,
                    iconColor: AdminColors.primary,
                    subtitle: '$publishedBooks Published | $draftBooks Drafts',
                    onTap: () => navProvider.navigateTo(AdminNavItem.books),
                  ),
                  StatCard(
                    title: 'Total Chapters',
                    value: totalChapters.toString(),
                    icon: Icons.collections_bookmark_outlined,
                    iconColor: AdminColors.saffronDark,
                    subtitle: 'Across 4 sacred scriptures',
                    onTap: () => navProvider.navigateTo(AdminNavItem.chapters),
                  ),
                  StatCard(
                    title: "Today's Daily Reading",
                    value: todayReadingStatus,
                    icon: Icons.today_outlined,
                    iconColor: AdminColors.success,
                    subtitle: 'Date: $todayStr',
                    onTap: () => navProvider.navigateTo(AdminNavItem.dailyReadings),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Two-column layout for Recent Books & Activity Stream
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recently Added Sacred Books
              Expanded(
                flex: 3,
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
                              'Sacred Books Overview',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.primaryDark,
                              ),
                            ),
                            TextButton(
                              onPressed: () => navProvider.navigateTo(AdminNavItem.books),
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        if (books.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'No sacred books found in Firestore.',
                                style: GoogleFonts.inter(color: AdminColors.textMuted),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: books.length > 5 ? 5 : books.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AdminColors.bgSubtle,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(book.iconEmoji, style: const TextStyle(fontSize: 20)),
                                  ),
                                ),
                                title: Text(
                                  book.title,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: AdminColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${book.totalChapters} Chapters | ID: ${book.id}',
                                  style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textMuted),
                                ),
                                trailing: PublishStatusBadge(published: book.published),
                                onTap: () {
                                  navProvider.selectBook(book.id);
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Recent Activity Log Stream
              Expanded(
                flex: 2,
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
                              'Recent Admin Activity',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.primaryDark,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 18),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        if (analyticsProvider.activityLogs.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'No recent admin actions recorded.',
                                style: GoogleFonts.inter(color: AdminColors.textMuted),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: analyticsProvider.activityLogs.length > 5
                                ? 5
                                : analyticsProvider.activityLogs.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final log = analyticsProvider.activityLogs[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AdminColors.bgSubtle,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit_note,
                                      size: 16,
                                      color: AdminColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${log.action}: ${log.target}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AdminColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${log.adminEmail} • ${log.timestamp.toString().substring(0, 16)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AdminColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bulk Import History Stream Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, color: AdminColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            'Bulk Import History Logs',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AdminColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: () => navProvider.navigateTo(AdminNavItem.verses),
                        icon: const Icon(Icons.upload_file_rounded, size: 16),
                        label: const Text('New Import Session'),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  StreamBuilder<List<ImportHistoryAdminModel>>(
                    stream: importService.getImportHistoryStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final logs = snapshot.data ?? [];
                      if (logs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No bulk import sessions executed yet. Upload CSV or XLSX to begin.',
                              style: GoogleFonts.inter(color: AdminColors.textMuted),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Date & Time')),
                            DataColumn(label: Text('File Name')),
                            DataColumn(label: Text('Target Book')),
                            DataColumn(label: Text('Total Rows')),
                            DataColumn(label: Text('Success')),
                            DataColumn(label: Text('Errors')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Imported By')),
                          ],
                          rows: logs.map((log) {
                            Color badgeColor = AdminColors.success;
                            if (log.status == 'partial') badgeColor = AdminColors.warning;
                            if (log.status == 'failed') badgeColor = AdminColors.error;

                            return DataRow(
                              cells: [
                                DataCell(Text(log.timestamp.toString().substring(0, 16))),
                                DataCell(Text(log.fileName, style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
                                DataCell(Text(log.bookName.isNotEmpty ? log.bookName : log.bookId)),
                                DataCell(Text('${log.totalRows}')),
                                DataCell(Text('${log.successCount}', style: GoogleFonts.inter(color: AdminColors.success, fontWeight: FontWeight.bold))),
                                DataCell(Text('${log.errorCount}', style: GoogleFonts.inter(color: log.errorCount > 0 ? AdminColors.error : AdminColors.textMuted))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      log.status.toUpperCase(),
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor),
                                    ),
                                  ),
                                ),
                                DataCell(Text(log.importedBy)),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
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
