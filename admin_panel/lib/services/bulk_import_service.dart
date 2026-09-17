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
  final int booksCreated;
  final int booksUpdated;
  final int chaptersCreated;
  final int chaptersUpdated;
  final int versesCreated;
  final int versesUpdated;
  final int skippedCount;
  final int duplicateCount;
  final int invalidCount;
  final List<String> errors;

  const RamayanaImportExecutionResult({
    required this.booksCreated,
    required this.booksUpdated,
    required this.chaptersCreated,
    required this.chaptersUpdated,
    required this.versesCreated,
    required this.versesUpdated,
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
  Future<void> analyzeRamayanaRowsAgainstFirestore({
    required List<RamayanaParsedRow> rows,
    required String mode, // 'upsert', 'create_only', 'update_existing', 'skip_duplicates'
    String? targetBookId,
  }) async {
    for (final row in rows) {
      if (!row.isValid) {
        row.action = 'error';
        continue;
      }

      final activeBookId = (targetBookId != null && targetBookId.isNotEmpty)
          ? targetBookId.toLowerCase().replaceAll(' ', '_')
          : row.bookId.isNotEmpty
              ? row.bookId
              : 'ramayana';

      final String chapterDocId = (activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads')
          ? 'chapter_${row.kandaNumber}'
          : 'kanda_${row.kandaNumber}_sarga_${row.sargaNumber}';

      final verseDocRef = _firestore
          .collection('sacred_books')
          .doc(activeBookId)
          .collection('chapters')
          .doc(chapterDocId)
          .collection('verses')
          .doc(row.verseId);

      try {
        final doc = await verseDocRef.get();
        final exists = doc.exists;

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
      } catch (_) {
        row.action = mode == 'update_existing' ? 'skip' : 'new';
      }
    }
  }

  /// Execute Sacred Book Chapter-Wise Import into Firestore
  Future<RamayanaImportExecutionResult> executeRamayanaImport({
    required String fileName,
    required List<RamayanaParsedRow> rows,
    required String mode, // 'upsert', 'create_only', 'update_existing', 'skip_duplicates'
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
    int skippedCount = 0;
    int duplicateCount = 0;
    int invalidCount = 0;
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

    onProgress?.call(0, rowsToProcess.length, 'Initializing $activeBookName Book Document...');

    // 1. Ensure Parent Sacred Book Document exists
    final bookRef = _firestore.collection('sacred_books').doc(activeBookId);
    final bookDoc = await bookRef.get();

    String defaultSourceUrl = _resolveDefaultSourceUrl(activeBookId);
    String defaultSourceName = '$activeBookName Source';
    if (rowsToProcess.isNotEmpty) {
      defaultSourceUrl = rowsToProcess.first.sourceUrl;
      defaultSourceName = rowsToProcess.first.sourceName;
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

    if (bookDoc.exists) {
      await bookRef.set(bookMap, SetOptions(merge: true));
      booksUpdated++;
    } else {
      bookMap['createdAt'] = FieldValue.serverTimestamp();
      bookMap['totalChapters'] = 1;
      await bookRef.set(bookMap);
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

    onProgress?.call(0, rowsToProcess.length, 'Processing ${chapterGroups.length} Chapter Groups...');

    int processedRowsCount = 0;
    WriteBatch batch = _firestore.batch();
    int opCount = 0;

    for (final entry in chapterGroups.entries) {
      final chapterDocId = entry.key;
      final groupRows = entry.value;
      final firstRow = groupRows.first;

      final kandaNum = firstRow.kandaNumber;
      final sargaNum = firstRow.sargaNumber;

      final globalChapterNumber = (activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads')
          ? kandaNum
          : (kandaNum * 1000) + sargaNum;

      final chapterRef = bookRef.collection('chapters').doc(chapterDocId);

      final String chapTitle = _formatChapterTitle(activeBookId, kandaNum, sargaNum);
      final String chapSubtitle = _formatChapterSubtitle(activeBookId, kandaNum, sargaNum);

      // Chapter document map
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

      batch.set(chapterRef, chapterMap, SetOptions(merge: true));
      opCount++;

      for (final row in groupRows) {
        final verseRef = chapterRef.collection('verses').doc(row.verseId);

        final verseMap = <String, dynamic>{
          'verse_id': row.verseId,
          'verseNumber': row.verseNumber,
          'kanda_number': row.kandaNumber,
          'sarga_number': row.sargaNumber,
          'sanskrit': row.sanskrit,
          'sanskritText': row.sanskrit,
          'english': row.english,
          'hindi': row.hindi,
          'gujarati': row.gujarati,
          'translations': {
            'en': row.english,
            'hi': row.hindi,
            'gu': row.gujarati,
          },
          'meaningEnglish': row.explanation,
          'meaningGujarati': row.explanation,
          'meaningHindi': row.explanation,
          'explanation': row.explanation,
          'source_url': row.sourceUrl,
          'source_name': row.sourceName,
          'qa_status': row.qaStatus,
          'notes': row.notes,
          'published': row.qaStatus == 'Approved',
          'archived': false,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        batch.set(verseRef, verseMap, SetOptions(merge: true));
        opCount++;

        if (row.action == 'update') {
          versesUpdated++;
        } else {
          versesCreated++;
        }

        processedRowsCount++;

        if (opCount >= 380) {
          await batch.commit();
          batch = _firestore.batch();
          opCount = 0;
          onProgress?.call(
            processedRowsCount,
            rowsToProcess.length,
            'Importing $chapTitle (Verse ${row.verseNumber})...',
          );
        }
      }
    }

    if (opCount > 0) {
      await batch.commit();
      opCount = 0;
    }

    // Update parent book total chapters count
    final totalChaptersSnap = await bookRef.collection('chapters').get();
    await bookRef.update({
      'totalChapters': totalChaptersSnap.docs.length,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    onProgress?.call(rowsToProcess.length, rowsToProcess.length, 'Finalizing import logs...');

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

    await historyRef.set(historyModel.toMap());

    // Record activity log
    await _firestore.collection('admin_activity_logs').add({
      'action': 'SACRED_BOOK_IMPORT',
      'userEmail': adminEmail,
      'details': 'Imported $activeBookName ($activeBookId): $versesCreated verses created, $versesUpdated updated, $skippedCount skipped from $fileName (Mode: $mode)',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return RamayanaImportExecutionResult(
      booksCreated: booksCreated,
      booksUpdated: booksUpdated,
      chaptersCreated: chaptersCreated,
      chaptersUpdated: chaptersUpdated,
      versesCreated: versesCreated,
      versesUpdated: versesUpdated,
      skippedCount: skippedCount,
      duplicateCount: duplicateCount,
      invalidCount: invalidCount,
      errors: importErrors,
    );
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
        return 'Chapter $kanda';
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
