import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'ramayana_parser_service.dart';

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

/// Centralized safe CSV cell accessor with bounds checking
String? getCsvCell(List<dynamic> row, int index) {
  if (index < 0 || index >= row.length) {
    return null;
  }
  final value = row[index];
  if (value == null) {
    return null;
  }
  String text = value.toString().trim();
  if (text.startsWith('\uFEFF')) {
    text = text.substring(1).trim();
  }
  if (text.contains('&#')) {
    text = _unescapeHtmlEntities(text);
  }
  if (text.isEmpty) {
    return null;
  }
  return text;
}

/// Safe integer parser for optional fields
int? parseOptionalInt(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return int.tryParse(text);
}

/// Book-specific import configuration
class SacredBookImportConfig {
  final String bookId;
  final String bookName;
  final String defaultBookCode;
  final String defaultSourceUrl;
  final String primaryChapterTerm;
  final String secondarySectionTerm;
  final bool requiresSecondarySection;

  const SacredBookImportConfig({
    required this.bookId,
    required this.bookName,
    required this.defaultBookCode,
    required this.defaultSourceUrl,
    required this.primaryChapterTerm,
    required this.secondarySectionTerm,
    this.requiresSecondarySection = false,
  });

  static SacredBookImportConfig forBook(String bookId, [String? customName]) {
    final cleanId = bookId.toLowerCase().replaceAll(' ', '_');
    switch (cleanId) {
      case 'ramayana':
        return SacredBookImportConfig(
          bookId: 'ramayana',
          bookName: customName ?? 'Ramayana',
          defaultBookCode: 'RAM',
          defaultSourceUrl: 'https://ramayana.info/',
          primaryChapterTerm: 'Kanda',
          secondarySectionTerm: 'Sarga',
          requiresSecondarySection: true,
        );
      case 'mahabharata':
        return SacredBookImportConfig(
          bookId: 'mahabharata',
          bookName: customName ?? 'Mahabharata',
          defaultBookCode: 'MAH',
          defaultSourceUrl: 'https://mahabharata.info/',
          primaryChapterTerm: 'Parva',
          secondarySectionTerm: 'Section',
          requiresSecondarySection: true,
        );
      case 'bhagavad_gita':
        return SacredBookImportConfig(
          bookId: 'bhagavad_gita',
          bookName: customName ?? 'Bhagavad Gita',
          defaultBookCode: 'GIT',
          defaultSourceUrl: 'https://bhagavadgita.info/',
          primaryChapterTerm: 'Chapter',
          secondarySectionTerm: 'Section',
          requiresSecondarySection: false,
        );
      case 'upanishads':
        return SacredBookImportConfig(
          bookId: 'upanishads',
          bookName: customName ?? 'Upanishads',
          defaultBookCode: 'UPN',
          defaultSourceUrl: 'https://upanishads.info/',
          primaryChapterTerm: 'Chapter',
          secondarySectionTerm: 'Section',
          requiresSecondarySection: false,
        );
      default:
        final code = cleanId.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
        return SacredBookImportConfig(
          bookId: cleanId,
          bookName: customName ?? cleanId,
          defaultBookCode: code.length >= 3 ? code.substring(0, 3) : code.padRight(3, 'X'),
          defaultSourceUrl: 'https://sanatanscroll.info/',
          primaryChapterTerm: 'Chapter',
          secondarySectionTerm: 'Section',
          requiresSecondarySection: false,
        );
    }
  }
}

/// Flexible CSV Header Mapper
class CsvHeaderMapper {
  static const Map<String, List<String>> _aliases = {
    'id': [
      'id', 'passage_id', 'passageid', 'verse_id', 'shlok_id', 'shloka_id', 'code',
      'ram_id', 'mah_id', 'git_id', 'upn_id'
    ],
    'canonical_reference': [
      'canonical_reference', 'canonical_ref', 'canonical_id', 'reference',
      'verse_reference', 'ref'
    ],
    'book_id': ['book_id', 'book', 'book_code', 'sacred_book'],
    'book_name': ['book_name', 'title', 'book_title', 'bookname'],
    'kanda_number': ['kanda_number', 'kanda', 'kand', 'kanda_no', 'kanda_name', 'parva', 'parva_number', 'chapter_number', 'chapter'],
    'sarga_number': ['sarga_number', 'sarga', 'sarg', 'sarga_no', 'sarga_num', 'section_number', 'section', 'adhyaya'],
    'verse_number': ['verse_number', 'verse', 'shloka', 'shloka_number', 'shlok', 'shlok_number', 'shlok_no', 'shloka_no', 'verse_no'],
    'sanskrit': ['sanskrit', 'sanskrit_text', 'sanskrit_shloka', 'shloka_text', 'sloka', 'original_sanskrit', 'sanskrit_passage'],
    'english': [
      'english', 'english_meaning', 'english_translation', 'translation_en', 'en', 'eng',
      'english_shloka_meaning', 'english_shlok_meaning', 'translation_english', 'meaning_english',
      'english_text', 'valmiki_ramayana_english', 'valmiki_english', 'english_summary', 'eng_meaning',
      'eng_translation'
    ],
    'hindi': [
      'hindi', 'hindi_meaning', 'hindi_translation', 'translation_hi', 'hi', 'hin',
      'hindi_shloka_meaning', 'hindi_shlok_meaning', 'translation_hindi', 'meaning_hindi',
      'hindi_text', 'hin_meaning', 'hin_translation'
    ],
    'gujarati': [
      'gujarati', 'gujarati_meaning', 'gujarati_translation', 'translation_gu', 'gu', 'guj',
      'gujarati_shloka_meaning', 'gujarati_shlok_meaning', 'translation_gujarati', 'meaning_gujarati',
      'gujarati_text', 'guj_meaning', 'guj_translation'
    ],
    'explanation': ['explanation', 'purport', 'commentary'],
    'source_url': ['source_url', 'source', 'url', 'link'],
    'source_name': ['source_name', 'sourcename'],
    'status': ['status'],
    'qa_status': ['qa_status', 'qastatus', 'qa', 'review_status'],
    'notes': ['notes', 'comment', 'remarks', 'note'],
  };

  static Map<String, int> mapHeaders(List<String> normalizedHeaders) {
    final Map<String, int> mapping = {};
    for (final entry in _aliases.entries) {
      final fieldKey = entry.key;
      final aliasList = entry.value;

      for (final alias in aliasList) {
        final normAlias = normalizeHeader(alias);
        final idx = normalizedHeaders.indexOf(normAlias);
        if (idx != -1) {
          mapping[fieldKey] = idx;
          break;
        }
      }

      if (!mapping.containsKey(fieldKey)) {
        for (final alias in aliasList) {
          final normAlias = normalizeHeader(alias);
          if (normAlias.length <= 2) continue;
          final idx = normalizedHeaders.indexWhere((h) => h.contains(normAlias));
          if (idx != -1) {
            mapping[fieldKey] = idx;
            break;
          }
        }
      }
    }

    if (!mapping.containsKey('english') && !mapping.containsKey('hindi') && !mapping.containsKey('gujarati')) {
      for (int i = 0; i < normalizedHeaders.length; i++) {
        final h = normalizedHeaders[i];
        if (h.contains('translation') || h.contains('meaning') || h.contains('summary')) {
          mapping['english'] = i;
          break;
        }
      }
    }

    return mapping;
  }
}

/// CSV Importer Service for Sacred Books
class CsvImportService {
  static final RegExp _idRegex = RegExp(r'^([A-Za-z0-9]+)-(\d+)-(\d+)(?:-(\d+))?(?:-\d+)*$');

  Future<RamayanaParseResult> parseFile(
    PlatformFile file, {
    String? targetBookId,
    String? targetBookName,
  }) async {
    final Uint8List? bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw Exception("File is empty or could not be read.");
    }

    final ext = (file.extension ?? (file.name.contains('.') ? file.name.split('.').last : '')).toLowerCase();
    if (ext == 'xlsx' || ext == 'xls') {
      return RamayanaParserService().parseFile(file, targetBookId: targetBookId, targetBookName: targetBookName);
    }

    if (ext != 'csv') {
      throw Exception("Unsupported file type. Please upload a .csv or .xlsx file.");
    }

    // UTF-8 decoding with fallback for malformed bytes to preserve Devanagari, Gujarati, Special Unicode
    String csvString;
    try {
      csvString = utf8.decode(bytes).replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    } catch (_) {
      try {
        csvString = utf8.decode(bytes, allowMalformed: true).replaceAll('\r\n', '\n').replaceAll('\r', '\n');
      } catch (e) {
        csvString = String.fromCharCodes(bytes).replaceAll('\r\n', '\n').replaceAll('\r', '\n');
      }
    }

    if (csvString.startsWith('\uFEFF')) {
      csvString = csvString.substring(1);
    }

    final List<List<dynamic>> rawRows = const CsvToListConverter(eol: '\n').convert(csvString);

    if (rawRows.isEmpty) {
      throw Exception("CSV file contains no readable rows.");
    }

    final config = SacredBookImportConfig.forBook(targetBookId ?? 'ramayana', targetBookName);

    // Header detection
    int headerRowIdx = -1;
    for (int r = 0; r < rawRows.length && r < 50; r++) {
      final row = rawRows[r];
      if (row.isEmpty) continue;

      final normCells = row.map((c) => normalizeHeader(c)).toList();
      if (_isContentHeaderRow(normCells)) {
        headerRowIdx = r;
        break;
      }
    }

    if (headerRowIdx == -1) {
      throw Exception("Could not detect required headers in CSV file. Required headers include Chapter, Verse, and Sanskrit.");
    }

    final headerRowCells = rawRows[headerRowIdx].map((e) => getCsvCell([e], 0) ?? '').toList();
    final normalizedHeaders = headerRowCells.map((e) => normalizeHeader(e)).toList();

    final columnMapping = CsvHeaderMapper.mapHeaders(normalizedHeaders);

    print('[CSV IMPORT] File name: ${file.name}');
    print('[CSV IMPORT] File size: ${bytes.length} bytes');
    print('[CSV IMPORT] Total CSV rows: ${rawRows.length}');
    print('[CSV IMPORT] Header row: ${headerRowIdx + 1}');
    print('[CSV IMPORT] Normalized headers: $normalizedHeaders');
    print('[CSV IMPORT] Detected columns: $columnMapping');

    int idIdx = columnMapping['id'] ?? -1;
    int canonicalRefIdx = columnMapping['canonical_reference'] ?? columnMapping['reference'] ?? -1;
    int bookIdIdx = columnMapping['book_id'] ?? -1;
    int bookNameIdx = columnMapping['book_name'] ?? -1;
    int kandaIdx = columnMapping['kanda_number'] ?? -1;
    int sargaIdx = columnMapping['sarga_number'] ?? -1;
    int verseIdx = columnMapping['verse_number'] ?? -1;
    int sanskritIdx = columnMapping['sanskrit'] ?? -1;
    int englishIdx = columnMapping['english'] ?? -1;
    int hindiIdx = columnMapping['hindi'] ?? -1;
    int gujaratiIdx = columnMapping['gujarati'] ?? -1;
    int explanationIdx = columnMapping['explanation'] ?? -1;
    int sourceUrlIdx = columnMapping['source_url'] ?? -1;
    int sourceNameIdx = columnMapping['source_name'] ?? -1;
    int qaStatusIdx = columnMapping['qa_status'] ?? -1;
    int notesIdx = columnMapping['notes'] ?? -1;

    final bool hasStructureOrSanskrit = (kandaIdx != -1 || sargaIdx != -1 || verseIdx != -1 || sanskritIdx != -1);
    final bool hasIdOrRef = (idIdx != -1 || canonicalRefIdx != -1);
    final bool hasAnyTranslation = (englishIdx != -1 || hindiIdx != -1 || gujaratiIdx != -1);

    final schema = ScriptureImportSchema.detect(
      targetBookId: targetBookId ?? 'ramayana',
      detectedHeaders: normalizedHeaders,
      hasKandaCol: kandaIdx != -1,
      hasSargaCol: sargaIdx != -1,
      hasVerseCol: verseIdx != -1,
      hasRefCol: hasIdOrRef,
    );

    final String fileImportMode = (!hasStructureOrSanskrit && hasIdOrRef && hasAnyTranslation)
        ? 'translation_update'
        : 'full_master';

    final detectedMappings = <String, String>{};
    detectedMappings['Import Mode'] = fileImportMode == 'translation_update' ? 'Translation Update Mode' : 'Full Master Mode';
    if (idIdx != -1) detectedMappings['ID / Verse ID'] = headerRowCells[idIdx];
    if (canonicalRefIdx != -1) detectedMappings['Canonical Reference'] = headerRowCells[canonicalRefIdx];
    if (kandaIdx != -1) detectedMappings['${config.primaryChapterTerm} / Kanda'] = headerRowCells[kandaIdx];
    if (sargaIdx != -1) detectedMappings['${config.secondarySectionTerm} / Sarga'] = headerRowCells[sargaIdx];
    if (verseIdx != -1) detectedMappings['Verse / Shlok'] = headerRowCells[verseIdx];
    if (sanskritIdx != -1) detectedMappings['Sanskrit'] = headerRowCells[sanskritIdx];
    if (englishIdx != -1) detectedMappings['English'] = headerRowCells[englishIdx];
    if (hindiIdx != -1) detectedMappings['Hindi'] = headerRowCells[hindiIdx];
    if (gujaratiIdx != -1) detectedMappings['Gujarati'] = headerRowCells[gujaratiIdx];

    print('[CSV IMPORT] Import Mode: $fileImportMode');
    print('[CSV IMPORT] Hierarchy Type: ${schema.hierarchyType}');

    final parsedRows = <RamayanaParsedRow>[];
    final seenIdsInFile = <String, int>{};
    final detectedKandasSet = <int>{};
    final detectedSargasSet = <String>{};

    int missingSanskritCount = 0;
    int missingEnglishCount = 0;
    int missingHindiCount = 0;
    int missingGujaratiCount = 0;
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

    for (int i = headerRowIdx + 1; i < rawRows.length; i++) {
      final row = rawRows[i];

      final rawId = getCsvCell(row, idIdx) ?? '';
      final canonicalRefStr = getCsvCell(row, canonicalRefIdx) ?? '';
      final rawBook = getCsvCell(row, bookIdIdx) ?? '';
      final rawBookNameCol = getCsvCell(row, bookNameIdx) ?? '';
      final rawKanda = getCsvCell(row, kandaIdx);
      final rawSarga = getCsvCell(row, sargaIdx);
      final rawVerse = getCsvCell(row, verseIdx);
      final sanskritText = getCsvCell(row, sanskritIdx) ?? '';
      final englishText = getCsvCell(row, englishIdx);
      final hindiText = getCsvCell(row, hindiIdx);
      final gujaratiText = getCsvCell(row, gujaratiIdx);
      final explanationText = getCsvCell(row, explanationIdx);
      final sourceUrlVal = getCsvCell(row, sourceUrlIdx) ?? config.defaultSourceUrl;
      final sourceNameVal = getCsvCell(row, sourceNameIdx) ?? '${config.bookName} Source';
      final rawQaStatus = getCsvCell(row, qaStatusIdx) ?? 'Approved';
      final notesText = getCsvCell(row, notesIdx);

      final colKanda = parseOptionalInt(rawKanda) ?? -1;
      final colSarga = parseOptionalInt(rawSarga) ?? -1;
      final colVerse = parseOptionalInt(rawVerse) ?? -1;

      // Skip completely empty CSV rows
      if (rawId.isEmpty && canonicalRefStr.isEmpty && sanskritText.isEmpty && colKanda <= 0 && colSarga <= 0 && colVerse <= 0 && englishText == null && hindiText == null && gujaratiText == null) {
        skippedRowsAfterHeader++;
        continue;
      }

      print('[CSV IMPORT] Current row: ${i + 1} | mode: $fileImportMode | id: $rawId | ref: $canonicalRefStr | kanda=$colKanda, sarga=$colSarga, verse=$colVerse');

      String bookCode = config.defaultBookCode;
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

      if (schema.hierarchyType == HierarchyType.referenceOnly) {
        if (finalKanda <= 0) finalKanda = 1;
        if (finalSarga <= 0) finalSarga = 1;
        if (finalVerse <= 0) finalVerse = i - headerRowIdx;
      } else if (!config.requiresSecondarySection && finalSarga <= 0) {
        finalSarga = 1;
      }

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

      if (!hasEnglish) missingEnglishCount++;
      if (!hasHindi) missingHindiCount++;
      if (!hasGujarati) missingGujaratiCount++;

      if (fileImportMode == 'translation_update') {
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
        if (idParsedSuccess && colKanda > 0 && parsedKanda != colKanda) {
          errors.add("ID ${config.primaryChapterTerm} value conflicts with explicit ${config.primaryChapterTerm} value (ID: $parsedKanda vs Col: $colKanda)");
          affectedCols.add(config.primaryChapterTerm);
        }
        if (idParsedSuccess && colSarga > 0 && parsedSarga > 0 && parsedSarga != colSarga) {
          errors.add("ID ${config.secondarySectionTerm} value conflicts with explicit ${config.secondarySectionTerm} value (ID: $parsedSarga vs Col: $colSarga)");
          affectedCols.add(config.secondarySectionTerm);
        }
        if (idParsedSuccess && colVerse > 0 && parsedVerse != colVerse) {
          errors.add("ID Verse value conflicts with explicit Verse value (ID: $parsedVerse vs Col: $colVerse)");
          affectedCols.add("Verse");
        }

        if (schema.hierarchyType == HierarchyType.referenceOnly) {
          if (rawId.isEmpty && canonicalRefStr.isEmpty) {
            errors.add("Missing required reference identifier (passage_id or reference_no)");
            affectedCols.add("Reference");
          }
          detectedKandasSet.add(finalKanda);
          detectedSargasSet.add('K${finalKanda}_S$finalSarga');
        } else {
          // Structural requirements check
          if (finalKanda <= 0) {
            errors.add("Missing or invalid ${config.primaryChapterTerm} number");
            affectedCols.add(config.primaryChapterTerm);
            missingChapterInfoCount++;
          } else {
            detectedKandasSet.add(finalKanda);
          }

          if (finalSarga <= 0 && config.requiresSecondarySection) {
            errors.add("Missing or invalid ${config.secondarySectionTerm} number");
            affectedCols.add(config.secondarySectionTerm);
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
        }

        if (!hasSanskrit) {
          errors.add("Missing Sanskrit shloka text");
          affectedCols.add("Sanskrit");
          missingSanskritCount++;
        }

        if (!hasEnglish && !hasHindi && !hasGujarati) {
          missingTranslationsCount++;
          if (!hasSanskrit) {
            errors.add("Missing required translations (English, Hindi, or Gujarati)");
            affectedCols.add("Translations");
          }
        }
      }

      String canonicalVerseId;
      if (rawId.isNotEmpty) {
        canonicalVerseId = rawId.trim();
      } else if (canonicalRefStr.isNotEmpty) {
        canonicalVerseId = canonicalRefStr.trim();
      } else if (finalKanda > 0 && finalVerse > 0) {
        final kandaPad = finalKanda.toString().padLeft(2, '0');
        final versePad = finalVerse.toString().padLeft(3, '0');
        if (!config.requiresSecondarySection) {
          canonicalVerseId = '$bookCode-$kandaPad-$versePad';
        } else {
          final sargaPad = (finalSarga > 0 ? finalSarga : 1).toString().padLeft(3, '0');
          canonicalVerseId = '$bookCode-$kandaPad-$sargaPad-$versePad';
        }
      } else {
        canonicalVerseId = 'Row ${i + 1}';
      }

      final bool isDup = canonicalVerseId.isNotEmpty &&
          !canonicalVerseId.contains('00-000-000') &&
          seenIdsInFile.containsKey(canonicalVerseId);

      if (isDup) {
        errors.add("Duplicate canonical ID in CSV: $canonicalVerseId (first seen at row ${seenIdsInFile[canonicalVerseId]})");
        affectedCols.add("ID");
      } else if (canonicalVerseId.contains('-')) {
        seenIdsInFile[canonicalVerseId] = i + 1;
      }

      final rowBookName = rawBookNameCol.isNotEmpty
          ? rawBookNameCol
          : rawBook.isNotEmpty
              ? rawBook
              : config.bookName;

      final parsedRow = RamayanaParsedRow(
        fileRowNumber: i + 1,
        rawId: rawId,
        verseId: canonicalVerseId,
        bookId: config.bookId,
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
      throw Exception("No valid content rows were detected in CSV file '${file.name}'.");
    }

    final validCount = parsedRows.where((r) => r.isValid).length;
    final invalidCount = parsedRows.where((r) => !r.isValid).length;
    final dupCount = parsedRows.where((r) => r.isDuplicateInFile).length;
    final sortedKandas = detectedKandasSet.toList()..sort();

    return RamayanaParseResult(
      rows: parsedRows,
      totalRawRowsInFile: rawRows.length,
      metadataRowsSkipped: headerRowIdx + skippedRowsAfterHeader,
      scriptureRowsDetected: parsedRows.length,
      headerRowNumber: headerRowIdx + 1,
      detectedColumnMappings: detectedMappings,
      hierarchyType: schema.hierarchyType,
      detectedKandas: sortedKandas,
      detectedSargasCount: detectedSargasSet.length,
      detectedVerseCount: parsedRows.length,
      validRowsCount: validCount,
      invalidRowsCount: invalidCount,
      duplicateRowsCount: dupCount,
      missingSanskritCount: missingSanskritCount,
      missingEnglishCount: missingEnglishCount,
      missingHindiCount: missingHindiCount,
      missingGujaratiCount: missingGujaratiCount,
      missingChapterInfoCount: missingChapterInfoCount,
      missingVerseNumCount: missingVerseNumCount,
      missingTranslationsCount: missingTranslationsCount,
      qaStatusCounts: qaStatusCounts,
      defaultSourceUrl: config.defaultSourceUrl,
      selectedSheetName: 'CSV Data',
      importMode: fileImportMode,
    );
  }

  bool _isContentHeaderRow(List<String> rowCells) {
    if (rowCells.isEmpty) return false;

    int matches = 0;
    bool hasKandaOrSargaOrVerse = false;
    bool hasSanskritOrTranslationOrId = false;

    for (final c in rowCells) {
      if (c == 'id' || c == 'passage_id' || c == 'passageid' || c == 'verse_id' || c == 'canonical_id' || c == 'canonical_reference' || c == 'reference' || c == 'ref' || c == 'verse_reference' || c == 'shlok_id' || c == 'code' || c == 'ram_id' || c == 'mah_id' || c == 'git_id' || c == 'upn_id') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'kanda' || c == 'kand' || c == 'kanda_number' || c == 'kanda_name' || c == 'kanda_no' || c == 'parva' || c == 'parva_number' || c == 'chapter' || c == 'chapter_number') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'sarga' || c == 'sarg' || c == 'sarga_number' || c == 'sarga_no' || c == 'section' || c == 'section_number' || c == 'adhyaya') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'verse' || c == 'shlok' || c == 'shloka' || c == 'verse_number' || c == 'shloka_number' || c == 'verse_no') {
        matches++;
        hasKandaOrSargaOrVerse = true;
      } else if (c == 'sanskrit' || c == 'sanskrit_shloka' || c == 'sanskrit_text' || c == 'shloka_text' || c == 'sloka') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'english' || c == 'hindi' || c == 'gujarati' || c == 'translation' || c == 'english_translation' || c == 'hindi_translation' || c == 'gujarati_translation' || c == 'english_meaning' || c == 'hindi_meaning' || c == 'gujarati_meaning' || c == 'translation_en' || c == 'translation_hi' || c == 'translation_gu' || c == 'en' || c == 'hi' || c == 'gu' || c == 'eng' || c == 'hin' || c == 'guj' || c == 'meaning_english' || c == 'meaning_hindi' || c == 'meaning_gujarati') {
        matches++;
        hasSanskritOrTranslationOrId = true;
      } else if (c == 'source_url' || c == 'source' || c == 'url' || c == 'qa_status' || c == 'status' || c == 'notes' || c == 'explanation') {
        matches++;
      }
    }

    return matches >= 2 && (hasKandaOrSargaOrVerse || hasSanskritOrTranslationOrId);
  }
}
