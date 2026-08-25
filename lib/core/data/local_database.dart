import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/streak_model.dart';
import '../../models/wisdom_model.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final docs = await getApplicationDocumentsDirectory();
    final path = p.join(docs.path, 'sanatan_scroll.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE completed_dates(
        date TEXT PRIMARY KEY
      );
    ''');

    await db.execute('''
      CREATE TABLE wisdom(
        id TEXT PRIMARY KEY,
        quote TEXT,
        source TEXT,
        chapter TEXT,
        verse TEXT,
        sanskrit TEXT,
        reflection TEXT,
        sageAdvice TEXT,
        tags TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE daily_assignment(
        date TEXT PRIMARY KEY,
        wisdom_id TEXT,
        fixed INTEGER DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE book_progress(
        book_id TEXT,
        chapter_number INTEGER,
        read INTEGER DEFAULT 0,
        PRIMARY KEY(book_id, chapter_number)
      );
    ''');

    await db.execute('''
      CREATE TABLE settings(
        key TEXT PRIMARY KEY,
        value TEXT
      );
    ''');
  }

  // Streaks / completed dates
  Future<void> addCompletedDate(DateTime date) async {
    final db = await database;
    final iso = _dateKey(date);
    await db.insert('completed_dates', {'date': iso}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeCompletedDate(DateTime date) async {
    final db = await database;
    final iso = _dateKey(date);
    await db.delete('completed_dates', where: 'date = ?', whereArgs: [iso]);
  }

  Future<List<DateTime>> getCompletedDates() async {
    final db = await database;
    final rows = await db.query('completed_dates');
    return rows.map((r) => DateTime.parse(r['date'] as String)).toList();
  }

  Future<StreakModel> computeStreakModel({int milestoneTarget = 30, String milestoneLabel = 'Steady — 30 Days'}) async {
    final completed = await getCompletedDates();
    final set = completed.map((d) => DateTime(d.year, d.month, d.day)).toSet();

    final now = DateTime.now();
    int current = 0;
    for (int i = 0; ; i++) {
      final day = DateTime(now.year, now.month, now.day - i);
      if (set.contains(day)) {
        current++;
      } else {
        break;
      }
    }

    // longest streak: simple scan
    final sorted = set.toList()..sort();
    int longest = 0;
    int running = 0;
    for (int i = 0; i < sorted.length; i++) {
      if (i == 0) {
        running = 1;
      } else {
        final prev = sorted[i - 1];
        final curr = sorted[i];
        if (curr.difference(prev).inDays == 1) {
          running++;
        } else {
          if (running > longest) longest = running;
          running = 1;
        }
      }
    }
    if (running > longest) longest = running;

    return StreakModel(
      currentStreak: current,
      longestStreak: longest,
      totalDays: set.length,
      completedDates: sorted,
      milestoneTarget: milestoneTarget,
      milestoneLabel: milestoneLabel,
      wisdomCollected: await _wisdomCount(),
    );
  }

  Future<int> _wisdomCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM wisdom')) ?? 0;
    return count;
  }

  // Wisdom
  Future<void> upsertWisdom(WisdomModel wisdom) async {
    final db = await database;
    await db.insert(
      'wisdom',
      {
        'id': wisdom.id,
        'quote': wisdom.quote,
        'source': wisdom.source,
        'chapter': wisdom.chapter,
        'verse': wisdom.verse,
        'sanskrit': wisdom.sanskrit,
        'reflection': wisdom.reflection,
        'sageAdvice': wisdom.sageAdvice,
        'tags': jsonEncode(wisdom.tags),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<WisdomModel?> getWisdomById(String id) async {
    final db = await database;
    final rows = await db.query('wisdom', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return _rowToWisdom(r);
  }

  WisdomModel _rowToWisdom(Map<String, Object?> r) {
    final tagsJson = (r['tags'] as String?) ?? '[]';
    final tags = (jsonDecode(tagsJson) as List).whereType<String>().toList();
    return WisdomModel(
      id: r['id'] as String,
      quote: (r['quote'] ?? '') as String,
      source: (r['source'] ?? '') as String,
      chapter: (r['chapter'] ?? '') as String,
      verse: (r['verse'] ?? '') as String,
      sanskrit: r['sanskrit'] as String?,
      reflection: r['reflection'] as String?,
      sageAdvice: r['sageAdvice'] as String?,
      tags: tags,
    );
  }

  Future<void> assignWisdomForDate(DateTime date, String wisdomId, {bool fixed = false}) async {
    final db = await database;
    await db.insert(
      'daily_assignment',
      {'date': _dateKey(date), 'wisdom_id': wisdomId, 'fixed': fixed ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<WisdomModel?> wisdomForDate(DateTime date) async {
    final db = await database;
    final rows = await db.query('daily_assignment', where: 'date = ?', whereArgs: [_dateKey(date)]);
    if (rows.isEmpty) return null;
    final wisdomId = rows.first['wisdom_id'] as String?;
    if (wisdomId == null) return null;
    return getWisdomById(wisdomId);
  }

  // Book progress
  Future<void> markChapterRead(String bookId, int chapterNumber, {bool read = true}) async {
    final db = await database;
    await db.insert(
      'book_progress',
      {'book_id': bookId, 'chapter_number': chapterNumber, 'read': read ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> chaptersReadCount(String bookId) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM book_progress WHERE book_id = ? AND read = 1', [bookId])) ?? 0;
    return count;
  }

  Future<List<int>> readChapters(String bookId) async {
    final db = await database;
    final rows = await db.query('book_progress', where: 'book_id = ? AND read = 1', whereArgs: [bookId]);
    return rows.map((r) => r['chapter_number'] as int).toList();
  }

  String _dateKey(DateTime d) => DateTime(d.year, d.month, d.day).toIso8601String();
}
