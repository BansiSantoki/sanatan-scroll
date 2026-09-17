import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp, FieldValue;

class AppSettingsAdminModel {
  final String featuredBookId;
  final bool maintenanceMode;
  final bool dailyReadingEnabled;
  final List<String> supportedLanguages;
  final DateTime? updatedAt;

  const AppSettingsAdminModel({
    required this.featuredBookId,
    required this.maintenanceMode,
    required this.dailyReadingEnabled,
    required this.supportedLanguages,
    this.updatedAt,
  }); 

  factory AppSettingsAdminModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    final rawLangs = map['supportedLanguages'];
    final langs = rawLangs is List
        ? rawLangs.map((e) => e.toString()).toList()
        : <String>['en', 'gu', 'hi'];

    return AppSettingsAdminModel(
      featuredBookId: (map['featuredBookId'] ?? 'bhagavad_gita').toString(),
      maintenanceMode: map['maintenanceMode'] as bool? ?? false,
      dailyReadingEnabled: map['dailyReadingEnabled'] as bool? ?? true,
      supportedLanguages: langs,
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'featuredBookId': featuredBookId,
      'maintenanceMode': maintenanceMode,
      'dailyReadingEnabled': dailyReadingEnabled,
      'supportedLanguages': supportedLanguages,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
