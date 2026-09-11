// Automatic FlutterFlow Custom Action
// Name: syncFirebaseUserProfile
// Description: Synchronizes Firebase authenticated user profile into Firestore collection 'users'

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> syncFirebaseUserProfile() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final existingUser = await userRef.get();

    final data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
      'photoURL': user.photoURL ?? '',
      'signInProvider': user.providerData.isEmpty
          ? 'firebase'
          : user.providerData.first.providerId,
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    if (!existingUser.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await userRef.set(data, SetOptions(merge: true));
  } catch (e) {
    debugPrint('Unable to sync Firebase user profile: $e');
  }
}
