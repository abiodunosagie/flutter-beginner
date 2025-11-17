// Week 16, Exercise 2: Dependency Injection Container
// Difficulty: Beginner-Intermediate
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

// ============================================================================
// SERVICE LOCATOR (Dependency Injection Container)
// ============================================================================

class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Storage for dependencies
  final Map<Type, dynamic> _services = {};

  // Register a dependency
  void register<T>(T service) {
    _services[T] = service;
  }

  // Register a factory (creates new instance each time)
  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  // Register a lazy singleton (creates instance on first access)
  void registerLazySingleton<T>(T Function() factory) {
    T? instance;
    _services[T] = () {
      instance ??= factory();
      return instance;
    };
  }

  // Get a dependency
  T get<T>() {
    final service = _services[T];

    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }

    // If it's a factory function, call it
    if (service is Function) {
      return service() as T;
    }

    return service as T;
  }

  // Check if a dependency is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  // Remove a dependency
  void unregister<T>() {
    _services.remove(T);
  }

  // Clear all dependencies
  void reset() {
    _services.clear();
  }
}

// Convenience accessor
final sl = ServiceLocator();

// ============================================================================
// DOMAIN LAYER
// ============================================================================

class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  @override
  String toString() => 'Todo(id: $id, title: "$title", completed: $completed)';
}

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(Todo todo);
}

// Use Cases
class GetAllTodos {
  final TodoRepository repository;
  GetAllTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}

class CreateTodo {
  final TodoRepository repository;
  CreateTodo(this.repository);

  Future<Todo> call(String title) async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      completed: false,
    );
    return await repository.createTodo(todo);
  }
}

// ============================================================================
// DATA LAYER
// ============================================================================

class TodoModel extends Todo {
  TodoModel({
    required String id,
    required String title,
    required bool completed,
  }) : super(id: id, title: title, completed: completed);

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
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
      completed: todo.completed,
    );
  }
}

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> createTodo(TodoModel todo);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  TodoRemoteDataSourceImpl(this.client);

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await client.get(Uri.parse('$baseUrl?_limit=5'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TodoModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch todos');
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
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    final todoModels = await remoteDataSource.getTodos();
    return todoModels.cast<Todo>();
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    final created = await remoteDataSource.createTodo(todoModel);
    return created;
  }
}

// ============================================================================
// DEPENDENCY INJECTION SETUP
// ============================================================================

void setupDependencies() {
  print('🔧 Setting up dependencies...\n');

  // External dependencies
  print('  Registering http.Client...');
  sl.register<http.Client>(http.Client());

  // Data sources
  print('  Registering TodoRemoteDataSource...');
  sl.register<TodoRemoteDataSource>(
    TodoRemoteDataSourceImpl(sl.get<http.Client>()),
  );

  // Repositories
  print('  Registering TodoRepository...');
  sl.register<TodoRepository>(
    TodoRepositoryImpl(sl.get<TodoRemoteDataSource>()),
  );

  // Use cases
  print('  Registering GetAllTodos use case...');
  sl.register<GetAllTodos>(
    GetAllTodos(sl.get<TodoRepository>()),
  );

  print('  Registering CreateTodo use case...');
  sl.register<CreateTodo>(
    CreateTodo(sl.get<TodoRepository>()),
  );

  print('\n✓ All dependencies registered!\n');
}

// Alternative: Setup with lazy singletons
void setupLazyDependencies() {
  print('🔧 Setting up lazy dependencies...\n');

  // These will only be created when first accessed
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(sl.get<http.Client>()),
  );

  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(sl.get<TodoRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetAllTodos>(
    () => GetAllTodos(sl.get<TodoRepository>()),
  );

  sl.registerLazySingleton<CreateTodo>(
    () => CreateTodo(sl.get<TodoRepository>()),
  );

  print('✓ All lazy dependencies registered!\n');
}

// ============================================================================
// PRESENTATION LAYER
// ============================================================================

class TodoController {
  // Get dependencies from service locator
  late final GetAllTodos getAllTodos;
  late final CreateTodo createTodo;

  TodoController() {
    print('📱 TodoController: Getting dependencies from service locator...');
    getAllTodos = sl.get<GetAllTodos>();
    createTodo = sl.get<CreateTodo>();
    print('✓ Dependencies injected!\n');
  }

  Future<void> loadTodos() async {
    print('📋 Loading todos...');
    try {
      final todos = await getAllTodos.call();
      print('✓ Loaded ${todos.length} todos:');
      for (var todo in todos) {
        print('  ${todo.completed ? "✅" : "⬜"} ${todo.title}');
      }
    } catch (e) {
      print('✗ Error: $e');
    }
  }

  Future<void> addTodo(String title) async {
    print('\n➕ Creating todo: "$title"');
    try {
      final todo = await createTodo.call(title);
      print('✓ Created: ${todo.title}');
    } catch (e) {
      print('✗ Error: $e');
    }
  }
}

// ============================================================================
// MAIN
// ============================================================================

void main() async {
  print('Dependency Injection with Service Locator');
  print('=' * 70);

  // Setup all dependencies
  setupDependencies();

  print('Testing dependency injection...\n');
  print('=' * 70);

  // Create controller (it will get dependencies from service locator)
  final controller = TodoController();

  // Test 1: Load todos
  print('Test 1: Load Todos');
  print('-' * 70);
  await controller.loadTodos();

  // Test 2: Create todo
  print('\nTest 2: Create Todo');
  print('-' * 70);
  await controller.addTodo('Learn Dependency Injection');

  // Test 3: Verify we can get dependencies anywhere
  print('\nTest 3: Direct Access to Dependencies');
  print('-' * 70);
  print('Getting repository directly from service locator...');
  final repository = sl.get<TodoRepository>();
  final todos = await repository.getTodos();
  print('✓ Got ${todos.length} todos directly from repository');

  // Test 4: Check registration status
  print('\nTest 4: Check Registration Status');
  print('-' * 70);
  print('TodoRepository registered? ${sl.isRegistered<TodoRepository>()}');
  print('GetAllTodos registered? ${sl.isRegistered<GetAllTodos>()}');
  print('SomeOtherClass registered? ${sl.isRegistered<String>()}');

  print('\n' + '=' * 70);
  print('✅ Dependency Injection working correctly!');
  print('\nBenefits:');
  print('  • Centralized dependency management');
  print('  • Easy to swap implementations');
  print('  • Better testability');
  print('  • Loose coupling between layers');
}
