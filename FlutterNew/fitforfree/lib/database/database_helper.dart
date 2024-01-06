import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    String path = join(await getDatabasesPath(), 'userDb.db'); //fvf.db
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  
Future<void> _createDb(Database db, int version) async {
  
  await db.execute('''
    CREATE TABLE IF NOT EXISTS user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      monday TEXT,
      tuesday TEXT,
      wednesday TEXT,
      thursday TEXT,
      friday TEXT,
      saturday TEXT,
      sunday TEXT,
      creation_date TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS records(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      record TEXT,
      week_name TEXT,
      date TEXT, 
      FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
    )
  ''');
  }

  
}