import 'package:flutter/foundation.dart';
import '../models/streak_model.dart';
import '../core/data/local_database.dart';

class StreakProvider extends ChangeNotifier {
  StreakProvider() {
    _init();
  }

  StreakModel _streak = StreakModel(
    currentStreak: 0,
    longestStreak: 0,
    totalDays: 0,
    completedDates: const [],
    milestoneTarget: 30,
    milestoneLabel: 'Steady — 30 Days',
    wisdomCollected: 0,
  );

  StreakModel get streak => _streak;

  Future<void> _init() async {
    _streak = await LocalDatabase.instance.computeStreakModel();
    notifyListeners();
  }

  Future<void> markCompleted(DateTime date) async {
    await LocalDatabase.instance.addCompletedDate(date);
    _streak = await LocalDatabase.instance.computeStreakModel();
    notifyListeners();
  }

  Future<void> unmarkCompleted(DateTime date) async {
    await LocalDatabase.instance.removeCompletedDate(date);
    _streak = await LocalDatabase.instance.computeStreakModel();
    notifyListeners();
  }

  bool isDateCompleted(DateTime date) {
    return _streak.completedDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
  }
}
