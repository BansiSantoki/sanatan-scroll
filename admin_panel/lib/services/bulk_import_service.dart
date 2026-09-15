import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../models/import_history_admin_model.dart';

class ParsedVerseRow {
  final int rowIndex;
  final String bookId;
  final String bookName;
  final int chapterNumber;
  final String chapterTitle;
  final int verseNumber;
  final String sanskritText;
  final String gujaratiTranslation;
  final String hindiTranslation;
  final String englishTranslation;
  final String explanation;
  final String audioUrl;
  final String imageUrl;
  final String status; // 'draft' or 'published'
  
  
  String action; // 'new', 'update', 'skip', 'error'
  List<String> validationErrors;

  ParsedVerseRow({
    required this.rowIndex,
    required this.bookId,
    required this.bookName,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.verseNumber,
    required this.sanskritText,
    required this.gujaratiTranslation,
    required this.hindiTranslation,
    required this.englishTranslation,
    required this.explanation,
    required this.audioUrl,
    required this.imageUrl,
    required this.status,
    this.action = 'new',
    List<String>? validationErrors,
  }) : validationErrors = validationErrors ?? [];
}

class BulkImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Parse uploaded PlatformFile (CSV or XLSX)
  Future<List<ParsedVerseRow>> parseFile(PlatformFile file, {String? targetBookId}) async {
    final Uint8List? bytes = file.bytes;
    if (bytes == null) {
      throw Exception("File content could not be read.");
    }

    final String extension = file.extension?.toLowerCase() ?? '';
    List<List<dynamic>> rawRows = [];

    if (extension == 'csv') {
      final csvString = utf8.decode(bytes);
      rawRows = const CsvToListConverter().convert(csvString);
    } else if (extension == 'xlsx' || extension == 'xls') {
      final excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet != null) {
          for (final row in sheet.rows) {
            rawRows.add(row.map((cell) => cell?.value?.toString() ?? '').toList());
          }
          break; // read first sheet
        }
      }
    } else {
      throw Exception("Unsupported file format: .$extension. Please upload CSV or XLSX.");
    }

    if (rawRows.isEmpty) {
      throw Exception("File is empty.");
    }

    // Identify header row
    final headerRow = rawRows.first.map((e) => e.toString().trim().toLowerCase()).toList();
    
    // Header mappings
    final bookIdIdx = _findHeaderIdx(headerRow, ['book_id', 'bookid', 'book']);
    final bookNameIdx = _findHeaderIdx(headerRow, ['book_name', 'bookname', 'book_title']);
    final chapNumIdx = _findHeaderIdx(headerRow, ['chapter_number', 'chapternumber', 'chapter_num', 'chapter']);
    final chapTitleIdx = _findHeaderIdx(headerRow, ['chapter_title', 'chaptertitle', 'chapter_name']);
    final verseNumIdx = _findHeaderIdx(headerRow, ['verse_number', 'versenumber', 'verse_num', 'verse']);
    final sanskritIdx = _findHeaderIdx(headerRow, ['sanskrit', 'shloka', 'sanskrit_text']);
    final gujaratiIdx = _findHeaderIdx(headerRow, ['gujarati', 'gujarati_translation']);
    final hindiIdx = _findHeaderIdx(headerRow, ['hindi', 'hindi_translation']);
    final englishIdx = _findHeaderIdx(headerRow, ['english', 'english_translation', 'translation']);
    final explanationIdx = _findHeaderIdx(headerRow, ['explanation', 'meaning', 'purport']);
    final audioIdx = _findHeaderIdx(headerRow, ['audio_url', 'audio']);
    final imageIdx = _findHeaderIdx(headerRow, ['image_url', 'image']);
    final statusIdx = _findHeaderIdx(headerRow, ['status', 'state']);

    List<ParsedVerseRow> parsedRows = [];

    for (int i = 1; i < rawRows.length; i++) {
      final row = rawRows[i];
      if (row.isEmpty || row.every((c) => c.toString().trim().isEmpty)) {
        continue; // skip blank row
      }

      String getVal(int idx) => idx != -1 && idx < row.length ? row[idx].toString().trim() : '';

      final rawBookId = getVal(bookIdIdx);
      final finalBookId = (targetBookId != null && targetBookId.isNotEmpty)
          ? targetBookId
          : rawBookId.isNotEmpty
              ? rawBookId.toLowerCase().replaceAll(' ', '_')
              : 'bhagavad_gita';

      final chapNum = int.tryParse(getVal(chapNumIdx)) ?? 1;
      final verseNum = int.tryParse(getVal(verseNumIdx)) ?? (i);

      final parsed = ParsedVerseRow(
        rowIndex: i + 1,
        bookId: finalBookId,
        bookName: getVal(bookNameIdx),
        chapterNumber: chapNum,
        chapterTitle: getVal(chapTitleIdx),
        verseNumber: verseNum,
        sanskritText: getVal(sanskritIdx),
        gujaratiTranslation: getVal(gujaratiIdx),
        hindiTranslation: getVal(hindiIdx),
        englishTranslation: getVal(englishIdx),
        explanation: getVal(explanationIdx),
        audioUrl: getVal(audioIdx),
        imageUrl: getVal(imageIdx),
        status: getVal(statusIdx).toLowerCase() == 'draft' ? 'draft' : 'published',
      );

      // Perform row validation
      final errors = <String>[];
      if (parsed.bookId.isEmpty) errors.add("Missing book_id");
      if (parsed.chapterNumber <= 0) errors.add("Invalid chapter_number");
      if (parsed.verseNumber <= 0) errors.add("Invalid verse_number");
      if (parsed.sanskritText.isEmpty && parsed.englishTranslation.isEmpty) {
        errors.add("Must include Sanskrit shloka or English translation");
      }

      if (errors.isNotEmpty) {
        parsed.action = 'error';
        parsed.validationErrors = errors;
      }

      parsedRows.add(parsed);
    }

    return parsedRows;
  }

  int _findHeaderIdx(List<String> headers, List<String> candidates) {
    for (final candidate in candidates) {
      final idx = headers.indexOf(candidate);
      if (idx != -1) return idx;
    }
    return -1;
  }

  /// Perform smart upsert analysis against Firestore
  Future<void> analyzeUpserts(List<ParsedVerseRow> rows) async {
    for (final row in rows) {
      if (row.action == 'error') continue;

      final verseRef = _firestore
          .collection('sacred_books')
          .doc(row.bookId)
          .collection('chapters')
          .doc('chapter_${row.chapterNumber}')
          .collection('verses')
          .doc('verse_${row.verseNumber}');

      final doc = await verseRef.get();
      if (doc.exists) {
        row.action = 'update';
      } else {
        row.action = 'new';
      }
    }
  }

  /// Execute batch import to Firestore in batches of up to 400 operations
  Future<ImportHistoryAdminModel> executeImport({
    required String fileName,
    required String bookId,
    required String bookName,
    required List<ParsedVerseRow> rows,
    required String adminEmail,
  }) async {
    int successCount = 0;
    int errorCount = 0;
    List<String> importErrors = [];

    // Filter valid rows
    final validRows = rows.where((r) => r.action != 'error' && r.action != 'skip').toList();
    errorCount += rows.length - validRows.length;
    for (final r in rows.where((r) => r.action == 'error')) {
      importErrors.add("Row ${r.rowIndex}: ${r.validationErrors.join(', ')}");
    }

    const int chunkSize = 400;
    for (int i = 0; i < validRows.length; i += chunkSize) {
      final chunk = validRows.sublist(i, i + chunkSize > validRows.length ? validRows.length : i + chunkSize);
      final WriteBatch batch = _firestore.batch();

      for (final row in chunk) {
        try {
          // Ensure chapter doc exists
          final chapRef = _firestore
              .collection('sacred_books')
              .doc(row.bookId)
              .collection('chapters')
              .doc('chapter_${row.chapterNumber}');

          batch.set(chapRef, {
            'chapterNumber': row.chapterNumber,
            'title': row.chapterTitle.isNotEmpty ? row.chapterTitle : 'Chapter ${row.chapterNumber}',
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Set verse doc
          final verseRef = chapRef.collection('verses').doc('verse_${row.verseNumber}');
          batch.set(verseRef, {
            'bookId': row.bookId,
            'chapterNumber': row.chapterNumber,
            'verseNumber': row.verseNumber,
            'sanskritText': row.sanskritText,
            'translations': {
              'gu': row.gujaratiTranslation,
              'hi': row.hindiTranslation,
              'en': row.englishTranslation,
            },
            'explanation': row.explanation,
            'audioUrl': row.audioUrl,
            'imageUrl': row.imageUrl,
            'status': row.status,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          successCount++;
        } catch (e) {
          errorCount++;
          importErrors.add("Row ${row.rowIndex} write error: $e");
        }
      }

      await batch.commit();
    }

    // Record import history log
    final historyRef = _firestore.collection('import_history').doc();
    final historyModel = ImportHistoryAdminModel(
      id: historyRef.id,
      fileName: fileName,
      bookId: bookId,
      bookName: bookName,
      totalRows: rows.length,
      successCount: successCount,
      errorCount: errorCount,
      status: errorCount == 0 ? 'completed' : (successCount > 0 ? 'partial' : 'failed'),
      errors: importErrors.take(20).toList(), // top 20 error snippets
      timestamp: DateTime.now(),
      importedBy: adminEmail,
    );

    await historyRef.set(historyModel.toMap());

    // Record activity log
    await _firestore.collection('admin_activity_logs').add({
      'action': 'BULK_IMPORT',
      'userEmail': adminEmail,
      'details': 'Imported $successCount verses into $bookName ($bookId) from $fileName',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return historyModel;
  }

  /// Stream import history records for Admin Panel dashboard & logs
  Stream<List<ImportHistoryAdminModel>> getImportHistoryStream() {
    return _firestore
        .collection('import_history')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ImportHistoryAdminModel.fromFirestore(doc)).toList());
  }
}
