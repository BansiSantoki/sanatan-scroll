import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class UserAdminModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String signInProvider;
  final String role;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  // Subcollection counts/meta
  final int savedItemsCount;
  final int currentStreak;
  final int totalStreakDays;
  final int completedChaptersCount;

  const UserAdminModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.signInProvider,
    this.role = 'user',
    this.createdAt,
    this.lastLoginAt,
    this.savedItemsCount = 0,
    this.currentStreak = 0,
    this.totalStreakDays = 0,
    this.completedChaptersCount = 0,
  });

  factory UserAdminModel.fromMap(String uid, Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return UserAdminModel(
      uid: uid,
      email: (map['email'] ?? '').toString(),
      displayName: map['displayName']?.toString(),
      photoURL: map['photoURL']?.toString(),
      signInProvider: (map['signInProvider'] ?? 'firebase').toString(),
      role: (map['role'] ?? 'user').toString(),
      createdAt: parseDate(map['createdAt']),
      lastLoginAt: parseDate(map['lastLoginAt']),
      savedItemsCount: _asInt(map['savedItemsCount'], fallback: 0),
      currentStreak: _asInt(map['currentStreak'], fallback: 0),
      totalStreakDays: _asInt(map['totalStreakDays'], fallback: 0),
      completedChaptersCount: _asInt(map['completedChaptersCount'], fallback: 0),
    );
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
