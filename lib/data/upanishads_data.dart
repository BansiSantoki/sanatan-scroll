import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import '../models/sacred_verse_model.dart';

class IshaUpanishadPassage {
  final String id;
  final String bookId;
  final String scriptureName;
  final String referenceNo;
  final String sanskrit;
  final String english;
  final String hindi;
  final String gujarati;

  const IshaUpanishadPassage({
    required this.id,
    this.bookId = 'upanishads',
    this.scriptureName = 'Isha Upanishad',
    required this.referenceNo,
    required this.sanskrit,
    required this.english,
    required this.hindi,
    required this.gujarati,
  });
}

class UpanishadsData {
  UpanishadsData._();

  static const List<IshaUpanishadPassage> passages = [
    IshaUpanishadPassage(
      id: 'ISHA-K-001',
      referenceNo: 'ISHA-K-01',
      sanskrit: 'ईशावास्यमिदं सर्वं यत्किञ्च जगत्यां जगत् । तेन त्यक्तेन भुञ्जीथा मा गृधः कस्य स्विद्धनम् ॥',
      english: 'All this—whatever moves in this moving world—is to be enveloped by the Lord. Through renunciation, sustain yourself; do not covet anyone’s wealth.',
      hindi: 'इस समस्त जगत में जो कुछ भी गतिशील है, वह सब ईश्वर से आवृत समझा जाए। त्याग के द्वारा अपने को संभालो; किसी के धन का लोभ मत करो।',
      gujarati: 'આ સમગ્ર જગતમાં જે કંઈ ગતિશીલ છે, તે બધું ઈશ્વરથી આવૃત સમજવું. ત્યાગ દ્વારા પોતાને સંભાળો; કોઈના ધનની લાલસા ન રાખો.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-002',
      referenceNo: 'ISHA-K-02',
      sanskrit: 'कुर्वन्नेवेह कर्माणि जिजीविषेच्छतं समाः । एवं त्वयि नान्यथेतोऽस्ति न कर्म लिप्यते नरे ॥',
      english: 'Doing actions here, one should wish to live for a hundred years. Living in this way, there is no other way for you by which action does not cling to a person.',
      hindi: 'यहाँ कर्म करते हुए मनुष्य को सौ वर्ष जीने की इच्छा करनी चाहिए। इस प्रकार जीते हुए तुम्हारे लिए यही मार्ग है, जिससे कर्म मनुष्य को बाँधता नहीं है।',
      gujarati: 'અહીં કર્મ કરતાં કરતાં મનુષ્યે સો વર્ષ જીવવાની ઇચ્છા રાખવી જોઈએ. આ રીતે જીવતા, તારા માટે એવો બીજો માર્ગ નથી જેમાં કર્મ મનુષ્યને ચોંટતું કે બાંધતું નથી.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-003',
      referenceNo: 'ISHA-K-03',
      sanskrit: 'असुर्या नाम ते लोका अन्धेन तमसावृताः । तांस्ते प्रेत्याभिगच्छन्ति ये के चात्महनो जनाः ॥',
      english: 'Those worlds called asurya are covered in blinding darkness. After death, those people who are destroyers of the Self go to them.',
      hindi: 'असुर्य नाम के वे लोक घोर अन्धकार से ढके हुए हैं। मृत्यु के बाद वे लोग वहाँ जाते हैं जो आत्मा के विनाशक हैं।',
      gujarati: 'અસુર્ય નામના તે લોક ઘોર અંધકારથી ઢંકાયેલા છે. મૃત્યુ પછી તેઓ ત્યાં જાય છે જેઓ આત્માના વિનાશક છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-004',
      referenceNo: 'ISHA-K-04',
      sanskrit: 'अनेजदेकं मनसो जवीयो नैनद्देवा आप्नुवन्पूर्वमर्षत् । तद्धावतोऽन्यानत्येति तिष्ठत्तस्मिन्नपो मातरिश्वा दधाति ॥',
      english: 'The One, unmoving, is swifter than the mind. The devas do not reach it; it has gone before them. Standing still, it outstrips those who run. In it, Matarishvan apportions the waters.',
      hindi: 'वह एक, अचल होकर भी मन से अधिक वेगवान है। देवता उसे प्राप्त नहीं कर पाते; वह उनसे पहले पहुँच चुका है। स्थिर रहते हुए भी वह दौड़ने वालों से आगे निकल जाता है। उसी में मातरिश्वा जलों को स्थापित करता है।',
      gujarati: 'તે એક, અચળ હોવા છતાં મન કરતાં વધુ ઝડપી છે. દેવતાઓ તેને પામી શકતા નથી; તે તેમનાથી પહેલાં પહોંચી ચૂક્યું છે. સ્થિર રહીને પણ તે દોડનારાઓને પાછળ મૂકે છે. તેમાં માતરિશ્વા જળોને સ્થાપે છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-005',
      referenceNo: 'ISHA-K-05',
      sanskrit: 'तदेजति तन्नैजति तद्दूरे तद्वन्तिके । तदन्तरस्य सर्वस्य तदु सर्वस्यास्य बाह्यतः ॥',
      english: 'It moves, and it does not move. It is far, and it is near. It is within all this, and it is also outside all this.',
      hindi: 'वह चलता है और नहीं भी चलता। वह दूर है और निकट भी। वह इस सबके भीतर है और इस सबके बाहर भी है।',
      gujarati: 'તે ગતિ કરે છે અને ગતિ કરતું નથી. તે દૂર છે અને નજીક પણ છે. તે આ બધાની અંદર છે અને આ બધાની બહાર પણ છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-006',
      referenceNo: 'ISHA-K-06',
      sanskrit: 'यस्तु सर्वाणि भूतान्यात्मन्येवानुपश्यति । सर्वभूतेषु चात्मानं ततो न विजुगुप्सते ॥',
      english: 'Whoever sees all beings in the Self alone, and the Self in all beings, no longer shrinks away from anything.',
      hindi: 'जो सभी प्राणियों को आत्मा में ही देखता है और सभी प्राणियों में आत्मा को देखता है, वह फिर किसी से घृणा या विरक्ति नहीं करता।',
      gujarati: 'જે બધા જીવોને આત્મામાં જ જુએ છે અને બધા જીવોમાં આત્માને જુએ છે, તે પછી કોઈથી ઘૃણા કે વિમુખતા રાખતો નથી.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-007',
      referenceNo: 'ISHA-K-07',
      sanskrit: 'यस्मिन्सर्वाणि भूतान्यात्मैवाभूद्विजानतः । तत्र को मोहः कः शोक एकत्वमनुपश्यतः ॥',
      english: 'For the one who knows, in whom all beings have become the Self itself, what delusion and what sorrow can there be for one who sees oneness?',
      hindi: 'जिस ज्ञानी के लिए सभी प्राणी आत्मा ही हो गए हैं, उस एकत्व को देखने वाले के लिए वहाँ कौन-सा मोह और कौन-सा शोक रह सकता है?',
      gujarati: 'જે જ્ઞાની માટે બધા જીવો આત્મા જ બની ગયા છે, તે એકત્વને જોનાર માટે પછી કયો મોહ અને કયો શોક રહી શકે?',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-008',
      referenceNo: 'ISHA-K-08',
      sanskrit: 'स पर्यगाच्छुक्रमकायमव्रणमस्नाविरं शुद्धमपापविद्धम् । कविर्मनीषी परिभूः स्वयंभूर्याथातथ्यतोऽर्थान्व्यदधाच्छाश्वतीभ्यः समाभ्यः ॥',
      english: 'That Self is all-pervading, radiant, bodiless, unwounded, without sinews, pure and untouched by evil; a seer, a thinker, all-surpassing, self-existent. It has ordered things according to their true nature through the enduring ages.',
      hindi: 'वह आत्मा सर्वव्यापी, प्रकाशमान, शरीररहित, अव्रण, स्नायु-रहित, शुद्ध और पाप से अछूती है; वह द्रष्टा, मनीषी, सब से परे और स्वयंभू है। उसने वस्तुओं को उनके यथार्थ स्वरूप के अनुसार शाश्वत कालों के लिए व्यवस्थित किया है।',
      gujarati: 'તે આત્મા સર્વવ્યાપી, પ્રકાશમાન, શરીરરહિત, અક્ષત, સ્નાયુ-રહિત, શુદ્ધ અને પાપથી અસ્પર્શિત છે; તે દ્રષ્ટા, મનીષી, સર્વથી પર અને સ્વયંભૂ છે. તેણે વસ્તુઓને તેમના યથાર્થ સ્વરૂપ અનુસાર દીર્ઘકાલ માટે વ્યવસ્થિત કરી છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-009',
      referenceNo: 'ISHA-K-09',
      sanskrit: 'अन्धं तमः प्रविशन्ति येऽविद्यामुपासते । ततो भूय इव ते तमो य उ विद्यायां रताः ॥',
      english: 'Into blind darkness enter those who devote themselves to avidya; into darkness, as if still deeper, those who delight in vidya.',
      hindi: 'जो अविद्या की उपासना करते हैं वे घोर अन्धकार में प्रवेश करते हैं; और जो विद्या में ही रत रहते हैं वे मानो उससे भी अधिक अन्धकार में जाते हैं।',
      gujarati: 'જે અવિદ્યાની ઉપાસના કરે છે તેઓ ઘોર અંધકારમાં પ્રવેશે છે; અને જે માત્ર વિદ્યામાં રત રહે છે તેઓ જાણે તેથી પણ વધુ અંધકારમાં જાય છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-010',
      referenceNo: 'ISHA-K-10',
      sanskrit: 'अन्यदेवाहुर्विद्ययान्यदाहुरविद्यया । इति शुश्रुम धीराणां ये नस्तद्विचचक्षिरे ॥',
      english: 'Quite different, they say, is what comes from vidya; different again, they say, from avidya. Thus we have heard from the wise who explained this to us.',
      hindi: 'कहा जाता है कि विद्या से एक भिन्न फल मिलता है और अविद्या से दूसरा। ऐसा हमने उन धीर ज्ञानी जनों से सुना है जिन्होंने हमें यह समझाया।',
      gujarati: 'કહેવામાં આવે છે કે વિદ્યાથી એક જુદું ફળ મળે છે અને અવિદ્યાથી બીજું. આવું અમે તે ધીર જ્ઞાનીઓ પાસેથી સાંભળ્યું છે જેમણે અમને આ સમજાવ્યું.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-011',
      referenceNo: 'ISHA-K-11',
      sanskrit: 'विद्यां चाविद्यां च यस्तद्वेदोभयं सह । अविद्यया मृत्युं तीर्त्वा विद्ययामृतमश्नुते ॥',
      english: 'Whoever knows vidya and avidya together—crossing death through avidya, one attains immortality through vidya.',
      hindi: 'जो विद्या और अविद्या दोनों को साथ जानता है, वह अविद्या के द्वारा मृत्यु को पार करके विद्या के द्वारा अमृतत्व को प्राप्त करता है।',
      gujarati: 'જે વિદ્યા અને અવિદ્યા બંનેને સાથે જાણે છે, તે અવિદ્યાથી મૃત્યુને પાર કરીને વિદ્યાથી અમૃતત્વને પ્રાપ્ત કરે છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-012',
      referenceNo: 'ISHA-K-12',
      sanskrit: 'अन्धं तमः प्रविशन्ति येऽसम्भूतिमुपासते । ततो भूय इव ते तमो य उ सम्भूत्यां रताः ॥',
      english: 'Into blind darkness enter those who devote themselves to asambhuti; into darkness, as if still deeper, those who delight in sambhuti.',
      hindi: 'जो असम्भूति की उपासना करते हैं वे घोर अन्धकार में प्रवेश करते हैं; और जो सम्भूति में ही रत रहते हैं वे मानो उससे भी अधिक अन्धकार में जाते हैं।',
      gujarati: 'જે અસંભૂતિની ઉપાસના કરે છે તેઓ ઘોર અંધકારમાં પ્રવેશે છે; અને જે માત્ર સંભૂતિમાં રત રહે છે તેઓ જાણે તેથી પણ વધુ અંધકારમાં જાય છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-013',
      referenceNo: 'ISHA-K-13',
      sanskrit: 'अन्यदेवाहुः सम्भवादन्यदाहुरसम्भवात् । इति शुश्रुम धीराणां ये नस्तद्विचचक्षिरे ॥',
      english: 'Quite different, they say, is what comes from sambhava; different again, they say, from asambhava. Thus we have heard from the wise who explained this to us.',
      hindi: 'कहा जाता है कि सम्भव से एक भिन्न फल मिलता है और असम्भव से दूसरा। ऐसा हमने उन धीर ज्ञानी जनों से सुना है जिन्होंने हमें यह समझाया।',
      gujarati: 'કહેવામાં આવે છે કે સંભવથી એક જુદું ફળ મળે છે અને અસંભવથી બીજું. આવું અમે તે ધીર જ્ઞાનીઓ પાસેથી સાંભળ્યું છે જેમણે અમને આ સમજાવ્યું.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-014',
      referenceNo: 'ISHA-K-14',
      sanskrit: 'सम्भूतिं च विनाशं च यस्तद्वेदोभयं सह । विनाशेन मृत्युं तीर्त्वा सम्भूत्यामृतमश्नुते ॥',
      english: 'Whoever knows sambhuti and vinasha together—crossing death through vinasha, one attains immortality through sambhuti.',
      hindi: 'जो सम्भूति और विनाश दोनों को साथ जानता है, वह विनाश के द्वारा मृत्यु को पार करके सम्भूति के द्वारा अमृतत्व को प्राप्त करता है।',
      gujarati: 'જે સંભૂતિ અને વિનાશ બંનેને સાથે જાણે છે, તે વિનાશ દ્વારા મૃત્યુને પાર કરીને સંભૂતિ દ્વારા અમૃતત્વને પ્રાપ્ત કરે છે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-015',
      referenceNo: 'ISHA-K-15',
      sanskrit: 'हिरण्मयेन पात्रेण सत्यस्यापिहितं मुखम् । तत्त्वं पूषन्नपावृणु सत्यधर्माय दृष्टये ॥',
      english: 'The face of truth is covered by a golden vessel. O Pushan, remove it so that one devoted to truth may see.',
      hindi: 'सत्य का मुख स्वर्णमय पात्र से ढका हुआ है। हे पूषन्, उसे हटा दो ताकि सत्यधर्म में स्थित साधक उसे देख सके।',
      gujarati: 'સત્યનું મુખ સુવર્ણમય પાત્રથી ઢંકાયેલું છે. હે પૂષન, તેને દૂર કર જેથી સત્યધર્મમાં સ્થિત સાધક તેને જોઈ શકે.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-016',
      referenceNo: 'ISHA-K-16',
      sanskrit: 'पूषन्नेकर्षे यम सूर्य प्राजापत्य व्यूह रश्मीन्समूह तेजः । यत्ते रूपं कल्याणतमं तत्ते पश्यामि योऽसावसौ पुरुषः सोऽहमस्मि ॥',
      english: 'O Pushan, sole seer, Yama, Surya, child of Prajapati: withdraw your rays, gather up your brilliance. I behold that most auspicious form of yours. That Person who is there—he am I.',
      hindi: 'हे पूषन्, एकर्षि, यम, सूर्य, प्रजापति-पुत्र! अपनी किरणों को हटा लो, अपने तेज को समेट लो। मैं तुम्हारा वह परम कल्याणमय रूप देखूँ। जो वह वहाँ पुरुष है—वही मैं हूँ।',
      gujarati: 'હે પૂષન, એકર્ષિ, યમ, સૂર્ય, પ્રજાપતિપુત્ર! તારા કિરણોને દૂર કર, તારું તેજ સમેટ. હું તારું તે સર્વોત્તમ કલ્યાણમય સ્વરૂપ જોઉં. જે તે ત્યાં પુરુષ છે—તે જ હું છું.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-017',
      referenceNo: 'ISHA-K-17',
      sanskrit: 'वायुरनिलममृतमथेदं भस्मान्तं शरीरम् । ॐ क्रतो स्मर कृतं स्मर क्रतो स्मर कृतं स्मर ॥',
      english: 'May the breath go to the immortal air; then let this body end in ashes. Om. O inner resolve, remember; remember what has been done. O inner resolve, remember; remember what has been done.',
      hindi: 'प्राण अमर वायु में मिल जाए और यह शरीर अंततः भस्म हो जाए। ॐ। हे संकल्पमय चेतना, स्मरण करो; किए हुए कर्मों को स्मरण करो। हे संकल्पमय चेतना, स्मरण करो; किए हुए कर्मों को स्मरण करो।',
      gujarati: 'પ્રાણ અમર વાયુમાં લીન થાય અને આ શરીર અંતે ભસ્મ થઈ જાય. ૐ. હે સંકલ્પમય ચેતના, સ્મરણ કર; કરેલા કર્મોને સ્મરણ કર. હે સંકલ્પમય ચેતના, સ્મરણ કર; કરેલા કર્મોને સ્મરણ કર.',
    ),
    IshaUpanishadPassage(
      id: 'ISHA-K-018',
      referenceNo: 'ISHA-K-18',
      sanskrit: 'अग्ने नय सुपथा राये अस्मान्विश्वानि देव वयुनानि विद्वान् । युयोध्यस्मज्जुहुराणमेनो भूयिष्ठां ते नम उक्तिं विधेम ॥',
      english: 'O Agni, lead us by the good path to prosperity, O divine one, knowing all the ways. Remove from us the crooked wrongdoing. To you we offer our fullest words of homage.',
      hindi: 'हे अग्ने, हमें शुभ मार्ग से समृद्धि की ओर ले चलो; हे देव, तुम सभी मार्गों को जानते हो। हमारे भीतर के टेड़े पाप को हमसे दूर करो। हम तुम्हें बार-बार नमस्कार के वचन अर्पित करते हैं।',
      gujarati: 'હે અગ્નિ, અમને શુભ માર્ગે સમૃદ્ધિ તરફ લઈ જા; હે દેવ, તું બધા માર્ગોને જાણે છે. અમારી અંદરના વાંકાચૂકા પાપને અમથી દૂર કર. અમે તને વારંવાર નમનના શબ્દો અર્પણ કરીએ છીએ.',
    ),
  ];

  static SacredBookModel buildUpanishadsBook() {
    return SacredBookModel(
      id: 'upanishads',
      title: 'Isha Upanishad',
      subtitle: 'The Inner Teaching',
      iconEmoji: '📜',
      totalChapters: 18,
      chapters: List.generate(18, (index) {
        final passage = passages[index];
        final num = index + 1;
        return SacredChapterModel(
          chapterNumber: num,
          title: passage.referenceNo,
          subtitle: 'Isha Upanishad • ${passage.referenceNo}',
          titleEn: passage.referenceNo,
          titleHi: passage.referenceNo,
          titleGu: passage.referenceNo,
          subtitleEn: 'Isha Upanishad • ${passage.referenceNo}',
          subtitleHi: 'ईशोपनिषद् • ${passage.referenceNo}',
          subtitleGu: 'ઈશોપનિષદ • ${passage.referenceNo}',
          descriptionEnglish: passage.english,
          descriptionHindi: passage.hindi,
          descriptionGujarati: passage.gujarati,
          verses: [
            SacredVerseModel(
              verseNumber: 1,
              sanskrit: passage.sanskrit,
              english: passage.english,
              hindi: passage.hindi,
              gujarati: passage.gujarati,
              meaningEnglish: passage.english,
              meaningHindi: passage.hindi,
              meaningGujarati: passage.gujarati,
              quote: passage.english,
              quoteHi: passage.hindi,
              quoteGu: passage.gujarati,
              contextText: passage.english,
              contextTextHi: passage.hindi,
              contextTextGu: passage.gujarati,
            ),
          ],
        );
      }),
    );
  }
}
