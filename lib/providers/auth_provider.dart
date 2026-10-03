import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

      final rawNonce = _generateNonce();
      final sha256Nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] Starting Apple Sign-In flow...');
        debugPrint('[APPLE_AUTH_DEBUG] Generated SHA256 nonce for Apple request.');
      }

      UserCredential userCredential;

      try {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: sha256Nonce,
        );

        if (kDebugMode) {
          debugPrint('[APPLE_AUTH_DEBUG] Received Apple ID credential successfully.');
        }

        final OAuthCredential credential = OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        userCredential = await _auth.signInWithCredential(credential);

        final firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          if (appleCredential.givenName != null || appleCredential.familyName != null) {
            final given = appleCredential.givenName ?? '';
            final family = appleCredential.familyName ?? '';
            final name = '$given $family'.trim();
            if (name.isNotEmpty) {
              await firebaseUser.updateDisplayName(name);
            }
          }
          await _syncUserProfile(firebaseUser);
        }
      } on SignInWithAppleAuthorizationException catch (e) {
        if (e.code == AuthorizationErrorCode.canceled) {
          if (kDebugMode) {
            debugPrint('[APPLE_AUTH_DEBUG] User cancelled Apple Sign-In.');
          }
          return 'Apple Sign-In cancelled';
        }

        if (kDebugMode) {
          debugPrint('[APPLE_AUTH_DEBUG] SignInWithApple exception: code=${e.code}, message=${e.message}. Attempting Firebase AppleAuthProvider fallback...');
        }

        final appleProvider = AppleAuthProvider();
        appleProvider.addScope('email');
        appleProvider.addScope('name');

        userCredential = await _auth.signInWithProvider(appleProvider);
        final firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          await _syncUserProfile(firebaseUser);
        }
      }

      notifyListeners();
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return 'Apple Sign-In cancelled';
      }
      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] Apple Authorization Error: code=${e.code}, message=${e.message}');
      }
      return 'Apple Sign-In failed: ${e.message}';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled' || e.code == 'user-cancelled') {
        return 'Apple Sign-In cancelled';
      }
      if (kDebugMode) {
        debugPrint('[APPLE_AUTH_DEBUG] FirebaseAuthException during Apple Sign-In: ${e.code} - ${e.message}');
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
        debugPrint('[APPLE_AUTH_DEBUG] Unexpected error during Apple Sign-In: $e');
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
      case 'invalid-credential':
        return 'Incorrect email or password.';

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
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;

    super.dispose();
  }
}