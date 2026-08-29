import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/data/local_database.dart';
import '../models/streak_model.dart';

class StreakProvider extends ChangeNotifier {
  StreakProvider() {
    _init();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _activeUserId = '';
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _streakSubscription;

  StreakModel _streak = const StreakModel(
    currentStreak: 0,
    longestStreak: 0,
    totalDays: 0,
    completedDates: [],
    milestoneTarget: 30,
    milestoneLabel: 'Steady — 30 Days',
    wisdomCollected: 0,
  );

  StreakModel get streak => _streak;

  Future<void> _init() async {
    _streak = await LocalDatabase.instance.computeStreakModel();
    notifyListeners();
  }

  void bindUser(String userId) {
    if (_activeUserId == userId) return;
    _streakSubscription?.cancel();
    _activeUserId = userId;

    if (_activeUserId.isEmpty) return;

    _streakSubscription = _firestore
        .collection('users')
        .doc(_activeUserId)
        .collection('streak')
        .doc('current')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final rawDates = data['completedDates'];
        if (rawDates is List) {
          for (final raw in rawDates) {
            if (raw is String) {
              final parsed = DateTime.tryParse(raw);
              if (parsed != null) {
                await LocalDatabase.instance.addCompletedDate(parsed);
              }
            }
          }
        }
      }
      _streak = await LocalDatabase.instance.computeStreakModel();
      notifyListeners();
    });
  }

  Future<void> markCompleted(DateTime date) async {
    final now = DateTime(date.year, date.month, date.day);
    await LocalDatabase.instance.addCompletedDate(now);
    _streak = await LocalDatabase.instance.computeStreakModel();
    notifyListeners();

    if (_activeUserId.isNotEmpty) {
      try {
        final completedIsoList = _streak.completedDates
            .map((d) => DateTime(d.year, d.month, d.day).toIso8601String())
            .toList();

        await _firestore
            .collection('users')
            .doc(_activeUserId)
            .collection('streak')
            .doc('current')
            .set({
          'currentStreak': _streak.currentStreak,
          'longestStreak': _streak.longestStreak,
          'totalDays': _streak.totalDays,
          'lastReadDate': now.toIso8601String(),
          'completedDates': completedIsoList,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        if (kDebugMode) {
          print('Error syncing streak to Firestore: $e');
        }
      }
    }
  }

  Future<void> unmarkCompleted(DateTime date) async {
    await LocalDatabase.instance.removeCompletedDate(date);
    _streak = await LocalDatabase.instance.computeStreakModel();
    notifyListeners();
  }

  bool isDateCompleted(DateTime date) {
    return _streak.isCompleted(date);
  }

  /// Calculates completed days count for current Monday..Sunday range
  int get thisWeekCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    int count = 0;
    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      if (_streak.isCompleted(day)) {
        count++;
      }
    }
    return count;
  }

  /// Map of Mon..Sun completion states for current week
  Map<String, bool> get weeklyCompletedMap {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final dayKeys = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final result = <String, bool>{};

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      result[dayKeys[i]] = _streak.isCompleted(day);
    }
    return result;
  }

  bool isMilestoneUnlocked(int targetDays) {
    return _streak.currentStreak >= targetDays || _streak.totalDays >= targetDays;
  }

  @override
  void dispose() {
    _streakSubscription?.cancel();
    super.dispose();
  }
}
