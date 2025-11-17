// Week 16, Exercise 5: Complete Production App Architecture
// Difficulty: Advanced
// Solution
//
// This is a comprehensive example combining ALL patterns learned:
// - Clean Architecture
// - Either pattern
// - Caching
// - Dependency Injection
// - Pagination
// - Error handling
// - Retry logic
// - Logging

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// ============================================================================
// CORE - Either & Failure
// ============================================================================

abstract class Either<L, R> {
  bool get isLeft;
  bool get isRight;
  T fold<T>(T Function(L) onLeft, T Function(R) onRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  Left(this.value);

  @override
  bool get isLeft => true;
  @override
  bool get isRight => false;

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  Right(this.value);

  @override
  bool get isLeft => false;
  @override
  bool get isRight => true;

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onRight(value);
}

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error']) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

// ============================================================================
// LOGGING
// ============================================================================

enum LogLevel { debug, info, warning, error }

class Logger {
  final String name;
  bool enabled;

  Logger(this.name, {this.enabled = true});

  void log(LogLevel level, String message) {
    if (!enabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();
    final emoji = _getEmoji(level);

    print('[$timestamp] $emoji [$levelStr] [$name] $message');
  }

  void debug(String message) => log(LogLevel.debug, message);
  void info(String message) => log(LogLevel.info, message);
  void warning(String message) => log(LogLevel.warning, message);
  void error(String message) => log(LogLevel.error, message);

  String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
}

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

  Todo copyWith({String? id, String? title, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() => 'Todo(id: $id, title: "$title", completed: $completed)';
}

class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int totalItems;
  final bool hasMore;

  PaginatedResult({
    required this.items,
    required this.page,
    required this.totalItems,
    required this.hasMore,
  });
}

abstract class TodoRepository {
  Future<Either<Failure, PaginatedResult<Todo>>> getTodos({
    required int page,
    required int limit,
    bool forceRefresh = false,
  });
  Future<Either<Failure, Todo>> createTodo(String title);
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
    return {'id': id, 'title': title, 'completed': completed, 'userId': 1};
  }
}

// Remote Data Source with retry logic
class TodoRemoteDataSource {
  final http.Client client;
  final Logger logger;
  final int maxRetries;

  TodoRemoteDataSource({
    required this.client,
    required this.logger,
    this.maxRetries = 3,
  });

  Future<List<TodoModel>> getTodos({
    required int page,
    required int limit,
  }) async {
    return _executeWithRetry(() async {
      final start = (page - 1) * limit;
      final url = 'https://jsonplaceholder.typicode.com/todos?_start=$start&_limit=$limit';

      logger.debug('GET $url');
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        logger.info('Fetched ${json.length} todos');
        return json.map((j) => TodoModel.fromJson(j)).toList();
      } else {
        throw ServerFailure('Status: ${response.statusCode}');
      }
    });
  }

  Future<TodoModel> createTodo(TodoModel todo) async {
    return _executeWithRetry(() async {
      logger.debug('POST todo: ${todo.title}');
      final response = await client.post(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );

      if (response.statusCode == 201) {
        logger.info('Todo created');
        return TodoModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerFailure('Status: ${response.statusCode}');
      }
    });
  }

  Future<T> _executeWithRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        attempts++;
        return await operation();
      } on SocketException catch (e) {
        logger.warning('Network error (attempt $attempts/$maxRetries)');
        if (attempts >= maxRetries) throw NetworkFailure(e.toString());
        await Future.delayed(Duration(seconds: 1 << (attempts - 1)));
      } catch (e) {
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 1 << (attempts - 1)));
      }
    }

    throw Exception('Max retries exceeded');
  }
}

// Local Data Source with caching
class TodoLocalDataSource {
  final Logger logger;
  final Map<int, List<TodoModel>> _cache = {};
  final Map<int, DateTime> _cacheTimestamps = {};
  final Duration cacheValidity = Duration(minutes: 5);

  TodoLocalDataSource(this.logger);

  List<TodoModel>? getCachedPage(int page) {
    final timestamp = _cacheTimestamps[page];
    if (timestamp != null &&
        DateTime.now().difference(timestamp) < cacheValidity) {
      logger.debug('Cache HIT for page $page');
      return _cache[page];
    }

    logger.debug('Cache MISS for page $page');
    return null;
  }

  void cachePage(int page, List<TodoModel> todos) {
    _cache[page] = todos;
    _cacheTimestamps[page] = DateTime.now();
    logger.debug('Cached page $page (${todos.length} items)');
  }

  void invalidateCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    logger.info('Cache invalidated');
  }
}

// Repository Implementation
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remote;
  final TodoLocalDataSource local;
  final Logger logger;

  TodoRepositoryImpl({
    required this.remote,
    required this.local,
    required this.logger,
  });

  @override
  Future<Either<Failure, PaginatedResult<Todo>>> getTodos({
    required int page,
    required int limit,
    bool forceRefresh = false,
  }) async {
    try {
      logger.info('Getting todos (page: $page, limit: $limit, refresh: $forceRefresh)');

      // Check cache unless force refresh
      if (!forceRefresh) {
        final cached = local.getCachedPage(page);
        if (cached != null) {
          return Right(_buildResult(cached.cast<Todo>(), page, limit));
        }
      }

      // Fetch from remote
      final todos = await remote.getTodos(page: page, limit: limit);

      // Cache result
      local.cachePage(page, todos);

      return Right(_buildResult(todos.cast<Todo>(), page, limit));
    } on NetworkFailure catch (e) {
      logger.error('Network failure: ${e.message}');
      return Left(e);
    } on ServerFailure catch (e) {
      logger.error('Server failure: ${e.message}');
      return Left(e);
    } catch (e) {
      logger.error('Unknown error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> createTodo(String title) async {
    try {
      logger.info('Creating todo: $title');

      final model = TodoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        completed: false,
      );

      final created = await remote.createTodo(model);

      // Invalidate cache since data changed
      local.invalidateCache();

      return Right(created);
    } on NetworkFailure catch (e) {
      logger.error('Network failure: ${e.message}');
      return Left(e);
    } catch (e) {
      logger.error('Error creating todo: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  PaginatedResult<Todo> _buildResult(
    List<Todo> items,
    int page,
    int limit,
  ) {
    return PaginatedResult(
      items: items,
      page: page,
      totalItems: 200, // JSONPlaceholder has 200 todos
      hasMore: page * limit < 200,
    );
  }
}

// ============================================================================
// DEPENDENCY INJECTION
// ============================================================================

class ServiceLocator {
  static final _instance = ServiceLocator._();
  factory ServiceLocator() => _instance;
  ServiceLocator._();

  final _services = <Type, dynamic>{};

  void register<T>(T service) => _services[T] = service;

  T get<T>() {
    final service = _services[T];
    if (service == null) throw Exception('$T not registered');
    return service as T;
  }

  void reset() => _services.clear();
}

final sl = ServiceLocator();

void setupDependencies() {
  sl.register<Logger>(Logger('App', enabled: true));
  sl.register<http.Client>(http.Client());
  sl.register<TodoRemoteDataSource>(
    TodoRemoteDataSource(
      client: sl.get(),
      logger: Logger('Remote'),
    ),
  );
  sl.register<TodoLocalDataSource>(TodoLocalDataSource(Logger('Cache')));
  sl.register<TodoRepository>(
    TodoRepositoryImpl(
      remote: sl.get(),
      local: sl.get(),
      logger: Logger('Repository'),
    ),
  );
}

// ============================================================================
// PRESENTATION LAYER
// ============================================================================

class TodoController {
  final TodoRepository repository;
  final Logger logger;

  final List<Todo> todos = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;

  TodoController({required this.repository})
      : logger = Logger('Controller');

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    currentPage++;

    logger.info('Loading page $currentPage...');

    final result = await repository.getTodos(page: currentPage, limit: 10);

    result.fold(
      (failure) {
        logger.error('Failed to load: ${failure.message}');
        currentPage--;
      },
      (paginated) {
        todos.addAll(paginated.items);
        hasMore = paginated.hasMore;
        logger.info('Loaded ${paginated.items.length} todos');
      },
    );

    isLoading = false;
  }

  Future<void> createTodo(String title) async {
    logger.info('Creating todo: $title');

    final result = await repository.createTodo(title);

    result.fold(
      (failure) => logger.error('Failed to create: ${failure.message}'),
      (todo) {
        todos.insert(0, todo);
        logger.info('Todo created successfully');
      },
    );
  }

  Future<void> refresh() async {
    logger.info('Refreshing...');
    currentPage = 0;
    todos.clear();
    hasMore = true;
    await loadMore();
  }

  void displayTodos() {
    print('\n📋 Todos (${todos.length} loaded, hasMore: $hasMore):');
    for (int i = 0; i < todos.length.clamp(0, 10); i++) {
      print('  ${i + 1}. ${todos[i].completed ? "✅" : "⬜"} ${todos[i].title}');
    }
    if (todos.length > 10) {
      print('  ... and ${todos.length - 10} more');
    }
  }
}

// ============================================================================
// MAIN
// ============================================================================

void main() async {
  print('Complete Production App Architecture');
  print('=' * 70);
  print('Combining: Clean Architecture, Either, Caching, DI, Pagination\n');

  // Setup
  setupDependencies();
  final controller = TodoController(repository: sl.get());

  // Scenario 1: Initial load
  print('\n1️⃣ Initial Load');
  print('-' * 70);
  await controller.loadMore();
  controller.displayTodos();

  // Scenario 2: Load more (uses cache)
  print('\n2️⃣ Load More Pages');
  print('-' * 70);
  await controller.loadMore();
  await controller.loadMore();
  controller.displayTodos();

  // Scenario 3: Create todo
  print('\n3️⃣ Create New Todo');
  print('-' * 70);
  await controller.createTodo('Master Clean Architecture');
  controller.displayTodos();

  // Scenario 4: Refresh
  print('\n4️⃣ Refresh');
  print('-' * 70);
  await controller.refresh();
  controller.displayTodos();

  print('\n' + '=' * 70);
  print('✅ Production architecture working perfectly!');
  print('\n🎓 Architecture Features:');
  print('  ✓ Clean Architecture (Domain/Data/Presentation)');
  print('  ✓ Either pattern for error handling');
  print('  ✓ Caching with TTL');
  print('  ✓ Dependency injection');
  print('  ✓ Pagination');
  print('  ✓ Retry logic with exponential backoff');
  print('  ✓ Comprehensive logging');
  print('  ✓ Separation of concerns');
  print('\n💡 This is production-ready code architecture!');
}
