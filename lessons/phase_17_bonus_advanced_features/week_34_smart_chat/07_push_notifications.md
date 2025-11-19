# Lesson 7: Push Notifications with Firebase Cloud Messaging

## 5-Year-Old Analogy 🎈

Imagine you're playing outside and your friend sends you a message:

**Without Notifications**: You have to keep checking your phone every minute - "Any messages? Any messages?" Annoying!

**With Notifications**: Your phone makes a "ding!" sound and shows "Sarah sent you a message!" - even if the app is closed! You know right away without checking!

That's what push notifications do - they tell you about new messages even when you're not using the app, like a friendly tap on your shoulder saying "Hey, someone messaged you!"

## What We'll Build

In this lesson, we'll implement:
- ✅ Firebase Cloud Messaging (FCM) setup
- ✅ Device token management
- ✅ Foreground notifications
- ✅ Background notifications
- ✅ Notification tap handling
- ✅ Custom notification sounds
- ✅ Notification badges
- ✅ Silent notifications
- ✅ Notification channels (Android)
- ✅ Cloud Functions for sending notifications

## Step 1: Firebase Cloud Messaging Setup

### Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.3.0
```

Run:
```bash
flutter pub get
```

### Configure Android

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application>
        <!-- Existing content... -->

        <!-- FCM Notification Icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />

        <!-- FCM Notification Color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />

        <!-- FCM Notification Channel -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="chat_messages" />
    </application>

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
</manifest>
```

### Configure iOS

Add to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

Request permission in iOS by updating `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import Firebase
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Step 2: Notification Service

Create `lib/services/notification_service.dart`:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.messageId}');
  // Handle background message
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> initialize() async {
    print('🔔 Initializing notification service...');

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Get FCM token
    await _getFCMToken();

    // Listen to token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print('FCM token refreshed: $newToken');
      _fcmToken = newToken;
      _saveFCMToken(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    print('✅ Notification service initialized');
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('Notification permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notification permission granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('⚠️ Notification permission provisional');
      } else {
        print('❌ Notification permission denied');
      }
    } catch (e) {
      print('Error requesting permission: $e');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Android initialization
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print('iOS local notification: $title');
      },
    );

    // Combined initialization
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
        _handleLocalNotificationTap(details.payload);
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create notification channels (Android)
  Future<void> _createNotificationChannels() async {
    const androidChannel = AndroidNotificationChannel(
      'chat_messages',
      'Chat Messages',
      description: 'Notifications for new chat messages',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    print('✅ Notification channels created');
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      if (Platform.isIOS) {
        // For iOS, request APNS token first
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          print('APNS token: $apnsToken');
        }
      }

      _fcmToken = await _messaging.getToken();
      print('FCM token: $_fcmToken');

      if (_fcmToken != null) {
        await _saveFCMToken(_fcmToken!);
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Save FCM token to Firestore
  Future<void> _saveFCMToken(String token) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      print('User not authenticated, cannot save token');
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ FCM token saved to Firestore');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  /// Handle foreground message
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.messageId}');

    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      // Show local notification
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'chat_messages',
            'Chat Messages',
            channelDescription: 'Notifications for new chat messages',
            importance: Importance.high,
            priority: Priority.high,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            sound: RawResourceAndroidNotificationSound('notification'),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'notification.aiff',
          ),
        ),
        payload: message.data['chatId'],
      );
    }
  }

  /// Handle notification tap (from background)
  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.messageId}');

    final chatId = message.data['chatId'];
    if (chatId != null) {
      // Navigate to chat screen
      // This would typically use a navigation service
      print('Navigate to chat: $chatId');
      // NavigationService.instance.navigateToChat(chatId);
    }
  }

  /// Handle local notification tap
  void _handleLocalNotificationTap(String? payload) {
    if (payload != null) {
      print('Local notification tapped, chat ID: $payload');
      // Navigate to chat screen
      // NavigationService.instance.navigateToChat(payload);
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  /// Show local notification manually
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'chat_messages',
          'Chat Messages',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Clear specific notification
  Future<void> clearNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      print('✅ FCM token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
```

## Step 3: Cloud Functions for Sending Notifications

Create `functions/index.js` (in your Firebase project):

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Send notification when a new message is created
exports.sendMessageNotification = functions.firestore
    .document('chats/{chatId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {
        const message = snapshot.data();
        const chatId = context.params.chatId;
        const senderId = message.senderId;

        console.log('New message in chat:', chatId);

        try {
            // Get chat document to find participants
            const chatDoc = await admin.firestore()
                .collection('chats')
                .doc(chatId)
                .get();

            if (!chatDoc.exists) {
                console.log('Chat not found');
                return null;
            }

            const chatData = chatDoc.data();
            const participants = chatData.participants;

            // Get sender's name
            const senderDoc = await admin.firestore()
                .collection('users')
                .doc(senderId)
                .get();

            const senderName = senderDoc.data()?.displayName || 'Someone';

            // Send notification to all participants except sender
            const recipients = participants.filter(id => id !== senderId);

            const notifications = recipients.map(async (recipientId) => {
                // Get recipient's FCM token
                const recipientDoc = await admin.firestore()
                    .collection('users')
                    .doc(recipientId)
                    .get();

                const fcmToken = recipientDoc.data()?.fcmToken;

                if (!fcmToken) {
                    console.log('No FCM token for user:', recipientId);
                    return null;
                }

                // Prepare notification payload
                const payload = {
                    token: fcmToken,
                    notification: {
                        title: senderName,
                        body: _getNotificationBody(message),
                    },
                    data: {
                        chatId: chatId,
                        senderId: senderId,
                        messageId: snapshot.id,
                        type: 'new_message',
                    },
                    android: {
                        priority: 'high',
                        notification: {
                            channelId: 'chat_messages',
                            sound: 'notification',
                            priority: 'high',
                        },
                    },
                    apns: {
                        payload: {
                            aps: {
                                sound: 'notification.aiff',
                                badge: 1,
                            },
                        },
                    },
                };

                // Send notification
                try {
                    const response = await admin.messaging().send(payload);
                    console.log('Notification sent:', response);
                    return response;
                } catch (error) {
                    console.error('Error sending notification:', error);
                    return null;
                }
            });

            await Promise.all(notifications);
            console.log('All notifications sent');
            return null;

        } catch (error) {
            console.error('Error in sendMessageNotification:', error);
            return null;
        }
    });

// Helper function to get notification body based on message type
function _getNotificationBody(message) {
    switch (message.type) {
        case 'text':
            return message.text || 'New message';
        case 'image':
            return '📷 Photo';
        case 'video':
            return '🎥 Video';
        case 'file':
            return '📎 ' + (message.fileName || 'File');
        default:
            return 'New message';
    }
}

// Send notification when user receives a call
exports.sendCallNotification = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError(
            'unauthenticated',
            'User must be authenticated'
        );
    }

    const { recipientId, callerName, callType } = data;

    try {
        const recipientDoc = await admin.firestore()
            .collection('users')
            .doc(recipientId)
            .get();

        const fcmToken = recipientDoc.data()?.fcmToken;

        if (!fcmToken) {
            throw new functions.https.HttpsError(
                'not-found',
                'Recipient FCM token not found'
            );
        }

        const payload = {
            token: fcmToken,
            notification: {
                title: `${callType} call from ${callerName}`,
                body: 'Tap to answer',
            },
            data: {
                type: 'incoming_call',
                callerId: context.auth.uid,
                callerName: callerName,
                callType: callType,
            },
            android: {
                priority: 'high',
                notification: {
                    channelId: 'calls',
                    priority: 'max',
                },
            },
        };

        const response = await admin.messaging().send(payload);
        return { success: true, messageId: response };

    } catch (error) {
        console.error('Error sending call notification:', error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});
```

Deploy functions:

```bash
cd functions
npm install
firebase deploy --only functions
```

## Step 4: Initialize in Main

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
```

## Step 5: Update User Service

Update user initialization to save FCM token:

```dart
Future<void> initializeUser() async {
  final notificationService = NotificationService();
  final fcmToken = notificationService.fcmToken;

  await _firestore.collection('users').doc(currentUserId).set({
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'status': 'online',
    'lastSeen': FieldValue.serverTimestamp(),
    'fcmToken': fcmToken,
  }, SetOptions(merge: true));
}
```

## Step 6: Navigation Service for Deep Links

Create `lib/services/navigation_service.dart`:

```dart
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService instance = NavigationService._internal();
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToChat(String chatId) {
    return navigatorKey.currentState!.pushNamed(
      '/chat',
      arguments: {'chatId': chatId},
    );
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}

// Update main.dart to use navigation key:
MaterialApp(
  navigatorKey: NavigationService.instance.navigatorKey,
  // ... rest of the config
);
```

## Verification Steps

### Test Foreground Notifications

1. Open app
2. Send message from another device
3. Notification appears at top
4. Sound plays
5. Tap notification → opens chat

### Test Background Notifications

1. Close app (but don't force quit)
2. Send message
3. Notification appears
4. Tap notification → app opens to chat

### Test Terminated State

1. Force quit app
2. Send message
3. Notification appears
4. Tap notification → app launches to chat

### Test Permission Handling

1. Deny notification permission
2. App should still work
3. Show UI to enable notifications

## Common Issues and Solutions

### Issue 1: No Notifications on iOS

**Problem**: Notifications don't appear

**Solution**:
```bash
# Ensure you have proper certificates
cd ios
pod install
# Enable Push Notifications in Xcode
```

### Issue 2: Android Notifications Not Showing

**Problem**: Silent delivery

**Solution**: Ensure high priority:
```dart
AndroidNotificationDetails(
  'chat_messages',
  'Chat Messages',
  importance: Importance.high,
  priority: Priority.high,
)
```

### Issue 3: Token Not Saved

**Problem**: FCM token is null

**Solution**: Wait for token:
```dart
await Future.delayed(Duration(seconds: 2));
final token = await messaging.getToken();
```

## Advanced Features

### Custom Notification Sounds

1. Add sound file to `android/app/src/main/res/raw/notification.mp3`
2. Add sound file to `ios/Runner/notification.aiff`
3. Reference in notification:

```dart
sound: RawResourceAndroidNotificationSound('notification'),
```

### Notification Badges

Update badge count:

```dart
FlutterLocalNotificationsPlugin().show(
  // ...
  iOS: DarwinNotificationDetails(
    badgeNumber: unreadCount,
  ),
);
```

### Rich Notifications (Images)

```javascript
// In Cloud Function
notification: {
    title: senderName,
    body: message.text,
    imageUrl: message.mediaUrl, // Add image
},
```

## Testing Notifications

Use Firebase Console to test:

1. Go to Cloud Messaging
2. Click "Send test message"
3. Enter your FCM token
4. Send notification

Or use curl:

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
-H "Authorization: key=YOUR_SERVER_KEY" \
-H "Content-Type: application/json" \
-d '{
  "to": "DEVICE_FCM_TOKEN",
  "notification": {
    "title": "Test",
    "body": "Test message"
  }
}'
```

## Best Practices

1. **Always request permission** before sending notifications
2. **Handle token refresh** to keep tokens updated
3. **Clear notifications** when user opens chat
4. **Respect user preferences** (mute, DND)
5. **Group notifications** for multiple messages
6. **Use silent notifications** for data sync

## Next Steps

In the next lesson, we'll add:
1. Message search
2. Chat groups
3. User blocking
4. Message encryption basics

## Key Takeaways

1. **FCM** enables push notifications across platforms
2. **Local notifications** show alerts in foreground
3. **Cloud Functions** send notifications automatically
4. **Token management** is crucial for delivery
5. **Deep linking** navigates to specific chats

Remember: Notifications bring users back to your app! 🔔
