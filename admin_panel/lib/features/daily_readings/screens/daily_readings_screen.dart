import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/publish_status_badge.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../providers/daily_readings_provider.dart';
import '../widgets/daily_reading_editor_dialog.dart';

class DailyReadingsScreen extends StatelessWidget {
  const DailyReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final readingsProvider = context.watch<DailyReadingsProvider>();

    if (readingsProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Daily Readings...');
    }

    final readings = readingsProvider.readings;

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
                  onChanged: (val) => readingsProvider.setSearchQuery(val),
                  decoration: const InputDecoration(
                    hintText: 'Search daily readings by date (YYYY-MM-DD), title or book...',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  DailyReadingEditorDialog.show(context);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Schedule Daily Reading'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Table / List
          Expanded(
            child: readings.isEmpty
                ? EmptyStateWidget(
                    title: 'No Daily Readings Found',
                    message: readingsProvider.searchQuery.isNotEmpty
                        ? 'No daily readings matching "${readingsProvider.searchQuery}"'
                        : 'Schedule daily scripture wisdom readings for mobile app seekers.',
                    actionLabel: 'Schedule Daily Reading',
                    onAction: () => DailyReadingEditorDialog.show(context),
                  )
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 56,
                        dataRowMaxHeight: 72,
                        columns: [
                          DataColumn(label: Text('Scheduled Date', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Title', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Scripture Ref', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                        ],
                        rows: readings.map((r) {
                          final isToday = r.dateString == DateTime.now().toIso8601String().substring(0, 10);
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: isToday ? AdminColors.success : AdminColors.textMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      r.dateString,
                                      style: GoogleFonts.inter(
                                        fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                                        color: isToday ? AdminColors.success : AdminColors.primaryDark,
                                      ),
                                    ),
                                    if (isToday) ...[
                                      const SizedBox(width: 6),
                                      const Chip(
                                        label: Text('TODAY', style: TextStyle(fontSize: 10, color: Colors.white)),
                                        backgroundColor: AdminColors.success,
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  r.title,
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text('${r.bookId} • Ch ${r.chapterNumber}:${r.verseNumber}'),
                                  backgroundColor: AdminColors.bgSubtle,
                                  side: BorderSide.none,
                                ),
                              ),
                              DataCell(
                                PublishStatusBadge(
                                  published: r.published,
                                  onTap: () {
                                    readingsProvider.togglePublishStatus(r.id, r.published);
                                  },
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: AdminColors.primary),
                                      onPressed: () {
                                        DailyReadingEditorDialog.show(context, reading: r);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AdminColors.error),
                                      onPressed: () async {
                                        final confirm = await ConfirmationDialog.show(
                                          context,
                                          title: 'Delete Daily Reading',
                                          content: 'Are you sure you want to delete daily reading for ${r.dateString}?',
                                          confirmLabel: 'Delete Reading',
                                          isDestructive: true,
                                        );
                                        if (confirm == true) {
                                          readingsProvider.deleteDailyReading(r.id);
                                        }
                                      },
                                    ),
                                  ],
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
