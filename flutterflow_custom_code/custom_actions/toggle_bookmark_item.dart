// Automatic FlutterFlow Custom Action
// Name: toggleBookmarkItem
// Description: Toggles bookmark item in Firestore subcollection 'users/{uid}/saved_items/{itemId}'

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> toggleBookmarkItem(
  String itemId,
  String title,
  String source,
  String content,
  String type,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('saved_items')
      .doc(itemId);

  try {
    final docSnap = await docRef.get();
    if (docSnap.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': itemId,
        'title': title,
        'source': source,
        'content': content,
        'type': type,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    debugPrint('Error toggling bookmark item in Firestore: $e');
  }
}
