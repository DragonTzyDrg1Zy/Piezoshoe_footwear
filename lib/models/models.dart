import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDevice {
  final String id;
  final String name;
  final int rssi;
  final BluetoothConnectionState connectionState;

  BluetoothDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.connectionState,
  });
}

class FootwearData {
  final double batteryLevel; // 0-100%
  final double voltage; // Microcontroller voltage reading
  final int stepCount;
  final DateTime timestamp;

  FootwearData({
    required this.batteryLevel,
    required this.voltage,
    required this.stepCount,
    required this.timestamp,
  });
}