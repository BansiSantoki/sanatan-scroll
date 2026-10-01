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

  SacredChapterModel copyWith({
    int? chapterNumber,
    String? title,
    String? subtitle,
    String? titleEn,
    String? titleGu,
    String? titleHi,
    String? subtitleEn,
    String? subtitleGu,
    String? subtitleHi,
    String? descriptionEnglish,
    String? descriptionGujarati,
    String? descriptionHindi,
    List<SacredVerseModel>? verses,
  }) {
    return SacredChapterModel(
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      titleEn: titleEn ?? this.titleEn,
      titleGu: titleGu ?? this.titleGu,
      titleHi: titleHi ?? this.titleHi,
      subtitleEn: subtitleEn ?? this.subtitleEn,
      subtitleGu: subtitleGu ?? this.subtitleGu,
      subtitleHi: subtitleHi ?? this.subtitleHi,
      descriptionEnglish: descriptionEnglish ?? this.descriptionEnglish,
      descriptionGujarati: descriptionGujarati ?? this.descriptionGujarati,
      descriptionHindi: descriptionHindi ?? this.descriptionHindi,
      verses: verses ?? this.verses,
    );
  }

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
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (titleGu != null && titleGu!.trim().isNotEmpty) return titleGu!;
    }
    if (code == 'hi') {
      if (titleHi != null && titleHi!.trim().isNotEmpty) return titleHi!;
    }
    if (titleEn != null && titleEn!.trim().isNotEmpty) {
      return titleEn!;
    }
    if (title.trim().isNotEmpty) return title;
    return 'Chapter $chapterNumber';
  }

  String getLocalizedSubtitle(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (subtitleGu != null && subtitleGu!.trim().isNotEmpty) return subtitleGu!;
      return 'અધ્યાય $chapterNumber';
    }
    if (code == 'hi') {
      if (subtitleHi != null && subtitleHi!.trim().isNotEmpty) return subtitleHi!;
      return 'अध्याय $chapterNumber';
    }
    if (subtitleEn != null && subtitleEn!.trim().isNotEmpty) {
      return subtitleEn!;
    }
    if (subtitle.trim().isNotEmpty) return subtitle;
    return 'Chapter $chapterNumber';
  }

  String getLocalizedDescription(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu' && descriptionGujarati.trim().isNotEmpty) {
      return descriptionGujarati;
    }
    if (code == 'hi' && descriptionHindi != null && descriptionHindi!.trim().isNotEmpty) {
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
