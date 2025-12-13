/// Week 31, Exercise 2: Add Const Constructors
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Optimize widget rebuilds with const:
/// 1. Find widgets that can be const
/// 2. Add const constructors
/// 3. Use const for static widgets
/// 4. Measure rebuild performance
///
/// Learning objectives:
/// - Const constructors
/// - Widget rebuilds
/// - Performance optimization

import 'package:flutter/material.dart';

void main() {
  runApp(ConstOptimizationApp());
}

class ConstOptimizationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Const Optimization',
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Make these const
          Icon(Icons.add, size: 100),
          SizedBox(height: 20),
          Text('Count:', style: TextStyle(fontSize: 24)),
          Text('$_counter', style: TextStyle(fontSize: 48)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: Text('Increment'),
          ),
        ],
      ),
    );
  }
}
