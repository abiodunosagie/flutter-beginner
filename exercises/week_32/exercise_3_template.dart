/// Week 32, Exercise 3: BLoC with Complex Events
///
/// INTERMEDIATE LEVEL
///
/// Implement BLoC pattern with multiple events:
/// 1. Create TodoBloc with multiple events
/// 2. Handle different event types
/// 3. Emit appropriate states
/// 4. Use BlocBuilder in UI
///
/// Learning objectives:
/// - BLoC pattern
/// - Event handling
/// - State transitions

import 'package:flutter/material.dart';

void main() {
  runApp(TodoBlocApp());
}

// TODO: Implement TodoBloc with events and states
// Events: LoadTodos, AddTodo, ToggleTodo, DeleteTodo
// States: TodoInitial, TodoLoading, TodoLoaded, TodoError

class TodoBlocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Todo',
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLoC Todos')),
      body: Center(child: Text('Implement BLoC pattern')),
    );
  }
}
