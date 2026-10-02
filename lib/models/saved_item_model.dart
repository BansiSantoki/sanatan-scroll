enum SavedItemType { verse, reading, reflection }

class SavedLocation {
  final String bookId;
  final int chapterNumber;
  final int? kandaNumber;
  final int? sargaNumber;
  final int verseNumber;
  final int? mantraNumber;
  final String? verseId;
  final String? passageId;

  const SavedLocation({
    required this.bookId,
    required this.chapterNumber,
    this.kandaNumber,
    this.sargaNumber,
    required this.verseNumber,
    this.mantraNumber,
    this.verseId,
    this.passageId,
  });

  Map<String, dynamic> toRouteArguments() {
    return {
      'textId': bookId,
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'kandaNumber': kandaNumber,
      'sargaNumber': sargaNumber,
      'verseNumber': verseNumber,
      'mantraNumber': mantraNumber,
      'verseId': verseId,
      'passageId': passageId,
    };
  }
}

class SavedItemModel {
  const SavedItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.source,
    this.savedAt,
    this.bookId,
    this.bookName,
    this.chapterId,
    this.chapterNumber,
    this.chapterName,
    this.kandaId,
    this.kandaNumber,
    this.kandaName,
    this.sargaId,
    this.sargaNumber,
    this.sargaName,
    this.mantraNumber,
    this.verseId,
    this.verseNumber,
    this.verseReference,
    this.passageId,
  });

  final String id;
  final SavedItemType type;
  final String title;
  final String content;
  final String source;
  final DateTime? savedAt;

  final String? bookId;
  final String? bookName;
  final String? chapterId;
  final int? chapterNumber;
  final String? chapterName;
  final String? kandaId;
  final int? kandaNumber;
  final String? kandaName;
  final String? sargaId;
  final int? sargaNumber;
  final String? sargaName;
  final int? mantraNumber;
  final String? verseId;
  final int? verseNumber;
  final String? verseReference;
  final String? passageId;

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
      bookId: map['bookId']?.toString(),
      bookName: map['bookName']?.toString(),
      chapterId: map['chapterId']?.toString(),
      chapterNumber: _parseInt(map['chapterNumber']),
      chapterName: map['chapterName']?.toString(),
      kandaId: map['kandaId']?.toString(),
      kandaNumber: _parseInt(map['kandaNumber']),
      kandaName: map['kandaName']?.toString(),
      sargaId: map['sargaId']?.toString(),
      sargaNumber: _parseInt(map['sargaNumber']),
      sargaName: map['sargaName']?.toString(),
      mantraNumber: _parseInt(map['mantraNumber']),
      verseId: map['verseId']?.toString(),
      verseNumber: _parseInt(map['verseNumber']),
      verseReference: map['verseReference']?.toString(),
      passageId: map['passageId']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'content': content,
      'source': source,
      'savedAt': savedAt?.toIso8601String(),
      if (bookId != null) 'bookId': bookId,
      if (bookName != null) 'bookName': bookName,
      if (chapterId != null) 'chapterId': chapterId,
      if (chapterNumber != null) 'chapterNumber': chapterNumber,
      if (chapterName != null) 'chapterName': chapterName,
      if (kandaId != null) 'kandaId': kandaId,
      if (kandaNumber != null) 'kandaNumber': kandaNumber,
      if (kandaName != null) 'kandaName': kandaName,
      if (sargaId != null) 'sargaId': sargaId,
      if (sargaNumber != null) 'sargaNumber': sargaNumber,
      if (sargaName != null) 'sargaName': sargaName,
      if (mantraNumber != null) 'mantraNumber': mantraNumber,
      if (verseId != null) 'verseId': verseId,
      if (verseNumber != null) 'verseNumber': verseNumber,
      if (verseReference != null) 'verseReference': verseReference,
      if (passageId != null) 'passageId': passageId,
    };
  }

  SavedLocation resolveLocation() {
    String resolvedBookId = bookId ?? '';
    int? resolvedChapNum = chapterNumber;
    int? resolvedKandaNum = kandaNumber;
    int? resolvedSargaNum = sargaNumber;
    int? resolvedVerseNum = verseNumber;
    int? resolvedMantraNum = mantraNumber;

    if (resolvedBookId.isEmpty) {
      final idLower = id.toLowerCase();
      final sourceLower = source.toLowerCase();
      final titleLower = title.toLowerCase();

      if (idLower.contains('ramayana') || sourceLower.contains('ramayana') || titleLower.contains('ramayana') || sourceLower.contains('kanda')) {
        resolvedBookId = 'ramayana';
      } else if (idLower.contains('upanishad') || sourceLower.contains('upanishad') || titleLower.contains('upanishad') || sourceLower.contains('mantra')) {
        resolvedBookId = 'upanishads';
      } else {
        resolvedBookId = 'bhagavad_gita';
      }
    }

    // Try parsing from ID string (e.g. bhagavad_gita_c2_v47 or ramayana_c1002_v15)
    final idRegex = RegExp(r'_c(\d+)_v(\d+)');
    final idMatch = idRegex.firstMatch(id);
    if (idMatch != null) {
      resolvedChapNum ??= int.tryParse(idMatch.group(1) ?? '');
      resolvedVerseNum ??= int.tryParse(idMatch.group(2) ?? '');
    }

    // Parse numbers from source or title if still missing
    final fullText = '$source $title';

    if (resolvedBookId == 'upanishads') {
      final mantraMatch = RegExp(r'mantra\s*(\d+)', caseSensitive: false).firstMatch(fullText);
      if (mantraMatch != null) {
        final m = int.tryParse(mantraMatch.group(1) ?? '');
        if (m != null) {
          resolvedMantraNum ??= m;
          resolvedChapNum ??= m;
          resolvedVerseNum ??= 1;
        }
      }
    } else if (resolvedBookId == 'ramayana') {
      final kandaMatch = RegExp(r'kanda\s*(\d+)', caseSensitive: false).firstMatch(fullText);
      final sargaMatch = RegExp(r'sarga\s*(\d+)', caseSensitive: false).firstMatch(fullText);
      final verseMatch = RegExp(r'(?:verse|shloka|shlok|v\.?)\s*(\d+)', caseSensitive: false).firstMatch(fullText);

      if (kandaMatch != null) {
        resolvedKandaNum ??= int.tryParse(kandaMatch.group(1) ?? '');
      }
      if (sargaMatch != null) {
        resolvedSargaNum ??= int.tryParse(sargaMatch.group(1) ?? '');
      }
      if (verseMatch != null) {
        resolvedVerseNum ??= int.tryParse(verseMatch.group(1) ?? '');
      }

      if (resolvedChapNum == null && resolvedKandaNum != null) {
        final k = resolvedKandaNum;
        final s = resolvedSargaNum ?? 1;
        resolvedChapNum = (k * 1000) + s;
      }
    } else {
      // Bhagavad Gita (e.g. "Ch. 2, V. 47" or "2.47")
      final chMatch = RegExp(r'(?:ch\.?|chapter)\s*(\d+)', caseSensitive: false).firstMatch(fullText);
      final vMatch = RegExp(r'(?:v\.?|verse)\s*(\d+)', caseSensitive: false).firstMatch(fullText);
      final dotMatch = RegExp(r'(\d+)\.(\d+)').firstMatch(fullText);

      if (chMatch != null && vMatch != null) {
        resolvedChapNum ??= int.tryParse(chMatch.group(1) ?? '');
        resolvedVerseNum ??= int.tryParse(vMatch.group(1) ?? '');
      } else if (dotMatch != null) {
        resolvedChapNum ??= int.tryParse(dotMatch.group(1) ?? '');
        resolvedVerseNum ??= int.tryParse(dotMatch.group(2) ?? '');
      }
    }

    // Default fallbacks
    resolvedChapNum ??= 1;
    resolvedVerseNum ??= 1;

    if (resolvedBookId == 'ramayana' && resolvedChapNum >= 1000) {
      resolvedKandaNum ??= resolvedChapNum ~/ 1000;
      resolvedSargaNum ??= resolvedChapNum % 1000;
    }

    return SavedLocation(
      bookId: resolvedBookId,
      chapterNumber: resolvedChapNum,
      kandaNumber: resolvedKandaNum,
      sargaNumber: resolvedSargaNum,
      verseNumber: resolvedVerseNum,
      mantraNumber: resolvedMantraNum,
      verseId: verseId,
      passageId: passageId,
    );
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

  static int? _parseInt(dynamic val) {
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }
}

