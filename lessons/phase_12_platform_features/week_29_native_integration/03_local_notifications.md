# Local Notifications: The Complete Guide

## What Are Local Notifications? (Explained Like You're 5)

Imagine you have a toy alarm clock in your room. When you set it, it goes "RING RING" to wake you up in the morning. The alarm clock doesn't need to call anyone or use the internet - it just rings all by itself when the time comes!

Local notifications are exactly like that alarm clock, but for your app! They're little messages that pop up on your phone to remind you about something - like:
- "Time to drink water!"
- "Your favorite show starts in 10 minutes!"
- "Don't forget to feed your pet!"

The word "local" means the notification comes from YOUR phone, not from the internet. It's like your phone is its own little alarm clock that can remind you about anything!

## Why Are Local Notifications So Cool?

Think about these everyday things:
1. **Alarm Clock Apps** - They wake you up even if your internet is off!
2. **Reminder Apps** - "Take your medicine at 3pm" shows up right at 3pm
3. **Fitness Apps** - "Time to move! You've been sitting for 1 hour"
4. **Game Apps** - "Your energy is full, come play!"
5. **Study Apps** - "Daily quiz is ready!"

All of these work WITHOUT the internet! The notification is scheduled on your phone, and your phone remembers to show it at the right time.

## Setting Up flutter_local_notifications

### Step 1: Add the Package

First, we need to add the special tool (package) that helps us create notifications. Open your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.2  # We need this for scheduled notifications!
```

Why do we need `timezone`? Because if you want to schedule a notification for "3pm tomorrow", your phone needs to know what timezone you're in!

### Step 2: Install the Package

Run this command in your terminal (think of it like downloading the notification toolbox):

```bash
flutter pub get
```

## Android Setup (Making Notifications Work on Android Phones)

Android phones need some special instructions before they can show notifications. It's like telling the phone, "Hey, this app is allowed to show notifications!"

### Step 1: Update AndroidManifest.xml

Open the file at `android/app/src/main/AndroidManifest.xml` and add these permissions:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- These tell Android: "This app needs to show notifications!" -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:label="my_awesome_app">

        <!-- This makes notifications work even after phone restarts -->
        <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
            </intent-filter>
        </receiver>

        <!-- This handles notifications when app is in background -->
        <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
            android:exported="false"/>

        <activity
            android:name=".MainActivity">
            <!-- Your other activity settings -->
        </activity>
    </application>
</manifest>
```

What do these permissions mean?
- `RECEIVE_BOOT_COMPLETED` - Notifications still work after you turn your phone off and on
- `VIBRATE` - Phone can buzz when notification appears
- `SCHEDULE_EXACT_ALARM` - App can schedule notifications for exact times
- `POST_NOTIFICATIONS` - App can actually show notifications (Android 13+)

### Step 2: Create Notification Icons

Android needs special icons for notifications. Create these folders and add a white icon:

```
android/app/src/main/res/drawable/
```

Add a file called `notification_icon.png` (should be a white icon on transparent background).

### Step 3: Custom Notification Sounds (Android)

Want your notification to make a special sound? Add sound files here:

```
android/app/src/main/res/raw/notification_sound.mp3
```

The sound file must be in `.mp3`, `.wav`, or `.ogg` format!

## iOS Setup (Making Notifications Work on iPhones)

iPhones are a bit different. They're very protective and always ask permission before letting apps show notifications.

### Step 1: Update Info.plist

Open `ios/Runner/Info.plist` and add:

```xml
<dict>
    <!-- Other settings... -->

    <!-- This tells iOS why you need to show notifications -->
    <key>NSUserNotificationCenterUsageDescription</key>
    <string>We need to show you important reminders!</string>

    <!-- This keeps notifications working in background -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
    </array>
</dict>
```

### Step 2: Custom Notification Sounds (iOS)

For iPhone custom sounds, add your sound file here:

```
ios/Runner/sounds/notification_sound.aiff
```

Important: iPhone prefers `.aiff` or `.caf` format (not `.mp3`!)

## Complete Notification Service Class

Let's build our notification system step by step!

### Example 1: Basic Notification Service

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// This is our notification helper - like a notification manager
class NotificationService {
  // This is the tool that actually creates notifications
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Has the notification system been set up yet?
  static bool _initialized = false;

  // Initialize the notification system
  // Call this when your app starts!
  static Future<void> initialize() async {
    if (_initialized) return; // Already set up!

    // Set up timezones (needed for scheduled notifications)
    tz.initializeTimeZones();

    // Android settings - how notifications look on Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // App icon to show
    );

    // iOS settings - how notifications look on iPhone
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,  // Ask to show alerts
      requestBadgePermission: true,  // Ask to show badge numbers
      requestSoundPermission: true,  // Ask to play sounds
    );

    // Combine Android and iOS settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with settings
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    print('🔔 Notifications initialized!');
  }

  // What happens when someone taps a notification
  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped!');
    print('Payload: ${response.payload}');

    // You can use the payload to navigate to specific screens!
    // For example: if payload is "chat", open chat screen
  }

  // Request permission (important for iOS!)
  static Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,  // Show alert
            badge: true,  // Show badge
            sound: true,  // Play sound
          );
      return result ?? false;
    }
    // Android automatically has permission in most cases
    return true;
  }
}
```

### Example 2: Show a Simple Notification RIGHT NOW

```dart
// Extension to make our NotificationService even more powerful!
extension ShowNotification on NotificationService {
  static Future<void> showNow({
    required int id,           // Unique number for this notification
    required String title,     // Big text at top
    required String body,      // Smaller text below
    String? payload,           // Extra data to send
  }) async {
    // Android notification settings
    const androidDetails = AndroidNotificationDetails(
      'instant_channel',        // Channel ID (must be unique)
      'Instant Notifications',  // Channel name (user sees this)
      channelDescription: 'Notifications that show immediately',
      importance: Importance.high,  // How important is this?
      priority: Priority.high,      // How urgent is this?
      showWhen: true,                // Show the time
      enableVibration: true,         // Make phone buzz
      playSound: true,               // Make a sound
    );

    // iOS notification settings
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,   // Show alert
      presentBadge: true,   // Show badge
      presentSound: true,   // Play sound
    );

    // Combine settings for both platforms
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification!
    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );

    print('📬 Notification shown: $title');
  }
}
```

### Example 3: Schedule a Notification for Later

```dart
extension ScheduledNotification on NotificationService {
  // Schedule a notification for a specific time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Convert DateTime to timezone-aware time
    final scheduledDate = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    // Create notification details
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Notifications scheduled for later',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule it!
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    print('⏰ Notification scheduled for: $scheduledTime');
  }
}
```

### Example 4: Repeating Notifications (Daily, Weekly, etc.)

```dart
extension RepeatingNotification on NotificationService {
  // Show a notification every day at the same time
  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required Time time,  // What time each day?
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Notifications',
      channelDescription: 'Notifications that repeat every day',
      importance: Importance.high,
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
      _nextInstanceOfTime(time),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );

    print('🔁 Daily notification set for ${time.hour}:${time.minute}');
  }

  // Helper: Calculate next time this should occur
  static tz.TZDateTime _nextInstanceOfTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Show a notification every week on a specific day
  static Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,  // 1=Monday, 7=Sunday
    required Time time,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'weekly_channel',
      'Weekly Notifications',
      channelDescription: 'Notifications that repeat every week',
      importance: Importance.high,
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
      _nextInstanceOfDayOfWeek(dayOfWeek, time),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );

    print('📅 Weekly notification set for day $dayOfWeek at ${time.hour}:${time.minute}');
  }

  // Helper: Calculate next instance of a specific day of week
  static tz.TZDateTime _nextInstanceOfDayOfWeek(int dayOfWeek, Time time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);

    // Keep adding days until we hit the right day of week
    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
```

### Example 5: Notification with Custom Sound

```dart
extension CustomSoundNotification on NotificationService {
  static Future<void> showWithCustomSound({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Android with custom sound
    const androidDetails = AndroidNotificationDetails(
      'sound_channel',
      'Custom Sound Notifications',
      channelDescription: 'Notifications with custom sounds',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      // Note: Don't include file extension! Just the name
    );

    // iOS with custom sound
    const iosDetails = DarwinNotificationDetails(
      sound: 'notification_sound.aiff',
      // Note: Include file extension for iOS!
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);

    print('🔊 Notification with custom sound shown!');
  }
}
```

### Example 6: Notification with Action Buttons

```dart
extension ActionNotification on NotificationService {
  static Future<void> showWithActions({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Android with action buttons
    const androidDetails = AndroidNotificationDetails(
      'action_channel',
      'Action Notifications',
      channelDescription: 'Notifications with action buttons',
      importance: Importance.high,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'action_yes',      // Action ID
          'Yes',             // Button text
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'action_no',
          'No',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'action_maybe',
          'Maybe',
          showsUserInterface: true,
        ),
      ],
    );

    // iOS with action buttons
    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'yes_no_category',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);

    print('🎯 Notification with actions shown!');
  }

  // Handle action button taps
  static void handleAction(NotificationResponse response) {
    if (response.actionId == 'action_yes') {
      print('User tapped YES!');
      // Do something...
    } else if (response.actionId == 'action_no') {
      print('User tapped NO!');
      // Do something else...
    } else if (response.actionId == 'action_maybe') {
      print('User tapped MAYBE!');
      // Do another thing...
    }
  }
}
```

### Example 7: Big Picture Notification (Android)

```dart
extension BigPictureNotification on NotificationService {
  static Future<void> showBigPicture({
    required int id,
    required String title,
    required String body,
    required String imagePath,  // Path to image asset
    String? payload,
  }) async {
    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath),
      largeIcon: FilePathAndroidBitmap(imagePath),
      contentTitle: title,
      summaryText: body,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );

    final androidDetails = AndroidNotificationDetails(
      'big_picture_channel',
      'Big Picture Notifications',
      channelDescription: 'Notifications with large images',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(id, title, body, details, payload: payload);

    print('🖼️ Big picture notification shown!');
  }
}
```

### Example 8: Progress Bar Notification

```dart
extension ProgressNotification on NotificationService {
  static Future<void> showProgress({
    required int id,
    required String title,
    required int progress,      // 0-100
    required int maxProgress,   // Usually 100
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'progress_channel',
      'Progress Notifications',
      channelDescription: 'Notifications showing progress',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
      ongoing: true,  // Can't be dismissed while showing
      autoCancel: false,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id,
      title,
      '$progress% complete',
      details,
      payload: payload,
    );
  }

  // Update the progress
  static Future<void> updateProgress({
    required int id,
    required String title,
    required int progress,
    required int maxProgress,
  }) async {
    await showProgress(
      id: id,
      title: title,
      progress: progress,
      maxProgress: maxProgress,
    );
  }

  // Complete the progress
  static Future<void> completeProgress({
    required int id,
    required String title,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'progress_channel',
      'Progress Notifications',
      channelDescription: 'Notifications showing progress',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: false,
      ongoing: false,
      autoCancel: true,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id,
      title,
      'Complete!',
      details,
    );
  }
}
```

### Example 9: Cancel Notifications

```dart
extension CancelNotification on NotificationService {
  // Cancel a specific notification
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
    print('❌ Notification $id cancelled');
  }

  // Cancel all notifications
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
    print('🧹 All notifications cancelled');
  }

  // Get list of pending scheduled notifications
  static Future<List<PendingNotificationRequest>> getPending() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Get list of active notifications
  static Future<List<ActiveNotification>> getActive() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();
    return result ?? [];
  }
}
```

### Example 10: Notification Manager Widget

```dart
import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationDemo extends StatefulWidget {
  @override
  State<NotificationDemo> createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  int _notificationId = 0;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await NotificationService.initialize();
    await NotificationService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Demo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCard(
            title: 'Instant Notification',
            description: 'Show a notification right now!',
            icon: Icons.notifications_active,
            color: Colors.blue,
            onTap: () async {
              await NotificationService.showNow(
                id: _notificationId++,
                title: 'Hello!',
                body: 'This is an instant notification 🎉',
                payload: 'instant',
              );
              _showSnackBar('Instant notification sent!');
            },
          ),

          _buildCard(
            title: 'Scheduled Notification',
            description: 'Show notification in 5 seconds',
            icon: Icons.schedule,
            color: Colors.orange,
            onTap: () async {
              await NotificationService.scheduleNotification(
                id: _notificationId++,
                title: 'Scheduled!',
                body: 'This was scheduled 5 seconds ago',
                scheduledTime: DateTime.now().add(Duration(seconds: 5)),
                payload: 'scheduled',
              );
              _showSnackBar('Notification scheduled for 5 seconds!');
            },
          ),

          _buildCard(
            title: 'Daily Notification',
            description: 'Repeat every day at 9 AM',
            icon: Icons.repeat,
            color: Colors.green,
            onTap: () async {
              await NotificationService.scheduleDailyNotification(
                id: 100,  // Same ID = replaces previous
                title: 'Good Morning!',
                body: 'Time to start your day 🌅',
                time: Time(9, 0, 0),  // 9:00 AM
                payload: 'daily',
              );
              _showSnackBar('Daily notification set for 9 AM!');
            },
          ),

          _buildCard(
            title: 'With Actions',
            description: 'Notification with Yes/No buttons',
            icon: Icons.touch_app,
            color: Colors.purple,
            onTap: () async {
              await NotificationService.showWithActions(
                id: _notificationId++,
                title: 'Question',
                body: 'Do you like Flutter?',
                payload: 'action',
              );
              _showSnackBar('Notification with actions sent!');
            },
          ),

          _buildCard(
            title: 'Custom Sound',
            description: 'Notification with special sound',
            icon: Icons.music_note,
            color: Colors.red,
            onTap: () async {
              await NotificationService.showWithCustomSound(
                id: _notificationId++,
                title: 'Listen!',
                body: 'This has a custom sound 🔊',
                payload: 'sound',
              );
              _showSnackBar('Notification with custom sound sent!');
            },
          ),

          _buildCard(
            title: 'Cancel All',
            description: 'Remove all scheduled notifications',
            icon: Icons.clear_all,
            color: Colors.grey,
            onTap: () async {
              await NotificationService.cancelAll();
              _showSnackBar('All notifications cancelled!');
            },
          ),

          _buildCard(
            title: 'View Pending',
            description: 'See what notifications are scheduled',
            icon: Icons.list,
            color: Colors.teal,
            onTap: () async {
              final pending = await NotificationService.getPending();
              _showDialog(
                'Pending Notifications',
                pending.isEmpty
                    ? 'No pending notifications'
                    : pending.map((n) => 'ID: ${n.id}, Title: ${n.title}').join('\n'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

## Real-World Use Cases

### Use Case 1: Water Reminder App

```dart
class WaterReminderApp {
  // Remind user to drink water every 2 hours
  static Future<void> setupWaterReminders() async {
    // Cancel any existing reminders
    await NotificationService.cancelAll();

    // Schedule reminders from 8 AM to 10 PM (every 2 hours)
    final times = [8, 10, 12, 14, 16, 18, 20];

    for (int i = 0; i < times.length; i++) {
      await NotificationService.scheduleDailyNotification(
        id: 200 + i,
        title: '💧 Time to Drink Water!',
        body: 'Stay hydrated! Drink a glass of water.',
        time: Time(times[i], 0, 0),
        payload: 'water_reminder',
      );
    }

    print('Water reminders set up for ${times.length} times per day!');
  }
}
```

### Use Case 2: Study Reminder App

```dart
class StudyReminderApp {
  // Remind student to study every day after school
  static Future<void> setupStudyReminder() async {
    await NotificationService.scheduleDailyNotification(
      id: 300,
      title: '📚 Study Time!',
      body: 'Time for your daily study session. Let\'s learn!',
      time: Time(16, 0, 0),  // 4 PM
      payload: 'study_reminder',
    );

    print('Study reminder set for 4 PM every day!');
  }

  // Remind about upcoming test
  static Future<void> scheduleTestReminder(DateTime testDate) async {
    // Remind 1 day before test
    await NotificationService.scheduleNotification(
      id: 301,
      title: '🎯 Test Tomorrow!',
      body: 'Don\'t forget! You have a test tomorrow.',
      scheduledTime: testDate.subtract(Duration(days: 1)),
      payload: 'test_reminder',
    );

    // Remind on test day (morning)
    await NotificationService.scheduleNotification(
      id: 302,
      title: '📝 Test Today!',
      body: 'Good luck on your test today! You got this!',
      scheduledTime: DateTime(
        testDate.year,
        testDate.month,
        testDate.day,
        7,  // 7 AM
        0,
      ),
      payload: 'test_day',
    );
  }
}
```

### Use Case 3: Fitness App

```dart
class FitnessReminderApp {
  // Remind to exercise
  static Future<void> setupWorkoutReminder() async {
    // Morning workout - Monday, Wednesday, Friday
    for (int day in [1, 3, 5]) {  // Mon, Wed, Fri
      await NotificationService.scheduleWeeklyNotification(
        id: 400 + day,
        title: '💪 Workout Time!',
        body: 'Time for your morning workout!',
        dayOfWeek: day,
        time: Time(6, 30, 0),  // 6:30 AM
        payload: 'morning_workout',
      );
    }

    print('Workout reminders set up!');
  }

  // Remind to move after sitting
  static Future<void> remindToMove() async {
    await NotificationService.showNow(
      id: 450,
      title: '🚶 Time to Move!',
      body: 'You\'ve been sitting for an hour. Take a quick walk!',
      payload: 'move_reminder',
    );
  }
}
```

### Use Case 4: Medication Reminder

```dart
class MedicationReminderApp {
  // Set up medication reminders
  static Future<void> setupMedicationReminder({
    required String medicationName,
    required List<Time> times,  // Times to take medicine
  }) async {
    for (int i = 0; i < times.length; i++) {
      await NotificationService.scheduleDailyNotification(
        id: 500 + i,
        title: '💊 Time for Medicine',
        body: 'Take your $medicationName',
        time: times[i],
        payload: 'medication_$medicationName',
      );
    }

    print('Medicine reminders set for $medicationName at ${times.length} times');
  }

  // Example usage
  static Future<void> example() async {
    await setupMedicationReminder(
      medicationName: 'Vitamins',
      times: [
        Time(8, 0, 0),   // 8 AM
        Time(20, 0, 0),  // 8 PM
      ],
    );
  }
}
```

### Use Case 5: Daily Quote App

```dart
class DailyQuoteApp {
  static final List<String> quotes = [
    'Believe you can and you\'re halfway there.',
    'The only way to do great work is to love what you do.',
    'Don\'t watch the clock; do what it does. Keep going.',
    'The future belongs to those who believe in their dreams.',
    'Success is not final, failure is not fatal.',
    'It always seems impossible until it\'s done.',
    'You are never too old to set another goal.',
  ];

  // Send a random quote every morning
  static Future<void> setupDailyQuote() async {
    await NotificationService.scheduleDailyNotification(
      id: 600,
      title: '✨ Daily Quote',
      body: quotes[DateTime.now().day % quotes.length],
      time: Time(8, 0, 0),  // 8 AM
      payload: 'daily_quote',
    );

    print('Daily quote reminder set up!');
  }
}
```

## Common Troubleshooting

### Problem 1: Notifications Not Showing on Android 13+

**Solution:** Request notification permission at runtime:

```dart
Future<void> requestAndroidPermission() async {
  if (Platform.isAndroid) {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final granted = await androidPlugin?.requestNotificationsPermission();
    print('Android notification permission: $granted');
  }
}
```

### Problem 2: Scheduled Notifications Not Firing

**Solution:** Check battery optimization settings and use `exactAllowWhileIdle` mode.

### Problem 3: Custom Sounds Not Playing

**Solution:**
- Android: File must be in `android/app/src/main/res/raw/` without extension in code
- iOS: File must be in `ios/Runner/` with extension in code

### Problem 4: Notifications Disappear After Phone Restart

**Solution:** Add `RECEIVE_BOOT_COMPLETED` permission in AndroidManifest.xml (shown above).

## Complete Main.dart Example

```dart
import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'notification_demo.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService.initialize();
  await NotificationService.requestPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: NotificationDemo(),
    );
  }
}
```

## Best Practices

1. **Always Initialize Early** - Call `NotificationService.initialize()` in `main()` before `runApp()`

2. **Request Permission** - Especially important for iOS! Always ask before scheduling notifications

3. **Use Unique IDs** - Each notification needs a unique ID. Same ID = replaces previous notification

4. **Test on Real Devices** - Notifications behave differently on emulators vs real phones

5. **Don't Spam Users** - Too many notifications will make users disable them!

6. **Provide Value** - Only send notifications that are truly helpful to the user

7. **Let Users Control** - Always provide settings to turn off or customize notifications

8. **Handle Timezone Changes** - If user travels, timezone-aware scheduling prevents issues

9. **Cancel When Done** - If a reminder is no longer needed, cancel it to free resources

10. **Test Edge Cases** - What happens if phone is off? Battery saver is on? Try everything!

## Congratulations!

You now know everything about local notifications! You learned:
- What local notifications are (like alarm clocks for your app!)
- How to set up the package for Android and iOS
- How to show instant notifications
- How to schedule notifications for later
- How to create repeating (daily/weekly) notifications
- How to add custom sounds and action buttons
- Real-world examples you can use in your own apps

Remember: Local notifications are incredibly powerful! They work even when your app is closed and the phone has no internet. Use them wisely to create apps that truly help people!

Now go build something amazing!
