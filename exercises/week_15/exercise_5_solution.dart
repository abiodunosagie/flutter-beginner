// Week 15, Exercise 5: Error Handling with Either Pattern
// Difficulty: Advanced
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// ============================================================================
// CORE - Either and Failure Types
// ============================================================================

// Either: Represents a value of one of two possible types
// Left = Failure, Right = Success
abstract class Either<L, R> {
  const Either();

  bool get isLeft;
  bool get isRight;

  L get left;
  R get right;

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

class Left<L, R> extends Either<L, R> {
  final L _value;

  const Left(this._value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  L get left => _value;

  @override
  R get right => throw Exception('Cannot get right value from Left');

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(_value);
  }
}

class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right(this._value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  L get left => throw Exception('Cannot get left value from Right');

  @override
  R get right => _value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(_value);
  }
}

// Failure hierarchy
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed'])
      : super(message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(String message, [this.statusCode]) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message);
}

// ============================================================================
// DOMAIN LAYER
// ============================================================================

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

  Todo copyWith({bool? completed}) {
    return Todo(
      id: id,
      title: title,
      description: description,
      completed: completed ?? this.completed,
      createdAt: createdAt,
    );
  }

  @override
  String toString() => 'Todo(id: $id, title: "$title", completed: $completed)';
}

// Repository with Either
abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> getTodoById(String id);
  Future<Either<Failure, Todo>> createTodo(Todo todo);
  Future<Either<Failure, Todo>> updateTodo(Todo todo);
  Future<Either<Failure, void>> deleteTodo(String id);
}

// Use Cases with Either
class GetAllTodos {
  final TodoRepository repository;
  GetAllTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() async {
    return await repository.getTodos();
  }
}

class GetTodoById {
  final TodoRepository repository;
  GetTodoById(this.repository);

  Future<Either<Failure, Todo>> call(String id) async {
    return await repository.getTodoById(id);
  }
}

class CreateTodo {
  final TodoRepository repository;
  CreateTodo(this.repository);

  Future<Either<Failure, Todo>> call({
    required String title,
    required String description,
  }) async {
    // Validation
    if (title.trim().isEmpty) {
      return Left(ValidationFailure('Title cannot be empty'));
    }

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

  Future<Either<Failure, Todo>> call(String id, bool completed) async {
    final result = await repository.getTodoById(id);

    return result.fold(
      (failure) => Left(failure),
      (todo) async {
        final updatedTodo = todo.copyWith(completed: completed);
        return await repository.updateTodo(updatedTodo);
      },
    );
  }
}

// ============================================================================
// DATA LAYER
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

// Data Source with Either
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
    } else if (response.statusCode == 404) {
      throw NotFoundFailure();
    } else {
      throw ServerFailure('Failed to fetch todos', response.statusCode);
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundFailure('Todo with id $id not found');
    } else {
      throw ServerFailure('Failed to fetch todo', response.statusCode);
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
      throw ServerFailure('Failed to create todo', response.statusCode);
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
      throw ServerFailure('Failed to update todo', response.statusCode);
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerFailure('Failed to delete todo', response.statusCode);
    }
  }
}

// Repository Implementation with Either
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todoModels = await remoteDataSource.getTodos();
      return Right(todoModels.cast<Todo>());
    } on SocketException {
      return Left(NetworkFailure());
    } on NotFoundFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String id) async {
    try {
      final todo = await remoteDataSource.getTodoById(id);
      return Right(todo);
    } on SocketException {
      return Left(NetworkFailure());
    } on NotFoundFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Todo>> createTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      final created = await remoteDataSource.createTodo(todoModel);
      return Right(created);
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      final updated = await remoteDataSource.updateTodo(todoModel);
      return Right(updated);
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await remoteDataSource.deleteTodo(id);
      return Right(null);
    } on SocketException {
      return Left(NetworkFailure());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}

// ============================================================================
// PRESENTATION - Result Handler
// ============================================================================

class TodoController {
  final GetAllTodos getAllTodos;
  final GetTodoById getTodoById;
  final CreateTodo createTodo;
  final UpdateTodoStatus updateTodoStatus;

  TodoController({
    required this.getAllTodos,
    required this.getTodoById,
    required this.createTodo,
    required this.updateTodoStatus,
  });

  Future<void> loadTodos() async {
    print('\n📋 Loading todos...');

    final result = await getAllTodos.call();

    result.fold(
      (failure) {
        print('✗ Error: ${failure.message}');
        _handleFailure(failure);
      },
      (todos) {
        print('✓ Loaded ${todos.length} todos');
        for (var todo in todos) {
          print('  ${todo.completed ? "✅" : "⬜"} ${todo.title}');
        }
      },
    );
  }

  Future<void> addTodo(String title, String description) async {
    print('\n➕ Creating todo...');

    final result = await createTodo.call(
      title: title,
      description: description,
    );

    result.fold(
      (failure) {
        print('✗ Error: ${failure.message}');
        _handleFailure(failure);
      },
      (todo) {
        print('✓ Created: ${todo.title}');
      },
    );
  }

  Future<void> toggleStatus(String id) async {
    print('\n🔄 Toggling status...');

    final result = await updateTodoStatus.call(id, true);

    result.fold(
      (failure) {
        print('✗ Error: ${failure.message}');
        _handleFailure(failure);
      },
      (todo) {
        print('✓ Updated: ${todo.title}');
        print('  Status: ${todo.completed ? "Completed" : "Incomplete"}');
      },
    );
  }

  void _handleFailure(Failure failure) {
    if (failure is NetworkFailure) {
      print('💡 Please check your internet connection');
    } else if (failure is NotFoundFailure) {
      print('💡 The requested item was not found');
    } else if (failure is ValidationFailure) {
      print('💡 Please check your input');
    } else if (failure is ServerFailure) {
      print('💡 Server error. Please try again later');
    }
  }
}

// ============================================================================
// MAIN
// ============================================================================

void main() async {
  print('Clean Architecture with Either Pattern');
  print('=' * 70);

  // Setup
  final client = http.Client();
  final dataSource = TodoRemoteDataSourceImpl(client);
  final repository = TodoRepositoryImpl(dataSource);

  final getAllTodos = GetAllTodos(repository);
  final getTodoById = GetTodoById(repository);
  final createTodo = CreateTodo(repository);
  final updateTodoStatus = UpdateTodoStatus(repository);

  final controller = TodoController(
    getAllTodos: getAllTodos,
    getTodoById: getTodoById,
    createTodo: createTodo,
    updateTodoStatus: updateTodoStatus,
  );

  // Test scenarios
  await controller.loadTodos();
  await controller.addTodo('Master Either Pattern', 'Learn functional error handling');
  await controller.toggleStatus('1');

  // Test validation error
  await controller.addTodo('', 'This should fail');

  print('\n' + '=' * 70);
  print('✅ Complete! Error handling with Either pattern working.');
}
