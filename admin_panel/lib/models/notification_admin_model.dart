import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp, FieldValue;

class NotificationAdminModel {
  final String id;
  final String title;
  final String message;
  final String targetAudience; // all, active, registered
  final String status; // sent, scheduled, draft
  final DateTime? createdAt;
  final DateTime? scheduledAt;

  const NotificationAdminModel({
    required this.id,
    required this.title,
    required this.message,
    this.targetAudience = 'all',
    this.status = 'sent',
    this.createdAt,
    this.scheduledAt,
  });

  factory NotificationAdminModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return NotificationAdminModel(
      id: id,
      title: (map['title'] ?? '').toString(),
      message: (map['message'] ?? '').toString(),
      targetAudience: (map['targetAudience'] ?? 'all').toString(),
      status: (map['status'] ?? 'sent').toString(),
      createdAt: parseDate(map['createdAt']),
      scheduledAt: parseDate(map['scheduledAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'targetAudience': targetAudience,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'scheduledAt': scheduledAt != null ? Timestamp.fromDate(scheduledAt!) : null,
    };
  }
}
