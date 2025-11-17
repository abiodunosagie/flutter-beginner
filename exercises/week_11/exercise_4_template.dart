// Week 11, Exercise 4: Counter with Bloc Pattern
// Difficulty: Intermediate-Advanced
//
// Instructions:
// 1. Create CounterEvent abstract class with Increment, Decrement, and Reset events
// 2. Create CounterState class using Equatable
// 3. Create CounterBloc extending Bloc<CounterEvent, CounterState>
// 4. Implement event handlers for each event
// 5. Use BlocProvider to provide the bloc
// 6. Use BlocBuilder to build UI
// 7. Use BlocListener to show a snackbar when count reaches 10
//
// Learning objectives:
// - Understanding Bloc pattern
// - Events and states
// - BlocProvider, BlocBuilder, BlocListener
// - Equatable for state comparison
//
// TODO: Import necessary packages
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

void main() {
  runApp(MyApp());
}

// TODO: Create CounterEvent abstract class
abstract class CounterEvent {}

// TODO: Create concrete event classes
// - IncrementPressed
// - DecrementPressed
// - ResetPressed

// TODO: Create CounterState class extending Equatable
class CounterState extends Equatable {
  // Field: count
  // Constructor
  // Override props for Equatable

  @override
  List<Object> get props => [];
}

// TODO: Create CounterBloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // Initialize with CounterState(0)
  // Register event handlers using on<Event>()
  // TODO: Implement _onIncrement, _onDecrement, _onReset
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Counter',
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Use BlocListener to show snackbar when count == 10
    // TODO: Use BlocBuilder to rebuild UI
    // TODO: Add buttons to trigger events

    return Scaffold(
      appBar: AppBar(title: Text('Bloc Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter Value:'),
            // TODO: Display counter
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Add buttons
              ],
            ),
          ],
        ),
      ),
    );
  }
}
