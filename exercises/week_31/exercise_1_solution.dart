/// Week 31, Exercise 1: Optimize ListView Performance
///
/// BEGINNER LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(ListOptimizationApp());
}

class ListOptimizationApp extends StatelessWidget {
  const ListOptimizationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Optimization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ItemListScreen(),
    );
  }
}

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimized List (10,000 items)'),
      ),
      body: ListView.builder(
        itemCount: 10000,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.star),
            title: Text('Item $index'),
            subtitle: Text('This is subtitle for item $index'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ListView.builder only builds visible items!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.info),
      ),
    );
  }
}

/* 
Performance Benefits:

Before (ListView with children):
- All 10,000 widgets created at once
- High memory usage
- Slow initial render

After (ListView.builder):
- Only visible items created
- Low memory usage  
- Fast initial render
- Smooth scrolling

Key Optimizations:
1. ListView.builder instead of ListView
2. const constructors for static widgets
3. No unnecessary rebuilds
*/
