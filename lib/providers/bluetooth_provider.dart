import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/models.dart';

class BluetoothProvider extends ChangeNotifier {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();
  
  List<BluetoothDevice> _availableDevices = [];
  BluetoothDevice? _connectedDevice;
  FootwearData? _latestData;
  bool _isScanning = false;
  bool _isDeviceOn = false;

  // Getters
  List<BluetoothDevice> get availableDevices => _availableDevices;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  FootwearData? get latestData => _latestData;
  bool get isScanning => _isScanning;
  bool get isDeviceOn => _isDeviceOn;

  // Start scanning for Bluetooth devices
  Future<void> startScanning() async {
    _isScanning = true;
    notifyListeners();

    try {
      _flutterBlue.startScan(timeout: const Duration(seconds: 10));
      
      _flutterBlue.scanResults.listen((results) {
        _availableDevices = results
            .map((result) => BluetoothDevice(
              id: result.device.remoteId.str,
              name: result.device.platformName,
              rssi: result.rssi,
              connectionState: result.device.connectionState,
            ))
            .toList();
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error starting scan: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  // Stop scanning
  Future<void> stopScanning() async {
    await _flutterBlue.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  // Connect to device
  Future<bool> connectToDevice(String deviceId) async {
    try {
      final device = BluetoothDevice(
        id: deviceId,
        name: 'Piezoshoe Device',
        rssi: 0,
        connectionState: BluetoothConnectionState.connected,
      );
      _connectedDevice = device;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      return false;
    }
  }

  // Disconnect from device
  Future<void> disconnectFromDevice() async {
    _connectedDevice = null;
    _isDeviceOn = false;
    notifyListeners();
  }

  // Toggle device on/off
  Future<void> toggleDevice(bool turnOn) async {
    try {
      _isDeviceOn = turnOn;
      // TODO: Send command to Arduino via Bluetooth
      // Command format: "ON" or "OFF"
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling device: $e');
    }
  }

  // Update footwear data (simulated or from Bluetooth)
  void updateFootwearData({
    required double batteryLevel,
    required double voltage,
    required int stepCount,
  }) {
    _latestData = FootwearData(
      batteryLevel: batteryLevel,
      voltage: voltage,
      stepCount: stepCount,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterBlue.stopScan();
    super.dispose();
  }
}