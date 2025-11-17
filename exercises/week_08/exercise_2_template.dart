// Exercise 2: Advanced Counter with Increment/Decrement/Reset (Beginner-Intermediate)
// Create a counter with three buttons: increment, decrement, and reset

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Counter',
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // TODO: Create _counter variable initialized to 0

  // TODO: Create _incrementCounter method

  // TODO: Create _decrementCounter method

  // TODO: Create _resetCounter method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add counter display

            // TODO: Add Row with three buttons:
            // 1. ElevatedButton with Icons.remove - calls _decrementCounter
            // 2. ElevatedButton with "Reset" text - calls _resetCounter
            // 3. ElevatedButton with Icons.add - calls _incrementCounter
          ],
        ),
      ),
    );
  }
}
