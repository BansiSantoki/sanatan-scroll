import 'sacred_verse_model.dart';

class SacredChapterModel {
  final int chapterNumber;
  final String title;
  final String subtitle;
  final String? titleEn;
  final String? titleGu;
  final String? titleHi;
  final String? subtitleEn;
  final String? subtitleGu;
  final String? subtitleHi;
  final String descriptionEnglish;
  final String descriptionGujarati;
  final String? descriptionHindi;
  final List<SacredVerseModel> verses;

  const SacredChapterModel({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    this.titleEn,
    this.titleGu,
    this.titleHi,
    this.subtitleEn,
    this.subtitleGu,
    this.subtitleHi,
    required this.descriptionEnglish,
    required this.descriptionGujarati,
    this.descriptionHindi,
    required this.verses,
  });

  factory SacredChapterModel.fromMap(Map<String, dynamic> map) {
    final rawVerses = map['verses'];
    final verses = rawVerses is List
        ? rawVerses
            .whereType<Map>()
            .map((v) => SacredVerseModel.fromMap(Map<String, dynamic>.from(v)))
            .toList()
        : <SacredVerseModel>[];

    return SacredChapterModel(
      chapterNumber: _asInt(map['chapterNumber'], fallback: 1),
      title: (map['title'] ?? map['title_en'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? map['subtitle_en'] ?? '').toString(),
      titleEn: map['title_en']?.toString(),
      titleGu: map['title_gu']?.toString(),
      titleHi: map['title_hi']?.toString(),
      subtitleEn: map['subtitle_en']?.toString(),
      subtitleGu: map['subtitle_gu']?.toString(),
      subtitleHi: map['subtitle_hi']?.toString(),
      descriptionEnglish: (map['descriptionEnglish'] ?? map['description_en'] ?? '').toString(),
      descriptionGujarati: (map['descriptionGujarati'] ?? map['description_gu'] ?? '').toString(),
      descriptionHindi: map['descriptionHindi']?.toString() ?? map['description_hi']?.toString(),
      verses: verses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterNumber': chapterNumber,
      'title': title,
      'subtitle': subtitle,
      'title_en': titleEn,
      'title_gu': titleGu,
      'title_hi': titleHi,
      'subtitle_en': subtitleEn,
      'subtitle_gu': subtitleGu,
      'subtitle_hi': subtitleHi,
      'descriptionEnglish': descriptionEnglish,
      'descriptionGujarati': descriptionGujarati,
      'descriptionHindi': descriptionHindi,
      'verses': verses.map((v) => v.toMap()).toList(),
    };
  }

  String getLocalizedTitle(String languageCode) {
    if (languageCode == 'gu' && titleGu != null && titleGu!.isNotEmpty) {
      return titleGu!;
    }
    if (languageCode == 'hi' && titleHi != null && titleHi!.isNotEmpty) {
      return titleHi!;
    }
    if (titleEn != null && titleEn!.isNotEmpty) {
      return titleEn!;
    }
    return title;
  }

  String getLocalizedSubtitle(String languageCode) {
    if (languageCode == 'gu' && subtitleGu != null && subtitleGu!.isNotEmpty) {
      return subtitleGu!;
    }
    if (languageCode == 'hi' && subtitleHi != null && subtitleHi!.isNotEmpty) {
      return subtitleHi!;
    }
    if (subtitleEn != null && subtitleEn!.isNotEmpty) {
      return subtitleEn!;
    }
    return subtitle;
  }

  String getLocalizedDescription(String languageCode) {
    if (languageCode == 'gu' && descriptionGujarati.isNotEmpty) {
      return descriptionGujarati;
    }
    if (languageCode == 'hi' && descriptionHindi != null && descriptionHindi!.isNotEmpty) {
      return descriptionHindi!;
    }
    return descriptionEnglish;
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  int get totalVerses => verses.length;
}
