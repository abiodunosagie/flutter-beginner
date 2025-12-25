// Example 03: Local Notifications
// Show and schedule notifications

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// NOTIFICATION SERVICE
// ═══════════════════════════════════════════════════════════════

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

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
      onDidReceiveNotificationResponse: (response) {
        print('Notification tapped: ${response.payload}');
      },
    );
  }

  Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  NotificationDetails get _details {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Notifications',
        channelDescription: 'Main notification channel',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Show immediate notification
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(id, title, body, _details, payload: payload);
  }

  // Schedule notification
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(delay),
      _details,
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
      _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
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
}

// ═══════════════════════════════════════════════════════════════
// NOTIFICATION SCREEN
// ═══════════════════════════════════════════════════════════════

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _notificationService = NotificationService();
  List<PendingNotificationRequest> _pendingNotifications = [];
  int _notificationId = 0;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _loadPendingNotifications();
  }

  Future<void> _requestPermission() async {
    final granted = await _notificationService.requestPermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification permission denied'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _loadPendingNotifications() async {
    final pending = await _notificationService.getPending();
    setState(() => _pendingNotifications = pending);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingNotifications,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ════════════════════════════════════════════════
          // INSTANT NOTIFICATION
          // ════════════════════════════════════════════════

          _buildSection(
            icon: Icons.notifications_active,
            title: 'Instant Notification',
            description: 'Show a notification right now',
            buttonText: 'Show Now',
            onPressed: () async {
              await _notificationService.show(
                id: _notificationId++,
                title: 'Hello! 👋',
                body: 'This is an instant notification!',
                payload: 'instant',
              );
              _showSuccess('Notification sent!');
            },
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // SCHEDULED NOTIFICATION
          // ════════════════════════════════════════════════

          _buildSection(
            icon: Icons.schedule,
            title: 'Scheduled Notification',
            description: 'Schedule a notification in 5 seconds',
            buttonText: 'Schedule in 5s',
            onPressed: () async {
              await _notificationService.schedule(
                id: _notificationId++,
                title: 'Scheduled! ⏰',
                body: '5 seconds have passed!',
                delay: const Duration(seconds: 5),
                payload: 'scheduled',
              );
              _showSuccess('Notification scheduled in 5 seconds');
              _loadPendingNotifications();
            },
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // DELAYED NOTIFICATIONS
          // ════════════════════════════════════════════════

          _buildSection(
            icon: Icons.timer,
            title: 'Delayed Notifications',
            description: 'Schedule multiple notifications at different times',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDelayButton('10s', const Duration(seconds: 10)),
                _buildDelayButton('30s', const Duration(seconds: 30)),
                _buildDelayButton('1m', const Duration(minutes: 1)),
                _buildDelayButton('5m', const Duration(minutes: 5)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // DAILY NOTIFICATION
          // ════════════════════════════════════════════════

          _buildSection(
            icon: Icons.repeat,
            title: 'Daily Notification',
            description: 'Set a daily reminder at 9:00 AM',
            buttonText: 'Set Daily at 9 AM',
            onPressed: () async {
              await _notificationService.scheduleDaily(
                id: 999, // Fixed ID for daily notification
                title: 'Good Morning! ☀️',
                body: 'Start your day with a smile!',
                hour: 9,
                minute: 0,
              );
              _showSuccess('Daily notification set for 9:00 AM');
              _loadPendingNotifications();
            },
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // PENDING NOTIFICATIONS
          // ════════════════════════════════════════════════

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.pending_actions),
                      const SizedBox(width: 8),
                      const Text(
                        'Pending Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text('${_pendingNotifications.length}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_pendingNotifications.isEmpty)
                    const Text(
                      'No pending notifications',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ..._pendingNotifications.map((n) => Card(
                          child: ListTile(
                            title: Text(n.title ?? 'No title'),
                            subtitle: Text(n.body ?? 'No body'),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () async {
                                await _notificationService.cancel(n.id);
                                _loadPendingNotifications();
                              },
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // CANCEL ALL
          // ════════════════════════════════════════════════

          OutlinedButton.icon(
            onPressed: () async {
              await _notificationService.cancelAll();
              _loadPendingNotifications();
              _showSuccess('All notifications cancelled');
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Cancel All Notifications'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
    String? buttonText,
    VoidCallback? onPressed,
    Widget? child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            if (child != null) child,
            if (buttonText != null && onPressed != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelayButton(String label, Duration delay) {
    return ElevatedButton(
      onPressed: () async {
        await _notificationService.schedule(
          id: _notificationId++,
          title: 'Timer Done! ⏱️',
          body: '$label have passed!',
          delay: delay,
        );
        _showSuccess('Notification scheduled in $label');
        _loadPendingNotifications();
      },
      child: Text(label),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * SETUP REQUIRED
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add to pubspec.yaml:
 *    dependencies:
 *      flutter_local_notifications: ^16.1.0
 *      timezone: ^0.9.2
 *
 * 2. Android - Add to android/app/src/main/AndroidManifest.xml:
 *    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
 *
 * 3. iOS - Notifications work out of the box but need permission
 *
 * ═══════════════════════════════════════════════════════════════
 */
