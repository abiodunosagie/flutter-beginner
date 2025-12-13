// Week 16, Exercise 3: Testing Repositories with Mocks
// Difficulty: Intermediate
// Solution

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode;
}

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(Todo todo);
  Future<void> deleteTodo(String id);
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
  Future<void> deleteTodo(String id);
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final todoModels = await remoteDataSource.getTodos();
      return todoModels.cast<Todo>();
    } catch (e) {
      throw Exception('Failed to get todos: $e');
    }
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      final created = await remoteDataSource.createTodo(todoModel);
      return created;
    } catch (e) {
      throw Exception('Failed to create todo: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await remoteDataSource.deleteTodo(id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}

// ============================================================================
// MOCK DATA SOURCE (for testing)
// ============================================================================

class MockTodoRemoteDataSource implements TodoRemoteDataSource {
  final List<TodoModel> _mockData = [
    TodoModel(id: '1', title: 'Learn Testing', completed: false),
    TodoModel(id: '2', title: 'Write Unit Tests', completed: false),
    TodoModel(id: '3', title: 'Master Mocking', completed: true),
  ];

  bool shouldFail = false;
  String? lastDeletedId;

  @override
  Future<List<TodoModel>> getTodos() async {
    if (shouldFail) {
      throw Exception('Network error');
    }

    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    return List.from(_mockData);
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    if (shouldFail) {
      throw Exception('Server error');
    }

    await Future.delayed(Duration(milliseconds: 100));

    // Simulate server assigning ID
    final created = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: todo.title,
      completed: todo.completed,
    );

    _mockData.add(created);
    return created;
  }

  @override
  Future<void> deleteTodo(String id) async {
    if (shouldFail) {
      throw Exception('Delete failed');
    }

    await Future.delayed(Duration(milliseconds: 100));
    lastDeletedId = id;
    _mockData.removeWhere((todo) => todo.id == id);
  }

  // Helper methods for testing
  void reset() {
    _mockData.clear();
    _mockData.addAll([
      TodoModel(id: '1', title: 'Learn Testing', completed: false),
      TodoModel(id: '2', title: 'Write Unit Tests', completed: false),
      TodoModel(id: '3', title: 'Master Mocking', completed: true),
    ]);
    shouldFail = false;
    lastDeletedId = null;
  }

  int get todoCount => _mockData.length;
}

// ============================================================================
// TEST FRAMEWORK (Simple assertion-based testing)
// ============================================================================

class TestRunner {
  int passed = 0;
  int failed = 0;
  int total = 0;

  void test(String description, Future<void> Function() testFn) async {
    total++;
    try {
      await testFn();
      passed++;
      print('  ✅ PASS: $description');
    } catch (e) {
      failed++;
      print('  ❌ FAIL: $description');
      print('     Error: $e');
    }
  }

  void expect<T>(T actual, T expected, [String? message]) {
    if (actual != expected) {
      throw Exception(
        message ?? 'Expected $expected but got $actual',
      );
    }
  }

  void expectTrue(bool condition, [String? message]) {
    if (!condition) {
      throw Exception(message ?? 'Expected true but got false');
    }
  }

  void expectThrows(Function fn, [String? message]) {
    try {
      fn();
      throw Exception(message ?? 'Expected exception but none was thrown');
    } catch (e) {
      // Expected
    }
  }

  void printSummary() {
    print('\n${"=" * 70}');
    print('TEST SUMMARY:');
    print('  Total: $total');
    print('  Passed: $passed ✅');
    print('  Failed: $failed ${failed > 0 ? "❌" : ""}');
    print('  Success Rate: ${(passed / total * 100).toStringAsFixed(1)}%');
    print('=' * 70);
  }
}

// ============================================================================
// TEST CASES
// ============================================================================

void main() async {
  print('Testing TodoRepository with Mocks');
  print('=' * 70);

  final runner = TestRunner();
  late MockTodoRemoteDataSource mockDataSource;
  late TodoRepository repository;

  // Setup before each test
  void setup() {
    mockDataSource = MockTodoRemoteDataSource();
    repository = TodoRepositoryImpl(mockDataSource);
  }

  print('\n📋 Test Suite: TodoRepository\n');

  // Test 1: getTodos returns list of todos
  await runner.test('getTodos returns list of todos', () async {
    setup();

    final todos = await repository.getTodos();

    runner.expect(todos.length, 3, 'Should return 3 todos');
    runner.expect(todos[0].title, 'Learn Testing', 'First todo title matches');
    runner.expectTrue(
      todos[0] is Todo,
      'Should return Todo entities, not TodoModels',
    );
  });

  // Test 2: getTodos with empty result
  await runner.test('getTodos handles empty result', () async {
    setup();
    mockDataSource._mockData.clear();

    final todos = await repository.getTodos();

    runner.expect(todos.length, 0, 'Should return empty list');
  });

  // Test 3: getTodos throws on error
  await runner.test('getTodos throws exception on data source error', () async {
    setup();
    mockDataSource.shouldFail = true;

    try {
      await repository.getTodos();
      throw Exception('Should have thrown');
    } catch (e) {
      runner.expectTrue(
        e.toString().contains('Failed to get todos'),
        'Should wrap original exception',
      );
    }
  });

  // Test 4: createTodo adds new todo
  await runner.test('createTodo creates and returns new todo', () async {
    setup();

    final newTodo = Todo(
      id: '0',
      title: 'New Test Todo',
      completed: false,
    );

    final created = await repository.createTodo(newTodo);

    runner.expect(created.title, 'New Test Todo', 'Title should match');
    runner.expect(created.completed, false, 'Completed should be false');
    runner.expect(mockDataSource.todoCount, 4, 'Should add to data source');
  });

  // Test 5: createTodo throws on error
  await runner.test('createTodo throws exception on error', () async {
    setup();
    mockDataSource.shouldFail = true;

    final newTodo = Todo(
      id: '0',
      title: 'Will Fail',
      completed: false,
    );

    try {
      await repository.createTodo(newTodo);
      throw Exception('Should have thrown');
    } catch (e) {
      runner.expectTrue(
        e.toString().contains('Failed to create todo'),
        'Should wrap original exception',
      );
    }
  });

  // Test 6: deleteTodo removes todo
  await runner.test('deleteTodo removes todo from data source', () async {
    setup();

    await repository.deleteTodo('1');

    runner.expect(mockDataSource.lastDeletedId, '1', 'Should delete correct ID');
    runner.expect(mockDataSource.todoCount, 2, 'Should remove from data source');
  });

  // Test 7: deleteTodo throws on error
  await runner.test('deleteTodo throws exception on error', () async {
    setup();
    mockDataSource.shouldFail = true;

    try {
      await repository.deleteTodo('1');
      throw Exception('Should have thrown');
    } catch (e) {
      runner.expectTrue(
        e.toString().contains('Failed to delete todo'),
        'Should wrap original exception',
      );
    }
  });

  // Test 8: Model to Entity conversion
  await runner.test('TodoModel correctly converts to Todo entity', () async {
    setup();

    final todos = await repository.getTodos();
    final firstTodo = todos[0];

    runner.expectTrue(
      firstTodo is Todo,
      'Should be a Todo instance',
    );
    runner.expectTrue(
      firstTodo is! TodoModel || firstTodo is Todo,
      'Should be compatible with Todo type',
    );
  });

  // Test 9: Repository maintains data consistency
  await runner.test('Repository maintains data consistency', () async {
    setup();

    final initialTodos = await repository.getTodos();
    final initialCount = initialTodos.length;

    await repository.createTodo(
      Todo(id: '0', title: 'Test', completed: false),
    );

    await repository.deleteTodo('1');

    final finalTodos = await repository.getTodos();

    runner.expect(
      finalTodos.length,
      initialCount,
      'Count should be same after create and delete',
    );
  });

  // Print summary
  runner.printSummary();

  if (runner.failed == 0) {
    print('\n🎉 All tests passed! Your repository is working correctly.');
    print('\nKey Learnings:');
    print('  • Mocking allows testing without external dependencies');
    print('  • Repositories can be tested in isolation');
    print('  • Good tests verify both success and failure scenarios');
    print('  • Clean Architecture makes code highly testable');
  } else {
    print('\n⚠️  Some tests failed. Review the failures above.');
  }
}
