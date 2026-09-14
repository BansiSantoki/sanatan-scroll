import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user_admin_model.dart';
import '../services/users_service.dart';
import '../services/activity_logs_service.dart';

class UsersProvider extends ChangeNotifier {
  final UsersService _usersService = UsersService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<UserAdminModel>>? _subscription;

  List<UserAdminModel> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  UserAdminModel? _selectedUserDetail;

  UsersProvider() {
    _init();
  }

  List<UserAdminModel> get users {
    if (_searchQuery.isEmpty) return _users;
    final q = _searchQuery.toLowerCase();
    return _users.where((u) {
      return u.email.toLowerCase().contains(q) ||
          (u.displayName?.toLowerCase().contains(q) ?? false) ||
          u.uid.toLowerCase().contains(q);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  UserAdminModel? get selectedUserDetail => _selectedUserDetail;
  int get totalUsers => _users.length;

  void _init() {
    _subscription = _usersService.streamUsers().listen(
      (data) {
        _users = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load users: $err';
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchUserDetail(String uid) async {
    _isLoading = true;
    notifyListeners();

    _selectedUserDetail = await _usersService.getUserDetails(uid);
    _isLoading = false;
    notifyListeners();
  }

  void clearUserDetail() {
    _selectedUserDetail = null;
    notifyListeners();
  }

  Future<bool> updateUserRole(String uid, String newRole) async {
    try {
      await _usersService.updateUserRole(uid, newRole);
      await _logsService.logAction(
        action: 'Updated User Role',
        target: 'UID: $uid',
        details: 'New Role: $newRole',
      );
      if (_selectedUserDetail?.uid == uid) {
        await fetchUserDetail(uid);
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update user role: $e';
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
