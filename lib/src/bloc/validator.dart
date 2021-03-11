import 'dart:async';

import 'package:qr_reader_app/src/models/scan_model.dart';

class Validators {
  final validGeo =
    StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
      handleData: (scans, sink) {
        final geoScans = scans.where((s) => s.type == 'geo').toList();
        sink.add(geoScans);
  });

  final validHttp =
    StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
      handleData: (scans, sink) {
        final geoScans = scans.where((s) => s.type == 'http').toList();
        sink.add(geoScans);
  });
}
