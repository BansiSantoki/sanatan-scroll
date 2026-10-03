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
    String sanskritText = _extractFieldValue(map, ['sanskrit', 'sanskritText', 'sanskrit_text', 'shloka', 'shlok', 'verse_sanskrit', 'sa', 'Sanskrit', 'Shloka']) ?? '';
    String englishText = _extractFieldValue(map, ['english', 'english_translation', 'translation_en', 'englishText', 'translation', 'en', 'English', 'English_translation', 'Translation_en', 'translationEnglish', 'english_meaning']) ?? '';
    String gujaratiText = _extractFieldValue(map, ['gujarati', 'gujarati_translation', 'translation_gu', 'gujaratiText', 'gu', 'Gujarati', 'Gujarati_translation', 'Translation_gu', 'translationGujarati', 'gujarati_meaning']) ?? '';
    String? hindiText = _extractFieldValue(map, ['hindi', 'hindi_translation', 'translation_hi', 'hindiText', 'hi', 'Hindi', 'Hindi_translation', 'Translation_hi', 'translationHindi', 'hindi_meaning']);

    String meaningEn = _extractFieldValue(map, ['meaningEnglish', 'explanation_en', 'explanation', 'meaning_en', 'meaning', 'meaning_english', 'explanationEnglish']) ?? (englishText.isNotEmpty ? englishText : '');
    String meaningGu = _extractFieldValue(map, ['meaningGujarati', 'explanation_gu', 'meaning_gu', 'meaning_gujarati', 'explanationGujarati']) ?? (gujaratiText.isNotEmpty ? gujaratiText : '');
    String? meaningHi = _extractFieldValue(map, ['meaningHindi', 'explanation_hi', 'meaning_hi', 'meaning_hindi', 'explanationHindi']) ?? hindiText;

    if (hindiText == null || hindiText.isEmpty) {
      hindiText = meaningHi;
    }
    if (gujaratiText.isEmpty && meaningGu.isNotEmpty) {
      gujaratiText = meaningGu;
    }
    if (englishText.isEmpty && meaningEn.isNotEmpty) {
      englishText = meaningEn;
    }

    final kanda = map['kanda_no'] != null
        ? _asInt(map['kanda_no'], fallback: -1)
        : (map['kanda_number'] != null
            ? _asInt(map['kanda_number'], fallback: -1)
            : (map['kandaNumber'] != null ? _asInt(map['kandaNumber'], fallback: -1) : null));
    final sarga = map['sarga_no'] != null
        ? _asInt(map['sarga_no'], fallback: -1)
        : (map['sarga_number'] != null
            ? _asInt(map['sarga_number'], fallback: -1)
            : (map['sargaNumber'] != null ? _asInt(map['sargaNumber'], fallback: -1) : null));

    dynamic rawVerseNum = map['verse_no'] ??
        map['verseNo'] ??
        map['verse_number'] ??
        map['verseNumber'] ??
        map['shlok_no'] ??
        map['shlokNo'] ??
        map['shloka_no'] ??
        map['shlokaNo'] ??
        map['shlok'] ??
        map['shloka'] ??
        map['verse'] ??
        map['verse_id'] ??
        map['id'];

    if (rawVerseNum == null && map['verse_reference'] != null) {
      final refStr = map['verse_reference'].toString().trim();
      if (refStr.contains('.')) {
        final lastPart = refStr.split('.').last;
        rawVerseNum = int.tryParse(lastPart);
      }
    }

    final vNum = _asInt(rawVerseNum, fallback: 1);

    return SacredVerseModel(
      verseNumber: vNum,
      kandaNumber: kanda != null && kanda > 0 ? kanda : null,
      sargaNumber: sarga != null && sarga > 0 ? sarga : null,
      sanskrit: sanskritText,
      english: englishText,
      gujarati: gujaratiText,
      hindi: hindiText,
      meaningEnglish: meaningEn,
      meaningGujarati: meaningGu,
      meaningHindi: meaningHi,
      transliteration: _extractFieldValue(map, ['transliteration']),
      quote: _extractFieldValue(map, ['quote', 'quote_en', 'quoteEnglish']),
      quoteHi: _extractFieldValue(map, ['quote_hi', 'quoteHi', 'quoteHindi']),
      quoteGu: _extractFieldValue(map, ['quote_gu', 'quoteGu', 'quoteGujarati']),
      contextText: _extractFieldValue(map, ['contextText', 'context_text', 'context_en']),
      contextTextHi: _extractFieldValue(map, ['contextTextHi', 'context_text_hi', 'context_hi']),
      contextTextGu: _extractFieldValue(map, ['contextTextGu', 'context_text_gu', 'context_gu']),
      whyItMatters: _extractFieldValue(map, ['whyItMatters', 'why_it_matters', 'why_it_matters_en']),
      whyItMattersHi: _extractFieldValue(map, ['whyItMattersHi', 'why_it_matters_hi']),
      whyItMattersGu: _extractFieldValue(map, ['whyItMattersGu', 'why_it_matters_gu']),
      reflectionPreview: _extractFieldValue(map, ['reflectionPreview', 'reflection_preview', 'reflection_preview_en', 'reflection_en', 'reflection']),
      reflectionPreviewHi: _extractFieldValue(map, ['reflectionPreviewHi', 'reflection_preview_hi', 'reflection_hi']),
      reflectionPreviewGu: _extractFieldValue(map, ['reflectionPreviewGu', 'reflection_preview_gu', 'reflection_gu']),
      reflectionFull: _extractFieldValue(map, ['reflectionFull', 'reflection_full', 'reflection_full_en', 'reflection_en', 'reflection']),
      reflectionFullHi: _extractFieldValue(map, ['reflectionFullHi', 'reflection_full_hi', 'reflection_hi']),
      reflectionFullGu: _extractFieldValue(map, ['reflectionFullGu', 'reflection_full_gu', 'reflection_gu']),
      oneThingToNotice: _extractFieldValue(map, ['oneThingToNotice', 'one_thing_to_notice', 'one_thing_to_notice_en']),
      oneThingToNoticeHi: _extractFieldValue(map, ['oneThingToNoticeHi', 'one_thing_to_notice_hi']),
      oneThingToNoticeGu: _extractFieldValue(map, ['oneThingToNoticeGu', 'one_thing_to_notice_gu']),
      tryThis: _extractFieldValue(map, ['tryThis', 'try_this', 'try_this_en']),
      tryThisHi: _extractFieldValue(map, ['tryThisHi', 'try_this_hi']),
      tryThisGu: _extractFieldValue(map, ['tryThisGu', 'try_this_gu']),
      carryThisWithYou: _extractFieldValue(map, ['carryThisWithYou', 'carry_this_with_you', 'carry_this_with_you_en']),
      carryThisWithYouHi: _extractFieldValue(map, ['carryThisWithYouHi', 'carry_this_with_you_hi']),
      carryThisWithYouGu: _extractFieldValue(map, ['carryThisWithYouGu', 'carry_this_with_you_gu']),
      audioUrl: _extractFieldValue(map, ['audioUrl', 'audio_url', 'audio_url_en']),
      audioUrlHi: _extractFieldValue(map, ['audioUrlHi', 'audio_url_hi']),
      audioUrlGu: _extractFieldValue(map, ['audioUrlGu', 'audio_url_gu']),
    );
  }

  static String? _extractFieldValue(Map<String, dynamic> map, List<String> candidateKeys) {
    for (final key in candidateKeys) {
      final val = map[key];
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString().trim();
      }
    }

    if (map['translations'] is Map) {
      final transMap = Map<String, dynamic>.from(map['translations']);
      for (final key in candidateKeys) {
        final val = transMap[key];
        if (val != null && val.toString().trim().isNotEmpty) {
          return val.toString().trim();
        }
      }
      final transMapLower = <String, dynamic>{};
      transMap.forEach((k, v) => transMapLower[k.toString().toLowerCase()] = v);
      for (final key in candidateKeys) {
        final val = transMapLower[key.toLowerCase()];
        if (val != null && val.toString().trim().isNotEmpty) {
          return val.toString().trim();
        }
      }
    }

    final rootLower = <String, dynamic>{};
    map.forEach((k, v) => rootLower[k.toString().toLowerCase()] = v);
    for (final key in candidateKeys) {
      final val = rootLower[key.toLowerCase()];
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString().trim();
      }
    }

    return null;
  }

  String getLocalizedTranslation(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();

    if (code == 'gu') {
      if (gujarati.trim().isNotEmpty) return gujarati;
      if (meaningGujarati.trim().isNotEmpty) return meaningGujarati;
      return 'અનુવાદ ઉપલબ્ધ નથી.';
    }
    if (code == 'hi') {
      if (hindi != null && hindi!.trim().isNotEmpty) return hindi!;
      if (meaningHindi != null && meaningHindi!.trim().isNotEmpty) return meaningHindi!;
      if (gujarati.trim().isNotEmpty) {
        final derived = _deriveHindiFromGujarati(gujarati);
        if (derived.isNotEmpty) return derived;
      }
      return 'अनुवाद उपलब्ध नहीं है।';
    }
    if (code == 'sa') {
      if (sanskrit.trim().isNotEmpty) return sanskrit;
      return 'अनुवाद उपलब्ध नहीं है।';
    }
    if (english.trim().isNotEmpty) return english;
    if (meaningEnglish.trim().isNotEmpty) return meaningEnglish;
    return 'Translation not available.';
  }

  static String _deriveHindiFromGujarati(String text) {
    if (text.trim().isEmpty) return '';
    final buffer = StringBuffer();
    for (final char in text.runes) {
      if (char >= 0x0A81 && char <= 0x0AF1) {
        buffer.writeCharCode(char - 0x180);
      } else {
        buffer.writeCharCode(char);
      }
    }
    return buffer.toString();
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

  String getLocalizedMeaning(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (meaningGujarati.trim().isNotEmpty) return meaningGujarati;
      return getLocalizedTranslation(languageCode);
    }
    if (code == 'hi') {
      if (meaningHindi != null && meaningHindi!.trim().isNotEmpty) return meaningHindi!;
      return getLocalizedTranslation(languageCode);
    }
    if (meaningEnglish.trim().isNotEmpty) return meaningEnglish;
    return getLocalizedTranslation(languageCode);
  }

  String getQuoteText(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'hi') {
      if (quoteHi != null && quoteHi!.trim().isNotEmpty) return quoteHi!;
      final meaning = getLocalizedMeaning(languageCode).trim();
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (code == 'gu') {
      if (quoteGu != null && quoteGu!.trim().isNotEmpty) return quoteGu!;
      final meaning = getLocalizedMeaning(languageCode).trim();
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (quote != null && quote!.trim().isNotEmpty) return quote!;
    final meaning = getLocalizedMeaning(languageCode).trim();
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getContextText(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'hi') {
      if (contextTextHi != null && contextTextHi!.trim().isNotEmpty) return contextTextHi!;
      final meaning = getLocalizedMeaning(languageCode).trim();
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (code == 'gu') {
      if (contextTextGu != null && contextTextGu!.trim().isNotEmpty) return contextTextGu!;
      final meaning = getLocalizedMeaning(languageCode).trim();
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (contextText != null && contextText!.trim().isNotEmpty) return contextText!;
    final meaning = getLocalizedMeaning(languageCode).trim();
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getWhyItMattersText(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (whyItMattersGu != null && whyItMattersGu!.trim().isNotEmpty) return whyItMattersGu!;
      return 'પ્રશંસા વ્યસન જેવી લાગી શકે છે અને ટીકા તમારો આખો દિવસ બગાડી શકે છે.';
    }
    if (code == 'hi') {
      if (whyItMattersHi != null && whyItMattersHi!.trim().isNotEmpty) return whyItMattersHi!;
      return 'क्योंकि प्रशंसा व्यसन जैसी लग सकती है और आलोचना आपका पूरा दिन खराब कर सकती है।';
    }
    if (whyItMatters != null && whyItMatters!.trim().isNotEmpty) return whyItMatters!;
    return 'Because praise can feel addictive and criticism can ruin your whole day.';
  }

  String getReflectionPreviewText(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'hi') {
      if (reflectionPreviewHi != null && reflectionPreviewHi!.trim().isNotEmpty) return reflectionPreviewHi!;
      final meaning = getLocalizedMeaning(languageCode).trim();
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (code == 'gu') {
      if (reflectionPreviewGu != null && reflectionPreviewGu!.trim().isNotEmpty) return reflectionPreviewGu!;
      final meaning = getLocalizedMeaning(languageCode).trim();
      if (meaning.isNotEmpty) return meaning;
      return getLocalizedTranslation(languageCode);
    }
    if (reflectionPreview != null && reflectionPreview!.trim().isNotEmpty) return reflectionPreview!;
    final meaning = getLocalizedMeaning(languageCode).trim();
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getReflectionFullText(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'hi') {
      if (reflectionFullHi != null && reflectionFullHi!.trim().isNotEmpty) return reflectionFullHi!;
    } else if (code == 'gu') {
      if (reflectionFullGu != null && reflectionFullGu!.trim().isNotEmpty) return reflectionFullGu!;
    } else {
      if (reflectionFull != null && reflectionFull!.trim().isNotEmpty) return reflectionFull!;
    }
    final meaning = getLocalizedMeaning(languageCode).trim();
    final translation = getLocalizedTranslation(languageCode).trim();
    if (meaning == translation || meaning.isEmpty) {
      return translation;
    }
    if (translation.isEmpty) {
      return meaning;
    }
    return '$meaning\n\n$translation';
  }

  String getOneThingToNotice(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (oneThingToNoticeGu != null && oneThingToNoticeGu!.trim().isNotEmpty) return oneThingToNoticeGu!;
      return 'બીજા કોઈના પ્રતિભાવને કારણે તમારો મૂડ જ્યારે પણ બદલાય ત્યારે તેના પર ધ્યાન આપો.';
    }
    if (code == 'hi') {
      if (oneThingToNoticeHi != null && oneThingToNoticeHi!.trim().isNotEmpty) return oneThingToNoticeHi!;
      return 'अगली बार जब किसी अन्य की प्रतिक्रिया से आपका मूड बदले, तो उस पर ध्यान दें।';
    }
    if (oneThingToNotice != null && oneThingToNotice!.trim().isNotEmpty) return oneThingToNotice!;
    return 'Notice the next time your mood changes because of someone else\'s reaction.';
  }

  String getTryThis(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (tryThisGu != null && tryThisGu!.trim().isNotEmpty) return tryThisGu!;
      return 'પરિણામ તપાસતા પહેલા પૂછો: શું મેં પૂર્ણ સમર્પણ સાથે કામ કર્યું?';
    }
    if (code == 'hi') {
      if (tryThisHi != null && tryThisHi!.trim().isNotEmpty) return tryThisHi!;
      return 'परिणाम जांचने से पहले पूछें: क्या मैंने पूर्ण निष्ठा से कार्य किया?';
    }
    if (tryThis != null && tryThis!.trim().isNotEmpty) return tryThis!;
    return 'Before checking the result, ask: Did I act well with true devotion?';
  }

  String getCarryThisWithYou(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'gu') {
      if (carryThisWithYouGu != null && carryThisWithYouGu!.trim().isNotEmpty) return carryThisWithYouGu!;
      return 'તમારી આંતરિક શાંતિ દુનિયા પાસેથી ભાડે લેવાની જરૂર નથી.';
    }
    if (code == 'hi') {
      if (carryThisWithYouHi != null && carryThisWithYouHi!.trim().isNotEmpty) return carryThisWithYouHi!;
      return 'आपकी आंतरिक शांति दुनिया से किराए पर लेने के लिए नहीं है।';
    }
    if (carryThisWithYou != null && carryThisWithYou!.trim().isNotEmpty) return carryThisWithYou!;
    return 'Your peace is not supposed to be rented from the world.';
  }

  String? getAudioUrlForLanguage(String languageCode) {
    final code = languageCode.toLowerCase().split('-').first.split('_').first.trim();
    if (code == 'hi' && audioUrlHi != null && audioUrlHi!.trim().isNotEmpty) {
      return audioUrlHi;
    }
    if (code == 'gu' && audioUrlGu != null && audioUrlGu!.trim().isNotEmpty) {
      return audioUrlGu;
    }
    if (audioUrl != null && audioUrl!.trim().isNotEmpty) {
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