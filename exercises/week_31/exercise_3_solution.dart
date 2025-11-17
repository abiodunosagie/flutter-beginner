/// Week 31, Exercise 3: Use DevTools to Find Performance Issues
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const PerformanceTestApp());
}

class PerformanceTestApp extends StatelessWidget {
  const PerformanceTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Profiling',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DevTools Guide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoCard(
            title: 'Run in Profile Mode',
            icon: Icons.speed,
            steps: [
              'flutter run --profile',
              'Performance mode (not debug!)',
              'Shows real performance',
            ],
          ),
          _InfoCard(
            title: 'Open DevTools',
            icon: Icons.developer_mode,
            steps: [
              'flutter pub global activate devtools',
              'flutter pub global run devtools',
              'Or use IDE DevTools button',
            ],
          ),
          _InfoCard(
            title: 'Performance Tab',
            icon: Icons.analytics,
            steps: [
              'Check frame rendering time',
              'Look for jank (>16ms frames)',
              'Identify slow widgets',
            ],
          ),
          _InfoCard(
            title: 'Common Issues',
            icon: Icons.warning,
            steps: [
              'Heavy build() methods',
              'Not using const',
              'Unnecessary rebuilds',
              'Large images not cached',
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> steps;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.steps,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            ...steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text(step)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
