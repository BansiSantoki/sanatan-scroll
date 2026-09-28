import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_auth_provider.dart';
import '../../../services/bulk_import_service.dart';
import '../../../services/csv_import_service.dart';
import '../../../services/excel_export_service.dart';
import '../../../services/ramayana_parser_service.dart';
import '../../../services/source_fetcher_service.dart';
import '../../../services/universal_web_file_picker.dart';

class RamayanaImportScreen extends StatefulWidget {
  const RamayanaImportScreen({super.key});

  @override
  State<RamayanaImportScreen> createState() => _RamayanaImportScreenState();
}

class _RamayanaImportScreenState extends State<RamayanaImportScreen> {
  final CsvImportService _csvImportService = CsvImportService();
  final SourceFetcherService _sourceFetcherService = SourceFetcherService();
  final BulkImportService _bulkImportService = BulkImportService();

  bool _isExporting = false;

  final TextEditingController _urlController = TextEditingController(text: 'https://ramayana.info/');

  int _currentStep = 1; // 1: Upload, 2: Parsing/Analyzing, 3: Preview & Validation, 4: Importing, 5: Result

  String _selectedBookId = 'ramayana';
  String _selectedBookName = 'Ramayana';
  List<Map<String, String>> _availableBooks = [
    {'id': 'ramayana', 'name': 'Ramayana', 'icon': '🏹'},
    {'id': 'bhagavad_gita', 'name': 'Bhagavad Gita', 'icon': '🪷'},
    {'id': 'upanishads', 'name': 'Upanishads', 'icon': '🕉️'},
  ];

  PlatformFile? _selectedFile;
  String? _sourceUrl;
  RamayanaParseResult? _parseResult;
  String _importMode = 'replace_all'; // 'replace_all', 'upsert', 'create_only', 'update_existing', 'skip_duplicates'
  String _tableFilter = 'all'; // 'all', 'valid', 'invalid', 'duplicates'

  bool _isAnalyzing = false;
  bool _isImporting = false;
  double _importProgress = 0.0;
  String _importProgressMessage = '';

  RamayanaImportExecutionResult? _executionResult;
  String? _errorMessage;

  bool _isVerifyingFirestore = false;
  Map<String, dynamic>? _verificationReport;

  @override
  void initState() {
    super.initState();
    _loadDynamicBooksFromFirestore();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadDynamicBooksFromFirestore() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('sacred_books').get();
      if (snap.docs.isNotEmpty) {
        final List<Map<String, String>> fetched = [];
        final Set<String> seenIds = {};

        for (final doc in snap.docs) {
          final data = doc.data();
          final id = doc.id.toLowerCase();
          final name = (data['title'] ?? data['name'] ?? id).toString();
          final icon = (data['iconEmoji'] ?? '📜').toString();
          fetched.add({'id': id, 'name': name, 'icon': icon});
          seenIds.add(id);
        }

        for (final b in [
          {'id': 'ramayana', 'name': 'Ramayana', 'icon': '🏹'},
          {'id': 'bhagavad_gita', 'name': 'Bhagavad Gita', 'icon': '🪷'},
          {'id': 'upanishads', 'name': 'Upanishads', 'icon': '🕉️'},
        ]) {
          if (!seenIds.contains(b['id'])) {
            fetched.add(b);
          }
        }

        if (mounted) {
          setState(() {
            _availableBooks = fetched;
          });
        }
      }
    } catch (_) {}
  }

  void _onBookSelected(String bookId) {
    final book = _availableBooks.firstWhere((b) => b['id'] == bookId, orElse: () => {'id': bookId, 'name': bookId, 'icon': '📜'});
    setState(() {
      _selectedBookId = bookId;
      _selectedBookName = book['name'] ?? bookId;
      _urlController.text = _resolveBookDefaultUrl(bookId);
      if (bookId == 'ramayana') {
        _importMode = 'replace_all';
      }
      _selectedFile = null;
      _sourceUrl = null;
      _parseResult = null;
      _executionResult = null;
      _errorMessage = null;
      _verificationReport = null;
      _importProgress = 0.0;
      _currentStep = 1;
    });
  }

  String _resolveBookDefaultUrl(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'https://ramayana.info/';
      case 'mahabharata': return 'https://mahabharata.info/';
      case 'bhagavad_gita': return 'https://bhagavadgita.info/';
      case 'upanishads': return 'https://upanishads.info/';
      default: return 'https://sanatanscroll.info/';
    }
  }

  // ============================================================
  // FILE PICKER & FETCHING HANDLERS
  // ============================================================

  Future<void> _pickFile() async {
    try {
      final file = await UniversalWebFilePicker.pickImportFile();

      if (file != null) {
        setState(() {
          _selectedFile = file;
          _sourceUrl = null;
          _errorMessage = null;
          _currentStep = 2;
        });
        await _processParsedFile(file);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to read Excel or CSV file. Please verify that the file is valid and UTF-8 compatible: $e';
        _currentStep = 1;
      });
    }
  }

  Future<void> _processParsedFile(PlatformFile file) async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final parseResult = await _csvImportService.parseFile(
        file,
        targetBookId: _selectedBookId,
        targetBookName: _selectedBookName,
      );
      await _bulkImportService.analyzeRamayanaRowsAgainstFirestore(
        rows: parseResult.rows,
        mode: _importMode,
        targetBookId: _selectedBookId,
      );

      setState(() {
        _parseResult = parseResult;
        _isAnalyzing = false;
        _currentStep = 3;
      });
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      setState(() {
        _isAnalyzing = false;
        _errorMessage = msg;
        _currentStep = 1;
      });
    }
  }

  Future<void> _fetchFromSourceUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid Source URL.';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _currentStep = 2;
    });

    try {
      final fetchResult = await _sourceFetcherService.fetchFromUrl(url);

      if (!fetchResult.success || fetchResult.parsedRows.isEmpty) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = fetchResult.errorMessage ?? 'No structured sacred book content detected at URL.';
          _currentStep = 1;
        });
        return;
      }

      await _bulkImportService.analyzeRamayanaRowsAgainstFirestore(
        rows: fetchResult.parsedRows,
        mode: _importMode,
        targetBookId: _selectedBookId,
      );

      final parseResult = RamayanaParseResult(
        rows: fetchResult.parsedRows,
        totalRawRowsInFile: fetchResult.parsedRows.length,
        metadataRowsSkipped: 0,
        scriptureRowsDetected: fetchResult.parsedRows.length,
        headerRowNumber: 1,
        detectedColumnMappings: {
          'Sanskrit': 'shloka',
          'Source URL': 'source_url',
        },
        detectedKandas: fetchResult.parsedRows.map((r) => r.kandaNumber).toSet().toList()..sort(),
        detectedSargasCount: fetchResult.parsedRows.map((r) => 'K${r.kandaNumber}_S${r.sargaNumber}').toSet().length,
        detectedVerseCount: fetchResult.parsedRows.length,
        validRowsCount: fetchResult.parsedRows.where((r) => r.isValid).length,
        invalidRowsCount: fetchResult.parsedRows.where((r) => !r.isValid).length,
        duplicateRowsCount: 0,
        missingSanskritCount: 0,
        missingEnglishCount: 0,
        missingHindiCount: 0,
        missingGujaratiCount: 0,
        missingChapterInfoCount: 0,
        missingVerseNumCount: 0,
        missingTranslationsCount: 0,
        qaStatusCounts: {'Approved': fetchResult.parsedRows.length},
        defaultSourceUrl: url,
        selectedSheetName: 'Source URL',
      );

      setState(() {
        _selectedFile = null;
        _sourceUrl = url;
        _parseResult = parseResult;
        _isAnalyzing = false;
        _currentStep = 3;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'Error fetching source URL: $e';
        _currentStep = 1;
      });
    }
  }

  void _onModeChanged(String newMode) async {
    if (_parseResult == null) return;
    setState(() {
      _importMode = newMode;
      _isAnalyzing = true;
    });

    await _bulkImportService.analyzeRamayanaRowsAgainstFirestore(
      rows: _parseResult!.rows,
      mode: newMode,
      targetBookId: _selectedBookId,
    );

    setState(() {
      _isAnalyzing = false;
    });
  }

  // ============================================================
  // EXECUTE IMPORT TO FIRESTORE
  // ============================================================

  Future<void> _confirmAndImport() async {
    if (_parseResult == null || _parseResult!.rows.isEmpty) return;

    if (_importMode == 'replace_all' && _parseResult!.invalidRowsCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('REPLACE mode requires 100% valid rows. There are ${_parseResult!.invalidRowsCount} invalid rows.'),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    final validCount = _parseResult!.rows.where((r) => r.isValid && r.action != 'skip').length;
    if (validCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid rows available to import in selected mode.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // SAFETY CHECK: selectedBookId must match import target
    final sampleRowBookId = _parseResult!.rows.first.bookId.toLowerCase();
    if (_selectedBookId.toLowerCase() != sampleRowBookId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected book ($_selectedBookId) and imported book ($sampleRowBookId) do not match. Please select the correct book and try again.'),
          backgroundColor: Colors.red[900],
        ),
      );
      return;
    }

    final adminEmail = context.read<AdminAuthProvider>().user?.email ?? 'admin@sanatan-scroll.com';

    final isReplaceMode = _importMode == 'replace_all';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isReplaceMode ? 'CONFIRM RAMAYANA DATASET REPLACEMENT' : 'Confirm Import to Firestore',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, color: isReplaceMode ? Colors.red[900] : AdminColors.primaryDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isReplaceMode) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'WARNING: This operation will REMOVE existing Ramayana records in Firestore and replace them with the new Master dataset.',
                        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.red[900]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ] else
              Text('Are you sure you want to write data to production Firestore?'),
            const SizedBox(height: 8),
            Text('• Target Book: $_selectedBookName ($_selectedBookId)', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('• Target Collection: sacred_books/$_selectedBookId', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('• New Verses to Write: $validCount', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('• Kandas: ${_parseResult!.detectedKandas.length}, Sargas: ${_parseResult!.detectedSargasCount}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
              child: Text(
                '• PRESERVED DATA: Bhagavad Gita, Mahabharata, Upanishads, Users, Reading Progress, Saved Items, Streaks & Ratings will NOT be modified.',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green[900]),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isReplaceMode ? Colors.red[800] : AdminColors.primaryDark,
              foregroundColor: Colors.white,
            ),
            child: Text(isReplaceMode ? 'Confirm Replace & Import' : 'Import to Firestore'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _currentStep = 4;
      _isImporting = true;
      _importProgress = 0.0;
      _importProgressMessage = 'Starting Firestore chapter-wise import for $_selectedBookName...';
    });

    final fileName = _selectedFile?.name ?? _sourceUrl ?? '${_selectedBookId}_Master_Sheet';

    try {
      final execResult = await _bulkImportService.executeRamayanaImport(
        fileName: fileName,
        rows: _parseResult!.rows,
        mode: _importMode,
        adminEmail: adminEmail,
        targetBookId: _selectedBookId,
        targetBookName: _selectedBookName,
        onProgress: (done, total, message) {
          if (mounted) {
            setState(() {
              _importProgress = total > 0 ? (done / total).clamp(0.0, 1.0) : 0.0;
              _importProgressMessage = message;
            });
          }
        },
      );

      setState(() {
        _isImporting = false;
        _executionResult = execResult;
        _currentStep = 5;
      });
    } catch (e) {
      setState(() {
        _isImporting = false;
        _errorMessage = 'Firestore Import Failed: $e';
        _currentStep = 3;
      });
    }
  }

  void _resetImport() {
    setState(() {
      _currentStep = 1;
      _selectedFile = null;
      _sourceUrl = null;
      _parseResult = null;
      _executionResult = null;
      _errorMessage = null;
      _importProgress = 0.0;
    });
  }

  // ============================================================
  // BUILD METHOD & LAYOUT
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bgCream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 20),
            _buildStepIndicator(),
            const SizedBox(height: 24),
            if (_errorMessage != null) _buildErrorMessageBox(),
            if (_currentStep == 1) _buildStep1UploadSection(),
            if (_currentStep == 2 || _isAnalyzing) _buildAnalyzingStateWidget(),
            if (_currentStep == 3 && !_isAnalyzing) _buildStep3PreviewAndValidationSection(),
            if (_currentStep == 4 || _isImporting) _buildStep4ImportingProgressWidget(),
            if (_currentStep == 5 && _executionResult != null) _buildStep5ResultReportSection(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WIDGET COMPONENTS
  // ============================================================

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AdminColors.saffron.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.cloud_upload_outlined, color: AdminColors.saffron, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SACRED BOOKS CONTENT IMPORT SYSTEM',
                  style: GoogleFonts.cinzel(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.primaryDark,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  'Universal Master Sheet CSV/XLSX Importer for Ramayana, Mahabharata, Bhagavad Gita, Upanishads & Sacred Texts',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      '1. Upload / Source',
      '2. Parse',
      '3. Preview & Validate',
      '4. Firestore Import',
      '5. Complete Report',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final stepNum = index + 1;
          final isActive = stepNum == _currentStep;
          final isDone = stepNum < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AdminColors.saffron
                        : isDone
                            ? AdminColors.primaryDark
                            : Colors.grey[300],
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '$stepNum',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.white : Colors.grey[700],
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    steps[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? AdminColors.primaryDark : Colors.grey[700],
                    ),
                  ),
                ),
                if (index < steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildErrorMessageBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage ?? 'An error occurred during parsing.',
              style: GoogleFonts.inter(color: Colors.red[900], fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
            onPressed: () => setState(() => _errorMessage = null),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport({required bool asCsv}) async {
    setState(() => _isExporting = true);
    try {
      final count = await ExcelExportService.exportBookData(
        bookId: _selectedBookId,
        bookName: _selectedBookName,
        asCsv: asCsv,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully exported $count verses from $_selectedBookName to ${asCsv ? "CSV" : "Excel"}.'),
            backgroundColor: Colors.green[800],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ============================================================
  // STEP 1: UPLOAD / SOURCE SELECTION / EXPORT
  // ============================================================

  Widget _buildStep1UploadSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        return Column(
          children: [
            _buildBookSelectorCard(),
            const SizedBox(height: 20),
            _buildExportCard(),
            const SizedBox(height: 20),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildFileUploadCard()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildUrlFetchCard()),
                ],
              )
            else
              Column(
                children: [
                  _buildFileUploadCard(),
                  const SizedBox(height: 20),
                  _buildUrlFetchCard(),
                ],
              ),
            const SizedBox(height: 24),
            _buildIdFormatInfoCard(),
          ],
        );
      },
    );
  }

  Widget _buildExportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.download_for_offline_outlined, color: AdminColors.saffron, size: 24),
              const SizedBox(width: 10),
              Text(
                'EXPORT CURRENT FIRESTORE DATA',
                style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Export all current Firestore records for $_selectedBookName (including all Admin Panel edits) into Excel (.xlsx) or CSV format for external editing or offline archiving.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _isExporting ? null : () => _performExport(asCsv: false),
                icon: _isExporting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.table_chart, size: 18),
                label: Text(_isExporting ? 'Exporting...' : 'Export Excel (.xlsx)', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _isExporting ? null : () => _performExport(asCsv: true),
                icon: const Icon(Icons.description, size: 18, color: AdminColors.primaryDark),
                label: Text('Export CSV (.csv)', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AdminColors.primaryDark)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  side: const BorderSide(color: AdminColors.primaryDark),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookSelectorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: AdminColors.saffron, size: 24),
              const SizedBox(width: 10),
              Text(
                'TARGET SACRED BOOK',
                style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Select the target Sacred Book you are importing content for. The importer dynamically adapts validation rules and ID formats.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: _availableBooks.map((book) {
              final id = book['id']!;
              final name = book['name']!;
              final icon = book['icon'] ?? '📜';
              final isSelected = id == _selectedBookId;

              return ChoiceChip(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text('$icon  $name', style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
                ),
                selected: isSelected,
                selectedColor: AdminColors.saffron.withValues(alpha: 0.2),
                backgroundColor: AdminColors.bgCream,
                side: BorderSide(color: isSelected ? AdminColors.saffron : Colors.grey[400]!, width: isSelected ? 1.5 : 1),
                onSelected: (selected) {
                  if (selected) {
                    _onBookSelected(id);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.table_chart_outlined, color: AdminColors.primaryDark, size: 24),
              const SizedBox(width: 10),
              Text(
                'WORKFLOW A: CSV / EXCEL MASTER SHEET UPLOAD',
                style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Upload CSV or Excel file for $_selectedBookName using the existing import pipeline.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: _pickFile,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: AdminColors.bgCream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AdminColors.saffron.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.upload_file, size: 48, color: AdminColors.saffron),
                  const SizedBox(height: 12),
                  Text(
                    'Click to Upload CSV or Excel File',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AdminColors.primaryDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Supports: .csv, .xlsx',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlFetchCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language_outlined, color: AdminColors.primaryDark, size: 24),
              const SizedBox(width: 10),
              Text(
                'WORKFLOW B: Source URL Fetch',
                style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Fetch $_selectedBookName structure and Sanskrit passages directly from declared source URL with preview & approval.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'Declared Source URL',
              hintText: _resolveBookDefaultUrl(_selectedBookId),
              prefixIcon: const Icon(Icons.link, color: AdminColors.saffron),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: AdminColors.bgCream,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _fetchFromSourceUrl,
              icon: const Icon(Icons.download_outlined),
              label: Text('Fetch $_selectedBookName Source Content'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdFormatInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.amber[900], size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MASTER SHEET ID FORMATS & CONFLICT RULES',
                  style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber[900]),
                ),
                const SizedBox(height: 6),
                Text(
                  '• Supported Canonical IDs: RAM-01-001-001 (Ramayana), MAH-01-001-001 (Mahabharata), GIT-01-001 (Bhagavad Gita), UPN-01-001 (Upanishads).\n'
                  '• Conflict Safety: If explicit columns (chapter, section, verse) conflict with parsed ID values, the importer flags the row as INVALID and requires explicit admin review before writing to Firestore.',
                  style: GoogleFonts.inter(fontSize: 12.5, color: Colors.amber[950], height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 2: ANALYZING STATE WIDGET
  // ============================================================

  Widget _buildAnalyzingStateWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const CircularProgressIndicator(color: AdminColors.saffron),
            const SizedBox(height: 20),
            Text(
              'Parsing Master Sheet & Analyzing Firestore Duplicates for $_selectedBookName...',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AdminColors.primaryDark),
            ),
            const SizedBox(height: 6),
            Text(
              'Checking Chapter hierarchy, ID consistency, missing fields & QA status...',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STEP 3: PREVIEW & VALIDATION DASHBOARD
  // ============================================================

  Widget _buildStep3PreviewAndValidationSection() {
    final result = _parseResult;
    if (result == null) {
      return Center(
        child: Text('No parse results available.', style: GoogleFonts.inter(color: Colors.grey[700])),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Action Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'IMPORT PREVIEW & VALIDATION DASHBOARD',
              style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _resetImport,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back / Re-upload'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: result.validRowsCount > 0 ? _confirmAndImport : null,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(result.validRowsCount > 0 ? 'Import to Firestore' : 'Import Disabled (0 Valid Rows)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: result.validRowsCount > 0 ? AdminColors.saffron : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Detected Sheet Structure Card
        _buildDetectedStructureCard(result),
        const SizedBox(height: 20),

        // 5 Summary Metrics Cards
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Raw Rows', '${result.totalRawRowsInFile}', Icons.format_list_numbered, Colors.blue)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Scripture Rows', '${result.scriptureRowsDetected}', Icons.auto_stories, Colors.teal)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Valid Rows', '${result.validRowsCount}', Icons.check_circle_outline, Colors.green)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Invalid Rows', '${result.invalidRowsCount}', Icons.warning_amber_outlined, Colors.red)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Duplicates', '${result.duplicateRowsCount}', Icons.copy_outlined, Colors.orange)),
          ],
        ),
        const SizedBox(height: 20),

        // Validation Breakdown & Mode Selection Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Validation Details Breakdown ($_selectedBookName)', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Source: ${_selectedFile?.name ?? _sourceUrl ?? 'Sheet Source'}', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  _buildDetailChip('Missing Sanskrit', '${result.missingSanskritCount}', result.missingSanskritCount > 0 ? Colors.red : Colors.grey),
                  _buildDetailChip('Missing English', '${result.missingEnglishCount}', result.missingEnglishCount > 0 ? Colors.amber[800]! : Colors.grey),
                  _buildDetailChip('Missing Hindi', '${result.missingHindiCount}', result.missingHindiCount > 0 ? Colors.amber[800]! : Colors.grey),
                  _buildDetailChip('Missing Gujarati', '${result.missingGujaratiCount}', result.missingGujaratiCount > 0 ? Colors.amber[800]! : Colors.grey),
                  if (result.hierarchyType != HierarchyType.referenceOnly) ...[
                    _buildDetailChip('Missing Chapter Info', '${result.missingChapterInfoCount}', result.missingChapterInfoCount > 0 ? Colors.red : Colors.grey),
                    _buildDetailChip('Missing Verse #', '${result.missingVerseNumCount}', result.missingVerseNumCount > 0 ? Colors.red : Colors.grey),
                  ],
                  _buildDetailChip('Approved QA', '${result.qaStatusCounts['Approved'] ?? 0}', Colors.green),
                  _buildDetailChip('Draft QA', '${result.qaStatusCounts['Draft'] ?? 0}', Colors.orange),
                ],
              ),
              const Divider(height: 28),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 10,
                children: [
                  Text('Import Mode:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'replace_all', label: Text('REPLACE EXISTING DATA'), icon: Icon(Icons.swap_horiz, color: Colors.red)),
                      ButtonSegment(value: 'upsert', label: Text('UPSERT (Merge)'), icon: Icon(Icons.sync)),
                      ButtonSegment(value: 'create_only', label: Text('CREATE ONLY'), icon: Icon(Icons.add_circle_outline)),
                      ButtonSegment(value: 'update_existing', label: Text('UPDATE EXISTING'), icon: Icon(Icons.edit_note)),
                      ButtonSegment(value: 'skip_duplicates', label: Text('SKIP DUPLICATES'), icon: Icon(Icons.block)),
                    ],
                    selected: {_importMode},
                    onSelectionChanged: (val) => _onModeChanged(val.first),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Data Table Inspector
        _buildValidationTableInspector(),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.bold, color: AdminColors.primaryDark)),
              Text(title, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildValidationTableInspector() {
    final parseRes = _parseResult;
    if (parseRes == null) return const SizedBox.shrink();
    final rows = parseRes.rows;
    final filteredRows = rows.where((r) {
      if (_tableFilter == 'valid') return r.isValid;
      if (_tableFilter == 'invalid') return !r.isValid;
      if (_tableFilter == 'duplicates') return r.isDuplicateInFile;
      return true;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Row Validation & Conflict Inspector', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold)),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'all', label: Text('All (${rows.length})')),
                    ButtonSegment(value: 'valid', label: Text('Valid (${rows.where((r) => r.isValid).length})')),
                    ButtonSegment(value: 'invalid', label: Text('Invalid (${rows.where((r) => !r.isValid).length})')),
                    ButtonSegment(value: 'duplicates', label: Text('Duplicates (${rows.where((r) => r.isDuplicateInFile).length})')),
                  ],
                  selected: {_tableFilter},
                  onSelectionChanged: (val) => setState(() => _tableFilter = val.first),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 380,
            child: ListView.separated(
              itemCount: filteredRows.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final row = filteredRows[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: row.isValid ? Colors.green[100] : Colors.red[100],
                    child: Text(
                      '${row.fileRowNumber}',
                      style: TextStyle(fontSize: 10, color: row.isValid ? Colors.green[900] : Colors.red[900], fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(row.verseId, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getActionColor(row.action).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          row.action.toUpperCase(),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getActionColor(row.action)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        parseRes.hierarchyType == HierarchyType.referenceOnly
                            ? '• Reference: ${row.canonicalRef.isNotEmpty ? row.canonicalRef : row.verseId}'
                            : '• Chap ${row.kandaNumber > 0 ? row.kandaNumber : "—"} Sec ${row.sargaNumber > 0 ? row.sargaNumber : "—"} Verse ${row.verseNumber > 0 ? row.verseNumber : "—"}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (row.sanskrit.isNotEmpty)
                        Text('Sanskrit: ${row.sanskrit}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                      if (!row.isValid)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('ERRORS: ${row.validationErrors.join("; ")}', style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  trailing: Text(row.qaStatus ?? 'Approved', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'new': return Colors.green[800]!;
      case 'update': return Colors.blue[800]!;
      case 'skip': return Colors.grey[700]!;
      case 'error': default: return Colors.red[800]!;
    }
  }

  Widget _buildDetectedStructureCard(RamayanaParseResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: AdminColors.primaryDark, size: 22),
              const SizedBox(width: 10),
              Text(
                'DETECTED SHEET STRUCTURE & MAPPING',
                style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Target Sacred Book: $_selectedBookName ($_selectedBookId)',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AdminColors.saffron),
          ),
          const SizedBox(height: 6),
          if (result.importMode == 'translation_update')
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.translate, color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DETECTED MODE: TRANSLATION UPDATE (Updates English, Hindi & Gujarati for existing Firestore verses using passage_id/reference).',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.table_chart, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DETECTED MODE: FULL MASTER SHEET (Full scripture content import: Sanskrit + Hierarchy + Translations).',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[900]),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          Text(
            'Detected Columns: ${result.detectedColumnMappings.entries.map((e) => '${e.key} -> "${e.value}"').join(', ')}',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey[800]),
          ),
          const SizedBox(height: 4),
          Text(
            result.hierarchyType == HierarchyType.referenceOnly
                ? 'Detected Chapters: 0 Chapters, 0 Sections, ${result.detectedVerseCount} Verses.'
                : 'Detected Chapters: ${result.detectedKandas.length} Chapters, ${result.detectedSargasCount} Sections, ${result.detectedVerseCount} Verses.',
            style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 4: IMPORTING PROGRESS
  // ============================================================

  Widget _buildStep4ImportingProgressWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const CircularProgressIndicator(color: AdminColors.saffron),
            const SizedBox(height: 24),
            Text(
              'Writing $_selectedBookName Content to Firestore...',
              style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 400,
              child: LinearProgressIndicator(
                value: _importProgress,
                backgroundColor: Colors.grey[300],
                color: AdminColors.saffron,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _importProgressMessage,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyFirestoreDocs() async {
    setState(() {
      _isVerifyingFirestore = true;
      _verificationReport = null;
    });

    try {
      final bookRef = FirebaseFirestore.instance.collection('sacred_books').doc(_selectedBookId);
      final bookDoc = await bookRef.get();

      if (!bookDoc.exists) {
        setState(() {
          _isVerifyingFirestore = false;
          _verificationReport = {
            'bookExists': false,
            'bookPath': 'sacred_books/$_selectedBookId',
            'chapterCount': 0,
            'verseCount': 0,
            'published': false,
          };
        });
        return;
      }

      final bookData = bookDoc.data() ?? {};
      final chaptersSnap = await bookRef.collection('chapters').get();
      int totalVerses = 0;

      for (final chapDoc in chaptersSnap.docs) {
        final vSnap = await chapDoc.reference.collection('verses').get();
        totalVerses += vSnap.docs.length;
      }

      setState(() {
        _isVerifyingFirestore = false;
        _verificationReport = {
          'bookExists': true,
          'bookPath': 'sacred_books/$_selectedBookId',
          'bookTitle': bookData['title'] ?? _selectedBookName,
          'chapterCount': chaptersSnap.docs.length,
          'verseCount': totalVerses,
          'published': bookData['published'] ?? false,
        };
      });
    } catch (e) {
      setState(() {
        _isVerifyingFirestore = false;
        _verificationReport = {
          'error': 'Verification failed: $e',
        };
      });
    }
  }

  // ============================================================
  // STEP 5: RESULT REPORT
  // ============================================================

  Widget _buildStep5ResultReportSection() {
    final res = _executionResult!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green[300]!),
            boxShadow: [
              BoxShadow(color: Colors.green.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 36),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_selectedBookName import completed.',
                        style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[900]),
                      ),
                      Text(
                        'The uploaded Excel Master Sheet has been set as the Canonical Source of Truth in Firestore.',
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 28),

              Text('PRIMARY METRICS REPORT:', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AdminColors.primaryDark)),
              const SizedBox(height: 12),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 700;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildReportStatCard('Excel rows', '${res.excelRows}', Icons.table_view, Colors.blue[800]!),
                      _buildReportStatCard('Firestore $_selectedBookName records', '${res.totalFirestoreRecords}', Icons.cloud_done, Colors.teal[800]!),
                      _buildReportStatCard('Kandas', '${res.totalKandas}', Icons.account_tree_outlined, Colors.purple[800]!),
                      _buildReportStatCard('Sargas', '${res.totalSargas}', Icons.format_list_bulleted, Colors.indigo[800]!),
                      _buildReportStatCard('Verses', '${res.totalVerses}', Icons.auto_stories, Colors.green[800]!),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              Text('CONTENT & TRANSLATIONS BREAKDOWN:', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AdminColors.primaryDark)),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildReportStatCard('Sanskrit verses', '${res.sanskritCount}', Icons.translate, Colors.amber[900]!),
                  _buildReportStatCard('English translations', '${res.englishCount}', Icons.language, Colors.blue[900]!),
                  _buildReportStatCard('Hindi translations', '${res.hindiCount}', Icons.language, Colors.orange[900]!),
                  _buildReportStatCard('Gujarati translations', '${res.gujaratiCount}', Icons.language, Colors.deepOrange[800]!),
                ],
              ),

              const SizedBox(height: 20),
              Text('ACTION BREAKDOWN:', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AdminColors.primaryDark)),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  _buildDetailChip('Added', '${res.versesCreated}', Colors.green[800]!),
                  _buildDetailChip('Updated', '${res.versesUpdated}', Colors.blue[800]!),
                  _buildDetailChip('Removed old $_selectedBookName records', '${res.removedOldRecords}', res.removedOldRecords > 0 ? Colors.red[700]! : Colors.grey[700]!),
                  _buildDetailChip('Skipped', '${res.skippedCount}', Colors.grey[700]!),
                  _buildDetailChip('Failed', '${res.invalidCount}', res.invalidCount > 0 ? Colors.red[800]! : Colors.grey[700]!),
                ],
              ),

              const SizedBox(height: 28),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _resetImport,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Import / Sync Another Master Sheet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: _isVerifyingFirestore ? null : _verifyFirestoreDocs,
                    icon: _isVerifyingFirestore
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.verified_outlined, color: AdminColors.saffron),
                    label: Text(
                      _isVerifyingFirestore ? 'Verifying Firestore...' : 'Verify Firestore Counts',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AdminColors.primaryDark),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      side: const BorderSide(color: AdminColors.saffron, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),

              if (_verificationReport != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud_done, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text('Live Firestore Verification Report', style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_verificationReport!['error'] != null)
                        Text(_verificationReport!['error'], style: GoogleFonts.inter(color: Colors.red, fontSize: 12.5))
                      else ...[
                        Text('• Book Path: ${_verificationReport!['bookPath']}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        Text('• Book Status: ${_verificationReport!['published'] == true ? "PUBLISHED ✅" : "DRAFT ⚠️"}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        Text('• Verified Chapter Documents: ${_verificationReport!['chapterCount']}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        Text('• Verified Verse Documents: ${_verificationReport!['verseCount']}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
