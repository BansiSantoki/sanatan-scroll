import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/sacred_chapter_admin_model.dart';
import '../services/chapters_service.dart';
import '../services/activity_logs_service.dart';

class ChaptersProvider extends ChangeNotifier {
  final ChaptersService _chaptersService = ChaptersService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<SacredChapterAdminModel>>? _subscription;

  String? _activeBookId;
  List<SacredChapterAdminModel> _chapters = [];
  bool _isLoading = false;
  String? _errorMessage;

  String? get activeBookId => _activeBookId;
  List<SacredChapterAdminModel> get chapters => _chapters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void bindBook(String bookId) {
    if (_activeBookId == bookId) return;
    _activeBookId = bookId;
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _subscription = _chaptersService.streamChapters(bookId).listen(
      (data) {
        _chapters = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load chapters: $err';
        notifyListeners();
      },
    );
  }

  Future<bool> saveChapter(SacredChapterAdminModel chapter) async {
    if (_activeBookId == null) return false;
    try {
      _isLoading = true;
      notifyListeners();

      await _chaptersService.saveChapter(_activeBookId!, chapter);
      await _logsService.logAction(
        action: 'Saved Chapter',
        target: chapter.title,
        details: 'Book: $_activeBookId, Chapter #${chapter.chapterNumber}',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving chapter: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> togglePublishStatus(int chapterNumber, bool currentStatus) async {
    if (_activeBookId == null) return false;
    try {
      final newStatus = !currentStatus;
      await _chaptersService.setPublishedStatus(_activeBookId!, chapterNumber, newStatus);
      await _logsService.logAction(
        action: newStatus ? 'Published Chapter' : 'Unpublished Chapter',
        target: 'Book: $_activeBookId, Chapter #$chapterNumber',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update chapter status: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteChapter(int chapterNumber, String title) async {
    if (_activeBookId == null) return false;
    try {
      await _chaptersService.deleteChapter(_activeBookId!, chapterNumber);
      await _logsService.logAction(
        action: 'Deleted Chapter',
        target: title,
        details: 'Book: $_activeBookId, Chapter #$chapterNumber',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete chapter: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
