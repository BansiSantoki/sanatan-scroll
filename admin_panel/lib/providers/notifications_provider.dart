import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/notification_admin_model.dart';
import '../services/notifications_service.dart';
import '../services/activity_logs_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsService _service = NotificationsService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<NotificationAdminModel>>? _subscription;

  List<NotificationAdminModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  NotificationsProvider() {
    _init();
  }

  List<NotificationAdminModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _subscription = _service.streamNotifications().listen(
      (data) {
        _notifications = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load notifications: $err';
        notifyListeners();
      },
    );
  }

  Future<bool> sendNotification(NotificationAdminModel notification) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _service.sendNotification(notification);
      await _logsService.logAction(
        action: 'Sent Notification',
        target: notification.title,
        details: 'Audience: ${notification.targetAudience}',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to send notification: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      await _service.deleteNotification(id);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete notification: $e';
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
