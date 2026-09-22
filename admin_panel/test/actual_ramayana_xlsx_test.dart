import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';

void main() {
  const filePath = r'C:\Users\Lenovo\Downloads\Ramayana_Admin_Import_Test.xlsx';
  test('Parse actual uploaded Ramayana_Admin_Import_Test.xlsx file cleanly', () async {
    final fileObj = File(filePath);
    if (!fileObj.existsSync()) return;

    final bytes = await fileObj.readAsBytes();
    final platformFile = PlatformFile(
      name: 'Ramayana_Admin_Import_Test.xlsx',
      size: bytes.length,
      bytes: bytes,
    );

    final parser = RamayanaParserService();
    final result = await parser.parseFile(
      platformFile,
      targetBookId: 'ramayana',
      targetBookName: 'Ramayana',
    );

    print('=== PARSE RESULT FOR ACTUAL XLSX ===');
    print('Selected Sheet Name: ${result.selectedSheetName}');
    print('Total Raw Rows in File: ${result.totalRawRowsInFile}');
    print('Scripture Rows Detected: ${result.scriptureRowsDetected}');
    print('Valid Rows Count: ${result.validRowsCount}');
    print('Invalid Rows Count: ${result.invalidRowsCount}');
    print('Duplicate Rows Count: ${result.duplicateRowsCount}');
    print('Detected Column Mappings: ${result.detectedColumnMappings}');

    expect(result.selectedSheetName, equals('Ramayana Content'));
    expect(result.scriptureRowsDetected, equals(27));
    expect(result.validRowsCount, equals(27));
    expect(result.invalidRowsCount, equals(0));

    // Special check for RAM-01-067-001
    final row1 = result.rows.firstWhere((r) => r.verseId == 'RAM-01-067-001');
    expect(row1.kandaNumber, equals(1));
    expect(row1.sargaNumber, equals(67));
    expect(row1.verseNumber, equals(1));
    expect(row1.sanskrit, isNotEmpty);
    expect(row1.english, isNotNull);
    expect(row1.hindi, isNull);
    expect(row1.gujarati, isNull);
    expect(row1.sourceUrl, equals('https://ramayana.info/story/bala/67/'));
    expect(row1.qaStatus, equals('Approved'));
    expect(row1.isValid, isTrue);

    // Special check for RAM-01-067-027 (last row)
    final lastRow = result.rows.firstWhere((r) => r.verseId == 'RAM-01-067-027');
    expect(lastRow.kandaNumber, equals(1));
    expect(lastRow.sargaNumber, equals(67));
    expect(lastRow.verseNumber, equals(27));
    expect(lastRow.sanskrit, isNotEmpty);
    expect(lastRow.isValid, isTrue);
  });
}
