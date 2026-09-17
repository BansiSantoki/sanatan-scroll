import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';
import 'package:excel/excel.dart';

void main() {
  late RamayanaParserService parserService;

  setUp(() {
    parserService = RamayanaParserService();
  });

  PlatformFile createCsvFile(String csvContent, String filename) {
    final bytes = Uint8List.fromList(utf8.encode(csvContent));
    return PlatformFile(
      name: filename,
      size: bytes.length,
      bytes: bytes,
    );
  }

  PlatformFile createXlsxFile({
    required Map<String, List<List<dynamic>>> sheets,
    required String filename,
  }) {
    final excel = Excel.createExcel();

    for (final entry in sheets.entries) {
      final sheetName = entry.key;
      final rows = entry.value;
      final Sheet sheet = excel[sheetName];

      for (int r = 0; r < rows.length; r++) {
        final rowData = rows[r];
        for (int c = 0; c < rowData.length; c++) {
          final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r));
          final val = rowData[c];
          if (val is int) {
            cell.value = IntCellValue(val);
          } else if (val is double) {
            cell.value = DoubleCellValue(val);
          } else if (val != null) {
            cell.value = TextCellValue(val.toString());
          }
        }
      }
    }

    if (sheets.keys.first != 'Sheet1' && excel.tables.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final bytes = Uint8List.fromList(excel.save()!);
    return PlatformFile(
      name: filename,
      size: bytes.length,
      bytes: bytes,
    );
  }

  group('RamayanaParserService Complete Test Suite (Generic Sacred Books)', () {
    test('A. Completely valid Ramayana row parses cleanly with RAM-01-001-001', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati,source_url,qa_status
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं तपस्वी वाग्विदां वरम्,Valmiki asked,वाल्मीकि ने पूछा,વાલ્મિકીએ પૂછ્યું,https://ramayana.info/,Approved
''';

      final file = createCsvFile(csvContent, 'valid_ramayana.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana', targetBookName: 'Ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('RAM-01-001-001'));
      expect(result.rows[0].isValid, isTrue);
    });

    test('B. Missing Sanskrit marks row invalid with error "Missing Sanskrit shloka text"', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
RAM-01-001-002,1,1,2,,English translation only,Approved
''';

      final file = createCsvFile(csvContent, 'missing_sanskrit.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors, contains('Missing Sanskrit shloka text'));
    });

    test('C. Missing ID auto-generates ID from Kanda/Sarga/Verse', () async {
      const csvContent = '''
kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
1,1,3,तपःस्वाध्यायनिरतं...,Valmiki asked Narada,Approved
''';

      final file = createCsvFile(csvContent, 'missing_id.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('RAM-01-001-003'));
    });

    test('D. Missing Kanda marks row invalid cleanly (Row 2 identifier, no fake -1)', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
,0,1,4,तपःस्वाध्यायनिरतं...,English,Approved
''';

      final file = createCsvFile(csvContent, 'missing_kanda.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('Row 2'));
      expect(result.rows[0].validationErrors, contains('Missing or invalid Kanda number'));
    });

    test('E. Missing Sarga marks row invalid cleanly', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
,1,,5,तपःस्वाध्यायनिरतं...,English,Approved
''';

      final file = createCsvFile(csvContent, 'missing_sarga.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors, contains('Missing or invalid Sarga/Chapter number'));
    });

    test('F. Missing Verse marks row invalid cleanly', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
,1,1,,तपःस्वाध्यायनिरतं...,English,Approved
''';

      final file = createCsvFile(csvContent, 'missing_verse.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors, contains('Missing or invalid Verse number'));
    });

    test('G. Duplicate ID flagged on second row', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं...,English 1,Approved
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं...,English 1,Approved
''';

      final file = createCsvFile(csvContent, 'dup.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.duplicateRowsCount, equals(1));
      expect(result.rows[1].isDuplicateInFile, isTrue);
    });

    test('H. Conflicting ID vs explicit numbers marks row invalid', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
RAM-01-001-001,2,1,1,तपःस्वाध्यायनिरतं...,English 1,Approved
''';

      final file = createCsvFile(csvContent, 'conflict.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('Chapter conflict: ID specifies 1 but column specifies 2'));
    });

    test('I. Completely empty row skipped safely', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं...,English 1,Approved
,,,,,,,,
RAM-01-001-002,1,1,2,को न्वस्मिन्सांप्रतं...,English 2,Approved
''';

      final file = createCsvFile(csvContent, 'empty_row.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.scriptureRowsDetected, equals(2));
      expect(result.validRowsCount, equals(2));
    });

    test('J. Null/blank optional translation fields processed safely', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati,source_url,qa_status
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं...,,,,,,Approved
''';

      final file = createCsvFile(csvContent, 'null_translations.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.scriptureRowsDetected, equals(1));
      expect(result.rows[0].english, isEmpty);
      expect(result.rows[0].hindi, isEmpty);
      expect(result.rows[0].gujarati, isEmpty);
    });

    test('K. XLSX with IntCellValue / DoubleCellValue cell types parses safely without null-check exception', () async {
      final file = createXlsxFile(
        sheets: {
          'Ramayana_Content': [
            ['id', 'kanda_number', 'sarga_number', 'verse_number', 'sanskrit', 'english', 'qa_status'],
            ['RAM-01-001-001', 1, 1, 1, 'तपःस्वाध्यायनिरतं...', 'English 1', 'Approved'],
            ['RAM-01-001-002', 1, 1, 2, 'को न्वस्मिन्सांप्रतं...', 'English 2', 'Approved'],
          ],
        },
        filename: 'Ramayana_Test.xlsx',
      );

      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.scriptureRowsDetected, equals(2));
      expect(result.validRowsCount, equals(2));
      expect(result.rows[0].kandaNumber, equals(1));
      expect(result.rows[0].sargaNumber, equals(1));
      expect(result.rows[0].verseNumber, equals(1));
    });

    test('L. Mahabharata sheet parses with MAH-01-001-001 and Parva/Section headers', () async {
      const csvContent = '''
id,parva,section,verse,sanskrit,english,qa_status
MAH-01-001-001,1,1,1,नारायणं नमस्कृत्य नरे चैव नरोत्तमम्...,Mahabharata opening,Approved
''';

      final file = createCsvFile(csvContent, 'mahabharata.csv');
      final result = await parserService.parseFile(file, targetBookId: 'mahabharata', targetBookName: 'Mahabharata');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('MAH-01-001-001'));
      expect(result.rows[0].bookId, equals('mahabharata'));
      expect(result.rows[0].chapterNumber, equals(1));
    });

    test('M. Bhagavad Gita sheet parses with GIT-01-001 and Chapter/Verse headers', () async {
      const csvContent = '''
id,chapter,verse,sanskrit,english,qa_status
GIT-01-001,1,1,धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः...,Dhritarashtra asked,Approved
''';

      final file = createCsvFile(csvContent, 'bhagavad_gita.csv');
      final result = await parserService.parseFile(file, targetBookId: 'bhagavad_gita', targetBookName: 'Bhagavad Gita');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('GIT-01-001'));
      expect(result.rows[0].bookId, equals('bhagavad_gita'));
      expect(result.rows[0].chapterNumber, equals(1));
      expect(result.rows[0].verseNumber, equals(1));
    });

    test('N. Upanishads sheet parses with UPN-01-001 and Chapter/Verse headers', () async {
      const csvContent = '''
id,chapter,verse,sanskrit,english,qa_status
UPN-01-001,1,1,ईशा वास्यमिदं सर्वम्...,All this is enveloped by God,Approved
''';

      final file = createCsvFile(csvContent, 'upanishads.csv');
      final result = await parserService.parseFile(file, targetBookId: 'upanishads', targetBookName: 'Upanishads');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('UPN-01-001'));
      expect(result.rows[0].bookId, equals('upanishads'));
    });
  });
}
