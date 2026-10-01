import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:universal_html/html.dart' as html;

class ExcelExportService {
  /// Exports current Firestore data for the selected book as .xlsx or .csv
  static Future<int> exportBookData({
    required String bookId,
    required String bookName,
    bool asCsv = false,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final bookRef = firestore.collection('sacred_books').doc(bookId);
      final chaptersSnap = await bookRef.collection('chapters').get();

      final List<List<dynamic>> rows = [
        // Standard header row matching importer candidates
        [
          'passage_id',
          'book_id',
          'book_name',
          'kanda_number',
          'kanda_name',
          'sarga_number',
          'verse_number',
          'canonical_reference',
          'sanskrit',
          'english',
          'hindi',
          'gujarati',
          'meaning_english',
          'meaning_hindi',
          'meaning_gujarati',
          'source_url',
          'qa_status',
          'notes',
        ]
      ];

      final sortedChapDocs = chaptersSnap.docs.toList();
      sortedChapDocs.sort((a, b) {
        final numA = _asInt(a.data()['chapterNumber'] ?? a.data()['kanda_number'], fallback: 1);
        final numB = _asInt(b.data()['chapterNumber'] ?? b.data()['kanda_number'], fallback: 1);
        return numA.compareTo(numB);
      });

      for (final chapDoc in sortedChapDocs) {
        final cData = chapDoc.data();
        final kNum = _asInt(cData['kanda_number'] ?? cData['chapterNumber'], fallback: 1);
        final kName = (cData['kanda_name'] ?? cData['title'] ?? 'Chapter $kNum').toString();
        final sNum = _asInt(cData['sarga_number'] ?? cData['section_number'], fallback: 1);

        final versesSnap = await chapDoc.reference.collection('verses').get();
        final sortedVerseDocs = versesSnap.docs.toList();

        sortedVerseDocs.sort((a, b) {
          final sargaA = _asInt(a.data()['sarga_number'] ?? a.data()['sargaNumber'], fallback: 1);
          final sargaB = _asInt(b.data()['sarga_number'] ?? b.data()['sargaNumber'], fallback: 1);
          if (sargaA != sargaB) return sargaA.compareTo(sargaB);
          final vA = _asInt(a.data()['verse_number'] ?? a.data()['verseNumber'], fallback: 1);
          final vB = _asInt(b.data()['verse_number'] ?? b.data()['verseNumber'], fallback: 1);
          return vA.compareTo(vB);
        });

        for (final vDoc in sortedVerseDocs) {
          final vData = vDoc.data();
          final vNum = _asInt(vData['verse_number'] ?? vData['verseNumber'], fallback: 1);
          final verseSNum = _asInt(vData['sarga_number'] ?? sNum, fallback: 1);
          final verseKNum = _asInt(vData['kanda_number'] ?? kNum, fallback: 1);

          final pId = vDoc.id.startsWith('RAM-') || vDoc.id.startsWith('GIT-') || vDoc.id.startsWith('MAH-') || vDoc.id.startsWith('UPN-')
              ? vDoc.id
              : '$bookId-$verseKNum-$verseSNum-$vNum';

          final ref = '$bookId $verseKNum.$verseSNum.$vNum';

          rows.add([
            pId,
            bookId,
            bookName,
            verseKNum,
            kName,
            verseSNum,
            vNum,
            ref,
            vData['sanskrit'] ?? vData['sanskritText'] ?? '',
            vData['english'] ?? vData['translation_en'] ?? '',
            vData['hindi'] ?? vData['translation_hi'] ?? '',
            vData['gujarati'] ?? vData['translation_gu'] ?? '',
            vData['meaningEnglish'] ?? vData['meaning_en'] ?? '',
            vData['meaningHindi'] ?? vData['meaning_hi'] ?? '',
            vData['meaningGujarati'] ?? vData['meaning_gu'] ?? '',
            vData['source_url'] ?? vData['sourceUrl'] ?? '',
            vData['qa_status'] ?? vData['qaStatus'] ?? 'Approved',
            vData['notes'] ?? '',
          ]);
        }
      }

      if (asCsv) {
        final csvString = const ListToCsvConverter().convert(rows);
        final bytes = utf8.encode(csvString);
        _downloadBytes(bytes, '${bookId}_export.csv', 'text/csv');
      } else {
        final excel = Excel.createExcel();
        final Sheet sheetObject = excel['Sheet1'];
        excel.setDefaultSheet('Sheet1');

        for (final r in rows) {
          sheetObject.appendRow(r.map((e) => TextCellValue(e.toString())).toList());
        }

        final fileBytes = excel.save();
        if (fileBytes != null) {
          _downloadBytes(fileBytes, '${bookId}_export.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        }
      }
      return rows.length - 1;
    } catch (e) {
      print('Excel export error: $e');
      rethrow;
    }
  }

  static void _downloadBytes(List<int> bytes, String fileName, String mimeType) {
    try {
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Download trigger error: $e');
    }
  }

  static int _asInt(dynamic val, {required int fallback}) {
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? fallback;
    return fallback;
  }
}
