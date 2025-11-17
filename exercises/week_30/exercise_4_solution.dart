/// Week 30, Exercise 4: App Store Connect Submission
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(AppStoreApp());
}

class AppStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Store Submission',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: AppStoreScreen(),
    );
  }
}

class AppStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Store Connect')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildPhaseCard('1. App Store Connect Setup', [
            'Create new app in App Store Connect',
            'Fill basic app information',
            'Set pricing and availability',
            'Add App Store categories',
          ], Colors.blue),
          _buildPhaseCard('2. App Information', [
            'Write app description',
            'Add keywords for SEO',
            'Upload app icon (1024x1024)',
            'Create privacy policy URL',
          ], Colors.green),
          _buildPhaseCard('3. Screenshots & Media', [
            'Upload screenshots for all device sizes',
            'Add app preview video (optional)',
            'Prepare promotional text',
          ], Colors.orange),
          _buildPhaseCard('4. Submit for Review', [
            'Fill review information',
            'Add demo account if needed',
            'Submit for review',
            'Wait for approval (1-3 days)',
          ], Colors.purple),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(String title, List<String> items, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Divider(),
            ...items.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, size: 20, color: color),
                  SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
