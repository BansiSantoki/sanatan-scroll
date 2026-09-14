import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/activity_log_admin_model.dart';

class ActivityLogsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('admin_activity_logs');

  Stream<List<ActivityLogAdminModel>> streamActivityLogs({int limit = 50}) {
    return _collection
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActivityLogAdminModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> logAction({
    required String action,
    required String target,
    String? details,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docRef = _collection.doc();
      final model = ActivityLogAdminModel(
        id: docRef.id,
        adminUid: user.uid,
        adminEmail: user.email ?? 'Unknown Admin',
        action: action,
        target: target,
        timestamp: DateTime.now(),
        details: details,
      );

      await docRef.set(model.toMap());
    } catch (_) {}
  }
}
