import 'package:file_picker/file_picker.dart';
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
import '../../../providers/verses_provider.dart';
import '../../../providers/admin_navigation_provider.dart';
import '../../import/widgets/import_preview_dialog.dart';
import '../widgets/verse_editor_dialog.dart';

class VersesScreen extends StatelessWidget {
  const VersesScreen({super.key});

  Future<void> _handleBulkImport(BuildContext context, String currentBookId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty && context.mounted) {
      final file = result.files.first;
      final importResult = await showDialog(
        context: context,
        builder: (_) => ImportPreviewDialog(file: file),
      );

      if (importResult != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bulk import completed successfully! ${importResult.successCount} verses added/updated.',
            ),
            backgroundColor: AdminColors.success,
          ),
        );
        // Refresh provider
        final versesProvider = context.read<VersesProvider>();
        final navProvider = context.read<AdminNavigationProvider>();
        final bookId = navProvider.selectedBookId ?? currentBookId;
        final chapNum = navProvider.selectedChapterNumber ?? 1;
        versesProvider.bindChapter(bookId: bookId, chapterNumber: chapNum);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = context.watch<BooksProvider>();
    final chaptersProvider = context.watch<ChaptersProvider>();
    final versesProvider = context.watch<VersesProvider>();
    final navProvider = context.watch<AdminNavigationProvider>();

    final books = booksProvider.rawBooks;
    final selectedBookId = navProvider.selectedBookId ?? (books.isNotEmpty ? books.first.id : '');
    final selectedChapterNum = navProvider.selectedChapterNumber ?? 1;

    if (books.isEmpty) {
      return EmptyStateWidget(
        title: 'No Sacred Books Found',
        message: 'No sacred books available in Firestore. Please sync or create a book first.',
        actionLabel: 'Sync Mobile Content',
        onAction: () => booksProvider.syncMobileContent(force: true),
      );
    }

    final selectedBook = books.firstWhere(
      (b) => b.id == selectedBookId,
      orElse: () => books.first,
    );

    if (selectedBookId.isNotEmpty && chaptersProvider.activeBookId != selectedBookId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chaptersProvider.bindBook(selectedBookId);
      });
    }

    if (selectedBookId.isNotEmpty &&
        (versesProvider.activeBookId != selectedBookId || versesProvider.activeChapterNumber != selectedChapterNum)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        versesProvider.bindChapter(bookId: selectedBookId, chapterNumber: selectedChapterNum);
      });
    }

    if (booksProvider.isLoading || versesProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Verses...');
    }

    final verses = versesProvider.verses;
    final chapters = chaptersProvider.chapters;

    if (chapters.isEmpty) {
      return EmptyStateWidget(
        title: 'No Chapters Found',
        message: 'No chapters available for book "${selectedBook.title}". Please create a chapter first.',
        actionLabel: 'Manage Chapters',
        onAction: () => navProvider.selectBook(selectedBookId),
      );
    }

    final selectedChapter = chapters.firstWhere(
      (c) => c.chapterNumber == selectedChapterNum,
      orElse: () => chapters.first,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation Bar
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
              BreadcrumbItem(
                label: 'Chapter #${selectedChapter.chapterNumber}: ${selectedChapter.title}',
                onTap: () => navProvider.selectChapter(selectedBookId, selectedChapterNum),
              ),
              const BreadcrumbItem(label: 'Verses'),
            ],
          ),

          const SizedBox(height: 16),

          // Selector Controls Bar
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.format_quote, color: AdminColors.primary),
                  const SizedBox(width: 12),
                  Text('Book:', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  if (books.isNotEmpty)
                    DropdownButton<String>(
                      value: books.any((b) => b.id == selectedBookId) ? selectedBookId : books.first.id,
                      underline: const SizedBox(),
                      style: GoogleFonts.cinzel(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.primaryDark,
                      ),
                      items: books.map((b) {
                        return DropdownMenuItem<String>(
                          value: b.id,
                          child: Text('${b.iconEmoji} ${b.title}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          navProvider.selectChapter(val, 1);
                        }
                      },
                    ),
                  const SizedBox(width: 24),

                  Text('Chapter:', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  if (chapters.isNotEmpty)
                    DropdownButton<int>(
                      value: chapters.any((c) => c.chapterNumber == selectedChapterNum)
                          ? selectedChapterNum
                          : chapters.first.chapterNumber,
                      underline: const SizedBox(),
                      style: GoogleFonts.cinzel(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.primaryDark,
                      ),
                      items: chapters.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.chapterNumber,
                          child: Text('Ch #${c.chapterNumber}: ${c.title}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          navProvider.selectChapter(selectedBookId, val);
                        }
                      },
                    ),
                  const Spacer(),

                  // Bulk Importer Button
                  OutlinedButton.icon(
                    onPressed: () => _handleBulkImport(context, selectedBookId),
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text('Bulk Import CSV/XLSX'),
                  ),
                  const SizedBox(width: 12),

                  ElevatedButton.icon(
                    onPressed: () {
                      if (selectedBookId.isNotEmpty) {
                        VerseEditorDialog.show(
                          context,
                          bookId: selectedBookId,
                          chapterNumber: selectedChapterNum,
                        );
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Verse'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Search Field
          TextField(
            onChanged: (val) => versesProvider.setSearchQuery(val),
            decoration: const InputDecoration(
              hintText: 'Search verses by Sanskrit text, English translation, Gujarati, or verse number...',
              prefixIcon: Icon(Icons.search, size: 20),
            ),
          ),
          const SizedBox(height: 16),

          // Verses Table / Cards
          Expanded(
            child: verses.isEmpty
                ? EmptyStateWidget(
                    title: 'No Verses Found',
                    message: versesProvider.searchQuery.isNotEmpty
                        ? 'No verses matching "${versesProvider.searchQuery}"'
                        : 'Add the first verse to Chapter #$selectedChapterNum under ${selectedBook.title}.',
                    actionLabel: 'Add Verse',
                    onAction: () => VerseEditorDialog.show(
                      context,
                      bookId: selectedBookId,
                      chapterNumber: selectedChapterNum,
                    ),
                  )
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 56,
                        dataRowMaxHeight: 80,
                        columns: [
                          DataColumn(label: Text('Verse #', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Sanskrit Shloka', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Translation Snippet', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                        ],
                        rows: verses.map((verse) {
                          return DataRow(
                            cells: [
                              DataCell(
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AdminColors.saffron,
                                  child: Text(
                                    verse.verseNumber.toString(),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 320),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    verse.sanskrit,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AdminColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 320),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    verse.english.isNotEmpty ? verse.english : verse.gujarati,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AdminColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                PublishStatusBadge(
                                  published: verse.published,
                                  onTap: () {
                                    versesProvider.togglePublishStatus(verse.verseNumber, verse.published);
                                  },
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: AdminColors.primary),
                                      onPressed: () {
                                        VerseEditorDialog.show(
                                          context,
                                          bookId: selectedBookId,
                                          chapterNumber: selectedChapterNum,
                                          verse: verse,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AdminColors.error),
                                      onPressed: () async {
                                        final confirm = await ConfirmationDialog.show(
                                          context,
                                          title: 'Delete Verse',
                                          content: 'Are you sure you want to delete Verse #${verse.verseNumber}?',
                                          confirmLabel: 'Delete Verse',
                                          isDestructive: true,
                                        );
                                        if (confirm == true) {
                                          versesProvider.deleteVerse(verse.verseNumber);
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
