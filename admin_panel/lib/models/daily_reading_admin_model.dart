import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp, FieldValue;

class DailyReadingAdminModel {
  final String id;
  final String dateString; // YYYY-MM-DD
  final String bookId;
  final int chapterNumber;
  final int verseNumber;
  final String title;
  final String description;
  final bool published;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DailyReadingAdminModel({
    required this.id,
    required this.dateString,
    required this.bookId,
    required this.chapterNumber,
    required this.verseNumber,
    required this.title,
    required this.description,
    this.published = true,
    this.createdAt,
    this.updatedAt,
  });

  factory DailyReadingAdminModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return DailyReadingAdminModel(
      id: id,
      dateString: (map['dateString'] ?? map['date'] ?? '').toString(),
      bookId: (map['bookId'] ?? '').toString(),
      chapterNumber: _asInt(map['chapterNumber'], fallback: 1),
      verseNumber: _asInt(map['verseNumber'], fallback: 1),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      published: map['published'] as bool? ?? true,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateString': dateString,
      'date': dateString,
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'verseNumber': verseNumber,
      'title': title,
      'description': description,
      'published': published,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
