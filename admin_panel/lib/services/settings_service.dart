import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_settings_admin_model.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _settingsDoc =>
      _firestore.collection('app_settings').doc('global');

  Stream<AppSettingsAdminModel> streamSettings() {
    return _settingsDoc.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return const AppSettingsAdminModel(
          featuredBookId: 'bhagavad_gita',
          maintenanceMode: false,
          dailyReadingEnabled: true,
          supportedLanguages: ['en', 'gu', 'hi'],
        );
      }
      return AppSettingsAdminModel.fromMap(snapshot.data()!);
    });
  }

  Future<void> saveSettings(AppSettingsAdminModel settings) async {
    await _settingsDoc.set(settings.toMap(), SetOptions(merge: true));
  }
}
