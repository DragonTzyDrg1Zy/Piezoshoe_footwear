import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/bluetooth_provider.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate data updates
    _simulateDataUpdates();
  }

  void _simulateDataUpdates() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<BluetoothProvider>().updateFootwearData(
          batteryLevel: 85,
          voltage: 4.2,
          stepCount: 1234,
        );
        _simulateDataUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, _) {
        final data = bluetoothProvider.latestData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Device Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connected Device',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bluetoothProvider.connectedDevice?.name ?? 'Unknown',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        bluetoothProvider.connectedDevice?.id ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Battery Level
              _buildMetricCard(
                context,
                'Battery Level',
                '${data?.batteryLevel.toStringAsFixed(1) ?? '--'}%',
                data?.batteryLevel ?? 0,
              ),
              const SizedBox(height: 16),

              // Microcontroller Voltage
              _buildMetricCard(
                context,
                'Microcontroller Voltage',
                '${data?.voltage.toStringAsFixed(2) ?? '--'} V',
                (data?.voltage ?? 0) / 5 * 100, // Normalize to percentage for visualization
              ),
              const SizedBox(height: 16),

              // Step Counter
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step Counter',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${data?.stepCount ?? 0} steps',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${data?.timestamp.toString().split('.')[0] ?? '--'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Power Control Section
              Text(
                'Device Control',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: bluetoothProvider.isDeviceOn
                        ? () => bluetoothProvider.toggleDevice(false)
                        : null,
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text('Turn Off'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: !bluetoothProvider.isDeviceOn
                        ? () => bluetoothProvider.toggleDevice(true)
                        : null,
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text('Turn On'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Disconnect Button
              ElevatedButton.icon(
                onPressed: () async {
                  await bluetoothProvider.disconnectFromDevice();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Disconnected')),
                    );
                  }
                },
                icon: const Icon(Icons.bluetooth_disabled),
                label: const Text('Disconnect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    double percentage,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}