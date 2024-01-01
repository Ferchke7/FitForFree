import 'package:fitforfree/models/routine.dart';
import 'package:fitforfree/models/weeks_routine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'routines';
  static final _routinesName = 'weeks';
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'routines_database.db');

    return openDatabase(
      path,
      version: 2, // Increment the version if you make changes to the database schema
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        // Create the weeks table
        await _initRoutines(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Upgrade the database from version 1 to version 2
          await _initRoutines(db);
        }
      },
    );
  }

  Future<void> _initRoutines(Database db) async {
    await db.execute('''
      CREATE TABLE $_routinesName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monday TEXT,
        tuesday TEXT,
        wednesday TEXT,
        thursday TEXT,
        friday TEXT,
        saturday TEXT,
        sunday TEXT,
        foreignKey INTEGER,
        FOREIGN KEY(foreignKey) REFERENCES $_tableName(id)
      )
    ''');
  }

  Future<int> insertWeekRoutine(WeekRoutines weekRoutines) async {
    final db = await database;
    return await db.insert(_routinesName, weekRoutines.toMap());
  }

  Future<List<WeekRoutines>> getRoutinesByDayAndForeignKey(String dayOfWeek, int foreignKey) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    _routinesName,
    where: '($dayOfWeek = ?) AND (foreignKey = ?)',
    whereArgs: [dayOfWeek, foreignKey],
  );

  return List.generate(maps.length, (i) {
    return WeekRoutines.fromMap(maps[i]);
  });
  }

  Future<List<WeekRoutines>> getRoutinesByForeignKey(int? foreignKey) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    _routinesName,
    where: 'foreignKey = ?',
    whereArgs: [foreignKey],
  );

  return List.generate(maps.length, (i) {
    return WeekRoutines.fromMap(maps[i]);
  });
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