import 'dart:io';
import 'package:excel/excel.dart';
import 'dart:convert';

final inputPath = 'admin_panel/tmp/Sanatan_Scroll_Isha_Upanishad_DEVELOPER_FINAL_v2.xlsx';
final outCsv = 'admin_panel/tmp/upanishads_import.csv';
final outJson = 'admin_panel/tmp/upanishads_report.json';
final outMd = 'admin_panel/tmp/upanishads_report.md';

String findColumn(List<Data?> headerRow, List<String> candidates) {
  for (var i = 0; i < headerRow.length; i++) {
    final cell = headerRow[i];
    if (cell == null) continue;
    final s = cell.value.toString().toLowerCase();
    for (final c in candidates) {
      if (s == c || s.contains(c)) return i.toString();
    }
  }
  return ''; // not found
}

void main(List<String> args) {
  final file = File(inputPath);
  if (!file.existsSync()) {
    print('Input file not found: $inputPath');
    exit(1);
  }

  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  final rowsOut = <Map<String, dynamic>>[];
  final stats = {
    'file': inputPath,
    'sheets': {},
    'total_rows': 0,
    'valid_rows': 0,
    'invalid_rows': 0,
  };

  for (final sheetName in excel.tables.keys) {
    final table = excel.tables[sheetName]!;
    final rows = table.maxRows;
    (stats['sheets'] as Map)[sheetName] = {'rows': rows};

    List<Data?> headerRow = [];
    if (table.rows.isNotEmpty) headerRow = table.rows.first;

    // header mapping candidates
    final mapCandidates = {
      'id': ['id', 'rawid', 'raw_id', 'verseid', 'verse_id'],
      'canonical': ['canonical', 'canonicalref', 'canonical_ref'],
      'verse': ['verse', 'sanskrit', 'shloka', 'verse_text'],
      'english': ['english', 'translation', 'translation_en'],
      'hindi': ['hindi', 'translation_hi'],
      'gujarati': ['gujarati']
    };

    // naive mapping: store index as int or -1
    final colIndex = <String, int>{};
    for (final k in mapCandidates.keys) {
      colIndex[k] = -1;
      for (var i = 0; i < headerRow.length; i++) {
        final cell = headerRow[i];
        if (cell == null) continue;
        final s = cell.value.toString().toLowerCase();
        for (final cand in mapCandidates[k]!) {
          if (s == cand || s.contains(cand)) {
            colIndex[k] = i;
            break;
          }
        }
        if (colIndex[k] != -1) break;
      }
    }

    var sheetValid = 0;
    for (var r = 1; r < table.rows.length; r++) {
      stats['total_rows'] = (stats['total_rows'] as int) + 1;
      final row = table.rows[r];
      String cellVal(int idx) {
        if (idx < 0 || idx >= row.length) return '';
        final c = row[idx];
        if (c == null) return '';
        return c.value?.toString() ?? '';
      }

      final rawId = colIndex['id']! >= 0 ? cellVal(colIndex['id']!) : '';
      final canonical = colIndex['canonical']! >= 0 ? cellVal(colIndex['canonical']!) : '';
      final sanskrit = colIndex['verse']! >= 0 ? cellVal(colIndex['verse']!) : '';
      final english = colIndex['english']! >= 0 ? cellVal(colIndex['english']!) : '';
      final hindi = colIndex['hindi']! >= 0 ? cellVal(colIndex['hindi']!) : '';
      final gujarati = colIndex['gujarati']! >= 0 ? cellVal(colIndex['gujarati']!) : '';

      var resolvedId = rawId.isNotEmpty ? rawId : (canonical.isNotEmpty ? canonical : '');
      if (resolvedId.isEmpty) {
        final trailing = RegExp(r"(\d+)$");
        for (final v in [sanskrit, english]) {
          if (v.isEmpty) continue;
          final m = trailing.firstMatch(v);
          if (m != null) {
            resolvedId = m.group(1) ?? '';
            break;
          }
        }
      }
      if (resolvedId.isEmpty) resolvedId = '$sheetName-$r';

      final valid = (sanskrit.trim().isNotEmpty) || (english.trim().isNotEmpty);
      if (valid) {
        stats['valid_rows'] = (stats['valid_rows'] as int) + 1;
        sheetValid++;
      } else {
        stats['invalid_rows'] = (stats['invalid_rows'] as int) + 1;
      }

      rowsOut.add({
        'id': resolvedId,
        'sheet': sheetName,
        'row_index': r + 1,
        'sanskrit': sanskrit.trim(),
        'english': english.trim(),
        'hindi': hindi.trim(),
        'gujarati': gujarati.trim(),
        'valid': valid,
      });
    }
    ((stats['sheets'] as Map)[sheetName] as Map)['valid_rows'] = sheetValid;
  }

  // write CSV
  final csvFile = File(outCsv);
  csvFile.parent.createSync(recursive: true);
  final sink = csvFile.openWrite(encoding: Utf8Codec());
  sink.writeln('id,sheet,row_index,sanskrit,english,hindi,gujarati,valid');
  for (final r in rowsOut) {
    final line = '"${r['id']}","${r['sheet']}","${r['row_index']}","${r['sanskrit']}","${r['english']}","${r['hindi']}","${r['gujarati']}","${r['valid']}"';
    sink.writeln(line);
  }
  sink.close();

  final jsonFile = File(outJson);
  jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(stats), encoding: Utf8Codec());
  final mdFile = File(outMd);
  final md = StringBuffer();
  md.writeln('# Upanishads Parse Report');
  md.writeln();
  md.writeln('- Input: $inputPath');
  md.writeln('- Total rows scanned: ${stats['total_rows']}');
  md.writeln('- Valid rows: ${stats['valid_rows']}');
  md.writeln('- Invalid rows: ${stats['invalid_rows']}');
  md.writeln();
  md.writeln('## Sheets');
  (stats['sheets'] as Map).forEach((k, v) {
    final m = v as Map;
    md.writeln('- $k: ${m['rows']} rows, ${m['valid_rows']} valid');
  });
  mdFile.writeAsStringSync(md.toString(), encoding: Utf8Codec());

  print('Wrote CSV: $outCsv');
  print('Wrote report: $outJson and $outMd');
}
