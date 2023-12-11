import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_printer/services/bluetooth_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  BluetoothService bl = BluetoothService();
  void _startScanDevices() {
    printerManager.startScan(const Duration(seconds: 2));
    printerManager.scanResults.listen((event) {
      print("ini device: $event");
      if (event.isNotEmpty) {
        setState(() {
          _devices = event;
          print("device: $_devices");
        });
      }
    });
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _startScanDevices();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Coba Print"),
            ElevatedButton(
                onPressed: () {
                  bl.testPrint(_devices[0]);
                },
                child: const Text('Test Print'))
          ],
        )),
        floatingActionButton: StreamBuilder(
            stream: printerManager.isScanningStream,
            initialData: false,
            builder: (context, snapshoot) {
              if (snapshoot.data!) {
                return FloatingActionButton(
                  onPressed: _stopScanDevices,
                  child: const Icon(Icons.stop),
                );
              } else {
                return FloatingActionButton(
                  onPressed: _startScanDevices,
                  child: const Icon(Icons.search),
                );
              }
            }),
      ),
    );
  }
}
