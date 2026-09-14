import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/sacred_book_admin_model.dart';
import '../services/sacred_books_service.dart';
import '../services/activity_logs_service.dart';

class BooksProvider extends ChangeNotifier {
  final SacredBooksService _booksService = SacredBooksService();
  final ActivityLogsService _logsService = ActivityLogsService();
  StreamSubscription<List<SacredBookAdminModel>>? _subscription;

  List<SacredBookAdminModel> _books = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _filterStatus = 'All'; // All, Published, Draft

  BooksProvider() {
    _init();
  }

  List<SacredBookAdminModel> get books {
    var list = List<SacredBookAdminModel>.from(_books);
    if (_filterStatus == 'Published') {
      list = list.where((b) => b.published).toList();
    } else if (_filterStatus == 'Draft') {
      list = list.where((b) => !b.published).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((b) {
        return b.title.toLowerCase().contains(q) ||
            b.id.toLowerCase().contains(q) ||
            b.subtitle.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  List<SacredBookAdminModel> get rawBooks => _books;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;

  int get totalBooks => _books.length;
  int get publishedBooks => _books.where((b) => b.published).length;
  int get draftBooks => _books.where((b) => !b.published).length;

  void _init() {
    _subscription = _booksService.streamBooks().listen(
      (data) {
        _books = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load sacred books: $err';
        notifyListeners();
      },
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  Future<bool> saveBook(SacredBookAdminModel book) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _booksService.saveBook(book);
      await _logsService.logAction(
        action: 'Saved Book',
        target: book.title,
        details: 'Book ID: ${book.id}',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving book: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> togglePublishStatus(String bookId, bool currentStatus) async {
    try {
      final newStatus = !currentStatus;
      await _booksService.setPublishedStatus(bookId, newStatus);
      await _logsService.logAction(
        action: newStatus ? 'Published Book' : 'Unpublished Book',
        target: bookId,
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update publish status: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBook(String bookId, String title) async {
    try {
      await _booksService.deleteBook(bookId);
      await _logsService.logAction(
        action: 'Deleted Book',
        target: title,
        details: 'Book ID: $bookId',
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete book: $e';
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
