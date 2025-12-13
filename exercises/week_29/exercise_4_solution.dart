/// Week 29, Exercise 4: Local Notifications
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(NotificationsApp());
}

class NotificationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _notificationCount = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notifications')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.notifications, size: 64, color: Colors.purple),
                    SizedBox(height: 16),
                    Text('Notifications Sent: $_notificationCount', 
                         style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showInstantNotification,
              icon: Icon(Icons.notifications_active),
              label: Text('Show Instant Notification'),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _scheduleNotification,
              icon: Icon(Icons.schedule),
              label: Text('Schedule Notification (5s)'),
            ),
            SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _cancelAllNotifications,
              icon: Icon(Icons.cancel),
              label: Text('Cancel All'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInstantNotification() {
    setState(() => _notificationCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification shown (demo)'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  void _scheduleNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for 5 seconds (demo)')),
    );
  }

  void _cancelAllNotifications() {
    setState(() => _notificationCount = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All notifications cancelled')),
    );
  }
}
