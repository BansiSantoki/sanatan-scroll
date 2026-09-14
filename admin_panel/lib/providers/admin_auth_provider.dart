import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/admin_auth_service.dart';

class AdminAuthProvider extends ChangeNotifier {
  final AdminAuthService _authService = AdminAuthService();
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  bool _isAdmin = false;
  bool _isLoading = true;
  String? _errorMessage;

  AdminAuthProvider() {
    _init();
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null && _isAdmin;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _authSubscription = _authService.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        _isAdmin = await _authService.checkIsAdmin(user);
        if (!_isAdmin) {
          _errorMessage = 'Access Denied: Account lacks administrator permissions.';
        } else {
          _errorMessage = null;
        }
      } else {
        _isAdmin = false;
        _errorMessage = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.signInWithEmail(email: email, password: password);
    _user = result.user;
    _isAdmin = result.isAdmin;
    _errorMessage = result.errorMessage;
    _isLoading = false;
    notifyListeners();

    return result.isAdmin;
  }

  Future<String?> sendPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();

    final error = await _authService.sendPasswordReset(email);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _user = null;
    _isAdmin = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
