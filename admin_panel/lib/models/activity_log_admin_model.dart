import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class ActivityLogAdminModel {
  final String id;
  final String adminUid;
  final String adminEmail;
  final String action; // e.g. "Updated Book", "Published Verse"
  final String target; // e.g. "Bhagavad Gita", "Chapter 1"
  final DateTime timestamp;
  final String? details;

  const ActivityLogAdminModel({
    required this.id,
    required this.adminUid,
    required this.adminEmail,
    required this.action,
    required this.target,
    required this.timestamp,
    this.details,
  });

  factory ActivityLogAdminModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return ActivityLogAdminModel(
      id: id,
      adminUid: (map['adminUid'] ?? '').toString(),
      adminEmail: (map['adminEmail'] ?? '').toString(),
      action: (map['action'] ?? '').toString(),
      target: (map['target'] ?? '').toString(),
      timestamp: parseDate(map['timestamp']),
      details: map['details']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adminUid': adminUid,
      'adminEmail': adminEmail,
      'action': action,
      'target': target,
      'timestamp': Timestamp.fromDate(timestamp),
      'details': details,
    };
  }
}
