/// Week 31, Exercise 2: Add Const Constructors
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const ConstOptimizationApp());
}

class ConstOptimizationApp extends StatelessWidget {
  const ConstOptimizationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Const Optimization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter with Const')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Count:', style: TextStyle(fontSize: 24)),
            Text('$_counter', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('Increment'),
            ),
            const SizedBox(height: 40),
            const _OptimizationInfo(),
          ],
        ),
      ),
    );
  }
}

class _OptimizationInfo extends StatelessWidget {
  const _OptimizationInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Const Widgets:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('✓ Not rebuilt when parent rebuilds'),
            Text('✓ Reused across widget tree'),
            Text('✓ Better performance'),
          ],
        ),
      ),
    );
  }
}
