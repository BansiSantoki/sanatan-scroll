import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';
import 'package:admin_panel/services/csv_import_service.dart';

void main() {
  const filePath = r'C:\Users\Lenovo\Downloads\Ramayana_App_Test_Translations_Pass_Only.xlsx';
  
  test('Parse user Ramayana_App_Test_Translations_Pass_Only.xlsx with XML namespace tolerance', () async {
    final fileObj = File(filePath);
    if (!fileObj.existsSync()) return;

    final bytes = await fileObj.readAsBytes();
    final platformFile = PlatformFile(
      name: 'Ramayana_App_Test_Translations_Pass_Only.xlsx',
      size: bytes.length,
      bytes: bytes,
    );

    final parser = RamayanaParserService();
    final result = await parser.parseFile(
      platformFile,
      targetBookId: 'ramayana',
      targetBookName: 'Ramayana',
    );

    expect(result.selectedSheetName, equals('App_Test_Translations'));
    expect(result.headerRowNumber, equals(1));
    expect(result.scriptureRowsDetected, equals(19));
    expect(result.validRowsCount, equals(19));
    expect(result.invalidRowsCount, equals(0));

    // Verify first row
    final row1 = result.rows.first;
    expect(row1.rawId, equals('RAM-01-002-015'));
    expect(row1.kandaNumber, equals(1));
    expect(row1.sargaNumber, equals(2));
    expect(row1.verseNumber, equals(15));
    expect(row1.sanskrit, contains('मा निषाद'));
    expect(row1.english, isNotNull);
    expect(row1.hindi, isNotNull);
    expect(row1.gujarati, isNotNull);

    // Verify Kanda 6 row (Yuddha Kanda range ID RAM-06-067-055-056)
    final yuddhaRow = result.rows.firstWhere((r) => r.rawId == 'RAM-06-067-055-056');
    expect(yuddhaRow.kandaNumber, equals(6));
    expect(yuddhaRow.sargaNumber, equals(67));
    expect(yuddhaRow.verseNumber, equals(55));
    expect(yuddhaRow.sanskrit, isNotEmpty);
  });

  test('Translation-Only CSV parses cleanly in Translation Update Mode without sanskrit or kanda/sarga/shlok columns', () async {
    const csvContent = '''
Ramayana Translation Updates
Notes: English, Hindi and Gujarati translations update file

passage_id,canonical_reference,english,hindi,gujarati
RAM-01-002-015,1.2.15,"O niṣāda, may you not attain enduring standing...","हे निषाद, तू दीर्घकाल तक...","હે નિષાદ, તું દીર્ઘકાળ સુધી..."
RAM-01-003-001,1.3.1,"Having heard that complete account...","उस धर्म-संहित सम्पूर्ण वृत्तांत को सुनकर...","ધર્મથી સંકળાયેલા તે સંપૂર્ણ वृत्तांत..."
''';

    final bytes = Uint8List.fromList(utf8.encode(csvContent));
    final platformFile = PlatformFile(
      name: 'Ramayana_Translation_Update.csv',
      size: bytes.length,
      bytes: bytes,
    );

    final csvService = CsvImportService();
    final result = await csvService.parseFile(
      platformFile,
      targetBookId: 'ramayana',
      targetBookName: 'Ramayana',
    );

    expect(result.importMode, equals('translation_update'));
    expect(result.headerRowNumber, equals(4));
    expect(result.scriptureRowsDetected, equals(2));
    expect(result.validRowsCount, equals(2));
    expect(result.invalidRowsCount, equals(0));

    final row1 = result.rows.first;
    expect(row1.rawId, equals('RAM-01-002-015'));
    expect(row1.canonicalRef, equals('1.2.15'));
    expect(row1.kandaNumber, equals(1));
    expect(row1.sargaNumber, equals(2));
    expect(row1.verseNumber, equals(15));
    expect(row1.english, isNotNull);
    expect(row1.hindi, isNotNull);
    expect(row1.gujarati, isNotNull);
    expect(row1.sanskrit, isEmpty); // Sanskrit not required in Translation Update mode
    expect(row1.isValid, isTrue);
  });

  test('Single language translation update file is valid in Translation Update Mode', () async {
    const csvContent = '''
passage_id,english
RAM-01-002-015,"O niṣāda, may you not attain enduring standing..."
RAM-01-003-001,"Having heard that complete account..."
''';

    final bytes = Uint8List.fromList(utf8.encode(csvContent));
    final platformFile = PlatformFile(
      name: 'English_Only_Update.csv',
      size: bytes.length,
      bytes: bytes,
    );

    final csvService = CsvImportService();
    final result = await csvService.parseFile(
      platformFile,
      targetBookId: 'ramayana',
      targetBookName: 'Ramayana',
    );

    expect(result.importMode, equals('translation_update'));
    expect(result.validRowsCount, equals(2));
    expect(result.rows[0].english, isNotNull);
    expect(result.rows[0].hindi, isNull);
    expect(result.rows[0].gujarati, isNull);
    expect(result.rows[0].isValid, isTrue);
  });
}
