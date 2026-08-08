# App 21: Bluetooth IoT — Complete Tutorial

> Scan devices, connect, read a characteristic. Hardware-adjacent jobs.

**Time:** 12–18 hours · **Min level:** 12  
**Package:** `flutter_blue_plus` (or `flutter_reactive_ble`)

## Features

- [ ] Permission flows (BT + location on Android)  
- [ ] Scan list of devices  
- [ ] Connect / disconnect  
- [ ] List services & characteristics  
- [ ] Read/notify one characteristic  
- [ ] Disconnect on dispose  

## Without hardware

Use a BLE peripheral simulator app on a second phone, or document UI with mock repository.

## Build order

1. Permissions  
2. Scan UI  
3. Connect  
4. Read battery service if available (`0x180F`)  
5. Error states  

## Portfolio blurb

> Bluetooth LE explorer app: scan, connect, and read characteristics with proper permission UX.

## Android permissions (modern)

- `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`  
- Location often still required for scan on older APIs  

## iOS

- `NSBluetoothAlwaysUsageDescription`  
- Background modes only if product needs them  

## Mock repository (no hardware)

```dart
class MockBleDevice {
  final String id;
  final String name;
  final int rssi;
}
Stream<List<MockBleDevice>> mockScan() async* {
  yield [MockBleDevice(id: '1', name: 'Demo Sensor', rssi: -55)];
}
```

Swap interface `BleRepository` between mock and `FlutterBluePlus` impl.

## Read flow

1. connect  
2. discoverServices  
3. find characteristic  
4. read or setNotifyValue(true)  
5. parse bytes → UI
