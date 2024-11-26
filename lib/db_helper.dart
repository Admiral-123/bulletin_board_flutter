import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();

  final String TABLE_BULLETIN = "bulletin_table";
  final String SNO_BULLETIN = "s_no";
  final String POINT_BULLETIN = "point";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir =
        await getApplicationDocumentsDirectory(); // Fix for correct path
    String dbPath = join(appDir.path, "bulletinDB.db");

    return openDatabase(
      dbPath,
      onCreate: (db, version) async {
        print("Creating table...");
        await db.execute(
          "CREATE TABLE $TABLE_BULLETIN ($SNO_BULLETIN INTEGER PRIMARY KEY AUTOINCREMENT, $POINT_BULLETIN TEXT)",
        );
        print("Table $TABLE_BULLETIN created successfully.");
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> readDB() async {
    try {
      var db = await getDB();
      return await db.query(TABLE_BULLETIN);
    } catch (e) {
      print("Error reading database: $e");
      return [];
    }
  }

  Future<void> addPoint({required String pt}) async {
    var db = await getDB();
    await db.insert(TABLE_BULLETIN, {POINT_BULLETIN: pt});
  }

  Future<void> removePoint({required int sno}) async {
    var db = await getDB();
    await db
        .delete(TABLE_BULLETIN, where: "$SNO_BULLETIN = ?", whereArgs: [sno]);
  }
}
