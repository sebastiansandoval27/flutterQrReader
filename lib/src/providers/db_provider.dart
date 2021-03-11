import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:qr_reader_app/src/models/scan_model.dart';
export 'package:qr_reader_app/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')');
    });
  }

  // INSERT
  newScanRaw(ScanModel newScan) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Scans (id, type, value) "
        "VALUES ( ${newScan.id}, '${newScan.type}', '${newScan.value}'  )");

    return res;
  }

  insertScan(ScanModel newScan) async {
    final db = await database;

    final res = await db.insert('Scans', newScan.toJson());

    return res;
  }

  // SELECT GET DATA
  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  // SELECT GET ALL
  Future<List<ScanModel>> getScans() async {
    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];

    return list;
  }

  // GET ALL WHERE
  Future<List<ScanModel>> getScansByType(String typeScan) async {
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE type='$typeScan'");

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];

    return list;
  }

  // UPDATE SCANS

  Future<int> updateScans(ScanModel newScan) async {
    final db = await database;

    final res = await db.update('Scans', newScan.toJson(),
        where: 'id = ?', whereArgs: [newScan.id]);

    return res;
  }

  // DELETE SCANS

  Future<int> deleteScans(int id) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // DELETE ALL SCANS

  Future<int> deleteAllScans() async {
    final db = await database;

    final res = await db.rawDelete('DELETE FROM Scans');

    return res;
  }
}
