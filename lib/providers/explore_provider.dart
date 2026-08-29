import 'package:flutter/foundation.dart';
import '../data/mock_sacred_texts.dart';
import '../models/sacred_text_model.dart';

class ExploreProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<SacredTextModel> get filteredTexts {
    var texts = MockSacredTexts.all;

    if (_selectedCategory != 'All') {
      texts = texts 
          .where((t) => t.category == _selectedCategory)
          .toList();
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
      MockSacredTexts.all.where((t) => t.isFeatured).firstOrNull ??
      MockSacredTexts.all.first;

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
}
