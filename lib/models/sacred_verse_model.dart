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

  final String? quote;
  final String? contextText;
  final String? whyItMatters;
  final String? reflectionPreview;
  final String? reflectionFull;
  final String? oneThingToNotice;
  final String? tryThis;
  final String? carryThisWithYou;
  final String? audioUrl;

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
    this.quote,
    this.contextText,
    this.whyItMatters,
    this.reflectionPreview,
    this.reflectionFull,
    this.oneThingToNotice,
    this.tryThis,
    this.carryThisWithYou,
    this.audioUrl,
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
      quote: map['quote']?.toString(),
      contextText: map['contextText']?.toString() ?? map['context_text']?.toString(),
      whyItMatters: map['whyItMatters']?.toString() ?? map['why_it_matters']?.toString(),
      reflectionPreview: map['reflectionPreview']?.toString() ?? map['reflection_preview']?.toString(),
      reflectionFull: map['reflectionFull']?.toString() ?? map['reflection_full']?.toString(),
      oneThingToNotice: map['oneThingToNotice']?.toString() ?? map['one_thing_to_notice']?.toString(),
      tryThis: map['tryThis']?.toString() ?? map['try_this']?.toString(),
      carryThisWithYou: map['carryThisWithYou']?.toString() ?? map['carry_this_with_you']?.toString(),
      audioUrl: map['audioUrl']?.toString() ?? map['audio_url']?.toString(),
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
      'quote': quote,
      'contextText': contextText,
      'whyItMatters': whyItMatters,
      'reflectionPreview': reflectionPreview,
      'reflectionFull': reflectionFull,
      'oneThingToNotice': oneThingToNotice,
      'tryThis': tryThis,
      'carryThisWithYou': carryThisWithYou,
      'audioUrl': audioUrl,
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

  String getQuoteText(String languageCode) {
    if (quote != null && quote!.isNotEmpty) return quote!;
    final meaning = getLocalizedMeaning(languageCode);
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getContextText(String languageCode) {
    if (contextText != null && contextText!.isNotEmpty) return contextText!;
    final meaning = getLocalizedMeaning(languageCode);
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getWhyItMattersText(String languageCode) {
    if (whyItMatters != null && whyItMatters!.isNotEmpty) return whyItMatters!;
    if (languageCode == 'gu') {
      return 'પ્રશંસા વ્યસન જેવી લાગી શકે છે અને ટીકા તમારો આખો દિવસ બગાડી શકે છે.';
    }
    if (languageCode == 'hi') {
      return 'क्योंकि प्रशंसा व्यसन जैसी लग सकती है और आलोचना आपका पूरा दिन खराब कर सकती है।';
    }
    return 'Because praise can feel addictive and criticism can ruin your whole day.';
  }

  String getReflectionPreviewText(String languageCode) {
    if (reflectionPreview != null && reflectionPreview!.isNotEmpty) return reflectionPreview!;
    final meaning = getLocalizedMeaning(languageCode);
    if (meaning.isNotEmpty) return meaning;
    return getLocalizedTranslation(languageCode);
  }

  String getReflectionFullText(String languageCode) {
    if (reflectionFull != null && reflectionFull!.isNotEmpty) return reflectionFull!;
    final meaning = getLocalizedMeaning(languageCode);
    final translation = getLocalizedTranslation(languageCode);
    return '$meaning\n\n$translation';
  }

  String getOneThingToNotice(String languageCode) {
    if (oneThingToNotice != null && oneThingToNotice!.isNotEmpty) return oneThingToNotice!;
    if (languageCode == 'gu') {
      return 'બીજા કોઈના પ્રતિભાવને કારણે તમારો મૂડ જ્યારે પણ બદલાય ત્યારે તેના પર ધ્યાન આપો.';
    }
    if (languageCode == 'hi') {
      return 'अगली बार जब किसी अन्य की प्रतिक्रिया से आपका मूड बदले, तो उस पर ध्यान दें।';
    }
    return 'Notice the next time your mood changes because of someone else\'s reaction.';
  }

  String getTryThis(String languageCode) {
    if (tryThis != null && tryThis!.isNotEmpty) return tryThis!;
    if (languageCode == 'gu') {
      return 'પરિણામ તપાસતા પહેલા પૂછો: શું મેં પૂર્ણ સમર્પણ સાથે કામ કર્યું?';
    }
    if (languageCode == 'hi') {
      return 'परिणाम जांचने से पहले पूछें: क्या मैंने पूर्ण निष्ठा से कार्य किया?';
    }
    return 'Before checking the result, ask: Did I act well with true devotion?';
  }

  String getCarryThisWithYou(String languageCode) {
    if (carryThisWithYou != null && carryThisWithYou!.isNotEmpty) return carryThisWithYou!;
    if (languageCode == 'gu') {
      return 'તમારી આંતરિક શાંતિ દુનિયા પાસેથી ભાડે લેવાની જરૂર નથી.';
    }
    if (languageCode == 'hi') {
      return 'आपकी आंतरिक शांति दुनिया से किराए पर लेने के लिए नहीं है।';
    }
    return 'Your peace is not supposed to be rented from the world.';
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