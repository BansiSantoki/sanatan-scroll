// Automatic FlutterFlow Custom Function
// Name: calculateWeeklyProgress
// Description: Computes a 7-element list of booleans (Mon-Sun) indicating reading completion for the current week.

List<bool> calculateWeeklyProgress(List<String>? completedDatesIso) {
  if (completedDatesIso == null || completedDatesIso.isEmpty) {
    return List.filled(7, false);
  }

  final completedSet = completedDatesIso
      .map((d) => DateTime.tryParse(d))
      .whereType<DateTime>()
      .map((d) => DateTime(d.year, d.month, d.day))
      .toSet();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));

  final result = <bool>[];
  for (int i = 0; i < 7; i++) {
    final day = monday.add(Duration(days: i));
    result.add(completedSet.contains(day));
  }
  return result;
}
