import 'package:flutter/foundation.dart';

class GuestAccessProvider extends ChangeNotifier {
  bool _hasUsedFreeChapter = false;

  bool get hasUsedFreeChapter => _hasUsedFreeChapter;

  bool canOpenChapter({required bool isAuthenticated}) {
    return isAuthenticated || !_hasUsedFreeChapter;
  }

  void markFreeChapterUsed({required bool isAuthenticated}) {
    if (isAuthenticated || _hasUsedFreeChapter) return;
    _hasUsedFreeChapter = true;
    notifyListeners();
  }
}
