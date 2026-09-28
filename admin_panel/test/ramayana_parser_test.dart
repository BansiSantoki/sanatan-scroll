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

  group('RamayanaParserService Comprehensive Production Null-Safety Test Suite', () {
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

    test('B. Null Hindi and Gujarati cells are accepted as null without crashing or marking row invalid', () async {
      const csvContent = '''
id,book_id,book_name,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati,source_url,status,qa_status
RAM-01-067-001,ramayana,Ramayana,1,67,1,जनकस्य वचःश्रुत्वा...,At the words of Janaka...,,,https://ramayana.info/story/bala/67/,published,approved
''';

      final file = createCsvFile(csvContent, 'null_hindi_gujarati.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].hindi, isNull);
      expect(result.rows[0].gujarati, isNull);
      expect(result.rows[0].english, isNotNull);
      expect(result.rows[0].isValid, isTrue);
    });

    test('C. Missing Sanskrit and translations marks row invalid', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
RAM-01-001-002,1,1,2,,,Approved
''';

      final file = createCsvFile(csvContent, 'missing_sanskrit.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('Missing required content'));
    });

    test('D. Missing ID auto-generates ID from Kanda/Sarga/Verse', () async {
      const csvContent = '''
kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
1,1,3,तपःस्वाध्यायनिरतं...,Valmiki asked Narada,Approved
''';

      final file = createCsvFile(csvContent, 'missing_id.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('RAM-01-001-003'));
    });

    test('E. Missing Kanda marks row invalid cleanly (Row 2 identifier)', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
,0,1,4,तपःस्वाध्यायनिरतं...,English,Approved
''';

      final file = createCsvFile(csvContent, 'missing_kanda.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('Row 2'));
      expect(result.rows[0].validationErrors.first, contains('Missing or invalid Kanda number'));
    });

    test('F. Missing Sarga marks row invalid cleanly', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
,1,,5,तपःस्वाध्यायनिरतं...,English,Approved
''';

      final file = createCsvFile(csvContent, 'missing_sarga.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('Missing or invalid Sarga number'));
    });

    test('G. Missing Verse marks row invalid cleanly', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
,1,1,,तपःस्वाध्यायनिरतं...,English,Approved
''';

      final file = createCsvFile(csvContent, 'missing_verse.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('Missing or invalid Verse number'));
    });

    test('H. Duplicate ID flagged on second row', () async {
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

    test('I. Conflicting ID vs explicit numbers marks row invalid', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,qa_status
RAM-01-001-001,2,1,1,तपःस्वाध्यायनिरतं...,English 1,Approved
''';

      final file = createCsvFile(csvContent, 'conflict.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('ID Kanda value conflicts with explicit Kanda value'));
    });

    test('J. Completely empty row skipped safely', () async {
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

    test('K. Multi-sheet workbook selects "Ramayana Content" and ignores "README"', () async {
      final file = createXlsxFile(
        sheets: {
          'README': [
            ['Instructions', 'Notes'],
            ['This sheet is for documentation', 'Do not parse'],
          ],
          'Ramayana Content': [
            ['id', 'kanda_number', 'sarga_number', 'verse_number', 'sanskrit', 'english', 'hindi', 'gujarati'],
            ['RAM-01-067-001', 1, 67, 1, 'जनकस्य वचःश्रुत्वा...', 'English text', null, null],
          ],
        },
        filename: 'MultiSheet_Ramayana.xlsx',
      );

      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.selectedSheetName, equals('Ramayana Content'));
      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('RAM-01-067-001'));
      expect(result.rows[0].hindi, isNull);
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

    test('O. Reference-based Isha Upanishad file (passage_id, reference_no) parses with 0 invalid rows', () async {
      const csvContent = '''
passage_id,scripture_name,reference_no,sanskrit,english,hindi,gujarati
ISHA-K-001,Isha Upanishad,ISHA-K-01,ईशा वास्यमिदम् सर्वं यत्किञ्च जगत्यां जगत्।,All this is enveloped by the Lord,यह सब ईश्वर से व्याप्त है।,આ બધું ઈશ્વરથી વ્યાપ્ત છે.
ISHA-K-002,Isha Upanishad,ISHA-K-02,कुर्वन्नेवेह कर्माणि जिजीविषेच्छतं समाः।,Always performing works here one should wish to live a hundred years.,कर्म करते हुए ही सौ वर्ष जीने की इच्छा करे।,કર્મો કરતા રહીને જ સો વર્ષ જીવવાની ઈચ્છા રાખવી.
''';

      final file = createCsvFile(csvContent, 'Isha_Upanishad_Reference.csv');
      final result = await parserService.parseFile(file, targetBookId: 'upanishads', targetBookName: 'Upanishads');

      expect(result.scriptureRowsDetected, equals(2));
      expect(result.validRowsCount, equals(2));
      expect(result.invalidRowsCount, equals(0));
      expect(result.missingChapterInfoCount, equals(0));
      expect(result.missingVerseNumCount, equals(0));
      expect(result.rows[0].verseId, equals('ISHA-K-001'));
      expect(result.rows[0].canonicalRef, equals('ISHA-K-01'));
      expect(result.rows[0].isValid, isTrue);
      expect(result.rows[1].verseId, equals('ISHA-K-002'));
      expect(result.rows[1].canonicalRef, equals('ISHA-K-02'));
      expect(result.rows[1].isValid, isTrue);
    });
  });
}
