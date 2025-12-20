# Level 12: Platform Features

## Welcome to Device Superpowers! 📱

Your phone has amazing hardware and features - camera, GPS, sensors, notifications. In this level, you'll learn how to use them in your Flutter app!

```
┌─────────────────────────────────────────────────────────┐
│                 PLATFORM FEATURES                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Your phone is packed with features:                    │
│                                                          │
│  📷 Camera         - Take photos and videos             │
│  📍 Location       - Know where user is                 │
│  🔔 Notifications  - Alert users when app is closed    │
│  📁 File System    - Read and write files               │
│  📋 Clipboard      - Copy and paste                     │
│  🔗 URL Launcher   - Open websites and apps             │
│  📱 Device Info    - Know what device is running        │
│  🔋 Battery        - Check battery status               │
│  📶 Connectivity   - Check internet connection          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What You'll Learn

```
LEVEL 12 TOPICS:
├── 1. Camera & Image Picker
│   ├── Taking photos
│   ├── Selecting from gallery
│   └── Video recording
│
├── 2. Location Services
│   ├── Getting current location
│   ├── Continuous location updates
│   └── Permissions handling
│
├── 3. Local Notifications
│   ├── Showing notifications
│   ├── Scheduled notifications
│   └── Notification actions
│
├── 4. URL Launcher
│   ├── Opening websites
│   ├── Making phone calls
│   ├── Sending emails/SMS
│   └── Opening other apps
│
├── 5. Connectivity
│   ├── Checking internet status
│   └── Listening to changes
│
└── 6. Device Info & Permissions
    ├── Getting device information
    └── Handling permissions properly
```

---

## Why Platform Features?

```
WITHOUT PLATFORM FEATURES:      WITH PLATFORM FEATURES:
┌──────────────────────┐       ┌──────────────────────┐
│                      │       │                      │
│  Your app is just    │       │  Your app becomes    │
│  a pretty interface  │       │  a POWERFUL tool!    │
│                      │       │                      │
│  ┌────────────────┐  │       │  📷 Scan documents   │
│  │  Hello World   │  │  →    │  📍 Find nearby      │
│  │                │  │       │  🔔 Remind me later  │
│  └────────────────┘  │       │  📞 Call support     │
│                      │       │                      │
└──────────────────────┘       └──────────────────────┘
```

---

## Folder Structure

```
Level-12-Platform-Features/
│
├── README.md (this file)
│
├── Theory/
│   ├── 01-CameraImagePicker.md
│   ├── 02-LocationServices.md
│   ├── 03-LocalNotifications.md
│   ├── 04-URLLauncher.md
│   └── 05-ConnectivityPermissions.md
│
├── Examples/
│   ├── Example01-ImagePicker.dart
│   ├── Example02-LocationTracker.dart
│   ├── Example03-Notifications.dart
│   └── Example04-URLLauncher.dart
│
└── Exercises/
    └── Exercises.md
```

---

## Key Packages

```yaml
dependencies:
  # Camera and images
  image_picker: ^1.0.4
  camera: ^0.10.5

  # Location
  geolocator: ^10.1.0
  geocoding: ^2.1.1

  # Notifications
  flutter_local_notifications: ^16.1.0

  # URL and external apps
  url_launcher: ^6.2.1

  # Connectivity
  connectivity_plus: ^5.0.2

  # Device info
  device_info_plus: ^9.1.1

  # Permissions
  permission_handler: ^11.1.0
```

---

## Permission Handling

Most platform features require user permission:

```
PERMISSION FLOW:
┌─────────────────┐
│  Check Status   │ ← Is permission already granted?
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
Granted    Not Granted
    │         │
    ▼         ▼
Use the    ┌─────────────┐
feature    │ Request     │ ← Ask user politely
           │ Permission  │
           └──────┬──────┘
                  │
             ┌────┴────┐
             │         │
             ▼         ▼
          Granted   Denied
             │         │
             ▼         ▼
          Use it   Show explanation
                   or alternative
```

---

## Platform Differences

```
┌─────────────────────────────────────────────────────────┐
│              iOS vs Android Differences                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  PERMISSIONS:                                            │
│  ├── iOS: Add to Info.plist                             │
│  └── Android: Add to AndroidManifest.xml               │
│                                                          │
│  CAMERA:                                                 │
│  ├── iOS: Requires permission string                    │
│  └── Android: Works with manifest entry                 │
│                                                          │
│  LOCATION:                                               │
│  ├── iOS: Requires usage description                    │
│  └── Android: Fine vs Coarse location                   │
│                                                          │
│  NOTIFICATIONS:                                          │
│  ├── iOS: Must request permission                       │
│  └── Android 13+: Must request permission               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Examples

### Image Picker

```dart
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

// From camera
final photo = await picker.pickImage(source: ImageSource.camera);

// From gallery
final image = await picker.pickImage(source: ImageSource.gallery);

if (image != null) {
  File file = File(image.path);
}
```

### Location

```dart
import 'package:geolocator/geolocator.dart';

// Get current position
Position position = await Geolocator.getCurrentPosition();
print('Lat: ${position.latitude}, Lng: ${position.longitude}');
```

### URL Launcher

```dart
import 'package:url_launcher/url_launcher.dart';

// Open website
await launchUrl(Uri.parse('https://flutter.dev'));

// Make phone call
await launchUrl(Uri.parse('tel:+1234567890'));

// Send email
await launchUrl(Uri.parse('mailto:hello@example.com'));
```

### Notifications

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

await notifications.show(
  0, // Notification ID
  'Hello!', // Title
  'This is a notification', // Body
  NotificationDetails(...),
);
```

---

## Learning Path

```
START HERE
    │
    ▼
┌─────────────────┐
│ 01-Camera       │ ← Take photos and pick images
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 02-Location     │ ← Get user's location
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 03-Notifications│ ← Alert users
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 04-URL Launcher │ ← Open external apps
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 05-Connectivity │ ← Check network status
└────────┬────────┘
         │
         ▼
    BUILD APPS
    WITH DEVICE
    SUPERPOWERS!
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│               LEVEL 12 SUMMARY                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  CAMERA/IMAGES                                           │
│  └── image_picker package                               │
│                                                          │
│  LOCATION                                                │
│  └── geolocator package                                 │
│                                                          │
│  NOTIFICATIONS                                           │
│  └── flutter_local_notifications package                │
│                                                          │
│  URL LAUNCHER                                            │
│  └── url_launcher package                               │
│                                                          │
│  CONNECTIVITY                                            │
│  └── connectivity_plus package                          │
│                                                          │
│  KEY CONCEPT:                                            │
│  Always handle permissions properly!                     │
│  Users should understand WHY you need access.           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Let's start:** `Theory/01-CameraImagePicker.md` 📸
