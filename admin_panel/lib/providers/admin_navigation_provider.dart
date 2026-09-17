import 'package:flutter/foundation.dart';

enum AdminNavItem {
  dashboard,
  books,
  chapters,
  verses,
  dailyReadings,
  importContent,
  media,
  users,
  notifications,
  analytics,
  settings,
  profile,
}

class AdminNavigationProvider extends ChangeNotifier {
  AdminNavItem _currentItem = AdminNavItem.dashboard;
  String? _selectedBookId;
  int? _selectedChapterNumber;

  AdminNavItem get currentItem => _currentItem;
  String? get selectedBookId => _selectedBookId;
  int? get selectedChapterNumber => _selectedChapterNumber;

  void navigateTo(AdminNavItem item, {String? bookId, int? chapterNumber}) {
    _currentItem = item;
    if (bookId != null) _selectedBookId = bookId;
    if (chapterNumber != null) _selectedChapterNumber = chapterNumber;
    notifyListeners();
  }

  void selectBook(String bookId) {
    _selectedBookId = bookId;
    _currentItem = AdminNavItem.chapters;
    notifyListeners();
  }

  void selectChapter(String bookId, int chapterNumber) {
    _selectedBookId = bookId;
    _selectedChapterNumber = chapterNumber;
    _currentItem = AdminNavItem.verses;
    notifyListeners();
  }
}
