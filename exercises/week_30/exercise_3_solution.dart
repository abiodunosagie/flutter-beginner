/// Week 30, Exercise 3: iOS Build and Archive
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(IOSBuildApp());
}

class IOSBuildApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Build Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: IOSBuildScreen(),
    );
  }
}

class IOSBuildScreen extends StatelessWidget {
  final bool isIOS = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('iOS Deployment')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (!isIOS)
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(child: Text('iOS deployment requires a Mac with Xcode')),
                  ],
                ),
              ),
            ),
          _buildRequirementsCard(),
          _buildStepsCard(),
          _buildCommandsCard(),
        ],
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _requirementItem('Mac computer'),
            _requirementItem('Xcode installed'),
            _requirementItem('Apple Developer Account (\$99/year)'),
            _requirementItem('Valid certificates and profiles'),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _stepItem('1', 'Open Runner.xcworkspace in Xcode'),
            _stepItem('2', 'Select Runner target'),
            _stepItem('3', 'Configure Bundle ID'),
            _stepItem('4', 'Select Team'),
            _stepItem('5', 'Product → Archive'),
            _stepItem('6', 'Distribute to App Store'),
          ],
        ),
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
            Text('Flutter Commands', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            _commandBox('Build iOS release', 'flutter build ios --release'),
            _commandBox('Build IPA', 'flutter build ipa'),
          ],
        ),
      ),
    );
  }

  Widget _requirementItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _stepItem(String number, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue,
            child: Text(number, style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _commandBox(String label, String command) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey[200],
            width: double.infinity,
            child: Text(command, style: TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }
}
