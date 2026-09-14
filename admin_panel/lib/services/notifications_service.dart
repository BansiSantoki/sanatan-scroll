import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_admin_model.dart';

class NotificationsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('notifications');

  Stream<List<NotificationAdminModel>> streamNotifications() {
    return _collection.snapshots().map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return NotificationAdminModel.fromMap(doc.id, doc.data());
      }).toList();
      list.sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
      return list;
    });
  }

  Future<void> sendNotification(NotificationAdminModel notification) async {
    final docRef = _collection.doc();
    final model = NotificationAdminModel(
      id: docRef.id,
      title: notification.title,
      message: notification.message,
      targetAudience: notification.targetAudience,
      status: notification.status,
      createdAt: DateTime.now(),
      scheduledAt: notification.scheduledAt,
    );
    await docRef.set(model.toMap());
  }

  Future<void> deleteNotification(String id) async {
    await _collection.doc(id).delete();
  }
}
