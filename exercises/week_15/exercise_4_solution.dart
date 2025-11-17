// Week 15, Exercise 4: Use Cases and Complete Flow
// Difficulty: Intermediate-Advanced
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

// ============================================================================
// DOMAIN LAYER - Business Logic
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

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'Todo(id: $id, title: "$title", completed: $completed)';
}

// Repository Interface
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodoById(String id);
  Future<Todo> createTodo(Todo todo);
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}

// USE CASES - Single responsibility operations

class GetAllTodos {
  final TodoRepository repository;
  GetAllTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}

class GetTodoById {
  final TodoRepository repository;
  GetTodoById(this.repository);

  Future<Todo?> call(String id) async {
    return await repository.getTodoById(id);
  }
}

class CreateTodo {
  final TodoRepository repository;
  CreateTodo(this.repository);

  Future<Todo> call({
    required String title,
    required String description,
  }) async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      completed: false,
      createdAt: DateTime.now(),
    );

    return await repository.createTodo(todo);
  }
}

class UpdateTodoStatus {
  final TodoRepository repository;
  UpdateTodoStatus(this.repository);

  Future<Todo> call(String id, bool completed) async {
    final todo = await repository.getTodoById(id);
    if (todo == null) {
      throw Exception('Todo not found');
    }

    final updatedTodo = todo.copyWith(completed: completed);
    return await repository.updateTodo(updatedTodo);
  }
}

class DeleteTodo {
  final TodoRepository repository;
  DeleteTodo(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTodo(id);
  }
}

// ============================================================================
// DATA LAYER - External Data
// ============================================================================

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

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> createTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

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
    }
    throw Exception('Failed to fetch todos');
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to fetch todo');
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
    }
    throw Exception('Failed to create todo');
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
    }
    throw Exception('Failed to update todo');
  }

  @override
  Future<void> deleteTodo(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }
}

// Repository Implementation
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    final todoModels = await remoteDataSource.getTodos();
    return todoModels.cast<Todo>();
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    return await remoteDataSource.getTodoById(id);
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    return await remoteDataSource.createTodo(todoModel);
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    return await remoteDataSource.updateTodo(todoModel);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await remoteDataSource.deleteTodo(id);
  }
}

// ============================================================================
// PRESENTATION LAYER - Controller (Uses Use Cases)
// ============================================================================

class TodoController {
  final GetAllTodos getAllTodos;
  final GetTodoById getTodoById;
  final CreateTodo createTodo;
  final UpdateTodoStatus updateTodoStatus;
  final DeleteTodo deleteTodo;

  TodoController({
    required this.getAllTodos,
    required this.getTodoById,
    required this.createTodo,
    required this.updateTodoStatus,
    required this.deleteTodo,
  });

  // High-level operations for UI
  Future<void> loadTodos() async {
    print('\n📋 Loading todos...');
    try {
      final todos = await getAllTodos.call();
      print('✓ Loaded ${todos.length} todos');
      _displayTodos(todos);
    } catch (e) {
      print('✗ Error loading todos: $e');
    }
  }

  Future<void> loadTodoDetails(String id) async {
    print('\n🔍 Loading todo details...');
    try {
      final todo = await getTodoById.call(id);
      if (todo != null) {
        print('✓ Found: ${todo.title}');
        print('  ID: ${todo.id}');
        print('  Description: ${todo.description}');
        print('  Completed: ${todo.completed}');
      }
    } catch (e) {
      print('✗ Error loading todo: $e');
    }
  }

  Future<void> addNewTodo(String title, String description) async {
    print('\n➕ Creating new todo...');
    try {
      final todo = await createTodo.call(
        title: title,
        description: description,
      );
      print('✓ Created: ${todo.title}');
    } catch (e) {
      print('✗ Error creating todo: $e');
    }
  }

  Future<void> toggleTodoStatus(String id) async {
    print('\n🔄 Toggling todo status...');
    try {
      final todo = await getTodoById.call(id);
      if (todo != null) {
        final updated = await updateTodoStatus.call(id, !todo.completed);
        print('✓ Updated: ${updated.title}');
        print('  New status: ${updated.completed ? "Completed" : "Incomplete"}');
      }
    } catch (e) {
      print('✗ Error updating todo: $e');
    }
  }

  Future<void> removeTodo(String id) async {
    print('\n🗑️  Deleting todo...');
    try {
      await deleteTodo.call(id);
      print('✓ Deleted todo $id');
    } catch (e) {
      print('✗ Error deleting todo: $e');
    }
  }

  void _displayTodos(List<Todo> todos) {
    print('\nTodos:');
    for (var todo in todos) {
      print('  ${todo.completed ? "✅" : "⬜"} ${todo.title}');
    }
  }
}

// ============================================================================
// MAIN - Setup and Testing
// ============================================================================

void main() async {
  print('Clean Architecture - Complete Flow Demo');
  print('=' * 70);

  // Setup dependencies (Dependency Injection)
  final client = http.Client();
  final dataSource = TodoRemoteDataSourceImpl(client);
  final repository = TodoRepositoryImpl(dataSource);

  // Create use cases
  final getAllTodos = GetAllTodos(repository);
  final getTodoById = GetTodoById(repository);
  final createTodo = CreateTodo(repository);
  final updateTodoStatus = UpdateTodoStatus(repository);
  final deleteTodo = DeleteTodo(repository);

  // Create controller
  final controller = TodoController(
    getAllTodos: getAllTodos,
    getTodoById: getTodoById,
    createTodo: createTodo,
    updateTodoStatus: updateTodoStatus,
    deleteTodo: deleteTodo,
  );

  // Test scenarios
  print('\n🎬 Scenario: User opens the app');
  await controller.loadTodos();

  print('\n🎬 Scenario: User views todo details');
  await controller.loadTodoDetails('3');

  print('\n🎬 Scenario: User creates a new todo');
  await controller.addNewTodo(
    'Master Clean Architecture',
    'Understand all layers and their interactions',
  );

  print('\n🎬 Scenario: User marks todo as complete');
  await controller.toggleTodoStatus('1');

  print('\n' + '=' * 70);
  print('\n✅ Clean Architecture Demo Complete!');
  print('All layers working together successfully.');
}
