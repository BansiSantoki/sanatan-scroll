class SacredVerseModel {
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

  const SacredVerseModel({
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
  });

  factory SacredVerseModel.fromMap(Map<String, dynamic> map) {
    final translationsMap = map['translations'] is Map ? Map<String, dynamic>.from(map['translations']) : null;

    final sanskritText = (map['sanskrit'] ?? map['sanskritText'] ?? map['shloka'] ?? '').toString();
    final englishText = (map['english'] ?? map['translation_en'] ?? map['english_translation'] ?? translationsMap?['en'] ?? '').toString();
    final gujaratiText = (map['gujarati'] ?? map['translation_gu'] ?? map['gujarati_translation'] ?? translationsMap?['gu'] ?? '').toString();
    final hindiText = map['hindi']?.toString() ?? map['translation_hi']?.toString() ?? map['hindi_translation']?.toString() ?? translationsMap?['hi']?.toString();

    final meaningEn = (map['meaningEnglish'] ?? map['explanation_en'] ?? map['explanation'] ?? map['meaning_en'] ?? map['meaning'] ?? '').toString();
    final meaningGu = (map['meaningGujarati'] ?? map['explanation_gu'] ?? map['meaning_gu'] ?? '').toString();
    final meaningHi = map['meaningHindi']?.toString() ?? map['explanation_hi']?.toString() ?? map['meaning_hi']?.toString();

    final kanda = map['kanda_number'] != null ? _asInt(map['kanda_number'], fallback: -1) : (map['kandaNumber'] != null ? _asInt(map['kandaNumber'], fallback: -1) : null);
    final sarga = map['sarga_number'] != null ? _asInt(map['sarga_number'], fallback: -1) : (map['sargaNumber'] != null ? _asInt(map['sargaNumber'], fallback: -1) : null);

    return SacredVerseModel(
      verseNumber: _asInt(
        map['verseNumber'] ?? map['verse_number'],
        fallback: 1,
      ),
      kandaNumber: kanda != null && kanda > 0 ? kanda : null,
      sargaNumber: sarga != null && sarga > 0 ? sarga : null,
      sanskrit: sanskritText,
      english: englishText,
      gujarati: gujaratiText,
      hindi: hindiText,
      meaningEnglish: meaningEn,
      meaningGujarati: meaningGu,
      meaningHindi: meaningHi,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
    };
  }

  String getLocalizedTranslation(String languageCode) {
    if (languageCode == 'gu') {
      if (gujarati.trim().isNotEmpty) return gujarati;
      if (hindi != null && hindi!.trim().isNotEmpty) return hindi!;
      if (english.trim().isNotEmpty) return english;
      return 'અનુવાદ ઉપલબ્ધ નથી.';
    }
    if (languageCode == 'hi') {
      if (hindi != null && hindi!.trim().isNotEmpty) return hindi!;
      if (gujarati.trim().isNotEmpty) return gujarati;
      if (english.trim().isNotEmpty) return english;
      return 'अनुवाद उपलब्ध नहीं है।';
    }
    if (languageCode == 'sa') {
      if (hindi != null && hindi!.trim().isNotEmpty) return hindi!;
      if (gujarati.trim().isNotEmpty) return gujarati;
      if (english.trim().isNotEmpty) return english;
      return 'अनुवाद उपलब्ध नहीं है।';
    }
    if (english.trim().isNotEmpty) return english;
    if (hindi != null && hindi!.trim().isNotEmpty) return hindi!;
    if (gujarati.trim().isNotEmpty) return gujarati;
    return 'Translation not available.';
  }

  String getLocalizedMeaning(String languageCode) {
    if (languageCode == 'gu') {
      if (meaningGujarati.isNotEmpty) return meaningGujarati;
      if (meaningHindi != null && meaningHindi!.isNotEmpty) return meaningHindi!;
      if (meaningEnglish.isNotEmpty) return meaningEnglish;
    }
    if (languageCode == 'hi') {
      if (meaningHindi != null && meaningHindi!.isNotEmpty) return meaningHindi!;
      if (meaningEnglish.isNotEmpty) return meaningEnglish;
      if (meaningGujarati.isNotEmpty) return meaningGujarati;
    }
    if (languageCode == 'sa') {
      if (meaningHindi != null && meaningHindi!.isNotEmpty) return meaningHindi!;
      if (meaningEnglish.isNotEmpty) return meaningEnglish;
      if (meaningGujarati.isNotEmpty) return meaningGujarati;
    }
    if (meaningEnglish.isNotEmpty) return meaningEnglish;
    if (meaningHindi != null && meaningHindi!.isNotEmpty) return meaningHindi!;
    if (meaningGujarati.isNotEmpty) return meaningGujarati;
    return getLocalizedTranslation(languageCode);
  }

  String getQuoteText(String languageCode) {
    if (languageCode == 'hi') {
      if (quoteHi != null && quoteHi!.isNotEmpty) return quoteHi!;
      final meaning = getLocalizedMeaning(languageCode);
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (languageCode == 'gu') {
      if (quoteGu != null && quoteGu!.isNotEmpty) return quoteGu!;
      final meaning = getLocalizedMeaning(languageCode);
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (quote != null && quote!.isNotEmpty) return quote!;
    final meaning = getLocalizedMeaning(languageCode);
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getContextText(String languageCode) {
    if (languageCode == 'hi') {
      if (contextTextHi != null && contextTextHi!.isNotEmpty) return contextTextHi!;
      final meaning = getLocalizedMeaning(languageCode);
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (languageCode == 'gu') {
      if (contextTextGu != null && contextTextGu!.isNotEmpty) return contextTextGu!;
      final meaning = getLocalizedMeaning(languageCode);
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (contextText != null && contextText!.isNotEmpty) return contextText!;
    final meaning = getLocalizedMeaning(languageCode);
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getWhyItMattersText(String languageCode) {
    if (languageCode == 'gu') {
      if (whyItMattersGu != null && whyItMattersGu!.isNotEmpty) return whyItMattersGu!;
      return 'પ્રશંસા વ્યસન જેવી લાગી શકે છે અને ટીકા તમારો આખો દિવસ બગાડી શકે છે.';
    }
    if (languageCode == 'hi') {
      if (whyItMattersHi != null && whyItMattersHi!.isNotEmpty) return whyItMattersHi!;
      return 'क्योंकि प्रशंसा व्यसन जैसी लग सकती है और आलोचना आपका पूरा दिन खराब कर सकती है।';
    }
    if (whyItMatters != null && whyItMatters!.isNotEmpty) return whyItMatters!;
    return 'Because praise can feel addictive and criticism can ruin your whole day.';
  }

  String getReflectionPreviewText(String languageCode) {
    if (languageCode == 'hi') {
      if (reflectionPreviewHi != null && reflectionPreviewHi!.isNotEmpty) return reflectionPreviewHi!;
      final meaning = getLocalizedMeaning(languageCode);
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (languageCode == 'gu') {
      if (reflectionPreviewGu != null && reflectionPreviewGu!.isNotEmpty) return reflectionPreviewGu!;
      final meaning = getLocalizedMeaning(languageCode);
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (reflectionPreview != null && reflectionPreview!.isNotEmpty) return reflectionPreview!;
    final meaning = getLocalizedMeaning(languageCode);
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getReflectionFullText(String languageCode) {
    if (languageCode == 'hi') {
      if (reflectionFullHi != null && reflectionFullHi!.isNotEmpty) return reflectionFullHi!;
    } else if (languageCode == 'gu') {
      if (reflectionFullGu != null && reflectionFullGu!.isNotEmpty) return reflectionFullGu!;
    } else {
      if (reflectionFull != null && reflectionFull!.isNotEmpty) return reflectionFull!;
    }
    final meaning = getLocalizedMeaning(languageCode);
    final translation = getLocalizedTranslation(languageCode);
    return '$meaning\n\n$translation';
  }

  String getOneThingToNotice(String languageCode) {
    if (languageCode == 'gu') {
      if (oneThingToNoticeGu != null && oneThingToNoticeGu!.isNotEmpty) return oneThingToNoticeGu!;
      return 'બીજા કોઈના પ્રતિભાવને કારણે તમારો મૂડ જ્યારે પણ બદલાય ત્યારે તેના પર ધ્યાન આપો.';
    }
    if (languageCode == 'hi') {
      if (oneThingToNoticeHi != null && oneThingToNoticeHi!.isNotEmpty) return oneThingToNoticeHi!;
      return 'अगली बार जब किसी अन्य की प्रतिक्रिया से आपका मूड बदले, तो उस पर ध्यान दें।';
    }
    if (oneThingToNotice != null && oneThingToNotice!.isNotEmpty) return oneThingToNotice!;
    return 'Notice the next time your mood changes because of someone else\'s reaction.';
  }

  String getTryThis(String languageCode) {
    if (languageCode == 'gu') {
      if (tryThisGu != null && tryThisGu!.isNotEmpty) return tryThisGu!;
      return 'પરિણામ તપાસતા પહેલા પૂછો: શું મેં પૂર્ણ સમર્પણ સાથે કામ કર્યું?';
    }
    if (languageCode == 'hi') {
      if (tryThisHi != null && tryThisHi!.isNotEmpty) return tryThisHi!;
      return 'परिणाम जांचने से पहले पूछें: क्या मैंने पूर्ण निष्ठा से कार्य किया?';
    }
    if (tryThis != null && tryThis!.isNotEmpty) return tryThis!;
    return 'Before checking the result, ask: Did I act well with true devotion?';
  }

  String getCarryThisWithYou(String languageCode) {
    if (languageCode == 'gu') {
      if (carryThisWithYouGu != null && carryThisWithYouGu!.isNotEmpty) return carryThisWithYouGu!;
      return 'તમારી આંતરિક શાંતિ દુનિયા પાસેથી ભાડે લેવાની જરૂર નથી.';
    }
    if (languageCode == 'hi') {
      if (carryThisWithYouHi != null && carryThisWithYouHi!.isNotEmpty) return carryThisWithYouHi!;
      return 'आपकी आंतरिक शांति दुनिया से किराए पर लेने के लिए नहीं है।';
    }
    if (carryThisWithYou != null && carryThisWithYou!.isNotEmpty) return carryThisWithYou!;
    return 'Your peace is not supposed to be rented from the world.';
  }

  String? getAudioUrlForLanguage(String languageCode) {
    if (languageCode == 'hi' && audioUrlHi != null && audioUrlHi!.isNotEmpty) {
      return audioUrlHi;
    }
    if (languageCode == 'gu' && audioUrlGu != null && audioUrlGu!.isNotEmpty) {
      return audioUrlGu;
    }
    if (audioUrl != null && audioUrl!.isNotEmpty) {
      return audioUrl;
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