# BLoC Advanced: Professional Patterns

Now let's explore advanced BLoC patterns used in production apps!

---

## Async Events with BLoC

Most real apps need to handle async operations (API calls, database):

```dart
// Events
abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// BLoC with async
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    // Show loading
    emit(UserLoading());

    try {
      // Fetch data
      final user = await repository.getUser(event.userId);
      // Show success
      emit(UserLoaded(user));
    } catch (e) {
      // Show error
      emit(UserError(e.toString()));
    }
  }
}
```

### Using in Widget

```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          return const Text('Press button to load user');
        }
        if (state is UserLoading) {
          return const CircularProgressIndicator();
        }
        if (state is UserLoaded) {
          return Text('Hello, ${state.user.name}!');
        }
        if (state is UserError) {
          return Column(
            children: [
              Text('Error: ${state.message}'),
              ElevatedButton(
                onPressed: () {
                  context.read<UserBloc>().add(LoadUser('123'));
                },
                child: const Text('Retry'),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
```

---

## Equatable: Better State Comparison

By default, BLoC uses `==` to compare states. Use Equatable for reliable comparisons:

```dart
import 'package:equatable/equatable.dart';

// Add equatable to pubspec.yaml
// equatable: ^2.0.5

// Events with Equatable
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);

  @override
  List<Object?> get props => [title];  // Compare by title
}

// States with Equatable
abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];  // Compare by todos list
}
```

### Why Equatable?

```
WITHOUT Equatable:
──────────────────
State A: TodoLoaded([Todo1, Todo2])
State B: TodoLoaded([Todo1, Todo2])

A == B ?  FALSE! (Different objects in memory)
Result: Widget rebuilds even though data is the same!


WITH Equatable:
───────────────
State A: TodoLoaded([Todo1, Todo2])
State B: TodoLoaded([Todo1, Todo2])

A == B ?  TRUE! (Equatable compares by props)
Result: No unnecessary rebuilds!
```

---

## BLoC to BLoC Communication

Sometimes BLoCs need to communicate:

### Method 1: Stream Subscription

```dart
class CartBloc extends Bloc<CartEvent, CartState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  CartBloc({required this.authBloc}) : super(CartInitial()) {
    // Listen to AuthBloc
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthLoggedOut) {
        add(ClearCart());  // Clear cart when user logs out
      }
    });

    on<ClearCart>((event, emit) {
      emit(CartInitial());
    });
  }

  @override
  Future<void> close() {
    authSubscription.cancel();  // Clean up!
    return super.close();
  }
}
```

### Method 2: BlocListener in Widget

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthLoggedOut) {
      context.read<CartBloc>().add(ClearCart());
    }
  },
  child: MyWidget(),
)
```

---

## Transforming Events

Control how events are processed:

### Debouncing (Wait for user to stop typing)

```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';
// Add: bloc_concurrency: ^0.2.1

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final results = await searchRepository.search(event.query);
    emit(SearchLoaded(results));
  }
}

// Custom debounce transformer
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}
```

### Throttling (Limit frequency)

```dart
on<ButtonPressed>(
  _onButtonPressed,
  transformer: throttle(const Duration(seconds: 1)),
);
```

### Sequential (One at a time)

```dart
on<LoadData>(
  _onLoadData,
  transformer: sequential(),  // Process one event at a time
);
```

### Droppable (Ignore while processing)

```dart
on<LoadData>(
  _onLoadData,
  transformer: droppable(),  // Drop events while one is processing
);
```

---

## Cubit: Simplified BLoC

For simpler cases, use `Cubit` - like BLoC but without events:

```dart
// Cubit - No events needed!
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}

// Usage in widget
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: BlocBuilder<CounterCubit, int>(
        builder: (context, count) {
          return Column(
            children: [
              Text('$count'),
              ElevatedButton(
                onPressed: () => context.read<CounterCubit>().increment(),
                child: Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### BLoC vs Cubit

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   CUBIT                        BLOC                 │
│   ─────                        ────                 │
│                                                     │
│   • Simpler                    • More structured    │
│   • Call methods directly      • Event-driven       │
│   • Less boilerplate           • Better traceability│
│   • Good for simple state      • Good for complex   │
│                                                     │
│   cubit.increment()            bloc.add(Increment())│
│                                                     │
│   When to use:                 When to use:         │
│   • Simple counters            • Complex flows      │
│   • Toggle states              • Need event history │
│   • Basic forms                • Advanced debugging │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Repository Pattern with BLoC

Separate data fetching from BLoC:

```dart
// Repository - handles data
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> updateUser(User user);
}

class ApiUserRepository implements UserRepository {
  final ApiClient client;

  ApiUserRepository(this.client);

  @override
  Future<User> getUser(String id) async {
    final response = await client.get('/users/$id');
    return User.fromJson(response);
  }

  @override
  Future<void> updateUser(User user) async {
    await client.put('/users/${user.id}', user.toJson());
  }
}

// BLoC - uses repository
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
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

// Provide with repository
BlocProvider(
  create: (context) => UserBloc(
    repository: context.read<UserRepository>(),
  ),
  child: UserPage(),
)
```

---

## Testing BLoC

BLoC is very easy to test:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

// Add to dev_dependencies: bloc_test: ^9.1.5

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
      'emits [0] when Reset is added after incrementing',
      build: () => CounterBloc(),
      seed: () => 5,  // Start from 5
      act: (bloc) => bloc.add(Reset()),
      expect: () => [0],
    );
  });
}
```

---

## Complete Example: Todo App with BLoC

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
// Events
// ─────────────────────────────────────
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

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

class FilterChanged extends TodoEvent {
  final TodoFilter filter;
  FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

enum TodoFilter { all, completed, pending }

// ─────────────────────────────────────
// State
// ─────────────────────────────────────
class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoFilter filter;

  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
  });

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.completed:
        return todos.where((t) => t.completed).toList();
      case TodoFilter.pending:
        return todos.where((t) => !t.completed).toList();
      case TodoFilter.all:
      default:
        return todos;
    }
  }

  int get completedCount => todos.where((t) => t.completed).length;
  int get pendingCount => todos.where((t) => !t.completed).length;

  TodoState copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [todos, filter];
}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<FilterChanged>(_onFilterChanged);
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: event.title,
    );
    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.where((t) => t.id != event.id).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  void _onFilterChanged(FilterChanged event, Emitter<TodoState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    BlocProvider(
      create: (_) => TodoBloc(),
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Todo',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const TodoPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Todo'),
      ),
      body: Column(
        children: [
          // Stats
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.orange.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Completed: ${state.completedCount}'),
                    Text('Pending: ${state.pendingCount}'),
                  ],
                ),
              );
            },
          ),

          // Filters
          BlocBuilder<TodoBloc, TodoState>(
            buildWhen: (prev, curr) => prev.filter != curr.filter,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: TodoFilter.values.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(filter.name.toUpperCase()),
                        selected: state.filter == filter,
                        onSelected: (_) {
                          context.read<TodoBloc>().add(FilterChanged(filter));
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          // Todo List
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                final todos = state.filteredTodos;

                if (todos.isEmpty) {
                  return const Center(
                    child: Text('No todos yet!'),
                  );
                }

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
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
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<TodoBloc>().add(DeleteTodo(todo.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter todo'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<TodoBloc>().add(AddTodo(controller.text));
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## Summary

| Concept | Purpose |
|---------|---------|
| Async Events | Handle API calls, database |
| Equatable | Better state comparison |
| Event Transformers | Debounce, throttle, sequential |
| Cubit | Simplified BLoC without events |
| Repository Pattern | Separate data from logic |
| BLoC Testing | blocTest for easy testing |

---

## Quick Quiz

**Q1:** What's the difference between BLoC and Cubit?

<details>
<summary>Answer</summary>

- **BLoC**: Uses Events and States. More structured, better for complex flows and debugging. Add events with `bloc.add(Event())`.
- **Cubit**: Uses only States. Simpler, less boilerplate. Call methods directly like `cubit.increment()`.

Use Cubit for simple state, BLoC for complex flows.

</details>

**Q2:** Why use Equatable with BLoC?

<details>
<summary>Answer</summary>

Equatable provides value equality comparison. Without it, BLoC compares states by reference, which can cause unnecessary rebuilds when two states have the same data but are different objects. With Equatable, states are compared by their properties.

</details>

---

**Next:** Learn how to choose the right state management solution!

---

**Continue to:** `08-ChoosingStateManagement.md`
