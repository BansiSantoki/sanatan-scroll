import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingPosition {
  const ReadingPosition({
    required this.bookId,
    this.chapterId,
    this.chapterNumber = 1,
    this.chapterName,
    this.kandaId,
    this.kandaNumber,
    this.kandaName,
    this.sargaId,
    this.sargaNumber,
    this.sargaName,
    this.verseId,
    this.verseNumber = 1,
    this.passageId,
    this.mantraNumber,
    this.pageIndex = 0,
    this.lastReadAt,
  });

  final String bookId;
  final String? chapterId;
  final int chapterNumber;
  final String? chapterName;
  final String? kandaId;
  final int? kandaNumber;
  final String? kandaName;
  final String? sargaId;
  final int? sargaNumber;
  final String? sargaName;
  final String? verseId;
  final int verseNumber;
  final String? passageId;
  final int? mantraNumber;
  final int pageIndex;
  final DateTime? lastReadAt;

  factory ReadingPosition.fromMap(String defaultBookId, Map<String, dynamic> map) {
    final bId = (map['bookId'] ?? defaultBookId).toString();
    final cNum = _asInt(map['chapterNumber'] ?? map['chapter_number'], fallback: 1);
    final vNum = _asInt(map['verseNumber'] ?? map['verse_number'] ?? map['shlokaNumber'] ?? map['shlok_no'], fallback: 1);
    final kNum = _asIntNullable(map['kandaNumber'] ?? map['kanda_number'] ?? map['kanda_no']);
    final sNum = _asIntNullable(map['sargaNumber'] ?? map['sarga_number'] ?? map['sarga_no']);
    final mNum = _asIntNullable(map['mantraNumber'] ?? map['mantra_number']);
    final pIdx = _asInt(map['pageIndex'], fallback: 0);

    return ReadingPosition(
      bookId: bId,
      chapterId: map['chapterId']?.toString(),
      chapterNumber: cNum,
      chapterName: map['chapterName']?.toString(),
      kandaId: map['kandaId']?.toString(),
      kandaNumber: kNum ?? (cNum >= 1000 ? cNum ~/ 1000 : null),
      kandaName: map['kandaName']?.toString(),
      sargaId: map['sargaId']?.toString(),
      sargaNumber: sNum ?? (cNum >= 1000 ? cNum % 1000 : null),
      sargaName: map['sargaName']?.toString(),
      verseId: map['verseId']?.toString(),
      verseNumber: vNum,
      passageId: map['passageId']?.toString(),
      mantraNumber: mNum ?? (bId == 'upanishads' ? cNum : null),
      pageIndex: pIdx,
      lastReadAt: map['updatedAt'] != null || map['lastReadAt'] != null
          ? _parseDateTime(map['updatedAt'] ?? map['lastReadAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      if (chapterId != null) 'chapterId': chapterId,
      'chapterNumber': chapterNumber,
      if (chapterName != null) 'chapterName': chapterName,
      if (kandaId != null) 'kandaId': kandaId,
      if (kandaNumber != null) 'kandaNumber': kandaNumber,
      if (kandaName != null) 'kandaName': kandaName,
      if (sargaId != null) 'sargaId': sargaId,
      if (sargaNumber != null) 'sargaNumber': sargaNumber,
      if (sargaName != null) 'sargaName': sargaName,
      if (verseId != null) 'verseId': verseId,
      'verseNumber': verseNumber,
      if (passageId != null) 'passageId': passageId,
      if (mantraNumber != null) 'mantraNumber': mantraNumber,
      'pageIndex': pageIndex,
      'lastReadAt': lastReadAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> toRouteArguments() {
    return {
      'textId': bookId,
      'bookId': bookId,
      'chapterNumber': chapterNumber,
      'kandaNumber': kandaNumber,
      'sargaNumber': sargaNumber,
      'verseNumber': verseNumber,
      'mantraNumber': mantraNumber,
      'verseId': verseId,
      'passageId': passageId,
      'pageIndex': pageIndex,
    };
  }

  static int _asInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static int? _asIntNullable(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is Timestamp) return raw.toDate();
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }
}

class ReadingProgressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, ReadingPosition> _positions = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSubscription;
  String _activeUserId = '';
  String _lastReadBookId = 'bhagavad_gita';

  String get lastReadBookId => _lastReadBookId;

  ReadingPosition? get latestPosition {
    if (_positions.isEmpty) return null;
    ReadingPosition? latest;
    for (final pos in _positions.values) {
      if (latest == null) {
        latest = pos;
      } else if (pos.lastReadAt != null &&
          (latest.lastReadAt == null || pos.lastReadAt!.isAfter(latest.lastReadAt!))) {
        latest = pos;
      }
    }
    return latest;
  }

  void _syncLastReadBookIdFromPositions() {
    final latest = latestPosition;
    if (latest != null && latest.bookId.isNotEmpty) {
      _lastReadBookId = latest.bookId;
    }
  }

  ReadingProgressProvider() {
    _loadLocalLastRead();
  }

  Future<void> _loadLocalLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBook = prefs.getString('last_read_book_id');
      if (savedBook != null && savedBook.isNotEmpty) {
        _lastReadBookId = savedBook;
      }

      final positionsJson = prefs.getString('reading_positions_json');
      if (positionsJson != null && positionsJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(positionsJson);
        decoded.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            _positions[key] = ReadingPosition.fromMap(key, value);
          }
        });
        _syncLastReadBookIdFromPositions();
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading local reading positions: $e');
      }
    }
  }

  Future<void> _savePositionsLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_read_book_id', _lastReadBookId);

      final Map<String, dynamic> encoded = {};
      _positions.forEach((key, pos) {
        encoded[key] = pos.toMap();
      });
      await prefs.setString('reading_positions_json', jsonEncode(encoded));
    } catch (_) {}
  }

  ReadingPosition? positionFor(String bookId) => _positions[bookId];

  Future<void> setLastReadBookId(String bookId) async {
    // Browsing a book/screen MUST NOT change the user's last reading progress.
    // Progress is ONLY updated when actual reading activity occurs via savePosition.
    if (kDebugMode) {
      debugPrint('[CONTINUE_DEBUG] setLastReadBookId ignored for browsing book: $bookId');
    }
  }

  void bindUser(String userId) {
    if (_activeUserId == userId) return;

    _subscription?.cancel();
    _userDocSubscription?.cancel();
    _activeUserId = userId;

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
        if (savedBook != null && savedBook.isNotEmpty && _positions.isEmpty) {
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
        _positions[doc.id] = ReadingPosition.fromMap(doc.id, data);
      }
      _syncLastReadBookIdFromPositions();
      _savePositionsLocally();
      notifyListeners();
    });
  }

  Future<void> savePosition({
    required String bookId,
    String? chapterId,
    required int chapterNumber,
    String? chapterName,
    String? kandaId,
    int? kandaNumber,
    String? kandaName,
    String? sargaId,
    int? sargaNumber,
    String? sargaName,
    String? verseId,
    required int verseNumber,
    String? passageId,
    int? mantraNumber,
    int pageIndex = 0,
    String reason = 'Actual reading activity',
  }) async {
    final position = ReadingPosition(
      bookId: bookId,
      chapterId: chapterId,
      chapterNumber: chapterNumber,
      chapterName: chapterName,
      kandaId: kandaId,
      kandaNumber: kandaNumber ?? (chapterNumber >= 1000 ? chapterNumber ~/ 1000 : null),
      kandaName: kandaName,
      sargaId: sargaId,
      sargaNumber: sargaNumber ?? (chapterNumber >= 1000 ? chapterNumber % 1000 : null),
      sargaName: sargaName,
      verseId: verseId,
      verseNumber: verseNumber,
      passageId: passageId,
      mantraNumber: mantraNumber ?? (bookId == 'upanishads' ? chapterNumber : null),
      pageIndex: pageIndex,
      lastReadAt: DateTime.now(),
    );

    _positions[bookId] = position;
    _lastReadBookId = bookId;
    notifyListeners();
    _savePositionsLocally();

    if (kDebugMode) {
      debugPrint('==================================================');
      debugPrint('[CONTINUE_DEBUG] PROGRESS UPDATED / SAVED');
      debugPrint('bookId: $bookId');
      debugPrint('chapterNumber: $chapterNumber');
      debugPrint('kandaNumber: ${position.kandaNumber}');
      debugPrint('sargaNumber: ${position.sargaNumber}');
      debugPrint('mantraNumber: ${position.mantraNumber}');
      debugPrint('verseId: $verseId');
      debugPrint('verseNumber: $verseNumber');
      debugPrint('pageIndex: $pageIndex');
      debugPrint('reason: $reason');
      debugPrint('timestamp: ${position.lastReadAt?.toIso8601String()}');
      debugPrint('==================================================');
    }

    if (_activeUserId.isEmpty) return;

    try {
      await _firestore
          .collection('users')
          .doc(_activeUserId)
          .collection('reading_progress')
          .doc(bookId)
          .set({
        ...position.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firestore.collection('users').doc(_activeUserId).set({
        'lastReadBookId': bookId,
        'lastReadChapterNumber': chapterNumber,
        'lastReadVerseNumber': verseNumber,
        'lastReadPosition': position.toMap(),
        'lastReadUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error updating Firestore reading progress: $e');
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }
}

