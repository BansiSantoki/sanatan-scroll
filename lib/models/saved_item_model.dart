enum SavedItemType { verse, reading, reflection }

class SavedItemModel {
  const SavedItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.source,
    this.savedAt,
  });

  final String id;
  final SavedItemType type;
  final String title;
  final String content;
  final String source;
  final DateTime? savedAt;

  factory SavedItemModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return SavedItemModel(
      id: id,
      type: _parseType((map['type'] ?? '').toString()),
      title: (map['title'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
      source: (map['source'] ?? '').toString(),
      savedAt: _parseDateTime(map['savedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'content': content,
      'source': source,
      'savedAt': savedAt?.toIso8601String(),
    };
  }

  String get typeLabel {
    switch (type) {
      case SavedItemType.verse:
        return 'Verse';
      case SavedItemType.reading:
        return 'Reading';
      case SavedItemType.reflection:
        return 'Reflection';
    }
  }

  static SavedItemType _parseType(String raw) {
    switch (raw) {
      case 'verse':
        return SavedItemType.verse;
      case 'reading':
        return SavedItemType.reading;
      case 'reflection':
        return SavedItemType.reflection;
      default:
        return SavedItemType.verse;
    }
  }

  static DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);

    final asString = raw.toString();
    return DateTime.tryParse(asString);
  }
}
