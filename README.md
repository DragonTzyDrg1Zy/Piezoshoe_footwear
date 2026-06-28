# Piezoshoe Footwear App

A Flutter mobile application for monitoring and controlling Arduino-based piezoelectric energy harvesting footwear via Bluetooth Classic.

## Features

- **Bluetooth Device Discovery**: Scan and connect to Piezoshoe devices
- **Real-time Monitoring**:
  - Battery Level (0-100%)
  - Microcontroller Voltage Readings
  - Step Counter
- **Device Control**: Turn the footwear on/off via Bluetooth commands
- **Live Dashboard**: Visual representation of all metrics

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── models.dart          # Data models (BluetoothDevice, FootwearData)
├── providers/
│   └── bluetooth_provider.dart  # State management for Bluetooth
└── screens/
    ├── home_screen.dart         # Main navigation screen
    ├── device_list_screen.dart  # Device discovery & connection
    └── monitoring_screen.dart   # Dashboard & controls
```

## Dependencies

- `flutter_blue_plus`: Bluetooth communication
- `provider`: State management
- `fl_chart`: Data visualization
- `intl`: Internationalization

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0+)
- Android/iOS development environment
- Xcode (for iOS) or Android Studio (for Android)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/DragonTzyDrg1Zy/Piezoshoe_footwear.git
cd Piezoshoe_footwear
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Bluetooth Protocol

### Device Connection
- Protocol: Classic Bluetooth (SPP)
- Baud Rate: 9600
- Data Format: ASCII

### Commands

| Command | Description | Response |
|---------|-------------|----------|
| `ON` | Turn device on | `OK` |
| `OFF` | Turn device off | `OK` |
| `STATUS` | Request device status | `BATTERY:85,VOLTAGE:4.2,STEPS:1234` |

## Arduino Integration

The app expects the Arduino microcontroller to:
1. Listen for incoming Bluetooth commands
2. Send periodic status updates with battery, voltage, and step data
3. Control the piezoelectric power circuit based on ON/OFF commands

### Example Arduino Sketch (Pseudo-code)

```cpp
#include <SoftwareSerial.h>

SoftwareSerial btSerial(10, 11); // RX, TX

void setup() {
  btSerial.begin(9600);
}

void loop() {
  if (btSerial.available()) {
    String command = btSerial.readStringUntil('\n');
    
    if (command == "ON") {
      enablePower();
      btSerial.println("OK");
    } else if (command == "OFF") {
      disablePower();
      btSerial.println("OK");
    } else if (command == "STATUS") {
      float battery = readBattery();
      float voltage = readVoltage();
      int steps = getStepCount();
      btSerial.print("BATTERY:");
      btSerial.print(battery);
      btSerial.print(",VOLTAGE:");
      btSerial.print(voltage);
      btSerial.print(",STEPS:");
      btSerial.println(steps);
    }
  }
}
```

## Future Enhancements

- [ ] Historical data charts and analytics
- [ ] Data export (CSV/JSON)
- [ ] Firmware update over-the-air (OTA)
- [ ] Multiple device support
- [ ] Low battery notifications
- [ ] Configurable thresholds

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.