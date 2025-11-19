# Firebase Cloud Messaging: Push Notifications

## What Are Push Notifications? (Explain Like I'm 5!)

Imagine you have a magical mailbox at your house. This isn't just any mailbox - it's SUPER special!

**Here's how it works:**

1. **Your Magical Mailbox** = Your phone
2. **The Mail Carrier** = Firebase Cloud Messaging (FCM)
3. **The Letter** = The notification message
4. **The Sender** = Your app's server

When someone wants to tell you something important (like "Your pizza is ready!" or "Your friend sent you a message!"), they don't need to knock on your door. Instead:

- They give the letter to the magical mail carrier (FCM)
- The mail carrier IMMEDIATELY flies to your house (even if you're sleeping!)
- The letter appears in your mailbox with a little "ding!" sound
- You see it right away, even if you weren't expecting it!

The AMAZING part? This works even when:
- Your app is closed (like when you're not home)
- Your phone is locked (like when you're sleeping)
- You're using other apps (like when you're playing in the backyard)

That's push notifications! They "push" messages to you instead of you having to "pull" (check) for them!

---

## Why Are Push Notifications So Important?

Think about these real-world examples:

1. **Chat Apps**: "Sarah sent you a message!" - You know immediately!
2. **Food Delivery**: "Your pizza is 5 minutes away!" - Perfect timing!
3. **Games**: "You got a new life! Come back and play!" - Re-engagement!
4. **Shopping**: "Your order has shipped!" - Peace of mind!
5. **News**: "Breaking news: Something important happened!" - Stay informed!

Without push notifications, you'd have to open every app constantly to check if anything happened. That would be SO tiring! 😴

---

## How Push Notifications Work (The Journey)

Let me explain the complete journey of a push notification:

```
Step 1: YOUR APP STARTS
├─ App asks: "Can I send you notifications?"
├─ You say: "Yes!"
└─ App gets a special "address" (FCM token) for your phone

Step 2: APP REGISTERS THE TOKEN
├─ App sends this "address" to your server
├─ Server saves it in database
└─ Now server knows how to reach this specific phone!

Step 3: SOMETHING HAPPENS
├─ Another user sends you a message
├─ Your order status changes
├─ A game event occurs
└─ Anything that needs to notify you!

Step 4: SERVER SENDS NOTIFICATION
├─ Server tells FCM: "Send this message to this address"
├─ FCM is like: "Got it! I'll deliver it!"
└─ Server provides: title, body, data, etc.

Step 5: FCM DELIVERS
├─ FCM finds your phone using the token
├─ Sends the notification through Apple/Google servers
└─ Works even if your app is closed!

Step 6: YOUR PHONE RECEIVES
├─ Phone shows the notification
├─ Plays a sound: "Ding!"
├─ Shows on lock screen
└─ Appears in notification tray

Step 7: YOU TAP IT
├─ App opens
├─ Goes to the right screen
└─ You see the content!
```

Pretty cool, right? Now let's build this step by step!

---

## Part 1: Setting Up Firebase Cloud Messaging (FCM)

### Step 1: Add Dependencies

First, open your `pubspec.yaml` file and add these packages:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase Core (required for all Firebase services)
  firebase_core: ^2.24.0

  # Firebase Messaging (for push notifications)
  firebase_messaging: ^14.7.0

  # Flutter Local Notifications (to show notifications when app is in foreground)
  flutter_local_notifications: ^16.2.0

  # For handling notification actions and navigation
  flutter_local_notifications: ^16.2.0
```

Run this command to install:
```bash
flutter pub get
```

**Why do we need THREE packages?**
- `firebase_core`: The foundation - like building a house foundation
- `firebase_messaging`: Receives messages from FCM - like the mailbox
- `flutter_local_notifications`: Shows notifications when app is open - like a doorbell

---

### Step 2: Android Setup (Complete Instructions)

#### Step 2.1: Update `android/build.gradle`

Open `android/build.gradle` and make sure you have:

```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

#### Step 2.2: Update `android/app/build.gradle`

Open `android/app/build.gradle`:

```gradle
// At the TOP of the file, after the first line
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services'  // ADD THIS LINE

android {
    defaultConfig {
        // Make sure minSdkVersion is at least 21
        minSdkVersion 21
    }
}

dependencies {
    // These should be here automatically
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}
```

#### Step 2.3: Add Notification Icons

Create a notification icon (must be white and transparent):

1. Go to [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-notification.html)
2. Create a simple icon
3. Download the zip file
4. Extract and copy the `res` folder contents to `android/app/src/main/res/`

Your folder structure should look like:
```
android/app/src/main/res/
├── drawable/
│   └── ic_notification.xml
├── mipmap-hdpi/
├── mipmap-mdpi/
├── mipmap-xhdpi/
├── mipmap-xxhdpi/
└── mipmap-xxxhdpi/
```

#### Step 2.4: Configure `AndroidManifest.xml`

Open `android/app/src/main/AndroidManifest.xml` and add:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Add permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:label="your_app_name"
        android:icon="@mipmap/ic_launcher">

        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"  <!-- IMPORTANT: Add this -->
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <!-- Add intent filter for notification clicks -->
            <intent-filter>
                <action android:name="FLUTTER_NOTIFICATION_CLICK" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>

            <!-- Your existing intent filter -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- Notification icon and color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />

        <!-- Notification channel (required for Android 8.0+) -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />
    </application>
</manifest>
```

#### Step 2.5: Create Notification Color

Create `android/app/src/main/res/values/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="notification_color">#FF6B35</color>
</resources>
```

---

### Step 3: iOS Setup (Complete Instructions)

#### Step 3.1: Enable Push Notifications in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode (NOT .xcodeproj!)
2. Select your project in the left sidebar
3. Select the "Runner" target
4. Click the "Signing & Capabilities" tab
5. Click "+ Capability"
6. Add "Push Notifications"
7. Add "Background Modes" and check:
   - Remote notifications
   - Background fetch

#### Step 3.2: Add to Info.plist

Open `ios/Runner/Info.plist` and add:

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
    <string>fetch</string>
</array>
```

#### Step 3.3: Update AppDelegate.swift

Open `ios/Runner/AppDelegate.swift` and replace with:

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
    // Configure Firebase
    FirebaseApp.configure()

    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### Step 3.4: Create APNs Key (Apple Push Notification service)

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Go to "Certificates, Identifiers & Profiles"
3. Click "Keys" in the left sidebar
4. Click the "+" button to create a new key
5. Name it "FCM Push Notifications"
6. Check "Apple Push Notifications service (APNs)"
7. Click "Continue" then "Register"
8. Download the `.p8` file (you can only download once!)
9. Note the Key ID shown

#### Step 3.5: Upload APNs Key to Firebase

1. Go to Firebase Console
2. Click the gear icon → Project Settings
3. Select "Cloud Messaging" tab
4. Scroll to "Apple app configuration"
5. Click "Upload" under APNs Authentication Key
6. Upload your `.p8` file
7. Enter your Key ID
8. Enter your Team ID (found in Apple Developer Portal)

---

## Part 2: Creating the Notification Service

Now let's create our complete notification service! This is the heart of our notification system.

### Example 1: Basic Notification Service

Create `lib/services/notification_service.dart`:

```dart
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// This function handles notifications when the app is in the BACKGROUND or TERMINATED
/// It MUST be a top-level function (not inside a class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📬 Background message received!');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

class NotificationService {
  // Singleton pattern - only ONE instance of this service ever exists
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Firebase Messaging instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Flutter Local Notifications instance (for showing notifications in foreground)
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Stream controller for notification taps
  final StreamController<String> _notificationTapController =
      StreamController<String>.broadcast();

  Stream<String> get notificationTapStream => _notificationTapController.stream;

  /// Initialize the notification service
  /// Call this in your main() function AFTER Firebase.initializeApp()
  Future<void> initialize() async {
    print('🔔 Initializing Notification Service...');

    // Step 1: Request permission (especially important for iOS)
    await _requestPermission();

    // Step 2: Initialize local notifications
    await _initializeLocalNotifications();

    // Step 3: Get the device token
    await _getToken();

    // Step 4: Set up message handlers
    _setupMessageHandlers();

    // Step 5: Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    print('✅ Notification Service initialized!');
  }

  /// Request permission to send notifications
  Future<void> _requestPermission() async {
    print('📝 Requesting notification permission...');

    final settings = await _messaging.requestPermission(
      alert: true,      // Show notification banner
      badge: true,      // Show badge on app icon
      sound: true,      // Play sound
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission!');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional permission');
    } else {
      print('❌ User denied permission');
    }
  }

  /// Initialize local notifications (for foreground notifications)
  Future<void> _initializeLocalNotifications() async {
    print('📱 Initializing local notifications...');

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with settings
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android (required for Android 8.0+)
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }

    print('✅ Local notifications initialized!');
  }

  /// Create a notification channel (Android 8.0+)
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get the FCM token for this device
  Future<String?> _getToken() async {
    try {
      final token = await _messaging.getToken();
      print('📱 FCM Token: $token');

      // TODO: Send this token to your server
      // Example: await api.sendTokenToServer(token);

      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  /// Set up message handlers for different app states
  void _setupMessageHandlers() {
    print('🎯 Setting up message handlers...');

    // Handle messages when app is in FOREGROUND
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundNotificationTap);

    // Check if app was opened from a terminated state
    _checkInitialMessage();
  }

  /// Handle messages when app is in foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Foreground message received!');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');

    // Show a local notification
    await _showLocalNotification(message);
  }

  /// Show a local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        message.hashCode, // Unique ID
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['route'], // Pass route for navigation
      );
    }
  }

  /// Handle notification tap when app is in background
  void _handleBackgroundNotificationTap(RemoteMessage message) {
    print('👆 Notification tapped (background)');
    print('Data: ${message.data}');

    // Navigate to specific screen
    final route = message.data['route'];
    if (route != null) {
      _notificationTapController.add(route);
    }
  }

  /// Check if app was opened from a terminated state by a notification
  Future<void> _checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message != null) {
      print('👆 App opened from notification (terminated state)');
      print('Data: ${message.data}');

      // Navigate to specific screen
      final route = message.data['route'];
      if (route != null) {
        // Wait a bit for the app to be ready
        await Future.delayed(const Duration(seconds: 1));
        _notificationTapController.add(route);
      }
    }
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('👆 Local notification tapped');
    print('Payload: ${response.payload}');

    if (response.payload != null) {
      _notificationTapController.add(response.payload!);
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Clean up
  void dispose() {
    _notificationTapController.close();
  }
}
```

**What does this code do?**

Think of this as building a complete mail system for your house:
1. **Request permission** = Ask if you can install a mailbox
2. **Initialize local notifications** = Build the physical mailbox
3. **Get token** = Get your unique address
4. **Setup handlers** = Hire people to check the mail and knock on your door
5. **Background handler** = Someone who checks mail even when you're not home

---

### Example 2: Initialize in Main Function

Update your `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Notification Service
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _setupNotificationNavigation();
  }

  void _setupNotificationNavigation() {
    // Listen for notification taps
    NotificationService().notificationTapStream.listen((route) {
      print('🚀 Navigating to: $route');

      // Navigate based on route
      _navigatorKey.currentState?.pushNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notifications Demo',
      navigatorKey: _navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
```

---

## Part 3: Handling Different Notification States

Notifications behave differently based on your app's state. Let's understand each:

### App States Explained

```
1. FOREGROUND (App is open and active)
   ├─ User is currently using your app
   ├─ Screen is on and app is visible
   └─ Notifications appear as banners/alerts inside the app

2. BACKGROUND (App is running but not visible)
   ├─ User switched to another app
   ├─ App is still in memory
   └─ Notifications appear in notification tray

3. TERMINATED (App is completely closed)
   ├─ User swiped away the app
   ├─ App is not in memory
   └─ Notifications appear in notification tray
```

### Example 3: Advanced State Handling

Create `lib/services/advanced_notification_service.dart`:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AdvancedNotificationService {
  static final AdvancedNotificationService _instance =
      AdvancedNotificationService._internal();
  factory AdvancedNotificationService() => _instance;
  AdvancedNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Track what the user is currently viewing
  String? currentRoute;

  /// Handle notification based on current app state
  void handleNotificationByState(
    RemoteMessage message,
    BuildContext context,
  ) {
    final notificationType = message.data['type'];
    final targetRoute = message.data['route'];

    print('📋 Notification type: $notificationType');
    print('🎯 Target route: $targetRoute');
    print('📍 Current route: $currentRoute');

    // Don't navigate if user is already on that screen
    if (targetRoute == currentRoute) {
      print('ℹ️ User is already on target screen');
      _showSnackBar(context, 'You are already viewing this content!');
      return;
    }

    // Navigate based on notification type
    switch (notificationType) {
      case 'chat':
        _handleChatNotification(message, context);
        break;
      case 'order':
        _handleOrderNotification(message, context);
        break;
      case 'promotion':
        _handlePromotionNotification(message, context);
        break;
      default:
        _handleGenericNotification(message, context);
    }
  }

  void _handleChatNotification(RemoteMessage message, BuildContext context) {
    final chatId = message.data['chat_id'];
    final senderId = message.data['sender_id'];

    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'chatId': chatId,
        'senderId': senderId,
      },
    );
  }

  void _handleOrderNotification(RemoteMessage message, BuildContext context) {
    final orderId = message.data['order_id'];

    Navigator.pushNamed(
      context,
      '/order-details',
      arguments: {'orderId': orderId},
    );
  }

  void _handlePromotionNotification(RemoteMessage message, BuildContext context) {
    final promoCode = message.data['promo_code'];

    // Show a dialog instead of navigating
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? 'Special Offer!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.notification?.body ?? ''),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Code: $promoCode',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shop');
            },
            child: const Text('Shop Now'),
          ),
        ],
      ),
    );
  }

  void _handleGenericNotification(RemoteMessage message, BuildContext context) {
    final route = message.data['route'];
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
```

---

## Part 4: Custom Notification Sounds and Icons

### Example 4: Custom Sounds (Android)

1. **Add your sound file:**
   - Place your `.mp3` or `.wav` file in `android/app/src/main/res/raw/`
   - Name it `notification_sound.mp3`

2. **Update notification code:**

```dart
Future<void> showNotificationWithCustomSound(
  String title,
  String body,
) async {
  const androidDetails = AndroidNotificationDetails(
    'custom_sound_channel',
    'Custom Sound Notifications',
    channelDescription: 'Notifications with custom sounds',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('notification_sound'), // No extension!
    playSound: true,
    icon: '@drawable/ic_notification',
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'notification_sound.mp3', // With extension for iOS
  );

  const details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await _localNotifications.show(
    0,
    title,
    body,
    details,
  );
}
```

### Example 5: Custom Icons and Colors (Android)

```dart
Future<void> showStyledNotification(
  String title,
  String body,
  {required Color color, String? largeIconUrl}
) async {
  // For image, you can use a URL or local asset
  final largeIcon = largeIconUrl != null
      ? await _downloadAndSaveImage(largeIconUrl)
      : null;

  final androidDetails = AndroidNotificationDetails(
    'styled_channel',
    'Styled Notifications',
    channelDescription: 'Beautiful styled notifications',
    importance: Importance.high,
    priority: Priority.high,
    color: color,
    largeIcon: largeIcon,
    styleInformation: const BigTextStyleInformation(''),
    icon: '@drawable/ic_notification',
  );

  await _localNotifications.show(
    0,
    title,
    body,
    NotificationDetails(android: androidDetails),
  );
}

// Helper to download image
Future<FilePathAndroidBitmap?> _downloadAndSaveImage(String url) async {
  try {
    final http.Response response = await http.get(Uri.parse(url));
    final Directory directory = await getTemporaryDirectory();
    final File file = File('${directory.path}/notification_icon.png');
    await file.writeAsBytes(response.bodyBytes);
    return FilePathAndroidBitmap(file.path);
  } catch (e) {
    print('Error downloading image: $e');
    return null;
  }
}
```

---

## Part 5: Topic-Based Notifications

Topics allow you to send notifications to groups of users!

### Example 6: Topic Subscription Manager

Create `lib/services/topic_manager.dart`:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class TopicManager {
  static final TopicManager _instance = TopicManager._internal();
  factory TopicManager() => _instance;
  TopicManager._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Keep track of subscribed topics
  final Set<String> _subscribedTopics = {};

  Set<String> get subscribedTopics => {..._subscribedTopics};

  /// Subscribe to a topic
  Future<bool> subscribeToTopic(String topic) async {
    try {
      print('📢 Subscribing to topic: $topic');
      await _messaging.subscribeToTopic(topic);
      _subscribedTopics.add(topic);
      print('✅ Successfully subscribed to: $topic');
      return true;
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
      return false;
    }
  }

  /// Unsubscribe from a topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      print('🔕 Unsubscribing from topic: $topic');
      await _messaging.unsubscribeFromTopic(topic);
      _subscribedTopics.remove(topic);
      print('✅ Successfully unsubscribed from: $topic');
      return true;
    } catch (e) {
      print('❌ Error unsubscribing from topic $topic: $e');
      return false;
    }
  }

  /// Subscribe to multiple topics at once
  Future<void> subscribeToMultipleTopics(List<String> topics) async {
    print('📢 Subscribing to ${topics.length} topics...');

    for (final topic in topics) {
      await subscribeToTopic(topic);
      // Small delay to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 100));
    }

    print('✅ Finished subscribing to all topics!');
  }

  /// Toggle topic subscription
  Future<bool> toggleTopicSubscription(String topic) async {
    if (_subscribedTopics.contains(topic)) {
      return await unsubscribeFromTopic(topic);
    } else {
      return await subscribeToTopic(topic);
    }
  }

  /// Check if subscribed to a topic
  bool isSubscribedTo(String topic) {
    return _subscribedTopics.contains(topic);
  }
}

/// Common topics you might use
class NotificationTopics {
  static const String news = 'news';
  static const String sports = 'sports';
  static const String weather = 'weather';
  static const String promotions = 'promotions';
  static const String updates = 'app_updates';
  static const String breaking = 'breaking_news';

  // User preference topics
  static const String daily = 'daily_digest';
  static const String weekly = 'weekly_summary';

  // Category-specific
  static String categoryTopic(String category) => 'category_$category';
  static String userTopic(String userId) => 'user_$userId';
}
```

### Example 7: Topic Subscription UI

```dart
import 'package:flutter/material.dart';
import 'services/topic_manager.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final topicManager = TopicManager();

  final List<TopicOption> topics = [
    TopicOption(
      name: NotificationTopics.news,
      displayName: 'News Updates',
      description: 'Get the latest news',
      icon: Icons.newspaper,
    ),
    TopicOption(
      name: NotificationTopics.sports,
      displayName: 'Sports',
      description: 'Live scores and updates',
      icon: Icons.sports_soccer,
    ),
    TopicOption(
      name: NotificationTopics.promotions,
      displayName: 'Promotions',
      description: 'Special offers and deals',
      icon: Icons.local_offer,
    ),
    TopicOption(
      name: NotificationTopics.breaking,
      displayName: 'Breaking News',
      description: 'Important breaking news',
      icon: Icons.notifications_active,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final isSubscribed = topicManager.isSubscribedTo(topic.name);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SwitchListTile(
              value: isSubscribed,
              onChanged: (value) async {
                setState(() {}); // Update UI immediately

                final success = await topicManager.toggleTopicSubscription(
                  topic.name,
                );

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? 'Subscribed to ${topic.displayName}'
                            : 'Unsubscribed from ${topic.displayName}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  setState(() {});
                }
              },
              title: Row(
                children: [
                  Icon(topic.icon, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    topic.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 36, top: 4),
                child: Text(topic.description),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopicOption {
  final String name;
  final String displayName;
  final String description;
  final IconData icon;

  TopicOption({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
  });
}
```

---

## Part 6: Sending Notifications (Backend)

### Example 8: Node.js Cloud Function

Install Firebase Admin SDK:
```bash
npm install firebase-admin
```

Create `functions/index.js`:

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

/**
 * Send notification to a specific device
 * Call with: https://your-project.cloudfunctions.net/sendNotification
 */
exports.sendNotification = functions.https.onRequest(async (req, res) => {
  // Get data from request
  const { token, title, body, data } = req.body;

  // Validate input
  if (!token || !title || !body) {
    return res.status(400).json({
      success: false,
      error: 'Missing required fields: token, title, body'
    });
  }

  // Create message
  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: data || {},
    token: token,
    android: {
      notification: {
        sound: 'default',
        priority: 'high',
        channelId: 'high_importance_channel',
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
        },
      },
    },
  };

  try {
    // Send message
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);

    return res.status(200).json({
      success: true,
      messageId: response
    });
  } catch (error) {
    console.error('Error sending message:', error);
    return res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * Send notification to a topic
 */
exports.sendTopicNotification = functions.https.onRequest(async (req, res) => {
  const { topic, title, body, data } = req.body;

  if (!topic || !title || !body) {
    return res.status(400).json({
      success: false,
      error: 'Missing required fields: topic, title, body'
    });
  }

  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: data || {},
    topic: topic,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent topic message:', response);

    return res.status(200).json({
      success: true,
      messageId: response
    });
  } catch (error) {
    console.error('Error sending topic message:', error);
    return res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * Send notification when a new chat message is created
 * Automatically triggered by Firestore
 */
exports.onNewChatMessage = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const message = snapshot.data();
    const chatId = context.params.chatId;

    // Get recipient's FCM token from Firestore
    const recipientDoc = await admin.firestore()
      .collection('users')
      .doc(message.recipientId)
      .get();

    const recipientToken = recipientDoc.data().fcmToken;

    if (!recipientToken) {
      console.log('Recipient has no FCM token');
      return null;
    }

    // Send notification
    const payload = {
      notification: {
        title: `New message from ${message.senderName}`,
        body: message.text,
      },
      data: {
        type: 'chat',
        chatId: chatId,
        route: '/chat',
      },
      token: recipientToken,
    };

    try {
      await admin.messaging().send(payload);
      console.log('Chat notification sent successfully');
    } catch (error) {
      console.error('Error sending chat notification:', error);
    }

    return null;
  });

/**
 * Send scheduled daily digest
 * Runs every day at 9 AM
 */
exports.sendDailyDigest = functions.pubsub
  .schedule('0 9 * * *')
  .timeZone('America/New_York')
  .onRun(async (context) => {
    console.log('Sending daily digest...');

    const message = {
      notification: {
        title: 'Your Daily Digest',
        body: 'Here\'s what happened today!',
      },
      data: {
        type: 'digest',
        route: '/digest',
      },
      topic: 'daily_digest',
    };

    try {
      await admin.messaging().send(message);
      console.log('Daily digest sent successfully');
    } catch (error) {
      console.error('Error sending daily digest:', error);
    }

    return null;
  });
```

### Example 9: Python Backend (Flask)

```python
from flask import Flask, request, jsonify
from firebase_admin import credentials, messaging, initialize_app

app = Flask(__name__)

# Initialize Firebase Admin SDK
cred = credentials.Certificate('path/to/serviceAccountKey.json')
initialize_app(cred)

@app.route('/send-notification', methods=['POST'])
def send_notification():
    """Send notification to a specific device"""
    data = request.json

    # Get parameters
    token = data.get('token')
    title = data.get('title')
    body = data.get('body')
    custom_data = data.get('data', {})

    # Validate
    if not token or not title or not body:
        return jsonify({
            'success': False,
            'error': 'Missing required fields'
        }), 400

    # Create message
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        data=custom_data,
        token=token,
        android=messaging.AndroidConfig(
            priority='high',
            notification=messaging.AndroidNotification(
                sound='default',
                channel_id='high_importance_channel',
            ),
        ),
        apns=messaging.APNSConfig(
            payload=messaging.APNSPayload(
                aps=messaging.Aps(
                    sound='default',
                    badge=1,
                ),
            ),
        ),
    )

    try:
        # Send message
        response = messaging.send(message)
        print(f'Successfully sent message: {response}')

        return jsonify({
            'success': True,
            'messageId': response
        }), 200
    except Exception as e:
        print(f'Error sending message: {e}')
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/send-to-topic', methods=['POST'])
def send_to_topic():
    """Send notification to a topic"""
    data = request.json

    topic = data.get('topic')
    title = data.get('title')
    body = data.get('body')

    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        topic=topic,
    )

    try:
        response = messaging.send(message)
        return jsonify({
            'success': True,
            'messageId': response
        }), 200
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    app.run(debug=True)
```

---

## Part 7: Testing Notifications

### Method 1: Firebase Console (Easiest!)

1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter notification title and text
4. Click "Send test message"
5. Paste your FCM token (from app logs)
6. Click "Test"

### Method 2: Using curl Command

```bash
# Replace YOUR_SERVER_KEY with your Firebase Server Key
# Replace FCM_TOKEN with the device token

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test from curl!"
    },
    "data": {
      "route": "/test",
      "type": "test"
    }
  }'
```

### Example 10: In-App Testing Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/notification_service.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final _notificationService = NotificationService();
  String? _fcmToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    setState(() => _isLoading = true);
    final token = await _notificationService._getToken();
    setState(() {
      _fcmToken = token;
      _isLoading = false;
    });
  }

  void _copyToken() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // FCM Token Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FCM Token',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use this token to send test notifications',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SelectableText(
                              _fcmToken ?? 'Loading...',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _copyToken,
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy Token'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Test Methods
                  const Text(
                    'How to Test:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildTestMethod(
                    title: '1. Firebase Console',
                    description: 'Easiest method - use Firebase web interface',
                    steps: [
                      'Go to Firebase Console',
                      'Click Cloud Messaging',
                      'Click "Send test message"',
                      'Paste your token',
                      'Click "Test"',
                    ],
                  ),

                  _buildTestMethod(
                    title: '2. Notification Composer',
                    description: 'Send to all users or specific topics',
                    steps: [
                      'Firebase Console → Cloud Messaging',
                      'Click "Send your first message"',
                      'Fill in title and message',
                      'Select target (app, topic, or token)',
                      'Click "Review" then "Publish"',
                    ],
                  ),

                  _buildTestMethod(
                    title: '3. API Request',
                    description: 'Use Postman or curl',
                    steps: [
                      'Get your Server Key from Firebase',
                      'Send POST to fcm.googleapis.com',
                      'Include Authorization header',
                      'Include notification payload',
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTestMethod({
    required String title,
    required String description,
    required List<String> steps,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: steps
                  .map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(step)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Part 8: Deep Linking with Notifications

Deep linking allows notifications to open specific screens with specific data!

### Example 11: Complete Deep Linking Setup

```dart
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  /// Handle deep link from notification
  Future<void> handleDeepLink(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    print('🔗 Handling deep link with data: $data');

    final String? route = data['route'];
    final String? action = data['action'];

    if (route == null) {
      print('⚠️ No route specified in notification data');
      return;
    }

    // Wait a bit to ensure app is ready
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate based on route
    switch (route) {
      case '/chat':
        await _handleChatDeepLink(context, data);
        break;

      case '/profile':
        await _handleProfileDeepLink(context, data);
        break;

      case '/order':
        await _handleOrderDeepLink(context, data);
        break;

      case '/product':
        await _handleProductDeepLink(context, data);
        break;

      default:
        // Generic navigation
        Navigator.pushNamed(context, route, arguments: data);
    }
  }

  Future<void> _handleChatDeepLink(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final chatId = data['chat_id'];
    final userId = data['user_id'];

    if (chatId == null) {
      print('⚠️ Missing chat_id in notification data');
      return;
    }

    // Navigate to chat screen
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'chatId': chatId,
        'userId': userId,
        'fromNotification': true,
      },
    );
  }

  Future<void> _handleProfileDeepLink(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final userId = data['user_id'];

    if (userId == null) {
      print('⚠️ Missing user_id in notification data');
      return;
    }

    Navigator.pushNamed(
      context,
      '/profile',
      arguments: {'userId': userId},
    );
  }

  Future<void> _handleOrderDeepLink(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final orderId = data['order_id'];

    if (orderId == null) {
      print('⚠️ Missing order_id in notification data');
      return;
    }

    // Maybe show loading while fetching order details
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Fetch order details
    // final order = await OrderService().getOrder(orderId);

    // Close loading
    Navigator.pop(context);

    // Navigate to order details
    Navigator.pushNamed(
      context,
      '/order-details',
      arguments: {'orderId': orderId},
    );
  }

  Future<void> _handleProductDeepLink(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final productId = data['product_id'];

    if (productId == null) {
      print('⚠️ Missing product_id in notification data');
      return;
    }

    Navigator.pushNamed(
      context,
      '/product-details',
      arguments: {'productId': productId},
    );
  }
}
```

---

## Part 9: Best Practices

### ✅ DO's:

1. **Always Request Permission First**
   ```dart
   await FirebaseMessaging.instance.requestPermission();
   ```

2. **Handle All Three App States**
   - Foreground (app open)
   - Background (app minimized)
   - Terminated (app closed)

3. **Send Token to Your Server**
   ```dart
   final token = await FirebaseMessaging.instance.getToken();
   await api.saveToken(token);
   ```

4. **Update Token When It Changes**
   ```dart
   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
     api.updateToken(newToken);
   });
   ```

5. **Use Meaningful Notification Data**
   ```json
   {
     "notification": {
       "title": "New Message",
       "body": "John sent you a message"
     },
     "data": {
       "type": "chat",
       "chat_id": "123",
       "user_id": "456",
       "route": "/chat"
     }
   }
   ```

6. **Test on Real Devices**
   - iOS simulator doesn't support push notifications
   - Always test on physical devices

### ❌ DON'Ts:

1. **Don't Spam Users**
   - Respect notification preferences
   - Don't send too many notifications

2. **Don't Send Sensitive Data in Notifications**
   - Notifications are not encrypted
   - Don't include passwords, credit cards, etc.

3. **Don't Forget iOS Certificates**
   - iOS requires APNs key setup
   - Test iOS notifications separately

4. **Don't Ignore Permission Denied**
   ```dart
   if (settings.authorizationStatus == AuthorizationStatus.denied) {
     // Show explanation why notifications are useful
     // Guide user to settings
   }
   ```

---

## Part 10: Troubleshooting Common Issues

### Issue 1: Notifications Not Received on iOS

**Possible Causes:**
1. APNs key not uploaded to Firebase
2. Wrong bundle identifier
3. App not registered for remote notifications
4. Testing on simulator (doesn't work!)

**Solution:**
```dart
// Check if registered
FirebaseMessaging.instance.getAPNSToken().then((token) {
  print('APNs token: $token');
  if (token == null) {
    print('❌ Not registered for remote notifications!');
  }
});
```

### Issue 2: Notifications Not Showing When App is in Foreground

**Cause:** Need to manually show local notification

**Solution:**
```dart
FirebaseMessaging.onMessage.listen((message) {
  // Show local notification
  _showLocalNotification(message);
});
```

### Issue 3: Token is Null

**Possible Causes:**
1. Firebase not initialized
2. No internet connection
3. Google Play Services not available (Android)

**Solution:**
```dart
try {
  final token = await FirebaseMessaging.instance.getToken();
  if (token == null) {
    // Retry after delay
    await Future.delayed(Duration(seconds: 2));
    final retryToken = await FirebaseMessaging.instance.getToken();
    print('Retry token: $retryToken');
  }
} catch (e) {
  print('Error getting token: $e');
}
```

### Issue 4: Notification Not Opening Correct Screen

**Cause:** Not handling notification data correctly

**Solution:**
```dart
// Make sure you're reading the correct data field
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  print('Full message data: ${message.data}');
  print('Notification: ${message.notification}');

  // Check both notification and data
  final route = message.data['route'] ?? '/';
  Navigator.pushNamed(context, route);
});
```

### Issue 5: Background Notifications Not Working

**Cause:** Background handler not registered

**Solution:**
```dart
// Must be at top level, not in a class
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}

// In main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register BEFORE runApp()
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}
```

---

## Summary: You're Now a Notification Expert!

Congratulations! You now know:

1. ✅ What push notifications are (magical mailbox!)
2. ✅ How to set up FCM for Android and iOS
3. ✅ How to handle foreground, background, and terminated states
4. ✅ How to customize sounds and icons
5. ✅ How to implement deep linking
6. ✅ How to use topic-based notifications
7. ✅ How to send notifications from a backend
8. ✅ How to test notifications thoroughly
9. ✅ Best practices and troubleshooting

Push notifications are like having a direct line to your users' attention. Use them wisely, and your app will keep users engaged and informed!

**Remember:** With great power comes great responsibility. Don't spam your users! 😊

---

## Next Steps

1. Implement notification preferences in your app
2. Set up scheduled notifications
3. Add rich media (images, videos) to notifications
4. Implement notification actions (reply, like, etc.)
5. Track notification analytics

Happy coding! 🚀
