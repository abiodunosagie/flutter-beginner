/// Week 29, Exercise 4: Local Notifications
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Implement local notifications:
/// 1. Add flutter_local_notifications package
/// 2. Initialize notification plugin
/// 3. Schedule notifications
/// 4. Handle notification taps
/// 5. Show different notification types
///
/// Learning objectives:
/// - Local notifications
/// - Notification scheduling
/// - Handle user interactions

import 'package:flutter/material.dart';

void main() {
  runApp(NotificationsApp());
}

class NotificationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications',
      home: NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // TODO: Implement notification features
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notifications')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Buttons to show different notification types
          ],
        ),
      ),
    );
  }
}
