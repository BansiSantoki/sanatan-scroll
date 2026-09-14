import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/sacred_book_admin_model.dart';
import '../services/sacred_books_service.dart';
import '../services/activity_logs_service.dart';
import '../services/seed_service.dart';

class BooksProvider extends ChangeNotifier {
  final SacredBooksService _booksService = SacredBooksService();
  final ActivityLogsService _logsService = ActivityLogsService();
  final SeedService _seedService = SeedService();
  StreamSubscription<List<SacredBookAdminModel>>? _subscription;

  List<SacredBookAdminModel> _books = [];
  bool _isLoading = true;
  bool _isSeeding = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _filterStatus = 'All'; // All, Published, Draft, Archived

  BooksProvider() {
    _init();
  }

  List<SacredBookAdminModel> get books {
    var list = List<SacredBookAdminModel>.from(_books);
    if (_filterStatus == 'Published') {
      list = list.where((b) => b.published && !b.archived).toList();
    } else if (_filterStatus == 'Draft') {
      list = list.where((b) => !b.published && !b.archived).toList();
    } else if (_filterStatus == 'Archived') {
      list = list.where((b) => b.archived).toList();
    } else {
      // 'All' - return active non-archived books or all books
      list = list.where((b) => !b.archived).toList();
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
  bool get isSeeding => _isSeeding;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;

  int get totalBooks => _books.where((b) => !b.archived).length;
  int get publishedBooks => _books.where((b) => b.published && !b.archived).length;
  int get draftBooks => _books.where((b) => !b.published && !b.archived).length;
  int get archivedBooks => _books.where((b) => b.archived).length;

  void _init() {
    _subscription = _booksService.streamBooks().listen(
      (data) async {
        _books = data;
        _isLoading = false;
        _errorMessage = null;

        // Auto-seed if Firestore has 0 books
        if (data.isEmpty && !_isSeeding) {
          _isSeeding = true;
          notifyListeners();
          try {
            await _seedService.syncExistingMobileContentToFirestore(force: false);
          } catch (e) {
            _errorMessage = 'Auto-seed note: $e';
          } finally {
            _isSeeding = false;
          }
        } else {
          notifyListeners();
        }
      },
      onError: (err) {
        _isLoading = false;
        _errorMessage = 'Failed to load sacred books: $err';
        notifyListeners();
      },
    );
  }

  Future<bool> syncMobileContent({bool force = true}) async {
    try {
      _isSeeding = true;
      notifyListeners();

      await _seedService.syncExistingMobileContentToFirestore(force: force);

      _isSeeding = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSeeding = false;
      _errorMessage = 'Failed to sync mobile content: $e';
      notifyListeners();
      return false;
    }
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
