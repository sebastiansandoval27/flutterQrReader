import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/pages/address_page.dart';
import 'package:qr_reader_app/src/pages/maps_page.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _bottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5), label: 'Address'),
        ]);
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
        break;
      case 1:
        return AddressPage();
        break;
      default:
        return MapsPage();
    }
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _scanQR,
    );
  }

  void _scanQR() async {
    // https://portfolio.sebastiansandoval27.vercel.app
    // geo: -73.35824743845453,5.514509965654052,500

    String futureString = 'https://portfolio.sebastiansandoval27.vercel.app';
/* 
    try {
      //futureString = await new QRCodeReader().scan();
      futureString = await FlutterBarcodeScanner.scanBarcode( '', 'Cancel', false,null);
    } catch (e) {
      futureString = e.toString();
    }
    */

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      scansBloc.insertScan(scan);
    }
  }
}
