import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_reading_admin_model.dart';

class DailyReadingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('daily_readings');

  Stream<List<DailyReadingAdminModel>> streamDailyReadings() {
    return _collection.snapshots().map((snapshot) {
      final readings = snapshot.docs.map((doc) {
        return DailyReadingAdminModel.fromMap(doc.id, doc.data());
      }).toList();
      readings.sort((a, b) => b.dateString.compareTo(a.dateString));
      return readings;
    });
  }

  Future<void> saveDailyReading(DailyReadingAdminModel reading) async {
    final docId = reading.id.isNotEmpty ? reading.id : reading.dateString;
    await _collection.doc(docId).set(
          reading.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> setPublishedStatus(String docId, bool published) async {
    await _collection.doc(docId).update({
      'published': published,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDailyReading(String docId) async {
    await _collection.doc(docId).delete();
  }
}
