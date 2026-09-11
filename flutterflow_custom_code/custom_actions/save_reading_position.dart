// Automatic FlutterFlow Custom Action
// Name: saveReadingPosition
// Description: Saves current book, chapter, and verse position in Firestore subcollection 'users/{uid}/reading_progress/{bookId}'

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> saveReadingPosition(
  String bookId,
  int chapterNumber,
  int verseNumber,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reading_progress')
        .doc(bookId)
        .set({
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'verseNumber': verseNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } catch (e) {
    debugPrint('Error saving reading position to Firestore: $e');
  }
}
