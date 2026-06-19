# Repository Pattern and Testing BLoC

## The Big Idea In One Sentence

> A **repository** is the one place that fetches your data, so the bloc only handles logic, and that split makes both easy to **test**.

Two ideas in this lesson: keep data-fetching in a repository (the warehouse), and write small tests that prove your bloc emits the right states.

Let's learn how to separate data fetching from business logic using the Repository pattern, and how to test your BLoCs easily! Think of repositories as the warehouse that stores ingredients, separate from the kitchen.

---

## The Repository Pattern

Repositories handle data fetching and storage, keeping your BLoC clean and focused on business logic.

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   WITHOUT Repository (Messy):                       │
│   ────────────────────────────                      │
│                                                     │
│   BLoC                                              │
│   • Business logic                                  │
│   • API calls                                       │
│   • Database queries                                │
│   • Caching logic                                   │
│   • Error handling                                  │
│   (Too many responsibilities!)                      │
│                                                     │
│   WITH Repository (Clean):                          │
│   ──────────────────────────                        │
│                                                     │
│   Repository             BLoC                       │
│   • API calls            • Business logic           │
│   • Database queries     • State management         │
│   • Caching              • User interactions        │
│   • Data formatting      • Validation               │
│                                                     │
│   (Each has one job!)                               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Creating a Repository

### Step 1: Define Repository Interface

```dart
// Abstract class defines what the repository can do
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getAllUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}
```

### Step 2: Implement the Repository

```dart
class ApiUserRepository implements UserRepository {
  final ApiClient client;

  ApiUserRepository({required this.client});

  @override
  Future<User> getUser(String id) async {
    try {
      final response = await client.get('/users/$id');
      return User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final response = await client.get('/users');
      return (response as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await client.put('/users/${user.id}', user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await client.delete('/users/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
```

---

## Using Repository in BLoC

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      // BLoC just asks repository for data
      final user = await repository.getUser(event.id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      await repository.updateUser(event.user);
      emit(UserLoaded(event.user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

### Providing Both Repository and BLoC

```dart
void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        // Provide repository
        RepositoryProvider(
          create: (_) => ApiUserRepository(
            client: ApiClient(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Provide BLoC with repository
          BlocProvider(
            create: (context) => UserBloc(
              repository: context.read<UserRepository>(),
            ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}
```

---

## Benefits of Repository Pattern

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   1. SEPARATION OF CONCERNS                         │
│      BLoC focuses on logic, Repository on data      │
│                                                     │
│   2. EASY TESTING                                   │
│      Mock the repository easily                     │
│                                                     │
│   3. REUSABILITY                                    │
│      Same repository, different BLoCs               │
│                                                     │
│   4. FLEXIBILITY                                    │
│      Switch from API to database easily             │
│      ApiRepository → DatabaseRepository             │
│                                                     │
│   5. CACHING                                        │
│      Add caching in repository, BLoC unaware        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Testing BLoC

BLoC is very easy to test! Let's learn how.

### Add Test Package

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
```

### Basic BLoC Test

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('CounterBloc', () {
    late CounterBloc bloc;

    setUp(() {
      bloc = CounterBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is 0', () {
      expect(bloc.state, 0);
    });

    blocTest<CounterBloc, int>(
      'emits [1] when Increment is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(Increment()),
      expect: () => [1],
    );

    blocTest<CounterBloc, int>(
      'emits [1, 2, 3] when Increment is added three times',
      build: () => CounterBloc(),
      act: (bloc) {
        bloc.add(Increment());
        bloc.add(Increment());
        bloc.add(Increment());
      },
      expect: () => [1, 2, 3],
    );

    blocTest<CounterBloc, int>(
      'emits [0] when Reset is added',
      build: () => CounterBloc(),
      seed: () => 5,  // Start from state 5
      act: (bloc) => bloc.add(Reset()),
      expect: () => [0],
    );
  });
}
```

---

## Testing with Mock Repository

Create a mock repository for testing:

```dart
import 'package:mocktail/mocktail.dart';

// Add to dev_dependencies: mocktail: ^1.0.0

// Mock repository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserBloc', () {
    late UserRepository repository;
    late UserBloc bloc;

    setUp(() {
      repository = MockUserRepository();
      bloc = UserBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] when LoadUser succeeds',
      build: () {
        // Mock successful response
        when(() => repository.getUser('123'))
            .thenAnswer((_) async => User(id: '123', name: 'John'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUser('123')),
      expect: () => [
        UserLoading(),
        UserLoaded(User(id: '123', name: 'John')),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserError] when LoadUser fails',
      build: () {
        // Mock error response
        when(() => repository.getUser('123'))
            .thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUser('123')),
      expect: () => [
        UserLoading(),
        UserError('Exception: Network error'),
      ],
    );
  });
}
```

---

## Complete Todo App with Repository Pattern

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ─────────────────────────────────────
// Models
// ─────────────────────────────────────
class Todo extends Equatable {
  final String id;
  final String title;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [id, title, completed];
}

// ─────────────────────────────────────
// Repository
// ─────────────────────────────────────
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(String title);
  Future<void> toggleTodo(String id);
  Future<void> deleteTodo(String id);
}

class LocalTodoRepository implements TodoRepository {
  final List<Todo> _todos = [];

  @override
  Future<List<Todo>> getTodos() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(_todos);
  }

  @override
  Future<void> addTodo(String title) async {
    await Future.delayed(Duration(milliseconds: 300));
    _todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
  }

  @override
  Future<void> toggleTodo(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        completed: !_todos[index].completed,
      );
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    _todos.removeWhere((t) => t.id == id);
  }
}

// ─────────────────────────────────────
// Events
// ─────────────────────────────────────
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
  @override
  List<Object?> get props => [title];
}

class ToggleTodo extends TodoEvent {
  final String id;
  ToggleTodo(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
  @override
  List<Object?> get props => [id];
}

// ─────────────────────────────────────
// States
// ─────────────────────────────────────
abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);

  int get completedCount => todos.where((t) => t.completed).length;
  int get pendingCount => todos.where((t) => !t.completed).length;

  @override
  List<Object?> get props => [todos];
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await repository.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await repository.addTodo(event.title);
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    }
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await repository.toggleTodo(event.id);
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await repository.deleteTodo(event.id);
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    }
  }
}

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    RepositoryProvider(
      create: (_) => LocalTodoRepository(),
      child: BlocProvider(
        create: (context) => TodoBloc(
          repository: context.read<TodoRepository>(),
        )..add(LoadTodos()),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC Todos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<TodoBloc>().add(LoadTodos());
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial || state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(LoadTodos());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TodoLoaded) {
            return Column(
              children: [
                // Stats
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.orange.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Completed: ${state.completedCount}'),
                      Text('Pending: ${state.pendingCount}'),
                    ],
                  ),
                ),

                // Todo list
                Expanded(
                  child: state.todos.isEmpty
                      ? Center(child: Text('No todos yet!'))
                      : ListView.builder(
                          itemCount: state.todos.length,
                          itemBuilder: (context, index) {
                            final todo = state.todos[index];
                            return ListTile(
                              leading: Checkbox(
                                value: todo.completed,
                                onChanged: (_) {
                                  context.read<TodoBloc>().add(ToggleTodo(todo.id));
                                },
                              ),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context.read<TodoBloc>().add(DeleteTodo(todo.id));
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add Todo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter todo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TodoBloc>().add(AddTodo(controller.text));
                Navigator.pop(dialogContext);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
```

---

## Summary

### Repository Pattern

| Benefit | Description |
|---------|-------------|
| Separation | Data logic separate from business logic |
| Testability | Easy to mock repositories |
| Flexibility | Switch data sources easily |
| Reusability | Share repositories across BLoCs |

### Testing BLoC

| Tool | Purpose |
|------|---------|
| `bloc_test` | Test BLoC easily with blocTest |
| `mocktail` | Mock dependencies (repositories) |
| `setUp/tearDown` | Initialize/cleanup for each test |
| `expect()` | Verify emitted states |

---

## Key Takeaways

1. **Repository Pattern** separates data fetching from business logic
2. **Easy testing** by mocking repositories
3. Use **bloc_test** package for clean BLoC tests
4. Test both **success and error** scenarios
5. Keep BLoCs **focused** on business logic only

You now know professional BLoC patterns used in production apps!

---

## Quick Quiz

**Q1.** What job does a repository do?

<details>
<summary>Answer</summary>
It fetches and stores data (from the internet, a database, files), so the bloc does not have to.
</details>

**Q2.** Why does using a repository make a bloc easier to test?

<details>
<summary>Answer</summary>
You can swap in a fake (mock) repository that returns whatever data you want, so you can test success and error cases without a real network.
</details>

**Q3.** Which package helps you write short bloc tests?

<details>
<summary>Answer</summary>
`bloc_test`, with its `blocTest(...)` helper.
</details>

---

## Assignment

### Problem 1: Whose job is it?

Sort each job into "Repository" or "BLoC":
1. Calling the internet to download a user.
2. Deciding to emit Loading then Loaded.
3. Reading rows from a database.

### Problem 2: Read a test

What does this test check?

```dart
blocTest<CounterBloc, int>(
  'emits [1] when Increment is added',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(Increment()),
  expect: () => [1],
);
```

### Problem 3: Why mock?

A friend says: "Why fake the repository in a test? Just call the real internet." Give one good reason mocking is better for a test.

---

## Assignment Answers

### Problem 1: Whose job is it?

1. **Repository** (it fetches data).
2. **BLoC** (it decides which states to emit).
3. **Repository** (it reads the data source).

### Problem 2: Read a test

It builds a fresh `CounterBloc`, adds one `Increment` event, and checks that the bloc emits exactly the state `1`. In plain words: "when I add Increment once, the count becomes 1."

### Problem 3: Why mock?

Any one of these is correct:
- Tests run fast and offline (no waiting on a real network).
- You can force an error on purpose to test the error path.
- Results are predictable, so the test does not break when real data changes.

---

## Navigation

⬅️ **Previous:** [BLoC Patterns](07b-BlocPatterns.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Choosing State Management](08-ChoosingStateManagement.md)
