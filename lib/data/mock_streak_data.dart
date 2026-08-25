import '../models/streak_model.dart';

class MockStreakData {
  MockStreakData._();

  static StreakModel get initial {
    final now = DateTime.now();
    final completedDates = <DateTime>[];

    for (int i = 0; i < 23; i++) {
      completedDates.add(DateTime(now.year, now.month, now.day - i));
    }

    return StreakModel(
      currentStreak: 23,
      longestStreak: 30,
      totalDays: 45,
      completedDates: completedDates,
      milestoneTarget: 30,
      milestoneLabel: 'Steady — 30 Days',
      wisdomCollected: 154,
    );
  }

  static const milestones = [
    ('Beginning', '7 Days', 7),
    ('Steady', '30 Days', 30),
    ('Practiced', '60 Days', 60),
    ('Devoted', '100 Days', 100),
    ('Enlightened', '365 Days', 365),
  ];
}
