import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../models/import_history_admin_model.dart';
import 'ramayana_parser_service.dart';

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

class RamayanaImportExecutionResult {
  final int excelRows;
  final int totalFirestoreRecords;
  final int totalKandas;
  final int totalSargas;
  final int totalVerses;
  final int englishCount;
  final int hindiCount;
  final int gujaratiCount;
  final int sanskritCount;
  final int booksCreated;
  final int booksUpdated;
  final int chaptersCreated;
  final int chaptersUpdated;
  final int versesCreated;
  final int versesUpdated;
  final int removedOldRecords;
  final int skippedCount;
  final int duplicateCount;
  final int invalidCount;
  final List<String> errors;

  const RamayanaImportExecutionResult({
    this.excelRows = 0,
    this.totalFirestoreRecords = 0,
    this.totalKandas = 0,
    this.totalSargas = 0,
    this.totalVerses = 0,
    this.englishCount = 0,
    this.hindiCount = 0,
    this.gujaratiCount = 0,
    this.sanskritCount = 0,
    required this.booksCreated,
    required this.booksUpdated,
    required this.chaptersCreated,
    required this.chaptersUpdated,
    required this.versesCreated,
    required this.versesUpdated,
    this.removedOldRecords = 0,
    required this.skippedCount,
    required this.duplicateCount,
    required this.invalidCount,
    required this.errors,
  });
}

class BulkImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Standard file parser for basic books
  Future<List<ParsedVerseRow>> parseFile(PlatformFile file, {String? targetBookId}) async {
    final Uint8List? bytes = file.bytes;
    if (bytes == null) {
      throw Exception("File content could not be read.");
    }

    final String extension = (file.extension ?? (file.name.contains('.') ? file.name.split('.').last : '')).toLowerCase();
    List<List<dynamic>> rawRows = [];

    if (extension == 'csv') {
      final csvString = utf8.decode(bytes).replaceAll('\r\n', '\n').replaceAll('\r', '\n');
      rawRows = const CsvToListConverter(eol: '\n').convert(csvString);
    } else if (extension == 'xlsx' || extension == 'xls') {
      final excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet != null) {
          for (final row in sheet.rows) {
            rawRows.add(row.map((cell) => safeString(cell) ?? '').toList());
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

    // Dynamic header row detection
    int headerRowIdx = 0;
    for (int r = 0; r < rawRows.length && r < 50; r++) {
      final rowLower = rawRows[r].map((e) => e.toString().trim().toLowerCase()).toList();
      int matches = 0;
      for (final cell in rowLower) {
        if (cell == 'book_id' || cell == 'book' || cell == 'chapter' || cell == 'chapter_number' || cell == 'verse' || cell == 'verse_number' || cell == 'sanskrit' || cell == 'english' || cell == 'kanda' || cell == 'sarga') {
          matches++;
        }
      }
      if (matches >= 2) {
        headerRowIdx = r;
        break;
      }
    }

    final headerRow = rawRows[headerRowIdx].map((e) => e.toString().trim().toLowerCase()).toList();

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

    for (int i = headerRowIdx + 1; i < rawRows.length; i++) {
      final row = rawRows[i];
      if (row.isEmpty || row.every((c) => c.toString().trim().isEmpty)) {
        continue;
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

  /// Perform smart upsert analysis for standard books against Firestore
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

  /// Execute batch import for standard books to Firestore
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
      errors: importErrors.take(20).toList(),
      timestamp: DateTime.now(),
      importedBy: adminEmail,
    );

    await historyRef.set(historyModel.toMap());

    await _firestore.collection('admin_activity_logs').add({
      'action': 'BULK_IMPORT',
      'userEmail': adminEmail,
      'details': 'Imported $successCount verses into $bookName ($bookId) from $fileName',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return historyModel;
  }

  /// Analyze Sacred Book rows against Firestore for duplicate & mode evaluation
  /// Analyze Sacred Book rows against Firestore for duplicate & mode evaluation
  Future<void> analyzeRamayanaRowsAgainstFirestore({
    required List<RamayanaParsedRow> rows,
    required String mode, // 'replace_all', 'upsert', 'create_only', 'update_existing', 'skip_duplicates'
    String? targetBookId,
  }) async {
    final bool hasTranslationModeRows = rows.any((r) => r.importMode == 'translation_update');

    // 1. Instantly assign memory actions based on row validity and target mode (0 DB network calls)
    for (final row in rows) {
      if (!row.isValid) {
        row.action = 'error';
        continue;
      }
      if (row.importMode == 'translation_update') {
        row.action = 'update';
      } else if (mode == 'replace_all' || mode == 'upsert') {
        row.action = 'new';
      } else {
        row.action = (mode == 'update_existing') ? 'skip' : 'new';
      }
    }

    if (mode == 'replace_all' || mode == 'upsert') {
      return; // Fast path: replace_all and upsert modes perform direct upserts via SetOptions(merge: true)
    }

    // 2. Query Firestore only if strictly required by selected mode
    if (hasTranslationModeRows || mode == 'create_only' || mode == 'skip_duplicates' || mode == 'update_existing') {
      final Map<String, List<RamayanaParsedRow>> chapterGroups = {};
      for (final row in rows) {
        if (!row.isValid) continue;
        final activeBookId = (targetBookId != null && targetBookId.isNotEmpty)
            ? targetBookId.toLowerCase().replaceAll(' ', '_')
            : row.bookId.isNotEmpty
                ? row.bookId
                : 'ramayana';

        final String chapterDocId = (activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads')
            ? 'chapter_${row.kandaNumber}'
            : 'kanda_${row.kandaNumber}_sarga_${row.sargaNumber}';

        final key = '$activeBookId|$chapterDocId';
        chapterGroups.putIfAbsent(key, () => []).add(row);
      }

      final groupKeys = chapterGroups.keys.toList();
      const int batchSize = 20;
      for (int i = 0; i < groupKeys.length; i += batchSize) {
        final batchKeys = groupKeys.sublist(i, i + batchSize > groupKeys.length ? groupKeys.length : i + batchSize);
        await Future.wait(batchKeys.map((key) async {
          final parts = key.split('|');
          final bId = parts[0];
          final cId = parts[1];
          final chapterRows = chapterGroups[key]!;

          try {
            final snap = await _firestore
                .collection('sacred_books')
                .doc(bId)
                .collection('chapters')
                .doc(cId)
                .collection('verses')
                .get()
                .timeout(const Duration(seconds: 10));

            final existingDocs = snap.docs;
            final existingDocIds = existingDocs.map((d) => d.id).toSet();
            final existingPassageIds = existingDocs
                .map((d) => (d.data()['passage_id'] ?? d.data()['verse_id'] ?? '').toString())
                .where((s) => s.isNotEmpty)
                .toSet();

            for (final row in chapterRows) {
              final bool exists = existingDocIds.contains(row.verseId) ||
                  (row.rawId.isNotEmpty && (existingDocIds.contains(row.rawId) || existingPassageIds.contains(row.rawId)));

              if (row.importMode == 'translation_update') {
                if (exists) {
                  row.action = 'update';
                } else {
                  row.action = 'error';
                  final identifier = row.rawId.isNotEmpty ? row.rawId : (row.canonicalRef.isNotEmpty ? row.canonicalRef : row.verseId);
                  if (!row.validationErrors.any((e) => e.contains('Verse not found'))) {
                    row.validationErrors.add("Verse not found in database ($identifier)");
                  }
                }
              } else {
                if (exists) {
                  if (mode == 'create_only' || mode == 'skip_duplicates') {
                    row.action = 'skip';
                  } else {
                    row.action = 'update';
                  }
                } else {
                  if (mode == 'update_existing') {
                    row.action = 'skip';
                  } else {
                    row.action = 'new';
                  }
                }
              }
            }
          } catch (_) {
            for (final row in chapterRows) {
              if (row.importMode == 'translation_update') {
                row.action = 'error';
                final identifier = row.rawId.isNotEmpty ? row.rawId : (row.canonicalRef.isNotEmpty ? row.canonicalRef : row.verseId);
                row.validationErrors.add("Verse not found in database ($identifier)");
              } else {
                row.action = mode == 'update_existing' ? 'skip' : 'new';
              }
            }
          }
        }));
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
  }

  /// Execute Sacred Book Chapter-Wise Import into Firestore
  Future<RamayanaImportExecutionResult> executeRamayanaImport({
    required String fileName,
    required List<RamayanaParsedRow> rows,
    required String mode, // 'replace_all', 'upsert', 'create_only', 'update_existing', 'skip_duplicates'
    required String adminEmail,
    String? targetBookId,
    String? targetBookName,
    void Function(int current, int total, String message)? onProgress,
  }) async {
    int booksCreated = 0;
    int booksUpdated = 0;
    int chaptersCreated = 0;
    int chaptersUpdated = 0;
    int versesCreated = 0;
    int versesUpdated = 0;
    int removedOldRecords = 0;
    int skippedCount = 0;
    int duplicateCount = 0;
    int invalidCount = 0;
    int sanskritCount = 0;
    int englishCount = 0;
    int hindiCount = 0;
    int gujaratiCount = 0;
    final Set<int> kandasSet = {};
    final Set<String> sargasSet = {};
    final List<String> importErrors = [];

    final String activeBookId = (targetBookId != null && targetBookId.isNotEmpty)
        ? targetBookId.toLowerCase().replaceAll(' ', '_')
        : rows.isNotEmpty && rows.first.bookId.isNotEmpty
            ? rows.first.bookId
            : 'ramayana';

    final String activeBookName = (targetBookName != null && targetBookName.isNotEmpty)
        ? targetBookName
        : rows.isNotEmpty && rows.first.bookName.isNotEmpty
            ? rows.first.bookName
            : _resolveBookTitle(activeBookId);

    // Filter valid rows
    final rowsToProcess = <RamayanaParsedRow>[];
    for (final row in rows) {
      if (!row.isValid) {
        invalidCount++;
        importErrors.add("Row ${row.fileRowNumber} invalid: ${row.validationErrors.join(', ')}");
      } else if (row.action == 'skip') {
        skippedCount++;
        if (row.isDuplicateInFile) duplicateCount++;
      } else {
        rowsToProcess.add(row);
      }
    }

    print('[IMPORT DEBUG] SELECTED BOOK: $activeBookId');
    print('[IMPORT DEBUG] IMPORT BOOK: $activeBookId');
    print('[IMPORT DEBUG] SCHEMA: ${_resolveBookSchema(activeBookId)}');
    print('[IMPORT DEBUG] FIRESTORE TARGET: sacred_books/$activeBookId');
    print('[IMPORT DEBUG] IMPORTED ROWS: ${rowsToProcess.length}');

    final bookRef = _firestore.collection('sacred_books').doc(activeBookId);

    try {
      onProgress?.call(0, rowsToProcess.length, '[IMPORT] Initializing $activeBookName Parent Book Document...');

      // 1. Ensure Parent Sacred Book Document exists
      final bookDoc = await bookRef.get().timeout(const Duration(seconds: 15));

      String defaultSourceUrl = _resolveDefaultSourceUrl(activeBookId);
      String defaultSourceName = '$activeBookName Source';
      if (rowsToProcess.isNotEmpty) {
        defaultSourceUrl = rowsToProcess.first.sourceUrl ?? defaultSourceUrl;
        defaultSourceName = rowsToProcess.first.sourceName ?? defaultSourceName;
      }

      final bookMap = <String, dynamic>{
        'id': activeBookId,
        'title': activeBookName,
        'subtitle': '$activeBookName Sacred Text',
        'title_en': activeBookName,
        'subtitle_en': '$activeBookName Sacred Text',
        'iconEmoji': _resolveBookEmoji(activeBookId),
        'order': _resolveBookOrder(activeBookId),
        'published': true,
        'archived': false,
        'source_url': defaultSourceUrl,
        'source_name': defaultSourceName,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (bookDoc.exists && mode != 'replace_all') {
        await bookRef.set(bookMap, SetOptions(merge: true)).timeout(const Duration(seconds: 15));
        booksUpdated++;
      } else {
        bookMap['createdAt'] = FieldValue.serverTimestamp();
        bookMap['totalChapters'] = 1;
        await bookRef.set(bookMap).timeout(const Duration(seconds: 15));
        booksCreated++;
      }

      // 2. Group rows by Chapter
      final chapterGroups = <String, List<RamayanaParsedRow>>{};
      for (final row in rowsToProcess) {
        final String key = (activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads')
            ? 'chapter_${row.kandaNumber}'
            : 'kanda_${row.kandaNumber}_sarga_${row.sargaNumber}';
        chapterGroups.putIfAbsent(key, () => []).add(row);
      }

      final int totalRowsCount = rowsToProcess.length;
      onProgress?.call(0, totalRowsCount, '[IMPORT] Processing $totalRowsCount data rows across ${chapterGroups.length} Chapter groups...');

      // 3. SAFE BATCHING WRITE LOOP WITH TIMEOUT, RETRY & EVENT LOOP YIELD
      const int maxOpsPerBatch = 80;
      int processedRowsCount = 0;
      int batchOpCount = 0;

      // Estimate total ops (chapters + verses)
      final int totalOpsCount = chapterGroups.length + rowsToProcess.length;
      int totalBatchesCount = (totalOpsCount / maxOpsPerBatch).ceil();
      if (totalBatchesCount == 0) totalBatchesCount = 1;
      int currentBatchIndex = 0;

      WriteBatch currentBatch = _firestore.batch();
      int batchRowStart = 1;

      Future<void> commitCurrentBatch() async {
        if (batchOpCount == 0) return;
        currentBatchIndex++;
        bool committed = false;

        for (int attempt = 1; attempt <= 3; attempt++) {
          try {
            onProgress?.call(
              processedRowsCount,
              totalRowsCount,
              '[IMPORT] Uploading Batch $currentBatchIndex / $totalBatchesCount ($processedRowsCount / $totalRowsCount rows completed)...',
            );
            await currentBatch.commit().timeout(const Duration(seconds: 20));
            committed = true;
            print('[IMPORT] Batch $currentBatchIndex / $totalBatchesCount committed successfully ($batchOpCount ops).');
            break;
          } catch (e) {
            print('[IMPORT WARNING] Batch $currentBatchIndex attempt $attempt failed: $e');
            if (attempt == 3) {
              importErrors.add('Batch $currentBatchIndex failed after 3 retries: $e');
              invalidCount += (processedRowsCount - batchRowStart + 1);
            } else {
              await Future.delayed(Duration(milliseconds: 300 * attempt));
            }
          }
        }

        if (committed) {
          onProgress?.call(
            processedRowsCount,
            totalRowsCount,
            '[IMPORT] Uploading... $processedRowsCount / $totalRowsCount (Batch $currentBatchIndex / $totalBatchesCount)',
          );
        }

        // Always reset batch state and yield to main event loop for smooth Web UI progress
        currentBatch = _firestore.batch();
        batchOpCount = 0;
        batchRowStart = processedRowsCount + 1;
        await Future.delayed(const Duration(milliseconds: 10));
      }

      for (final entry in chapterGroups.entries) {
        final chapterDocId = entry.key;
        final groupRows = entry.value;
        final firstRow = groupRows.first;

        final kandaNum = firstRow.kandaNumber;
        final sargaNum = firstRow.sargaNumber;
        if (kandaNum > 0) kandasSet.add(kandaNum);
        if (kandaNum > 0 && sargaNum > 0) sargasSet.add('K${kandaNum}_S$sargaNum');

        final globalChapterNumber = (activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads')
            ? kandaNum
            : (kandaNum * 1000) + sargaNum;

        final chapterRef = bookRef.collection('chapters').doc(chapterDocId);
        final String chapTitle = _formatChapterTitle(activeBookId, kandaNum, sargaNum);
        final String chapSubtitle = _formatChapterSubtitle(activeBookId, kandaNum, sargaNum);

        final chapterMap = <String, dynamic>{
          'chapterNumber': globalChapterNumber,
          'kanda_number': kandaNum,
          'sarga_number': sargaNum,
          'title': chapTitle,
          'subtitle': chapSubtitle,
          'title_en': chapTitle,
          'subtitle_en': chapSubtitle,
          'descriptionEnglish': '$chapTitle of $activeBookName.',
          'source_url': firstRow.sourceUrl,
          'source_name': firstRow.sourceName,
          'qa_status': firstRow.qaStatus,
          'published': true,
          'archived': false,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        currentBatch.set(chapterRef, chapterMap, SetOptions(merge: true));
        batchOpCount++;
        chaptersCreated++;

        if (batchOpCount >= maxOpsPerBatch) {
          await commitCurrentBatch();
        }

        for (final row in groupRows) {
          final verseRef = chapterRef.collection('verses').doc(row.verseId);

          if (row.sanskrit.isNotEmpty) sanskritCount++;
          if (row.english != null && row.english!.isNotEmpty) englishCount++;
          if (row.hindi != null && row.hindi!.isNotEmpty) hindiCount++;
          if (row.gujarati != null && row.gujarati!.isNotEmpty) gujaratiCount++;

          if (row.importMode == 'translation_update') {
            final Map<String, dynamic> updateMap = {};
            if (row.english != null && row.english!.trim().isNotEmpty) {
              updateMap['english'] = row.english;
              updateMap['translations.en'] = row.english;
              updateMap['meaningEnglish'] = row.english;
            }
            if (row.hindi != null && row.hindi!.trim().isNotEmpty) {
              updateMap['hindi'] = row.hindi;
              updateMap['translations.hi'] = row.hindi;
              updateMap['meaningHindi'] = row.hindi;
            }
            if (row.gujarati != null && row.gujarati!.trim().isNotEmpty) {
              updateMap['gujarati'] = row.gujarati;
              updateMap['translations.gu'] = row.gujarati;
              updateMap['meaningGujarati'] = row.gujarati;
            }
            if (updateMap.isNotEmpty) {
              updateMap['updatedAt'] = FieldValue.serverTimestamp();
              currentBatch.set(verseRef, updateMap, SetOptions(merge: true));
              batchOpCount++;
              versesUpdated++;
            }
          } else {
            final verseMap = <String, dynamic>{
              'verse_id': row.verseId,
              'passage_id': row.rawId.isNotEmpty ? row.rawId : row.verseId,
              'canonical_reference': row.canonicalRef.isNotEmpty ? row.canonicalRef : '${row.kandaNumber}.${row.sargaNumber}.${row.verseNumber}',
              'verseNumber': row.verseNumber,
              'shlok_no': row.verseNumber,
              'kanda_number': row.kandaNumber,
              'kanda_no': row.kandaNumber,
              'kanda_name': _getKandaName(row.kandaNumber),
              'sarga_number': row.sargaNumber,
              'sarga_no': row.sargaNumber,
              'sanskrit': row.sanskrit,
              'sanskritText': row.sanskrit,
              'english': row.english ?? '',
              'hindi': row.hindi ?? '',
              'gujarati': row.gujarati ?? '',
              'translations': {
                'en': row.english ?? '',
                'hi': row.hindi ?? '',
                'gu': row.gujarati ?? '',
              },
              'meaningEnglish': (row.english != null && row.english!.isNotEmpty) ? row.english : (row.explanation ?? ''),
              'meaningHindi': (row.hindi != null && row.hindi!.isNotEmpty) ? row.hindi : (row.explanation ?? ''),
              'meaningGujarati': (row.gujarati != null && row.gujarati!.isNotEmpty) ? row.gujarati : (row.explanation ?? ''),
              'explanation': row.explanation ?? row.english ?? '',
              'source_url': row.sourceUrl ?? '',
              'qa_status': row.qaStatus ?? 'Approved',
              'notes': row.notes ?? '',
              'published': true,
              'archived': false,
              'updatedAt': FieldValue.serverTimestamp(),
            };

            currentBatch.set(verseRef, verseMap, SetOptions(merge: true));
            batchOpCount++;

            if (row.action == 'update') {
              versesUpdated++;
            } else {
              versesCreated++;
            }
          }

          processedRowsCount++;

          if (batchOpCount >= maxOpsPerBatch) {
            await commitCurrentBatch();
          }
        }
      }

      if (batchOpCount > 0) {
        await commitCurrentBatch();
      }

      // Update parent book total chapters count safely
      try {
        await bookRef.update({
          'totalChapters': chapterGroups.length,
          'updatedAt': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 10));
      } catch (_) {}

      // 4. SAFE OBSOLETE CLEANUP FOR ACTIVE BOOK ONLY (REPLACE_ALL MODE)
      if (mode == 'replace_all') {
        onProgress?.call(totalRowsCount, totalRowsCount, '[IMPORT] Cleaning obsolete records for $activeBookName safely...');
        try {
          final newDocIds = rowsToProcess.map((r) => r.verseId).toSet();
          final existingChapSnap = await bookRef.collection('chapters').get().timeout(const Duration(seconds: 15));
          for (final chapDoc in existingChapSnap.docs) {
            final verseSnap = await chapDoc.reference.collection('verses').get().timeout(const Duration(seconds: 15));
            WriteBatch cleanBatch = _firestore.batch();
            int cleanCount = 0;
            for (final verseDoc in verseSnap.docs) {
              if (!newDocIds.contains(verseDoc.id)) {
                cleanBatch.delete(verseDoc.reference);
                cleanCount++;
                removedOldRecords++;
                if (cleanCount >= maxOpsPerBatch) {
                  await cleanBatch.commit().timeout(const Duration(seconds: 15));
                  cleanBatch = _firestore.batch();
                  cleanCount = 0;
                  await Future.delayed(const Duration(milliseconds: 10));
                }
              }
            }
            if (cleanCount > 0) {
              await cleanBatch.commit().timeout(const Duration(seconds: 15));
            }
          }
        } catch (e) {
          print('[IMPORT WARNING] Cleanup of obsolete records encountered error: $e');
        }
      }

      onProgress?.call(totalRowsCount, totalRowsCount, '[IMPORT] Import complete! $processedRowsCount / $totalRowsCount rows processed.');

      // Write import history log
      final historyRef = _firestore.collection('import_history').doc();
      final historyModel = ImportHistoryAdminModel(
        id: historyRef.id,
        fileName: fileName,
        bookId: activeBookId,
        bookName: activeBookName,
        totalRows: rows.length,
        successCount: versesCreated + versesUpdated,
        errorCount: invalidCount,
        status: invalidCount == 0 ? 'completed' : (versesCreated + versesUpdated > 0 ? 'partial' : 'failed'),
        errors: importErrors.take(20).toList(),
        timestamp: DateTime.now(),
        importedBy: adminEmail,
      );

      try {
        await historyRef.set(historyModel.toMap()).timeout(const Duration(seconds: 10));
        await _firestore.collection('admin_activity_logs').add({
          'action': 'SACRED_BOOK_IMPORT',
          'userEmail': adminEmail,
          'details': 'Imported $activeBookName ($activeBookId): $versesCreated verses created, $versesUpdated updated, $removedOldRecords old records removed from $fileName (Mode: $mode)',
          'timestamp': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 10));
      } catch (e) {
        print('[BULK IMPORT WARNING] Could not write history log: $e');
      }

      final int totalFirestoreRecords = 1 + chapterGroups.length + (versesCreated + versesUpdated);

      return RamayanaImportExecutionResult(
        excelRows: rows.length,
        totalFirestoreRecords: totalFirestoreRecords,
        totalKandas: kandasSet.length,
        totalSargas: sargasSet.length,
        totalVerses: versesCreated + versesUpdated,
        englishCount: englishCount,
        hindiCount: hindiCount,
        gujaratiCount: gujaratiCount,
        sanskritCount: sanskritCount,
        booksCreated: booksCreated,
        booksUpdated: booksUpdated,
        chaptersCreated: chaptersCreated,
        chaptersUpdated: chaptersUpdated,
        versesCreated: versesCreated,
        versesUpdated: versesUpdated,
        removedOldRecords: removedOldRecords,
        skippedCount: skippedCount,
        duplicateCount: duplicateCount,
        invalidCount: invalidCount,
        errors: importErrors,
      );
    } catch (e, stack) {
      print('[CRITICAL IMPORT ERROR] executeRamayanaImport threw: $e\n$stack');
      importErrors.add('Critical execution error: $e');
      return RamayanaImportExecutionResult(
        excelRows: rows.length,
        totalFirestoreRecords: 0,
        totalKandas: 0,
        totalSargas: 0,
        totalVerses: 0,
        englishCount: 0,
        hindiCount: 0,
        gujaratiCount: 0,
        sanskritCount: 0,
        booksCreated: 0,
        booksUpdated: 0,
        chaptersCreated: 0,
        chaptersUpdated: 0,
        versesCreated: 0,
        versesUpdated: 0,
        skippedCount: skippedCount,
        duplicateCount: duplicateCount,
        invalidCount: rows.length,
        errors: importErrors,
      );
    }
  }

  static int _asInt(dynamic val, {int fallback = 0}) {
    if (val == null) return fallback;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString().trim()) ?? fallback;
  }

  static String _resolveBookTitle(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'Ramayana';
      case 'mahabharata': return 'Mahabharata';
      case 'bhagavad_gita': return 'Bhagavad Gita';
      case 'upanishads': return 'Upanishads';
      default: return bookId.split('_').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
    }
  }

  static String _resolveBookEmoji(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return '🏹';
      case 'mahabharata': return '⚔️';
      case 'bhagavad_gita': return '🪷';
      case 'upanishads': return '🕉️';
      default: return '📜';
    }
  }

  static int _resolveBookOrder(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'bhagavad_gita': return 1;
      case 'ramayana': return 2;
      case 'mahabharata': return 3;
      case 'upanishads': return 4;
      default: return 10;
    }
  }

  static String _resolveBookSchema(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'kanda_sarga_verse';
      case 'bhagavad_gita': return 'chapter_verse';
      case 'upanishads': return 'reference_only';
      default: return 'reference_only';
    }
  }

  static String _resolveDefaultSourceUrl(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'https://ramayana.info/';
      case 'mahabharata': return 'https://mahabharata.info/';
      case 'bhagavad_gita': return 'https://bhagavadgita.info/';
      case 'upanishads': return 'https://upanishads.info/';
      default: return 'https://sanatanscroll.info/';
    }
  }

  static String _formatChapterTitle(String bookId, int kanda, int sarga) {
    switch (bookId.toLowerCase()) {
      case 'ramayana':
        final kandaName = _getKandaName(kanda);
        return '$kandaName - Sarga $sarga';
      case 'mahabharata':
        return 'Parva $kanda - Section $sarga';
      case 'bhagavad_gita':
        return 'Chapter $kanda';
      case 'upanishads':
        return 'Isha Upanishad';
      default:
        return 'Chapter $kanda';
    }
  }

  static String _formatChapterSubtitle(String bookId, int kanda, int sarga) {
    switch (bookId.toLowerCase()) {
      case 'ramayana':
        final kandaName = _getKandaName(kanda);
        return '$kandaName • Sarga $sarga';
      case 'mahabharata':
        return 'Parva $kanda • Section $sarga';
      case 'bhagavad_gita':
        return 'Bhagavad Gita • Chapter $kanda';
      case 'upanishads':
        return 'Upanishads • Chapter $kanda';
      default:
        return 'Chapter $kanda';
    }
  }

  static String _getKandaName(int kanda) {
    switch (kanda) {
      case 1: return 'Bala Kanda';
      case 2: return 'Ayodhya Kanda';
      case 3: return 'Aranya Kanda';
      case 4: return 'Kishkindha Kanda';
      case 5: return 'Sundara Kanda';
      case 6: return 'Yuddha Kanda';
      case 7: return 'Uttara Kanda';
      default: return 'Kanda $kanda';
    }
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
