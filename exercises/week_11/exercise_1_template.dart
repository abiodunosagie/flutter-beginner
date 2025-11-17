// Week 11, Exercise 1: Simple Counter with Riverpod StateProvider
// Difficulty: Beginner
//
// Instructions:
// 1. Set up a Riverpod StateProvider for a counter
// 2. Create a ConsumerWidget that displays the counter value
// 3. Add increment and decrement buttons
// 4. Add a reset button
//
// Learning objectives:
// - Understanding Riverpod StateProvider
// - Using ConsumerWidget
// - Using ref.watch() and ref.read()
//
// TODO: Import necessary packages
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // TODO: Wrap your app with ProviderScope
  runApp(MyApp());
}

// TODO: Create a StateProvider for the counter
// Hint: final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter with Riverpod',
      home: CounterScreen(),
    );
  }
}

// TODO: Convert this to a ConsumerWidget
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Watch the counter provider
    // TODO: Display the counter value
    // TODO: Add buttons to increment, decrement, and reset

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter Value:'),
            // TODO: Display counter here
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Add decrement button
                SizedBox(width: 20),
                // TODO: Add reset button
                SizedBox(width: 20),
                // TODO: Add increment button
              ],
            ),
          ],
        ),
      ),
    );
  }
}
