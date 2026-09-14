import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp, FieldValue;

class SacredChapterAdminModel {
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
  final int totalVerses;
  final bool published;
  final int order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SacredChapterAdminModel({
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
    this.totalVerses = 0,
    this.published = true,
    this.order = 1,
    this.createdAt,
    this.updatedAt,
  });

  factory SacredChapterAdminModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return SacredChapterAdminModel(
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
      totalVerses: _asInt(map['totalVerses'], fallback: 0),
      published: map['published'] as bool? ?? true,
      order: _asInt(map['order'], fallback: 1),
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
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
      'published': published,
      'order': order,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  SacredChapterAdminModel copyWith({
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
    bool? published,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SacredChapterAdminModel(
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
      published: published ?? this.published,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
