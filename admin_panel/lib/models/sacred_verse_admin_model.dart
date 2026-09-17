import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp, FieldValue;

class SacredVerseAdminModel {
  final String? verseId;
  final int verseNumber;
  final int? kandaNumber;
  final int? sargaNumber;
  final String sanskrit;
  final String english;
  final String gujarati;
  final String? hindi;
  final String meaningEnglish;
  final String meaningGujarati;
  final String? meaningHindi;
  final String? transliteration;

  final String? quote;
  final String? quoteHi;
  final String? quoteGu;

  final String? contextText;
  final String? contextTextHi;
  final String? contextTextGu;

  final String? whyItMatters;
  final String? whyItMattersHi;
  final String? whyItMattersGu;

  final String? reflectionPreview;
  final String? reflectionPreviewHi;
  final String? reflectionPreviewGu;

  final String? reflectionFull;
  final String? reflectionFullHi;
  final String? reflectionFullGu;

  final String? oneThingToNotice;
  final String? oneThingToNoticeHi;
  final String? oneThingToNoticeGu;

  final String? tryThis;
  final String? tryThisHi;
  final String? tryThisGu;

  final String? carryThisWithYou;
  final String? carryThisWithYouHi;
  final String? carryThisWithYouGu;

  final String? audioUrl;
  final String? audioUrlHi;
  final String? audioUrlGu;

  final String? sourceUrl;
  final String? sourceName;
  final String qaStatus; // Draft, Review, Approved, Rejected
  final String? notes;

  final bool published;
  final bool archived;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SacredVerseAdminModel({
    this.verseId,
    required this.verseNumber,
    this.kandaNumber,
    this.sargaNumber,
    required this.sanskrit,
    required this.english,
    required this.gujarati,
    this.hindi,
    required this.meaningEnglish,
    required this.meaningGujarati,
    this.meaningHindi,
    this.transliteration,
    this.quote,
    this.quoteHi,
    this.quoteGu,
    this.contextText,
    this.contextTextHi,
    this.contextTextGu,
    this.whyItMatters,
    this.whyItMattersHi,
    this.whyItMattersGu,
    this.reflectionPreview,
    this.reflectionPreviewHi,
    this.reflectionPreviewGu,
    this.reflectionFull,
    this.reflectionFullHi,
    this.reflectionFullGu,
    this.oneThingToNotice,
    this.oneThingToNoticeHi,
    this.oneThingToNoticeGu,
    this.tryThis,
    this.tryThisHi,
    this.tryThisGu,
    this.carryThisWithYou,
    this.carryThisWithYouHi,
    this.carryThisWithYouGu,
    this.audioUrl,
    this.audioUrlHi,
    this.audioUrlGu,
    this.sourceUrl,
    this.sourceName,
    this.qaStatus = 'Approved',
    this.notes,
    this.published = true,
    this.archived = false,
    this.createdAt,
    this.updatedAt,
  });

  factory SacredVerseAdminModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return SacredVerseAdminModel(
      verseId: map['verse_id']?.toString() ?? map['verseId']?.toString(),
      verseNumber: _asInt(map['verseNumber'], fallback: 1),
      kandaNumber: map['kanda_number'] != null ? _asInt(map['kanda_number'], fallback: 1) : (map['kandaNumber'] != null ? _asInt(map['kandaNumber'], fallback: 1) : null),
      sargaNumber: map['sarga_number'] != null ? _asInt(map['sarga_number'], fallback: 1) : (map['sargaNumber'] != null ? _asInt(map['sargaNumber'], fallback: 1) : null),
      sanskrit: (map['sanskrit'] ?? '').toString(),
      english: (map['english'] ?? map['translation_en'] ?? '').toString(),
      gujarati: (map['gujarati'] ?? map['translation_gu'] ?? '').toString(),
      hindi: map['hindi']?.toString() ?? map['translation_hi']?.toString(),
      meaningEnglish: (map['meaningEnglish'] ?? map['explanation_en'] ?? '').toString(),
      meaningGujarati: (map['meaningGujarati'] ?? map['explanation_gu'] ?? '').toString(),
      meaningHindi: map['meaningHindi']?.toString() ?? map['explanation_hi']?.toString(),
      transliteration: map['transliteration']?.toString(),
      quote: map['quote']?.toString() ?? map['quote_en']?.toString(),
      quoteHi: map['quote_hi']?.toString(),
      quoteGu: map['quote_gu']?.toString(),
      contextText: map['contextText']?.toString() ?? map['context_text']?.toString() ?? map['context_en']?.toString(),
      contextTextHi: map['contextTextHi']?.toString() ?? map['context_text_hi']?.toString() ?? map['context_hi']?.toString(),
      contextTextGu: map['contextTextGu']?.toString() ?? map['context_text_gu']?.toString() ?? map['context_gu']?.toString(),
      whyItMatters: map['whyItMatters']?.toString() ?? map['why_it_matters']?.toString() ?? map['why_it_matters_en']?.toString(),
      whyItMattersHi: map['whyItMattersHi']?.toString() ?? map['why_it_matters_hi']?.toString(),
      whyItMattersGu: map['whyItMattersGu']?.toString() ?? map['why_it_matters_gu']?.toString(),
      reflectionPreview: map['reflectionPreview']?.toString() ?? map['reflection_preview']?.toString() ?? map['reflection_preview_en']?.toString(),
      reflectionPreviewHi: map['reflectionPreviewHi']?.toString() ?? map['reflection_preview_hi']?.toString(),
      reflectionPreviewGu: map['reflectionPreviewGu']?.toString() ?? map['reflection_preview_gu']?.toString(),
      reflectionFull: map['reflectionFull']?.toString() ?? map['reflection_full']?.toString() ?? map['reflection_full_en']?.toString(),
      reflectionFullHi: map['reflectionFullHi']?.toString() ?? map['reflection_full_hi']?.toString(),
      reflectionFullGu: map['reflectionFullGu']?.toString() ?? map['reflection_full_gu']?.toString(),
      oneThingToNotice: map['oneThingToNotice']?.toString() ?? map['one_thing_to_notice']?.toString() ?? map['one_thing_to_notice_en']?.toString(),
      oneThingToNoticeHi: map['oneThingToNoticeHi']?.toString() ?? map['one_thing_to_notice_hi']?.toString(),
      oneThingToNoticeGu: map['oneThingToNoticeGu']?.toString() ?? map['one_thing_to_notice_gu']?.toString(),
      tryThis: map['tryThis']?.toString() ?? map['try_this']?.toString() ?? map['try_this_en']?.toString(),
      tryThisHi: map['tryThisHi']?.toString() ?? map['try_this_hi']?.toString(),
      tryThisGu: map['tryThisGu']?.toString() ?? map['try_this_gu']?.toString(),
      carryThisWithYou: map['carryThisWithYou']?.toString() ?? map['carry_this_with_you']?.toString() ?? map['carry_this_with_you_en']?.toString(),
      carryThisWithYouHi: map['carryThisWithYouHi']?.toString() ?? map['carry_this_with_you_hi']?.toString(),
      carryThisWithYouGu: map['carryThisWithYouGu']?.toString() ?? map['carry_this_with_you_gu']?.toString(),
      audioUrl: map['audioUrl']?.toString() ?? map['audio_url']?.toString() ?? map['audio_url_en']?.toString(),
      audioUrlHi: map['audioUrlHi']?.toString() ?? map['audio_url_hi']?.toString(),
      audioUrlGu: map['audioUrlGu']?.toString() ?? map['audio_url_gu']?.toString(),
      sourceUrl: map['source_url']?.toString() ?? map['sourceUrl']?.toString(),
      sourceName: map['source_name']?.toString() ?? map['sourceName']?.toString(),
      qaStatus: (map['qa_status'] ?? map['qaStatus'] ?? 'Approved').toString(),
      notes: map['notes']?.toString(),
      published: map['published'] as bool? ?? true,
      archived: map['archived'] as bool? ?? false,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verse_id': verseId,
      'verseNumber': verseNumber,
      'kanda_number': kandaNumber,
      'sarga_number': sargaNumber,
      'sanskrit': sanskrit,
      'english': english,
      'gujarati': gujarati,
      'hindi': hindi,
      'meaningEnglish': meaningEnglish,
      'meaningGujarati': meaningGujarati,
      'meaningHindi': meaningHindi,
      'transliteration': transliteration,
      'quote': quote,
      'quote_hi': quoteHi,
      'quote_gu': quoteGu,
      'contextText': contextText,
      'context_text_hi': contextTextHi,
      'context_text_gu': contextTextGu,
      'whyItMatters': whyItMatters,
      'why_it_matters_hi': whyItMattersHi,
      'why_it_matters_gu': whyItMattersGu,
      'reflectionPreview': reflectionPreview,
      'reflection_preview_hi': reflectionPreviewHi,
      'reflection_preview_gu': reflectionPreviewGu,
      'reflectionFull': reflectionFull,
      'reflection_full_hi': reflectionFullHi,
      'reflection_full_gu': reflectionFullGu,
      'oneThingToNotice': oneThingToNotice,
      'one_thing_to_notice_hi': oneThingToNoticeHi,
      'one_thing_to_notice_gu': oneThingToNoticeGu,
      'tryThis': tryThis,
      'try_this_hi': tryThisHi,
      'try_this_gu': tryThisGu,
      'carryThisWithYou': carryThisWithYou,
      'carry_this_with_you_hi': carryThisWithYouHi,
      'carry_this_with_you_gu': carryThisWithYouGu,
      'audioUrl': audioUrl,
      'audio_url_hi': audioUrlHi,
      'audio_url_gu': audioUrlGu,
      'source_url': sourceUrl,
      'source_name': sourceName,
      'qa_status': qaStatus,
      'notes': notes,
      'published': published,
      'archived': archived,
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
