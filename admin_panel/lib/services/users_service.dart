import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_admin_model.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Stream<List<UserAdminModel>> streamUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserAdminModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<UserAdminModel?> getUserDetails(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;

    final data = doc.data()!;
    int savedCount = 0;
    int currentStreak = 0;
    int totalStreakDays = 0;
    int completedChapters = 0;

    try {
      final savedSnap = await _usersCollection.doc(uid).collection('saved_items').get();
      savedCount = savedSnap.docs.length;
    } catch (_) {}

    try {
      final streakDoc = await _usersCollection.doc(uid).collection('streak').doc('current').get();
      if (streakDoc.exists && streakDoc.data() != null) {
        currentStreak = (streakDoc.data()!['currentStreak'] as num?)?.toInt() ?? 0;
        totalStreakDays = (streakDoc.data()!['totalDays'] as num?)?.toInt() ?? 0;
      }
    } catch (_) {}

    try {
      final completedSnap = await _usersCollection.doc(uid).collection('completed_chapters').get();
      completedChapters = completedSnap.docs.length;
    } catch (_) {}

    final mergedData = Map<String, dynamic>.from(data)
      ..['savedItemsCount'] = savedCount
      ..['currentStreak'] = currentStreak
      ..['totalStreakDays'] = totalStreakDays
      ..['completedChaptersCount'] = completedChapters;

    return UserAdminModel.fromMap(uid, mergedData);
  }

  Future<void> updateUserRole(String uid, String newRole) async {
    await _usersCollection.doc(uid).update({
      'role': newRole,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
