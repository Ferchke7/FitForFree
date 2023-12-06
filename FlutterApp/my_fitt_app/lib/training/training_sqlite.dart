import 'package:my_fitt_app/user_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'fitness_app.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        dateOfBirth TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS trainings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        dayOfWeek TEXT,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainingId INTEGER,
        date TEXT,
        FOREIGN KEY (trainingId) REFERENCES trainings (id)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS reps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recordId INTEGER,
        count INTEGER,
        weight INTEGER,
        FOREIGN KEY (recordId) REFERENCES records (id)
      )
    ''');
  }

  static Future<void> createUser(User user) async {
    final db = await DatabaseHelper.db();
    await db.insert('users', user.toJson());
  }

  static Future<User?> getUser(String userId) async {
    final db = await DatabaseHelper.db();
    final userData = await db.query('users', where: 'id = ?', whereArgs: [userId], limit: 1);

    if (userData.isEmpty) {
      return null;
    }

    final List<Map<String, dynamic>> trainingData = await db.query('trainings', where: 'userId = ?', whereArgs: [userId]);

    final List<Training> trainings = trainingData.map((trainingMap) {
      final List<Map<String, dynamic>> recordData = [];

      return Training(
        dayOfWeek: trainingMap['dayOfWeek'],
        records: recordData.map((recordMap) {
          final List<Map<String, dynamic>> repData = [];

          return Record(
            date: DateTime.parse(recordMap['date']),
            reps: repData.map((repMap) {
              return Rep(
                count: repMap['count'],
                weight: repMap['weight'],
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();

    final user = User.fromJson(userData.first);
    user.trainings = trainings;

    return user;
  }

  // Other helper methods for updating and deleting data go here...
}
