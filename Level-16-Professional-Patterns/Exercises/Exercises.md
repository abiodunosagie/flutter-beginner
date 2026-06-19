# Level 16: Professional Patterns - Exercises

Practice building professionally structured Flutter applications!

---

## Exercise 1: Clean Architecture Folder Structure (Beginner)

**Goal:** Set up a clean architecture folder structure for a "Todo" app.

**Tasks:**

### Part A: Create Folder Structure
Create the following folder structure:

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   └── usecases/
│       └── usecase.dart
│
├── features/
│   └── todos/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
│
├── injection_container.dart
└── main.dart
```

### Part B: Create Base Classes

```dart
// core/error/exceptions.dart
// Create: ServerException, CacheException, NetworkException

// core/error/failures.dart
// Create: abstract Failure class
// Create: ServerFailure, CacheFailure, NetworkFailure

// core/usecases/usecase.dart
// Create: abstract UseCase<Type, Params>
// Create: NoParams class
```

**Checklist:**
- [ ] All folders created
- [ ] Exception classes defined
- [ ] Failure classes defined
- [ ] UseCase base class created

<details>
<summary>✅ Solution</summary>

```dart
// core/error/exceptions.dart
class ServerException implements Exception {}
class CacheException implements Exception {}
class NetworkException implements Exception {}

// core/error/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not load cached data']);
}
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

// core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Use when a use case needs no input.
class NoParams {
  const NoParams();
}
```

The folders are just empty directories you create; the real work is these small base classes. `Failure` (returned to the app) is separate from `Exception` (thrown deep in the data layer) on purpose: data sources throw exceptions, the repository catches them and returns the matching `Failure`.

</details>

---

## Exercise 2: Entity and Model (Beginner)

**Goal:** Create properly separated Entity and Model classes.

**Tasks:**

### Part A: Create Todo Entity

```dart
// features/todos/domain/entities/todo.dart

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;

  // TODO: Add constructor

  // TODO: Add business logic methods:
  // - bool get isOverdue
  // - bool get isDueToday
  // - bool get isDueSoon (within 3 days)

  // TODO: Add copyWith method
}

enum Priority { low, medium, high }
```

### Part B: Create Todo Model

```dart
// features/todos/data/models/todo_model.dart

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String createdAt;
  final String? dueDate;
  final String priority;

  // TODO: Add constructor

  // TODO: Add fromJson factory

  // TODO: Add toJson method

  // TODO: Add toEntity method

  // TODO: Add fromEntity factory
}
```

### Part C: Test Conversion

```dart
void main() {
  final model = TodoModel.fromJson({
    'id': '1',
    'title': 'Test Todo',
    'description': 'Description',
    'is_completed': false,
    'created_at': '2024-01-15T10:00:00Z',
    'due_date': '2024-01-20T10:00:00Z',
    'priority': 'high',
  });

  final entity = model.toEntity();
  print('Entity title: ${entity.title}');
  print('Is overdue: ${entity.isOverdue}');
  print('Is high priority: ${entity.priority == Priority.high}');
}
```

<details>
<summary>✅ Solution</summary>

```dart
// domain/entities/todo.dart
enum Priority { low, medium, high }

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;

  const Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = Priority.medium,
  });

  bool get isOverdue =>
      dueDate != null && !isCompleted && dueDate!.isBefore(DateTime.now());

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isDueSoon =>
      dueDate != null &&
      !isCompleted &&
      dueDate!.isAfter(DateTime.now()) &&
      dueDate!.difference(DateTime.now()).inDays <= 3;

  Todo copyWith({String? title, bool? isCompleted, Priority? priority}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      dueDate: dueDate,
      priority: priority ?? this.priority,
    );
  }
}

// data/models/todo_model.dart
class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String createdAt;
  final String? dueDate;
  final String priority;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    required this.priority,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        isCompleted: json['is_completed'] ?? false,
        createdAt: json['created_at'],
        dueDate: json['due_date'],
        priority: json['priority'] ?? 'medium',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'is_completed': isCompleted,
        'created_at': createdAt,
        'due_date': dueDate,
        'priority': priority,
      };

  Todo toEntity() => Todo(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
        createdAt: DateTime.parse(createdAt),
        dueDate: dueDate != null ? DateTime.parse(dueDate!) : null,
        priority: Priority.values.firstWhere(
          (p) => p.name == priority,
          orElse: () => Priority.medium,
        ),
      );

  factory TodoModel.fromEntity(Todo todo) => TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        createdAt: todo.createdAt.toIso8601String(),
        dueDate: todo.dueDate?.toIso8601String(),
        priority: todo.priority.name,
      );
}
```

The Entity is the clean, in-app object with business logic (`isOverdue`); the Model handles the messy JSON (snake_case keys, dates as strings) and converts to/from the entity. Keeping them separate means a change in the API's JSON only touches the Model.

</details>

---

## Exercise 3: Repository Interface and Implementation (Intermediate)

**Goal:** Create a repository with proper abstraction.

**Tasks:**

### Part A: Define Repository Interface

```dart
// features/todos/domain/repositories/todo_repository.dart

abstract class TodoRepository {
  // TODO: Define these methods returning Either<Failure, T>
  // - getAllTodos()
  // - getTodo(String id)
  // - addTodo(Todo todo)
  // - updateTodo(Todo todo)
  // - deleteTodo(String id)
  // - toggleComplete(String id)
  // - getTodosByPriority(Priority priority)
  // - getOverdueTodos()
}
```

### Part B: Create Data Sources

```dart
// features/todos/data/datasources/todo_remote_datasource.dart
abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getAllTodos();
  Future<TodoModel> getTodo(String id);
  Future<TodoModel> addTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

// features/todos/data/datasources/todo_local_datasource.dart
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<void> cacheTodo(TodoModel todo);
  Future<void> removeTodo(String id);
}
```

### Part C: Implement Repository

```dart
// features/todos/data/repositories/todo_repository_impl.dart

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    // TODO: Implement with:
    // 1. Check network connection
    // 2. If online: fetch from remote, cache locally
    // 3. If offline: return from cache
    // 4. Handle exceptions, return Failure on error
  }

  // TODO: Implement other methods
}
```

<details>
<summary>✅ Solution</summary>

```dart
// domain/repositories/todo_repository.dart
abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getAllTodos();
  Future<Either<Failure, Todo>> getTodo(String id);
  Future<Either<Failure, Todo>> addTodo(Todo todo);
  Future<Either<Failure, Todo>> updateTodo(Todo todo);
  Future<Either<Failure, void>> deleteTodo(String id);
  Future<Either<Failure, Todo>> toggleComplete(String id);
  Future<Either<Failure, List<Todo>>> getTodosByPriority(Priority priority);
  Future<Either<Failure, List<Todo>>> getOverdueTodos();
}

// data/repositories/todo_repository_impl.dart
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTodos = await remoteDataSource.getAllTodos();
        await localDataSource.cacheTodos(remoteTodos);          // keep cache fresh
        return Right(remoteTodos.map((m) => m.toEntity()).toList());
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final cached = await localDataSource.getCachedTodos();   // offline fallback
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }

  // Other methods follow the same shape: check connection,
  // call the data source, convert Model -> Entity, and map any
  // exception to the matching Failure with Left(...).
}
```

The key idea: the repository returns `Either<Failure, T>` (never throws to the caller), tries the network first, falls back to the cache when offline, and converts data-layer exceptions into domain-layer failures.

</details>

---

## Exercise 4: Use Cases (Intermediate)

**Goal:** Create use cases for single responsibility actions.

**Tasks:**

### Part A: Create Use Cases

```dart
// features/todos/domain/usecases/get_all_todos.dart
class GetAllTodosUseCase implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  GetAllTodosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) {
    return repository.getAllTodos();
  }
}

// TODO: Create these use cases:
// - GetTodoUseCase (params: String id)
// - AddTodoUseCase (params: AddTodoParams)
// - UpdateTodoUseCase (params: Todo)
// - DeleteTodoUseCase (params: String id)
// - ToggleCompleteUseCase (params: String id)
```

### Part B: Create Params Classes

```dart
class AddTodoParams {
  final String title;
  final String description;
  final DateTime? dueDate;
  final Priority priority;

  AddTodoParams({
    required this.title,
    this.description = '',
    this.dueDate,
    this.priority = Priority.medium,
  });
}
```

### Part C: Complex Use Case

```dart
// Create a use case that involves multiple operations

class CompleteTodoWithNotificationUseCase {
  final TodoRepository todoRepository;
  final NotificationService notificationService;

  CompleteTodoWithNotificationUseCase({
    required this.todoRepository,
    required this.notificationService,
  });

  Future<Either<Failure, Todo>> call(String todoId) async {
    // TODO: Implement:
    // 1. Toggle todo complete
    // 2. If successful, cancel any reminders for this todo
    // 3. Return updated todo or failure
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
// Each use case = one action. They all look like this:
class GetTodoUseCase implements UseCase<Todo, String> {
  final TodoRepository repository;
  GetTodoUseCase(this.repository);
  @override
  Future<Either<Failure, Todo>> call(String id) => repository.getTodo(id);
}

class AddTodoUseCase implements UseCase<Todo, AddTodoParams> {
  final TodoRepository repository;
  AddTodoUseCase(this.repository);
  @override
  Future<Either<Failure, Todo>> call(AddTodoParams params) {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: params.title,
      description: params.description,
      createdAt: DateTime.now(),
      dueDate: params.dueDate,
      priority: params.priority,
    );
    return repository.addTodo(todo);
  }
}

class ToggleCompleteUseCase implements UseCase<Todo, String> {
  final TodoRepository repository;
  ToggleCompleteUseCase(this.repository);
  @override
  Future<Either<Failure, Todo>> call(String id) =>
      repository.toggleComplete(id);
}

class DeleteTodoUseCase implements UseCase<void, String> {
  final TodoRepository repository;
  DeleteTodoUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(String id) => repository.deleteTodo(id);
}

// Complex use case: combine two operations.
class CompleteTodoWithNotificationUseCase {
  final TodoRepository todoRepository;
  final NotificationService notificationService;
  CompleteTodoWithNotificationUseCase({
    required this.todoRepository,
    required this.notificationService,
  });

  Future<Either<Failure, Todo>> call(String todoId) async {
    final result = await todoRepository.toggleComplete(todoId);
    return result.fold(
      (failure) => Left(failure),
      (todo) async {
        if (todo.isCompleted) {
          await notificationService.cancelReminder(todoId);
        }
        return Right(todo);
      },
    );
  }
}
```

Each use case has one job and just forwards to the repository. The "complex" one shows how to chain steps: it only cancels the reminder if the toggle succeeded (using `fold`).

</details>

---

## Exercise 5: Dependency Injection Setup (Intermediate)

**Goal:** Configure GetIt for dependency injection.

**Tasks:**

### Part A: Install Dependencies

```yaml
# pubspec.yaml
dependencies:
  get_it: ^7.6.0
  dartz: ^0.10.1
  shared_preferences: ^2.2.0
  http: ^1.1.0
```

### Part B: Create Injection Container

```dart
// injection_container.dart

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  // TODO: Register SharedPreferences (async)
  // TODO: Register http.Client

  //! Core
  // TODO: Register NetworkInfo

  //! Features - Todos
  // Data sources
  // TODO: Register TodoRemoteDataSource
  // TODO: Register TodoLocalDataSource

  // Repository
  // TODO: Register TodoRepository

  // Use cases
  // TODO: Register all use cases

  // Controller
  // TODO: Register TodoController as factory
}
```

### Part C: Use in Main

```dart
// main.dart
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
```

### Part D: Access Dependencies

```dart
class TodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TodoController>()..loadTodos(),
      child: // ...
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
// injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External (created once, shared)
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Data sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl(prefs: sl()));

  //! Repository (depends on the data sources + network info above)
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton(() => GetAllTodosUseCase(sl()));
  sl.registerLazySingleton(() => AddTodoUseCase(sl()));
  sl.registerLazySingleton(() => ToggleCompleteUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTodoUseCase(sl()));

  //! Controller (factory: a fresh one each time the screen opens)
  sl.registerFactory(() => TodoController(
        getAllTodosUseCase: sl(),
        addTodoUseCase: sl(),
        toggleCompleteUseCase: sl(),
        deleteTodoUseCase: sl(),
      ));
}
```

`sl()` automatically supplies whatever type the constructor needs (GetIt resolves it). Use **singleton** for things you want one shared copy of (clients, repository), and **factory** for controllers so each screen gets a fresh one.

</details>

---

## Exercise 6: Controller with State Management (Intermediate)

**Goal:** Create a controller that manages async state properly.

**Tasks:**

### Part A: Define State

```dart
enum TodosStatus { initial, loading, success, error }

class TodosState {
  final TodosStatus status;
  final List<Todo> todos;
  final String? errorMessage;
  final Todo? selectedTodo;

  const TodosState({
    this.status = TodosStatus.initial,
    this.todos = const [],
    this.errorMessage,
    this.selectedTodo,
  });

  TodosState copyWith({
    TodosStatus? status,
    List<Todo>? todos,
    String? errorMessage,
    Todo? selectedTodo,
  }) {
    return TodosState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage,
      selectedTodo: selectedTodo ?? this.selectedTodo,
    );
  }
}
```

### Part B: Create Controller

```dart
class TodoController extends ChangeNotifier {
  final GetAllTodosUseCase getAllTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final ToggleCompleteUseCase toggleCompleteUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  TodosState _state = const TodosState();
  TodosState get state => _state;

  TodoController({
    required this.getAllTodosUseCase,
    required this.addTodoUseCase,
    required this.toggleCompleteUseCase,
    required this.deleteTodoUseCase,
  });

  // TODO: Implement these methods:
  // - loadTodos()
  // - addTodo(AddTodoParams params)
  // - toggleComplete(String id)
  // - deleteTodo(String id)
  // - filterByPriority(Priority? priority)
  // - filterCompleted(bool? completed)

  void _emit(TodosState newState) {
    _state = newState;
    notifyListeners();
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> loadTodos() async {
  _emit(_state.copyWith(status: TodosStatus.loading));
  final result = await getAllTodosUseCase(const NoParams());
  result.fold(
    (failure) => _emit(_state.copyWith(
      status: TodosStatus.error,
      errorMessage: failure.message,
    )),
    (todos) => _emit(_state.copyWith(
      status: TodosStatus.success,
      todos: todos,
    )),
  );
}

Future<void> addTodo(AddTodoParams params) async {
  final result = await addTodoUseCase(params);
  result.fold(
    (failure) => _emit(_state.copyWith(
      status: TodosStatus.error,
      errorMessage: failure.message,
    )),
    (todo) => _emit(_state.copyWith(
      status: TodosStatus.success,
      todos: [..._state.todos, todo],
    )),
  );
}

Future<void> toggleComplete(String id) async {
  final result = await toggleCompleteUseCase(id);
  result.fold(
    (failure) => _emit(_state.copyWith(
      status: TodosStatus.error,
      errorMessage: failure.message,
    )),
    (updated) => _emit(_state.copyWith(
      todos: _state.todos
          .map((t) => t.id == updated.id ? updated : t)
          .toList(),
    )),
  );
}

Future<void> deleteTodo(String id) async {
  final result = await deleteTodoUseCase(id);
  result.fold(
    (failure) => _emit(_state.copyWith(
      status: TodosStatus.error,
      errorMessage: failure.message,
    )),
    (_) => _emit(_state.copyWith(
      todos: _state.todos.where((t) => t.id != id).toList(),
    )),
  );
}
```

Every action follows the same pattern: call the use case, then `fold` the `Either` into either an error state or an updated success state, and `_emit` it so the UI rebuilds. The widget in Part C just reads `controller.state.status` and shows loading/error/success.

</details>

### Part C: Use in Widget

```dart
class TodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoController>(
      builder: (context, controller, child) {
        final state = controller.state;

        return switch (state.status) {
          TodosStatus.initial || TodosStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          TodosStatus.error =>
            ErrorView(
              message: state.errorMessage ?? 'Unknown error',
              onRetry: controller.loadTodos,
            ),
          TodosStatus.success =>
            TodosList(
              todos: state.todos,
              onToggle: controller.toggleComplete,
              onDelete: controller.deleteTodo,
            ),
        };
      },
    );
  }
}
```

---

## Exercise 7: Error Handling (Intermediate)

**Goal:** Implement comprehensive error handling.

**Tasks:**

### Part A: Define Specific Failures

```dart
// core/error/failures.dart

sealed class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    String message = 'Server error occurred',
    this.statusCode,
  }) : super(message, 'SERVER_ERROR');
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Please check your internet connection',
  }) : super(message, 'NETWORK_ERROR');
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Could not load cached data',
  }) : super(message, 'CACHE_ERROR');
}

class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure({
    required this.errors,
    String message = 'Validation failed',
  }) : super(message, 'VALIDATION_ERROR');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Resource not found',
  }) : super(message, 'NOT_FOUND');
}
```

### Part B: Error UI Components

```dart
// Create reusable error widgets

class ErrorSnackBar {
  static void show(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(failure.message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement full-screen error view
    // with icon, message, and retry button
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

The `sealed class Failure` plus specific subclasses (Part A) let the controller react differently per failure type (Part C uses `result.fold` and checks `if (failure is ValidationFailure)` etc.). Note: the Part C snippet references extra `TodosState` fields like `validationErrors`/`pendingSync`; in a real build you would add those to your state class, or simplify to a single `errorMessage`. The reusable `ErrorView`/`ErrorSnackBar` keep all error UI in one place.

</details>

### Part C: Handle Errors in Controller

```dart
Future<void> addTodo(AddTodoParams params) async {
  final result = await addTodoUseCase(params);

  result.fold(
    (failure) {
      // Handle specific failure types
      if (failure is ValidationFailure) {
        _emit(_state.copyWith(
          validationErrors: failure.errors,
        ));
      } else if (failure is NetworkFailure) {
        // Maybe queue for later sync?
        _emit(_state.copyWith(
          errorMessage: failure.message,
          pendingSync: true,
        ));
      } else {
        _emit(_state.copyWith(
          errorMessage: failure.message,
        ));
      }
    },
    (todo) {
      _emit(_state.copyWith(
        todos: [..._state.todos, todo],
        status: TodosStatus.success,
      ));
    },
  );
}
```

---

## Exercise 8: Full Feature Implementation (Advanced)

**Goal:** Implement a complete feature with all professional patterns.

**Feature: User Profile**

### Requirements:
- Display user profile
- Edit profile (name, email, avatar)
- Change password
- Logout
- Offline support (show cached profile)
- Loading and error states

### Structure:
```
lib/
└── features/
    └── profile/
        ├── data/
        │   ├── datasources/
        │   │   ├── profile_remote_datasource.dart
        │   │   └── profile_local_datasource.dart
        │   ├── models/
        │   │   └── user_model.dart
        │   └── repositories/
        │       └── profile_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user.dart
        │   ├── repositories/
        │   │   └── profile_repository.dart
        │   └── usecases/
        │       ├── get_profile.dart
        │       ├── update_profile.dart
        │       └── change_password.dart
        └── presentation/
            ├── controllers/
            │   └── profile_controller.dart
            ├── pages/
            │   ├── profile_page.dart
            │   └── edit_profile_page.dart
            └── widgets/
                ├── profile_header.dart
                └── profile_form.dart
```

### Tasks:
1. Create User entity with validation
2. Create UserModel with serialization
3. Define ProfileRepository interface
4. Implement data sources
5. Implement repository with caching
6. Create use cases
7. Set up dependency injection
8. Create ProfileController
9. Build UI screens
10. Add error handling

<details>
<summary>✅ Solution (representative)</summary>

This feature follows the EXACT same shape as the Todo feature you built in Exercises 2-6, just with `User` instead of `Todo`. Here are the key pieces; the rest mirror the Todo solutions.

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  // Business-rule validation lives on the entity.
  bool get hasValidEmail => email.contains('@') && email.contains('.');
  bool get hasName => name.trim().isNotEmpty;

  User copyWith({String? name, String? email, String? avatarUrl}) => User(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}

// domain/repositories/profile_repository.dart
abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateProfile(User user);
  Future<Either<Failure, void>> changePassword(String oldPw, String newPw);
}

// domain/usecases/get_profile.dart
class GetProfileUseCase implements UseCase<User, NoParams> {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);
  @override
  Future<Either<Failure, User>> call(NoParams params) =>
      repository.getProfile();
}

// presentation/controllers/profile_controller.dart (skeleton)
class ProfileController extends ChangeNotifier {
  final GetProfileUseCase getProfile;
  final UpdateProfileUseCase updateProfile;
  ProfileController({required this.getProfile, required this.updateProfile});

  ProfileState _state = const ProfileState();
  ProfileState get state => _state;

  Future<void> load() async {
    _emit(_state.copyWith(status: Status.loading));
    final result = await getProfile(const NoParams());
    result.fold(
      (f) => _emit(_state.copyWith(status: Status.error, errorMessage: f.message)),
      (user) => _emit(_state.copyWith(status: Status.success, user: user)),
    );
  }

  void _emit(ProfileState s) { _state = s; notifyListeners(); }
}
```

- `UserModel` (data layer): add `fromJson`/`toJson`/`toEntity`/`fromEntity`, exactly like `TodoModel`.
- Repository impl: try remote, cache to local, fall back to cache when offline, map exceptions to failures, same as `TodoRepositoryImpl`.
- DI: register the data sources, repository, use cases, and controller in `injection_container.dart`, same as Exercise 5.
- UI: `profile_page` reads `controller.state.status` and shows loading / error (`ErrorView`) / the profile; `edit_profile_page` uses a `Form` with validators that reuse `user.hasValidEmail`.

The whole point of Clean Architecture: once you know the Todo feature, every new feature (Profile, Settings, etc.) is the same predictable set of files.

</details>

---

## Architecture Checklist

Use this checklist when building features:

```
DOMAIN LAYER:
□ Entity created with business logic
□ Repository interface defined
□ Use cases created (one per action)
□ No Flutter imports in domain

DATA LAYER:
□ Model with serialization
□ Remote data source implemented
□ Local data source for caching
□ Repository implements interface
□ Proper error mapping

PRESENTATION LAYER:
□ Controller with state management
□ Loading, error, success states
□ Clean separation from business logic
□ Reactive UI updates

DEPENDENCY INJECTION:
□ All dependencies registered
□ Proper scoping (singleton vs factory)
□ Easy to mock for testing

ERROR HANDLING:
□ Specific failure types
□ User-friendly messages
□ Retry options where appropriate
□ Logging for debugging
```

---

## Quick Reference

```
CLEAN ARCHITECTURE LAYERS:

Presentation → Domain ← Data
    ↓              ↓
  Widgets      Entities
  Pages        Use Cases
  Controllers  Repo Interfaces
    ↓              ↓
    └──────────────┘
        (Domain is center)

DEPENDENCY RULE:
- Outer layers depend on inner
- Inner knows nothing about outer
- Domain is pure Dart (no Flutter)

USE CASE PATTERN:
class DoSomethingUseCase implements UseCase<Result, Params> {
  final Repository repository;
  DoSomethingUseCase(this.repository);

  @override
  Future<Either<Failure, Result>> call(Params params) {
    return repository.doSomething(params);
  }
}

REPOSITORY PATTERN:
abstract class Repository {      // Domain (interface)
  Future<Either<Failure, T>> method();
}

class RepositoryImpl implements Repository {  // Data (implementation)
  final RemoteDataSource remote;
  final LocalDataSource local;
  // Implementation with caching, error handling
}
```

---

**Congratulations!** You've completed the entire Flutter Beginner Course!

You now have the knowledge to build professional, maintainable Flutter applications.

## What's Next?

1. **Build a real project** using these patterns
2. **Explore advanced topics**: Riverpod, BLoC, GoRouter
3. **Learn testing**: Unit tests, widget tests, integration tests
4. **Study performance**: Optimization, profiling
5. **Contribute to open source** Flutter projects

**Happy coding!** 🎉
