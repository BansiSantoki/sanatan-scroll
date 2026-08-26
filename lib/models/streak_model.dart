class StreakModel {
  const StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDays,
    required this.completedDates,
    required this.milestoneTarget,
    required this.milestoneLabel,
    required this.wisdomCollected,
    this.diyaDates = const [],
    this.bhogDates = const [],
  });

  final int currentStreak;
  final int longestStreak;
  final int totalDays;

  /// All dates on which the user completed an offering/activity.
  final List<DateTime> completedDates;

  final int milestoneTarget;
  final String milestoneLabel;
  final int wisdomCollected;

  /// Optional dynamic offering dates.
  ///
  /// These are kept separate so the calendar can show
  /// Diya Offering and Bhog Offering differently.
  final List<DateTime> diyaDates;
  final List<DateTime> bhogDates;

  // ==========================================================
  // DATE HELPERS
  // ==========================================================

  bool isCompleted(DateTime date) {
    return _containsDate(completedDates, date);
  }

  bool isDiyaOffering(DateTime date) {
    return _containsDate(diyaDates, date);
  }

  bool isBhogOffering(DateTime date) {
    return _containsDate(bhogDates, date);
  }

  bool _containsDate(
    List<DateTime> dates,
    DateTime target,
  ) {
    return dates.any(
      (date) =>
          date.year == target.year &&
          date.month == target.month &&
          date.day == target.day,
    );
  }
}