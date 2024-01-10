import 'package:fitforfree/database/database_helper.dart';
import 'package:fitforfree/models/records.dart';
import 'package:fitforfree/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<int> insertUser(User user) async {
    Database db = await dbHelper.database;
    return await db.insert('user', user.toMap());
  }

  Future<List<User>> getUsers() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        monday: maps[i]['monday'],
        tuesday: maps[i]['tuesday'],
        wednesday: maps[i]['wednesday'],
        thursday: maps[i]['thursday'],
        friday: maps[i]['friday'],
        saturday: maps[i]['saturday'],
        sunday: maps[i]['sunday'],
        creationDate: maps[i]['creation_date'],
      );
    });
  }

  Future<User?> getUserByUsername(String username) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps =
        await db.query('user', where: 'username = ?', whereArgs: [username]);

    if (maps.isEmpty) {
      return null; // Return null if no user found with the given username
    }

    return User(
      id: maps[0]['id'],
      username: maps[0]['username'],
      monday: maps[0]['monday'],
      tuesday: maps[0]['tuesday'],
      wednesday: maps[0]['wednesday'],
      thursday: maps[0]['thursday'],
      friday: maps[0]['friday'],
      saturday: maps[0]['saturday'],
      sunday: maps[0]['sunday'],
      creationDate: maps[0]['creation_date'],
    );
  }

  Future<int> insertRecord(Records record) async {
    Database db = await dbHelper.database;
    return await db.insert('records', {
      ...record.toMap(),
      'week_name': record.weekName,
      'date': record.date,
    });
  }

  Future<List<Records>> getRecordsByUserId(int userId) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps =
        await db.query('records', where: 'user_id = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) {
      return Records(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        record: maps[i]['record'],
        weekName: maps[i]['week_name'],
        date: maps[i]['date'],
      );
    });
  }

  Future<int> deleteRecord(int recordId) async {
    Database db = await dbHelper.database;
    return await db.delete('records', where: 'id = ?', whereArgs: [recordId]);
  }

  Future<List<Records>> getRecordsByWeekName(String weekName) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db
        .query('records', where: 'week_name = ?', whereArgs: [weekName]);

    return List.generate(maps.length, (i) {
      return Records(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        record: maps[i]['record'],
        weekName: maps[i]['week_name'],
        date: maps[i]['date'],
      );
    });
  }

  Future<List<Records>> getRecordsByUserIdAndWeekName(
      int userId, String weekName) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'records',
      where: 'user_id = ? AND week_name = ?',
      whereArgs: [userId, weekName],
    );

    return List.generate(maps.length, (i) {
      return Records(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        record: maps[i]['record'],
        weekName: maps[i]['week_name'],
        date: maps[i]['date'],
      );
    });
  }

  Future<int> updateUser(User updatedUser) async {
    Database db = await dbHelper.database;
    return await db.update(
      'user',
      updatedUser.toMap(),
      where: 'id = ?',
      whereArgs: [updatedUser.id],
    );
  }
}
