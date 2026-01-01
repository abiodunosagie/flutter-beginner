# Level 12: Real-World Apps Using These Concepts

See how platform features make apps feel native!

---

## Camera & Image Picker

### Visual Content!

**Instagram / TikTok**
```dart
class CameraService {
  final ImagePicker _picker = ImagePicker();

  // Take a photo
  Future<File?> capturePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }

  // Record a video
  Future<File?> recordVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(seconds: 60),
    );
    return video != null ? File(video.path) : null;
  }

  // Pick from gallery
  Future<List<File>> pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    return images.map((xfile) => File(xfile.path)).toList();
  }
}
```

---

## Location Services

### Geo-Aware Apps!

**Uber / Maps Apps**
```dart
class LocationService {
  Future<Position?> getCurrentLocation() async {
    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return null;  // User needs to enable in settings
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Track location in real-time (Uber driver tracking)
  Stream<Position> trackLocation() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,  // Update every 10 meters
      ),
    );
  }

  // Calculate distance (delivery apps)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // km
  }
}
```

**Food Delivery Apps**
```dart
// Show nearby restaurants
Future<List<Restaurant>> getNearbyRestaurants() async {
  final position = await locationService.getCurrentLocation();
  return await api.getRestaurants(
    lat: position!.latitude,
    lng: position.longitude,
    radius: 5, // km
  );
}
```

---

## Biometric Authentication

### Secure Apps!

**Banking / Finance Apps**
```dart
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    return await _auth.canCheckBiometrics &&
           await _auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

// Usage in banking app
void accessAccount() async {
  if (await biometricService.authenticate()) {
    showAccountDetails();
  } else {
    showPinEntryScreen();
  }
}
```

---

## Local Notifications

### Keep Users Engaged!

**Reminder Apps / Calendars**
```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Schedule a reminder
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          'Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Daily recurring notification (habits apps)
  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required Time time,
  }) async {
    await _notifications.showDailyAtTime(
      id,
      title,
      'Time for your daily habit!',
      time,
      notificationDetails,
    );
  }
}
```

---

## Sharing

### Social Features!

**Any Social App**
```dart
class ShareService {
  // Share text
  Future<void> shareText(String text) async {
    await Share.share(text);
  }

  // Share with image (Instagram, WhatsApp)
  Future<void> shareWithImage(File image, String caption) async {
    await Share.shareXFiles([XFile(image.path)], text: caption);
  }

  // Share link with preview
  Future<void> shareLink(String url, String title) async {
    await Share.share('$title\n\n$url');
  }
}
```

---

## Device Info

### Adaptive Features!

**Analytics / Support**
```dart
class DeviceInfoService {
  Future<Map<String, String>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return {
        'model': info.model,
        'brand': info.brand,
        'version': info.version.release,
        'sdkInt': info.version.sdkInt.toString(),
      };
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return {
        'model': info.model,
        'name': info.name,
        'version': info.systemVersion,
      };
    }
    return {};
  }
}
```

---

## In-App Purchases

### Monetization!

**Gaming / Subscription Apps**
```dart
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<List<ProductDetails>> getProducts() async {
    final response = await _iap.queryProductDetails({
      'premium_monthly',
      'premium_yearly',
      'coins_100',
    });
    return response.productDetails;
  }

  Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);

    if (product.id.contains('subscription')) {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  // Listen for purchases
  void listenToPurchases() {
    _iap.purchaseStream.listen((purchases) {
      for (var purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          deliverProduct(purchase);
          _iap.completePurchase(purchase);
        }
      }
    });
  }
}
```

---

## Real Apps Using Platform Features

| Feature | Apps Using It |
|---------|--------------|
| **Camera** | Instagram, Snapchat, TikTok |
| **Location** | Uber, Google Maps, DoorDash |
| **Biometrics** | Banking apps, Password managers |
| **Notifications** | All messaging apps, Reminders |
| **Sharing** | Every social app |
| **In-App Purchases** | Games, Spotify, YouTube |

---

## Platform-Specific UI

### Native Feel!

**Adaptive Widgets**
```dart
// Platform-specific button
Widget buildButton() {
  if (Platform.isIOS) {
    return CupertinoButton(
      child: Text('Done'),
      onPressed: _submit,
    );
  }
  return ElevatedButton(
    child: Text('Done'),
    onPressed: _submit,
  );
}

// Platform-specific dialog
void showAlert(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Confirm'),
        actions: [
          CupertinoDialogAction(child: Text('Cancel')),
          CupertinoDialogAction(child: Text('OK')),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm'),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () {}),
          TextButton(child: Text('OK'), onPressed: () {}),
        ],
      ),
    );
  }
}
```

---

## Build It Yourself!

After this level, you could build:

1. **Photo Filter App** - Camera + image processing
2. **Location Tracker** - GPS tracking with maps
3. **Secure Vault** - Biometric-protected storage
4. **Habit Tracker** - Daily notification reminders
5. **Subscription App** - In-app purchases

---

**Platform features make your app feel like it belongs on the device!**
