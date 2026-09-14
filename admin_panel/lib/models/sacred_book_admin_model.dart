import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp, FieldValue;

class SacredBookAdminModel {
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
  final int totalChapters;
  final int order;
  final bool published;
  final bool archived;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SacredBookAdminModel({
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
    required this.totalChapters,
    this.order = 1,
    this.published = true,
    this.archived = false,
    this.createdAt,
    this.updatedAt,
  });

  factory SacredBookAdminModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return SacredBookAdminModel(
      id: id,
      title: (map['title'] ?? map['title_en'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? map['subtitle_en'] ?? '').toString(),
      titleEn: map['title_en']?.toString(),
      titleGu: map['title_gu']?.toString(),
      titleHi: map['title_hi']?.toString(),
      subtitleEn: map['subtitle_en']?.toString(),
      subtitleGu: map['subtitle_gu']?.toString(),
      subtitleHi: map['subtitle_hi']?.toString(),
      iconEmoji: (map['iconEmoji'] ?? '📜').toString(),
      coverUrl: map['coverUrl']?.toString(),
      totalChapters: _asInt(map['totalChapters'], fallback: 0),
      order: _asInt(map['order'], fallback: 1),
      published: map['published'] as bool? ?? true,
      archived: map['archived'] as bool? ?? false,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
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
      'coverUrl': coverUrl,
      'totalChapters': totalChapters,
      'order': order,
      'published': published,
      'archived': archived,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  SacredBookAdminModel copyWith({
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
    int? totalChapters,
    int? order,
    bool? published,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SacredBookAdminModel(
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
      totalChapters: totalChapters ?? this.totalChapters,
      order: order ?? this.order,
      published: published ?? this.published,
      archived: archived ?? this.archived,
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
