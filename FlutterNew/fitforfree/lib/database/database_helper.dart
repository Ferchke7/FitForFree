import 'package:fitforfree/models/Routine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'routines';

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'routines_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertRoutine(Routine routine) async {
    final db = await database;
    return await db.insert(_tableName, routine.toMap());
  }

  Future<List<Routine>> getRoutines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Routine(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<int> updateRoutine(Routine routine) async {
    final db = await database;
    return await db.update(
      _tableName,
      routine.toMap(),
      where: 'id = ?',
      whereArgs: [routine.id],
    );
  }
  Future deleteAllRoutines() async {
    final db = await database;
    return await db.rawDelete('DELETE FROM $_tableName');
  }

  Future<int> deleteRoutine(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}