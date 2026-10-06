import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../core/data/local_database.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSubscription;

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

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

  bool get isLoading => _isLoading || _isGoogleLoading || _isAppleLoading;

  bool get isGoogleLoading => _isGoogleLoading;

  bool get isAppleLoading => _isAppleLoading;

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
      _isGoogleLoading = true;
      notifyListeners();

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: defaultTargetPlatform == TargetPlatform.iOS
            ? '746323217658-g9kmvge3q4gnahcv41rotp7er6ndmih3.apps.googleusercontent.com'
            : null,
        serverClientId:
            '746323217658-0qfl1om1hk67vflkormno80seq38pvcr.apps.googleusercontent.com',
      );

      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await _syncUserProfile(firebaseUser);
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthError(e);
    } catch (e) {
      final message = e.toString();

      if (message.contains('sign_in_canceled') ||
          message.contains('canceled') ||
          message.contains('cancelled') ||
          message.contains('12501')) {
        return 'Google Sign-In cancelled';
      }

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
      _isGoogleLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // APPLE SIGN IN
  // ============================================================

  Future<String?> signInWithApple() async {
    try {
      _isAppleLoading = true;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] Starting Apple Sign-In flow...');
      }

      UserCredential? userCredential;

      // 1. Primary Flow: Firebase native AppleAuthProvider on iOS
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          if (kDebugMode) {
            debugPrint('[APPLE_AUTH_DEBUG] Attempting native Firebase AppleAuthProvider flow...');
          }
          final appleProvider = AppleAuthProvider();
          appleProvider.addScope('email');
          appleProvider.addScope('name');

          userCredential = await _auth.signInWithProvider(appleProvider);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'canceled' || e.code == 'user-cancelled' || e.code == '1001') {
            if (kDebugMode) debugPrint('[APPLE_AUTH_DEBUG] User cancelled Apple Sign-In.');
            return 'Apple Sign-In cancelled';
          }
          if (e.code == 'operation-not-allowed') {
            return _firebaseAuthError(e);
          }
          if (kDebugMode) {
            debugPrint('[APPLE_AUTH_DEBUG] signInWithProvider error: ${e.code} - ${e.message}. Trying getAppleIDCredential flow...');
          }
        } catch (e) {
          final msg = e.toString().toLowerCase();
          if (msg.contains('canceled') || msg.contains('cancelled') || msg.contains('1001')) {
            return 'Apple Sign-In cancelled';
          }
          if (kDebugMode) {
            debugPrint('[APPLE_AUTH_DEBUG] Native provider error: $e. Trying getAppleIDCredential flow...');
          }
        }
      }

      // 2. Secondary Flow: Manual nonce + SignInWithApple plugin
      if (userCredential == null || userCredential.user == null) {
        final rawNonce = _generateNonce();
        final sha256Nonce = sha256.convert(utf8.encode(rawNonce)).toString();

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: sha256Nonce,
        );

        final idToken = appleCredential.identityToken;
        if (idToken == null || idToken.isEmpty) {
          return 'Apple Sign-In failed: Apple Identity Token was not returned.';
        }

        final OAuthCredential credential = OAuthProvider('apple.com').credential(
          idToken: idToken,
          rawNonce: rawNonce,
        );

        userCredential = await _auth.signInWithCredential(credential);

        final firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          if (appleCredential.givenName != null || appleCredential.familyName != null) {
            final given = appleCredential.givenName ?? '';
            final family = appleCredential.familyName ?? '';
            final name = '$given $family'.trim();
            if (name.isNotEmpty && (firebaseUser.displayName == null || firebaseUser.displayName!.isEmpty)) {
              await firebaseUser.updateDisplayName(name);
            }
          }
        }
      }

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _syncUserProfile(currentUser);
      }

      notifyListeners();
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return 'Apple Sign-In cancelled';
      }
      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] AuthorizationException: code=${e.code}, message=${e.message}');
      }
      return 'Apple Sign-In failed: ${e.message}';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled' || e.code == 'user-cancelled') {
        return 'Apple Sign-In cancelled';
      }
      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] FirebaseAuthException: code=${e.code}, message=${e.message}');
      }
      return _firebaseAuthError(e);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('canceled') ||
          msg.contains('cancelled') ||
          msg.contains('1001') ||
          msg.contains('user-cancelled')) {
        return 'Apple Sign-In cancelled';
      }
      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] Unexpected error: $e');
      }
      return 'Apple Sign-In failed: $e';
    } finally {
      _isAppleLoading = false;
      notifyListeners();
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
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
        return 'Incorrect email or password.';

      case 'invalid-credential':
        return 'Apple Sign-In credential validation failed (invalid-credential). Please verify Apple Services ID (com.sanatanscroll.app), Team ID, and Private Key in Firebase Console > Authentication > Apple provider.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Please choose a stronger password.';

      case 'operation-not-allowed':
        return 'Apple Sign-In is not enabled in Firebase Console. Please go to Firebase Console > Authentication > Sign-in method and enable the Apple provider for project sanatan-scroll-19b25.';

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
  // DELETE ACCOUNT
  // ============================================================

  Future<String?> deleteAccount() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return 'No authenticated user found.';
    }

    final uid = currentUser.uid;
    _setLoading(true);

    try {
      if (kDebugMode) {
        debugPrint('[ACCOUNT_DELETION] Starting deletion for user $uid...');
      }

      // 1. Delete user-scoped Firestore data
      await _deleteUserFirestoreData(uid);

      // 2. Delete Firebase Auth user (handling recent login requirement)
      try {
        await currentUser.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          if (kDebugMode) {
            debugPrint('[ACCOUNT_DELETION] Recent authentication required. Initiating re-auth...');
          }
          final reauthError = await _reauthenticateUser(currentUser);
          if (reauthError != null) {
            return reauthError;
          }
          // Retry Auth deletion after successful re-auth
          await currentUser.delete();
        } else {
          rethrow;
        }
      }

      // 3. Clear local storage and SQLite caches
      await _clearLocalUserData();

      // 4. Sign out from GoogleSignIn if active
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('[ACCOUNT_DELETION] FirebaseAuthException: ${e.code} - ${e.message}');
      }
      return _firebaseAuthError(e);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ACCOUNT_DELETION] Error during account deletion: $e');
      }
      return 'Failed to delete account. Please try again: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _deleteUserFirestoreData(String uid) async {
    try {
      final userRef = _firestore.collection('users').doc(uid);

      final List<String> userSubcollections = [
        'saved_items',
        'streak',
        'reading_progress',
        'completed_chapters',
        'chapter_ratings',
      ];

      for (final subName in userSubcollections) {
        try {
          final snapshot = await userRef.collection(subName).get();
          for (final doc in snapshot.docs) {
            await doc.reference.delete();
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[ACCOUNT_DELETION] Error deleting subcollection $subName: $e');
          }
        }
      }

      // Delete main user profile document
      await userRef.delete();

      if (kDebugMode) {
        debugPrint('[ACCOUNT_DELETION] Successfully deleted Firestore data for user $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ACCOUNT_DELETION] Error deleting user document $uid: $e');
      }
    }
  }

  Future<String?> _reauthenticateUser(User user) async {
    try {
      final providers = user.providerData.map((p) => p.providerId).toList();
      final bool isApple = providers.contains('apple.com');
      final bool isGoogle = providers.contains('google.com');

      if (isGoogle || (!isApple && defaultTargetPlatform != TargetPlatform.iOS)) {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: defaultTargetPlatform == TargetPlatform.iOS
              ? '746323217658-g9kmvge3q4gnahcv41rotp7er6ndmih3.apps.googleusercontent.com'
              : null,
          serverClientId:
              '746323217658-0qfl1om1hk67vflkormno80seq38pvcr.apps.googleusercontent.com',
        );

        try {
          await googleSignIn.signOut();
        } catch (_) {}

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          return 'Re-authentication was cancelled.';
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
        return null;
      } else if (isApple || defaultTargetPlatform == TargetPlatform.iOS) {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          try {
            final appleProvider = AppleAuthProvider();
            await user.reauthenticateWithProvider(appleProvider);
            return null;
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[ACCOUNT_DELETION] Native Apple re-auth error: $e. Retrying with credential flow...');
            }
          }
        }

        final rawNonce = _generateNonce();
        final sha256Nonce = sha256.convert(utf8.encode(rawNonce)).toString();

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: sha256Nonce,
        );

        final idToken = appleCredential.identityToken;
        if (idToken == null || idToken.isEmpty) {
          return 'Apple re-authentication failed: missing token.';
        }

        final credential = OAuthProvider('apple.com').credential(
          idToken: idToken,
          rawNonce: rawNonce,
        );

        await user.reauthenticateWithCredential(credential);
        return null;
      }

      return 'Please sign out and sign in again before deleting your account.';
    } on FirebaseAuthException catch (e) {
      return _firebaseAuthError(e);
    } catch (e) {
      return 'Re-authentication failed: $e';
    }
  }

  Future<void> _clearLocalUserData() async {
    try {
      await LocalDatabase.instance.clearUserData();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_read_book_id');
      await prefs.remove('reading_positions_json');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ACCOUNT_DELETION] Error clearing local user data: $e');
      }
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