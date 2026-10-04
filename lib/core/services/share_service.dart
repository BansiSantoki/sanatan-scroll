import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/sacred_book_model.dart';
import '../../models/sacred_chapter_model.dart';
import '../../models/sacred_verse_model.dart';

class ShareService {
  ShareService._();

  static const String _playStoreLink =
      'https://play.google.com/store/apps/details?id=com.sanatanscroll.app&pcampaignid=web_share';

  static const String _appStoreLink =
      'https://apps.apple.com/gb/app/sanatan-scroll/id6764406241';

  static String get formattedStoreLinks {
    return 'Read more on Sanatan Scroll:\n\n'
        'App Store: $_appStoreLink\n\n'
        'Play Store: $_playStoreLink';
  }

  /// Share raw text directly using native Android/iOS platform share sheet.
  static Future<void> share({
    required String title,
    required String text,
    Rect? sharePositionOrigin,
  }) async {
    final String finalText = text.contains('Read more on Sanatan Scroll:')
        ? text
        : '$text\n\n$formattedStoreLinks';

    if (kDebugMode) {
      debugPrint('==================================================');
      debugPrint('[SHARE DEBUG] Share tapped');
      debugPrint('  platform: $defaultTargetPlatform');
      debugPrint('  title: $title');
      debugPrint('  share text generated:\n$finalText');
      debugPrint('  share action started');
      debugPrint('==================================================');
    }

    try {
      final result = await Share.share(
        finalText,
        subject: title,
        sharePositionOrigin: sharePositionOrigin ?? const Rect.fromLTWH(0, 0, 100, 100),
      );
      if (kDebugMode) {
        debugPrint('[SHARE DEBUG] share success: status=${result.status}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SHARE DEBUG] share failure: $e');
      }
    }
  }

  /// Builds standardized scripture verse share text with both App Store and Play Store links.
  static String buildShareText({
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
    required String langCode,
  }) {
    final cleanLang = langCode.toLowerCase().split('-').first.trim();
    final bookTitle = book.getLocalizedTitle(langCode);
    final sanskritText = verse.sanskrit.trim();
    final translationText = verse.getLocalizedTranslation(langCode).trim();

    String sectionAndVerseStr;
    String referenceStr;

    if (book.id == 'upanishads') {
      final mantraNum = chapter.chapterNumber > 0 ? chapter.chapterNumber : verse.verseNumber;
      if (cleanLang == 'hi') {
        sectionAndVerseStr = 'मंत्र $mantraNum';
      } else if (cleanLang == 'gu') {
        sectionAndVerseStr = 'મંત્ર $mantraNum';
      } else {
        sectionAndVerseStr = 'Mantra $mantraNum';
      }
      referenceStr = 'Mantra $mantraNum';
    } else if (book.id == 'ramayana' || verse.kandaNumber != null || verse.sargaNumber != null || chapter.chapterNumber >= 1000) {
      final kanda = verse.kandaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber ~/ 1000 : chapter.chapterNumber);
      final sarga = verse.sargaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber % 1000 : 1);
      final verseNum = verse.verseNumber;

      const kandaNames = [
        {'en': 'Bala Kanda', 'hi': 'बाल काण्ड', 'gu': 'બાળ કાંડ'},
        {'en': 'Ayodhya Kanda', 'hi': 'अयोध्या काण्ड', 'gu': 'અયોધ્યા કાંડ'},
        {'en': 'Aranya Kanda', 'hi': 'अरण्य काण्ड', 'gu': 'અરણ્ય કાંડ'},
        {'en': 'Kishkindha Kanda', 'hi': 'किष्किन्धा काण्ड', 'gu': 'કિષ્કિંધા કાંડ'},
        {'en': 'Sundara Kanda', 'hi': 'सुन्दर काण्ड', 'gu': 'સુંદર કાંડ'},
        {'en': 'Yuddha Kanda', 'hi': 'युद्ध काण्ड', 'gu': 'યુદ્ધ કાંડ'},
        {'en': 'Uttara Kanda', 'hi': 'उत्तर काण्ड', 'gu': 'ઉત્તર કાંડ'},
      ];

      final kMap = (kanda >= 1 && kanda <= 7) ? kandaNames[kanda - 1] : null;
      final kName = kMap != null
          ? (cleanLang == 'hi' ? kMap['hi']! : (cleanLang == 'gu' ? kMap['gu']! : kMap['en']!))
          : 'Kanda $kanda';

      final sargaWord = cleanLang == 'gu' ? 'સર્ગ' : (cleanLang == 'hi' ? 'सर्ग' : 'Sarga');
      final verseWord = cleanLang == 'gu' ? 'શ્લોક' : (cleanLang == 'hi' ? 'श्लोक' : 'Verse');

      sectionAndVerseStr = '$kName • $sargaWord $sarga • $verseWord $verseNum';
      referenceStr = '$kanda.$sarga.$verseNum';
    } else {
      // Bhagavad Gita and all other scriptures
      final chapNum = chapter.chapterNumber;
      final verseNum = verse.verseNumber;

      final chapWord = cleanLang == 'gu' ? 'અધ્યાય' : (cleanLang == 'hi' ? 'अध्याय' : 'Chapter');
      final verseWord = cleanLang == 'gu' ? 'શ્લોક' : (cleanLang == 'hi' ? 'श्लोक' : 'Verse');

      sectionAndVerseStr = '$chapWord $chapNum • $verseWord $verseNum';
      referenceStr = '$chapNum.$verseNum';
    }

    final buffer = StringBuffer();
    buffer.writeln('Sanatan Scroll');
    buffer.writeln();
    buffer.writeln(bookTitle);
    buffer.writeln(sectionAndVerseStr);
    buffer.writeln();
    if (sanskritText.isNotEmpty) {
      buffer.writeln(sanskritText);
      buffer.writeln();
    }
    buffer.writeln(translationText);
    buffer.writeln();
    buffer.writeln('Reference: $referenceStr');
    buffer.writeln();
    buffer.write(formattedStoreLinks);

    return buffer.toString();
  }

  /// Shares exact currently visible scripture verse content via native share sheet.
  static Future<void> shareVerse({
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
    required String langCode,
    Rect? sharePositionOrigin,
  }) async {
    final generatedText = buildShareText(
      book: book,
      chapter: chapter,
      verse: verse,
      langCode: langCode,
    );

    final verseId = verse.transliteration ?? '${book.id}_c${chapter.chapterNumber}_v${verse.verseNumber}';

    if (kDebugMode) {
      debugPrint('==================================================');
      debugPrint('[SHARE DEBUG] Share tapped');
      debugPrint('  platform: $defaultTargetPlatform');
      debugPrint('  bookId: ${book.id}');
      debugPrint('  verseId: $verseId');
      debugPrint('  verseNumber: ${verse.verseNumber}');
      debugPrint('  selectedLanguage: $langCode');
      debugPrint('  share text generated:\n$generatedText');
      debugPrint('  share action started');
      debugPrint('==================================================');
    }

    try {
      final result = await Share.share(
        generatedText,
        subject: '${book.getLocalizedTitle(langCode)} - Verse ${verse.verseNumber}',
        sharePositionOrigin: sharePositionOrigin ?? const Rect.fromLTWH(0, 0, 100, 100),
      );
      if (kDebugMode) {
        debugPrint('[SHARE DEBUG] share success: status=${result.status}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SHARE DEBUG] share failure: $e');
      }
    }
  }

  /// Open native platform share sheet directly.
  static Future<void> showOptions({
    required BuildContext context,
    required String title,
    required String text,
  }) async {
    final box = context.findRenderObject() as RenderBox?;
    final Rect? origin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;
    await share(title: title, text: text, sharePositionOrigin: origin);
  }
}



