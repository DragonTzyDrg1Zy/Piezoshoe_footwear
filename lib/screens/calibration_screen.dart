import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bluetooth_provider.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({Key? key}) : super(key: key);

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  final TextEditingController baselineXController = TextEditingController(text: '512');
  final TextEditingController baselineYController = TextEditingController(text: '512');
  final TextEditingController baselineZController = TextEditingController(text: '512');
  final TextEditingController stepThresholdController = TextEditingController(text: '100');
  final TextEditingController batteryMinController = TextEditingController(text: '3.0');
  final TextEditingController batteryMaxController = TextEditingController(text: '4.2');

  bool isCalibrating = false;

  Future<void> _calibrateBaseline() async {
    setState(() => isCalibrating = true);
    try {
      int x = int.parse(baselineXController.text);
      int y = int.parse(baselineYController.text);
      int z = int.parse(baselineZController.text);
      String command = 'CALIBRATE_BASELINE:$x,$y,$z';
      await context.read<BluetoothProvider>().sendCommand(command);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Baseline calibration sent')),
        );
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => isCalibrating = false);
    }
  }

  Future<void> _calibrateStepThreshold() async {
    setState(() => isCalibrating = true);
    try {
      int threshold = int.parse(stepThresholdController.text);
      String command = 'SET_THRESHOLD:$threshold';
      await context.read<BluetoothProvider>().sendCommand(command);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Step threshold updated')),
        );
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => isCalibrating = false);
    }
  }

  Future<void> _calibrateBatteryVoltage() async {
    setState(() => isCalibrating = true);
    try {
      double min = double.parse(batteryMinController.text);
      double max = double.parse(batteryMaxController.text);
      String command = 'SET_BATTERY:$min,$max';
      await context.read<BluetoothProvider>().sendCommand(command);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Battery calibration updated')),
        );
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => isCalibrating = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calibration'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accelerometer Section
            _buildSection(
              'Accelerometer Baseline',
              'Set X, Y, Z values (typically ~512)',
              [
                _buildInput('X Axis', baselineXController),
                _buildInput('Y Axis', baselineYController),
                _buildInput('Z Axis', baselineZController),
              ],
              _calibrateBaseline,
              'Apply',
            ),
            const SizedBox(height: 24),

            // Step Threshold Section
            _buildSection(
              'Step Threshold',
              'Lower = more sensitive, Higher = less sensitive',
              [
                _buildInput('Threshold', stepThresholdController),
              ],
              _calibrateStepThreshold,
              'Apply',
            ),
            const SizedBox(height: 24),

            // Battery Calibration Section
            _buildSection(
              'Battery Calibration',
              'Set min and max voltage (Volts)',
              [
                _buildInput('Min Voltage', batteryMinController),
                _buildInput('Max Voltage', batteryMaxController),
              ],
              _calibrateBatteryVoltage,
              'Apply',
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tips',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Place shoe on flat surface before calibrating\n'
                    '• Baseline readings should be ~512\n'
                    '• Adjust threshold based on step sensitivity\n'
                    '• Battery min/max from multimeter readings',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    String subtitle,
    List<Widget> inputs,
    Future<void> Function() onApply,
    String buttonText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          ...inputs,
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isCalibrating ? null : onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isCalibrating ? 'Processing...' : buttonText,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        enabled: !isCalibrating,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    baselineXController.dispose();
    baselineYController.dispose();
    baselineZController.dispose();
    stepThresholdController.dispose();
    batteryMinController.dispose();
    batteryMaxController.dispose();
    super.dispose();
  }
}
