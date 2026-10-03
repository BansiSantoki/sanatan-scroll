import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import '../models/sacred_verse_model.dart';
import 'bhagavad_gita_excel_source_of_truth.dart';

class BhagavadGitaData {
  BhagavadGitaData._();

  static SacredBookModel? _gitaBookCache;

  static void clearCache() {
    _gitaBookCache = null;
  }

  static SacredBookModel buildGitaBook() {
    if (_gitaBookCache != null) return _gitaBookCache!;

    final Map<int, List<Map<String, dynamic>>> chapterGroupMap = {};
    for (final record in bhagavadGitaExcelSourceData) {
      final chapNo = (record['chapter_no'] as num?)?.toInt() ?? 1;
      chapterGroupMap.putIfAbsent(chapNo, () => []).add(record);
    }

    final sortedChapNos = chapterGroupMap.keys.toList()..sort();
    final List<SacredChapterModel> chapters = [];

    for (final chapNo in sortedChapNos) {
      final records = chapterGroupMap[chapNo]!;
      records.sort((a, b) {
        final vA = (a['verse_no'] as num?)?.toInt() ?? 1;
        final vB = (b['verse_no'] as num?)?.toInt() ?? 1;
        return vA.compareTo(vB);
      });

      final firstRecord = records.first;
      final chapName = (firstRecord['chapter_name'] ?? 'Chapter $chapNo').toString();

      final List<SacredVerseModel> verses = records.map((r) => SacredVerseModel.fromMap(r)).toList();

      chapters.add(
        SacredChapterModel(
          chapterNumber: chapNo,
          title: chapName,
          subtitle: 'Chapter $chapNo',
          titleEn: chapName,
          titleHi: chapName,
          titleGu: chapName,
          subtitleEn: 'Chapter $chapNo',
          subtitleHi: 'अध्याय $chapNo',
          subtitleGu: 'અધ્યાય $chapNo',
          descriptionEnglish: 'Chapter $chapNo of Bhagavad Gita: $chapName',
          descriptionHindi: 'भगवद् गीता अध्याय $chapNo: $chapName',
          descriptionGujarati: 'ભગવદ્ ગીતા અધ્યાય $chapNo: $chapName',
          verses: verses,
        ),
      );
    }

    _gitaBookCache = SacredBookModel(
      id: 'bhagavad_gita',
      title: 'Bhagavad Gita',
      subtitle: 'The Divine Song of Lord Krishna',
      titleEn: 'Bhagavad Gita',
      titleGu: 'ભગવદ્ ગીતા',
      titleHi: 'भगवद् गीता',
      subtitleEn: 'The Divine Song of Lord Krishna',
      subtitleGu: 'ભગવાન શ્રી કૃષ્ણનું દિવ્ય સંગીત',
      subtitleHi: 'भगवान श्री कृष्ण का दिव्य गीत',
      iconEmoji: '🕉️',
      totalChapters: chapters.length,
      chapters: chapters,
    );

    return _gitaBookCache!;
  }
}
