import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingPosition {
  const ReadingPosition({
    required this.chapterNumber,
    required this.verseNumber,
  });

  final int chapterNumber;
  final int verseNumber;
}

class ReadingProgressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, ReadingPosition> _positions = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSubscription;
  String _activeUserId = '';
  String _lastReadBookId = 'bhagavad_gita';

  String get lastReadBookId => _lastReadBookId;

  ReadingProgressProvider() {
    _loadLocalLastRead();
  }

  Future<void> _loadLocalLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('last_read_book_id');
      if (saved != null && saved.isNotEmpty) {
        _lastReadBookId = saved;
        notifyListeners();
      }
    } catch (_) {}
  }

  ReadingPosition? positionFor(String bookId) => _positions[bookId];

  Future<void> setLastReadBookId(String bookId) async {
    if (bookId.isEmpty) return;
    _lastReadBookId = bookId;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_read_book_id', bookId);
    } catch (_) {}

    if (_activeUserId.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(_activeUserId).set({
          'lastReadBookId': bookId,
          'lastReadUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}
    }
  }

  void bindUser(String userId) {
    if (_activeUserId == userId) return;

    _subscription?.cancel();
    _userDocSubscription?.cancel();
    _activeUserId = userId;
    _positions.clear();

    if (userId.isEmpty) {
      notifyListeners();
      return;
    }

    _userDocSubscription = _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((docSnap) {
      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        final savedBook = data['lastReadBookId'] as String?;
        if (savedBook != null && savedBook.isNotEmpty) {
          _lastReadBookId = savedBook;
          notifyListeners();
        }
      }
    });

    _subscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('reading_progress')
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        _positions[doc.id] = ReadingPosition(
          chapterNumber: _asInt(data['chapterNumber'], fallback: 1),
          verseNumber: _asInt(data['verseNumber'], fallback: 1),
        );
      }
      notifyListeners();
    });
  }

  Future<void> savePosition({
    required String bookId,
    required int chapterNumber,
    required int verseNumber,
  }) async {
    final position = ReadingPosition(
      chapterNumber: chapterNumber,
      verseNumber: verseNumber,
    );
    _positions[bookId] = position;
    _lastReadBookId = bookId;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_read_book_id', bookId);
    } catch (_) {}

    if (_activeUserId.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(_activeUserId)
        .collection('reading_progress')
        .doc(bookId)
        .set({
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'verseNumber': verseNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore.collection('users').doc(_activeUserId).set({
      'lastReadBookId': bookId,
      'lastReadChapterNumber': chapterNumber,
      'lastReadVerseNumber': verseNumber,
      'lastReadUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }
}
