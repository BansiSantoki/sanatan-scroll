import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSubscription;

  bool _isLoading = false;

  AuthProvider() {
    _authSubscription = _auth.authStateChanges().listen(
      _handleAuthState,
      onError: (Object error) {
        debugPrint('Auth state error: $error');
      },
    );
  }

  // ============================================================
  // AUTH STATE
  // ============================================================

  Future<void> _handleAuthState(User? user) async {
    if (user != null) {
      await _syncUserProfile(user);
    }

    notifyListeners();
  }

  // ============================================================
  // FIRESTORE USER PROFILE
  // ============================================================

  Future<void> _syncUserProfile(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);

      final existingUser = await userRef.get();

      final data = <String, dynamic>{
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'signInProvider': user.providerData.isEmpty
            ? 'firebase'
            : user.providerData.first.providerId,
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      // createdAt માત્ર પ્રથમ વખત જ set થશે.
      if (!existingUser.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      await userRef.set(
        data,
        SetOptions(merge: true),
      );
    } catch (error) {
      debugPrint(
        'Unable to sync Firebase user profile: $error',
      );
    }
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get user => _auth.currentUser;

  bool get isAuthenticated => _auth.currentUser != null;

  // ============================================================
  // USER DATA
  // ============================================================

  String get userName {
    final name = _auth.currentUser?.displayName;

    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }

    final email = _auth.currentUser?.email;

    if (email != null && email.trim().isNotEmpty) {
      return email.split('@').first;
    }

    return 'Seeker';
  }

  String get firstName {
    final fullName = userName.trim();

    if (fullName.isEmpty) {
      return 'Seeker';
    }

    return fullName.split(' ').first;
  }

  String get userEmail {
    return _auth.currentUser?.email ?? '';
  }

  String? get userPhotoUrl {
    return _auth.currentUser?.photoURL;
  }

  String get userId {
    return _auth.currentUser?.uid ?? '';
  }

  // ============================================================
  // LOADING
  // ============================================================

  bool get isLoading => _isLoading;

  bool get isGoogleLoading => _isLoading;

  bool get isAppleLoading => false;

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }

  // ============================================================
  // EMAIL / PASSWORD SIGN UP
  // ============================================================

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthError(e);
    } catch (e) {
      return 'Something went wrong during sign up: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // EMAIL / PASSWORD SIGN IN
  // ============================================================

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthError(e);
    } catch (e) {
      return 'Something went wrong during sign in: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // GOOGLE SIGN IN
  // ============================================================

  Future<String?> signInWithGoogle() async {
    try {
      _setLoading(true);

      // Existing Google session clear કરવી જરૂરી નથી.
      // Directly account picker open થશે.
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        return 'Google Sign-In cancelled';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        return 'Google Sign-In failed: Google ID token was not returned.';
      }

      final AuthCredential credential =
          GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      await _auth.signInWithCredential(credential);

      final firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        await _syncUserProfile(firebaseUser);
      }

      notifyListeners();

      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthError(e);
    } catch (e) {
      final message = e.toString();

      if (message.contains('ApiException: 10')) {
        return 'Google Sign-In configuration error (ApiException: 10). '
            'Please check the Android package name and SHA-1 in Firebase.';
      }

      if (message.contains('sign_in_failed')) {
        return 'Google Sign-In failed. Please check Firebase Google '
            'Sign-In configuration and SHA-1 certificate.';
      }

      return 'Google Sign-In failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<String?> updateProfile({
    required String displayName,
    String? photoUrl,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return 'You must be signed in to edit your profile.';
    }

    try {
      _setLoading(true);

      final name = displayName.trim();

      if (name.isEmpty) {
        return 'Please enter your name.';
      }

      await currentUser.updateDisplayName(name);

      if (photoUrl != null && photoUrl.trim().isNotEmpty) {
        await currentUser.updatePhotoURL(
          photoUrl.trim(),
        );
      }

      await currentUser.reload();

      final updatedUser = _auth.currentUser;

      if (updatedUser != null) {
        await _syncUserProfile(updatedUser);
      }

      notifyListeners();

      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthError(e);
    } catch (e) {
      return 'Unable to update your profile: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> signOut() async {
    try {
      _setLoading(true);

      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        debugPrint(
          'Google sign out error: $e',
        );
      }

      await _auth.signOut();

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Sign out error: $e',
      );
    } finally {
      _setLoading(false);
    }
  }

  // Old logout method
  Future<void> logout() async {
    await signOut();
  }

  // ============================================================
  // FIREBASE AUTH ERROR HANDLER
  // ============================================================

  String _firebaseAuthError(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Please choose a stronger password.';

      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      default:
        return e.message ??
            'Authentication failed. Please try again.';
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;

    super.dispose();
  }
}