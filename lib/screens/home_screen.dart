import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bluetooth_provider.dart';
import 'device_list_screen.dart';
import 'monitoring_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BluetoothProvider>().startScanning();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piezoshoe Footwear Monitor'),
        elevation: 0,
      ),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, _) {
          // If device is connected, show monitoring screen
          if (bluetoothProvider.connectedDevice != null) {
            return const MonitoringScreen();
          }
          
          // Otherwise show device list
          return const DeviceListScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    context.read<BluetoothProvider>().stopScanning();
    super.dispose();
  }
}