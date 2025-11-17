/// Week 32, Exercise 2: AsyncNotifier Pattern
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Implement async data fetching with Riverpod:
/// 1. Create AsyncNotifier for API calls
/// 2. Handle loading/error/data states
/// 3. Implement refresh functionality
/// 4. Show appropriate UI for each state
///
/// Learning objectives:
/// - AsyncNotifier usage
/// - Async state management
/// - Error handling

import 'package:flutter/material.dart';

void main() {
  runApp(AsyncApp());
}

// TODO: Implement AsyncNotifier for fetching data
// TODO: Create provider for async data
// TODO: Use ConsumerWidget to display data

class AsyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Data',
      home: DataScreen(),
    );
  }
}

class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Async Data')),
      body: Center(child: Text('Implement async pattern')),
    );
  }
}
