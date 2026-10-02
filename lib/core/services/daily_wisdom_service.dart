import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyWisdomVerse {
  final String id;
  final String bookId;
  final String titleEn;
  final String titleHi;
  final String titleGu;
  final String verseRef;
  final int chapterNumber;
  final int? kandaNumber;
  final int? sargaNumber;
  final int verseNumber;
  final int? mantraNumber;
  final String sanskrit;
  final String translationEn;
  final String translationHi;
  final String translationGu;
  final Color bgColor;
  final String imagePath;

  const DailyWisdomVerse({
    required this.id,
    required this.bookId,
    required this.titleEn,
    required this.titleHi,
    required this.titleGu,
    required this.verseRef,
    required this.chapterNumber,
    this.kandaNumber,
    this.sargaNumber,
    required this.verseNumber,
    this.mantraNumber,
    required this.sanskrit,
    required this.translationEn,
    required this.translationHi,
    required this.translationGu,
    required this.bgColor,
    required this.imagePath,
  });

  String getLocalizedTitle(String langCode) {
    if (langCode == 'hi') return titleHi;
    if (langCode == 'gu') return titleGu;
    return titleEn;
  }

  String getLocalizedTranslation(String langCode) {
    if (langCode == 'hi') return translationHi;
    if (langCode == 'gu') return translationGu;
    return translationEn;
  }

  Map<String, dynamic> toRouteArguments() {
    return {
      'textId': bookId,
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'kandaNumber': kandaNumber,
      'sargaNumber': sargaNumber,
      'verseNumber': verseNumber,
      'mantraNumber': mantraNumber,
      'verseId': id,
    };
  }
}

class DailyWisdomService {
  DailyWisdomService._();

  static const String _keySelectedDate = 'daily_wisdom_selected_date';
  static const String _keySelectedVerseId = 'daily_wisdom_selected_verse_id';
  static const String _keyHistory = 'daily_wisdom_history';

  static const List<DailyWisdomVerse> pool = [
    DailyWisdomVerse(
      id: 'gita_2_47',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '2.47',
      chapterNumber: 2,
      verseNumber: 47,
      sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥',
      translationEn: 'You have a right to perform your prescribed duty, but not to the fruits of action. Never consider yourself the cause of results, nor be attached to inaction.',
      translationHi: 'कर्म करने में ही तुम्हारा अधिकार है, उसके फलों में कभी नहीं। तुम कर्मफल का हेतु मत बनो और तुम्हारी अकर्मण्यता में भी आसक्ति न हो।',
      translationGu: 'તમને માત્ર તમારું વિહિત કર્તવ્ય કરવાનો જ અધિકાર છે, પરંતુ તેના ફળ ઉપર ક્યારેય નહીં. કર્મફળના હેતુ ન બનો અને અકર્મમાં આસક્તિ ન રાખો.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_2_48',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '2.48',
      chapterNumber: 2,
      verseNumber: 48,
      sanskrit: 'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय ।\nसिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते ॥',
      translationEn: 'Perform your duty equipoised, O Arjuna, abandoning all attachment to success or failure. Such equanimity is called Yoga.',
      translationHi: 'हे धनंजय! आसक्ति को त्यागकर तथा सिद्धि और असिद्धि में समान बुद्धि रखकर योग में स्थित होकर कर्म करो, यह समभाव ही योग कहलाता है।',
      translationGu: 'હે અર્જુન! આસક્તિ છોડીને તથા સફળતા અને અસફળતામાં સમબુદ્ધિ રાખીને યોગમાં સ્થિત થઈને કર્મ કરો, આ સમભાવ જ યોગ કહેવાય છે.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_3_19',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '3.19',
      chapterNumber: 3,
      verseNumber: 19,
      sanskrit: 'तस्मादसक्तः सततं कार्यं कर्म समाचर ।\nअसक्तो ह्याचरन्कर्म परमाप्नोति पूरुषः ॥',
      translationEn: 'Therefore, without attachment, always perform work that ought to be done, for by working without attachment one attains the Supreme.',
      translationHi: 'इसलिए आसक्ति से रहित होकर निरंतर अपने कर्तव्य कर्म का अच्छी तरह पालन करो, क्योंकि अनासक्त होकर कर्म करने से मनुष्य परमात्मा को प्राप्त होता है।',
      translationGu: 'તેથી આસક્તિ વિના સતત તમારા કર્તવ્યનું પાલન કરો, કારણ કે અનાસક્ત થઈને કર્મ કરવાથી મનુષ્ય પરમાત્માને પામે છે.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_4_7',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '4.7',
      chapterNumber: 4,
      verseNumber: 7,
      sanskrit: 'यदा यदा हि धर्मस्य ग्लानिर्भवति भारत ।\nअभ्युत्थानमधर्मस्य तदात्मानं सृजाम्यहम् ॥',
      translationEn: 'Whenever there is a decline of righteousness and a rise of unrighteousness, O Bharata, I manifest Myself.',
      translationHi: 'हे भारत! जब-जब धर्म की हानि और अधर्म की वृद्धि होती है, तब-तब मैं स्वयं की रचना करता हूँ (प्रकट होता हूँ)।',
      translationGu: 'હે ભારત! જ્યારે જ્યારે ધર્મની હાનિ અને અધર્મની વૃદ્ધિ થાય છે, ત્યારે હું પોતે પ્રકટ થાઉં છું.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_6_5',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '6.5',
      chapterNumber: 6,
      verseNumber: 5,
      sanskrit: 'उद्धरेदात्मनात्मानं नात्मानमवसादयेत् ।\nआत्मैव ह्यात्मनो बन्धुरात्मैव रिपुरात्मनः ॥',
      translationEn: 'Elevate yourself through the power of your mind, and do not degrade yourself. For the mind alone is one’s friend, and the mind alone is one’s enemy.',
      translationHi: 'अपने द्वारा अपना उद्धार करे, अपना पतन न होने दे; क्योंकि यह मन ही आत्मा का मित्र है और मन ही आत्मा का शत्रु है।',
      translationGu: 'પોતાના મન દ્વારા પોતાનો ઉદ્ધાર કરો, પોતાને નીચા ન પાડો. કારણ કે મન જ મનુષ્યનો મિત્ર છે અને મન જ શત્રુ છે.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_18_66',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '18.66',
      chapterNumber: 18,
      verseNumber: 66,
      sanskrit: 'सर्वधर्मान्परित्यज्य मामेकं शरणं व्रज ।\nअहं त्वा सर्वपापेभ्यो मोक्षयिष्यामि मा शुचः ॥',
      translationEn: 'Abandon all varieties of duties and simply surrender unto Me. I shall deliver you from all sinful reactions; do not grieve.',
      translationHi: 'सब धर्मों को त्यागकर केवल मेरी शरण में आ जाओ। मैं तुम्हें सब पापों से मुक्त कर दूंगा, तुम शोक मत करो।',
      translationGu: 'બધા ધર્મોનો ત્યાગ કરીને માત્ર મારી શરણમાં આવી જાઓ. હું તમને સઘળાં પાપોમાંથી મુક્ત કરીશ, તમે શોક ન કરો.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'isha_1',
      bookId: 'upanishads',
      titleEn: 'Isha Upanishad',
      titleHi: 'ईश उपनिषद्',
      titleGu: 'ઈશ ઉપનિષદ',
      verseRef: 'Mantra 1',
      chapterNumber: 1,
      mantraNumber: 1,
      verseNumber: 1,
      sanskrit: 'ईशावास्यमिदं सर्वं यत्किञ्च जगत्यां जगत् ।\nतेन त्यक्तेन भुञ्जीथा मा गृधः कस्य स्विद्धनम् ॥',
      translationEn: 'All this—whatever moves in this moving world—is to be enveloped by the Lord. Through renunciation, sustain yourself; do not covet anyone’s wealth.',
      translationHi: 'इस समस्त जगत में जो कुछ भी गतिशील है, वह सब ईश्वर से आवृत समझा जाए। त्याग के द्वारा अपने को संभालो; किसी के धन का लोभ मत करो।',
      translationGu: 'આ સમગ્ર જગતમાં જે કંઈ ગતિશીલ છે, તે બધું ઈશ્વરથી આવૃત સમજવું. ત્યાગ દ્વારા પોતાને સંભાળો; કોઈના ધનની લાલસા ન રાખો.',
      bgColor: Color(0xFFF2B75B),
      imagePath: 'assets/images/upanishad_leaf_art.png',
    ),
    DailyWisdomVerse(
      id: 'isha_2',
      bookId: 'upanishads',
      titleEn: 'Isha Upanishad',
      titleHi: 'ईश उपनिषद्',
      titleGu: 'ઈશ ઉપનિષદ',
      verseRef: 'Mantra 2',
      chapterNumber: 2,
      mantraNumber: 2,
      verseNumber: 2,
      sanskrit: 'कुर्वन्नेवेह कर्माणि जिजीविषेच्छतं समाः ।\nएवं त्वयि नान्यथेतोऽस्ति न कर्म लिप्यते नरे ॥',
      translationEn: 'Doing actions here, one should wish to live for a hundred years. Living in this way, there is no other way for you by which action does not cling to a person.',
      translationHi: 'यहाँ कर्म करते हुए मनुष्य को सौ वर्ष जीने की इच्छा करनी चाहिए। इस प्रकार जीते हुए तुम्हारे लिए यही मार्ग है, जिससे कर्म मनुष्य को बाँधता नहीं है।',
      translationGu: 'અહીં કર્મ કરતાં કરતાં મનુષ્યે સો વર્ષ જીવવાની ઇચ્છા રાખવી જોઈએ. આ રીતે જીવતા, તારા માટે એવો બીજો માર્ગ નથી જેમાં કર્મ મનુષ્યને ચોંટતું કે બાંધતું નથી.',
      bgColor: Color(0xFFF2B75B),
      imagePath: 'assets/images/upanishad_leaf_art.png',
    ),
    DailyWisdomVerse(
      id: 'isha_16',
      bookId: 'upanishads',
      titleEn: 'Isha Upanishad',
      titleHi: 'ईश उपनिषद्',
      titleGu: 'ઈશ ઉપનિષદ',
      verseRef: 'Mantra 16',
      chapterNumber: 16,
      mantraNumber: 16,
      verseNumber: 16,
      sanskrit: 'पूषन्नेकर्षे यम सूर्य प्राजापत्य व्यूह रश्मीन्समूह तेजो ।\nयत्ते रूपं कल्याणतमं तत्ते पश्यामि योऽसावसौ पुरुषः सोऽहमस्मि ॥',
      translationEn: 'O Nourisher, sole Seer, Controller, Sun, offspring of Prajapati, gather your rays and withdraw your glare, that I may behold your most auspicious form. That Being who is there, I am He.',
      translationHi: 'हे पोषक! हे एकऋषि! हे सूर्य! अपनी किरणों को समेटो, ताकि मैं तुम्हारे सबसे कल्याणकारी रूप को देख सकूँ। जो वह पुरुष वहाँ है, वही मैं हूँ।',
      translationGu: 'હે પોષક! હે એકઋષિ! હે સૂર્ય! આપના કિરણોને સમેટો, જેથી હું આપના કલ્યાણકારી રૂપને જોઈ શકું. જે તે પુરુષ ત્યાં છે, તે જ હું છું.',
      bgColor: Color(0xFFF2B75B),
      imagePath: 'assets/images/upanishad_leaf_art.png',
    ),
    DailyWisdomVerse(
      id: 'ramayana_1_1',
      bookId: 'ramayana',
      titleEn: 'Ramayana',
      titleHi: 'रामायण',
      titleGu: 'રામાયણ',
      verseRef: 'Bala Kanda 1.1',
      chapterNumber: 1001,
      kandaNumber: 1,
      sargaNumber: 1,
      verseNumber: 1,
      sanskrit: 'रामो विग्रहवान् धर्मः साधुः सत्यपराक्रमः ।\nराजा सर्वस्य लोकस्य देवानामिव वासवः ॥',
      translationEn: 'Rama is the embodiment of righteousness, noble, and truthful in valor. He is the king of all the world, just as Indra is of the gods.',
      translationHi: 'श्रीराम धर्म के साक्षात स्वरूप, साधु स्वभाव वाले और सत्य पराक्रमी हैं। वे सम्पूर्ण लोक के राजा हैं, जैसे देवताओं के इन्द्र हैं।',
      translationGu: 'શ્રીરામ ધર્મના સાક્ષાત સ્વરૂપ, સાધુ સ્વભાવના અને સત્ય પરાક્રમી છે. તેઓ સમગ્ર લોકના રાજા છે, જેમ દેવતાઓના ઇન્દ્ર છે.',
      bgColor: Color(0xFF94AA84),
      imagePath: 'assets/images/ramayana_bow_art.png',
    ),
    DailyWisdomVerse(
      id: 'ramayana_1_2',
      bookId: 'ramayana',
      titleEn: 'Ramayana',
      titleHi: 'रामायण',
      titleGu: 'રામાયણ',
      verseRef: 'Bala Kanda 1.2',
      chapterNumber: 1001,
      kandaNumber: 1,
      sargaNumber: 1,
      verseNumber: 2,
      sanskrit: 'तपःस्वाध्यायनिरतां तपस्वी वाग्विदां वरम् ।\nनारदं परिपप्रच्छ वाल्मीकिर्मुनिपुंगवम् ॥',
      translationEn: 'Sage Valmiki asked of Narada, the chief among ascetic sages and master of speech, who is ever devoted to austerity and study of the Vedas.',
      translationHi: 'तपस्या और स्वाध्याय में निरंतर लीन रहने वाले वाग्मियों में श्रेष्ठ नारदजी से महर्षि वाल्मीकि ने पूछा।',
      translationGu: 'તપસ્યા અને સ્વાધ્યાયમાં લીન રહેતા તથા ઉત્તમ વક્તા એવા નારદજીને મહર્ષિ વાલ્મીકિએ પૂછ્યું.',
      bgColor: Color(0xFF94AA84),
      imagePath: 'assets/images/ramayana_bow_art.png',
    ),
    DailyWisdomVerse(
      id: 'gita_12_15',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '12.15',
      chapterNumber: 12,
      verseNumber: 15,
      sanskrit: 'यस्मान्नोद्विजते लोको लोकान्नोद्विजते च यः ।\nहर्षामर्षभयोद्वेगैर्मुक्तो यः स च मे प्रियः ॥',
      translationEn: 'He by whom the world is not agitated and who is not agitated by the world, who is free from joy, envy, fear, and anxiety—he is dear to Me.',
      translationHi: 'जिससे कोई जीव उद्वेग को प्राप्त नहीं होता और जो स्वयं भी किसी जीव से उद्वेग को प्राप्त नहीं होता; जो हर्ष, अमर्ष, भय और उद्वेग से मुक्त है—वह मुझे प्रिय है।',
      translationGu: 'જેનાથી કોઈ જીવ ઉદ્વેગ પામતો નથી અને જે પોતે પણ કોઈ જીવથી ઉદ્વેગ પામતો નથી; જે હર્ષ, ભય અને ઉદ્વેગથી મુક્ત છે—તે મને પ્રિય છે.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_9_22',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '9.22',
      chapterNumber: 9,
      verseNumber: 22,
      sanskrit: 'अनन्याश्चिन्तयन्तो मां ये जनाः पर्युपासते ।\nतेषां नित्याभियुक्तानां योगक्षेमं वहाम्यहम् ॥',
      translationEn: 'To those who always worship Me with exclusive devotion, meditating on My transcendental form—to them I carry what they lack, and I preserve what they have.',
      translationHi: 'जो अनन्य प्रेमी भक्त मेरा निरंतर चिंतन करते हुए मेरी उपासना करते हैं, उन नित्य अभियुक्त पुरुषों का योगक्षेम मैं स्वयं वहन करता हूँ।',
      translationGu: 'જે ભક્તો અનન્ય ભાવથી મારું ચિંતન કરતા મારી ઉપાસના કરે છે, તેમના યોગક્ષેમનું વહન હું પોતે કરું છું.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_5_24',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '5.24',
      chapterNumber: 5,
      verseNumber: 24,
      sanskrit: 'योऽन्तःसुखोऽन्तरारामस्तथान्तर्ज्योतिरेव यः ।\nस योगी ब्रह्मनिर्वाणं ब्रह्मभूतोऽधिगच्छति ॥',
      translationEn: 'One who finds happiness within, who is active within, and who is illumined within—that yogi attains liberation in the Supreme.',
      translationHi: 'जो पुरुष अंतरात्मा में ही सुख वाला है, आत्मा में ही रमण करने वाला है और जो आत्मा में ही ज्ञान की ज्योति वाला है, वह योगी ब्रह्मरूप होकर शांत मुक्ति को प्राप्त होता है।',
      translationGu: 'જે પુરુષ અંતરાત્મામાં જ સુખી છે અને આત્મામાં જ રમમાણ રહે છે, તે યોગી પરમ શાંતિ અને મુક્તિ પામે છે.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
    DailyWisdomVerse(
      id: 'gita_7_7',
      bookId: 'bhagavad_gita',
      titleEn: 'Bhagavad Gita',
      titleHi: 'भगवद् गीता',
      titleGu: 'ભગવદ્ ગીતા',
      verseRef: '7.7',
      chapterNumber: 7,
      verseNumber: 7,
      sanskrit: 'मत्तः परतरं नान्यत्किञ्चिदस्ति धनञ्जय ।\nमयि सर्वमिदं प्रोतं सूत्रे मणिगणा इव ॥',
      translationEn: 'There is nothing higher than Me, O Arjuna. Everything rests upon Me, as pearls strung on a thread.',
      translationHi: 'हे धनंजय! मुझसे श्रेष्ठ दूसरा कोई भी कारण नहीं है। यह सम्पूर्ण जगत् धागे में मणियों की भाँति मुझमें पिरोया हुआ है।',
      translationGu: 'હે અર્જુન! મારાથી શ્રેષ્ઠ બીજું કંઈ નથી. આ આખું જગત દોરામાં મણકાઓની જેમ મારામાં પરવાયેલું છે.',
      bgColor: Color(0xFFE47A46),
      imagePath: 'assets/images/bhagavat_gita_big.png',
    ),
  ];

  static String _formatTodayDateKey(DateTime now) {
    return '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}';
  }

  static DailyWisdomVerse getFallbackWisdom(DateTime now) {
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = (dayOfYear.abs()) % pool.length;
    return pool[index];
  }

  static Future<DailyWisdomVerse> getTodayWisdom() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final todayKey = _formatTodayDateKey(now);

      final storedDate = prefs.getString(_keySelectedDate);
      final storedVerseId = prefs.getString(_keySelectedVerseId);

      if (storedDate == todayKey && storedVerseId != null && storedVerseId.isNotEmpty) {
        final existing = pool.firstWhere(
          (v) => v.id == storedVerseId,
          orElse: () => getFallbackWisdom(now),
        );
        return existing;
      }

      // New day: select a random verse avoiding recent history
      List<String> history = prefs.getStringList(_keyHistory) ?? [];
      List<DailyWisdomVerse> available = pool.where((v) => !history.contains(v.id)).toList();

      if (available.isEmpty) {
        history = [];
        available = List.from(pool);
      }

      final random = Random(now.millisecondsSinceEpoch);
      final selectedVerse = available[random.nextInt(available.length)];

      history.add(selectedVerse.id);

      await prefs.setString(_keySelectedDate, todayKey);
      await prefs.setString(_keySelectedVerseId, selectedVerse.id);
      await prefs.setStringList(_keyHistory, history);

      return selectedVerse;
    } catch (_) {
      return getFallbackWisdom(DateTime.now());
    }
  }
}
