// Exercise 4: Todo List App (Intermediate-Advanced)
// Create a todo list where users can add and remove items

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // TODO: Create List<String> _todos to store todo items

  // TODO: Create TextEditingController _controller

  // TODO: Create method _addTodo() that:
  // - Gets text from _controller
  // - If not empty, adds to _todos list
  // - Clears the _controller

  // TODO: Create method _removeTodo(int index) that removes item at index

  @override
  void dispose() {
    // TODO: Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo List'),
      ),
      body: Column(
        children: [
          // TODO: Create input section with TextField and Add button
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // TODO: Add Expanded TextField with _controller

                // TODO: Add SizedBox width 10

                // TODO: Add ElevatedButton "Add" that calls _addTodo
              ],
            ),
          ),

          Divider(),

          // TODO: Create Expanded ListView.builder to display todos
          // Each item should be a ListTile with:
          // - Title showing the todo text
          // - trailing IconButton (delete icon) that calls _removeTodo
        ],
      ),
    );
  }
}
