/// Week 31, Exercise 5: Complete Performance Audit
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const PerformanceAuditApp());
}

class PerformanceAuditApp extends StatelessWidget {
  const PerformanceAuditApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Audit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const AuditScreen(),
    );
  }
}

class AuditScreen extends StatelessWidget {
  const AuditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Audit Checklist')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AuditSection(
            title: 'Build Performance',
            items: [
              'Use const constructors',
              'Avoid unnecessary rebuilds',
              'Keep build() methods light',
              'Use keys for list items',
            ],
          ),
          _AuditSection(
            title: 'List Performance',
            items: [
              'Use ListView.builder',
              'Implement pagination',
              'Limit item complexity',
              'Cache item heights',
            ],
          ),
          _AuditSection(
            title: 'Image Performance',
            items: [
              'Use cached_network_image',
              'Compress images',
              'Set cache limits',
              'Use appropriate formats',
            ],
          ),
          _AuditSection(
            title: 'Memory Management',
            items: [
              'Dispose controllers',
              'Cancel streams',
              'Clear image cache',
              'Monitor memory usage',
            ],
          ),
          _AuditSection(
            title: 'Tools & Monitoring',
            items: [
              'Run in profile mode',
              'Use DevTools',
              'Check frame times',
              'Monitor app size',
            ],
          ),
        ],
      ),
    );
  }
}

class _AuditSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _AuditSection({
    required this.title,
    required this.items,
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
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_box_outline_blank, size: 20),
                  const SizedBox(width: 12),
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
