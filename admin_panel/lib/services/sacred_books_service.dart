import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sacred_book_admin_model.dart';

class SacredBooksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _booksCollection =>
      _firestore.collection('sacred_books');

  Stream<List<SacredBookAdminModel>> streamBooks() {
    return _booksCollection.snapshots().map((snapshot) {
      final books = snapshot.docs.map((doc) {
        return SacredBookAdminModel.fromMap(doc.id, doc.data());
      }).toList();
      books.sort((a, b) => a.order.compareTo(b.order));
      return books;
    });
  }

  Future<List<SacredBookAdminModel>> getBooks() async {
    final snapshot = await _booksCollection.get();
    final books = snapshot.docs.map((doc) {
      return SacredBookAdminModel.fromMap(doc.id, doc.data());
    }).toList();
    books.sort((a, b) => a.order.compareTo(b.order));
    return books;
  }

  Future<SacredBookAdminModel?> getBookById(String id) async {
    final doc = await _booksCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return SacredBookAdminModel.fromMap(doc.id, doc.data()!);
  }

  Future<void> saveBook(SacredBookAdminModel book) async {
    await _booksCollection.doc(book.id).set(
          book.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> setPublishedStatus(String bookId, bool published) async {
    await _booksCollection.doc(bookId).update({
      'published': published,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteBook(String bookId) async {
    await _booksCollection.doc(bookId).delete();
  }
}
