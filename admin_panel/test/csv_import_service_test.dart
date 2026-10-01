import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_panel/services/csv_import_service.dart';

void main() {
  late CsvImportService csvImportService;

  setUp(() {
    csvImportService = CsvImportService();
  });

  PlatformFile createCsvFile(String csvContent, String filename) {
    final bytes = Uint8List.fromList(utf8.encode(csvContent));
    return PlatformFile(
      name: filename,
      size: bytes.length,
      bytes: bytes,
    );
  }

  group('CsvImportService Complete Test Suite (CSV-First Architecture)', () {
    test('1. Completely valid Ramayana CSV row parses cleanly with RAM-01-067-001', () async {
      const csvContent = '''
id,book_id,book_name,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati,source_url,status,qa_status
RAM-01-067-001,ramayana,Ramayana,1,67,1,जनकस्य वचःश्रुत्वा विश्वामित्रो महामुनिः...,At the words of Janaka...,,,https://ramayana.info/story/bala/67/,published,approved
''';

      final file = createCsvFile(csvContent, 'ramayana_test.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana', targetBookName: 'Ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('RAM-01-067-001'));
      expect(result.rows[0].kandaNumber, equals(1));
      expect(result.rows[0].sargaNumber, equals(67));
      expect(result.rows[0].verseNumber, equals(1));
      expect(result.rows[0].sanskrit, contains('जनकस्य'));
      expect(result.rows[0].english, contains('Janaka'));
      expect(result.rows[0].hindi, isNull);
      expect(result.rows[0].gujarati, isNull);
      expect(result.rows[0].isValid, isTrue);
    });

    test('2. Blank Hindi and Gujarati optional cells produce null without throwing exception', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं...,Valmiki asked,,
''';

      final file = createCsvFile(csvContent, 'optional_nulls.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].hindi, isNull);
      expect(result.rows[0].gujarati, isNull);
      expect(result.rows[0].isValid, isTrue);
    });

    test('3. Missing Sanskrit and translations flags row as invalid with "Missing required content"', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english
RAM-01-001-002,1,1,2,,
''';

      final file = createCsvFile(csvContent, 'missing_sanskrit.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('Missing required content'));
    });

    test('4. Missing ID auto-generates ID from Kanda/Sarga/Verse', () async {
      const csvContent = '''
kanda_number,sarga_number,verse_number,sanskrit,english
1,1,3,तपःस्वाध्यायनिरतं...,Valmiki asked Narada
''';

      final file = createCsvFile(csvContent, 'missing_id.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('RAM-01-001-003'));
    });

    test('5. Conflicting ID vs explicit column numbers flags invalid row', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english
RAM-01-001-001,2,1,1,तपःस्वाध्यायनिरतं...,English 1
''';

      final file = createCsvFile(csvContent, 'conflict.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana');

      expect(result.invalidRowsCount, equals(1));
      expect(result.rows[0].validationErrors.first, contains('ID Kanda value conflicts with explicit Kanda value'));
    });

    test('6. Completely empty CSV rows are skipped cleanly', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं...,English 1
,,,,,
RAM-01-001-002,1,1,2,को न्वस्मिन्सांप्रतं...,English 2
''';

      final file = createCsvFile(csvContent, 'empty_rows.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana');

      expect(result.scriptureRowsDetected, equals(2));
      expect(result.validRowsCount, equals(2));
    });

    test('7. Mahabharata CSV parses with Parva / Section structure', () async {
      const csvContent = '''
id,parva,section,verse,sanskrit,english
MAH-01-001-001,1,1,1,नारायणं नमस्कृत्य...,Mahabharata opening
''';

      final file = createCsvFile(csvContent, 'mahabharata.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'mahabharata', targetBookName: 'Mahabharata');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('MAH-01-001-001'));
      expect(result.rows[0].bookId, equals('mahabharata'));
    });

    test('8. Bhagavad Gita CSV parses with Chapter / Verse structure (no mandatory Sarga)', () async {
      const csvContent = '''
id,chapter,verse,sanskrit,english
GIT-01-001,1,1,धर्मक्षेत्रे कुरुक्षेत्रे...,Dhritarashtra asked
''';

      final file = createCsvFile(csvContent, 'gita.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'bhagavad_gita', targetBookName: 'Bhagavad Gita');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].verseId, equals('GIT-01-001'));
      expect(result.rows[0].bookId, equals('bhagavad_gita'));
      expect(result.rows[0].chapterNumber, equals(1));
      expect(result.rows[0].verseNumber, equals(1));
    });

    test('9. UTF-8 Unicode Devanagari, Gujarati, English special characters are preserved exactly', () async {
      const csvContent = '''
id,kanda_number,sarga_number,verse_number,sanskrit,english,hindi,gujarati
RAM-01-001-001,1,1,1,तपःस्वाध्यायनिरतं तपस्वी वाग्विदां वरम्,Valmiki's question,वाल्मीकि का प्रश्न,વાલ્મિકીનો પ્રશ્ન
''';

      final file = createCsvFile(csvContent, 'unicode.csv');
      final result = await csvImportService.parseFile(file, targetBookId: 'ramayana');

      expect(result.validRowsCount, equals(1));
      expect(result.rows[0].sanskrit, equals('तपःस्वाध्यायनिरतं तपस्वी वाग्विदां वरम्'));
      expect(result.rows[0].english, equals("Valmiki's question"));
      expect(result.rows[0].hindi, equals('वाल्मीकि का प्रश्न'));
      expect(result.rows[0].gujarati, equals('વાલ્મિકીનો પ્રશ્ન'));
    });
  });
}
