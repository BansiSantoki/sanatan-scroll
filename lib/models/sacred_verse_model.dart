class SacredVerseModel {
  final int verseNumber;

  final String sanskrit;
  final String english;
  final String gujarati;
  final String? hindi;

  final String meaningEnglish;
  final String meaningGujarati;
  final String? meaningHindi;

  final String? transliteration;

  const SacredVerseModel({
    required this.verseNumber,
    required this.sanskrit,
    required this.english,
    required this.gujarati,
    this.hindi,
    required this.meaningEnglish,
    required this.meaningGujarati,
    this.meaningHindi,
    this.transliteration,
  });

  factory SacredVerseModel.fromMap(Map<String, dynamic> map) {
    return SacredVerseModel(
      verseNumber: _asInt(
        map['verseNumber'],
        fallback: 1,
      ),
      sanskrit: (map['sanskrit'] ?? '').toString(),
      english: (map['english'] ?? map['translation_en'] ?? '').toString(),
      gujarati: (map['gujarati'] ?? map['translation_gu'] ?? '').toString(),
      hindi: map['hindi']?.toString() ?? map['translation_hi']?.toString(),
      meaningEnglish: (map['meaningEnglish'] ?? map['explanation_en'] ?? '').toString(),
      meaningGujarati: (map['meaningGujarati'] ?? map['explanation_gu'] ?? '').toString(),
      meaningHindi: map['meaningHindi']?.toString() ?? map['explanation_hi']?.toString(),
      transliteration: map['transliteration']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verseNumber': verseNumber,
      'sanskrit': sanskrit,
      'english': english,
      'gujarati': gujarati,
      'hindi': hindi,
      'meaningEnglish': meaningEnglish,
      'meaningGujarati': meaningGujarati,
      'meaningHindi': meaningHindi,
      'transliteration': transliteration,
    };
  }

  String getLocalizedTranslation(String languageCode) {
    if (languageCode == 'gu' && gujarati.isNotEmpty) {
      return gujarati;
    }
    if (languageCode == 'hi' && hindi != null && hindi!.isNotEmpty) {
      return hindi!;
    }
    return english;
  }

  String getLocalizedMeaning(String languageCode) {
    if (languageCode == 'gu' && meaningGujarati.isNotEmpty) {
      return meaningGujarati;
    }
    if (languageCode == 'hi' && meaningHindi != null && meaningHindi!.isNotEmpty) {
      return meaningHindi!;
    }
    return meaningEnglish;
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