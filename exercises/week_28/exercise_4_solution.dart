/// Week 28, Exercise 4: Push Notifications with FCM
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(NotificationsApp());
}

class NotificationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? _fcmToken;
  List<Map<String, String>> _notifications = [];
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      // Real FCM implementation:
      // final messaging = FirebaseMessaging.instance;

      // Request permission
      // final settings = await messaging.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );

      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   setState(() => _permissionGranted = true);
      // }

      // Get FCM token
      // final token = await messaging.getToken();
      // setState(() => _fcmToken = token);

      // Listen to foreground messages
      // FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Listen to background tap
      // FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);

      // Demo simulation
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _fcmToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
        _permissionGranted = true;
      });
    } catch (e) {
      print('FCM initialization failed: $e');
    }
  }

  void _handleForegroundMessage(Map<String, String> message) {
    setState(() {
      _notifications.insert(0, message);
    });

    // Show in-app notification or use flutter_local_notifications
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message['title'] ?? 'New notification'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Handle tap
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications'),
        actions: [
          if (_permissionGranted)
            Icon(Icons.check_circle, color: Colors.white),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text(
                          'FCM Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Permission: ${_permissionGranted ? "Granted ✓" : "Not granted"}',
                      style: TextStyle(fontSize: 14),
                    ),
                    if (_fcmToken != null) ...[
                      SizedBox(height: 8),
                      Text(
                        'FCM Token:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _fcmToken!,
                          style: TextStyle(fontSize: 11, fontFamily: 'monospace'),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _simulateNotification,
              icon: Icon(Icons.send),
              label: Text('Simulate Notification (Demo)'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 24),

            Row(
              children: [
                Icon(Icons.history, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Notification History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            if (_notifications.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No notifications yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: _notifications.map((notification) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.notifications, color: Colors.white),
                      ),
                      title: Text(
                        notification['title'] ?? 'Notification',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(notification['body'] ?? ''),
                          SizedBox(height: 4),
                          Text(
                            notification['time'] ?? '',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _simulateNotification() {
    final notification = {
      'title': 'Test Notification',
      'body': 'This is a simulated push notification',
      'time': DateTime.now().toString(),
    };

    _handleForegroundMessage(notification);
  }
}

/*
To send a test notification, use Firebase Console or this curl command:

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Hello",
      "body": "Test notification from FCM"
    }
  }'
*/
