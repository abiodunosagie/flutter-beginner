// Exercise 1: Simple Counter App (Beginner)
// Create a counter app with increment button

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // TODO: Create a variable _counter initialized to 0

  // TODO: Create method _incrementCounter() that uses setState to increment _counter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add Text widget showing "Count:"

            // TODO: Add Text widget showing _counter value (fontSize: 48, bold, blue)

            // TODO: Add SizedBox with height 40

            // TODO: Add ElevatedButton with "Increment" text
            // onPressed should call _incrementCounter
          ],
        ),
      ),
    );
  }
}
