import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/sacred_books_repository.dart';
import '../models/sacred_book_model.dart';
import '../models/sacred_text_model.dart';

class ExploreProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<SacredTextModel> _liveTexts = [];
  StreamSubscription<List<SacredBookModel>>? _subscription;

  ExploreProvider() {
    _initLiveStream();
  }

  void _initLiveStream() {
    _subscription = SacredBooksRepository.streamAllBooks().listen((books) {
      _liveTexts = books.asMap().entries.map((entry) {
        final index = entry.key;
        final book = entry.value;

        return SacredTextModel(
          id: book.id,
          title: book.title,
          subtitle: book.subtitle,
          description: (book.description != null && book.description!.isNotEmpty)
              ? book.description!
              : book.subtitle,
          category: _inferCategory(book.id),
          chapters: book.totalChapters,
          verses: book.chapters.fold<int>(0, (sum, c) => sum + c.verses.length),
          pages: book.totalChapters * 20,
          gradientIndex: index % 6,
          isFeatured: index == 0,
          iconEmoji: book.iconEmoji,
        );
      }).toList();

      notifyListeners();
    });
  }

  String _inferCategory(String id) {
    if (id == 'bhagavad_gita') return 'Bhagavad Gita';
    if (id == 'upanishads') return 'Upanishads';
    if (id == 'yoga_sutras') return 'Meditation';
    if (id == 'puranas' || id == 'shiva_purana' || id == 'vishnu_purana') return 'Bhakti';
    return 'Dharma';
  }

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<SacredTextModel> get filteredTexts {
    var texts = _liveTexts;

    if (_selectedCategory != 'All') {
      texts = texts.where((t) => t.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      texts = texts
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                t.subtitle.toLowerCase().contains(query) ||
                t.category.toLowerCase().contains(query) ||
                t.description.toLowerCase().contains(query),
          )
          .toList();
    }

    return texts;
  }

  SacredTextModel? get featuredText =>
      _liveTexts.where((t) => t.isFeatured).firstOrNull ?? _liveTexts.firstOrNull;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
