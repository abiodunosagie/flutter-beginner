// Week 16, Exercise 4: Pagination Pattern
// Difficulty: Intermediate-Advanced
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
  String toString() => 'Todo(id: $id, title: "$title")';
}

// Paginated Response
class PaginatedResult<T> {
  final List<T> items;
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final bool hasMore;

  PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
    required this.hasMore,
  });

  int get totalPages => (totalItems / itemsPerPage).ceil();
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => !hasMore;

  @override
  String toString() {
    return 'PaginatedResult(page: $currentPage/$totalPages, items: ${items.length}, hasMore: $hasMore)';
  }
}

abstract class TodoRepository {
  Future<PaginatedResult<Todo>> getTodos({
    required int page,
    required int limit,
  });
}

// Use Case: Get Paginated Todos
class GetPaginatedTodos {
  final TodoRepository repository;

  GetPaginatedTodos(this.repository);

  Future<PaginatedResult<Todo>> call({
    required int page,
    int limit = 10,
  }) async {
    return await repository.getTodos(page: page, limit: limit);
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
}

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos({
    required int page,
    required int limit,
  });
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  TodoRemoteDataSourceImpl(this.client);

  @override
  Future<List<TodoModel>> getTodos({
    required int page,
    required int limit,
  }) async {
    // Calculate offset for pagination
    final start = (page - 1) * limit;

    // JSONPlaceholder uses _start and _limit for pagination
    final uri = Uri.parse('$baseUrl?_start=$start&_limit=$limit');

    print('  🌐 Fetching page $page (limit: $limit, start: $start)');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final todos = jsonList.map((json) => TodoModel.fromJson(json)).toList();
      print('  ✓ Fetched ${todos.length} todos');
      return todos;
    } else {
      throw Exception('Failed to fetch todos');
    }
  }
}

// Local cache for pagination
class TodoLocalCache {
  final Map<int, List<TodoModel>> _pageCache = {};

  void cachePage(int page, List<TodoModel> todos) {
    _pageCache[page] = todos;
  }

  List<TodoModel>? getPage(int page) {
    return _pageCache[page];
  }

  bool hasPage(int page) {
    return _pageCache.containsKey(page);
  }

  void clear() {
    _pageCache.clear();
  }

  int get cachedPages => _pageCache.length;
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalCache cache;

  // JSONPlaceholder has 200 total todos
  static const int totalTodos = 200;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.cache,
  });

  @override
  Future<PaginatedResult<Todo>> getTodos({
    required int page,
    required int limit,
  }) async {
    print('\n📋 Repository: Getting page $page (limit: $limit)');

    // Check cache first
    if (cache.hasPage(page)) {
      print('  📦 Cache hit for page $page');
      final cachedTodos = cache.getPage(page)!;
      return _buildPaginatedResult(
        items: cachedTodos.cast<Todo>(),
        page: page,
        limit: limit,
      );
    }

    // Fetch from remote
    print('  ⚠ Cache miss for page $page');
    final todos = await remoteDataSource.getTodos(page: page, limit: limit);

    // Cache the result
    cache.cachePage(page, todos);
    print('  💾 Cached page $page');

    return _buildPaginatedResult(
      items: todos.cast<Todo>(),
      page: page,
      limit: limit,
    );
  }

  PaginatedResult<Todo> _buildPaginatedResult({
    required List<Todo> items,
    required int page,
    required int limit,
  }) {
    final totalItems = totalTodos;
    final hasMore = (page * limit) < totalItems;

    return PaginatedResult<Todo>(
      items: items,
      currentPage: page,
      itemsPerPage: limit,
      totalItems: totalItems,
      hasMore: hasMore,
    );
  }
}

// ============================================================================
// PRESENTATION LAYER - Pagination Controller
// ============================================================================

class TodoPaginationController {
  final GetPaginatedTodos getPaginatedTodos;

  int currentPage = 0;
  final int itemsPerPage = 10;
  final List<Todo> allLoadedTodos = [];
  bool isLoading = false;
  bool hasMore = true;

  TodoPaginationController(this.getPaginatedTodos);

  Future<void> loadNextPage() async {
    if (isLoading || !hasMore) {
      if (!hasMore) {
        print('  ℹ️  No more pages to load');
      }
      return;
    }

    isLoading = true;
    currentPage++;

    print('\n📄 Loading page $currentPage...');

    try {
      final result = await getPaginatedTodos.call(
        page: currentPage,
        limit: itemsPerPage,
      );

      // Add new items to our list
      allLoadedTodos.addAll(result.items);
      hasMore = result.hasMore;

      print('✓ Loaded ${result.items.length} todos');
      print('  Current page: ${result.currentPage}/${result.totalPages}');
      print('  Total loaded: ${allLoadedTodos.length}/${result.totalItems}');
      print('  Has more: $hasMore');
    } catch (e) {
      print('✗ Error loading page: $e');
      currentPage--; // Rollback on error
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh() async {
    print('\n🔄 Refreshing from beginning...');
    currentPage = 0;
    allLoadedTodos.clear();
    hasMore = true;
    await loadNextPage();
  }

  void displayTodos({int? limit}) {
    final todosToShow = limit != null && limit < allLoadedTodos.length
        ? allLoadedTodos.sublist(0, limit)
        : allLoadedTodos;

    print('\nCurrently Loaded Todos (${allLoadedTodos.length} total):');
    for (int i = 0; i < todosToShow.length; i++) {
      final todo = todosToShow[i];
      print('  ${i + 1}. ${todo.completed ? "✅" : "⬜"} ${todo.title}');
    }

    if (limit != null && limit < allLoadedTodos.length) {
      print('  ... and ${allLoadedTodos.length - limit} more');
    }

    if (hasMore) {
      print('\n  💡 More todos available. Call loadNextPage() to load more.');
    } else {
      print('\n  🎉 All todos loaded!');
    }
  }
}

// ============================================================================
// MAIN
// ============================================================================

void main() async {
  print('Pagination Pattern Demo');
  print('=' * 70);

  // Setup
  final client = http.Client();
  final dataSource = TodoRemoteDataSourceImpl(client);
  final cache = TodoLocalCache();
  final repository = TodoRepositoryImpl(
    remoteDataSource: dataSource,
    cache: cache,
  );
  final useCase = GetPaginatedTodos(repository);
  final controller = TodoPaginationController(useCase);

  // Scenario 1: Load first page
  print('\n📱 Scenario 1: Initial Load');
  print('-' * 70);
  await controller.loadNextPage();
  controller.displayTodos(limit: 5);

  // Scenario 2: Load more (page 2)
  print('\n📱 Scenario 2: Load More');
  print('-' * 70);
  await controller.loadNextPage();
  controller.displayTodos(limit: 10);

  // Scenario 3: Load more (page 3) - Should use cache for previous pages
  print('\n📱 Scenario 3: Load More (with caching)');
  print('-' * 70);
  await controller.loadNextPage();
  print('Cache status: ${cache.cachedPages} pages cached');
  controller.displayTodos(limit: 15);

  // Scenario 4: Try to load when already loading
  print('\n📱 Scenario 4: Prevent Duplicate Loading');
  print('-' * 70);
  controller.isLoading = true;
  await controller.loadNextPage();
  controller.isLoading = false;

  // Scenario 5: Refresh from beginning
  print('\n📱 Scenario 5: Refresh');
  print('-' * 70);
  cache.clear();
  await controller.refresh();
  controller.displayTodos(limit: 5);

  // Scenario 6: Load many pages to demonstrate pagination
  print('\n📱 Scenario 6: Load Multiple Pages');
  print('-' * 70);
  for (int i = 0; i < 5; i++) {
    await controller.loadNextPage();
  }
  controller.displayTodos(limit: 10);

  // Scenario 7: Attempt to load beyond last page
  print('\n📱 Scenario 7: Load Until Last Page');
  print('-' * 70);
  while (controller.hasMore) {
    await controller.loadNextPage();
  }
  print('Reached the end!');
  print('Total loaded: ${controller.allLoadedTodos.length} todos');

  // Try loading more (should do nothing)
  print('\nAttempting to load more...');
  await controller.loadNextPage();

  print('\n' + '=' * 70);
  print('✅ Pagination pattern working correctly!');
  print('\nKey Features:');
  print('  • Loads data in chunks (pages)');
  print('  • Caches previous pages');
  print('  • Prevents duplicate loading');
  print('  • Handles last page gracefully');
  print('  • Supports refresh functionality');
}
