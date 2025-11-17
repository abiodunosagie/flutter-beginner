// Week 15, Exercise 3: Repository Implementation
// Difficulty: Intermediate
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

// ============================================================================
// DOMAIN LAYER
// ============================================================================

// Entity
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

// Repository Interface (Contract)
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodoById(String id);
  Future<Todo> createTodo(Todo todo);
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}

// ============================================================================
// DATA LAYER
// ============================================================================

// Model
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

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['title'] ?? '',
      completed: json['completed'] ?? false,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'userId': 1,
    };
  }

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

// Data Source Interface
abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> createTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

// Data Source Implementation
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
      throw Exception('Failed to fetch todos');
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch todo');
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
      throw Exception('Failed to create todo');
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
      throw Exception('Failed to update todo');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }
}

// ============================================================================
// REPOSITORY IMPLEMENTATION (Bridges Domain and Data)
// ============================================================================

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    try {
      // Fetch from data source (returns TodoModel)
      final List<TodoModel> todoModels = await remoteDataSource.getTodos();

      // Convert TodoModel to Todo (data layer to domain layer)
      return todoModels.cast<Todo>();
    } catch (e) {
      throw Exception('Repository: Failed to get todos - $e');
    }
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    try {
      final TodoModel todoModel = await remoteDataSource.getTodoById(id);
      return todoModel; // TodoModel extends Todo
    } catch (e) {
      throw Exception('Repository: Failed to get todo - $e');
    }
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    try {
      // Convert Todo to TodoModel (domain to data)
      final TodoModel todoModel = TodoModel.fromEntity(todo);

      // Create via data source
      final TodoModel created = await remoteDataSource.createTodo(todoModel);

      return created;
    } catch (e) {
      throw Exception('Repository: Failed to create todo - $e');
    }
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    try {
      final TodoModel todoModel = TodoModel.fromEntity(todo);
      final TodoModel updated = await remoteDataSource.updateTodo(todoModel);
      return updated;
    } catch (e) {
      throw Exception('Repository: Failed to update todo - $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await remoteDataSource.deleteTodo(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete todo - $e');
    }
  }
}

// ============================================================================
// TESTING
// ============================================================================

void main() async {
  print('Testing Repository Implementation');
  print('=' * 70);

  // Setup: Create dependencies
  final client = http.Client();
  final dataSource = TodoRemoteDataSourceImpl(client);
  final repository = TodoRepositoryImpl(dataSource);

  // Test 1: Get all todos
  print('\n1. Get All Todos (via Repository)');
  print('-' * 70);
  try {
    List<Todo> todos = await repository.getTodos();
    print('✓ Retrieved ${todos.length} todos:');
    for (int i = 0; i < 5 && i < todos.length; i++) {
      print('  ${i + 1}. ${todos[i].completed ? "✓" : "○"} ${todos[i].title}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 2: Get specific todo
  print('\n2. Get Todo by ID (via Repository)');
  print('-' * 70);
  try {
    Todo? todo = await repository.getTodoById('5');
    if (todo != null) {
      print('✓ Found: ${todo.title}');
      print('  ID: ${todo.id}');
      print('  Completed: ${todo.completed}');
    }
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 3: Create todo
  print('\n3. Create Todo (via Repository)');
  print('-' * 70);
  try {
    Todo newTodo = Todo(
      id: '0', // Will be assigned by server
      title: 'Master Clean Architecture',
      description: 'Understand all layers and their responsibilities',
      completed: false,
      createdAt: DateTime.now(),
    );

    Todo created = await repository.createTodo(newTodo);
    print('✓ Created todo:');
    print('  ID: ${created.id}');
    print('  Title: ${created.title}');
  } catch (e) {
    print('✗ Error: $e');
  }

  // Test 4: Update todo
  print('\n4. Update Todo (via Repository)');
  print('-' * 70);
  try {
    Todo updatedTodo = Todo(
      id: '1',
      title: 'Updated: Learn Clean Architecture',
      description: 'Completed learning',
      completed: true,
      createdAt: DateTime.now(),
    );

    Todo updated = await repository.updateTodo(updatedTodo);
    print('✓ Updated todo:');
    print('  ID: ${updated.id}');
    print('  Title: ${updated.title}');
    print('  Completed: ${updated.completed}');
  } catch (e) {
    print('✗ Error: $e');
  }

  print('\n' + '=' * 70);
  print('Repository successfully bridges Domain and Data layers!');
}
