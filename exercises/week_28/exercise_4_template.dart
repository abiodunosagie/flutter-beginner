/// Week 28, Exercise 4: Push Notifications with FCM
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Implement Firebase Cloud Messaging (Push Notifications):
/// 1. Add firebase_messaging package
/// 2. Request notification permissions
/// 3. Get FCM token
/// 4. Handle foreground notifications
/// 5. Handle background notifications
/// 6. Handle notification tap (open app)
/// 7. Show local notification when app is in foreground
///
/// Learning objectives:
/// - Firebase Cloud Messaging
/// - Notification permissions
/// - Handle different notification states

import 'package:flutter/material.dart';
// TODO: Add firebase_messaging package
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  // TODO: Initialize Firebase
  runApp(NotificationsApp());
}

class NotificationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notifications',
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
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // TODO: Initialize FCM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Push Notifications')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Show FCM token

            // TODO: Button to request permissions

            SizedBox(height: 16),

            // TODO: List of received notifications
            Text(
              'Received Notifications:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_messages[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Implement _initializeFCM()
  // - Request permissions
  // - Get FCM token
  // - Listen to onMessage (foreground)
  // - Listen to onMessageOpenedApp (background tap)

  // TODO: Implement _handleMessage(RemoteMessage message)
  // - Extract title and body
  // - Add to messages list
  // - Show notification if needed
}
