import 'sacred_verse_model.dart';

class SacredChapterModel {
  final int chapterNumber;
  final String title;
  final String subtitle;
  final String descriptionEnglish;
  final String descriptionGujarati;
  final List<SacredVerseModel> verses;

  const SacredChapterModel({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.descriptionEnglish,
    required this.descriptionGujarati,
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
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      descriptionEnglish: (map['descriptionEnglish'] ?? '').toString(),
      descriptionGujarati: (map['descriptionGujarati'] ?? '').toString(),
      verses: verses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterNumber': chapterNumber,
      'title': title,
      'subtitle': subtitle,
      'descriptionEnglish': descriptionEnglish,
      'descriptionGujarati': descriptionGujarati,
      'verses': verses.map((v) => v.toMap()).toList(),
    };
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  int get totalVerses => verses.length;
}
