import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/services/csv_import_service.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';

void main() {
  late CsvImportService csvService;
  late RamayanaParserService parserService;

  setUp(() {
    csvService = CsvImportService();
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

  PlatformFile createUtf8BomCsvFile(String csvContent, String filename) {
    final utf8Bytes = utf8.encode(csvContent);
    final bomBytes = Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8Bytes]);
    return PlatformFile(
      name: filename,
      size: bomBytes.length,
      bytes: bomBytes,
    );
  }

  group('Sanatan Scroll Multilingual CSV Importer Complete Acceptance Suite', () {
    test('1. Required Internal Test Case TEST-01-001-001 with mixed multilingual content parses cleanly', () async {
      const csvContent = '''
id,book_name,chapter_number,sarga_number,verse_number,title,sanskrit,english,hindi,gujarati,source_url,qa_status
"TEST-01-001-001","રામાયણ","1","1","1","રામાયણ — रामायण — रामायणम् — Ramayana","धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः","On the sacred field of Kurukshetra...","धर्मभूमि कुरुक्षेत्र में एकत्रित होकर...","ધર્મક્ષેત્ર કુરુક્ષેત્રમાં એકત્રિત થઈને...","https://sanatanscroll.info/","Approved"
''';

      final file = createCsvFile(csvContent, 'test_multilingual.csv');
      final result = await csvService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.invalidRowsCount, equals(0));

      final row = result.rows.first;
      expect(row.verseId, equals('TEST-01-001-001'));
      expect(row.sanskrit, equals('धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः'));
      expect(row.english, equals('On the sacred field of Kurukshetra...'));
      expect(row.hindi, equals('धर्मभूमि कुरुक्षेत्र में एकत्रित होकर...'));
      expect(row.gujarati, equals('ધર્મક્ષેત્ર કુરુક્ષેત્રમાં એકત્રિત થઈને...'));
      expect(row.isValid, isTrue);
    });

    test('2. UTF-8 BOM byte sequence (EF BB BF) from Excel does NOT corrupt first header or data field', () async {
      const csvContent = '''id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati
RAM-01-001-002,1,1,2,तपःस्वाध्यायनिरतं तपस्वी...,Valmiki asked Narada...,वाल्मीकि ने नारद से पूछा...,વાલ્મિકીએ નારદને પૂછ્યું...
''';

      final file = createUtf8BomCsvFile(csvContent, 'bom_test.csv');
      final result = await csvService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows.first.verseId, equals('RAM-01-001-002'));
      expect(result.rows.first.kandaNumber, equals(1));
      expect(result.rows.first.sanskrit, contains('तपःस्वाध्यायनिरतं'));
      expect(result.rows.first.gujarati, contains('નારદને'));
      expect(result.rows.first.isValid, isTrue);
    });

    test('3. Multi-line Sanskrit shlokas and Gujarati/Hindi line breaks inside quoted CSV fields are preserved', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati
"RAM-01-001-003","1","1","3","धर्मक्षेत्रे कुरुक्षेत्रे\nसमवेता युयुत्सवः\nमामकाः पाण्डवाश्चैव\nकिमकुर्वत सञ्जय","On the field of Kurukshetra\nAssembled together...","धर्मभूमि कुरुक्षेत्र में\nएकत्रित होकर...","ધર્મક્ષેત્ર કુરુક્ષેત્રમાં\nએકત્રિત થઈને..."
''';

      final file = createCsvFile(csvContent, 'multiline_test.csv');
      final result = await csvService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      final row = result.rows.first;
      expect(row.sanskrit, contains('\n'));
      expect(row.english, contains('\n'));
      expect(row.hindi, contains('\n'));
      expect(row.gujarati, contains('\n'));
      expect(row.sanskrit.split('\n').length, equals(4));
      expect(row.isValid, isTrue);
    });

    test('4. Optional language fields (e.g. null/empty Hindi or Gujarati) do NOT crash or invalidate the row', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati
RAM-01-001-004,1,1,4,को न्वस्मिन्सांप्रतं लोके...,Who in this world is currently endowed with virtues?,,
RAM-01-001-005,1,1,5,आत्मवान्को जितक्रोधो...,Who is self-controlled and has conquered anger?,,ધૈર્યવાન કોણ છે...
''';

      final file = createCsvFile(csvContent, 'optional_lang_test.csv');
      final result = await csvService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(2));
      expect(result.invalidRowsCount, equals(0));

      final row1 = result.rows[0];
      expect(row1.sanskrit, isNotEmpty);
      expect(row1.english, isNotEmpty);
      expect(row1.hindi, isNull);
      expect(row1.gujarati, isNull);
      expect(row1.isValid, isTrue);

      final row2 = result.rows[1];
      expect(row2.sanskrit, isNotEmpty);
      expect(row2.hindi, isNull);
      expect(row2.gujarati, isNotEmpty);
      expect(row2.isValid, isTrue);
    });

    test('5. Case-insensitive and Devanagari/Gujarati header aliases map correctly', () async {
      const csvContent = '''
ID,Kanda,Sarga,Verse,Sanskrit Shloka,English Translation,Hindi Meaning,Gujarati Translation
RAM-01-001-006,1,1,6,उच्यमानं त्वया बुद्ध्वा...,Hearing words spoken by you...,आपकी वाणी सुनकर...,તમારું વચન સાંભળીને...
''';

      final file = createCsvFile(csvContent, 'aliased_headers.csv');
      final result = await parserService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      final row = result.rows.first;
      expect(row.sanskrit, contains('उच्यमानं'));
      expect(row.english, contains('Hearing'));
      expect(row.hindi, contains('वाणी'));
      expect(row.gujarati, contains('વચન'));
      expect(row.isValid, isTrue);
    });
  });
}
