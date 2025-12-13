// Week 15, Exercise 1: Domain Layer - Entities and Repository Interface
// Difficulty: Beginner
// Solution

// DOMAIN LAYER - Pure business logic, no external dependencies

// Entity: Todo
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

  // Create a copy with modifications
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

// Use Case: Get All Todos
class GetAllTodos {
  final TodoRepository repository;

  GetAllTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}

// Use Case: Get Todo by ID
class GetTodoById {
  final TodoRepository repository;

  GetTodoById(this.repository);

  Future<Todo?> call(String id) async {
    return await repository.getTodoById(id);
  }
}

// Mock Implementation for Testing
class MockTodoRepository implements TodoRepository {
  final List<Todo> _todos = [
    Todo(
      id: '1',
      title: 'Learn Clean Architecture',
      description: 'Study the principles of clean architecture',
      completed: false,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Todo(
      id: '2',
      title: 'Build Flutter App',
      description: 'Create a todo app with clean architecture',
      completed: false,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Todo(
      id: '3',
      title: 'Write Tests',
      description: 'Test all layers of the application',
      completed: true,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<Todo>> getTodos() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    return _todos;
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _todos.firstWhere(
      (todo) => todo.id == id,
      orElse: () => throw Exception('Todo not found'),
    );
  }

  @override
  Future<Todo> createTodo(Todo todo) async {
    await Future.delayed(Duration(milliseconds: 300));
    _todos.add(todo);
    return todo;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    _todos.removeWhere((todo) => todo.id == id);
  }
}

void main() async {
  print('Testing Domain Layer');
  print('=' * 60);

  // Create mock repository
  final repository = MockTodoRepository();

  // Create use case
  final getAllTodos = GetAllTodos(repository);
  final getTodoById = GetTodoById(repository);

  // Test: Get all todos
  print('\n1. Getting all todos...');
  List<Todo> todos = await getAllTodos.call();
  print('Found ${todos.length} todos:');
  for (var todo in todos) {
    print('  ${todo.completed ? "✓" : "○"} $todo');
  }

  // Test: Get specific todo
  print('\n2. Getting todo by ID...');
  Todo? todo = await getTodoById.call('1');
  if (todo != null) {
    print('Found: $todo');
    print('Description: ${todo.description}');
  }

  print('\n' + '=' * 60);
  print('Domain layer working correctly!');
}
