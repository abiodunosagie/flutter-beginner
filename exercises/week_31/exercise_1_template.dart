/// Week 31, Exercise 1: Optimize ListView Performance
///
/// BEGINNER LEVEL
///
/// Convert regular ListView to ListView.builder:
/// 1. Start with ListView with many children
/// 2. Convert to ListView.builder
/// 3. Measure performance difference
/// 4. Add const constructors where possible
///
/// Learning objectives:
/// - ListView.builder benefits
/// - Lazy loading
/// - Performance measurement

import 'package:flutter/material.dart';

void main() {
  runApp(ListOptimizationApp());
}

class ListOptimizationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Optimization',
      home: ItemListScreen(),
    );
  }
}

class ItemListScreen extends StatelessWidget {
  // TODO: Create large list of items (1000+)
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Optimize This List')),
      body: ListView(
        // TODO: Convert to ListView.builder
        children: List.generate(1000, (index) {
          return ListTile(
            leading: Icon(Icons.star),
            title: Text('Item $index'),
            subtitle: Text('Subtitle for item $index'),
          );
        }),
      ),
    );
  }
}
