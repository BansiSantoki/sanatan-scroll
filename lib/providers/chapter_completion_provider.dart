import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChapterCompletion {
  const ChapterCompletion({
    required this.bookTitle,
    required this.chapterTitle,
  });

  final String bookTitle;
  final String chapterTitle;
}

class ChapterCompletionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChapterCompletion? _pending;
  String _userId = '';

  ChapterCompletion? get pending => _pending;

  void bindUser(String userId) {
    _userId = userId;
  }

  Future<String?> markCompleted({
    required String bookTitle,
    required String chapterTitle,
    int? chapterNumber,
    String? bookId,
  }) async {
    _pending = ChapterCompletion(
      bookTitle: bookTitle,
      chapterTitle: chapterTitle,
    );
    notifyListeners();

    if (_userId.isEmpty) return null;
    final completionId =
        '${bookId ?? bookTitle}_chapter_${chapterNumber ?? chapterTitle}'
            .replaceAll(' ', '_')
            .toLowerCase();
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('completed_chapters')
          .doc(completionId)
          .set({
        'bookId': bookId,
        'bookTitle': bookTitle,
        'chapterNumber': chapterNumber,
        'chapterTitle': chapterTitle,
        'completedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return null;
    } on FirebaseException catch (error) {
      return error.message ?? 'Unable to save chapter completion.';
    } catch (_) {
      return 'Unable to save chapter completion.';
    }
  }

  ChapterCompletion? takePending() {
    final completion = _pending;
    _pending = null;
    if (completion != null) notifyListeners();
    return completion;
  }
}
