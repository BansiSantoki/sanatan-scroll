class SacredVerseModel {
  final int verseNumber;

  final String sanskrit;
  final String english;
  final String gujarati;

  final String meaningEnglish;
  final String meaningGujarati;

  final String? transliteration;

  const SacredVerseModel({
    required this.verseNumber,
    required this.sanskrit,
    required this.english,
    required this.gujarati,
    required this.meaningEnglish,
    required this.meaningGujarati,
    this.transliteration,
  });

  factory SacredVerseModel.fromMap(Map<String, dynamic> map) {
    return SacredVerseModel(
      verseNumber: _asInt(
        map['verseNumber'],
        fallback: 1,
      ),
      sanskrit: (map['sanskrit'] ?? '').toString(),
      english: (map['english'] ?? '').toString(),
      gujarati: (map['gujarati'] ?? '').toString(),
      meaningEnglish: (map['meaningEnglish'] ?? '').toString(),
      meaningGujarati: (map['meaningGujarati'] ?? '').toString(),
      transliteration: map['transliteration']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verseNumber': verseNumber,
      'sanskrit': sanskrit,
      'english': english,
      'gujarati': gujarati,
      'meaningEnglish': meaningEnglish,
      'meaningGujarati': meaningGujarati,
      'transliteration': transliteration,
    };
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