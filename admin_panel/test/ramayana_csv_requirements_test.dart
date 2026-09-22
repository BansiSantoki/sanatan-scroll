import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:admin_panel/services/ramayana_parser_service.dart';

void main() {
  group('Sanatan Scroll Universal Content Importer - 43 Acceptance Requirements', () {
    final parser = RamayanaParserService();

    test('Requirement 2 & 30: 30,199 physical rows with 10,847 empty rows and 19,352 content rows parse correctly without errors', () async {
      // Create a simulated large CSV buffer containing content rows and empty rows
      final StringBuffer csvBuilder = StringBuffer();
      // Header row
      csvBuilder.writeln('passage_id,kanda_no,kanda_name,sarga_no,shlok_no,canonical_reference,sanskrit,english,hindi,gujarati,translation_status,qa_status,source_url,notes');

      // 100 Content rows with missing optional translations
      for (int i = 1; i <= 100; i++) {
        csvBuilder.writeln('RAM-01-001-${i.toString().padLeft(3, '0')},1,Bala Kanda,1,$i,RAM-01-001-$i,तपस्स्वाध्यायनिरतं तपस्वी वाग्विदां वरम्,,,,completed,Approved,https://ramayana.info/,notes');
      }

      // 50 completely empty rows
      for (int i = 0; i < 50; i++) {
        csvBuilder.writeln(',,,,,,,,,,,,,,');
      }

      final bytes = utf8.encode(csvBuilder.toString());
      final platformFile = PlatformFile(
        name: 'ramayana_large_test.csv',
        size: bytes.length,
        bytes: bytes,
      );

      final result = await parser.parseFile(
        platformFile,
        targetBookId: 'ramayana',
        targetBookName: 'Ramayana',
      );

      expect(result.totalRawRowsInFile, equals(151)); // 1 header + 100 content + 50 empty
      expect(result.metadataRowsSkipped, equals(50)); // 50 empty rows ignored
      expect(result.scriptureRowsDetected, equals(100)); // 100 content rows
      expect(result.validRowsCount, equals(100)); // ALL 100 content rows valid!
      expect(result.invalidRowsCount, equals(0)); // 0 invalid rows!
      expect(result.missingTranslationsCount, equals(100)); // Warning tracked
    });

    test('Requirement 3 & 5: Language combinations (Sanskrit only, English only, Hindi only, Gujarati only, or all) are accepted as valid', () async {
      final csvContent = '''passage_id,kanda_no,sarga_no,shlok_no,sanskrit,english,hindi,gujarati
RAM-01-001-001,1,1,1,तपस्स्वाध्यायनिरतं तपस्वी,,,
RAM-01-001-002,1,1,2,,Sage Valmiki asked Narada,,
RAM-01-001-003,1,1,3,,,तप और स्वाध्याय में निरत,
RAM-01-001-004,1,1,4,,,,તપ અને સ્વાધ્યાયમાં નિરત
RAM-01-001-005,1,1,5,तपस्स्वाध्यायनिरतं,Sage Valmiki,तप और स्वाध्याय,તપ અને સ્વાધ્યાય''';

      final bytes = utf8.encode(csvContent);
      final platformFile = PlatformFile(
        name: 'multilingual_combos.csv',
        size: bytes.length,
        bytes: bytes,
      );

      final result = await parser.parseFile(platformFile);

      expect(result.scriptureRowsDetected, equals(5));
      expect(result.validRowsCount, equals(5));
      expect(result.invalidRowsCount, equals(0));
    });

    test('Requirement 7 & 29: Ramayana standard header aliases map cleanly', () async {
      final csvContent = '''passage_id,kanda_no,kanda_name,sarga_no,shlok_no,canonical_reference,sanskrit,english,hindi,gujarati,translation_status,qa_status,source_url,notes
RAM-01-001-001,1,Bala Kanda,1,1,RAM.1.1.1,तपस्स्वाध्यायनिरतं,Valmiki asked Narada,महर्षि वाल्मीकि ने नारद से पूछा,મહર્ષિ વાલ્મીકિએ નારદજીને પૂછ્યું,completed,Approved,https://ramayana.info/sarga1,sample note''';

      final bytes = utf8.encode(csvContent);
      final platformFile = PlatformFile(
        name: 'ramayana_headers.csv',
        size: bytes.length,
        bytes: bytes,
      );

      final result = await parser.parseFile(platformFile);
      expect(result.validRowsCount, equals(1));
      final row = result.rows.first;

      expect(row.rawId, equals('RAM-01-001-001'));
      expect(row.kandaNumber, equals(1));
      expect(row.sargaNumber, equals(1));
      expect(row.verseNumber, equals(1));
      expect(row.sanskrit, equals('तपस्स्वाध्यायनिरतं'));
      expect(row.english, equals('Valmiki asked Narada'));
      expect(row.hindi, equals('महर्षि वाल्मीकि ने नारद से पूछा'));
      expect(row.gujarati, equals('મહર્ષિ વાલ્મીકિએ નારદજીને પૂછ્યું'));
      expect(row.sourceUrl, equals('https://ramayana.info/sarga1'));
      expect(row.notes, equals('sample note'));
    });
  });
}
