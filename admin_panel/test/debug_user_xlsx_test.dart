import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';
import 'package:excel/excel.dart';

void main() {
  const filePath = r'C:\Users\Lenovo\Downloads\Ramayana_App_Test_Translations_Pass_Only.xlsx';
  
  test('Debug Ramayana_App_Test_Translations_Pass_Only.xlsx', () async {
    final fileObj = File(filePath);
    expect(fileObj.existsSync(), isTrue, reason: 'File must exist');

    final bytes = await fileObj.readAsBytes();
    print('File length: ${bytes.length}');

    final archive = ZipDecoder().decodeBytes(bytes);
    print('Zip files in xlsx: ${archive.files.map((f) => f.name).toList()}');
    
    for (final file in archive.files) {
      if (file.name == 'xl/worksheets/sheet1.xml') {
        print('=== xl/worksheets/sheet1.xml ===');
        final str = utf8.decode(file.content as List<int>);
        print(str.length > 3000 ? str.substring(0, 3000) : str);
      }
    }

    // Now test with RamayanaParserService
    final platformFile = PlatformFile(
      name: 'Ramayana_App_Test_Translations_Pass_Only.xlsx',
      size: bytes.length,
      bytes: bytes,
    );

    final parser = RamayanaParserService();
    try {
      final result = await parser.parseFile(
        platformFile,
        targetBookId: 'ramayana',
        targetBookName: 'Ramayana',
      );
      print('SUCCESS! Selected Sheet: ${result.selectedSheetName}, Header Row: ${result.headerRowNumber}, Rows: ${result.scriptureRowsDetected}');
    } catch (e) {
      print('ERROR PARSING FILE: $e');
    }
  });
}
