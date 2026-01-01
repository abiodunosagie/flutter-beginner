# Level 12: Common Mistakes

Learn from these common platform feature errors!

---

## Mistake #1: Not Checking Permissions

```dart
// ❌ WRONG - Crashes without permission
final photo = await ImagePicker().pickImage(source: ImageSource.camera);

// ✅ RIGHT - Check and request first
final status = await Permission.camera.status;
if (!status.isGranted) {
  final result = await Permission.camera.request();
  if (!result.isGranted) {
    showError('Camera permission required');
    return;
  }
}
final photo = await ImagePicker().pickImage(source: ImageSource.camera);
```

---

## Mistake #2: Ignoring Permanently Denied

```dart
// ❌ WRONG - User stuck if permanently denied
if (!status.isGranted) {
  await Permission.camera.request();  // Does nothing if permanently denied!
}

// ✅ RIGHT - Handle all cases
if (status.isDenied) {
  final result = await Permission.camera.request();
  if (!result.isGranted) return;
} else if (status.isPermanentlyDenied) {
  // Can't request again - must open settings
  await openAppSettings();
  return;
}
```

---

## Mistake #3: Missing Permission Descriptions (iOS)

```xml
<!-- ❌ WRONG - Missing from Info.plist -->
<!-- App crashes with no explanation -->

<!-- ✅ RIGHT - Add to ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to let you take photos for reviews</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to let you select images</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby stores</string>
```

---

## Mistake #4: Missing Android Permissions

```xml
<!-- ❌ WRONG - Missing from AndroidManifest.xml -->

<!-- ✅ RIGHT - Add to android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

---

## Mistake #5: Not Initializing Notifications

```dart
// ❌ WRONG - Notifications don't show
FlutterLocalNotificationsPlugin().show(
  0, 'Title', 'Body', null,
);  // Nothing happens!

// ✅ RIGHT - Initialize first
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifications = FlutterLocalNotificationsPlugin();
  await notifications.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  runApp(MyApp());
}
```

---

## Mistake #6: Missing Notification Channel (Android 8+)

```dart
// ❌ WRONG - No channel defined
await notifications.show(
  0,
  'Title',
  'Body',
  NotificationDetails(
    android: AndroidNotificationDetails('channel_id', 'Channel Name'),
  ),
);  // Might not show on Android 8+!

// ✅ RIGHT - Create channel first
await notifications
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(
      AndroidNotificationChannel(
        'channel_id',
        'Channel Name',
        importance: Importance.high,
      ),
    );
```

---

## Mistake #7: Location Without Checking Services

```dart
// ❌ WRONG - Fails if GPS is off
final position = await Geolocator.getCurrentPosition();

// ✅ RIGHT - Check services first
final serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) {
  showError('Please enable location services');
  return;
}

final permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    showError('Location permission denied');
    return;
  }
}

final position = await Geolocator.getCurrentPosition();
```

---

## Mistake #8: No Loading State for Camera

```dart
// ❌ WRONG - User taps, nothing happens visually
onPressed: () async {
  final photo = await ImagePicker().pickImage(source: ImageSource.camera);
  // Camera opens, but user might think button is broken
}

// ✅ RIGHT - Show loading
onPressed: () async {
  setState(() => isLoading = true);
  try {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Handle photo
    }
  } finally {
    setState(() => isLoading = false);
  }
}
```

---

## Mistake #9: Not Handling Null Results

```dart
// ❌ WRONG - Crashes if user cancels
final photo = await ImagePicker().pickImage(source: ImageSource.camera);
final bytes = await photo.readAsBytes();  // Null error if cancelled!

// ✅ RIGHT - Check for null
final photo = await ImagePicker().pickImage(source: ImageSource.camera);
if (photo == null) {
  // User cancelled
  return;
}
final bytes = await photo.readAsBytes();
```

---

## Mistake #10: Platform-Specific Code Without Checks

```dart
// ❌ WRONG - Crashes on web or wrong platform
if (Platform.isIOS) {
  // iOS specific code
}
// Crashes on web! Platform.isIOS throws on web.

// ✅ RIGHT - Check for web first
import 'package:flutter/foundation.dart';

if (kIsWeb) {
  // Web doesn't have camera
  return;
}
if (Platform.isIOS) {
  // iOS specific
}
```

---

## Quick Reference: Platform Permissions

| Feature | iOS Info.plist | Android Manifest |
|---------|---------------|------------------|
| Camera | NSCameraUsageDescription | CAMERA |
| Photos | NSPhotoLibraryUsageDescription | READ_EXTERNAL_STORAGE |
| Location | NSLocationWhenInUseUsageDescription | ACCESS_FINE_LOCATION |
| Notifications | - | POST_NOTIFICATIONS |
| Microphone | NSMicrophoneUsageDescription | RECORD_AUDIO |

---

**Still stuck? Re-read the Theory files or ask for help!**
