import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';
class TrainingDatabaseHelper {
  

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'flutterjunction.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE trainings(
        
        userId String PRIMARY KEY,
        activityName String,
        repNumber INT,
        weight INT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<int> createItem(String userId, int? repNumber, int? weight) async {
    final db = await TrainingDatabaseHelper.db();

    final data = {'userId': userId,'repNumber': repNumber, 'weight': weight};
    final id = await db.insert('trainings', data);
    return id;
  }

  // Read all items 
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await TrainingDatabaseHelper.db();
    return db.query('trainings', orderBy: "repNumber");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
    static Future<List<Map<String, dynamic>>> getItem(int repNumber) async {
    final db = await TrainingDatabaseHelper.db();
    return db.query('trainings', where: "repNumber = ?", whereArgs: [repNumber], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await TrainingDatabaseHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await TrainingDatabaseHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}