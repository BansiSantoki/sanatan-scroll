import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';
import 'package:csv/csv.dart';

void main() {
  const xlsxPath = r'C:\Users\Lenovo\Downloads\Ramayana_Admin_Import_Test.xlsx';
  test('Export Ramayana_Admin_Import_Test.xlsx to Ramayana_Admin_Import_Test.csv', () async {
    if (!File(xlsxPath).existsSync()) return;
    const csvPath = r'C:\Users\Lenovo\Downloads\Ramayana_Admin_Import_Test.csv';

    final bytes = await File(xlsxPath).readAsBytes();
    final sheets = SafeXlsxReader.decodeSheets(bytes);
    final rows = sheets['Ramayana Content'] ?? sheets.values.first;

    final csvString = const ListToCsvConverter().convert(rows);
    await File(csvPath).writeAsString(csvString);

    print('[CSV GENERATION] Wrote ${rows.length} rows to $csvPath');
    expect(File(csvPath).existsSync(), isTrue);
  });
}
