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
  final String? coverUrl;
  final String? description;
  final int order;
  final bool published;
  final bool archived;
  final int totalChapters;
  final int totalVerses;
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
    this.coverUrl,
    this.description,
    this.order = 1,
    this.published = true,
    this.archived = false,
    required this.totalChapters,
    this.totalVerses = 0,
    this.chapters = const [],
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
      map['totalChapters'] ?? map['total_chapters'],
      fallback: chapters.length,
    );

    final inferredVerses = _asInt(
      map['totalVerses'] ?? map['total_verses'],
      fallback: chapters.fold<int>(0, (sum, c) => sum + c.verses.length),
    );

    return SacredBookModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? map['title_en'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? map['subtitle_en'] ?? '').toString(),
      titleEn: map['title_en']?.toString(),
      titleGu: map['title_gu']?.toString(),
      titleHi: map['title_hi']?.toString(),
      subtitleEn: map['subtitle_en']?.toString(),
      subtitleGu: map['subtitle_gu']?.toString(),
      subtitleHi: map['subtitle_hi']?.toString(),
      iconEmoji: (map['iconEmoji'] ?? '📜').toString(),
      coverUrl: map['coverUrl']?.toString() ?? map['cover_url']?.toString(),
      description: (map['description'] ?? map['about'] ?? '').toString(),
      order: _asInt(map['order'], fallback: 1),
      published: map['published'] as bool? ?? map['is_published'] as bool? ?? (map['status'] == 'published' || map['status'] == null),
      archived: map['archived'] as bool? ?? (map['status'] == 'archived'),
      totalChapters: inferredTotal > 0 ? inferredTotal : chapters.length,
      totalVerses: inferredVerses,
      chapters: chapters,
    );
  }

  SacredBookModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? titleEn,
    String? titleGu,
    String? titleHi,
    String? subtitleEn,
    String? subtitleGu,
    String? subtitleHi,
    String? iconEmoji,
    String? coverUrl,
    String? description,
    int? order,
    bool? published,
    bool? archived,
    int? totalChapters,
    int? totalVerses,
    List<SacredChapterModel>? chapters,
  }) {
    return SacredBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      titleEn: titleEn ?? this.titleEn,
      titleGu: titleGu ?? this.titleGu,
      titleHi: titleHi ?? this.titleHi,
      subtitleEn: subtitleEn ?? this.subtitleEn,
      subtitleGu: subtitleGu ?? this.subtitleGu,
      subtitleHi: subtitleHi ?? this.subtitleHi,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      order: order ?? this.order,
      published: published ?? this.published,
      archived: archived ?? this.archived,
      totalChapters: totalChapters ?? this.totalChapters,
      totalVerses: totalVerses ?? this.totalVerses,
      chapters: chapters ?? this.chapters,
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
    if (languageCode == 'gu') {
      if (titleGu != null && titleGu!.isNotEmpty) return titleGu!;
      if (id == 'bhagavad_gita' || id == 'gita') return 'ભગવદ્ ગીતા';
      if (id == 'ramayana') return 'રામાયણ';
      if (id == 'upanishads') return 'ઉપનિષદો';
    }
    if (languageCode == 'hi') {
      if (titleHi != null && titleHi!.isNotEmpty) return titleHi!;
      if (id == 'bhagavad_gita' || id == 'gita') return 'भगवद्गीता';
      if (id == 'ramayana') return 'रामायण';
      if (id == 'upanishads') return 'उपनिषद';
    }
    if (languageCode == 'sa') {
      if (id == 'bhagavad_gita' || id == 'gita') return 'भगवद्गीता';
      if (id == 'ramayana') return 'रामायणम्';
      if (id == 'upanishads') return 'उपनिषदः';
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
    if (chapters.isEmpty) return null;

    // 1. Exact chapterNumber match
    for (final chapter in chapters) {
      if (chapter.chapterNumber == chapterNumber) {
        return chapter;
      }
    }

    // 2. 1-indexed positional fallback (if chapterNumber is between 1 and chapters.length)
    if (chapterNumber >= 1 && chapterNumber <= chapters.length) {
      return chapters[chapterNumber - 1];
    }

    // 3. Fallback to first chapter
    return chapters.first;
  }
}
