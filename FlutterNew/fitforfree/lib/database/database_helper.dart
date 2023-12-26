import 'package:fitforfree/database/routine_models.dart';
import 'package:fitforfree/database/user_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS user(
      email TEXT PRIMARY KEY
    )
  ''');

  await db.execute('''
    CREATE TABLE routine(
      id INTEGER PRIMARY AUTOINCREMENT KEY,
      user_email TEXT,
      monday TEXT,
      tuesday TEXT,
      wednesday TEXT,
      thursday TEXT,
      friday TEXT,
      saturday TEXT,
      sunday TEXT,
      FOREIGN KEY (user_email) REFERENCES user(email)
    )
  ''');
}

  // CREATE
  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('user', user.toMap());
  }

  Future<int> insertRoutine(Routine routine) async {
    Database db = await instance.database;
    return await db.insert('routine', routine.toMap());
  }
  
  // READ
  Future<List<User>> getAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('user');
    return result.map((map) => User(email: map['email'])).toList();
  }

  Future<List<Routine>> getAllRoutines() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('routine');
    return result
        .map((map) => Routine(
              id: map['id'],
              userEmail: map['user_email'],
              monday: map['monday'],
              tuesday: map['tuesday'],
              wednesday: map['wednesday'],
              thursday: map['thursday'],
              friday: map['friday'],
              saturday: map['saturday'],
              sunday: map['sunday'],
            ))
        .toList();
  }

  // UPDATE
  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update('user', user.toMap(),
        where: 'email = ?', whereArgs: [user.email]);
  }

  Future<int> updateRoutine1(Routine routine) async {
    Database db = await instance.database;
    return await db.update('routine', routine.toMap(),
        where: 'id = ?', whereArgs: [routine.id]);
  }

  // DELETE
  Future<int> deleteUser(String email) async {
    Database db = await instance.database;
    return await db.delete('user', where: 'email = ?', whereArgs: [email]);
  }

  Future<int> deleteRoutine(int id) async {
    Database db = await instance.database;
    return await db.delete('routine', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<Routine>> getAllRoutinesForUser(String userEmail) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'routine',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );
    return result
        .map((map) => Routine(
              id: map['id'],
              userEmail: map['user_email'],
              monday: map['monday'],
              tuesday: map['tuesday'],
              wednesday: map['wednesday'],
              thursday: map['thursday'],
              friday: map['friday'],
              saturday: map['saturday'],
              sunday: map['sunday'],
            ))
        .toList();
  }

  // UPDATE
  Future<int> updateRoutine(Routine routine) async {
    Database db = await instance.database;
    return await db.update('routine', routine.toMap(),
        where: 'id = ?', whereArgs: [routine.id]);
  }
}
