import 'package:flutter/foundation.dart';
import '../data/mock_wisdom_data.dart';
import '../models/wisdom_model.dart';

class DailyProgressProvider extends ChangeNotifier {
  List<DailyActivity> _activities =
      List.from(MockWisdomData.dailyActivities);

  List<DailyActivity> get activities => List.unmodifiable(_activities);

  int get completedCount =>
      _activities.where((a) => a.isCompleted).length;

  int get totalCount => _activities.length;

  double get progress =>
      totalCount > 0 ? completedCount / totalCount : 0;

  void toggleActivity(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _activities[index] = _activities[index].copyWith(
        isCompleted: !_activities[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void reset() {
    _activities = List.from(MockWisdomData.dailyActivities);
    notifyListeners();
  }
}
