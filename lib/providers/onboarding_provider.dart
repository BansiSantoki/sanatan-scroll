import 'package:flutter/foundation.dart';

class OnboardingProvider extends ChangeNotifier {
  final Set<String> _selectedInterests = <String>{};

  Set<String> get selectedInterests =>
      Set<String>.unmodifiable(_selectedInterests);

  bool get hasSelection => _selectedInterests.isNotEmpty;

  int get selectedCount => _selectedInterests.length;

  void toggleInterest(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      _selectedInterests.add(interest);
    }

    notifyListeners();
  }

  bool isSelected(String interest) {
    return _selectedInterests.contains(interest);
  }

  void clearAll() {
    _selectedInterests.clear();
    notifyListeners();
  }

  void reset() {
    clearAll();
  }
}
