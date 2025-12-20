# Connectivity & Permissions

## Part 1: Connectivity

### The Simple Explanation

Connectivity tells you if the user has internet access and what type (WiFi or mobile data).

```
┌─────────────────────────────────────────────────────────┐
│                   CONNECTIVITY                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐                                        │
│  │   📱        │                                        │
│  │   Phone     │                                        │
│  └──────┬──────┘                                        │
│         │                                                │
│    ┌────┴────┐                                          │
│    │         │                                          │
│    ▼         ▼                                          │
│  ┌────┐   ┌────┐   ┌────┐                              │
│  │WiFi│   │ 4G │   │None│                              │
│  │ 📶 │   │ 📱 │   │ ❌ │                              │
│  └────┘   └────┘   └────┘                              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

### Setup

```yaml
dependencies:
  connectivity_plus: ^5.0.2
```

---

### Check Current Status

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternet() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

Future<String> getConnectionType() async {
  final result = await Connectivity().checkConnectivity();

  switch (result) {
    case ConnectivityResult.wifi:
      return 'WiFi';
    case ConnectivityResult.mobile:
      return 'Mobile Data';
    case ConnectivityResult.ethernet:
      return 'Ethernet';
    case ConnectivityResult.none:
      return 'No Connection';
    default:
      return 'Unknown';
  }
}
```

---

### Listen to Changes

```dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  bool isConnected = true;

  void startListening(Function(bool) onConnectivityChanged) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      isConnected = result != ConnectivityResult.none;
      onConnectivityChanged(isConnected);
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
```

---

### Connectivity Banner Widget

```dart
class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _listenToConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _isConnected = result != ConnectivityResult.none);
  }

  void _listenToConnectivity() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _isConnected = result != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Offline banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isConnected ? 0 : 30,
          color: Colors.red,
          child: _isConnected
              ? null
              : const Center(
                  child: Text(
                    'No internet connection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
        // Main content
        Expanded(child: widget.child),
      ],
    );
  }
}

// Usage
ConnectivityBanner(
  child: YourMainWidget(),
)
```

---

## Part 2: Permissions

### The Simple Explanation

Permissions are like asking for keys to different rooms. You can't enter without asking first!

```
┌─────────────────────────────────────────────────────────┐
│                    PERMISSIONS                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Your App: "Can I use the camera?"                      │
│                                                          │
│  User: ┌─────────────────────────────────┐              │
│        │ "MyApp" wants to access your    │              │
│        │ camera                          │              │
│        │                                 │              │
│        │  [Don't Allow]    [Allow]       │              │
│        └─────────────────────────────────┘              │
│                                                          │
│  PERMISSION STATES:                                      │
│  ├── Granted        ✅ User said yes                    │
│  ├── Denied         ❌ User said no (can ask again)    │
│  ├── Permanently    🚫 User said never (must go        │
│  │   Denied            to settings)                     │
│  └── Restricted     🔒 Device policy blocks it         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

### Setup

```yaml
dependencies:
  permission_handler: ^11.1.0
```

### iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<!-- Camera -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>

<!-- Photo Library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access</string>

<!-- Location -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need location to show nearby places</string>

<!-- Microphone -->
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone for voice recording</string>

<!-- Contacts -->
<key>NSContactsUsageDescription</key>
<string>We need contacts to find your friends</string>

<!-- Calendar -->
<key>NSCalendarsUsageDescription</key>
<string>We need calendar access to add events</string>
```

### Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Camera -->
<uses-permission android:name="android.permission.CAMERA"/>

<!-- Location -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- Storage -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<!-- Microphone -->
<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<!-- Contacts -->
<uses-permission android:name="android.permission.READ_CONTACTS"/>

<!-- Notifications (Android 13+) -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

---

### Check Permission Status

```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> checkCameraPermission() async {
  final status = await Permission.camera.status;

  if (status.isGranted) {
    print('Camera permission granted');
  } else if (status.isDenied) {
    print('Camera permission denied');
  } else if (status.isPermanentlyDenied) {
    print('Camera permission permanently denied');
  } else if (status.isRestricted) {
    print('Camera permission restricted');
  }
}
```

---

### Request Permission

```dart
Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

// With explanation
Future<bool> requestCameraWithExplanation(BuildContext context) async {
  // Check current status
  final status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  }

  // Show explanation dialog first
  if (status.isDenied) {
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission'),
        content: const Text(
          'We need camera access to take photos for your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (shouldRequest != true) return false;
  }

  // Request permission
  final result = await Permission.camera.request();

  // If permanently denied, offer to open settings
  if (result.isPermanentlyDenied) {
    final openSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Camera permission is required. Please enable it in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (openSettings == true) {
      await openAppSettings();
    }
    return false;
  }

  return result.isGranted;
}
```

---

### Request Multiple Permissions

```dart
Future<Map<Permission, PermissionStatus>> requestMultiple() async {
  return await [
    Permission.camera,
    Permission.microphone,
    Permission.location,
  ].request();
}

// Check if all granted
Future<bool> checkAllPermissions() async {
  final statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();

  return statuses.values.every((status) => status.isGranted);
}
```

---

### Complete Permission Service

```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check if permission is granted
  static Future<bool> isGranted(Permission permission) async {
    return await permission.isGranted;
  }

  // Request single permission
  static Future<bool> request(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  // Request with context for dialogs
  static Future<bool> requestWithContext(
    BuildContext context,
    Permission permission, {
    required String title,
    required String rationale,
  }) async {
    // Check if already granted
    if (await permission.isGranted) {
      return true;
    }

    // If denied, show explanation
    if (await permission.isDenied) {
      final proceed = await _showRationale(context, title, rationale);
      if (!proceed) return false;
    }

    // Request
    final status = await permission.request();

    // Handle permanently denied
    if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context, title);
      return false;
    }

    return status.isGranted;
  }

  // Show rationale dialog
  static Future<bool> _showRationale(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Show settings dialog
  static Future<void> _showSettingsDialog(
    BuildContext context,
    String title,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
          '$title permission was denied. Please enable it in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (result == true) {
      await openAppSettings();
    }
  }

  // Common permission requests
  static Future<bool> requestCamera(BuildContext context) {
    return requestWithContext(
      context,
      Permission.camera,
      title: 'Camera Permission',
      rationale: 'We need camera access to take photos.',
    );
  }

  static Future<bool> requestLocation(BuildContext context) {
    return requestWithContext(
      context,
      Permission.location,
      title: 'Location Permission',
      rationale: 'We need location access to show nearby places.',
    );
  }

  static Future<bool> requestNotification(BuildContext context) {
    return requestWithContext(
      context,
      Permission.notification,
      title: 'Notification Permission',
      rationale: 'Allow notifications to stay updated.',
    );
  }

  static Future<bool> requestMicrophone(BuildContext context) {
    return requestWithContext(
      context,
      Permission.microphone,
      title: 'Microphone Permission',
      rationale: 'We need microphone access for voice recording.',
    );
  }
}
```

---

### Usage Example

```dart
class PermissionDemo extends StatelessWidget {
  const PermissionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PermissionTile(
            icon: Icons.camera_alt,
            title: 'Camera',
            permission: Permission.camera,
            onRequest: () => PermissionService.requestCamera(context),
          ),
          PermissionTile(
            icon: Icons.location_on,
            title: 'Location',
            permission: Permission.location,
            onRequest: () => PermissionService.requestLocation(context),
          ),
          PermissionTile(
            icon: Icons.notifications,
            title: 'Notifications',
            permission: Permission.notification,
            onRequest: () => PermissionService.requestNotification(context),
          ),
          PermissionTile(
            icon: Icons.mic,
            title: 'Microphone',
            permission: Permission.microphone,
            onRequest: () => PermissionService.requestMicrophone(context),
          ),
        ],
      ),
    );
  }
}

class PermissionTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final Permission permission;
  final Future<bool> Function() onRequest;

  const PermissionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.permission,
    required this.onRequest,
  });

  @override
  State<PermissionTile> createState() => _PermissionTileState();
}

class _PermissionTileState extends State<PermissionTile> {
  PermissionStatus? _status;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await widget.permission.status;
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(widget.icon),
        title: Text(widget.title),
        subtitle: Text(_getStatusText()),
        trailing: _status?.isGranted == true
            ? const Icon(Icons.check_circle, color: Colors.green)
            : ElevatedButton(
                onPressed: () async {
                  await widget.onRequest();
                  await _checkStatus();
                },
                child: const Text('Request'),
              ),
      ),
    );
  }

  String _getStatusText() {
    switch (_status) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      case PermissionStatus.limited:
        return 'Limited';
      default:
        return 'Unknown';
    }
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│       CONNECTIVITY & PERMISSIONS SUMMARY                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  CONNECTIVITY (connectivity_plus)                        │
│  ├── Check: Connectivity().checkConnectivity()          │
│  └── Listen: Connectivity().onConnectivityChanged       │
│                                                          │
│  PERMISSIONS (permission_handler)                        │
│  ├── Check: permission.status                           │
│  ├── Request: permission.request()                      │
│  ├── Multiple: [perms].request()                        │
│  └── Settings: openAppSettings()                        │
│                                                          │
│  PERMISSION STATES:                                      │
│  ├── granted           - Can use feature                │
│  ├── denied            - Denied (can ask again)         │
│  ├── permanentlyDenied - Must go to settings            │
│  ├── restricted        - Blocked by device              │
│  └── limited           - Partial access (photos)        │
│                                                          │
│  BEST PRACTICES:                                         │
│  ├── Explain WHY you need permission                    │
│  ├── Handle denial gracefully                           │
│  ├── Offer to open settings if permanently denied       │
│  └── Only request when actually needed                  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Next:** Check out the Examples folder for complete working code!
