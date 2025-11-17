/// Week 32, Exercise 1: Riverpod with State Persistence
///
/// BEGINNER LEVEL
///
/// Create a counter app with Riverpod that persists state:
/// 1. Add flutter_riverpod and shared_preferences packages
/// 2. Create StateNotifier for counter
/// 3. Save counter value to SharedPreferences
/// 4. Load saved value on app start
///
/// Learning objectives:
/// - Riverpod basics
/// - State persistence
/// - SharedPreferences integration

import 'package:flutter/material.dart';
// TODO: Add flutter_riverpod package

void main() {
  runApp(
    // TODO: Wrap with ProviderScope
    CounterApp(),
  );
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Counter',
      home: CounterScreen(),
    );
  }
}

// TODO: Create CounterNotifier extending StateNotifier<int>
// TODO: Create provider

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Use riverpod hooks to access state
    
    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Display counter value
            // TODO: Add increment button
          ],
        ),
      ),
    );
  }
}
