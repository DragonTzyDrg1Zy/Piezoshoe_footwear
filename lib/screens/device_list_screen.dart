import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bluetooth_provider.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await bluetoothProvider.stopScanning();
            await bluetoothProvider.startScanning();
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Devices',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pull to refresh',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (bluetoothProvider.availableDevices.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: bluetoothProvider.isScanning
                        ? const CircularProgressIndicator()
                        : Text(
                            'No devices found',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                  ),
                )
              else
                ...bluetoothProvider.availableDevices.map((device) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.id),
                      trailing: Text('${device.rssi} dBm'),
                      onTap: () async {
                        final connected = await bluetoothProvider.connectToDevice(device.id);
                        if (connected && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Connected to ${device.name}')),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }
}