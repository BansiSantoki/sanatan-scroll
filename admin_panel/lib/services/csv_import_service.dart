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
      case 'isha_upanishad':
        return SacredBookImportConfig(
          bookId: cleanId,
          bookName: customName ?? (cleanId == 'isha_upanishad' ? 'Isha Upanishad' : 'Upanishads'),
          defaultBookCode: cleanId == 'isha_upanishad' ? 'ISHA' : 'UPN',
          defaultSourceUrl: 'https://upanishads.info/',
          primaryChapterTerm: 'Mantra',
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
      'ram_id', 'mah_id', 'git_id', 'upn_id', 'isha_id'
    ],
    'canonical_reference': [
      'canonical_reference', 'canonical_ref', 'canonical_id', 'reference',
      'verse_reference', 'ref'
    ],
    'book_id': ['book_id', 'book', 'book_code', 'sacred_book', 'collection'],
    'book_name': ['book_name', 'title', 'book_title', 'bookname', 'scripture_name', 'scripture'],
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

/// CSV & Excel Universal Importer Service for Sacred Books
class CsvImportService {
  Future<RamayanaParseResult> parseFile(
    PlatformFile file, {
    String? targetBookId,
    String? targetBookName,
  }) async {
    return RamayanaParserService().parseFile(
      file,
      targetBookId: targetBookId,
      targetBookName: targetBookName,
    );
  }
}
