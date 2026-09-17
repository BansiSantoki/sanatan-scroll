import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

String _extractCellStr(dynamic cell) {
  if (cell == null) return '';
  try {
    if (cell is Data) {
      final val = cell.value;
      if (val == null) return '';
      if (val is TextCellValue) {
        final inner = val.value;
        final textStr = inner.text ?? '';
        if (textStr.isNotEmpty) return textStr.trim();
        final str = inner.toString().trim();
        final match = RegExp(r'text:\s*([^,\)]+)').firstMatch(str);
        if (match != null) {
          final g1 = match.group(1);
          if (g1 != null) return g1.trim();
        }
        return str;
      }
      if (val is IntCellValue) return val.value.toString().trim();
      if (val is DoubleCellValue) return val.value.toString().trim();
      if (val is BoolCellValue) return val.value.toString().trim();
      if (val is DateCellValue) return '${val.year}-${val.month}-${val.day}';
      if (val is DateTimeCellValue) return '${val.year}-${val.month}-${val.day}';
      if (val is TimeCellValue) return val.toString().trim();
      try {
        dynamic d = val;
        if (d.value != null) {
          dynamic inner = d.value;
          if (inner is String) return inner.trim();
          try {
            if (inner.text != null) return inner.text.toString().trim();
          } catch (_) {}
          return inner.toString().trim();
        }
      } catch (_) {}
      final s = val.toString().trim();
      final match = RegExp(r'text:\s*([^,\)]+)').firstMatch(s);
      if (match != null) {
        final g1 = match.group(1);
        if (g1 != null) return g1.trim();
      }
      return s;
    }
    return cell.toString().trim();
  } catch (_) {
    return '';
  }
}

String? safeString(dynamic value) {
  if (value == null) return null;
  final text = _extractCellStr(value);
  return text.isEmpty ? null : text;
}

int? safeInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is Data) {
    final val = value.value;
    if (val == null) return null;
    if (val is IntCellValue) return val.value;
    if (val is DoubleCellValue) return val.value.toInt();
    return safeInt(val.toString());
  }
  final str = safeString(value);
  if (str == null) return null;
  final direct = int.tryParse(str);
  if (direct != null) return direct;
  final match = RegExp(r'\d+').firstMatch(str);
  if (match != null) {
    final g0 = match.group(0);
    if (g0 != null) {
      return int.tryParse(g0);
    }
  }
  return null;
}

class RamayanaParsedRow {
  final int fileRowNumber; // Original spreadsheet row number (1-indexed)
  final String rawId;
  final String verseId; // e.g. RAM-01-001-001 or GIT-01-001
  final String bookId; // e.g. ramayana, mahabharata, bhagavad_gita
  final String bookName;
  final int kandaNumber; // Primary chapter (Kanda / Parva / Chapter)
  final int sargaNumber; // Sub-unit (Sarga / Section / Adhyaya)
  final int verseNumber;
  final String sanskrit;
  final String english;
  final String hindi;
  final String gujarati;
  final String explanation;
  final String sourceUrl;
  final String sourceName;
  final String qaStatus; // Draft, Review, Approved, Rejected
  final String notes;

  String action; // 'new', 'update', 'skip', 'error'
  List<String> validationErrors;
  List<String> affectedColumns;
  bool isDuplicateInFile;

  // Generic aliases
  int get chapterNumber => kandaNumber;
  int get sectionNumber => sargaNumber;

  RamayanaParsedRow({
    required this.fileRowNumber,
    required this.rawId,
    required this.verseId,
    required this.bookId,
    required this.bookName,
    required this.kandaNumber,
    required this.sargaNumber,
    required this.verseNumber,
    required this.sanskrit,
    required this.english,
    required this.hindi,
    required this.gujarati,
    required this.explanation,
    required this.sourceUrl,
    required this.sourceName,
    required this.qaStatus,
    required this.notes,
    this.action = 'new',
    List<String>? validationErrors,
    List<String>? affectedColumns,
    this.isDuplicateInFile = false,
  })  : validationErrors = validationErrors ?? [],
        affectedColumns = affectedColumns ?? [];

  bool get isValid => validationErrors.isEmpty;
}

class RamayanaParseResult {
  final List<RamayanaParsedRow> rows;
  final int totalRawRowsInFile;
  final int metadataRowsSkipped;
  final int scriptureRowsDetected;
  final int headerRowNumber; // 1-indexed
  final Map<String, String> detectedColumnMappings;
  final List<int> detectedKandas;
  final int detectedSargasCount;
  final int detectedVerseCount;
  final int validRowsCount;
  final int invalidRowsCount;
  final int duplicateRowsCount;
  final int missingSanskritCount;
  final int missingChapterInfoCount;
  final int missingVerseNumCount;
  final int missingTranslationsCount;
  final Map<String, int> qaStatusCounts;
  final String defaultSourceUrl;

  const RamayanaParseResult({
    required this.rows,
    required this.totalRawRowsInFile,
    required this.metadataRowsSkipped,
    required this.scriptureRowsDetected,
    required this.headerRowNumber,
    required this.detectedColumnMappings,
    required this.detectedKandas,
    required this.detectedSargasCount,
    required this.detectedVerseCount,
    required this.validRowsCount,
    required this.invalidRowsCount,
    required this.duplicateRowsCount,
    required this.missingSanskritCount,
    required this.missingChapterInfoCount,
    required this.missingVerseNumCount,
    required this.missingTranslationsCount,
    required this.qaStatusCounts,
    required this.defaultSourceUrl,
  });
}

class RamayanaParserService {
  /// Universal RegExp pattern for IDs like RAM-01-001-001, MAH-01-001-001, GIT-01-001, UPN-01-001
  static final RegExp _idRegex = RegExp(r'^([A-Za-z0-9]+)-(\d+)-(\d+)(?:-(\d+))?$');

  static final List<String> _instructionKeywords = [
    'instructions',
    'instruction',
    'purport',
    'rules',
    'rule',
    'notes',
    'note:',
    'notes:',
    'readme',
    'metadata',
    'specification',
    'guideline',
    'guidelines',
  ];

  /// Parse uploaded PlatformFile (CSV or XLSX) for any Sacred Book
  Future<RamayanaParseResult> parseFile(
    PlatformFile file, {
    String? targetBookId,
    String? targetBookName,
  }) async {
    final Uint8List? bytes = file.bytes;
    if (bytes == null) {
      throw Exception("File content could not be read.");
    }

    final String activeBookId = (targetBookId != null && targetBookId.isNotEmpty)
        ? targetBookId.toLowerCase().replaceAll(' ', '_')
        : 'ramayana';
    final String activeBookName = (targetBookName != null && targetBookName.isNotEmpty)
        ? targetBookName
        : _resolveBookName(activeBookId);

    final String defaultBookCode = _resolveBookCode(activeBookId);

    final String extension = (file.extension ?? (file.name.contains('.') ? file.name.split('.').last : '')).toLowerCase();
    List<List<dynamic>> rawRows = [];

    if (extension == 'csv') {
      final csvString = utf8.decode(bytes).replaceAll('\r\n', '\n').replaceAll('\r', '\n');
      rawRows = const CsvToListConverter(eol: '\n').convert(csvString);
    } else if (extension == 'xlsx' || extension == 'xls') {
      final excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null || sheet.rows.isEmpty) continue;

        final sheetRows = sheet.rows.map((row) => row.map((cell) => _extractCellStr(cell)).toList()).toList();
        final hIdx = _findContentHeaderRowIndex(sheetRows);
        if (hIdx != -1) {
          rawRows = sheetRows;
          break; // Found worksheet with valid content table!
        }
      }

      // Fallback if no content table header was found in any sheet: use first non-empty sheet
      if (rawRows.isEmpty && excel.tables.isNotEmpty) {
        for (final table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet != null && sheet.rows.isNotEmpty) {
            rawRows = sheet.rows.map((row) => row.map((cell) => _extractCellStr(cell)).toList()).toList();
            break;
          }
        }
      }
    } else {
      throw Exception("Unsupported file format: .$extension. Please upload CSV or XLSX.");
    }

    if (rawRows.isEmpty) {
      throw Exception("File is empty or contains no readable rows.");
    }

    // Locate the content table header row
    final headerRowIdx = _findContentHeaderRowIndex(rawRows);

    if (headerRowIdx == -1) {
      throw Exception("No valid sacred book content table was detected in this file. Please upload a CSV/XLSX file containing Chapter, Verse, and Sanskrit columns.");
    }

    // Extract locked source URL from pre-header metadata rows if present
    String defaultSourceUrl = _extractMetadataSourceUrl(rawRows.sublist(0, headerRowIdx + 1));
    if (defaultSourceUrl.isEmpty) {
      defaultSourceUrl = _resolveDefaultSourceUrl(activeBookId);
    }

    final metadataRowsSkipped = headerRowIdx;
    final headerRowCells = rawRows[headerRowIdx].map((e) => _extractCellStr(e)).toList();
    final headerRowLower = headerRowCells.map((e) => e.toLowerCase()).toList();

    // Flexible Column mapping with normalization and expanded aliases
    final idIdx = _findHeaderIdx(headerRowLower, ['id', 'verse_id', 'canonical_id', 'shlok_id', 'shloka_id', 'example_id', 'code', 'passage_id', 'ram_id', 'mah_id', 'git_id', 'upn_id']);
    final bookIdIdx = _findHeaderIdx(headerRowLower, ['book_id', 'bookid', 'book', 'book_code', 'sacred_book']);
    final bookNameIdx = _findHeaderIdx(headerRowLower, ['book_name', 'bookname', 'book_title', 'title']);
    final kandaIdx = _findHeaderIdx(headerRowLower, ['kanda_number', 'kandanumber', 'kanda number', 'kanda', 'kand', 'kanda_no', 'kanda #', 'kandam', 'parva', 'parva_number', 'parva number', 'parva_no', 'chapter_number', 'chapternumber', 'chapter number', 'chapter', 'chapter_no', 'chapter #']);
    final sargaIdx = _findHeaderIdx(headerRowLower, ['sarga_number', 'sarganumber', 'sarga number', 'sarga', 'sarg', 'sarga_no', 'sarga #', 'section_number', 'sectionnumber', 'section number', 'section', 'section_no', 'section #', 'adhyaya', 'adhyaya_number', 'adhyaya number', 'subchapter']);
    final verseIdx = _findHeaderIdx(headerRowLower, ['verse_number', 'versenumber', 'verse number', 'shlok_number', 'shloka_number', 'shlok number', 'shloka number', 'verse', 'shlok', 'shloka', 'verse_no', 'verse #']);
    final sanskritIdx = _findHeaderIdx(headerRowLower, ['sanskrit_shloka', 'sanskrit shloka', 'sanskrit_text', 'sanskrit text', 'sanskrit', 'shloka_text', 'sloka', 'sloka_text', 'original_sanskrit', 'passage', 'verse_text']);
    final englishIdx = _findHeaderIdx(headerRowLower, ['english_translation', 'english translation', 'english_meaning', 'english meaning', 'english', 'translation_en', 'en', 'eng']);
    final hindiIdx = _findHeaderIdx(headerRowLower, ['hindi_translation', 'hindi translation', 'hindi_meaning', 'hindi meaning', 'hindi', 'translation_hi', 'hi', 'hin']);
    final gujaratiIdx = _findHeaderIdx(headerRowLower, ['gujarati_translation', 'gujarati translation', 'gujarati_meaning', 'gujarati meaning', 'gujarati', 'translation_gu', 'gu', 'guj']);
    final explanationIdx = _findHeaderIdx(headerRowLower, ['explanation', 'meaning', 'purport', 'notes_explanation', 'commentary']);
    final sourceUrlIdx = _findHeaderIdx(headerRowLower, ['source_url', 'sourceurl', 'source', 'url', 'source_link', 'link', 'locked_source']);
    final sourceNameIdx = _findHeaderIdx(headerRowLower, ['source_name', 'sourcename', 'source_title']);
    final qaStatusIdx = _findHeaderIdx(headerRowLower, ['qa_status', 'qastatus', 'qa', 'status', 'review_status', 'state']);
    final notesIdx = _findHeaderIdx(headerRowLower, ['notes', 'comment', 'remarks', 'note']);

    final detectedMappings = <String, String>{};
    if (idIdx != -1) detectedMappings['ID / Verse ID'] = headerRowCells[idIdx];
    if (kandaIdx != -1) detectedMappings['Chapter / Kanda / Parva'] = headerRowCells[kandaIdx];
    if (sargaIdx != -1) detectedMappings['Section / Sarga / Adhyaya'] = headerRowCells[sargaIdx];
    if (verseIdx != -1) detectedMappings['Verse / Shlok'] = headerRowCells[verseIdx];
    if (sanskritIdx != -1) detectedMappings['Sanskrit'] = headerRowCells[sanskritIdx];
    if (englishIdx != -1) detectedMappings['English'] = headerRowCells[englishIdx];
    if (hindiIdx != -1) detectedMappings['Hindi'] = headerRowCells[hindiIdx];
    if (gujaratiIdx != -1) detectedMappings['Gujarati'] = headerRowCells[gujaratiIdx];

    final parsedRows = <RamayanaParsedRow>[];
    final seenIdsInFile = <String, int>{};
    final detectedKandasSet = <int>{};
    final detectedSargasSet = <String>{};

    int missingSanskritCount = 0;
    int missingChapterInfoCount = 0;
    int missingVerseNumCount = 0;
    int missingTranslationsCount = 0;
    final Map<String, int> qaStatusCounts = {
      'Draft': 0,
      'Review': 0,
      'Approved': 0,
      'Rejected': 0,
    };

    int skippedInstructionRowsAfterHeader = 0;

    // Parse Data Rows starting after headerRowIdx
    for (int i = headerRowIdx + 1; i < rawRows.length; i++) {
      final row = rawRows[i];
      if (row.isEmpty || row.every((c) => _extractCellStr(c).isEmpty)) {
        continue; // skip blank row safely
      }

      // Skip instruction or metadata rows that might appear after header
      if (_isInstructionOrMetadataRow(row)) {
        skippedInstructionRowsAfterHeader++;
        continue;
      }

      String getVal(int idx) => idx != -1 && idx < row.length ? _extractCellStr(row[idx]) : '';

      final rawId = getVal(idIdx);
      final rawBook = getVal(bookIdIdx);
      final rawBookNameCol = getVal(bookNameIdx);
      final rawKanda = getVal(kandaIdx);
      final rawSarga = getVal(sargaIdx);
      final rawVerse = getVal(verseIdx);
      final sanskritText = getVal(sanskritIdx);
      final englishText = getVal(englishIdx);
      final hindiText = getVal(hindiIdx);
      final gujaratiText = getVal(gujaratiIdx);
      final explanationText = getVal(explanationIdx);
      final sourceUrlVal = getVal(sourceUrlIdx).isNotEmpty ? getVal(sourceUrlIdx) : defaultSourceUrl;
      final sourceNameVal = getVal(sourceNameIdx).isNotEmpty ? getVal(sourceNameIdx) : '$activeBookName Source';
      final rawQaStatus = getVal(qaStatusIdx);
      final notesText = getVal(notesIdx);

      final colKanda = safeInt(rawKanda) ?? -1;
      final colSarga = safeInt(rawSarga) ?? -1;
      final colVerse = safeInt(rawVerse) ?? -1;

      String bookCode = defaultBookCode;
      int parsedKanda = -1;
      int parsedSarga = -1;
      int parsedVerse = -1;
      bool idParsedSuccess = false;

      if (rawId.isNotEmpty) {
        final match = _idRegex.firstMatch(rawId);
        if (match != null) {
          final g1 = match.group(1);
          final g2 = match.group(2);
          final g3 = match.group(3);
          final g4 = match.group(4);

          if (g1 != null && g2 != null && g3 != null) {
            bookCode = g1.toUpperCase();
            if (g4 != null) {
              // 4 components: BOOK-KANDA-SARGA-VERSE (e.g. RAM-01-001-001 or MAH-01-001-001)
              parsedKanda = int.tryParse(g2) ?? -1;
              parsedSarga = int.tryParse(g3) ?? -1;
              parsedVerse = int.tryParse(g4) ?? -1;
              idParsedSuccess = (parsedKanda > 0 && parsedSarga > 0 && parsedVerse > 0);
            } else {
              // 3 components: BOOK-CHAP-VERSE (e.g. GIT-01-001 or UPN-01-001)
              parsedKanda = int.tryParse(g2) ?? -1;
              parsedSarga = 1; // default section 1
              parsedVerse = int.tryParse(g3) ?? -1;
              idParsedSuccess = (parsedKanda > 0 && parsedVerse > 0);
            }
          }
        }
      }

      int finalKanda = colKanda > 0 ? colKanda : parsedKanda;
      int finalSarga = colSarga > 0 ? colSarga : parsedSarga;
      int finalVerse = colVerse > 0 ? colVerse : parsedVerse;

      // For books that don't use 2-tier sub-sections (e.g. Bhagavad Gita), default sarga to 1 if not explicitly given
      if ((activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads') && finalSarga <= 0) {
        finalSarga = 1;
      }

      // If row has NO scripture content signals, treat as non-content row and skip cleanly!
      if (finalKanda <= 0 && finalVerse <= 0 && sanskritText.isEmpty && !idParsedSuccess) {
        skippedInstructionRowsAfterHeader++;
        continue;
      }

      // QA Status normalization
      String qaStatus = 'Approved';
      final qaLower = rawQaStatus.toLowerCase();
      if (qaLower.contains('draft')) {
        qaStatus = 'Draft';
      } else if (qaLower.contains('review')) {
        qaStatus = 'Review';
      } else if (qaLower.contains('reject')) {
        qaStatus = 'Rejected';
      } else if (qaLower.contains('approve')) {
        qaStatus = 'Approved';
      }
      qaStatusCounts[qaStatus] = (qaStatusCounts[qaStatus] ?? 0) + 1;

      final errors = <String>[];
      final affectedCols = <String>[];

      // CONFLICT RULE: Check if explicit column values conflict with values parsed from ID
      if (idParsedSuccess && colKanda > 0 && parsedKanda != colKanda) {
        errors.add("Chapter conflict: ID specifies $parsedKanda but column specifies $colKanda");
        affectedCols.add("Chapter");
      }
      if (idParsedSuccess && colSarga > 0 && parsedSarga > 0 && parsedSarga != colSarga) {
        errors.add("Section conflict: ID specifies $parsedSarga but column specifies $colSarga");
        affectedCols.add("Section");
      }
      if (idParsedSuccess && colVerse > 0 && parsedVerse != colVerse) {
        errors.add("Verse conflict: ID specifies Verse $parsedVerse but column specifies Verse $colVerse");
        affectedCols.add("Verse");
      }

      // Check required scripture fields for content rows
      if (finalKanda <= 0) {
        final term = _resolveChapterTerm(activeBookId);
        errors.add("Missing or invalid $term number");
        affectedCols.add(term);
        missingChapterInfoCount++;
      } else {
        detectedKandasSet.add(finalKanda);
      }

      if (finalSarga <= 0 && activeBookId == 'ramayana') {
        errors.add("Missing or invalid Sarga/Chapter number");
        affectedCols.add("Sarga / Chapter");
        missingChapterInfoCount++;
      }

      if (finalKanda > 0 && finalSarga > 0) {
        detectedSargasSet.add('K${finalKanda}_S$finalSarga');
      }

      if (finalVerse <= 0) {
        errors.add("Missing or invalid Verse number");
        affectedCols.add("Verse / Shlok");
        missingVerseNumCount++;
      }

      if (sanskritText.isEmpty) {
        errors.add("Missing Sanskrit shloka text");
        affectedCols.add("Sanskrit");
        missingSanskritCount++;
      }

      if (englishText.isEmpty && hindiText.isEmpty && gujaratiText.isEmpty) {
        errors.add("Missing required translations (English, Hindi, or Gujarati)");
        affectedCols.add("Translations");
        missingTranslationsCount++;
      }

      // Canonical verse ID generation - e.g. RAM-01-001-001 or GIT-01-001
      String canonicalVerseId;
      if (finalKanda > 0 && finalVerse > 0) {
        final kandaPad = finalKanda.toString().padLeft(2, '0');
        final versePad = finalVerse.toString().padLeft(3, '0');
        if (activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads') {
          canonicalVerseId = '$bookCode-$kandaPad-$versePad';
        } else {
          final sargaPad = (finalSarga > 0 ? finalSarga : 1).toString().padLeft(3, '0');
          canonicalVerseId = '$bookCode-$kandaPad-$sargaPad-$versePad';
        }
      } else if (rawId.isNotEmpty && _idRegex.hasMatch(rawId)) {
        canonicalVerseId = rawId.toUpperCase();
      } else {
        // Use exact row number identifier for invalid rows
        canonicalVerseId = 'Row ${i + 1}';
      }

      final bool isDup = canonicalVerseId.contains('-') &&
          !canonicalVerseId.contains('00-000-000') &&
          seenIdsInFile.containsKey(canonicalVerseId);

      if (isDup) {
        errors.add("Duplicate verse ID in sheet: $canonicalVerseId (first seen at row ${seenIdsInFile[canonicalVerseId]})");
        affectedCols.add("ID / Verse ID");
      } else if (canonicalVerseId.contains('-')) {
        seenIdsInFile[canonicalVerseId] = i + 1;
      }

      final rowBookName = rawBookNameCol.isNotEmpty
          ? rawBookNameCol
          : rawBook.isNotEmpty
              ? rawBook
              : activeBookName;

      final parsedRow = RamayanaParsedRow(
        fileRowNumber: i + 1, // 1-indexed actual row in file
        rawId: rawId,
        verseId: canonicalVerseId,
        bookId: activeBookId,
        bookName: rowBookName,
        kandaNumber: finalKanda,
        sargaNumber: finalSarga > 0 ? finalSarga : 1,
        verseNumber: finalVerse,
        sanskrit: sanskritText,
        english: englishText,
        hindi: hindiText,
        gujarati: gujaratiText,
        explanation: explanationText,
        sourceUrl: sourceUrlVal,
        sourceName: sourceNameVal,
        qaStatus: qaStatus,
        notes: notesText,
        action: errors.isNotEmpty ? 'error' : 'new',
        validationErrors: errors,
        affectedColumns: affectedCols,
        isDuplicateInFile: isDup,
      );

      parsedRows.add(parsedRow);
    }

    if (parsedRows.isEmpty) {
      throw Exception("No valid content table was detected in this file. Please upload a valid CSV/XLSX file containing scripture verses.");
    }

    final validCount = parsedRows.where((r) => r.isValid).length;
    final invalidCount = parsedRows.where((r) => !r.isValid).length;
    final dupCount = parsedRows.where((r) => r.isDuplicateInFile).length;
    final sortedKandas = detectedKandasSet.toList()..sort();

    return RamayanaParseResult(
      rows: parsedRows,
      totalRawRowsInFile: rawRows.length,
      metadataRowsSkipped: metadataRowsSkipped + skippedInstructionRowsAfterHeader,
      scriptureRowsDetected: parsedRows.length,
      headerRowNumber: headerRowIdx + 1,
      detectedColumnMappings: detectedMappings,
      detectedKandas: sortedKandas,
      detectedSargasCount: detectedSargasSet.length,
      detectedVerseCount: parsedRows.length,
      validRowsCount: validCount,
      invalidRowsCount: invalidCount,
      duplicateRowsCount: dupCount,
      missingSanskritCount: missingSanskritCount,
      missingChapterInfoCount: missingChapterInfoCount,
      missingVerseNumCount: missingVerseNumCount,
      missingTranslationsCount: missingTranslationsCount,
      qaStatusCounts: qaStatusCounts,
      defaultSourceUrl: defaultSourceUrl,
    );
  }

  static String _resolveBookName(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'Ramayana';
      case 'mahabharata': return 'Mahabharata';
      case 'bhagavad_gita': return 'Bhagavad Gita';
      case 'upanishads': return 'Upanishads';
      default: return bookId.split('_').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
    }
  }

  static String _resolveBookCode(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'RAM';
      case 'mahabharata': return 'MAH';
      case 'bhagavad_gita': return 'GIT';
      case 'upanishads': return 'UPN';
      default:
        final clean = bookId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
        return clean.length >= 3 ? clean.substring(0, 3) : clean.padRight(3, 'X');
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

  static String _resolveChapterTerm(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'ramayana': return 'Kanda';
      case 'mahabharata': return 'Parva / Chapter';
      case 'bhagavad_gita': return 'Chapter';
      case 'upanishads': return 'Chapter / Section';
      default: return 'Chapter';
    }
  }

  /// Locate the content table header row in raw rows
  int _findContentHeaderRowIndex(List<List<dynamic>> rawRows) {
    for (int r = 0; r < rawRows.length && r < 100; r++) {
      final row = rawRows[r];
      if (row.isEmpty) continue;

      if (_isInstructionOrMetadataRow(row)) {
        continue;
      }

      final rowStr = row.map((e) => _extractCellStr(e)).toList();
      if (_isContentHeaderRow(rowStr)) {
        return r;
      }
    }
    return -1;
  }

  bool _isInstructionOrMetadataRow(List<dynamic> row) {
    if (row.isEmpty) return true;
    final firstCell = _extractCellStr(row.first).toLowerCase();
    if (firstCell.isEmpty) return false;

    // Check if first cell starts with or equals an instruction keyword
    for (final kw in _instructionKeywords) {
      if (firstCell == kw || firstCell.startsWith('$kw:') || firstCell.startsWith('$kw ') || firstCell.startsWith('$kw,')) {
        return true;
      }
    }

    // Check if cell contains clear instruction title phrases
    if (firstCell.contains('locked source') ||
        firstCell.contains('translation method') ||
        firstCell.contains('id format') ||
        firstCell.contains('current scope') ||
        firstCell.contains('sanskrit rule') ||
        firstCell.contains('row rule') ||
        firstCell.contains('purpose')) {
      return true;
    }

    return false;
  }

  bool _isContentHeaderRow(List<String> rowCells) {
    if (rowCells.isEmpty) return false;

    for (final cell in rowCells) {
      if (cell.trim().length > 30) return false;
      final lower = cell.trim().toLowerCase();
      if (lower.contains('rule') ||
          lower.contains('guideline') ||
          lower.contains('instruction') ||
          lower.contains('workflow') ||
          lower.contains('scope') ||
          lower.contains('purpose') ||
          lower.contains('method') ||
          lower.contains('format')) {
        return false;
      }
    }

    int matches = 0;
    bool hasKandaOrSargaOrVerse = false;
    bool hasSanskritOrTranslationOrId = false;

    for (final cell in rowCells) {
      final c = cell.trim().toLowerCase();
      if (c == 'id' || c == 'verse_id' || c == 'canonical_id' || c == 'shlok_id' || c == 'code' || c == 'passage_id' || c == 'ram_id' || c == 'mah_id' || c == 'git_id' || c == 'upn_id') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'kanda' || c == 'kand' || c == 'kanda_number' || c == 'kandanumber' || c == 'kanda number' || c == 'parva' || c == 'parva_number' || c == 'chapter' || c == 'chapter_number' || c == 'chapternumber' || c == 'chapter number') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'sarga' || c == 'sarg' || c == 'sarga_number' || c == 'sarganumber' || c == 'sarga number' || c == 'section' || c == 'section_number' || c == 'adhyaya') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'verse' || c == 'shlok' || c == 'shloka' || c == 'verse_number' || c == 'versenumber' || c == 'verse number' || c == 'shlok_number' || c == 'shloka_number' || c == 'shlok number' || c == 'shloka number' || c == 'verse_no') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'sanskrit' || c == 'sanskrit_shloka' || c == 'sanskrit shloka' || c == 'sanskrit_text' || c == 'sanskrit text' || c == 'shloka_text' || c == 'sloka' || c == 'sloka_text' || c == 'passage' || c == 'verse_text') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'english' || c == 'hindi' || c == 'gujarati' || c == 'translation' || c == 'english_translation' || c == 'english translation' || c == 'english_meaning' || c == 'english meaning' || c == 'hindi_translation' || c == 'hindi translation' || c == 'hindi_meaning' || c == 'hindi meaning' || c == 'gujarati_translation' || c == 'gujarati translation' || c == 'gujarati_meaning' || c == 'gujarati meaning') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'source_url' || c == 'source' || c == 'url' || c == 'qa_status' || c == 'status' || c == 'notes' || c == 'explanation') {
        matches++;
      }
    }

    return matches >= 2 && (hasKandaOrSargaOrVerse || hasSanskritOrTranslationOrId);
  }

  String _extractMetadataSourceUrl(List<List<dynamic>> rows) {
    for (final row in rows) {
      for (final cell in row) {
        final cellStr = _extractCellStr(cell);
        if (cellStr.contains('http://') || cellStr.contains('https://')) {
          final match = RegExp(r'https?://[^\s,]+').firstMatch(cellStr);
          if (match != null) {
            final g0 = match.group(0);
            if (g0 != null && g0.isNotEmpty) {
              return g0;
            }
          }
        }
      }
    }
    return '';
  }

  int _findHeaderIdx(List<String> headers, List<String> candidates) {
    for (final candidate in candidates) {
      for (int i = 0; i < headers.length; i++) {
        final h = headers[i].trim().toLowerCase();
        if (h == candidate || h == '${candidate}_id' || h == '${candidate}_name' || h == '${candidate}_number') return i;
      }
    }
    for (final candidate in candidates) {
      if (candidate.length <= 2) continue; // skip short candidates for substring matching
      for (int i = 0; i < headers.length; i++) {
        final h = headers[i].trim().toLowerCase();
        if (h.contains(candidate)) return i;
      }
    }
    return -1;
  }
}
