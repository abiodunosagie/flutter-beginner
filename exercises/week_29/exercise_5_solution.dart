/// Week 29, Exercise 5: Location-Based Reminder App
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Reminders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: ReminderScreen(),
    );
  }
}

class Reminder {
  final String id;
  final String title;
  final String location;
  final double lat;
  final double lng;
  bool isActive;

  Reminder({
    required this.id,
    required this.title,
    required this.location,
    required this.lat,
    required this.lng,
    this.isActive = true,
  });
}

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<Reminder> _reminders = [
    Reminder(
      id: '1',
      title: 'Buy groceries',
      location: 'Supermarket',
      lat: 37.7749,
      lng: -122.4194,
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Reminders')),
      body: _reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No reminders yet'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.place, color: Colors.deepOrange),
                    title: Text(reminder.title),
                    subtitle: Text(reminder.location),
                    trailing: Switch(
                      value: reminder.isActive,
                      onChanged: (value) {
                        setState(() => reminder.isActive = value);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add reminder dialog (demo)')),
    );
  }
}
