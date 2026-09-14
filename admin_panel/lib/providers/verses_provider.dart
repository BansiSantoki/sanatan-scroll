import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/sacred_verse_admin_model.dart';
import '../services/verses_service.dart';
import '../services/activity_logs_service.dart';

class VersesProvider extends ChangeNotifier {
  final VersesService _versesService = VersesService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<SacredVerseAdminModel>>? _subscription;

  String? _activeBookId;
  int? _activeChapterNumber;
  List<SacredVerseAdminModel> _verses = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  String? get activeBookId => _activeBookId;
  int? get activeChapterNumber => _activeChapterNumber;
  List<SacredVerseAdminModel> get verses {
    if (_searchQuery.isEmpty) return _verses;
    final q = _searchQuery.toLowerCase();
    return _verses.where((v) {
      return v.verseNumber.toString().contains(q) ||
          v.sanskrit.toLowerCase().contains(q) ||
          v.english.toLowerCase().contains(q) ||
          v.gujarati.toLowerCase().contains(q) ||
          (v.hindi?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  void bindChapter({required String bookId, required int chapterNumber}) {
    if (_activeBookId == bookId && _activeChapterNumber == chapterNumber) return;
    _activeBookId = bookId;
    _activeChapterNumber = chapterNumber;
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _subscription = _versesService
        .streamVerses(bookId: bookId, chapterNumber: chapterNumber)
        .listen(
      (data) {
        _verses = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load verses: $err';
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> saveVerse(SacredVerseAdminModel verse) async {
    if (_activeBookId == null || _activeChapterNumber == null) return false;
    try {
      _isLoading = true;
      notifyListeners();

      await _versesService.saveVerse(
        bookId: _activeBookId!,
        chapterNumber: _activeChapterNumber!,
        verse: verse,
      );
      await _logsService.logAction(
        action: 'Saved Verse',
        target: 'Book: $_activeBookId, Ch: $_activeChapterNumber, Verse #${verse.verseNumber}',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving verse: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> togglePublishStatus(int verseNumber, bool currentStatus) async {
    if (_activeBookId == null || _activeChapterNumber == null) return false;
    try {
      final newStatus = !currentStatus;
      await _versesService.setPublishedStatus(
        bookId: _activeBookId!,
        chapterNumber: _activeChapterNumber!,
        verseNumber: verseNumber,
        published: newStatus,
      );
      await _logsService.logAction(
        action: newStatus ? 'Published Verse' : 'Unpublished Verse',
        target: 'Verse #$verseNumber in $_activeBookId Ch: $_activeChapterNumber',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update verse status: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVerse(int verseNumber) async {
    if (_activeBookId == null || _activeChapterNumber == null) return false;
    try {
      await _versesService.deleteVerse(
        bookId: _activeBookId!,
        chapterNumber: _activeChapterNumber!,
        verseNumber: verseNumber,
      );
      await _logsService.logAction(
        action: 'Deleted Verse',
        target: 'Verse #$verseNumber in $_activeBookId Ch: $_activeChapterNumber',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete verse: $e';
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
