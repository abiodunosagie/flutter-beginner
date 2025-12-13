/// Week 30, Exercise 1: Prepare Android Release Build
///
/// BEGINNER LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Production App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: ReleaseInfoScreen(),
    );
  }
}

class ReleaseInfoScreen extends StatelessWidget {
  final String appVersion = '1.0.0';
  final String buildNumber = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Release Build Info')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.android, size: 80, color: Colors.green),
                  SizedBox(height: 16),
                  Text('Production Ready', 
                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Version: $appVersion ($buildNumber)'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildChecklistCard(),
          SizedBox(height: 16),
          _buildCommandsCard(),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pre-Release Checklist', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _checklistItem('App name configured'),
            _checklistItem('App icon added'),
            _checklistItem('Version number updated'),
            _checklistItem('Permissions configured'),
            _checklistItem('Tested in release mode'),
          ],
        ),
      ),
    );
  }

  Widget _checklistItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildCommandsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build Commands', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _commandItem('APK', 'flutter build apk --release'),
            _commandItem('App Bundle', 'flutter build appbundle --release'),
            _commandItem('Split APKs', 'flutter build apk --split-per-abi'),
          ],
        ),
      ),
    );
  }

  Widget _commandItem(String title, String command) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Text(command, style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
