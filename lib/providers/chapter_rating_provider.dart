import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChapterRatingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, int> _ratings = {};
  String _userId = '';

  int ratingFor(String bookId, int chapterNumber) =>
      _ratings['${bookId}_$chapterNumber'] ?? 0;

  void bindUser(String userId) {
    if (_userId == userId) return;
    _userId = userId;
    _ratings.clear();
    notifyListeners();
  }

  Future<String?> setRating({
    required String bookId,
    required int chapterNumber,
    required int rating,
  }) async {
    if (rating < 1 || rating > 5) return 'Rating must be between 1 and 5.';
    final key = '${bookId}_$chapterNumber';
    _ratings[key] = rating;
    notifyListeners();

    if (_userId.isEmpty) return null;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('chapter_ratings')
          .doc(key)
          .set({
        'userId': _userId,
        'bookId': bookId,
        'chapterNumber': chapterNumber,
        'rating': rating,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return null;
    } on FirebaseException catch (error) {
      return error.message ?? 'Unable to save your rating.';
    } catch (_) {
      return 'Unable to save your rating.';
    }
  }

  Future<void> loadRating({
    required String bookId,
    required int chapterNumber,
  }) async {
    if (_userId.isEmpty) return;
    final key = '${bookId}_$chapterNumber';
    if (_ratings.containsKey(key)) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('chapter_ratings')
        .doc(key)
        .get();
    final rawRating = snapshot.data()?['rating'];
    if (rawRating is num) {
      _ratings[key] = rawRating.toInt().clamp(1, 5);
    }
    notifyListeners();
  }
}
