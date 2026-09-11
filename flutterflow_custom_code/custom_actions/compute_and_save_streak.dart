// Automatic FlutterFlow Custom Action
// Name: computeAndSaveStreak
// Description: Computes current daily reading streak and updates Firestore subcollection 'users/{uid}/streak/current'

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

Future<void> computeAndSaveStreak(DateTime date) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final now = DateTime(date.year, date.month, date.day);
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('streak')
      .doc('current');

  try {
    final docSnap = await docRef.get();
    List<String> completedDates = [];
    int currentStreak = 0;
    int longestStreak = 0;

    if (docSnap.exists && docSnap.data() != null) {
      final data = docSnap.data()!;
      final rawDates = data['completedDates'];
      if (rawDates is List) {
        completedDates = rawDates.cast<String>();
      }
      currentStreak = (data['currentStreak'] as num?)?.toInt() ?? 0;
      longestStreak = (data['longestStreak'] as num?)?.toInt() ?? 0;
    }

    final isoDate = now.toIso8601String();
    if (!completedDates.contains(isoDate)) {
      completedDates.add(isoDate);
      completedDates.sort();

      // Recalculate streak
      final set = completedDates
          .map((d) => DateTime.tryParse(d))
          .whereType<DateTime>()
          .map((d) => DateTime(d.year, d.month, d.day))
          .toSet();

      final today = DateTime(now.year, now.month, now.day);
      int run = 0;
      for (int i = 0;; i++) {
        final day = today.subtract(Duration(days: i));
        if (set.contains(day)) {
          run++;
        } else {
          break;
        }
      }
      currentStreak = run;
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    }

    await docRef.set({
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalDays': completedDates.length,
      'lastReadDate': isoDate,
      'completedDates': completedDates,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } catch (e) {
    debugPrint('Error saving streak to Firestore: $e');
  }
}
