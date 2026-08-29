import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/mock_saved_data.dart';
import '../models/saved_item_model.dart';

class SavedProvider extends ChangeNotifier {
  final List<SavedItemModel> _items = List.from(MockSavedData.initial);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _savedSubscription;
  String _activeUserId = '';
  String _activeFilter = 'All';

  List<SavedItemModel> get items {
    if (_activeFilter == 'All') return List.unmodifiable(_items);
    final query = _activeFilter.toLowerCase().trim();
    final filtered = _items.where((i) {
      return i.source.toLowerCase().contains(query) ||
          i.title.toLowerCase().contains(query) ||
          i.content.toLowerCase().contains(query);
    }).toList();
    return List.unmodifiable(filtered);
  }

  String get activeFilter => _activeFilter;

  bool get isSyncedWithCloud => _activeUserId.isNotEmpty;

  void bindUser(String userId) {
    if (_activeUserId == userId) return;

    _savedSubscription?.cancel();
    _activeUserId = userId;

    if (_activeUserId.isEmpty) {
      _items
        ..clear()
        ..addAll(MockSavedData.initial);
      notifyListeners();
      return;
    }

    _savedSubscription = _firestore
        .collection('users')
        .doc(_activeUserId)
        .collection('saved_items')
        .orderBy('savedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _items
        ..clear()
        ..addAll(
          snapshot.docs.map((doc) {
            final data = doc.data();
            final normalized = <String, dynamic>{...data};

            final rawSavedAt = data['savedAt'];
            if (rawSavedAt is Timestamp) {
              normalized['savedAt'] = rawSavedAt.toDate().toIso8601String();
            }

            return SavedItemModel.fromMap(
              id: doc.id,
              map: normalized,
            );
          }),
        );

      notifyListeners();
    });
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();

    if (_activeUserId.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_activeUserId)
            .collection('saved_items')
            .doc(id)
            .delete();
      } catch (e) {
        if (kDebugMode) {
          print('Error deleting saved item from Firestore: $e');
        }
      }
    }
  }

  Future<void> addItem(SavedItemModel item) async {
    if (!_items.any((i) => i.id == item.id)) {
      _items.insert(0, item);
      notifyListeners();
    }

    if (_activeUserId.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_activeUserId)
            .collection('saved_items')
            .doc(item.id)
            .set({
          ...item.toMap(),
          'savedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        if (kDebugMode) {
          print('Error adding saved item to Firestore: $e');
        }
      }
    }
  }

  Future<void> toggleItem(SavedItemModel item) async {
    if (isSaved(item.id)) {
      await removeItem(item.id);
      return;
    }

    await addItem(item);
  }

  bool isSaved(String id) => _items.any((i) => i.id == id);



  @override
  void dispose() {
    _savedSubscription?.cancel();
    super.dispose();
  }
}
