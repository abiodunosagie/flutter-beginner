# Level 12 Checkpoint: Platform Features

Before moving to Level 13, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Permission Handling
What's the correct order for requesting permissions?

```dart
// Put in order:
___ Check if permission is granted
___ Request permission
___ Handle "denied" response
___ Handle "permanently denied" response
___ Use the feature
```

<details>
<summary>Check Answer</summary>

1. Check if permission is granted
2. Request permission (if not granted)
3. Handle "denied" response (can ask again)
4. Handle "permanently denied" response (open settings)
5. Use the feature (only if granted)

```dart
Future<bool> handleCameraPermission() async {
  var status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    status = await Permission.camera.request();
    return status.isGranted;
  }

  if (status.isPermanentlyDenied) {
    await openAppSettings();
    return false;
  }

  return false;
}
```

</details>

---

### 2. Camera Usage
What's the difference?

```dart
// Option A
ImagePicker().pickImage(source: ImageSource.camera);

// Option B
ImagePicker().pickImage(source: ImageSource.gallery);

// Option C
ImagePicker().pickMultiImage();
```

<details>
<summary>Check Answer</summary>

- **A**: Opens camera to take a new photo
- **B**: Opens photo gallery to select existing photo
- **C**: Opens gallery for selecting multiple photos

All return `XFile?` (or `List<XFile>` for multi).

</details>

---

### 3. Local Notifications
What does each part do?

```dart
FlutterLocalNotificationsPlugin().show(
  0,                                    // ____
  'New Order!',                         // ____
  'Your order #123 is confirmed',       // ____
  NotificationDetails(
    android: AndroidNotificationDetails(
      'orders',                         // ____
      'Order Updates',                  // ____
      importance: Importance.high,
      priority: Priority.high,
    ),
  ),
);
```

<details>
<summary>Check Answers</summary>

```dart
FlutterLocalNotificationsPlugin().show(
  0,                                    // Notification ID (for updating/canceling)
  'New Order!',                         // Title
  'Your order #123 is confirmed',       // Body
  NotificationDetails(
    android: AndroidNotificationDetails(
      'orders',                         // Channel ID (for grouping)
      'Order Updates',                  // Channel name (user sees this)
      importance: Importance.high,      // Notification importance
      priority: Priority.high,          // Display priority
    ),
  ),
);
```

</details>

---

### 4. Location Services
What information does this provide?

```dart
final position = await Geolocator.getCurrentPosition();
print(position.latitude);
print(position.longitude);
print(position.accuracy);
print(position.altitude);
print(position.speed);
```

<details>
<summary>Check Answer</summary>

- **latitude**: North/South coordinate (-90 to 90)
- **longitude**: East/West coordinate (-180 to 180)
- **accuracy**: Position accuracy in meters
- **altitude**: Height above sea level in meters
- **speed**: Speed in meters per second (if moving)

</details>

---

### 5. Platform Checks
When would you use these?

```dart
import 'dart:io';

if (Platform.isIOS) { ... }
if (Platform.isAndroid) { ... }

import 'package:flutter/foundation.dart';

if (kIsWeb) { ... }
```

<details>
<summary>Check Answer</summary>

Use platform checks when:
- Different plugins for iOS/Android
- Platform-specific UI elements
- Platform-specific permissions
- Web doesn't support certain features
- Different behavior needed per platform

Example:
```dart
if (kIsWeb) {
  // Web: No camera, use file picker
} else if (Platform.isIOS) {
  // iOS: Specific permission flow
} else {
  // Android: Different permissions
}
```

</details>

---

### 6. Push Notifications
What's the difference between local and push notifications?

<details>
<summary>Check Answer</summary>

**Local Notifications:**
- Triggered by the app itself
- Works offline
- No server needed
- Examples: reminders, alarms, task notifications

**Push Notifications:**
- Sent from a server (like Firebase Cloud Messaging)
- Requires internet
- Can wake app in background
- Examples: new message, order update, marketing

</details>

---

## Hands-On Check

### Task 1: Camera Feature
Implement a function to capture a product review photo:

```dart
class CameraService {
  // Implement:
  // - Check camera permission
  // - Request if needed
  // - Take photo
  // - Return image path or null
}
```

<details>
<summary>Example Solution</summary>

```dart
class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> takePhoto() async {
    // Check/request permission
    final status = await Permission.camera.status;

    if (status.isDenied) {
      final result = await Permission.camera.request();
      if (!result.isGranted) return null;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return null;
    }

    // Take photo
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      return photo?.path;
    } catch (e) {
      print('Camera error: $e');
      return null;
    }
  }

  Future<String?> pickFromGallery() async {
    final status = await Permission.photos.status;

    if (!status.isGranted) {
      final result = await Permission.photos.request();
      if (!result.isGranted) return null;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );

    return image?.path;
  }
}
```

</details>

---

### Task 2: Local Notifications
Set up notifications for order updates:

```dart
class NotificationService {
  // Implement:
  // - Initialize notifications
  // - Show order confirmation notification
  // - Show delivery update notification
  // - Handle notification tap
}
```

<details>
<summary>Example Solution</summary>

```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'orders',
            'Order Updates',
            importance: Importance.high,
          ),
        );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle tap - navigate to order
    final payload = response.payload;
    if (payload != null) {
      // Navigate to order detail
    }
  }

  Future<void> showOrderConfirmation(String orderId) async {
    await _notifications.show(
      orderId.hashCode,
      'Order Confirmed!',
      'Your order #$orderId has been confirmed',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'orders',
          'Order Updates',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: orderId,
    );
  }

  Future<void> showDeliveryUpdate(String orderId, String status) async {
    await _notifications.show(
      orderId.hashCode,
      'Delivery Update',
      'Order #$orderId: $status',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'orders',
          'Order Updates',
          importance: Importance.high,
        ),
      ),
      payload: orderId,
    );
  }
}
```

</details>

---

### Task 3: Location for Store Finder
Implement store finder with user location:

```dart
class LocationService {
  // Implement:
  // - Check location permission
  // - Get current position
  // - Calculate distance to store
}
```

<details>
<summary>Example Solution</summary>

```dart
class LocationService {
  Future<Position?> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // Or prompt user to enable
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }

  List<Store> sortByDistance(List<Store> stores, Position userPosition) {
    stores.sort((a, b) {
      final distA = calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        a.latitude,
        a.longitude,
      );
      final distB = calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });
    return stores;
  }
}
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Permission | _________________ |
| ImagePicker | _________________ |
| Local notification | _________________ |
| Push notification | _________________ |
| Geolocation | _________________ |
| Platform channel | _________________ |

---

## Ready for Level 13?

### I can confidently:
- [ ] Request and handle permissions
- [ ] Capture photos with camera
- [ ] Pick images from gallery
- [ ] Show local notifications
- [ ] Handle notification taps
- [ ] Get user's current location
- [ ] Calculate distances between coordinates
- [ ] Handle platform-specific differences

### Capstone Progress:
- [ ] Users can add photos to reviews
- [ ] Order confirmation shows notification
- [ ] Store finder shows nearby stores
- [ ] Permissions are requested gracefully

---

## If You're Stuck

**Common issues at this level:**

1. **"Permission denied" on first launch**
   - Always check permission before requesting
   - Handle all permission states (denied, permanently denied)

2. **Camera/gallery not opening**
   - Check if permission was granted
   - Add required Info.plist entries for iOS
   - Add required manifest permissions for Android

3. **Notifications not showing**
   - Initialize plugin in main()
   - Create notification channels for Android 8+
   - Check notification permissions on iOS

4. **Location inaccurate**
   - Use `LocationAccuracy.high` for better accuracy
   - Wait for GPS to get fix (can take a few seconds)
   - Handle timeout scenarios

---

**Ready to level up? Head to Level 13: Testing & Quality!**
