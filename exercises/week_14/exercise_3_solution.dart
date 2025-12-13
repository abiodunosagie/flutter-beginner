// Week 14, Exercise 3: POST Request - Creating Data
// Difficulty: Intermediate
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

class Todo {
  final int? id; // Nullable because it's assigned by server
  final int userId;
  final String title;
  final bool completed;

  Todo({
    this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'userId': userId,
      'title': title,
      'completed': completed,
    };

    // Only include id if it exists
    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  @override
  String toString() {
    return 'Todo(id: $id, userId: $userId, title: "$title", completed: $completed)';
  }
}

Future<Todo?> createTodo(Todo todo) async {
  try {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      print('Success! Todo created (Status: ${response.statusCode})');
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      print('Error: Failed to create todo (Status: ${response.statusCode})');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

void main() async {
  print('Creating Todos...\n');
  print('=' * 60);

  // Create first todo
  print('\n1. Creating first todo...');
  Todo todo1 = Todo(
    userId: 1,
    title: 'Learn Flutter HTTP requests',
    completed: false,
  );

  print('Sending: $todo1');
  Todo? createdTodo1 = await createTodo(todo1);
  if (createdTodo1 != null) {
    print('Received: $createdTodo1');
  }

  print('\n' + '-' * 60);

  // Create second todo
  print('\n2. Creating second todo...');
  Todo todo2 = Todo(
    userId: 1,
    title: 'Build a REST API client',
    completed: true,
  );

  print('Sending: $todo2');
  Todo? createdTodo2 = await createTodo(todo2);
  if (createdTodo2 != null) {
    print('Received: $createdTodo2');
  }

  print('\n' + '=' * 60);
  print('\nAll todos created successfully!');
}
