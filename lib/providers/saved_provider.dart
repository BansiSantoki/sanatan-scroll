import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../data/mock_saved_data.dart';
import '../models/saved_item_model.dart';

class SavedProvider extends ChangeNotifier {
  final List<SavedItemModel> _items = List.from(MockSavedData.initial);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _savedSubscription;
  String _activeUserId = '';
  String _activeFilter = 'All';

  String get effectiveUserId {
    if (_activeUserId.isNotEmpty) return _activeUserId;
    return _auth.currentUser?.uid ?? '';
  }

  List<SavedItemModel> get items {
    if (_activeFilter == 'All') return List.unmodifiable(_items);
    final filtered = _items.where((i) => _matchesFilter(i, _activeFilter)).toList();
    return List.unmodifiable(filtered);
  }

  bool _matchesFilter(SavedItemModel item, String filter) {
    if (filter == 'All') return true;

    final filterLower = filter.toLowerCase().trim();

    // 1. Direct bookId checks
    final bookId = (item.bookId ?? '').toLowerCase().trim();
    if (filterLower == 'upanishads' || filterLower == 'upanishad') {
      if (bookId == 'upanishads' || bookId == 'upanishad' || bookId == 'isha_upanishad') {
        return true;
      }
    } else if (filterLower == 'bhagavad gita' || filterLower == 'gita') {
      if (bookId == 'bhagavad_gita' || bookId == 'gita') {
        return true;
      }
    } else if (filterLower == 'ramayana') {
      if (bookId == 'ramayana') {
        return true;
      }
    }

    // 2. Check item id prefix
    final idLower = item.id.toLowerCase();
    if (filterLower == 'upanishads' || filterLower == 'upanishad') {
      if (idLower.startsWith('upanishad') || idLower.startsWith('isha') || idLower.contains('upanishad')) {
        return true;
      }
    } else if (filterLower == 'bhagavad gita' || filterLower == 'gita') {
      if (idLower.startsWith('bhagavad') || idLower.startsWith('gita') || idLower.contains('gita')) {
        return true;
      }
    } else if (filterLower == 'ramayana') {
      if (idLower.startsWith('ramayana') || idLower.contains('ramayana')) {
        return true;
      }
    }

    // 3. Singular vs Plural text matching (e.g. 'upanishad' vs 'upanishads')
    final String queryBase = filterLower.endsWith('s')
        ? filterLower.substring(0, filterLower.length - 1)
        : filterLower;

    final sourceLower = item.source.toLowerCase();
    final titleLower = item.title.toLowerCase();
    final bookNameLower = (item.bookName ?? '').toLowerCase();
    final contentLower = item.content.toLowerCase();

    return sourceLower.contains(queryBase) ||
        titleLower.contains(queryBase) ||
        bookNameLower.contains(queryBase) ||
        contentLower.contains(queryBase) ||
        sourceLower.contains(filterLower) ||
        titleLower.contains(filterLower) ||
        bookNameLower.contains(filterLower) ||
        contentLower.contains(filterLower);
  }

  String get activeFilter => _activeFilter;

  bool get isSyncedWithCloud => effectiveUserId.isNotEmpty;

  void bindUser(String userId) {
    if (_activeUserId == userId && _savedSubscription != null) return;

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
    }, onError: (e) {
      if (kDebugMode) {
        debugPrint('[SAVE DEBUG] Firestore listen error for uid $_activeUserId: $e');
      }
    });
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    final uid = effectiveUserId;

    SavedItemModel? targetItem;
    try {
      targetItem = _items.firstWhere((i) => i.id == id);
    } catch (_) {}

    if (kDebugMode) {
      debugPrint('==================================================');
      debugPrint('[SAVE DEBUG] Save tapped (UNSAVE)');
      debugPrint('  uid: $uid');
      debugPrint('  bookId: ${targetItem?.bookId}');
      debugPrint('  section/chapter: ${targetItem?.chapterNumber}');
      debugPrint('  verseId: ${targetItem?.verseId}');
      debugPrint('  verseNumber: ${targetItem?.verseNumber}');
      debugPrint('  action: unsave');
      debugPrint('  Firestore path: users/$uid/saved_items/$id');
      debugPrint('==================================================');
    }

    _items.removeWhere((i) => i.id == id);
    notifyListeners();

    if (uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('saved_items')
            .doc(id)
            .delete();

        if (kDebugMode) {
          debugPrint('[SAVE DEBUG] Firestore unsave success: users/$uid/saved_items/$id');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[SAVE DEBUG] Error deleting saved item from Firestore: $e');
        }
      }
    }
  }

  Future<void> addItem(SavedItemModel item) async {
    final uid = effectiveUserId;

    if (kDebugMode) {
      debugPrint('==================================================');
      debugPrint('[SAVE DEBUG] Save tapped (SAVE)');
      debugPrint('  uid: $uid');
      debugPrint('  bookId: ${item.bookId}');
      debugPrint('  section/chapter: ${item.chapterNumber}');
      debugPrint('  verseId: ${item.verseId}');
      debugPrint('  verseNumber: ${item.verseNumber}');
      debugPrint('  action: save');
      debugPrint('  Firestore path: users/$uid/saved_items/${item.id}');
      debugPrint('==================================================');
    }

    if (!_items.any((i) => i.id == item.id)) {
      _items.insert(0, item);
      notifyListeners();
    }

    if (uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('saved_items')
            .doc(item.id)
            .set({
          ...item.toMap(),
          'savedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (kDebugMode) {
          debugPrint('[SAVE DEBUG] Firestore save success: users/$uid/saved_items/${item.id}');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[SAVE DEBUG] Error adding saved item to Firestore: $e');
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

