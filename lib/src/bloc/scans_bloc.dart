import 'dart:async';

import 'package:qr_reader_app/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Get Scans from DB
    getScans();
  }

  final _scansController = new StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getScans());
  }

  insertScan(ScanModel scanModel) async {
    await DBProvider.db.insertScan(scanModel);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScans(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    getScans();
  }
}
