import 'package:sanatan_scroll/models/sacred_verse_model.dart';

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

  factory SacredChapterModel.fromMap(
    Map<String, dynamic> map,
  ) {
    final List<SacredVerseModel> parsedVerses = [];

    final dynamic rawVerses = map['verses'];

    if (rawVerses is List) {
      for (final item in rawVerses) {
        if (item is Map<String, dynamic>) {
          parsedVerses.add(
            SacredVerseModel.fromMap(item),
          );
        } else if (item is Map) {
          parsedVerses.add(
            SacredVerseModel.fromMap(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return SacredChapterModel(
      chapterNumber: _asInt(
        map['chapterNumber'],
        fallback: 1,
      ),
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      descriptionEnglish:
          (map['descriptionEnglish'] ?? '').toString(),
      descriptionGujarati:
          (map['descriptionGujarati'] ?? '').toString(),
      verses: parsedVerses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapterNumber': chapterNumber,
      'title': title,
      'subtitle': subtitle,
      'descriptionEnglish': descriptionEnglish,
      'descriptionGujarati': descriptionGujarati,
      'verses': verses
          .map(
            (verse) => verse.toMap(),
          )
          .toList(),
    };
  }

  SacredVerseModel? getVerse(int verseNumber) {
    for (final verse in verses) {
      if (verse.verseNumber == verseNumber) {
        return verse;
      }
    }

    return null;
  }

  static int _asInt(
    dynamic value, {
    required int fallback,
  }) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }
}