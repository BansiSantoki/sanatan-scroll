import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wisdom_model.dart';
import 'mock_wisdom_data.dart';

class DailyReadingsRepository {
  DailyReadingsRepository._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<WisdomModel> streamDailyWisdom() {
    return _firestore
        .collection('daily_readings')
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs
          .where((doc) => doc.data()['published'] != false)
          .toList();

      if (docs.isEmpty) {
        return MockWisdomData.dailyWisdom;
      }

      docs.sort((a, b) {
        final dateA = (a.data()['dateString'] ?? a.data()['date'] ?? '').toString();
        final dateB = (b.data()['dateString'] ?? b.data()['date'] ?? '').toString();
        return dateB.compareTo(dateA);
      });

      final data = docs.first.data();
      final title = (data['title'] ?? 'Daily Wisdom').toString();
      final description = (data['description'] ?? '').toString();
      final bookId = (data['bookId'] ?? 'bhagavad_gita').toString();
      final chapterNumber = _asInt(data['chapterNumber'], fallback: 1);
      final verseNumber = _asInt(data['verseNumber'], fallback: 1);

      return WisdomModel(
        id: docs.first.id,
        quote: description.isNotEmpty ? description : MockWisdomData.dailyWisdom.quote,
        source: _formatBookTitle(bookId),
        chapter: 'Chapter $chapterNumber',
        verse: 'Verse $verseNumber',
        sanskrit: data['sanskrit']?.toString() ?? 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।',
        reflection: title.isNotEmpty ? title : 'Daily Reflection',
        sageAdvice: 'surrender the results to the Divine. This is the path to inner peace.',
        tags: const ['#WisdomReflection', '#DailyWisdom'],
      );
    });
  }

  static String _formatBookTitle(String id) {
    if (id == 'bhagavad_gita') return 'Bhagavad Gita';
    if (id == 'ramayana') return 'Ramayana';
    if (id == 'upanishads') return 'Upanishads';
    if (id == 'mahabharata') return 'Mahabharata';
    return id.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }

  static int _asInt(dynamic val, {required int fallback}) {
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? fallback;
    return fallback;
  }
}
