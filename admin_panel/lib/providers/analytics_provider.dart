import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/activity_log_admin_model.dart';
import '../services/activity_logs_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<ActivityLogAdminModel>>? _subscription;

  List<ActivityLogAdminModel> _activityLogs = [];
  bool _isLoading = true;
  String? _errorMessage;

  AnalyticsProvider() {
    _init();
  }

  List<ActivityLogAdminModel> get activityLogs => _activityLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _subscription = _logsService.streamActivityLogs(limit: 100).listen(
      (data) {
        _activityLogs = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load activity logs: $err';
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
