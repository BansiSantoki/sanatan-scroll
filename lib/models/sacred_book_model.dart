import 'sacred_chapter_model.dart';
class SacredBookModel {
  final String id;
  final String title;
  final String subtitle;
  final String iconEmoji;
  final int totalChapters;
  final List<SacredChapterModel> chapters;

  const SacredBookModel({
    required this.id,
    required this.title,
    required this.subtitle,
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
      'iconEmoji': iconEmoji,
      'totalChapters': totalChapters,
      'chapters': chapters.map((chapter) => chapter.toMap()).toList(),
    };
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
