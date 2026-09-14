import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../services/admin_auth_service.dart';
import '../../../services/bulk_import_service.dart';
import '../../../providers/books_provider.dart';
import '../../../services/template_generator_service.dart';

class ImportPreviewDialog extends StatefulWidget {
  final PlatformFile file;

  const ImportPreviewDialog({
    super.key,
    required this.file,
  });

  @override
  State<ImportPreviewDialog> createState() => _ImportPreviewDialogState();
}

class _ImportPreviewDialogState extends State<ImportPreviewDialog> {
  final BulkImportService _importService = BulkImportService();
  
  bool _isLoading = true;
  bool _isImporting = false;
  String? _errorMessage;

  List<ParsedVerseRow> _parsedRows = [];
  String? _selectedBookId;
  String _selectedBookName = '';

  int get _newCount => _parsedRows.where((r) => r.action == 'new').length;
  int get _updateCount => _parsedRows.where((r) => r.action == 'update').length;
  int get _errorCount => _parsedRows.where((r) => r.action == 'error').length;

  @override
  void initState() {
    super.initState();
    _parseAndAnalyze();
  }

  Future<void> _parseAndAnalyze() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rows = await _importService.parseFile(widget.file, targetBookId: _selectedBookId);
      
      setState(() {
        _parsedRows = rows;
        _isLoading = false;
      });

      // Analyze upserts in background
      await _importService.analyzeUpserts(_parsedRows);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _executeImport() async {
    if (_parsedRows.isEmpty || _errorCount == _parsedRows.length) return;

    final authService = context.read<AdminAuthService>();
    final adminEmail = authService.currentUser?.email ?? 'Admin';

    setState(() {
      _isImporting = true;
    });

    try {
      final result = await _importService.executeImport(
        fileName: widget.file.name,
        bookId: _selectedBookId ?? (_parsedRows.isNotEmpty ? _parsedRows.first.bookId : 'bhagavad_gita'),
        bookName: _selectedBookName.isNotEmpty ? _selectedBookName : 'Sacred Scripture',
        rows: _parsedRows,
        adminEmail: adminEmail,
      );

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isImporting = false;
          _errorMessage = "Import failed: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = context.watch<BooksProvider>();
    final books = booksProvider.rawBooks;

    return Dialog(
      backgroundColor: AdminColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 1050,
        height: 720,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AdminColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.table_chart_rounded,
                        color: AdminColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bulk Import Scriptures',
                          style: GoogleFonts.cinzel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.primaryDark,
                          ),
                        ),
                        Text(
                          widget.file.name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: AdminColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Controls & Summary Bar
            Row(
              children: [
                // Book selector
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _selectedBookId,
                    decoration: InputDecoration(
                      labelText: 'Target Book (Optional Override)',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Auto-detect from File (Default)'),
                      ),
                      ...books.map((b) => DropdownMenuItem(
                            value: b.id,
                            child: Text('${b.title} (${b.id})'),
                          )),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedBookId = val;
                        final b = books.firstWhere((element) => element.id == val, orElse: () => books.first);
                        _selectedBookName = b.title;
                      });
                      _parseAndAnalyze();
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Stat Badges
                _statBadge('Total', '${_parsedRows.length}', AdminColors.primary),
                const SizedBox(width: 8),
                _statBadge('New', '$_newCount', AdminColors.success),
                const SizedBox(width: 8),
                _statBadge('Update', '$_updateCount', AdminColors.warning),
                const SizedBox(width: 8),
                _statBadge('Error', '$_errorCount', AdminColors.error),
              ],
            ),
            const SizedBox(height: 16),

            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AdminColors.errorBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AdminColors.error),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AdminColors.error, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.inter(fontSize: 13, color: AdminColors.error),
                      ),
                    ),
                  ],
                ),
              ),

            // Content Table / Loading State
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _parsedRows.isEmpty
                      ? Center(
                          child: Text(
                            'No valid data rows found in file.',
                            style: GoogleFonts.inter(color: AdminColors.textMuted),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AdminColors.border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AdminColors.bgSubtle),
                                  columns: const [
                                    DataColumn(label: Text('#')),
                                    DataColumn(label: Text('Action')),
                                    DataColumn(label: Text('Book ID')),
                                    DataColumn(label: Text('Chapter')),
                                    DataColumn(label: Text('Verse')),
                                    DataColumn(label: Text('Sanskrit Shloka')),
                                    DataColumn(label: Text('English Translation')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Errors')),
                                  ],
                                  rows: _parsedRows.map((row) {
                                    Color actionColor = AdminColors.success;
                                    if (row.action == 'update') actionColor = AdminColors.warning;
                                    if (row.action == 'error') actionColor = AdminColors.error;

                                    return DataRow(
                                      cells: [
                                        DataCell(Text('${row.rowIndex}')),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: actionColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              row.action.toUpperCase(),
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: actionColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(row.bookId)),
                                        DataCell(Text('${row.chapterNumber}')),
                                        DataCell(Text('${row.verseNumber}')),
                                        DataCell(
                                          SizedBox(
                                            width: 220,
                                            child: Text(
                                              row.sanskritText,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 220,
                                            child: Text(
                                              row.englishTranslation,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(row.status)),
                                        DataCell(
                                          row.validationErrors.isNotEmpty
                                              ? Tooltip(
                                                  message: row.validationErrors.join('\n'),
                                                  child: Text(
                                                    row.validationErrors.first,
                                                    style: GoogleFonts.inter(fontSize: 11, color: AdminColors.error),
                                                  ),
                                                )
                                              : const Text('-'),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
            ),
            const SizedBox(height: 20),

            // Footer action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => TemplateGeneratorService.downloadCsvTemplate(),
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Download CSV Template'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => TemplateGeneratorService.downloadXlsxTemplate(),
                      icon: const Icon(Icons.table_view_rounded, size: 16),
                      label: const Text('Download XLSX Template'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isImporting || _parsedRows.isEmpty || _newCount + _updateCount == 0
                          ? null
                          : _executeImport,
                      icon: _isImporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.cloud_upload_rounded, size: 18),
                      label: Text(_isImporting ? 'Importing...' : 'Confirm Import (${_newCount + _updateCount} Rows)'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBadge(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AdminColors.textSecondary),
          ),
          Text(
            count,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
