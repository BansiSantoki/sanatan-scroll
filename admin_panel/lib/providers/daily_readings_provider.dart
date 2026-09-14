import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/daily_reading_admin_model.dart';
import '../services/daily_readings_service.dart';
import '../services/activity_logs_service.dart';

class DailyReadingsProvider extends ChangeNotifier {
  final DailyReadingsService _service = DailyReadingsService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<DailyReadingAdminModel>>? _subscription;

  List<DailyReadingAdminModel> _readings = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  DailyReadingsProvider() {
    _init();
  }

  List<DailyReadingAdminModel> get readings {
    if (_searchQuery.isEmpty) return _readings;
    final q = _searchQuery.toLowerCase();
    return _readings.where((r) {
      return r.dateString.contains(q) ||
          r.title.toLowerCase().contains(q) ||
          r.bookId.toLowerCase().contains(q);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  void _init() {
    _subscription = _service.streamDailyReadings().listen(
      (data) {
        _readings = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load daily readings: $err';
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> saveDailyReading(DailyReadingAdminModel reading) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _service.saveDailyReading(reading);
      await _logsService.logAction(
        action: 'Saved Daily Reading',
        target: 'Date: ${reading.dateString}',
        details: 'Title: ${reading.title}',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving daily reading: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> togglePublishStatus(String docId, bool currentStatus) async {
    try {
      final newStatus = !currentStatus;
      await _service.setPublishedStatus(docId, newStatus);
      await _logsService.logAction(
        action: newStatus ? 'Published Daily Reading' : 'Unpublished Daily Reading',
        target: 'ID: $docId',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update publish status: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteDailyReading(String docId) async {
    try {
      await _service.deleteDailyReading(docId);
      await _logsService.logAction(
        action: 'Deleted Daily Reading',
        target: 'ID: $docId',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete daily reading: $e';
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
