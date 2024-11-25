// create db

import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  final String TABLE_BULLETIN = "table";
  final String SNO_BULLETIN = "s_no";
  final String POINT_BULLETIN = "pont";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationCacheDirectory();

    String dbPatb = join(appDir.path, "bulletinDB.db");

    return openDatabase(dbPatb, onCreate: (db, version) {
      db.execute(
          "create table $TABLE_BULLETIN ($SNO_BULLETIN integer primary autoincrement, $POINT_BULLETIN text)");
    }, version: 1);
  }

  // query

  Future<List<Map<String, dynamic>>> readDB() async {
    var db = await getDB();
    return db.query(TABLE_BULLETIN);
  }

  // insert

  Future<void> addPoint({required String pt}) async {
    var db = await getDB();

    await db.insert(TABLE_BULLETIN, {POINT_BULLETIN: pt});
  }

// delete
  Future<void> removePoint({required int sno}) async {
    var db = await getDB();

    db.delete(TABLE_BULLETIN, where: "$SNO_BULLETIN = $sno");
  }
}
