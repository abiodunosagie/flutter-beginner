# Local Notifications

## The Big Idea In One Sentence

> Local notifications are alerts your app itself schedules on the device (no server needed), like a reminder that pops up at 8am, even when the app is closed.

## The Simple Explanation

Notifications are like sticky notes for your phone - they remind you of things even when you're not using the app!

```
┌─────────────────────────────────────────────────────────┐
│                   NOTIFICATIONS                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────────────────────────┐                   │
│  │ 📱 Your Phone                    │                   │
│  │                                  │                   │
│  │ ┌────────────────────────────┐  │                   │
│  │ │ 🔔 My App                  │  │                   │
│  │ │ Don't forget your meeting! │  │ ← Notification    │
│  │ │ In 15 minutes              │  │                   │
│  │ └────────────────────────────┘  │                   │
│  │                                  │                   │
│  └──────────────────────────────────┘                   │
│                                                          │
│  LOCAL = From your app, no server needed               │
│  PUSH = From a server (covered in Firebase level)      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Setup

### 1. Add Package

```yaml
dependencies:
  flutter_local_notifications: ^16.1.0
  timezone: ^0.9.2  # For scheduled notifications
```

### 2. Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Inside <manifest> tag -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Inside <application> tag -->
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

### 3. iOS Configuration

Add to `ios/Runner/AppDelegate.swift`:

```swift
import flutter_local_notifications

// Inside application function
FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)
}

if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

---

## Initialize Notifications

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }
}
```

---

## Show Simple Notification

```dart
Future<void> showNotification({
  required int id,
  required String title,
  required String body,
  String? payload,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'default_channel',        // Channel ID
    'Default Notifications',  // Channel name
    channelDescription: 'Default notification channel',
    importance: Importance.high,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();

  const details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await _notifications.show(
    id,
    title,
    body,
    details,
    payload: payload,
  );
}

// Usage
await notificationService.showNotification(
  id: 1,
  title: 'Hello!',
  body: 'This is a test notification',
  payload: 'test_payload',
);
```

---

## Scheduled Notifications

```dart
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

// Initialize timezone (call once at app start)
void initializeTimezone() {
  tz_data.initializeTimeZones();
}

// Schedule a notification
Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledTime,
  String? payload,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'scheduled_channel',
    'Scheduled Notifications',
    channelDescription: 'Notifications that are scheduled',
    importance: Importance.high,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();

  const details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await _notifications.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    details,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    payload: payload,
  );
}

// Usage: Remind me in 1 hour
await notificationService.scheduleNotification(
  id: 2,
  title: 'Reminder',
  body: 'Time to take a break!',
  scheduledTime: DateTime.now().add(const Duration(hours: 1)),
);
```

---

## Daily Repeating Notification

```dart
Future<void> scheduleDailyNotification({
  required int id,
  required String title,
  required String body,
  required int hour,
  required int minute,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'daily_channel',
    'Daily Notifications',
    channelDescription: 'Daily recurring notifications',
    importance: Importance.high,
  );

  const details = NotificationDetails(android: androidDetails);

  await _notifications.zonedSchedule(
    id,
    title,
    body,
    _nextInstanceOfTime(hour, minute),
    details,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
  );
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }

  return scheduled;
}

// Usage: Daily reminder at 9:00 AM
await notificationService.scheduleDailyNotification(
  id: 3,
  title: 'Good Morning!',
  body: 'Start your day with a smile 😊',
  hour: 9,
  minute: 0,
);
```

---

## Cancel Notifications

```dart
// Cancel specific notification
await _notifications.cancel(1);

// Cancel all notifications
await _notifications.cancelAll();
```

---

## Notification with Actions

```dart
Future<void> showNotificationWithActions() async {
  const androidDetails = AndroidNotificationDetails(
    'action_channel',
    'Action Notifications',
    channelDescription: 'Notifications with action buttons',
    importance: Importance.high,
    priority: Priority.high,
    actions: [
      AndroidNotificationAction(
        'accept',
        'Accept',
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'decline',
        'Decline',
        showsUserInterface: true,
      ),
    ],
  );

  const details = NotificationDetails(android: androidDetails);

  await _notifications.show(
    4,
    'Meeting Invitation',
    'John invited you to a meeting',
    details,
    payload: 'meeting_123',
  );
}

// Handle action in onDidReceiveNotificationResponse
void _onNotificationTapped(NotificationResponse response) {
  if (response.actionId == 'accept') {
    print('User accepted');
  } else if (response.actionId == 'decline') {
    print('User declined');
  } else {
    print('Notification tapped: ${response.payload}');
  }
}
```

---

## Complete Notification Service

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Function(String?)? onNotificationTapped;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        onNotificationTapped?.call(response.payload);
      },
    );
  }

  // Request permission (Android 13+)
  Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  // Show immediate notification
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  // Schedule notification
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Schedule daily notification
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Cancel notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPending() async {
    return await _notifications.pendingNotificationRequests();
  }

  NotificationDetails get _notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Notifications',
        channelDescription: 'Main notification channel',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, hour, minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
```

---

## Usage Example

```dart
class ReminderApp extends StatefulWidget {
  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  final _notifications = NotificationService();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _notifications.initialize();
    await _notifications.requestPermission();

    _notifications.onNotificationTapped = (payload) {
      if (payload != null) {
        // Navigate to specific screen based on payload
        print('Navigate to: $payload');
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => _notifications.show(
              id: 1,
              title: 'Test',
              body: 'This is a test notification!',
            ),
            child: const Text('Show Notification Now'),
          ),

          ElevatedButton(
            onPressed: () => _notifications.schedule(
              id: 2,
              title: 'Reminder',
              body: '5 seconds have passed!',
              when: DateTime.now().add(const Duration(seconds: 5)),
            ),
            child: const Text('Schedule in 5 seconds'),
          ),

          ElevatedButton(
            onPressed: () => _notifications.scheduleDaily(
              id: 3,
              title: 'Daily Reminder',
              body: 'Time for your daily check-in!',
              hour: 9,
              minute: 0,
            ),
            child: const Text('Schedule Daily at 9 AM'),
          ),

          ElevatedButton(
            onPressed: () => _notifications.cancelAll(),
            child: const Text('Cancel All'),
          ),
        ],
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│           LOCAL NOTIFICATIONS SUMMARY                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  PACKAGE: flutter_local_notifications + timezone        │
│                                                          │
│  SHOW NOTIFICATION:                                      │
│  notifications.show(id, title, body, details)           │
│                                                          │
│  SCHEDULE:                                               │
│  notifications.zonedSchedule(...)                       │
│                                                          │
│  REPEAT DAILY:                                           │
│  matchDateTimeComponents: DateTimeComponents.time       │
│                                                          │
│  CANCEL:                                                 │
│  notifications.cancel(id)                               │
│  notifications.cancelAll()                              │
│                                                          │
│  REMEMBER:                                               │
│  ├── Initialize at app start                            │
│  ├── Request permission (Android 13+, iOS)              │
│  ├── Handle notification taps                           │
│  └── Configure Android/iOS properly                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What makes a notification "local" rather than "push"?

<details>
<summary>Answer</summary>
The app schedules it on the device itself, no server or internet needed. Push notifications come from a server.
</details>

**Q2.** Give one good use for a local notification.

<details>
<summary>Answer</summary>
A reminder or alarm: "Time to drink water", "Your timer is done", a daily habit nudge.
</details>

**Q3.** Do notifications need permission?

<details>
<summary>Answer</summary>
Yes, modern Android and iOS require the user to allow notifications.
</details>

---

## Assignment

### Problem 1: Local or push?

A reminder at 9pm scheduled by the app with no internet: local or push?

### Problem 2: A use case

Name one feature in a to-do app that would use a local notification.

### Problem 3: First requirement

What must you get from the user before showing notifications?

---

## Assignment Answers

### Problem 1: Local or push?

**Local.** The app scheduled it on the device; no server is involved.

### Problem 2: A use case

A due-date reminder: notify the user when a task is due (e.g. "Homework due in 1 hour").

### Problem 3: First requirement

Notification permission, the user has to allow notifications.

---

**Next:** `04-URLLauncher.md` - Opening external apps and URLs
