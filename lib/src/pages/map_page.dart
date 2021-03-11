import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qr_reader_app/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                map.move(scanModel.getLatLng(), 5.0, id: '');
              })
        ],
      ),
      body: _createFlutterMap(scanModel),
      floatingActionButton: _floatingbutton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: new MapOptions(
        center: scan.getLatLng(),
        zoom: 5.0,
        maxZoom: 5.0,
        minZoom: 3.0,
      ),
      layers: [
        _createMap(),
        _optionsMap(scan),
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']);
  }

  _optionsMap(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => new Container(
            child: Icon(Icons.location_on,
                size: 85.0, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  _floatingbutton(context) {
    return FloatingActionButton(
      onPressed: () {
         // streets, dark, light, outdoors, satellite
        if ( mapType == 'streets' ) {
          mapType = 'dark';
        } else if ( mapType == 'dark' ) {
          mapType = 'light';
        } else if ( mapType == 'light' ) {
          mapType = 'outdoors';
        } else if ( mapType == 'outdoors' ) {
          mapType = 'satellite';
        } else {
          mapType = 'streets';
        }

        setState((){});
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.repeat),
    );
  }
}
