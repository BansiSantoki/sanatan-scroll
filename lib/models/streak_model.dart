class StreakModel {
  const StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDays,
    required this.completedDates,
    required this.milestoneTarget,
    required this.milestoneLabel,
    required this.wisdomCollected,
  });

  final int currentStreak;
  final int longestStreak;
  final int totalDays;
  final List<DateTime> completedDates;
  final int milestoneTarget;
  final String milestoneLabel;
  final int wisdomCollected;
}
