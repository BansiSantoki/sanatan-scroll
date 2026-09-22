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

  group('Excel (.xlsx) & CSV Universal Parser Tests', () {
    test('1. Ramayana Excel (.xlsx) file parses successfully with 3 translations', () async {
      final xlsxFile = createXlsxFile(
        filename: 'Ramayana_Master.xlsx',
        sheets: {
          'Ramayana Content': [
            ['passage_id', 'kanda_name', 'sarga_no', 'shlok_no', 'canonical_reference', 'sanskrit', 'english', 'hindi', 'gujarati'],
            ['RAM-01-002-015', 'Bala Kanda', 2, 15, '1.2.15', 'मा निषाद...', 'O nishada...', 'हे निषाद...', 'હે નિષાદ...'],
          ],
        },
      );

      final result = await parserService.parseFile(xlsxFile, targetBookId: 'ramayana', targetBookName: 'Ramayana');

      expect(result.rows.length, 1);
      final row = result.rows.first;
      expect(row.rawId, 'RAM-01-002-015');
      expect(row.kandaNumber, 1);
      expect(row.sargaNumber, 2);
      expect(row.verseNumber, 15);
      expect(row.sanskrit, 'मा निषाद...');
      expect(row.english, 'O nishada...');
      expect(row.hindi, 'हे निषाद...');
      expect(row.gujarati, 'હે નિષાદ...');
      expect(row.isValid, true);
    });

    test('2. Bhagavad Gita Excel (.xlsx) parses successfully', () async {
      final xlsxFile = createXlsxFile(
        filename: 'Gita.xlsx',
        sheets: {
          'Sheet1': [
            ['passage_id', 'chapter_number', 'verse_number', 'sanskrit', 'english', 'hindi', 'gujarati'],
            ['GIT-01-001', 1, 1, 'धर्मक्षेत्रे कुरुक्षेत्रे...', 'On the field of Dharma...', 'धर्मक्षेत्र कुरुक्षेत्र में...', 'ધર્મક્ષેત્રે કુરુક્ષેત્રે...'],
          ],
        },
      );

      final result = await parserService.parseFile(xlsxFile, targetBookId: 'bhagavad_gita', targetBookName: 'Bhagavad Gita');

      expect(result.rows.length, 1);
      final row = result.rows.first;
      expect(row.rawId, 'GIT-01-001');
      expect(row.kandaNumber, 1);
      expect(row.verseNumber, 1);
      expect(row.sanskrit, 'धर्मक्षेत्रे कुरुक्षेत्रे...');
      expect(row.english, 'On the field of Dharma...');
      expect(row.isValid, true);
    });

    test('3. Mahabharata Excel (.xlsx) parses successfully', () async {
      final xlsxFile = createXlsxFile(
        filename: 'Mahabharata.xlsx',
        sheets: {
          'Sheet1': [
            ['passage_id', 'parva', 'section', 'verse', 'sanskrit', 'english'],
            ['MAH-01-001-001', 1, 1, 1, 'नारायणं नमस्कृत्य...', 'Narayanam namaskrutya...',],
          ],
        },
      );

      final result = await parserService.parseFile(xlsxFile, targetBookId: 'mahabharata', targetBookName: 'Mahabharata');

      expect(result.rows.length, 1);
      final row = result.rows.first;
      expect(row.rawId, 'MAH-01-001-001');
      expect(row.kandaNumber, 1);
      expect(row.sargaNumber, 1);
      expect(row.verseNumber, 1);
      expect(row.isValid, true);
    });

    test('4. Upanishads Excel (.xlsx) parses successfully', () async {
      final xlsxFile = createXlsxFile(
        filename: 'Upanishads.xlsx',
        sheets: {
          'Sheet1': [
            ['passage_id', 'chapter', 'verse', 'sanskrit', 'english'],
            ['UPN-01-001', 1, 1, 'ईशा वास्यमिदं सर्वं...', 'All this is enveloped by God...'],
          ],
        },
      );

      final result = await parserService.parseFile(xlsxFile, targetBookId: 'upanishads', targetBookName: 'Upanishads');

      expect(result.rows.length, 1);
      final row = result.rows.first;
      expect(row.rawId, 'UPN-01-001');
      expect(row.kandaNumber, 1);
      expect(row.verseNumber, 1);
      expect(row.isValid, true);
    });
  });
}
