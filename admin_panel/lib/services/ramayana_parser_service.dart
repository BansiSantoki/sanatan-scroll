import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:excel/excel.dart';

/// Centralized safe cell accessor with bounds checking
dynamic getCellSafely(List<dynamic> row, int index) {
  if (index < 0 || index >= row.length) {
    return null;
  }
  return row[index];
}

String _unescapeHtmlEntities(String input) {
  if (!input.contains('&#')) return input;
  return input.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
    final code = int.tryParse(match.group(1) ?? '');
    if (code != null) {
      return String.fromCharCode(code);
    }
    return match.group(0)!;
  }).replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (match) {
    final code = int.tryParse(match.group(1) ?? '', radix: 16);
    if (code != null) {
      return String.fromCharCode(code);
    }
    return match.group(0)!;
  });
}

/// Safe string converter for Excel cells and dynamic values
String? safeString(dynamic value) {
  if (value == null) return null;

  String text = '';
  if (value is String) {
    text = value.trim();
  } else {
    text = value.toString().trim();
  }

  if (text.startsWith('\uFEFF')) {
    text = text.substring(1).trim();
  }

  if (text.startsWith('TextCellValue(') && text.endsWith(')')) {
    text = text.substring(14, text.length - 1).trim();
  }

  if (text.contains('&#')) {
    text = _unescapeHtmlEntities(text);
  }

  return text.isEmpty ? null : text;
}

/// Safe integer converter for Excel cells, numbers, and dynamic values
int? safeInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();

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

/// Header normalization function
String normalizeHeader(dynamic value) {
  if (value == null) return '';
  String text = value.toString().trim();
  if (text.startsWith('\uFEFF')) {
    text = text.substring(1).trim();
  }
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[\s\-_]+'), '_');
}

/// High-performance, production-safe OpenXML / XLSX Spreadsheet Decoder
class SafeXlsxReader {
  static Map<String, List<List<dynamic>>> decodeSheets(List<int> bytes) {
    final Map<String, List<List<dynamic>>> sheetsMap = {};

    try {
      final archive = ZipDecoder().decodeBytes(bytes);

      // 1. Extract shared strings if xl/sharedStrings.xml exists
      final List<String> sharedStrings = [];
      final sharedStringsFile = archive.findFile('xl/sharedStrings.xml');
      if (sharedStringsFile != null) {
        final xmlStr = utf8.decode(sharedStringsFile.content as List<int>);
        final matches = RegExp(r'<(?:\w+:)?t[^>]*>(.*?)</(?:\w+:)?t>', dotAll: true).allMatches(xmlStr);
        for (final m in matches) {
          final str = _unescapeXml(m.group(1) ?? '');
          sharedStrings.add(str);
        }
      }

      // 2. Parse workbook.xml to map rId to Sheet Name
      final Map<String, String> ridToSheetName = {};
      final workbookFile = archive.findFile('xl/workbook.xml');
      if (workbookFile != null) {
        final wbXml = utf8.decode(workbookFile.content as List<int>);
        final sheetMatches = RegExp(r'<(?:\w+:)?sheet\s+[^>]*name="([^"]+)"[^>]*r:id="([^"]+)"|<(?:\w+:)?sheet\s+[^>]*r:id="([^"]+)"[^>]*name="([^"]+)"').allMatches(wbXml);
        for (final m in sheetMatches) {
          final name = m.group(1) ?? m.group(4);
          final rid = m.group(2) ?? m.group(3);
          if (name != null && rid != null) {
            ridToSheetName[rid] = name;
          }
        }
      }

      // 3. Parse workbook.xml.rels to map rId to Target File Path
      final Map<String, String> ridToTarget = {};
      final relsFile = archive.findFile('xl/_rels/workbook.xml.rels');
      if (relsFile != null) {
        final relsXml = utf8.decode(relsFile.content as List<int>);
        final relMatches = RegExp(r'<(?:\w+:)?Relationship\s+[^>]*Id="([^"]+)"[^>]*Target="([^"]+)"|<(?:\w+:)?Relationship\s+[^>]*Target="([^"]+)"[^>]*Id="([^"]+)"').allMatches(relsXml);
        for (final m in relMatches) {
          final id = m.group(1) ?? m.group(4);
          final target = m.group(2) ?? m.group(3);
          if (id != null && target != null) {
            final cleanTarget = target.startsWith('/') ? target.substring(1) : (target.startsWith('xl/') ? target : 'xl/$target');
            ridToTarget[id] = cleanTarget;
          }
        }
      }

      // 4. Decode worksheets
      final sheetFiles = archive.files.where((f) => f.name.startsWith('xl/worksheets/') && f.name.endsWith('.xml')).toList();
      sheetFiles.sort((a, b) => a.name.compareTo(b.name));

      for (final sheetFile in sheetFiles) {
        String sheetName = sheetFile.name.replaceAll('xl/worksheets/', '').replaceAll('.xml', '');
        // Find matching sheet name from relationships if available
        for (final entry in ridToTarget.entries) {
          if (entry.value == sheetFile.name || entry.value.endsWith(sheetFile.name)) {
            final mappedName = ridToSheetName[entry.key];
            if (mappedName != null && mappedName.isNotEmpty) {
              sheetName = mappedName;
              break;
            }
          }
        }

        final xmlStr = utf8.decode(sheetFile.content as List<int>);
        final rows = _parseWorksheetXml(xmlStr, sharedStrings);
        sheetsMap[sheetName] = rows;
      }
    } catch (e) {
      print('[SAFE XLSX READER ERROR]: $e');
    }

    return sheetsMap;
  }

  static List<List<dynamic>> _parseWorksheetXml(String xmlStr, List<String> sharedStrings) {
    final List<List<dynamic>> resultRows = [];
    final rowRegExp = RegExp(r'<(?:\w+:)?row[^>]*>(.*?)</(?:\w+:)?row>', dotAll: true);
    final rowMatches = rowRegExp.allMatches(xmlStr);

    for (final rowMatch in rowMatches) {
      final rowContent = rowMatch.group(1) ?? '';
      final Map<int, dynamic> colMap = {};
      int maxColIdx = 0;

      final cellRegExp = RegExp(r'<(?:\w+:)?c\s+([^>]*?)>(.*?)</(?:\w+:)?c>|<(?:\w+:)?c\s+([^>]*?)/>', dotAll: true);
      final cellMatches = cellRegExp.allMatches(rowContent);

      for (final cellMatch in cellMatches) {
        final attrStr = (cellMatch.group(1) ?? cellMatch.group(3) ?? '');
        final innerStr = (cellMatch.group(2) ?? '');

        final refMatch = RegExp(r'r="([A-Z]+)(\d+)"').firstMatch(attrStr);
        int colIdx = -1;
        if (refMatch != null) {
          colIdx = _colLetterToNumber(refMatch.group(1)!);
        } else {
          colIdx = maxColIdx;
        }

        if (colIdx > maxColIdx) maxColIdx = colIdx;

        final typeMatch = RegExp(r't="([^"]+)"').firstMatch(attrStr);
        final type = typeMatch?.group(1);

        dynamic val;
        if (type == 's') {
          final vMatch = RegExp(r'<(?:\w+:)?v>(.*?)</(?:\w+:)?v>', dotAll: true).firstMatch(innerStr);
          if (vMatch != null) {
            final sIdx = int.tryParse(vMatch.group(1) ?? '');
            if (sIdx != null && sIdx >= 0 && sIdx < sharedStrings.length) {
              val = sharedStrings[sIdx];
            }
          }
        } else if (type == 'inlineStr' || type == 'str') {
          final vMatch = RegExp(r'<(?:\w+:)?v>(.*?)</(?:\w+:)?v>', dotAll: true).firstMatch(innerStr);
          if (vMatch != null) {
            val = _unescapeXml(vMatch.group(1) ?? '');
          } else {
            final tMatch = RegExp(r'<(?:\w+:)?t[^>]*>(.*?)</(?:\w+:)?t>', dotAll: true).firstMatch(innerStr);
            if (tMatch != null) {
              val = _unescapeXml(tMatch.group(1) ?? '');
            }
          }
        } else if (type == 'b') {
          final vMatch = RegExp(r'<(?:\w+:)?v>(.*?)</(?:\w+:)?v>', dotAll: true).firstMatch(innerStr);
          val = vMatch?.group(1) == '1';
        } else {
          final vMatch = RegExp(r'<(?:\w+:)?v>(.*?)</(?:\w+:)?v>', dotAll: true).firstMatch(innerStr);
          if (vMatch != null) {
            val = _unescapeXml(vMatch.group(1) ?? '');
          } else {
            final tMatch = RegExp(r'<(?:\w+:)?t[^>]*>(.*?)</(?:\w+:)?t>', dotAll: true).firstMatch(innerStr);
            if (tMatch != null) {
              val = _unescapeXml(tMatch.group(1) ?? '');
            }
          }
        }

        colMap[colIdx] = val ?? '';
      }

      if (colMap.isNotEmpty) {
        final List<dynamic> rowList = List.generate(maxColIdx + 1, (i) => colMap[i] ?? '');
        resultRows.add(rowList);
      }
    }

    return resultRows;
  }

  static int _colLetterToNumber(String letter) {
    int sum = 0;
    for (int i = 0; i < letter.length; i++) {
      sum *= 26;
      sum += (letter.codeUnitAt(i) - 64);
    }
    return sum - 1;
  }

  static String _unescapeXml(String input) {
    return input
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&');
  }
}

class RamayanaParsedRow {
  final int fileRowNumber;
  final String rawId;
  final String verseId;
  final String bookId;
  final String bookName;
  final int kandaNumber;
  final int sargaNumber;
  final int verseNumber;
  final String sanskrit;
  final String? english;
  final String? hindi;
  final String? gujarati;
  final String? explanation;
  final String? sourceUrl;
  final String? sourceName;
  final String? qaStatus;
  final String? notes;
  final String importMode; // 'full_master' or 'translation_update'
  final String canonicalRef;

  String action; // 'new', 'update', 'skip', 'error'
  List<String> validationErrors;
  List<String> affectedColumns;
  bool isDuplicateInFile;

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
    this.english,
    this.hindi,
    this.gujarati,
    this.explanation,
    this.sourceUrl,
    this.sourceName,
    this.qaStatus,
    this.notes,
    this.importMode = 'full_master',
    this.canonicalRef = '',
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
  final int headerRowNumber;
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
  final String selectedSheetName;
  final String importMode; // 'full_master' or 'translation_update'

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
    required this.selectedSheetName,
    this.importMode = 'full_master',
  });
}

class RamayanaParserService {
  static final RegExp _idRegex = RegExp(r'^([A-Za-z0-9]+)-(\d+)-(\d+)(?:-(\d+))?(?:-\d+)*$');

  static final List<String> _ignoredSheetKeywords = [
    'readme',
    'instruction',
    'instructions',
    'doc',
    'documentation',
    'notes',
    'metadata',
  ];

  static Map<String, List<List<dynamic>>> parseXlsxSheets(Uint8List bytes) {
    Map<String, List<List<dynamic>>> sheetsMap = {};

    try {
      final excel = Excel.decodeBytes(bytes);
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        final List<List<dynamic>> sheetRows = [];
        for (final row in sheet.rows) {
          final List<dynamic> rowValues = [];
          for (final cell in row) {
            if (cell == null || cell.value == null) {
              rowValues.add(null);
            } else {
              rowValues.add(_extractCellValue(cell.value));
            }
          }
          sheetRows.add(rowValues);
        }
        if (sheetRows.any((r) => r.any((v) => v != null && v.toString().trim().isNotEmpty))) {
          sheetsMap[table] = sheetRows;
        }
      }
    } catch (e) {
      print('[EXCEL DECODE PACKAGE ERROR]: $e');
    }

    if (sheetsMap.isEmpty) {
      try {
        sheetsMap = SafeXlsxReader.decodeSheets(bytes);
      } catch (e) {
        print('[SAFE XLSX READER ERROR]: $e');
      }
    }

    return sheetsMap;
  }

  static dynamic _extractCellValue(dynamic val) {
    if (val == null) return null;

    try {
      if (val is TextCellValue) {
        final v = val.value;
        if (v == null) return null;
        if (v is String) return v;
        try {
          final dynamic dynV = v;
          if (dynV.text != null && dynV.text.toString().isNotEmpty) {
            return dynV.text.toString();
          }
          if (dynV.raw != null && dynV.raw.toString().isNotEmpty) {
            return dynV.raw.toString();
          }
          if (dynV.value != null && dynV.value.toString().isNotEmpty) {
            return dynV.value.toString();
          }
        } catch (_) {}
        return v.toString();
      } else if (val is IntCellValue) {
        return val.value;
      } else if (val is DoubleCellValue) {
        return val.value;
      } else if (val is BoolCellValue) {
        return val.value;
      } else if (val is DateCellValue) {
        return val.toString();
      } else if (val is TimeCellValue) {
        return val.toString();
      }
    } catch (_) {}

    final str = val.toString().trim();
    if (str.startsWith('TextCellValue(') && str.endsWith(')')) {
      return str.substring(14, str.length - 1).trim();
    }
    if (str.startsWith('IntCellValue(') && str.endsWith(')')) {
      return int.tryParse(str.substring(13, str.length - 1).trim()) ?? str;
    }
    return str;
  }

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

    final bool isZipHeader = bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B;
    final bool isCsvExt = extension == 'csv' || (!isZipHeader && (extension == 'txt' || extension.isEmpty));

    Map<String, List<List<dynamic>>> sheetsMap = {};

    if (isCsvExt && !isZipHeader) {
      try {
        final csvString = utf8.decode(bytes).replaceAll('\r\n', '\n').replaceAll('\r', '\n');
        final csvRows = const CsvToListConverter(eol: '\n').convert(csvString);
        sheetsMap['Sheet1'] = csvRows;
      } catch (e) {
        sheetsMap = parseXlsxSheets(bytes);
      }
    } else {
      sheetsMap = parseXlsxSheets(bytes);
    }

    if (sheetsMap.isEmpty) {
      throw Exception("Unable to read Excel / CSV file. Please verify that the file is a valid .xlsx or .csv document.");
    }

    // Multi-sheet and Multi-row Header Candidate Scanner (Scans rows 0..50 in all sheets)
    String selectedSheetName = '';
    List<List<dynamic>> rawRows = [];
    int headerRowIdx = -1;

    int maxScore = 0;
    final Map<String, List<String>> sheetDiagnostics = {};

    // 1. First pass: Scan non-documentation sheets with content
    for (final entry in sheetsMap.entries) {
      final sName = entry.key;
      final sLower = sName.toLowerCase().trim();
      final rows = entry.value;

      final hasTextData = rows.any((r) => r.any((cell) => safeString(cell) != null && safeString(cell)!.isNotEmpty));
      if (!hasTextData) continue;

      if (sheetsMap.length > 1 && _ignoredSheetKeywords.any((kw) => sLower == kw || sLower.startsWith(kw))) {
        sheetDiagnostics[sName] = ['Ignored documentation sheet'];
        continue;
      }

      final scannedDetails = <String>[];
      for (int r = 0; r < rows.length && r < 50; r++) {
        final rowStr = rows[r].map((e) => normalizeHeader(e)).toList();
        final score = _calculateHeaderScore(rowStr);
        if (score > 0) {
          scannedDetails.add('Row ${r + 1}: Score $score (${rowStr.where((s) => s.isNotEmpty).take(5).join(', ')})');
          if (score > maxScore) {
            maxScore = score;
            selectedSheetName = sName;
            rawRows = rows;
            headerRowIdx = r;
          }
        }
      }
      if (scannedDetails.isEmpty) {
        sheetDiagnostics[sName] = ['Scanned first ${rows.length < 50 ? rows.length : 50} rows -> No matching header keywords'];
      } else {
        sheetDiagnostics[sName] = scannedDetails;
      }
    }

    // 2. Second pass: Fallback to all sheets if no candidate found yet
    if (headerRowIdx == -1) {
      for (final entry in sheetsMap.entries) {
        final sName = entry.key;
        final rows = entry.value;
        for (int r = 0; r < rows.length && r < 50; r++) {
          final rowStr = rows[r].map((e) => normalizeHeader(e)).toList();
          final score = _calculateHeaderScore(rowStr);
          if (score > 0 && score > maxScore) {
            maxScore = score;
            selectedSheetName = sName;
            rawRows = rows;
            headerRowIdx = r;
          }
        }
      }
    }

    // 3. Ultimate Fallback: Select first non-empty sheet and row 0
    if (headerRowIdx == -1 && sheetsMap.isNotEmpty) {
      for (final entry in sheetsMap.entries) {
        final rows = entry.value;
        for (int r = 0; r < rows.length && r < 10; r++) {
          final nonEmptyCount = rows[r].where((e) => safeString(e) != null && safeString(e)!.isNotEmpty).length;
          if (nonEmptyCount >= 2) {
            selectedSheetName = entry.key;
            rawRows = rows;
            headerRowIdx = r;
            break;
          }
        }
        if (headerRowIdx != -1) break;
      }
    }

    if (rawRows.isEmpty || headerRowIdx == -1) {
      final diagBuffer = StringBuffer();
      diagBuffer.writeln("Could not detect usable import headers in any sheet of this file.");
      diagBuffer.writeln();
      diagBuffer.writeln("Workbook Diagnostic Report:");
      diagBuffer.writeln("• File Name: ${file.name}");
      diagBuffer.writeln("• Sheets Found: ${sheetsMap.keys.toList()}");
      for (final diag in sheetDiagnostics.entries) {
        diagBuffer.writeln("  - Sheet '${diag.key}': ${diag.value.join('; ')}");
      }
      diagBuffer.writeln();
      diagBuffer.writeln("Please verify that your file contains column headers like passage_id, kanda_name, sarga_no, shlok_no, sanskrit, or english.");
      throw Exception(diagBuffer.toString());
    }

    print('[IMPORT DEBUG] File: ${file.name}, Extension: $extension, Size: ${file.size} bytes');
    print('[IMPORT DEBUG] Sheets in workbook: ${sheetsMap.keys.toList()}');
    print('[IMPORT DEBUG] Selected Sheet: $selectedSheetName');
    print('[IMPORT DEBUG] Header Row Index: ${headerRowIdx + 1}');

    String defaultSourceUrl = _extractMetadataSourceUrl(rawRows.sublist(0, headerRowIdx + 1));
    if (defaultSourceUrl.isEmpty) {
      defaultSourceUrl = _resolveDefaultSourceUrl(activeBookId);
    }

    final metadataRowsSkipped = headerRowIdx;
    final headerRowCells = rawRows[headerRowIdx].map((e) => safeString(e) ?? '').toList();
    final normalizedHeaders = headerRowCells.map((e) => normalizeHeader(e)).toList();

    print('[IMPORT DEBUG] Detected headers: $headerRowCells');
    print('[IMPORT DEBUG] Normalized headers: $normalizedHeaders');

    // Flexible Column Mapping using normalized header names & aliases
    final idIdx = _findHeaderIdx(normalizedHeaders, ['id', 'passage_id', 'passageid', 'verse_id', 'shlok_id', 'shloka_id', 'code', 'ram_id', 'mah_id', 'git_id', 'upn_id']);
    final canonicalRefIdx = _findHeaderIdx(normalizedHeaders, ['canonical_reference', 'canonical_ref', 'reference', 'ref', 'verse_reference']);
    final bookIdIdx = _findHeaderIdx(normalizedHeaders, ['book_id', 'bookid', 'book', 'book_code', 'sacred_book']);
    final bookNameIdx = _findHeaderIdx(normalizedHeaders, ['book_name', 'bookname', 'book_title', 'title']);
    final kandaIdx = _findHeaderIdx(normalizedHeaders, ['kanda_number', 'kandanumber', 'kanda_name', 'kanda', 'kand', 'kanda_no', 'kandam', 'parva', 'parva_number', 'chapter_number', 'chapternumber', 'chapter']);
    final sargaIdx = _findHeaderIdx(normalizedHeaders, ['sarga_number', 'sarganumber', 'sarga', 'sarg', 'sarga_no', 'sarga_num', 'section_number', 'sectionnumber', 'section', 'adhyaya']);
    final verseIdx = _findHeaderIdx(normalizedHeaders, ['verse_number', 'versenumber', 'verse', 'shlok_number', 'shloka_number', 'shlok_no', 'shloka_no', 'shlok', 'shloka', 'verse_no']);
    final sanskritIdx = _findHeaderIdx(normalizedHeaders, ['sanskrit', 'sanskrit_shloka', 'sanskrit_text', 'shloka_text', 'sloka', 'original_sanskrit', 'sanskrit_passage']);
    int englishIdx = _findHeaderIdx(normalizedHeaders, [
      'english', 'english_translation', 'english_meaning', 'translation_en', 'en', 'eng',
      'english_shloka_meaning', 'english_shlok_meaning', 'translation_english', 'meaning_english',
      'english_text', 'valmiki_ramayana_english', 'valmiki_english', 'english_summary', 'eng_meaning',
      'eng_translation'
    ]);
    int hindiIdx = _findHeaderIdx(normalizedHeaders, [
      'hindi', 'hindi_translation', 'hindi_meaning', 'translation_hi', 'hi', 'hin',
      'hindi_shloka_meaning', 'hindi_shlok_meaning', 'translation_hindi', 'meaning_hindi',
      'hindi_text', 'hin_meaning', 'hin_translation'
    ]);
    int gujaratiIdx = _findHeaderIdx(normalizedHeaders, [
      'gujarati', 'gujarati_translation', 'gujarati_meaning', 'translation_gu', 'gu', 'guj',
      'gujarati_shloka_meaning', 'gujarati_shlok_meaning', 'translation_gujarati', 'meaning_gujarati',
      'gujarati_text', 'guj_meaning', 'guj_translation'
    ]);

    // Fallback: If no explicit english/hindi/gujarati header found, check for generic 'translation' or 'meaning' column
    if (englishIdx == -1 && hindiIdx == -1 && gujaratiIdx == -1) {
      final genericIdx = _findHeaderIdx(normalizedHeaders, ['translation', 'meaning', 'shloka_meaning', 'shlok_meaning', 'summary']);
      if (genericIdx != -1) {
        englishIdx = genericIdx;
      }
    }

    final explanationIdx = _findHeaderIdx(normalizedHeaders, ['explanation', 'purport', 'commentary']);
    final sourceUrlIdx = _findHeaderIdx(normalizedHeaders, ['source_url', 'sourceurl', 'source', 'url', 'link']);
    final sourceNameIdx = _findHeaderIdx(normalizedHeaders, ['source_name', 'sourcename']);
    final qaStatusIdx = _findHeaderIdx(normalizedHeaders, ['qa_status', 'qastatus', 'qa', 'status', 'review_status']);
    final notesIdx = _findHeaderIdx(normalizedHeaders, ['notes', 'comment', 'remarks', 'note']);

    final bool hasStructureOrSanskrit = (kandaIdx != -1 || sargaIdx != -1 || verseIdx != -1 || sanskritIdx != -1);
    final bool hasIdOrRef = (idIdx != -1 || canonicalRefIdx != -1);
    final bool hasAnyTranslation = (englishIdx != -1 || hindiIdx != -1 || gujaratiIdx != -1);

    final String fileImportMode = (!hasStructureOrSanskrit && hasIdOrRef && hasAnyTranslation)
        ? 'translation_update'
        : 'full_master';

    final detectedMappings = <String, String>{};
    detectedMappings['Import Mode'] = fileImportMode == 'translation_update' ? 'Translation Update Mode' : 'Full Master Mode';
    if (idIdx != -1) detectedMappings['ID / Verse ID'] = headerRowCells[idIdx];
    if (canonicalRefIdx != -1) detectedMappings['Canonical Reference'] = headerRowCells[canonicalRefIdx];
    if (kandaIdx != -1) detectedMappings['Chapter / Kanda / Parva'] = headerRowCells[kandaIdx];
    if (sargaIdx != -1) detectedMappings['Section / Sarga / Adhyaya'] = headerRowCells[sargaIdx];
    if (verseIdx != -1) detectedMappings['Verse / Shlok'] = headerRowCells[verseIdx];
    if (sanskritIdx != -1) detectedMappings['Sanskrit'] = headerRowCells[sanskritIdx];
    if (englishIdx != -1) detectedMappings['English'] = headerRowCells[englishIdx];
    if (hindiIdx != -1) detectedMappings['Hindi'] = headerRowCells[hindiIdx];
    if (gujaratiIdx != -1) detectedMappings['Gujarati'] = headerRowCells[gujaratiIdx];

    print('[IMPORT DEBUG] File Import Mode: $fileImportMode');
    print('[IMPORT DEBUG] Column mapping: $detectedMappings');

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

    int skippedRowsAfterHeader = 0;

    // Parse Data Rows starting after headerRowIdx
    for (int i = headerRowIdx + 1; i < rawRows.length; i++) {
      final row = rawRows[i];

      // Safe row cell retrieval
      dynamic getCell(int idx) => getCellSafely(row, idx);

      final rawId = safeString(getCell(idIdx)) ?? '';
      final canonicalRefStr = safeString(getCell(canonicalRefIdx)) ?? '';
      final rawBook = safeString(getCell(bookIdIdx)) ?? '';
      final rawBookNameCol = safeString(getCell(bookNameIdx)) ?? '';
      final rawKanda = getCell(kandaIdx);
      final rawSarga = getCell(sargaIdx);
      final rawVerse = getCell(verseIdx);
      final sanskritText = safeString(getCell(sanskritIdx)) ?? '';
      final englishText = safeString(getCell(englishIdx));
      final hindiText = safeString(getCell(hindiIdx));
      final gujaratiText = safeString(getCell(gujaratiIdx));
      final explanationText = safeString(getCell(explanationIdx));
      final sourceUrlVal = safeString(getCell(sourceUrlIdx)) ?? defaultSourceUrl;
      final sourceNameVal = safeString(getCell(sourceNameIdx)) ?? '$activeBookName Source';
      final rawQaStatus = safeString(getCell(qaStatusIdx)) ?? 'Approved';
      final notesText = safeString(getCell(notesIdx));

      int colKanda = safeInt(rawKanda) ?? -1;
      if (colKanda <= 0 && rawKanda != null) {
        final strKanda = safeString(rawKanda)?.toLowerCase() ?? '';
        if (strKanda.contains('bala')) colKanda = 1;
        else if (strKanda.contains('ayodhya')) colKanda = 2;
        else if (strKanda.contains('aranya')) colKanda = 3;
        else if (strKanda.contains('kishkindha')) colKanda = 4;
        else if (strKanda.contains('sundara')) colKanda = 5;
        else if (strKanda.contains('yuddha') || strKanda.contains('lanka')) colKanda = 6;
        else if (strKanda.contains('uttara')) colKanda = 7;
      }
      final colSarga = safeInt(rawSarga) ?? -1;
      final colVerse = safeInt(rawVerse) ?? -1;

      // Completely empty row check (handles null and empty string cells safely)
      if (rawId.isEmpty && canonicalRefStr.isEmpty && sanskritText.isEmpty && colKanda <= 0 && colSarga <= 0 && colVerse <= 0 && (englishText == null || englishText.isEmpty) && (hindiText == null || hindiText.isEmpty) && (gujaratiText == null || gujaratiText.isEmpty)) {
        skippedRowsAfterHeader++;
        continue;
      }

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
              parsedKanda = int.tryParse(g2) ?? -1;
              parsedSarga = int.tryParse(g3) ?? -1;
              parsedVerse = int.tryParse(g4) ?? -1;
              idParsedSuccess = (parsedKanda > 0 && parsedSarga > 0 && parsedVerse > 0);
            } else {
              parsedKanda = int.tryParse(g2) ?? -1;
              parsedSarga = 1;
              parsedVerse = int.tryParse(g3) ?? -1;
              idParsedSuccess = (parsedKanda > 0 && parsedVerse > 0);
            }
          }
        }
      }

      // Fallback: Parse canonicalRef (e.g. "1.2.15" or "1.15") if Kanda/Sarga/Verse not set
      if (parsedKanda <= 0 && canonicalRefStr.isNotEmpty) {
        final parts = canonicalRefStr.split(RegExp(r'[\.\-\/\:]')).map((s) => int.tryParse(s.trim()) ?? -1).where((n) => n > 0).toList();
        if (parts.length >= 3) {
          parsedKanda = parts[0];
          parsedSarga = parts[1];
          parsedVerse = parts[2];
        } else if (parts.length == 2) {
          parsedKanda = parts[0];
          parsedSarga = 1;
          parsedVerse = parts[1];
        }
      }

      int finalKanda = colKanda > 0 ? colKanda : parsedKanda;
      int finalSarga = colSarga > 0 ? colSarga : parsedSarga;
      int finalVerse = colVerse > 0 ? colVerse : parsedVerse;

      if ((activeBookId == 'bhagavad_gita' || activeBookId == 'upanishads') && finalSarga <= 0) {
        finalSarga = 1;
      }

      // Print MANDATORY debug info for each row
      print('[IMPORT DEBUG] row ${i + 1} | mode: $fileImportMode | id: $rawId | ref: $canonicalRefStr | kanda: $finalKanda | sarga: $finalSarga | verse: $finalVerse | sanskrit present: ${sanskritText.isNotEmpty} | english present: ${englishText != null} | hindi present: ${hindiText != null} | gujarati present: ${gujaratiText != null}');

      String qaStatus = 'Approved';
      final qaLower = rawQaStatus.toLowerCase();
      if (qaLower.contains('draft')) {
        qaStatus = 'Draft';
      } else if (qaLower.contains('review')) {
        qaStatus = 'Review';
      } else if (qaLower.contains('reject')) {
        qaStatus = 'Rejected';
      } else if (qaLower.contains('approve') || qaLower.contains('publish')) {
        qaStatus = 'Approved';
      }
      qaStatusCounts[qaStatus] = (qaStatusCounts[qaStatus] ?? 0) + 1;

      final errors = <String>[];
      final affectedCols = <String>[];

      final bool hasSanskrit = sanskritText.isNotEmpty;
      final bool hasEnglish = englishText != null && englishText.trim().isNotEmpty;
      final bool hasHindi = hindiText != null && hindiText.trim().isNotEmpty;
      final bool hasGujarati = gujaratiText != null && gujaratiText.trim().isNotEmpty;

      if (fileImportMode == 'translation_update') {
        // Translation Update Mode Requirements
        if (rawId.isEmpty && canonicalRefStr.isEmpty && (finalKanda <= 0 || finalVerse <= 0)) {
          errors.add("Missing required verse identifier (passage_id or canonical_reference)");
          affectedCols.add("Verse Reference");
        }
        if (!hasEnglish && !hasHindi && !hasGujarati) {
          errors.add("Must provide at least one non-empty translation (English, Hindi, or Gujarati)");
          affectedCols.add("Translations");
          missingTranslationsCount++;
        }
        if (finalKanda > 0) detectedKandasSet.add(finalKanda);
        if (finalKanda > 0 && finalSarga > 0) detectedSargasSet.add('K${finalKanda}_S$finalSarga');
      } else {
        // Full Master Mode Requirements
        if (idParsedSuccess && colKanda > 0 && parsedKanda != colKanda) {
          errors.add("ID Kanda value conflicts with explicit Kanda value (ID: $parsedKanda vs Col: $colKanda)");
          affectedCols.add("Chapter / Kanda");
        }
        if (idParsedSuccess && colSarga > 0 && parsedSarga > 0 && parsedSarga != colSarga) {
          errors.add("ID Sarga value conflicts with explicit Sarga value (ID: $parsedSarga vs Col: $colSarga)");
          affectedCols.add("Section / Sarga");
        }
        if (idParsedSuccess && colVerse > 0 && parsedVerse != colVerse) {
          errors.add("ID Verse value conflicts with explicit Verse value (ID: $parsedVerse vs Col: $colVerse)");
          affectedCols.add("Verse");
        }

        if (finalKanda <= 0) {
          final term = _resolveChapterTerm(activeBookId);
          errors.add("Missing or invalid $term number");
          affectedCols.add(term);
          missingChapterInfoCount++;
        } else {
          detectedKandasSet.add(finalKanda);
        }

        if (finalSarga <= 0 && activeBookId == 'ramayana') {
          errors.add("Missing or invalid Sarga number");
          affectedCols.add("Sarga");
          missingChapterInfoCount++;
        }

        if (finalKanda > 0 && finalSarga > 0) {
          detectedSargasSet.add('K${finalKanda}_S$finalSarga');
        }

        if (finalVerse <= 0) {
          errors.add("Missing or invalid Verse number");
          affectedCols.add("Verse");
          missingVerseNumCount++;
        }

        if (!hasSanskrit) {
          missingSanskritCount++;
        }

        if (!hasEnglish && !hasHindi && !hasGujarati) {
          missingTranslationsCount++;
          if (!hasSanskrit) {
            errors.add("Missing required content: must provide Sanskrit shloka text or translation");
            affectedCols.add("Content");
          }
        }
      }

      // Canonical verse ID generation
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
      } else if (rawId.isNotEmpty) {
        canonicalVerseId = rawId.toUpperCase();
      } else if (canonicalRefStr.isNotEmpty) {
        canonicalVerseId = canonicalRefStr;
      } else {
        canonicalVerseId = 'Row ${i + 1}';
      }

      final bool isDup = canonicalVerseId.contains('-') &&
          !canonicalVerseId.contains('00-000-000') &&
          seenIdsInFile.containsKey(canonicalVerseId);

      if (isDup) {
        errors.add("Duplicate canonical ID in sheet: $canonicalVerseId (first seen at row ${seenIdsInFile[canonicalVerseId]})");
        affectedCols.add("ID");
      } else if (canonicalVerseId.contains('-')) {
        seenIdsInFile[canonicalVerseId] = i + 1;
      }

      final rowBookName = rawBookNameCol.isNotEmpty
          ? rawBookNameCol
          : rawBook.isNotEmpty
              ? rawBook
              : activeBookName;

      final parsedRow = RamayanaParsedRow(
        fileRowNumber: i + 1,
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
        importMode: fileImportMode,
        canonicalRef: canonicalRefStr,
        action: errors.isNotEmpty ? 'error' : 'new',
        validationErrors: errors,
        affectedColumns: affectedCols,
        isDuplicateInFile: isDup,
      );

      parsedRows.add(parsedRow);
    }

    if (parsedRows.isEmpty) {
      throw Exception("No valid content rows were detected in sheet '$selectedSheetName'.");
    }

    final validCount = parsedRows.where((r) => r.isValid).length;
    final invalidCount = parsedRows.where((r) => !r.isValid).length;
    final dupCount = parsedRows.where((r) => r.isDuplicateInFile).length;
    final sortedKandas = detectedKandasSet.toList()..sort();

    return RamayanaParseResult(
      rows: parsedRows,
      totalRawRowsInFile: rawRows.length,
      metadataRowsSkipped: metadataRowsSkipped + skippedRowsAfterHeader,
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
      selectedSheetName: selectedSheetName,
      importMode: fileImportMode,
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

  int _findContentHeaderRowIndex(List<List<dynamic>> rawRows) {
    for (int r = 0; r < rawRows.length && r < 100; r++) {
      final row = rawRows[r];
      if (row.isEmpty) continue;

      final rowStr = row.map((e) => normalizeHeader(e)).toList();
      if (_isContentHeaderRow(rowStr)) {
        return r;
      }
    }

    // Fallback: If no keyword header match, select first row with 2+ non-empty cells
    for (int r = 0; r < rawRows.length && r < 10; r++) {
      final row = rawRows[r];
      final nonEmptyCount = row.where((e) => safeString(e) != null && safeString(e)!.isNotEmpty).length;
      if (nonEmptyCount >= 2) {
        return r;
      }
    }

    return -1;
  }

  static int _calculateHeaderScore(List<String> rowCells) {
    if (rowCells.isEmpty) return 0;

    int score = 0;
    bool hasCoreField = false;

    for (final c in rowCells) {
      if (c.isEmpty) continue;

      if (c == 'id' || c == 'passage_id' || c == 'verse_id' || c == 'canonical_id' || c == 'canonical_reference' || c == 'shlok_id' || c == 'shloka_id' || c == 'code' || c == 'ram_id' || c == 'mah_id' || c == 'git_id' || c == 'upn_id' || c == 'ref' || c == 'reference') {
        score += 3;
        hasCoreField = true;
      } else if (c == 'kanda' || c == 'kand' || c == 'kanda_number' || c == 'kanda_name' || c == 'kanda_no' || c == 'kandam' || c == 'parva' || c == 'parva_number' || c == 'parva_name' || c == 'parva_no' || c == 'chapter' || c == 'chapter_number' || c == 'chapter_name' || c == 'chapter_no') {
        score += 2;
        hasCoreField = true;
      } else if (c == 'sarga' || c == 'sarg' || c == 'sarga_number' || c == 'sarga_no' || c == 'sarga_num' || c == 'section' || c == 'section_number' || c == 'section_name' || c == 'section_no' || c == 'adhyaya' || c == 'adhyaya_no') {
        score += 2;
        hasCoreField = true;
      } else if (c == 'verse' || c == 'shlok' || c == 'shloka' || c == 'verse_number' || c == 'verse_no' || c == 'shlok_number' || c == 'shloka_number' || c == 'shlok_no' || c == 'shloka_no' || c == 'shlok_num' || c == 'shloka_num') {
        score += 2;
        hasCoreField = true;
      } else if (c == 'sanskrit' || c == 'sanskrit_shloka' || c == 'sanskrit_text' || c == 'sanskrit_shlok' || c == 'shloka_text' || c == 'shlok_text' || c == 'sloka' || c == 'original_sanskrit' || c == 'passage' || c == 'text') {
        score += 3;
        hasCoreField = true;
      } else if (c == 'english' || c == 'hindi' || c == 'gujarati' || c == 'translation' || c == 'english_translation' || c == 'hindi_translation' || c == 'gujarati_translation' || c == 'english_meaning' || c == 'hindi_meaning' || c == 'gujarati_meaning' || c == 'translation_en' || c == 'translation_hi' || c == 'translation_gu' || c == 'en' || c == 'hi' || c == 'gu' || c == 'eng' || c == 'hin' || c == 'guj' || c == 'meaning_english' || c == 'meaning_hindi' || c == 'meaning_gujarati') {
        score += 2;
        hasCoreField = true;
      } else if (c == 'source_url' || c == 'sourceurl' || c == 'source' || c == 'url' || c == 'link' || c == 'qa_status' || c == 'qastatus' || c == 'qa' || c == 'status' || c == 'review_status' || c == 'notes' || c == 'comment' || c == 'remarks' || c == 'note' || c == 'explanation' || c == 'purport' || c == 'commentary' || c == 'book_id' || c == 'bookid' || c == 'book' || c == 'book_name' || c == 'bookname' || c == 'title') {
        score += 1;
      }
    }

    return hasCoreField ? score : 0;
  }

  bool _isContentHeaderRow(List<String> rowCells) {
    if (rowCells.isEmpty) return false;

    int matches = 0;
    bool hasKandaOrSargaOrVerse = false;
    bool hasSanskritOrTranslationOrId = false;

    for (final c in rowCells) {
      if (c == 'id' || c == 'passage_id' || c == 'verse_id' || c == 'canonical_id' || c == 'canonical_reference' || c == 'shlok_id' || c == 'shloka_id' || c == 'code' || c == 'ram_id' || c == 'mah_id' || c == 'git_id' || c == 'upn_id' || c == 'ref' || c == 'reference') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'kanda' || c == 'kand' || c == 'kanda_number' || c == 'kanda_name' || c == 'kanda_no' || c == 'kandam' || c == 'parva' || c == 'parva_number' || c == 'parva_name' || c == 'parva_no' || c == 'chapter' || c == 'chapter_number' || c == 'chapter_name' || c == 'chapter_no') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'sarga' || c == 'sarg' || c == 'sarga_number' || c == 'sarga_no' || c == 'sarga_num' || c == 'section' || c == 'section_number' || c == 'section_name' || c == 'section_no' || c == 'adhyaya' || c == 'adhyaya_no') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'verse' || c == 'shlok' || c == 'shloka' || c == 'verse_number' || c == 'verse_no' || c == 'shlok_number' || c == 'shloka_number' || c == 'shlok_no' || c == 'shloka_no' || c == 'shlok_num' || c == 'shloka_num') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'sanskrit' || c == 'sanskrit_shloka' || c == 'sanskrit_text' || c == 'sanskrit_shlok' || c == 'shloka_text' || c == 'shlok_text' || c == 'sloka' || c == 'original_sanskrit' || c == 'passage' || c == 'text') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'english' || c == 'hindi' || c == 'gujarati' || c == 'translation' || c == 'english_translation' || c == 'hindi_translation' || c == 'gujarati_translation' || c == 'english_meaning' || c == 'hindi_meaning' || c == 'gujarati_meaning' || c == 'translation_en' || c == 'translation_hi' || c == 'translation_gu' || c == 'en' || c == 'hi' || c == 'gu' || c == 'eng' || c == 'hin' || c == 'guj' || c == 'meaning_english' || c == 'meaning_hindi' || c == 'meaning_gujarati') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'source_url' || c == 'sourceurl' || c == 'source' || c == 'url' || c == 'link' || c == 'qa_status' || c == 'qastatus' || c == 'qa' || c == 'status' || c == 'review_status' || c == 'notes' || c == 'comment' || c == 'remarks' || c == 'note' || c == 'explanation' || c == 'purport' || c == 'commentary' || c == 'book_id' || c == 'bookid' || c == 'book' || c == 'book_name' || c == 'bookname' || c == 'title') {
        matches++;
      }
    }

    return matches >= 1 && (hasKandaOrSargaOrVerse || hasSanskritOrTranslationOrId);
  }

  String _extractMetadataSourceUrl(List<List<dynamic>> rows) {
    for (final row in rows) {
      for (final cell in row) {
        final cellStr = safeString(cell) ?? '';
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
      final normCand = normalizeHeader(candidate);
      for (int i = 0; i < headers.length; i++) {
        final h = headers[i];
        if (h == normCand || h == '${normCand}_id' || h == '${normCand}_name' || h == '${normCand}_number') return i;
      }
    }
    for (final candidate in candidates) {
      final normCand = normalizeHeader(candidate);
      if (normCand.length <= 2) continue;
      for (int i = 0; i < headers.length; i++) {
        if (headers[i].contains(normCand)) return i;
      }
    }
    return -1;
  }
}
