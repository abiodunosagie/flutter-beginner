# Firebase Cloud Messaging: Push Notifications

## Complete FCM Guide

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission (iOS)
    await _fcm.requestPermission();

    // Get token
    String? token = await _fcm.getToken();
    print('FCM Token: $token');

    // Handle messages
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleMessage(RemoteMessage message) {
    print('Got message: ${message.notification?.title}');
    // Show local notification
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('App opened from notification');
    // Navigate to specific screen
  }
}
```

Master push notifications! 🚀
