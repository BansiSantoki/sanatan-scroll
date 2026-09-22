import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sacred_verse_admin_model.dart';

class VersesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _resolveChapterDocId(String bookId, dynamic chapterNumber) async {
    final chaptersRef = _firestore.collection('sacred_books').doc(bookId).collection('chapters');
    final directId = chapterNumber.toString();

    try {
      final directSnap = await chaptersRef.doc(directId).get();
      if (directSnap.exists) {
        return directId;
      }

      final targetNum = int.tryParse(directId);
      if (targetNum != null) {
        final snap = await chaptersRef.get();
        for (final doc in snap.docs) {
          final cNum = _asInt(doc.data()['chapterNumber'] ?? doc.data()['chapter_number'], fallback: -1);
          final kNum = _asInt(doc.data()['kanda_number'], fallback: -1);
          if (cNum == targetNum || kNum == targetNum) {
            return doc.id;
          }
        }
      }
    } catch (_) {}

    return directId;
  }

  static int _asInt(dynamic val, {required int fallback}) {
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? fallback;
    return fallback;
  }

  Stream<List<SacredVerseAdminModel>> streamVerses({
    required String bookId,
    required dynamic chapterNumber,
  }) {
    late StreamController<List<SacredVerseAdminModel>> controller;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sub;

    controller = StreamController<List<SacredVerseAdminModel>>.broadcast(
      onListen: () async {
        final docId = await _resolveChapterDocId(bookId, chapterNumber);
        sub = _firestore
            .collection('sacred_books')
            .doc(bookId)
            .collection('chapters')
            .doc(docId)
            .collection('verses')
            .snapshots()
            .listen((snapshot) {
          final verses = snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return SacredVerseAdminModel.fromMap(data);
          }).toList();
          verses.sort((a, b) {
            final sargaA = a.sargaNumber ?? 1;
            final sargaB = b.sargaNumber ?? 1;
            if (sargaA != sargaB) return sargaA.compareTo(sargaB);
            return a.verseNumber.compareTo(b.verseNumber);
          });
          controller.add(verses);
        }, onError: (err) {
          controller.addError(err);
        });
      },
      onCancel: () => sub?.cancel(),
    );

    return controller.stream;
  }

  Future<List<SacredVerseAdminModel>> getVerses({
    required String bookId,
    required dynamic chapterNumber,
  }) async {
    final docId = await _resolveChapterDocId(bookId, chapterNumber);
    final snapshot = await _firestore
        .collection('sacred_books')
        .doc(bookId)
        .collection('chapters')
        .doc(docId)
        .collection('verses')
        .get();
    final verses = snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return SacredVerseAdminModel.fromMap(data);
    }).toList();
    verses.sort((a, b) {
      final sargaA = a.sargaNumber ?? 1;
      final sargaB = b.sargaNumber ?? 1;
      if (sargaA != sargaB) return sargaA.compareTo(sargaB);
      return a.verseNumber.compareTo(b.verseNumber);
    });
    return verses;
  }

  Future<void> saveVerse({
    required String bookId,
    required dynamic chapterNumber,
    required SacredVerseAdminModel verse,
  }) async {
    final chapDocId = await _resolveChapterDocId(bookId, chapterNumber);
    final verseDocId = (verse.verseId != null && verse.verseId!.isNotEmpty)
        ? verse.verseId!
        : verse.verseNumber.toString();

    await _firestore
        .collection('sacred_books')
        .doc(bookId)
        .collection('chapters')
        .doc(chapDocId)
        .collection('verses')
        .doc(verseDocId)
        .set(verse.toMap(), SetOptions(merge: true));
  }

  Future<void> setPublishedStatus({
    required String bookId,
    required dynamic chapterNumber,
    required dynamic verseNumber,
    required bool published,
  }) async {
    final chapDocId = await _resolveChapterDocId(bookId, chapterNumber);
    await _firestore
        .collection('sacred_books')
        .doc(bookId)
        .collection('chapters')
        .doc(chapDocId)
        .collection('verses')
        .doc(verseNumber.toString())
        .update({
      'published': published,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteVerse({
    required String bookId,
    required dynamic chapterNumber,
    required dynamic verseNumber,
  }) async {
    final chapDocId = await _resolveChapterDocId(bookId, chapterNumber);
    await _firestore
        .collection('sacred_books')
        .doc(bookId)
        .collection('chapters')
        .doc(chapDocId)
        .collection('verses')
        .doc(verseNumber.toString())
        .delete();
  }
}
