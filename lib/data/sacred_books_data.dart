import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import '../models/sacred_verse_model.dart';

class SacredBooksData {
  SacredBooksData._();

  static final List<SacredBookModel> all = [
    _buildGitaBook(),
    _buildRamayanaBook(),
    ..._additionalBookIds.map(_buildAdditionalBook),
  ];

  static const Map<String, String> _additionalBookTitles = {
    'mahabharata': 'Mahabharata',
    'upanishads': 'Upanishads',
    'vedas': 'Vedas',
    'puranas': 'Puranas',
    'yoga_sutras': 'Yoga Sutras',
    'arthashastra': 'Arthashastra',
    'karma_yoga': 'Karma Yoga',
    'meditation': 'Meditation',
    'bhakti': 'Bhakti',
    'self_realization': 'Self Realization',
    'krishna_teachings': "Krishna's Teachings",
    'inner_peace': 'Inner Peace',
    'shiva_purana': 'Shiva Purana',
    'vishnu_purana': 'Vishnu Purana',
  };

  static final List<String> _additionalBookIds =
      _additionalBookTitles.keys.toList(growable: false);

  static SacredBookModel _buildAdditionalBook(String id) {
    final title = _additionalBookTitles[id]!;

    final chapterCount = switch (id) {
      'mahabharata' => 18,
      'upanishads' => 6,
      'vedas' => 4,
      'yoga_sutras' => 4,
      'arthashastra' => 15,
      'karma_yoga' => 3,
      _ => 5,
    };

    return SacredBookModel(
      id: id,
      title: title,
      subtitle: 'A living path of spiritual wisdom',
      iconEmoji: '📜',
      totalChapters: chapterCount,
      chapters: List.generate(chapterCount, (chapterIndex) {
        final chapterNumber = chapterIndex + 1;

        return SacredChapterModel(
          chapterNumber: chapterNumber,
          title: '$title Chapter $chapterNumber',
          subtitle: 'Teachings for the seeker',
          descriptionEnglish:
              'This chapter offers a reflective path through $title, connecting timeless wisdom with everyday dharma.',
          descriptionGujarati:
              '$title ના આ અધ્યાયમાં શાશ્વત જ્ઞાનને દૈનિક ધર્મ સાથે જોડતો આધ્યાત્મિક માર્ગ દર્શાવવામાં આવ્યો છે.',
          verses: List.generate(8, (verseIndex) {
            final verseNumber = verseIndex + 1;

            return SacredVerseModel(
              verseNumber: verseNumber,
              sanskrit:
                  'अध्याय $chapterNumber श्लोक $verseNumber - धर्मस्य मार्गः',
              english:
                  'The teaching of $title reminds us in chapter $chapterNumber, verse $verseNumber to live with truth, compassion, and steady awareness.',
              gujarati:
                  '$title ના અધ્યાય $chapterNumber ના શ્લોક $verseNumber માં સત્ય, કરુણા અને સ્થિર જાગૃતિ સાથે જીવવાનો ઉપદેશ છે.',
              meaningEnglish:
                  'Spiritual understanding grows through sincere practice, selfless action, and a heart open to the Divine.',
              meaningGujarati:
                  'નિષ્ઠાપૂર્વકની સાધના, નિષ્કામ કર્મ અને દિવ્યતા માટે ખુલ્લા હૃદયથી આધ્યાત્મિક સમજ વિકસે છે.',
            );
          }),
        );
      }),
    );
  }

  // =====================================================
  // BHAGAVAD GITA
  // =====================================================

  static SacredBookModel _buildGitaBook() {
    return SacredBookModel(
      id: 'bhagavad_gita',
      title: 'Bhagavad Gita',
      subtitle: 'The Divine Song of Lord Krishna',
      iconEmoji: '🕉️',
      totalChapters: 18,
      chapters: List.generate(18, (index) {
        final chapterNumber = index + 1;
        final chapterTitle = _gitaChapterTitle(chapterNumber);

        return SacredChapterModel(
          chapterNumber: chapterNumber,
          title: chapterTitle,
          subtitle: 'Bhagavad Gita Chapter $chapterNumber',
          descriptionEnglish:
    _gitaChapterDescriptionsEnglish.length > chapterNumber - 1
        ? _gitaChapterDescriptionsEnglish[chapterNumber - 1]
        : 'This chapter offers spiritual wisdom and guidance for the seeker.',

descriptionGujarati:
    _gitaChapterDescriptionsGujarati.length > chapterNumber - 1
        ? _gitaChapterDescriptionsGujarati[chapterNumber - 1]
        : 'આ અધ્યાય સાધક માટે આધ્યાત્મિક જ્ઞાન અને માર્ગદર્શન આપે છે.',
         

          // Chapters 1-4 use their complete verse data.
          // Remaining chapters keep the existing placeholder data for now.
         verses: chapterNumber == 1
    ? _gitaChapter1Verses()
    : chapterNumber == 2
        ? _gitaChapter2Verses()
        : chapterNumber == 3
            ? _gitaChapter3Verses()
            : chapterNumber == 4
                ? _gitaChapter4Verses()
                : chapterNumber == 5
                    ? _gitaChapter5Verses()
                    : chapterNumber == 6
                      ? _gitaChapter6Verses()
                      : chapterNumber == 7
                       ? _gitaChapter7Verses()
                       : chapterNumber == 8 
                        ? _gitaChapter8Verses()
                        : chapterNumber == 9
                         ? _gitaChapter9Verses()
                         : chapterNumber == 10
                          ? _gitaChapter10Verses()
                          : chapterNumber == 11
                           ?_gitaChapter11Verses()
                           :chapterNumber == 12
                            ? _gitaChapter12Verses()
                            :chapterNumber ==13
                             ? _gitaChapter13Verses()
                             :chapterNumber ==14
                             ? _gitaChapter14Verses()
                             :chapterNumber ==15
                             ? _gitaChapter15Verses()
                             :chapterNumber ==16
                             ? _gitaChapter16Verses()
                             :chapterNumber ==17
                             ? _gitaChapter17Verses()
                             :chapterNumber ==18
                             ? _gitaChapter18Verses()
                    : List.generate(18, (verseIndex) {
                  final verseNumber = verseIndex + 1;

                  final theme = _gitaVerseThemes[
                      (chapterNumber + verseIndex) %
                          _gitaVerseThemes.length];

                  return SacredVerseModel(
                    verseNumber: verseNumber,
                    sanskrit:
                        'अध्याय $chapterNumber श्लोक $verseNumber - योगः $theme',
                    english:
                        'In $chapterTitle, verse $verseNumber guides the seeker to practice $theme with steadiness, faith, and surrender to the Divine.',
                    gujarati:
                        '$chapterTitle ના શ્લોક $verseNumber માં સાધકને $theme ને નિષ્ઠા, શ્રદ્ધા અને પરમાત્મા સમર્પણ સાથે જીવવાની પ્રેરણા આપે છે.',
                    meaningEnglish:
                        'This verse teaches that progress comes when action, devotion, and inner balance are practiced together without ego.',
                    meaningGujarati:
                        'આ શ્લોક શીખવે છે કે અહંકાર છોડીને કર્તવ્ય, ભક્તિ અને મનનો સમત્વ સાથે રાખીએ ત્યારે સાચી પ્રગતિ થાય છે.',
                  );
                }),
        );
      }),
    );
  }

  // =====================================================
  // BHAGAVAD GITA - CHAPTER 1
  // ARJUNA VISHADA YOGA
  // 47 VERSES
  // =====================================================

  static List<SacredVerseModel> _gitaChapter1Verses() {

    return [
      SacredVerseModel(
        verseNumber: 1,
        sanskrit:
            'धृतराष्ट्र उवाच ।\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ॥१॥',
        gujarati:
            'ધૃતરાષ્ટ્ર બોલ્યા: હે સંજય! ધર્મભૂમિ કુરુક્ષેત્રમાં યુદ્ધ કરવાની ઇચ્છાથી ભેગા થયેલા મારા પુત્રો અને પાંડુના પુત્રોએ શું કર્યું?',
        english:
            'Dhritarashtra said: O Sanjaya, what did my sons and the sons of Pandu do when they assembled on the holy field of Kurukshetra, eager to fight?',
        meaningGujarati:
            'ધૃતરાષ્ટ્ર સંજયને પૂછે છે કે ધર્મક્ષેત્ર કુરુક્ષેત્રમાં યુદ્ધ માટે ભેગા થયેલા કૌરવો અને પાંડવો શું કરી રહ્યા છે.',
        meaningEnglish:
            'Dhritarashtra asks Sanjaya what happened when the Kauravas and Pandavas gathered at Kurukshetra for battle.',
      ),

      SacredVerseModel(
        verseNumber: 2,
        sanskrit:
            'सञ्जय उवाच ।\nदृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा ।\nआचार्यमुपसङ्गम्य राजा वचनमब्रवीत् ॥२॥',
        gujarati:
            'સંજય બોલ્યા: પાંડવોની યુદ્ધ માટે ગોઠવાયેલી વિશાળ સેનાને જોઈને રાજા દુર્યોધન પોતાના ગુરુ દ્રોણાચાર્ય પાસે જઈને આ શબ્દો બોલ્યો.',
        english:
            'Sanjaya said: Seeing the Pandava army arranged for battle, King Duryodhana approached his teacher Drona and spoke these words.',
        meaningGujarati:
            'પાંડવોની વિશાળ અને વ્યવસ્થિત સેનાને જોઈને દુર્યોધન દ્રોણાચાર્ય પાસે જાય છે અને પોતાની વાત શરૂ કરે છે.',
        meaningEnglish:
            'Seeing the Pandava army properly arranged for battle, Duryodhana approaches Drona and begins to speak.',
      ),

      SacredVerseModel(
        verseNumber: 3,
        sanskrit:
            'पश्यैतां पाण्डुपुत्राणामाचार्य महतीं चमूम् ।\nव्यूढां द्रुपदपुत्रेण तव शिष्येण धीमता ॥३॥',
        gujarati:
            'હે આચાર્ય! તમારા બુદ્ધિશાળી શિષ્ય દ્રુપદના પુત્ર ધૃષ્ટદ્યુમ્ને ગોઠવેલી પાંડવોની આ વિશાળ સેનાને જુઓ.',
        english:
            'O teacher, behold this mighty army of the sons of Pandu, arranged by your wise disciple, the son of Drupada.',
        meaningGujarati:
            'દુર્યોધન દ્રોણાચાર્યને પાંડવોની વિશાળ સેનાની રચના બતાવે છે અને ધૃષ્ટદ્યુમ્નનો ઉલ્લેખ કરે છે.',
        meaningEnglish:
            'Duryodhana points out the great Pandava army and mentions that it has been arranged by Drona’s intelligent disciple, the son of Drupada.',
      ),

      SacredVerseModel(
        verseNumber: 4,
        sanskrit:
            'अत्र शूरा महेष्वासा भीमार्जुनसमा युधि ।\nयुयुधानो विराटश्च द्रुपदश्च महारथः ॥४॥',
        gujarati:
            'આ સેનામાં ભીમ અને અર્જુન જેવા શક્તિશાળી ધનુર્ધારી યોદ્ધાઓ છે—યુયુધાન, વિરાટ અને મહારથી દ્રુપદ જેવા વીર પણ છે.',
        english:
            'Here are many mighty bowmen equal in battle to Bhima and Arjuna, including Yuyudhana, Virata and the great warrior Drupada.',
        meaningGujarati:
            'પાંડવોની સેનામાં ભીમ અને અર્જુન સમાન શક્તિશાળી યોદ્ધાઓ હાજર છે.',
        meaningEnglish:
            'Duryodhana recognizes that the Pandava army contains many powerful warriors comparable to Bhima and Arjuna.',
      ),

      SacredVerseModel(
        verseNumber: 5,
        sanskrit:
            'धृष्टकेतुश्चेकितानः काशिराजश्च वीर्यवान् ।\nपुरुजित्कुन्तिभोजश्च शैब्यश्च नरपुङ्गवः ॥५॥',
        gujarati:
            'ધૃષ્ટકેતુ, ચેકિતાન, પરાક્રમી કાશીરાજ, પુરુજિત, કુંતીભોજ અને મનુષ્યોમાં શ્રેષ્ઠ શૈબ્ય જેવા મહાન યોદ્ધાઓ પણ છે.',
        english:
            'There are also great warriors such as Dhrishtaketu, Chekitana, the powerful King of Kashi, Purujit, Kuntibhoja and Shaibya.',
        meaningGujarati:
            'પાંડવોની સેનામાં અનેક પ્રખ્યાત અને પરાક્રમી રાજાઓ તથા યોદ્ધાઓ પણ છે.',
        meaningEnglish:
            'Duryodhana continues listing the renowned and powerful warriors present on the Pandava side.',
      ),

      SacredVerseModel(
        verseNumber: 6,
        sanskrit:
            'युधामन्युश्च विक्रान्त उत्तमौजाश्च वीर्यवान् ।\nसौभद्रो द्रौपदेयाश्च सर्व एव महारथाः ॥६॥',
        gujarati:
            'પરાક્રમી યુધામન્યુ, શક્તિશાળી ઉત્તમૌજા, સુભદ્રાનો પુત્ર અભિમન્યુ અને દ્રૌપદીના પાંચ પુત્રો—આ બધા મહારથી છે.',
        english:
            'There are also the brave Yudhamanyu and powerful Uttamauja, Abhimanyu, the son of Subhadra, and the sons of Draupadi; all are great warriors.',
        meaningGujarati:
            'યુધામન્યુ, ઉત્તમૌજા, અભિમન્યુ અને દ્રૌપદીના પુત્રોને પણ મહારથી યોદ્ધા તરીકે ગણાવવામાં આવ્યા છે.',
        meaningEnglish:
            'Yudhamanyu, Uttamauja, Abhimanyu and the sons of Draupadi are described as great warriors.',
      ),

      SacredVerseModel(
        verseNumber: 7,
        sanskrit:
            'अस्माकं तु विशिष्टा ये तान्निबोध द्विजोत्तम ।\nनायका मम सैन्यस्य संज्ञार्थं तान्ब्रवीमि ते ॥७॥',
        gujarati:
            'હે શ્રેષ્ઠ બ્રાહ્મણ દ્રોણાચાર્ય! હવે અમારી સેનામાં જે મુખ્ય યોદ્ધાઓ છે તેમના વિશે પણ જાણો. તમારી જાણ માટે હું તેમના નામ કહું છું.',
        english:
            'O best of the twice-born, know also the distinguished leaders of our army. I shall name them for your information.',
        meaningGujarati:
            'હવે દુર્યોધન પોતાની સેનાના મુખ્ય યોદ્ધાઓના નામ દ્રોણાચાર્યને જણાવવા લાગે છે.',
        meaningEnglish:
            'Duryodhana now begins to identify the distinguished leaders of his own army.',
      ),

      SacredVerseModel(
        verseNumber: 8,
        sanskrit:
            'भवान्भीष्मश्च कर्णश्च कृपश्च समितिञ्जयः ।\nअश्वत्थामा विकर्णश्च सौमदत्तिस्तथैव च ॥८॥',
        gujarati:
            'આપ દ્રોણાચાર્ય, પિતામહ ભીષ્મ, કર્ણ, યુદ્ધમાં વિજયી કૃપાચાર્ય, અશ્વત્થામા, વિકર્ણ અને સોમદત્તનો પુત્ર ભૂરિશ્રવા—આ બધા આપણા મુખ્ય યોદ્ધાઓ છે.',
        english:
            'You, Bhishma, Karna, the victorious Kripa, Ashvatthama, Vikarna and Bhurishrava are among our foremost warriors.',
        meaningGujarati:
            'દુર્યોધન પોતાની તરફના મુખ્ય અને શક્તિશાળી યોદ્ધાઓની યાદી આપે છે.',
        meaningEnglish:
            'Duryodhana lists Drona, Bhishma, Karna, Kripa, Ashvatthama, Vikarna and Bhurishrava among the foremost warriors.',
      ),

      SacredVerseModel(
        verseNumber: 9,
        sanskrit:
            'अन्ये च बहवः शूरा मदर्थे त्यक्तजीविताः ।\nनानाशस्त्रप्रहरणाः सर्वे युद्धविशारदाः ॥९॥',
        gujarati:
            'મારા માટે પોતાનું જીવન અર્પણ કરવા તૈયાર એવા બીજા ઘણા શૂરવીરો પણ છે. તેઓ વિવિધ શસ્ત્રોથી સજ્જ છે અને યુદ્ધકલામાં નિપુણ છે.',
        english:
            'There are many other brave warriors who are ready to give up their lives for my sake. They are skilled in warfare and equipped with various weapons.',
        meaningGujarati:
            'દુર્યોધન કહે છે કે તેની તરફ ઘણા એવા વીર યોદ્ધાઓ છે જે યુદ્ધમાં જીવન અર્પણ કરવા તૈયાર છે.',
        meaningEnglish:
            'Duryodhana emphasizes that many other skilled warriors are prepared to sacrifice their lives for his cause.',
      ),

      SacredVerseModel(
        verseNumber: 10,
        sanskrit:
            'अपर्याप्तं तदस्माकं बलं भीष्माभिरक्षितम् ।\nपर्याप्तं त्विदमेतेषां बलं भीमाभिरक्षितम् ॥१०॥',
        gujarati:
            'પિતામહ ભીષ્મ દ્વારા રક્ષાયેલી અમારી સેના અપરિમિત છે, જ્યારે ભીમ દ્વારા રક્ષાયેલી પાંડવોની સેના મર્યાદિત છે.',
        english:
            'Our army, protected by Bhishma, is vast and unlimited, whereas their army, protected by Bhima, is limited.',
        meaningGujarati:
            'દુર્યોધન પોતાની સેનાને ભીષ્મના રક્ષણ હેઠળ અપરિમિત અને પાંડવોની સેનાને ભીમના રક્ષણ હેઠળ મર્યાદિત ગણાવે છે.',
        meaningEnglish:
            'Duryodhana compares the strength of the two armies and expresses confidence in the army protected by Bhishma.',
      ),

      SacredVerseModel(
        verseNumber: 11,
        sanskrit:
            'अयनेषु च सर्वेषु यथाभागमवस्थिताः ।\nभीष्ममेवाभिरक्षन्तु भवन्तः सर्व एव हि ॥११॥',
        gujarati:
            'તેથી તમે બધા પોતાના પોતાના સ્થાન પર રહીને દરેક બાજુથી પિતામહ ભીષ્મનું રક્ષણ કરો.',
        english:
            'Therefore, all of you, standing firmly in your respective positions, must protect Bhishma from all sides.',
        meaningGujarati:
            'દુર્યોધન પોતાના તમામ યોદ્ધાઓને પોતાના સ્થાન પર રહીને ભીષ્મનું રક્ષણ કરવા કહે છે.',
        meaningEnglish:
            'Duryodhana instructs all his warriors to remain in position and protect Bhishma from every side.',
      ),

      SacredVerseModel(
        verseNumber: 12,
        sanskrit:
            'तस्य सञ्जनयन्हर्षं कुरुवृद्धः पितामहः ।\nसिंहनादं विनद्योच्चैः शङ्खं दध्मौ प्रतापवान् ॥१२॥',
        gujarati:
            'દુર્યોધનના મનમાં ઉત્સાહ પેદા કરવા માટે કુરુવંશના વૃદ્ધ પિતામહ ભીષ્મે સિંહની જેમ ગર્જના કરીને જોરથી શંખ વગાડ્યો.',
        english:
            'Then the mighty grandsire Bhishma, the eldest of the Kurus, blew his conch loudly like a lion’s roar to encourage Duryodhana.',
        meaningGujarati:
            'દુર્યોધનને ઉત્સાહ આપવા માટે પિતામહ ભીષ્મે સિંહની ગર્જના સમાન અવાજ સાથે શંખ વગાડ્યો.',
        meaningEnglish:
            'Bhishma encourages Duryodhana by loudly blowing his conch with the force of a lion’s roar.',
      ),

      SacredVerseModel(
        verseNumber: 13,
        sanskrit:
            'ततः शङ्खाश्च भेर्यश्च पणवानकगोमुखाः ।\nसहसैवाभ्यहन्यन्त स शब्दस्तुमुलोऽभवत् ॥१३॥',
        gujarati:
            'ત્યારબાદ શંખ, નગારાં, ઢોલ અને અન્ય યુદ્ધવાદ્યો એકસાથે વાગવા લાગ્યાં અને તેમનો ભયંકર અવાજ થયો.',
        english:
            'Then conches, kettledrums, drums and horns were sounded all at once, creating a tremendous noise.',
        meaningGujarati:
            'ભીષ્મના શંખ પછી બંને સેનાઓમાં યુદ્ધવાદ્યોના જોરદાર અવાજો ગુંજવા લાગ્યા.',
        meaningEnglish:
            'After Bhishma’s conch, many instruments were sounded together, filling the battlefield with a tremendous noise.',
      ),

      SacredVerseModel(
        verseNumber: 14,
        sanskrit:
            'ततः श्वेतैर्हयैर्युक्ते महति स्यन्दने स्थितौ ।\nमाधवः पाण्डवश्चैव दिव्यौ शङ्खौ प्रदध्मतुः ॥१४॥',
        gujarati:
            'ત્યારબાદ સફેદ ઘોડાઓ જોડાયેલા ભવ્ય રથમાં બેઠેલા ભગવાન શ્રીકૃષ્ણ અને અર્જુને પોતાના દિવ્ય શંખ વગાડ્યા.',
        english:
            'Then Krishna and Arjuna, seated in the great chariot drawn by white horses, blew their divine conches.',
        meaningGujarati:
            'સફેદ ઘોડાઓથી જોડાયેલા રથમાં બેઠેલા શ્રીકૃષ્ણ અને અર્જુને પોતાના દિવ્ય શંખ વગાડ્યા.',
        meaningEnglish:
            'Krishna and Arjuna respond by blowing their divine conches from their magnificent chariot.',
      ),

      SacredVerseModel(
        verseNumber: 15,
        sanskrit:
            'पाञ्चजन्यं हृषीकेशो देवदत्तं धनञ्जयः ।\nपौण्ड्रं दध्मौ महाशङ्खं भीमकर्मा वृकोदरः ॥१५॥',
        gujarati:
            'હૃષીકેશ શ્રીકૃષ્ણે પાંચજન્ય શંખ વગાડ્યો, અર્જુને દેવદત્ત શંખ અને ભયંકર પરાક્રમી ભીમે પૌંડ્ર નામનો મહાશંખ વગાડ્યો.',
        english:
            'Krishna blew the Panchajanya, Arjuna blew the Devadatta, and Bhima, the doer of mighty deeds, blew his great conch named Paundra.',
        meaningGujarati:
            'શ્રીકૃષ્ણ, અર્જુન અને ભીમ પોતાના વિશિષ્ટ શંખ વગાડે છે.',
        meaningEnglish:
            'The conches of Krishna, Arjuna and Bhima are named Panchajanya, Devadatta and Paundra respectively.',
      ),

      SacredVerseModel(
        verseNumber: 16,
        sanskrit:
            'अनन्तविजयं राजा कुन्तीपुत्रो युधिष्ठिरः ।\nनकुलः सहदेवश्च सुघोषमणिपुष्पकौ ॥१६॥',
        gujarati:
            'કુંતીપુત્ર રાજા યુધિષ્ઠિરે અનંતવિજય શંખ વગાડ્યો. નકુલે સુઘોષ અને સહદેવે મણિપુષ્પક શંખ વગાડ્યા.',
        english:
            'King Yudhishthira, the son of Kunti, blew the conch Anantavijaya; Nakula and Sahadeva blew Sughosha and Manipushpaka.',
        meaningGujarati:
            'યુધિષ્ઠિર, નકુલ અને સહદેવ પણ પોતાના વિશિષ્ટ શંખ વગાડે છે.',
        meaningEnglish:
            'Yudhishthira, Nakula and Sahadeva also sound their respective conches.',
      ),

      SacredVerseModel(
        verseNumber: 17,
        sanskrit:
            'काश्यश्च परमेष्वासः शिखण्डी च महारथः ।\nधृष्टद्युम्नो विराटश्च सात्यकिश्चापराजितः ॥१७॥',
        gujarati:
            'મહાન ધનુર્ધારી કાશીરાજ, મહારથી શિખંડી, ધૃષ્ટદ્યુમ્ન, વિરાટ અને અજેય સાત્યકિએ પણ પોતાના શંખ વગાડ્યા.',
        english:
            'The great archer King of Kashi, the mighty warrior Shikhandi, Dhrishtadyumna, Virata and the unconquerable Satyaki also blew their conches.',
        meaningGujarati:
            'પાંડવોની તરફના અનેક મહાન યોદ્ધાઓ પણ યુદ્ધ માટે પોતાની હાજરી દર્શાવે છે.',
        meaningEnglish:
            'Several prominent Pandava warriors also blow their conches in preparation for the battle.',
      ),

      SacredVerseModel(
        verseNumber: 18,
        sanskrit:
            'द्रुपदो द्रौपदेयाश्च सर्वशः पृथिवीपते ।\nसौभद्रश्च महाबाहुः शङ्खान्दध्मुः पृथक्पृथक् ॥१८॥',
        gujarati:
            'હે રાજન! દ્રુપદ, દ્રૌપદીના પાંચ પુત્રો અને મહાબાહુ અભિમન્યુએ પણ અલગ અલગ પોતાના શંખ વગાડ્યા.',
        english:
            'O King, Drupada, the sons of Draupadi and the mighty-armed Abhimanyu each blew their respective conches.',
        meaningGujarati:
            'દ્રુપદ, દ્રૌપદીના પુત્રો અને અભિમન્યુએ પણ પોતાના શંખ વગાડ્યા.',
        meaningEnglish:
            'Drupada, the sons of Draupadi and Abhimanyu each sound their own conches.',
      ),

      SacredVerseModel(
        verseNumber: 19,
        sanskrit:
            'स घोषो धार्तराष्ट्राणां हृदयानि व्यदारयत् ।\nनभश्च पृथिवीं चैव तुमुलोऽभ्यनुनादयन् ॥१९॥',
        gujarati:
            'આ ભયંકર શંખનાદે આકાશ અને પૃથ્વીને ગજાવી દીધાં અને ધૃતરાષ્ટ્રના પુત્રોના હૃદયમાં ભય પેદા કર્યો.',
        english:
            'The terrible sound of those conches echoed through the sky and earth and pierced the hearts of the sons of Dhritarashtra.',
        meaningGujarati:
            'પાંડવોની સેનાના શંખનાદથી સમગ્ર વાતાવરણ ગુંજી ઊઠ્યું અને કૌરવોના હૃદયમાં ભય ઉત્પન્ન થયો.',
        meaningEnglish:
            'The powerful sound of the Pandava conches fills the earth and sky and deeply affects the Kauravas.',
      ),

      SacredVerseModel(
        verseNumber: 20,
        sanskrit:
            'अथ व्यवस्थितान्दृष्ट्वा धार्तराष्ट्रान् कपिध्वजः ।\nप्रवृत्ते शस्त्रसम्पाते धनुरुद्यम्य पाण्डवः ॥२०॥',
        gujarati:
            'હવે યુદ્ધ શરૂ થવાનું હતું. ત્યારે કપિધ્વજ અર્જુને ધૃતરાષ્ટ્રના પુત્રોને યુદ્ધ માટે તૈયાર જોઈને પોતાનું ધનુષ્ય ઉપાડ્યું.',
        english:
            'Then Arjuna, whose banner bore Hanuman, saw the sons of Dhritarashtra ready for battle and lifted his bow as the weapons were about to clash.',
        meaningGujarati:
            'યુદ્ધ શરૂ થવાની ક્ષણે અર્જુન પોતાનું ધનુષ્ય ઉપાડે છે અને સામેની સેનાને નિહાળે છે.',
        meaningEnglish:
            'As the battle is about to begin, Arjuna raises his bow and looks toward the opposing army.',
      ),

      SacredVerseModel(
        verseNumber: 21,
        sanskrit:
            'हृषीकेशं तदा वाक्यमिदमाह महीपते ।\nअर्जुन उवाच ।\nसेनयोरुभयोर्मध्ये रथं स्थापय मेऽच्युत ॥२१॥',
        gujarati:
            'અર્જુને કહ્યું: હે અચ્યુત! મારો રથ બંને સેનાઓની વચ્ચે ઊભો રાખો.',
        english:
            'Arjuna said: O Krishna, please place my chariot between the two armies.',
        meaningGujarati:
            'અર્જુન શ્રીકૃષ્ણને બંને સેનાઓની વચ્ચે રથ ઊભો રાખવા વિનંતી કરે છે.',
        meaningEnglish:
            'Arjuna asks Krishna to position the chariot between the two armies.',
      ),

      SacredVerseModel(
        verseNumber: 22,
        sanskrit:
            'यावदेतान्निरीक्षेऽहं योद्धुकामानवस्थितान् ।\nकैर्मया सह योद्धव्यमस्मिन् रणसमुद्यमे ॥२२॥',
        gujarati:
            'જ્યાં સુધી હું યુદ્ધ કરવા માટે ઊભેલા આ યોદ્ધાઓને જોઈ લઉં કે મારે આ યુદ્ધમાં કોની સાથે લડવાનું છે.',
        english:
            'Let me see those who stand here eager to fight, and with whom I must engage in this battle.',
        meaningGujarati:
            'અર્જુન યુદ્ધમાં કોની સામે લડવાનું છે તે પોતાના નેત્રોથી જોવા માંગે છે.',
        meaningEnglish:
            'Arjuna wants to observe the warriors with whom he is about to fight.',
      ),

      SacredVerseModel(
        verseNumber: 23,
        sanskrit:
            'योत्स्यमानानवेक्षेऽहं य एतेऽत्र समागताः ।\nधार्तराष्ट्रस्य दुर्बुद्धेर्युद्धे प्रियचिकीर्षवः ॥२३॥',
        gujarati:
            'ધૃતરાષ્ટ્રના દુષ્ટબુદ્ધિ પુત્ર દુર્યોધનને પ્રસન્ન કરવા માટે અહીં યુદ્ધ કરવા આવેલા યોદ્ધાઓને હું જોવા માંગું છું.',
        english:
            'I wish to see those assembled here to fight, desiring to please the evil-minded son of Dhritarashtra.',
        meaningGujarati:
            'અર્જુન દુર્યોધનના પક્ષમાં યુદ્ધ કરવા આવેલા યોદ્ધાઓને જોવા માંગે છે.',
        meaningEnglish:
            'Arjuna wishes to see those who have gathered to fight on behalf of Duryodhana.',
      ),

      SacredVerseModel(
        verseNumber: 24,
        sanskrit:
            'सञ्जय उवाच ।\nएवमुक्तो हृषीकेशो गुडाकेशेन भारत ।\nसेनयोरुभयोर्मध्ये स्थापयित्वा रथोत्तमम् ॥२४॥',
        gujarati:
            'સંજય બોલ્યા: અર્જુને આમ કહ્યું ત્યારે ભગવાન શ્રીકૃષ્ણે બંને સેનાઓની વચ્ચે પોતાનો ઉત્તમ રથ ઊભો રાખ્યો.',
        english:
            'Sanjaya said: O Bharata, after Arjuna spoke thus, Krishna placed the magnificent chariot between the two armies.',
        meaningGujarati:
            'અર્જુનની વિનંતી સ્વીકારીને શ્રીકૃષ્ણે રથ બંને સેનાઓની વચ્ચે લઈ ગયા.',
        meaningEnglish:
            'Krishna fulfills Arjuna’s request and places the chariot between the two armies.',
      ),

      SacredVerseModel(
        verseNumber: 25,
        sanskrit:
            'भीष्मद्रोणप्रमुखतः सर्वेषां च महीक्षिताम् ।\nउवाच पार्थ पश्यैतान् समवेतान् कुरूनिति ॥२५॥',
        gujarati:
            'ભીષ્મ, દ્રોણાચાર્ય અને અન્ય રાજાઓની સામે રથ ઊભો રાખીને શ્રીકૃષ્ણે કહ્યું: હે પાર્થ! અહીં ભેગા થયેલા કુરુવંશના લોકોને જુઓ.',
        english:
            'In front of Bhishma, Drona and all the other kings, Krishna said: O Partha, behold all these Kurus assembled here.',
        meaningGujarati:
            'શ્રીકૃષ્ણ અર્જુનને ભીષ્મ, દ્રોણ અને અન્ય કુરુ યોદ્ધાઓની સામે રથ ઊભો રાખીને તેમને જોવા કહે છે.',
        meaningEnglish:
            'Krishna places the chariot before the great elders and tells Arjuna to behold the assembled Kurus.',
      ),

      SacredVerseModel(
        verseNumber: 26,
        sanskrit:
            'तत्रापश्यत्स्थितान्पार्थः पितॄनथ पितामहान् ।\nआचार्यान्मातुलान्भ्रातॄन् पुत्रान्पौत्रान्सखींस्तथा ॥२६॥',
        gujarati:
            'અર્જુને ત્યાં પોતાના પિતા સમાન વડીલો, પિતામહો, ગુરુઓ, મામાઓ, ભાઈઓ, પુત્રો, પૌત્રો અને મિત્રોને ઊભેલા જોયા.',
        english:
            'There Arjuna saw fathers, grandfathers, teachers, maternal uncles, brothers, sons, grandsons and friends standing in both armies.',
        meaningGujarati:
            'અર્જુનને યુદ્ધભૂમિમાં પોતાના જ પરિવારના અનેક સંબંધીઓ અને વડીલો દેખાય છે.',
        meaningEnglish:
            'Arjuna recognizes many close relatives, elders, teachers and friends on the battlefield.',
      ),

      SacredVerseModel(
        verseNumber: 27,
        sanskrit:
            'श्वशुरान्सुहृदश्चैव सेनयोरुभयोरपि ।\nतान्समीक्ष्य स कौन्तेयः सर्वान्बन्धूनवस्थितान् ॥२७॥',
        gujarati:
            'તેણે બંને સેનાઓમાં પોતાના સસરા અને સ્નેહીજનો સહિત બધા સંબંધીઓને ઊભેલા જોયા.',
        english:
            'He also saw fathers-in-law and dear relatives in both armies. Seeing all his relatives standing there, Arjuna was deeply affected.',
        meaningGujarati:
            'બંને પક્ષોમાં પોતાના સસરા, સ્નેહીજનો અને સંબંધીઓને જોઈને અર્જુનનું મન વ્યથિત થવા લાગે છે.',
        meaningEnglish:
            'Seeing relatives and loved ones on both sides causes Arjuna deep emotional distress.',
      ),

      SacredVerseModel(
        verseNumber: 28,
        sanskrit:
            'कृपया परयाविष्टो विषीदन्निदमब्रवीत् ।\nअर्जुन उवाच ।\nदृष्ट्वेमं स्वजनं कृष्ण युयुत्सुं समुपस्थितम् ॥२८॥',
        gujarati:
            'અતિશય કરુણાથી વ્યાકુળ થયેલા અર્જુને કહ્યું: હે કૃષ્ણ! યુદ્ધ કરવા માટે સામે ઊભેલા મારા સ્વજનોને જોઈને મારું મન દુઃખી થઈ રહ્યું છે.',
        english:
            'Overcome with compassion and sorrow, Arjuna said: O Krishna, seeing my own people standing here eager to fight...',
        meaningGujarati:
            'પોતાના સ્વજનોને યુદ્ધ માટે તૈયાર જોઈને અર્જુન કરુણા અને શોકથી વ્યાકુળ થઈ જાય છે.',
        meaningEnglish:
            'Arjuna becomes overwhelmed with compassion and sorrow upon seeing his own people ready to fight.',
      ),

      SacredVerseModel(
        verseNumber: 29,
        sanskrit:
            'सीदन्ति मम गात्राणि मुखं च परिशुष्यति ।\nवेपथुश्च शरीरे मे रोमहर्षश्च जायते ॥२९॥',
        gujarati:
            'મારા અંગો ઢીલા પડી રહ્યા છે, મારું મોં સુકાઈ રહ્યું છે, શરીર કાંપી રહ્યું છે અને મારા રોમ ઊભા થઈ રહ્યા છે.',
        english:
            'My limbs are failing me, my mouth is drying up, my body is trembling, and my hair is standing on end.',
        meaningGujarati:
            'અર્જુનના શરીરમાં ભય, શોક અને માનસિક તાણના ગંભીર લક્ષણો દેખાવા લાગે છે.',
        meaningEnglish:
            'Arjuna describes how intense sorrow and fear are affecting his body.',
      ),

      SacredVerseModel(
        verseNumber: 30,
        sanskrit:
            'गाण्डीवं स्रंसते हस्तात्त्वक्चैव परिदह्यते ।\nन च शक्नोम्यवस्थातुं भ्रमतीव च मे मनः ॥३०॥',
        gujarati:
            'મારા હાથમાંથી ગાંડીવ ધનુષ્ય પડી રહ્યું છે, મારી ચામડી બળી રહી છે, હું ઊભો રહી શકતો નથી અને મારું મન જાણે ભમરી રહ્યું છે.',
        english:
            'My bow Gandiva is slipping from my hand, my skin is burning, I cannot stand steadily, and my mind seems to be reeling.',
        meaningGujarati:
            'અર્જુન એટલો વ્યાકુળ છે કે તેનું ધનુષ્ય હાથમાંથી છૂટી રહ્યું છે અને તેનું મન અસ્થિર બની ગયું છે.',
        meaningEnglish:
            'Arjuna is so overwhelmed that he cannot hold his bow properly or maintain mental and physical steadiness.',
      ),

      SacredVerseModel(
        verseNumber: 31,
        sanskrit:
            'निमित्तानि च पश्यामि विपरीतानि केशव ।\nन च श्रेयोऽनुपश्यामि हत्वा स्वजनमाहवे ॥३१॥',
        gujarati:
            'હે કેશવ! મને બધા અશુભ સંકેતો દેખાઈ રહ્યા છે. યુદ્ધમાં પોતાના સ્વજનોને મારીને મને કોઈ કલ્યાણ દેખાતું નથી.',
        english:
            'O Keshava, I see bad omens everywhere. I do not see any good in killing my own relatives in battle.',
        meaningGujarati:
            'અર્જુનને પોતાના સ્વજનોની હત્યામાં કોઈ શુભ પરિણામ દેખાતું નથી.',
        meaningEnglish:
            'Arjuna cannot see any beneficial outcome in killing his own relatives.',
      ),

      SacredVerseModel(
        verseNumber: 32,
        sanskrit:
            'न काङ्क्षे विजयं कृष्ण न च राज्यं सुखानि च ।\nकिं नो राज्येन गोविन्द किं भोगैर्जीवितेन वा ॥३२॥',
        gujarati:
            'હે કૃષ્ણ! મને વિજયની, રાજ્યની કે સુખોની કોઈ ઇચ્છા નથી. હે ગોવિંદ! જ્યારે પોતાના લોકો જ નહીં રહે, ત્યારે રાજ્ય, ભોગ અને જીવનનો શું ઉપયોગ?',
        english:
            'O Krishna, I do not desire victory, kingdom or pleasures. O Govinda, what use are kingdom, enjoyment or even life without our loved ones?',
        meaningGujarati:
            'સ્વજનો વગર મળેલું રાજ્ય, ભોગ કે જીવન અર્જુનને નિરર્થક લાગે છે.',
        meaningEnglish:
            'Arjuna questions the value of victory, wealth and life if they come at the cost of loved ones.',
      ),

      SacredVerseModel(
        verseNumber: 33,
        sanskrit:
            'येषामर्थे काङ्क्षितं नो राज्यं भोगाः सुखानि च ।\nत इमेऽवस्थिता युद्धे प्राणांस्त्यक्त्वा धनानि च ॥३३॥',
        gujarati:
            'જેમના માટે આપણે રાજ્ય, ભોગ અને સુખની ઇચ્છા રાખીએ છીએ, તે જ લોકો પોતાના પ્રાણ અને ધનનો ત્યાગ કરવા માટે યુદ્ધમાં ઊભા છે.',
        english:
            'Those for whose sake we desire kingdom, pleasures and happiness are standing here in battle, ready to give up their lives and wealth.',
        meaningGujarati:
            'જેઓ માટે રાજ્ય અને સુખ જોઈએ છે, એ જ સ્વજનો યુદ્ધમાં મૃત્યુ માટે ઊભા છે.',
        meaningEnglish:
            'The very people for whom Arjuna would enjoy the kingdom are now standing ready to sacrifice their lives.',
      ),

      SacredVerseModel(
        verseNumber: 34,
        sanskrit:
            'आचार्याः पितरः पुत्रास्तथैव च पितामहाः ।\nमातुलाः श्वशुराः पौत्राः श्यालाः सम्बन्धिनस्तथा ॥३४॥',
        gujarati:
            'અહીં મારા ગુરુઓ, પિતા સમાન વડીલો, પુત્રો, પિતામહો, મામાઓ, સસરા, પૌત્રો, સાળાઓ અને અન્ય સગાં-સંબંધીઓ ઊભા છે.',
        english:
            'Teachers, fathers, sons, grandfathers, maternal uncles, fathers-in-law, grandsons, brothers-in-law and other relatives are standing here.',
        meaningGujarati:
            'અર્જુન યુદ્ધભૂમિમાં પોતાના વિવિધ સંબંધીઓ અને પ્રિયજનોની યાદ કરે છે.',
        meaningEnglish:
            'Arjuna emphasizes the many kinds of close family relationships represented on the battlefield.',
      ),

      SacredVerseModel(
        verseNumber: 35,
        sanskrit:
            'एतान्न हन्तुमिच्छामि घ्नतोऽपि मधुसूदन ।\nअपि त्रैलोक्यराज्यस्य हेतोः किं नु महीकृते ॥३५॥',
        gujarati:
            'હે મધુસૂદન! તેઓ મને મારી નાખે તો પણ હું તેમને મારવા માંગતો નથી. ત્રણેય લોકનું રાજ્ય મળે તો પણ પૃથ્વીના રાજ્ય માટે તો તેમને મારવાની વાત જ ક્યાંથી આવે?',
        english:
            'O Madhusudana, even if they were to kill me, I would not want to kill them—not even for sovereignty over the three worlds, much less for this earthly kingdom.',
        meaningGujarati:
            'અર્જુન કહે છે કે ત્રણેય લોકનું રાજ્ય મળે તો પણ પોતાના સ્વજનોને મારીને તે મેળવવા માંગતો નથી.',
        meaningEnglish:
            'Arjuna says that even the greatest possible kingdom would not justify killing his own relatives.',
      ),

      SacredVerseModel(
        verseNumber: 36,
        sanskrit:
            'निहत्य धार्तराष्ट्रान्नः का प्रीतिः स्याज्जनार्दन ।\nपापमेवाश्रयेदस्मान्हत्वैतानाततायिनः ॥३६॥',
        gujarati:
            'હે જનાર્દન! ધૃતરાષ્ટ્રના પુત્રોને મારીને આપણને કયો આનંદ મળશે? તેમને મારીને આપણને પાપ જ લાગશે.',
        english:
            'O Janardana, what happiness could we gain by killing the sons of Dhritarashtra? By killing them, sin would surely come upon us.',
        meaningGujarati:
            'અર્જુનને લાગે છે કે ધૃતરાષ્ટ્રના પુત્રોને મારીને મળનાર આનંદ કરતાં પાપનું ભારણ વધારે હશે.',
        meaningEnglish:
            'Arjuna believes that killing the sons of Dhritarashtra would bring no real happiness and would instead lead to sin.',
      ),

      SacredVerseModel(
        verseNumber: 37,
        sanskrit:
            'तस्मान्नार्हा वयं हन्तुं धार्तराष्ट्रान्स्वबान्धवान् ।\nस्वजनं हि कथं हत्वा सुखिनः स्याम माधव ॥३७॥',
        gujarati:
            'તેથી પોતાના જ સગાં ધૃતરાષ્ટ્રના પુત્રોને મારવા આપણે યોગ્ય નથી. હે માધવ! પોતાના લોકોને મારીને આપણે કેવી રીતે સુખી થઈ શકીએ?',
        english:
            'Therefore, we should not kill our own relatives, the sons of Dhritarashtra. O Madhava, how could we be happy after killing our own people?',
        meaningGujarati:
            'પોતાના જ સંબંધીઓને મારીને સાચું સુખ પ્રાપ્ત થઈ શકે નહીં એવું અર્જુન માને છે.',
        meaningEnglish:
            'Arjuna argues that true happiness cannot come from killing one’s own relatives.',
      ),

      SacredVerseModel(
        verseNumber: 38,
        sanskrit:
            'यद्यप्येते न पश्यन्ति लोभोपहतचेतसः ।\nकुलक्षयकृतं दोषं मित्रद्रोहे च पातकम् ॥३८॥',
        gujarati:
            'લોભથી જેમનું મન અંધ બની ગયું છે, એવા આ લોકો કુળના વિનાશમાં રહેલો દોષ અને મિત્રદ્રોહનું પાપ જોતા નથી.',
        english:
            'Though their minds are overcome by greed, they do not see the wrong in destroying the family or the sin of betraying their own relatives.',
        meaningGujarati:
            'અર્જુન કહે છે કે લોભથી અંધ બનેલા લોકો કુળના વિનાશના દોષને સમજતા નથી.',
        meaningEnglish:
            'Arjuna believes that greed has blinded the opposing side to the consequences of destroying their own family.',
      ),

      SacredVerseModel(
        verseNumber: 39,
        sanskrit:
            'कथं न ज्ञेयमस्माभिः पापादस्मान्निवर्तितुम् ।\nकुलक्षयकृतं दोषं प्रपश्यद्भिर्जनार्दन ॥३९॥',
        gujarati:
            'હે જનાર્દન! જ્યારે આપણે કુળના વિનાશથી થતો દોષ જોઈ શકીએ છીએ, ત્યારે આ પાપથી દૂર રહેવાનો વિચાર આપણે કેમ ન કરીએ?',
        english:
            'O Janardana, knowing the evil caused by destruction of the family, why should we not turn away from this sinful act?',
        meaningGujarati:
            'જ્યારે કુળવિનાશના પરિણામો સમજાય છે ત્યારે તે વિનાશક કર્મથી દૂર રહેવું જોઈએ.',
        meaningEnglish:
            'If the consequences of destroying the family are understood, Arjuna asks why they should not avoid such an act.',
      ),

      SacredVerseModel(
        verseNumber: 40,
        sanskrit:
            'कुलक्षये प्रणश्यन्ति कुलधर्माः सनातनाः ।\nधर्मे नष्टे कुलं कृत्स्नमधर्मोऽभिभवत्युत ॥४०॥',
        gujarati:
            'કુળનો નાશ થતાં તેના સનાતન કુળધર્મો નષ્ટ થઈ જાય છે અને ધર્મનો નાશ થતાં સમગ્ર કુળમાં અધર્મનું પ્રભુત્વ થઈ જાય છે.',
        english:
            'When a family is destroyed, its ancient family traditions perish. When righteousness is destroyed, unrighteousness takes over the entire family.',
        meaningGujarati:
            'કુળના વિનાશ સાથે તેની પરંપરાઓ અને ધાર્મિક કર્તવ્યો નષ્ટ થઈ શકે છે અને અધર્મ વધે છે.',
        meaningEnglish:
            'Arjuna fears that destruction of families will also destroy their established traditions and allow unrighteousness to prevail.',
      ),

      SacredVerseModel(
        verseNumber: 41,
        sanskrit:
            'अधर्माभिभवात्कृष्ण प्रदुष्यन्ति कुलस्त्रियः ।\nस्त्रीषु दुष्टासु वार्ष्णेय जायते वर्णसङ्करः ॥४१॥',
        gujarati:
            'હે કૃષ્ણ! જ્યારે અધર્મ વધે છે ત્યારે કુળની સ્ત્રીઓ દૂષિત થાય છે અને સ્ત્રીઓના દૂષિત થવાથી કુળમાં વર્ણસંકર સંતતિ ઉત્પન્ન થાય છે.',
        english:
            'O Krishna, when unrighteousness prevails, the women of the family become corrupted, and this leads to unwanted social confusion.',
        meaningGujarati:
            'અર્જુન પોતાના સમયની સામાજિક અને કુટુંબ વ્યવસ્થાના ભંગ અંગે ચિંતા વ્યક્ત કરે છે.',
        meaningEnglish:
            'Arjuna expresses concern that the destruction of social and family order will create wider social disorder.',
      ),

      SacredVerseModel(
        verseNumber: 42,
        sanskrit:
            'सङ्करो नरकायैव कुलघ्नानां कुलस्य च ।\nपतन्ति पितरो ह्येषां लुप्तपिण्डोदकक्रियाः ॥४२॥',
        gujarati:
            'વર્ણસંકરતા કુળનો નાશ કરનારાઓ અને સમગ્ર કુળને નરક તરફ લઈ જાય છે. પિંડ અને જળની ધાર્મિક ક્રિયાઓ બંધ થવાથી તેમના પૂર્વજોનું પણ પતન થાય છે.',
        english:
            'Such social confusion leads the destroyers of the family and the family itself toward hell. The ancestors also fall because the traditional offerings to them cease.',
        meaningGujarati:
            'કુટુંબની પરંપરાગત ધાર્મિક ક્રિયાઓ બંધ થવાથી કુળ અને પૂર્વજોની સ્થિતિ પર પણ અસર પડે છે એવી અર્જુનની માન્યતા છે.',
        meaningEnglish:
            'Arjuna fears that the collapse of family traditions will interrupt customary duties toward ancestors and harm the family.',
      ),

      SacredVerseModel(
        verseNumber: 43,
        sanskrit:
            'दोषैरेतैः कुलघ्नानां वर्णसङ्करकारकैः ।\nउत्साद्यन्ते जातिधर्माः कुलधर्माश्च शाश्वताः ॥४३॥',
        gujarati:
            'કુળના વિનાશથી અને વર્ણસંકરતા પેદા કરનારા આ દોષોથી સનાતન જાતિધર્મ અને કુળધર્મ નષ્ટ થઈ જાય છે.',
        english:
            'Because of these destructive actions, which create social confusion, the eternal family and social duties are destroyed.',
        meaningGujarati:
            'કુળના વિનાશ અને સામાજિક વ્યવસ્થાના ભંગથી પરંપરાગત ધર્મ અને કર્તવ્યો નષ્ટ થઈ શકે છે.',
        meaningEnglish:
            'Arjuna believes that family destruction can lead to the loss of long-standing social and family duties.',
      ),

      SacredVerseModel(
        verseNumber: 44,
        sanskrit:
            'उत्सन्नकुलधर्माणां मनुष्याणां जनार्दन ।\nनरकेऽनियतं वासो भवतीत्यनुशुश्रुम ॥४४॥',
        gujarati:
            'હે જનાર્દન! જેમના કુળધર્મો નષ્ટ થઈ ગયા છે એવા લોકોનો લાંબા સમય સુધી નરકમાં વાસ થાય છે એવું અમે સાંભળ્યું છે.',
        english:
            'O Janardana, we have heard that those whose family traditions are destroyed must dwell in hell for a long time.',
        meaningGujarati:
            'પરંપરાગત કુળધર્મોના નાશના ગંભીર આધ્યાત્મિક પરિણામો વિશે અર્જુન ચિંતા વ્યક્ત કરે છે.',
        meaningEnglish:
            'Arjuna recalls the teaching that the loss of family traditions carries serious spiritual consequences.',
      ),

      SacredVerseModel(
        verseNumber: 45,
        sanskrit:
            'अहो बत महत्पापं कर्तुं व्यवसिता वयम् ।\nयद्राज्यसुखलोभेन हन्तुं स्वजनमुद्यताः ॥४५॥',
        gujarati:
            'અરે! રાજ્યના સુખના લોભમાં પોતાના જ સ્વજનોને મારવા માટે તૈયાર થઈને આપણે કેટલું મોટું પાપ કરવા જઈ રહ્યા છીએ!',
        english:
            'Alas! We are about to commit a great sin, driven by greed for the pleasures of a kingdom and prepared to kill our own relatives.',
        meaningGujarati:
            'અર્જુનને લાગે છે કે રાજ્ય અને સુખના લોભમાં પોતાના સ્વજનોની હત્યા કરવી મોટું પાપ છે.',
        meaningEnglish:
            'Arjuna laments that the desire for kingdom and pleasure has brought them to the edge of a grave moral act.',
      ),

      SacredVerseModel(
        verseNumber: 46,
        sanskrit:
            'यदि मामप्रतीकारमशस्त्रं शस्त्रपाणयः ।\nधार्तराष्ट्रा रणे हन्युस्तन्मे क्षेमतरं भवेत् ॥४६॥',
        gujarati:
            'જો હું કોઈ પ્રતિકાર ન કરું, શસ્ત્ર વિના રહું અને ધૃતરાષ્ટ્રના પુત્રો શસ્ત્રોથી મને યુદ્ધમાં મારી નાખે, તો એ મારા માટે વધુ કલ્યાણકારી હશે.',
        english:
            'If the sons of Dhritarashtra, armed with weapons, were to kill me while I remain unarmed and offer no resistance, that would be better for me.',
        meaningGujarati:
            'અર્જુન કહે છે કે પોતાના સ્વજનોને મારવા કરતાં પોતે નિઃશસ્ત્ર રહીને મૃત્યુ સ્વીકારવું વધુ સારું છે.',
        meaningEnglish:
            'Arjuna would rather be killed without resistance than kill his own relatives.',
      ),

      SacredVerseModel(
        verseNumber: 47,
        sanskrit:
            'सञ्जय उवाच ।\nएवमुक्त्वार्जुनः सङ्ख्ये रथोपस्थ उपाविशत् ।\nविसृज्य सशरं चापं शोकसंविग्नमानसः ॥४७॥',
        gujarati:
            'સંજય બોલ્યા: આ રીતે કહીને શોકથી વ્યાકુળ મનવાળા અર્જુને બાણ સહિતનું ગાંડીવ ધનુષ્ય મૂકી દીધું અને યુદ્ધભૂમિમાં પોતાના રથમાં બેસી ગયો.',
        english:
            'Sanjaya said: Having spoken thus, Arjuna, whose mind was overwhelmed with sorrow, cast aside his bow and arrows and sat down on the seat of his chariot on the battlefield.',
        meaningGujarati:
            'અર્જુન શોકથી વ્યાકુળ થઈને પોતાનું ધનુષ્ય અને બાણ મૂકી દે છે અને રથમાં બેસી જાય છે. અહીં પ્રથમ અધ્યાયનો અંત થાય છે.',
        meaningEnglish:
            'Overwhelmed by sorrow, Arjuna puts down his bow and arrows and sits down in the chariot. This concludes Chapter 1.',
      ),
    ];
  }
  // =====================================================
// BHAGAVAD GITA - CHAPTER 2
// SANKHYA YOGA
// =====================================================

static List<SacredVerseModel> _gitaChapter2Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'सञ्जय उवाच ।\nतं तथा कृपयाविष्टमश्रुपूर्णाकुलेक्षणम् ।\nविषीदन्तमिदं वाक्यमुवाच मधुसूदनः ॥१॥',
      english:
          'Sanjaya said: Seeing Arjuna overwhelmed with compassion, his eyes filled with tears and his mind overcome with sorrow, Krishna spoke these words.',
      gujarati:
          'સંજય બોલ્યા: કરુણાથી વ્યાકુળ અને આંસુભરી આંખોવાળા શોકગ્રસ્ત અર્જુનને જોઈને શ્રીકૃષ્ણે આ શબ્દો કહ્યા.',
      meaningEnglish:
          'Krishna begins to guide Arjuna out of his sorrow and confusion.',
      meaningGujarati:
          'શ્રીકૃષ્ણ અર્જુનને શોક અને મૂંઝવણમાંથી બહાર કાઢવા માટે ઉપદેશ આપવાનું શરૂ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'श्रीभगवानुवाच ।\nकुतस्त्वा कश्मलमिदं विषमे समुपस्थितम् ।\nअनार्यजुष्टमस्वर्ग्यमकीर्तिकरमर्जुन ॥२॥',
      english:
          'The Supreme Lord said: O Arjuna, from where has this weakness come upon you at this critical moment? It is unworthy, does not lead to higher realms, and brings disgrace.',
      gujarati:
          'શ્રીભગવાન બોલ્યા: હે અર્જુન! આ સંકટના સમયે તારા મનમાં આવી નિર્બળતા ક્યાંથી આવી? આ આર્યને યોગ્ય નથી અને અપકીર્તિ આપનાર છે.',
      meaningEnglish:
          'Krishna challenges Arjuna to rise above weakness and remember his higher responsibility.',
      meaningGujarati:
          'શ્રીકૃષ્ણ અર્જુનને નિર્બળતા છોડીને પોતાના ઉચ્ચ કર્તવ્યને યાદ કરવા પ્રેરણા આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'क्लैब्यं मा स्म गमः पार्थ नैतत्त्वय्युपपद्यते ।\nक्षुद्रं हृदयदौर्बल्यं त्यक्त्वोत्तिष्ठ परन्तप ॥३॥',
      english:
          'O Partha, do not yield to weakness. It does not befit you. Give up this petty weakness of heart and arise, O conqueror of enemies.',
      gujarati:
          'હે પાર્થ! નિર્બળતાને વશ ન થા. આ તને યોગ્ય નથી. હૃદયની ક્ષુદ્ર નિર્બળતા છોડીને ઊભો થા.',
      meaningEnglish:
          'Arjuna is encouraged to overcome emotional weakness and stand firmly in his duty.',
      meaningGujarati:
          'અર્જુનને ભાવનાત્મક નિર્બળતા છોડીને પોતાના કર્તવ્યમાં સ્થિર થવા પ્રેરણા મળે છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'अर्जुन उवाच ।\nकथं भीष्ममहं सङ्ख्ये द्रोणं च मधुसूदन ।\nइषुभिः प्रतियोत्स्यामि पूजार्हावरिसूदन ॥४॥',
      english:
          'Arjuna said: O Madhusudana, how can I fight Bhishma and Drona with arrows when they are worthy of my reverence?',
      gujarati:
          'અર્જુન બોલ્યા: હે મધુસૂદન! ભીષ્મ અને દ્રોણાચાર્ય જેવા પૂજનીય મહાનુભાવો સામે હું બાણોથી કેવી રીતે યુદ્ધ કરું?',
      meaningEnglish:
          'Arjuna is still unable to accept fighting his respected elders and teachers.',
      meaningGujarati:
          'અર્જુન પોતાના પૂજનીય વડીલો અને ગુરુઓ સામે યુદ્ધ કરવાની વાત સ્વીકારી શકતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'गुरूनहत्वा हि महानुभावान्\nश्रेयो भोक्तुं भैक्ष्यमपीह लोके ।\nहत्वार्थकामांस्तु गुरूनिहैव\nभुञ्जीय भोगान् रुधिरप्रदिग्धान् ॥५॥',
      english:
          'It would be better to live by begging in this world than to kill these great teachers. Whatever worldly pleasures I might enjoy after killing them would be stained with their blood.',
      gujarati:
          'આ મહાન ગુરુઓને મારી નાખવા કરતાં આ લોકમાં ભિક્ષા માગીને જીવવું પણ શ્રેયસ્કર છે. તેમને મારીને મળતા ભોગો પણ લોહીથી રંગાયેલા હશે.',
      meaningEnglish:
          'Arjuna feels that material gain is meaningless if it requires harming those he reveres.',
      meaningGujarati:
          'પૂજનીય ગુરુઓને નુકસાન પહોંચાડીને મળતું ભૌતિક સુખ અર્જુનને નિરર્થક લાગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'न चैतद्विद्मः कतरन्नो गरीयो\nयद्वा जयेम यदि वा नो जयेयुः ।\nयानेव हत्वा न जिजीविषामस्\nतेऽवस्थिताः प्रमुखे धार्तराष्ट्राः ॥६॥',
      english:
          'I do not know which is better for us—to conquer them or be conquered by them. Those very people whom we would not wish to live after killing are standing before us.',
      gujarati:
          'અમારા માટે શું શ્રેષ્ઠ છે—અમે તેમને જીતીએ કે તેઓ અમને જીતે—એ પણ હું જાણતો નથી. જેમને મારીને જીવવાની ઇચ્છા નથી, તે જ લોકો સામે ઊભા છે.',
      meaningEnglish:
          'Arjuna admits that his judgment is clouded and he cannot determine the right course.',
      meaningGujarati:
          'અર્જુન સ્વીકારે છે કે તેની બુદ્ધિ મૂંઝવણમાં છે અને તેને યોગ્ય માર્ગ સમજાતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'कार्पण्यदोषोपहतस्वभावः\nपृच्छामि त्वां धर्मसम्मूढचेताः ।\nयच्छ्रेय एतन्निश्चितं ब्रूहि तन्मे\nशिष्यस्तेऽहं शाधि मां त्वां प्रपन्नम् ॥७॥',
      english:
          'My nature is overcome by weakness and my mind is confused about my duty. I ask you to tell me decisively what is truly beneficial. I am your disciple; please guide me, for I have surrendered to you.',
      gujarati:
          'મારી સ્વભાવિક શક્તિ નષ્ટ થઈ ગઈ છે અને હું ધર્મ વિષે મૂંઝવણમાં છું. જે ખરેખર શ્રેયસ્કર છે તે નિશ્ચિત રીતે મને કહો. હું તમારો શિષ્ય છું; મને માર્ગદર્શન આપો.',
      meaningEnglish:
          'Arjuna surrenders as a disciple and asks Krishna for clear spiritual guidance.',
      meaningGujarati:
          'અર્જુન પોતાને શ્રીકૃષ્ણનો શિષ્ય માનીને સાચા કલ્યાણનો માર્ગ બતાવવા વિનંતી કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'न हि प्रपश्यामि ममापनुद्याद्\nयच्छोकमुच्छोषणमिन्द्रियाणाम् ।\nअवाप्य भूमावसपत्नमृद्धं\nराज्यं सुराणामपि चाधिपत्यम् ॥८॥',
      english:
          'I do not see what could remove this sorrow that is drying up my senses, even if I were to gain a prosperous kingdom on earth or even lordship over the gods.',
      gujarati:
          'મારી ઇન્દ્રિયોને સુકવી નાખતા આ શોકને દૂર કરનાર કોઈ માર્ગ મને દેખાતો નથી, ભલે મને પૃથ્વીનું સમૃદ્ધ રાજ્ય કે દેવતાઓનું પણ અધિપત્ય મળે.',
      meaningEnglish:
          'Arjuna realizes that material success cannot remove his inner sorrow.',
      meaningGujarati:
          'અર્જુન સમજે છે કે ભૌતિક સંપત્તિ કે સત્તા તેના આંતરિક શોકને દૂર કરી શકતી નથી.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'सञ्जय उवाच ।\nएवमुक्त्वा हृषीकेशं गुडाकेशः परन्तप ।\nन योत्स्य इति गोविन्दमुक्त्वा तूष्णीं बभूव ह ॥९॥',
      english:
          'Sanjaya said: Having spoken thus to Krishna, Arjuna said, “I will not fight,” and became silent.',
      gujarati:
          'સંજય બોલ્યા: આ રીતે શ્રીકૃષ્ણને કહીને અર્જુને કહ્યું કે “હું યુદ્ધ નહીં કરું” અને મૌન થઈ ગયો.',
      meaningEnglish:
          'Arjuna reaches a point where he refuses to fight and becomes silent.',
      meaningGujarati:
          'અર્જુન યુદ્ધ કરવાનો ઇનકાર કરીને મૌન થઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'तमुवाच हृषीकेशः प्रहसन्निव भारत ।\nसेनयोरुभयोर्मध्ये विषीदन्तमिदं वचः ॥१०॥',
      english:
          'O Bharata, Krishna, as though smiling, spoke these words to the sorrowful Arjuna standing between the two armies.',
      gujarati:
          'હે ભારત! બંને સેનાઓની વચ્ચે શોકગ્રસ્ત અર્જુનને શ્રીકૃષ્ણે જાણે સ્મિત કરતાં આ શબ્દો કહ્યા.',
      meaningEnglish:
          'Krishna begins the deeper spiritual teaching that will transform Arjuna’s understanding.',
      meaningGujarati:
          'શ્રીકૃષ્ણ હવે અર્જુનને ઊંડું આધ્યાત્મિક જ્ઞાન આપવાનું શરૂ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'श्रीभगवानुवाच ।\nअशोच्यानन्वशोचस्त्वं प्रज्ञावादांश्च भाषसे ।\nगतासूनगतासूंश्च नानुशोचन्ति पण्डिताः ॥११॥',
      english:
          'The Supreme Lord said: You grieve for those who should not be grieved for, yet you speak words of wisdom. The wise grieve neither for the living nor for the dead.',
      gujarati:
          'શ્રીભગવાન બોલ્યા: તું એવા લોકો માટે શોક કરે છે જેમના માટે શોક કરવો યોગ્ય નથી, છતાં જ્ઞાનની વાતો કરે છે. જ્ઞાની જીવિત કે મૃત કોઈ માટે શોક કરતા નથી.',
      meaningEnglish:
          'Krishna introduces the distinction between the temporary body and the eternal self.',
      meaningGujarati:
          'શ્રીકૃષ્ણ નાશવાન શરીર અને શાશ્વત આત્મા વચ્ચેનો ભેદ સમજાવવાનું શરૂ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'न त्वेवाहं जातु नासं न त्वं नेमे जनाधिपाः ।\nन चैव न भविष्यामः सर्वे वयमतः परम् ॥१२॥',
      english:
          'Never was there a time when I did not exist, nor you, nor these kings; nor will there be a time when any of us shall cease to be.',
      gujarati:
          'એવું ક્યારેય નહોતું કે હું નહોતો, તું નહોતો કે આ રાજાઓ નહોતા; અને ભવિષ્યમાં પણ આપણે સૌ અસ્તિત્વવિહોણા નહીં થઈએ.',
      meaningEnglish:
          'The self is presented as continuing beyond the changes of bodily existence.',
      meaningGujarati:
          'આત્માનું અસ્તિત્વ શરીરના પરિવર્તનથી પર છે તે સમજાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'देहिनोऽस्मिन्यथा देहे कौमारं यौवनं जरा ।\nतथा देहान्तरप्राप्तिर्धीरस्तत्र न मुह्यति ॥१३॥',
      english:
          'Just as the embodied self passes through childhood, youth and old age, it similarly passes into another body. The wise are not deluded by this.',
      gujarati:
          'જેમ શરીરમાં બાળપણ, યુવાની અને વૃદ્ધાવસ્થા આવે છે તેમ આત્મા બીજા શરીરને પ્રાપ્ત કરે છે. ધીર પુરુષ આથી મૂંઝાતો નથી.',
      meaningEnglish:
          'Physical change is compared with the transition from one body to another.',
      meaningGujarati:
          'શરીરના જીવનચક્રની જેમ આત્માના બીજા શરીરમાં પ્રવેશની સમજ આપવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'मात्रास्पर्शास्तु कौन्तेय शीतोष्णसुखदुःखदाः ।\nआगमापायिनोऽनित्यास्तांस्तितिक्षस्व भारत ॥१४॥',
      english:
          'O son of Kunti, contact of the senses with their objects produces cold and heat, pleasure and pain. They come and go and are temporary; endure them patiently.',
      gujarati:
          'હે કુંતીપુત્ર! ઇન્દ્રિયો અને વિષયોના સંપર્કથી ઠંડી-ગરમી, સુખ-દુઃખ થાય છે. તે આવનજાવનવાળા અને અનિત્ય છે; તેથી તેમને ધીરજથી સહન કર.',
      meaningEnglish:
          'Pleasure and pain are temporary experiences, so one should learn to endure them with balance.',
      meaningGujarati:
          'સુખ અને દુઃખ ક્ષણિક છે, તેથી સમત્વ અને ધૈર્યથી તેમને સહન કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'यं हि न व्यथयन्त्येते पुरुषं पुरुषर्षभ ।\nसमदुःखसुखं धीरं सोऽमृतत्वाय कल्पते ॥१५॥',
      english:
          'O best among men, the person whom pleasure and pain do not disturb, who remains steady in both, is fit for immortality.',
      gujarati:
          'હે પુરુષશ્રેષ્ઠ! જેને સુખ અને દુઃખ વ્યાકુળ કરતા નથી અને જે બંનેમાં સમ રહે છે તે અમૃતત્વ માટે યોગ્ય બને છે.',
      meaningEnglish:
          'Steadiness in pleasure and pain is a mark of spiritual maturity.',
      meaningGujarati:
          'સુખ-દુઃખમાં સમત્વ રાખવું આધ્યાત્મિક પરિપક્વતાનું લક્ષણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'नासतो विद्यते भावो नाभावो विद्यते सतः ।\nउभयोरपि दृष्टोऽन्तस्त्वनयोस्तत्त्वदर्शिभिः ॥१६॥',
      english:
          'The unreal has no lasting existence, and the real never ceases to exist. The seers of truth understand the distinction between the two.',
      gujarati:
          'અસતનું સ્થાયી અસ્તિત્વ નથી અને સતનું ક્યારેય અભાવ થતો નથી. તત્ત્વદર્શી ઋષિઓએ બંનેનો ભેદ જોયો છે.',
      meaningEnglish:
          'Krishna distinguishes the temporary from the eternal.',
      meaningGujarati:
          'શ્રીકૃષ્ણ અનિત્ય અને નિત્ય વચ્ચેનો મૂળભૂત ભેદ સમજાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'अविनाशि तु तद्विद्धि येन सर्वमिदं ततम् ।\nविनाशमव्ययस्यास्य न कश्चित्कर्तुमर्हति ॥१७॥',
      english:
          'Know that by which all this is pervaded to be indestructible. No one can destroy that imperishable reality.',
      gujarati:
          'જે તત્ત્વથી આ સમગ્ર જગત વ્યાપ્ત છે તેને અવિનાશી જાણ. આ અવિનાશી તત્ત્વનો નાશ કોઈ કરી શકતું નથી.',
      meaningEnglish:
          'The eternal spiritual reality cannot be destroyed.',
      meaningGujarati:
          'શાશ્વત આધ્યાત્મિક તત્ત્વનો કોઈ પણ રીતે નાશ થઈ શકતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'अन्तवन्त इमे देहा नित्यस्योक्ताः शरीरिणः ।\nअनाशिनोऽप्रमेयस्य तस्माद्युध्यस्व भारत ॥१८॥',
      english:
          'The bodies of the eternal embodied self are said to be perishable, while the self itself is eternal and immeasurable. Therefore, fight, O Bharata.',
      gujarati:
          'આ શરીરો નાશવાન છે, પરંતુ શરીરમાં રહેલો આત્મા નિત્ય અને અપ્રમેય છે. તેથી હે ભારત, તું યુદ્ધ કર.',
      meaningEnglish:
          'The body is temporary but the self is eternal; therefore Arjuna should perform his duty without attachment.',
      meaningGujarati:
          'શરીર નાશવાન છે પરંતુ આત્મા નિત્ય છે; તેથી અર્જુને આસક્તિ વિના પોતાનું કર્તવ્ય કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'य एनं वेत्ति हन्तारं यश्चैनं मन्यते हतम् ।\nउभौ तौ न विजानीतो नायं हन्ति न हन्यते ॥१९॥',
      english:
          'One who thinks the self kills, and one who thinks it is killed, neither understands the truth. The self neither kills nor is killed.',
      gujarati:
          'જે આત્માને મારનાર માને છે અથવા મરનાર માને છે, બંને તત્ત્વને જાણતા નથી. આત્મા ન તો મારે છે ન મરે છે.',
      meaningEnglish:
          'The eternal self is beyond physical acts of killing and being killed.',
      meaningGujarati:
          'શાશ્વત આત્મા શરીરના જન્મ-મરણ અને હિંસાના ભૌતિક વ્યવહારથી પર છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'न जायते म्रियते वा कदाचिन्नायं भूत्वा भविता वा न भूयः ।\nअजो नित्यः शाश्वतोऽयं पुराणो न हन्यते हन्यमाने शरीरे ॥२०॥',
      english:
          'The self is never born and never dies. It is unborn, eternal, everlasting and ancient; it is not destroyed when the body is destroyed.',
      gujarati:
          'આત્માનો ક્યારેય જન્મ થતો નથી અને મૃત્યુ પણ નથી. તે અજન્મા, નિત્ય, શાશ્વત અને પુરાતન છે; શરીર નષ્ટ થાય ત્યારે પણ તે નષ્ટ થતો નથી.',
      meaningEnglish:
          'The soul is eternal and does not perish with the body.',
      meaningGujarati:
          'આત્મા શાશ્વત છે અને શરીરના નાશ સાથે તેનો નાશ થતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'वेदाविनाशिनं नित्यं य एनमजमव्ययम् ।\nकथं स पुरुषः पार्थ कं घातयति हन्ति कम् ॥२१॥',
      english:
          'O Partha, how can one who knows the self to be indestructible, eternal, unborn and immutable cause anyone to be killed or kill anyone?',
      gujarati:
          'હે પાર્થ! જે આત્માને અવિનાશી, નિત્ય, અજન્મા અને અપરિવર્તનશીલ જાણે છે તે કોઈને કેવી રીતે મારી શકે અથવા કોઈને મારનાર કેવી રીતે માની શકે?',
      meaningEnglish:
          'Knowledge of the eternal self changes one’s understanding of life and death.',
      meaningGujarati:
          'આત્માના શાશ્વત સ્વરૂપનું જ્ઞાન જીવન અને મૃત્યુની સમજને બદલી નાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'वासांसि जीर्णानि यथा विहाय\nनवानि गृह्णाति नरोऽपराणि ।\nतथा शरीराणि विहाय जीर्णा\nन्यन्यानि संयाति नवानि देही ॥२२॥',
      english:
          'Just as a person discards worn-out clothes and puts on new ones, the embodied self discards old bodies and enters new ones.',
      gujarati:
          'જેમ મનુષ્ય જૂના વસ્ત્રો છોડીને નવા વસ્ત્રો ધારણ કરે છે, તેમ આત્મા જૂના શરીરને છોડીને નવું શરીર ધારણ કરે છે.',
      meaningEnglish:
          'Krishna uses the example of changing clothes to explain the changing of bodies.',
      meaningGujarati:
          'જૂના કપડાં બદલીને નવા પહેરવાના ઉદાહરણથી શરીર બદલવાની વાત સમજાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'नैनं छिन्दन्ति शस्त्राणि नैनं दहति पावकः ।\nन चैनं क्लेदयन्त्यापो न शोषयति मारुतः ॥२३॥',
      english:
          'Weapons cannot cut the self, fire cannot burn it, water cannot wet it, and wind cannot dry it.',
      gujarati:
          'શસ્ત્રો આત્માને કાપી શકતા નથી, અગ્નિ તેને બાળી શકતી નથી, પાણી તેને ભીનું કરી શકતું નથી અને વાયુ તેને સૂકવી શકતો નથી.',
      meaningEnglish:
          'The self is beyond the destructive forces of the physical world.',
      meaningGujarati:
          'આત્મા ભૌતિક જગતના વિનાશક તત્ત્વોથી પર છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'अच्छेद्योऽयमदाह्योऽयमक्लेद्योऽशोष्य एव च ।\nनित्यः सर्वगतः स्थाणुरचलोऽयं सनातनः ॥२४॥',
      english:
          'The self cannot be cut, burned, wetted or dried. It is eternal, all-pervading, stable, immovable and everlasting.',
      gujarati:
          'આત્મા અછેદ્ય, અદાહ્ય, અક્લેદ્ય અને અશોષ્ય છે. તે નિત્ય, સર્વવ્યાપક, સ્થિર, અચળ અને સનાતન છે.',
      meaningEnglish:
          'The nature of the self is described as eternal and unchanging.',
      meaningGujarati:
          'આત્માનું સ્વરૂપ નિત્ય અને અપરિવર્તનશીલ તરીકે સમજાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'अव्यक्तोऽयमचिन्त्योऽयमविकार्योऽयमुच्यते ।\nतस्मादेवं विदित्वैनं नानुशोचितुमर्हसि ॥२५॥',
      english:
          'The self is said to be unmanifest, inconceivable and unchanging. Knowing this, you should not grieve.',
      gujarati:
          'આત્મા અવ્યક્ત, અચિંત્ય અને અપરિવર્તનશીલ કહેવાય છે. આ રીતે તેને જાણીને તારે શોક કરવો યોગ્ય નથી.',
      meaningEnglish:
          'Understanding the nature of the self helps overcome grief.',
      meaningGujarati:
          'આત્માના સ્વરૂપનું જ્ઞાન શોકને દૂર કરવામાં મદદ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'अथ चैनं नित्यजातं नित्यं वा मन्यसे मृतम् ।\nतथापि त्वं महाबाहो नैवं शोचितुमर्हसि ॥२६॥',
      english:
          'Even if you think the self is constantly born and constantly dies, O mighty-armed one, you still should not grieve.',
      gujarati:
          'હે મહાબાહુ! જો તું આત્માને વારંવાર જન્મનાર અને મૃત્યુ પામનાર માને તો પણ તારે શોક કરવો યોગ્ય નથી.',
      meaningEnglish:
          'Krishna addresses Arjuna even from the viewpoint of ordinary beliefs about birth and death.',
      meaningGujarati:
          'શ્રીકૃષ્ણ જન્મ અને મૃત્યુની સામાન્ય સમજને આધારે પણ અર્જુનને શોક ન કરવા કહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'जातस्य हि ध्रुवो मृत्युर्ध्रुवं जन्म मृतस्य च ।\nतस्मादपरिहार्येऽर्थे न त्वं शोचितुमर्हसि ॥२७॥',
      english:
          'For one who is born, death is certain; and for one who dies, birth is certain. Therefore, you should not grieve over what is unavoidable.',
      gujarati:
          'જન્મેલા માટે મૃત્યુ નિશ્ચિત છે અને મૃત્યુ પામેલા માટે જન્મ નિશ્ચિત છે. તેથી જે અનિવાર્ય છે તેના માટે શોક કરવો યોગ્ય નથી.',
      meaningEnglish:
          'The cycle of birth and death is presented as unavoidable in embodied existence.',
      meaningGujarati:
          'દેહધારી જીવનમાં જન્મ અને મૃત્યુના ચક્રને અનિવાર્ય સમજાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'अव्यक्तादीनि भूतानि व्यक्तमध्यानि भारत ।\nअव्यक्तनिधनान्येव तत्र का परिदेवना ॥२८॥',
      english:
          'Beings are unmanifest before birth, manifest in the middle, and unmanifest again after death. What reason is there for lamentation?',
      gujarati:
          'હે ભારત! જીવ જન્મ પહેલાં અવ્યક્ત હોય છે, જીવનમાં વ્યક્ત થાય છે અને મૃત્યુ પછી ફરી અવ્યક્ત બને છે. તો પછી શોક શા માટે?',
      meaningEnglish:
          'Krishna explains the temporary visible phase of embodied existence.',
      meaningGujarati:
          'દેહધારી જીવનનું વ્યક્ત સ્વરૂપ સમયબદ્ધ છે તે સમજાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'आश्चर्यवत्पश्यति कश्चिदेनमाश्चर्यवद्वदति तथैव चान्यः ।\nआश्चर्यवच्चैनमन्यः शृणोति श्रुत्वाप्येनं वेद न चैव कश्चित् ॥२९॥',
      english:
          'Some behold the self as wonderful, some speak of it as wonderful, and others hear of it as wonderful; yet even after hearing, few truly understand it.',
      gujarati:
          'કોઈ આત્માને આશ્ચર્યરૂપે જુએ છે, કોઈ તેના વિષે આશ્ચર્યરૂપે કહે છે અને કોઈ આશ્ચર્યરૂપે સાંભળે છે; છતાં સાંભળ્યા પછી પણ બહુ ઓછા લોકો તેને સાચે જાણે છે.',
      meaningEnglish:
          'The true nature of the self is profound and difficult to fully comprehend.',
      meaningGujarati:
          'આત્માનું તત્ત્વ અત્યંત ગહન છે અને તેને સંપૂર્ણ રીતે સમજવું સરળ નથી.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'देही नित्यमवध्योऽयं देहे सर्वस्य भारत ।\nतस्मात्सर्वाणि भूतानि न त्वं शोचितुमर्हसि ॥३०॥',
      english:
          'The embodied self dwelling in every body is eternal and cannot be destroyed. Therefore, you should not grieve for any being.',
      gujarati:
          'હે ભારત! દરેક શરીરમાં રહેલો આત્મા નિત્ય અને અવિનાશી છે. તેથી કોઈ જીવ માટે તારે શોક કરવો યોગ્ય નથી.',
      meaningEnglish:
          'Krishna concludes this section by emphasizing the indestructibility of the self.',
      meaningGujarati:
          'શ્રીકૃષ્ણ આત્માની અવિનાશિતાને સમજાવીને અર્જુનને શોક છોડવા કહે છે.',
    ),

    // -------------------------------------------------
    // VERSES 31 - 72
    // -------------------------------------------------

    SacredVerseModel(
      verseNumber: 31,
      sanskrit:
          'स्वधर्ममपि चावेक्ष्य न विकम्पितुमर्हसि ।\nधर्म्याद्धि युद्धाच्छ्रेयोऽन्यत्क्षत्रियस्य न विद्यते ॥३१॥',
      english:
          'Considering your own duty, you should not waver. For a warrior, there is nothing more honorable than a righteous battle.',
      gujarati:
          'પોતાના સ્વધર્મને ધ્યાનમાં રાખીને તારે ડગમગવું ન જોઈએ. ક્ષત્રિય માટે ધર્મયુક્ત યુદ્ધ કરતાં શ્રેષ્ઠ કર્તવ્ય બીજું નથી.',
      meaningEnglish:
          'Arjuna is reminded of his responsibility according to his role.',
      meaningGujarati:
          'અર્જુનને પોતાના કર્તવ્ય અને જવાબદારીનું સ્મરણ કરાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit:
          'यदृच्छया चोपपन्नं स्वर्गद्वारमपावृतम् ।\nसुखिनः क्षत्रियाः पार्थ लभन्ते युद्धमीदृशम् ॥३२॥',
      english:
          'O Partha, fortunate are the warriors who receive such an opportunity for a righteous battle, which opens the gates of heaven.',
      gujarati:
          'હે પાર્થ! આવા ધર્મયુક્ત યુદ્ધનો અવસર પ્રાપ્ત કરનારા ક્ષત્રિયો ભાગ્યશાળી છે, કારણ કે તે સ્વર્ગના દ્વાર સમાન છે.',
      meaningEnglish:
          'A righteous opportunity to fulfill duty is considered a rare blessing.',
      meaningGujarati:
          'ધર્મપૂર્વક કર્તવ્ય નિભાવવાનો અવસર દુર્લભ અને પવિત્ર માનવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit:
          'अथ चेत्त्वमिमं धर्म्यं सङ्ग्रामं न करिष्यसि ।\nततः स्वधर्मं कीर्तिं च हित्वा पापमवाप्स्यसि ॥३३॥',
      english:
          'If you do not perform this righteous battle, you will abandon your duty and reputation and incur wrongdoing.',
      gujarati:
          'જો તું આ ધર્મયુક્ત યુદ્ધ નહીં કરે તો પોતાનું સ્વધર્મ અને કીર્તિ છોડીને પાપને પ્રાપ્ત થશે.',
      meaningEnglish:
          'Refusing one’s rightful duty can itself become a moral failure.',
      meaningGujarati:
          'યોગ્ય કર્તવ્યથી ભાગવું પણ અધર્મનું કારણ બની શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit:
          'अकीर्तिं चापि भूतानि कथयिष्यन्ति तेऽव्ययाम् ।\nसम्भावितस्य चाकीर्तिर्मरणादतिरिच्यते ॥३४॥',
      english:
          'People will speak of your lasting dishonor, and for a respected person dishonor is worse than death.',
      gujarati:
          'લોકો તારી કાયમી અપકીર્તિની વાત કરશે. માનનીય વ્યક્તિ માટે અપકીર્તિ મૃત્યુ કરતાં પણ વધારે દુઃખદ છે.',
      meaningEnglish:
          'Krishna explains the consequences of abandoning honorable responsibility.',
      meaningGujarati:
          'કર્તવ્ય છોડવાથી થતી અપકીર્તિના પરિણામો સમજાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 35,
      sanskrit:
          'भयाद्रणादुपरतं मंस्यन्ते त्वां महारथाः ।\nयेषां च त्वं बहुमतो भूत्वा यास्यसि लाघवम् ॥३५॥',
      english:
          'The great warriors will think you withdrew from battle out of fear, and those who once respected you will hold you in low regard.',
      gujarati:
          'મહારથી યોદ્ધાઓ માનશે કે તું ભયના કારણે યુદ્ધમાંથી પાછો હટી ગયો અને જે લોકો તને માન આપતા હતા તેઓ તને હલકો ગણશે.',
      meaningEnglish:
          'Arjuna’s withdrawal could be interpreted as fear rather than compassion.',
      meaningGujarati:
          'અર્જુનનો પીછેહઠનો નિર્ણય ભય તરીકે સમજાઈ શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 36,
      sanskrit:
          'अवाच्यवादांश्च बहून्वदिष्यन्ति तवाहिताः ।\nनिन्दन्तस्तव सामर्थ्यं ततो दुःखतरं नु किम् ॥३६॥',
      english:
          'Your enemies will speak many insulting words and ridicule your ability. What could be more painful than that?',
      gujarati:
          'તારા શત્રુઓ તારી શક્તિની નિંદા કરીને અનેક અપમાનજનક શબ્દો કહેશે. તેનાથી વધુ દુઃખદ શું હોઈ શકે?',
      meaningEnglish:
          'Krishna points out the social consequences Arjuna may face by abandoning his duty.',
      meaningGujarati:
          'કર્તવ્ય છોડવાથી થતી સામાજિક નિંદાના પરિણામો તરફ શ્રીકૃષ્ણ ધ્યાન દોરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 37,
      sanskrit:
          'हतो वा प्राप्स्यसि स्वर्गं जित्वा वा भोक्ष्यसे महीम् ।\nतस्मादुत्तिष्ठ कौन्तेय युद्धाय कृतनिश्चयः ॥३७॥',
      english:
          'If you are killed, you will attain heaven; if you win, you will enjoy the earth. Therefore arise with determination to fight.',
      gujarati:
          'જો તું યુદ્ધમાં મૃત્યુ પામશે તો સ્વર્ગ પ્રાપ્ત કરશે અને જો જીતશે તો પૃથ્વીનો ભોગ કરશે. તેથી નિશ્ચય કરીને ઊભો થા અને યુદ્ધ કર.',
      meaningEnglish:
          'Arjuna is urged to act with determination without being paralyzed by outcomes.',
      meaningGujarati:
          'અર્જુનને પરિણામની ચિંતા છોડીને નિશ્ચયપૂર્વક કર્તવ્ય કરવા કહેવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 38,
      sanskrit:
          'सुखदुःखे समे कृत्वा लाभालाभौ जयाजयौ ।\nततो युद्धाय युज्यस्व नैवं पापमवाप्स्यसि ॥३८॥',
      english:
          'Treat pleasure and pain, gain and loss, victory and defeat alike, and engage in your duty. In this way you will not incur wrongdoing.',
      gujarati:
          'સુખ-દુઃખ, લાભ-હાનિ અને જય-પરાજયને સમાન માનીને કર્તવ્ય કર. આ રીતે તું પાપથી બચીશ.',
      meaningEnglish:
          'Equanimity is essential when performing duty.',
      meaningGujarati:
          'કર્તવ્ય કરતી વખતે સુખ-દુઃખ અને જીત-હારથી સમભાવ રાખવો જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 39,
      sanskrit:
          'एषा तेऽभिहिता सांख्ये बुद्धिर्योगे त्विमां शृणु ।\nबुद्ध्या युक्तो यया पार्थ कर्मबन्धं प्रहास्यसि ॥३९॥',
      english:
          'This wisdom has been explained to you from the standpoint of knowledge. Now hear it from the standpoint of disciplined action, by which you can free yourself from bondage to action.',
      gujarati:
          'આ જ્ઞાનનો માર્ગ તને સમજાવ્યો. હવે કર્મયોગ સાંભળ, જેના દ્વારા બુદ્ધિયુક્ત થઈને તું કર્મના બંધનથી મુક્ત થઈ શકીશ.',
      meaningEnglish:
          'Krishna transitions from knowledge of the self to the practice of Karma Yoga.',
      meaningGujarati:
          'શ્રીકૃષ્ણ આત્મજ્ઞાનથી કર્મયોગ તરફ ઉપદેશને આગળ વધારે છે.',
    ),

    SacredVerseModel(
      verseNumber: 40,
      sanskrit:
          'नेहाभिक्रमनाशोऽस्ति प्रत्यवायो न विद्यते ।\nस्वल्पमप्यस्य धर्मस्य त्रायते महतो भयात् ॥४०॥',
      english:
          'In this path there is no loss of effort and no adverse result. Even a little practice of this discipline protects one from great fear.',
      gujarati:
          'આ માર્ગમાં કરેલો પ્રયત્ન ક્યારેય વ્યર્થ જતો નથી અને તેનો વિપરીત પરિણામ નથી. આ ધર્મનું થોડું પણ આચરણ મોટા ભયથી રક્ષણ આપે છે.',
      meaningEnglish:
          'Even small sincere efforts in spiritual discipline have lasting value.',
      meaningGujarati:
          'આધ્યાત્મિક સાધનામાં કરેલો નાનો પણ નિષ્ઠાપૂર્વકનો પ્રયત્ન મહત્વપૂર્ણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 41,
      sanskrit:
          'व्यवसायात्मिका बुद्धिरेकेह कुरुनन्दन ।\nबहुशाखा ह्यनन्ताश्च बुद्धयोऽव्यवसायिनाम् ॥४१॥',
      english:
          'Those who are firmly resolved have one-pointed understanding, while the minds of the irresolute are scattered in many directions.',
      gujarati:
          'હે કુરુનંદન! નિશ્ચયવાળા સાધકની બુદ્ધિ એકાગ્ર હોય છે, જ્યારે અનિશ્ચિત મનવાળાની બુદ્ધિ અનેક દિશામાં વિખેરાયેલી હોય છે.',
      meaningEnglish:
          'Spiritual progress requires focused and steady intelligence.',
      meaningGujarati:
          'આધ્યાત્મિક પ્રગતિ માટે નિશ્ચય અને એકાગ્ર બુદ્ધિ જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 42,
      sanskrit:
          'यामिमां पुष्पितां वाचं प्रवदन्त्यविपश्चितः ।\nवेदवादरताः पार्थ नान्यदस्तीति वादिनः ॥४२॥',
      english:
          'Those lacking deeper understanding speak flowery words and become attached to ritualistic promises, saying there is nothing beyond them.',
      gujarati:
          'હે પાર્થ! ઓછા જ્ઞાનવાળા લોકો આકર્ષક શબ્દોમાં માત્ર કર્મકાંડના ફળોની વાત કરે છે અને કહે છે કે આથી પર કંઈ નથી.',
      meaningEnglish:
          'Krishna warns against becoming attached only to external promises and ritual results.',
      meaningGujarati:
          'માત્ર બાહ્ય કર્મકાંડ અને તેના ફળોમાં આસક્ત થવાથી બચવાની શીખ આપવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 43,
      sanskrit:
          'कामात्मानः स्वर्गपरा जन्मकर्मफलप्रदाम् ।\nक्रियाविशेषबहुलां भोगैश्वर्यगतिं प्रति ॥४३॥',
      english:
          'Desiring pleasure and heavenly rewards, such people become attached to elaborate actions promising enjoyment and power.',
      gujarati:
          'ભોગ અને સ્વર્ગની ઇચ્છાવાળા લોકો એવા કર્મોમાં આસક્ત થાય છે જે ભોગ અને ઐશ્વર્યના ફળનું વચન આપે છે.',
      meaningEnglish:
          'Attachment to rewards can distract a person from deeper spiritual realization.',
      meaningGujarati:
          'ફળની આસક્તિ મનુષ્યને ઊંડા આધ્યાત્મિક જ્ઞાનથી દૂર લઈ જઈ શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 44,
      sanskrit:
          'भोगैश्वर्यप्रसक्तानां तयापहृतचेतसाम् ।\nव्यवसायात्मिका बुद्धिः समाधौ न विधीयते ॥४४॥',
      english:
          'For those whose minds are attached to pleasure and power, steady understanding for spiritual concentration does not arise.',
      gujarati:
          'ભોગ અને ઐશ્વર્યમાં આસક્ત લોકોની બુદ્ધિ સ્થિર થતી નથી અને આધ્યાત્મિક સમાધિમાં સ્થિરતા આવતી નથી.',
      meaningEnglish:
          'Excessive attachment to pleasure and power weakens inner concentration.',
      meaningGujarati:
          'ભોગ અને સત્તાની વધારે આસક્તિ આંતરિક એકાગ્રતાને નબળી બનાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 45,
      sanskrit:
          'त्रैगुण्यविषया वेदा निस्त्रैगुण्यो भवार्जुन ।\nनिर्द्वन्द्वो नित्यसत्त्वस्थो निर्योगक्षेम आत्मवान् ॥४५॥',
      english:
          'The Vedas deal with the three modes of nature. Rise beyond the three modes, be free from dualities, established in purity, and self-controlled.',
      gujarati:
          'વેદો ત્રણ ગુણોના ક્ષેત્રને સમજાવે છે. હે અર્જુન! તું ત્રણ ગુણોથી પર થા, દ્વંદ્વોથી મુક્ત થા, શુદ્ધતામાં સ્થિર અને આત્મસંયમી બન.',
      meaningEnglish:
          'Krishna encourages Arjuna to rise beyond material dualities and the three gunas.',
      meaningGujarati:
          'શ્રીકૃષ્ણ અર્જુનને ત્રણ ગુણો અને દ્વંદ્વોથી ઉપર ઉઠવા કહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 46,
      sanskrit:
          'यावानर्थ उदपाने सर्वतः सम्प्लुतोदके ।\nतावान्सर्वेषु वेदेषु ब्राह्मणस्य विजानतः ॥४६॥',
      english:
          'As all the purposes served by a small well are served by a great reservoir, so all the purposes of the Vedas are fulfilled for one who truly knows the Supreme.',
      gujarati:
          'જેમ વિશાળ જળાશયથી નાનાં કૂવાના બધા ઉપયોગો પૂર્ણ થાય છે, તેમ તત્ત્વજ્ઞાની માટે વેદોના તમામ ફળો પૂર્ણ થાય છે.',
      meaningEnglish:
          'Higher realization encompasses the limited purposes of external knowledge.',
      meaningGujarati:
          'ઉચ્ચ તત્ત્વજ્ઞાન બાહ્ય જ્ઞાનના મર્યાદિત હેતુઓને પણ સમાવી લે છે.',
    ),

    SacredVerseModel(
      verseNumber: 47,
      sanskrit:
          'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥४७॥',
      english:
          'You have a right to action alone, never to its fruits. Do not let the fruits of action be your motive, and do not become attached to inaction.',
      gujarati:
          'તારો અધિકાર માત્ર કર્મ કરવામાં છે, તેના ફળમાં ક્યારેય નથી. કર્મફળને હેતુ ન બનાવ અને અકર્મણ્યતામાં પણ આસક્ત ન થા.',
      meaningEnglish:
          'This verse teaches selfless action: perform your duty without attachment to the result.',
      meaningGujarati:
          'આ શ્લોક નિષ્કામ કર્મનો મૂળ ઉપદેશ આપે છે—ફળની આસક્તિ વિના કર્તવ્ય કરવું.',
    ),

    SacredVerseModel(
      verseNumber: 48,
      sanskrit:
          'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय ।\nसिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते ॥४८॥',
      english:
          'Perform your duties established in yoga, abandoning attachment, and remaining even-minded in success and failure. Such equanimity is called yoga.',
      gujarati:
          'હે ધનંજય! આસક્તિ છોડીને યોગમાં સ્થિર રહી કર્મ કર. સફળતા અને નિષ્ફળતામાં સમભાવ રાખવો એ જ યોગ કહેવાય છે.',
      meaningEnglish:
          'Yoga is defined here as inner balance while performing action.',
      meaningGujarati:
          'કર્મ કરતી વખતે સફળતા અને નિષ્ફળતામાં સમભાવ રાખવો એ યોગ છે.',
    ),

    SacredVerseModel(
      verseNumber: 49,
      sanskrit:
          'दूरेण ह्यवरं कर्म बुद्धियोगाद्धनञ्जय ।\nबुद्धौ शरणमन्विच्छ कृपणाः फलहेतवः ॥४९॥',
      english:
          'Action performed with desire for results is far inferior to action guided by wisdom. Seek refuge in wisdom; those motivated only by results are spiritually limited.',
      gujarati:
          'હે ધનંજય! ફળની ઇચ્છાથી કરેલું કર્મ બુદ્ધિયોગ કરતાં ઘણું નીચું છે. બુદ્ધિમાં શરણ લે; ફળને હેતુ બનાવનાર કૃપણ છે.',
      meaningEnglish:
          'Wisdom transforms ordinary action into a path of spiritual freedom.',
      meaningGujarati:
          'બુદ્ધિયુક્ત કર્મ સામાન્ય કર્મને આધ્યાત્મિક મુક્તિના માર્ગમાં ફેરવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 50,
      sanskrit:
          'बुद्धियुक्तो जहातीह उभे सुकृतदुष्कृते ।\nतस्माद्योगाय युज्यस्व योगः कर्मसु कौशलम् ॥५०॥',
      english:
          'One united with wisdom casts off both good and bad karmic results. Therefore practice yoga; yoga is skillfulness in action.',
      gujarati:
          'બુદ્ધિયુક્ત મનુષ્ય આ લોકમાં સારા અને ખરાબ બંને કર્મફળના બંધનને છોડે છે. તેથી યોગમાં જોડા; કર્મમાં કુશળતા જ યોગ છે.',
      meaningEnglish:
          'True skill in action means acting wisely without becoming bound by results.',
      meaningGujarati:
          'કર્મમાં સાચી કુશળતા એટલે જ્ઞાનપૂર્વક અને આસક્તિ વિના કર્મ કરવું.',
    ),

    SacredVerseModel(
      verseNumber: 51,
      sanskrit:
          'कर्मजं बुद्धियुक्ता हि फलं त्यक्त्वा मनीषिणः ।\nजन्मबन्धविनिर्मुक्ताः पदं गच्छन्त्यनामयम् ॥५१॥',
      english:
          'The wise, abandoning the fruits born of action through disciplined understanding, become free from the bondage of birth and attain a state beyond suffering.',
      gujarati:
          'બુદ્ધિયુક્ત જ્ઞાની લોકો કર્મફળનો ત્યાગ કરીને જન્મના બંધનથી મુક્ત થાય છે અને દુઃખરહિત પરમ પદ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Selfless action leads toward freedom from the cycle of bondage.',
      meaningGujarati:
          'નિષ્કામ કર્મ જન્મ અને બંધનના ચક્રમાંથી મુક્તિના માર્ગે લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 52,
      sanskrit:
          'यदा ते मोहकलिलं बुद्धिर्व्यतितरिष्यति ।\nतदा गन्तासि निर्वेदं श्रोतव्यस्य श्रुतस्य च ॥५२॥',
      english:
          'When your intellect crosses beyond the confusion of delusion, you will become indifferent to what has been heard and what remains to be heard.',
      gujarati:
          'જ્યારે તારી બુદ્ધિ મોહના કાદવને પાર કરી જશે ત્યારે સાંભળેલી અને સાંભળવાની બાબતો પ્રત્યે તને વૈરાગ્ય પ્રાપ્ત થશે.',
      meaningEnglish:
          'Clear wisdom frees the mind from confusion and endless dependence on external opinions.',
      meaningGujarati:
          'સાચું જ્ઞાન મનને મોહ અને અવિરત બાહ્ય આધારથી મુક્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 53,
      sanskrit:
          'श्रुतिविप्रतिपन्ना ते यदा स्थास्यति निश्चला ।\nसमाधावचला बुद्धिस्तदा योगमवाप्स्यसि ॥५३॥',
      english:
          'When your intellect, no longer disturbed by conflicting teachings, becomes steady in contemplation, then you will attain yoga.',
      gujarati:
          'જ્યારે વિવિધ વિચારોની ગૂંચવણથી મુક્ત થઈ તારી બુદ્ધિ સમાધિમાં અચળ અને સ્થિર થશે ત્યારે તું યોગ પ્રાપ્ત કરીશ.',
      meaningEnglish:
          'Steady contemplation is the foundation of spiritual realization.',
      meaningGujarati:
          'સ્થિર અને એકાગ્ર બુદ્ધિ આધ્યાત્મિક અનુભૂતિનો આધાર છે.',
    ),

    SacredVerseModel(
      verseNumber: 54,
      sanskrit:
          'अर्जुन उवाच ।\nस्थितप्रज्ञस्य का भाषा समाधिस्थस्य केशव ।\nस्थितधीः किं प्रभाषेत किमासीत व्रजेत किम् ॥५४॥',
      english:
          'Arjuna said: O Keshava, what are the characteristics of one whose wisdom is steady and who is established in meditation? How does such a person speak, sit and move?',
      gujarati:
          'અર્જુન બોલ્યા: હે કેશવ! સ્થિતપ્રજ્ઞ મનુષ્યનાં લક્ષણો શું છે? તે કેવી રીતે બોલે છે, બેસે છે અને વર્તે છે?',
      meaningEnglish:
          'Arjuna asks how spiritual wisdom appears in everyday life.',
      meaningGujarati:
          'અર્જુન પૂછે છે કે સ્થિર જ્ઞાનવાળા મનુષ્યનું વ્યવહારિક જીવન કેવું હોય છે.',
    ),

    SacredVerseModel(
      verseNumber: 55,
      sanskrit:
          'श्रीभगवानुवाच ।\nप्रजहाति यदा कामान् सर्वान्पार्थ मनोगतान् ।\nआत्मन्येवात्मना तुष्टः स्थितप्रज्ञस्तदोच्यते ॥५५॥',
      english:
          'The Supreme Lord said: When a person gives up all desires arising in the mind and is satisfied in the self through the self, that person is called steady in wisdom.',
      gujarati:
          'શ્રીભગવાન બોલ્યા: જ્યારે મનમાં ઉદ્ભવતી તમામ ઇચ્છાઓ છોડીને મનુષ્ય આત્મામાં જ આત્માથી સંતોષ પામે છે ત્યારે તેને સ્થિતપ્રજ્ઞ કહેવાય છે.',
      meaningEnglish:
          'A steady person finds fulfillment within rather than depending on external desires.',
      meaningGujarati:
          'સ્થિતપ્રજ્ઞ મનુષ્ય બાહ્ય ઇચ્છાઓ પર આધાર રાખ્યા વિના આત્મામાં સંતોષ મેળવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 56,
      sanskrit:
          'दुःखेष्वनुद्विग्नमनाः सुखेषु विगतस्पृहः ।\nवीतरागभयक्रोधः स्थितधीर्मुनिरुच्यते ॥५६॥',
      english:
          'One whose mind is not disturbed by sorrow, who has no craving for pleasure, and who is free from attachment, fear and anger is called a sage of steady wisdom.',
      gujarati:
          'જેનું મન દુઃખમાં વ્યાકુળ થતું નથી, સુખમાં આસક્ત થતું નથી અને રાગ, ભય તથા ક્રોધથી મુક્ત છે તેને સ્થિર બુદ્ધિવાળો મુનિ કહેવાય છે.',
      meaningEnglish:
          'Emotional steadiness is a defining quality of spiritual wisdom.',
      meaningGujarati:
          'ભાવનાત્મક સમત્વ આધ્યાત્મિક જ્ઞાનનું મહત્વપૂર્ણ લક્ષણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 57,
      sanskrit:
          'यः सर्वत्रानभिस्नेहस्तत्तत्प्राप्य शुभाशुभम् ।\nनाभिनन्दति न द्वेष्टि तस्य प्रज्ञा प्रतिष्ठिता ॥५७॥',
      english:
          'One who is unattached everywhere, who neither rejoices nor hates upon receiving good or bad, has steady wisdom.',
      gujarati:
          'જે સર્વત્ર આસક્તિ વિના રહે છે અને શુભ કે અશુભ પ્રાપ્ત થતાં અતિ આનંદ કે દ્વેષ કરતો નથી તેની બુદ્ધિ સ્થિર છે.',
      meaningEnglish:
          'Steady wisdom remains balanced amid favorable and unfavorable events.',
      meaningGujarati:
          'સ્થિર બુદ્ધિવાળો મનુષ્ય અનુકૂળ અને પ્રતિકૂળ પરિસ્થિતિમાં સમભાવ રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 58,
      sanskrit:
          'यदा संहरते चायं कूर्मोऽङ्गानीव सर्वशः ।\nइन्द्रियाणीन्द्रियार्थेभ्यस्तस्य प्रज्ञा प्रतिष्ठिता ॥५८॥',
      english:
          'When a person withdraws the senses from their objects as a tortoise withdraws its limbs, wisdom becomes firmly established.',
      gujarati:
          'જ્યારે મનુષ્ય કાચબો પોતાના અંગોને અંદર ખેંચે તેમ ઇન્દ્રિયોને તેમના વિષયોથી પાછી ખેંચે છે ત્યારે તેની બુદ્ધિ સ્થિર બને છે.',
      meaningEnglish:
          'Self-control over the senses supports stable wisdom.',
      meaningGujarati:
          'ઇન્દ્રિયસંયમ સ્થિર જ્ઞાન માટે જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 59,
      sanskrit:
          'विषया विनिवर्तन्ते निराहारस्य देहिनः ।\nरसवर्जं रसोऽप्यस्य परं दृष्ट्वा निवर्तते ॥५९॥',
      english:
          'Objects may withdraw from one who abstains, but the taste for them remains. That taste also disappears upon experiencing the Supreme.',
      gujarati:
          'વિષયોથી દૂર રહેવાથી વિષયો દૂર થાય છે પરંતુ તેમની આસક્તિ રહી શકે છે. પરમ તત્ત્વનો અનુભવ થતાં આ આસક્તિ પણ દૂર થાય છે.',
      meaningEnglish:
          'True detachment comes through higher realization, not mere suppression.',
      meaningGujarati:
          'સાચો વૈરાગ્ય માત્ર દમનથી નહીં પરંતુ ઉચ્ચ આધ્યાત્મિક અનુભવથી આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 60,
      sanskrit:
          'यततो ह्यपि कौन्तेय पुरुषस्य विपश्चितः ।\nइन्द्रियाणि प्रमाथीनि हरन्ति प्रसभं मनः ॥६०॥',
      english:
          'Even for a person striving with discernment, the turbulent senses can forcibly carry away the mind.',
      gujarati:
          'હે કુંતીપુત્ર! પ્રયત્નશીલ અને વિવેકી મનુષ્યનું મન પણ ચંચળ ઇન્દ્રિયો બળજબરીથી ખેંચી શકે છે.',
      meaningEnglish:
          'Sense control requires continuous awareness and discipline.',
      meaningGujarati:
          'ઇન્દ્રિયસંયમ માટે સતત જાગૃતિ અને શિસ્ત જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 61,
      sanskrit:
          'तानि सर्वाणि संयम्य युक्त आसीत मत्परः ।\nवशे हि यस्येन्द्रियाणि तस्य प्रज्ञा प्रतिष्ठिता ॥६१॥',
      english:
          'Having restrained all the senses, remain established in Me. The wisdom of one whose senses are controlled becomes steady.',
      gujarati:
          'બધી ઇન્દ્રિયોને સંયમમાં રાખીને મારામાં મન સ્થિર કર. જેના ઇન્દ્રિયો વશમાં છે તેની બુદ્ધિ સ્થિર છે.',
      meaningEnglish:
          'Sense mastery combined with devotion leads to steady wisdom.',
      meaningGujarati:
          'ઇન્દ્રિયસંયમ અને પરમાત્મા પ્રત્યેની ભક્તિ સ્થિર બુદ્ધિ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 62,
      sanskrit:
          'ध्यायतो विषयान्पुंसः सङ्गस्तेषूपजायते ।\nसङ्गात्सञ्जायते कामः कामात्क्रोधोऽभिजायते ॥६२॥',
      english:
          'When a person repeatedly thinks about sense objects, attachment arises. From attachment comes desire, and from desire comes anger.',
      gujarati:
          'મનુષ્ય વિષયોનું સતત ચિંતન કરે ત્યારે આસક્તિ થાય છે. આસક્તિથી કામના અને કામનાથી ક્રોધ ઉત્પન્ન થાય છે.',
      meaningEnglish:
          'Krishna describes the beginning of the chain that leads from attachment to anger.',
      meaningGujarati:
          'શ્રીકૃષ્ણ આસક્તિથી કામના અને કામનાથી ક્રોધ ઉત્પન્ન થવાની પ્રક્રિયા સમજાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 63,
      sanskrit:
          'क्रोधाद्भवति सम्मोहः सम्मोहात्स्मृतिविभ्रमः ।\nस्मृतिभ्रंशाद् बुद्धिनाशो बुद्धिनाशात्प्रणश्यति ॥६३॥',
      english:
          'From anger comes delusion, from delusion loss of memory, from loss of memory destruction of discrimination, and from destruction of discrimination one falls.',
      gujarati:
          'ક્રોધથી મોહ થાય છે, મોહથી સ્મૃતિભ્રમ થાય છે, સ્મૃતિભ્રમથી બુદ્ધિનો નાશ થાય છે અને બુદ્ધિના નાશથી મનુષ્યનું પતન થાય છે.',
      meaningEnglish:
          'Unchecked desire can create a chain that ultimately destroys clear judgment.',
      meaningGujarati:
          'અનિયંત્રિત કામના અંતે ક્રોધ, મોહ અને બુદ્ધિના નાશ દ્વારા પતન તરફ લઈ જઈ શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 64,
      sanskrit:
          'रागद्वेषवियुक्तैस्तु विषयानिन्द्रियैश्चरन् ।\nआत्मवश्यैर्विधेयात्मा प्रसादमधिगच्छति ॥६४॥',
      english:
          'But one who moves among objects with senses controlled and free from attachment and aversion attains inner serenity.',
      gujarati:
          'પરંતુ જે મનુષ્ય રાગ અને દ્વેષથી મુક્ત રહી સંયમિત ઇન્દ્રિયો દ્વારા વિષયોમાં વર્તે છે તે આંતરિક પ્રસન્નતા પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Balanced engagement with the world leads to inner peace.',
      meaningGujarati:
          'રાગ-દ્વેષથી મુક્ત અને સંયમિત જીવન આંતરિક શાંતિ આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 65,
      sanskrit:
          'प्रसादे सर्वदुःखानां हानिरस्योपजायते ।\nप्रसन्नचेतसो ह्याशु बुद्धिः पर्यवतिष्ठते ॥६५॥',
      english:
          'In inner serenity, all sorrows are diminished, and the intellect of one with a peaceful mind quickly becomes steady.',
      gujarati:
          'આંતરિક પ્રસન્નતા પ્રાપ્ત થતાં દુઃખોનું ક્ષય થાય છે અને શાંત મનુષ્યની બુદ્ધિ ઝડપથી સ્થિર થાય છે.',
      meaningEnglish:
          'Inner peace supports clear and stable intelligence.',
      meaningGujarati:
          'મનની શાંતિ બુદ્ધિને સ્પષ્ટ અને સ્થિર બનાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 66,
      sanskrit:
          'नास्ति बुद्धिरयुक्तस्य न चायुक्तस्य भावना ।\nन चाभावयतः शान्तिरशान्तस्य कुतः सुखम् ॥६६॥',
      english:
          'One who is not disciplined has no steady wisdom or contemplation. Without contemplation there is no peace, and without peace how can there be happiness?',
      gujarati:
          'અસંયમિત મનુષ્યમાં સ્થિર બુદ્ધિ અને ધ્યાન નથી. ધ્યાન વિના શાંતિ નથી અને શાંતિ વિના સુખ ક્યાંથી મળે?',
      meaningEnglish:
          'Discipline, contemplation, peace and happiness are connected.',
      meaningGujarati:
          'સંયમ, ધ્યાન, શાંતિ અને સુખ એકબીજા સાથે જોડાયેલા છે.',
    ),

    SacredVerseModel(
      verseNumber: 67,
      sanskrit:
          'इन्द्रियाणां हि चरतां यन्मनोऽनुविधीयते ।\nतदस्य हरति प्रज्ञां वायुर्नावमिवाम्भसि ॥६७॥',
      english:
          'When the mind follows even one wandering sense, that sense carries away the wisdom of the person like wind carrying a boat on water.',
      gujarati:
          'જ્યારે મન કોઈ એક ભટકતી ઇન્દ્રિયને અનુસરે છે ત્યારે તે ઇન્દ્રિય તેની બુદ્ધિને પાણીમાં પવન નાવને ખેંચી જાય તેમ ખેંચી જાય છે.',
      meaningEnglish:
          'An uncontrolled sense can disturb the entire mind.',
      meaningGujarati:
          'એક અનિયંત્રિત ઇન્દ્રિય પણ સમગ્ર મનની સ્થિરતા ભંગ કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 68,
      sanskrit:
          'तस्माद्यस्य महाबाहो निगृहीतानि सर्वशः ।\nइन्द्रियाणीन्द्रियार्थेभ्यस्तस्य प्रज्ञा प्रतिष्ठिता ॥६८॥',
      english:
          'Therefore, O mighty-armed one, the wisdom of one whose senses are completely restrained from their objects becomes steady.',
      gujarati:
          'હે મહાબાહુ! તેથી જે મનુષ્ય પોતાની ઇન્દ્રિયોને તેમના વિષયોથી સંપૂર્ણ રીતે સંયમમાં રાખે છે તેની બુદ્ધિ સ્થિર થાય છે.',
      meaningEnglish:
          'Complete sense discipline supports steady wisdom.',
      meaningGujarati:
          'સંપૂર્ણ ઇન્દ્રિયસંયમ સ્થિર બુદ્ધિ માટે મહત્વપૂર્ણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 69,
      sanskrit:
          'या निशा सर्वभूतानां तस्यां जागर्ति संयमी ।\nयस्यां जाग्रति भूतानि सा निशा पश्यतो मुनेः ॥६९॥',
      english:
          'What is night to all beings is wakefulness for the disciplined sage, and what is wakefulness to ordinary beings is night to the sage who sees truth.',
      gujarati:
          'જે સર્વ જીવો માટે રાત્રિ સમાન છે તેમાં સંયમી જાગે છે; અને જેમાં સામાન્ય જીવો જાગે છે તે તત્ત્વદર્શી મુનિ માટે રાત્રિ સમાન છે.',
      meaningEnglish:
          'The spiritually awakened person sees reality differently from ordinary worldly consciousness.',
      meaningGujarati:
          'આધ્યાત્મિક રીતે જાગૃત મનુષ્યની દૃષ્ટિ સામાન્ય દુન્યવી દૃષ્ટિ કરતાં અલગ હોય છે.',
    ),

    SacredVerseModel(
      verseNumber: 70,
      sanskrit:
          'आपूर्यमाणमचलप्रतिष्ठं समुद्रमापः प्रविशन्ति यद्वत् ।\nतद्वत्कामा यं प्रविशन्ति सर्वे स शान्तिमाप्नोति न कामकामी ॥७०॥',
      english:
          'As rivers enter the ever-full and unmoving ocean without disturbing it, so desires enter the person who remains steady; that person attains peace, not one who constantly seeks desires.',
      gujarati:
          'જેમ સતત ભરાતો અને અચળ સમુદ્ર નદીઓનું પાણી સ્વીકારીને પણ અશાંત થતો નથી, તેમ જે મનુષ્યમાં ઇચ્છાઓ આવે છતાં તે સ્થિર રહે છે તે શાંતિ મેળવે છે; ઇચ્છાઓ પાછળ દોડનાર નહીં.',
      meaningEnglish:
          'Peace comes from remaining inwardly full and steady despite the arrival of desires.',
      meaningGujarati:
          'ઇચ્છાઓ વચ્ચે પણ આંતરિક રીતે સ્થિર રહેવું સાચી શાંતિનું કારણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 71,
      sanskrit:
          'विहाय कामान्यः सर्वान्पुमांश्चरति निःस्पृहः ।\nनिर्ममो निरहङ्कारः स शान्तिमधिगच्छति ॥७१॥',
      english:
          'One who abandons all desires, moves without craving, and lives without possessiveness and ego attains peace.',
      gujarati:
          'જે મનુષ્ય બધી કામનાઓ છોડીને નિષ્પૃહ રહે છે, મમતા અને અહંકારથી મુક્ત રહે છે તે શાંતિ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Freedom from craving, possessiveness and ego leads to peace.',
      meaningGujarati:
          'કામના, મમતા અને અહંકારથી મુક્તિ આંતરિક શાંતિ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 72,
      sanskrit:
          'एषा ब्राह्मी स्थितिः पार्थ नैनां प्राप्य विमुह्यति ।\nस्थित्वास्यामन्तकालेऽपि ब्रह्मनिर्वाणमृच्छति ॥७२॥',
      english:
          'O Partha, this is the state of being established in Brahman. Having attained it, one is no longer deluded. Being established in this state even at the final moment, one attains liberation in Brahman.',
      gujarati:
          'હે પાર્થ! આ બ્રહ્મસ્થિતિ છે. તેને પ્રાપ્ત કર્યા પછી મનુષ્ય ફરી મોહમાં પડતો નથી. અંતકાળે પણ તેમાં સ્થિર રહીને બ્રહ્મનિર્વાણ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Chapter 2 concludes by describing the state of spiritual realization and liberation.',
      meaningGujarati:
          'અધ્યાય ૨ સ્થિર જ્ઞાન, બ્રહ્મસ્થિતિ અને અંતિમ મુક્તિના ઉપદેશ સાથે પૂર્ણ થાય છે.',
    ),
  ];
}
// =====================================================

// =====================================================
// BHAGAVAD GITA - CHAPTER 5
// KARMA SANNYASA YOGA
// 29 VERSES
// Sanskrit verified against Gita Supersite.
// Gujarati/English explanations are based on the user's supplied chapter notes.
// =====================================================

static List<SacredVerseModel> _gitaChapter5Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit: 'अर्जुन उवाच ।\nसंन्यासं कर्मणां कृष्ण पुनर्योगं च शंससि ।\nयच्छ्रेय एतयोरेकं तन्मे ब्रूहि सुनिश्चितम् ॥५.१॥',
      english: 'Arjuna asks which is better for him: renouncing actions or performing Karma Yoga.',
      gujarati: 'અર્જુન કહે છે: હે શ્રીકૃષ્ણ! તમે કર્મસંન્યાસ અને કર્મયોગ બંનેની પ્રશંસા કરો છો. આ બંનેમાંથી મારા માટે કયો માર્ગ શ્રેષ્ઠ છે તે સ્પષ્ટ રીતે કહો.',
      meaningEnglish: 'Simple meaning: Arjuna wants clarity about whether to renounce action or continue performing action.',
      meaningGujarati: 'સરળ અર્થ: કર્મ છોડવું સારું કે કર્મ કરતાં રહેવું સારું—અર્જુન આ અંગે સ્પષ્ટતા માંગે છે.',
    ),
    SacredVerseModel(
      verseNumber: 2,
      sanskrit: 'श्रीभगवानुवाच ।\nसंन्यासः कर्मयोगश्च निःश्रेयसकरावुभौ ।\nतयोस्तु कर्मसंन्यासात्कर्मयोगो विशिष्यते ॥५.२॥',
      english: 'Krishna says both renunciation and Karma Yoga lead to welfare, but Karma Yoga is superior to merely renouncing action.',
      gujarati: 'શ્રીકૃષ્ણ કહે છે: કર્મસંન્યાસ અને કર્મયોગ બંને કલ્યાણકારી છે, પરંતુ કર્મસંન્યાસ કરતાં કર્મયોગ શ્રેષ્ઠ છે.',
      meaningEnglish: 'Simple meaning: It is better to give up attachment while performing action than simply to abandon action.',
      meaningGujarati: 'સરળ અર્થ: કર્મ છોડવા કરતાં આસક્તિ છોડીને કર્મ કરવું વધુ સારું છે.',
    ),
    SacredVerseModel(
      verseNumber: 3,
      sanskrit: 'ज्ञेयः स नित्यसंन्यासी यो न द्वेष्टि न काङ्क्षति ।\nनिर्द्वन्द्वो हि महाबाहो सुखं बन्धात्प्रमुच्यते ॥५.३॥',
      english: 'One who neither hates nor desires is the true renunciant and is freed from the pairs of opposites.',
      gujarati: 'જે વ્યક્તિ કોઈ વસ્તુ પ્રત્યે દ્વેષ રાખતો નથી અને કોઈ વસ્તુની ઈચ્છા પણ રાખતો નથી, તે સાચો સંન્યાસી છે.',
      meaningEnglish: 'Simple meaning: Renunciation is an inner state; desires and aversions must be given up.',
      meaningGujarati: 'સરળ અર્થ: માત્ર કપડાં કે ઘર છોડવાથી સંન્યાસી બનાતું નથી; મનમાંથી ઈચ્છા અને દ્વેષ છોડવા જરૂરી છે.',
    ),
    SacredVerseModel(
      verseNumber: 4,
      sanskrit: 'साङ्ख्ययोगौ पृथग्बालाः प्रवदन्ति न पण्डिताः ।\nएकमप्यास्थितः सम्यगुभयोर्विन्दते फलम् ॥५.४॥',
      english: 'Only the unwise distinguish Sankhya and Karma Yoga as completely separate; one who properly follows either gains the fruit of both.',
      gujarati: 'જ્ઞાનયોગ અને કર્મયોગને અલગ માનનાર લોકો સંપૂર્ણ સત્ય જાણતા નથી. બંનેમાંથી કોઈ એકનું યોગ્ય રીતે પાલન કરનાર વ્યક્તિ બંનેનું ફળ પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Simple meaning: Knowledge and selfless action ultimately lead toward the same liberation.',
      meaningGujarati: 'સરળ અર્થ: જ્ઞાન અને નિષ્કામ કર્મ બંને અંતે એક જ મુક્તિના માર્ગ તરફ લઈ જાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 5,
      sanskrit: 'यत्साङ्ख्यैः प्राप्यते स्थानं तद्योगैरपि गम्यते ।\nएकं साङ्ख्यं च योगं च यः पश्यति स पश्यति ॥५.५॥',
      english: 'The state reached by Sankhya is also reached by Karma Yoga; one who sees them as essentially one truly sees.',
      gujarati: 'જ્ઞાનયોગથી જે પરમ સ્થાન પ્રાપ્ત થાય છે, તે જ સ્થાન કર્મયોગથી પણ પ્રાપ્ત થાય છે.',
      meaningEnglish: 'Simple meaning: True knowledge and selfless action have the same ultimate goal: realization of the Divine.',
      meaningGujarati: 'સરળ અર્થ: સાચું જ્ઞાન અને નિષ્કામ કર્મ—બંનેનો અંતિમ હેતુ પરમાત્માની પ્રાપ્તિ છે.',
    ),
    SacredVerseModel(
      verseNumber: 6,
      sanskrit: 'संन्यासस्तु महाबाहो दुःखमाप्तुमयोगतः ।\nयोगयुक्तो मुनिर्ब्रह्म नचिरेणाधिगच्छति ॥५.६॥',
      english: 'Renunciation is difficult without Karma Yoga, but a sage established in Yoga quickly attains Brahman.',
      gujarati: 'કર્મયોગ વિના સંન્યાસ પ્રાપ્ત કરવો મુશ્કેલ છે. કર્મયોગમાં સ્થિર થયેલો જ્ઞાની ટૂંક સમયમાં પરમાત્માને પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Simple meaning: Selfless action purifies the mind and prepares one for true renunciation.',
      meaningGujarati: 'સરળ અર્થ: પહેલાં મનને શુદ્ધ કરવા નિષ્કામ કર્મ કરવું જરૂરી છે.',
    ),
    SacredVerseModel(
      verseNumber: 7,
      sanskrit: 'योगयुक्तो विशुद्धात्मा विजितात्मा जितेन्द्रियः ।\nसर्वभूतात्मभूतात्मा कुर्वन्नपि न लिप्यते ॥५.७॥',
      english: 'The disciplined Karma Yogi, pure in mind and master of the senses, sees the Self in all beings and is not bound by action.',
      gujarati: 'જે વ્યક્તિ મનને જીતીને, ઇન્દ્રિયોને વશમાં રાખીને અને દરેક જીવમાં પરમાત્માને જુએ છે, તે કર્મ કરતો હોવા છતાં કર્મથી બંધાતો નથી.',
      meaningEnglish: 'Simple meaning: When the mind is pure, action does not create bondage.',
      meaningGujarati: 'સરળ અર્થ: મન શુદ્ધ હોય તો કર્મ આપણને બંધનમાં નાખતું નથી.',
    ),
    SacredVerseModel(
      verseNumber: 8,
      sanskrit: 'नैव किञ्चित्करोमीति युक्तो मन्येत तत्त्ववित् ।\nपश्यञ्शृण्वन्स्पृशञ्जिघ्रन्नश्नन्गच्छन्स्वपञ्श्वसन् ॥५.८॥',
      english: 'The knower of truth, while seeing, hearing, touching, smelling, eating, walking, sleeping and breathing, knows inwardly that he does nothing.',
      gujarati: 'જ્ઞાની વ્યક્તિ જોતા, સાંભળતા, સ્પર્શતા, ખાતા, ચાલતા, સૂતા અને શ્વાસ લેતા હોવા છતાં જાણે છે કે “હું કંઈ કરતો નથી.”',
      meaningEnglish: 'Simple meaning: The wise person knows the Self is distinct from bodily activities.',
      meaningGujarati: 'સરળ અર્થ: જ્ઞાની પોતાને શરીર નહીં પરંતુ આત્મા માને છે.',
    ),
    SacredVerseModel(
      verseNumber: 9,
      sanskrit: 'प्रलपन्विसृजन्गृह्णन्नुन्मिषन्निमिषन्नपि ।\nइन्द्रियाणीन्द्रियार्थेषु वर्तन्त इति धारयन् ॥५.९॥',
      english: 'While speaking, releasing, grasping, opening or closing the eyes, the knower understands that the senses move among their objects.',
      gujarati: 'જ્ઞાની વ્યક્તિ બોલતા, છોડતા, લેતા, આંખો ખોલતા કે બંધ કરતા પણ સમજે છે કે ઇન્દ્રિયો પોતાના વિષયોમાં કાર્ય કરે છે.',
      meaningEnglish: 'Simple meaning: The wise person remains inwardly unattached to the activities of the senses.',
      meaningGujarati: 'સરળ અર્થ: શરીર અને ઇન્દ્રિયો કર્મ કરે છે, પરંતુ આત્મા તેમાં આસક્ત રહેતો નથી.',
    ),
    SacredVerseModel(
      verseNumber: 10,
      sanskrit: 'ब्रह्मण्याधाय कर्माणि सङ्गं त्यक्त्वा करोति यः ।\nलिप्यते न स पापेन पद्मपत्रमिवाम्भसा ॥५.१०॥',
      english: 'One who performs actions by offering them to Brahman without attachment is untouched by sin, like a lotus leaf by water.',
      gujarati: 'જે વ્યક્તિ પોતાના બધા કર્મો પરમાત્માને અર્પણ કરીને કરે છે, તે કમળના પાનની જેમ પાણીથી અસ્પર્શિત રહે છે અને પાપથી લિપ્ત થતો નથી.',
      meaningEnglish: 'Simple meaning: Perform action and offer its results to God.',
      meaningGujarati: 'સરળ અર્થ: કર્મ કરો, પરંતુ તેનું પરિણામ ભગવાનને અર્પણ કરો.',
    ),
    SacredVerseModel(
      verseNumber: 11,
      sanskrit: 'कायेन मनसा बुद्ध्या केवलैरिन्द्रियैरपि ।\nयोगिनः कर्म कुर्वन्ति सङ्गं त्यक्त्वात्मशुद्धये ॥५.११॥',
      english: 'Yogis perform actions through body, mind, intellect and senses without attachment, for the purification of the self.',
      gujarati: 'યોગીઓ આસક્તિ છોડીને શરીર, મન, બુદ્ધિ અને ઇન્દ્રિયો દ્વારા કર્મ કરે છે.',
      meaningEnglish: 'Simple meaning: Action is necessary, but attachment to its fruits is not.',
      meaningGujarati: 'સરળ અર્થ: કર્મ કરવું જરૂરી છે, પરંતુ ફળની અપેક્ષા રાખવી નહીં.',
    ),
    SacredVerseModel(
      verseNumber: 12,
      sanskrit: 'युक्तः कर्मफलं त्यक्त्वा शान्तिमाप्नोति नैष्ठिकीम् ।\nअयुक्तः कामकारेण फले सक्तो निबध्यते ॥५.१२॥',
      english: 'The Karma Yogi attains lasting peace by giving up the fruits of action, while one attached to results becomes bound.',
      gujarati: 'કર્મયોગી કર્મના ફળનો ત્યાગ કરીને શાંતિ મેળવે છે. પરંતુ જે ફળની ઈચ્છાથી કર્મ કરે છે તે બંધનમાં પડે છે.',
      meaningEnglish: 'Simple meaning: Work sincerely, but do not be anxious about the result.',
      meaningGujarati: 'સરળ અર્થ: કર્મ કરો, ફળની ચિંતા ન કરો.',
    ),
    SacredVerseModel(
      verseNumber: 13,
      sanskrit: 'सर्वकर्माणि मनसा संन्यस्यास्ते सुखं वशी ।\nनवद्वारे पुरे देही नैव कुर्वन्न कारयन् ॥५.१३॥',
      english: 'The self-controlled person mentally renounces all actions and dwells happily in the nine-gated city, neither acting nor causing action.',
      gujarati: 'આત્મજ્ઞાની વ્યક્તિ પોતાના શરીરને નવ દ્વારવાળા શહેર સમાન માનીને તેમાં રહે છે અને પોતે કંઈ કરતો નથી એમ સમજે છે.',
      meaningEnglish: 'Simple meaning: The Self is distinct from the body, which is like a city with nine gates.',
      meaningGujarati: 'સરળ અર્થ: આત્મા શરીરથી અલગ છે.',
    ),
    SacredVerseModel(
      verseNumber: 14,
      sanskrit: 'न कर्तृत्वं न कर्माणि लोकस्य सृजति प्रभुः ।\nन कर्मफलसंयोगं स्वभावस्तु प्रवर्तते ॥५.१४॥',
      english: 'The Supreme does not create the sense of doership, actions, or the connection with their fruits; nature operates according to its own tendencies.',
      gujarati: 'પરમાત્મા કોઈને કર્મ કરવા માટે મજબૂર કરતા નથી અને કર્મનું ફળ પણ તેઓ સીધું બનાવતા નથી; મનુષ્યની પોતાની પ્રકૃતિને કારણે કર્મ થાય છે.',
      meaningEnglish: 'Simple meaning: Responsibility for our actions cannot simply be placed on God.',
      meaningGujarati: 'સરળ અર્થ: આપણા કર્મ માટે જવાબદારી આપણી પોતાની છે.',
    ),
    SacredVerseModel(
      verseNumber: 15,
      sanskrit: 'नादत्ते कस्यचित्पापं न चैव सुकृतं विभुः ।\nअज्ञानेनावृतं ज्ञानं तेन मुह्यन्ति जन्तवः ॥५.१५॥',
      english: 'The all-pervading Lord takes neither sin nor virtue from anyone; knowledge is covered by ignorance, and beings become deluded.',
      gujarati: 'પરમાત્મા કોઈનું પાપ કે પુણ્ય પોતાના પર લેતા નથી. અજ્ઞાનના કારણે મનુષ્ય સત્યને ઓળખી શકતો નથી.',
      meaningEnglish: 'Simple meaning: Ignorance prevents a person from recognizing the truth.',
      meaningGujarati: 'સરળ અર્થ: અજ્ઞાન દૂર થાય ત્યારે જ સાચું જ્ઞાન પ્રાપ્ત થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 16,
      sanskrit: 'ज्ञानेन तु तदज्ञानं येषां नाशितमात्मनः ।\nतेषामादित्यवज्ज्ञानं प्रकाशयति तत्परम् ॥५.१६॥',
      english: 'For those whose ignorance is destroyed by knowledge of the Self, that knowledge shines like the sun and reveals the Supreme.',
      gujarati: 'જેમ સૂર્યનો પ્રકાશ અંધકાર દૂર કરે છે તેમ જ્ઞાનનો પ્રકાશ અજ્ઞાનનો નાશ કરે છે.',
      meaningEnglish: 'Simple meaning: Knowledge reveals the true nature of life and the Self.',
      meaningGujarati: 'સરળ અર્થ: જ્ઞાન પ્રાપ્ત થતાં જીવનનું સાચું સ્વરૂપ સમજાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 17,
      sanskrit: 'तद्बुद्धयस्तदात्मानस्तन्निष्ठास्तत्परायणाः ।\nगच्छन्त्यपुनरावृत्तिं ज्ञाननिर्धूतकल्मषाः ॥५.१७॥',
      english: 'Those whose intellect and mind are fixed in the Supreme, who take refuge in Him and are purified by knowledge, reach a state from which there is no return.',
      gujarati: 'જે વ્યક્તિ પરમાત્માને જ પોતાનું સર્વસ્વ માને છે અને જેમનું મન તથા બુદ્ધિ તેમાં સ્થિર છે, તેઓ જ્ઞાન દ્વારા પાપોથી મુક્ત થઈ પરમ ગતિ મેળવે છે.',
      meaningEnglish: 'Simple meaning: Fixing mind and intellect in God leads the seeker toward liberation.',
      meaningGujarati: 'સરળ અર્થ: ભગવાનમાં મન રાખવાથી વ્યક્તિ મુક્તિના માર્ગે આગળ વધે છે.',
    ),
    SacredVerseModel(
      verseNumber: 18,
      sanskrit: 'विद्याविनयसम्पन्ने ब्राह्मणे गवि हस्तिनि ।\nशुनि चैव श्वपाके च पण्डिताः समदर्शिनः ॥५.१८॥',
      english: 'The wise see with equal vision a learned and humble Brahmin, a cow, an elephant, a dog and one who is socially outcast.',
      gujarati: 'જ્ઞાની વ્યક્તિ વિદ્વાન બ્રાહ્મણ, ગાય, હાથી, કૂતરો અને નીચા ગણાતા વ્યક્તિમાં પણ સમાન આત્માને જુએ છે.',
      meaningEnglish: 'Simple meaning: The true wise person sees the same Self in all beings.',
      meaningGujarati: 'સરળ અર્થ: સાચા જ્ઞાની માટે બધા જીવોમાં રહેલો આત્મા સમાન છે.',
    ),
    SacredVerseModel(
      verseNumber: 19,
      sanskrit: 'इहैव तैर्जितः सर्गो येषां साम्ये स्थितं मनः ।\nनिर्दोषं हि समं ब्रह्म तस्माद्ब्रह्मणि ते स्थिताः ॥५.१९॥',
      english: 'Those whose minds are established in equality have conquered birth and death even here, for Brahman is equal and without defect.',
      gujarati: 'જે વ્યક્તિની બુદ્ધિ સમભાવમાં સ્થિર છે તેણે આ જીવનમાં જ જન્મ-મરણના બંધનને જીત્યું છે.',
      meaningEnglish: 'Simple meaning: Seeing equality in all beings brings the mind closer to liberation.',
      meaningGujarati: 'સરળ અર્થ: સૌમાં સમાન આત્મા જોવાથી મનુષ્ય મુક્તિના નજીક પહોંચે છે.',
    ),
    SacredVerseModel(
      verseNumber: 20,
      sanskrit: 'न प्रहृष्येत्प्रियं प्राप्य नोद्विजेत्प्राप्य चाप्रियम् ।\nस्थिरबुद्धिरसम्मूढो ब्रह्मविद्ब्रह्मणि स्थितः ॥५.२०॥',
      english: 'One who knows Brahman remains steady, neither overly joyful on receiving what is pleasant nor disturbed by what is unpleasant.',
      gujarati: 'જે વ્યક્તિને પ્રિય વસ્તુ મળે ત્યારે અતિશય ખુશી થતી નથી અને અપ્રિય વસ્તુ મળે ત્યારે દુઃખ થતું નથી, તે સ્થિર બુદ્ધિવાળો છે.',
      meaningEnglish: 'Simple meaning: Do not let changing circumstances control the mind.',
      meaningGujarati: 'સરળ અર્થ: પરિસ્થિતિ પ્રમાણે મન બદલવું નહીં.',
    ),
    SacredVerseModel(
      verseNumber: 21,
      sanskrit: 'बाह्यस्पर्शेष्वसक्तात्मा विन्दत्यात्मनि यत्सुखम् ।\nस ब्रह्मयोगयुक्तात्मा सुखमक्षयमश्नुते ॥५.२१॥',
      english: 'One unattached to external sense contacts finds happiness within and, united with Brahman, enjoys imperishable bliss.',
      gujarati: 'જે વ્યક્તિ બાહ્ય વિષયોમાં સુખ શોધતો નથી અને પોતાનામાં જ સુખ મેળવે છે, તે પરમાત્મામાં સ્થિત થઈને અવિનાશી આનંદ મેળવે છે.',
      meaningEnglish: 'Simple meaning: Lasting happiness is found within, not in external objects.',
      meaningGujarati: 'સરળ અર્થ: સાચું સુખ બહારની વસ્તુઓમાં નહીં પરંતુ પોતાના અંતરમાં છે.',
    ),
    SacredVerseModel(
      verseNumber: 22,
      sanskrit: 'ये हि संस्पर्शजा भोगा दुःखयोनय एव ते ।\nआद्यन्तवन्तः कौन्तेय न तेषु रमते बुधः ॥५.२२॥',
      english: 'Pleasures born from contact with the senses are sources of suffering; they have a beginning and an end, so the wise do not delight in them.',
      gujarati: 'ઇન્દ્રિયો અને વિષયોના સંપર્કથી મળતું સુખ શરૂઆતમાં સારું લાગે છે, પરંતુ અંતે દુઃખ આપે છે.',
      meaningEnglish: 'Simple meaning: Worldly pleasure is temporary, so one should not become overly dependent on it.',
      meaningGujarati: 'સરળ અર્થ: દુન્યવી સુખ થોડા સમયનું છે, તેથી તેના પાછળ વધારે દોડવું નહીં.',
    ),
    SacredVerseModel(
      verseNumber: 23,
      sanskrit: 'शक्नोतीहैव यः सोढुं प्राक्शरीरविमोक्षणात् ।\nकामक्रोधोद्भवं वेगं स युक्तः स सुखी नरः ॥५.२३॥',
      english: 'One who can withstand the force of desire and anger before leaving the body is a disciplined and happy person.',
      gujarati: 'જે મનુષ્ય શરીર છોડતા પહેલાં જ કામ અને ક્રોધથી ઉત્પન્ન થતી શક્તિશાળી વેગોને સહન કરી શકે છે, તે સાચો યોગી અને સુખી છે.',
      meaningEnglish: 'Simple meaning: Mastery over desire and anger is essential for spiritual progress.',
      meaningGujarati: 'સરળ અર્થ: કામ અને ક્રોધ પર નિયંત્રણ મેળવવું ખૂબ જરૂરી છે.',
    ),
    SacredVerseModel(
      verseNumber: 24,
      sanskrit: 'योऽन्तःसुखोऽन्तरारामस्तथान्तर्ज्योतिरेव यः ।\nस योगी ब्रह्मनिर्वाणं ब्रह्मभूतोऽधिगच्छति ॥५.२४॥',
      english: 'The yogi who finds happiness, delight and light within becomes united with Brahman and attains Brahma-nirvana.',
      gujarati: 'જે વ્યક્તિને પોતાના અંતરમાં જ સુખ, આનંદ અને પ્રકાશ મળે છે, તે યોગી બ્રહ્મરૂપ બની પરમ શાંતિ પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Simple meaning: Inner spiritual joy is the highest happiness.',
      meaningGujarati: 'સરળ અર્થ: આત્મિક આનંદ સૌથી મોટું સુખ છે.',
    ),
    SacredVerseModel(
      verseNumber: 25,
      sanskrit: 'लभन्ते ब्रह्मनिर्वाणमृषयः क्षीणकल्मषाः ।\nछिन्नद्वैधा यतात्मानः सर्वभूतहिते रताः ॥५.२५॥',
      english: 'Those who are purified of sin, free from doubt, self-controlled and devoted to the welfare of all beings attain Brahman.',
      gujarati: 'જે લોકો પાપથી મુક્ત છે, સંશયથી મુક્ત છે, બધા જીવોના હિતમાં કાર્ય કરે છે અને પોતાની ઇન્દ્રિયો પર નિયંત્રણ રાખે છે, તેઓ બ્રહ્મને પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Simple meaning: Purity, service to all beings and self-control support liberation.',
      meaningGujarati: 'સરળ અર્થ: સારા વિચારો, સેવા અને આત્મસંયમથી મુક્તિ મળે છે.',
    ),
    SacredVerseModel(
      verseNumber: 26,
      sanskrit: 'कामक्रोधवियुक्तानां यतीनां यतचेतसाम् ।\nअभितो ब्रह्मनिर्वाणं वर्तते विदितात्मनाम् ॥५.२६॥',
      english: 'For those disciplined seekers who are free from desire and anger and have controlled their minds, Brahma-nirvana is near.',
      gujarati: 'જે સંન્યાસી કામ અને ક્રોધથી મુક્ત છે અને પોતાના મનને નિયંત્રિત કરે છે, તે બ્રહ્મને પ્રાપ્ત કરવા સક્ષમ બને છે.',
      meaningEnglish: 'Simple meaning: Victory over desire and anger is necessary for spiritual advancement.',
      meaningGujarati: 'સરળ અર્થ: કામ અને ક્રોધ પર વિજય મેળવવો આધ્યાત્મિક પ્રગતિ માટે જરૂરી છે.',
    ),
    SacredVerseModel(
      verseNumber: 27,
      sanskrit: 'स्पर्शान्कृत्वा बहिर्बाह्यांश्चक्षुश्चैवान्तरे भ्रुवोः ।\nप्राणापानौ समौ कृत्वा नासाभ्यन्तरचारिणौ ॥५.२७॥',
      english: 'With external sense objects set aside, the gaze steady between the eyebrows, and the inward and outward breaths balanced, the yogi practices meditation.',
      gujarati: 'યોગી બાહ્ય વિષયોનો ત્યાગ કરીને, દૃષ્ટિને સ્થિર રાખીને અને શ્વાસને નિયંત્રિત કરીને ધ્યાન કરે છે.',
      meaningEnglish: 'Simple meaning: Meditation uses sense withdrawal, steady attention and breath regulation.',
      meaningGujarati: 'સરળ અર્થ: ધ્યાન દ્વારા મનને શાંત અને નિયંત્રિત કરી શકાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 28,
      sanskrit: 'यतेन्द्रियमनोबुद्धिर्मुनिर्मोक्षपरायणः ।\nविगतेच्छाभयक्रोधो यः सदा मुक्त एव सः ॥५.२८॥',
      english: 'The sage who controls the senses, mind and intellect, is devoted to liberation, and is free from desire, fear and anger is ever liberated.',
      gujarati: 'યોગી મન, ઇન્દ્રિયો અને બુદ્ધિને વશમાં રાખીને, કામ, ક્રોધ અને ભયથી મુક્ત થઈ પરમાત્મામાં સ્થિર થાય છે.',
      meaningEnglish: 'Simple meaning: Inner control and freedom from desire, fear and anger stabilize the seeker in the Divine.',
      meaningGujarati: 'સરળ અર્થ: મન, ઇન્દ્રિયો અને બુદ્ધિ પર નિયંત્રણથી આંતરિક શાંતિ પ્રાપ્ત થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 29,
      sanskrit: 'भोक्तारं यज्ञतपसां सर्वलोकमहेश्वरम् ।\nसुहृदं सर्वभूतानां ज्ञात्वा मां शान्तिमृच्छति ॥५.२९॥',
      english: 'Knowing Krishna as the enjoyer of all sacrifices and austerities, the Supreme Lord of all worlds, and the true friend of all beings, one attains peace.',
      gujarati: 'શ્રીકૃષ્ણ કહે છે: જે મને બધા યજ્ઞો અને તપનો ભોક્તા, બધા લોકનો મહેશ્વર અને બધા જીવોનો સાચો મિત્ર જાણે છે, તે પરમ શાંતિ પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Simple meaning: Knowing God as the Supreme Lord and the true friend of all beings brings lasting peace.',
      meaningGujarati: 'સરળ અર્થ: ભગવાન જ સર્વના સ્વામી અને સાચા મિત્ર છે. આ વાતને સમજવાથી મનુષ્યને સાચી શાંતિ મળે છે.',
    ),
  ];
}

// =====================================================
// BHAGAVAD GITA - CHAPTER 4
// JNANA KARMA SANNYASA YOGA
// 42 VERSES
// Sanskrit verified against a published Devanagari chapter text.
// Gujarati explanations are based on the user's supplied chapter notes.
// =====================================================

static List<SacredVerseModel> _gitaChapter4Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit: 'श्रीभगवानुवाच ।\nइमं विवस्वते योगं प्रोक्तवानहमव्ययम् ।\nविवस्वान्मनवे प्राह मनुरिक्ष्वाकवेऽब्रवीत् ॥४.१॥',
      english: 'Lord Krishna says that He first taught this imperishable yoga to the Sun-god, who taught Manu, and Manu taught Ikshvaku.',
      gujarati: 'શ્રીકૃષ્ણ કહે છે કે આ અવિનાશી યોગ મેં સૌપ્રથમ સૂર્યદેવને કહ્યો હતો. સૂર્યદેવે મનુને અને મનુએ ઇક્ષ્વાકુને આ યોગ સમજાવ્યો હતો.',
      meaningEnglish: 'Key point: Lord Krishna says that He first taught this imperishable yoga to the Sun-god, who taught Manu, and Manu taught Ikshvaku.',
      meaningGujarati: 'મુખ્ય વાત: આ જ્ઞાન ખૂબ પ્રાચીન છે અને ગુરુ-શિષ્ય પરંપરાથી ચાલ્યું છે.',
    ),
    SacredVerseModel(
      verseNumber: 2,
      sanskrit: 'एवं परंपराप्राप्तमिमं राजर्षयो विदुः ।\nस कालेनेह महता योगो नष्टः परंतप ॥४.२॥',
      english: 'In this way the royal sages knew this yoga, but over time that teaching was lost.',
      gujarati: 'આ રીતે રાજર્ષિઓએ આ યોગને જાણ્યો હતો, પરંતુ સમય જતાં આ યોગનું જ્ઞાન લુપ્ત થઈ ગયું. તેથી શ્રીકૃષ્ણ ફરીથી અર્જુનને આ રહસ્યમય યોગ સમજાવે છે.',
      meaningEnglish: 'Key point: In this way the royal sages knew this yoga, but over time that teaching was lost.',
      meaningGujarati: 'મુખ્ય વાત: સાચું આધ્યાત્મિક જ્ઞાન સમય જતાં ભૂલાઈ શકે છે.',
    ),
    SacredVerseModel(
      verseNumber: 3,
      sanskrit: 'स एवायं मया तेऽद्य योगः प्रोक्तः पुरातनः ।\nभक्तोऽसि मे सखा चेति रहस्यं ह्येतदुत्तमम् ॥४.३॥',
      english: 'Krishna explains this ancient yoga to Arjuna because he is His devotee and friend.',
      gujarati: 'શ્રીકૃષ્ણ કહે છે કે અર્જુન મારો ભક્ત અને મિત્ર હોવાથી મેં તેને આ પ્રાચીન યોગનું રહસ્ય સમજાવ્યું છે.',
      meaningEnglish: 'Key point: Krishna explains this ancient yoga to Arjuna because he is His devotee and friend.',
      meaningGujarati: 'મુખ્ય વાત: ભક્તિ અને શ્રદ્ધાથી જ સાચું જ્ઞાન પ્રાપ્ત થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 4,
      sanskrit: 'अर्जुन उवाच ।\nअपरं भवतो जन्म परं जन्म विवस्वतः ।\nकथमेतद्विजानीयां त्वमादौ प्रोक्तवानिति ॥४.४॥',
      english: "Arjuna asks how Krishna could have taught the Sun-god when the Sun-god is ancient and Krishna's birth is later.",
      gujarati: 'અર્જુન પૂછે છે કે સૂર્યદેવ તો ઘણા પ્રાચીન છે અને તમે અત્યારે જન્મ્યા છો, તો તમે તેમને આ યોગ કેવી રીતે શીખવ્યો?',
      meaningEnglish: 'Key point: અર્જુનને શ્રીકૃષ્ણના દિવ્ય સ્વરૂપ વિશે પ્રશ્ન થાય છે.',
      meaningGujarati: 'મુખ્ય વાત: અર્જુનને શ્રીકૃષ્ણના દિવ્ય સ્વરૂપ વિશે પ્રશ્ન થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 5,
      sanskrit: 'श्रीभगवानुवाच ।\nबहूनि मे व्यतीतानि जन्मानि तव चार्जुन ।\nतान्यहं वेद सर्वाणि न त्वं वेत्थ परंतप ॥४.५॥',
      english: 'Krishna says that both He and Arjuna have had many births; He remembers them all, while Arjuna does not.',
      gujarati: 'શ્રીકૃષ્ણ કહે છે કે મારા અને તારા ઘણા જન્મ થઈ ચૂક્યા છે. મને એ બધા જન્મ યાદ છે, પરંતુ તને યાદ નથી.',
      meaningEnglish: 'Key point: Krishna says that both He and Arjuna have had many births; He remembers them all, while Arjuna does not.',
      meaningGujarati: 'મુખ્ય વાત: ભગવાન જન્મ-મરણથી પર છે અને પોતાના બધા અવતારોને જાણે છે.',
    ),
    SacredVerseModel(
      verseNumber: 6,
      sanskrit: 'अजोऽपि सन्नव्ययात्मा भूतानामीश्वरोऽपि सन् ।\nप्रकृतिं स्वामधिष्ठाय संभवाम्यात्ममायया ॥४.६॥',
      english: 'Though unborn, imperishable, and Lord of all beings, Krishna manifests Himself through His own divine power.',
      gujarati: 'ભગવાન કહે છે કે હું અજન્મા અને અવિનાશી હોવા છતાં મારી યોગમાયાથી અવતાર ધારણ કરું છું.',
      meaningEnglish: 'Key point: Though unborn, imperishable, and Lord of all beings, Krishna manifests Himself through His own divine power.',
      meaningGujarati: 'મુખ્ય વાત: ભગવાન પોતાની ઈચ્છાથી પૃથ્વી પર અવતાર લે છે.',
    ),
    SacredVerseModel(
      verseNumber: 7,
      sanskrit: 'यदा यदा हि धर्मस्य ग्लानिर्भवति भारत ।\nअभ्युत्थानमधर्मस्य तदात्मानं सृजाम्यहम् ॥४.७॥',
      english: 'Whenever righteousness declines and unrighteousness rises, Krishna manifests Himself.',
      gujarati: 'જ્યારે જ્યારે ધર્મનો નાશ અને અધર્મની વૃદ્ધિ થાય છે, ત્યારે હું પૃથ્વી પર અવતાર ધારણ કરું છું.',
      meaningEnglish: 'Key point: Whenever righteousness declines and unrighteousness rises, Krishna manifests Himself.',
      meaningGujarati: 'મુખ્ય વાત: ધર્મની રક્ષા માટે ભગવાન અવતાર લે છે.',
    ),
    SacredVerseModel(
      verseNumber: 8,
      sanskrit: 'परित्राणाय साधूनां विनाशाय च दुष्कृताम् ।\nधर्मसंस्थापनार्थाय संभवामि युगे युगे ॥४.८॥',
      english: 'Krishna manifests in every age to protect the righteous, destroy evil, and re-establish dharma.',
      gujarati: 'સાધુઓનું રક્ષણ કરવા, દુષ્ટોનો નાશ કરવા અને ધર્મની સ્થાપના કરવા ભગવાન યુગે યુગે અવતાર લે છે.',
      meaningEnglish: 'Key point: Krishna manifests in every age to protect the righteous, destroy evil, and re-establish dharma.',
      meaningGujarati: 'મુખ્ય વાત: સાધુનું રક્ષણ, દુષ્ટોનો વિનાશ અને ધર્મની સ્થાપના.',
    ),
    SacredVerseModel(
      verseNumber: 9,
      sanskrit: 'जन्म कर्म च मे दिव्यमेवं यो वेत्ति तत्त्वतः ।\nत्यक्त्वा देहं पुनर्जन्म नैति मामेति सोऽर्जुन ॥४.९॥',
      english: "One who truly understands Krishna's divine birth and actions does not take rebirth after leaving the body and attains Him.",
      gujarati: 'જે વ્યક્તિ ભગવાનના દિવ્ય જન્મ અને કર્મનું સાચું જ્ઞાન મેળવે છે, તે મૃત્યુ પછી ફરી જન્મ લેતો નથી અને ભગવાનને પ્રાપ્ત થાય છે.',
      meaningEnglish: 'Key point: ભગવાનના દિવ્ય સ્વરૂપને સમજવાથી મોક્ષ મળે છે.',
      meaningGujarati: 'મુખ્ય વાત: ભગવાનના દિવ્ય સ્વરૂપને સમજવાથી મોક્ષ મળે છે.',
    ),
    SacredVerseModel(
      verseNumber: 10,
      sanskrit: 'वीतरागभयक्रोधा मन्मया मामुपाश्रिताः ।\nबहवो ज्ञानतपसा पूता मद्भावमागताः ॥४.१०॥',
      english: 'Many people, freed from attachment, fear, and anger, take refuge in Krishna and become purified through knowledge and spiritual discipline.',
      gujarati: 'ઘણા લોકો રાગ, ભય અને ક્રોધથી મુક્ત થઈને ભગવાનના આશ્રયમાં રહી જ્ઞાન અને તપ દ્વારા પવિત્ર થયા છે.',
      meaningEnglish: 'Key point: Many people, freed from attachment, fear, and anger, take refuge in Krishna and become purified through knowledge and spiritual discipline.',
      meaningGujarati: 'મુખ્ય વાત: રાગ, ભય અને ક્રોધ છોડવાથી આધ્યાત્મિક પ્રગતિ થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 11,
      sanskrit: 'ये यथा मां प्रपद्यन्ते तांस्तथैव भजाम्यहम् ।\nमम वर्त्मानुवर्तन्ते मनुष्याः पार्थ सर्वशः ॥४.११॥',
      english: 'Krishna responds to people according to the way they approach Him; all ultimately follow His path.',
      gujarati: 'ભગવાન કહે છે કે જે મને જે રીતે ભજે છે, હું તેને તે જ રીતે ફળ આપું છું. બધા લોકો કોઈ ને કોઈ રીતે મારા જ માર્ગે આવે છે.',
      meaningEnglish: 'Key point: Krishna responds to people according to the way they approach Him; all ultimately follow His path.',
      meaningGujarati: 'મુખ્ય વાત: ભગવાન દરેક ભક્તની ભાવના પ્રમાણે તેને ફળ આપે છે.',
    ),
    SacredVerseModel(
      verseNumber: 12,
      sanskrit: 'काङ्क्षन्तः कर्मणां सिद्धिं यजन्त इह देवताः ।\nक्षिप्रं हि मानुषे लोके सिद्धिर्भवति कर्मजा ॥४.१२॥',
      english: 'Those seeking success from their actions worship deities because action-born results can come quickly in the human world.',
      gujarati: 'લોકો કર્મના ફળની ઈચ્છાથી દેવતાઓની પૂજા કરે છે, કારણ કે તેમને ઝડપથી ફળ મળે છે.',
      meaningEnglish: 'Key point: Those seeking success from their actions worship deities because action-born results can come quickly in the human world.',
      meaningGujarati: 'મુખ્ય વાત: ઈચ્છા માટે કરવામાં આવતી ઉપાસના ભૌતિક ફળ આપે છે.',
    ),
    SacredVerseModel(
      verseNumber: 13,
      sanskrit: 'चातुर्वर्ण्यं मया सृष्टं गुणकर्मविभागशः ।\nतस्य कर्तारमपि मां विद्ध्यकर्तारमव्ययम् ॥४.१३॥',
      english: 'Krishna says the fourfold order was created according to qualities and actions, while He Himself remains the imperishable non-doer.',
      gujarati: 'ભગવાને ગુણ અને કર્મના આધારે ચાર વર્ણની વ્યવસ્થા બનાવી છે. છતાં ભગવાન પોતે અકર્તા અને અવિનાશી છે.',
      meaningEnglish: 'Key point: Krishna says the fourfold order was created according to qualities and actions, while He Himself remains the imperishable non-doer.',
      meaningGujarati: 'મુખ્ય વાત: વ્યક્તિનું કાર્ય અને ગુણ તેની ભૂમિકા નક્કી કરે છે.',
    ),
    SacredVerseModel(
      verseNumber: 14,
      sanskrit: 'न मां कर्माणि लिम्पन्ति न मे कर्मफले स्पृहा ।\nइति मां योऽभिजानाति कर्मभिर्न स बध्यते ॥४.१४॥',
      english: 'Actions do not bind Krishna and He has no desire for their fruits; one who knows this is not bound by action.',
      gujarati: 'કર્મો મને બંધન કરતા નથી અને મને કર્મના ફળની ઈચ્છા નથી. જે વ્યક્તિ મને આ રીતે ઓળખે છે તે પણ કર્મના બંધનથી મુક્ત થઈ શકે છે.',
      meaningEnglish: 'Key point: Actions do not bind Krishna and He has no desire for their fruits; one who knows this is not bound by action.',
      meaningGujarati: 'મુખ્ય વાત: કર્મફળની આસક્તિ છોડવાથી બંધન થતું નથી.',
    ),
    SacredVerseModel(
      verseNumber: 15,
      sanskrit: 'एवं ज्ञात्वा कृतं कर्म पूर्वैरपि मुमुक्षुभिः ।\nकुरु कर्मैव तस्मात्त्वं पूर्वैः पूर्वतरं कृतम् ॥४.१५॥',
      english: 'Knowing this, ancient seekers of liberation performed their duties; therefore Arjuna should act as they did.',
      gujarati: 'પ્રાચીન સમયમાં મુમુક્ષુઓએ પણ આ જ્ઞાન સમજીને કર્મ કર્યા હતા. તેથી અર્જુન, તું પણ તેમના પ્રમાણે કર્મ કર.',
      meaningEnglish: 'Key point: Knowing this, ancient seekers of liberation performed their duties; therefore Arjuna should act as they did.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાન સાથે નિષ્કામ કર્મ કરવું જોઈએ.',
    ),
    SacredVerseModel(
      verseNumber: 16,
      sanskrit: 'किं कर्म किमकर्मेति कवयोऽप्यत्र मोहिताः ।\nतत्ते कर्म प्रवक्ष्यामि यज्ज्ञात्वा मोक्ष्यसेऽशुभात् ॥४.१६॥',
      english: 'Even the wise can be confused about action and inaction, so Krishna explains the truth of action by which one can be freed from evil.',
      gujarati: 'કર્મ શું છે અને અકર્મ શું છે તે સમજવામાં બુદ્ધિશાળી લોકો પણ મૂંઝાય છે. તેથી કર્મનું સાચું જ્ઞાન જરૂરી છે.',
      meaningEnglish: 'Key point: Even the wise can be confused about action and inaction, so Krishna explains the truth of action by which one can be freed from evil.',
      meaningGujarati: 'મુખ્ય વાત: કર્મ અને અકર્મનો સાચો ભેદ સમજવો મુશ્કેલ છે.',
    ),
    SacredVerseModel(
      verseNumber: 17,
      sanskrit: 'कर्मणो ह्यपि बोद्धव्यं बोद्धव्यं च विकर्मणः ।\nअकर्मणश्च बोद्धव्यं गहना कर्मणो गतिः ॥४.१७॥',
      english: 'One must understand action, wrong action, and inaction, for the nature and consequences of action are profound.',
      gujarati: 'કર્મ, વિકર્મ અને અકર્મ — આ ત્રણેયને સમજવા જરૂરી છે. કર્મની ગતિ ખૂબ ગહન છે.',
      meaningEnglish: 'Key point: One must understand action, wrong action, and inaction, for the nature and consequences of action are profound.',
      meaningGujarati: 'મુખ્ય વાત: કર્મ = યોગ્ય કાર્ય; વિકર્મ = ખોટું અથવા નિષિદ્ધ કાર્ય; અકર્મ = કર્મમાં આસક્તિનો અભાવ.',
    ),
    SacredVerseModel(
      verseNumber: 18,
      sanskrit: 'कर्मण्यकर्म यः पश्येदकर्मणि च कर्म यः ।\nस बुद्धिमान्मनुष्येषु स युक्तः कृत्स्नकर्मकृत् ॥४.१८॥',
      english: 'One who sees inaction within action and action within inaction is truly wise and disciplined.',
      gujarati: 'જે વ્યક્તિ કર્મમાં અકર્મ અને અકર્મમાં કર્મ જુએ છે, તે સાચો જ્ઞાની છે.',
      meaningEnglish: 'Key point: One who sees inaction within action and action within inaction is truly wise and disciplined.',
      meaningGujarati: 'મુખ્ય વાત: કર્મ કરતાં પણ મનથી નિષ્કામ રહેવું એ જ સાચું જ્ઞાન છે.',
    ),
    SacredVerseModel(
      verseNumber: 19,
      sanskrit: 'यस्य सर्वे समारम्भाः कामसंकल्पवर्जिताः ।\nज्ञानाग्निदग्धकर्माणं तमाहुः पण्डितं बुधाः ॥४.१९॥',
      english: 'The wise call one a sage whose undertakings are free from desire and whose actions are consumed by the fire of knowledge.',
      gujarati: 'જેના બધા કર્મો જ્ઞાનની અગ્નિથી ભસ્મ થઈ ગયા છે અને જે કર્મફળની ઈચ્છા રાખતો નથી, તે જ્ઞાની છે.',
      meaningEnglish: 'Key point: The wise call one a sage whose undertakings are free from desire and whose actions are consumed by the fire of knowledge.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાન કર્મના બંધનને નષ્ટ કરે છે.',
    ),
    SacredVerseModel(
      verseNumber: 20,
      sanskrit: 'त्यक्त्वा कर्मफलासङ्गं नित्यतृप्तो निराश्रयः ।\nकर्मण्यभिप्रवृत्तोऽपि नैव किंचित्करोति सः ॥४.२०॥',
      english: 'One who gives up attachment to results, remains content and self-reliant, is not bound even while acting.',
      gujarati: 'જે કર્મના ફળની આસક્તિ છોડીને ભગવાનમાં સ્થિર રહે છે, તે કર્મ કરતો હોવા છતાં કર્મથી બંધાતો નથી.',
      meaningEnglish: 'Key point: One who gives up attachment to results, remains content and self-reliant, is not bound even while acting.',
      meaningGujarati: 'મુખ્ય વાત: નિષ્કામ કર્મ = કર્મબંધનથી મુક્તિ.',
    ),
    SacredVerseModel(
      verseNumber: 21,
      sanskrit: 'निराशीर्यतचित्तात्मा त्यक्तसर्वपरिग्रहः ।\nशारीरं केवलं कर्म कुर्वन्नाप्नोति किल्बिषम् ॥४.२१॥',
      english: 'One who controls the mind, gives up possessiveness, and performs only necessary bodily duties does not incur sin.',
      gujarati: 'જે વ્યક્તિ પોતાની ઈચ્છાઓ અને ઈન્દ્રિયો પર નિયંત્રણ રાખીને માત્ર કર્તવ્ય કર્મ કરે છે, તે પાપથી બંધાતો નથી.',
      meaningEnglish: 'Key point: One who controls the mind, gives up possessiveness, and performs only necessary bodily duties does not incur sin.',
      meaningGujarati: 'મુખ્ય વાત: જરૂરિયાત મુજબ કરેલું નિષ્કામ કર્મ પાપરૂપ નથી.',
    ),
    SacredVerseModel(
      verseNumber: 22,
      sanskrit: 'यदृच्छालाभसंतुष्टो द्वंद्वातीतो विमत्सरः ।\nसमः सिद्धावसिद्धौ च कृत्वापि न निबध्यते ॥४.२२॥',
      english: 'One who is content with what comes naturally, free from envy and dualities, and equal in success and failure is not bound by action.',
      gujarati: 'જે વ્યક્તિ જે મળે તેમાં સંતોષ રાખે છે, ઈર્ષ્યા કરતો નથી અને સફળતા-નિષ્ફળતામાં સમાન રહે છે, તે કર્મથી બંધાતો નથી.',
      meaningEnglish: 'Key point: One who is content with what comes naturally, free from envy and dualities, and equal in success and failure is not bound by action.',
      meaningGujarati: 'મુખ્ય વાત: સંતોષ + સમત્વ = કર્મબંધનથી મુક્તિ.',
    ),
    SacredVerseModel(
      verseNumber: 23,
      sanskrit: 'गतसङ्गस्य मुक्तस्य ज्ञानावस्थितचेतसः ।\nयज्ञायाचरतः कर्म समग्रं प्रविलीयते ॥४.२३॥',
      english: 'For one who is free from attachment, liberated, and established in knowledge, actions performed in the spirit of sacrifice dissolve.',
      gujarati: 'જે વ્યક્તિ આસક્તિ છોડીને કર્મ કરે છે અને પોતાના બધા કર્મો ભગવાનને અર્પણ કરે છે, તેના કર્મો નષ્ટ થઈ જાય છે.',
      meaningEnglish: 'Key point: For one who is free from attachment, liberated, and established in knowledge, actions performed in the spirit of sacrifice dissolve.',
      meaningGujarati: 'મુખ્ય વાત: કર્મ ભગવાનને અર્પણ કરવાથી કર્મબંધન દૂર થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 24,
      sanskrit: 'ब्रह्मार्पणं ब्रह्महविर्ब्रह्माग्नौ ब्रह्मणा हुतम् ।\nब्रह्मैव तेन गन्तव्यं ब्रह्मकर्मसमाधिना ॥४.२४॥',
      english: 'For one established in Brahman, the offering, the oblation, the fire, and the act of offering are all seen as Brahman.',
      gujarati: 'જે વ્યક્તિ બ્રહ્મમાં સ્થિત રહીને યજ્ઞરૂપે કર્મ કરે છે, તેના માટે અર્પણ કરનાર, અર્પણ અને અગ્નિ — બધું બ્રહ્મરૂપ છે.',
      meaningEnglish: 'Key point: For one established in Brahman, the offering, the oblation, the fire, and the act of offering are all seen as Brahman.',
      meaningGujarati: 'મુખ્ય વાત: સાચા જ્ઞાનીને સમગ્ર જગતમાં બ્રહ્મનું દર્શન થાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 25,
      sanskrit: 'दैवमेवापरे यज्ञं योगिनः पर्युपासते ।\nब्रह्माग्नावपरे यज्ञं यज्ञेनैवोपजुह्वति ॥४.२५॥',
      english: 'Some yogis worship the divine through ritual sacrifice, while others offer the sacrifice itself into the fire of Brahman.',
      gujarati: 'કેટલાક યોગીઓ દેવતાઓની પૂજા યજ્ઞરૂપે કરે છે, જ્યારે કેટલાક જ્ઞાનરૂપી યજ્ઞ દ્વારા પરમાત્માની ઉપાસના કરે છે.',
      meaningEnglish: 'Key point: Some yogis worship the divine through ritual sacrifice, while others offer the sacrifice itself into the fire of Brahman.',
      meaningGujarati: 'મુખ્ય વાત: યજ્ઞના અનેક પ્રકાર છે.',
    ),
    SacredVerseModel(
      verseNumber: 26,
      sanskrit: 'श्रोत्रादीनीन्द्रियाण्यन्ये संयमाग्निषु जुह्वति ।\nशब्दादीन्विषयानन्य इन्द्रियाग्निषु जुह्वति ॥४.२६॥',
      english: 'Some offer the senses into the fire of self-control, while others offer sense objects into the disciplined activity of the senses.',
      gujarati: 'કેટલાક લોકો ઈન્દ્રિયોને સંયમની અગ્નિમાં હોમે છે અને કેટલાક વિષયોને ઈન્દ્રિયોની અગ્નિમાં હોમે છે.',
      meaningEnglish: 'Key point: Some offer the senses into the fire of self-control, while others offer sense objects into the disciplined activity of the senses.',
      meaningGujarati: 'મુખ્ય વાત: ઈન્દ્રિય સંયમ પણ એક પ્રકારનો યજ્ઞ છે.',
    ),
    SacredVerseModel(
      verseNumber: 27,
      sanskrit: 'सर्वाणीन्द्रियकर्माणि प्राणकर्माणि चापरे ।\nआत्मसंयमयोगाग्नौ जुह्वति ज्ञानदीपिते ॥४.२७॥',
      english: 'Some yogis offer the activities of the senses and vital forces into the fire of self-control illuminated by knowledge.',
      gujarati: 'કેટલાક યોગીઓ ઈન્દ્રિયો, પ્રાણ અને મનની ક્રિયાઓને યોગની અગ્નિમાં અર્પણ કરે છે.',
      meaningEnglish: 'Key point: Some yogis offer the activities of the senses and vital forces into the fire of self-control illuminated by knowledge.',
      meaningGujarati: 'મુખ્ય વાત: મન અને ઈન્દ્રિયો પર નિયંત્રણ પણ સાધના છે.',
    ),
    SacredVerseModel(
      verseNumber: 28,
      sanskrit: 'द्रव्ययज्ञास्तपोयज्ञा योगयज्ञास्तथापरे ।\nस्वाध्यायज्ञानयज्ञाश्च यतयः संशितव्रताः ॥४.२८॥',
      english: 'Some practice sacrifice through giving, austerity, yoga, study, and the pursuit of spiritual knowledge.',
      gujarati: 'કેટલાક લોકો દ્રવ્યયજ્ઞ, તપયજ્ઞ, યોગયજ્ઞ અને સ્વાધ્યાય-જ્ઞાનયજ્ઞ કરે છે.',
      meaningEnglish: 'Key point: Some practice sacrifice through giving, austerity, yoga, study, and the pursuit of spiritual knowledge.',
      meaningGujarati: 'મુખ્ય વાત: દાન, તપ, યોગ અને જ્ઞાન — બધા યજ્ઞના સ્વરૂપ છે.',
    ),
    SacredVerseModel(
      verseNumber: 29,
      sanskrit: 'अपाने जुह्वति प्राणं प्राणेऽपानं तथापरे ।\nप्राणापानगती रुद्ध्वा प्राणायामपरायणाः ॥४.२९॥',
      english: 'Some regulate the incoming and outgoing breaths through pranayama, offering one breath into the other.',
      gujarati: 'કેટલાક પ્રાણાયામ દ્વારા પ્રાણ અને અપાન વાયુનું નિયંત્રણ કરે છે.',
      meaningEnglish: 'Key point: Some regulate the incoming and outgoing breaths through pranayama, offering one breath into the other.',
      meaningGujarati: 'મુખ્ય વાત: શ્વાસનું નિયંત્રણ મન અને શરીરને સંયમિત કરવામાં મદદ કરે છે.',
    ),
    SacredVerseModel(
      verseNumber: 30,
      sanskrit: 'अपरे नियताहाराः प्राणान्प्राणेषु जुह्वति ।\nसर्वेऽप्येते यज्ञविदो यज्ञक्षपितकल्मषाः ॥४.३०॥',
      english: 'Others regulate food and offer the vital energies in disciplined practice; all such practitioners are purified through sacrifice.',
      gujarati: 'આ બધા યજ્ઞ કરનાર લોકો પોતાના પાપોનો નાશ કરે છે અને યજ્ઞના અવશેષરૂપ અમૃતનો અનુભવ કરે છે.',
      meaningEnglish: 'Key point: Others regulate food and offer the vital energies in disciplined practice; all such practitioners are purified through sacrifice.',
      meaningGujarati: 'મુખ્ય વાત: યોગ્ય સાધના મનુષ્યને શુદ્ધ કરે છે.',
    ),
    SacredVerseModel(
      verseNumber: 31,
      sanskrit: 'यज्ञशिष्टामृतभुजो यान्ति ब्रह्म सनातनम् ।\nनायं लोकोऽस्त्ययज्ञस्य कुतोऽन्यः कुरुसत्तम ॥४.३૧॥',
      english: 'Those who partake of the remnants of sacrifice attain the eternal Brahman; one who does not perform sacrifice cannot truly prosper even here.',
      gujarati: 'જે લોકો યજ્ઞના અવશેષરૂપ પ્રસાદનો સ્વીકાર કરે છે તેઓ બ્રહ્મને પ્રાપ્ત કરે છે. યજ્ઞ ન કરનાર માટે આ જગત પણ સુખદ નથી.',
      meaningEnglish: 'Key point: Those who partake of the remnants of sacrifice attain the eternal Brahman; one who does not perform sacrifice cannot truly prosper even here.',
      meaningGujarati: 'મુખ્ય વાત: નિષ્કામ યજ્ઞ આધ્યાત્મિક પ્રગતિનું સાધન છે.',
    ),
    SacredVerseModel(
      verseNumber: 32,
      sanskrit: 'एवं बहुविधा यज्ञा वितता ब्रह्मणो मुखे ।\nकर्मजान्विद्धि तान्सर्वानेवं ज्ञात्वा विमोक्ष्यसे ॥४.३૨॥',
      english: 'Many kinds of sacrifice are described in the Vedic teaching; know them all as arising from action, and understanding this brings liberation.',
      gujarati: 'વેદોમાં અનેક પ્રકારના યજ્ઞોનું વર્ણન કરવામાં આવ્યું છે. આ બધા કર્મમાંથી ઉત્પન્ન થાય છે. તેમને સમજવાથી કર્મબંધનથી મુક્તિ મળે છે.',
      meaningEnglish: 'Key point: Many kinds of sacrifice are described in the Vedic teaching; know them all as arising from action, and understanding this brings liberation.',
      meaningGujarati: 'મુખ્ય વાત: યજ્ઞ કર્મ સાથે જોડાયેલો છે અને જ્ઞાનથી કર્મબંધન તૂટે છે.',
    ),
    SacredVerseModel(
      verseNumber: 33,
      sanskrit: 'श्रेयान्द्रव्यमयाद्यज्ञाज्ज्ञानयज्ञः परंतप ।\nसर्वं कर्माखिलं पार्थ ज्ञाने परिसमाप्यते ॥४.३३॥',
      english: 'The sacrifice of knowledge is superior to material sacrifice, because all action ultimately culminates in knowledge.',
      gujarati: 'દ્રવ્યથી કરવામાં આવતા યજ્ઞ કરતાં જ્ઞાનયજ્ઞ શ્રેષ્ઠ છે, કારણ કે બધા કર્મોનું અંતિમ લક્ષ્ય જ્ઞાન છે.',
      meaningEnglish: 'Key point: The sacrifice of knowledge is superior to material sacrifice, because all action ultimately culminates in knowledge.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાનયજ્ઞ સૌથી શ્રેષ્ઠ યજ્ઞ છે.',
    ),
    SacredVerseModel(
      verseNumber: 34,
      sanskrit: 'तद्विद्धि प्रणिपातेन परिप्रश्नेन सेवया ।\nउपदेक्ष्यन्ति ते ज्ञानं ज्ञानिनस्तत्त्वदर्शिनः ॥४.३४॥',
      english: 'Gain knowledge by approaching realized teachers with humility, sincere questions, and service; they will instruct you in truth.',
      gujarati: 'જ્ઞાન મેળવવા માટે જ્ઞાની અને ગુરુ પાસે જઈને વિનમ્રતાથી પ્રશ્નો પૂછવા અને સેવા કરવી જોઈએ. જ્ઞાની વ્યક્તિ સાચું જ્ઞાન આપે છે.',
      meaningEnglish: 'Key point: Gain knowledge by approaching realized teachers with humility, sincere questions, and service; they will instruct you in truth.',
      meaningGujarati: 'મુખ્ય વાત: ગુરુની સેવા + વિનમ્ર પ્રશ્ન + શ્રદ્ધા = જ્ઞાનપ્રાપ્તિ.',
    ),
    SacredVerseModel(
      verseNumber: 35,
      sanskrit: 'यज्ज्ञात्वा न पुनर्मोहमेवं यास्यसि पाण्डव ।\nयेन भूतान्यशेषेण द्रक्ष्यस्यात्मन्यथो मयि ॥४.३૫॥',
      english: 'After gaining this knowledge, you will not fall into the same delusion and will see all beings in the Self and in Krishna.',
      gujarati: 'આ જ્ઞાન પ્રાપ્ત કર્યા પછી ફરીથી મોહમાં પડશો નહીં. આ જ્ઞાનથી તું બધા જીવોને પોતાના આત્મામાં અને ભગવાનમાં જોઈ શકીશ.',
      meaningEnglish: 'Key point: After gaining this knowledge, you will not fall into the same delusion and will see all beings in the Self and in Krishna.',
      meaningGujarati: 'મુખ્ય વાત: સાચું જ્ઞાન ભેદભાવ અને મોહ દૂર કરે છે.',
    ),
    SacredVerseModel(
      verseNumber: 36,
      sanskrit: 'अपि चेदसि पापेभ्यः सर्वेभ्यः पापकृत्तमः ।\nसर्वं ज्ञानप्लवेनैव वृजिनं संतरिष्यसि ॥४.३६॥',
      english: 'Even if you are the greatest sinner, the boat of knowledge can carry you across the ocean of wrongdoing.',
      gujarati: 'તું સૌથી મોટો પાપી હોય તો પણ જ્ઞાનરૂપી નાવ દ્વારા પાપોના સમુદ્રને પાર કરી શકે છે.',
      meaningEnglish: 'Key point: Even if you are the greatest sinner, the boat of knowledge can carry you across the ocean of wrongdoing.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાન પાપોથી મુક્તિ અપાવતું શક્તિશાળી સાધન છે.',
    ),
    SacredVerseModel(
      verseNumber: 37,
      sanskrit: 'यथैधांसि समिद्धोऽग्निर्भस्मसात्कुरुतेऽर्जुन ।\nज्ञानाग्निः सर्वकर्माणि भस्मसात्कुरुते तथा ॥४.३७॥',
      english: 'As fire turns wood to ashes, the fire of knowledge burns all actions and their binding effects.',
      gujarati: 'જેમ અગ્નિ લાકડાને ભસ્મ કરી નાખે છે તેમ જ્ઞાનની અગ્નિ બધા કર્મોને ભસ્મ કરી નાખે છે.',
      meaningEnglish: 'Key point: As fire turns wood to ashes, the fire of knowledge burns all actions and their binding effects.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાન કર્મબંધનનો નાશ કરે છે.',
    ),
    SacredVerseModel(
      verseNumber: 38,
      sanskrit: 'न हि ज्ञानेन सदृशं पवित्रमिह विद्यते ।\nतत्स्वयं योगसंसिद्धः कालेनात्मनि विन्दति ॥४.३८॥',
      english: 'Nothing in this world is as purifying as knowledge; one perfected in yoga gradually realizes it within.',
      gujarati: 'આ જગતમાં જ્ઞાન જેટલું પવિત્ર બીજું કંઈ નથી. યોગમાં સિદ્ધ થયેલો મનુષ્ય સમય જતાં પોતાના અંતરમાં આ જ્ઞાન પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Key point: Nothing in this world is as purifying as knowledge; one perfected in yoga gradually realizes it within.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાન સૌથી પવિત્ર વસ્તુ છે.',
    ),
    SacredVerseModel(
      verseNumber: 39,
      sanskrit: 'श्रद्धावाँल्लभते ज्ञानं तत्परः संयतेन्द्रियः ।\nज्ञानं लब्ध्वा परां शान्तिमचिरेणाधिगच्छति ॥४.३९॥',
      english: 'A faithful person who is dedicated and controls the senses gains knowledge and soon attains supreme peace.',
      gujarati: 'શ્રદ્ધાવાન, ઈન્દ્રિયોને નિયંત્રણમાં રાખનાર અને જ્ઞાન મેળવવા તત્પર વ્યક્તિ જ્ઞાન પ્રાપ્ત કરે છે અને પછી પરમ શાંતિ મેળવે છે.',
      meaningEnglish: 'Key point: A faithful person who is dedicated and controls the senses gains knowledge and soon attains supreme peace.',
      meaningGujarati: 'મુખ્ય વાત: શ્રદ્ધા + સંયમ + જ્ઞાનની ઈચ્છા = શાંતિ.',
    ),
    SacredVerseModel(
      verseNumber: 40,
      sanskrit: 'अज्ञश्चाश्रद्दधानश्च संशयात्मा विनश्यति ।\nनायं लोकोऽस्ति न परो न सुखं संशयात्मनः ॥४.४०॥',
      english: 'The ignorant, faithless, and doubting person cannot find true peace or happiness in this world or beyond.',
      gujarati: 'જે વ્યક્તિ શ્રદ્ધા વગરનો, અજ્ઞાની અને સંશયથી ભરેલો છે તેને શાંતિ મળતી નથી. સંશયી વ્યક્તિનો વિનાશ થાય છે.',
      meaningEnglish: 'Key point: The ignorant, faithless, and doubting person cannot find true peace or happiness in this world or beyond.',
      meaningGujarati: 'મુખ્ય વાત: જીવનમાં સતત શંકા રાખવાથી પ્રગતિ અટકી જાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 41,
      sanskrit: 'योगसंन्यस्तकर्माणं ज्ञानसंछिन्नसंशयम् ।\nआत्मवन्तं न कर्माणि निबध्नन्ति धनंजय ॥४.४१॥',
      english: 'One who has surrendered actions through yoga, cut doubts through knowledge, and is established in the Self is not bound by action.',
      gujarati: 'જે વ્યક્તિ યોગ દ્વારા પોતાના કર્મોનો ત્યાગ કરે છે અને જ્ઞાન દ્વારા પોતાના સંશયો દૂર કરે છે, તેને કર્મો બાંધતા નથી.',
      meaningEnglish: 'Key point: One who has surrendered actions through yoga, cut doubts through knowledge, and is established in the Self is not bound by action.',
      meaningGujarati: 'મુખ્ય વાત: જ્ઞાન અને યોગથી કર્મબંધન તૂટી જાય છે.',
    ),
    SacredVerseModel(
      verseNumber: 42,
      sanskrit: 'तस्मादज्ञानसंभूतं हृत्स्थं ज्ञानासिनात्मनः ।\nछित्त्वैनं संशयं योगमातिष्ठोत्तिष्ठ भारत ॥४.४२॥',
      english: 'Krishna tells Arjuna to cut the doubt born of ignorance with the sword of knowledge, take refuge in yoga, and rise to his duty.',
      gujarati: 'શ્રીકૃષ્ણ અંતમાં અર્જુનને કહે છે કે હૃદયમાં રહેલા અજ્ઞાનજન્ય સંશયને જ્ઞાનની તલવારથી કાપી નાખ અને યોગમાં સ્થિર થઈને ઊભો થા.',
      meaningEnglish: 'Key point: Krishna tells Arjuna to cut the doubt born of ignorance with the sword of knowledge, take refuge in yoga, and rise to his duty.',
      meaningGujarati: 'મુખ્ય વાત: સંશય છોડ, જ્ઞાન પ્રાપ્ત કર અને કર્તવ્ય કર્મ કર.',
    ),
  ];
}
// =====================================================
// BHAGAVAD GITA - CHAPTER 6
// Ātma-Saṃyama Yoga
// 47 VERSES
// Sanskrit verified against a published Devanagari chapter text.
// Gujarati explanations are based on the user's supplied chapter notes.
// =====================================================
static List<SacredVerseModel> _gitaChapter6Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'श्रीभगवानुवाच । अनाश्रितः कर्मफलं कार्यं कर्म करोति यः । स संन्यासी च योगी च न निरग्निर्न चाक्रियः ॥',
      english:
          'The Blessed Lord said: One who performs his prescribed duty without attachment to the results of action is a true renunciant and yogi, not one who merely gives up fire or stops all activity.',
      gujarati:
          'શ્રી ભગવાન કહે છે: જે મનુષ્ય કર્મના ફળની આશા રાખ્યા વગર પોતાનું કર્તવ્ય કર્મ કરે છે, તે જ સાચો સંન્યાસી અને યોગી છે. માત્ર અગ્નિનો ત્યાગ કરનાર કે કર્મ કરવાનું છોડી દેનાર સંન્યાસી કે યોગી નથી.',
      meaningEnglish:
          'True renunciation means performing duty without attachment to its results.',
      meaningGujarati:
          'સાચો સંન્યાસ એટલે કર્મફળની આસક્તિ છોડીને કર્તવ્ય કરવું.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'यं संन्यासमिति प्राहुर्योगं तं विद्धि पाण्डव । न ह्यसंन्यस्तसङ्कल्पो योगी भवति कश्चन ॥',
      english:
          'O Pandava, know that what is called renunciation is indeed Yoga, for no one becomes a yogi without giving up selfish desires and intentions.',
      gujarati:
          'હે પાંડવ! જેને સંન્યાસ કહેવામાં આવે છે તેને જ તું યોગ જાણ. કારણ કે પોતાની સ્વાર્થભરી ઇચ્છાઓ અને સંકલ્પોનો ત્યાગ કર્યા વગર કોઈ મનુષ્ય યોગી બની શકતો નથી.',
      meaningEnglish:
          'Yoga requires freedom from selfish desires and intentions.',
      meaningGujarati:
          'યોગ માટે સ્વાર્થભરી ઇચ્છાઓ અને સંકલ્પોથી મુક્ત થવું જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'आरुरुक्षोर्मुनेर्योगं कर्म कारणमुच्यते । योगारूढस्य तस्यैव शमः कारणमुच्यते ॥',
      english:
          'For a sage who wishes to attain Yoga, action is said to be the means; for one who has attained Yoga, tranquility and cessation of selfish activity are the means.',
      gujarati:
          'જે મુનિ યોગ પ્રાપ્ત કરવા ઇચ્છે છે તેના માટે કર્મ સાધન છે. પરંતુ જે યોગમાં સ્થિર થઈ ગયો છે તેના માટે મનની શાંતિ અને કર્મફળની આસક્તિનો ત્યાગ સાધન છે.',
      meaningEnglish:
          'Action helps the seeker rise toward Yoga, while tranquility supports one established in Yoga.',
      meaningGujarati:
          'સાધક માટે કર્મ યોગ તરફ લઈ જાય છે અને યોગમાં સ્થિર વ્યક્તિ માટે શાંતિ મહત્વપૂર્ણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'यदा हि नेन्द्रियार्थेषु न कर्मस्वनुषज्जते । सर्वसङ्कल्पसन्न्यासी योगारूढस्तदोच्यते ॥',
      english:
          'When a person is no longer attached to sense objects or actions and has renounced all selfish desires, he is said to be established in Yoga.',
      gujarati:
          'જ્યારે મનુષ્ય ઇન્દ્રિયોના વિષયોમાં કે કર્મોમાં આસક્ત રહેતો નથી અને બધા સ્વાર્થભર્યા સંકલ્પોનો ત્યાગ કરે છે, ત્યારે તે યોગમાં સ્થિર થયેલો કહેવાય છે.',
      meaningEnglish:
          'Freedom from attachment establishes a person firmly in Yoga.',
      meaningGujarati:
          'આસક્તિથી મુક્તિ મનુષ્યને યોગમાં સ્થિર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'उद्धरेदात्मनात्मानं नात्मानमवसादयेत् । आत्मैव ह्यात्मनो बन्धुरात्मैव रिपुरात्मनः ॥',
      english:
          'One should uplift oneself by one’s own effort and should not degrade oneself. The self alone is one’s friend and the self alone is one’s enemy.',
      gujarati:
          'મનુષ્યે પોતાના પ્રયત્નથી પોતાનો ઉદ્ધાર કરવો જોઈએ અને પોતાનું પતન કરવું નહીં. કારણ કે મનુષ્ય પોતે જ પોતાનો મિત્ર છે અને પોતે જ પોતાનો શત્રુ છે.',
      meaningEnglish:
          'Self-discipline can uplift a person, while lack of control can become an obstacle.',
      meaningGujarati:
          'આત્મસંયમ મનુષ્યનો ઉદ્ધાર કરે છે અને અસંયમ તેનો અવરોધ બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'बन्धुरात्मात्मनस्तस्य येनात्मैवात्मना जितः । अनात्मनस्तु शत्रुत्वे वर्तेतात्मैव शत्रुवत् ॥',
      english:
          'For one who has conquered the mind, the mind is his best friend. But for one who has failed to control it, the mind acts like an enemy.',
      gujarati:
          'જે મનુષ્યે પોતાના મનને જીતી લીધું છે, તેના માટે મન મિત્ર સમાન છે. પરંતુ જેણે મનને જીતી લીધું નથી, તેના માટે એ જ મન શત્રુની જેમ વર્તે છે.',
      meaningEnglish:
          'A controlled mind becomes a friend; an uncontrolled mind becomes an enemy.',
      meaningGujarati:
          'સંયમિત મન મિત્ર બને છે અને અસંયમિત મન શત્રુ સમાન બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'जितात्मनः प्रशान्तस्य परमात्मा समाहितः । शीतोष्णसुखदुःखेषु तथा मानापमानयोः ॥',
      english:
          'For one who has conquered the mind and attained tranquility, the Supreme Self is steadily realized. Such a person remains equal in cold and heat, pleasure and pain, honor and dishonor.',
      gujarati:
          'જે મનુષ્યે પોતાના મનને જીતી લીધું છે અને શાંત થયો છે, તે પરમાત્મામાં સ્થિર રહે છે. તે ઠંડી-ગરમી, સુખ-દુઃખ અને માન-અપમાનમાં સમભાવ રાખે છે.',
      meaningEnglish:
          'Inner mastery brings steadiness amid opposites.',
      meaningGujarati:
          'મન પર વિજય મેળવવાથી સુખ-દુઃખ અને માન-અપમાનમાં સમભાવ આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'ज्ञानविज्ञानतृप्तात्मा कूटस्थो विजितेन्द्रियः । युक्त इत्युच्यते योगी समलोष्टाश्मकाञ्चनः ॥',
      english:
          'A yogi who is satisfied with knowledge and realization, steadfast, self-controlled, and who sees earth, stone and gold alike is called truly established in Yoga.',
      gujarati:
          'જે યોગી જ્ઞાન અને આત્મસાક્ષાત્કારથી સંતુષ્ટ છે, અડગ છે, ઇન્દ્રિયો પર વિજય મેળવ્યો છે અને માટી, પથ્થર તથા સોનાને સમાન માને છે, તે યુક્ત યોગી કહેવાય છે.',
      meaningEnglish:
          'True Yoga brings knowledge, realization, self-control and equality of vision.',
      meaningGujarati:
          'સાચો યોગ જ્ઞાન, આત્મસાક્ષાત્કાર, ઇન્દ્રિયસંયમ અને સમભાવ આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'सुहृन्मित्रार्युदासीनमध्यस्थद्वेष्यबन्धुषु । साधुष्वपि च पापेषु समबुद्धिर्विशिष्यते ॥',
      english:
          'One who has equal vision toward friends, companions, enemies, neutrals, relatives, saints and sinners is considered superior.',
      gujarati:
          'જે મનુષ્ય મિત્ર, સ્નેહી, શત્રુ, ઉદાસીન, મધ્યસ્થ, દ્વેષ કરનાર, સગાં, સાધુ અને પાપી — સૌ પ્રત્યે સમભાવ રાખે છે, તે શ્રેષ્ઠ છે.',
      meaningEnglish:
          'A mature yogi maintains equal vision toward all kinds of people.',
      meaningGujarati:
          'પરિપક્વ યોગી દરેક વ્યક્તિ પ્રત્યે સમભાવ રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'योगी युञ्जीत सततमात्मानं रहसि स्थितः । एकाकी यतचित्तात्मा निराशीरपरिग्रहः ॥',
      english:
          'A yogi should constantly practice meditation in solitude, alone, with controlled mind and body, free from desires and possessiveness.',
      gujarati:
          'યોગીએ એકાંતમાં રહીને સતત ધ્યાનનો અભ્યાસ કરવો જોઈએ. તેણે મન અને શરીરને વશમાં રાખવાં અને આશા તથા સંગ્રહની ભાવનાથી મુક્ત રહેવું જોઈએ.',
      meaningEnglish:
          'Meditation requires discipline, solitude and freedom from excessive desire and possession.',
      meaningGujarati:
          'ધ્યાન માટે સંયમ, એકાંત અને ઇચ્છા તથા સંગ્રહથી મુક્તિ જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'शुचौ देशे प्रतिष्ठाप्य स्थिरमासनमात्मनः । नात्युच्छ्रितं नातिनीचं चैलाजिनकुशोत्तरम् ॥',
      english:
          'In a clean and sacred place, a yogi should establish a firm seat, neither too high nor too low, covered with cloth, deer skin and kusa grass.',
      gujarati:
          'યોગીએ પવિત્ર અને સ્વચ્છ સ્થળે પોતાનું આસન ગોઠવવું જોઈએ. તે ન તો ખૂબ ઊંચું હોય કે ન ખૂબ નીચું. તેના પર કુશનું ઘાસ, મૃગચર્મ અને વસ્ત્ર રાખવું જોઈએ.',
      meaningEnglish:
          'A suitable and steady place supports meditation practice.',
      meaningGujarati:
          'યોગ માટે યોગ્ય અને સ્થિર આસન ધ્યાનની સાધનામાં સહાયક બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'तत्रैकाग्रं मनः कृत्वा यतचित्तेन्द्रियक्रियः । उपविश्यासने युञ्ज्याद्योगमात्मविशुद्धये ॥',
      english:
          'Sitting there, controlling the mind and senses and concentrating the mind on one point, one should practice yoga for purification of the self.',
      gujarati:
          'ત્યાં બેસીને મન અને ઇન્દ્રિયોની ક્રિયાઓને નિયંત્રિત કરીને મનને એકાગ્ર કરી આત્માની શુદ્ધિ માટે યોગનો અભ્યાસ કરવો જોઈએ.',
      meaningEnglish:
          'Focused meditation helps purify the inner self.',
      meaningGujarati:
          'એકાગ્ર ધ્યાન આંતરિક આત્મશુદ્ધિમાં મદદ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'समं कायशिरोग्रीवं धारयन्नचलं स्थिरः । सम्प्रेक्ष्य नासिकाग्रं स्वं दिशश्चानवलोकयन् ॥',
      english:
          'The yogi should hold the body, head and neck straight and steady, fixing the gaze toward the tip of the nose.',
      gujarati:
          'યોગીએ શરીર, માથું અને ગરદનને સીધી અને સ્થિર રાખવી જોઈએ તથા દૃષ્ટિને નાકના અગ્રભાગ પર સ્થિર રાખવી જોઈએ.',
      meaningEnglish:
          'A steady posture supports concentration during meditation.',
      meaningGujarati:
          'સ્થિર આસન ધ્યાન દરમિયાન એકાગ્રતા જાળવવામાં મદદ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'प्रशान्तात्मा विगतभीर्ब्रह्मचारिव्रते स्थितः । मनः संयम्य मच्चित्तो युक्त आसीत मत्परः ॥',
      english:
          'With a peaceful mind, fearless and established in celibacy, the yogi should control the mind and meditate on Me, having Me as the supreme goal.',
      gujarati:
          'શાંત મનવાળો, નિર્ભય અને બ્રહ્મચર્યના વ્રતમાં સ્થિર યોગી મનને સંયમમાં રાખીને મારામાં ચિત્ત સ્થિર કરી મને પરમ લક્ષ્ય માનીને બેસે.',
      meaningEnglish:
          'Meditation becomes deeper through peace, fearlessness, discipline and devotion.',
      meaningGujarati:
          'શાંતિ, નિર્ભયતા, સંયમ અને ભક્તિથી ધ્યાન વધુ ઊંડું બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'युञ्जन्नेवं सदात्मानं योगी नियतमानसः । शान्तिं निर्वाणपरमां मत्संस्थामधिगच्छति ॥',
      english:
          'Thus constantly controlling the mind, the yogi attains supreme peace and reaches the highest state of liberation in Me.',
      gujarati:
          'આ રીતે સતત મનને નિયંત્રિત કરનાર યોગી પરમ શાંતિ પ્રાપ્ત કરે છે અને મારામાં સ્થિત પરમ મુક્તિ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Steady Yoga leads toward supreme peace and liberation.',
      meaningGujarati:
          'સતત યોગાભ્યાસ પરમ શાંતિ અને મુક્તિ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'नात्यश्नतस्तु योगोऽस्ति न चैकान्तमनश्नतः । न चातिस्वप्नशीलस्य जाग्रतो नैव चार्जुन ॥',
      english:
          'Yoga is not possible for one who eats too much or too little, nor for one who sleeps too much or too little.',
      gujarati:
          'હે અર્જુન! જે બહુ ખાય છે અથવા બિલકુલ ઓછું ખાય છે, જે વધારે ઊંઘે છે અથવા ખૂબ ઓછું ઊંઘે છે, તે યોગી બની શકતો નથી.',
      meaningEnglish:
          'Balance in food and sleep is important for Yoga.',
      meaningGujarati:
          'યોગ માટે આહાર અને ઊંઘમાં સંતુલન જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'युक्ताहारविहारस्य युक्तचेष्टस्य कर्मसु । युक्तस्वप्नावबोधस्य योगो भवति दुःखहा ॥',
      english:
          'Yoga removes suffering for one who is moderate in food, recreation, work, sleep and waking.',
      gujarati:
          'જે મનુષ્ય આહાર, વિહાર, કર્મ, ઊંઘ અને જાગરણમાં યોગ્ય સંયમ રાખે છે, તેનો યોગ દુઃખનો નાશ કરે છે.',
      meaningEnglish:
          'Moderation in daily life supports freedom from suffering.',
      meaningGujarati:
          'દૈનિક જીવનમાં સંયમ દુઃખથી મુક્તિ માટે સહાયક છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'यदा विनियतं चित्तमात्मन्येवावतिष्ठते । निःस्पृहः सर्वकामेभ्यो युक्त इत्युच्यते तदा ॥',
      english:
          'When the controlled mind becomes steady in the Self and is free from all desires, one is said to be established in Yoga.',
      gujarati:
          'જ્યારે સંયમિત મન આત્મામાં જ સ્થિર થઈ જાય છે અને બધી કામનાઓથી મુક્ત થઈ જાય છે, ત્યારે મનુષ્ય યોગમાં સ્થિર કહેવાય છે.',
      meaningEnglish:
          'Steady awareness of the Self is a sign of established Yoga.',
      meaningGujarati:
          'આત્મામાં સ્થિર થયેલું સંયમિત મન યોગની નિશાની છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'यथा दीपो निवातस्थो नेङ्गते सोपमा स्मृता । योगिनो यतचित्तस्य युञ्जतो योगमात्मनः ॥',
      english:
          'As a lamp in a windless place does not flicker, so is the disciplined mind of a yogi absorbed in meditation.',
      gujarati:
          'પવન વિનાના સ્થળે દીવો જેમ સ્થિર રહે છે, તેમ આત્માના ધ્યાનમાં જોડાયેલા સંયમી યોગીનું મન સ્થિર રહે છે.',
      meaningEnglish:
          'A disciplined mind becomes steady like a lamp protected from wind.',
      meaningGujarati:
          'સંયમી મન પવન વિનાના દીવા જેવું સ્થિર બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'यत्रोपरमते चित्तं निरुद्धं योगसेवया । यत्र चैवात्मनात्मानं पश्यन्नात्मनि तुष्यति ॥',
      english:
          'When the mind becomes completely restrained through yoga and one sees the Self through the purified mind and rejoices in the Self, that is the state of yoga.',
      gujarati:
          'યોગના અભ્યાસથી જ્યારે મન સંપૂર્ણ રીતે શાંત થઈ જાય છે અને શુદ્ધ મન દ્વારા આત્માનું દર્શન કરીને આત્મામાં જ આનંદ અનુભવે છે, ત્યારે યોગની પૂર્ણ અવસ્થા પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'The purified mind experiences inner joy through realization of the Self.',
      meaningGujarati:
          'શુદ્ધ મન આત્મસાક્ષાત્કાર દ્વારા આંતરિક આનંદ અનુભવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'सुखमात्यन्तिकं यत्तद्बुद्धिग्राह्यमतीन्द्रियम् । वेत्ति यत्र न चैवायं स्थितश्चलति तत्त्वतः ॥',
      english:
          'In that state, one experiences supreme transcendental happiness, understood by the purified intellect and beyond the senses, and never deviates from the truth.',
      gujarati:
          'તે અવસ્થામાં મનુષ્ય ઇન્દ્રિયોથી પર અને શુદ્ધ બુદ્ધિથી અનુભવાય તેવા પરમ સુખને પ્રાપ્ત કરે છે અને સત્યથી ક્યારેય વિચલિત થતો નથી.',
      meaningEnglish:
          'The yogic state brings happiness beyond ordinary sensory experience.',
      meaningGujarati:
          'યોગની અવસ્થા ઇન્દ્રિયોથી પરનું પરમ સુખ આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'यं लब्ध्वा चापरं लाभं मन्यते नाधिकं ततः । यस्मिन्स्थितो न दुःखेन गुरुणापि विचाल्यते ॥',
      english:
          'Having attained that state, one considers no other gain greater than it and is not shaken even by the greatest sorrow.',
      gujarati:
          'જે પરમ સુખ પ્રાપ્ત કર્યા પછી મનુષ્ય બીજા કોઈ લાભને તેનાથી મોટો માનતો નથી અને ભારેમાં ભારે દુઃખથી પણ વિચલિત થતો નથી.',
      meaningEnglish:
          'Spiritual fulfillment gives stability even in difficult circumstances.',
      meaningGujarati:
          'આધ્યાત્મિક પૂર્ણતા મુશ્કેલ પરિસ્થિતિમાં પણ સ્થિરતા આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'तं विद्याद् दुःखसंयोगवियोगं योगसंज्ञितम् । स निश्चयेन योक्तव्यो योगोऽनिर्विण्णचेतसा ॥',
      english:
          'This state of freedom from union with sorrow is called Yoga. It should be practiced with determination and without losing heart.',
      gujarati:
          'દુઃખના સંયોગથી વિયોગ થવાની અવસ્થાને યોગ કહેવામાં આવે છે. આ યોગનો નિશ્ચયપૂર્વક અને ઉત્સાહપૂર્વક અભ્યાસ કરવો જોઈએ.',
      meaningEnglish:
          'Yoga is practiced with determination to become free from sorrow.',
      meaningGujarati:
          'યોગનો અભ્યાસ નિશ્ચય અને ઉત્સાહથી કરવો જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'सङ्कल्पप्रभवान्कामांस्त्यक्त्वा सर्वानशेषतः । मनसैवेन्द्रियग्रामं विनियम्य समन्ततः ॥',
      english:
          'Abandoning completely all desires born of selfish imagination, one should control all the senses through the mind.',
      gujarati:
          'સંકલ્પમાંથી ઉત્પન્ન થતી બધી કામનાઓનો સંપૂર્ણ ત્યાગ કરીને મન દ્વારા બધી ઇન્દ્રિયોને દરેક રીતે નિયંત્રિત કરવી જોઈએ.',
      meaningEnglish:
          'The seeker gradually becomes free from desires and gains mastery over the senses.',
      meaningGujarati:
          'સાધક ધીમે ધીમે કામનાઓથી મુક્ત થઈ ઇન્દ્રિયો પર સંયમ મેળવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'शनैः शनैरुपरमेद् बुद्ध्या धृतिगृहीतया । आत्मसंस्थं मनः कृत्वा न किञ्चिदपि चिन्तयेत् ॥',
      english:
          'Gradually, with steady determination and intelligence, one should bring the mind under control and fix it in the Self, thinking of nothing else.',
      gujarati:
          'ધીરે ધીરે ધૈર્યવાળી બુદ્ધિથી મનને શાંત કરવું અને મનને આત્મામાં સ્થિર કરીને બીજી કોઈ વસ્તુનું ચિંતન ન કરવું.',
      meaningEnglish:
          'Meditation develops gradually through patience and steady intelligence.',
      meaningGujarati:
          'ધીરજ અને સ્થિર બુદ્ધિથી ધ્યાન ધીમે ધીમે વિકસે છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'यतो यतो निश्चरति मनश्चञ्चलमस्थिरम् । ततस्ततो नियम्यैतदात्मन्येव वशं नयेत् ॥',
      english:
          'Whenever and wherever the restless and unsteady mind wanders, one should bring it back under control and fix it in the Self.',
      gujarati:
          'ચંચળ અને અસ્થિર મન જ્યાં જ્યાં ભટકે ત્યાંથી તેને પાછું ખેંચીને આત્મામાં જ સ્થિર કરવું જોઈએ.',
      meaningEnglish:
          'Whenever the mind wanders, gently bring it back to the Self.',
      meaningGujarati:
          'મન ભટકે ત્યારે તેને ફરીથી આત્મા તરફ સ્થિર કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'प्रशान्तमनसं ह्येनं योगिनं सुखमुत्तमम् । उपैति शान्तरजसं ब्रह्मभूतमकल्मषम् ॥',
      english:
          'Supreme happiness comes to the yogi whose mind is peaceful, whose passions are quieted, and who has become pure and united with Brahman.',
      gujarati:
          'જે યોગીનું મન શાંત છે, રજોગુણ શાંત થયો છે અને જે પાપરહિત બની બ્રહ્મરૂપ થયો છે, તેને પરમ સુખ પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'Peaceful and purified consciousness leads to supreme happiness.',
      meaningGujarati:
          'શાંત અને શુદ્ધ ચિત્ત પરમ સુખ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'युञ्जन्नेवं सदात्मानं योगी विगतकल्मषः । सुखेन ब्रह्मसंस्पर्शमत्यन्तं सुखमश्नुते ॥',
      english:
          'Constantly practicing yoga, the yogi becomes free from impurities and easily experiences the infinite happiness of contact with Brahman.',
      gujarati:
          'આ રીતે સતત યોગનો અભ્યાસ કરનાર પાપરહિત યોગી સરળતાથી બ્રહ્મનો સ્પર્શ કરતું અનંત સુખ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Continuous Yoga practice purifies the seeker and leads to infinite happiness.',
      meaningGujarati:
          'સતત યોગાભ્યાસ સાધકને શુદ્ધ કરીને અનંત સુખ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'सर्वभूतस्थमात्मानं सर्वभूतानि चात्मनि । ईक्षते योगयुक्तात्मा सर्वत्र समदर्शनः ॥',
      english:
          'The yogi who is united with the Self sees the Self in all beings and all beings in the Self, seeing equally everywhere.',
      gujarati:
          'યોગમાં સ્થિર થયેલો સમદર્શી યોગી બધા જીવોમાં આત્માને અને આત્મામાં બધા જીવોને જુએ છે.',
      meaningEnglish:
          'A realized yogi sees the unity of the Self in all beings.',
      meaningGujarati:
          'સાક્ષાત્કારી યોગી બધા જીવોમાં આત્માની એકતા જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'यो मां पश्यति सर्वत्र सर्वं च मयि पश्यति । तस्याहं न प्रणश्यामि स च मे न प्रणश्यति ॥',
      english:
          'One who sees Me everywhere and sees everything in Me is never separated from Me, nor am I ever separated from him.',
      gujarati:
          'જે મનુષ્ય મને સર્વત્ર જુએ છે અને સમગ્ર જગતને મારામાં જુએ છે, તે મારાથી ક્યારેય અલગ થતો નથી અને હું પણ તેનાથી અલગ થતો નથી.',
      meaningEnglish:
          'Seeing the Divine everywhere creates a deep sense of spiritual unity.',
      meaningGujarati:
          'સર્વત્ર દિવ્યતાનું દર્શન આધ્યાત્મિક એકતાનો અનુભવ કરાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 31,
      sanskrit:
          'सर्वभूतस्थितं यो मां भजत्येकत्वमास्थितः । सर्वथा वर्तमानोऽपि स योगी मयि वर्तते ॥',
      english:
          'The yogi who worships Me as present in all beings, knowing their unity, remains always united with Me.',
      gujarati:
          'જે યોગી બધા જીવોમાં મને સ્થિત જાણીને મારી ભક્તિ કરે છે, તે દરેક પરિસ્થિતિમાં મારામાં જ સ્થિત રહે છે.',
      meaningEnglish:
          'Devotion to the Divine present in all beings keeps the yogi united with the Divine.',
      meaningGujarati:
          'બધા જીવોમાં રહેલી દિવ્યતાની ભક્તિ યોગીને પરમાત્મા સાથે જોડે છે.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit:
          'आत्मौपम्येन सर्वत्र समं पश्यति योऽर्जुन । सुखं वा यदि वा दुःखं स योगी परमो मतः ॥',
      english:
          'O Arjuna, the yogi who sees all beings as equal to himself, whether in pleasure or pain, is considered the highest yogi.',
      gujarati:
          'હે અર્જુન! જે યોગી પોતાના જેવા જ બધા જીવોને માને છે અને તેમના સુખ તથા દુઃખને પોતાના સુખ-દુઃખ સમાન જુએ છે, તે શ્રેષ્ઠ યોગી છે.',
      meaningEnglish:
          'The highest yogi feels empathy and equality toward all beings.',
      meaningGujarati:
          'શ્રેષ્ઠ યોગી બધા જીવો પ્રત્યે સમભાવ અને સહાનુભૂતિ રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit:
          'अर्जुन उवाच । योऽयं योगस्त्वया प्रोक्तः साम्येन मधुसूदन । एतस्याहं न पश्यामि चञ्चलत्वात् स्थितिं स्थिराम् ॥',
      english:
          'Arjuna said: O Madhusudana, the system of Yoga You have described seems difficult to practice because the mind is restless and unstable.',
      gujarati:
          'અર્જુન કહે છે: હે મધુસૂદન! તમે જે સમત્વવાળો યોગ કહ્યો છે, તે મનની ચંચળતાને કારણે મને સ્થિર રીતે શક્ય જણાતો નથી.',
      meaningEnglish:
          'Arjuna expresses concern about the difficulty of maintaining mental steadiness.',
      meaningGujarati:
          'અર્જુન મનની ચંચળતાને કારણે યોગમાં સ્થિર રહેવાની મુશ્કેલી વ્યક્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit:
          'चञ्चलं हि मनः कृष्ण प्रमाथि बलवद्दृढम् । तस्याहं निग्रहं मन्ये वायोरिव सुदुष्करम् ॥',
      english:
          'O Krishna, the mind is restless, turbulent, powerful and obstinate. I consider controlling it as difficult as controlling the wind.',
      gujarati:
          'હે કૃષ્ણ! મન ખૂબ ચંચળ, ઉથલપાથલ કરનાર, બળવાન અને હઠી છે. તેને વશમાં કરવું પવનને રોકવા જેટલું મુશ્કેલ લાગે છે.',
      meaningEnglish:
          'Arjuna compares controlling the restless mind to controlling the wind.',
      meaningGujarati:
          'અર્જુન ચંચળ મનને નિયંત્રિત કરવું પવનને રોકવા જેટલું મુશ્કેલ માને છે.',
    ),

    SacredVerseModel(
      verseNumber: 35,
      sanskrit:
          'श्रीभगवानुवाच । असंशयं महाबाहो मनो दुर्निग्रहं चलम् । अभ्यासेन तु कौन्तेय वैराग्येण च गृह्यते ॥',
      english:
          'The Lord said: Undoubtedly the mind is restless and difficult to control, but it can be controlled through practice and detachment.',
      gujarati:
          'શ્રી ભગવાન કહે છે: હે મહાબાહુ! નિઃસંદેહ મન ચંચળ અને વશ કરવું મુશ્કેલ છે, પરંતુ હે કુંતીપુત્ર! અભ્યાસ અને વૈરાગ્ય દ્વારા તેને વશ કરી શકાય છે.',
      meaningEnglish:
          'Practice and detachment are the two key means for controlling the mind.',
      meaningGujarati:
          'મનને વશ કરવા માટે અભ્યાસ અને વૈરાગ્ય મુખ્ય સાધનો છે.',
    ),

    SacredVerseModel(
      verseNumber: 36,
      sanskrit:
          'असंयतात्मना योगो दुष्प्राप इति मे मतिः । वश्यात्मना तु यतता शक्योऽवाप्तुमुपायतः ॥',
      english:
          'Yoga is difficult for one whose mind is uncontrolled, but it can be attained by one who has mastered the mind and strives with the proper method.',
      gujarati:
          'જેનું મન સંયમિત નથી તેના માટે યોગ પ્રાપ્ત કરવો મુશ્કેલ છે. પરંતુ જેણે મનને વશમાં કર્યું છે અને યોગ્ય પ્રયત્ન કરે છે તે યોગ પ્રાપ્ત કરી શકે છે.',
      meaningEnglish:
          'Self-control and proper effort make Yoga attainable.',
      meaningGujarati:
          'આત્મસંયમ અને યોગ્ય પ્રયત્નથી યોગ પ્રાપ્ત કરી શકાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 37,
      sanskrit:
          'अर्जुन उवाच । अयतिः श्रद्धयोपेतो योगाच्चलितमानसः । अप्राप्य योगसंसिद्धिं कां गतिं कृष्ण गच्छति ॥',
      english:
          'Arjuna said: O Krishna, what happens to one who has faith but fails to control himself, whose mind wanders from Yoga and who does not attain perfection?',
      gujarati:
          'અર્જુન પૂછે છે: હે કૃષ્ણ! જે મનુષ્ય શ્રદ્ધાવાળો છે, પરંતુ પોતાના મનને વશ કરી શકતો નથી અને યોગમાંથી વિચલિત થઈ જાય છે તથા યોગની સિદ્ધિ પ્રાપ્ત કરી શકતો નથી, તેનું શું થાય છે?',
      meaningEnglish:
          'Arjuna asks about the destiny of a sincere seeker who does not attain perfection.',
      meaningGujarati:
          'અર્જુન એવા શ્રદ્ધાવાન સાધકનું શું થાય છે તે પૂછે છે જે યોગસિદ્ધિ પ્રાપ્ત કરી શકતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 38,
      sanskrit:
          'कच्चिन्नोभयविभ्रष्टश्छिन्नाभ्रमिव नश्यति । अप्रतिष्ठो महाबाहो विमूढो ब्रह्मणः पथि ॥',
      english:
          'Does such a person, fallen from both paths, perish like a scattered cloud, having no support on the path to Brahman?',
      gujarati:
          'હે મહાબાહુ! શું એવો મનુષ્ય બંને માર્ગોથી ભ્રષ્ટ થઈને, આકાશમાં વિખરાયેલા વાદળની જેમ નાશ પામે છે અને બ્રહ્મના માર્ગમાં આધારવિહોણો બની જાય છે?',
      meaningEnglish:
          'Arjuna wonders whether an unsuccessful seeker loses the benefit of spiritual effort.',
      meaningGujarati:
          'અર્જુન પૂછે છે કે અધૂરો રહેલો આધ્યાત્મિક પ્રયત્ન વ્યર્થ જાય છે કે નહીં.',
    ),

    SacredVerseModel(
      verseNumber: 39,
      sanskrit:
          'एतन्मे संशयं कृष्ण छेत्तुमर्हस्यशेषतः । त्वदन्यः संशयस्यास्य छेत्ता न ह्युपपद्यते ॥',
      english:
          'O Krishna, please completely dispel this doubt of mine. No one other than You can remove this doubt.',
      gujarati:
          'હે કૃષ્ણ! મારા આ સંશયને સંપૂર્ણપણે દૂર કરવા તમે જ યોગ્ય છો, કારણ કે તમારા સિવાય બીજું કોઈ આ સંશય દૂર કરી શકે તેમ નથી.',
      meaningEnglish:
          'Arjuna asks Krishna to completely resolve his doubt.',
      meaningGujarati:
          'અર્જુન શ્રીકૃષ્ણને પોતાના સંશયનું સંપૂર્ણ નિવારણ કરવા વિનંતી કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 40,
      sanskrit:
          'श्रीभगवानुवाच । पार्थ नैवेह नामुत्र विनाशस्तस्य विद्यते । न हि कल्याणकृत्कश्चिद् दुर्गतिं तात गच्छति ॥',
      english:
          'The Lord said: O Partha, such a person is never destroyed, either in this world or the next. One who performs good deeds never meets with an evil destiny.',
      gujarati:
          'શ્રી ભગવાન કહે છે: હે પાર્થ! આવા મનુષ્યનો આ લોકમાં કે પરલોકમાં ક્યારેય નાશ થતો નથી. હે તાત! શુભ કર્મ કરનાર મનુષ્ય ક્યારેય દુર્ગતિને પ્રાપ્ત થતો નથી.',
      meaningEnglish:
          'Sincere spiritual effort is never ultimately lost.',
      meaningGujarati:
          'નિષ્ઠાપૂર્વકનો આધ્યાત્મિક પ્રયત્ન ક્યારેય સંપૂર્ણપણે વ્યર્થ જતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 41,
      sanskrit:
          'प्राप्य पुण्यकृतां लोकानुषित्वा शाश्वतीः समाः । शुचीनां श्रीमतां गेहे योगभ्रष्टोऽभिजायते ॥',
      english:
          'After dwelling for many years in the worlds of the righteous, the unsuccessful yogi is born in the house of the pure and prosperous.',
      gujarati:
          'યોગથી ભ્રષ્ટ થયેલો મનુષ્ય પુણ્યશાળી લોકોના લોકમાં લાંબો સમય રહીને પછી પવિત્ર અને સમૃદ્ધ પરિવારના ઘરમાં જન્મ લે છે.',
      meaningEnglish:
          'The spiritual seeker receives a favorable opportunity for further progress.',
      meaningGujarati:
          'આધ્યાત્મિક સાધકને આગળની પ્રગતિ માટે અનુકૂળ તક મળે છે.',
    ),

    SacredVerseModel(
      verseNumber: 42,
      sanskrit:
          'अथवा योगिनामेव कुले भवति धीमताम् । एतद्धि दुर्लभतरं लोके जन्म यदीदृशम् ॥',
      english:
          'Or he may be born in a family of wise yogis. Such a birth is very rare in this world.',
      gujarati:
          'અથવા તે જ્ઞાની યોગીઓના કુળમાં જન્મ લે છે. આ પ્રકારનો જન્મ આ જગતમાં ખૂબ જ દુર્લભ છે.',
      meaningEnglish:
          'Birth in a spiritually wise family provides a rare opportunity for Yoga.',
      meaningGujarati:
          'જ્ઞાની યોગીઓના પરિવારમાં જન્મ આધ્યાત્મિક પ્રગતિ માટે દુર્લભ તક આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 43,
      sanskrit:
          'तत्र तं बुद्धिसंयोगं लभते पौर्वदेहिकम् । यतते च ततो भूयः संसिद्धौ कुरुनन्दन ॥',
      english:
          'There he regains the spiritual wisdom acquired in his previous body and strives again for perfection.',
      gujarati:
          'હે કુરુનંદન! એવા જન્મમાં તેને પૂર્વજન્મમાં પ્રાપ્ત કરેલું જ્ઞાન ફરીથી પ્રાપ્ત થાય છે અને તે ફરીથી પૂર્ણ સિદ્ધિ માટે પ્રયત્ન કરે છે.',
      meaningEnglish:
          'Previous spiritual progress continues to support the seeker.',
      meaningGujarati:
          'પૂર્વની આધ્યાત્મિક પ્રગતિ સાધકને ફરીથી સિદ્ધિ તરફ આગળ વધવામાં મદદ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 44,
      sanskrit:
          'पूर्वाभ्यासेन तेनैव ह्रियते ह्यवशोऽपि सः । जिज्ञासुरपि योगस्य शब्दब्रह्मातिवर्तते ॥',
      english:
          'By the force of his previous practice, he is naturally drawn toward Yoga, even without conscious effort, and goes beyond the ritualistic principles of scripture.',
      gujarati:
          'પૂર્વજન્મના યોગાભ્યાસના સંસ્કારને કારણે તે મનુષ્ય પોતાની ઇચ્છા વગર પણ યોગ તરફ ખેંચાય છે અને યોગનો જિજ્ઞાસુ બનીને માત્ર વૈદિક કર્મકાંડથી આગળ વધે છે.',
      meaningEnglish:
          'Previous practice naturally draws the seeker back toward Yoga.',
      meaningGujarati:
          'પૂર્વનો યોગાભ્યાસ સાધકને સ્વાભાવિક રીતે ફરી યોગ તરફ આકર્ષે છે.',
    ),

    SacredVerseModel(
      verseNumber: 45,
      sanskrit:
          'प्रयत्नाद्यतमानस्तु योगी संशुद्धकिल्बिषः । अनेकजन्मसंसिद्धस्ततो याति परां गतिम् ॥',
      english:
          'The yogi who strives sincerely, becoming purified of all impurities through many births of practice, ultimately attains the supreme destination.',
      gujarati:
          'જે યોગી પ્રયત્નપૂર્વક સાધના કરે છે અને અનેક જન્મોના અભ્યાસથી પાપોથી શુદ્ધ થઈ જાય છે, તે અંતે પરમ ગતિ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Persistent practice and purification ultimately lead to the supreme destination.',
      meaningGujarati:
          'સતત સાધના અને શુદ્ધિકરણ અંતે પરમ ગતિ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 46,
      sanskrit:
          'तपस्विभ्योऽधिको योगी ज्ञानिभ्योऽपि मतोऽधिकः । कर्मिभ्यश्चाधिको योगी तस्माद्योगी भवार्जुन ॥',
      english:
          'A yogi is superior to ascetics, superior to scholars, and superior to those engaged in fruitive actions. Therefore, O Arjuna, become a yogi.',
      gujarati:
          'યોગી તપસ્વીઓ કરતાં શ્રેષ્ઠ છે, જ્ઞાનીઓ કરતાં પણ શ્રેષ્ઠ છે અને કર્મફળની ઇચ્છાથી કર્મ કરનારાઓ કરતાં પણ શ્રેષ્ઠ છે. તેથી હે અર્જુન! તું યોગી બન.',
      meaningEnglish:
          'Krishna encourages Arjuna to become a yogi through integrated spiritual practice.',
      meaningGujarati:
          'શ્રીકૃષ્ણ અર્જુનને સર્વાંગી આધ્યાત્મિક સાધના દ્વારા યોગી બનવા પ્રેરણા આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 47,
      sanskrit:
          'योगिनामपि सर्वेषां मद्गतेनान्तरात्मना । श्रद्धावान्भजते यो मां स मे युक्ततमो मतः ॥',
      english:
          'Of all yogis, the one who always thinks of Me within himself, has great faith in Me and lovingly serves Me is considered by Me to be the highest yogi.',
      gujarati:
          'બધા યોગીઓમાં જે યોગી શ્રદ્ધાપૂર્વક પોતાના અંતરમાં મારું ચિંતન કરે છે અને પ્રેમથી મારી ભક્તિ કરે છે, તે મારા મત પ્રમાણે સર્વશ્રેષ્ઠ અને પરમ યોગી છે.',
      meaningEnglish:
          'The highest yogi combines meditation, faith and loving devotion to the Divine.',
      meaningGujarati:
          'સર્વશ્રેષ્ઠ યોગી ધ્યાન, શ્રદ્ધા અને પરમાત્માની પ્રેમભક્તિને એકસાથે જીવે છે.',
    ),
  ];
}


  // BHAGAVAD GITA CHAPTER TITLES
  // =====================================================

  static String _gitaChapterTitle(int chapterNumber) {
    const titles = [
      'Arjuna Vishada Yoga',
      'Sankhya Yoga',
      'Karma Yoga',
      'Jnana Karma Sannyasa Yoga',
      'Karma Sannyasa Yoga',
      'Dhyana Yoga',
      'Jnana Vijnana Yoga',
      'Akshara Brahma Yoga',
      'Raja Vidya Raja Guhya Yoga',
      'Vibhuti Yoga',
      'Vishvarupa Darshana Yoga',
      'Bhakti Yoga',
      'Kshetra Kshetrajna Vibhaga Yoga',
      'Gunatraya Vibhaga Yoga',
      'Purushottama Yoga',
      'Daivasura Sampad Vibhaga Yoga',
      'Shraddhatraya Vibhaga Yoga',
      'Moksha Sannyasa Yoga',
    ];

    return titles[chapterNumber - 1];
  }


// =====================================================
// BHAGAVAD GITA - CHAPTER 3
// KARMA YOGA
// 43 VERSES
// =====================================================

static List<SacredVerseModel> _gitaChapter3Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'अर्जुन उवाच ।\n'
          'ज्यायसी चेत्कर्मणस्ते मता बुद्धिर्जनार्दन ।\n'
          'तत्किं कर्मणि घोरे मां नियोजयसि केशव ॥३.१॥',
      english: 'Arjuna said: O Janardana, if knowledge is considered superior to action, then why do You engage me in this terrible action of war?',
      gujarati: 'અર્જુન કહે છે: હે જનાર્દન! જો આપના મતે કર્મ કરતાં જ્ઞાન શ્રેષ્ઠ છે, તો પછી હે કેશવ! મને આ ભયંકર યુદ્ધકર્મમાં શા માટે પ્રવૃત્ત કરો છો?',
      meaningEnglish: 'Arjuna said: O Janardana, if knowledge is considered superior to action, then why do You engage me in this terrible action of war?',
      meaningGujarati: 'અર્જુન કહે છે: હે જનાર્દન! જો આપના મતે કર્મ કરતાં જ્ઞાન શ્રેષ્ઠ છે, તો પછી હે કેશવ! મને આ ભયંકર યુદ્ધકર્મમાં શા માટે પ્રવૃત્ત કરો છો?',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'व्यामिश्रेणेव वाक्येन बुद्धिं मोहयसीव मे ।\n'
          'तदेकं वद निश्चित्य येन श्रेयोऽहमाप्नुयाम् ॥३.२॥',
      english: 'Your words seem to confuse my understanding. Therefore, tell me decisively the one path by which I may attain the highest good.',
      gujarati: 'આપના મિશ્રિત જેવા લાગતા વચનોથી મારી બુદ્ધિ મૂંઝાઈ જાય છે. તેથી મારા માટે જે શ્રેયસ્કર હોય તે એક નિશ્ચિત માર્ગ મને કહો.',
      meaningEnglish: 'Your words seem to confuse my understanding. Therefore, tell me decisively the one path by which I may attain the highest good.',
      meaningGujarati: 'આપના મિશ્રિત જેવા લાગતા વચનોથી મારી બુદ્ધિ મૂંઝાઈ જાય છે. તેથી મારા માટે જે શ્રેયસ્કર હોય તે એક નિશ્ચિત માર્ગ મને કહો.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'श्रीभगवानुवाच ।\n'
          'लोकेऽस्मिन् द्विविधा निष्ठा पुरा प्रोक्ता मयानघ ।\n'
          'ज्ञानयोगेन सांख्यानां कर्मयोगेन योगिनाम् ॥३.३॥',
      english: 'The Blessed Lord said: O sinless Arjuna, I have explained two paths in this world: the path of knowledge for the contemplative and the path of selfless action for the yogis.',
      gujarati: 'શ્રી ભગવાન કહે છે: હે નિષ્પાપ અર્જુન! આ જગતમાં બે પ્રકારની નિષ્ઠા મેં પહેલાં કહી છે—જ્ઞાનયોગ સાંખ્યયોગીઓ માટે અને કર્મયોગ કર્મ કરનાર યોગીઓ માટે.',
      meaningEnglish: 'The Blessed Lord said: O sinless Arjuna, I have explained two paths in this world: the path of knowledge for the contemplative and the path of selfless action for the yogis.',
      meaningGujarati: 'શ્રી ભગવાન કહે છે: હે નિષ્પાપ અર્જુન! આ જગતમાં બે પ્રકારની નિષ્ઠા મેં પહેલાં કહી છે—જ્ઞાનયોગ સાંખ્યયોગીઓ માટે અને કર્મયોગ કર્મ કરનાર યોગીઓ માટે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'न कर्मणामनारम्भान्नैष्कर्म्यं पुरुषोऽश्नुते ।\n' 
          'न च संन्यसनादेव सिद्धिं समधिगच्छति ॥३.४॥',
      english: 'A person does not attain freedom from action merely by avoiding work, nor does one attain perfection merely by renouncing actions.',
      gujarati: 'માત્ર કર્મનો આરંભ ન કરવાથી મનુષ્ય કર્મબંધનથી મુક્ત થતો નથી અને માત્ર કર્મનો ત્યાગ કરવાથી પણ સિદ્ધિ પ્રાપ્ત થતી નથી.',
      meaningEnglish: 'A person does not attain freedom from action merely by avoiding work, nor does one attain perfection merely by renouncing actions.',
      meaningGujarati: 'માત્ર કર્મનો આરંભ ન કરવાથી મનુષ્ય કર્મબંધનથી મુક્ત થતો નથી અને માત્ર કર્મનો ત્યાગ કરવાથી પણ સિદ્ધિ પ્રાપ્ત થતી નથી.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'न हि कश्चित्क्षणमपि जातु तिष्ठत्यकर्मकृत् ।\n' 
          'कार्यते ह्यवशः कर्म सर्वः प्रकृतिजैर्गुणैः ॥३.५॥',
      english: 'No one can remain without performing action even for a moment. Everyone is compelled to act by the qualities of nature.',
      gujarati: 'કોઈ પણ મનુષ્ય એક ક્ષણ પણ કર્મ કર્યા વિના રહી શકતો નથી. પ્રકૃતિના ગુણો દરેક વ્યક્તિને કર્મ કરવા માટે મજબૂર કરે છે.',
      meaningEnglish: 'No one can remain without performing action even for a moment. Everyone is compelled to act by the qualities of nature.',
      meaningGujarati: 'કોઈ પણ મનુષ્ય એક ક્ષણ પણ કર્મ કર્યા વિના રહી શકતો નથી. પ્રકૃતિના ગુણો દરેક વ્યક્તિને કર્મ કરવા માટે મજબૂર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'कर्मेन्द्रियाणि संयम्य य आस्ते मनसा स्मरन् ।\n' 
          'इन्द्रियार्थान्विमूढात्मा मिथ्याचारः स उच्यते ॥३.६॥',
      english: 'One who restrains the organs of action but mentally thinks of sense objects is deluded and is called a hypocrite.',
      gujarati: 'જે મનુષ્ય કર્મેન્દ્રિયોને રોકીને મનમાં ઇન્દ્રિયોના વિષયોનું ચિંતન કરે છે, તે મૂર્ખ અને દંભી કહેવાય છે.',
      meaningEnglish: 'One who restrains the organs of action but mentally thinks of sense objects is deluded and is called a hypocrite.',
      meaningGujarati: 'જે મનુષ્ય કર્મેન્દ્રિયોને રોકીને મનમાં ઇન્દ્રિયોના વિષયોનું ચિંતન કરે છે, તે મૂર્ખ અને દંભી કહેવાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'यस्त्विन्द्रियाणि मनसा नियम्यारभतेऽर्जुन ।\n' 
          'कर्मेन्द्रियैः कर्मयोगमसक्तः स विशिष्यते ॥३.७॥',
      english: 'But, O Arjuna, one who controls the senses with the mind and performs action without attachment is superior.',
      gujarati: 'પરંતુ હે અર્જુન! જે મનુષ્ય મન દ્વારા ઇન્દ્રિયોને વશમાં રાખીને આસક્તિ વિના કર્મયોગ કરે છે, તે શ્રેષ્ઠ છે.',
      meaningEnglish: 'But, O Arjuna, one who controls the senses with the mind and performs action without attachment is superior.',
      meaningGujarati: 'પરંતુ હે અર્જુન! જે મનુષ્ય મન દ્વારા ઇન્દ્રિયોને વશમાં રાખીને આસક્તિ વિના કર્મયોગ કરે છે, તે શ્રેષ્ઠ છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'नियतं कुरु कर्म त्वं कर्म ज्यायो ह्यकर्मणः ।\n' 
          'शरीरयात्रापि च ते न प्रसिद्ध्येदकर्मणः ॥३.८॥',
      english: 'Perform your prescribed duty, for action is better than inaction. Even the maintenance of the body would not be possible through inaction.',
      gujarati: 'તારે નિયત કર્મ કરવું જોઈએ, કારણ કે કર્મ કરવું એ કર્મ ન કરવા કરતાં શ્રેષ્ઠ છે. કર્મ કર્યા વિના શરીરનું જીવનનિર્વાહ પણ શક્ય નથી.',
      meaningEnglish: 'Perform your prescribed duty, for action is better than inaction. Even the maintenance of the body would not be possible through inaction.',
      meaningGujarati: 'તારે નિયત કર્મ કરવું જોઈએ, કારણ કે કર્મ કરવું એ કર્મ ન કરવા કરતાં શ્રેષ્ઠ છે. કર્મ કર્યા વિના શરીરનું જીવનનિર્વાહ પણ શક્ય નથી.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'यज्ञार्थात्कर्मणोऽन्यत्र लोकोऽयं कर्मबन्धनः ।\n' 
          'तदर्थं कर्म कौन्तेय मुक्तसङ्गः समाचर ॥३.९॥',
      english: 'Except for actions performed as sacrifice to the Supreme, all actions cause bondage. Therefore, O son of Kunti, perform your duties without attachment.',
      gujarati: 'યજ્ઞભાવથી કરેલા કર્મ સિવાયનાં બધા કર્મો મનુષ્યને કર્મબંધનમાં બાંધે છે. તેથી હે કુંતીપુત્ર! આસક્તિ છોડીને યજ્ઞભાવથી કર્મ કર.',
      meaningEnglish: 'Except for actions performed as sacrifice to the Supreme, all actions cause bondage. Therefore, O son of Kunti, perform your duties without attachment.',
      meaningGujarati: 'યજ્ઞભાવથી કરેલા કર્મ સિવાયનાં બધા કર્મો મનુષ્યને કર્મબંધનમાં બાંધે છે. તેથી હે કુંતીપુત્ર! આસક્તિ છોડીને યજ્ઞભાવથી કર્મ કર.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'सहयज्ञाः प्रजाः सृष्ट्वा पुरोवाच प्रजापतिः ।\n' 
          'अनेन प्रसविष्यध्वमेष वोऽस्त्विष्टकामधुक् ॥३.१०॥',
      english: 'At the beginning of creation, Prajapati created beings along with sacrifice and said, “By this sacrifice you shall prosper and it will fulfill your righteous desires.”',
      gujarati: 'સૃષ્ટિના આરંભમાં પ્રજાપતિએ યજ્ઞ સાથે પ્રજાની રચના કરીને કહ્યું કે આ યજ્ઞ દ્વારા તમે વૃદ્ધિ પામશો અને તમારી યોગ્ય ઇચ્છાઓ પૂર્ણ થશે.',
      meaningEnglish: 'At the beginning of creation, Prajapati created beings along with sacrifice and said, “By this sacrifice you shall prosper and it will fulfill your righteous desires.”',
      meaningGujarati: 'સૃષ્ટિના આરંભમાં પ્રજાપતિએ યજ્ઞ સાથે પ્રજાની રચના કરીને કહ્યું કે આ યજ્ઞ દ્વારા તમે વૃદ્ધિ પામશો અને તમારી યોગ્ય ઇચ્છાઓ પૂર્ણ થશે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'देवान्भावयतानेन ते देवा भावयन्तु वः ।\n' 
          'परस्परं भावयन्तः श्रेयः परमवाप्स्यथ ॥३.११॥',
      english: 'Nourish the divine forces through sacrifice, and may they nourish you. By mutually supporting one another, you shall attain the highest good.',
      gujarati: 'યજ્ઞ દ્વારા દેવતાઓને પ્રસન્ન કરો અને દેવતાઓ પણ તમને પ્રસન્ન કરે. એકબીજાની ઉન્નતિ કરતાં તમે પરમ કલ્યાણ પ્રાપ્ત કરશો.',
      meaningEnglish: 'Nourish the divine forces through sacrifice, and may they nourish you. By mutually supporting one another, you shall attain the highest good.',
      meaningGujarati: 'યજ્ઞ દ્વારા દેવતાઓને પ્રસન્ન કરો અને દેવતાઓ પણ તમને પ્રસન્ન કરે. એકબીજાની ઉન્નતિ કરતાં તમે પરમ કલ્યાણ પ્રાપ્ત કરશો.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'इष्टान्भोगान्हि वो देवा दास्यन्ते यज्ञभाविताः ।\n' 
          'तैर्दत्तानप्रदायैभ्यो यो भुङ्क्ते स्तेन एव सः ॥३.१२॥',
      english: 'The gods, pleased by sacrifice, will grant you desired necessities. One who enjoys these gifts without offering them back is indeed a thief.',
      gujarati: 'યજ્ઞથી પ્રસન્ન થયેલા દેવતાઓ તમને જરૂરી ભોગ આપશે. પરંતુ દેવતાઓને અર્પણ કર્યા વિના જે તેનો ઉપયોગ કરે છે તે ચોર સમાન છે.',
      meaningEnglish: 'The gods, pleased by sacrifice, will grant you desired necessities. One who enjoys these gifts without offering them back is indeed a thief.',
      meaningGujarati: 'યજ્ઞથી પ્રસન્ન થયેલા દેવતાઓ તમને જરૂરી ભોગ આપશે. પરંતુ દેવતાઓને અર્પણ કર્યા વિના જે તેનો ઉપયોગ કરે છે તે ચોર સમાન છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'यज्ञशिष्टाशिनः सन्तो मुच्यन्ते सर्वकिल्बिषैः ।\n' 
          'भुञ्जते ते त्वघं पापा ये पचन्त्यात्मकारणात् ॥३.१३॥',
      english: 'Those who eat food left after sacrifice are freed from sins, while those who cook only for themselves eat sin.',
      gujarati: 'યજ્ઞમાં અર્પણ કર્યા પછીનું પ્રસાદરૂપ અન્ન ખાનારા સંતો બધા પાપોથી મુક્ત થાય છે. પરંતુ જે લોકો માત્ર પોતાના માટે જ રસોઈ કરે છે તેઓ પાપનું ભોજન કરે છે.',
      meaningEnglish: 'Those who eat food left after sacrifice are freed from sins, while those who cook only for themselves eat sin.',
      meaningGujarati: 'યજ્ઞમાં અર્પણ કર્યા પછીનું પ્રસાદરૂપ અન્ન ખાનારા સંતો બધા પાપોથી મુક્ત થાય છે. પરંતુ જે લોકો માત્ર પોતાના માટે જ રસોઈ કરે છે તેઓ પાપનું ભોજન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'अन्नाद्भवन्ति भूतानि पर्जन्यादन्नसम्भवः ।\n' 
          'यज्ञाद्भवति पर्जन्यो यज्ञः कर्मसमुद्भवः ॥३.१४॥',
      english: 'All living beings arise from food; food comes from rain; rain comes from sacrifice, and sacrifice arises from action.',
      gujarati: 'બધાં જીવો અન્નથી ઉત્પન્ન થાય છે, અન્ન વરસાદથી ઉત્પન્ન થાય છે, વરસાદ યજ્ઞથી થાય છે અને યજ્ઞ કર્મથી ઉત્પન્ન થાય છે.',
      meaningEnglish: 'All living beings arise from food; food comes from rain; rain comes from sacrifice, and sacrifice arises from action.',
      meaningGujarati: 'બધાં જીવો અન્નથી ઉત્પન્ન થાય છે, અન્ન વરસાદથી ઉત્પન્ન થાય છે, વરસાદ યજ્ઞથી થાય છે અને યજ્ઞ કર્મથી ઉત્પન્ન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'कर्म ब्रह्मोद्भवं विद्धि ब्रह्माक्षरसमुद्भवम् ।\n' 
          'तस्मात्सर्वगतं ब्रह्म नित्यं यज्ञे प्रतिष्ठितम् ॥३.१५॥',
      english: 'Know that action arises from the Vedas, and the Vedas arise from the imperishable Supreme. Therefore, the all-pervading Brahman is eternally established in sacrifice.',
      gujarati: 'કર્મ વેદમાંથી ઉત્પન્ન થાય છે અને વેદ અવિનાશી પરમાત્મામાંથી ઉત્પન્ન થયા છે. તેથી સર્વવ્યાપી પરબ્રહ્મ યજ્ઞમાં સદાય પ્રતિષ્ઠિત છે.',
      meaningEnglish: 'Know that action arises from the Vedas, and the Vedas arise from the imperishable Supreme. Therefore, the all-pervading Brahman is eternally established in sacrifice.',
      meaningGujarati: 'કર્મ વેદમાંથી ઉત્પન્ન થાય છે અને વેદ અવિનાશી પરમાત્મામાંથી ઉત્પન્ન થયા છે. તેથી સર્વવ્યાપી પરબ્રહ્મ યજ્ઞમાં સદાય પ્રતિષ્ઠિત છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'एवं प्रवर्तितं चक्रं नानुवर्तयतीह यः ।\n' 
          'अघायुरिन्द्रियारामो मोघं पार्थ स जीवति ॥३.१६॥',
      english: 'One who does not follow this cosmic cycle of sacrifice and action lives in vain, delighting only in the senses.',
      gujarati: 'જે મનુષ્ય આ રીતે ચલાવવામાં આવેલા યજ્ઞચક્રને અનુસરતો નથી અને માત્ર ઇન્દ્રિયસુખમાં મગ્ન રહે છે, તેનું જીવન વ્યર્થ છે.',
      meaningEnglish: 'One who does not follow this cosmic cycle of sacrifice and action lives in vain, delighting only in the senses.',
      meaningGujarati: 'જે મનુષ્ય આ રીતે ચલાવવામાં આવેલા યજ્ઞચક્રને અનુસરતો નથી અને માત્ર ઇન્દ્રિયસુખમાં મગ્ન રહે છે, તેનું જીવન વ્યર્થ છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'यस्त्वात्मरतिरेव स्यादात्मतृप्तश्च मानवः ।\n' 
          'आत्मन्येव च सन्तुष्टस्तस्य कार्यं न विद्यते ॥३.१७॥',
      english: 'But the person who rejoices in the Self, is satisfied in the Self and content in the Self has no obligatory duty.',
      gujarati: 'જે મનુષ્ય આત્મામાં જ આનંદ મેળવે છે, આત્માથી જ સંતુષ્ટ છે અને આત્મામાં જ સંતોષ પામે છે, તેના માટે કોઈ ફરજિયાત કર્મ બાકી રહેતું નથી.',
      meaningEnglish: 'But the person who rejoices in the Self, is satisfied in the Self and content in the Self has no obligatory duty.',
      meaningGujarati: 'જે મનુષ્ય આત્મામાં જ આનંદ મેળવે છે, આત્માથી જ સંતુષ્ટ છે અને આત્મામાં જ સંતોષ પામે છે, તેના માટે કોઈ ફરજિયાત કર્મ બાકી રહેતું નથી.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'नैव तस्य कृतेनार्थो नाकृतेनेह कश्चन ।\n' 
          'न चास्य सर्वभूतेषु कश्चिदर्थव्यपाश्रयः ॥३.१८॥',
      english: 'Such a person has nothing to gain from action or inaction, nor does he depend upon anyone for any purpose.',
      gujarati: 'આવા આત્મજ્ઞાનીને કર્મ કરવાથી કે કર્મ ન કરવાથી કોઈ લાભ કે નુકસાન નથી અને તે કોઈપણ જીવ પર પોતાના સ્વાર્થ માટે આધાર રાખતો નથી.',
      meaningEnglish: 'Such a person has nothing to gain from action or inaction, nor does he depend upon anyone for any purpose.',
      meaningGujarati: 'આવા આત્મજ્ઞાનીને કર્મ કરવાથી કે કર્મ ન કરવાથી કોઈ લાભ કે નુકસાન નથી અને તે કોઈપણ જીવ પર પોતાના સ્વાર્થ માટે આધાર રાખતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'तस्मादसक्तः सततं कार्यं कर्म समाचर ।\n' 
          'असक्तो ह्याचरन्कर्म परं आप्नोति पूरुषः ॥३.१९॥',
      english: 'Therefore, always perform your duty without attachment. By performing action without attachment, a person attains the Supreme.',
      gujarati: 'તેથી આસક્તિ છોડીને હંમેશા પોતાના કર્તવ્યનું પાલન કર. આસક્તિ વિના કર્મ કરવાથી મનુષ્ય પરમાત્માને પ્રાપ્ત કરે છે.',
      meaningEnglish: 'Therefore, always perform your duty without attachment. By performing action without attachment, a person attains the Supreme.',
      meaningGujarati: 'તેથી આસક્તિ છોડીને હંમેશા પોતાના કર્તવ્યનું પાલન કર. આસક્તિ વિના કર્મ કરવાથી મનુષ્ય પરમાત્માને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'कर्मणैव हि संसिद्धिमास्थिता जनकादयः ।\n' 
          'लोकसंग्रहमेवापि संपश्यन्कर्तुमर्हसि ॥३.२०॥',
      english: 'King Janaka and others attained perfection through action alone. You should also perform action for the welfare and guidance of society.',
      gujarati: 'રાજા જનક વગેરે મહાપુરુષોએ કર્મ દ્વારા જ સિદ્ધિ મેળવી હતી. તેથી લોકકલ્યાણ માટે પણ તારે કર્મ કરવું જોઈએ.',
      meaningEnglish: 'King Janaka and others attained perfection through action alone. You should also perform action for the welfare and guidance of society.',
      meaningGujarati: 'રાજા જનક વગેરે મહાપુરુષોએ કર્મ દ્વારા જ સિદ્ધિ મેળવી હતી. તેથી લોકકલ્યાણ માટે પણ તારે કર્મ કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'यद्यदाचरति श्रेष्ठस्तत्तदेवेतरो जनः ।\n' 
          'स यत्प्रमाणं कुरुते लोकस्तदनुवर्तते ॥३.२१॥',
      english: 'Whatever a great person does, ordinary people follow. Whatever standard he establishes, the world follows.',
      gujarati: 'શ્રેષ્ઠ પુરુષ જેવું આચરણ કરે છે, સામાન્ય લોકો પણ તેવું જ કરે છે. તે જે આદર્શ સ્થાપે છે, લોકો તેને અનુસરે છે.',
      meaningEnglish: 'Whatever a great person does, ordinary people follow. Whatever standard he establishes, the world follows.',
      meaningGujarati: 'શ્રેષ્ઠ પુરુષ જેવું આચરણ કરે છે, સામાન્ય લોકો પણ તેવું જ કરે છે. તે જે આદર્શ સ્થાપે છે, લોકો તેને અનુસરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'न मे पार्थास्ति कर्तव्यं त्रिषु लोकेषु किञ्चन ।\n' 
          'नानवाप्तमवाप्तव्यं वर्त एव च कर्मणि ॥३.२२॥',
      english: 'O Arjuna, there is nothing in the three worlds that I must accomplish, nor is there anything unattained that I need to attain. Yet I continue to act.',
      gujarati: 'હે પાર્થ! ત્રણેય લોકમાં મારા માટે કોઈ કર્તવ્ય બાકી નથી અને પ્રાપ્ત કરવાનું પણ કંઈ બાકી નથી, છતાં હું કર્મ કરતો રહું છું.',
      meaningEnglish: 'O Arjuna, there is nothing in the three worlds that I must accomplish, nor is there anything unattained that I need to attain. Yet I continue to act.',
      meaningGujarati: 'હે પાર્થ! ત્રણેય લોકમાં મારા માટે કોઈ કર્તવ્ય બાકી નથી અને પ્રાપ્ત કરવાનું પણ કંઈ બાકી નથી, છતાં હું કર્મ કરતો રહું છું.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'यदि ह्यहं न वर्तेयं जातु कर्मण्यतन्द्रितः ।\n' 
          'मम वर्त्मानुवर्तन्ते मनुष्याः पार्थ सर्वशः ॥३.२३॥',
      english: 'If I ever ceased to perform action, people would follow My path in every way.',
      gujarati: 'જો હું ક્યારેય કર્મ કરવામાં આળસ કરું, તો હે પાર્થ! લોકો દરેક રીતે મારા માર્ગનું અનુસરણ કરશે.',
      meaningEnglish: 'If I ever ceased to perform action, people would follow My path in every way.',
      meaningGujarati: 'જો હું ક્યારેય કર્મ કરવામાં આળસ કરું, તો હે પાર્થ! લોકો દરેક રીતે મારા માર્ગનું અનુસરણ કરશે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'उत्सीदेयुरिमे लोका न कुर्यां कर्म चेदहम् ।\n' 
          'सङ्करस्य च कर्ता स्यामुपहन्यामिमाः प्रजाः ॥३.२४॥',
      english: 'If I did not perform action, these worlds would perish, and I would become the cause of confusion and destruction of society.',
      gujarati: 'જો હું કર્મ ન કરું તો આ બધા લોકો નાશ પામે અને સામાજિક વ્યવસ્થામાં અસ્થિરતા ઊભી થાય તથા પ્રજાનો વિનાશ થાય.',
      meaningEnglish: 'If I did not perform action, these worlds would perish, and I would become the cause of confusion and destruction of society.',
      meaningGujarati: 'જો હું કર્મ ન કરું તો આ બધા લોકો નાશ પામે અને સામાજિક વ્યવસ્થામાં અસ્થિરતા ઊભી થાય તથા પ્રજાનો વિનાશ થાય.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'सक्ताः कर्मण्यविद्वांसो यथा कुर्वन्ति भारत ।\n' 
          'कुर्याद्विद्वांस्तथासक्तश्चिकीर्षुर्लोकसंग्रहम् ॥३.२५॥',
      english: 'The ignorant perform actions with attachment. The wise should perform actions without attachment, for the welfare of society.',
      gujarati: 'હે ભારત! અજ્ઞાની લોકો આસક્તિથી કર્મ કરે છે. તેવી જ રીતે જ્ઞાની મનુષ્યે પણ આસક્તિ વિના લોકકલ્યાણની ભાવનાથી કર્મ કરવું જોઈએ.',
      meaningEnglish: 'The ignorant perform actions with attachment. The wise should perform actions without attachment, for the welfare of society.',
      meaningGujarati: 'હે ભારત! અજ્ઞાની લોકો આસક્તિથી કર્મ કરે છે. તેવી જ રીતે જ્ઞાની મનુષ્યે પણ આસક્તિ વિના લોકકલ્યાણની ભાવનાથી કર્મ કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'न बुद्धिभेदं जनयेदज्ञानां कर्मसङ्गिनाम् ।\n' 
          'जोषयेत्सर्वकर्माणि विद्वान्युक्तः समाचरन् ॥३.२६॥',
      english: 'The wise should not disturb the understanding of ignorant people attached to action. Instead, they should inspire them to perform their duties properly.',
      gujarati: 'જ્ઞાની મનુષ્યે કર્મમાં આસક્ત અજ્ઞાની લોકોની બુદ્ધિમાં ભ્રમ ઊભો ન કરવો જોઈએ. પોતે યોગ્ય રીતે કર્મ કરીને તેમને પણ કર્મ કરવા પ્રેરવા જોઈએ.',
      meaningEnglish: 'The wise should not disturb the understanding of ignorant people attached to action. Instead, they should inspire them to perform their duties properly.',
      meaningGujarati: 'જ્ઞાની મનુષ્યે કર્મમાં આસક્ત અજ્ઞાની લોકોની બુદ્ધિમાં ભ્રમ ઊભો ન કરવો જોઈએ. પોતે યોગ્ય રીતે કર્મ કરીને તેમને પણ કર્મ કરવા પ્રેરવા જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'प्रकृतेः क्रियमाणानि गुणैः कर्माणि सर्वशः ।\n' 
          'अहङ्कारविमूढात्मा कर्ताहमिति मन्यते ॥३.२७॥',
      english: 'All actions are performed by the three qualities of nature, but a person deluded by ego thinks, “I am the doer.”',
      gujarati: 'બધાં કર્મો પ્રકૃતિના ત્રણ ગુણો દ્વારા થાય છે, પરંતુ અહંકારથી મોહિત થયેલો મનુષ્ય “હું કર્તા છું” એવું માને છે.',
      meaningEnglish: 'All actions are performed by the three qualities of nature, but a person deluded by ego thinks, “I am the doer.”',
      meaningGujarati: 'બધાં કર્મો પ્રકૃતિના ત્રણ ગુણો દ્વારા થાય છે, પરંતુ અહંકારથી મોહિત થયેલો મનુષ્ય “હું કર્તા છું” એવું માને છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'तत्त्ववित्तु महाबाहो गुणकर्मविभागयोः ।\n' 
          'गुणा गुणेषु वर्तन्त इति मत्वा न सज्जते ॥३.२८॥',
      english: 'One who knows the truth understands that the qualities of nature act upon the qualities, and therefore does not become attached.',
      gujarati: 'હે મહાબાહુ! તત્ત્વજ્ઞાની જાણે છે કે પ્રકૃતિના ગુણો જ ગુણોમાં કાર્ય કરે છે; તેથી તે આસક્ત થતો નથી.',
      meaningEnglish: 'One who knows the truth understands that the qualities of nature act upon the qualities, and therefore does not become attached.',
      meaningGujarati: 'હે મહાબાહુ! તત્ત્વજ્ઞાની જાણે છે કે પ્રકૃતિના ગુણો જ ગુણોમાં કાર્ય કરે છે; તેથી તે આસક્ત થતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'प्रकृतेर्गुणसम्मूढाः सज्जन्ते गुणकर्मसु ।\n' 
          'तानकृत्स्नविदो मन्दान्कृत्स्नविन्न विचालयेत् ॥३.२९॥',
      english: 'Those deluded by the qualities of nature become attached to their actions. The wise should not disturb such people who lack complete understanding.',
      gujarati: 'પ્રકૃતિના ગુણોથી મોહિત થયેલા લોકો ગુણો અને કર્મોમાં આસક્ત થાય છે. સંપૂર્ણ જ્ઞાન ધરાવનાર જ્ઞાની એવા અજ્ઞાન લોકોને વિચલિત ન કરે.',
      meaningEnglish: 'Those deluded by the qualities of nature become attached to their actions. The wise should not disturb such people who lack complete understanding.',
      meaningGujarati: 'પ્રકૃતિના ગુણોથી મોહિત થયેલા લોકો ગુણો અને કર્મોમાં આસક્ત થાય છે. સંપૂર્ણ જ્ઞાન ધરાવનાર જ્ઞાની એવા અજ્ઞાન લોકોને વિચલિત ન કરે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'मयि सर्वाणि कर्माणि संन्यस्याध्यात्मचेतसा ।\n' 
          'निराशीनिर्ममो भूत्वा युध्यस्व विगतज्वरः ॥३.३०॥',
      english: 'Dedicate all actions to Me, with your mind fixed on the Self. Give up desire and possessiveness, and perform your duty without anxiety.',
      gujarati: 'બધાં કર્મો મને અર્પણ કરીને, આત્મભાવમાં મન સ્થિર રાખીને, આશા અને મમતા છોડીને તથા ચિંતા રહિત થઈને તું યુદ્ધ કર.',
      meaningEnglish: 'Dedicate all actions to Me, with your mind fixed on the Self. Give up desire and possessiveness, and perform your duty without anxiety.',
      meaningGujarati: 'બધાં કર્મો મને અર્પણ કરીને, આત્મભાવમાં મન સ્થિર રાખીને, આશા અને મમતા છોડીને તથા ચિંતા રહિત થઈને તું યુદ્ધ કર.',
    ),

    SacredVerseModel(
      verseNumber: 31,
      sanskrit:
          'ये मे मतमिदं नित्यमनुतिष्ठन्ति मानवाः ।\n' 
          'श्रद्धावन्तोऽनसूयन्तो मुच्यन्ते तेऽपि कर्मभिः ॥३.३१॥',
      english: 'Those who faithfully follow My teaching without envy are freed from the bondage of actions.',
      gujarati: 'જે મનુષ્યો શ્રદ્ધાથી અને દોષદૃષ્ટિ વિના મારા આ ઉપદેશનું સદા પાલન કરે છે, તેઓ પણ કર્મબંધનથી મુક્ત થાય છે.',
      meaningEnglish: 'Those who faithfully follow My teaching without envy are freed from the bondage of actions.',
      meaningGujarati: 'જે મનુષ્યો શ્રદ્ધાથી અને દોષદૃષ્ટિ વિના મારા આ ઉપદેશનું સદા પાલન કરે છે, તેઓ પણ કર્મબંધનથી મુક્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit:
          'ये त्वेतदभ्यसूयन्तो नानुतिष्ठन्ति मे मतम् ।\n' 
          'सर्वज्ञानविमूढांस्तान्विद्धि नष्टानचेतसः ॥३.३२॥',
      english: 'But those who criticize and do not follow this teaching are deluded in all knowledge and are considered lost.',
      gujarati: 'પરંતુ જે લોકો મારા આ મતની નિંદા કરે છે અને તેનું પાલન કરતા નથી, તેમને સર્વજ્ઞાનમાં મૂઢ અને વિનાશ પામેલા સમજવા.',
      meaningEnglish: 'But those who criticize and do not follow this teaching are deluded in all knowledge and are considered lost.',
      meaningGujarati: 'પરંતુ જે લોકો મારા આ મતની નિંદા કરે છે અને તેનું પાલન કરતા નથી, તેમને સર્વજ્ઞાનમાં મૂઢ અને વિનાશ પામેલા સમજવા.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit:
          'सदृशं चेष्टते स्वस्याः प्रकृतेर्ज्ञानवानपि ।\n' 
          'प्रकृतिं यान्ति भूतानि निग्रहः किं करिष्यति ॥३.३३॥',
      english: 'Even a wise person acts according to his own nature. All beings follow their nature; what can mere restraint accomplish?',
      gujarati: 'જ્ઞાની મનુષ્ય પણ પોતાની પ્રકૃતિ પ્રમાણે જ વર્તે છે. બધા જીવો પોતાની પ્રકૃતિને અનુસરે છે; માત્ર બળજબરીથી રોકવાથી શું થશે?',
      meaningEnglish: 'Even a wise person acts according to his own nature. All beings follow their nature; what can mere restraint accomplish?',
      meaningGujarati: 'જ્ઞાની મનુષ્ય પણ પોતાની પ્રકૃતિ પ્રમાણે જ વર્તે છે. બધા જીવો પોતાની પ્રકૃતિને અનુસરે છે; માત્ર બળજબરીથી રોકવાથી શું થશે?',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit:
          'इन्द्रियस्येन्द्रियस्यार्थे रागद्वेषौ व्यवस्थितौ ।\n' 
          'तयोर्न वशमागच्छेत्तौ ह्यस्य परिपन्थिनौ ॥३.३४॥',
      english: 'Attachment and aversion exist toward the objects of each sense. One should not come under their control, because they are obstacles on the spiritual path.',
      gujarati: 'દરેક ઇન્દ્રિયના વિષય પ્રત્યે રાગ અને દ્વેષ રહેલા છે. મનુષ્યે તેમના વશમાં ન થવું જોઈએ, કારણ કે તે બંને તેના માર્ગમાં અવરોધરૂપ છે.',
      meaningEnglish: 'Attachment and aversion exist toward the objects of each sense. One should not come under their control, because they are obstacles on the spiritual path.',
      meaningGujarati: 'દરેક ઇન્દ્રિયના વિષય પ્રત્યે રાગ અને દ્વેષ રહેલા છે. મનુષ્યે તેમના વશમાં ન થવું જોઈએ, કારણ કે તે બંને તેના માર્ગમાં અવરોધરૂપ છે.',
    ),

    SacredVerseModel(
      verseNumber: 35,
      sanskrit:
          'श्रेयान्स्वधर्मो विगुणः परधर्मात्स्वनुष्ठितात् ।\n' 
          'स्वधर्मे निधनं श्रेयः परधर्मो भयावहः ॥३.३५॥',
      english: 'It is better to perform one’s own duty imperfectly than another’s duty perfectly. It is better to die performing one’s own duty; another’s duty is dangerous.',
      gujarati: 'બીજાના ધર્મને સારી રીતે કરવા કરતાં પોતાનો ધર્મ થોડો અપૂર્ણ હોય તો પણ કરવો શ્રેષ્ઠ છે. પોતાના ધર્મમાં મૃત્યુ પણ કલ્યાણકારક છે; બીજાનો ધર્મ ભયજનક છે.',
      meaningEnglish: 'It is better to perform one’s own duty imperfectly than another’s duty perfectly. It is better to die performing one’s own duty; another’s duty is dangerous.',
      meaningGujarati: 'બીજાના ધર્મને સારી રીતે કરવા કરતાં પોતાનો ધર્મ થોડો અપૂર્ણ હોય તો પણ કરવો શ્રેષ્ઠ છે. પોતાના ધર્મમાં મૃત્યુ પણ કલ્યાણકારક છે; બીજાનો ધર્મ ભયજનક છે.',
    ),

    SacredVerseModel(
      verseNumber: 36,
      sanskrit:
          'अर्जुन उवाच ।\n' 
          'अथ केन प्रयुक्तोऽयं पापं चरति पुरुषः ।\n' 
          'अनिच्छन्नपि वार्ष्णेय बलादिव नियोजितः ॥३.३६॥',
      english: 'Arjuna said: O Krishna, what compels a person to commit sin even against his own wishes, as if driven by force?',
      gujarati: 'અર્જુન કહે છે: હે કૃષ્ણ! મનુષ્ય પોતાની ઇચ્છા ન હોવા છતાં જાણે બળજબરીથી શા માટે પાપકર્મ કરે છે?',
      meaningEnglish: 'Arjuna said: O Krishna, what compels a person to commit sin even against his own wishes, as if driven by force?',
      meaningGujarati: 'અર્જુન કહે છે: હે કૃષ્ણ! મનુષ્ય પોતાની ઇચ્છા ન હોવા છતાં જાણે બળજબરીથી શા માટે પાપકર્મ કરે છે?',
    ),

    SacredVerseModel(
      verseNumber: 37,
      sanskrit:
          'श्रीभगवानुवाच ।\n' 
          'काम एष क्रोध एष रजोगुणसमुद्भवः ।\n' 
          'महाशनो महापाप्मा विद्ध्येनमिह वैरिणम् ॥३.३७॥',
      english: 'The Blessed Lord said: It is desire, and from desire arises anger. Born of the quality of passion, it is a great devourer and great sinner. Know it as your enemy.',
      gujarati: 'શ્રી ભગવાન કહે છે: આ કામના છે અને કામનામાંથી ક્રોધ ઉત્પન્ન થાય છે. રજોગુણથી ઉત્પન્ન થયેલી આ કામના અતૃપ્ત અને મહાપાપી છે; તેને પોતાનો શત્રુ જાણ.',
      meaningEnglish: 'The Blessed Lord said: It is desire, and from desire arises anger. Born of the quality of passion, it is a great devourer and great sinner. Know it as your enemy.',
      meaningGujarati: 'શ્રી ભગવાન કહે છે: આ કામના છે અને કામનામાંથી ક્રોધ ઉત્પન્ન થાય છે. રજોગુણથી ઉત્પન્ન થયેલી આ કામના અતૃપ્ત અને મહાપાપી છે; તેને પોતાનો શત્રુ જાણ.',
    ),

    SacredVerseModel(
      verseNumber: 38,
      sanskrit:
          'धूमेनाव्रियते वह्निर्यथादर्शो मलेन च ।\n' 
          'यथोल्बेनावृतो गर्भस्तथा तेनेदमावृतम् ॥३.३८॥',
      english: 'As fire is covered by smoke, a mirror by dust, and an embryo by the womb, so knowledge is covered by desire.',
      gujarati: 'જેમ અગ્નિ ધુમાડાથી, અરીસો ધૂળથી અને ગર્ભ ગર્ભાશયથી ઢંકાયેલો હોય છે, તેમ જ્ઞાન કામનાથી ઢંકાઈ જાય છે.',
      meaningEnglish: 'As fire is covered by smoke, a mirror by dust, and an embryo by the womb, so knowledge is covered by desire.',
      meaningGujarati: 'જેમ અગ્નિ ધુમાડાથી, અરીસો ધૂળથી અને ગર્ભ ગર્ભાશયથી ઢંકાયેલો હોય છે, તેમ જ્ઞાન કામનાથી ઢંકાઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 39,
      sanskrit:
          'आवृतं ज्ञानमेतेन ज्ञानिनो नित्यवैरिणा ।\n' 
          'कामरूपेण कौन्तेय दुष्पूरेणानलेन च ॥३.३९॥',
      english: 'O Arjuna, knowledge is covered by this eternal enemy of the wise—the insatiable fire of desire.',
      gujarati: 'હે કુંતીપુત્ર! જ્ઞાનીનો આ નિત્ય શત્રુ એવી કામના છે, જે ક્યારેય તૃપ્ત થતી નથી અને જ્ઞાનને ઢાંકી દે છે.',
      meaningEnglish: 'O Arjuna, knowledge is covered by this eternal enemy of the wise—the insatiable fire of desire.',
      meaningGujarati: 'હે કુંતીપુત્ર! જ્ઞાનીનો આ નિત્ય શત્રુ એવી કામના છે, જે ક્યારેય તૃપ્ત થતી નથી અને જ્ઞાનને ઢાંકી દે છે.',
    ),

    SacredVerseModel(
      verseNumber: 40,
      sanskrit:
          'इन्द्रियाणि मनो बुद्धिरस्याधिष्ठानमुच्यते ।\n' 
          'एतैर्विमोहयत्येष ज्ञानमावृत्य देहिनम् ॥३.४०॥',
      english: 'The senses, mind and intellect are said to be the seats of desire. Through these, desire deludes the embodied soul by covering knowledge.',
      gujarati: 'ઇન્દ્રિયો, મન અને બુદ્ધિ કામનાના નિવાસસ્થાન કહેવાય છે. આના દ્વારા કામના જ્ઞાનને ઢાંકી મનુષ્યને મોહિત કરે છે.',
      meaningEnglish: 'The senses, mind and intellect are said to be the seats of desire. Through these, desire deludes the embodied soul by covering knowledge.',
      meaningGujarati: 'ઇન્દ્રિયો, મન અને બુદ્ધિ કામનાના નિવાસસ્થાન કહેવાય છે. આના દ્વારા કામના જ્ઞાનને ઢાંકી મનુષ્યને મોહિત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 41,
      sanskrit:
          'तस्मात्त्वमिन्द्रियाण्यादौ नियम्य भरतर्षभ ।\n' 
          'पाप्मानं प्रजहि ह्येनं ज्ञानविज्ञाननाशनम् ॥३.४१॥',
      english: 'Therefore, O best of the Bharatas, first control the senses and destroy this sinful desire, which destroys knowledge and realization.',
      gujarati: 'તેથી હે ભરતશ્રેષ્ઠ! સૌ પ્રથમ ઇન્દ્રિયોને વશમાં કરીને જ્ઞાન અને વિજ્ઞાનનો નાશ કરનાર આ કામનાનો ત્યાગ કર.',
      meaningEnglish: 'Therefore, O best of the Bharatas, first control the senses and destroy this sinful desire, which destroys knowledge and realization.',
      meaningGujarati: 'તેથી હે ભરતશ્રેષ્ઠ! સૌ પ્રથમ ઇન્દ્રિયોને વશમાં કરીને જ્ઞાન અને વિજ્ઞાનનો નાશ કરનાર આ કામનાનો ત્યાગ કર.',
    ),

    SacredVerseModel(
      verseNumber: 42,
      sanskrit:
          'इन्द्रियाणि पराण्याहुरिन्द्रियेभ्यः परं मनः ।\n' 
          'मनसस्तु परा बुद्धिर्यो बुद्धेः परतस्तु सः ॥३.४२॥',
      english: 'The senses are superior to the body; the mind is higher than the senses; the intellect is higher than the mind, and beyond the intellect is the Self.',
      gujarati: 'ઇન્દ્રિયોને શરીર કરતાં શ્રેષ્ઠ માનવામાં આવે છે, ઇન્દ્રિયોથી મન શ્રેષ્ઠ છે, મનથી બુદ્ધિ શ્રેષ્ઠ છે અને બુદ્ધિથી પણ પરમ આત્મા શ્રેષ્ઠ છે.',
      meaningEnglish: 'The senses are superior to the body; the mind is higher than the senses; the intellect is higher than the mind, and beyond the intellect is the Self.',
      meaningGujarati: 'ઇન્દ્રિયોને શરીર કરતાં શ્રેષ્ઠ માનવામાં આવે છે, ઇન્દ્રિયોથી મન શ્રેષ્ઠ છે, મનથી બુદ્ધિ શ્રેષ્ઠ છે અને બુદ્ધિથી પણ પરમ આત્મા શ્રેષ્ઠ છે.',
    ),

    SacredVerseModel(
      verseNumber: 43,
      sanskrit:
          'एवं बुद्धेः परं बुद्ध्वा संस्तभ्यात्मानमात्मना ।\n' 
          'जहि शत्रुं महाबाहो कामरूपं दुरासदम् ॥३.४३॥',
      english: 'Thus knowing the Self to be higher than the intellect, control the mind through the Self and destroy the difficult-to-conquer enemy in the form of desire.',
      gujarati: 'આ રીતે બુદ્ધિથી પરમ આત્માને જાણીને, આત્મબળ દ્વારા મનને વશમાં રાખ અને હે મહાબાહુ! કામનાના રૂપમાં રહેલા દુર્જય શત્રુનો નાશ કર.',
      meaningEnglish: 'Thus knowing the Self to be higher than the intellect, control the mind through the Self and destroy the difficult-to-conquer enemy in the form of desire.',
      meaningGujarati: 'આ રીતે બુદ્ધિથી પરમ આત્માને જાણીને, આત્મબળ દ્વારા મનને વશમાં રાખ અને હે મહાબાહુ! કામનાના રૂપમાં રહેલા દુર્જય શત્રુનો નાશ કર.',
    ),

  ];
}

// =====================================================
// BHAGAVAD GITA - CHAPTER 7
// JNANA VIJNANA YOGA
// =====================================================

static List<SacredVerseModel> _gitaChapter7Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'श्रीभगवानुवाच ।\nमय्यासक्तमनाः पार्थ योगं युञ्जन्मदाश्रयः ।\nअसंशयं समग्रं मां यथा ज्ञास्यसि तच्छृणु ॥',
      english:
          'The Supreme Lord said: O Arjuna, with your mind attached to Me and taking refuge in Me, practice Yoga. Listen to how you can know Me completely and without doubt.',
      gujarati:
          'શ્રી ભગવાન કહે છે: હે પાર્થ! મારામાં મન લગાવીને અને મારો આશ્રય લઈને યોગનો અભ્યાસ કર. હવે તું મને સંપૂર્ણ રીતે અને કોઈ પણ સંશય વિના કેવી રીતે જાણી શકીશ તે સાંભળ.',
      meaningEnglish:
          'The seeker should practice Yoga with devotion and surrender to understand the Divine completely.',
      meaningGujarati:
          'સાધકે ભક્તિ અને શરણાગતિ સાથે યોગનો અભ્યાસ કરીને પરમાત્માને સંપૂર્ણ રીતે સમજવાનો પ્રયત્ન કરવો જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'ज्ञानं तेऽहं सविज्ञानमिदं वक्ष्याम्यशेषतः ।\nयज्ज्ञात्वा नेह भूयोऽन्यज्ज्ञातव्यमवशिष्यते ॥',
      english:
          'I shall explain to you this knowledge along with realization in its entirety. Knowing this, nothing further remains to be known in this world.',
      gujarati:
          'હું તને આ જ્ઞાનને તેના અનુભૂતિરૂપ વિજ્ઞાન સહિત સંપૂર્ણ રીતે સમજાવીશ. જેને જાણ્યા પછી આ દુનિયામાં બીજું કંઈ જાણવાનું બાકી રહેતું નથી.',
      meaningEnglish:
          'True spiritual knowledge becomes complete when intellectual understanding is joined with direct realization.',
      meaningGujarati:
          'સાચું આધ્યાત્મિક જ્ઞાન ત્યારે પૂર્ણ બને છે જ્યારે સમજણ સાથે આત્માનુભૂતિ પણ જોડાય.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'मनुष्याणां सहस्रेषु कश्चिद्यतति सिद्धये ।\nयततामपि सिद्धानां कश्चिन्मां वेत्ति तत्त्वतः ॥',
      english:
          'Among thousands of people, only a few strive for perfection; and among those who strive and attain perfection, hardly anyone truly knows Me.',
      gujarati:
          'હજારો મનુષ્યોમાંથી કોઈ એક જ સિદ્ધિ માટે પ્રયત્ન કરે છે, અને પ્રયત્ન કરીને સિદ્ધ થયેલા મનુષ્યોમાંથી પણ કોઈ એક જ મને તત્ત્વથી ઓળખે છે.',
      meaningEnglish:
          'Deep realization of the Divine is rare and requires sincere spiritual effort.',
      meaningGujarati:
          'પરમાત્માનું તત્ત્વજ્ઞાન દુર્લભ છે અને તેના માટે નિષ્ઠાપૂર્વક આધ્યાત્મિક પ્રયત્ન જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'भूमिरापोऽनलो वायुः खं मनो बुद्धिरेव च ।\nअहङ्कार इतीयं मे भिन्ना प्रकृतिरष्टधा ॥',
      english:
          'Earth, water, fire, air, ether, mind, intellect and ego—these are My eightfold divided material nature.',
      gujarati:
          'પૃથ્વી, જળ, અગ્નિ, વાયુ, આકાશ, મન, બુદ્ધિ અને અહંકાર—આ મારી આઠ પ્રકારની વિભાજિત પ્રકૃતિ છે.',
      meaningEnglish:
          'The material universe is composed of eight aspects of Divine nature.',
      meaningGujarati:
          'ભૌતિક જગત પરમાત્માની આઠ પ્રકારની પ્રકૃતિથી બનેલું છે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'अपरेयमितस्त्वन्यां प्रकृतिं विद्धि मे पराम् ।\nजीवभूतां महाबाहो ययेदं धार्यते जगत् ॥',
      english:
          'This is My lower nature. Know My other, higher nature, O mighty-armed Arjuna, which consists of living beings and by which this universe is sustained.',
      gujarati:
          'હે મહાબાહુ! આ મારી નીચી પ્રકૃતિ છે. હવે મારી બીજી પરા પ્રકૃતિને જાણ, જે જીવરૂપ છે અને જેના દ્વારા આ સમગ્ર જગત ટકેલું છે.',
      meaningEnglish:
          'Beyond material nature exists the higher living principle that sustains the universe.',
      meaningGujarati:
          'ભૌતિક પ્રકૃતિથી પર જીવરૂપ પરા પ્રકૃતિ છે, જે સમગ્ર જગતને ધારણ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'एतद्योनीनि भूतानि सर्वाणीत्युपधारय ।\nअहं कृत्स्नस्य जगतः प्रभवः प्रलयस्तथा ॥',
      english:
          'Know that all beings have these two natures as their source. I am the origin and dissolution of the entire universe.',
      gujarati:
          'આ બંને પ્રકૃતિમાંથી જ બધા જીવો ઉત્પન્ન થાય છે. હું સમગ્ર જગતની ઉત્પત્તિનું અને પ્રલયનું મૂળ કારણ છું.',
      meaningEnglish:
          'The Divine is both the source from which creation arises and the destination into which it dissolves.',
      meaningGujarati:
          'પરમાત્મા સમગ્ર સૃષ્ટિની ઉત્પત્તિ અને પ્રલય બંનેનું મૂળ કારણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'मत्तः परतरं नान्यत्किञ्चिदस्ति धनञ्जय ।\nमयि सर्वमिदं प्रोतं सूत्रे मणिगणा इव ॥',
      english:
          'O Dhananjaya, there is nothing higher than Me. Everything is strung upon Me like pearls on a thread.',
      gujarati:
          'હે ધનંજય! મારાથી શ્રેષ્ઠ બીજું કંઈ જ નથી. જેમ દોરામાં મણકા પરોવાયેલા હોય છે તેમ આ સમગ્ર જગત મારામાં પરોવાયેલું છે.',
      meaningEnglish:
          'The Divine is the ultimate foundation that connects and supports all existence.',
      meaningGujarati:
          'સમગ્ર સૃષ્ટિનું અંતિમ આધાર અને જોડાણ પરમાત્મા છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'रसोऽहमप्सु कौन्तेय प्रभास्मि शशिसूर्ययोः ।\nप्रणवः सर्ववेदेषु शब्दः खे पौरुषं नृषु ॥',
      english:
          'O son of Kunti, I am the taste in water, the light in the sun and moon, the sacred syllable Om in all the Vedas, sound in ether, and ability in human beings.',
      gujarati:
          'હે કૌન્તેય! હું જળમાં રહેલો રસ છું, સૂર્ય અને ચંદ્રમાં રહેલું તેજ છું, બધા વેદોમાં પવિત્ર ૐકાર છું, આકાશમાં શબ્દ છું અને મનુષ્યોમાં પુરુષાર્થ છું.',
      meaningEnglish:
          'The Divine can be recognized through the essential qualities and powers present throughout creation.',
      meaningGujarati:
          'સૃષ્ટિમાં રહેલા વિવિધ ગુણો અને શક્તિઓમાં પરમાત્માની ઉપસ્થિતિ અનુભવી શકાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'पुण्यो गन्धः पृथिव्यां च तेजश्चास्मि विभावसौ ।\nजीवनं सर्वभूतेषु तपश्चास्मि तपस्विषु ॥',
      english:
          'I am the pure fragrance of the earth, the brilliance in fire, the life in all beings, and the austerity of ascetics.',
      gujarati:
          'હું પૃથ્વીમાં રહેલી પવિત્ર સુગંધ છું, અગ્નિમાં રહેલું તેજ છું, બધા જીવોમાં રહેલું જીવન છું અને તપસ્વીઓનું તપ છું.',
      meaningEnglish:
          'The Divine presence is reflected in purity, brilliance, life and sincere spiritual discipline.',
      meaningGujarati:
          'પવિત્રતા, તેજ, જીવન અને સાચી સાધનામાં પરમાત્માની ઉપસ્થિતિ જોવા મળે છે.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'बीजं मां सर्वभूतानां विद्धि पार्थ सनातनम् ।\nबुद्धिर्बुद्धिमतामस्मि तेजस्तेजस्विनामहम् ॥',
      english:
          'O Arjuna, know Me as the eternal seed of all beings. I am the intelligence of the intelligent and the brilliance of the brilliant.',
      gujarati:
          'હે પાર્થ! મને બધા જીવોનું સનાતન બીજ જાણ. હું બુદ્ધિમાનોની બુદ્ધિ અને તેજસ્વીઓનું તેજ છું.',
      meaningEnglish:
          'The Divine is the eternal source of life, intelligence and brilliance.',
      meaningGujarati:
          'પરમાત્મા જીવન, બુદ્ધિ અને તેજનો સનાતન સ્ત્રોત છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'बलं बलवतां चाहं कामरागविवर्जितम् ।\nधर्माविरुद्धो भूतेषु कामोऽस्मि भरतर्षभ ॥',
      english:
          'I am the strength of the strong, free from desire and attachment. O best of the Bharatas, I am the desire in beings that is not contrary to righteousness.',
      gujarati:
          'હે ભરતશ્રેષ્ઠ! હું કામના અને આસક્તિથી રહિત બળવાનનું બળ છું અને પ્રાણીઓમાં ધર્મની વિરુદ્ધ ન હોય તેવી કામના પણ હું જ છું.',
      meaningEnglish:
          'Strength and desire are divine when they remain free from selfish attachment and do not oppose righteousness.',
      meaningGujarati:
          'જ્યારે બળ અને ઇચ્છા સ્વાર્થથી મુક્ત રહીને ધર્મને અનુસરે છે ત્યારે તેમાં દિવ્યતા છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'ये चैव सात्त्विका भावा राजसास्तामसाश्च ये ।\nमत्त एवेति तान्विद्धि न त्वहं तेषु ते मयि ॥',
      english:
          'Know that all states of being arising from goodness, passion and ignorance come from Me. Yet I am not in them; they are in Me.',
      gujarati:
          'સાત્ત્વિક, રાજસિક અને તામસિક જે જે ભાવો છે તે બધા મારાથી જ ઉત્પન્ન થાય છે. પરંતુ હું તેમનામાં બંધાયેલો નથી; તેઓ મારામાં રહેલા છે.',
      meaningEnglish:
          'The three qualities arise from Divine nature, yet the Divine remains beyond their limitations.',
      meaningGujarati:
          'ત્રણેય ગુણો પરમાત્માની પ્રકૃતિમાંથી ઉત્પન્ન થાય છે, પરંતુ પરમાત્મા તેમના બંધનથી પર છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'त्रिभिर्गुणमयैर्भावैरेभिः सर्वमिदं जगत् ।\nमोहितं नाभिजानाति मामेभ्यः परमव्ययम् ॥',
      english:
          'The whole world is deluded by these three qualities of nature and does not know Me, who am beyond them and imperishable.',
      gujarati:
          'આ ત્રણ ગુણોથી બનેલા ભાવોથી આખું જગત મોહિત થયેલું છે. તેથી તે આ ત્રણ ગુણોથી પર એવા અવિનાશી મને ઓળખી શકતું નથી.',
      meaningEnglish:
          'Attachment to the three qualities can hide awareness of the eternal Divine reality.',
      meaningGujarati:
          'ત્રણ ગુણોના મોહમાં ફસાઈ જવાથી મનુષ્ય અવિનાશી પરમાત્માને ઓળખી શકતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'दैवी ह्येषा गुणमयी मम माया दुरत्यया ।\nमामेव ये प्रपद्यन्ते मायामेतां तरन्ति ते ॥',
      english:
          'This divine Maya of Mine, consisting of the three qualities, is difficult to cross. But those who take refuge in Me alone cross over this Maya.',
      gujarati:
          'મારી આ દૈવી ત્રિગુણમયી માયા પાર કરવી ખૂબ મુશ્કેલ છે. પરંતુ જે લોકો માત્ર મારો આશ્રય લે છે તેઓ આ માયાને પાર કરી જાય છે.',
      meaningEnglish:
          'Surrender and devotion provide the way to transcend the illusion created by material nature.',
      meaningGujarati:
          'શરણાગતિ અને ભક્તિ દ્વારા મનુષ્ય માયાના બંધનને પાર કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'न मां दुष्कृतिनो मूढाः प्रपद्यन्ते नराधमाः ।\nमाययापहृतज्ञाना आसुरं भावमाश्रिताः ॥',
      english:
          'The evil-doers, the deluded, the lowest among men, those whose knowledge is stolen by Maya, and those who follow demonic tendencies do not surrender to Me.',
      gujarati:
          'દુષ્ટ કર્મ કરનારા, મૂર્ખ, મનુષ્યોમાં અધમ, માયાથી જેમનું જ્ઞાન હરી લેવાયું છે અને આસુરી ભાવના ધરાવનારા લોકો મને શરણે આવતા નથી.',
      meaningEnglish:
          'Ego, harmful actions and ignorance can prevent a person from turning toward the Divine.',
      meaningGujarati:
          'અહંકાર, દુષ્કર્મ અને અજ્ઞાન મનુષ્યને પરમાત્માની શરણાગતિથી દૂર રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'चतुर्विधा भजन्ते मां जनाः सुकृतिनोऽर्जुन ।\nआर्तो जिज्ञासुरर्थार्थी ज्ञानी च भरतर्षभ ॥',
      english:
          'O Arjuna, four kinds of virtuous people worship Me: the distressed, the seeker of knowledge, the seeker of wealth, and the wise.',
      gujarati:
          'હે અર્જુન! ચાર પ્રકારના પુણ્યશાળી લોકો મારી ભક્તિ કરે છે—દુઃખી, જ્ઞાનની ઇચ્છાવાળા, ધનની ઇચ્છાવાળા અને જ્ઞાની.',
      meaningEnglish:
          'People approach the Divine for different reasons, including relief, knowledge, worldly needs and wisdom.',
      meaningGujarati:
          'લોકો દુઃખ નિવારણ, જ્ઞાન, ભૌતિક જરૂરિયાતો અથવા પરમ જ્ઞાન માટે પરમાત્માની ભક્તિ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'तेषां ज्ञानी नित्ययुक्त एकभक्तिर्विशिष्यते ।\nप्रियो हि ज्ञानिनोऽत्यर्थमहं स च मम प्रियः ॥',
      english:
          'Among these, the wise person who is ever united with Me and devoted exclusively to Me is the best. I am extremely dear to the wise, and he is dear to Me.',
      gujarati:
          'આ ચારેયમાં સતત મારી સાથે જોડાયેલો અને અનન્ય ભક્તિવાળો જ્ઞાની શ્રેષ્ઠ છે. જ્ઞાનીને હું અત્યંત પ્રિય છું અને જ્ઞાની પણ મને પ્રિય છે.',
      meaningEnglish:
          'Selfless wisdom and unwavering devotion represent the highest relationship with the Divine.',
      meaningGujarati:
          'નિષ્કામ જ્ઞાન અને અડગ ભક્તિ પરમાત્મા સાથેના શ્રેષ્ઠ સંબંધનું સ્વરૂપ છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'उदाराः सर्व एवैते ज्ञानी त्वात्मैव मे मतम् ।\nआस्थितः स हि युक्तात्मा मामेवानुत्तमां गतिम् ॥',
      english:
          'All these devotees are noble, but I regard the wise as My very Self, because he, being steadfast in Me, has taken Me as the highest goal.',
      gujarati:
          'આ બધા ભક્તો ઉદાર છે, પરંતુ જ્ઞાની તો મારા મત પ્રમાણે મારા જ સ્વરૂપ સમાન છે. કારણ કે તે મારામાં સ્થિર રહીને મને જ પરમ ગતિ માને છે.',
      meaningEnglish:
          'The wise devotee sees the Divine as the highest and ultimate goal of life.',
      meaningGujarati:
          'જ્ઞાની ભક્ત પરમાત્માને જીવનનું સર્વોચ્ચ અને અંતિમ લક્ષ્ય માને છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'बहूनां जन्मनामन्ते ज्ञानवान्मां प्रपद्यते ।\nवासुदेवः सर्वमिति स महात्मा सुदुर्लभः ॥',
      english:
          'After many births, a person of wisdom surrenders to Me, realizing that Vasudeva is everything. Such a great soul is very rare.',
      gujarati:
          'ઘણા જન્મોના અંતે જ્ઞાની મનુષ્ય મને શરણે આવે છે અને સમજે છે કે “વાસુદેવ જ સર્વ છે.” એવો મહાત્મા ખૂબ જ દુર્લભ છે.',
      meaningEnglish:
          'After deep spiritual growth, wisdom leads the seeker to recognize the Divine as present in everything.',
      meaningGujarati:
          'ગહન આધ્યાત્મિક વિકાસ પછી જ્ઞાની સમજે છે કે સમગ્ર અસ્તિત્વમાં પરમાત્માની જ ઉપસ્થિતિ છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'कामैस्तैस्तैर्हृतज्ञानाः प्रपद्यन्तेऽन्यदेवताः ।\nतं तं नियममास्थाय प्रकृत्या नियताः स्वया ॥',
      english:
          'Those whose knowledge is carried away by various desires worship other deities, following particular rules according to their own nature.',
      gujarati:
          'જુદી જુદી કામનાઓથી જેમનું જ્ઞાન હરી લેવાયું છે તે લોકો પોતાની પ્રકૃતિ પ્રમાણે નિયમોનું પાલન કરીને અન્ય દેવતાઓની શરણ લે છે.',
      meaningEnglish:
          'Desire can redirect spiritual attention toward temporary goals and limited forms of worship.',
      meaningGujarati:
          'કામનાઓ મનુષ્યનું ધ્યાન પરમ લક્ષ્યથી દૂર કરીને નાશવંત ઇચ્છાઓ તરફ દોરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'यो यो यां यां तनुं भक्तः श्रद्धयार्चितुमिच्छति ।\nतस्य तस्याचलां श्रद्धां तामेव विदधाम्यहम् ॥',
      english:
          'Whatever form a devotee desires to worship with faith, I make that faith firm and unwavering.',
      gujarati:
          'જે જે ભક્ત જે જે દેવતાના સ્વરૂપની શ્રદ્ધાથી પૂજા કરવા ઈચ્છે છે, તેની તે શ્રદ્ધાને હું જ સ્થિર કરું છું.',
      meaningEnglish:
          'The Divine supports sincere faith, allowing devotion to become steady according to the seeker’s chosen form.',
      meaningGujarati:
          'પરમાત્મા ભક્તની સાચી શ્રદ્ધાને સ્થિર બનાવે છે અને તેને ભક્તિના માર્ગે આગળ વધારે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'स तया श्रद्धया युक्तस्तस्याराधनमीहते ।\nलभते च ततः कामान्मयैव विहितान् हि तान् ॥',
      english:
          'Endowed with that faith, the devotee worships that deity and obtains the desired results, which are actually granted by Me.',
      gujarati:
          'તે ભક્ત તે શ્રદ્ધાથી યુક્ત થઈને તે દેવતાની આરાધના કરે છે અને પોતાની ઇચ્છિત વસ્તુઓ મેળવે છે; પરંતુ તે ફળો ખરેખર મારા દ્વારા જ આપવામાં આવે છે.',
      meaningEnglish:
          'All results ultimately depend upon the Divine source, even when worship is directed through particular forms.',
      meaningGujarati:
          'ભક્તિનું ફળ અંતે પરમાત્માના જ નિયમ અને કૃપાથી પ્રાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'अन्तवत्तु फलं तेषां तद्भवत्यल्पमेधसाम् ।\nदेवान्देवयजो यान्ति मद्भक्ता यान्ति मामपि ॥',
      english:
          'But the fruits obtained by such people are temporary. Those who worship the gods go to the gods, while My devotees come to Me.',
      gujarati:
          'પરંતુ આવા અલ્પબુદ્ધિવાળા લોકોનાં ફળો નાશવંત હોય છે. દેવોની ભક્તિ કરનારા દેવોને પામે છે અને મારા ભક્તો મને પામે છે.',
      meaningEnglish:
          'Worldly rewards are temporary, while devotion directed toward the Supreme leads to the eternal goal.',
      meaningGujarati:
          'ભૌતિક ફળો નાશવંત છે, જ્યારે પરમાત્માની ભક્તિ શાશ્વત લક્ષ્ય તરફ દોરી જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'अव्यक्तं व्यक्तिमापन्नं मन्यन्ते मामबुद्धयः ।\nपरं भावमजानन्तो ममाव्ययमनुत्तमम् ॥',
      english:
          'The ignorant think that I, who am imperishable and supreme, was formerly unmanifest and have now become manifest. They do not understand My higher nature.',
      gujarati:
          'અજ્ઞાની લોકો મને પહેલાં અવ્યક્ત અને હવે વ્યક્ત થયેલો માને છે. તેઓ મારા અવિનાશી અને સર્વોચ્ચ સ્વરૂપને જાણતા નથી.',
      meaningEnglish:
          'The Divine is eternal and should not be understood merely as a temporary physical manifestation.',
      meaningGujarati:
          'પરમાત્મા શાશ્વત છે અને તેમને માત્ર ભૌતિક સ્વરૂપ પૂરતા સમજવા યોગ્ય નથી.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'नाहं प्रकाशः सर्वस्य योगमायासमावृतः ।\nमूढोऽयं नाभिजानाति लोको मामजमव्ययम् ॥',
      english:
          'I am not manifest to everyone, being covered by My divine Yoga-Maya. The deluded world does not know Me, who am unborn and imperishable.',
      gujarati:
          'હું મારી યોગમાયાથી ઢંકાયેલો હોવાથી દરેકને પ્રગટ થતો નથી. આ મોહિત થયેલું જગત મને અજન્મા અને અવિનાશી તરીકે ઓળખતું નથી.',
      meaningEnglish:
          'Divine reality is not always perceived because worldly illusion obscures deeper spiritual understanding.',
      meaningGujarati:
          'માયાના આવરણને કારણે મનુષ્ય પરમાત્માના અવિનાશી સ્વરૂપને સહજ રીતે જોઈ શકતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'वेदाहं समतीतानि वर्तमानानि चार्जुन ।\nभविष्याणि च भूतानि मां तु वेद न कश्चन ॥',
      english:
          'O Arjuna, I know all beings of the past, present and future, but no one truly knows Me.',
      gujarati:
          'હે અર્જુન! ભૂતકાળમાં થયેલા, વર્તમાનમાં રહેલા અને ભવિષ્યમાં થનારા બધા જીવોને હું જાણું છું, પરંતુ મને કોઈ સંપૂર્ણ રીતે જાણતું નથી.',
      meaningEnglish:
          'The Divine knows the entire flow of existence, while ordinary human knowledge remains limited.',
      meaningGujarati:
          'પરમાત્મા ભૂત, વર્તમાન અને ભવિષ્યના સમગ્ર અસ્તિત્વને જાણે છે, જ્યારે માનવ જ્ઞાન સીમિત છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'इच्छाद्वेषसमुत्थेन द्वन्द्वमोहेन भारत ।\nसर्वभूतानि सम्मोहं सर्गे यान्ति परन्तप ॥',
      english:
          'O Bharata, all beings become deluded at birth by the dualities of desire and hatred.',
      gujarati:
          'હે ભરત! ઈચ્છા અને દ્વેષમાંથી ઉત્પન્ન થતા સુખ-દુઃખ વગેરે દ્વંદ્વોના મોહને કારણે બધા જીવો જન્મથી જ મોહિત થાય છે.',
      meaningEnglish:
          'Desire and aversion create duality and confusion, drawing the mind away from spiritual clarity.',
      meaningGujarati:
          'ઈચ્છા અને દ્વેષ મનમાં દ્વંદ્વ અને મોહ ઉત્પન્ન કરીને આધ્યાત્મિક સ્પષ્ટતા દૂર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'येषां त्वन्तगतं पापं जनानां पुण्यकर्मणाम् ।\nते द्वन्द्वमोहनिर्मुक्ता भजन्ते मां दृढव्रताः ॥',
      english:
          'But those persons of righteous deeds whose sins have been destroyed are freed from the delusion of dualities and worship Me with firm determination.',
      gujarati:
          'જેમના પાપો પુણ્યકર્મોથી નાશ પામ્યા છે એવા મનુષ્યો સુખ-દુઃખના દ્વંદ્વના મોહથી મુક્ત થઈને દૃઢ નિશ્ચયથી મારી ભક્તિ કરે છે.',
      meaningEnglish:
          'Righteous living purifies the mind and helps the seeker become steady in devotion.',
      meaningGujarati:
          'સત્કર્મો મનને શુદ્ધ કરે છે અને સાધકને દૃઢ ભક્તિમાં સ્થિર થવામાં મદદ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'जरामरणमोक्षाय मामाश्रित्य यतन्ति ये ।\nते ब्रह्म तद्विदुः कृत्स्नमध्यात्मं कर्म चाखिलम् ॥',
      english:
          'Those who take refuge in Me and strive for liberation from old age and death know Brahman, the Self, and all action in its entirety.',
      gujarati:
          'જે લોકો વૃદ્ધાવસ્થા અને મૃત્યુમાંથી મુક્તિ મેળવવા મારો આશ્રય લઈને પ્રયત્ન કરે છે, તેઓ બ્રહ્મ, અધ્યાત્મ અને સમગ્ર કર્મને તત્ત્વથી જાણે છે.',
      meaningEnglish:
          'Those who seek liberation through Divine refuge gain deeper understanding of Brahman, the Self and action.',
      meaningGujarati:
          'મુક્તિ માટે પરમાત્માનો આશ્રય લેનાર સાધક બ્રહ્મ, આત્મા અને કર્મના તત્ત્વને સમજવા લાગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'साधिभूताधिदैवं मां साधियज्ञं च ये विदुः ।\nप्रयाणकालेऽपि च मां ते विदुर्युक्तचेतसः ॥',
      english:
          'Those who know Me along with the material world, the divine principles and the principle of sacrifice, and whose minds are united with Me, know Me even at the time of death.',
      gujarati:
          'જે લોકો મને અધિભૂત, અધિદૈવ અને અધિયજ્ઞ સહિત જાણે છે અને જેમનું મન મારામાં જોડાયેલું છે, તેઓ મૃત્યુના સમયે પણ મને તત્ત્વથી જાણે છે.',
      meaningEnglish:
          'A mind united with the Divine can retain spiritual awareness even at the final moment of life.',
      meaningGujarati:
          'પરમાત્મામાં સ્થિર થયેલું મન જીવનના અંતિમ સમયે પણ આધ્યાત્મિક જાગૃતિ જાળવી શકે છે.',
    ),
  ];
}
// =====================================================
// BHAGAVAD GITA - CHAPTER 8
// AKSHARA BRAHMA YOGA
// =====================================================

static List<SacredVerseModel> _gitaChapter8Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'अर्जुन उवाच ।\nकिं तद् ब्रह्म किमध्यात्मं किं कर्म पुरुषोत्तम ।\nअधिभूतं च किं प्रोक्तमधिदैवं किमुच्यते ॥',
      english:
          'Arjuna said: O Supreme Person, what is Brahman? What is Adhyatma? What is Karma? What is called Adhibhuta and what is Adhidaiva?',
      gujarati:
          'અર્જુન કહે છે: હે પુરુષોત્તમ! બ્રહ્મ એટલે શું? અધ્યાત્મ એટલે શું? કર્મ એટલે શું? અધિભૂત અને અધિદૈવ કોને કહે છે?',
      meaningEnglish:
          'Arjuna asks about Brahman, the Self, Karma, the material principle and the divine principle.',
      meaningGujarati:
          'અર્જુન બ્રહ્મ, અધ્યાત્મ, કર્મ, અધિભૂત અને અધિદૈવ જેવા આધ્યાત્મિક તત્ત્વો વિશે પ્રશ્ન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'अधियज्ञः कथं कोऽत्र देहेऽस्मिन्मधुसूदन ।\nप्रयाणकाले च कथं ज्ञेयोऽसि नियतात्मभिः ॥',
      english:
          'O Madhusudana, who is Adhiyajna in this body? How can You be known at the time of death by those who have controlled their minds?',
      gujarati:
          'હે મધુસૂદન! આ દેહમાં અધિયજ્ઞ કોણ છે? અંતકાળે મનને વશમાં રાખનાર યોગીઓ તમને કેવી રીતે જાણી શકે?',
      meaningEnglish:
          'Arjuna asks how the Divine is present as Adhiyajna in the body and how one can remember Him at the time of death.',
      meaningGujarati:
          'અર્જુન પૂછે છે કે દેહમાં અધિયજ્ઞ તરીકે પરમાત્માનું સ્વરૂપ શું છે અને અંતકાળે તેમનું સ્મરણ કેવી રીતે થઈ શકે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'श्रीभगवानुवाच ।\nअक्षरं ब्रह्म परमं स्वभावोऽध्यात्ममुच्यते ।\nभूतभावोद्भवकरो विसर्गः कर्मसंज्ञितः ॥',
      english:
          'The Supreme Lord said: The imperishable Supreme is Brahman. One’s own essential nature is called Adhyatma. The offering that causes the birth of beings is called Karma.',
      gujarati:
          'શ્રી ભગવાન કહે છે: અવિનાશી અને પરમ તત્ત્વ બ્રહ્મ છે. જીવનું પોતાનું સ્વરૂપ અધ્યાત્મ કહેવાય છે. પ્રાણીઓની ઉત્પત્તિ કરનાર વિસર્ગને કર્મ કહેવામાં આવે છે.',
      meaningEnglish:
          'Krishna explains Brahman as the imperishable Supreme, Adhyatma as the essential nature of the self, and Karma as the creative action that brings beings into existence.',
      meaningGujarati:
          'શ્રીકૃષ્ણ બ્રહ્મને અવિનાશી પરમ તત્ત્વ, અધ્યાત્મને જીવનું સ્વરૂપ અને કર્મને જીવોની ઉત્પત્તિ કરનાર ક્રિયા તરીકે સમજાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'अधिभूतं क्षरो भावः पुरुषश्चाधिदैवतम् ।\nअधियज्ञोऽहमेवात्र देहे देहभृतां वर ॥',
      english:
          'The perishable nature is Adhibhuta; the Cosmic Person is Adhidaiva; and I alone am Adhiyajna in this body, O best of embodied beings.',
      gujarati:
          'હે નરશ્રેષ્ઠ! નાશવંત પદાર્થોને અધિભૂત કહે છે. પુરુષ એટલે ચૈતન્ય અધિદૈવ છે. આ દેહમાં રહેલો અધિયજ્ઞ હું જ છું.',
      meaningEnglish:
          'The perishable material world is Adhibhuta, the Cosmic Person is Adhidaiva, and Krishna Himself is Adhiyajna within the body.',
      meaningGujarati:
          'નાશવંત ભૌતિક જગત અધિભૂત છે, ચૈતન્ય પુરુષ અધિદૈવ છે અને દેહમાં રહેલો અધિયજ્ઞ સ્વયં શ્રીકૃષ્ણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'अन्तकाले च मामेव स्मरन्मुक्त्वा कलेवरम् ।\nयः प्रयाति स मद्भावं याति नास्त्यत्र संशयः ॥',
      english:
          'Whoever remembers Me at the time of death and leaves the body attains My nature. Of this there is no doubt.',
      gujarati:
          'જે મનુષ્ય અંતકાળે મારું સ્મરણ કરતાં શરીર છોડે છે, તે નિઃસંદેહ મારા સ્વરૂપને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'A person who remembers the Divine at the final moment attains the Divine state.',
      meaningGujarati:
          'જે મનુષ્ય અંતિમ ક્ષણે પરમાત્માનું સ્મરણ કરીને દેહ છોડે છે તે પરમાત્માના સ્વરૂપને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'यं यं वापि स्मरन्भावं त्यजत्यन्ते कलेवरम् ।\nतं तमेवैति कौन्तेय सदा तद्भावभावितः ॥',
      english:
          'Whatever state of being one remembers at the time of leaving the body, that state one attains, O son of Kunti, having always been absorbed in it.',
      gujarati:
          'હે કૌન્તેય! મનુષ્ય અંતકાળે જે ભાવનું સ્મરણ કરતાં શરીર છોડે છે, તે સતત જે ભાવમાં રહ્યો હોય તે જ ભાવને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'The state of mind at the time of death reflects what one has continually cultivated throughout life.',
      meaningGujarati:
          'મૃત્યુ સમયે મનમાં રહેલો ભાવ આખા જીવન દરમિયાન કરેલા સતત ચિંતન અને આસક્તિનું પરિણામ હોય છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'तस्मात्सर्वेषु कालेषु मामनुस्मर युध्य च ।\nमय्यर्पितमनोबुद्धिर्मामेवैष्यस्यसंशयः ॥',
      english:
          'Therefore, remember Me at all times and fight. With your mind and intellect dedicated to Me, you shall surely attain Me.',
      gujarati:
          'તેથી હે અર્જુન! દરેક સમયે મારું સ્મરણ કર અને યુદ્ધ કર. મન અને બુદ્ધિને મને અર્પણ કરવાથી તું નિશ્ચિતપણે મને પ્રાપ્ત કરીશ.',
      meaningEnglish:
          'Spiritual remembrance should continue while performing one’s duties in life.',
      meaningGujarati:
          'જીવનની પોતાની ફરજો નિભાવતા નિભાવતા પણ સતત પરમાત્માનું સ્મરણ કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'अभ्यासयोगयुक्तेन चेतसा नान्यगामिना ।\nपरमं पुरुषं दिव्यं याति पार्थानुचिन्तयन् ॥',
      english:
          'By practicing Yoga with a mind that does not wander elsewhere, one attains the Supreme Divine Person by constant meditation.',
      gujarati:
          'અનન્ય ચિત્તથી સતત અભ્યાસ કરનાર યોગી પરમ દિવ્ય પુરુષનું ચિંતન કરીને તેને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Constant practice and one-pointed meditation lead the seeker toward the Supreme Divine Person.',
      meaningGujarati:
          'સતત અભ્યાસ અને એકાગ્ર ચિત્તથી પરમ દિવ્ય પુરુષનું ધ્યાન કરવાથી સાધક પરમાત્માને પ્રાપ્ત કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'कविं पुराणमनुशासितारमणोरणीयांसमनुस्मरेद्यः ।\nसर्वस्य धातारमचिन्त्यरूपमादित्यवर्णं तमसः परस्तात् ॥',
      english:
          'One should meditate upon the Omniscient, Ancient, Ruler, subtler than the smallest, Sustainer of all, inconceivable, radiant like the sun and beyond darkness.',
      gujarati:
          'જે સર્વજ્ઞ, પુરાતન, સર્વના શાસક, અણુથી પણ સૂક્ષ્મ, સર્વના ધારણકર્તા, અચિંત્ય સ્વરૂપ અને સૂર્ય સમાન પ્રકાશમાન એવા પરમાત્માનું ધ્યાન કરે છે, તે તેને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'The seeker should meditate upon the eternal, all-knowing and radiant Supreme Reality that sustains everything.',
      meaningGujarati:
          'સાધકે સર્વજ્ઞ, સનાતન, સર્વના ધારણકર્તા અને પ્રકાશસ્વરૂપ પરમાત્માનું ધ્યાન કરવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'प्रयाणकाले मनसाचलेन भक्त्या युक्तो योगबलेन चैव ।\nभ्रुवोर्मध्ये प्राणमावेश्य सम्यक् स तं परं पुरुषमुपैति दिव्यम् ॥',
      english:
          'At the time of death, with an unwavering mind, devotion and the power of Yoga, fixing the life-breath between the eyebrows, one attains the Supreme Divine Person.',
      gujarati:
          'અંતકાળે મનને સ્થિર કરીને ભક્તિ અને યોગબળથી પ્રાણને ભ્રૂમધ્યમાં સ્થિર કરનાર યોગી પરમ દિવ્ય પુરુષને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'A disciplined yogi who remains steady, devoted and focused at the final moment attains the Supreme Divine Person.',
      meaningGujarati:
          'અંતિમ સમયે સ્થિર મન, ભક્તિ અને યોગબળથી ચિત્તને કેન્દ્રિત કરનાર યોગી પરમ દિવ્ય પુરુષને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'यदक्षरं वेदविदो वदन्ति यद् यतयो वीतरागाः ।\nयदिच्छन्तो ब्रह्मचर्यं चरन्ति तत्ते पदं संग्रहेण प्रवक्ष्ये ॥',
      english:
          'I shall briefly explain that imperishable state which the knowers of the Vedas describe, which disciplined sages free from attachment attain, and for which seekers practice celibacy.',
      gujarati:
          'વેદવેત્તાઓ જેને અક્ષર કહે છે અને વીતરાગ સંન્યાસીઓ જેને પ્રાપ્ત કરે છે, તે પદને પ્રાપ્ત કરવા માટે બ્રહ્મચર્ય પાળવામાં આવે છે. તે પરમ પદનું હું સંક્ષેપમાં વર્ણન કરીશ.',
      meaningEnglish:
          'Krishna describes the imperishable Supreme state sought by Vedic knowers and disciplined sages.',
      meaningGujarati:
          'શ્રીકૃષ્ણ તે અવિનાશી પરમ પદનું વર્ણન કરે છે જેને વેદજ્ઞ અને વીતરાગ સાધકો પ્રાપ્ત કરવા ઈચ્છે છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'सर्वद्वाराणि संयम्य मनो हृदि निरुध्य च ।\nमूर्ध्न्याधायात्मनः प्राणमास्थितो योगधारणाम् ॥',
      english:
          'Having restrained all the senses, fixing the mind in the heart and the life-breath in the head, one becomes established in Yoga.',
      gujarati:
          'બધી ઇન્દ્રિયોના દ્વારોને રોકીને, મનને હૃદયમાં સ્થિર કરીને અને પ્રાણને મસ્તકમાં સ્થિર કરીને યોગધારણામાં સ્થિર થવું.',
      meaningEnglish:
          'The yogi withdraws the senses, steadies the mind and concentrates the life force through disciplined Yoga.',
      meaningGujarati:
          'યોગી ઇન્દ્રિયોને સંયમમાં રાખીને મનને સ્થિર કરે છે અને પ્રાણને નિયંત્રિત કરીને યોગમાં સ્થિર થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'ॐ इत्येकाक्षरं ब्रह्म व्याहरन्मामनुस्मरन् ।\nयः प्रयाति त्यजन्देहं स याति परमां गतिम् ॥',
      english:
          'Uttering the single syllable Om, which is Brahman, and remembering Me, one who leaves the body attains the Supreme Goal.',
      gujarati:
          'બ્રહ્મવાચક એકાક્ષર ‘ૐ’નો ઉચ્ચાર કરીને મારું સ્મરણ કરતાં દેહ છોડનાર મનુષ્ય પરમ ગતિને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'Remembering the Divine while chanting the sacred syllable Om leads the seeker toward the Supreme Goal.',
      meaningGujarati:
          'ૐકારનું સ્મરણ અને પરમાત્માનું ચિંતન કરતાં દેહ છોડનાર સાધક પરમ ગતિને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'अनन्यचेताः सततं यो मां स्मरति नित्यशः ।\nतस्याहं सुलभः पार्थ नित्ययुक्तस्य योगिनः ॥',
      english:
          'O Partha, I am easily attainable by that ever-united yogi who constantly remembers Me with an undivided mind.',
      gujarati:
          'હે પાર્થ! જે યોગી અનન્ય ચિત્તથી સદા મારું સ્મરણ કરે છે, તે સદા મારામાં જોડાયેલ હોવાથી મને સહેલાઈથી પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'The Divine is easily attainable for the yogi who remembers Him continuously with exclusive devotion.',
      meaningGujarati:
          'જે યોગી અનન્ય ભક્તિ અને સતત સ્મરણથી પરમાત્મા સાથે જોડાયેલો રહે છે તેને પરમાત્માની પ્રાપ્તિ સરળ બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'मामुपेत्य पुनर्जन्म दुःखालयमशाश्वतम् ।\nनाप्नुवन्ति महात्मानः संसिद्धिं परमां गताः ॥',
      english:
          'Having attained Me, great souls do not again take birth in this temporary abode of suffering, having reached the highest perfection.',
      gujarati:
          'મને પ્રાપ્ત કરેલા મહાત્માઓ ફરીથી દુઃખમય અને અશાશ્વત સંસારમાં જન્મ લેતા નથી.',
      meaningEnglish:
          'Those who attain the Supreme are freed from repeated birth in the temporary world of suffering.',
      meaningGujarati:
          'પરમાત્માને પ્રાપ્ત કરેલા મહાત્માઓ જન્મ-મરણના દુઃખમય અને અશાશ્વત ચક્રમાંથી મુક્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'आब्रह्मभुवनाल्लोकाः पुनरावर्तिनोऽर्जुन ।\nमामुपेत्य तु कौन्तेय पुनर्जन्म न विद्यते ॥',
      english:
          'All worlds up to the realm of Brahma are subject to return, O Arjuna. But after attaining Me, there is no more rebirth.',
      gujarati:
          'હે અર્જુન! બ્રહ્મલોક સુધીના બધા લોકમાંથી ફરી જન્મ લેવો પડે છે. પરંતુ મને પ્રાપ્ત કર્યા પછી પુનર્જન્મ થતો નથી.',
      meaningEnglish:
          'All material realms remain within the cycle of return, while attainment of the Supreme ends rebirth.',
      meaningGujarati:
          'ભૌતિક સૃષ્ટિના બધા લોક પુનરાગમનના ચક્રમાં છે, જ્યારે પરમાત્માની પ્રાપ્તિથી પુનર્જન્મનો અંત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'सहस्रयुगपर्यन्तमहर्यद्ब्रह्मणो विदुः ।\nरात्रिं युगसहस्रान्तां तेऽहोरात्रविदो जनाः ॥',
      english:
          'Those who know the duration of day and night understand that Brahma’s day lasts for a thousand ages and his night also for a thousand ages.',
      gujarati:
          'બ્રહ્માનો એક દિવસ હજાર યુગ જેટલો અને તેની રાત્રિ પણ હજાર યુગ જેટલી હોય છે.',
      meaningEnglish:
          'The cosmic scale of Brahma’s day and night is described as extending over vast cycles of ages.',
      meaningGujarati:
          'અહીં બ્રહ્માના દિવસ અને રાત્રિના અત્યંત વિશાળ કાળચક્રનું વર્ણન કરવામાં આવ્યું છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'अव्यक्ताद् व्यक्तयः सर्वाः प्रभवन्त्यहरागमे ।\nरात्र्यागमे प्रलीयन्ते तत्रैवाव्यक्तसंज्ञके ॥',
      english:
          'At the coming of Brahma’s day, all beings emerge from the unmanifest; at night they dissolve into that same unmanifest.',
      gujarati:
          'બ્રહ્માના દિવસના આરંભે બધા જીવો અવ્યક્તમાંથી વ્યક્ત થાય છે અને રાત્રિના આરંભે ફરી અવ્યક્તમાં લીન થાય છે.',
      meaningEnglish:
          'Creation emerges from the unmanifest and dissolves back into it according to the cosmic cycle.',
      meaningGujarati:
          'સૃષ્ટિના ચક્રમાં જીવો અવ્યક્તમાંથી વ્યક્ત થાય છે અને ફરી અવ્યક્તમાં લીન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'भूतग्रामः स एवायं भूत्वा भूत्वा प्रलीयते ।\nरात्र्यागमेऽवशः पार्थ प्रभवत्यहरागमे ॥',
      english:
          'Again and again the multitude of beings comes into existence and dissolves helplessly at the coming of night and day.',
      gujarati:
          'હે પાર્થ! જીવોનો આ સમૂહ વારંવાર ઉત્પન્ન થાય છે અને બ્રહ્માની રાત્રિમાં લય પામે છે તથા દિવસે ફરી ઉત્પન્ન થાય છે.',
      meaningEnglish:
          'The multitude of beings repeatedly appears and disappears according to the cosmic cycle.',
      meaningGujarati:
          'જીવોનો સમૂહ બ્રહ્માના દિવસ અને રાત્રિના ચક્ર અનુસાર વારંવાર ઉત્પન્ન અને લય પામે છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'परस्तस्मात्तु भावोऽन्योऽव्यक्तोऽव्यक्तात्सनातनः ।\nयः स सर्वेषु भूतेषु नश्यत्सु न विनश्यति ॥',
      english:
          'Beyond this unmanifest is another eternal unmanifest reality which does not perish when all beings perish.',
      gujarati:
          'આ અવ્યક્તથી પર એક બીજું સનાતન અવ્યક્ત તત્ત્વ છે, જે બધા જીવો નાશ પામે ત્યારે પણ નાશ પામતું નથી.',
      meaningEnglish:
          'Beyond the temporary cosmic manifestation exists an eternal reality that remains when all beings perish.',
      meaningGujarati:
          'નાશવંત સૃષ્ટિથી પર એક સનાતન તત્ત્વ છે જે સમગ્ર સૃષ્ટિના નાશ પછી પણ અવિનાશી રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'अव्यक्तोऽक्षर इत्युक्तस्तमाहुः परमां गतिम् ।\nयं प्राप्य न निवर्तन्ते तद्धाम परमं मम ॥',
      english:
          'That unmanifest, called the Imperishable, is said to be the Supreme Goal. Having attained it, beings do not return; that is My Supreme Abode.',
      gujarati:
          'જે અવ્યક્તને અક્ષર કહે છે તે પરમ ગતિ છે. જેને પ્રાપ્ત કર્યા પછી જ્ઞાનીઓ પાછા આવતા નથી, તે મારું પરમધામ છે.',
      meaningEnglish:
          'The imperishable Supreme Abode is the highest destination from which there is no return to material existence.',
      meaningGujarati:
          'અવિનાશી પરમધામ સર્વોચ્ચ ગતિ છે, જેને પ્રાપ્ત કર્યા પછી જીવને ફરી સંસારમાં આવવું પડતું નથી.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'पुरुषः स परः पार्थ भक्त्या लभ्यस्त्वनन्यया ।\nयस्यान्तःस्थानि भूतानि येन सर्वमिदं ततम् ॥',
      english:
          'O Partha, that Supreme Person is attained only by undivided devotion; all beings dwell in Him and He pervades the entire universe.',
      gujarati:
          'હે પાર્થ! સર્વ ભૂતો જેમાં સ્થિત છે અને જેનાથી આખું જગત વ્યાપ્ત છે તે પરમ પુરુષ અનન્ય ભક્તિથી પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'The Supreme Person who pervades and supports all beings is attained through exclusive devotion.',
      meaningGujarati:
          'સમગ્ર જગતને વ્યાપ્ત અને ધારણ કરનાર પરમ પુરુષ અનન્ય ભક્તિ દ્વારા પ્રાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'यत्र काले त्वनावृत्तिमावृत्तिं चैव योगिनः ।\nप्रयाता यान्ति तं कालं वक्ष्यामि भरतर्षभ ॥',
      english:
          'O best of the Bharatas, I shall now explain the times when yogis depart and either return or do not return.',
      gujarati:
          'હે ભરતશ્રેષ્ઠ! જે કાળે યોગીઓ મૃત્યુ પામીને પાછા જન્મતા નથી અને જે કાળે મૃત્યુ પામીને પાછા જન્મે છે, તે કાળ હું તને કહું છું.',
      meaningEnglish:
          'Krishna now describes the two traditional paths associated with return and non-return after death.',
      meaningGujarati:
          'શ્રીકૃષ્ણ હવે મૃત્યુ પછી પુનરાગમન અને અપુનરાગમન સાથે જોડાયેલા બે માર્ગોનું વર્ણન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'अग्निर्ज्योतिरहः शुक्लः षण्मासा उत्तरायणम् ।\nतत्र प्रयाता गच्छन्ति ब्रह्म ब्रह्मविदो जनाः ॥',
      english:
          'Those who depart through fire, light, daytime, the bright fortnight and the six months of the northern course of the sun reach Brahman.',
      gujarati:
          'અગ્નિ, પ્રકાશ, દિવસ, શુક્લપક્ષ અને ઉત્તરાયણના છ માસ દરમિયાન મૃત્યુ પામનારા બ્રહ્મવેત્તાઓ બ્રહ્મને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'The bright path is described as the path by which knowers of Brahman attain Brahman without returning.',
      meaningGujarati:
          'અગ્નિ, પ્રકાશ, દિવસ, શુક્લપક્ષ અને ઉત્તરાયણ સાથે જોડાયેલ તેજસ્વી માર્ગ બ્રહ્મજ્ઞાનીને બ્રહ્મપ્રાપ્તિ તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'धूमो रात्रिस्तथा कृष्णः षण्मासा दक्षिणायनम् ।\nतत्र चान्द्रमसं ज्योतिर्योगी प्राप्य निवर्तते ॥',
      english:
          'Those who depart through smoke, night, the dark fortnight and the six months of the southern course of the sun reach the lunar realm and return.',
      gujarati:
          'ધૂમ્ર, રાત્રિ, કૃષ્ણપક્ષ અને દક્ષિણાયનના છ માસ દરમિયાન મૃત્યુ પામનાર યોગી ચંદ્રલોકના ભોગ ભોગવી પાછો આવે છે.',
      meaningEnglish:
          'The darker path leads to the lunar realm, after which the soul returns to the world of mortality.',
      meaningGujarati:
          'ધૂમ્ર, રાત્રિ, કૃષ્ણપક્ષ અને દક્ષિણાયન સાથે જોડાયેલ માર્ગ ચંદ્રલોક સુધી લઈ જઈને પુનરાગમન કરાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'शुक्लकृष्णे गती ह्येते जगतः शाश्वते मते ।\nएकया यात्यनावृत्तिमन्ययावर्तते पुनः ॥',
      english:
          'The bright and dark paths are regarded as the eternal paths of the world. By one, there is no return; by the other, one returns again.',
      gujarati:
          'શુક્લ અને કૃષ્ણ એમ બે શાશ્વત માર્ગો માનવામાં આવ્યા છે. એક માર્ગથી જનારને પુનર્જન્મ થતો નથી અને બીજા માર્ગથી જનાર પાછો જન્મ લે છે.',
      meaningEnglish:
          'Two paths are described: one leading beyond return and the other leading back into worldly existence.',
      meaningGujarati:
          'અહીં બે માર્ગોનું વર્ણન છે—એક પુનર્જન્મથી મુક્તિ તરફ અને બીજો ફરી સંસાર તરફ લઈ જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'नैते सृती पार्थ जानन् योगी मुह्यति कश्चन ।\nतस्मात्सर्वेषु कालेषु योगयुक्तो भव अर्जुन ॥',
      english:
          'Knowing these two paths, no yogi is deluded. Therefore, O Arjuna, remain united with Yoga at all times.',
      gujarati:
          'હે પાર્થ! આ બંને માર્ગોને જાણનાર યોગી મોહ પામતો નથી. તેથી હે અર્જુન! દરેક સમયે યોગમાં સ્થિર રહે.',
      meaningEnglish:
          'Understanding the nature of these paths, the yogi remains free from confusion and stays established in Yoga.',
      meaningGujarati:
          'આ બંને માર્ગોના તત્ત્વને જાણનાર યોગી મોહથી મુક્ત રહીને સતત યોગમાં સ્થિર રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'वेदेषु यज्ञेषु तपःसु चैव दानेषु यत्पुण्यफलं प्रदिष्टम् ।\nअत्येति तत्सर्वमिदं विदित्वा योगी परं स्थानमुपैति चाद्यम् ॥',
      english:
          'The yogi who knows this surpasses all the fruits of merit prescribed in the Vedas, sacrifices, austerities and charity, and attains the Supreme Primordial Abode.',
      gujarati:
          'આ જ્ઞાનને જાણનાર યોગી વેદ, યજ્ઞ, તપ અને દાનથી મળતાં બધા પુણ્યફળને પાર કરી પરમ આદિ સ્થાનને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'A yogi who understands this spiritual teaching transcends the limited results of rituals and virtuous actions and attains the Supreme Abode.',
      meaningGujarati:
          'આ જ્ઞાનને સમજેલો યોગી વેદ, યજ્ઞ, તપ અને દાનના સીમિત પુણ્યફળથી પર જઈ પરમ સ્થાનને પ્રાપ્ત કરે છે.',
    ),
  ];
}
// =====================================================
// BHAGAVAD GITA - CHAPTER 9
// RAJA VIDYA RAJA GUHYA YOGA
// =====================================================

static List<SacredVerseModel> _gitaChapter9Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'श्रीभगवानुवाच ।\nइदं तु ते गुह्यतमं प्रवक्ष्याम्यनसूयवे ।\nज्ञानं विज्ञानसहितं यज्ज्ञात्वा मोक्ष्यसेऽशुभात् ॥',
      english:
          'The Supreme Lord said: To you, who are free from envy, I shall reveal this most secret knowledge along with realization; knowing it, you will be freed from evil.',
      gujarati:
          'શ્રી ભગવાન કહે છે: હે અર્જુન! તું નિર્મળ છે, તેથી હું તને આ અત્યંત ગુપ્ત જ્ઞાન વિજ્ઞાન સહિત કહીશ, જેને જાણીને તું અશુભ સંસારથી મુક્ત થઈશ.',
      meaningEnglish:
          'The Divine reveals the highest spiritual knowledge to the sincere seeker, leading toward freedom from worldly suffering.',
      meaningGujarati:
          'પરમાત્મા નિર્મળ અને નિષ્ઠાવાન સાધકને પરમ ગુપ્ત જ્ઞાન આપે છે, જે સંસારના અશુભ બંધનમાંથી મુક્તિ તરફ દોરી જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'राजविद्या राजगुह्यं पवित्रमिदमुत्तमम् ।\nप्रत्यक्षावगमं धर्म्यं सुसुखं कर्तुमव्ययम् ॥',
      english:
          'This is the king of knowledge and the king of secrets, supremely pure, directly realizable, righteous, easy to practice and imperishable.',
      gujarati:
          'આ જ્ઞાન સર્વ વિદ્યાઓનો રાજા અને સર્વ ગુહ્યોમાં શ્રેષ્ઠ છે. તે પવિત્ર, પ્રત્યક્ષ અનુભવવા યોગ્ય, ધર્મમય, સુખપૂર્વક આચરી શકાય એવું અને અવિનાશી છે.',
      meaningEnglish:
          'Spiritual knowledge is supreme because it is pure, practical, directly realizable and everlasting.',
      meaningGujarati:
          'આધ્યાત્મિક જ્ઞાન સર્વોચ્ચ છે કારણ કે તે પવિત્ર, અનુભવવા યોગ્ય, આચરણમાં સરળ અને અવિનાશી છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'अश्रद्दधानाः पुरुषा धर्मस्यास्य परन्तप ।\nअप्राप्य मां निवर्तन्ते मृत्युसंसारवर्त्मनि ॥',
      english:
          'Those without faith in this dharma do not attain Me and return to the path of mortal existence.',
      gujarati:
          'હે પરંતપ! જે મનુષ્યો આ ધર્મમાં શ્રદ્ધા રાખતા નથી તેઓ મને પ્રાપ્ત કર્યા વિના મૃત્યુમય સંસારના માર્ગમાં ભટકતા રહે છે.',
      meaningEnglish:
          'Without faith in the spiritual path, a person remains caught in the cycle of worldly existence.',
      meaningGujarati:
          'આધ્યાત્મિક માર્ગમાં શ્રદ્ધા ન રાખવાથી મનુષ્ય જન્મ-મરણના સંસારચક્રમાં ભટકતો રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'मया ततमिदं सर्वं जगदव्यक्तमूर्तिना ।\nमत्स्थानि सर्वभूतानि न चाहं तेष्ववस्थितः ॥',
      english:
          'In My unmanifest form I pervade the entire universe. All beings exist in Me, but I am not contained in them.',
      gujarati:
          'હું અવ્યક્ત સ્વરૂપે સમગ્ર જગતમાં વ્યાપ્ત છું. બધા જીવો મારામાં સ્થિત છે, પરંતુ હું તેમનામાં સ્થિત નથી.',
      meaningEnglish:
          'The Divine pervades the entire universe while remaining beyond the limitations of individual beings.',
      meaningGujarati:
          'પરમાત્મા સમગ્ર જગતમાં વ્યાપ્ત છે, પરંતુ કોઈ એક જીવ કે પદાર્થની સીમામાં બંધાયેલા નથી.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'न च मत्स्थानि भूतानि पश्य मे योगमैश्वरम् ।\nभूतभृन्न च भूतस्थो ममात्मा भूतभावनः ॥',
      english:
          'Yet beings do not truly dwell in Me. Behold My divine Yoga! I sustain all beings, yet My Self is not confined by them.',
      gujarati:
          'વાસ્તવમાં બધા ભૂતો મારામાં સ્થિત નથી. મારી આ ઈશ્વરી યોગમાયાને જો. હું બધા ભૂતોને ધારણ કરું છું છતાં તેમનામાં બંધાયેલો નથી.',
      meaningEnglish:
          'The Divine sustains all beings without being limited or confined by creation.',
      meaningGujarati:
          'પરમાત્મા સમગ્ર સૃષ્ટિને ધારણ કરે છે, પરંતુ સૃષ્ટિના કોઈ પણ બંધનથી મર્યાદિત નથી.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'यथाकाशस्थितो नित्यं वायुः सर्वत्रगो महान् ।\nतथा सर्वाणि भूतानि मत्स्थानीत्युपधारय ॥',
      english:
          'As the mighty wind moves everywhere while remaining in space, so understand that all beings exist in Me.',
      gujarati:
          'જેમ સર્વત્ર ફરતો પ્રચંડ વાયુ સદા આકાશમાં જ રહે છે, તેમ બધા જીવો મારામાં સ્થિત છે એમ માન.',
      meaningEnglish:
          'Just as wind exists within space, all beings exist within the Divine.',
      meaningGujarati:
          'જેમ વાયુ આકાશમાં રહીને સર્વત્ર ગતિ કરે છે, તેમ બધા જીવો પરમાત્મામાં સ્થિત રહીને કાર્ય કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'सर्वभूतानि कौन्तेय प्रकृतिं यान्ति मामिकाम् ।\nकल्पक्षये पुनस्तानि कल्पादौ विसृजाम्यहम् ॥',
      english:
          'At the end of a cosmic cycle, all beings enter My Prakriti; at the beginning of the next cycle, I send them forth again.',
      gujarati:
          'હે કૌન્તેય! કલ્પના અંતે બધા જીવો મારી પ્રકૃતિમાં લીન થાય છે અને કલ્પના આરંભે હું તેમને ફરી ઉત્પન્ન કરું છું.',
      meaningEnglish:
          'Creation and dissolution occur repeatedly within the Divine cosmic order.',
      meaningGujarati:
          'સૃષ્ટિનો લય અને પુનઃસર્જન પરમાત્માની પ્રકૃતિના નિયમ અનુસાર વારંવાર થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'प्रकृतिं स्वामवष्टभ्य विसृजामि पुनः पुनः ।\nभूतग्राममिमं कृत्स्नमवशं प्रकृतेर्वशात् ॥',
      english:
          'Controlling My own Prakriti, I repeatedly send forth all these beings, helplessly subject to the power of nature.',
      gujarati:
          'મારી પ્રકૃતિને વશમાં રાખીને હું વારંવાર બધા જીવોને ઉત્પન્ન કરું છું. તેઓ પ્રકૃતિના વશમાં હોવાથી પોતાના નિયંત્રણમાં નથી.',
      meaningEnglish:
          'The Divine governs nature, through which beings repeatedly come into existence.',
      meaningGujarati:
          'પરમાત્માની અધ્યક્ષતામાં પ્રકૃતિ દ્વારા જીવો વારંવાર ઉત્પન્ન થાય છે અને પ્રકૃતિના નિયમોને આધીન રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'न च मां तानि कर्माणि निबध्नन्ति धनञ्जय ।\nउदासीनवदासीनमसक्तं तेषु कर्मसु ॥',
      english:
          'These actions do not bind Me, O Dhananjaya, for I remain detached and indifferent to them.',
      gujarati:
          'હે ધનંજય! આ બધા કર્મો મને બાંધતા નથી, કારણ કે હું તે કર્મોમાં આસક્ત થયા વિના ઉદાસીનની જેમ રહું છું.',
      meaningEnglish:
          'The Divine performs and governs cosmic activity without attachment or bondage to its results.',
      meaningGujarati:
          'પરમાત્મા સૃષ્ટિના કર્મોને નિયંત્રિત કરે છે પરંતુ કોઈ આસક્તિ કે કર્મબંધનમાં બંધાતા નથી.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'मयाध्यक्षेण प्रकृतिः सूयते सचराचरम् ।\nहेतुनानेन कौन्तेय जगद्विपरिवर्तते ॥',
      english:
          'Under My supervision, Prakriti produces all moving and unmoving beings. Because of this, the universe continues to function.',
      gujarati:
          'મારી અધ્યક્ષતામાં પ્રકૃતિ સમગ્ર ચરાચર જગતને ઉત્પન્ન કરે છે. હે કૌન્તેય! આ કારણથી જગતની રચના અને પરિવર્તન ચાલે છે.',
      meaningEnglish:
          'Nature functions under Divine supervision and gives rise to the moving and unmoving universe.',
      meaningGujarati:
          'પ્રકૃતિ પરમાત્માની અધ્યક્ષતામાં સમગ્ર ચરાચર જગતની રચના અને પરિવર્તન ચલાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'अवजानन्ति मां मूढा मानुषीं तनुमाश्रितम् ।\nपरं भावमजानन्तो मम भूतमहेश्वरम् ॥',
      english:
          'Fools disregard Me when I appear in human form, not knowing My higher divine nature as the Supreme Lord of all beings.',
      gujarati:
          'મૂર્ખ લોકો માનવ શરીર ધારણ કરેલા મને સામાન્ય મનુષ્ય માને છે. તેઓ મારા પરમ દિવ્ય સ્વરૂપને જાણતા નથી.',
      meaningEnglish:
          'Those who see only the external human form fail to recognize the Divine nature of the Supreme Lord.',
      meaningGujarati:
          'જે લોકો પરમાત્માના માત્ર માનવ સ્વરૂપને જુએ છે તેઓ તેમના પરમ દિવ્ય સ્વરૂપને ઓળખી શકતા નથી.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'मोघाशा मोघकर्माणो मोघज्ञाना विचेतसः ।\nराक्षसीमासुरीं चैव प्रकृतिं मोहिनीं श्रिताः ॥',
      english:
          'Their hopes, actions and knowledge become fruitless because they have taken refuge in delusive demonic nature.',
      gujarati:
          'એવા લોકોની આશાઓ, કર્મો અને જ્ઞાન નિષ્ફળ જાય છે, કારણ કે તેઓ મોહ પમાડનારી આસુરી અને રાક્ષસી પ્રકૃતિનો આશ્રય લે છે.',
      meaningEnglish:
          'When a person follows destructive and delusive tendencies, their efforts and knowledge lose their higher purpose.',
      meaningGujarati:
          'આસુરી અને મોહમય પ્રકૃતિનો આશ્રય લેવાથી મનુષ્યની આશા, કર્મ અને જ્ઞાન પોતાના આધ્યાત્મિક હેતુથી ભટકી જાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'महात्मानस्तु मां पार्थ दैवीं प्रकृतिमाश्रिताः ।\nभजन्त्यनन्यमनसो ज्ञात्वा भूतादिमव्ययम् ॥',
      english:
          'But the great souls, taking refuge in divine nature, worship Me with undivided minds, knowing Me as the eternal source of all beings.',
      gujarati:
          'પરંતુ હે પાર્થ! મહાત્માઓ દૈવી પ્રકૃતિનો આશ્રય લઈને મને સર્વ જીવોનો અવિનાશી મૂળ જાણીને અનન્ય મનથી મારી ભક્તિ કરે છે.',
      meaningEnglish:
          'Great souls take refuge in divine qualities and worship the eternal source of all beings with one-pointed devotion.',
      meaningGujarati:
          'મહાત્માઓ દૈવી ગુણોનો આશ્રય લઈને સર્વ જીવોના અવિનાશી મૂળ એવા પરમાત્માની અનન્ય ભક્તિ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'सततं कीर्तयन्तो मां यतन्तश्च दृढव्रताः ।\nनमस्यन्तश्च मां भक्त्या नित्ययुक्ता उपासते ॥',
      english:
          'Always glorifying Me, striving with firm vows and bowing to Me with devotion, they constantly worship Me.',
      gujarati:
          'મહાત્માઓ સતત મારું કીર્તન કરે છે, દઢ વ્રતથી પ્રયત્ન કરે છે અને ભક્તિપૂર્વક મને નમન કરીને મારી ઉપાસના કરે છે.',
      meaningEnglish:
          'Constant remembrance, sincere effort, devotion and discipline form the path of dedicated worship.',
      meaningGujarati:
          'સતત સ્મરણ, દૃઢ સંકલ્પ, ભક્તિ અને નમ્રતા દ્વારા સાધક પરમાત્માની સતત ઉપાસના કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'ज्ञानयज्ञेन चाप्यन्ये यजन्तो मामुपासते ।\nएकत्वेन पृथक्त्वेन बहुधा विश्वतोमुखम् ॥',
      english:
          'Others worship Me through the sacrifice of knowledge, seeing Me as One, as distinct in many forms, and as the One who faces everywhere.',
      gujarati:
          'કેટલાક લોકો જ્ઞાનયજ્ઞ દ્વારા મારી ઉપાસના કરે છે. કેટલાક મને એકરૂપે અને કેટલાક અનેકરૂપે, વિશ્વરૂપે રહેલા પરમાત્મા તરીકે પૂજે છે.',
      meaningEnglish:
          'Seekers may approach the Divine through different understandings, recognizing unity and diversity within creation.',
      meaningGujarati:
          'સાધકો વિવિધ દૃષ્ટિકોણથી પરમાત્માની ઉપાસના કરી શકે છે અને એક તથા અનેક સ્વરૂપોમાં તેમની અનુભૂતિ કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'अहं क्रतुरहं यज्ञः स्वधाहमहमौषधम् ।\nमन्त्रोऽहमहमेवाज्यमहमग्निरहं हुतम् ॥',
      english:
          'I am the ritual, the sacrifice, the offering to ancestors, the medicine, the mantra, the clarified butter, the fire and the offering.',
      gujarati:
          'અગ્નિહોત્ર યજ્ઞ, વૈશ્વદેવ યજ્ઞ, પિતૃઓને અર્પણ થતું સ્વધા, ઔષધ, મંત્ર, ઘી, અગ્નિ અને હવનકર્મ — આ બધું હું જ છું.',
      meaningEnglish:
          'The Divine is present as every essential part of sacred worship and sacrifice.',
      meaningGujarati:
          'યજ્ઞ અને ઉપાસનાના દરેક પવિત્ર અંગમાં પરમાત્માની જ ઉપસ્થિતિ છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'पिताहमस्य जगतो माता धाता पितामहः ।\nवेद्यं पवित्रमोंकार ऋक्साम यजुरेव च ॥',
      english:
          'I am the father, mother, sustainer and grandfather of this universe. I am the object of knowledge, the purifier, Om, and the Rig, Sama and Yajur Vedas.',
      gujarati:
          'હું આ જગતનો પિતા, માતા, ધારણ કરનાર અને પિતામહ છું. હું જ જાણવાલાયક તત્ત્વ, પવિત્ર કરનાર, ઓમકાર તથા ઋગ્વેદ, સામવેદ અને યજુર્વેદ છું.',
      meaningEnglish:
          'The Divine is the source, protector and ultimate object of spiritual knowledge.',
      meaningGujarati:
          'પરમાત્મા સમગ્ર જગતના પિતા, માતા, આધાર અને પવિત્ર જ્ઞાનના અંતિમ વિષય છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'गतिर्भर्ता प्रभुः साक्षी निवासः शरणं सुहृत् ।\nप्रभवः प्रलयः स्थानं निधानं बीजमव्ययम् ॥',
      english:
          'I am the goal, sustainer, Lord, witness, abode, refuge, friend, origin, dissolution, foundation, resting place and imperishable seed.',
      gujarati:
          'હું સર્વનું લક્ષ્ય, પોષણ કરનાર, સ્વામી, સાક્ષી, નિવાસસ્થાન, શરણ, મિત્ર, ઉત્પત્તિ, પ્રલય, આધાર અને અવિનાશી બીજ છું.',
      meaningEnglish:
          'The Divine is the ultimate goal, support, witness, refuge, origin and imperishable seed of all existence.',
      meaningGujarati:
          'પરમાત્મા સર્વનું અંતિમ લક્ષ્ય, આધાર, સાક્ષી, શરણ, ઉત્પત્તિ અને અવિનાશી બીજ છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'तपाम्यहमहं वर्षं निगृह्णाम्युत्सृजामि च ।\nअमृतं चैव मृत्युश्च सदसच्चाहमर्जुन ॥',
      english:
          'I give heat; I send and withhold rain. I am immortality and death, and I am both existence and non-existence.',
      gujarati:
          'હે અર્જુન! હું તાપ આપું છું, વરસાદ વરસાવું છું અને રોકું છું. હું અમૃત પણ છું અને મૃત્યુ પણ છું. સત્ અને અસત્ પણ હું જ છું.',
      meaningEnglish:
          'The Divine encompasses the forces and opposites that govern existence, including life and death.',
      meaningGujarati:
          'પરમાત્મા જીવન અને મૃત્યુ સહિત અસ્તિત્વના વિવિધ વિરોધી સ્વરૂપોમાં પણ વ્યાપ્ત છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'त्रैविद्या मां सोमपाः पूतपापा\nयज्ञैरिष्ट्वा स्वर्गतिं प्रार्थयन्ते ।\nते पुण्यमासाद्य सुरेन्द्रलोकम्\nअश्नन्ति दिव्यान्दिवि देवभोगान् ॥',
      english:
          'Those who know the three Vedas, drink Soma and are purified of sins worship Me through sacrifices and seek heaven. Having attained heaven, they enjoy divine pleasures there.',
      gujarati:
          'ત્રણ વેદોના જ્ઞાતા, સોમપાન કરનારા અને પાપોથી શુદ્ધ થયેલા લોકો યજ્ઞો દ્વારા મારી ઉપાસના કરીને સ્વર્ગની ઇચ્છા કરે છે. તેઓ સ્વર્ગલોકમાં જઈ દિવ્ય ભોગો ભોગવે છે.',
      meaningEnglish:
          'Those who perform prescribed rituals with the desire for heaven may attain heavenly pleasures.',
      meaningGujarati:
          'સ્વર્ગની ઇચ્છાથી યજ્ઞકર્મ કરનારા મનુષ્યો પુણ્યના આધારે સ્વર્ગીય સુખ પ્રાપ્ત કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'ते तं भुक्त्वा स्वर्गलोकं विशालं\nक्षीणे पुण्ये मर्त्यलोकं विशन्ति ।\nएवं त्रयीधर्ममनुप्रपन्ना\nगतागतं कामकामा लभन्ते ॥',
      english:
          'After enjoying the vast heavenly world, when their merit is exhausted they return to the mortal world. Thus, those following the Vedic rituals for desires repeatedly come and go.',
      gujarati:
          'સ્વર્ગના વિશાળ ભોગ ભોગવી લીધા પછી જ્યારે તેમનું પુણ્ય ક્ષીણ થાય છે ત્યારે તેઓ મૃત્યુલોકમાં પાછા આવે છે. આ રીતે કામનાઓથી પ્રેરિત લોકો જન્મ-મરણના ચક્રમાં ફરતા રહે છે.',
      meaningEnglish:
          'Heavenly pleasures are temporary; when the accumulated merit is exhausted, the soul returns to mortal existence.',
      meaningGujarati:
          'સ્વર્ગના ભોગો પણ અસ્થાયી છે. પુણ્ય ક્ષીણ થતાં મનુષ્ય ફરી મૃત્યુલોકમાં આવે છે અને સંસારચક્ર ચાલુ રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'अनन्याश्चिन्तयन्तो मां ये जनाः पर्युपासते ।\nतेषां नित्याभियुक्तानां योगक्षेमं वहाम्यहम् ॥',
      english:
          'Those who worship Me with exclusive devotion and constantly think of Me—I provide what they lack and preserve what they have.',
      gujarati:
          'જે મનુષ્યો અનન્ય ભક્તિથી મારું ચિંતન અને ઉપાસના કરે છે, તેમના યોગક્ષેમનો ભાર હું પોતે ઉઠાવું છું.',
      meaningEnglish:
          'The Divine cares for those who remain constantly devoted and surrendered with exclusive faith.',
      meaningGujarati:
          'જે ભક્ત અનન્ય શ્રદ્ધાથી સતત પરમાત્માનું ચિંતન કરે છે, તેના યોગક્ષેમની જવાબદારી પરમાત્મા સ્વીકારે છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'येऽप्यन्यदेवताभक्ता यजन्ते श्रद्धयान्विताः ।\nतेऽपि मामेव कौन्तेय यजन्त्यविधिपूर्वकम् ॥',
      english:
          'Even those who worship other deities with faith are actually worshipping Me, O son of Kunti, though not according to the proper understanding.',
      gujarati:
          'હે કૌન્તેય! જે લોકો શ્રદ્ધાથી અન્ય દેવોની ઉપાસના કરે છે, તેઓ પણ વાસ્તવમાં મારી જ ઉપાસના કરે છે, પરંતુ યોગ્ય જ્ઞાન વગર.',
      meaningEnglish:
          'Different forms of worship ultimately relate to the same Supreme Divine, though understanding may differ.',
      meaningGujarati:
          'વિવિધ દેવતાઓની શ્રદ્ધાપૂર્વક ઉપાસના અંતે પરમ તત્ત્વ સાથે જ જોડાય છે, પરંતુ યોગ્ય જ્ઞાનનો અભાવ હોઈ શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'अहं हि सर्वयज्ञानां भोक्ता च प्रभुरेव च ।\nन तु मामभिजानन्ति तत्त्वेनातश्च्यवन्ति ते ॥',
      english:
          'I alone am the enjoyer and Lord of all sacrifices. But those who do not know Me in truth fall from the spiritual path.',
      gujarati:
          'હું જ બધા યજ્ઞોનો ભોક્તા અને સ્વામી છું. પરંતુ લોકો મને તત્ત્વથી ઓળખતા નથી, તેથી તેઓ પોતાના આધ્યાત્મિક લક્ષ્યથી ભટકી જાય છે.',
      meaningEnglish:
          'The Supreme is the ultimate recipient and Lord of every sacrifice, but lack of true understanding keeps seekers from the highest goal.',
      meaningGujarati:
          'બધા યજ્ઞોના અંતિમ ભોક્તા પરમાત્મા છે, પરંતુ તત્ત્વજ્ઞાનના અભાવે સાધક પરમ આધ્યાત્મિક લક્ષ્યથી ભટકી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'यान्ति देवव्रता देवान् पितॄन्यान्ति पितृव्रताः ।\nभूतानि यान्ति भूतेज्या यान्ति मद्याजिनोऽपि माम् ॥',
      english:
          'Worshippers of the gods go to the gods; worshippers of ancestors go to the ancestors; worshippers of spirits go to them; and My worshippers come to Me.',
      gujarati:
          'દેવોની ઉપાસના કરનારા દેવોને પ્રાપ્ત થાય છે, પિતૃોની ઉપાસના કરનારા પિતૃલોકને જાય છે, ભૂતોની ઉપાસના કરનારા ભૂતોને પ્રાપ્ત થાય છે અને મારી ઉપાસના કરનારા મને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'The destination of a seeker corresponds to the object of their worship and devotion.',
      meaningGujarati:
          'સાધક જે તત્ત્વની ઉપાસના કરે છે તે મુજબ તેની ગતિ થાય છે; પરમાત્માની ઉપાસના કરનાર પરમાત્માને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'पत्रं पुष्पं फलं तोयं यो मे भक्त्या प्रयच्छति ।\nतदहं भक्त्युपहृतमश्नामि प्रयतात्मनः ॥',
      english:
          'Whoever offers Me with devotion a leaf, a flower, a fruit or water, I accept that loving offering from the pure-hearted.',
      gujarati:
          'જે ભક્ત મને ભક્તિપૂર્વક પાન, ફૂલ, ફળ અથવા જળ અર્પણ કરે છે, તે શુદ્ધ હૃદયથી કરેલું અર્પણ હું સ્વીકારું છું.',
      meaningEnglish:
          'The Divine values the devotion and purity of the offering rather than its material greatness.',
      meaningGujarati:
          'પરમાત્મા અર્પણની કિંમત કરતાં ભક્તના પ્રેમ, શ્રદ્ધા અને શુદ્ધ હૃદયને વધુ મહત્વ આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'यत्करोषि यदश्नासि यज्जुहोषि ददासि यत् ।\nयत्तपस्यसि कौन्तेय तत्कुरुष्व मदर्पणम् ॥',
      english:
          'Whatever you do, whatever you eat, whatever you offer, give or perform as austerity—do it as an offering to Me.',
      gujarati:
          'હે કૌન્તેય! તું જે કરે, જે ખાય, જે યજ્ઞ કરે, જે દાન આપે અને જે તપ કરે—તે બધું મને અર્પણ કરીને કર.',
      meaningEnglish:
          'Every action can become spiritual when it is consciously offered to the Divine.',
      meaningGujarati:
          'જીવનનું દરેક કર્મ પરમાત્માને અર્પણભાવથી કરવામાં આવે તો તે આધ્યાત્મિક સાધના બની શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'शुभाशुभफलैरेवं मोक्ष्यसे कर्मबन्धनैः ।\nसंन्यासयोगयुक्तात्मा विमुक्तो मामुपैष्यसि ॥',
      english:
          'Thus you will be freed from the bondage of good and bad results of actions. With your mind united with renunciation, you will attain Me.',
      gujarati:
          'આ રીતે તું કર્મના શુભ અને અશુભ ફળના બંધનથી મુક્ત થઈશ અને સંન્યાસયોગથી જોડાઈ મને પ્રાપ્ત કરીશ.',
      meaningEnglish:
          'Offering actions to the Divine frees the seeker from attachment to the results of action.',
      meaningGujarati:
          'કર્મોને પરમાત્માને અર્પણ કરવાથી કર્મફળની આસક્તિમાંથી મુક્તિ મળે છે અને સાધક પરમાત્માની નજીક પહોંચે છે.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'समोऽहं सर्वभूतेषु न मे द्वेष्योऽस्ति न प्रियः ।\nये भजन्ति तु मां भक्त्या मयि ते तेषु चाप्यहम् ॥',
      english:
          'I am equal to all beings. No one is hateful or especially dear to Me. But those who worship Me with devotion dwell in Me, and I dwell in them.',
      gujarati:
          'હું બધા જીવો પ્રત્યે સમાન છું. મને કોઈ પ્રિય કે અપ્રિય નથી. પરંતુ જે ભક્તિથી મારી ઉપાસના કરે છે, તે મારામાં રહે છે અને હું તેમનામાં રહું છું.',
      meaningEnglish:
          'The Divine is impartial toward all beings, while sincere devotion creates a deep spiritual union.',
      meaningGujarati:
          'પરમાત્મા બધા જીવો પ્રત્યે સમાન છે, પરંતુ નિષ્ઠાવાન ભક્તિથી ભક્ત અને પરમાત્મા વચ્ચે ગાઢ એકતા અનુભવાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'अपि चेत्सुदुराचारो भजते मामनन्यभाक् ।\nसाधुरेव स मन्तव्यः सम्यग्व्यवसितो हि सः ॥',
      english:
          'Even if a very sinful person worships Me with exclusive devotion, he should be regarded as righteous, for he has rightly resolved.',
      gujarati:
          'જો કોઈ અત્યંત દુરાચારી મનુષ્ય પણ અનન્ય ભક્તિથી મારી ઉપાસના કરે તો તેને સાધુ માનવો જોઈએ, કારણ કે તેનો નિશ્ચય સાચો છે.',
      meaningEnglish:
          'Sincere and exclusive devotion can transform a person by turning their life toward righteousness.',
      meaningGujarati:
          'સાચી અને અનન્ય ભક્તિ મનુષ્યના જીવનને પરિવર્તિત કરીને તેને ધર્મના માર્ગે દોરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 31,
      sanskrit:
          'क्षिप्रं भवति धर्मात्मा शश्वच्छान्तिं निगच्छति ।\nकौन्तेय प्रतिजानीहि न मे भक्तः प्रणश्यति ॥',
      english:
          'He quickly becomes righteous and attains lasting peace. O son of Kunti, declare that My devotee never perishes.',
      gujarati:
          'તે જલ્દી જ ધર્માત્મા બની જાય છે અને શાશ્વત શાંતિ પ્રાપ્ત કરે છે. હે કૌન્તેય! નિશ્ચિત કહી દે કે મારો ભક્ત ક્યારેય નાશ પામતો નથી.',
      meaningEnglish:
          'A sincere devotee can quickly transform their life and attain lasting peace; true devotion never goes to waste.',
      meaningGujarati:
          'નિષ્ઠાવાન ભક્તિથી જીવનમાં ઝડપી પરિવર્તન આવે છે અને શાશ્વત શાંતિ પ્રાપ્ત થાય છે; સાચી ભક્તિ ક્યારેય નિષ્ફળ જતી નથી.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit:
          'मां हि पार्थ व्यपाश्रित्य येऽपि स्यु: पापयोनयः ।\nस्त्रियो वैश्यास्तथा शूद्रास्तेऽपि यान्ति परां गतिम् ॥',
      english:
          'O Partha, those who take refuge in Me—even those considered of lower birth, women, Vaishyas and Shudras—can attain the Supreme Goal.',
      gujarati:
          'હે પાર્થ! જે કોઈ મારો આશ્રય લે છે, તેઓ સ્ત્રીઓ, વૈશ્યો, શૂદ્રો અથવા અન્ય કોઈ પણ હોય, તેઓ પણ પરમ ગતિને પ્રાપ્ત કરી શકે છે.',
      meaningEnglish:
          'The path of devotion is open to everyone who sincerely takes refuge in the Divine.',
      meaningGujarati:
          'પરમાત્માની ભક્તિ અને શરણાગતિનો માર્ગ દરેક મનુષ્ય માટે ખુલ્લો છે અને દરેક પરમ ગતિ પ્રાપ્ત કરી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit:
          'किं पुनर्ब्राह्मणाः पुण्या भक्ता राजर्षयस्तथा ।\nअनित्यमसुखं लोकमिमं प्राप्य भजस्व माम् ॥',
      english:
          'How much more easily, then, can righteous Brahmins and devoted royal sages attain Me! Therefore, having come into this impermanent and unhappy world, worship Me.',
      gujarati:
          'તો પછી પુણ્યશાળી બ્રાહ્મણો અને ભક્ત રાજર્ષિઓની તો વાત જ શું! તેથી આ અશાશ્વત અને દુઃખમય સંસારમાં આવ્યા પછી મારી ભક્તિ કર.',
      meaningEnglish:
          'Since worldly existence is temporary and filled with difficulties, one should dedicate life to spiritual devotion.',
      meaningGujarati:
          'આ સંસાર અશાશ્વત અને દુઃખમય હોવાથી મનુષ્યે પોતાના જીવનને પરમાત્માની ભક્તિ તરફ વાળવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit:
          'मन्मना भव मद्भक्तो मद्याजी मां नमस्कुरु ।\nमामेवैष्यसि युक्त्वैवमात्मानं मत्परायणः ॥',
      english:
          'Fix your mind on Me, become My devotee, worship Me and bow down to Me. Thus, having dedicated yourself to Me as your supreme goal, you will surely attain Me.',
      gujarati:
          'મારામાં મન રાખ, મારો ભક્ત બન, મારી પૂજા કર અને મને નમસ્કાર કર. આ રીતે મને પરમ લક્ષ્ય માનીને મારી સાથે જોડાઈશ તો નિશ્ચિતપણે મને પ્રાપ્ત કરીશ.',
      meaningEnglish:
          'Constant remembrance, devotion, worship and surrender lead the seeker toward the Supreme Goal.',
      meaningGujarati:
          'મનમાં પરમાત્માનું સ્મરણ, ભક્તિ, પૂજા અને સંપૂર્ણ શરણાગતિ દ્વારા સાધક પરમાત્માને પરમ લક્ષ્ય તરીકે પ્રાપ્ત કરી શકે છે.',
    ),
  ];
}
// =====================================================
// BHAGAVAD GITA - CHAPTER 10
// VIBHUTI YOGA
// =====================================================

static List<SacredVerseModel> _gitaChapter10Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'श्रीभगवानुवाच ।\nभूय एव महाबाहो शृणु मे परमं वचः ।\nयत्तेऽहं प्रीयमाणाय वक्ष्यामि हितकाम्यया ॥',
      english:
          'The Supreme Lord said: O mighty-armed Arjuna, listen again to My supreme words, which I shall speak for your welfare because you are dear to Me.',
      gujarati:
          'શ્રી ભગવાન બોલ્યા: હે મહાબાહુ અર્જુન! તું મને પ્રિય છે, તેથી તારા હિતની ઇચ્છાથી હું ફરીથી મારા પરમ વચનો કહું છું, તે સાંભળ.',
      meaningEnglish:
          'The Lord lovingly shares higher spiritual wisdom for the welfare of the devoted seeker.',
      meaningGujarati:
          'ભગવાન ભક્ત સાધકના હિત માટે પ્રેમપૂર્વક ઉચ્ચ આધ્યાત્મિક જ્ઞાનનું વર્ણન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'न मे विदुः सुरगणाः प्रभवं न महर्षयः ।\nअहमादिर्हि देवानां महर्षीणां च सर्वशः ॥',
      english:
          'Neither the hosts of gods nor the great sages know My origin, for I am the source of all the gods and great sages.',
      gujarati:
          'દેવતાઓના સમૂહો કે મહર્ષિઓ પણ મારા મૂળ સ્વરૂપને જાણતા નથી, કારણ કે હું બધા દેવો અને મહર્ષિઓનો સર્વ રીતે આદિ સ્ત્રોત છું.',
      meaningEnglish:
          'The Divine is the original source of the gods and sages and therefore transcends their knowledge.',
      meaningGujarati:
          'પરમાત્મા દેવો અને મહર્ષિઓના પણ મૂળ સ્ત્રોત છે, તેથી તેમનું સ્વરૂપ તેમની સમજણથી પર છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'यो मामजमनादिं च वेत्ति लोकमहेश्वरम् ।\nअसम्मूढः स मर्त्येषु सर्वपापैः प्रमुच्यते ॥',
      english:
          'One who knows Me as unborn, beginningless and the Supreme Lord of all worlds becomes free from delusion and all sins.',
      gujarati:
          'જે મને અજન્મા, અનાદિ અને સમગ્ર લોકનો મહેશ્વર જાણે છે, તે મનુષ્યોમાં મોહરહિત બનીને બધા પાપોથી મુક્ત થાય છે.',
      meaningEnglish:
          'Knowing the Divine as unborn and eternal removes delusion and leads toward freedom.',
      meaningGujarati:
          'પરમાત્માને અજન્મા અને અનાદિ જાણવાથી મોહ દૂર થાય છે અને મુક્તિનો માર્ગ ખુલ્લો થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'बुद्धिर्ज्ञानमसम्मोहः क्षमा सत्यं दमः शमः ।\nसुखं दुःखं भवोऽभावो भयं चाभयमेव च ।',
      english:
          'Intelligence, knowledge, freedom from delusion, forgiveness, truthfulness, self-control, calmness, happiness, sorrow, existence, non-existence, fear and fearlessness arise from Me.',
      gujarati:
          'બુદ્ધિ, જ્ઞાન, મોહરહિતતા, ક્ષમા, સત્ય, ઇન્દ્રિયસંયમ, શાંતિ, સુખ, દુઃખ, ઉત્પત્તિ, વિનાશ, ભય અને નિર્ભયતા મારામાંથી જ ઉત્પન્ન થાય છે.',
      meaningEnglish:
          'The many qualities and states experienced by living beings ultimately arise from the Divine.',
      meaningGujarati:
          'જીવોમાં અનુભવાતા વિવિધ ગુણો અને ભાવોનો મૂળ સ્ત્રોત પરમાત્મા છે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'अहिंसा समता तुष्टिस्तपो दानं यशोऽयशः ।\nभवन्ति भावा भूतानां मत्त एव पृथग्विधाः ॥',
      english:
          'Non-violence, equality, satisfaction, austerity, charity, fame and disgrace—all these different qualities of beings arise from Me alone.',
      gujarati:
          'અહિંસા, સમતા, સંતોષ, તપ, દાન, યશ અને અપયશ—આ બધા વિવિધ ભાવો મારામાંથી જ ઉત્પન્ન થાય છે.',
      meaningEnglish:
          'Both positive and challenging qualities of life arise within the Divine order of existence.',
      meaningGujarati:
          'જીવનના સારા તેમજ પડકારરૂપ વિવિધ ભાવો પણ દિવ્ય વ્યવસ્થામાંથી જ ઉત્પન્ન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'महर्षयः सप्त पूर्वे चत्वारो मनवस्तथा ।\nमद्भावा मानसा जाता येषां लोक इमाः प्रजाः ॥',
      english:
          'The seven great sages, the four ancient sages, and the Manus were born from My mind; all the beings in the world descend from them.',
      gujarati:
          'સાત મહર્ષિઓ, ચાર પ્રાચીન ઋષિઓ અને મનુઓ મારા મનમાંથી ઉત્પન્ન થયા છે અને સમગ્ર જગતની પ્રજા તેમનાથી ઉત્પન્ન થઈ છે.',
      meaningEnglish:
          'The Divine is the source from which the great spiritual ancestors and cosmic orders arise.',
      meaningGujarati:
          'દિવ્ય ચેતનામાંથી મહાન ઋષિઓ અને સર્જનવ્યવસ્થાના મૂળ સ્ત્રોતો ઉત્પન્ન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'एतां विभूतिं योगं च मम यो वेत्ति तत्त्वतः ।\nसोऽविकम्पेन योगेन युज्यते नात्र संशयः ॥',
      english:
          'One who truly knows My divine manifestations and this Yoga becomes firmly united with Me through unwavering devotion. There is no doubt about this.',
      gujarati:
          'જે મારી દિવ્ય વિભૂતિઓ અને યોગને તત્ત્વથી જાણે છે, તે અડગ યોગ દ્વારા મારી સાથે જોડાય છે; તેમાં કોઈ સંશય નથી.',
      meaningEnglish:
          'Understanding Divine manifestations deeply strengthens unwavering spiritual union.',
      meaningGujarati:
          'પરમાત્માની વિભૂતિઓને તત્ત્વથી સમજવાથી સાધક અડગ યોગમાં સ્થિર થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'अहं सर्वस्य प्रभवो मत्तः सर्वं प्रवर्तते ।\nइति मत्वा भजन्ते मां बुधा भावसमन्विताः ॥',
      english:
          'I am the source of everything; everything proceeds from Me. Knowing this, the wise worship Me with deep devotion.',
      gujarati:
          'હું સમગ્ર સૃષ્ટિનો મૂળ સ્ત્રોત છું અને મારામાંથી જ બધું પ્રવર્તે છે. આ જાણીને જ્ઞાની લોકો પ્રેમ અને ભક્તિથી મારી ઉપાસના કરે છે.',
      meaningEnglish:
          'Wisdom leads the seeker to recognize the Divine as the source of all existence and worship with devotion.',
      meaningGujarati:
          'જ્ઞાની પરમાત્માને સમગ્ર અસ્તિત્વના મૂળ સ્ત્રોત તરીકે ઓળખીને ભક્તિ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'मच्चित्ता मद्गतप्राणा बोधयन्तः परस्परम् ।\nकथयन्तश्च मां नित्यं तुष्यन्ति च रमन्ति च ॥',
      english:
          'With their minds fixed on Me and their lives devoted to Me, My devotees enlighten one another about Me and always find satisfaction and joy in speaking of Me.',
      gujarati:
          'જેમના મન મારામાં સ્થિર છે અને જેમના પ્રાણ મને સમર્પિત છે, તે ભક્તો પરસ્પર મારું જ્ઞાન વહેંચે છે અને સતત મારી વાતોમાં આનંદ અને સંતોષ મેળવે છે.',
      meaningEnglish:
          'Devoted seekers find joy and fulfillment by sharing spiritual wisdom with one another.',
      meaningGujarati:
          'પરમાત્મામાં સ્થિર ભક્તો પરસ્પર આધ્યાત્મિક જ્ઞાન વહેંચીને આનંદ અને સંતોષ મેળવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'तेषां सततयुक्तानां भजतां प्रीतिपूर्वकम् ।\nददामि बुद्धियोगं तं येन मामुपयान्ति ते ॥',
      english:
          'To those who are constantly devoted to Me and worship Me with love, I give the wisdom by which they attain Me.',
      gujarati:
          'જે ભક્તો સતત પ્રેમપૂર્વક મારી ભક્તિ કરે છે, તેમને હું એવો બુદ્ધિયોગ આપું છું જેના દ્વારા તેઓ મને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'The Divine grants spiritual understanding to those who remain devoted with love.',
      meaningGujarati:
          'પ્રેમપૂર્વક સતત ભક્તિ કરનાર સાધકને પરમાત્મા આત્મજ્ઞાન તરફ દોરી જતું બુદ્ધિયોગ આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'तेषामेवानुकम्पार्थमहमज्ञानजं तमः ।\nनाशयाम्यात्मभावस्थो ज्ञानदीपेन भास्वता ॥',
      english:
          'Out of compassion for them, dwelling within their hearts, I destroy the darkness born of ignorance with the shining lamp of knowledge.',
      gujarati:
          'તેમના પર કૃપા કરવા માટે હું તેમના હૃદયમાં રહીને અજ્ઞાનથી ઉત્પન્ન થયેલા અંધકારનો તેજસ્વી જ્ઞાનદીપથી નાશ કરું છું.',
      meaningEnglish:
          'Divine grace removes ignorance by illuminating the seeker with spiritual knowledge.',
      meaningGujarati:
          'પરમાત્માની કૃપા જ્ઞાનના પ્રકાશ દ્વારા અજ્ઞાનનો અંધકાર દૂર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'अर्जुन उवाच ।\nपरं ब्रह्म परं धाम पवित्रं परमं भवान् ।\nपुरुषं शाश्वतं दिव्यमादिदेवमजं विभुम् ॥',
      english:
          'Arjuna said: You are the Supreme Brahman, the Supreme abode, the supreme purifier, the eternal divine Person, the primal Lord, unborn and all-pervading.',
      gujarati:
          'અર્જુન બોલ્યા: તમે પરબ્રહ્મ, પરમ ધામ, પરમ પવિત્ર, શાશ્વત દિવ્ય પુરુષ, આદિદેવ, અજન્મા અને સર્વવ્યાપી છો.',
      meaningEnglish:
          'Arjuna recognizes Krishna as the Supreme, eternal and all-pervading Divine reality.',
      meaningGujarati:
          'અર્જુન ભગવાનને પરબ્રહ્મ, શાશ્વત, અજન્મા અને સર્વવ્યાપી પરમ તત્ત્વ તરીકે સ્વીકારે છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'आहुस्त्वामृषयः सर्वे देवर्षिर्नारदस्तथा ।\nअसितो देवलो व्यासः स्वयं चैव ब्रवीषि मे ॥',
      english:
          'All the sages and divine sage Narada, Asita, Devala and Vyasa have declared this, and You Yourself have told me so.',
      gujarati:
          'નારદ, અસિત, દેવલ અને વ્યાસ જેવા બધા ઋષિઓએ પણ એવું જ કહ્યું છે અને તમે પોતે પણ મને આ વાત કહી છે.',
      meaningEnglish:
          'Arjuna affirms that great sages and the Lord Himself have declared the same truth.',
      meaningGujarati:
          'અર્જુન કહે છે કે મહાન ઋષિઓ અને ભગવાને પોતે પણ આ પરમ સત્યનું સમર્થન કર્યું છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'सर्वमेतदृतं मन्ये यन्मां वदसि केशव ।\nन हि ते भगवन्व्यक्तिं विदुर्देवा न दानवाः ॥',
      english:
          'O Krishna, I accept as truth all that You have told me. Neither gods nor demons can understand Your true manifestation.',
      gujarati:
          'હે કેશવ! તમે મને જે કંઈ કહ્યું છે તે બધું હું સત્ય માનું છું. દેવો કે દાનવો પણ તમારા વાસ્તવિક સ્વરૂપને સંપૂર્ણ રીતે જાણી શકતા નથી.',
      meaningEnglish:
          'Arjuna accepts the Lord’s words as truth and recognizes His transcendence.',
      meaningGujarati:
          'અર્જુન ભગવાનના વચનોને સત્ય સ્વીકારે છે અને તેમના પરાત્પર સ્વરૂપને માને છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'स्वयमेवात्मनात्मानं वेत्थ त्वं पुरुषोत्तम ।\nभूतभावन भूतिश देवदेव जगत्पते ॥',
      english:
          'O Supreme Person, Creator of beings, Lord of all beings, God of gods and Lord of the universe, You alone know Yourself by Yourself.',
      gujarati:
          'હે પુરુષોત્તમ! હે ભૂતોના સર્જક, ભૂતેશ, દેવોના દેવ અને જગતના સ્વામી! તમે જ તમારા સ્વરૂપને સંપૂર્ણ રીતે જાણો છો.',
      meaningEnglish:
          'Only the Supreme Divine can fully know the infinite nature of the Supreme Divine.',
      meaningGujarati:
          'અનંત પરમાત્માના સંપૂર્ણ સ્વરૂપને પરમાત્મા પોતે જ સંપૂર્ણ રીતે જાણે છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'वक्तुमर्हस्यशेषेण दिव्या ह्यात्मविभूतयः ।\nयाभिर्विभूतिभिर्लोकानिमांस्त्वं व्याप्य तिष्ठसि ॥',
      english:
          'Please describe completely Your divine manifestations by which You pervade and sustain all these worlds.',
      gujarati:
          'તમારી જે દિવ્ય વિભૂતિઓ દ્વારા તમે સમગ્ર જગતને વ્યાપ્ત કરીને રહો છો, તે બધી વિભૂતિઓ મને સંપૂર્ણ રીતે જણાવો.',
      meaningEnglish:
          'Arjuna asks to understand the Divine through the manifestations present throughout creation.',
      meaningGujarati:
          'અર્જુન સમગ્ર સૃષ્ટિમાં રહેલી ભગવાનની દિવ્ય વિભૂતિઓ વિશે જાણવા માંગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'कथं विद्यामहं योगिंस्त्वां सदा परिचिन्तयन् ।\nकेषु केषु च भावेषु चिन्त्योऽसि भगवन्मया ॥',
      english:
          'O Yogi, how may I constantly meditate upon You? In what forms and manifestations should I contemplate You?',
      gujarati:
          'હે યોગેશ્વર! હું સતત તમારું ધ્યાન કેવી રીતે કરું? કયા કયા સ્વરૂપોમાં હું તમારું ચિંતન કરું?',
      meaningEnglish:
          'Arjuna asks how to recognize and contemplate the Divine in everyday existence.',
      meaningGujarati:
          'અર્જુન પૂછે છે કે જીવનમાં કયા કયા સ્વરૂપો દ્વારા પરમાત્માનું સતત ચિંતન કરી શકાય.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'विस्तरेणात्मनो योगं विभूतिं च जनार्दन ।\nभूयः कथय तृप्तिर्हि शृण्वतो नास्ति मेऽमृतम् ॥',
      english:
          'O Janardana, please describe Your Yoga and divine manifestations in detail, for I never become satisfied by hearing Your immortal words.',
      gujarati:
          'હે જનાર્દન! તમારા યોગ અને દિવ્ય વિભૂતિઓનું વિસ્તૃત વર્ણન ફરીથી કરો, કારણ કે તમારા અમૃતમય વચનો સાંભળવાથી મને ક્યારેય તૃપ્તિ થતી નથી.',
      meaningEnglish:
          'Arjuna eagerly desires to hear more about the Divine and His manifestations.',
      meaningGujarati:
          'અર્જુન પરમાત્માની વિભૂતિઓ અને યોગ વિશે વધુ સાંભળવા માટે આતુર છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'श्रीभगवानुवाच ।\nहन्त ते कथयिष्यामि दिव्या ह्यात्मविभूतयः ।\nप्राधान्यतः कुरुश्रेष्ठ नास्त्यन्तो विस्तरस्य मे ॥',
      english:
          'The Supreme Lord said: O best of the Kurus, I shall now tell you My principal divine manifestations, for there is no end to the extent of My manifestations.',
      gujarati:
          'શ્રી ભગવાન બોલ્યા: હે કુરુશ્રેષ્ઠ! હવે હું મારી મુખ્ય દિવ્ય વિભૂતિઓ તને કહું છું, કારણ કે મારી વિભૂતિઓનો કોઈ અંત નથી.',
      meaningEnglish:
          'The Lord explains that His manifestations are infinite, but He will describe the principal ones.',
      meaningGujarati:
          'ભગવાન કહે છે કે તેમની વિભૂતિઓ અનંત છે, છતાં તેઓ મુખ્ય વિભૂતિઓનું વર્ણન કરશે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'अहमात्मा गुडाकेश सर्वभूताशयस्थितः ।\nअहमादिश्च मध्यं च भूतानामन्त एव च ॥',
      english:
          'O Arjuna, I am the Self dwelling in the hearts of all beings. I am their beginning, middle and end.',
      gujarati:
          'હે અર્જુન! હું બધા જીવોના હૃદયમાં રહેલો આત્મા છું. હું બધા જીવોનો આદિ, મધ્ય અને અંત છું.',
      meaningEnglish:
          'The Divine dwells within every being and is the beginning, middle and end of existence.',
      meaningGujarati:
          'પરમાત્મા દરેક જીવના હૃદયમાં રહેલા છે અને સમગ્ર અસ્તિત્વના આદિ, મધ્ય અને અંત છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'आदित्यानामहं विष्णुर्ज्योतिषां रविरंशुमान् ।\nमरीचिर्मरुतामस्मि नक्षत्राणामहं शशी ॥',
      english:
          'Among the Adityas I am Vishnu; among lights I am the radiant Sun; among the Maruts I am Marichi; among the stars I am the Moon.',
      gujarati:
          'આદિત્યોમાં હું વિષ્ણુ છું, પ્રકાશોમાં તેજસ્વી સૂર્ય છું, મરુતોમાં મરીચિ છું અને નક્ષત્રોમાં ચંદ્ર છું.',
      meaningEnglish:
          'The Divine is revealed through the most prominent and radiant expressions of creation.',
      meaningGujarati:
          'સૃષ્ટિના શ્રેષ્ઠ અને તેજસ્વી સ્વરૂપોમાં પરમાત્માની વિભૂતિ પ્રગટ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'वेदानां सामवेदोऽस्मि देवानामस्मि वासवः ।\nइन्द्रियाणां मनश्चास्मि भूतानामस्मि चेतना ॥',
      english:
          'Among the Vedas I am the Sama Veda; among the gods I am Indra; among the senses I am the mind; and in all beings I am consciousness.',
      gujarati:
          'વેદોમાં હું સામવેદ છું, દેવોમાં ઇન્દ્ર છું, ઇન્દ્રિયોમાં મન છું અને બધા જીવોમાં ચેતના છું.',
      meaningEnglish:
          'Consciousness itself is one of the clearest expressions of the Divine within living beings.',
      meaningGujarati:
          'જીવોમાં રહેલી ચેતના પરમાત્માની મહાન વિભૂતિઓમાંની એક છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'रुद्राणां शङ्करश्चास्मि वित्तेशो यक्षरक्षसाम् ।\nवसूनां पावकश्चास्मि मेरुः शिखरिणामहम् ॥',
      english:
          'Among the Rudras I am Shankara; among Yakshas and Rakshasas I am Kubera; among the Vasus I am Fire; among mountains I am Mount Meru.',
      gujarati:
          'રુદ્રોમાં હું શંકર છું, યક્ષ-રાક્ષસોમાં કુબેર છું, વસુઓમાં અગ્નિ છું અને પર્વતોમાં મેરુ છું.',
      meaningEnglish:
          'The Lord identifies Himself with the foremost expressions of power, wealth, fire and greatness.',
      meaningGujarati:
          'શક્તિ, સંપત્તિ, તેજ અને મહાનતાના શ્રેષ્ઠ સ્વરૂપોમાં ભગવાનની વિભૂતિ દર્શાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'पुरोधसां च मुख्यं मां विद्धि पार्थ बृहस्पतिम् ।\nसेनानीनामहं स्कन्दः सरसामस्मि सागरः ॥',
      english:
          'Among priests, know Me to be Brihaspati; among commanders I am Skanda; among bodies of water I am the ocean.',
      gujarati:
          'હે પાર્થ! પુરોહિતોમાં હું બૃહસ્પતિ છું, સેનાપતિઓમાં સ્કંદ છું અને જળાશયોમાં સમુદ્ર છું.',
      meaningEnglish:
          'Wisdom, leadership and vastness are represented as divine manifestations.',
      meaningGujarati:
          'જ્ઞાન, નેતૃત્વ અને વિશાળતામાં પરમાત્માની વિભૂતિનો અનુભવ કરી શકાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'महर्षीणां भृगुरहं गिरामस्म्येकमक्षरम् ।\nयज्ञानां जपयज्ञोऽस्मि स्थावराणां हिमालयः ॥',
      english:
          'Among great sages I am Bhrigu; among words I am the sacred syllable Om; among sacrifices I am the sacrifice of chanting; among immovable things I am the Himalayas.',
      gujarati:
          'મહર્ષિઓમાં હું ભૃગુ છું, વાણીઓમાં એક અક્ષર ‘ૐ’ છું, યજ્ઞોમાં જપયજ્ઞ છું અને સ્થાવર વસ્તુઓમાં હિમાલય છું.',
      meaningEnglish:
          'The Divine is reflected in spiritual wisdom, sacred sound, devotional practice and majestic stillness.',
      meaningGujarati:
          'આધ્યાત્મિક જ્ઞાન, પવિત્ર ૐકાર, જપ અને હિમાલય જેવી મહાન સ્થિરતામાં દિવ્યતા પ્રગટ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'अश्वत्थः सर्ववृक्षाणां देवर्षीणां च नारदः ।\nगन्धर्वाणां चित्ररथः सिद्धानां कपिलो मुनिः ॥',
      english:
          'Among trees I am the Ashvattha; among divine sages I am Narada; among Gandharvas I am Chitraratha; among perfected beings I am Kapila.',
      gujarati:
          'વૃક્ષોમાં હું અશ્વત્થ છું, દેવર્ષિઓમાં નારદ છું, ગંધર્વોમાં ચિત્રરથ છું અને સિદ્ધોમાં કપિલ મુનિ છું.',
      meaningEnglish:
          'The Lord identifies Himself with distinguished examples among trees, sages, celestial beings and perfected souls.',
      meaningGujarati:
          'વૃક્ષો, ઋષિઓ, દિવ્ય જીવો અને સિદ્ધ પુરુષોમાં શ્રેષ્ઠ સ્વરૂપો ભગવાનની વિભૂતિ દર્શાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'उच्चैःश्रवसमश्वानां विद्धि माममृतोद्भवम् ।\nऐरावतं गजेन्द्राणां नराणां च नराधिपम् ॥',
      english:
          'Among horses I am Ucchaihshrava, born from the ocean of nectar; among elephants I am Airavata; among humans I am the king.',
      gujarati:
          'ઘોડાઓમાં અમૃતમંથનમાંથી ઉત્પન્ન થયેલો ઉચ્ચૈઃશ્રવા હું છું, હાથીઓમાં ઐરાવત છું અને મનુષ્યોમાં રાજા છું.',
      meaningEnglish:
          'Excellence and nobility in the natural and human world are expressions of Divine glory.',
      meaningGujarati:
          'પ્રકૃતિ અને માનવજગતમાં શ્રેષ્ઠતા તથા મહાનતા પરમાત્માની વિભૂતિનું દર્શન કરાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'आयुधानामहं वज्रं धेनूनामस्मि कामधुक् ।\nप्रजनश्चास्मि कन्दर्पः सर्पाणामस्मि वासुकिः ॥',
      english:
          'Among weapons I am the thunderbolt; among cows I am Kamadhenu; I am Cupid among causes of procreation and Vasuki among serpents.',
      gujarati:
          'શસ્ત્રોમાં હું વજ્ર છું, ગાયોમાં કામધેનુ છું, પ્રજોત્પત્તિના કારણોમાં કામદેવ છું અને સર્પોમાં વાસુકિ છું.',
      meaningEnglish:
          'Power, abundance, creative energy and greatness are described as Divine manifestations.',
      meaningGujarati:
          'શક્તિ, સમૃદ્ધિ, સર્જનશક્તિ અને મહાનતાને ભગવાન પોતાની વિભૂતિ તરીકે દર્શાવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'अनन्तश्चास्मि नागानां वरुणो यादसामहम् ।\nपितॄणामर्यमा चास्मि यमः संयमतामहम् ॥',
      english:
          'Among Nagas I am Ananta; among aquatic beings I am Varuna; among ancestors I am Aryama; among rulers of discipline I am Yama.',
      gujarati:
          'નાગોમાં હું અનંત છું, જળચરોમાં વરુણ છું, પિતૃઓમાં અર્યમા છું અને નિયંત્રણ કરનારાઓમાં યમ છું.',
      meaningEnglish:
          'Infinity, order, ancestral reverence and discipline are presented as expressions of the Divine.',
      meaningGujarati:
          'અનંતતા, વ્યવસ્થા, પિતૃભાવ અને સંયમમાં પરમાત્માની વિભૂતિ દર્શાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'प्रह्लादश्चास्मि दैत्यानां कालः कलयतामहम् ।\nमृगाणां च मृगेन्द्रोऽहं वैनतेयश्च पक्षिणाम् ॥',
      english:
          'Among demons I am Prahlada; among conquerors of time I am Time; among animals I am the lion; among birds I am Garuda.',
      gujarati:
          'દૈત્યોમાં હું પ્રહ્લાદ છું, સમયને ગણનારા બધામાં હું કાળ છું, પ્રાણીઓમાં સિંહ છું અને પક્ષીઓમાં ગરુડ છું.',
      meaningEnglish:
          'Devotion, time, strength and majesty are highlighted as Divine manifestations.',
      meaningGujarati:
          'ભક્તિ, કાળ, શક્તિ અને મહાનતા ભગવાનની વિભૂતિ તરીકે દર્શાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 31,
      sanskrit:
          'पवनः पवतामस्मि रामः शस्त्रभृतामहम् ।\nझषाणां मकरश्चास्मि स्रोतसामस्मि जाह्नवी ॥',
      english:
          'Among purifiers I am the wind; among warriors I am Rama; among aquatic creatures I am the crocodile; among rivers I am the Ganga.',
      gujarati:
          'પવિત્ર કરનારાઓમાં હું પવન છું, શસ્ત્રધારીઓમાં રામ છું, જળચરોમાં મગર છું અને નદીઓમાં ગંગા છું.',
      meaningEnglish:
          'Purity, courage, strength and sacredness are represented through Divine manifestations.',
      meaningGujarati:
          'પવિત્રતા, શૌર્ય, શક્તિ અને પવિત્ર પ્રવાહોમાં ભગવાનની દિવ્યતા અનુભવી શકાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit:
          'सर्गाणामादिरन्तश्च मध्यं चैवाहमर्जुन ।\nअध्यात्मविद्या विद्यानां वादः प्रवदतामहम् ॥',
      english:
          'I am the beginning, middle and end of all creation. Among sciences I am the science of the Self, and among discussions I am the logical conclusion.',
      gujarati:
          'હે અર્જુન! સૃષ્ટિનો આદિ, મધ્ય અને અંત હું છું. વિદ્યાઓમાં આત્મવિદ્યા અને ચર્ચા કરનારાઓમાં તત્ત્વપૂર્ણ વાદ હું છું.',
      meaningEnglish:
          'The Divine encompasses the entire process of creation and the highest form of spiritual knowledge.',
      meaningGujarati:
          'પરમાત્મા સમગ્ર સર્જનને વ્યાપે છે અને વિદ્યાઓમાં આત્મવિદ્યા સર્વોચ્ચ જ્ઞાનનું પ્રતિનિધિત્વ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit:
          'अक्षराणामकारोऽस्मि द्वन्द्वः सामासिकस्य च ।\nअहमेवाक्षयः कालो धाताहं विश्वतोमुखः ॥',
      english:
          'Among letters I am the letter A; among compounds I am the dual compound. I am the imperishable Time and the universal sustainer.',
      gujarati:
          'અક્ષરોમાં હું ‘અ’ છું, સમાસોમાં દ્વંદ્વ સમાસ છું. હું અક્ષય કાળ છું અને સર્વ દિશામાં મુખ ધરાવતો વિશ્વધાતા છું.',
      meaningEnglish:
          'The Divine is present in language, time and the universal sustaining principle.',
      meaningGujarati:
          'ભાષા, કાળ અને સમગ્ર વિશ્વને ધારણ કરનારા તત્ત્વમાં પરમાત્માની વિભૂતિ રહેલી છે.',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit:
          'मृत्युः सर्वहरश्चाहमुद्भवश्च भविष्यताम् ।\nकीर्तिः श्रीर्वाक्च नारीणां स्मृतिर्मेधा धृतिः क्षमा ॥',
      english:
          'I am all-devouring death and also the source of all future beings. Among feminine qualities I am fame, prosperity, speech, memory, intelligence, firmness and forgiveness.',
      gujarati:
          'હું બધું હરી લેતો મૃત્યુ છું અને ભવિષ્યમાં જન્મનાર જીવોની ઉત્પત્તિ પણ છું. સ્ત્રીઓમાં કીર્તિ, શ્રી, વાણી, સ્મૃતિ, મેધા, ધૃતિ અને ક્ષમા હું છું.',
      meaningEnglish:
          'The Divine encompasses both the ending of life and the qualities that sustain human greatness and virtue.',
      meaningGujarati:
          'પરમાત્મા જીવનના અંતરૂપ મૃત્યુમાં પણ છે અને કીર્તિ, બુદ્ધિ, ધૈર્ય તથા ક્ષમા જેવા ગુણોમાં પણ પ્રગટે છે.',
    ),

    SacredVerseModel(
      verseNumber: 35,
      sanskrit:
          'बृहत्साम तथा साम्नां गायत्री छन्दसामहम् ।\nमासानां मार्गशीर्षोऽहमृतूनां कुसुमाकरः ॥',
      english:
          'Among hymns I am the Brihat-Sama; among meters I am Gayatri; among months I am Margashirsha; among seasons I am spring.',
      gujarati:
          'સામગાનમાં હું બૃહત્સામ છું, છંદોમાં ગાયત્રી છું, મહિનાઓમાં માર્ગશીર્ષ છું અને ઋતુઓમાં વસંત છું.',
      meaningEnglish:
          'The finest expressions of sacred music, poetry, time and natural beauty are Divine manifestations.',
      meaningGujarati:
          'પવિત્ર સંગીત, છંદ, સમય અને પ્રકૃતિની સુંદરતાના શ્રેષ્ઠ સ્વરૂપોમાં પરમાત્માની વિભૂતિ જોવા મળે છે.',
    ),

    SacredVerseModel(
      verseNumber: 36,
      sanskrit:
          'द्यूतं छलयतामस्मि तेजस्तेजस्विनामहम् ।\nजयोऽस्मि व्यवसायोऽस्मि सत्त्वं सत्त्ववतामहम् ॥',
      english:
          'Among the deceitful I am gambling; among the splendid I am splendour. I am victory, determination and the goodness of the good.',
      gujarati:
          'છલ કરનારાઓમાં હું જુગાર છું, તેજસ્વીઓનું તેજ છું. હું વિજય, દૃઢ નિશ્ચય અને સાત્વિક લોકોનું સત્વ છું.',
      meaningEnglish:
          'The Lord is the source of power, brilliance, determination and excellence wherever they appear.',
      meaningGujarati:
          'શક્તિ, તેજ, દૃઢ નિશ્ચય અને સત્વ જેવા ગુણોમાં પરમાત્માની શક્તિ પ્રગટ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 37,
      sanskrit:
          'वृष्णीनां वासुदेवोऽस्मि पाण्डवानां धनञ्जयः ।\nमुनीनामप्यहं व्यासः कवीनामुशना कविः ॥',
      english:
          'Among the Vrishnis I am Vasudeva; among the Pandavas I am Arjuna; among sages I am Vyasa; among poets I am Ushana.',
      gujarati:
          'વૃષ્ણિઓમાં હું વાસુદેવ છું, પાંડવોમાં ધનંજય અર્જુન છું, મુનિઓમાં વ્યાસ છું અને કવિઓમાં ઉશના કવિ છું.',
      meaningEnglish:
          'The Divine is represented through distinguished personalities known for wisdom, courage and creative insight.',
      meaningGujarati:
          'જ્ઞાન, શૌર્ય અને સર્જનાત્મક પ્રજ્ઞા ધરાવતા શ્રેષ્ઠ પુરુષોમાં ભગવાનની વિભૂતિ દર્શાવવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 38,
      sanskrit:
          'दण्डो दमयतामस्मि नीतिरस्मि जिगीषताम् ।\nमौनं चैवास्मि गुह्यानां ज्ञानं ज्ञानवतामहम् ॥',
      english:
          'Among punishers I am discipline; among those seeking victory I am strategy. Among secrets I am silence, and among the wise I am knowledge.',
      gujarati:
          'દંડ આપનારાઓમાં હું દંડ છું, વિજય ઇચ્છનારાઓમાં નીતિ છું. ગુપ્ત વસ્તુઓમાં મૌન અને જ્ઞાની લોકોમાં જ્ઞાન હું છું.',
      meaningEnglish:
          'Discipline, wise strategy, silence and knowledge are expressions of Divine intelligence.',
      meaningGujarati:
          'સંયમ, નીતિ, મૌન અને જ્ઞાનમાં પરમાત્માની બુદ્ધિ અને શક્તિ પ્રગટ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 39,
      sanskrit:
          'यच्चापि सर्वभूतानां बीजं तदहमर्जुन ।\nन तदस्ति विना यत्स्यान्मया भूतं चराचरम् ॥',
      english:
          'O Arjuna, I am also the seed of all beings. Nothing moving or unmoving can exist without Me.',
      gujarati:
          'હે અર્જુન! હું બધા જીવોનું બીજ પણ છું. મારા વિના ચર કે અચર કોઈ પણ વસ્તુનું અસ્તિત્વ નથી.',
      meaningEnglish:
          'The Divine is the fundamental source and sustaining principle of every living and non-living existence.',
      meaningGujarati:
          'ચર અને અચર સમગ્ર અસ્તિત્વના મૂળમાં પરમાત્મા જ આધારરૂપ છે.',
    ),

    SacredVerseModel(
      verseNumber: 40,
      sanskrit:
          'नान्तोऽस्ति मम दिव्यानां विभूतीनां परन्तप ।\nएष तूद्देशतः प्रोक्तो विभूतेर्विस्तरो मया ॥',
      english:
          'O conqueror of foes, there is no end to My divine manifestations. I have only briefly described some of them.',
      gujarati:
          'હે પરંતપ! મારી દિવ્ય વિભૂતિઓનો કોઈ અંત નથી. મેં માત્ર ઉદાહરણરૂપે મારી વિભૂતિઓનો થોડો વિસ્તાર કહ્યો છે.',
      meaningEnglish:
          'The Divine manifestations are infinite, and only a small portion has been described.',
      meaningGujarati:
          'પરમાત્માની દિવ્ય વિભૂતિઓ અનંત છે અને અહીં માત્ર થોડાં મુખ્ય ઉદાહરણો જણાવવામાં આવ્યા છે.',
    ),

    SacredVerseModel(
      verseNumber: 41,
      sanskrit:
          'यद्यद्विभूतिमत्सत्त्वं श्रीमदूर्जितमेव वा ।\nतत्तदेवावगच्छ त्वं मम तेजोंऽशसम्भवम् ॥',
      english:
          'Whatever being is glorious, beautiful or powerful, know that it arises from a portion of My divine splendour.',
      gujarati:
          'જ્યાં ક્યાં કોઈ મહાન, સુંદર, તેજસ્વી અથવા શક્તિશાળી વસ્તુ દેખાય, ત્યાં તેને મારા દિવ્ય તેજના અંશમાંથી ઉત્પન્ન થયેલી જાણ.',
      meaningEnglish:
          'Whenever greatness, beauty or power appears, it can be recognized as an expression of Divine splendour.',
      meaningGujarati:
          'જ્યાં મહાનતા, સુંદરતા અથવા શક્તિ દેખાય ત્યાં પરમાત્માના દિવ્ય તેજનો અંશ સમજવો.',
    ),

    SacredVerseModel(
      verseNumber: 42,
      sanskrit:
          'अथवा बहुनैतेन किं ज्ञातेन तवार्जुन ।\nविष्टभ्याहमिदं कृत्स्नमेकांशेन स्थितो जगत् ॥',
      english:
          'But what need is there, O Arjuna, for all this detailed knowledge? With a single portion of Myself I pervade and sustain the entire universe.',
      gujarati:
          'હે અર્જુન! આટલું બધું જાણવાની જરૂર શું છે? હું મારા માત્ર એક અંશથી સમગ્ર જગતને વ્યાપ્ત કરીને તેને ધારણ કરું છું.',
      meaningEnglish:
          'The entire universe is sustained by only a fraction of the Divine presence.',
      meaningGujarati:
          'સમગ્ર બ્રહ્માંડ પરમાત્માની દિવ્ય શક્તિના માત્ર એક અંશથી જ વ્યાપ્ત અને ધારણ થયેલું છે.',
    ),
  ];
}
// =====================================================
// BHAGAVAD GITA - CHAPTER 11
// Vishwaroopa Darshana Yoga
// =====================================================

static List<SacredVerseModel> _gitaChapter11Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit: '''
मदनुग्रहाय परमं गुह्यमध्यात्मसंज्ञितम् ।
यत्त्वयोक्तं वचस्तेन मोहोऽयं विगतो मम ॥
''',
      english:
          'Arjuna said: By Your grace, You have spoken the supreme and secret knowledge of the Self, and my delusion has now disappeared.',
      gujarati:
          'અર્જુન બોલ્યા: મારા પર કૃપા કરવા માટે તમે જે પરમ ગુપ્ત આત્મજ્ઞાન આપ્યું છે, તે સાંભળવાથી મારો મોહ દૂર થઈ ગયો છે.',
      meaningEnglish:
          'Arjuna says that Krishna’s spiritual teachings have removed his confusion and delusion.',
      meaningGujarati:
          'અર્જુન કહે છે કે ભગવાન શ્રીકૃષ્ણના આત્મજ્ઞાનથી તેમનો મોહ અને મૂંઝવણ દૂર થઈ ગઈ છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit: '''
भवाप्ययौ हि भूतानां श्रुतौ विस्तरशो मया ।
त्वत्तः कमलपत्राक्ष माहात्म्यमपि चाव्ययम् ॥
''',
      english:
          'O lotus-eyed Lord, I have heard from You in detail about the origin and dissolution of beings and also about Your imperishable greatness.',
      gujarati:
          'હે કમળનયન! મેં તમારી પાસેથી જીવોની ઉત્પત્તિ અને વિનાશ તથા તમારા અવિનાશી મહાત્મ્યનું વિસ્તૃત વર્ણન સાંભળ્યું છે.',
      meaningEnglish:
          'Arjuna has heard about the creation and dissolution of beings and Krishna’s eternal greatness.',
      meaningGujarati:
          'અર્જુને જીવોની ઉત્પત્તિ-વિનાશ અને ભગવાનના અવિનાશી મહાત્મ્ય વિશે વિસ્તૃત રીતે સાંભળ્યું છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit: '''
एवमेतद्यथात्थ त्वमात्मानं परमेश्वर ।
द्रष्टुमिच्छामि ते रूपमैश्वरं पुरुषोत्तम ॥
''',
      english:
          'O Supreme Lord, what You have said about Yourself is exactly so. O Supreme Person, I wish to see Your divine cosmic form.',
      gujarati:
          'હે પરમેશ્વર! તમે તમારા વિશે જે કહ્યું છે તે હું સત્ય માનું છું. હે પુરુષોત્તમ! હું તમારું ઐશ્વર્યમય વિશ્વરૂપ જોવા ઇચ્છું છું.',
      meaningEnglish:
          'Arjuna accepts Krishna’s words as truth and asks to see His divine universal form.',
      meaningGujarati:
          'અર્જુન ભગવાનના વચનોને સત્ય માનીને તેમના દિવ્ય વિશ્વરૂપના દર્શનની ઇચ્છા વ્યક્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit: '''
मन्यसे यदि तच्छक्यं मया द्रष्टुमिति प्रभो ।
योगेश्वर ततो मे त्वं दर्शयात्मानमव्ययम् ॥
''',
      english:
          'O Lord of Yoga, if You think I am capable of seeing it, then please show me Your imperishable divine form.',
      gujarati:
          'હે યોગેશ્વર! જો તમે માનો કે હું તમારું તે સ્વરૂપ જોઈ શકું છું, તો મને તમારું અવિનાશી વિશ્વરૂપ દર્શાવો.',
      meaningEnglish:
          'Arjuna humbly asks Krishna to reveal the imperishable cosmic form if he is worthy of seeing it.',
      meaningGujarati:
          'અર્જુન વિનમ્રતાથી ભગવાનને વિનંતી કરે છે કે જો તે યોગ્ય હોય તો તેમને અવિનાશી વિશ્વરૂપ દર્શાવે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit: '''
श्रीभगवानुवाच ।
पश्य मे पार्थ रूपाणि शतशोऽथ सहस्रशः ।
नानाविधानि दिव्यानि नानावर्णाकृतीनि च ॥
''',
      english:
          'The Supreme Lord said: O Arjuna, behold My hundreds and thousands of divine forms, of various kinds, colours and shapes.',
      gujarati:
          'શ્રી ભગવાન બોલ્યા: હે પાર્થ! મારા સેંકડો અને હજારો પ્રકારના, વિવિધ રંગો અને આકારવાળા દિવ્ય સ્વરૂપોને જો.',
      meaningEnglish:
          'Krishna begins revealing His countless divine manifestations in many forms, colours and shapes.',
      meaningGujarati:
          'ભગવાન શ્રીકૃષ્ણ પોતાના અસંખ્ય દિવ્ય અને વિવિધ સ્વરૂપો અર્જુનને દર્શાવવાનું શરૂ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit: '''
पश्यादित्यान्वसून्रुद्रानश्विनौ मरुतस्तथा ।
बहून्यदृष्टपूर्वाणि पश्याश्चर्याणि भारत ॥
''',
      english:
          'Behold the Adityas, Vasus, Rudras, Ashvins and Maruts, and many other wonderful forms never seen before.',
      gujarati:
          'હે ભારત! આદિત્યો, વસુઓ, રુદ્રો, અશ્વિનીકુમારો અને મરુતોને તથા પહેલાં ક્યારેય ન જોયેલા અનેક અદ્ભુત સ્વરૂપોને જો.',
      meaningEnglish:
          'Krishna tells Arjuna to behold the divine beings and many extraordinary forms never seen before.',
      meaningGujarati:
          'ભગવાન અર્જુનને વિવિધ દેવસમૂહો અને પહેલાં ક્યારેય ન જોયેલા અદ્ભુત સ્વરૂપો જોવા કહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit: '''
इहैकस्थं जगत्कृत्स्नं पश्याद्य सचराचरम् ।
मम देहे गुडाकेश यच्चान्यद्द्रष्टुमिच्छसि ॥
''',
      english:
          'O Arjuna, behold the entire universe, with everything moving and unmoving, gathered together in My body, along with whatever else you wish to see.',
      gujarati:
          'હે અર્જુન! મારા શરીરમાં એક જ સ્થળે સમગ્ર ચરાચર જગત તથા તું જે કંઈ જોવા ઇચ્છે છે તે બધું જો.',
      meaningEnglish:
          'The entire moving and unmoving universe is present within Krishna’s divine form.',
      meaningGujarati:
          'સમગ્ર ચરાચર જગત ભગવાનના દિવ્ય શરીરમાં એક જ સ્થળે સમાયેલું છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit: '''
न तु मां शक्यसे द्रष्टुमनेनैव स्वचक्षुषा ।
दिव्यं ददामि ते चक्षुः पश्य मे योगमैश्वरम् ॥
''',
      english:
          'You cannot see Me with Your ordinary eyes. Therefore I give you divine vision; behold My divine Yoga.',
      gujarati:
          'તું મને આ સામાન્ય આંખોથી જોઈ શકતો નથી. તેથી હું તને દિવ્ય દૃષ્ટિ આપું છું; મારી ઐશ્વર્યમય યોગશક્તિને જો.',
      meaningEnglish:
          'Ordinary human vision cannot perceive the cosmic form, so Krishna grants Arjuna divine vision.',
      meaningGujarati:
          'સામાન્ય માનવીય દૃષ્ટિથી વિશ્વરૂપ જોઈ શકાતું નથી, તેથી ભગવાન અર્જુનને દિવ્ય દૃષ્ટિ આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit: '''
सञ्जय उवाच ।
एवमुक्त्वा ततो राजन्महायोगेश्वरो हरिः ।
दर्शयामास पार्थाय परमं रूपमैश्वरम् ॥
''',
      english:
          'Sanjaya said: Having spoken thus, the great Lord of Yoga revealed His supreme divine form to Arjuna.',
      gujarati:
          'સંજય બોલ્યા: હે રાજન! મહાન યોગેશ્વર શ્રીહરિએ આ પ્રમાણે કહીને અર્જુનને પોતાનું પરમ ઐશ્વર્યમય સ્વરૂપ દર્શાવ્યું.',
      meaningEnglish:
          'Sanjaya describes Krishna revealing His supreme universal form to Arjuna.',
      meaningGujarati:
          'સંજય જણાવે છે કે ભગવાન શ્રીકૃષ્ણે અર્જુનને પોતાનું પરમ ઐશ્વર્યમય વિશ્વરૂપ દર્શાવ્યું.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit: '''
अनेकवक्त्रनयनमनेकाद्भुतदर्शनम् ।
अनेकदिव्याभरणं दिव्यानेकोद्यतायुधम् ॥
''',
      english:
          'The Lord appeared with countless faces and eyes, countless wonderful visions, divine ornaments and heavenly weapons.',
      gujarati:
          'તે વિશ્વરૂપમાં અસંખ્ય મુખ અને આંખો, અદ્ભુત દર્શનો, દિવ્ય આભૂષણો અને અનેક દિવ્ય શસ્ત્રો હતાં.',
      meaningEnglish:
          'The cosmic form contains countless faces, eyes, divine ornaments and weapons.',
      meaningGujarati:
          'વિશ્વરૂપમાં અસંખ્ય મુખ, આંખો, દિવ્ય આભૂષણો અને શસ્ત્રોનું અદ્ભુત દર્શન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit: '''
दिव्यमाल्याम्बरधरं दिव्यगन्धानुलेपनम् ।
सर्वाश्चर्यमयं देवमनन्तं विश्वतोमुखम् ॥
''',
      english:
          'Adorned with divine garlands and garments, anointed with divine fragrances, infinite and facing in every direction.',
      gujarati:
          'દિવ્ય માળા અને વસ્ત્રોથી શોભતા, દિવ્ય સુગંધથી યુક્ત, અનંત અને સર્વ દિશામાં મુખ ધરાવતા ભગવાનનું સ્વરૂપ હતું.',
      meaningEnglish:
          'The universal form is infinite, divine and present in every direction.',
      meaningGujarati:
          'વિશ્વરૂપ અનંત, દિવ્ય અને સર્વ દિશામાં વ્યાપ્ત છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit: '''
दिवि सूर्यसहस्रस्य भवेद्युगपदुत्थिता ।
यदि भाः सदृशी सा स्याद्भासस्तस्य महात्मनः ॥
''',
      english:
          'If a thousand suns were to rise simultaneously in the sky, their brilliance might resemble the splendour of that great Being.',
      gujarati:
          'આકાશમાં એકસાથે હજાર સૂર્યો ઉગે તો જેવો પ્રકાશ થાય, તે કદાચ તે મહાત્માના તેજ સમાન હોય.',
      meaningEnglish:
          'The brilliance of the cosmic form is compared to the combined radiance of a thousand suns.',
      meaningGujarati:
          'વિશ્વરૂપના અતિશય તેજની તુલના એકસાથે ઉગેલા હજાર સૂર્યોના પ્રકાશ સાથે કરવામાં આવી છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit: '''
तत्रैकस्थं जगत्कृत्स्नं प्रविभक्तमनेकधा ।
अपश्यद्देवदेवस्य शरीरे पाण्डवस्तदा ॥
''',
      english:
          'Arjuna then saw the entire universe, divided into many forms, gathered together in the body of the Lord of lords.',
      gujarati:
          'ત્યારે અર્જુને દેવોના દેવના શરીરમાં અનેક પ્રકારમાં વિભાજિત થયેલું સમગ્ર જગત એક જ સ્થાને જોયું.',
      meaningEnglish:
          'Arjuna sees the whole universe gathered within Krishna’s divine body.',
      meaningGujarati:
          'અર્જુન ભગવાનના દિવ્ય શરીરમાં સમગ્ર જગતને એક જ સ્થળે સમાયેલું જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit: '''
ततः स विस्मयाविष्टो हृष्टरोमा धनञ्जयः ।
प्रणम्य शिरसा देवं कृताञ्जलिरभाषत ॥
''',
      english:
          'Then Arjuna, filled with wonder and with his hair standing on end, bowed his head to the Lord and spoke with folded hands.',
      gujarati:
          'આ વિશ્વરૂપ જોઈને અર્જુન આશ્ચર્યથી ભરાઈ ગયા, તેમના રોમાંચ ઊભા થઈ ગયા અને માથું નમાવી હાથ જોડીને ભગવાનને કહેવા લાગ્યા.',
      meaningEnglish:
          'Overwhelmed by awe, Arjuna bows before Krishna with folded hands.',
      meaningGujarati:
          'વિશ્વરૂપના દર્શનથી અર્જુન આશ્ચર્ય અને ભક્તિથી ભરાઈ ભગવાનને નમન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit: '''
अर्जुन उवाच ।
पश्यामि देवांस्तव देव देहे
सर्वांस्तथा भूतविशेषसङ्घान् ।
ब्रह्माणमीशं कमलासनस्थम्
ऋषींश्च सर्वानुरगांश्च दिव्यान् ॥
''',
      english:
          'Arjuna said: O Lord, I see all the gods and all varieties of beings in Your body, along with Brahma seated on the lotus, Shiva and all the divine sages and serpents.',
      gujarati:
          'અર્જુન બોલ્યા: હે દેવ! તમારા શરીરમાં બધા દેવો, વિવિધ પ્રકારના જીવો, કમળ પર બેઠેલા બ્રહ્મા, ઈશ્વર શિવ, બધા ઋષિઓ અને દિવ્ય નાગોને હું જોઈ રહ્યો છું.',
      meaningEnglish:
          'Arjuna sees gods, beings, Brahma, Shiva, sages and divine serpents within Krishna’s form.',
      meaningGujarati:
          'અર્જુન ભગવાનના વિશ્વરૂપમાં દેવો, જીવો, બ્રહ્મા, શિવ, ઋષિઓ અને દિવ્ય નાગોને જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit: '''
अनेकबाहूदरवक्त्रनेत्रं
पश्यामि त्वां सर्वतोऽनन्तरूपम् ।
नान्तं न मध्यं न पुनस्तवादिं
पश्यामि विश्वेश्वर विश्वरूप ॥
''',
      english:
          'I see You with countless arms, stomachs, mouths and eyes, infinite in every direction. I see neither Your beginning, middle nor end, O Lord of the universe.',
      gujarati:
          'હે વિશ્વેશ્વર! હું તમને અસંખ્ય હાથ, પેટ, મુખ અને આંખોવાળા અનંત સ્વરૂપમાં જોઈ રહ્યો છું. તમારા આદિ, મધ્ય કે અંતને હું જોઈ શકતો નથી.',
      meaningEnglish:
          'Arjuna cannot find any beginning, middle or end to Krishna’s infinite universal form.',
      meaningGujarati:
          'અર્જુન ભગવાનના અનંત વિશ્વરૂપનો કોઈ આદિ, મધ્ય કે અંત જોઈ શકતા નથી.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit: '''
किरीटिनं गदिनं चक्रिणं च
तेजोराशिं सर्वतोदीप्तिमन्तम् ।
पश्यामि त्वां दुर्निरीक्ष्यं समन्ताद्
दीप्तानलार्कद्युतिमप्रमेयम् ॥
''',
      english:
          'I see You crowned, armed with mace and discus, shining like a mass of blazing light, difficult to behold, radiant like fire and the sun.',
      gujarati:
          'હું તમને મુગટધારી, ગદા અને ચક્ર ધારણ કરેલા, ચારે તરફ પ્રકાશ ફેલાવતા અને અગ્નિ તથા સૂર્ય સમાન તેજસ્વી જોઈ રહ્યો છું.',
      meaningEnglish:
          'Arjuna sees Krishna crowned and armed, radiating an immeasurable brilliance like fire and the sun.',
      meaningGujarati:
          'અર્જુન ભગવાનને મુગટ, ગદા અને ચક્ર સાથે અગ્નિ અને સૂર્ય સમાન અપરિમિત તેજવાળા જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit: '''
त्वमक्षरं परमं वेदितव्यं
त्वमस्य विश्वस्य परं निधानम् ।
त्वमव्ययः शाश्वतधर्मगोप्ता
सनातनस्त्वं पुरुषो मतो मे ॥
''',
      english:
          'You are the imperishable Supreme Reality to be known. You are the ultimate support of this universe, the eternal protector of righteousness and the everlasting Supreme Person.',
      gujarati:
          'તમે જાણવાલાયક પરમ અક્ષર બ્રહ્મ છો. તમે સમગ્ર વિશ્વનો પરમ આધાર છો, શાશ્વત ધર્મના રક્ષક અને સનાતન પુરુષ છો.',
      meaningEnglish:
          'Arjuna recognizes Krishna as the imperishable Supreme Reality and eternal protector of dharma.',
      meaningGujarati:
          'અર્જુન ભગવાનને પરમ અક્ષર તત્ત્વ અને શાશ્વત ધર્મના રક્ષક તરીકે ઓળખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit: '''
अनादिमध्यान्तमनन्तवीर्यम्
अनन्तबाहुं शशिसूर्यनेत्रम् ।
पश्यामि त्वां दीप्तहुताशवक्त्रं
स्वतेजसा विश्वमिदं तपन्तम् ॥
''',
      english:
          'You have no beginning, middle or end, infinite power and countless arms. With the sun and moon as Your eyes and blazing fire as Your mouth, You illuminate and heat the universe.',
      gujarati:
          'તમારો આદિ, મધ્ય કે અંત નથી; તમારી શક્તિ અનંત છે અને હાથ અસંખ્ય છે. સૂર્ય-ચંદ્ર તમારી આંખો છે અને અગ્નિ સમાન મુખથી તમે સમગ્ર જગતને પ્રકાશિત કરો છો.',
      meaningEnglish:
          'Krishna is eternal and infinite, with the sun and moon as His eyes and blazing fire as His mouth.',
      meaningGujarati:
          'ભગવાન અનાદિ અને અનંત છે; સૂર્ય-ચંદ્ર તેમની આંખો અને અગ્નિ તેમનું મુખ દર્શાવવામાં આવ્યું છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit: '''
द्यावापृथिव्योरिदमन्तरं हि
व्याप्तं त्वयैकेन दिशश्च सर्वाः ।
दृष्ट्वाद्भुतं रूपमुग्रं तवेदं
लोकत्रयं प्रव्यथितं महात्मन् ॥
''',
      english:
          'The space between heaven and earth and all directions are filled by You alone. Seeing Your wondrous and terrible form, the three worlds are trembling.',
      gujarati:
          'સ્વર્ગ અને પૃથ્વી વચ્ચેનું સમગ્ર અંતર તથા બધી દિશાઓ તમારા દ્વારા જ વ્યાપ્ત છે. તમારું અદ્ભુત અને ભયંકર સ્વરૂપ જોઈને ત્રણેય લોક કંપી રહ્યા છે.',
      meaningEnglish:
          'Krishna’s cosmic form fills all space, causing the three worlds to tremble with awe.',
      meaningGujarati:
          'ભગવાનનું વિશ્વરૂપ સમગ્ર અવકાશમાં વ્યાપ્ત હોવાથી ત્રણેય લોક તેના અદ્ભુત અને ઉગ્ર સ્વરૂપથી કંપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit: '''
अमी हि त्वां सुरसङ्घा विशन्ति
केचिद्भीताः प्राञ्जलयो गृणन्ति ।
स्वस्तीत्युक्त्वा महर्षिसिद्धसङ्घाः
स्तुवन्ति त्वां स्तुतिभिः पुष्कलाभिः ॥
''',
      english:
          'The hosts of gods enter You; some, frightened, pray with folded hands. Great sages and perfected beings praise You with abundant hymns.',
      gujarati:
          'દેવતાઓના સમૂહો તમારામાં પ્રવેશી રહ્યા છે, કેટલાક ભયભીત થઈ હાથ જોડીને પ્રાર્થના કરે છે. મહર્ષિઓ અને સિદ્ધોના સમૂહો વિવિધ સ્તુતિઓથી તમારી પ્રશંસા કરે છે.',
      meaningEnglish:
          'Gods, sages and perfected beings respond to the cosmic form with reverence, prayer and praise.',
      meaningGujarati:
          'દેવો, મહર્ષિઓ અને સિદ્ધો વિશ્વરૂપ સામે ભક્તિ, પ્રાર્થના અને સ્તુતિ દ્વારા નમન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit: '''
रुद्रादित्या वसवो ये च साध्या
विश्वेऽश्विनौ मरुतश्चोष्मपाश्च ।
गन्धर्वयक्षासुरसिद्धसङ्घा
वीक्षन्ते त्वां विस्मिताश्चैव सर्वे ॥
''',
      english:
          'The Rudras, Adityas, Vasus, Sadhyas, Vishvedevas, Ashvins, Maruts, ancestors, Gandharvas, Yakshas, Asuras and Siddhas—all behold You in wonder.',
      gujarati:
          'રુદ્રો, આદિત્યો, વસુઓ, સાધ્યો, વિશ્વેદેવો, અશ્વિનીકુમારો, મરુતો, પિતૃઓ, ગંધર્વો, યક્ષો, અસુરો અને સિદ્ધો બધા આશ્ચર્યથી તમને જોઈ રહ્યા છે.',
      meaningEnglish:
          'Many divine and supernatural beings behold Krishna’s universal form with amazement.',
      meaningGujarati:
          'વિવિધ દેવો, પિતૃઓ, ગંધર્વો, યક્ષો, અસુરો અને સિદ્ધો ભગવાનના વિશ્વરૂપને આશ્ચર્યથી જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit: '''
रूपं महत्ते बहुवक्त्रनेत्रं
महाबाहो बहुबाहूरुपादम् ।
बहूदरं बहुदंष्ट्राकरालं
दृष्ट्वा लोकाः प्रव्यथितास्तथाहम् ॥
''',
      english:
          'Seeing Your immense form with many mouths, eyes, arms, thighs, feet, stomachs and terrible teeth, the worlds are terrified, and so am I.',
      gujarati:
          'હે મહાબાહુ! તમારા અનેક મુખ, આંખો, હાથ, પગ, પેટ અને ભયંકર દાંતવાળા વિશાળ સ્વરૂપને જોઈને બધા લોકોની જેમ હું પણ ભયભીત થયો છું.',
      meaningEnglish:
          'The terrifying magnitude of the universal form frightens both the worlds and Arjuna.',
      meaningGujarati:
          'વિશ્વરૂપની વિશાળતા અને ભયંકરતા જોઈને ત્રણેય લોક તથા અર્જુન ભયભીત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit: '''
नभःस्पृशं दीप्तमनेकवर्णं
व्यात्ताननं दीप्तविशालनेत्रम् ।
दृष्ट्वा हि त्वां प्रव्यथितान्तरात्मा
धृतिं न विन्दामि शमं च विष्णो ॥
''',
      english:
          'Seeing You touching the sky, blazing with many colours, with wide-open mouths and huge shining eyes, my inner self trembles and I find neither courage nor peace.',
      gujarati:
          'આકાશને સ્પર્શતા, અનેક રંગોથી તેજસ્વી, વિશાળ ખુલ્લા મુખ અને પ્રજ્વલિત આંખોવાળા તમને જોઈને મારું અંતર કંપી રહ્યું છે; મને ધીરજ કે શાંતિ મળતી નથી.',
      meaningEnglish:
          'The overwhelming cosmic vision leaves Arjuna trembling and without peace.',
      meaningGujarati:
          'વિશ્વરૂપના ભયંકર અને તેજસ્વી દર્શનથી અર્જુનનું અંતર કંપે છે અને તેમને શાંતિ મળતી નથી.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit: '''
दंष्ट्राकरालानि च ते मुखानि
दृष्ट्वैव कालानलसन्निभानि ।
दिशो न जाने न लभे च शर्म
प्रसीद देवेश जगन्निवास ॥
''',
      english:
          'Seeing Your terrible mouths with fearful teeth, resembling the fire of destruction, I cannot recognize the directions or find peace. O Lord of gods, be gracious to me.',
      gujarati:
          'પ્રલયના અગ્નિ જેવા ભયંકર દાંતવાળા તમારા મુખોને જોઈને મને દિશાઓનું જ્ઞાન રહેતું નથી અને શાંતિ મળતી નથી. હે દેવેશ! હે જગતના આશ્રય! મારા પર પ્રસન્ન થાઓ.',
      meaningEnglish:
          'Arjuna becomes completely overwhelmed by the destructive appearance of Krishna’s mouths and asks for mercy.',
      meaningGujarati:
          'વિનાશના અગ્નિ જેવા ભયંકર મુખોથી અર્જુન વ્યાકુળ થઈ ભગવાનની કૃપા માગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit: '''
अमी च त्वां धृतराष्ट्रस्य पुत्राः
सर्वे सहैवावनिपालसङ्घैः ।
भीष्मो द्रोणः सूतपुत्रस्तथासौ
सहास्मदीयैरपि योधमुख्यैः ॥
''',
      english:
          'All the sons of Dhritarashtra, along with the kings and great warriors, Bhishma, Drona, Karna and our own warriors are rushing into Your terrible mouths.',
      gujarati:
          'ધૃતરાષ્ટ્રના બધા પુત્રો, રાજાઓ, ભીષ્મ, દ્રોણ, કર્ણ તથા આપણા પક્ષના મુખ્ય યોદ્ધાઓ પણ તમારા ભયંકર મુખોમાં ઝડપથી પ્રવેશી રહ્યા છે.',
      meaningEnglish:
          'Arjuna sees the great warriors of both armies entering Krishna’s terrible mouths.',
      meaningGujarati:
          'અર્જુન બંને પક્ષના મહાન યોદ્ધાઓને ભગવાનના ભયંકર મુખોમાં પ્રવેશતા જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit: '''
वक्त्राणि ते त्वरमाणा विशन्ति
दंष्ट्राकरालानि भयानकानि ।
केचिद्विलग्ना दशनान्तरेषु
सन्दृश्यन्ते चूर्णितैरुत्तमाङ्गैः ॥
''',
      english:
          'They are rushing into Your terrible mouths. Some are caught between Your teeth with their heads crushed.',
      gujarati:
          'કેટલાક તમારા ભયંકર દાંતવાળા મુખોમાં ઝડપથી પ્રવેશી રહ્યા છે અને કેટલાક તમારા દાંત વચ્ચે ફસાયેલા તથા તેમના મસ્તક ચૂર થયેલા દેખાય છે.',
      meaningEnglish:
          'Arjuna sees warriors being destroyed within the terrible mouths of the universal form.',
      meaningGujarati:
          'અર્જુન યોદ્ધાઓને વિશ્વરૂપના ભયંકર મુખોમાં વિનાશ પામતા જુએ છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit: '''
यथा नदीनां बहवोऽम्बुवेगाः
समुद्रमेवाभिमुखा द्रवन्ति ।
तथा तवामी नरलोकवीरा
विशन्ति वक्त्राण्यभिविज्वलन्ति ॥
''',
      english:
          'As many rivers flow toward the ocean, so these heroes of the human world are entering Your blazing mouths.',
      gujarati:
          'જેમ અનેક નદીઓના પ્રવાહ સમુદ્ર તરફ દોડી જાય છે, તેમ આ બધા મનુષ્યલોકના વીર યોદ્ધાઓ તમારા પ્રજ્વલિત મુખોમાં પ્રવેશી રહ્યા છે.',
      meaningEnglish:
          'The warriors enter Krishna’s mouths as naturally and inevitably as rivers flow into the ocean.',
      meaningGujarati:
          'યોદ્ધાઓનો ભગવાનના મુખોમાં પ્રવેશ નદીઓના સમુદ્રમાં મળવા જેવો અનિવાર્ય દર્શાવવામાં આવ્યો છે.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit: '''
यथा प्रदीप्तं ज्वलनं पतङ्गा
विशन्ति नाशाय समृद्धवेगाः ।
तथैव नाशाय विशन्ति लोकाः
तवापि वक्त्राणि समृद्धवेगाः ॥
''',
      english:
          'As moths rush into a blazing fire to their destruction, so these beings rush into Your mouths for destruction.',
      gujarati:
          'જેમ પતંગિયાં પોતાના વિનાશ માટે પ્રજ્વલિત અગ્નિમાં દોડી જાય છે, તેમ આ બધા લોકો પોતાના વિનાશ માટે તમારા મુખોમાં ઝડપથી પ્રવેશી રહ્યા છે.',
      meaningEnglish:
          'The beings rushing into the cosmic form are compared to moths rushing into fire toward destruction.',
      meaningGujarati:
          'વિનાશ તરફ દોડતા જીવોની તુલના અગ્નિમાં દોડી જતા પતંગિયાં સાથે કરવામાં આવી છે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit: '''
लेलिह्यसे ग्रसमानः समन्ताल्लोकान्समग्रान्वदनैर्ज्वलद्भिः ।
तेजोभिरापूर्य जगत्समग्रं
भासस्तवोग्राः प्रतपन्ति विष्णो ॥
''',
      english:
          'You are licking up and devouring all the worlds with Your blazing mouths. Your terrible radiance fills the entire universe and scorches it.',
      gujarati:
          'તમે તમારા પ્રજ્વલિત મુખોથી સમગ્ર જગતને ચાટી-ચાટીને ગળી રહ્યા છો. તમારા ઉગ્ર તેજથી સમગ્ર જગત વ્યાપ્ત થઈને તપે છે.',
      meaningEnglish:
          'Krishna’s blazing cosmic form consumes the worlds and fills the universe with its powerful radiance.',
      meaningGujarati:
          'ભગવાનનું ઉગ્ર વિશ્વરૂપ સમગ્ર જગતને ગ્રસે છે અને તેના તેજથી સમગ્ર બ્રહ્માંડ વ્યાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 31,
      sanskrit: '''
आख्याहि मे को भवानुग्ररूपो
नमोऽस्तु ते देववर प्रसीद ।
विज्ञातुमिच्छामि भवन्तमाद्यं
न हि प्रजानामि तव प्रवृत्तिम् ॥
''',
      english:
          'Tell me who You are in this terrible form. O Supreme Lord, I bow to You. I wish to know You, the Primal Being, for I do not understand Your purpose.',
      gujarati:
          'આ ઉગ્ર સ્વરૂપમાં તમે કોણ છો તે મને કહો. હે દેવોના શ્રેષ્ઠ! તમને નમસ્કાર છે, મારા પર પ્રસન્ન થાઓ. હું તમને આદિ પુરુષ તરીકે જાણવા ઇચ્છું છું, કારણ કે તમારી પ્રવૃત્તિનું રહસ્ય હું સમજી શકતો નથી.',
      meaningEnglish:
          'Arjuna asks Krishna to explain the identity and purpose of His terrifying cosmic form.',
      meaningGujarati:
          'અર્જુન ભગવાનના ઉગ્ર વિશ્વરૂપનું સ્વરૂપ અને તેની પ્રવૃત્તિનું રહસ્ય જાણવા વિનંતી કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit: '''
श्रीभगवानुवाच ।
कालोऽस्मि लोकक्षयकृत्प्रवृद्धो
लोकान्समाहर्तुमिह प्रवृत्तः ।
ऋतेऽपि त्वां न भविष्यन्ति सर्वे
येऽवस्थिताः प्रत्यनीकेषु योधाः ॥
''',
      english:
          'The Supreme Lord said: I am Time, the mighty destroyer of worlds, engaged here in destroying these people. Even without you, none of the warriors standing on the opposing side will survive.',
      gujarati:
          'શ્રી ભગવાન બોલ્યા: હું વધેલો કાળ છું, જે લોકનો સંહાર કરનાર છે. અહીં આ લોકોને નાશ કરવા માટે પ્રવૃત્ત થયો છું. તારા વિના પણ સામે ઊભેલા આ બધા યોદ્ધાઓ જીવતા નહીં રહે.',
      meaningEnglish:
          'Krishna reveals Himself as Time, the force that brings about the destruction of the warriors.',
      meaningGujarati:
          'ભગવાન પોતાને કાળ તરીકે પ્રગટ કરે છે, જે યુદ્ધમાં રહેલા યોદ્ધાઓના વિનાશનું કારણ બને છે.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit: '''
तस्मात्त्वमुत्तिष्ठ यशो लभस्व
जित्वा शत्रून्भुङ्क्ष्व राज्यं समृद्धम् ।
मयैवैते निहताः पूर्वमेव
निमित्तमात्रं भव सव्यसाचिन् ॥
''',
      english:
          'Therefore arise and gain glory. Conquer your enemies and enjoy the prosperous kingdom. They have already been slain by Me; you are merely an instrument, O Arjuna.',
      gujarati:
          'તેથી ઊભો થા અને યશ પ્રાપ્ત કર. શત્રુઓને જીતીને સમૃદ્ધ રાજ્યનો ભોગ કર. આ બધા મારા દ્વારા પહેલેથી જ માર્યા ગયા છે; હે સવ્યસાચી! તું માત્ર નિમિત્ત બન.',
      meaningEnglish:
          'Krishna tells Arjuna to rise and act as an instrument in the divine plan.',
      meaningGujarati:
          'ભગવાન અર્જુનને ઊભા થઈ ધર્મયુદ્ધમાં નિમિત્ત બની પોતાનું કર્તવ્ય કરવા કહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit: '''
द्रोणं च भीष्मं च जयद्रथं च
कर्णं तथान्यानपि योधवीरान् ।
मया हतांस्त्वं जहि मा व्यथिष्ठा
युध्यस्व जेतासि रणे सपत्नान् ॥
''',
      english:
          'Drona, Bhishma, Jayadratha, Karna and other great warriors have already been destroyed by Me. Do not fear. Fight and you will conquer your enemies in battle.',
      gujarati:
          'દ્રોણ, ભીષ્મ, જયદ્રથ, કર્ણ તથા અન્ય મહાન યોદ્ધાઓ મારા દ્વારા પહેલેથી જ માર્યા ગયા છે. તેથી તું ભય ન રાખ. યુદ્ધ કર અને તારા શત્રુઓને જીતીશ.',
      meaningEnglish:
          'Krishna assures Arjuna that the outcome is already determined and tells him to fight without fear.',
      meaningGujarati:
          'ભગવાન અર્જુનને નિર્ભય થઈ યુદ્ધ કરવા અને પોતાના શત્રુઓ પર વિજય મેળવવા પ્રોત્સાહિત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 35,
      sanskrit: '''
सञ्जय उवाच ।
एतच्छ्रुत्वा वचनं केशवस्य
कृताञ्जलिर्वेपमानः किरीटी ।
नमस्कृत्वा भूय एवाह कृष्णं
सगद्गदं भीतभीतः प्रणम्य ॥
''',
      english:
          'Sanjaya said: Hearing these words of Krishna, Arjuna trembled, bowed with folded hands and, overwhelmed with fear, again addressed Krishna in a faltering voice.',
      gujarati:
          'સંજય બોલ્યા: કેશવના આ વચનો સાંભળીને અર્જુન કંપવા લાગ્યા, હાથ જોડીને નમસ્કાર કર્યો અને અત્યંત ભયભીત થઈ ગદગદ સ્વરે ફરી શ્રીકૃષ્ણને સંબોધ્યા.',
      meaningEnglish:
          'Arjuna trembles with awe and fear and respectfully addresses Krishna again.',
      meaningGujarati:
          'અર્જુન ભગવાનના વચનોથી ભય અને ભક્તિથી કંપતા હાથ જોડીને ફરી ભગવાનને સંબોધે છે.',
    ),

    SacredVerseModel(
      verseNumber: 36,
      sanskrit: '''
अर्जुन उवाच ।
स्थाने हृषीकेश तव प्रकीर्त्या
जगत्प्रहृष्यत्यनुरज्यते च ।
रक्षांसि भीतानि दिशो द्रवन्ति
सर्वे नमस्यन्ति च सिद्धसङ्घाः ॥
''',
      english:
          'Arjuna said: O Hrishikesha, the world rightly rejoices and becomes devoted on hearing Your glories. The demons flee in fear and all perfected beings bow before You.',
      gujarati:
          'અર્જુન બોલ્યા: હે હૃષીકેશ! તમારી કીર્તિ સાંભળીને જગત આનંદિત થાય છે અને તમારી ભક્તિ કરે છે. રાક્ષસો ભયથી ભાગી જાય છે અને બધા સિદ્ધો તમને નમસ્કાર કરે છે.',
      meaningEnglish:
          'Arjuna says that Krishna’s glory naturally brings joy to the righteous and fear to negative forces.',
      meaningGujarati:
          'અર્જુન કહે છે કે ભગવાનની કીર્તિથી સજ્જનો આનંદિત થાય છે અને રાક્ષસી શક્તિઓ ભયથી ભાગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 37,
      sanskrit: '''
कस्माच्च ते न नमेरन्महात्मन्
गरीयसे ब्रह्मणोऽप्यादिकर्त्रे ।
अनन्त देवेश जगन्निवास
त्वमक्षरं सदसत्तत्परं यत् ॥
''',
      english:
          'O Great Soul, why should they not bow to You? You are greater than Brahma, the original Creator. O Infinite Lord, You are the imperishable Reality beyond both existence and non-existence.',
      gujarati:
          'હે મહાત્મા! લોકો તમને નમસ્કાર કેમ ન કરે? તમે બ્રહ્માથી પણ મહાન અને આદિકર્તા છો. હે અનંત, દેવેશ, જગતના આશ્રય! તમે સત અને અસતથી પર અક્ષર તત્ત્વ છો.',
      meaningEnglish:
          'Arjuna recognizes Krishna as greater than Brahma and as the imperishable reality beyond material existence.',
      meaningGujarati:
          'અર્જુન ભગવાનને બ્રહ્માથી પણ મહાન અને સત-અસતથી પર અક્ષર તત્ત્વ તરીકે સ્વીકારે છે.',
    ),

    SacredVerseModel(
      verseNumber: 38,
      sanskrit: '''
त्वमादिदेवः पुरुषः पुराणस्
त्वमस्य विश्वस्य परं निधानम् ।
वेत्तासि वेद्यं च परं च धाम
त्वया ततं विश्वमनन्तरूप ॥
''',
      english:
          'You are the primal God, the ancient Person and the supreme refuge of this universe. You are the knower, the object of knowledge and the supreme abode. The universe is pervaded by You.',
      gujarati:
          'તમે આદિદેવ, સનાતન પુરુષ અને સમગ્ર વિશ્વના પરમ આશ્રય છો. તમે જ જ્ઞાતા, જ્ઞેય અને પરમ ધામ છો. હે અનંત સ્વરૂપ! સમગ્ર વિશ્વ તમારાથી વ્યાપ્ત છે.',
      meaningEnglish:
          'Arjuna praises Krishna as the primal divine Person, supreme refuge and all-pervading reality.',
      meaningGujarati:
          'અર્જુન ભગવાનને આદિદેવ, સનાતન પુરુષ, પરમ આશ્રય અને સર્વવ્યાપી તત્ત્વ તરીકે વંદે છે.',
    ),

    SacredVerseModel(
      verseNumber: 39,
      sanskrit: '''
वायुर्यमोऽग्निर्वरुणः शशाङ्कः
प्रजापतिस्त्वं प्रपितामहश्च ।
नमो नमस्तेऽस्तु सहस्रकृत्वः
पुनश्च भूयोऽपि नमो नमस्ते ॥
''',
      english:
          'You are Vayu, Yama, Agni, Varuna, the Moon, Prajapati and the great-grandfather. Salutations to You a thousand times, and again and again salutations.',
      gujarati:
          'તમે વાયુ, યમ, અગ્નિ, વરુણ, ચંદ્ર, પ્રજાપતિ અને પિતામહથી પણ પરમ છો. તમને હજારો વાર નમસ્કાર અને ફરી ફરી નમસ્કાર.',
      meaningEnglish:
          'Arjuna sees Krishna as the divine reality behind the various cosmic powers and repeatedly offers salutations.',
      meaningGujarati:
          'અર્જુન ભગવાનને વિવિધ બ્રહ્માંડીય શક્તિઓના મૂળરૂપ તરીકે જોઈ વારંવાર નમસ્કાર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 40,
      sanskrit: '''
नमः पुरस्तादथ पृष्ठतस्ते
नमोऽस्तु ते सर्वत एव सर्व ।
अनन्तवीर्यामितविक्रमस्त्वं
सर्वं समाप्नोषि ततोऽसि सर्वः ॥
''',
      english:
          'Salutations to You from the front and from behind; salutations from every side. You possess infinite power and immeasurable strength and You pervade everything; therefore You are everything.',
      gujarati:
          'તમને આગળથી, પાછળથી અને બધી દિશાઓથી નમસ્કાર. તમારી શક્તિ અનંત અને પરાક્રમ અપરિમિત છે. તમે સર્વત્ર વ્યાપ્ત છો, તેથી તમે જ સર્વ છો.',
      meaningEnglish:
          'Because Krishna pervades everything and possesses infinite power, Arjuna offers salutations from every direction.',
      meaningGujarati:
          'ભગવાન સર્વત્ર વ્યાપ્ત હોવાથી અને અનંત શક્તિ ધરાવતા હોવાથી અર્જુન તેમને દરેક દિશાથી નમસ્કાર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 41,
      sanskrit: '''
सखेति मत्वा प्रसभं यदुक्तं
हे कृष्ण हे यादव हे सखेति ।
अजानता महिमानं तवेदं
मया प्रमादात्प्रणयेन वापि ॥
''',
      english:
          'Thinking of You merely as a friend, I may have addressed You as “Krishna,” “Yadava,” or “my friend,” without knowing Your greatness, out of affection or carelessness.',
      gujarati:
          'તમને માત્ર મિત્ર માનીને મેં અજ્ઞાન, પ્રેમ અથવા બેદરકારીથી “હે કૃષ્ણ”, “હે યાદવ”, “હે સખા” વગેરે કહીને જે કંઈ કહ્યું હોય, તે માટે ક્ષમા કરજો.',
      meaningEnglish:
          'Arjuna regrets addressing Krishna casually as a friend without fully understanding His divine greatness.',
      meaningGujarati:
          'અર્જુન ભગવાનને માત્ર મિત્ર માનીને કરેલા અનૌપચારિક સંબોધન માટે ક્ષમા માગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 42,
      sanskrit: '''
यच्चावहासार्थमसत्कृतोऽसि
विहारशय्यासनभोजनेषु ।
एकोऽथवाप्यच्युत तत्समक्षं
तत्क्षामये त्वामहमप्रमेयम् ॥
''',
      english:
          'Whatever disrespect I showed You while joking, resting, sitting, eating or in private or before others, I ask You, the immeasurable One, to forgive me.',
      gujarati:
          'રમતમાં, બેઠા, સૂતા, ખાતા કે એકાંતમાં અથવા અન્ય લોકોની સામે મેં તમારો જે અનાદર કર્યો હોય, હે અપ્રમેય પ્રભુ! તે બધું ક્ષમા કરજો.',
      meaningEnglish:
          'Arjuna asks Krishna to forgive every act of disrespect done casually or unknowingly.',
      meaningGujarati:
          'અર્જુન અજાણતા કે મજાકમાં થયેલા દરેક અનાદર માટે અપ્રમેય ભગવાન પાસે ક્ષમા માગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 43,
      sanskrit: '''
पितासि लोकस्य चराचरस्य
त्वमस्य पूज्यश्च गुरुर्गरीयान् ।
न त्वत्समोऽस्त्यभ्यधिकः कुतोऽन्यो
लोकत्रयेऽप्यप्रतिमप्रभाव ॥
''',
      english:
          'You are the father of the entire moving and unmoving world, the most worshipful and the greatest teacher. None is equal to You, and none can be greater than You in the three worlds.',
      gujarati:
          'તમે સમગ્ર ચરાચર જગતના પિતા, પૂજનીય અને મહાન ગુરુ છો. ત્રણેય લોકમાં તમારા સમાન કોઈ નથી અને તમારાથી શ્રેષ્ઠ તો કોઈ હોઈ જ શકે નહીં.',
      meaningEnglish:
          'Arjuna recognizes Krishna as the father, teacher and supreme being of the entire universe.',
      meaningGujarati:
          'અર્જુન ભગવાનને સમગ્ર ચરાચર જગતના પિતા, મહાન ગુરુ અને સર્વોચ્ચ તત્ત્વ તરીકે સ્વીકારે છે.',
    ),

    SacredVerseModel(
      verseNumber: 44,
      sanskrit: '''
तस्मात्प्रणम्य प्रणिधाय कायं
प्रसादये त्वामहमीशमीड्यम् ।
पितेव पुत्रस्य सखेव सख्युः
प्रियः प्रियायार्हसि देव सोढुम् ॥
''',
      english:
          'Therefore, bowing down and prostrating my body before You, I seek Your grace. As a father forgives his son, a friend forgives a friend, and a beloved forgives the beloved, please forgive me.',
      gujarati:
          'તેથી હું શરીરથી દંડવત્ પ્રણામ કરીને તમારી કૃપા માગું છું. જેમ પિતા પુત્રને, મિત્ર મિત્રને અને પ્રિયજન પ્રિયને ક્ષમા કરે છે, તેમ હે દેવ! તમે પણ મને ક્ષમા કરો.',
      meaningEnglish:
          'Arjuna bows before Krishna and asks for forgiveness with the humility of a son before his father or friend before a friend.',
      meaningGujarati:
          'અર્જુન દંડવત્ પ્રણામ કરીને પિતા, મિત્ર અને પ્રિયજન જેવી કરુણાથી ભગવાન પાસે ક્ષમા માગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 45,
      sanskrit: '''
अदृष्टपूर्वं हृषितोऽस्मि दृष्ट्वा
भयेन च प्रव्यथितं मनो मे ।
तदेव मे दर्शय देव रूपं
प्रसीद देवेश जगन्निवास ॥
''',
      english:
          'I am delighted to have seen what was never seen before, yet my mind is distressed with fear. Therefore, O Lord, show me Your peaceful form again. Be gracious to me.',
      gujarati:
          'જે સ્વરૂપ પહેલાં ક્યારેય જોયું ન હતું તે જોઈને હું આનંદિત થયો છું, પરંતુ મારું મન ભયથી વ્યાકુળ છે. તેથી હે દેવેશ! ફરી તમારું શાંત સ્વરૂપ મને દર્શાવો અને મારા પર પ્રસન્ન થાઓ.',
      meaningEnglish:
          'Arjuna is amazed by the unprecedented vision but asks Krishna to return to His peaceful form.',
      meaningGujarati:
          'અર્જુન અદ્વિતીય વિશ્વરૂપથી આનંદિત પણ ભયભીત છે અને ભગવાનનું શાંત સ્વરૂપ ફરી જોવા માંગે છે.',
    ),

    SacredVerseModel(
      verseNumber: 46,
      sanskrit: '''
किरीटिनं गदिनं चक्रहस्तम्
इच्छामि त्वां द्रष्टुमहं तथैव ।
तेनैव रूपेण चतुर्भुजेन
सहस्रबाहो भव विश्वमूर्ते ॥
''',
      english:
          'I wish to see You as before, wearing the crown, holding the mace and discus. O thousand-armed Lord of the universe, please appear again in Your four-armed form.',
      gujarati:
          'હું તમને ફરી મુગટધારી, ગદા અને ચક્ર ધારણ કરેલા સ્વરૂપમાં જોવા ઇચ્છું છું. હે સહસ્રબાહુ વિશ્વરૂપ! ફરી તમારા ચતુર્ભુજ સ્વરૂપમાં પ્રગટ થાઓ.',
      meaningEnglish:
          'Arjuna asks Krishna to return to the familiar four-armed divine form with crown, mace and discus.',
      meaningGujarati:
          'અર્જુન ભગવાનને ફરી તેમના પરિચિત મુગટ, ગદા અને ચક્રધારી ચતુર્ભુજ સ્વરૂપમાં આવવા વિનંતી કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 47,
      sanskrit: '''
श्रीभगवानुवाच ।
मया प्रसन्नेन तवार्जुनेदं
रूपं परं दर्शितमात्मयोगात् ।
तेजोमयं विश्वमनन्तमाद्यं
यन्मे त्वदन्येन न दृष्टपूर्वम् ॥
''',
      english:
          'The Supreme Lord said: O Arjuna, being pleased with you, I have shown you this supreme, radiant, infinite and primal universal form through My own divine power. No one other than you has seen it before.',
      gujarati:
          'શ્રી ભગવાન બોલ્યા: હે અર્જુન! તારા પર પ્રસન્ન થઈને મેં મારી યોગશક્તિથી આ પરમ, તેજસ્વી, અનંત અને આદિ વિશ્વરૂપ તને બતાવ્યું છે. તારા સિવાય કોઈએ આ સ્વરૂપ પહેલાં જોયું નથી.',
      meaningEnglish:
          'Krishna explains that He revealed the extraordinary universal form to Arjuna through His divine power.',
      meaningGujarati:
          'ભગવાન કહે છે કે પોતાની દિવ્ય યોગશક્તિથી પ્રસન્ન થઈ તેમણે અર્જુનને આ અદ્વિતીય વિશ્વરૂપ દર્શાવ્યું.',
    ),

    SacredVerseModel(
      verseNumber: 48,
      sanskrit: '''
न वेदयज्ञाध्ययनैर्न दानैर्
न च क्रियाभिर्न तपोभिरुग्रैः ।
एवंरूपः शक्य अहं नृलोके
द्रष्टुं त्वदन्येन कुरुप्रवीर ॥
''',
      english:
          'O best of the Kurus, this form cannot be seen in the human world by Vedic study, sacrifices, charity, rituals or severe austerities.',
      gujarati:
          'હે કુરુવીર! વેદાધ્યયન, યજ્ઞ, દાન, ધાર્મિક ક્રિયાઓ અથવા કઠોર તપ દ્વારા પણ મનુષ્યલોકમાં આ મારું વિશ્વરૂપ તારા સિવાય કોઈ જોઈ શકતું નથી.',
      meaningEnglish:
          'The universal form cannot be attained merely through learning, rituals, charity or severe austerities.',
      meaningGujarati:
          'માત્ર વેદાધ્યયન, યજ્ઞ, દાન, ક્રિયા કે કઠોર તપથી વિશ્વરૂપના દર્શન શક્ય નથી.',
    ),

    SacredVerseModel(
      verseNumber: 49,
      sanskrit: '''
मा ते व्यथा मा च विमूढभावो
दृष्ट्वा रूपं घोरमीदृङ्ममेदम् ।
व्यपेतभीः प्रीतमनाः पुनस्त्वं
तदेव मे रूपमिदं प्रपश्य ॥
''',
      english:
          'Do not be frightened or confused by seeing this terrible form of Mine. Be free from fear and with a peaceful mind behold My familiar form again.',
      gujarati:
          'મારું આ ભયંકર સ્વરૂપ જોઈને તું વ્યથિત કે મૂંઝાયેલો ન થા. ભય છોડીને પ્રસન્ન મનથી ફરી મારું શાંત અને પરિચિત સ્વરૂપ જો.',
      meaningEnglish:
          'Krishna reassures Arjuna and tells him not to remain frightened by the terrifying vision.',
      meaningGujarati:
          'ભગવાન અર્જુનને આશ્વાસન આપે છે કે ભય છોડીને શાંત મનથી ફરી તેમનું પરિચિત સ્વરૂપ જુએ.',
    ),

    SacredVerseModel(
      verseNumber: 50,
      sanskrit: '''
सञ्जय उवाच ।
इत्यर्जुनं वासुदेवस्तथोक्त्वा
स्वकं रूपं दर्शयामास भूयः ।
आश्वासयामास च भीतमेनं
भूत्वा पुनः सौम्यवपुर्महात्मा ॥
''',
      english:
          'Sanjaya said: Having spoken thus to Arjuna, Vasudeva again showed His own familiar form and comforted the frightened Arjuna by assuming His gentle form.',
      gujarati:
          'સંજય બોલ્યા: આ પ્રમાણે અર્જુનને કહીને વાસુદેવે ફરી પોતાનું સૌમ્ય અને પરિચિત સ્વરૂપ ધારણ કર્યું અને ભયભીત અર્જુનને આશ્વાસન આપ્યું.',
      meaningEnglish:
          'Krishna returns to His gentle form and comforts Arjuna after the overwhelming cosmic vision.',
      meaningGujarati:
          'ભગવાન ફરી સૌમ્ય સ્વરૂપ ધારણ કરીને ભયભીત અર્જુનને આશ્વાસન આપે છે.',
    ),

    SacredVerseModel(
      verseNumber: 51,
      sanskrit: '''
अर्जुन उवाच ।
दृष्ट्वेदं मानुषं रूपं तव सौम्यं जनार्दन ।
इदानीमस्मि संवृत्तः सचेताः प्रकृतिं गतः ॥
''',
      english:
          'Arjuna said: O Janardana, seeing Your gentle human form, my mind is now composed and I have returned to my normal state.',
      gujarati:
          'અર્જુન બોલ્યા: હે જનાર્દન! તમારું આ સૌમ્ય માનવ સ્વરૂપ જોઈને હવે મારું મન શાંત થયું છે અને હું ફરી સ્વસ્થ અવસ્થામાં આવ્યો છું.',
      meaningEnglish:
          'Seeing Krishna’s familiar gentle form restores Arjuna’s peace and composure.',
      meaningGujarati:
          'ભગવાનનું સૌમ્ય માનવ સ્વરૂપ જોઈને અર્જુનનું મન ફરી શાંત અને સ્વસ્થ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 52,
      sanskrit: '''
श्रीभगवानुवाच ।
सुदुर्दर्शमिदं रूपं दृष्टवानसि यन्मम ।
देवा अप्यस्य रूपस्य नित्यं दर्शनकाङ्क्षिणः ॥
''',
      english:
          'The Supreme Lord said: This form of Mine which you have seen is very difficult to behold. Even the gods always long to see this form.',
      gujarati:
          'શ્રી ભગવાન બોલ્યા: તેં મારું જે સ્વરૂપ જોયું છે તે અત્યંત દુર્લભ છે. દેવતાઓ પણ આ સ્વરૂપના દર્શન માટે સદાય ઇચ્છુક રહે છે.',
      meaningEnglish:
          'Krishna says that the universal form is extremely rare and even the gods long to behold it.',
      meaningGujarati:
          'ભગવાન જણાવે છે કે વિશ્વરૂપના દર્શન અત્યંત દુર્લભ છે અને દેવતાઓ પણ તેના દર્શનની ઇચ્છા રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 53,
      sanskrit: '''
नाहं वेदैर्न तपसा न दानेन न चेज्यया ।
शक्य एवंविधो द्रष्टुं दृष्टवानसि मां यथा ॥
''',
      english:
          'I cannot be seen in this form merely by studying the Vedas, performing austerities, giving charity or performing sacrifices.',
      gujarati:
          'વેદોના અધ્યયનથી, તપથી, દાનથી કે યજ્ઞથી પણ મારું આ સ્વરૂપ તે રીતે જોઈ શકાતું નથી જે રીતે તેં મને જોયો છે.',
      meaningEnglish:
          'Krishna emphasizes that ritual practices alone cannot reveal the divine form in this manner.',
      meaningGujarati:
          'ભગવાન સમજાવે છે કે માત્ર વેદાધ્યયન, તપ, દાન કે યજ્ઞથી આ દિવ્ય વિશ્વરૂપનું દર્શન થઈ શકતું નથી.',
    ),

    SacredVerseModel(
      verseNumber: 54,
      sanskrit: '''
भक्त्या त्वनन्यया शक्य अहमेवंविधोऽर्जुन ।
ज्ञातुं द्रष्टुं च तत्त्वेन प्रवेष्टुं च परंतप ॥
''',
      english:
          'O Arjuna, only through single-minded devotion can I be truly known, seen in this form and entered into.',
      gujarati:
          'હે અર્જુન! અનન્ય ભક્તિ દ્વારા જ મને આ સ્વરૂપમાં તત્ત્વથી જાણી શકાય, જોઈ શકાય અને પ્રાપ્ત કરી શકાય છે.',
      meaningEnglish:
          'Krishna teaches that unwavering devotion is the means to truly know, see and attain Him.',
      meaningGujarati:
          'ભગવાન કહે છે કે અનન્ય અને એકાગ્ર ભક્તિ દ્વારા જ તેમને તત્ત્વથી જાણી, જોઈ અને પ્રાપ્ત કરી શકાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 55,
      sanskrit: '''
मत्कर्मकृन्मत्परमो मद्भक्तः सङ्गवर्जितः ।
निर्वैरः सर्वभूतेषु यः स मामेति पाण्डव ॥
''',
      english:
          'O Arjuna, one who performs all actions for Me, considers Me the Supreme Goal, is devoted to Me, free from attachment and without hatred toward any being, attains Me.',
      gujarati:
          'હે પાંડવ! જે મનુષ્ય મારા માટે કર્મ કરે છે, મને પરમ લક્ષ્ય માને છે, મારો ભક્ત છે, આસક્તિથી રહિત છે અને કોઈ જીવ પ્રત્યે વેર રાખતો નથી, તે મને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'One who dedicates actions to Krishna, makes Him the highest goal, remains unattached and free from hatred attains Him.',
      meaningGujarati:
          'જે ભગવાન માટે કર્મ કરે છે, તેમને પરમ લક્ષ્ય માને છે, આસક્તિ અને વેરથી રહિત રહી ભક્તિ કરે છે તે ભગવાનને પ્રાપ્ત કરે છે.',
    ),
  ];
}

static List<SacredVerseModel> _gitaChapter12Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'अर्जुन उवाच ।\n'
          'एवं सततयुक्ता ये भक्तास्त्वां पर्युपासते ।\n'
          'ये चाप्यक्षरमव्यक्तं तेषां के योगवित्तमाः ॥१२.१॥',
      english:
          'Arjuna said: O Lord, who are better—those devotees who constantly worship You with devotion, or those who worship the imperishable and unmanifest Brahman?',
      gujarati:
          'અર્જુન બોલ્યા: હે ભગવાન! જે ભક્તો હંમેશાં આપની ભક્તિપૂર્વક ઉપાસના કરે છે અને જે અવ્યક્ત અવિનાશી બ્રહ્મની ઉપાસના કરે છે, તેમાં શ્રેષ્ઠ યોગી કોણ છે?',
      meaningEnglish:
          'Arjuna asks which path is considered superior: devotion to the personal form of the Lord or worship of the unmanifest Brahman.',
      meaningGujarati:
          'અર્જુન પૂછે છે કે ભગવાનની ભક્તિ કરનાર અને અવ્યક્ત બ્રહ્મની ઉપાસના કરનારામાં શ્રેષ્ઠ યોગી કોણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'श्रीभगवानुवाच ।\n'
          'मय्यावेश्य मनो ये मां नित्ययुक्ता उपासते ।\n'
          'श्रद्धया परयोपेतास्ते मे युक्ततमा मताः ॥१२.२॥',
      english:
          'The Blessed Lord said: Those who fix their mind on Me and worship Me constantly with supreme faith are considered by Me to be the best yogis.',
      gujarati:
          'ભગવાન બોલ્યા: જે ભક્તો મનને મારામાં સ્થિર કરીને અને શ્રેષ્ઠ શ્રદ્ધાથી સતત મારી ઉપાસના કરે છે, તે મને સર્વોત્તમ યોગી લાગે છે.',
      meaningEnglish:
          'The Lord considers those who constantly worship Him with supreme faith and a focused mind to be the best yogis.',
      meaningGujarati:
          'ભગવાન કહે છે કે શ્રેષ્ઠ શ્રદ્ધાથી મનને ભગવાનમાં સ્થિર કરીને સતત ભક્તિ કરનાર ભક્તો ઉત્તમ યોગી છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'ये त्वक्षरमनिर्देश्यमव्यक्तं पर्युपासते ।\n'
          'सर्वत्रगमचिन्त्यं च कूटस्थमचलंध्रुवम् ॥१२.३॥',
      english:
          'Those who worship the imperishable, unmanifest, all-pervading, inconceivable and eternal Brahman, controlling all their senses and remaining equal-minded toward all beings, also attain Me.',
      gujarati:
          'જે લોકો અવ્યક્ત, અવિનાશી, સર્વવ્યાપક અને અચળ બ્રહ્મની ઉપાસના કરે છે, ઇન્દ્રિયોને વશમાં રાખે છે, સર્વ પ્રાણીઓ પ્રત્યે સમભાવ રાખે છે અને સર્વના હિતમાં રત રહે છે, તેઓ પણ મને જ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Those who worship the imperishable and unmanifest Brahman follow a difficult but valid path toward the Divine.',
      meaningGujarati:
          'અવ્યક્ત અને અવિનાશી બ્રહ્મની ઉપાસના કરનાર પણ પરમાત્માને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'सन्नियम्येन्द्रियग्रामं सर्वत्र समबुद्धयः ।\n'
          'ते प्राप्नुवन्ति मामेव सर्वभूतहिते रताः ॥१२.४॥',
      english:
          'Those who worship the imperishable, unmanifest, all-pervading and eternal Brahman, controlling their senses and remaining equal-minded toward all beings, also attain Me.',
      gujarati:
          'જે લોકો અવ્યક્ત, અવિનાશી, સર્વવ્યાપક અને અચળ બ્રહ્મની ઉપાસના કરે છે, ઇન્દ્રિયોને વશમાં રાખે છે, સર્વ પ્રાણીઓ પ્રત્યે સમભાવ રાખે છે અને સર્વના હિતમાં રત રહે છે, તેઓ પણ મને જ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Sense control, equality toward all beings and concern for the welfare of everyone lead the seeker toward the Divine.',
      meaningGujarati:
          'ઇન્દ્રિયસંયમ, સર્વ પ્રાણીઓ પ્રત્યે સમભાવ અને સર્વના હિતમાં રહેવું આધ્યાત્મિક પ્રગતિનો માર્ગ છે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'क्लेशोऽधिकतरस्तेषामव्यक्तासक्तचेतसाम् ।\n'
          'अव्यक्ता हि गतिर्दुःखं देहवद्भिरवाप्यते ॥१२.५॥',
      english:
          'The path of those whose minds are attached to the unmanifest is more difficult, because the unmanifest goal is difficult for embodied beings to attain.',
      gujarati:
          'જેમનું મન અવ્યક્ત બ્રહ્મમાં આસક્ત છે તેમના માટે સાધના વધુ મુશ્કેલ છે, કારણ કે દેહધારી મનુષ્યો માટે અવ્યક્તની પ્રાપ્તિ દુષ્કર છે.',
      meaningEnglish:
          'The path of meditation on the unmanifest is especially difficult for embodied beings.',
      meaningGujarati:
          'દેહધારી મનુષ્યો માટે અવ્યક્ત બ્રહ્મની સાધના વધુ કઠિન છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'ये तु सर्वाणि कर्माणि मयि संन्यस्य मत्पराः ।\n'
          'अनन्येनैव योगेन मां ध्यायन्त उपासते ॥१२.६॥',
      english:
          'Those who dedicate all actions to Me, consider Me supreme, and worship Me with exclusive devotion.',
      gujarati:
          'જે લોકો પોતાનાં બધાં કર્મો મને અર્પણ કરે છે, મને જ પરમ માને છે અને અનન્ય ભક્તિથી મારી ઉપાસના કરે છે.',
      meaningEnglish:
          'A devotee should dedicate all actions to the Lord and worship Him with exclusive devotion.',
      meaningGujarati:
          'બધાં કર્મો ભગવાનને અર્પણ કરીને અનન્ય ભક્તિથી તેમની ઉપાસના કરવી જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'तेषामहं समुद्धर्ता मृत्युसंसारसागरात् ।\n'
          'भवामि नचिरात्पार्थ मय्यावेशितचेतसाम् ॥१२.७॥',
      english:
          'Those who dedicate all actions to Me, consider Me supreme, and worship Me with exclusive devotion—I quickly deliver them from the ocean of birth and death.',
      gujarati:
          'જે લોકો પોતાનાં બધાં કર્મો મને અર્પણ કરે છે, મને જ પરમ માને છે અને અનન્ય ભક્તિથી મારી ઉપાસના કરે છે, તેમના મનને મારામાં સ્થિર હોવાથી હું તેમને જન્મ-મરણના સંસારસાગરમાંથી જલદી ઉદ્ધાર કરું છું.',
      meaningEnglish:
          'The Lord promises to deliver devoted seekers from the cycle of birth and death.',
      meaningGujarati:
          'અનન્ય ભક્તિ કરનાર ભક્તનો ભગવાન જન્મ-મરણના સંસારસાગરમાંથી ઉદ્ધાર કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'मय्येव मन आधत्स्व मयि बुद्धिं निवेशय ।\n'
          'निवसिष्यसि मय्येव अत ऊर्ध्वं न संशयः ॥१२.८॥',
      english:
          'Fix your mind on Me and place your intellect in Me. Then you will certainly live in Me hereafter.',
      gujarati:
          'તું તારું મન મારામાં જ રાખ અને તારી બુદ્ધિને પણ મારામાં જ સ્થિર કર. આમ કરવાથી તું નિશ્ચયપૂર્વક મારામાં જ નિવાસ કરીશ.',
      meaningEnglish:
          'The seeker should dedicate both mind and intellect to the Lord.',
      meaningGujarati:
          'મન અને બુદ્ધિ બંનેને ભગવાનમાં સ્થિર કરવાથી ભક્ત ભગવાનમાં નિવાસ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'अथ चित्तं समाधातुं न शक्नोषि मयि स्थिरम् ।\n'
          'अभ्यासयोगेन ततो मामिच्छाप्तुं धनञ्जय ॥१२.९॥',
      english:
          'If you cannot steadily fix your mind on Me, then seek to attain Me through the practice of meditation.',
      gujarati:
          'જો તું તારું મન મારામાં સ્થિર કરી શકતો ન હોય તો હે અર્જુન! અભ્યાસયોગ દ્વારા મને પ્રાપ્ત કરવાનો પ્રયત્ન કર.',
      meaningEnglish:
          'If constant concentration is difficult, the seeker should develop devotion through regular spiritual practice.',
      meaningGujarati:
          'જો મન સતત ભગવાનમાં સ્થિર ન રહે તો નિયમિત અભ્યાસ દ્વારા મનને ભગવાન તરફ લાવવું જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'अभ्यासेऽप्यसमर्थोऽसि मत्कर्मपरमो भव ।\n'
          'मदर्थमपि कर्माणि कुर्वन् सिद्धिमवाप्स्यसि ॥१२.१०॥',
      english:
          'If you are unable even to practice meditation, perform actions for My sake. By performing actions for Me, you will attain perfection.',
      gujarati:
          'જો તું અભ્યાસ કરવામાં પણ અસમર્થ હોય તો મારા માટે કર્મ કર. મારા માટે કર્મ કરતાં કરતાં તું સિદ્ધિ પ્રાપ્ત કરીશ.',
      meaningEnglish:
          'If meditation is difficult, performing one’s duties as an offering to the Lord becomes the spiritual practice.',
      meaningGujarati:
          'ધ્યાનનો અભ્યાસ મુશ્કેલ હોય તો પોતાના કર્મો ભગવાનને અર્પણ કરીને કરવાથી સિદ્ધિ પ્રાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'अथैतदप्यशक्तोऽसि कर्तुं मद्योगमाश्रितः ।\n'
          'सर्वकर्मफलत्यागं ततः कुरु यतात्मवान् ॥१२.११॥',
      english:
          'If you cannot even do this, then surrender the fruits of all your actions and control yourself.',
      gujarati:
          'જો આ પણ કરવામાં તું અસમર્થ હોય તો મન અને ઇન્દ્રિયોને વશમાં રાખીને તમામ કર્મોના ફળનો ત્યાગ કર.',
      meaningEnglish:
          'When other practices are difficult, renouncing attachment to the results of action is recommended.',
      meaningGujarati:
          'અન્ય સાધનાઓ મુશ્કેલ હોય તો કર્મના ફળ પ્રત્યેની આસક્તિનો ત્યાગ કરવો જોઈએ.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'श्रेयो हि ज्ञानमभ्यासाज्ज्ञानाद्ध्यानं विशिष्यते ।\n'
          'ध्यानात्कर्मफलत्यागस्त्यागाच्छान्तिरनन्तरम् ॥१२.१२॥',
      english:
          'Knowledge is better than mere practice; meditation is superior to knowledge; renunciation of the fruits of action is superior to meditation, and peace immediately follows renunciation.',
      gujarati:
          'માત્ર અભ્યાસ કરતાં જ્ઞાન શ્રેષ્ઠ છે, જ્ઞાન કરતાં ધ્યાન શ્રેષ્ઠ છે અને ધ્યાન કરતાં કર્મફળનો ત્યાગ શ્રેષ્ઠ છે. કર્મફળનો ત્યાગ કરવાથી તરત જ શાંતિ પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'The teaching progresses from practice to knowledge, meditation and finally renunciation of the fruits of action, which brings peace.',
      meaningGujarati:
          'અભ્યાસ, જ્ઞાન અને ધ્યાનથી આગળ વધીને કર્મફળનો ત્યાગ કરવાથી અંતે શાંતિ પ્રાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'अद्वेष्टा सर्वभूतानां मैत्रः करुण एव च ।\n'
          'निर्ममो निरहङ्कारः समदुःखसुखः क्षमी ॥१२.१३॥',
      english:
          'One who hates no being, is friendly and compassionate, free from possessiveness and ego, equal in happiness and sorrow, and forgiving is dear to Me.',
      gujarati:
          'જે કોઈ જીવ પ્રત્યે દ્વેષ રાખતો નથી, મિત્રભાવ અને કરુણા રાખે છે, મમતા અને અહંકારથી રહિત છે, સુખ-દુઃખમાં સમાન રહે છે અને ક્ષમાશીલ છે, તે મારો પ્રિય ભક્ત છે.',
      meaningEnglish:
          'A true devotee is compassionate, free from hatred and ego, and remains balanced in happiness and sorrow.',
      meaningGujarati:
          'સાચો ભક્ત દ્વેષ અને અહંકારથી મુક્ત, કરુણાશીલ અને સુખ-દુઃખમાં સમભાવવાળો હોય છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'सन्तुष्टः सततं योगी यतात्मा दृढनिश्चयः ।\n'
          'मय्यर्पितमनोबुद्धिर्यो मद्भक्तः स मे प्रियः ॥१२.१४॥',
      english:
          'One who is always content, self-controlled, firmly determined and whose mind and intellect are surrendered to Me is dear to Me.',
      gujarati:
          'જે સંતુષ્ટ છે, મન-ઇન્દ્રિયોને વશમાં રાખે છે, દૃઢ નિશ્ચયવાળો છે અને પોતાની બુદ્ધિ તથા મન મને અર્પણ કરે છે, તે મારો પ્રિય ભક્ત છે.',
      meaningEnglish:
          'Contentment, self-control, determination and surrender of mind and intellect characterize a beloved devotee.',
      meaningGujarati:
          'સંતોષ, આત્મસંયમ, દૃઢ નિશ્ચય અને ભગવાનને મન-બુદ્ધિનું સમર્પણ ભક્તના ગુણો છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'यस्मान्नोद्विजते लोको लोकान्नोद्विजते च यः ।\n'
          'हर्षामर्षभयोद्वेगैर्मुक्तो यः स च मे प्रियः ॥१२.१५॥',
      english:
          'He by whom the world is not disturbed and who is not disturbed by the world, who is free from joy, anger, fear and anxiety, is dear to Me.',
      gujarati:
          'જેના કારણે કોઈને દુઃખ કે ભય થતો નથી અને જે પોતે પણ દુનિયાથી વ્યથિત થતો નથી, જે હર્ષ, ક્રોધ, ભય અને ચિંતાથી મુક્ત છે, તે મને પ્રિય છે.',
      meaningEnglish:
          'A peaceful devotee neither causes disturbance to others nor becomes disturbed by others.',
      meaningGujarati:
          'શાંત ભક્ત બીજા લોકોને વ્યથિત કરતો નથી અને પોતે પણ દુનિયાથી વ્યથિત થતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'अनपेक्षः शुचिर्दक्ष उदासीनो गतव्यथः ।\n'
          'सर्वारम्भपरित्यागी यो मद्भक्तः स मे प्रियः ॥१२.१६॥',
      english:
          'One who is desireless, pure, efficient, impartial, free from anxiety and who has renounced selfish undertakings is dear to Me.',
      gujarati:
          'જે અપેક્ષારહિત, શુદ્ધ, કુશળ, નિષ્પક્ષ અને ચિંતામુક્ત છે તથા સ્વાર્થપૂર્ણ આરંભોનો ત્યાગ કરે છે, તે મારો પ્રિય ભક્ત છે.',
      meaningEnglish:
          'The beloved devotee is pure, capable, impartial and free from selfish expectations and anxiety.',
      meaningGujarati:
          'પ્રિય ભક્ત અપેક્ષારહિત, શુદ્ધ, કુશળ, નિષ્પક્ષ અને સ્વાર્થથી મુક્ત હોય છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'यो न हृष्यति न द्वेष्टि न शोचति न काङ्क्षति ।\n'
          'शुभाशुभपरित्यागी भक्तिमान्यः स मे प्रियः ॥१२.१७॥',
      english:
          'One who neither rejoices nor hates, neither grieves nor desires, and renounces good and evil results, is dear to Me.',
      gujarati:
          'જે ન તો અતિશય હર્ષ પામે છે, ન દ્વેષ કરે છે, ન શોક કરે છે, ન ઇચ્છા રાખે છે અને શુભ-અશુભ ફળનો ત્યાગ કરે છે, તે ભક્ત મને પ્રિય છે.',
      meaningEnglish:
          'The devotee remains balanced and does not become attached to pleasure, grief, desire or results.',
      meaningGujarati:
          'ભક્ત હર્ષ, દ્વેષ, શોક, ઇચ્છા અને કર્મફળની આસક્તિથી મુક્ત રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'समः शत्रौ च मित्रे च तथा मानापमानयोः ।\n'
          'शीतोष्णसुखदुःखेषु समः सङ्गविवर्जितः ॥१२.१८॥',
      english:
          'One who is equal toward friend and enemy, honor and dishonor, heat and cold, pleasure and pain, is dear to Me.',
      gujarati:
          'જે શત્રુ અને મિત્રમાં, માન અને અપમાનમાં, ઠંડી-ગરમી તથા સુખ-દુઃખમાં સમભાવ રાખે છે, તે મને પ્રિય છે.',
      meaningEnglish:
          'A mature devotee maintains equality in opposite experiences and relationships.',
      meaningGujarati:
          'પરિપક્વ ભક્ત મિત્ર-શત્રુ અને સુખ-દુઃખ જેવા દ્વંદ્વોમાં સમભાવ રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'तुल्यनिन्दास्तुतिर्मौनी सन्तुष्टो येन केनचित् ।\n'
          'अनिकेतः स्थिरमतिर्भक्तिमान्मे प्रियो नरः ॥१२.१९॥',
      english:
          'One who is equal in praise and blame, content, detached and steady-minded is dear to Me.',
      gujarati:
          'જે પ્રશંસા અને નિંદાને સમાન માને છે, સંતુષ્ટ અને આસક્તિરહિત છે તથા સ્થિર બુદ્ધિ ધરાવે છે, તે મને પ્રિય છે.',
      meaningEnglish:
          'The devotee is not shaken by praise or criticism and remains content and steady.',
      meaningGujarati:
          'પ્રશંસા કે નિંદાથી અસ્થિર થયા વિના સંતુષ્ટ અને સ્થિર રહેવું ભક્તનો ગુણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'ये तु धर्म्यामृतमिदं यथोक्तं पर्युपासते ।\n'
          'श्रद्दधाना मत्परमा भक्तास्तेऽतीव मे प्रियाः ॥१२.२०॥',
      english:
          'Those devotees who faithfully follow this immortal teaching and regard Me as supreme are exceedingly dear to Me.',
      gujarati:
          'જે ભક્તો શ્રદ્ધાપૂર્વક આ અમૃતરૂપ ધર્મનું પાલન કરે છે અને મને પરમ માને છે, તે ભક્તો મને અત્યંત પ્રિય છે.',
      meaningEnglish:
          'Those who faithfully live according to this teaching and make the Lord supreme in their lives are especially dear to Him.',
      meaningGujarati:
          'જે ભક્તો શ્રદ્ધાથી આ ધર્મનું પાલન કરે છે અને ભગવાનને પરમ માને છે, તેઓ ભગવાનને અત્યંત પ્રિય છે.',
    ),
  ];
}

static List<SacredVerseModel> _gitaChapter13Verses() {
  return [
    SacredVerseModel(
      verseNumber: 1,
      sanskrit:
          'अर्जुन उवाच ।\n'
          'प्रकृतिं पुरुषं चैव क्षेत्रं क्षेत्रज्ञमेव च ।\n'
          'एतद्वेदितुमिच्छामि ज्ञानं ज्ञेयं च केशव ॥१३.१॥',
      english:
          'Arjuna said: O Krishna, I wish to know about Nature, the individual soul, the field, the knower of the field, knowledge and the object of knowledge.',
      gujarati:
          'અર્જુન પૂછે છે: હે કેશવ! હું પ્રકૃતિ, પુરુષ, ક્ષેત્ર, ક્ષેત્રજ્ઞ, જ્ઞાન અને જ્ઞેય વિશે જાણવા ઇચ્છું છું.',
      meaningEnglish:
          'Arjuna asks Krishna to explain Nature, the soul, the field, its knower, knowledge and the object of knowledge.',
      meaningGujarati:
          'અર્જુન પ્રકૃતિ, પુરુષ, ક્ષેત્ર, ક્ષેત્રજ્ઞ, જ્ઞાન અને જ્ઞેય વિશે ભગવાનને પૂછે છે.',
    ),

    SacredVerseModel(
      verseNumber: 2,
      sanskrit:
          'श्रीभगवानुवाच ।\n'
          'इदं शरीरं कौन्तेय क्षेत्रमित्यभिधीयते ।\n'
          'एतद्यो वेत्ति तं प्राहुः क्षेत्रज्ञ इति तद्विदः ॥१३.२॥',
      english:
          'The Blessed Lord said: This body is called the field, and one who knows this field is called the knower of the field.',
      gujarati:
          'ભગવાન કહે છે: હે કુંતીપુત્ર! આ શરીરને ક્ષેત્ર કહેવામાં આવે છે અને જે આ ક્ષેત્રને જાણે છે તેને ક્ષેત્રજ્ઞ કહેવામાં આવે છે.',
      meaningEnglish:
          'The body is called the field, while the conscious knower of the body is called the knower of the field.',
      meaningGujarati:
          'શરીર ક્ષેત્ર છે અને શરીરને જાણનાર ચેતન તત્ત્વને ક્ષેત્રજ્ઞ કહેવામાં આવે છે.',
    ),

    SacredVerseModel(
      verseNumber: 3,
      sanskrit:
          'क्षेत्रज्ञं चापि मां विद्धि सर्वक्षेत्रेषु भारत ।\n'
          'क्षेत्रक्षेत्रज्ञयोर्ज्ञानं यत्तज्ज्ञानं मतं मम ॥१३.३॥',
      english:
          'Know Me as the Knower of the field in all bodies. Knowledge of the field and its knower is true knowledge.',
      gujarati:
          'હે ભારત! બધા શરીરોમાં રહેલા ક્ષેત્રજ્ઞને મને જ જાણ. ક્ષેત્ર અને ક્ષેત્રજ્ઞનું જ્ઞાન જ મારા મત મુજબ સાચું જ્ઞાન છે.',
      meaningEnglish:
          'Krishna declares Himself to be the ultimate knower present in every field.',
      meaningGujarati:
          'ભગવાન કહે છે કે બધા શરીરોમાં રહેલા ક્ષેત્રજ્ઞનું પરમ સ્વરૂપ પોતે જ છે.',
    ),

    SacredVerseModel(
      verseNumber: 4,
      sanskrit:
          'तत्क्षेत्रं यच्च यादृक्च यद्विकारि यतश्च यत् ।\n'
          'स च यो यत्प्रभावश्च तत्समासेन मे शृणु ॥१३.४॥',
      english:
          'Hear briefly from Me what the field is, what its nature is, how it changes, from what it arises and what its powers are.',
      gujarati:
          'ક્ષેત્ર શું છે, કેવું છે, તેમાં કયા ફેરફારો થાય છે, તે ક્યાંથી ઉત્પન્ન થાય છે અને તેની શક્તિ શું છે—તે બધું મારાથી સંક્ષેપમાં સાંભળ.',
      meaningEnglish:
          'Krishna begins explaining the nature, changes, origin and powers of the field.',
      meaningGujarati:
          'ભગવાન ક્ષેત્રનું સ્વરૂપ, તેના ફેરફારો, ઉત્પત્તિ અને શક્તિનું વર્ણન કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 5,
      sanskrit:
          'ऋषिभिर्बहुधा गीतं छन्दोभिर्विविधैः पृथक् ।\n'
          'ब्रह्मसूत्रपदैश्चैव हेतुमद्भिर्विनिश्चितैः ॥१३.५॥',
      english:
          'The nature of the field has been described in many ways by sages and in various Vedic hymns and Brahma-sutras with logical reasoning.',
      gujarati:
          'આ ક્ષેત્રનું વર્ણન અનેક ઋષિઓએ વિવિધ વૈદિક મંત્રોમાં અને તર્કપૂર્ણ બ્રહ્મસૂત્રોમાં કર્યું છે.',
      meaningEnglish:
          'The nature of the field has been explained by sages and spiritual scriptures through different approaches.',
      meaningGujarati:
          'ક્ષેત્રનું જ્ઞાન ઋષિઓ અને શાસ્ત્રોએ વિવિધ રીતે સમજાવ્યું છે.',
    ),

    SacredVerseModel(
      verseNumber: 6,
      sanskrit:
          'महाभूतान्यहङ्कारो बुद्धिरव्यक्तमेव च ।\n'
          'इन्द्रियाणि दशैकं च पञ्च चेन्द्रियगोचराः ॥१३.६॥',
      english:
          'The field consists of the five great elements, ego, intellect, the unmanifest, the eleven senses and the five sense objects.',
      gujarati:
          'પાંચ મહાભૂત, અહંકાર, બુદ્ધિ, અવ્યક્ત, અગિયાર ઇન્દ્રિયો અને પાંચ ઇન્દ્રિયવિષયો ક્ષેત્રના ભાગો છે.',
      meaningEnglish:
          'The field includes the elements, ego, intellect, unmanifest nature, senses and their objects.',
      meaningGujarati:
          'ક્ષેત્રમાં પાંચ મહાભૂત, અહંકાર, બુદ્ધિ, અવ્યક્ત, અગિયાર ઇન્દ્રિયો અને પાંચ વિષયોનો સમાવેશ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 7,
      sanskrit:
          'इच्छा द्वेषः सुखं दुःखं सङ्घातश्चेतना धृतिः ।\n'
          'एतत्क्षेत्रं समासेन सविकारमुदाहृतम् ॥१३.७॥',
      english:
          'The field also includes desire, hatred, pleasure, pain, the body, consciousness and firmness.',
      gujarati:
          'ઇચ્છા, દ્વેષ, સુખ, દુઃખ, શરીર, ચેતના અને ધૃતિ—આ બધું મળીને ક્ષેત્ર કહેવાય છે.',
      meaningEnglish:
          'Desire, aversion, happiness, suffering, bodily existence, consciousness and determination are also aspects of the field.',
      meaningGujarati:
          'ઇચ્છા, દ્વેષ, સુખ, દુઃખ, શરીર, ચેતના અને ધૃતિ પણ ક્ષેત્રના સ્વરૂપનો ભાગ છે.',
    ),

    SacredVerseModel(
      verseNumber: 8,
      sanskrit:
          'अमानित्वमदम्भित्वमहिंसा क्षान्तिरार्जवम् ।\n'
          'आचार्योपासनं शौचं स्थैर्यमात्मविनिग्रहः ॥१३.८॥',
      english:
          'Humility, absence of hypocrisy, non-violence, patience, straightforwardness, service to the teacher, purity, steadiness and self-control are qualities of knowledge.',
      gujarati:
          'નમ્રતા, દંભરહિતતા, અહિંસા, ક્ષમા, સરળતા, ગુરુસેવા, પવિત્રતા, સ્થિરતા અને આત્મસંયમ જ્ઞાનના ગુણો છે.',
      meaningEnglish:
          'True knowledge begins with humility, honesty, non-violence, patience, purity and self-control.',
      meaningGujarati:
          'સાચા જ્ઞાન માટે નમ્રતા, અહિંસા, ક્ષમા, પવિત્રતા અને આત્મસંયમ જરૂરી છે.',
    ),

    SacredVerseModel(
      verseNumber: 9,
      sanskrit:
          'इन्द्रियार्थेषु वैराग्यमनहङ्कार एव च ।\n'
          'जन्ममृत्युजराव्याधिदुःखदोषानुदर्शनम् ॥१३.९॥',
      english:
          'Detachment from sense objects, absence of ego, and awareness of the suffering inherent in birth, death, old age and disease are knowledge.',
      gujarati:
          'ઇન્દ્રિયવિષયોથી વૈરાગ્ય, અહંકારનો અભાવ અને જન્મ-મરણ-જરા-વ્યાધિના દુઃખનું જ્ઞાન જ્ઞાનના ગુણો છે.',
      meaningEnglish:
          'Knowledge involves detachment from sense pleasures and awareness of the limitations of embodied life.',
      meaningGujarati:
          'ઇન્દ્રિયસુખથી વૈરાગ્ય અને જીવનના દુઃખદ પાસાઓની સમજ આધ્યાત્મિક જ્ઞાનનો ભાગ છે.',
    ),

    SacredVerseModel(
      verseNumber: 10,
      sanskrit:
          'असक्तिरनभिष्वङ्गः पुत्रदारगृहादिषु ।\n'
          'नित्यं च समचित्तत्वमिष्टानिष्टोपपत्तिषु ॥१३.१०॥',
      english:
          'Non-attachment to family and possessions and equanimity toward pleasant and unpleasant circumstances are knowledge.',
      gujarati:
          'પરિવાર પ્રત્યે આસક્તિનો અભાવ અને સુખદ-દુઃખદ પરિસ્થિતિઓમાં સમચિત્તતા જ્ઞાનના ગુણો છે.',
      meaningEnglish:
          'A wise person remains unattached and maintains equanimity in favorable and unfavorable situations.',
      meaningGujarati:
          'જ્ઞાની વ્યક્તિ આસક્તિ વિના સુખદ અને દુઃખદ પરિસ્થિતિમાં સમભાવ રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 11,
      sanskrit:
          'मयि चानन्ययोगेन भक्तिरव्यभिचारिणी ।\n'
          'विविक्तदेशसेवित्वमरतिर्जनसंसदि ॥१३.११॥',
      english:
          'Exclusive devotion to Me, love of solitude and detachment from crowds are considered knowledge.',
      gujarati:
          'અનન્ય ભક્તિ, એકાંત પ્રત્યે પ્રેમ અને ભીડથી અલિપ્તતા જ્ઞાનના ગુણો છે.',
      meaningEnglish:
          'Steady devotion, love of solitude and freedom from unnecessary social distraction support spiritual knowledge.',
      meaningGujarati:
          'અનન્ય ભક્તિ, એકાંત અને બાહ્ય વિક્ષેપોથી અલિપ્તતા આધ્યાત્મિક જ્ઞાનને મજબૂત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 12,
      sanskrit:
          'अध्यात्मज्ञाननित्यत्वं तत्त्वज्ञानार्थदर्शनम् ।\n'
          'एतज्ज्ञानमिति प्रोक्तमज्ञानं यदतोऽन्यथा ॥१३.१२॥',
      english:
          'Constant pursuit of spiritual knowledge and realization of Truth—these constitute knowledge.',
      gujarati:
          'આધ્યાત્મિક જ્ઞાનમાં સ્થિરતા અને પરમ સત્યનું જ્ઞાન—આ બધું જ્ઞાન કહેવાય છે.',
      meaningEnglish:
          'Constant spiritual inquiry and realization of truth are described as true knowledge.',
      meaningGujarati:
          'સતત આધ્યાત્મિક જ્ઞાનની શોધ અને પરમ સત્યની અનુભૂતિને સાચું જ્ઞાન કહેવાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 13,
      sanskrit:
          'ज्ञेयं यत्तत्प्रवक्ष्यामि यज्ज्ञात्वामृतमश्नुते ।\n'
          'अनादिमत्परं ब्रह्म न सत्तन्नासदुच्यते ॥१३.१३॥',
      english:
          'I shall now explain the object of knowledge, knowing which one attains immortality—the beginningless Supreme Brahman.',
      gujarati:
          'હવે હું તે જ્ઞેયનું વર્ણન કરીશ જેને જાણવાથી અમૃતત્વ પ્રાપ્ત થાય છે. તે અનાદિ પરબ્રહ્મ છે.',
      meaningEnglish:
          'The Supreme Brahman is the object of knowledge, and knowing it leads beyond mortality.',
      meaningGujarati:
          'પરબ્રહ્મ જ જ્ઞેય છે અને તેને જાણવાથી અમૃતત્વ પ્રાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 14,
      sanskrit:
          'सर्वतः पाणिपादं तत्सर्वतोऽक्षिशिरोमुखम् ।\n'
          'सर्वतः श्रुतिमल्लोके सर्वमावृत्य तिष्ठति ॥१३.१४॥',
      english:
          'It has hands and feet everywhere, eyes, heads and faces everywhere; it hears everywhere and exists pervading everything.',
      gujarati:
          'પરમાત્માના હાથ-પગ, આંખો, મસ્તક અને મુખ સર્વત્ર છે. તે સર્વત્ર સાંભળે છે અને સમગ્ર જગતને વ્યાપીને રહેલો છે.',
      meaningEnglish:
          'The Divine pervades all beings and is symbolically described as having senses everywhere.',
      meaningGujarati:
          'પરમાત્મા સમગ્ર જગતમાં સર્વત્ર વ્યાપેલો છે.',
    ),

    SacredVerseModel(
      verseNumber: 15,
      sanskrit:
          'सर्वेन्द्रियगुणाभासं सर्वेन्द्रियविवर्जितम् ।\n'
          'असक्तं सर्वभृच्चैव निर्गुणं गुणभोक्तृ च ॥१३.१५॥',
      english:
          'He appears through the functions of all senses, yet is beyond the senses; unattached, yet supporting all; beyond the three qualities, yet experiencing them.',
      gujarati:
          'તે તમામ ઇન્દ્રિયોના વિષયોમાં પ્રકાશરૂપે દેખાય છે છતાં ઇન્દ્રિયોથી પર છે. આસક્તિ વિના સર્વનું પાલન કરે છે અને ગુણોથી પર હોવા છતાં ગુણોના ભોક્તા સમાન દેખાય છે.',
      meaningEnglish:
          'The Supreme supports everything while remaining beyond the senses and material qualities.',
      meaningGujarati:
          'પરમાત્મા સર્વનું પાલન કરે છે છતાં ઇન્દ્રિયો અને ગુણોથી પર છે.',
    ),

    SacredVerseModel(
      verseNumber: 16,
      sanskrit:
          'बहिरन्तश्च भूतानामचरं चरमेव च ।\n'
          'सूक्ष्मत्वात्तदविज्ञेयं दूरस्थं चान्तिके च तत् ॥१३.१६॥',
      english:
          'He is within and outside all beings, moving and unmoving. Because He is subtle, He is difficult to know; He is far away yet very near.',
      gujarati:
          'પરમાત્મા બધા જીવોની અંદર અને બહાર છે, સ્થાવર તથા જંગમ બંનેમાં છે. અત્યંત સૂક્ષ્મ હોવાથી તે જાણવામાં મુશ્કેલ છે; તે દૂર પણ છે અને અત્યંત નજીક પણ છે.',
      meaningEnglish:
          'The Divine exists both within and beyond all beings and is simultaneously near and far.',
      meaningGujarati:
          'પરમાત્મા દરેક જીવની અંદર અને બહાર છે; તે દૂર પણ છે અને નજીક પણ છે.',
    ),

    SacredVerseModel(
      verseNumber: 17,
      sanskrit:
          'अविभक्तं च भूतेषु विभक्तमिव च स्थितम् ।\n'
          'भूतभर्तृ च तज्ज्ञेयं ग्रसिष्णु प्रभविष्णु च ॥१३.१७॥',
      english:
          'Though undivided, He appears divided among beings. He supports all beings, absorbs them and also brings them into existence.',
      gujarati:
          'પરમાત્મા અવિભાજ્ય હોવા છતાં બધા જીવોમાં જુદા-જુદા હોય તેમ દેખાય છે. તે સર્વનું પાલન કરે છે, સંહાર કરે છે અને સર્જન પણ કરે છે.',
      meaningEnglish:
          'The One Supreme Reality appears in many beings while remaining fundamentally undivided.',
      meaningGujarati:
          'એક પરમ તત્ત્વ અનેક જીવોમાં જુદું દેખાય છે છતાં મૂળભૂત રીતે અવિભાજ્ય છે.',
    ),

    SacredVerseModel(
      verseNumber: 18,
      sanskrit:
          'ज्योतिषामपि तज्ज्योतिस्तमसः परमुच्यते ।\n'
          'ज्ञानं ज्ञेयं ज्ञानगम्यं हृदि सर्वस्य विष्ठितम् ॥१३.१८॥',
      english:
          'He is the light of all lights, beyond darkness. He is knowledge, the object of knowledge and the goal of knowledge, seated in the hearts of all.',
      gujarati:
          'તે સર્વ પ્રકાશોનો પણ પ્રકાશ છે અને અજ્ઞાનરૂપ અંધકારથી પર છે. તે જ્ઞાન છે, જ્ઞેય છે અને જ્ઞાનથી પ્રાપ્ત થવાનું ધ્યેય છે; તે સૌના હૃદયમાં રહેલો છે.',
      meaningEnglish:
          'The Supreme is the inner light, the object and goal of spiritual knowledge, present in every heart.',
      meaningGujarati:
          'પરમાત્મા સૌના હૃદયમાં રહેલો આંતરિક પ્રકાશ અને જ્ઞાનનું પરમ ધ્યેય છે.',
    ),

    SacredVerseModel(
      verseNumber: 19,
      sanskrit:
          'इति क्षेत्रं तथा ज्ञानं ज्ञेयं चोक्तं समासतः ।\n'
          'मद्भक्त एतद्विज्ञाय मद्भावायोपपद्यते ॥१३.१९॥',
      english:
          'Thus the field, knowledge and the object of knowledge have been described briefly. My devotee who understands this attains My nature.',
      gujarati:
          'આ રીતે ક્ષેત્ર, જ્ઞાન અને જ્ઞેયનું સંક્ષિપ્ત વર્ણન કર્યું. જે મારો ભક્ત આને સમજી લે છે તે મારા સ્વરૂપને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'Understanding the field, knowledge and the object of knowledge helps the devotee attain the Divine nature.',
      meaningGujarati:
          'ક્ષેત્ર, જ્ઞાન અને જ્ઞેયને સમજનાર ભક્ત પરમાત્માના સ્વરૂપને પ્રાપ્ત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 20,
      sanskrit:
          'प्रकृतिं पुरुषं चैव विद्ध्यनादी उभावपि ।\n'
          'विकारांश्च गुणांश्चैव विद्धि प्रकृतिसंभवान् ॥१३.२०॥',
      english:
          'Know that both Nature and the individual soul are beginningless. All modifications and qualities arise from Nature.',
      gujarati:
          'પ્રકૃતિ અને પુરુષ બંનેને અનાદિ જાણ. બધા વિકારો અને ત્રણેય ગુણો પ્રકૃતિમાંથી ઉત્પન્ન થાય છે.',
      meaningEnglish:
          'Nature and the individual soul are beginningless, while material modifications and qualities arise from Nature.',
      meaningGujarati:
          'પ્રકૃતિ અને પુરુષ અનાદિ છે, જ્યારે વિકારો અને ગુણો પ્રકૃતિમાંથી ઉત્પન્ન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 21,
      sanskrit:
          'कार्यकारणकर्तृत्वे हेतुः प्रकृतिरुच्यते ।\n'
          'पुरुषः सुखदुःखानां भोक्तृत्वे हेतुरुच्यते ॥१३.२१॥',
      english:
          'Nature is said to be the cause of body and senses and their activities, while the individual soul is the experiencer of pleasure and pain.',
      gujarati:
          'શરીર, ઇન્દ્રિયો અને તેમની ક્રિયાઓનું કારણ પ્રકૃતિ છે, જ્યારે સુખ અને દુઃખના અનુભવનું કારણ પુરુષ છે.',
      meaningEnglish:
          'Nature produces the body, senses and their activities, while the soul experiences pleasure and pain.',
      meaningGujarati:
          'પ્રકૃતિ શરીર અને ઇન્દ્રિયોની ક્રિયાઓનું કારણ છે, જ્યારે પુરુષ સુખ-દુઃખનો અનુભવ કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 22,
      sanskrit:
          'पुरुषः प्रकृतिस्थो हि भुङ्क्ते प्रकृतिजान्गुणान् ।\n'
          'कारणं गुणसङ्गोऽस्य सदसद्योनिजन्मसु ॥१३.२२॥',
      english:
          'The soul residing in Nature experiences the qualities born of Nature. Attachment to these qualities causes birth in higher or lower wombs.',
      gujarati:
          'પ્રકૃતિમાં રહેલો પુરુષ પ્રકૃતિથી ઉત્પન્ન થયેલા ગુણોનો અનુભવ કરે છે. ગુણો સાથેની આસક્તિના કારણે તેને સારા-નરસા યોનિઓમાં જન્મ લેવો પડે છે.',
      meaningEnglish:
          'Attachment to the qualities of Nature binds the soul to repeated birth.',
      meaningGujarati:
          'પ્રકૃતિના ગુણો પ્રત્યેની આસક્તિ આત્માને જન્મ-મરણના બંધનમાં રાખે છે.',
    ),

    SacredVerseModel(
      verseNumber: 23,
      sanskrit:
          'उपद्रष्टानुमन्ता च भर्ता भोक्ता महेश्वरः ।\n'
          'परमात्मेति चाप्युक्तो देहेऽस्मिन् पुरुषः परः ॥१३.२३॥',
      english:
          'The Supreme Person in the body is the witness, permitter, supporter, experiencer, great Lord and Supreme Self.',
      gujarati:
          'આ શરીરમાં રહેલો પરમ પુરુષ સાક્ષી, અનુમતિ આપનાર, પાલન કરનાર, ભોક્તા, મહેશ્વર અને પરમાત્મા કહેવાય છે.',
      meaningEnglish:
          'The Supreme Self within the body is the witness, supporter and inner Lord.',
      meaningGujarati:
          'શરીરમાં રહેલો પરમાત્મા સાક્ષી, પાલનકર્તા અને આંતરિક સ્વામી છે.',
    ),

    SacredVerseModel(
      verseNumber: 24,
      sanskrit:
          'य एवं वेत्ति पुरुषं प्रकृतिं च गुणैः सह ।\n'
          'सर्वथा वर्तमानोऽपि न स भूयोऽभिजायते ॥१३.२४॥',
      english:
          'One who truly knows the soul, Nature and the three qualities is not born again, regardless of how he lives.',
      gujarati:
          'જે પુરુષ પ્રકૃતિ અને તેના ત્રણ ગુણો સાથેના સ્વરૂપને સાચી રીતે જાણે છે, તે કોઈપણ રીતે જીવન જીવતો હોવા છતાં ફરી જન્મ લેતો નથી.',
      meaningEnglish:
          'True understanding of the soul, Nature and its qualities frees a person from repeated birth.',
      meaningGujarati:
          'આત્મા, પ્રકૃતિ અને ગુણોના તત્ત્વજ્ઞાનથી પુનર્જન્મના બંધનમાંથી મુક્તિ મળે છે.',
    ),

    SacredVerseModel(
      verseNumber: 25,
      sanskrit:
          'ध्यानेनात्मनि पश्यन्ति केचिदात्मानमात्मना ।\n'
          'अन्ये सांख्येन योगेन कर्मयोगेन चापरे ॥१३.२५॥',
      english:
          'Some perceive the Self within through meditation, others through knowledge of Sankhya, and others through Karma Yoga.',
      gujarati:
          'કેટલાક લોકો ધ્યાનયોગથી પોતાના અંતરમાં આત્માને જુએ છે, કેટલાક સાંખ્યયોગથી અને કેટલાક કર્મયોગથી આત્માને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Different seekers realize the Self through meditation, knowledge or selfless action.',
      meaningGujarati:
          'સાધકો ધ્યાન, જ્ઞાન અથવા કર્મયોગ જેવા વિવિધ માર્ગોથી આત્મસાક્ષાત્કાર મેળવી શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 26,
      sanskrit:
          'अन्ये त्वेवमजानन्तः श्रुत्वान्येभ्य उपासते ।\n'
          'तेऽपि चातितरन्त्येव मृत्युं श्रुतिपरायणाः ॥१३.२६॥',
      english:
          'Others, not knowing these paths themselves, hear from realized persons and worship accordingly. They too cross beyond death by their faith in hearing.',
      gujarati:
          'જે લોકો પોતે આ માર્ગોને જાણતા નથી તેઓ જ્ઞાની પુરુષો પાસેથી સાંભળીને ઉપાસના કરે છે. શ્રદ્ધાપૂર્વક સાંભળનારા તેઓ પણ જન્મ-મરણના બંધનને પાર કરે છે.',
      meaningEnglish:
          'Those who sincerely hear spiritual teachings from realized persons can also cross beyond mortality.',
      meaningGujarati:
          'જ્ઞાની પુરુષો પાસેથી શ્રદ્ધાપૂર્વક સાંભળીને સાધના કરનાર પણ જન્મ-મરણથી પાર જઈ શકે છે.',
    ),

    SacredVerseModel(
      verseNumber: 27,
      sanskrit:
          'यावत्सञ्जायते किञ्चित्सत्त्वं स्थावरजङ्गमम् ।\n'
          'क्षेत्रक्षेत्रज्ञसंयोगात्तद्विद्धि भरतर्षभ ॥१३.२७॥',
      english:
          'Know, O best of the Bharatas, that whatever being—moving or unmoving—is born results from the union of the field and the knower of the field.',
      gujarati:
          'હે ભરતશ્રેષ્ઠ! જગતમાં જે કંઈ સ્થાવર કે જંગમ પ્રાણી ઉત્પન્ન થાય છે તે ક્ષેત્ર અને ક્ષેત્રજ્ઞના સંયોગથી ઉત્પન્ન થાય છે.',
      meaningEnglish:
          'All living beings arise through the relationship between the field and the knower of the field.',
      meaningGujarati:
          'સ્થાવર અને જંગમ બધા જીવો ક્ષેત્ર અને ક્ષેત્રજ્ઞના સંયોગથી ઉત્પન્ન થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 28,
      sanskrit:
          'समं सर्वेषु भूतेषु तिष्ठन्तं परमेश्वरम् ।\n'
          'विनश्यत्स्वविनश्यन्तं यः पश्यति स पश्यति ॥१३.२८॥',
      english:
          'One who sees the Supreme Lord equally present in all beings, even while their bodies perish, truly sees.',
      gujarati:
          'જે મનુષ્ય બધા જીવોમાં સમાન રીતે રહેલા પરમાત્માને જુએ છે અને નાશ પામતા શરીરોમાં પણ અવિનાશી પરમાત્માને જુએ છે, તે જ સાચું જુએ છે.',
      meaningEnglish:
          'True vision means seeing the same imperishable Supreme Self in all beings.',
      meaningGujarati:
          'સાચી દૃષ્ટિ એ છે કે નાશવંત શરીરોમાં પણ એક જ અવિનાશી પરમાત્માને જોવો.',
    ),

    SacredVerseModel(
      verseNumber: 29,
      sanskrit:
          'समं पश्यन्हि सर्वत्र समवस्थितमीश्वरम् ।\n'
          'न हिनस्त्यात्मनात्मानं ततो याति परां गतिम् ॥१३.२९॥',
      english:
          'Seeing the Lord equally present everywhere, one does not harm oneself by oneself and thus attains the supreme destination.',
      gujarati:
          'જે સર્વત્ર સમાન રીતે રહેલા પરમાત્માને જુએ છે તે પોતે જ પોતાના આત્માને નુકસાન કરતો નથી અને અંતે પરમગતિ પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Seeing the Divine equally in all beings prevents harmful actions and leads toward liberation.',
      meaningGujarati:
          'સર્વમાં પરમાત્માને સમાન જોવાથી આત્મવિનાશક કર્મોથી બચી પરમગતિ પ્રાપ્ત થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 30,
      sanskrit:
          'प्रकृत्यैव च कर्माणि क्रियमाणानि सर्वशः ।\n'
          'यः पश्यति तथात्मानमकर्तारं स पश्यति ॥१३.३०॥',
      english:
          'One who sees that all actions are performed by Nature and that the Self is not the doer truly sees.',
      gujarati:
          'જે મનુષ્ય જુએ છે કે બધા કર્મો પ્રકૃતિ દ્વારા જ થાય છે અને આત્મા ખરેખર કર્તા નથી, તે જ સાચું જ્ઞાન ધરાવે છે.',
      meaningEnglish:
          'True understanding recognizes the activities of Nature while seeing the Self as beyond material action.',
      meaningGujarati:
          'સાચું જ્ઞાન પ્રકૃતિનાં કર્મોને સમજે છે અને આત્માને ભૌતિક કર્તાપણાથી પર જાણે છે.',
    ),

    SacredVerseModel(
      verseNumber: 31,
      sanskrit:
          'यदा भूतपृथग्भावमेकस्थमनुपश्यति ।\n'
          'तत एव च विस्तारं ब्रह्म सम्पद्यते तदा ॥१३.३१॥',
      english:
          'When one sees that all the diverse beings are rooted in the One and have expanded from That alone, one attains Brahman.',
      gujarati:
          'જ્યારે મનુષ્ય જુએ છે કે બધા જુદા-જુદા જીવો એક પરમ તત્ત્વમાં સ્થિત છે અને એ જ એકમાંથી તેમનો વિસ્તાર થયો છે, ત્યારે તે બ્રહ્મને પ્રાપ્ત કરે છે.',
      meaningEnglish:
          'Seeing all diversity as arising from and resting in the One leads to realization of Brahman.',
      meaningGujarati:
          'બધા જીવો એક પરમ તત્ત્વમાંથી પ્રગટ થયા છે તે સમજવાથી બ્રહ્મની પ્રાપ્તિ થાય છે.',
    ),

    SacredVerseModel(
      verseNumber: 32,
      sanskrit:
          'अनादित्वान्निर्गुणत्वात्परमात्मायमव्ययः ।\n'
          'शरीरस्थोऽपि कौन्तेय न करोति न लिप्यते ॥१३.३२॥',
      english:
          'Because the Supreme Self is beginningless and beyond the qualities, it is imperishable. Though dwelling in the body, it neither acts nor becomes tainted.',
      gujarati:
          'પરમાત્મા અનાદિ અને ગુણોથી પર હોવાથી અવિનાશી છે. હે કુંતીપુત્ર! શરીરમાં રહેલો હોવા છતાં તે કર્મ કરતો નથી અને કર્મોથી લેપાતો નથી.',
      meaningEnglish:
          'The Supreme Self remains untouched by material action even while dwelling within the body.',
      meaningGujarati:
          'શરીરમાં રહેલો હોવા છતાં પરમાત્મા કર્મોથી અસ્પર્શિત અને અવિનાશી રહે છે.',
    ),

    SacredVerseModel(
      verseNumber: 33,
      sanskrit:
          'यथा सर्वगतं सौक्ष्म्यादाकाशं नोपलिप्यते ।\n'
          'सर्वत्रावस्थितो देहे तथात्मा नोपलिप्यते ॥१३.३३॥',
      english:
          'Just as the all-pervading sky is not tainted because of its subtle nature, so the Self dwelling in every body is not tainted.',
      gujarati:
          'જેમ સર્વવ્યાપક આકાશ અત્યંત સૂક્ષ્મ હોવાથી કોઈ વસ્તુથી લેપાતું નથી, તેમ દરેક શરીરમાં રહેલો આત્મા પણ કર્મોથી લેપાતો નથી.',
      meaningEnglish:
          'Just as space remains untouched by what exists within it, the Self remains untouched by bodily actions.',
      meaningGujarati:
          'જેમ આકાશ કોઈ વસ્તુથી લેપાતું નથી તેમ આત્મા પણ શરીરના કર્મોથી લેપાતો નથી.',
    ),

    SacredVerseModel(
      verseNumber: 34,
      sanskrit:
          'यथा प्रकाशयत्येकः कृत्स्नं लोकमिमं रविः ।\n'
          'क्षेत्रं क्षेत्री तथा कृत्स्नं प्रकाशयति भारत ॥१३.३४॥',
      english:
          'Just as the one Sun illumines the entire world, so the knower of the field illumines the entire field.',
      gujarati:
          'જેમ એક સૂર્ય સમગ્ર જગતને પ્રકાશિત કરે છે, તેમ ક્ષેત્રજ્ઞ સમગ્ર ક્ષેત્રને પ્રકાશિત કરે છે.',
      meaningEnglish:
          'The knower of the field illuminates the body and its experiences just as the Sun illuminates the world.',
      meaningGujarati:
          'જેમ સૂર્ય જગતને પ્રકાશિત કરે છે તેમ ક્ષેત્રજ્ઞ સમગ્ર શરીરરૂપ ક્ષેત્રને પ્રકાશિત કરે છે.',
    ),

    SacredVerseModel(
      verseNumber: 35,
      sanskrit:
          'क्षेत्रक्षेत्रज्ञयोरेवमन्तरं ज्ञानचक्षुषा ।\n'
          'भूतप्रकृतिमोक्षं च ये विदुर्यान्ति ते परम् ॥१३.३५॥',
      english:
          'Those who perceive the distinction between the field and the knower of the field with the eye of knowledge, and understand liberation from Nature, attain the Supreme.',
      gujarati:
          'જે મનુષ્યો જ્ઞાનની દૃષ્ટિથી ક્ષેત્ર અને ક્ષેત્રજ્ઞનો ભેદ સમજે છે અને પ્રકૃતિના બંધનમાંથી મુક્ત થવાનો માર્ગ જાણે છે, તેઓ પરમપદને પ્રાપ્ત થાય છે.',
      meaningEnglish:
          'Those who understand the distinction between the field and its knower and become free from Nature attain the Supreme.',
      meaningGujarati:
          'ક્ષેત્ર અને ક્ષેત્રજ્ઞનો ભેદ સમજીને પ્રકૃતિના બંધનમાંથી મુક્ત થનાર પરમપદ પ્રાપ્ત કરે છે.',
    ),
  ];
}
static List<SacredVerseModel> _gitaChapter14Verses() {
  return [
    SacredVerseModel(
  verseNumber: 1,
  sanskrit:
      'परं भूयः प्रवक्ष्यामि ज्ञानानां ज्ञानमुत्तमम्।\n'
      'यज्ज्ञात्वा मुनयः सर्वे परां सिद्धिमितो गताः॥१४.१॥',
  english:
      'I shall again explain the supreme knowledge, knowing which all sages have attained the highest perfection.',
  gujarati:
      'હું ફરીથી સર્વ જ્ઞાનોમાં શ્રેષ્ઠ જ્ઞાન કહું છું, જેને જાણીને બધા મુનિઓ આ સંસારથી પરમ સિદ્ધિને પ્રાપ્ત થયા છે.',
  meaningEnglish:
      'The supreme knowledge leads the seeker to the highest perfection.',
  meaningGujarati:
      'સર્વોત્તમ જ્ઞાનને જાણવાથી મનુષ્ય પરમ સિદ્ધિ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 2,
  sanskrit:
      'इदं ज्ञानमुपाश्रित्य मम साधर्म्यमागताः।\n'
      'सर्गेऽपि नोपजायन्ते प्रलये न व्यथन्ति च॥१४.२॥',
  english:
      'Taking refuge in this knowledge, one attains My nature and is neither born at creation nor disturbed at dissolution.',
  gujarati:
      'આ જ્ઞાનનો આશ્રય લઈને મનુષ્ય મારા સ્વરૂપને પ્રાપ્ત કરે છે. પછી સૃષ્ટિના સમયે જન્મતો નથી અને પ્રલય સમયે દુઃખ પામતો નથી.',
  meaningEnglish:
      'By taking refuge in this spiritual knowledge, one becomes united with the divine nature and is freed from birth and dissolution.',
  meaningGujarati:
      'આ આધ્યાત્મિક જ્ઞાનનો આશ્રય લેવાથી મનુષ્ય દિવ્ય સ્વરૂપને પ્રાપ્ત કરીને જન્મ અને પ્રલયના બંધનથી મુક્ત થાય છે.',
),

SacredVerseModel(
  verseNumber: 3,
  sanskrit:
      'मम योनिर्महद् ब्रह्म तस्मिन् गर्भं दधाम्यहम्।\n'
      'सम्भवः सर्वभूतानां ततो भवति भारत॥१४.३॥',
  english:
      'The great Brahman is My womb; in it I place the seed from which all beings are born.',
  gujarati:
      'હે ભારત! મહત્ બ્રહ્મ મારી પ્રકૃતિ છે. તેમાં હું ચેતનાનું બીજ સ્થાપું છું અને તેમાંથી સર્વ પ્રાણીઓ ઉત્પન્ન થાય છે.',
  meaningEnglish:
      'The divine places the seed of life in Prakriti, from which all beings arise.',
  meaningGujarati:
      'પરમાત્મા પ્રકૃતિમાં ચેતનાનું બીજ સ્થાપે છે અને તેમાંથી સર્વ જીવો ઉત્પન્ન થાય છે.',
),

SacredVerseModel(
  verseNumber: 4,
  sanskrit:
      'सर्वयोनिषु कौन्तेय मूर्तयः सम्भवन्ति याः।\n'
      'तासां ब्रह्म महद्योनिरहं बीजप्रदः पिता॥१४.४॥',
  english:
      'Whatever forms are born in all species, Prakriti is their mother and I am the seed-giving Father.',
  gujarati:
      'હે કૌન્તેય! સર્વ યોનિઓમાંથી જે પ્રાણીઓ જન્મે છે તેમની મહાન પ્રકૃતિ માતા છે અને હું બીજ આપનાર પિતા છું.',
  meaningEnglish:
      'Prakriti is the universal mother of all beings, while the Supreme is the seed-giving Father.',
  meaningGujarati:
      'પ્રકૃતિ સર્વ જીવોની માતા છે અને પરમાત્મા બીજ આપનાર પિતા છે.',
),

SacredVerseModel(
  verseNumber: 5,
  sanskrit:
      'सत्त्वं रजस्तम इति गुणाः प्रकृतिसम्भवाः।\n'
      'निबध्नन्ति महाबाहो देहे देहिनमव्ययम्॥१४.५॥',
  english:
      'Sattva, Rajas and Tamas are the three qualities born of Prakriti. They bind the imperishable soul to the body.',
  gujarati:
      'હે મહાબાહુ! સત્ત્વ, રજસ અને તમસ પ્રકૃતિમાંથી ઉત્પન્ન થયેલા ત્રણ ગુણો છે. તેઓ અવિનાશી આત્માને શરીર સાથે બાંધી રાખે છે.',
  meaningEnglish:
      'The three Gunas arise from Prakriti and bind the eternal soul to bodily existence.',
  meaningGujarati:
      'સત્ત્વ, રજસ અને તમસ પ્રકૃતિના ત્રણ ગુણો છે અને તેઓ આત્માને શરીર સાથે બાંધે છે.',
),

SacredVerseModel(
  verseNumber: 6,
  sanskrit:
      'तत्र सत्त्वं निर्मलत्वात्प्रकाशकमनामयम्।\n'
      'सुखसङ्गेन बध्नाति ज्ञानसङ्गेन चानघ॥१४.६॥',
  english:
      'Sattva is pure and illuminating; yet it binds a person through attachment to happiness and knowledge.',
  gujarati:
      'સત્ત્વગુણ નિર્મળ અને પ્રકાશ આપનાર છે, પરંતુ તે મનુષ્યને સુખ અને જ્ઞાનના આસક્તિ દ્વારા બાંધે છે.',
  meaningEnglish:
      'Sattva is pure and illuminating, but attachment to happiness and knowledge can also become binding.',
  meaningGujarati:
      'સત્ત્વગુણ શુદ્ધ હોવા છતાં સુખ અને જ્ઞાનની આસક્તિ દ્વારા મનુષ્યને બાંધે છે.',
),

SacredVerseModel(
  verseNumber: 7,
  sanskrit:
      'रजो रागात्मकं विद्धि तृष्णासङ्गसमुद्भवम्।\n'
      'तन्निबध्नाति कौन्तेय कर्मसङ्गेन देहिनम्॥१४.७॥',
  english:
      'Know Rajas to be of the nature of passion, born from desire and attachment. It binds the soul through attachment to action.',
  gujarati:
      'રજોગુણ રાગ અને તૃષ્ણાથી ઉત્પન્ન થાય છે. તે મનુષ્યને કર્મ પ્રત્યેની આસક્તિથી બાંધે છે.',
  meaningEnglish:
      'Rajas arises from desire and attachment and binds a person through attachment to action.',
  meaningGujarati:
      'રજોગુણ તૃષ્ણા અને આસક્તિથી ઉત્પન્ન થઈ કર્મમાં આસક્તિ દ્વારા બાંધે છે.',
),

SacredVerseModel(
  verseNumber: 8,
  sanskrit:
      'तमस्त्वज्ञानजं विद्धि मोहनं सर्वदेहिनाम्।\n'
      'प्रमादालस्यनिद्राभिस्तन्निबध्नाति भारत॥१४.८॥',
  english:
      'Tamas is born of ignorance and deludes all beings. It binds through negligence, laziness and sleep.',
  gujarati:
      'તમોગુણ અજ્ઞાનમાંથી ઉત્પન્ન થાય છે અને બધા જીવોને મોહિત કરે છે. તે પ્રમાદ, આળસ અને ઊંઘ દ્વારા બાંધે છે.',
  meaningEnglish:
      'Tamas comes from ignorance and binds beings through negligence, laziness and sleep.',
  meaningGujarati:
      'તમોગુણ અજ્ઞાનથી ઉત્પન્ન થઈ પ્રમાદ, આળસ અને ઊંઘ દ્વારા જીવને બાંધે છે.',
),

SacredVerseModel(
  verseNumber: 9,
  sanskrit:
      'सत्त्वं सुखे सञ्जयति रजः कर्मणि भारत।\n'
      'ज्ञानमावृत्य तु तमः प्रमादे सञ्जयत्युत॥१४.९॥',
  english:
      'Sattva attaches one to happiness, Rajas to action, while Tamas covers knowledge and leads to negligence.',
  gujarati:
      'સત્ત્વ સુખમાં આસક્ત કરે છે, રજસ કર્મમાં આસક્ત કરે છે અને તમસ જ્ઞાનને ઢાંકી પ્રમાદમાં જોડે છે.',
  meaningEnglish:
      'Sattva leads toward happiness, Rajas toward action, and Tamas toward negligence by covering knowledge.',
  meaningGujarati:
      'સત્ત્વ સુખમાં, રજસ કર્મમાં અને તમસ અજ્ઞાન તથા પ્રમાદમાં આસક્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 10,
  sanskrit:
      'रजस्तमश्चाभिभूय सत्त्वं भवति भारत।\n'
      'रजः सत्त्वं तमश्चैव तमः सत्त्वं रजस्तथा॥१४.१०॥',
  english:
      'Sometimes Sattva prevails over Rajas and Tamas; sometimes Rajas prevails, and sometimes Tamas.',
  gujarati:
      'ક્યારેક સત્ત્વગુણ રજસ અને તમસ પર વિજય મેળવે છે; ક્યારેક રજસ સત્ત્વ અને તમસ પર અને ક્યારેક તમસ સત્ત્વ અને રજસ પર પ્રબળ બને છે.',
  meaningEnglish:
      'The three Gunas continually compete, with one becoming dominant over the others at different times.',
  meaningGujarati:
      'ત્રણેય ગુણોમાં સમય પ્રમાણે એક ગુણ બીજા ગુણો કરતાં પ્રબળ બને છે.',
),

SacredVerseModel(
  verseNumber: 11,
  sanskrit:
      'सर्वद्वारेषु देहेऽस्मिन् प्रकाश उपजायते।\n'
      'ज्ञानं यदा तदा विद्याद्विवृद्धं सत्त्वमित्युत॥१४.११॥',
  english:
      'When knowledge and illumination arise through all the senses, one should know that Sattva has increased.',
  gujarati:
      'જ્યારે શરીરના બધા ઇન્દ્રિયોમાં જ્ઞાનનો પ્રકાશ પ્રગટ થાય ત્યારે સમજવું કે સત્ત્વગુણ વધ્યો છે.',
  meaningEnglish:
      'Clarity and illumination through the senses indicate the increase of Sattva.',
  meaningGujarati:
      'ઇન્દ્રિયોમાં જ્ઞાન અને પ્રકાશ વધે ત્યારે સત્ત્વગુણની વૃદ્ધિ સમજવી.',
),

SacredVerseModel(
  verseNumber: 12,
  sanskrit:
      'लोभः प्रवृत्तिरारम्भः कर्मणामशमः स्पृहा।\n'
      'रजस्येतानि जायन्ते विवृद्धे भरतर्षभ॥१४.१२॥',
  english:
      'Greed, activity, constant undertaking of actions, restlessness and craving arise when Rajas increases.',
  gujarati:
      'રજોગુણ વધે ત્યારે લોભ, અતિશય પ્રવૃત્તિ, કર્મોમાં આરંભ, અશાંતિ અને તૃષ્ણા ઉત્પન્ન થાય છે.',
  meaningEnglish:
      'Greed, restless activity and craving are signs of increased Rajas.',
  meaningGujarati:
      'લોભ, અશાંતિ, અતિશય કર્મપ્રવૃત્તિ અને તૃષ્ણા રજોગુણની વૃદ્ધિના લક્ષણો છે.',
),

SacredVerseModel(
  verseNumber: 13,
  sanskrit:
      'अप्रकाशोऽप्रवृत्तिश्च प्रमादो मोह एव च।\n'
      'तमस्येतानि जायन्ते विवृद्धे कुरुनन्दन॥१४.१३॥',
  english:
      'When Tamas increases, darkness, inactivity, negligence and delusion arise.',
  gujarati:
      'તમોગુણ વધે ત્યારે અજ્ઞાન, નિષ્ક્રિયતા, પ્રમાદ અને મોહ ઉત્પન્ન થાય છે.',
  meaningEnglish:
      'Darkness, inactivity, negligence and delusion indicate increased Tamas.',
  meaningGujarati:
      'અજ્ઞાન, નિષ્ક્રિયતા, પ્રમાદ અને મોહ તમોગુણની વૃદ્ધિના લક્ષણો છે.',
),

SacredVerseModel(
  verseNumber: 14,
  sanskrit:
      'यदा सत्त्वे प्रवृद्धे तु प्रलयं याति देहभृत्।\n'
      'तदोत्तमविदां लोकानमलान्प्रतिपद्यते॥१४.१४॥',
  english:
      'If one dies when Sattva predominates, one reaches the pure worlds of the knowers of the Highest.',
  gujarati:
      'જ્યારે સત્ત્વગુણ વધેલો હોય ત્યારે મૃત્યુ પામનાર ઉત્તમ જ્ઞાનીઓના પવિત્ર લોકને પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'A person who dies while Sattva predominates reaches pure and elevated realms.',
  meaningGujarati:
      'સત્ત્વગુણની પ્રબળ સ્થિતિમાં મૃત્યુ પામનાર પવિત્ર અને ઉચ્ચ લોકને પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 15,
  sanskrit:
      'रजसि प्रलयं गत्वा कर्मसङ्गिषु जायते।\n'
      'तथा प्रलीनस्तमसि मूढयोनिषु जायते॥१४.१५॥',
  english:
      'Dying in Rajas, one is born among those attached to action; dying in Tamas, one is born in ignorant forms.',
  gujarati:
      'રજોગુણમાં મૃત્યુ પામનાર કર્માસક્ત મનુષ્યોમાં જન્મે છે અને તમોગુણમાં મૃત્યુ પામનાર મૂઢ યોનિઓમાં જન્મે છે.',
  meaningEnglish:
      'The dominant Guna at death influences the nature of the next birth.',
  meaningGujarati:
      'મૃત્યુ સમયે જે ગુણ પ્રબળ હોય તે આગળના જન્મની સ્થિતિને પ્રભાવિત કરે છે.',
),

SacredVerseModel(
  verseNumber: 16,
  sanskrit:
      'कर्मणः सुकृतस्याहुः सात्त्विकं निर्मलं फलम्।\n'
      'रजसस्तु फलं दुःखमज्ञानं तमसः फलम्॥१४.१६॥',
  english:
      'The fruit of righteous action is pure and sattvic; the fruit of Rajas is suffering, and the fruit of Tamas is ignorance.',
  gujarati:
      'સારા કર્મનું ફળ સાત્ત્વિક અને નિર્મળ હોય છે. રજસનું ફળ દુઃખ અને તમસનું ફળ અજ્ઞાન છે.',
  meaningEnglish:
      'Sattvic actions lead to purity, Rajasic actions to suffering, and Tamasic actions to ignorance.',
  meaningGujarati:
      'સાત્ત્વિક કર્મ શુદ્ધ ફળ આપે છે, રજસ દુઃખ આપે છે અને તમસ અજ્ઞાન તરફ લઈ જાય છે.',
),

SacredVerseModel(
  verseNumber: 17,
  sanskrit:
      'सत्त्वात्सञ्जायते ज्ञानं रजसो लोभ एव च।\n'
      'प्रमादमोहौ तमसो भवतोऽज्ञानमेव च॥१४.१७॥',
  english:
      'From Sattva arises knowledge; from Rajas, greed; and from Tamas arise negligence, delusion and ignorance.',
  gujarati:
      'સત્ત્વમાંથી જ્ઞાન, રજસમાંથી લોભ અને તમસમાંથી પ્રમાદ, મોહ તથા અજ્ઞાન ઉત્પન્ન થાય છે.',
  meaningEnglish:
      'Knowledge arises from Sattva, greed from Rajas, and negligence and ignorance from Tamas.',
  meaningGujarati:
      'સત્ત્વથી જ્ઞાન, રજસથી લોભ અને તમસથી પ્રમાદ, મોહ તથા અજ્ઞાન ઉત્પન્ન થાય છે.',
),

SacredVerseModel(
  verseNumber: 18,
  sanskrit:
      'ऊर्ध्वं गच्छन्ति सत्त्वस्था मध्ये तिष्ठन्ति राजसाः।\n'
      'जघन्यगुणवृत्तिस्था अधो गच्छन्ति तामसाः॥१४.१८॥',
  english:
      'Those established in Sattva rise upward; those in Rajas remain in the middle; those in Tamas go downward.',
  gujarati:
      'સત્ત્વગુણમાં રહેનારા ઊંચા લોકમાં જાય છે, રજોગુણી મધ્યમાં રહે છે અને તમોગુણી અધોગતિ પામે છે.',
  meaningEnglish:
      'Sattva leads upward, Rajas keeps one in the middle, and Tamas leads downward.',
  meaningGujarati:
      'સત્ત્વ ઊર્ધ્વગતિ આપે છે, રજસ મધ્યમાં રાખે છે અને તમસ અધોગતિ તરફ લઈ જાય છે.',
),

SacredVerseModel(
  verseNumber: 19,
  sanskrit:
      'नान्यं गुणेभ्यः कर्तारं यदा द्रष्टानुपश्यति।\n'
      'गुणेभ्यश्च परं वेत्ति मद्भावं सोऽधिगच्छति॥१४.१९॥',
  english:
      'When one sees that the Gunas alone are the doers and knows Me as beyond them, one attains My nature.',
  gujarati:
      'જ્યારે મનુષ્ય સમજે છે કે ગુણો જ બધા કર્મોના કર્તા છે અને પોતાને ગુણોથી પર જાણે છે, ત્યારે તે મારા સ્વરૂપને પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'Seeing the Gunas as the agents and realizing the Supreme beyond them leads to the divine state.',
  meaningGujarati:
      'ગુણોને કર્મોના કર્તા સમજીને પોતાને ગુણોથી પર જાણવાથી મનુષ્ય પરમાત્માના સ્વરૂપને પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 20,
  sanskrit:
      'गुणानेतानतीत्य त्रीन्देही देहसमुद्भवान्।\n'
      'जन्ममृत्युजरादुःखैर्विमुक्तोऽमृतमश्नुते॥१४.२०॥',
  english:
      'Transcending these three Gunas, the embodied soul becomes free from birth, death, old age and suffering, and attains immortality.',
  gujarati:
      'આ ત્રણેય ગુણોને પાર કરનાર મનુષ્ય જન્મ, મૃત્યુ, વૃદ્ધાવસ્થા અને દુઃખથી મુક્ત થઈ અમૃતત્વ પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'Transcending the three Gunas frees the soul from the suffering of material existence and leads to immortality.',
  meaningGujarati:
      'ત્રણેય ગુણોથી પર થવાથી મનુષ્ય જન્મ, મૃત્યુ, વૃદ્ધાવસ્થા અને દુઃખથી મુક્ત થઈ અમૃતત્વ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 21,
  sanskrit:
      'अर्जुन उवाच—\n'
      'कैर्लिङ्गैस्त्रीन् गुणानेतानतीतो भवति प्रभो।\n'
      'किमाचारः कथं चैतांस्त्रीन् गुणानतिवर्तते॥१४.२१॥',
  english:
      'Arjuna asked: By what signs is one known who has transcended the three Gunas? What is his conduct, and how does he transcend them?',
  gujarati:
      'અર્જુન પૂછે છે: હે પ્રભુ! ત્રણ ગુણોથી પર થયેલા મનુષ્યનાં લક્ષણો કયા છે? તેનું આચરણ કેવું હોય છે અને તે ત્રણ ગુણોને કેવી રીતે પાર કરે છે?',
  meaningEnglish:
      'Arjuna asks about the signs, conduct and method of one who has transcended the three Gunas.',
  meaningGujarati:
      'અર્જુન ગુણાતીત મનુષ્યનાં લક્ષણો, આચરણ અને ગુણોને પાર કરવાની રીત વિશે પૂછે છે.',
),

SacredVerseModel(
  verseNumber: 22,
  sanskrit:
      'श्रीभगवानुवाच—\n'
      'प्रकाशं च प्रवृत्तिं च मोहमेव च पाण्डव।\n'
      'न द्वेष्टि सम्प्रवृत्तानि न निवृत्तानि काङ्क्षति॥१४.२२॥',
  english:
      'The Lord said: One who has transcended the Gunas neither hates illumination, activity or delusion when they arise, nor longs for them when they disappear.',
  gujarati:
      'ભગવાન કહે છે: ગુણોથી પર થયેલો મનુષ્ય પ્રકાશ, પ્રવૃત્તિ કે મોહ ઉત્પન્ન થાય ત્યારે તેમનો દ્વેષ કરતો નથી અને તે દૂર થાય ત્યારે તેમની ઇચ્છા પણ કરતો નથી.',
  meaningEnglish:
      'A person beyond the Gunas neither rejects nor desires the manifestations of the Gunas.',
  meaningGujarati:
      'ગુણાતીત મનુષ્ય ગુણોના પ્રકાશ, પ્રવૃત્તિ કે મોહ પ્રત્યે ન દ્વેષ રાખે છે ન આસક્તિ.',
),

SacredVerseModel(
  verseNumber: 23,
  sanskrit:
      'उदासीनवदासीनो गुणैर्यो न विचाल्यते।\n'
      'गुणा वर्तन्त इत्येव योऽवतिष्ठति नेङ्गते॥१४.२३॥',
  english:
      'He remains indifferent and is not disturbed by the Gunas, knowing that the Gunas alone are acting.',
  gujarati:
      'જે મનુષ્ય ગુણોથી વિચલિત થતો નથી અને “ગુણો જ ગુણોમાં વર્તે છે” એમ સમજીને સ્થિર રહે છે, તે ગુણાતીત છે.',
  meaningEnglish:
      'The Gunatita remains steady, understanding that the Gunas are acting according to their nature.',
  meaningGujarati:
      'ગુણાતીત મનુષ્ય ગુણોના કાર્યથી વિચલિત થયા વિના સ્થિર રહે છે અને ગુણોને જ કાર્યરત માને છે.',
),

SacredVerseModel(
  verseNumber: 24,
  sanskrit:
      'समदुःखसुखः स्वस्थः समलोष्टाश्मकाञ्चनः।\n'
      'तुल्यप्रियाप्रियो धीरस्तुल्यनिन्दात्मसंस्तुतिः॥१४.२४॥',
  english:
      'He is alike in pleasure and pain, steady within, regarding a clod, stone and gold equally, and equal toward the pleasant and unpleasant.',
  gujarati:
      'જે સુખ-દુઃખમાં સમાન રહે છે, માટી, પથ્થર અને સોનાને સમાન માને છે અને પ્રિય-અપ્રિય તથા નિંદા-સ્તુતિમાં સમાન રહે છે તે ધીર પુરુષ છે.',
  meaningEnglish:
      'The wise person remains equal in pleasure and pain, valuables and ordinary objects, praise and criticism.',
  meaningGujarati:
      'જ્ઞાની સુખ-દુઃખ, માટી-પથ્થર-સોનું તથા નિંદા-સ્તુતિમાં સમભાવ રાખે છે.',
),

SacredVerseModel(
  verseNumber: 25,
  sanskrit:
      'मानापमानयोस्तुल्यस्तुल्यो मित्रारिपक्षयोः।\n'
      'सर्वारम्भपरित्यागी गुणातीतः स उच्यते॥१४.२५॥',
  english:
      'He is equal in honor and dishonor, friend and enemy, and has renounced all selfish undertakings. Such a person is called Gunatita.',
  gujarati:
      'જે માન-અપમાન, મિત્ર-શત્રુમાં સમાન રહે છે અને સ્વાર્થભર્યા બધા કર્મારંભનો ત્યાગ કરે છે તે ગુણાતીત કહેવાય છે.',
  meaningEnglish:
      'Equanimity toward honor, dishonor, friends and enemies, along with freedom from selfish undertakings, defines a Gunatita.',
  meaningGujarati:
      'માન-અપમાન અને મિત્ર-શત્રુમાં સમભાવ તથા સ્વાર્થપૂર્ણ કર્મોના ત્યાગથી મનુષ્ય ગુણાતીત કહેવાય છે.',
),

SacredVerseModel(
  verseNumber: 26,
  sanskrit:
      'मां च योऽव्यभिचारेण भक्तियोगेन सेवते।\n'
      'स गुणान्समतीत्यैतान्ब्रह्मभूयाय कल्पते॥१४.२६॥',
  english:
      'One who serves Me with unwavering devotion transcends the three Gunas and becomes fit for Brahman.',
  gujarati:
      'જે મનુષ્ય અડગ ભક્તિયોગથી મારી સેવા કરે છે તે ત્રણેય ગુણોને પાર કરીને બ્રહ્મરૂપ થવા યોગ્ય બને છે.',
  meaningEnglish:
      'Unwavering devotion to the Supreme enables one to transcend all three Gunas and attain Brahman.',
  meaningGujarati:
      'અડગ ભક્તિ દ્વારા મનુષ્ય ત્રણેય ગુણોને પાર કરીને બ્રહ્મપ્રાપ્તિ માટે યોગ્ય બને છે.',
),

SacredVerseModel(
  verseNumber: 27,
  sanskrit:
      'ब्रह्मणो हि प्रतिष्ठाहममृतस्याव्ययस्य च।\n'
      'शाश्वतस्य च धर्मस्य सुखस्यैकान्तिकस्य च॥१४.२७॥',
  english:
      'For I am the foundation of Brahman, the immortal and imperishable, the eternal Dharma and absolute bliss.',
  gujarati:
      'કારણ કે હું અમર અને અવિનાશી બ્રહ્મનો આધાર, શાશ્વત ધર્મનો તથા અખંડ સુખનો આધાર છું.',
  meaningEnglish:
      'The Supreme is the foundation of immortal Brahman, eternal Dharma and absolute bliss.',
  meaningGujarati:
      'પરમાત્મા અમર બ્રહ્મ, શાશ્વત ધર્મ અને અખંડ સુખનો આધાર છે.',
),
  ];
  }
  static List<SacredVerseModel> _gitaChapter15Verses() {
  return [
    SacredVerseModel(
  verseNumber: 1,
  sanskrit:
      'श्रीभगवानुवाच—\n'
      'ऊर्ध्वमूलमधःशाखमश्वत्थं प्राहुरव्ययम्।\n'
      'छन्दांसि यस्य पर्णानि यस्तं वेद स वेदवित्॥१५.१॥',
  english:
      'The Lord said: The imperishable Ashvattha tree has its roots above and branches below. Its leaves are the Vedic hymns. One who knows this tree knows the Vedas.',
  gujarati:
      'ભગવાન કહે છે: આ સંસારરૂપ અશ્વત્થ વૃક્ષનાં મૂળ ઉપર અને શાખાઓ નીચે છે. તેના પાંદડાં વેદોના મંત્રો છે. જે આ વૃક્ષને જાણે છે તે વેદજ્ઞ છે.',
  meaningEnglish:
      'The Ashvattha tree represents the cosmic material existence, and knowing it leads to understanding the Vedic truth.',
  meaningGujarati:
      'અશ્વત્થ વૃક્ષ સંસારના સ્વરૂપનું પ્રતીક છે અને તેને સમજવાથી વૈદિક સત્યનું જ્ઞાન થાય છે.',
),

SacredVerseModel(
  verseNumber: 2,
  sanskrit:
      'अधश्चोर्ध्वं प्रसृतास्तस्य शाखा गुणप्रवृद्धा विषयप्रवालाः।\n'
      'अधश्च मूलान्यनुसन्ततानि कर्मानुबन्धीनि मनुष्यलोके॥१५.२॥',
  english:
      'Its branches spread upward and downward, nourished by the Gunas, with sense-objects as their shoots. Its roots extend downward into the world of humans, binding through actions.',
  gujarati:
      'તેની શાખાઓ ઉપર અને નીચે ફેલાયેલી છે અને ત્રણ ગુણોથી વધે છે. વિષયો તેના અંકુરો છે અને મનુષ્યલોકમાં કર્મના બંધનરૂપ મૂળ ફેલાયેલા છે.',
  meaningEnglish:
      'The branches of worldly existence grow through the Gunas and sense-objects, while karma creates binding roots.',
  meaningGujarati:
      'ત્રણ ગુણો અને ઇન્દ્રિયવિષયો સંસારવૃક્ષને વિસ્તારે છે અને કર્મો મનુષ્યને તેના બંધનમાં બાંધે છે.',
),

SacredVerseModel(
  verseNumber: 3,
  sanskrit:
      'न रूपमस्येह तथोपलभ्यते नान्तो न चादिर्न च सम्प्रतिष्ठा।\n'
      'अश्वत्थमेनं सुविरूढमूलमसङ्गशस्त्रेण दृढेन छित्त्वा॥१५.३॥',
  english:
      'Its true form cannot be perceived here, nor its beginning, end or foundation. This deeply rooted Ashvattha tree should be cut down with the strong weapon of detachment.',
  gujarati:
      'આ સંસારવૃક્ષનું સાચું સ્વરૂપ અહીં જાણી શકાતું નથી; તેનો અંત, આરંભ કે આધાર પણ જાણી શકાતો નથી. તેથી દૃઢ અસંગરૂપી શસ્ત્રથી તેના મૂળને કાપવું જોઈએ.',
  meaningEnglish:
      'The deeply rooted tree of worldly attachment must be cut down with the strong weapon of detachment.',
  meaningGujarati:
      'સંસારની ગાઢ આસક્તિને દૃઢ વૈરાગ્યના શસ્ત્રથી દૂર કરવી જોઈએ.',
),

SacredVerseModel(
  verseNumber: 4,
  sanskrit:
      'ततः पदं तत्परिमार्गितव्यं यस्मिन्गता न निवर्तन्ति भूयः।\n'
      'तमेव चाद्यं पुरुषं प्रपद्ये यतः प्रवृत्तिः प्रसृता पुराणी॥१५.४॥',
  english:
      'Then one should seek that supreme state from which none return, taking refuge in the Primordial Person from whom this ancient activity has arisen.',
  gujarati:
      'ત્યારબાદ તે પરમ પદની શોધ કરવી જોઈએ જ્યાં પહોંચ્યા પછી પાછા ફરવું પડતું નથી. જે આ સનાતન સંસારપ્રવાહનું મૂળ છે તે આદિ પુરુષનો આશ્રય લેવો જોઈએ.',
  meaningEnglish:
      'After overcoming attachment, one should seek the eternal supreme state and take refuge in the Primordial Person.',
  meaningGujarati:
      'આસક્તિનો ત્યાગ કર્યા પછી મનુષ્ય પરમ પદની શોધ કરી આદિ પુરુષનો આશ્રય લેવો જોઈએ.',
),

SacredVerseModel(
  verseNumber: 5,
  sanskrit:
      'निर्मानमोहा जितसङ्गदोषा अध्यात्मनित्या विनिवृत्तकामाः।\n'
      'द्वन्द्वैर्विमुक्ताः सुखदुःखसंज्ञैर् गच्छन्त्यमूढाः पदमव्ययं तत्॥१५.५॥',
  english:
      'Those free from pride and delusion, who have conquered attachment, are devoted to the Self, free from desires and dualities of pleasure and pain, attain the imperishable state.',
  gujarati:
      'જે માન અને મોહથી મુક્ત છે, આસક્તિનો દોષ જીતી લીધો છે, આત્મજ્ઞાનમાં સ્થિર છે, કામનાઓથી મુક્ત છે અને સુખ-દુઃખના દ્વંદ્વથી પર છે, તે અવિનાશી પદને પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'Freedom from pride, delusion, attachment, desire and duality leads the seeker to the imperishable state.',
  meaningGujarati:
      'માન, મોહ, આસક્તિ, કામના અને સુખ-દુઃખના દ્વંદ્વથી મુક્ત થવાથી અવિનાશી પદ પ્રાપ્ત થાય છે.',
),

SacredVerseModel(
  verseNumber: 6,
  sanskrit:
      'न तद्भासयते सूर्यो न शशाङ्को न पावकः।\n'
      'यद्गत्वा न निवर्तन्ते तद्धाम परमं मम॥१५.६॥',
  english:
      'Neither the sun, moon nor fire illumines that supreme abode of Mine. Having reached it, one never returns.',
  gujarati:
      'મારા પરમ ધામને સૂર્ય, ચંદ્ર કે અગ્નિ પ્રકાશિત કરી શકતા નથી. જેને પ્રાપ્ત કર્યા પછી જીવ ફરી સંસારમાં પાછો આવતો નથી.',
  meaningEnglish:
      'The Supreme abode is self-luminous and beyond the material sources of light; reaching it ends return to worldly existence.',
  meaningGujarati:
      'પરમ ધામ ભૌતિક પ્રકાશથી પર છે અને તેને પ્રાપ્ત કર્યા પછી સંસારમાં પાછા ફરવું પડતું નથી.',
),

SacredVerseModel(
  verseNumber: 7,
  sanskrit:
      'ममैवांशो जीवलोके जीवभूतः सनातनः।\n'
      'मनःषष्ठानीन्द्रियाणि प्रकृतिस्थानि कर्षति॥१५.७॥',
  english:
      'The eternal individual soul in the world of living beings is indeed My own portion and draws the mind and five senses situated in Prakriti.',
  gujarati:
      'આ જીવલોકમાં રહેલો સનાતન જીવાત્મા મારો જ અંશ છે. તે પ્રકૃતિમાં રહેલા મન અને પાંચ ઇન્દ્રિયોને પોતાની તરફ ખેંચે છે.',
  meaningEnglish:
      'The eternal individual soul is a portion of the Supreme and interacts with the mind and senses in Prakriti.',
  meaningGujarati:
      'સનાતન જીવાત્મા પરમાત્માનો અંશ છે અને મન તથા પાંચ ઇન્દ્રિયો દ્વારા પ્રકૃતિ સાથે જોડાય છે.',
),

SacredVerseModel(
  verseNumber: 8,
  sanskrit:
      'शरीरं यदवाप्नोति यच्चाप्युत्क्रामतीश्वरः।\n'
      'गृहीत्वैतानि संयाति वायुर्गन्धानिवाशयात्॥१५.८॥',
  english:
      'When the soul enters a body or leaves it, it carries the mind and senses with it, just as the wind carries fragrances from their source.',
  gujarati:
      'જીવાત્મા જ્યારે શરીર ધારણ કરે છે અથવા તેને છોડે છે ત્યારે મન અને ઇન્દ્રિયોને સાથે લઈ જાય છે, જેમ વાયુ ફૂલોમાંથી સુગંધને લઈ જાય છે.',
  meaningEnglish:
      'The soul carries the subtle mind and senses from one body to another, like wind carrying fragrance.',
  meaningGujarati:
      'જીવાત્મા એક શરીરમાંથી બીજા શરીરમાં જતા મન અને ઇન્દ્રિયોને સાથે લઈ જાય છે.',
),

SacredVerseModel(
  verseNumber: 9,
  sanskrit:
      'श्रोत्रं चक्षुः स्पर्शनं च रसनं घ्राणमेव च।\n'
      'अधिष्ठाय मनश्चायं विषयानुपसेवते॥१५.९॥',
  english:
      'Presiding over the ears, eyes, skin, tongue, nose and mind, the soul experiences the sense-objects.',
  gujarati:
      'જીવાત્મા કાન, આંખ, ત્વચા, જીભ, નાક અને મનનો આશ્રય લઈને શબ્દ, રૂપ, સ્પર્શ, રસ અને ગંધ જેવા વિષયોનો અનુભવ કરે છે.',
  meaningEnglish:
      'The soul experiences the world through the five senses and the mind.',
  meaningGujarati:
      'જીવાત્મા મન અને પાંચ ઇન્દ્રિયો દ્વારા ઇન્દ્રિયવિષયોનો અનુભવ કરે છે.',
),

SacredVerseModel(
  verseNumber: 10,
  sanskrit:
      'उत्क्रामन्तं स्थितं वापि भुञ्जानं वा गुणान्वितम्।\n'
      'विमूढा नानुपश्यन्ति पश्यन्ति ज्ञानचक्षुषः॥१५.१०॥',
  english:
      'The deluded do not perceive the soul when it leaves, stays or experiences the Gunas; those with the eye of knowledge can see it.',
  gujarati:
      'જીવ શરીર છોડે, શરીરમાં રહે કે વિષયો ભોગવે ત્યારે અજ્ઞાની તેને જોઈ શકતા નથી; જ્ઞાનચક્ષુ ધરાવનાર જ તેને જોઈ શકે છે.',
  meaningEnglish:
      'Only those with spiritual knowledge can perceive the soul beyond its bodily activities.',
  meaningGujarati:
      'જ્ઞાનચક્ષુ ધરાવનાર જ શરીરથી પર રહેલા જીવાત્માના સ્વરૂપને જોઈ શકે છે.',
),

SacredVerseModel(
  verseNumber: 11,
  sanskrit:
      'यतन्तो योगिनश्चैनं पश्यन्त्यात्मन्यवस्थितम्।\n'
      'यतन्तोऽप्यकृतात्मानो नैनं पश्यन्त्यचेतसः॥१५.११॥',
  english:
      'Yogis who strive see the soul dwelling within themselves, but those who are not purified cannot see it even though they strive.',
  gujarati:
      'પ્રયત્નશીલ યોગીઓ આત્મામાં રહેલા આત્માને જોઈ શકે છે, પરંતુ જેમનું અંતઃકરણ શુદ્ધ નથી તેઓ પ્રયત્ન કરવા છતાં તેને જોઈ શકતા નથી.',
  meaningEnglish:
      'Self-realization is perceived by sincere and purified yogis through inner spiritual effort.',
  meaningGujarati:
      'શુદ્ધ અંતઃકરણ ધરાવતા પ્રયત્નશીલ યોગીઓ પોતાના અંતરમાં આત્માનો અનુભવ કરી શકે છે.',
),

SacredVerseModel(
  verseNumber: 12,
  sanskrit:
      'यदादित्यगतं तेजो जगद्भासयतेऽखिलम्।\n'
      'यच्चन्द्रमसि यच्चाग्नौ तत्तेजो विद्धि मामकम्॥१५.१२॥',
  english:
      'The light of the sun that illumines the whole world, and the light in the moon and fire—know that light to be Mine.',
  gujarati:
      'સૂર્યમાં રહેલું જે તેજ સમગ્ર જગતને પ્રકાશિત કરે છે અને ચંદ્ર તથા અગ્નિમાં જે તેજ છે, તે મારું જ તેજ છે.',
  meaningEnglish:
      'The illuminating power of the sun, moon and fire is understood as a manifestation of the Supreme.',
  meaningGujarati:
      'સૂર્ય, ચંદ્ર અને અગ્નિનું પ્રકાશરૂપ તેજ પરમાત્માની જ શક્તિ છે.',
),

SacredVerseModel(
  verseNumber: 13,
  sanskrit:
      'गामाविश्य च भूतानि धारयाम्यहमोजसा।\n'
      'पुष्णामि चौषधीः सर्वाः सोमो भूत्वा रसात्मकः॥१५.१३॥',
  english:
      'Entering the earth, I sustain all beings by My power; becoming the moon, I nourish all plants with their essence.',
  gujarati:
      'હું પૃથ્વીમાં પ્રવેશીને મારા સામર્થ્યથી સર્વ પ્રાણીઓને ધારણ કરું છું અને ચંદ્રરૂપે સર્વ ઔષધિઓ તથા વનસ્પતિને પોષણ આપું છું.',
  meaningEnglish:
      'The Supreme sustains all beings through the earth and nourishes vegetation through the moon.',
  meaningGujarati:
      'પરમાત્મા પૃથ્વી દ્વારા જીવોને ધારણ કરે છે અને ચંદ્રરૂપે વનસ્પતિને પોષણ આપે છે.',
),

SacredVerseModel(
  verseNumber: 14,
  sanskrit:
      'अहं वैश्वानरो भूत्वा प्राणिनां देहमाश्रितः।\n'
      'प्राणापानसमायुक्तः पचाम्यन्नं चतुर्विधम्॥१५.१४॥',
  english:
      'Becoming the fire of digestion in living beings, I digest the four kinds of food with the help of Prana and Apana.',
  gujarati:
      'હું પ્રાણીઓના શરીરમાં વૈશ્વાનર અગ્નિ બનીને પ્રાણ અને અપાન સાથે મળીને ચાર પ્રકારના અન્નનું પાચન કરું છું.',
  meaningEnglish:
      'The Supreme manifests as the digestive fire that processes the food consumed by living beings.',
  meaningGujarati:
      'પરમાત્મા શરીરમાં વૈશ્વાનર અગ્નિરૂપે અન્નનું પાચન કરે છે.',
),

SacredVerseModel(
  verseNumber: 15,
  sanskrit:
      'सर्वस्य चाहं हृदि सन्निविष्टो मत्तः स्मृतिर्ज्ञानमपोहनं च।\n'
      'वेदैश्च सर्वैरहमेव वेद्यो वेदान्तकृद्वेदविदेव चाहम्॥१५.१५॥',
  english:
      'I am seated in the hearts of all. From Me come memory, knowledge and their removal. I alone am to be known through all the Vedas; I am the author and knower of Vedanta.',
  gujarati:
      'હું સૌના હૃદયમાં રહેલો છું. મારાથી સ્મૃતિ, જ્ઞાન અને વિસ્મૃતિ થાય છે. બધા વેદો દ્વારા હું જ જાણવા યોગ્ય છું; હું વેદાંતનો રચયિતા અને વેદનો જ્ઞાતા છું.',
  meaningEnglish:
      'The Supreme dwells in every heart and is the source of memory, knowledge and forgetfulness, and the ultimate subject of the Vedas.',
  meaningGujarati:
      'પરમાત્મા સૌના હૃદયમાં વસે છે અને સ્મૃતિ, જ્ઞાન તથા વિસ્મૃતિનો સ્ત્રોત છે; વેદો દ્વારા તેને જ જાણવા યોગ્ય છે.',
),

SacredVerseModel(
  verseNumber: 16,
  sanskrit:
      'द्वाविमौ पुरुषौ लोके क्षरश्चाक्षर एव च।\n'
      'क्षरः सर्वाणि भूतानि कूटस्थोऽक्षर उच्यते॥१५.१६॥',
  english:
      'There are two kinds of beings in this world: the perishable and the imperishable. All beings are perishable, while the unchanging Self is called imperishable.',
  gujarati:
      'આ જગતમાં બે પ્રકારના પુરુષો છે—ક્ષર અને અક્ષર. સર્વ પ્રાણીઓ ક્ષર છે, જ્યારે કૂટસ્થ એટલે કે અપરિવર્તનશીલ આત્મા અક્ષર કહેવાય છે.',
  meaningEnglish:
      'The world contains the perishable beings and the imperishable, unchanging Self.',
  meaningGujarati:
      'ક્ષર એટલે નાશવાન પ્રાણીઓ અને અક્ષર એટલે અપરિવર્તનશીલ આત્મા.',
),

SacredVerseModel(
  verseNumber: 17,
  sanskrit:
      'उत्तमः पुरुषस्त्वन्यः परमात्मेत्युदाहृतः।\n'
      'यो लोकत्रयमाविश्य बिभर्त्यव्यय ईश्वरः॥१५.१७॥',
  english:
      'But there is another Supreme Person, called Paramatma, who enters the three worlds and sustains them as the imperishable Lord.',
  gujarati:
      'પરંતુ તે બંનેથી પર એક ઉત્તમ પુરુષ છે, જેને પરમાત્મા કહેવામાં આવે છે. તે અવિનાશી ઈશ્વર ત્રણેય લોકમાં પ્રવેશીને તેમનું પાલન કરે છે.',
  meaningEnglish:
      'Beyond the perishable and imperishable is the Supreme Person, Paramatma, who sustains all three worlds.',
  meaningGujarati:
      'ક્ષર અને અક્ષરથી પર પરમાત્મા નામનો ઉત્તમ પુરુષ છે, જે ત્રણેય લોકનું પાલન કરે છે.',
),

SacredVerseModel(
  verseNumber: 18,
  sanskrit:
      'यस्मात्क्षरमतीतोऽहमक्षरादपि चोत्तमः।\n'
      'अतोऽस्मि लोके वेदे च प्रथितः पुरुषोत्तमः॥१५.१८॥',
  english:
      'Because I transcend the perishable and am higher even than the imperishable, I am celebrated in the world and the Vedas as Purushottama.',
  gujarati:
      'હું ક્ષરથી પર અને અક્ષરથી પણ શ્રેષ્ઠ છું. તેથી લોકમાં અને વેદોમાં હું પુરુષોત્તમ તરીકે પ્રસિદ્ધ છું.',
  meaningEnglish:
      'The Supreme is beyond both the perishable and imperishable and is therefore known as Purushottama.',
  meaningGujarati:
      'ક્ષર અને અક્ષર બંનેથી પર હોવાથી પરમાત્મા પુરુષોત્તમ કહેવાય છે.',
),

SacredVerseModel(
  verseNumber: 19,
  sanskrit:
      'यो मामेवमसम्मूढो जानाति पुरुषोत्तमम्।\n'
      'स सर्वविद्भजति मां सर्वभावेन भारत॥१५.१९॥',
  english:
      'Whoever, without delusion, knows Me as Purushottama knows everything and worships Me with all his being.',
  gujarati:
      'હે ભારત! જે મોહરહિત થઈ મને પુરુષોત્તમ તરીકે જાણે છે, તે સર્વજ્ઞ બને છે અને પોતાના સમગ્ર ભાવથી મારી ભક્તિ કરે છે.',
  meaningEnglish:
      'One who truly understands the Supreme as Purushottama becomes spiritually wise and worships Him wholeheartedly.',
  meaningGujarati:
      'પુરુષોત્તમના સ્વરૂપને મોહરહિત થઈ જાણનાર સર્વજ્ઞ બની સંપૂર્ણ ભાવથી ભગવાનની ભક્તિ કરે છે.',
),

SacredVerseModel(
  verseNumber: 20,
  sanskrit:
      'इति गुह्यतमं शास्त्रमिदमुक्तं मयानघ।\n'
      'एतद्बुद्ध्वा बुद्धिमान्स्यात्कृतकृत्यश्च भारत॥१५.२०॥',
  english:
      'Thus I have revealed this most secret teaching to you. Understanding it, one becomes wise and fulfills the purpose of life.',
  gujarati:
      'હે નિષ્પાપ અર્જુન! મેં તને આ અત્યંત ગુહ્ય શાસ્ત્ર કહ્યું છે. તેને જાણીને મનુષ્ય બુદ્ધિમાન બને છે અને જીવનનું કર્તવ્ય પૂર્ણ કરનાર બને છે.',
  meaningEnglish:
      'Understanding this profound teaching makes a person wise and fulfills the purpose of life.',
  meaningGujarati:
      'આ ગુહ્ય ઉપદેશને સમજીને મનુષ્ય બુદ્ધિમાન બને છે અને જીવનનું સાચું કર્તવ્ય પૂર્ણ કરે છે.',
),
  ];
  }
  // અધ્યાય 16 — દૈવાસુર સંપદ્વિભાગ યોગ
  static List<SacredVerseModel> _gitaChapter16Verses() {
  return [
    SacredVerseModel(
  verseNumber: 1,
  sanskrit:
      'श्रीभगवानुवाच ।\n'
      'अभयं सत्त्वसंशुद्धिर्ज्ञानयोगव्यवस्थितिः ।\n'
      'दानं दमश्च यज्ञश्च स्वाध्यायस्तप आर्जवम् ॥१६.१॥',
  english:
      'Śrī Bhagavān said: Fearlessness, purity of mind, steadfastness in knowledge and yoga, charity, self-control, sacrifice, study of the scriptures, austerity and straightforwardness are divine qualities.',
  gujarati:
      'ભગવાન કહે છે — નિર્ભયતા, અંતઃકરણની શુદ્ધિ, જ્ઞાનયોગમાં સ્થિરતા, દાન, ઇન્દ્રિયસંયમ, યજ્ઞ, સ્વાધ્યાય, તપ અને સરળતા — આ દૈવી સંપત્તિના ગુણો છે.',
  meaningEnglish:
      'Fearlessness, purity, spiritual knowledge, self-control, charity, austerity and simplicity are among the qualities of divine nature.',
  meaningGujarati:
      'નિર્ભયતા, અંતઃકરણની શુદ્ધિ, જ્ઞાનમાં સ્થિરતા, સંયમ, દાન, તપ અને સરળતા દૈવી સ્વભાવના ગુણો છે.',
),

SacredVerseModel(
  verseNumber: 2,
  sanskrit:
      'अहिंसा सत्यमक्रोधस्त्यागः शान्तिरपैशुनम् ।\n'
      'दया भूतेष्वलोलुप्त्वं मार्दवं ह्रीरचापलम् ॥१६.२॥',
  english:
      'Nonviolence, truthfulness, absence of anger, renunciation, peacefulness, absence of fault-finding, compassion toward beings, freedom from greed, gentleness, modesty and absence of fickleness are divine qualities.',
  gujarati:
      'અહિંસા, સત્ય, ક્રોધનો અભાવ, ત્યાગ, શાંતિ, કોઈની નિંદા ન કરવી, પ્રાણીઓ પ્રત્યે દયા, લોભનો અભાવ, નમ્રતા અને ચંચળતાનો અભાવ — આ દૈવી ગુણો છે.',
  meaningEnglish:
      'Divine nature is expressed through nonviolence, truth, peace, compassion, humility, selflessness and freedom from greed.',
  meaningGujarati:
      'અહિંસા, સત્ય, શાંતિ, દયા, નમ્રતા, ત્યાગ અને લોભથી મુક્તિ દૈવી સ્વભાવ દર્શાવે છે.',
),

SacredVerseModel(
  verseNumber: 3,
  sanskrit:
      'तेजः क्षमा धृतिः शौचमद्रोहो नातिमानिता ।\n'
      'भवन्ति सम्पदं दैवीमभिजातस्य भारत ॥१६.३॥',
  english:
      'Radiance, forgiveness, fortitude, purity, absence of hatred and absence of excessive pride are the qualities of one born with divine nature.',
  gujarati:
      'તેજ, ક્ષમા, ધૈર્ય, પવિત્રતા, કોઈ પ્રત્યે દ્વેષ ન રાખવો અને અતિમાન ન હોવો — આ દૈવી સંપત્તિ ધરાવનારના ગુણો છે.',
  meaningEnglish:
      'Forgiveness, courage, purity, freedom from hatred and humility are signs of divine character.',
  meaningGujarati:
      'ક્ષમા, ધૈર્ય, પવિત્રતા, દ્વેષનો અભાવ અને નમ્રતા દૈવી સ્વભાવના મુખ્ય લક્ષણો છે.',
),

SacredVerseModel(
  verseNumber: 4,
  sanskrit:
      'दम्भो दर्पोऽभिमानश्च क्रोधः पारुष्यमेव च ।\n'
      'अज्ञानं चाभिजातस्य पार्थ सम्पदमासुरीम् ॥१६.४॥',
  english:
      'Hypocrisy, arrogance, pride, anger, harshness and ignorance are the qualities of one born with an asuric nature.',
  gujarati:
      'દંભ, ઘમંડ, અભિમાન, ક્રોધ, કઠોરતા અને અજ્ઞાન — આ આસુરી સંપત્તિના ગુણો છે.',
  meaningEnglish:
      'Hypocrisy, arrogance, pride, anger, cruelty and ignorance characterize the asuric nature.',
  meaningGujarati:
      'દંભ, ઘમંડ, અભિમાન, ક્રોધ, કઠોરતા અને અજ્ઞાન આસુરી સ્વભાવનાં લક્ષણો છે.',
),

SacredVerseModel(
  verseNumber: 5,
  sanskrit:
      'दैवी सम्पद्विमोक्षाय निबन्धायासुरी मता ।\n'
      'मा शुचः सम्पदं दैवीमभिजातोऽसि पाण्डव ॥१६.५॥',
  english:
      'The divine qualities lead to liberation, while the asuric qualities are considered to lead to bondage. Do not grieve, O Pāṇḍava, for you are born with divine qualities.',
  gujarati:
      'દૈવી સંપત્તિ મોક્ષ તરફ લઈ જાય છે અને આસુરી સંપત્તિ બંધનમાં નાખે છે. હે અર્જુન! તું દૈવી સંપત્તિ લઈને જન્મ્યો છે, તેથી ચિંતા ન કર.',
  meaningEnglish:
      'Divine qualities lead toward freedom, whereas asuric qualities create bondage. Arjuna is reassured that he possesses divine qualities.',
  meaningGujarati:
      'દૈવી ગુણો મુક્તિ તરફ અને આસુરી ગુણો બંધન તરફ લઈ જાય છે; અર્જુનને ભગવાન આશ્વાસન આપે છે કે તે દૈવી ગુણોથી સંપન્ન છે.',
),

SacredVerseModel(
  verseNumber: 6,
  sanskrit:
      'द्वौ भूतसर्गौ लोकेऽस्मिन् दैव आसुर एव च ।\n'
      'दैवो विस्तरशः प्रोक्त आसुरं पार्थ मे शृणु ॥१६.६॥',
  english:
      'There are two kinds of beings in this world: divine and asuric. The divine nature has been described at length; now hear from Me about the asuric nature.',
  gujarati:
      'આ જગતમાં બે પ્રકારના મનુષ્યો છે — દૈવી અને આસુરી. દૈવી ગુણોનું વર્ણન થઈ ગયું, હવે આસુરી ગુણો સાંભળ.',
  meaningEnglish:
      'Human nature is described as having two broad tendencies: divine and asuric.',
  meaningGujarati:
      'મનુષ્યમાં દૈવી અને આસુરી એમ બે પ્રકારની સ્વભાવવૃત્તિઓ જોવા મળે છે.',
),

SacredVerseModel(
  verseNumber: 7,
  sanskrit:
      'प्रवृत्तिं च निवृत्तिं च जना न विदुरासुराः ।\n'
      'न शौचं नापि चाचारो न सत्यं तेषु विद्यते ॥१६.७॥',
  english:
      'The asuric people do not know what should be done and what should not be done. They have neither purity, proper conduct nor truthfulness.',
  gujarati:
      'આસુરી સ્વભાવવાળા લોકો શું કરવું અને શું ન કરવું તે જાણતા નથી. તેમનામાં પવિત્રતા, સારો આચાર અને સત્ય હોતું નથી.',
  meaningEnglish:
      'Asuric people lack discrimination about right conduct and are deficient in purity, morality and truth.',
  meaningGujarati:
      'આસુરી સ્વભાવમાં યોગ્ય-અયોગ્યનો વિવેક, પવિત્રતા, સદાચાર અને સત્યનો અભાવ હોય છે.',
),

SacredVerseModel(
  verseNumber: 8,
  sanskrit:
      'असत्यमप्रतिष्ठं ते जगदाहुरनीश्वरम् ।\n'
      'अपरस्परसम्भूतं किमन्यत्कामहैतुकम् ॥१६.८॥',
  english:
      'They say that the world is unreal, without foundation and without God, and that it has arisen merely from mutual causes and desire.',
  gujarati:
      'આસુરી લોકો કહે છે કે જગત અસત્ય છે, તેનો કોઈ આધાર કે ઈશ્વર નથી અને બધું માત્ર કામનાઓથી ઉત્પન્ન થયું છે.',
  meaningEnglish:
      'The asuric view rejects moral and divine order and sees the world as purposeless and driven by desire.',
  meaningGujarati:
      'આસુરી દૃષ્ટિ જગતને ઈશ્વરવિહિન અને આધારવિહિન માનીને તેને માત્ર કામનાઓથી ચાલતું માને છે.',
),

SacredVerseModel(
  verseNumber: 9,
  sanskrit:
      'एतां दृष्टिमवष्टभ्य नष्टात्मानोऽल्पबुद्धयः ।\n'
      'प्रभवन्त्युग्रकर्माणः क्षयाय जगतोऽहिताः ॥१६.९॥',
  english:
      'Holding such a view, these misguided and narrow-minded people engage in fierce actions and become enemies of the world, working toward its destruction.',
  gujarati:
      'આવા વિચારને પકડીને અલ્પબુદ્ધિ લોકો ઉગ્ર કર્મો કરે છે અને જગતના વિનાશનું કારણ બને છે.',
  meaningEnglish:
      'Wrong understanding can lead people to destructive actions that harm themselves and the world.',
  meaningGujarati:
      'ખોટી દૃષ્ટિ અને અલ્પબુદ્ધિ મનુષ્યને વિનાશક કર્મો તરફ દોરી જાય છે.',
),

SacredVerseModel(
  verseNumber: 10,
  sanskrit:
      'काममाश्रित्य दुष्पूरं दम्भमानमदान्विताः ।\n'
      'मोहाद्गृहीत्वासद्ग्राहान्प्रवर्तन्तेऽशुचिव्रताः ॥१६.१०॥',
  english:
      'Taking refuge in insatiable desire and filled with hypocrisy, pride and arrogance, they act under delusion, holding false beliefs and following impure practices.',
  gujarati:
      'કદી ન સંતોષાય તેવી કામનાઓને આશ્રય લઈને દંભ, અભિમાન અને મોહથી ભરાયેલા લોકો ખોટા વિચારો પકડીને અશુદ્ધ કર્મો કરે છે.',
  meaningEnglish:
      'Uncontrolled desire, pride and delusion lead to false beliefs and impure actions.',
  meaningGujarati:
      'અતૃપ્ત કામનાઓ, દંભ, અભિમાન અને મોહ મનુષ્યને ખોટી માન્યતાઓ અને અશુદ્ધ કર્મો તરફ દોરી જાય છે.',
),

SacredVerseModel(
  verseNumber: 11,
  sanskrit:
      'चिन्तामपरिमेयां च प्रलयान्तामुपाश्रिताः ।\n'
      'कामोपभोगपरमा एतावदिति निश्चिताः ॥१६.११॥',
  english:
      'They are obsessed with immeasurable anxieties lasting until death, convinced that the enjoyment of desires is the highest goal of life.',
  gujarati:
      'તેમની ચિંતા મૃત્યુ સુધી ચાલે છે. તેઓ માને છે કે જીવનનો એકમાત્ર હેતુ ઇન્દ્રિયસુખ મેળવવાનો છે.',
  meaningEnglish:
      'Those driven by asuric tendencies remain consumed by anxiety and regard sense enjoyment as the ultimate purpose.',
  meaningGujarati:
      'આસુરી વૃત્તિ ધરાવનાર સતત ચિંતામાં રહે છે અને ઇન્દ્રિયભોગને જીવનનું પરમ લક્ષ્ય માને છે.',
),

SacredVerseModel(
  verseNumber: 12,
  sanskrit:
      'आशापाशशतैर्बद्धाः कामक्रोधपरायणाः ।\n'
      'ईहन्ते कामभोगार्थमन्यायेनार्थसञ्चयान् ॥१६.१२॥',
  english:
      'Bound by hundreds of cords of hope, devoted to desire and anger, they strive to accumulate wealth by unjust means for the enjoyment of desires.',
  gujarati:
      'સેંકડો આશાઓના બંધનમાં બંધાયેલા અને કામ-ક્રોધમાં ફસાયેલા લોકો ઇન્દ્રિયસુખ માટે અન્યાયથી ધન ભેગું કરે છે.',
  meaningEnglish:
      'Desire, anger and endless expectations bind them and drive them toward unjust accumulation of wealth.',
  meaningGujarati:
      'અસંખ્ય આશાઓ, કામ અને ક્રોધના બંધનમાં ફસાઈને તેઓ ઇન્દ્રિયસુખ માટે અન્યાયથી ધન એકત્ર કરે છે.',
),

SacredVerseModel(
  verseNumber: 13,
  sanskrit:
      'इदमद्य मया लब्धमिमं प्राप्स्ये मनोरथम् ।\n'
      'इदमस्तीदमपि मे भविष्यति पुनर्धनम् ॥१६.१३॥',
  english:
      'Today I have gained this; I shall obtain this desire as well. This much wealth is mine, and more will be mine in the future.',
  gujarati:
      'આજે મેં આ મેળવી લીધું છે, હવે મારી બીજી ઇચ્છા પણ પૂરી કરીશ. મારી પાસે આટલું ધન છે અને ભવિષ્યમાં વધુ ધન થશે — એવો વિચાર કરે છે.',
  meaningEnglish:
      'The asuric mind constantly thinks about present gains, future desires and increasing wealth.',
  meaningGujarati:
      'આસુરી મન સતત પ્રાપ્ત થયેલા ધન અને ભવિષ્યમાં મળનારા વધુ ધનની ઇચ્છામાં વ્યસ્ત રહે છે.',
),

SacredVerseModel(
  verseNumber: 14,
  sanskrit:
      'असौ मया हतः शत्रुर्हनिष्ये चापरानपि ।\n'
      'ईश्वरोऽहमहं भोगी सिद्धोऽहं बलवान्सुखी ॥१६.१४॥',
  english:
      'That enemy has been slain by me, and I shall slay others as well. I am the lord, I am the enjoyer, I am successful, powerful and happy.',
  gujarati:
      'મેં આ શત્રુને મારી નાખ્યો છે અને બીજાઓને પણ મારીશ. હું જ ઈશ્વર છું, હું ભોગી છું, હું સિદ્ધ, શક્તિશાળી અને સુખી છું — એવો અહંકાર કરે છે.',
  meaningEnglish:
      'Pride and ego make the person imagine himself to be supreme, powerful, successful and independent.',
  meaningGujarati:
      'અહંકારથી મનુષ્ય પોતાને સર્વોચ્ચ, શક્તિશાળી, સિદ્ધ અને સુખી માનવા લાગે છે.',
),

SacredVerseModel(
  verseNumber: 15,
  sanskrit:
      'आढ्योऽभिजनवानस्मि कोऽन्योऽस्ति सदृशो मया ।\n'
      'यक्ष्ये दास्यामि मोदिष्य इत्यज्ञानविमोहिताः ॥१६.१५॥',
  english:
      'I am wealthy and born into a distinguished family; who is equal to me? I shall perform sacrifices, give charity and rejoice. Thus they are deluded by ignorance.',
  gujarati:
      'હું ધનવાન અને મોટા કુળનો છું; મારા જેવો બીજો કોણ છે? હું યજ્ઞ કરીશ, દાન આપીશ અને આનંદ કરીશ — આ રીતે અજ્ઞાનથી મોહિત રહે છે.',
  meaningEnglish:
      'Wealth, status and pride can create a false sense of superiority and self-importance.',
  meaningGujarati:
      'ધન, કુળ અને પ્રતિષ્ઠાનો અહંકાર મનુષ્યમાં પોતાને સર્વથી શ્રેષ્ઠ માનવાનો મોહ ઉત્પન્ન કરે છે.',
),

SacredVerseModel(
  verseNumber: 16,
  sanskrit:
      'अनेकचित्तविभ्रान्ता मोहजालसमावृताः ।\n'
      'प्रसक्ताः कामभोगेषु पतन्ति नरकेऽशुचौ ॥१६.१६॥',
  english:
      'Confused by many anxieties and entangled in the net of delusion, attached to the enjoyment of desires, they fall into an impure hell.',
  gujarati:
      'અનેક ચિંતાઓથી વ્યાકુળ અને મોહના જાળમાં ફસાયેલા લોકો ઇન્દ્રિયભોગમાં આસક્ત થઈને અશુદ્ધ નરકમાં પડે છે.',
  meaningEnglish:
      'Delusion, anxiety and attachment to sense pleasure lead to spiritual downfall.',
  meaningGujarati:
      'મોહ, ચિંતા અને ઇન્દ્રિયભોગની આસક્તિ મનુષ્યને અધોગતિ તરફ લઈ જાય છે.',
),

SacredVerseModel(
  verseNumber: 17,
  sanskrit:
      'आत्मसम्भाविताः स्तब्धा धनमानमदान्विताः ।\n'
      'यजन्ते नामयज्ञैस्ते दम्भेनाविधिपूर्वकम् ॥१६.१७॥',
  english:
      'Self-conceited, stubborn and intoxicated by wealth and pride, they perform sacrifices merely for show and without proper discipline.',
  gujarati:
      'પોતાને જ મહાન માનનારા, ધનના અભિમાનથી મસ્ત લોકો દંભપૂર્વક શાસ્ત્રવિરુદ્ધ યજ્ઞ કરે છે.',
  meaningEnglish:
      'Such people may perform religious acts, but pride and showmanship make those acts improper.',
  meaningGujarati:
      'દંભ અને ધનના અભિમાનથી કરવામાં આવતી ધાર્મિક ક્રિયાઓ સાચી ભાવનાથી રહિત બની જાય છે.',
),

SacredVerseModel(
  verseNumber: 18,
  sanskrit:
      'अहङ्कारं बलं दर्पं कामं क्रोधं च संश्रिताः ।\n'
      'मामात्मपरदेहेषु प्रद्विषन्तोऽभ्यसूयकाः ॥१६.१८॥',
  english:
      'Taking refuge in ego, power, arrogance, desire and anger, they hate Me dwelling in their own bodies and in the bodies of others.',
  gujarati:
      'અહંકાર, શક્તિ, ઘમંડ, કામ અને ક્રોધનો આશ્રય લઈને તેઓ પોતાના અને બીજાના શરીરમાં રહેલા ભગવાનનો દ્વેષ કરે છે.',
  meaningEnglish:
      'Ego, arrogance, desire and anger cause them to reject and oppose the Divine presence within themselves and others.',
  meaningGujarati:
      'અહંકાર, ઘમંડ, કામ અને ક્રોધના કારણે તેઓ પોતાના તથા અન્યના અંતરમાં રહેલા પરમાત્માનો દ્વેષ કરે છે.',
),

SacredVerseModel(
  verseNumber: 19,
  sanskrit:
      'तानहं द्विषतः क्रूरान्संसारेषु नराधमान् ।\n'
      'क्षिपाम्यजस्रमशुभानासुरीष्वेव योनिषु ॥१६.१९॥',
  english:
      'Those cruel, hateful and lowest among people I repeatedly cast into asuric forms of existence in the cycle of worldly life.',
  gujarati:
      'આવા ક્રૂર અને દ્વેષી અધમ લોકોને હું વારંવાર આસુરી યોનિઓમાં જન્મ આપું છું.',
  meaningEnglish:
      'Those who persist in cruelty and hatred remain bound to lower asuric states of existence.',
  meaningGujarati:
      'ક્રૂરતા અને દ્વેષમાં સ્થિર રહેનાર જીવ આસુરી ગતિમાં વારંવાર બંધાયેલો રહે છે.',
),

SacredVerseModel(
  verseNumber: 20,
  sanskrit:
      'आसुरीं योनिमापन्ना मूढा जन्मनि जन्मनि ।\n'
      'मामप्राप्यैव कौन्तेय ततो यान्त्यधमां गतिम् ॥१६.२०॥',
  english:
      'Entering asuric forms of existence birth after birth, the deluded never attaining Me, O Kaunteya, thereafter go to the lowest state.',
  gujarati:
      'આ મૂર્ખ લોકો જન્મોજન્મ આસુરી યોનિમાં જન્મે છે અને મને પ્રાપ્ત કર્યા વિના અધમ ગતિને પામે છે.',
  meaningEnglish:
      'Repeatedly following asuric tendencies prevents spiritual realization and leads to lower states.',
  meaningGujarati:
      'આસુરી સ્વભાવને વારંવાર અનુસરવાથી પરમાત્માની પ્રાપ્તિ થતી નથી અને અધમ ગતિ પ્રાપ્ત થાય છે.',
),

SacredVerseModel(
  verseNumber: 21,
  sanskrit:
      'त्रिविधं नरकस्येदं द्वारं नाशनमात्मनः ।\n'
      'कामः क्रोधस्तथा लोभस्तस्मादेतत्त्रयं त्यजेत् ॥१६.२१॥',
  english:
      'Desire, anger and greed are the three gates to hell and the destruction of the self. Therefore one should abandon these three.',
  gujarati:
      'કામ, ક્રોધ અને લોભ — આ ત્રણ નરકનાં દ્વાર છે. તેથી મનુષ્યે આ ત્રણેયનો ત્યાગ કરવો જોઈએ.',
  meaningEnglish:
      'Desire, anger and greed are three major causes of spiritual downfall and should be consciously abandoned.',
  meaningGujarati:
      'કામ, ક્રોધ અને લોભ આત્મિક અધોગતિના ત્રણ મુખ્ય દ્વાર છે, તેથી તેમનો ત્યાગ કરવો જોઈએ.',
),

SacredVerseModel(
  verseNumber: 22,
  sanskrit:
      'एतैर्विमुक्तः कौन्तेय तमोद्वारैस्त्रिभिर्नरः ।\n'
      'आचरत्यात्मनः श्रेयस्ततो याति परां गतिम् ॥१६.२२॥',
  english:
      'Freed from these three gates of darkness, a person follows what is beneficial for the self and thereby attains the supreme goal.',
  gujarati:
      'આ ત્રણ નરકનાં દ્વારથી મુક્ત થયેલો મનુષ્ય પોતાના કલ્યાણનો માર્ગ અપનાવે છે અને પરમગતિ પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'Freedom from desire, anger and greed allows a person to pursue true welfare and attain the highest state.',
  meaningGujarati:
      'કામ, ક્રોધ અને લોભથી મુક્ત થઈને મનુષ્ય પોતાના શ્રેયનો માર્ગ અપનાવે છે અને પરમગતિ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 23,
  sanskrit:
      'यः शास्त्रविधिमुत्सृज्य वर्तते कामकारतः ।\n'
      'न स सिद्धिमवाप्नोति न सुखं न परां गतिम् ॥१६.२३॥',
  english:
      'One who abandons the injunctions of scripture and acts according to personal desire attains neither perfection, happiness nor the supreme goal.',
  gujarati:
      'જે મનુષ્ય શાસ્ત્રની આજ્ઞાનો ત્યાગ કરીને પોતાની ઇચ્છા પ્રમાણે વર્તે છે તેને સિદ્ધિ, સુખ કે પરમગતિ મળતી નથી.',
  meaningEnglish:
      'Ignoring the guidance of scripture and acting solely according to desire does not lead to true perfection, happiness or liberation.',
  meaningGujarati:
      'શાસ્ત્રના માર્ગદર્શનને છોડીને માત્ર પોતાની ઇચ્છા પ્રમાણે વર્તવાથી સિદ્ધિ, સુખ અને પરમગતિ પ્રાપ્ત થતી નથી.',
),

SacredVerseModel(
  verseNumber: 24,
  sanskrit:
      'तस्माच्छास्त्रं प्रमाणं ते कार्याकार्यव्यवस्थितौ ।\n'
      'ज्ञात्वा शास्त्रविधानोक्तं कर्म कर्तुमिहार्हसि ॥१६.२४॥',
  english:
      'Therefore let scripture be your authority in determining what should and should not be done. Knowing what is prescribed by scripture, you should perform your duties here.',
  gujarati:
      'તેથી શું કરવું અને શું ન કરવું તે નક્કી કરવા માટે શાસ્ત્રને પ્રમાણ માનવું જોઈએ અને શાસ્ત્ર પ્રમાણે કર્મ કરવું જોઈએ.',
  meaningEnglish:
      'Scriptural guidance should be used to distinguish right from wrong and to guide one’s actions.',
  meaningGujarati:
      'કાર્ય અને અકર્યનો નિર્ણય કરવા માટે શાસ્ત્રને પ્રમાણ માનીને તેના અનુસાર કર્મ કરવું જોઈએ.',
),

  ];
  }
 // અધ્યાય 17 — શ્રદ્ધાત્રય વિભાગ યોગ
  static List<SacredVerseModel> _gitaChapter17Verses() {
  return [
    SacredVerseModel(
  verseNumber: 1,
  sanskrit:
      'अर्जुन उवाच ।\n'
      'ये शास्त्रविधिमुत्सृज्य यजन्ते श्रद्धयान्विताः ।\n'
      'तेषां निष्ठा तु का कृष्ण सत्त्वमाहो रजस्तमः ॥१७.१॥',
  english:
      'Arjuna asked: O Kṛṣṇa, what is the nature of those who worship with faith but disregard the injunctions of scripture? Is their faith sattvic, rajasic or tamasic?',
  gujarati:
      'અર્જુન પૂછે છે — હે કૃષ્ણ! જે લોકો શાસ્ત્રની વિધિ છોડીને શ્રદ્ધાથી પૂજા કરે છે, તેમની શ્રદ્ધા સાત્ત્વિક, રાજસિક કે તામસિક કઈ છે?',
  meaningEnglish:
      'Arjuna asks about the nature of faith in people who worship according to their own conviction without following scripture.',
  meaningGujarati:
      'અર્જુન જાણવા માંગે છે કે શાસ્ત્રવિધિ વિના શ્રદ્ધાથી પૂજા કરનારની શ્રદ્ધા કયા ગુણની હોય છે.',
),

SacredVerseModel(
  verseNumber: 2,
  sanskrit:
      'श्रीभगवानुवाच ।\n'
      'त्रिविधा भवति श्रद्धा देहिनां सा स्वभावजा ।\n'
      'सात्त्विकी राजसी चैव तामसी चेति तां शृणु ॥१७.२॥',
  english:
      'The Lord said: The faith of embodied beings is of three kinds, born of their nature: sattvic, rajasic and tamasic. Hear about them.',
  gujarati:
      'ભગવાન કહે છે — મનુષ્યોની શ્રદ્ધા તેમના સ્વભાવ પ્રમાણે ત્રણ પ્રકારની હોય છે: સાત્ત્વિક, રાજસિક અને તામસિક.',
  meaningEnglish:
      'Faith naturally takes three forms according to the qualities of a person: sattva, rajas and tamas.',
  meaningGujarati:
      'મનુષ્યના સ્વભાવમાં રહેલા ત્રણ ગુણો પ્રમાણે તેની શ્રદ્ધા પણ સાત્ત્વિક, રાજસિક અથવા તામસિક બને છે.',
),

SacredVerseModel(
  verseNumber: 3,
  sanskrit:
      'सत्त्वानुरूपा सर्वस्य श्रद्धा भवति भारत ।\n'
      'श्रद्धामयोऽयं पुरुषो यो यच्छ्रद्धः स एव सः ॥१७.३॥',
  english:
      'The faith of every person is according to their inner nature. A person is made of faith; whatever their faith is, so are they.',
  gujarati:
      'દરેક મનુષ્યની શ્રદ્ધા તેના અંતઃકરણ પ્રમાણે હોય છે. મનુષ્ય જે પ્રકારની શ્રદ્ધા ધરાવે છે તેવો જ બને છે.',
  meaningEnglish:
      'A person’s character and way of life reflect the kind of faith held within.',
  meaningGujarati:
      'મનુષ્યની શ્રદ્ધા તેના સ્વભાવને ઘડે છે અને જે પ્રકારની શ્રદ્ધા હોય છે તે પ્રમાણે તેનું વ્યક્તિત્વ બને છે.',
),

SacredVerseModel(
  verseNumber: 4,
  sanskrit:
      'यजन्ते सात्त्विका देवान्यक्षरक्षांसि राजसाः ।\n'
      'प्रेतान्भूतगणांश्चान्ये यजन्ते तामसा जनाः ॥१७.४॥',
  english:
      'The sattvic worship the gods; the rajasic worship yakṣas and rākṣasas; others, who are tamasic, worship spirits and ghosts.',
  gujarati:
      'સાત્ત્વિક લોકો દેવોની પૂજા કરે છે, રાજસિક લોકો યક્ષ-રાક્ષસોની અને તામસિક લોકો ભૂત-પ્રેતની પૂજા કરે છે.',
  meaningEnglish:
      'The object of worship reflects the dominant quality of a person’s faith.',
  meaningGujarati:
      'મનુષ્ય જેની ઉપાસના કરે છે તેમાં પણ તેની સાત્ત્વિક, રાજસિક અથવા તામસિક વૃત્તિનું પ્રતિબિંબ જોવા મળે છે.',
),

SacredVerseModel(
  verseNumber: 5,
  sanskrit:
      'अशास्त्रविहितं घोरं तप्यन्ते ये तपो जनाः ।\n'
      'दम्भाहङ्कारसंयुक्ताः कामरागबलान्विताः ॥१७.५॥',
  english:
      'Those who perform severe austerities not prescribed by scripture, driven by hypocrisy, ego, desire and attachment, are not following the proper path.',
  gujarati:
      'જે લોકો શાસ્ત્રવિરુદ્ધ ઘોર તપ કરે છે અને દંભ, અહંકાર, કામના તથા આસક્તિથી ભરેલા છે, તેઓ યોગ્ય તપ કરતા નથી.',
  meaningEnglish:
      'Austerity performed against scriptural guidance and motivated by ego, desire and attachment is misguided.',
  meaningGujarati:
      'દંભ, અહંકાર, કામના અને આસક્તિથી પ્રેરિત શાસ્ત્રવિરુદ્ધ ઘોર તપ યોગ્ય સાધના નથી.',
),

SacredVerseModel(
  verseNumber: 6,
  sanskrit:
      'कर्शयन्तः शरीरस्थं भूतग्राममचेतसः ।\n'
      'मां चैवान्तःशरीरस्थं तान्विद्ध्यासुरनिश्चयान् ॥१७.६॥',
  english:
      'Those foolish people who torture the elements of the body and also Me dwelling within the body should be known to have asuric resolve.',
  gujarati:
      'જે લોકો શરીરને અતિશય કષ્ટ આપે છે અને શરીરમાં રહેલા મને પણ પીડા પહોંચાડે છે, તેમને આસુરી સ્વભાવવાળા જાણ.',
  meaningEnglish:
      'Extreme self-torture that harms the body and disregards the Divine within is considered asuric.',
  meaningGujarati:
      'શરીરને અયોગ્ય રીતે પીડા આપવી અને અંતરમાં રહેલા પરમાત્માની અવગણના કરવી આસુરી વૃત્તિ છે.',
),

SacredVerseModel(
  verseNumber: 7,
  sanskrit:
      'आहारस्त्वपि सर्वस्य त्रिविधो भवति प्रियः ।\n'
      'यज्ञस्तपस्तथा दानं तेषां भेदमिमं शृणु ॥१७.७॥',
  english:
      'The food dear to each person is of three kinds, as are sacrifice, austerity and charity. Hear their distinctions.',
  gujarati:
      'દરેકને ગમતો આહાર ત્રણ પ્રકારનો હોય છે. તેવી જ રીતે યજ્ઞ, તપ અને દાન પણ ત્રણ પ્રકારનાં છે. હવે તેમનો ભેદ સાંભળ.',
  meaningEnglish:
      'Food, sacrifice, austerity and charity are each classified according to the three Gunas.',
  meaningGujarati:
      'આહાર, યજ્ઞ, તપ અને દાન — આ ચારેયની પ્રકૃતિ સાત્ત્વિક, રાજસિક અને તામસિક એમ ત્રણ પ્રકારની હોય છે.',
),

SacredVerseModel(
  verseNumber: 8,
  sanskrit:
      'आयुःसत्त्वबलारोग्यसुखप्रीतिविवर्धनाः ।\n'
      'रस्याः स्निग्धाः स्थिरा हृद्या आहाराः सात्त्विकप्रियाः ॥१७.८॥',
  english:
      'Foods that increase longevity, vitality, strength, health, happiness and satisfaction, and are juicy, nourishing, stable and pleasing, are dear to the sattvic.',
  gujarati:
      'આયુષ્ય, સત્વ, બળ, આરોગ્ય, સુખ અને પ્રસન્નતા વધારનારા રસવાળા, સ્નિગ્ધ, પૌષ્ટિક અને હૃદયને ગમે તેવા આહાર સાત્ત્વિક લોકોને પ્રિય હોય છે.',
  meaningEnglish:
      'Sattvic food is nourishing, wholesome and supportive of health, strength, longevity and inner happiness.',
  meaningGujarati:
      'સાત્ત્વિક આહાર આયુષ્ય, આરોગ્ય, બળ, પ્રસન્નતા અને સુખ વધારનાર પૌષ્ટિક તથા હિતકારી આહાર છે.',
),

SacredVerseModel(
  verseNumber: 9,
  sanskrit:
      'कट्वम्ललवणात्युष्णतीक्ष्णरूक्षविदाहिनः ।\n'
      'आहारा राजसस्येष्टा दुःखशोकामयप्रदाः ॥१७.९॥',
  english:
      'Foods that are bitter, sour, salty, excessively hot, pungent, dry and burning are dear to the rajasic and produce pain, sorrow and disease.',
  gujarati:
      'કડવા, ખાટા, ખારા, ખૂબ ગરમ, તીખા, સૂકા અને દાહ કરનારા ખોરાક રાજસિક લોકોને પ્રિય હોય છે અને તે દુઃખ, શોક તથા રોગ ઉત્પન્ન કરે છે.',
  meaningEnglish:
      'Rajasic food is excessively stimulating and is described as causing discomfort, sorrow and illness.',
  meaningGujarati:
      'રાજસિક આહાર અતિ તીખો, ખારો, ખાટો, ગરમ અથવા દાહક હોય છે અને દુઃખ તથા રોગનું કારણ બને છે.',
),

SacredVerseModel(
  verseNumber: 10,
  sanskrit:
      'यातयामं गतरसं पूति पर्युषितं च यत् ।\n'
      'उच्छिष्टमपि चामेध्यं भोजनं तामसप्रियम् ॥१७.१०॥',
  english:
      'Food that is stale, tasteless, putrid, decomposed, leftover and impure is dear to the tamasic.',
  gujarati:
      'વાસી, રસહીન, દુર્ગંધવાળું, લાંબા સમયથી રાખેલું, એંઠું અને અપવિત્ર ભોજન તામસિક લોકોને પ્રિય હોય છે.',
  meaningEnglish:
      'Tamasic food is stale, impure, spoiled or lacking freshness and nourishment.',
  meaningGujarati:
      'વાસી, અપવિત્ર, દુર્ગંધવાળું અને રસહીન ભોજન તામસિક આહાર ગણાય છે.',
),

SacredVerseModel(
  verseNumber: 11,
  sanskrit:
      'अफलाकाङ्क्षिभिर्यज्ञो विधिदृष्टो य इज्यते ।\n'
      'यष्टव्यमेवेति मनः समाधाय स सात्त्विकः ॥१७.११॥',
  english:
      'The sacrifice performed according to scripture, without desire for its fruit and with the mind fixed on the duty of performing it, is sattvic.',
  gujarati:
      'ફળની ઇચ્છા રાખ્યા વિના શાસ્ત્રવિધિ પ્રમાણે અને કર્તવ્ય માનીને કરવામાં આવેલ યજ્ઞ સાત્ત્વિક છે.',
  meaningEnglish:
      'A sacrifice performed properly as a duty, without seeking personal reward, is sattvic.',
  meaningGujarati:
      'ફળની આશા વિના માત્ર કર્તવ્યભાવથી અને શાસ્ત્રવિધિ પ્રમાણે કરવામાં આવેલ યજ્ઞ સાત્ત્વિક છે.',
),

SacredVerseModel(
  verseNumber: 12,
  sanskrit:
      'अभिसन्धाय तु फलं दम्भार्थमपि चैव यत् ।\n'
      'इज्यते भरतश्रेष्ठ तं यज्ञं विद्धि राजसम् ॥१७.१२॥',
  english:
      'The sacrifice performed with a desire for its fruit or for the sake of display is known as rajasic.',
  gujarati:
      'ફળ મેળવવાની ઇચ્છાથી અથવા દેખાડા માટે કરવામાં આવેલ યજ્ઞ રાજસિક છે.',
  meaningEnglish:
      'A sacrifice motivated by reward, recognition or show is rajasic.',
  meaningGujarati:
      'ફળ, લાભ અથવા દેખાડાની ઇચ્છાથી કરવામાં આવેલ યજ્ઞ રાજસિક કહેવાય છે.',
),

SacredVerseModel(
  verseNumber: 13,
  sanskrit:
      'विधिहीनमसृष्टान्नं मन्त्रहीनमदक्षिणम् ।\n'
      'श्रद्धाविरहितं यज्ञं तामसं परिचक्षते ॥१७.१३॥',
  english:
      'A sacrifice performed without proper rules, without offering food, without sacred mantras, without giving gifts and without faith is called tamasic.',
  gujarati:
      'શાસ્ત્રવિધિ વગર, અન્નદાન વગર, મંત્ર વગર, દક્ષિણા વગર અને શ્રદ્ધા વગર કરવામાં આવેલ યજ્ઞ તામસિક કહેવાય છે.',
  meaningEnglish:
      'A sacrifice lacking proper procedure, generosity, sacred recitation and faith is tamasic.',
  meaningGujarati:
      'વિધિ, મંત્ર, અન્નદાન, દક્ષિણા અને શ્રદ્ધા વગરનો યજ્ઞ તામસિક ગણાય છે.',
),

SacredVerseModel(
  verseNumber: 14,
  sanskrit:
      'देवद्विजगुरुप्राज्ञपूजनं शौचमार्जवम् ।\n'
      'ब्रह्मचर्यमहिंसा च शारीरं तप उच्यते ॥१७.१४॥',
  english:
      'Worship of the Divine, the learned, teachers and wise people, purity, straightforwardness, celibacy and nonviolence are called austerity of the body.',
  gujarati:
      'દેવ, બ્રાહ્મણ, ગુરુ અને જ્ઞાનીની પૂજા, પવિત્રતા, સરળતા, બ્રહ્મચર્ય અને અહિંસા — શરીરનું તપ કહેવાય છે.',
  meaningEnglish:
      'Physical austerity consists of reverence, purity, simplicity, self-restraint and nonviolence.',
  meaningGujarati:
      'શરીરનું તપ પૂજા, પવિત્રતા, સરળતા, બ્રહ્મચર્ય અને અહિંસાથી બને છે.',
),

SacredVerseModel(
  verseNumber: 15,
  sanskrit:
      'अनुद्वेगकरं वाक्यं सत्यं प्रियहितं च यत् ।\n'
      'स्वाध्यायाभ्यसनं चैव वाङ्मयं तप उच्यते ॥१७.१५॥',
  english:
      'Speech that does not cause distress, is truthful, pleasant and beneficial, together with regular study of scripture, is called austerity of speech.',
  gujarati:
      'કોઈને દુઃખ ન પહોંચાડે તેવું, સત્ય, પ્રિય અને હિતકારક વચન તથા સ્વાધ્યાય — વાણીનું તપ છે.',
  meaningEnglish:
      'Verbal austerity means speaking truthfully, kindly and beneficially without causing unnecessary distress, along with scriptural study.',
  meaningGujarati:
      'વાણીનું તપ સત્ય, પ્રિય, હિતકારી અને કોઈને દુઃખ ન પહોંચાડે તેવી વાણી તથા સ્વાધ્યાય છે.',
),

SacredVerseModel(
  verseNumber: 16,
  sanskrit:
      'मनःप्रसादः सौम्यत्वं मौनमात्मविनिग्रहः ।\n'
      'भावसंशुद्धिरित्येतत्तपो मानसमुच्यते ॥१७.१६॥',
  english:
      'Serenity of mind, gentleness, silence, self-control and purity of intention are called austerity of the mind.',
  gujarati:
      'મનની પ્રસન્નતા, શાંત સ્વભાવ, મૌન, મનનું સંયમ અને ભાવોની શુદ્ધિ — મનનું તપ કહેવાય છે.',
  meaningEnglish:
      'Mental austerity is inner serenity, gentleness, self-restraint, silence and purity of thought and intention.',
  meaningGujarati:
      'મનનું તપ પ્રસન્નતા, સૌમ્યતા, મૌન, આત્મસંયમ અને ભાવોની શુદ્ધિમાં રહેલું છે.',
),

SacredVerseModel(
  verseNumber: 17,
  sanskrit:
      'श्रद्धया परया तप्तं तपस्तत्त्रिविधं नरैः ।\n'
      'अफलाकाङ्क्षिभिर्युक्तैः सात्त्विकं परिचक्षते ॥१७.१७॥',
  english:
      'The threefold austerity performed with supreme faith by disciplined people without desire for its fruit is called sattvic.',
  gujarati:
      'પરમ શ્રદ્ધાથી અને ફળની ઇચ્છા વગર કરવામાં આવેલ ત્રણ પ્રકારનું તપ સાત્ત્વિક કહેવાય છે.',
  meaningEnglish:
      'Austerity performed with deep faith, discipline and without seeking reward is sattvic.',
  meaningGujarati:
      'શ્રદ્ધા અને સંયમ સાથે ફળની ઇચ્છા વિના કરવામાં આવેલ ત્રિવિધ તપ સાત્ત્વિક છે.',
),

SacredVerseModel(
  verseNumber: 18,
  sanskrit:
      'सत्कारमानपूजार्थं तपो दम्भेन चैव यत् ।\n'
      'क्रियते तदिह प्रोक्तं राजसं चलमध्रुवम् ॥१७.१८॥',
  english:
      'Austerity performed for gaining respect, honor and worship, and for display, is called rajasic; it is unstable and temporary.',
  gujarati:
      'માન, સન્માન અને પૂજા મેળવવા માટે દંભથી કરવામાં આવેલ તપ રાજસિક છે અને તેનું ફળ અસ્થિર હોય છે.',
  meaningEnglish:
      'Austerity undertaken for recognition, honor or display is rajasic and does not remain steady.',
  meaningGujarati:
      'માન, સન્માન, પૂજા અથવા દેખાડા માટે કરવામાં આવેલ તપ રાજસિક અને અસ્થિર હોય છે.',
),

SacredVerseModel(
  verseNumber: 19,
  sanskrit:
      'मूढग्राहेणात्मनो यत्पीडया क्रियते तपः ।\n'
      'परस्योत्सादनार्थं वा तत्तामसमुदाहृतम् ॥१७.१९॥',
  english:
      'Austerity performed through foolish obstinacy by tormenting oneself or with the purpose of harming another is called tamasic.',
  gujarati:
      'મૂર્ખતાથી પોતાના શરીરને કષ્ટ આપીને અથવા બીજાને નુકસાન પહોંચાડવા માટે કરવામાં આવેલ તપ તામસિક છે.',
  meaningEnglish:
      'Self-torment or austerity intended to harm another is considered tamasic.',
  meaningGujarati:
      'મૂર્ખતાથી પોતાને પીડા આપવી અથવા બીજાને નુકસાન પહોંચાડવા માટે કરેલું તપ તામસિક છે.',
),

SacredVerseModel(
  verseNumber: 20,
  sanskrit:
      'दातव्यमिति यद्दानं दीयतेऽनुपकारिणे ।\n'
      'देशे काले च पात्रे च तद्दानं सात्त्विकं स्मृतम् ॥१७.२०॥',
  english:
      'Charity given with the thought that it should be given, without expecting anything in return, at the proper place, time and to a worthy person, is considered sattvic.',
  gujarati:
      'કોઈ ઉપકારની અપેક્ષા વગર, યોગ્ય સ્થળે, યોગ્ય સમયે અને યોગ્ય વ્યક્તિને કરેલું દાન સાત્ત્વિક છે.',
  meaningEnglish:
      'Selfless charity given at the proper time and place to a worthy recipient is sattvic.',
  meaningGujarati:
      'યોગ્ય વ્યક્તિને યોગ્ય સમય અને સ્થળે કોઈ ઉપકારની અપેક્ષા વિના કરેલું દાન સાત્ત્વિક છે.',
),

SacredVerseModel(
  verseNumber: 21,
  sanskrit:
      'यत्तु प्रत्युपकारार्थं फलमुद्दिश्य वा पुनः ।\n'
      'दीयते च परिक्लिष्टं तद्दानं राजसं स्मृतम् ॥१७.२१॥',
  english:
      'Charity given with the expectation of something in return or with a desire for a result, and given unwillingly, is considered rajasic.',
  gujarati:
      'પાછો ઉપકાર મળે અથવા ફળ મળે તેવી ઇચ્છાથી અને મનમાં દુઃખ સાથે કરવામાં આવેલ દાન રાજસિક છે.',
  meaningEnglish:
      'Charity motivated by reward, return or reluctance is rajasic.',
  meaningGujarati:
      'ફળ, લાભ અથવા બદલામાં ઉપકારની ઇચ્છાથી કરવામાં આવેલ અને અનિચ્છાપૂર્વક કરેલું દાન રાજસિક છે.',
),

SacredVerseModel(
  verseNumber: 22,
  sanskrit:
      'अदेशकाले यद्दानमपात्रेभ्यश्च दीयते ।\n'
      'असत्कृतमवज्ञातं तत्तामसमुदाहृतम् ॥१७.२२॥',
  english:
      'Charity given at an improper place or time, to an unworthy person, without respect and with contempt, is called tamasic.',
  gujarati:
      'અયોગ્ય સ્થળે, અયોગ્ય સમયે, અયોગ્ય વ્યક્તિને, અપમાનપૂર્વક આપવામાં આવેલ દાન તામસિક છે.',
  meaningEnglish:
      'Charity given improperly, disrespectfully or to an unworthy recipient is tamasic.',
  meaningGujarati:
      'અયોગ્ય સમય, સ્થળ અથવા વ્યક્તિને અપમાનપૂર્વક કરવામાં આવેલ દાન તામસિક ગણાય છે.',
),

SacredVerseModel(
  verseNumber: 23,
  sanskrit:
      'ॐ तत्सदिति निर्देशो ब्रह्मणस्त्रिविधः स्मृतः ।\n'
      'ब्राह्मणास्तेन वेदाश्च यज्ञाश्च विहिताः पुरा ॥१७.२३॥',
  english:
      'Om Tat Sat is remembered as the threefold designation of Brahman. By these, the Brahmanas, the Vedas and sacrifices were established in ancient times.',
  gujarati:
      'ૐ, તત્ અને સત્ — બ્રહ્મના ત્રણ નામરૂપ નિર્દેશ માનવામાં આવ્યા છે. પ્રાચીન કાળથી બ્રાહ્મણો, વેદો અને યજ્ઞો આના દ્વારા પવિત્ર માનવામાં આવ્યા છે.',
  meaningEnglish:
      'Om, Tat and Sat are three sacred designations associated with Brahman and with sacred practices.',
  meaningGujarati:
      'ૐ, તત્ અને સત્ બ્રહ્મના ત્રણ પવિત્ર નિર્દેશ છે અને પ્રાચીન કાળથી વેદ, યજ્ઞ તથા ધાર્મિક કર્મો સાથે જોડાયેલા છે.',
),

SacredVerseModel(
  verseNumber: 24,
  sanskrit:
      'तस्मादोमित्युदाहृत्य यज्ञदानतपःक्रियाः ।\n'
      'प्रवर्तन्ते विधानोक्ताः सततं ब्रह्मवादिनाम् ॥१७.२४॥',
  english:
      'Therefore, uttering Om, the acts of sacrifice, charity and austerity prescribed by scripture are always begun by those who follow the path of Brahman.',
  gujarati:
      'તેથી બ્રહ્મને માનનારા લોકો શાસ્ત્રવિધિ પ્રમાણે યજ્ઞ, દાન અને તપની શરૂઆત “ૐ”થી કરે છે.',
  meaningEnglish:
      'Om is used as a sacred beginning for scripturally prescribed sacrifice, charity and austerity.',
  meaningGujarati:
      'શાસ્ત્રવિધિ અનુસાર યજ્ઞ, દાન અને તપ જેવા પવિત્ર કર્મોની શરૂઆત “ૐ”ના ઉચ્ચારથી કરવામાં આવે છે.',
),

SacredVerseModel(
  verseNumber: 25,
  sanskrit:
      'तदित्यनभिसन्धाय फलं यज्ञतपःक्रियाः ।\n'
      'दानक्रियाश्च विविधाः क्रियन्ते मोक्षकाङ्क्षिभिः ॥१७.२५॥',
  english:
      'Uttering Tat, those who seek liberation perform various acts of sacrifice, austerity and charity without seeking their fruits.',
  gujarati:
      'મોક્ષની ઇચ્છા રાખનારા લોકો ફળની ઇચ્છા વગર “તત્” ભાવથી યજ્ઞ, તપ અને વિવિધ દાન કરે છે.',
  meaningEnglish:
      'Those seeking liberation perform sacred actions without attachment to their results, dedicating them to the Supreme.',
  meaningGujarati:
      'મોક્ષકામી મનુષ્ય ફળની આસક્તિ છોડીને “તત્” ભાવથી યજ્ઞ, તપ અને દાન કરે છે.',
),

SacredVerseModel(
  verseNumber: 26,
  sanskrit:
      'सद्भावे साधुभावे च सदित्येतत्प्रयुज्यते ।\n'
      'प्रशस्ते कर्मणि तथा सच्छब्दः पार्थ युज्यते ॥१७.२६॥',
  english:
      'The word Sat is used in the sense of truth and goodness, and the word Sat is also used for an auspicious and worthy action, O Pārtha.',
  gujarati:
      '“સત્” શબ્દ સત્ય અને સારા ભાવ માટે વપરાય છે. શુભ અને ઉત્તમ કર્મો માટે પણ “સત્” શબ્દ વપરાય છે.',
  meaningEnglish:
      'Sat signifies truth, goodness and noble or auspicious action.',
  meaningGujarati:
      '“સત્” સત્ય, સદભાવ અને શુભ તથા ઉત્તમ કર્મનું સૂચક છે.',
),

SacredVerseModel(
  verseNumber: 27,
  sanskrit:
      'यज्ञे तपसि दाने च स्थितिः सदिति चोच्यते ।\n'
      'कर्म चैव तदर्थीयं सदित्येवाभिधीयते ॥१७.२७॥',
  english:
      'Steadfastness in sacrifice, austerity and charity is called Sat, and action performed for the sake of the Supreme is also called Sat.',
  gujarati:
      'યજ્ઞ, તપ અને દાનમાં સ્થિર રહેવું “સત્” કહેવાય છે. ભગવાન માટે કરવામાં આવેલ કર્મ પણ “સત્” કહેવાય છે.',
  meaningEnglish:
      'Steadfastness in sacred duties and actions dedicated to the Supreme are described as Sat.',
  meaningGujarati:
      'યજ્ઞ, તપ અને દાનમાં નિષ્ઠા તથા ભગવાન માટે કરવામાં આવેલ કર્મ “સત્” કહેવાય છે.',
),

SacredVerseModel(
  verseNumber: 28,
  sanskrit:
      'अश्रद्धया हुतं दत्तं तपस्तप्तं कृतं च यत् ।\n'
      'असदित्युच्यते पार्थ न च तत्प्रेत्य नो इह ॥१७.२८॥',
  english:
      'Whatever is offered, given, performed as austerity or done without faith is called Asat, O Pārtha. It has no value either in this world or after death.',
  gujarati:
      'હે અર્જુન! શ્રદ્ધા વગર કરવામાં આવેલ યજ્ઞ, દાન, તપ અથવા કોઈપણ કર્મ “અસત્” કહેવાય છે. તેનું આ લોકમાં કે પરલોકમાં કોઈ ફળ નથી.',
  meaningEnglish:
      'Actions performed without faith are considered Asat and do not bear meaningful spiritual fruit in this life or beyond.',
  meaningGujarati:
      'શ્રદ્ધા વગર કરવામાં આવેલ યજ્ઞ, દાન, તપ કે કર્મ અસત્ કહેવાય છે અને તેનું આધ્યાત્મિક ફળ મળતું નથી.',
),

  ];
  }

  static List<SacredVerseModel> _gitaChapter18Verses() {
  return [
    SacredVerseModel(
  verseNumber: 1,
  sanskrit:
      'अर्जुन उवाच ।\n'
      'संन्यासस्य महाबाहो तत्त्वमिच्छामि वेदितुम् ।\n'
      'त्यागस्य च हृषीकेश पृथक्केशिनिषूदन ॥१८.१॥',
  english:
      'Arjuna said: O mighty-armed Krishna, O Lord of the senses, I wish to understand clearly the true nature of Sannyasa (renunciation) and Tyaga (relinquishment).',
  gujarati:
      'અર્જુન કહે છે: હે મહાબાહુ શ્રીકૃષ્ણ! હે હૃષીકેશ! હે કેશિનિષૂદન! હું સંન્યાસ અને ત્યાગના તત્ત્વને અલગ-અલગ રીતે જાણવા ઇચ્છું છું.',
  meaningEnglish:
      'Arjuna wishes to understand the true nature of renunciation and relinquishment.',
  meaningGujarati:
      'અર્જુન સંન્યાસ અને ત્યાગના સાચા તત્ત્વને સમજવા ઇચ્છે છે.',
),

SacredVerseModel(
  verseNumber: 2,
  sanskrit:
      'श्रीभगवानुवाच ।\n'
      'काम्यानां कर्मणां न्यासं संन्यासं कवयो विदुः ।\n'
      'सर्वकर्मफलत्यागं प्राहुस्त्यागं विचक्षणाः ॥१८.२॥',
  english:
      'The Blessed Lord said: The wise understand Sannyasa as giving up actions performed with selfish desires, while the wise describe Tyaga as giving up the fruits of all actions.',
  gujarati:
      'ભગવાન શ્રીકૃષ્ણ કહે છે: જ્ઞાની પુરુષો કામનાથી કરવામાં આવતા કર્મોના ત્યાગને સંન્યાસ કહે છે, જ્યારે વિવેકી પુરુષો બધા કર્મોના ફળનો ત્યાગ કરવાને ત્યાગ કહે છે.',
  meaningEnglish:
      'Sannyasa means giving up desire-driven actions, while Tyaga means giving up the fruits of all actions.',
  meaningGujarati:
      'કામનાથી કરાયેલા કર્મોનો ત્યાગ સંન્યાસ છે અને બધા કર્મોના ફળનો ત્યાગ ત્યાગ કહેવાય છે.',
),

SacredVerseModel(
  verseNumber: 3,
  sanskrit:
      'त्याज्यं दोषवदित्येके कर्म प्राहुर्मनीषिणः ।\n'
      'यज्ञदानतपःकर्म न त्याज्यमिति चापरे ॥१८.३॥',
  english:
      'Some wise people say that all actions should be abandoned because they contain faults. Others say that acts of sacrifice, charity and austerity should never be abandoned.',
  gujarati:
      'કેટલાક જ્ઞાની લોકો કહે છે કે કર્મમાં દોષ હોવાથી તેનો ત્યાગ કરવો જોઈએ. જ્યારે બીજા લોકો કહે છે કે યજ્ઞ, દાન અને તપ જેવા કર્મોનો ક્યારેય ત્યાગ કરવો જોઈએ નહીં.',
  meaningEnglish:
      'Some consider all action faulty and to be abandoned, while others say sacrifice, charity and austerity must never be abandoned.',
  meaningGujarati:
      'કેટલાક કર્મનો ત્યાગ કહે છે, જ્યારે બીજા યજ્ઞ, દાન અને તપનો ત્યાગ ન કરવાની વાત કહે છે.',
),

SacredVerseModel(
  verseNumber: 4,
  sanskrit:
      'निश्चयं शृणु मे तत्र त्यागे भरतसत्तम ।\n'
      'त्यागो हि पुरुषव्याघ्र त्रिविधः संप्रकीर्तितः ॥१८.४॥',
  english:
      'O best of the Bharatas, hear My definite conclusion regarding renunciation. Renunciation is said to be of three kinds.',
  gujarati:
      'હે ભરતશ્રેષ્ઠ! ત્યાગ વિશે મારો નિશ્ચિત મત સાંભળ. હે પુરુષશ્રેષ્ઠ! ત્યાગ ત્રણ પ્રકારનો કહેવાયો છે.',
  meaningEnglish:
      'Renunciation is of three kinds according to the three modes of nature.',
  meaningGujarati:
      'ત્યાગ સત્વ, રજસ અને તમસ ગુણ પ્રમાણે ત્રણ પ્રકારનો કહેવાયો છે.',
),

SacredVerseModel(
  verseNumber: 5,
  sanskrit:
      'यज्ञदानतपःकर्म न त्याज्यं कार्यमेव तत् ।\n'
      'यज्ञो दानं तपश्चैव पावनानि मनीषिणाम् ॥१८.५॥',
  english:
      'Acts of sacrifice, charity and austerity should not be abandoned; they must be performed. These actions purify even the wise.',
  gujarati:
      'યજ્ઞ, દાન અને તપ જેવા કર્મોનો ત્યાગ કરવો જોઈએ નહીં; તે કરવાં જ જોઈએ. કારણ કે યજ્ઞ, દાન અને તપ જ્ઞાની પુરુષોને પવિત્ર કરનારાં છે.',
  meaningEnglish:
      'Sacrifice, charity and austerity should always be performed because they purify the wise.',
  meaningGujarati:
      'યજ્ઞ, દાન અને તપનો ત્યાગ ન કરવો જોઈએ, કારણ કે તે મનુષ્યને પવિત્ર કરે છે.',
),

SacredVerseModel(
  verseNumber: 6,
  sanskrit:
      'एतान्यपि तु कर्माणि सङ्गं त्यक्त्वा फलानि च ।\n'
      'कर्तव्यानीति मे पार्थ निश्चितं मतमुत्तमम् ॥१८.६॥',
  english:
      'O Arjuna, these actions should also be performed after giving up attachment and desire for their fruits. This is My firm and highest conclusion.',
  gujarati:
      'હે પાર્થ! આ કર્મો પણ આસક્તિ અને કર્મફળની ઈચ્છા છોડીને કરવાં જોઈએ. આ મારો નિશ્ચિત અને શ્રેષ્ઠ મત છે.',
  meaningEnglish:
      'Perform sacrifice, charity and austerity without attachment or desire for their fruits.',
  meaningGujarati:
      'યજ્ઞ, દાન અને તપ આસક્તિ અને ફળની ઇચ્છા વગર કરવાં જોઈએ.',
),

SacredVerseModel(
  verseNumber: 7,
  sanskrit:
      'नियतस्य तु संन्यासः कर्मणो नोपपद्यते ।\n'
      'मोहात्तस्य परित्यागस्तामसः परिकीर्तितः ॥१८.७॥',
  english:
      'Giving up one’s prescribed duty is not proper. Abandoning duty out of delusion is called Tamasic renunciation.',
  gujarati:
      'નિયત કર્મનો ત્યાગ કરવો યોગ્ય નથી. મોહને કારણે પોતાના કર્તવ્યકર્મનો ત્યાગ કરવામાં આવે તો તે તામસ ત્યાગ કહેવાય છે.',
  meaningEnglish:
      'Abandoning prescribed duty out of delusion is considered Tamasic renunciation.',
  meaningGujarati:
      'મોહને કારણે કર્તવ્યનો ત્યાગ કરવો તામસ ત્યાગ છે.',
),

SacredVerseModel(
  verseNumber: 8,
  sanskrit:
      'दुःखमित्येव यत्कर्म कायक्लेशभयात्त्यजेत् ।\n'
      'स कृत्वा राजसं त्यागं नैव त्यागफलं लभेत् ॥१८.८॥',
  english:
      'One who abandons duty because it is difficult or physically painful performs Rajasic renunciation and does not obtain the true fruit of renunciation.',
  gujarati:
      'કર્મ કરવાથી શરીરને દુઃખ થશે એમ માનીને જે વ્યક્તિ કર્મનો ત્યાગ કરે છે, તેનો ત્યાગ રાજસ કહેવાય છે. એવો ત્યાગ કરનારને સાચા ત્યાગનું ફળ મળતું નથી.',
  meaningEnglish:
      'Abandoning duty because it is difficult or painful is Rajasic renunciation.',
  meaningGujarati:
      'દુઃખ અથવા શારીરિક કષ્ટના ભયથી કર્મનો ત્યાગ કરવો રાજસ ત્યાગ છે.',
),

SacredVerseModel(
  verseNumber: 9,
  sanskrit:
      'कार्यमित्येव यत्कर्म नियतं क्रियतेऽर्जुन ।\n'
      'सङ्गं त्यक्त्वा फलं चैव स त्यागः सात्त्विको मतः ॥१८.९॥',
  english:
      'O Arjuna, performing one’s prescribed duty simply because it ought to be done, while giving up attachment and the desire for results, is considered Sattvic renunciation.',
  gujarati:
      'હે અર્જુન! જે વ્યક્તિ પોતાના કર્તવ્યને કરવું જ જોઈએ એમ માનીને, આસક્તિ અને કર્મફળની ઈચ્છા છોડીને કર્મ કરે છે, તેનો ત્યાગ સાત્ત્વિક કહેવાય છે.',
  meaningEnglish:
      'Performing duty without attachment or desire for results is Sattvic renunciation.',
  meaningGujarati:
      'કર્તવ્યને આસક્તિ અને ફળની ઇચ્છા વગર કરવું સાત્ત્વિક ત્યાગ છે.',
),

SacredVerseModel(
  verseNumber: 10,
  sanskrit:
      'न द्वेष्ट्यकुशलं कर्म कुशले नानुषज्जते ।\n'
      'त्यागी सत्त्वसमाविष्टो मेधावी छिन्नसंशयः ॥१८.१०॥',
  english:
      'The true renunciant neither hates unpleasant work nor becomes attached to pleasant work. Such a person is wise, balanced and free from doubt.',
  gujarati:
      'સાત્ત્વિક ત્યાગી અપ્રિય કર્મથી દ્વેષ કરતો નથી અને પ્રિય કર્મમાં આસક્ત થતો નથી. તે જ્ઞાની હોય છે અને તેના બધા સંશયો દૂર થઈ ગયા હોય છે.',
  meaningEnglish:
      'A wise renunciant remains balanced toward pleasant and unpleasant actions.',
  meaningGujarati:
      'સાચો ત્યાગી પ્રિય કે અપ્રિય કર્મમાં આસક્તિ કે દ્વેષ રાખતો નથી.',
),

SacredVerseModel(
  verseNumber: 11,
  sanskrit:
      'न हि देहभृता शक्यं त्यक्तुं कर्माण्यशेषतः ।\n'
      'यस्तु कर्मफलत्यागी स त्यागीत्यभिधीयते ॥१८.११॥',
  english:
      'A person who has a body cannot completely abandon all actions. But one who gives up the fruits of action is truly called a renunciant.',
  gujarati:
      'દેહધારી મનુષ્ય માટે સંપૂર્ણ રીતે બધા કર્મોનો ત્યાગ કરવો શક્ય નથી. પરંતુ જે કર્મના ફળનો ત્યાગ કરે છે, તેને સાચો ત્યાગી કહેવાય છે.',
  meaningEnglish:
      'A person cannot completely give up action, but giving up the fruits of action makes one a true renunciant.',
  meaningGujarati:
      'બધા કર્મોનો ત્યાગ શક્ય નથી; કર્મફળનો ત્યાગ કરનાર સાચો ત્યાગી છે.',
),

SacredVerseModel(
  verseNumber: 12,
  sanskrit:
      'अनिष्टमिष्टं मिश्रं च त्रिविधं कर्मणः फलम् ।\n'
      'भवत्यत्यागिनां प्रेत्य न तु संन्यासिनां क्वचित् ॥१८.१२॥',
  english:
      'Those who do not renounce the fruits of action receive three kinds of results—unpleasant, pleasant and mixed. Those who truly renounce do not receive such karmic results.',
  gujarati:
      'કર્મનો અનિષ્ટ, ઇષ્ટ અને મિશ્ર—આ ત્રણ પ્રકારનો ફળ ત્યાગ ન કરનારને મૃત્યુ પછી મળે છે. પરંતુ સાચા સંન્યાસીને આવું ફળ મળતું નથી.',
  meaningEnglish:
      'Those who do not renounce action fruits experience pleasant, unpleasant and mixed results.',
  meaningGujarati:
      'કર્મફળનો ત્યાગ ન કરનારને ઇષ્ટ, અનિષ્ટ અને મિશ્ર ત્રણ પ્રકારનાં ફળ મળે છે.',
),

SacredVerseModel(
  verseNumber: 13,
  sanskrit:
      'पञ्चैतानि महाबाहो कारणानि निबोध मे ।\n'
      'साङ्ख्ये कृतान्ते प्रोक्तानि सिद्धये सर्वकर्मणाम् ॥१८.१३॥',
  english:
      'O mighty-armed Arjuna, learn from Me the five causes of action, as described in the Sankhya teaching.',
  gujarati:
      'હે મહાબાહુ! બધા કર્મોની સિદ્ધિ માટે સાંખ્ય દર્શનમાં પાંચ કારણો કહેવામાં આવ્યાં છે. તે કારણોને મારી પાસેથી જાણી લો.',
  meaningEnglish:
      'Five causes are responsible for the accomplishment of actions.',
  meaningGujarati:
      'બધા કર્મોની સિદ્ધિ માટે પાંચ કારણો જણાવવામાં આવ્યા છે.',
),

SacredVerseModel(
  verseNumber: 14,
  sanskrit:
      'अधिष्ठानं तथा कर्ता करणं च पृथग्विधम् ।\n'
      'विविधाश्च पृथक्चेष्टा दैवं चैवात्र पञ्चमम् ॥१८.१४॥',
  english:
      'The five causes are: the body or basis of action, the doer, the various instruments, the different efforts involved, and divine providence.',
  gujarati:
      'કર્મના પાંચ કારણો છે: શરીર, કર્તા, વિવિધ ઇન્દ્રિયો તથા સાધનો, અનેક પ્રકારની ક્રિયાઓ અને પાંચમું કારણ દૈવ છે.',
  meaningEnglish:
      'The five causes are the body, doer, instruments, efforts and divine providence.',
  meaningGujarati:
      'કર્મનાં પાંચ કારણો શરીર, કર્તા, સાધનો, પ્રયત્નો અને દૈવ છે.',
),

SacredVerseModel(
  verseNumber: 15,
  sanskrit:
      'शरीरवाङ्मनोभिर्यत्कर्म प्रारभते नरः ।\n'
      'न्याय्यं वा विपरीतं वा पञ्चैते तस्य हेतवः ॥१८.१५॥',
  english:
      'Whatever action a person performs through body, speech or mind—whether right or wrong—has these five causes.',
  gujarati:
      'મનુષ્ય શરીર, વાણી અને મન દ્વારા જે પણ યોગ્ય કે અયોગ્ય કર્મ કરે છે, તેના પાંચેય કારણો જવાબદાર હોય છે.',
  meaningEnglish:
      'Every action performed through body, speech or mind has these five causes.',
  meaningGujarati:
      'શરીર, વાણી કે મનથી કરાયેલા યોગ્ય કે અયોગ્ય કર્મ પાછળ આ પાંચ કારણો હોય છે.',
),

SacredVerseModel(
  verseNumber: 16,
  sanskrit:
      'तत्रैवं सति कर्तारमात्मानं केवलं तु यः ।\n'
      'पश्यत्यकृतबुद्धित्वान्न स पश्यति दुर्मतिः ॥१८.१६॥',
  english:
      'One who, due to an unrefined intellect, considers the Self alone to be the sole doer does not truly understand.',
  gujarati:
      'આ પાંચ કારણો હોવા છતાં જે અજ્ઞાની વ્યક્તિ આત્માને જ એકમાત્ર કર્તા માને છે, તે સાચું જ્ઞાન ધરાવતી નથી.',
  meaningEnglish:
      'One who considers the Self alone to be the sole doer does not truly understand.',
  meaningGujarati:
      'જે આત્માને જ એકમાત્ર કર્તા માને છે તે સાચી સમજ ધરાવતો નથી.',
),

SacredVerseModel(
  verseNumber: 17,
  sanskrit:
      'यस्य नाहङ्कृतो भावो बुद्धिर्यस्य न लिप्यते ।\n'
      'हत्वापि स इमाँल्लोकान्न हन्ति न निबध्यते ॥१८.१७॥',
  english:
      'One who is free from ego and whose intellect is unattached does not become bound by action, even while performing an extremely difficult duty.',
  gujarati:
      'જેના મનમાં અહંકાર નથી અને જેની બુદ્ધિ કર્મમાં આસક્ત થતી નથી, તે યુદ્ધમાં લોકોને મારી નાખે તો પણ વાસ્તવમાં બંધાતો નથી.',
  meaningEnglish:
      'One who is free from ego and attachment is not bound by action.',
  meaningGujarati:
      'અહંકાર અને આસક્તિથી મુક્ત મનુષ્ય કર્મથી બંધાતો નથી.',
),

SacredVerseModel(
  verseNumber: 18,
  sanskrit:
      'ज्ञानं ज्ञेयं परिज्ञाता त्रिविधा कर्मचोदना ।\n'
      'करणं कर्म कर्तेति त्रिविधः कर्मसङ्ग्रहः ॥१८.१८॥',
  english:
      'Knowledge, the object of knowledge and the knower are the threefold impulse behind action. The instruments, the action and the doer constitute the threefold basis of action.',
  gujarati:
      'જ્ઞાન, જ્ઞેય અને જ્ઞાતા—આ ત્રણ કર્મ માટે પ્રેરણા આપે છે. કરણ, કર્મ અને કર્તા—આ ત્રણ કર્મના આધાર છે.',
  meaningEnglish:
      'Knowledge, the object of knowledge and the knower inspire action; instruments, action and doer form its basis.',
  meaningGujarati:
      'જ્ઞાન, જ્ઞેય અને જ્ઞાતા કર્મની પ્રેરણા છે અને કરણ, કર્મ તથા કર્તા કર્મના આધાર છે.',
),

SacredVerseModel(
  verseNumber: 19,
  sanskrit:
      'ज्ञानं कर्म च कर्ता च त्रिधैव गुणभेदतः ।\n'
      'प्रोच्यते गुणसङ्ख्याने यथावच्छृणु तान्यपि ॥१८.१९॥',
  english:
      'Knowledge, action and the doer are each classified into three types according to the three gunas—Sattva, Rajas and Tamas.',
  gujarati:
      'સાંખ્ય દર્શનમાં જ્ઞાન, કર્મ અને કર્તા ત્રણેયને સત્વ, રજસ અને તમસ ગુણોના આધારે ત્રણ પ્રકારના કહેવામાં આવ્યા છે. હવે તે સાંભળ.',
  meaningEnglish:
      'Knowledge, action and the doer are each divided into three types according to the three gunas.',
  meaningGujarati:
      'જ્ઞાન, કર્મ અને કર્તા સત્વ, રજસ અને તમસ પ્રમાણે ત્રણ પ્રકારના છે.',
),

SacredVerseModel(
  verseNumber: 20,
  sanskrit:
      'सर्वभूतेषु येनैकं भावमव्ययमीक्षते ।\n'
      'अविभक्तं विभक्तेषु तज्ज्ञानं विद्धि सात्त्विकम् ॥१८.२०॥',
  english:
      'That knowledge is Sattvic by which one sees the one imperishable Reality present equally in all beings.',
  gujarati:
      'જે જ્ઞાન દ્વારા મનુષ્ય બધા જુદા-જુદા જીવોમાં એક અવિનાશી પરમ તત્ત્વને જુએ છે, તે જ્ઞાન સાત્ત્વિક કહેવાય છે.',
  meaningEnglish:
      'Seeing one imperishable Reality equally present in all beings is Sattvic knowledge.',
  meaningGujarati:
      'બધા જીવોમાં એક અવિનાશી તત્ત્વને જોવું સાત્ત્વિક જ્ઞાન છે.',
),

SacredVerseModel(
  verseNumber: 21,
  sanskrit:
      'पृथक्त्वेन तु यज्ज्ञानं नानाभावान्पृथग्विधान् ।\n'
      'वेत्ति सर्वेषु भूतेषु तज्ज्ञानं विद्धि राजसम् ॥१८.२१॥',
  english:
      'That knowledge is Rajasic which sees beings as separate and distinct from one another.',
  gujarati:
      'જે જ્ઞાન બધા જીવોમાં અલગ-અલગ અને ભિન્ન ભાવોને જ જુએ છે, તે જ્ઞાન રાજસ કહેવાય છે.',
  meaningEnglish:
      'Seeing beings as separate and distinct is Rajasic knowledge.',
  meaningGujarati:
      'જીવોમાં માત્ર ભિન્નતા જોવી રાજસ જ્ઞાન છે.',
),

SacredVerseModel(
  verseNumber: 22,
  sanskrit:
      'यत्तु कृत्स्नवदेकस्मिन् कार्ये सक्तमहैतुकम् ।\n'
      'अतत्त्वार्थवदल्पं च तत्तामसमुदाहृतम् ॥१८.२२॥',
  english:
      'Knowledge that clings to one limited aspect as if it were the whole truth, without understanding reality properly, is called Tamasic.',
  gujarati:
      'જે જ્ઞાન એક જ નાની વસ્તુ કે કાર્યમાં સંપૂર્ણ સત્ય માનીને આસક્ત રહે છે અને વાસ્તવિક તત્ત્વને સમજતું નથી, તે તામસ જ્ઞાન કહેવાય છે.',
  meaningEnglish:
      'Limited and incomplete understanding that mistakes one aspect for the whole truth is Tamasic knowledge.',
  meaningGujarati:
      'અપૂર્ણ અને એક જ વસ્તુને સંપૂર્ણ સત્ય માનતું જ્ઞાન તામસ જ્ઞાન છે.',
),

SacredVerseModel(
  verseNumber: 23,
  sanskrit:
      'नियतं सङ्गरहितमरागद्वेषतः कृतम् ।\n'
      'अफलप्रेप्सुना कर्म यत्तत्सात्त्विकमुच्यते ॥१८.२३॥',
  english:
      'Action performed as a duty, without attachment, likes, dislikes or desire for results, is called Sattvic action.',
  gujarati:
      'જે નિયત કર્મ આસક્તિ, રાગ અને દ્વેષ વગર અને ફળની ઈચ્છા વિના કરવામાં આવે છે, તે સાત્ત્વિક કર્મ કહેવાય છે.',
  meaningEnglish:
      'Duty performed without attachment, likes, dislikes or desire for results is Sattvic action.',
  meaningGujarati:
      'આસક્તિ અને ફળની ઇચ્છા વગર કરાયેલ કર્તવ્ય સાત્ત્વિક કર્મ છે.',
),

SacredVerseModel(
  verseNumber: 24,
  sanskrit:
      'यत्तु कामेप्सुना कर्म साहङ्कारेण वा पुनः ।\n'
      'क्रियते बहुलायासं तद्राजसमुदाहृतम् ॥१८.२४॥',
  english:
      'Action performed with selfish desire, ego and excessive effort is called Rajasic action.',
  gujarati:
      'જે કર્મ ફળની ઈચ્છા રાખીને અથવા અહંકારથી અને ખૂબ પ્રયત્નપૂર્વક કરવામાં આવે છે, તે રાજસ કર્મ કહેવાય છે.',
  meaningEnglish:
      'Action driven by selfish desire, ego and excessive effort is Rajasic.',
  meaningGujarati:
      'ફળની ઇચ્છા, અહંકાર અને અતિશય પ્રયત્નથી કરાયેલ કર્મ રાજસ છે.',
),

SacredVerseModel(
  verseNumber: 25,
  sanskrit:
      'अनुबन्धं क्षयं हिंसामनपेक्ष्य च पौरुषम् ।\n'
      'मोहादारभ्यते कर्म यत्तत्तामसमुच्यते ॥१८.२५॥',
  english:
      'Action undertaken in delusion, without considering consequences, loss, harm or one’s own ability, is called Tamasic action.',
  gujarati:
      'પરિણામ, નુકસાન, હિંસા અને પોતાની શક્તિનો વિચાર કર્યા વગર મોહથી જે કર્મ કરવામાં આવે છે, તે તામસ કર્મ કહેવાય છે.',
  meaningEnglish:
      'Action performed in delusion without considering consequences or ability is Tamasic.',
  meaningGujarati:
      'પરિણામ અને પોતાની શક્તિનો વિચાર કર્યા વગર મોહથી કરાયેલ કર્મ તામસ છે.',
),

SacredVerseModel(
  verseNumber: 26,
  sanskrit:
      'मुक्तसङ्गोऽनहंवादी धृत्युत्साहसमन्वितः ।\n'
      'सिद्ध्यसिद्ध्योर्निर्विकारः कर्ता सात्त्विक उच्यते ॥१८.२६॥',
  english:
      'A Sattvic doer is free from attachment and ego, full of determination and enthusiasm, and remains balanced in success and failure.',
  gujarati:
      'જે કર્તા આસક્તિ અને અહંકારથી મુક્ત છે, ધૈર્ય અને ઉત્સાહથી ભરેલો છે અને સફળતા-નિષ્ફળતામાં સમભાવ રાખે છે, તે સાત્ત્વિક કર્તા કહેવાય છે.',
  meaningEnglish:
      'A Sattvic doer is detached, free from ego and balanced in success and failure.',
  meaningGujarati:
      'આસક્તિ અને અહંકારથી મુક્ત તથા સફળતા-નિષ્ફળતામાં સમભાવ રાખનાર સાત્ત્વિક કર્તા છે.',
),

SacredVerseModel(
  verseNumber: 27,
  sanskrit:
      'रागी कर्मफलप्रेप्सुर्लुब्धो हिंसात्मकोऽशुचिः ।\n'
      'हर्षशोकान्वितः कर्ता राजसः परिकीर्तितः ॥१८.२७॥',
  english:
      'A Rajasic doer is attached, desirous of results, greedy, harmful, impure and affected by joy and sorrow.',
  gujarati:
      'જે કર્તા આસક્ત, કર્મફળની ઈચ્છાવાળો, લોભી, હિંસક, અશુદ્ધ અને સુખ-દુઃખમાં ચંચળ રહે છે, તે રાજસ કર્તા કહેવાય છે.',
  meaningEnglish:
      'An attached, greedy and result-seeking doer affected by joy and sorrow is Rajasic.',
  meaningGujarati:
      'આસક્ત, લોભી અને કર્મફળની ઇચ્છાવાળો કર્તા રાજસ છે.',
),

SacredVerseModel(
  verseNumber: 28,
  sanskrit:
      'अयुक्तः प्राकृतः स्तब्धः शठो नैष्कृतिकोऽलसः ।\n'
      'विषादी दीर्घसूत्री च कर्ता तामस उच्यते ॥१८.२८॥',
  english:
      'A Tamasic doer is undisciplined, ignorant, stubborn, deceitful, lazy, gloomy and habitually delays action.',
  gujarati:
      'જે કર્તા અસ્થિર, અજ્ઞાની, હઠીલો, કપટી, આળસુ, ઉદાસીન અને કામને લાંબું ખેંચનાર છે, તે તામસ કર્તા કહેવાય છે.',
  meaningEnglish:
      'An undisciplined, ignorant, stubborn, lazy and delaying doer is Tamasic.',
  meaningGujarati:
      'અસ્થિર, અજ્ઞાની, હઠીલો, આળસુ અને કામને લંબાવનાર કર્તા તામસ છે.',
),

SacredVerseModel(
  verseNumber: 29,
  sanskrit:
      'बुद्धेर्भेदं धृतेश्चैव गुणतस्त्रिविधं शृणु ।\n'
      'प्रोच्यमानमशेषेण पृथक्त्वेन धनञ्जय ॥१८.२९॥',
  english:
      'O Dhananjaya, now hear about the threefold distinction of intellect and steadfastness according to the three gunas.',
  gujarati:
      'હે ધનંજય! હવે સત્વ, રજસ અને તમસ ગુણ પ્રમાણે બુદ્ધિ અને ધૃતિના ત્રણ પ્રકારોને સંપૂર્ણ રીતે સાંભળ.',
  meaningEnglish:
      'Intellect and steadfastness are classified into three types according to the three gunas.',
  meaningGujarati:
      'બુદ્ધિ અને ધૃતિ સત્વ, રજસ અને તમસ પ્રમાણે ત્રણ પ્રકારની છે.',
),

SacredVerseModel(
  verseNumber: 30,
  sanskrit:
      'प्रवृत्तिं च निवृत्तिं च कार्याकार्ये भयाभये ।\n'
      'बन्धं मोक्षं च या वेत्ति बुद्धिः सा पार्थ सात्त्विकी ॥१८.३०॥',
  english:
      'The intellect that correctly understands action and inaction, duty and non-duty, fear and fearlessness, bondage and liberation is Sattvic.',
  gujarati:
      'હે પાર્થ! જે બુદ્ધિ કર્મ કરવાનું અને ન કરવાનું, કર્તવ્ય અને અકર્તવ્ય, ભય અને નિર્ભયતા તથા બંધન અને મોક્ષને સાચી રીતે ઓળખે છે, તે સાત્ત્વિક બુદ્ધિ છે.',
  meaningEnglish:
      'An intellect that correctly distinguishes duty, non-duty, fear, fearlessness, bondage and liberation is Sattvic.',
  meaningGujarati:
      'કર્તવ્ય-અકર્તવ્ય, ભય-નિર્ભયતા અને બંધન-મોક્ષનો સાચો ભેદ જાણતી બુદ્ધિ સાત્ત્વિક છે.',
),

SacredVerseModel(
  verseNumber: 31,
  sanskrit:
      'यया धर्ममधर्मं च कार्यं चाकार्यमेव च ।\n'
      'अयथावत्प्रजानाति बुद्धिः सा पार्थ राजसी ॥१८.३१॥',
  english:
      'The intellect that cannot clearly distinguish righteousness from unrighteousness and duty from non-duty is Rajasic.',
  gujarati:
      'હે પાર્થ! જે બુદ્ધિ ધર્મ અને અધર્મ તથા કર્તવ્ય અને અકર્તવ્યને સાચી રીતે ઓળખી શકતી નથી, તે રાજસ બુદ્ધિ છે.',
  meaningEnglish:
      'An intellect that does not correctly distinguish dharma from adharma is Rajasic.',
  meaningGujarati:
      'ધર્મ-અધર્મ અને કર્તવ્ય-અકર્તવ્યનો સાચો ભેદ ન કરી શકતી બુદ્ધિ રાજસ છે.',
),

SacredVerseModel(
  verseNumber: 32,
  sanskrit:
      'अधर्मं धर्ममिति या मन्यते तमसावृता ।\n'
      'सर्वार्थान्विपरीतांश्च बुद्धिः सा पार्थ तामसी ॥१८.३२॥',
  english:
      'The intellect covered by darkness that mistakes unrighteousness for righteousness and sees everything wrongly is Tamasic.',
  gujarati:
      'હે પાર્થ! તમસથી ઢંકાયેલી જે બુદ્ધિ અધર્મને ધર્મ માને છે અને દરેક વસ્તુને વિપરીત રીતે સમજે છે, તે તામસ બુદ્ધિ છે.',
  meaningEnglish:
      'An intellect that mistakes unrighteousness for righteousness and sees things incorrectly is Tamasic.',
  meaningGujarati:
      'અધર્મને ધર્મ માનતી અને વસ્તુઓને વિપરીત રીતે સમજતી બુદ્ધિ તામસ છે.',
),

SacredVerseModel(
  verseNumber: 33,
  sanskrit:
      'धृत्या यया धारयते मनःप्राणेन्द्रियक्रियाः ।\n'
      'योगेनाव्यभिचारिण्या धृतिः सा पार्थ सात्त्विकी ॥१८.३३॥',
  english:
      'The steadfastness by which the mind, life-force and senses are firmly controlled through yoga is Sattvic steadfastness.',
  gujarati:
      'હે પાર્થ! જે અડગ ધૃતિ દ્વારા મન, પ્રાણ અને ઇન્દ્રિયોની ક્રિયાઓને યોગપૂર્વક નિયંત્રિત રાખવામાં આવે છે, તે સાત્ત્વિક ધૃતિ છે.',
  meaningEnglish:
      'Steadfastness that firmly controls the mind, life-force and senses through yoga is Sattvic.',
  meaningGujarati:
      'યોગ દ્વારા મન, પ્રાણ અને ઇન્દ્રિયોને નિયંત્રિત રાખતી અડગ ધૃતિ સાત્ત્વિક છે.',
),

SacredVerseModel(
  verseNumber: 34,
  sanskrit:
      'यया तु धर्मकामार्थान्धृत्या धारयतेऽर्जुन ।\n'
      'प्रसङ्गेन फलाकाङ्क्षी धृतिः सा पार्थ राजसी ॥१८.३४॥',
  english:
      'The steadfastness by which a person clings to duty, desire and wealth while seeking their fruits is Rajasic.',
  gujarati:
      'હે અર્જુન! જે ધૃતિથી મનુષ્ય ધર્મ, કામ અને અર્થને કર્મફળની આસક્તિ સાથે પકડી રાખે છે, તે રાજસ ધૃતિ છે.',
  meaningEnglish:
      'Steadfastness attached to duty, desire and wealth with expectation of results is Rajasic.',
  meaningGujarati:
      'ફળની આસક્તિ સાથે ધર્મ, કામ અને અર્થને પકડી રાખતી ધૃતિ રાજસ છે.',
),

SacredVerseModel(
  verseNumber: 35,
  sanskrit:
      'यया स्वप्नं भयं शोकं विषादं मदमेव च ।\n'
      'न विमुञ्चति दुर्मेधा धृतिः सा पार्थ तामसी ॥१८.३५॥',
  english:
      'The steadfastness by which a foolish person remains attached to sleep, fear, sorrow, depression and arrogance is Tamasic.',
  gujarati:
      'હે પાર્થ! જે ધૃતિથી મૂર્ખ મનુષ્ય ઊંઘ, ભય, શોક, ઉદાસીનતા અને અહંકારને છોડતો નથી, તે તામસ ધૃતિ છે.',
  meaningEnglish:
      'Steadfastness that keeps a person attached to sleep, fear, sorrow, depression and arrogance is Tamasic.',
  meaningGujarati:
      'ઊંઘ, ભય, શોક, ઉદાસીનતા અને અહંકારને છોડવા ન દેતી ધૃતિ તામસ છે.',
),

SacredVerseModel(
  verseNumber: 36,
  sanskrit:
      'सुखं त्विदानीं त्रिविधं शृणु मे भरतर्षभ ।\n'
      'अभ्यासाद्रमते यत्र दुःखान्तं च निगच्छति ॥१८.३६॥',
  english:
      'O best of the Bharatas, now hear of the three kinds of happiness. That happiness in which one rejoices through practice and eventually reaches the end of suffering is described next.',
  gujarati:
      'હે ભરતશ્રેષ્ઠ! હવે ત્રણ પ્રકારના સુખ વિશે સાંભળ. જે સુખના અભ્યાસથી મનુષ્ય આનંદ પામે છે અને અંતે દુઃખનો અંત આવે છે તે સુખને સમજ.',
  meaningEnglish:
      'There are three kinds of happiness; the higher form leads through practice toward the end of suffering.',
  meaningGujarati:
      'સુખ ત્રણ પ્રકારનું છે અને તેનો ઉત્તમ પ્રકાર અભ્યાસ દ્વારા દુઃખનો અંત લાવે છે.',
),

SacredVerseModel(
  verseNumber: 37,
  sanskrit:
      'यत्तदग्रे विषमिव परिणामेऽमृतोपमम् ।\n'
      'तत्सुखं सात्त्विकं प्रोक्तमात्मबुद्धिप्रसादजम् ॥१८.३७॥',
  english:
      'That happiness which seems like poison in the beginning but becomes like nectar in the end, arising from clarity of the Self, is Sattvic happiness.',
  gujarati:
      'જે સુખ શરૂઆતમાં વિષ જેવું લાગે છે પરંતુ અંતે અમૃત જેવું બને છે અને આત્મજ્ઞાનથી પ્રાપ્ત થાય છે, તે સાત્ત્વિક સુખ કહેવાય છે.',
  meaningEnglish:
      'Happiness that is difficult at first but becomes like nectar in the end is Sattvic.',
  meaningGujarati:
      'શરૂઆતમાં કઠિન પરંતુ અંતે અમૃત સમાન બનતું સુખ સાત્ત્વિક છે.',
),

SacredVerseModel(
  verseNumber: 38,
  sanskrit:
      'विषयेन्द्रियसंयोगाद्यत्तदग्रेऽमृतोपमम् ।\n'
      'परिणामे विषमिव तत्सुखं राजसं स्मृतम् ॥१८.३८॥',
  english:
      'Happiness arising from the contact of the senses with sense objects, which seems like nectar at first but becomes poison in the end, is Rajasic happiness.',
  gujarati:
      'ઇન્દ્રિયો અને વિષયોના સંયોગથી જે સુખ શરૂઆતમાં અમૃત જેવું લાગે છે પરંતુ અંતે વિષ જેવું બને છે, તે રાજસ સુખ કહેવાય છે.',
  meaningEnglish:
      'Sense-based happiness that seems pleasant at first but becomes painful in the end is Rajasic.',
  meaningGujarati:
      'ઇન્દ્રિયવિષયોથી મળતું શરૂઆતમાં સુખદ પરંતુ અંતે દુઃખદ સુખ રાજસ છે.',
),

SacredVerseModel(
  verseNumber: 39,
  sanskrit:
      'यदग्रे चानुबन्धे च सुखं मोहनमात्मनः ।\n'
      'निद्रालस्यप्रमादोत्थं तत्तामसमुदाहृतम् ॥१८.३९॥',
  english:
      'Happiness arising from sleep, laziness and negligence, which deludes the self from beginning to end, is Tamasic happiness.',
  gujarati:
      'જે સુખ શરૂઆતથી અંત સુધી આત્માને મોહમાં નાખે છે અને ઊંઘ, આળસ તથા પ્રમાદમાંથી ઉત્પન્ન થાય છે, તે તામસ સુખ કહેવાય છે.',
  meaningEnglish:
      'Happiness arising from sleep, laziness and negligence is Tamasic.',
  meaningGujarati:
      'ઊંઘ, આળસ અને પ્રમાદથી ઉત્પન્ન થતું મોહમય સુખ તામસ છે.',
),

SacredVerseModel(
  verseNumber: 40,
  sanskrit:
      'न तदस्ति पृथिव्यां वा दिवि देवेषु वा पुनः ।\n'
      'सत्त्वं प्रकृतिजैर्मुक्तं यदेभिः स्यात्त्रिभिर्गुणैः ॥१८.४०॥',
  english:
      'There is no being on earth or even among the gods in heaven who is completely free from the three gunas born of nature.',
  gujarati:
      'પૃથ્વી પર કે સ્વર્ગમાં દેવતાઓમાં પણ એવું કોઈ જીવ નથી કે જે પ્રકૃતિના આ ત્રણ ગુણોથી સંપૂર્ણપણે મુક્ત હોય.',
  meaningEnglish:
      'No being in the world or among the gods is completely free from the three qualities of nature.',
  meaningGujarati:
      'પૃથ્વી કે સ્વર્ગમાં કોઈ પણ જીવ પ્રકૃતિના ત્રણ ગુણોથી સંપૂર્ણપણે મુક્ત નથી.',
),
SacredVerseModel(
  verseNumber: 41,
  sanskrit:
      'ब्राह्मणक्षत्रियविशां शूद्राणां च परन्तप ।\n'
      'कर्माणि प्रविभक्तानि स्वभावप्रभवैर्गुणैः ॥१८.४१॥',
  english:
      'O scorcher of foes, the duties of Brahmanas, Kshatriyas, Vaishyas and Shudras are divided according to the qualities born of their own nature.',
  gujarati:
      'હે પરંતપ! બ્રાહ્મણ, ક્ષત્રિય, વૈશ્ય અને શૂદ્રનાં કર્મો તેમના સ્વભાવથી ઉત્પન્ન થયેલા ગુણો પ્રમાણે વહેંચાયેલા છે.',
  meaningEnglish:
      'The duties of the four social classes are determined by the qualities arising from their natural disposition.',
  meaningGujarati:
      'બ્રાહ્મણ, ક્ષત્રિય, વૈશ્ય અને શૂદ્રનાં કર્મો તેમના સ્વભાવજન્ય ગુણો પ્રમાણે નક્કી થાય છે.',
),

SacredVerseModel(
  verseNumber: 42,
  sanskrit:
      'शमो दमस्तपः शौचं क्षान्तिरार्जवमेव च ।\n'
      'ज्ञानं विज्ञानमास्तिक्यं ब्रह्मकर्म स्वभावजम् ॥१८.४२॥',
  english:
      'Peacefulness, self-control, austerity, purity, patience, straightforwardness, knowledge, wisdom and faith are the natural duties of a Brahmana.',
  gujarati:
      'મનનો સંયમ, ઇન્દ્રિયોનો સંયમ, તપ, પવિત્રતા, ક્ષમા, સરળતા, જ્ઞાન, વિજ્ઞાન અને શ્રદ્ધા — આ બ્રાહ્મણના સ્વભાવજન્ય કર્મો છે.',
  meaningEnglish:
      'Peacefulness, self-control, purity, patience, knowledge, wisdom and faith are the natural qualities and duties of a Brahmana.',
  meaningGujarati:
      'મન અને ઇન્દ્રિયોનો સંયમ, તપ, પવિત્રતા, ક્ષમા, સરળતા, જ્ઞાન, વિજ્ઞાન અને શ્રદ્ધા બ્રાહ્મણના સ્વભાવજન્ય ગુણો છે.',
),

SacredVerseModel(
  verseNumber: 43,
  sanskrit:
      'शौर्यं तेजो धृतिर्दाक्ष्यं युद्धे चाप्यपलायनम् ।\n'
      'दानमीश्वरभावश्च क्षात्रं कर्म स्वभावजम् ॥१८.४३॥',
  english:
      'Heroism, strength, firmness, skill, courage in battle, generosity and leadership are the natural duties of a Kshatriya.',
  gujarati:
      'શૌર્ય, તેજ, ધૈર્ય, કુશળતા, યુદ્ધમાંથી ન ભાગવું, દાન અને નેતૃત્વભાવ — આ ક્ષત્રિયના સ્વભાવજન્ય કર્મો છે.',
  meaningEnglish:
      'Courage, strength, determination, skill, generosity and leadership are the natural qualities of a Kshatriya.',
  meaningGujarati:
      'શૌર્ય, શક્તિ, ધૈર્ય, કુશળતા, યુદ્ધમાં અડગ રહેવું, દાન અને નેતૃત્વ ક્ષત્રિયના સ્વભાવજન્ય ગુણો છે.',
),

SacredVerseModel(
  verseNumber: 44,
  sanskrit:
      'कृषिगोरक्ष्यवाणिज्यं वैश्यकर्म स्वभावजम् ।\n'
      'परिचर्यात्मकं कर्म शूद्रस्यापि स्वभावजम् ॥१८.४४॥',
  english:
      'Agriculture, cattle-rearing and trade are the natural duties of a Vaishya, while service is the natural duty of a Shudra.',
  gujarati:
      'કૃષિ, ગોપાલન અને વેપાર વૈશ્યનાં સ્વભાવજન્ય કર્મો છે. સેવા કરવી એ શૂદ્રનું સ્વભાવજન્ય કર્મ છે.',
  meaningEnglish:
      'Agriculture, protection of cattle and trade are natural duties of a Vaishya, while service is the natural duty of a Shudra.',
  meaningGujarati:
      'કૃષિ, ગોપાલન અને વેપાર વૈશ્યના સ્વભાવજન્ય કર્મો છે, જ્યારે સેવા કરવી શૂદ્રનું સ્વભાવજન્ય કર્મ છે.',
),

SacredVerseModel(
  verseNumber: 45,
  sanskrit:
      'स्वे स्वे कर्मण्यभिरतः संसिद्धिं लभते नरः ।\n'
      'स्वकर्मनिरतः सिद्धिं यथा विन्दति तच्छृणु ॥१८.४५॥',
  english:
      'A person devoted to his own duty attains perfection. Hear how one devoted to his own work reaches perfection.',
  gujarati:
      'પોતાના પોતાના કર્મમાં નિષ્ઠાપૂર્વક લાગેલો મનુષ્ય સિદ્ધિ પ્રાપ્ત કરે છે. પોતાનું કર્મ કરતાં કેવી રીતે સિદ્ધિ મળે છે તે સાંભળ.',
  meaningEnglish:
      'A person who faithfully performs his own duty can attain perfection through that work.',
  meaningGujarati:
      'પોતાના સ્વભાવ અને કર્તવ્ય પ્રમાણે કર્મમાં નિષ્ઠા રાખવાથી મનુષ્ય સિદ્ધિ પ્રાપ્ત કરી શકે છે.',
),

SacredVerseModel(
  verseNumber: 46,
  sanskrit:
      'यतः प्रवृत्तिर्भूतानां येन सर्वमिदं ततम् ।\n'
      'स्वकर्मणा तमभ्यर्च्य सिद्धिं विन्दति मानवः ॥१८.४६॥',
  english:
      'By worshipping Him from whom all beings arise and by whom the whole universe is pervaded, a person attains perfection through his own duty.',
  gujarati:
      'જે પરમાત્માથી સર્વ જીવોની ઉત્પત્તિ થાય છે અને જે સમગ્ર જગતમાં વ્યાપ્ત છે, તેની પોતાના કર્મ દ્વારા ઉપાસના કરીને મનુષ્ય સિદ્ધિ પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'By performing one’s own duty as an offering to the Supreme who pervades the entire universe, a person attains perfection.',
  meaningGujarati:
      'સમગ્ર જગતમાં વ્યાપ્ત પરમાત્માની પોતાના કર્મ દ્વારા ઉપાસના કરવાથી મનુષ્ય સિદ્ધિ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 47,
  sanskrit:
      'श्रेयान्स्वधर्मो विगुणः परधर्मात्स्वनुष्ठितात् ।\n'
      'स्वभावनियतं कर्म कुर्वन्नाप्नोति किल्बिषम् ॥१८.४७॥',
  english:
      'One’s own duty, though imperfect, is better than another’s duty performed well. By performing one’s natural duty, one does not incur sin.',
  gujarati:
      'બીજાના ધર્મને સારી રીતે કરવા કરતાં પોતાનો ધર્મ થોડો અપૂર્ણ હોય તો પણ શ્રેષ્ઠ છે. પોતાના સ્વભાવ પ્રમાણેનું કર્મ કરવાથી પાપ લાગતું નથી.',
  meaningEnglish:
      'Performing one’s own natural duty, even imperfectly, is better than performing another’s duty perfectly.',
  meaningGujarati:
      'પોતાના સ્વભાવજન્ય કર્તવ્યને અપૂર્ણ રીતે કરવું પણ બીજાના કર્તવ્યને ઉત્તમ રીતે કરવા કરતાં શ્રેષ્ઠ છે.',
),

SacredVerseModel(
  verseNumber: 48,
  sanskrit:
      'सहजं कर्म कौन्तेय सदोषमपि न त्यजेत् ।\n'
      'सर्वारम्भा हि दोषेण धूमेनाग्निरिवावृताः ॥१८.४८॥',
  english:
      'One should not abandon one’s natural duty even if it has defects, for every undertaking is covered by some imperfection, just as fire is covered by smoke.',
  gujarati:
      'હે કૌન્તેય! પોતાના સ્વભાવજન્ય કર્મમાં દોષ હોય તો પણ તેને છોડવું નહીં, કારણ કે દરેક કર્મ કોઈ ને કોઈ દોષથી આવરાયેલું હોય છે, જેમ અગ્નિ ધુમાડાથી ઢંકાયેલો હોય છે.',
  meaningEnglish:
      'A person should not abandon natural duty because of its imperfections, since every action has some limitation.',
  meaningGujarati:
      'પોતાના સ્વભાવજન્ય કર્મમાં દોષ હોય તો પણ તેનો ત્યાગ ન કરવો, કારણ કે દરેક કર્મમાં કોઈ ને કોઈ દોષ હોય છે.',
),

SacredVerseModel(
  verseNumber: 49,
  sanskrit:
      'असक्तबुद्धिः सर्वत्र जितात्मा विगतस्पृहः ।\n'
      'नैष्कर्म्यसिद्धिं परमां संन्यासेनाधिगच्छति ॥१८.४९॥',
  english:
      'One whose intellect is unattached, who has mastered himself and is free from desires attains the highest perfection through renunciation.',
  gujarati:
      'જેની બુદ્ધિ સર્વત્ર આસક્તિ રહિત છે, જેણે પોતાના મનને જીતી લીધું છે અને જે ઇચ્છાઓથી મુક્ત છે, તે સંન્યાસ દ્વારા પરમ નૈષ્કર્મ્ય સિદ્ધિ પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'One who is free from attachment and desires, and has mastered the self, attains the highest perfection through renunciation.',
  meaningGujarati:
      'આસક્તિ અને ઇચ્છાઓથી મુક્ત તથા આત્મસંયમી મનુષ્ય સંન્યાસ દ્વારા પરમ સિદ્ધિ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 50,
  sanskrit:
      'सिद्धिं प्राप्तो यथा ब्रह्म तथाप्नोति निबोध मे ।\n'
      'समासेनैव कौन्तेय निष्ठा ज्ञानस्य या परा ॥१८.५०॥',
  english:
      'Learn from Me briefly how one who has attained perfection reaches Brahman, the supreme culmination of knowledge.',
  gujarati:
      'હે કૌન્તેય! સિદ્ધિ પ્રાપ્ત કરેલો મનુષ્ય જ્ઞાનની પરમ અવસ્થા એવા બ્રહ્મને કેવી રીતે પ્રાપ્ત કરે છે તે સંક્ષેપમાં મારી પાસેથી જાણ.',
  meaningEnglish:
      'One who has attained perfection can reach Brahman, the supreme goal of spiritual knowledge.',
  meaningGujarati:
      'સિદ્ધિ પ્રાપ્ત કરેલો મનુષ્ય જ્ઞાનની પરમ અવસ્થા બ્રહ્મને પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 51,
  sanskrit:
      'बुद्ध्या विशुद्धया युक्तो धृत्यात्मानं नियम्य च ।\n'
      'शब्दादीन्विषयांस्त्यक्त्वा रागद्वेषौ व्युदस्य च ॥१८.५१॥',
  english:
      'Endowed with purified intellect, controlling the self with firmness, abandoning sense objects and casting away attachment and aversion.',
  gujarati:
      'શુદ્ધ બુદ્ધિથી યુક્ત થઈ, ધૈર્યથી મનને નિયંત્રિત કરીને, શબ્દ વગેરે ઇન્દ્રિયવિષયોનો ત્યાગ કરીને અને રાગ-દ્વેષને દૂર કરીને...',
  meaningEnglish:
      'Through purified intellect, self-control, renunciation of sense attachments and freedom from likes and dislikes, one progresses toward spiritual perfection.',
  meaningGujarati:
      'શુદ્ધ બુદ્ધિ, આત્મસંયમ અને રાગ-દ્વેષના ત્યાગ દ્વારા મનુષ્ય આધ્યાત્મિક સિદ્ધિ તરફ આગળ વધે છે.',
),

SacredVerseModel(
  verseNumber: 52,
  sanskrit:
      'विविक्तसेवी लघ्वाशी यतवाक्कायमानसः ।\n'
      'ध्यानयोगपरो नित्यं वैराग्यं समुपाश्रितः ॥१८.५२॥',
  english:
      'One should live in solitude, eat moderately, control speech, body and mind, remain devoted to meditation and take refuge in detachment.',
  gujarati:
      'એકાંતમાં રહેનાર, મિતાહારી, વાણી-શરીર-મનને સંયમમાં રાખનાર, સતત ધ્યાનયોગમાં રહેનાર અને વૈરાગ્યનો આશ્રય લેનાર હોવો જોઈએ.',
  meaningEnglish:
      'Living simply, controlling speech, body and mind, practicing meditation and cultivating detachment leads toward spiritual realization.',
  meaningGujarati:
      'એકાંત, મિતાહાર, ઇન્દ્રિય અને મનનો સંયમ, ધ્યાન અને વૈરાગ્ય આધ્યાત્મિક પ્રગતિ માટે જરૂરી છે.',
),

SacredVerseModel(
  verseNumber: 53,
  sanskrit:
      'अहंकारं बलं दर्पं कामं क्रोधं परिग्रहम् ।\n'
      'विमुच्य निर्ममः शान्तो ब्रह्मभूयाय कल्पते ॥१८.५३॥',
  english:
      'Abandoning ego, pride, desire, anger and possessiveness, becoming free from selfishness and peaceful, one becomes fit for realizing Brahman.',
  gujarati:
      'અહંકાર, બળનો ગર્વ, દર્પ, કામ, ક્રોધ અને સંગ્રહભાવ છોડીને, મમતારહિત અને શાંત બનેલો મનુષ્ય બ્રહ્મરૂપ થવા યોગ્ય બને છે.',
  meaningEnglish:
      'By giving up ego, pride, desire, anger and possessiveness, a person becomes peaceful and fit for realizing Brahman.',
  meaningGujarati:
      'અહંકાર, કામ, ક્રોધ અને મમતાનો ત્યાગ કરીને મનુષ્ય શાંત બને છે અને બ્રહ્મજ્ઞાન માટે યોગ્ય બને છે.',
),

SacredVerseModel(
  verseNumber: 54,
  sanskrit:
      'ब्रह्मभूतः प्रसन्नात्मा न शोचति न काङ्क्षति ।\n'
      'समः सर्वेषु भूतेषु मद्भक्तिं लभते पराम् ॥१८.५४॥',
  english:
      'Having realized Brahman, one becomes joyful, neither grieving nor desiring. Being equal toward all beings, one attains supreme devotion to Me.',
  gujarati:
      'બ્રહ્મરૂપ બનેલો પ્રસન્ન આત્માવાળો મનુષ્ય ન શોક કરે છે ન કોઈ ઇચ્છા રાખે છે. સર્વ જીવોમાં સમભાવ રાખીને તે મારી પરમ ભક્તિ પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'One who realizes Brahman becomes peaceful and free from grief and desire, sees all beings equally and attains supreme devotion.',
  meaningGujarati:
      'બ્રહ્મને પ્રાપ્ત કરેલો મનુષ્ય શોક અને ઇચ્છાથી મુક્ત થઈ સર્વમાં સમભાવ રાખે છે અને પરમ ભક્તિ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 55,
  sanskrit:
      'भक्त्या मामभिजानाति यावान्यश्चास्मि तत्त्वतः ।\n'
      'ततो मां तत्त्वतो ज्ञात्वा विशते तदनन्तरम् ॥१८.५५॥',
  english:
      'Through devotion one truly knows Me as I am. Having known Me in truth, one enters into Me thereafter.',
  gujarati:
      'ભક્તિ દ્વારા મનુષ્ય મને તત્ત્વથી ઓળખે છે—હું જેવો છું અને જેટલો છું તે રીતે. મને તત્ત્વથી જાણ્યા પછી તે મારામાં પ્રવેશ કરે છે.',
  meaningEnglish:
      'Through true devotion, one understands the Supreme in reality and ultimately attains union with Him.',
  meaningGujarati:
      'પરમ ભક્તિ દ્વારા ભગવાનને તત્ત્વથી જાણીને મનુષ્ય અંતે ભગવાનને પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 56,
  sanskrit:
      'सर्वकर्माण्यपि सदा कुर्वाणो मद्व्यपाश्रयः ।\n'
      'मत्प्रसादादवाप्नोति शाश्वतं पदमव्ययम् ॥१८.५६॥',
  english:
      'Even while performing all actions, one who takes refuge in Me attains the eternal and imperishable state by My grace.',
  gujarati:
      'મારો આશ્રય લઈને બધા કર્મો સતત કરતો મનુષ્ય મારી કૃપાથી શાશ્વત અને અવિનાશી પદ પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'A person who performs duties while taking refuge in the Supreme attains the eternal state through divine grace.',
  meaningGujarati:
      'ભગવાનનો આશ્રય લઈને કર્મ કરનાર મનુષ્ય ભગવાનની કૃપાથી શાશ્વત અવિનાશી પદ પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 57,
  sanskrit:
      'चेतसा सर्वकर्माणि मयि संन्यस्य मत्परः ।\n'
      'बुद्धियोगमुपाश्रित्य मच्चित्तः सततं भव ॥१८.५७॥',
  english:
      'Surrender all actions to Me, make Me your supreme goal, take refuge in Buddhi-yoga and constantly fix your mind on Me.',
  gujarati:
      'મનથી બધા કર્મો મને અર્પણ કરીને, મને પરમ લક્ષ્ય માનીને, બુદ્ધિયોગનો આશ્રય લઈ સતત મારામાં મન રાખ.',
  meaningEnglish:
      'Offer all actions to the Supreme, make Him the highest goal and keep the mind constantly absorbed in Him through spiritual wisdom.',
  meaningGujarati:
      'બધા કર્મો ભગવાનને અર્પણ કરીને તેમને પરમ લક્ષ્ય માની સતત ભગવાનમાં મન સ્થિર રાખવું.',
),

SacredVerseModel(
  verseNumber: 58,
  sanskrit:
      'मच्चित्तः सर्वदुर्गाणि मत्प्रसादात्तरिष्यसि ।\n'
      'अथ चेत्त्वमहंकारान्न श्रोष्यसि विनङ्क्ष्यसि ॥१८.५८॥',
  english:
      'With your mind fixed on Me, you will overcome all difficulties by My grace. But if you refuse to listen because of ego, you will perish.',
  gujarati:
      'મારામાં મન રાખીશ તો મારી કૃપાથી તમામ મુશ્કેલીઓ પાર કરીશ. પરંતુ અહંકારથી મારી વાત નહીં સાંભળે તો વિનાશ પામશે.',
  meaningEnglish:
      'By keeping the mind fixed on the Supreme, one can overcome difficulties through divine grace, while ego and refusal lead to downfall.',
  meaningGujarati:
      'ભગવાનમાં મન સ્થિર રાખવાથી તેમની કૃપાથી મુશ્કેલીઓ પાર થાય છે, જ્યારે અહંકાર વિનાશ તરફ લઈ જાય છે.',
),

SacredVerseModel(
  verseNumber: 59,
  sanskrit:
      'यदहंकारमाश्रित्य न योत्स्य इति मन्यसे ।\n'
      'मिथ्यैष व्यवसायस्ते प्रकृतिस्त्वां नियोक्ष्यति ॥१८.५९॥',
  english:
      'If, out of ego, you think “I will not fight,” your decision is futile. Your own nature will compel you to act.',
  gujarati:
      'અહંકારના આશ્રયે “હું યુદ્ધ નહીં કરું” એવું માને છે, પરંતુ તારો આ નિર્ણય વ્યર્થ છે; તારો સ્વભાવ તને કર્મ કરવા માટે પ્રેરશે.',
  meaningEnglish:
      'An ego-based decision to avoid one’s duty is ultimately futile because one’s own nature will drive one to action.',
  meaningGujarati:
      'અહંકારથી કર્તવ્યનો ઇનકાર કરવાનો નિર્ણય વ્યર્થ છે, કારણ કે મનુષ્યનો સ્વભાવ તેને કર્મ કરવા પ્રેરશે.',
),

SacredVerseModel(
  verseNumber: 60,
  sanskrit:
      'स्वभावजेन कौन्तेय निबद्धः स्वेन कर्मणा ।\n'
      'कर्तुं नेच्छसि यन्मोहात्करिष्यस्यवशोऽपि तत् ॥१८.६०॥',
  english:
      'Bound by your own nature-born actions, you will do, even against your will, what you do not wish to do because of delusion.',
  gujarati:
      'હે કૌન્તેય! પોતાના સ્વભાવથી ઉત્પન્ન કર્મથી બંધાયેલો તું મોહને કારણે જે કરવું નથી ઇચ્છતો, તે પણ તારી ઇચ્છા વિરુદ્ધ કરવો પડશે.',
  meaningEnglish:
      'Because one is bound by one’s natural tendencies, one may ultimately perform actions even against one’s present wishes.',
  meaningGujarati:
      'સ્વભાવજન્ય કર્મના બંધનને કારણે મનુષ્ય મોહથી જે કર્મ કરવા નથી ઇચ્છતો તે પણ અંતે કરવા માટે પ્રેરાય છે.',
),

SacredVerseModel(
  verseNumber: 61,
  sanskrit:
      'ईश्वरः सर्वभूतानां हृद्देशेऽर्जुन तिष्ठति ।\n'
      'भ्रामयन्सर्वभूतानि यन्त्रारूढानि मायया ॥१८.६१॥',
  english:
      'The Lord dwells in the hearts of all beings and, through His Maya, causes them to move as if mounted on a machine.',
  gujarati:
      'હે અર્જુન! ઈશ્વર સર્વ જીવોના હૃદયમાં વસે છે અને પોતાની માયાથી જાણે યંત્ર પર બેઠેલા જીવોને ભ્રમણ કરાવે છે.',
  meaningEnglish:
      'The Supreme Lord dwells within every heart and, through His divine power, guides the movements of all beings.',
  meaningGujarati:
      'પરમાત્મા સર્વના હૃદયમાં નિવાસ કરે છે અને પોતાની માયા દ્વારા સર્વ જીવોની ગતિને સંચાલિત કરે છે.',
),

SacredVerseModel(
  verseNumber: 62,
  sanskrit:
      'तमेव शरणं गच्छ सर्वभावेन भारत ।\n'
      'तत्प्रसादात्परां शान्तिं स्थानं प्राप्स्यसि शाश्वतम् ॥१८.६२॥',
  english:
      'Take refuge in Him alone with your whole being. By His grace you will attain supreme peace and the eternal abode.',
  gujarati:
      'હે ભારત! સંપૂર્ણ ભાવથી એ પરમાત્માની જ શરણમાં જા. તેની કૃપાથી તું પરમ શાંતિ અને શાશ્વત સ્થાન પ્રાપ્ત કરીશ.',
  meaningEnglish:
      'By surrendering completely to the Supreme, one receives divine grace, supreme peace and the eternal state.',
  meaningGujarati:
      'સંપૂર્ણ ભાવથી પરમાત્માની શરણાગતિ કરવાથી તેમની કૃપાથી પરમ શાંતિ અને શાશ્વત પદ પ્રાપ્ત થાય છે.',
),

SacredVerseModel(
  verseNumber: 63,
  sanskrit:
      'इति ते ज्ञानमाख्यातं गुह्याद्गुह्यतरं मया ।\n'
      'विमृश्यैतदशेषेण यथेच्छसि तथा कुरु ॥१८.६३॥',
  english:
      'Thus I have explained this most secret knowledge to you. Reflect on it fully and then do as you wish.',
  gujarati:
      'આ રીતે મેં તને અત્યંત ગુપ્ત જ્ઞાન કહી દીધું છે. હવે આ બધાનો સંપૂર્ણ વિચાર કરીને તને જે યોગ્ય લાગે તે કર.',
  meaningEnglish:
      'After receiving this profound knowledge, Arjuna is asked to reflect upon it completely and then make his own decision.',
  meaningGujarati:
      'ભગવાને આપેલું ગુપ્ત જ્ઞાન સંપૂર્ણ રીતે વિચારીને મનુષ્યે પોતાના વિવેકથી યોગ્ય નિર્ણય લેવો જોઈએ.',
),

SacredVerseModel(
  verseNumber: 64,
  sanskrit:
      'सर्वगुह्यतमं भूयः शृणु मे परमं वचः ।\n'
      'इष्टोऽसि मे दृढमिति ततो वक्ष्यामि ते हितम् ॥१८.६४॥',
  english:
      'Hear again My supreme and most secret teaching. You are very dear to Me, therefore I shall tell you what is beneficial for you.',
  gujarati:
      'હવે ફરી મારું સર્વથી ગુપ્ત અને પરમ વચન સાંભળ. તું મને અત્યંત પ્રિય છે, તેથી હું તારા હિતની વાત કહીશ.',
  meaningEnglish:
      'Because Arjuna is deeply dear to Krishna, the Lord gives him His most confidential and beneficial teaching.',
  meaningGujarati:
      'અર્જુન ભગવાનને અત્યંત પ્રિય હોવાથી ભગવાન તેને પોતાનું સર્વોત્તમ અને હિતકારક ગુપ્ત જ્ઞાન આપે છે.',
),

SacredVerseModel(
  verseNumber: 65,
  sanskrit:
      'मन्मना भव मद्भक्तो मद्याजी मां नमस्कुरु ।\n'
      'मामेवैष्यसि सत्यं ते प्रतिजाने प्रियोऽसि मे ॥१८.६५॥',
  english:
      'Fix your mind on Me, become My devotee, worship Me and bow to Me. You will surely come to Me, for you are dear to Me.',
  gujarati:
      'મારામાં મન રાખ, મારો ભક્ત બન, મારી પૂજા કર અને મને નમસ્કાર કર. તું ચોક્કસ મને પ્રાપ્ત કરીશ, કારણ કે તું મને પ્રિય છે.',
  meaningEnglish:
      'Constant remembrance, devotion, worship and surrender to the Supreme lead the devotee to Him.',
  meaningGujarati:
      'ભગવાનમાં મન રાખીને, ભક્તિ, પૂજા અને નમસ્કાર દ્વારા મનુષ્ય ભગવાનને પ્રાપ્ત કરી શકે છે.',
),

SacredVerseModel(
  verseNumber: 66,
  sanskrit:
      'सर्वधर्मान्परित्यज्य मामेकं शरणं व्रज ।\n'
      'अहं त्वा सर्वपापेभ्यो मोक्षयिष्यामि मा शुचः ॥१८.६६॥',
  english:
      'Abandon all other forms of duty and take refuge in Me alone. I will liberate you from all sins; do not grieve.',
  gujarati:
      'બધા ધર્મોનો ત્યાગ કરીને માત્ર મારી શરણમાં આવ. હું તને બધા પાપોમાંથી મુક્ત કરીશ; તું શોક ન કર.',
  meaningEnglish:
      'Complete surrender to the Supreme is presented as the highest path to liberation and freedom from sin.',
  meaningGujarati:
      'માત્ર પરમાત્માની સંપૂર્ણ શરણાગતિ મોક્ષ અને પાપબંધનથી મુક્તિનો પરમ માર્ગ છે.',
),

SacredVerseModel(
  verseNumber: 67,
  sanskrit:
      'इदं ते नातपस्काय नाभक्ताय कदाचन ।\n'
      'न चाशुश्रूषवे वाच्यं न च मां योऽभ्यसूयति ॥१८.६७॥',
  english:
      'This teaching should never be given to one who is not austere, not devoted, unwilling to hear, or envious of Me.',
  gujarati:
      'આ ગુપ્ત જ્ઞાન એવા મનુષ્યને ક્યારેય ન કહેવું જે તપ કરતો નથી, ભક્ત નથી, સાંભળવા ઇચ્છતો નથી અથવા મારી નિંદા કરે છે.',
  meaningEnglish:
      'This profound teaching should be shared only with those who have sincerity, devotion, willingness to listen and respect for the Supreme.',
  meaningGujarati:
      'આ ગુપ્ત જ્ઞાન શ્રદ્ધા, ભક્તિ અને સાંભળવાની ઇચ્છા ધરાવતા યોગ્ય વ્યક્તિને જ આપવું જોઈએ.',
),

SacredVerseModel(
  verseNumber: 68,
  sanskrit:
      'य इदं परमं गुह्यं मद्भक्तेष्वभिधास्यति ।\n'
      'भक्तिं मयि परां कृत्वा मामेवैष्यत्यसंशयः ॥१८.६८॥',
  english:
      'One who teaches this supreme secret to My devotees, with supreme devotion to Me, will certainly come to Me.',
  gujarati:
      'જે મનુષ્ય મારા ભક્તોમાં આ પરમ ગુપ્ત જ્ઞાનનો ઉપદેશ કરશે અને મારામાં પરમ ભક્તિ રાખશે, તે નિશ્ચિતપણે મને પ્રાપ્ત કરશે.',
  meaningEnglish:
      'One who shares this supreme teaching with sincere devotees and remains devoted to the Lord will attain Him.',
  meaningGujarati:
      'ભગવાનના ભક્તોને આ પરમ જ્ઞાન સમજાવનાર અને ભગવાનમાં પરમ ભક્તિ રાખનાર મનુષ્ય ભગવાનને પ્રાપ્ત કરે છે.',
),

SacredVerseModel(
  verseNumber: 69,
  sanskrit:
      'न च तस्मान्मनुष्येषु कश्चिन्मे प्रियकृत्तमः ।\n'
      'भविता न च मे तस्मादन्यः प्रियतरो भुवि ॥१८.६९॥',
  english:
      'Among humans, no one performs a deed more pleasing to Me than this person, nor will anyone be dearer to Me on earth.',
  gujarati:
      'મનુષ્યોમાં તેના કરતાં મને વધુ પ્રિય કાર્ય કરનાર કોઈ નથી અને પૃથ્વી પર તેના કરતાં મને વધુ પ્રિય બીજો કોઈ નહીં હોય.',
  meaningEnglish:
      'The person who shares this sacred teaching with devotion is considered especially dear to the Lord.',
  meaningGujarati:
      'આ પવિત્ર જ્ઞાનને ભક્તિપૂર્વક વહેંચનાર મનુષ્ય ભગવાનને અત્યંત પ્રિય બને છે.',
),

SacredVerseModel(
  verseNumber: 70,
  sanskrit:
      'अध्येष्यते च य इमं धर्म्यं संवादमावयोः ।\n'
      'ज्ञानयज्ञेन तेनाहमिष्टः स्यामिति मे मतिः ॥१८.७०॥',
  english:
      'Whoever studies this sacred dialogue of ours worships Me through the sacrifice of knowledge; this is My conviction.',
  gujarati:
      'જે મનુષ્ય આપણા આ પવિત્ર સંવાદનો અભ્યાસ કરશે, તેના દ્વારા જ્ઞાનયજ્ઞથી મારી ઉપાસના થઈ છે એવું મારું માનવું છે.',
  meaningEnglish:
      'Studying the sacred dialogue between Krishna and Arjuna is itself considered a form of worship through the sacrifice of knowledge.',
  meaningGujarati:
      'ભગવાન અને અર્જુનના પવિત્ર સંવાદનો અભ્યાસ કરવો એ જ્ઞાનયજ્ઞ દ્વારા ભગવાનની ઉપાસના સમાન છે.',
),

SacredVerseModel(
  verseNumber: 71,
  sanskrit:
      'श्रद्धावाननसूयश्च शृणुयादपि यो नरः ।\n'
      'सोऽपि मुक्तः शुभाँल्लोकान्प्राप्नुयात्पुण्यकर्मणाम् ॥१८.७१॥',
  english:
      'A person who listens with faith and without envy becomes liberated and attains the auspicious worlds of those who perform righteous deeds.',
  gujarati:
      'જે મનુષ્ય શ્રદ્ધાપૂર્વક અને દોષદૃષ્ટિ વિના આ જ્ઞાન સાંભળે છે, તે પણ મુક્ત થઈને પુણ્યકર્મ કરનાર લોકોના શુભ લોકને પ્રાપ્ત કરે છે.',
  meaningEnglish:
      'Even one who simply listens to this teaching with faith and without envy gains spiritual benefit and moves toward liberation.',
  meaningGujarati:
      'શ્રદ્ધા અને દોષદૃષ્ટિ વિના આ પવિત્ર જ્ઞાન સાંભળનારને પણ આધ્યાત્મિક લાભ અને મુક્તિનો માર્ગ મળે છે.',
),

SacredVerseModel(
  verseNumber: 72,
  sanskrit:
      'कच्चिदेतच्छ्रुतं पार्थ त्वयैकाग्रेण चेतसा ।\n'
      'कच्चिदज्ञानसंमोहः प्रनष्टस्ते धनंजय ॥१८.७२॥',
  english:
      'O Arjuna, have you heard this with an attentive mind? Has your delusion born of ignorance been destroyed?',
  gujarati:
      'હે પાર્થ! શું તેં આ જ્ઞાન એકાગ્ર મનથી સાંભળ્યું? હે ધનંજય! શું તારો અજ્ઞાનથી ઉત્પન્ન મોહ નષ્ટ થયો?',
  meaningEnglish:
      'Krishna asks Arjuna whether he has understood the teaching with full attention and whether his ignorance and delusion have been removed.',
  meaningGujarati:
      'ભગવાન અર્જુનને પૂછે છે કે તેણે આ જ્ઞાન એકાગ્રતાથી સમજ્યું છે કે નહીં અને તેનો અજ્ઞાનજન્ય મોહ દૂર થયો છે કે નહીં.',
),

SacredVerseModel(
  verseNumber: 73,
  sanskrit:
      'नष्टो मोहः स्मृतिर्लब्धा त्वत्प्रसादान्मयाच्युत ।\n'
      'स्थितोऽस्मि गतसंदेहः करिष्ये वचनं तव ॥१८.७३॥',
  english:
      'Arjuna said: O Acyuta, by Your grace my delusion is destroyed and my memory is restored. I am free from doubt and will follow Your command.',
  gujarati:
      'અર્જુન કહે છે: હે અચ્યુત! તમારી કૃપાથી મારો મોહ નષ્ટ થયો છે અને મને મારી સાચી સ્મૃતિ પ્રાપ્ત થઈ છે. હવે હું સંશયરહિત છું અને તમારા વચનનું પાલન કરીશ.',
  meaningEnglish:
      'Arjuna declares that his delusion has disappeared, his understanding has returned, his doubts are gone, and he is ready to follow Krishna’s teaching.',
  meaningGujarati:
      'અર્જુન કહે છે કે ભગવાનની કૃપાથી તેનો મોહ અને સંશય દૂર થયા છે અને હવે તે ભગવાનના વચનનું પાલન કરવા તૈયાર છે.',
),

SacredVerseModel(
  verseNumber: 74,
  sanskrit:
      'संजय उवाच ।\n'
      'इत्यहं वासुदेवस्य पार्थस्य च महात्मनः ।\n'
      'संवादमिममश्रौषमद्भुतं रोमहर्षणम् ॥१८.७४॥',
  english:
      'Sanjaya said: Thus I heard this wonderful and thrilling dialogue between Vasudeva Krishna and the great-souled Arjuna.',
  gujarati:
      'સંજય કહે છે: આ રીતે મેં વાસુદેવ શ્રીકૃષ્ણ અને મહાત્મા અર્જુનનો આ અદ્ભુત અને રોમાંચ ઉત્પન્ન કરનારો સંવાદ સાંભળ્યો.',
  meaningEnglish:
      'Sanjaya describes the dialogue between Krishna and Arjuna as a wondrous and deeply moving spiritual conversation.',
  meaningGujarati:
      'સંજય શ્રીકૃષ્ણ અને અર્જુન વચ્ચેના આ અદ્ભુત અને રોમાંચક સંવાદને યાદ કરે છે.',
),

SacredVerseModel(
  verseNumber: 75,
  sanskrit:
      'व्यासप्रसादाच्छ्रुतवानेतद्गुह्यमहं परम् ।\n'
      'योगं योगेश्वरात्कृष्णात्साक्षात्कथयतः स्वयम् ॥१८.७५॥',
  english:
      'By the grace of Vyasa, I heard directly from Krishna, the Lord of Yoga, this supreme and secret teaching as He Himself spoke it.',
  gujarati:
      'વ્યાસજીની કૃપાથી મેં યોગેશ્વર શ્રીકૃષ્ણ પોતે જે પરમ ગુપ્ત યોગ કહી રહ્યા હતા તે સીધો સાંભળ્યો.',
  meaningEnglish:
      'By Vyasa’s grace, Sanjaya was able to hear directly the supreme and secret teaching spoken by Krishna Himself.',
  meaningGujarati:
      'વ્યાસજીની કૃપાથી સંજયે યોગેશ્વર શ્રીકૃષ્ણ પાસેથી સીધું આ પરમ ગુપ્ત યોગજ્ઞાન સાંભળ્યું.',
),

SacredVerseModel(
  verseNumber: 76,
  sanskrit:
      'राजन्संस्मृत्य संस्मृत्य संवादमिममद्भुतम् ।\n'
      'केशवार्जुनयोः पुण्यं हृष्यामि च मुहुर्मुहुः ॥१८.७६॥',
  english:
      'O King, remembering again and again this wonderful and sacred dialogue between Krishna and Arjuna, I rejoice again and again.',
  gujarati:
      'હે રાજન! કેશવ અને અર્જુનનો આ પવિત્ર અને અદ્ભુત સંવાદ વારંવાર યાદ કરીને હું વારંવાર આનંદિત થાઉં છું.',
  meaningEnglish:
      'Sanjaya repeatedly remembers the sacred dialogue between Krishna and Arjuna and feels great joy each time.',
  meaningGujarati:
      'કૃષ્ણ અને અર્જુનના પવિત્ર સંવાદને વારંવાર યાદ કરીને સંજયને વારંવાર આનંદ અને પ્રસન્નતા થાય છે.',
),

SacredVerseModel(
  verseNumber: 77,
  sanskrit:
      'तच्च संस्मृत्य संस्मृत्य रूपमत्यद्भुतं हरेः ।\n'
      'विस्मयो मे महान्राजन्हृष्यामि च पुनः पुनः ॥१८.७७॥',
  english:
      'O King, remembering again and again the exceedingly wonderful form of Hari, I am filled with great wonder and rejoice repeatedly.',
  gujarati:
      'હે રાજન! ભગવાન હરિના તે અતિ અદ્ભુત વિશ્વરૂપને વારંવાર યાદ કરીને મને મહાન આશ્ચર્ય થાય છે અને હું વારંવાર આનંદિત થાઉં છું.',
  meaningEnglish:
      'Remembering the extraordinary divine form of the Lord fills Sanjaya with wonder and joy again and again.',
  meaningGujarati:
      'ભગવાનના અતિ અદ્ભુત વિશ્વરૂપને વારંવાર યાદ કરતાં સંજયને મહાન આશ્ચર્ય અને આનંદની અનુભૂતિ થાય છે.',
),

SacredVerseModel(
  verseNumber: 78,
  sanskrit:
      'यत्र योगेश्वरः कृष्णो यत्र पार्थो धनुर्धरः ।\n'
      'तत्र श्रीर्विजयो भूतिर्ध्रुवा नीतिर्मतिर्मम ॥१८.७८॥',
  english:
      'Wherever Krishna, the Lord of Yoga, and Arjuna, the wielder of the bow, are present, there will be prosperity, victory, glory and firm righteousness. This is my conviction.',
  gujarati:
      'જ્યાં યોગેશ્વર શ્રીકૃષ્ણ છે અને જ્યાં ધનુર્ધારી અર્જુન છે, ત્યાં સમૃદ્ધિ, વિજય, વૈભવ અને અડગ નીતિ હોય છે—એ મારો નિશ્ચય છે.',
  meaningEnglish:
      'Where divine wisdom and righteous action come together, there are prosperity, victory, glory and firm righteousness.',
  meaningGujarati:
      'જ્યાં ભગવાનનું માર્ગદર્શન અને ધર્મપૂર્ણ કર્મ સાથે હોય ત્યાં સમૃદ્ધિ, વિજય, વૈભવ અને અડગ ધર્મની સ્થાપના થાય છે.',
),
  ];
  }


  // BHAGAVAD GITA CHAPTER DESCRIPTIONS - ENGLISH
  // =====================================================

  static const List<String> _gitaChapterDescriptionsEnglish = [
  'Arjuna faces inner conflict and surrenders to Krishna for guidance.',
  'Krishna explains the eternal self and the wisdom of balanced action.',
  'The path of selfless duty is revealed as sacred discipline.',
  'Knowledge and right action are united through devotion and discernment.',
  'Renunciation is understood as freedom from attachment, not from duty.',
  'Mind mastery, meditation, and disciplined living are emphasized.',
  'Krishna reveals His supreme nature and the way of loving devotion.',
  'The chapter explores remembrance of the Divine at life and death.',
  'The kingly secret of devotion and divine grace is explained.',
  'Krishna describes His divine manifestations in all creation.',
  'Arjuna beholds the universal cosmic form of Krishna.',
  'Pure devotion is presented as the easiest and highest path.',
  'Body and knower of body are distinguished through spiritual wisdom.',
  'The three gunas and their influence on human behavior are described.',
  'The supreme person beyond the changing world is revealed.',
  'Divine and demonic tendencies are compared for self-reflection.',
  'Faith and worship are explained according to one\'s inner nature.',
  'Final liberation through surrender, wisdom, and duty is concluded.',
];

  // =====================================================
  // BHAGAVAD GITA CHAPTER DESCRIPTIONS - GUJARATI
  // =====================================================

  static const List<String> _gitaChapterDescriptionsGujarati = [
  'અર્જુનના મનના સંઘર્ષમાં શ્રીકૃષ્ણનો શરણાગતિ માર્ગ શરૂ થાય છે.',
  'શ્રીકૃષ્ણ આત્માની નિત્યતા અને સમત્વયુક્ત કર્મનું જ્ઞાન આપે છે.',
  'નિષ્કામ કર્મને પવિત્ર સાધના રૂપે સમજાવવામાં આવે છે.',
  'જ્ઞાન અને કર્તવ્યને ભક્તિ સાથે જોડવાનો માર્ગ બતાવવામાં આવે છે.',
  'ત્યાગનો સાચો અર્થ આસક્તિ છોડવો છે, કર્તવ્ય નહીં.',
  'મનનિયંત્રણ અને ધ્યાનયોગના નિયમો સમજાવવામાં આવે છે.',
  'શ્રીકૃષ્ણ પોતાની પરમ સત્તા અને ભક્તિમાર્ગ દર્શાવે છે.',
  'અંતિમ ક્ષણમાં દિવ્ય સ્મરણનું મહત્ત્વ સમજાવવામાં આવે છે.',
  'રાજવિધ્યા અને ભક્તિનું રહસ્યમય જ્ઞાન અહીં દર્શાવાયું છે.',
  'સૃષ્ટિમાં વ્યાપેલી દિવ્ય વિભૂતિઓનું વર્ણન થાય છે.',
  'અર્જુન શ્રીકૃષ્ણના વિશ્વરૂપનું દર્શન કરે છે.',
  'સહજ અને શ્રેષ્ઠ ભક્તિમાર્ગનું મહત્ત્વ સમજાવવામાં આવે છે.',
  'ક્ષેત્ર અને ક્ષેત્રજ્ઞનું તત્ત્વજ્ઞાન અહીં રજૂ થાય છે.',
  'ત્રણ ગુણો અને જીવન પર તેમનો પ્રભાવ સમજાવવામાં આવ્યો છે.',
  'પરમ પુરુષોત્તમ તત્વનું ગહન રહસ્ય ખુલ્લું પડે છે.',
  'દૈવી અને આસુરી સ્વભાવના ભેદથી આત્મવિચારનો માર્ગ મળે છે.',
  'શ્રદ્ધા, આહાર અને ઉપાસના વિષે સ્વભાવ અનુસાર સમજ મળે છે.',
  'જ્ઞાન, ભક્તિ અને સમર્પણથી મોક્ષનો અંતિમ ઉપદેશ આપવામાં આવ્યો છે.',
];

  // =====================================================
  // GITA VERSE THEMES
  // =====================================================

  static const List<String> _gitaVerseThemes = [
    'Dharma',
    'Selfless Action',
    'Inner Discipline',
    'Devotion',
    'Steady Wisdom',
    'Compassion',
    'Detachment',
    'Surrender',
    'Meditation',
    'Truthful Living',
  ];

  // =====================================================
  // RAMAYANA
  // =====================================================

  static SacredBookModel _buildRamayanaBook() {
    return SacredBookModel(
      id: 'ramayana',
      title: 'Ramayana',
      subtitle: 'The Divine Journey of Lord Rama',
      iconEmoji: '🏹',
      totalChapters: 7,
      chapters: List.generate(7, (index) {
        final chapterNumber = index + 1;
        final kandaTitle = _ramayanaKandaTitle(chapterNumber);

        return SacredChapterModel(
          chapterNumber: chapterNumber,
          title: kandaTitle,
          subtitle: 'Ramayana Kanda $chapterNumber',
          descriptionEnglish:
              'This section presents the key journey of $kandaTitle with its moral teachings on duty, devotion, courage, and compassion.',
          descriptionGujarati:
              '${_ramayanaKandaTitleGujarati(chapterNumber)} માં ધર્મ, ભક્તિ, શૌર્ય અને કરુણાના જીવનમૂલ્યો સાથે શ્રીરામની પવિત્ર યાત્રા વર્ણવાઈ છે.',
          verses: List.generate(12, (verseIndex) {
            final verseNumber = verseIndex + 1;

            final storyline = _ramayanaThemes[
                (chapterNumber + verseIndex) % _ramayanaThemes.length];

            return SacredVerseModel(
              verseNumber: verseNumber,
              sanskrit:
                  'काण्ड $chapterNumber श्लोक $verseNumber - $storyline',
              english: 
                  'In $kandaTitle, verse $verseNumber reflects on $storyline and reminds us that dharma must guide every decision.',
              gujarati:
                  '$kandaTitle ના શ્લોક $verseNumber માં $storyline નો ઉપદેશ છે અને સમજાવે છે કે દરેક નિર્ણયમાં ધર્મ માર્ગદર્શક હોવો જોઈએ.',
              meaningEnglish:
                  'The Ramayana teaches that righteousness, patience, and devotion transform hardship into spiritual strength.',
              meaningGujarati:
                  'રામાયણ શીખવે છે કે સત્ય, ધૈર્ય અને ભક્તિથી મુશ્કેલી પણ આધ્યાત્મિક શક્તિમાં પરિવર્તિત થાય છે.',
            );
          }),
        );
      }),
    );
  }
  

  // =====================================================
  // FIND BOOK
  // =====================================================

  static SacredBookModel? findById(String id) {
    try {
      return all.firstWhere(
        (book) => book.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // RAMAYANA KANDA TITLES
  // =====================================================

  static String _ramayanaKandaTitle(int chapterNumber) {
    const titles = [
      'Bala Kanda',
      'Ayodhya Kanda',
      'Aranya Kanda',
      'Kishkindha Kanda',
      'Sundara Kanda',
      'Yuddha Kanda',
      'Uttara Kanda',
    ];

    return titles[chapterNumber - 1];
  }

  static String _ramayanaKandaTitleGujarati(int chapterNumber) {
    const titles = [
      'બાલ કાંડ',
      'અયોધ્યા કાંડ',
      'અરણ્ય કાંડ',
      'કિષ્કિંધા કાંડ',
      'સુંદર કાંડ',
      'યુદ્ધ કાંડ',
      'ઉત્તર કાંડ',
    ];

    return titles[chapterNumber - 1];
  }

  static const List<String> _ramayanaThemes = [
    'Rama\'s obedience',
    'Sita\'s devotion',
    'Lakshmana\'s service',
    'Hanuman\'s courage',
    'Sugriva alliance',
    'Search for Sita',
    'Battle for righteousness',
    'Return to Ayodhya',
    'Compassion in leadership',
    'Victory of dharma',
  ];
}