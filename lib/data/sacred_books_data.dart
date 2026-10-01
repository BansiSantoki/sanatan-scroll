import '../models/sacred_book_model.dart';
import '../models/sacred_chapter_model.dart';
import 'bhagavad_gita_data.dart';
import 'upanishads_data.dart';

class SacredBooksData {
  SacredBooksData._();

  static final List<SacredBookModel> all = [
    _buildGitaBook(),
    _buildRamayanaBook(),
    // Mahabharata intentionally omitted from fallback list per owner's request
    ..._additionalBookIds.map(_buildAdditionalBook),
  ];

  static const Map<String, String> _additionalBookTitles = {
    'upanishads': 'Upanishads',
  };

  static final List<String> _additionalBookIds =
      _additionalBookTitles.keys.toList(growable: false);

  static SacredBookModel _buildAdditionalBook(String id) {
    if (id == 'upanishads') {
      return UpanishadsData.buildUpanishadsBook();
    }

    final title = _additionalBookTitles[id]!;
    final chapterCount = switch (id) {
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
          verses: const [],
        );
      }),
    );
  }

  // =====================================================
  // BHAGAVAD GITA
  // =====================================================

  static SacredBookModel _buildGitaBook() {
    return BhagavadGitaData.buildGitaBook();
  }

  // =====================================================
  // RAMAYANA
  // =====================================================

  static SacredBookModel _buildRamayanaBook() {
    return SacredBookModel(
      id: 'ramayana',
      title: 'Ramayana',
      subtitle: 'The Epic of Duty',
      iconEmoji: '🏹',
      totalChapters: 7,
      chapters: [
        SacredChapterModel(
          chapterNumber: 1,
          title: 'Bala Kanda',
          subtitle: 'The Book of Childhood',
          titleEn: 'Bala Kanda',
          titleHi: 'बाल काण्ड',
          titleGu: 'બાળ કાંડ',
          subtitleEn: 'The Book of Childhood',
          subtitleHi: 'बाल्यकाल की कथा',
          subtitleGu: 'બાળપણની કથા',
          descriptionEnglish: 'The birth of Lord Rama, his early life, training, and marriage to Sita.',
          descriptionHindi: 'श्रीराम का जन्म, बाल्यकाल, शिक्षा और सीताजी से विवाह की कथा।',
          descriptionGujarati: 'શ્રીરામનો જન્મ, બાળપણ, શિક્ષણ અને સીતાજી સાથે વિવાહની કથા.',
          verses: const [],
        ),
        SacredChapterModel(
          chapterNumber: 2,
          title: 'Ayodhya Kanda',
          subtitle: 'The Book of Ayodhya',
          titleEn: 'Ayodhya Kanda',
          titleHi: 'अयोध्या काण्ड',
          titleGu: 'અયોધ્યા કાંડ',
          subtitleEn: 'The Book of Ayodhya',
          subtitleHi: 'अयोध्या की कथा',
          subtitleGu: 'અયોધ્યાની કથા',
          descriptionEnglish: 'Preparations for Rama’s coronation, Kaikeyi’s boons, and Rama’s departure into exile.',
          descriptionHindi: 'श्रीराम के राज्याभिषेक की तैयारी, कैकेयी के वरदान और श्रीराम का वनगमन।',
          descriptionGujarati: 'શ્રીરામના રાજ્યાભિષેકની તૈયારી, કૈકેયીના વરદાન અને શ્રીરામનું વનગમન.',
          verses: const [],
        ),
        SacredChapterModel(
          chapterNumber: 3,
          title: 'Aranya Kanda',
          subtitle: 'The Book of the Forest',
          titleEn: 'Aranya Kanda',
          titleHi: 'अरण्य काण्ड',
          titleGu: 'અરણ્ય કાંડ',
          subtitleEn: 'The Book of the Forest',
          subtitleHi: 'वनवास की कथा',
          subtitleGu: 'વનવાસની કથા',
          descriptionEnglish: 'Life in the forest, encounters with sages, Surpanakha, and Sita’s abduction by Ravana.',
          descriptionHindi: 'ऋषियों के साथ वनवास जीवन, शूर्पणखा प्रसंग और रावण द्वारा सीता हरण।',
          descriptionGujarati: 'ઋષિઓ સાથે વનવાસ જીવન, શૂર્પણખા પ્રસંગ અને રાવણ દ્વારા સીતા હરણ.',
          verses: const [],
        ),
        SacredChapterModel(
          chapterNumber: 4,
          title: 'Kishkindha Kanda',
          subtitle: 'The Book of Kishkindha',
          titleEn: 'Kishkindha Kanda',
          titleHi: 'किष्किन्धा काण्ड',
          titleGu: 'કિષ્કિંધા કાંડ',
          subtitleEn: 'The Book of Kishkindha',
          subtitleHi: 'सुग्रीव और हनुमान मिलन',
          subtitleGu: 'સુગ્રીવ અને હનુમાન મિલન',
          descriptionEnglish: 'Alliance with Sugriva, meeting Hanuman, the slaying of Vali, and search for Sita.',
          descriptionHindi: 'सुग्रीव से मित्रता, हनुमान जी से मिलन, बालि वध और सीता की खोज।',
          descriptionGujarati: 'સુગ્રીવ સાથે મિત્રતા, હનુમાનજી સાથે મિલન, બાલિ વધ અને સીતાની શોધ.',
          verses: const [],
        ),
        SacredChapterModel(
          chapterNumber: 5,
          title: 'Sundara Kanda',
          subtitle: 'The Book of Beauty',
          titleEn: 'Sundara Kanda',
          titleHi: 'सुन्दर काण्ड',
          titleGu: 'સુંદર કાંડ',
          subtitleEn: 'The Book of Beauty',
          subtitleHi: 'हनुमान जी की लंका यात्रा',
          subtitleGu: 'હનુમાનજીની લંકા યાત્રા',
          descriptionEnglish: 'Hanuman’s heroic leap across the ocean, locating Sita in Ashoka Vatika, and burning of Lanka.',
          descriptionHindi: 'हनुमान जी का समुद्र लांघना, अशोक वाटिका में सीता खोज और लंका दहन।',
          descriptionGujarati: 'હનુમાનજીનું સમુદ્ર લંઘન, અશોક વાટિકામાં સીતા શોધ અને લંકા દહન.',
          verses: const [],
        ),
        SacredChapterModel(
          chapterNumber: 6,
          title: 'Yuddha Kanda',
          subtitle: 'The Book of War',
          titleEn: 'Yuddha Kanda',
          titleHi: 'युद्ध काण्ड',
          titleGu: 'યુદ્ધ કાંડ',
          subtitleEn: 'The Book of War',
          subtitleHi: 'लंका युद्ध और विजय',
          subtitleGu: 'લંકા યુદ્ધ અને વિજય',
          descriptionEnglish: 'Building the Ram Setu, the great war between Rama’s army and Ravana, slaying of Ravana.',
          descriptionHindi: 'राम सेतु निर्माण, श्रीराम की सेना और रावण के बीच महायुद्ध तथा रावण वध।',
          descriptionGujarati: 'રામ સેતુ નિર્માણ, શ્રીરામની સેના અને રાવણ વચ્ચે મહાયુદ્ધ તથા રાવણ વધ.',
          verses: const [],
        ),
        SacredChapterModel(
          chapterNumber: 7,
          title: 'Uttara Kanda',
          subtitle: 'The Final Book',
          titleEn: 'Uttara Kanda',
          titleHi: 'उत्तर काण्ड',
          titleGu: 'ઉત્તર કાંડ',
          subtitleEn: 'The Final Book',
          subtitleHi: 'उत्तर गाथा और राम राज्य',
          subtitleGu: 'ઉત્તર ગાથા અને રામ રાજ્ય',
          descriptionEnglish: 'Return to Ayodhya, coronation of Lord Rama, establishment of Ram Rajya, and final journey.',
          descriptionHindi: 'अयोध्या वापसी, श्रीराम का राज्याभिषेक, राम राज्य की स्थापना और महाप्रस्थान।',
          descriptionGujarati: 'અયોધ્યા વાપસી, શ્રીરામનો રાજ્યાભિષેક, રામ રાજ્યની સ્થાપના અને મહાપ્રસ્થાન.',
          verses: const [],
        ),
      ],
    );
  }

  // =====================================================
  // FIND BOOK
  // =====================================================

  static SacredBookModel? findById(String id) {
    final normalizedId = (id == 'gita') ? 'bhagavad_gita' : id;
    try {
      return all.firstWhere(
        (book) => book.id == normalizedId || book.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}