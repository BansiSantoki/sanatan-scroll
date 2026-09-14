import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/breadcrumb_nav.dart';
import '../../../core/widgets/publish_status_badge.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../providers/books_provider.dart';
import '../../../providers/chapters_provider.dart';
import '../../../providers/admin_navigation_provider.dart';
import '../widgets/chapter_editor_dialog.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = context.watch<BooksProvider>();
    final chaptersProvider = context.watch<ChaptersProvider>();
    final navProvider = context.watch<AdminNavigationProvider>();

    final books = booksProvider.rawBooks;
    final selectedBookId = navProvider.selectedBookId ?? (books.isNotEmpty ? books.first.id : '');

    if (selectedBookId.isNotEmpty && chaptersProvider.activeBookId != selectedBookId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chaptersProvider.bindBook(selectedBookId);
      });
    }

    if (booksProvider.isLoading || chaptersProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Chapters...');
    }

    if (books.isEmpty) {
      return EmptyStateWidget(
        title: 'No Sacred Books Found',
        message: 'No sacred books available in Firestore. Please sync or create a book first.',
        actionLabel: 'Sync Mobile Content',
        onAction: () => booksProvider.syncMobileContent(force: true),
      );
    }

    final chapters = chaptersProvider.chapters;
    final selectedBook = books.firstWhere(
      (b) => b.id == selectedBookId,
      orElse: () => books.first,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation
          BreadcrumbNav(
            items: [
              BreadcrumbItem(
                label: 'Sacred Books',
                onTap: () => navProvider.navigateTo(AdminNavItem.books),
              ),
              BreadcrumbItem(
                label: selectedBook.title,
                onTap: () => navProvider.selectBook(selectedBookId),
              ),
              const BreadcrumbItem(label: 'Chapters'),
            ],
          ),

          const SizedBox(height: 16),

          // Book Switcher Bar
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: AdminColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Active Sacred Book:',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AdminColors.textPrimary),
                  ),
                  const SizedBox(width: 16),
                  if (books.isNotEmpty)
                    DropdownButton<String>(
                      value: books.any((b) => b.id == selectedBookId) ? selectedBookId : books.first.id,
                      underline: const SizedBox(),
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.primaryDark,
                      ),
                      items: books.map((b) {
                        return DropdownMenuItem<String>(
                          value: b.id,
                          child: Text('${b.iconEmoji} ${b.title} (${b.id})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          navProvider.selectBook(val);
                        }
                      },
                    ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (selectedBookId.isNotEmpty) {
                        ChapterEditorDialog.show(context, bookId: selectedBookId);
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Chapter'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Chapters Data Table / Empty State
          Expanded(
            child: chapters.isEmpty
                ? EmptyStateWidget(
                    title: 'No Chapters Found',
                    message: 'No chapters created under "${selectedBook.title}" yet.',
                    actionLabel: 'Add Chapter',
                    onAction: () => ChapterEditorDialog.show(context, bookId: selectedBookId),
                  )
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 56,
                        dataRowMaxHeight: 72,
                        columns: [
                          DataColumn(label: Text('Ch #', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Title', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Subtitle', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Total Verses', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                        ],
                        rows: chapters.map((ch) {
                          return DataRow(
                            cells: [
                              DataCell(
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AdminColors.primaryDark,
                                  child: Text(
                                    ch.chapterNumber.toString(),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(ch.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                    if (ch.titleGu != null || ch.titleHi != null)
                                      Text(
                                        ch.titleGu ?? ch.titleHi ?? '',
                                        style: GoogleFonts.inter(fontSize: 11, color: AdminColors.textMuted),
                                      ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  ch.subtitle,
                                  style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text('${ch.totalVerses} Verses'),
                                  backgroundColor: AdminColors.bgSubtle,
                                  side: BorderSide.none,
                                ),
                              ),
                              DataCell(
                                PublishStatusBadge(
                                  published: ch.published,
                                  onTap: () {
                                    chaptersProvider.togglePublishStatus(ch.chapterNumber, ch.published);
                                  },
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AdminColors.saffron,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onPressed: () {
                                        navProvider.selectChapter(selectedBookId, ch.chapterNumber);
                                      },
                                      icon: const Icon(Icons.format_quote, size: 16),
                                      label: const Text('Edit Verses'),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: AdminColors.primary),
                                      onPressed: () {
                                        ChapterEditorDialog.show(context, bookId: selectedBookId, chapter: ch);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AdminColors.error),
                                      onPressed: () async {
                                        final confirm = await ConfirmationDialog.show(
                                          context,
                                          title: 'Delete Chapter',
                                          content: 'Are you sure you want to delete Chapter #${ch.chapterNumber} "${ch.title}"?',
                                          confirmLabel: 'Delete Chapter',
                                          isDestructive: true,
                                        );
                                        if (confirm == true) {
                                          chaptersProvider.deleteChapter(ch.chapterNumber, ch.title);
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
