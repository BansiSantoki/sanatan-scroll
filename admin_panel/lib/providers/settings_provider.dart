import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_settings_admin_model.dart';
import '../services/settings_service.dart';
import '../services/activity_logs_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<AppSettingsAdminModel>? _subscription;

  AppSettingsAdminModel _settings = const AppSettingsAdminModel(
    featuredBookId: 'bhagavad_gita',
    maintenanceMode: false,
    dailyReadingEnabled: true,
    supportedLanguages: ['en', 'gu', 'hi'],
  );
  bool _isLoading = true;
  String? _errorMessage;

  SettingsProvider() {
    _init();
  }

  AppSettingsAdminModel get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _subscription = _service.streamSettings().listen(
      (data) {
        _settings = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load app settings: $err';
        notifyListeners();
      },
    );
  }

  Future<bool> saveSettings(AppSettingsAdminModel newSettings) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _service.saveSettings(newSettings);
      await _logsService.logAction(
        action: 'Updated Global App Settings',
        target: 'app_settings/global',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save settings: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
