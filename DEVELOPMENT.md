# Piezoshoe Footwear App - Development Guide

## Architecture

The app follows a **Provider-based architecture** with separation of concerns:

- **Models**: Data structures (BluetoothDevice, FootwearData)
- **Providers**: State management using Provider package
- **Screens**: UI layers with stateful/stateless widgets

## Bluetooth Communication

### Current Implementation

The `BluetoothProvider` handles:
- Device scanning and discovery
- Connection management
- Data reception and parsing
- Command sending (ON/OFF)

### Next Steps

1. **Implement Serial Communication**:
   - Parse incoming data from Arduino
   - Format commands correctly
   - Handle connection loss gracefully

2. **Add Data Persistence**:
   - Store historical data locally
   - Export as CSV/JSON

3. **Enhance Error Handling**:
   - Reconnection logic
   - Timeout management
   - User notifications

## Testing

### Manual Testing Checklist

- [ ] Scan for devices
- [ ] Connect to device
- [ ] Receive real-time data
- [ ] Toggle device on/off
- [ ] Disconnect gracefully
- [ ] Handle connection loss
- [ ] Battery level display accuracy

## Building & Deployment

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Permissions Required

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
</permission>
```

### iOS (Info.plist)

```xml
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app uses Bluetooth to connect to your Piezoshoe device</string>
<key>NSBluetoothCentralUsageDescription</key>
<string>This app uses Bluetooth to monitor your footwear</string>
```

## Troubleshooting

### Device not found
- Ensure Bluetooth is enabled
- Check if device is in pairing mode
- Verify device is within range

### Connection drops
- Check Bluetooth signal strength (RSSI)
- Verify Arduino is powered
- Check serial baud rate (9600)

### Data not updating
- Verify Arduino is sending data in correct format
- Check Bluetooth serial monitor
- Ensure app has necessary permissions