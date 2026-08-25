import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  String _activeUserId = '';

  ReadingPosition? positionFor(String bookId) => _positions[bookId];

  void bindUser(String userId) {
    if (_activeUserId == userId) return;

    _subscription?.cancel();
    _activeUserId = userId;
    _positions.clear();

    if (userId.isEmpty) {
      notifyListeners();
      return;
    }

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
    notifyListeners();

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
    super.dispose();
  }
}
