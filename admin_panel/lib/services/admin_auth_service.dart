import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminAuthResult {
  final User? user;
  final bool isAdmin;
  final String? errorMessage;

  const AdminAuthResult({
    this.user,
    required this.isAdmin,
    this.errorMessage,
  });
}

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> checkIsAdmin(User user) async {
    try {
      // 1. Check Custom Claims
      final idTokenResult = await user.getIdTokenResult(true);
      if (idTokenResult.claims?['admin'] == true) {
        return true;
      }

      // 2. Fallback check in Firestore user document
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        final role = data['role']?.toString().toLowerCase();
        final isAdminFlag = data['isAdmin'] == true;
        if (role == 'admin' || isAdminFlag) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying admin authorization: $e');
      }
      return false;
    }
  }

  Future<AdminAuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return const AdminAuthResult(
          isAdmin: false,
          errorMessage: 'Authentication failed. User is null.',
        );
      }

      final isAdmin = await checkIsAdmin(user);
      if (!isAdmin) {
        await _auth.signOut();
        return const AdminAuthResult(
          isAdmin: false,
          errorMessage: 'Access Denied: Account does not have administrator privileges.',
        );
      }

      return AdminAuthResult(user: user, isAdmin: true);
    } on FirebaseAuthException catch (e) {
      return AdminAuthResult(
        isAdmin: false,
        errorMessage: _mapAuthError(e),
      );
    } catch (e) {
      return AdminAuthResult(
        isAdmin: false,
        errorMessage: 'Sign-in failed: $e',
      );
    }
  }

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'Failed to send reset email: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This admin account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }
}
