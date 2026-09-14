import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/publish_status_badge.dart';
import '../../../models/import_history_admin_model.dart';
import '../../../models/daily_reading_admin_model.dart';
import '../../../services/bulk_import_service.dart';
import '../../../providers/books_provider.dart';
import '../../../providers/daily_readings_provider.dart';
import '../../../providers/users_provider.dart';
import '../../../providers/analytics_provider.dart';
import '../../../providers/admin_navigation_provider.dart';
import '../../books/widgets/book_editor_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = context.watch<BooksProvider>();
    final usersProvider = context.watch<UsersProvider>();
    final readingsProvider = context.watch<DailyReadingsProvider>();
    final analyticsProvider = context.watch<AnalyticsProvider>();
    final navProvider = context.read<AdminNavigationProvider>();

    final books = booksProvider.books;
    final rawBooks = booksProvider.rawBooks;
    final totalBooks = booksProvider.totalBooks;
    final publishedBooks = booksProvider.publishedBooks;
    final draftBooks = booksProvider.draftBooks;
    final archivedBooks = booksProvider.archivedBooks;
    final totalUsers = usersProvider.totalUsers;

    // Aggregate total chapters across non-archived books
    int totalChapters = 0;
    for (final b in rawBooks) {
      if (!b.archived) {
        totalChapters += b.totalChapters;
      }
    }

    // Safe Daily Reading lookup for today
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    DailyReadingAdminModel? todayReading;
    for (final r in readingsProvider.readings) {
      if (r.dateString == todayStr) {
        todayReading = r;
        break;
      }
    }

    final importService = BulkImportService();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Greeting & Production Live Badge
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
              boxShadow: [
                BoxShadow(
                  color: AdminColors.primaryDark.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Sanatan Scroll CMS',
                            style: GoogleFonts.cinzel(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade700.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.greenAccent.shade400, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Production Live (sanatan-scroll-19b25)',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Live real-time Firestore content management connected directly to active seeker mobile apps.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => BookEditorDialog.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.saffron,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Sacred Book'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100
                  ? 4
                  : constraints.maxWidth > 700
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 2.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    title: 'Sacred Books',
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
                    subtitle: 'Across $totalBooks sacred texts',
                    onTap: () => navProvider.navigateTo(AdminNavItem.chapters),
                  ),
                  StatCard(
                    title: 'Registered Seekers',
                    value: totalUsers > 0 ? totalUsers.toString() : 'Active',
                    icon: Icons.people_outline,
                    iconColor: AdminColors.info,
                    subtitle: 'Mobile App Users',
                    onTap: () => navProvider.navigateTo(AdminNavItem.users),
                  ),
                  StatCard(
                    title: 'Daily Readings',
                    value: readingsProvider.readings.length.toString(),
                    icon: Icons.today_outlined,
                    iconColor: AdminColors.success,
                    subtitle: todayReading != null ? 'Today: ${todayReading.title}' : 'Not set for today',
                    onTap: () => navProvider.navigateTo(AdminNavItem.dailyReadings),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Secondary Stat Chips Bar
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat('Published Texts', publishedBooks.toString(), AdminColors.success),
                  const SizedBox(width: 16),
                  _buildMiniStat('Draft Texts', draftBooks.toString(), AdminColors.warning),
                  const SizedBox(width: 16),
                  _buildMiniStat('Archived Texts', archivedBooks.toString(), AdminColors.textMuted),
                  const SizedBox(width: 16),
                  _buildMiniStat('Scheduled Readings', readingsProvider.readings.length.toString(), AdminColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions Bar
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => BookEditorDialog.show(context),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Sacred Book'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => navProvider.navigateTo(AdminNavItem.chapters),
                        icon: const Icon(Icons.collections_bookmark_rounded, size: 18),
                        label: const Text('Manage Chapters'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => navProvider.navigateTo(AdminNavItem.verses),
                        icon: const Icon(Icons.format_quote_rounded, size: 18),
                        label: const Text('Manage Verses'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => navProvider.navigateTo(AdminNavItem.dailyReadings),
                        icon: const Icon(Icons.calendar_today_rounded, size: 18),
                        label: const Text('Create Daily Reading'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => booksProvider.syncMobileContent(force: true),
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: const Text('Re-sync Mobile Content'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Two-column layout for Sacred Books Overview & Today's Reading / Activity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sacred Books Overview Table
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
                              child: Column(
                                children: [
                                  Text(
                                    'No sacred books found in Firestore.',
                                    style: GoogleFonts.inter(color: AdminColors.textMuted),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: () => booksProvider.syncMobileContent(force: true),
                                    icon: const Icon(Icons.sync, size: 16),
                                    label: const Text('Sync Mobile Content'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: books.length > 6 ? 6 : books.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
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
                                  '${book.totalChapters} Chapters • ID: ${book.id}',
                                  style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textMuted),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PublishStatusBadge(published: book.published),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios, size: 14, color: AdminColors.primary),
                                      onPressed: () => navProvider.selectBook(book.id),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Right Column: Today's Daily Reading & Recent Activity
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Today's Reading Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today's Reading",
                                  style: GoogleFonts.cinzel(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AdminColors.primaryDark,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AdminColors.bgSubtle,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    todayStr,
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.primary),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            if (todayReading != null) ...[
                              Text(
                                todayReading.title,
                                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: AdminColors.textPrimary),
                              ),
                              if (todayReading.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  todayReading.description,
                                  style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textSecondary),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AdminColors.bgSubtle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Ref: ${todayReading.bookId} • Ch ${todayReading.chapterNumber} • Verse ${todayReading.verseNumber}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AdminColors.primaryDark),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => navProvider.navigateTo(AdminNavItem.dailyReadings),
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit Daily Reading'),
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'No reading scheduled for today.',
                                  style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textMuted),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => navProvider.navigateTo(AdminNavItem.dailyReadings),
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Create Daily Reading'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recent Admin Activity Log
                    Card(
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
                            const Divider(height: 20),

                            if (analyticsProvider.activityLogs.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'No recent admin actions recorded.',
                                    style: GoogleFonts.inter(color: AdminColors.textMuted, fontSize: 13),
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
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${log.action}: ${log.target}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: AdminColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              log.timestamp.toString().length >= 16
                                                  ? log.timestamp.toString().substring(0, 16)
                                                  : log.timestamp.toString(),
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
                  ],
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
                              'No bulk import sessions executed yet.',
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

                            final timeStr = log.timestamp.toString().length >= 16
                                ? log.timestamp.toString().substring(0, 16)
                                : log.timestamp.toString();

                            return DataRow(
                              cells: [
                                DataCell(Text(timeStr)),
                                DataCell(Text(log.fileName, style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
                                DataCell(Text(log.bookName.isNotEmpty ? log.bookName : log.bookId)),
                                DataCell(Text('${log.totalRows}')),
                                DataCell(Text('${log.successCount}', style: GoogleFonts.inter(color: AdminColors.success, fontWeight: FontWeight.bold))),
                                DataCell(Text('${log.errorCount}', style: GoogleFonts.inter(color: log.errorCount > 0 ? AdminColors.error : AdminColors.textMuted))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: badgeColor.withValues(alpha: 0.15),
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

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AdminColors.textMuted,
          ),
        ),
      ],
    );
  }
}
