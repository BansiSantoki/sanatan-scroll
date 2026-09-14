import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sacred_verse_admin_model.dart';

class VersesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getVersesCollection({
    required String bookId,
    required int chapterNumber,
  }) {
    return _firestore
        .collection('sacred_books')
        .doc(bookId)
        .collection('chapters')
        .doc(chapterNumber.toString())
        .collection('verses');
  }

  Stream<List<SacredVerseAdminModel>> streamVerses({
    required String bookId,
    required int chapterNumber,
  }) {
    return _getVersesCollection(bookId: bookId, chapterNumber: chapterNumber)
        .snapshots()
        .map((snapshot) {
      final verses = snapshot.docs.map((doc) {
        return SacredVerseAdminModel.fromMap(doc.data());
      }).toList();
      verses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
      return verses;
    });
  }

  Future<List<SacredVerseAdminModel>> getVerses({
    required String bookId,
    required int chapterNumber,
  }) async {
    final snapshot = await _getVersesCollection(
      bookId: bookId,
      chapterNumber: chapterNumber,
    ).get();
    final verses = snapshot.docs.map((doc) {
      return SacredVerseAdminModel.fromMap(doc.data());
    }).toList();
    verses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
    return verses;
  }

  Future<void> saveVerse({
    required String bookId,
    required int chapterNumber,
    required SacredVerseAdminModel verse,
  }) async {
    final docId = verse.verseNumber.toString();
    await _getVersesCollection(bookId: bookId, chapterNumber: chapterNumber)
        .doc(docId)
        .set(verse.toMap(), SetOptions(merge: true));
  }

  Future<void> setPublishedStatus({
    required String bookId,
    required int chapterNumber,
    required int verseNumber,
    required bool published,
  }) async {
    await _getVersesCollection(bookId: bookId, chapterNumber: chapterNumber)
        .doc(verseNumber.toString())
        .update({
      'published': published,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteVerse({
    required String bookId,
    required int chapterNumber,
    required int verseNumber,
  }) async {
    await _getVersesCollection(bookId: bookId, chapterNumber: chapterNumber)
        .doc(verseNumber.toString())
        .delete();
  }
}
