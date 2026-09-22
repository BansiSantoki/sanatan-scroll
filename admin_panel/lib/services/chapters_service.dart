import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sacred_chapter_admin_model.dart';

class ChaptersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _getChaptersCollection(String bookId) {
    return _firestore.collection('sacred_books').doc(bookId).collection('chapters');
  }

  Stream<List<SacredChapterAdminModel>> streamChapters(String bookId) {
    return _getChaptersCollection(bookId).snapshots().map((snapshot) {
      final chapters = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return SacredChapterAdminModel.fromMap(data);
      }).toList();
      chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      return chapters;
    });
  }

  Future<List<SacredChapterAdminModel>> getChapters(String bookId) async {
    final snapshot = await _getChaptersCollection(bookId).get();
    final chapters = snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return SacredChapterAdminModel.fromMap(data);
    }).toList();
    chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    return chapters;
  }

  Future<void> saveChapter(String bookId, SacredChapterAdminModel chapter) async {
    final docId = (chapter.id != null && chapter.id!.isNotEmpty)
        ? chapter.id!
        : (chapter.kandaNumber != null && chapter.sargaNumber != null)
            ? 'kanda_${chapter.kandaNumber}_sarga_${chapter.sargaNumber}'
            : chapter.chapterNumber.toString();

    await _getChaptersCollection(bookId).doc(docId).set(
          chapter.toMap(),
          SetOptions(merge: true),
        );
    
    // Also update parent book's totalChapters count
    final snapshot = await _getChaptersCollection(bookId).get();
    await _firestore.collection('sacred_books').doc(bookId).update({
      'totalChapters': snapshot.docs.length,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setPublishedStatus(String bookId, dynamic chapterIdOrNumber, bool published) async {
    final docId = chapterIdOrNumber.toString();
    await _getChaptersCollection(bookId).doc(docId).update({
      'published': published,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteChapter(String bookId, dynamic chapterIdOrNumber) async {
    final docId = chapterIdOrNumber.toString();
    await _getChaptersCollection(bookId).doc(docId).delete();
    
    final snapshot = await _getChaptersCollection(bookId).get();
    await _firestore.collection('sacred_books').doc(bookId).update({
      'totalChapters': snapshot.docs.length,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
