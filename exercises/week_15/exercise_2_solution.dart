// Week 15, Exercise 2: Data Layer - Models and Data Source
// Difficulty: Beginner-Intermediate
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

// DOMAIN LAYER - Entity
class Todo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Todo(id: $id, title: "$title", completed: $completed)';
  }
}

// DATA LAYER - Model (extends Entity, adds JSON serialization)
class TodoModel extends Todo {
  TodoModel({
    required String id,
    required String title,
    required String description,
    required bool completed,
    required DateTime createdAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          completed: completed,
          createdAt: createdAt,
        );

  // From JSON (API response)
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['title'] ?? '', // JSONPlaceholder doesn't have description
      completed: json['completed'] ?? false,
      createdAt: DateTime.now(), // JSONPlaceholder doesn't provide this
    );
  }

  // To JSON (API request)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'userId': 1, // Required by JSONPlaceholder
    };
  }

  // From Entity (Domain to Data)
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      createdAt: todo.createdAt,
    );
  }
}

// DATA SOURCE Interface
abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> createTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

// DATA SOURCE Implementation
class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  TodoRemoteDataSourceImpl(this.client);

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await client.get(Uri.parse('$baseUrl?_limit=10'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TodoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch todos: ${response.statusCode}');
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch todo: ${response.statusCode}');
    }
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create todo: ${response.statusCode}');
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update todo: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo: ${response.statusCode}');
    }
  }
}

void main() async {
  print('Testing Data Layer - Remote Data Source');
  print('=' * 60);

  final dataSource = TodoRemoteDataSourceImpl(http.Client());

  // Test 1: Get all todos
  print('\n1. Fetching todos from API...');
  try {
    List<TodoModel> todos = await dataSource.getTodos();
    print('✓ Fetched ${todos.length} todos:');
    for (int i = 0; i < 3 && i < todos.length; i++) {
      print('  ${todos[i].completed ? "✓" : "○"} ${todos[i].title}');
    }
    print('  ... and ${todos.length - 3} more');
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 2: Get specific todo
  print('\n2. Fetching todo by ID (1)...');
  try {
    TodoModel todo = await dataSource.getTodoById('1');
    print('✓ Found: ${todo.title}');
    print('  Completed: ${todo.completed}');
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 3: Create new todo
  print('\n3. Creating new todo...');
  try {
    TodoModel newTodo = TodoModel(
      id: '0',
      title: 'Test Clean Architecture',
      description: 'Learn data layer patterns',
      completed: false,
      createdAt: DateTime.now(),
    );

    TodoModel created = await dataSource.createTodo(newTodo);
    print('✓ Created todo with ID: ${created.id}');
    print('  Title: ${created.title}');
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 4: Update todo
  print('\n4. Updating todo...');
  try {
    TodoModel updatedTodo = TodoModel(
      id: '1',
      title: 'Updated Todo Title',
      description: 'Updated description',
      completed: true,
      createdAt: DateTime.now(),
    );

    TodoModel updated = await dataSource.updateTodo(updatedTodo);
    print('✓ Updated todo ${updated.id}');
    print('  New title: ${updated.title}');
    print('  Completed: ${updated.completed}');
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 5: Delete todo
  print('\n5. Deleting todo...');
  try {
    await dataSource.deleteTodo('1');
    print('✓ Deleted todo 1');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n' + '=' * 60);
  print('Data layer testing complete!');
}
