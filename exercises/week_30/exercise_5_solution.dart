/// Week 30, Exercise 5: Complete Deployment Checklist
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(DeploymentChecklistApp());
}

class DeploymentChecklistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deployment Checklist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: ChecklistScreen(),
    );
  }
}

class ChecklistItem {
  final String title;
  bool isChecked;
  ChecklistItem(this.title, {this.isChecked = false});
}

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<ChecklistItem> preReleaseItems = [
    ChecklistItem('All features tested'),
    ChecklistItem('No critical bugs'),
    ChecklistItem('Performance optimized'),
    ChecklistItem('App icon added'),
    ChecklistItem('Version number updated'),
    ChecklistItem('Privacy policy ready'),
  ];

  final List<ChecklistItem> androidItems = [
    ChecklistItem('Keystore generated and backed up'),
    ChecklistItem('Signing configured'),
    ChecklistItem('App bundle built'),
    ChecklistItem('Play Store listing complete'),
    ChecklistItem('Screenshots uploaded'),
  ];

  final List<ChecklistItem> iosItems = [
    ChecklistItem('Certificates configured'),
    ChecklistItem('Bundle ID set'),
    ChecklistItem('App archived in Xcode'),
    ChecklistItem('App Store listing complete'),
    ChecklistItem('Screenshots uploaded'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deployment Checklist')),
      body: ListView(
        children: [
          _buildSection('Pre-Release', preReleaseItems, Colors.blue),
          _buildSection('Android', androidItems, Colors.green),
          _buildSection('iOS', iosItems, Colors.purple),
          _buildProgressCard(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<ChecklistItem> items, Color color) {
    final completed = items.where((item) => item.isChecked).length;
    final total = items.length;

    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: color.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.checklist, color: color),
                SizedBox(width: 12),
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                Text('$completed/$total', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...items.map((item) => CheckboxListTile(
            title: Text(item.title),
            value: item.isChecked,
            onChanged: (value) {
              setState(() => item.isChecked = value ?? false);
            },
          )),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final allItems = [...preReleaseItems, ...androidItems, ...iosItems];
    final completed = allItems.where((item) => item.isChecked).length;
    final total = allItems.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Overall Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            LinearProgressIndicator(value: progress, minHeight: 10),
            SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(0)}% Complete'),
            if (progress == 1.0) ...[
              SizedBox(height: 16),
              Icon(Icons.celebration, size: 48, color: Colors.green),
              Text('Ready to Deploy!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }
}
