import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:universal_html/html.dart' as html;

class TemplateGeneratorService {
  static const List<String> csvHeaders = [
    'book_id',
    'book_name',
    'chapter_number',
    'chapter_title',
    'verse_number',
    'sanskrit',
    'gujarati',
    'hindi',
    'english',
    'explanation',
    'audio_url',
    'image_url',
    'status',
  ];

  static const List<List<String>> sampleRows = [
    [
      'bhagavad_gita',
      'Bhagavad Gita',
      '2',
      'Sankhya Yoga',
      '47',
      'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन। मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
      'તમને તમારું કર્તવ્ય કરવાનો અધિકાર છે, પરંતુ તેના ફળ પર નહીં.',
      'आपको अपने कर्तव्य का पालन करने का अधिकार है, लेकिन उसके फलों पर नहीं।',
      'You have a right to perform your prescribed duty, but you are not entitled to the fruits of action.',
      'Lord Krishna explains the philosophy of Nishkama Karma (selfless action).',
      'https://storage.googleapis.com/sanatan-scroll/audio/gita_2_47.mp3',
      'https://storage.googleapis.com/sanatan-scroll/images/gita_2_47.jpg',
      'published',
    ],
    [
      'bhagavad_gita',
      'Bhagavad Gita',
      '2',
      'Sankhya Yoga',
      '48',
      'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय। सिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते॥',
      'હે ધનંજય! સમભાવમાં સ્થિત રહીને કર્મો કરો.',
      'हे धनंजय! समत्व बुद्धि में स्थित होकर कर्म करो।',
      'Be steadfast in yoga, O Arjuna. Perform your duty and abandon all attachment to success or failure.',
      'True yoga is equanimity of mind amidst success and failure.',
      '',
      '',
      'published',
    ],
    [
      'ramayana',
      'Ramayana',
      '1',
      'Bala Kanda',
      '1',
      'तपःस्वाध्यायनिरतं तपस्वी वाग्विदां वरम्। नारदं परिपप्रच्छ वाल्मीकिर्मुनिपुङ्गवम्॥',
      'મહર્ષિ વાલ્મીકિએ દેવર્ષિ નારદને પવિત્ર ગુણો વિશે પૂછ્યું.',
      'महर्षि वाल्मीकि ने देवर्षि नारद से आदर्श पुरुष के गुणों के बारे में पूछा।',
      'Sage Valmiki inquired of Devarsi Narada about the ideal man possessed of all noble qualities.',
      'The opening shloka of Ramayana setting the stage for Sri Rama\'s virtues.',
      '',
      '',
      'published',
    ]
  ];

  /// Download CSV Template
  static void downloadCsvTemplate({String fileName = 'sanatan_scroll_verses_template.csv'}) {
    final List<List<dynamic>> rows = [csvHeaders, ...sampleRows];
    final String fullCsv = const ListToCsvConverter().convert(rows);

    final bytes = utf8.encode(fullCsv);

    final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  /// Download XLSX Template
  static void downloadXlsxTemplate({String fileName = 'sanatan_scroll_verses_template.xlsx'}) {
    final excel = Excel.createExcel();
    final sheet = excel['Verses_Template'];
    excel.setDefaultSheet('Verses_Template');

    // Add headers
    sheet.appendRow(csvHeaders.map((e) => TextCellValue(e)).toList());

    // Add sample rows
    for (final row in sampleRows) {
      sheet.appendRow(row.map((e) => TextCellValue(e)).toList());
    }

    final List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      final blob = html.Blob([fileBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    }
  }
}
