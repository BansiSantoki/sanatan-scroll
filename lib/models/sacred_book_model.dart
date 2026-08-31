import 'sacred_chapter_model.dart';

class SacredBookModel {
  final String id;
  final String title;
  final String subtitle;
  final String? titleEn;
  final String? titleGu;
  final String? titleHi;
  final String? subtitleEn;
  final String? subtitleGu;
  final String? subtitleHi;
  final String iconEmoji;
  final int totalChapters;
  final List<SacredChapterModel> chapters;

  const SacredBookModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.titleEn,
    this.titleGu,
    this.titleHi,
    this.subtitleEn,
    this.subtitleGu,
    this.subtitleHi,
    required this.iconEmoji,
    required this.totalChapters,
    required this.chapters,
  });

  factory SacredBookModel.fromMap(Map<String, dynamic> map) {
    final rawChapters = map['chapters'];
    final chapters = rawChapters is List
        ? rawChapters
            .whereType<Map>()
            .map(
              (chapter) => SacredChapterModel.fromMap(
                Map<String, dynamic>.from(chapter),
              ),
            )
            .toList()
        : <SacredChapterModel>[];

    final inferredTotal = _asInt(
      map['totalChapters'],
      fallback: chapters.length,
    );

    return SacredBookModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      titleEn: map['title_en']?.toString(),
      titleGu: map['title_gu']?.toString(),
      titleHi: map['title_hi']?.toString(),
      subtitleEn: map['subtitle_en']?.toString(),
      subtitleGu: map['subtitle_gu']?.toString(),
      subtitleHi: map['subtitle_hi']?.toString(),
      iconEmoji: (map['iconEmoji'] ?? '').toString(),
      totalChapters: inferredTotal > 0 ? inferredTotal : chapters.length,
      chapters: chapters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'title_en': titleEn,
      'title_gu': titleGu,
      'title_hi': titleHi,
      'subtitle_en': subtitleEn,
      'subtitle_gu': subtitleGu,
      'subtitle_hi': subtitleHi,
      'iconEmoji': iconEmoji,
      'totalChapters': totalChapters,
      'chapters': chapters.map((chapter) => chapter.toMap()).toList(),
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

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  SacredChapterModel? getChapter(int chapterNumber) {
    try {
      return chapters.firstWhere(
        (chapter) => chapter.chapterNumber == chapterNumber,
      );
    } catch (_) {
      return null;
    }
  }
}
