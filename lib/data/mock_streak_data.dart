import '../models/streak_model.dart';

class MockStreakData {
  MockStreakData._();

  // ==========================================================
  // INITIAL STREAK DATA
  // ==========================================================

  static StreakModel get initial {
    final now = DateTime.now();

    final completedDates = <DateTime>[];

    // Demo data:
    // Last 23 days completed.
    //
    // Later આ data Firebase / Firestore / APIમાંથી આવશે.
    for (int i = 0; i < 23; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day - i,
      );

      completedDates.add(date);
    }

    // Demo Diya dates.
    final diyaDates = <DateTime>[];

    for (final date in completedDates) {
      diyaDates.add(date);
    }

    // Demo Bhog dates.
    //
    // હાલ example તરીકે થોડા દિવસ રાખ્યા છે.
    // Later client/user actual bhog offering પ્રમાણે
    // આ list Firebaseમાંથી આવશે.
    final bhogDates = <DateTime>[];

    return StreakModel(
      currentStreak: 23,
      longestStreak: 30,
      totalDays: completedDates.length,

      completedDates: completedDates,

      milestoneTarget: 30,
      milestoneLabel: 'Steady — 30 Days',

      wisdomCollected: 154,

      diyaDates: diyaDates,
      bhogDates: bhogDates,
    );
  }

  // ==========================================================
  // MILESTONES
  // ==========================================================

  static const milestones = [
    ('Beginning', '7 Days', 7),
    ('Steady', '30 Days', 30),
    ('Practiced', '60 Days', 60),
    ('Devoted', '100 Days', 100),
    ('Enlightened', '365 Days', 365),
  ];
}