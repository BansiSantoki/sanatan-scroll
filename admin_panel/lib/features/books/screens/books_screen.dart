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
import '../../../providers/admin_navigation_provider.dart';
import '../widgets/book_editor_dialog.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = context.watch<BooksProvider>();
    final navProvider = context.read<AdminNavigationProvider>();

    if (booksProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Sacred Books from Firestore...');
    }

    final books = booksProvider.books;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Bar
          BreadcrumbNav(
            items: [
              BreadcrumbItem(
                label: 'Dashboard',
                onTap: () => navProvider.navigateTo(AdminNavItem.dashboard),
              ),
              const BreadcrumbItem(label: 'Sacred Books'),
            ],
          ),
          const SizedBox(height: 16),

          // Header Bar & Controls
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => booksProvider.setSearchQuery(val),
                  decoration: const InputDecoration(
                    hintText: 'Search sacred books by title, ID or subtitle...',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'All', label: Text('All')),
                  ButtonSegment(value: 'Published', label: Text('Published')),
                  ButtonSegment(value: 'Draft', label: Text('Draft')),
                ],
                selected: {booksProvider.filterStatus},
                onSelectionChanged: (set) {
                  booksProvider.setFilterStatus(set.first);
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  BookEditorDialog.show(context);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Sacred Book'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content List / Table
          Expanded(
            child: books.isEmpty
                ? EmptyStateWidget(
                    title: 'No Sacred Books Found',
                    message: booksProvider.searchQuery.isNotEmpty
                        ? 'No books matching "${booksProvider.searchQuery}"'
                        : 'Get started by creating your first sacred scripture text.',
                    actionLabel: 'Add Sacred Book',
                    onAction: () => BookEditorDialog.show(context),
                  )
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 56,
                        dataRowMaxHeight: 72,
                        columns: [
                          DataColumn(label: Text('Book ID', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Icon & Title', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Subtitle', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Chapters', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                        ],
                        rows: books.map((book) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  book.id,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: AdminColors.primary,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AdminColors.bgSubtle,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(book.iconEmoji, style: const TextStyle(fontSize: 18)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          book.title,
                                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                        ),
                                        if (book.titleGu != null || book.titleHi != null)
                                          Text(
                                            book.titleGu ?? book.titleHi ?? '',
                                            style: GoogleFonts.inter(fontSize: 11, color: AdminColors.textMuted),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  book.subtitle,
                                  style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text('${book.totalChapters} Chapters'),
                                  backgroundColor: AdminColors.bgSubtle,
                                  side: BorderSide.none,
                                ),
                              ),
                              DataCell(
                                PublishStatusBadge(
                                  published: book.published,
                                  onTap: () {
                                    booksProvider.togglePublishStatus(book.id, book.published);
                                  },
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AdminColors.primaryLight,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      onPressed: () {
                                        navProvider.selectBook(book.id);
                                      },
                                      icon: const Icon(Icons.list_alt, size: 16),
                                      label: const Text('Chapters'),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: AdminColors.primary),
                                      onPressed: () {
                                        BookEditorDialog.show(context, book: book);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AdminColors.error),
                                      onPressed: () async {
                                        final confirm = await ConfirmationDialog.show(
                                          context,
                                          title: 'Delete Sacred Book',
                                          content:
                                              'Are you sure you want to delete "${book.title}" (${book.id})? It is recommended to Unpublish/Archive scripture content instead of permanent deletion.',
                                          confirmLabel: 'Delete Permanently',
                                          isDestructive: true,
                                        );
                                        if (confirm == true) {
                                          booksProvider.deleteBook(book.id, book.title);
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
