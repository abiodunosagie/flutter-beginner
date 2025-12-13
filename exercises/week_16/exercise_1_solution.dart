// Week 16, Exercise 1: Caching Strategy - Remote and Local Data Sources
// Difficulty: Beginner
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Future<List<Todo>> getTodos({bool forceRefresh = false});
  Future<Todo> createTodo(Todo todo);
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

// LOCAL DATA SOURCE (Cache)
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<void> cacheTodo(TodoModel todo);
  Future<void> clearCache();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  List<TodoModel> _cache = [];
  DateTime? _lastCacheTime;
  final Duration cacheValidity = Duration(minutes: 5);

  @override
  Future<List<TodoModel>> getCachedTodos() async {
    print('  📦 Reading from cache...');

    // Check if cache is still valid
    if (_lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < cacheValidity) {
      print('  ✓ Cache hit! Returning ${_cache.length} todos from cache');
      return _cache;
    } else {
      if (_lastCacheTime != null) {
        print('  ⚠ Cache expired');
      } else {
        print('  ⚠ Cache empty');
      }
      return [];
    }
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    print('  💾 Caching ${todos.length} todos...');
    _cache = todos;
    _lastCacheTime = DateTime.now();
    print('  ✓ Cache updated');
  }

  @override
  Future<void> cacheTodo(TodoModel todo) async {
    print('  💾 Caching single todo...');
    _cache.add(todo);
    _lastCacheTime = DateTime.now();
    print('  ✓ Todo cached');
  }

  @override
  Future<void> clearCache() async {
    print('  🗑️  Clearing cache...');
    _cache.clear();
    _lastCacheTime = null;
    print('  ✓ Cache cleared');
  }
}

// REMOTE DATA SOURCE (API)
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
    print('  🌐 Fetching from API...');
    final response = await client.get(Uri.parse('$baseUrl?_limit=5'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final todos = jsonList.map((json) => TodoModel.fromJson(json)).toList();
      print('  ✓ Fetched ${todos.length} todos from API');
      return todos;
    } else {
      throw Exception('Failed to fetch todos');
    }
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    print('  🌐 Creating todo via API...');
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      print('  ✓ Todo created via API');
      return TodoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create todo');
    }
  }
}

// REPOSITORY WITH CACHING
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Todo>> getTodos({bool forceRefresh = false}) async {
    print('\n📋 Repository: Getting todos (forceRefresh: $forceRefresh)');

    // If force refresh, skip cache
    if (!forceRefresh) {
      // Try cache first
      final cachedTodos = await localDataSource.getCachedTodos();
      if (cachedTodos.isNotEmpty) {
        return cachedTodos.cast<Todo>();
      }
    }

    // Cache miss or force refresh - fetch from remote
    final remoteTodos = await remoteDataSource.getTodos();

    // Update cache
    await localDataSource.cacheTodos(remoteTodos);

    return remoteTodos.cast<Todo>();
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    print('\n➕ Repository: Creating todo');

    final todoModel = TodoModel.fromEntity(todo);

    // Create via remote
    final created = await remoteDataSource.createTodo(todoModel);

    // Update cache
    await localDataSource.cacheTodo(created);

    return created;
  }
}

// ============================================================================
// TESTING
// ============================================================================

void main() async {
  print('Testing Caching Strategy');
  print('=' * 70);

  // Setup
  final client = http.Client();
  final remoteDataSource = TodoRemoteDataSourceImpl(client);
  final localDataSource = TodoLocalDataSourceImpl();
  final repository = TodoRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // Test 1: First fetch (cache miss, will fetch from API)
  print('\n1️⃣ First Fetch - Cache Miss');
  print('-' * 70);
  List<Todo> todos = await repository.getTodos();
  print('Result: Got ${todos.length} todos');
  print('First todo: ${todos[0].title}');

  // Test 2: Second fetch (cache hit, will use cache)
  print('\n2️⃣ Second Fetch - Cache Hit');
  print('-' * 70);
  todos = await repository.getTodos();
  print('Result: Got ${todos.length} todos');
  print('First todo: ${todos[0].title}');

  // Test 3: Force refresh (will skip cache and fetch from API)
  print('\n3️⃣ Third Fetch - Force Refresh');
  print('-' * 70);
  todos = await repository.getTodos(forceRefresh: true);
  print('Result: Got ${todos.length} todos');
  print('First todo: ${todos[0].title}');

  // Test 4: Create new todo (will update cache)
  print('\n4️⃣ Create New Todo - Cache Update');
  print('-' * 70);
  Todo newTodo = Todo(
    id: '999',
    title: 'Learn Caching Strategies',
    completed: false,
  );
  Todo created = await repository.createTodo(newTodo);
  print('Result: Created "${created.title}"');

  // Test 5: Fetch again (should include new todo from cache)
  print('\n5️⃣ Fifth Fetch - Verify Cache Update');
  print('-' * 70);
  todos = await repository.getTodos();
  print('Result: Got ${todos.length} todos');
  print('Last todo: ${todos.last.title}');

  // Test 6: Clear cache
  print('\n6️⃣ Clear Cache');
  print('-' * 70);
  await localDataSource.clearCache();

  // Test 7: Fetch after clearing cache (cache miss)
  print('\n7️⃣ Fetch After Clear - Cache Miss');
  print('-' * 70);
  todos = await repository.getTodos();
  print('Result: Got ${todos.length} todos');

  print('\n' + '=' * 70);
  print('✅ Caching strategy working correctly!');
  print('Benefits: Faster loading, reduced API calls, offline capability');
}
