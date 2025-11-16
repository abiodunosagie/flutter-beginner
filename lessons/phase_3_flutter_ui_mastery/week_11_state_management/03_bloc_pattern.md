# Week 11, Day 5-7: Bloc Pattern - Event-Driven State Management

## What is Bloc?

**Bloc** (Business Logic Component) is a predictable state management pattern that separates business logic from UI.

**Key philosophy:**
- **Events** → **Bloc** → **States**
- UI sends events → Bloc processes → UI rebuilds with new state

**Think of it like ordering food:**
- **Event** = Your order ("I want pizza")
- **Bloc** = Kitchen (processes your order)
- **State** = Food delivered to your table

---

## Bloc vs Riverpod

| Feature | Bloc | Riverpod |
|---------|------|----------|
| Pattern | Event-driven | Provider-based |
| Learning curve | Steeper | Gentler |
| Boilerplate | More | Less |
| Testing | Excellent | Good |
| Time travel debugging | ✓ Yes | ✗ No |
| Best for | Complex flows | Simple to moderate |

**When to use Bloc:**
- Complex business logic
- Need event tracking
- Want time-travel debugging
- Large enterprise apps

**When to use Riverpod:**
- Quick development
- Simpler state needs
- Moderate complexity

---

## Core Concepts

### 1. Events

**Events** = Things that happen (user actions, API responses)

```dart
abstract class CounterEvent {}

class IncrementPressed extends CounterEvent {}

class DecrementPressed extends CounterEvent {}
```

### 2. States

**States** = Data at a point in time

```dart
class CounterState {
  final int count;

  CounterState(this.count);
}
```

### 3. Bloc

**Bloc** = Converts events into states

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<IncrementPressed>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<DecrementPressed>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}
```

---

## Setup

### 1. Add Dependencies

**pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5  # For comparing states
```

Run:
```bash
flutter pub get
```

### 2. Basic Structure

```
lib/
├── bloc/
│   ├── counter_bloc.dart
│   ├── counter_event.dart
│   └── counter_state.dart
└── screens/
    └── counter_screen.dart
```

---

## Simple Counter Example

### Events

```dart
// counter_event.dart
abstract class CounterEvent {}

class IncrementPressed extends CounterEvent {}

class DecrementPressed extends CounterEvent {}

class ResetPressed extends CounterEvent {}
```

### States

```dart
// counter_state.dart
import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int count;

  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}
```

**Why Equatable?**
- Compares states by value, not reference
- Prevents unnecessary rebuilds
- `props` defines what to compare

### Bloc

```dart
// counter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    // Handle IncrementPressed
    on<IncrementPressed>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    // Handle DecrementPressed
    on<DecrementPressed>((event, emit) {
      emit(CounterState(state.count - 1));
    });

    // Handle ResetPressed
    on<ResetPressed>((event, emit) {
      emit(const CounterState(0));
    });
  }
}
```

**How it works:**
1. `super(CounterState(0))` = Initial state (count = 0)
2. `on<EventType>()` = Register event handler
3. `emit()` = Emit new state
4. `state.count` = Access current state

### UI

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.count}',
                  style: TextStyle(fontSize: 48),
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementPressed());
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(ResetPressed());
                  },
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementPressed());
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

**Key widgets:**
- **BlocProvider** = Provides Bloc to widget tree
- **BlocBuilder** = Rebuilds when state changes
- **context.read()** = Get Bloc to add events

---

## BlocBuilder vs BlocListener vs BlocConsumer

### BlocBuilder

Rebuilds UI when state changes:

```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('Count: ${state.count}');
  },
)
```

### BlocListener

Listens to state changes without rebuilding (for side effects):

```dart
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state.count == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You reached 10!')),
      );
    }
  },
  child: Text('Static content'),
)
```

**Use for:**
- Showing snackbars
- Navigation
- Dialogs
- Any one-time action

### BlocConsumer

Combines BlocBuilder + BlocListener:

```dart
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state.count < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Count is negative!')),
      );
    }
  },
  builder: (context, state) {
    return Text('${state.count}');
  },
)
```

---

## Complex States with Equatable

### Multiple State Properties

```dart
import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  const TodoState({
    required this.todos,
    this.isLoading = false,
    this.error,
  });

  // Copy with for immutability
  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading, error];
}
```

---

## Complete Example: Todo App with Bloc

### Models

```dart
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({String? id, String? title, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
```

### Events

```dart
abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;

  AddTodo(this.title);
}

class ToggleTodo extends TodoEvent {
  final String id;

  ToggleTodo(this.id);
}

class DeleteTodo extends TodoEvent {
  final String id;

  DeleteTodo(this.id);
}

class ClearCompleted extends TodoEvent {}
```

### States

```dart
import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get activeCount => todos.length - completedCount;

  @override
  List<Object> get props => [todos, isLoading];
}
```

### Bloc

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ClearCompleted>(_onClearCompleted);
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    if (event.title.trim().isEmpty) return;

    final newTodo = Todo(
      id: const Uuid().v4(),
      title: event.title.trim(),
    );

    emit(state.copyWith(
      todos: [...state.todos, newTodo],
    ));
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    emit(state.copyWith(
      todos: state.todos.where((todo) => todo.id != event.id).toList(),
    ));
  }

  void _onClearCompleted(ClearCompleted event, Emitter<TodoState> emit) {
    emit(state.copyWith(
      todos: state.todos.where((todo) => !todo.isCompleted).toList(),
    ));
  }
}
```

### UI

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TodoBloc(),
        child: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Todo App'),
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.completedCount > 0) {
                return TextButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(ClearCompleted());
                  },
                  child: Text(
                    'Clear Completed',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Input field
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      context.read<TodoBloc>().add(AddTodo(value));
                      _controller.clear();
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(AddTodo(_controller.text));
                    _controller.clear();
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Stats
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ${state.todos.length}'),
                    Text('Active: ${state.activeCount}'),
                    Text('Completed: ${state.completedCount}'),
                  ],
                ),
              );
            },
          ),

          // Todo list
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.todos.isEmpty) {
                  return Center(
                    child: Text(
                      'No todos yet!',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) {
                            context.read<TodoBloc>().add(ToggleTodo(todo.id));
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isCompleted ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<TodoBloc>().add(DeleteTodo(todo.id));
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Cubit - Simpler Alternative

**Cubit** = Simplified Bloc (no events, just functions)

### When to use Cubit:
- Simpler state changes
- No need to track events
- Less boilerplate

### Example: Counter with Cubit

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}

// Usage
BlocProvider(
  create: (context) => CounterCubit(),
  child: BlocBuilder<CounterCubit, int>(
    builder: (context, count) {
      return Text('$count');
    },
  ),
)

// Add events → Call methods
context.read<CounterCubit>().increment();
```

**Bloc vs Cubit:**

| Feature | Bloc | Cubit |
|---------|------|-------|
| Events | ✓ Yes | ✗ No |
| Functions | ✗ No | ✓ Yes |
| Boilerplate | More | Less |
| Event tracking | ✓ Yes | ✗ No |
| Use when | Complex logic | Simple state |

---

## BlocObserver - Global Monitoring

Track all Bloc events and state changes:

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType}, $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}
```

**Output:**
```
onCreate -- CounterBloc
onEvent -- CounterBloc, IncrementPressed
onChange -- CounterBloc, Change { currentState: 0, nextState: 1 }
```

---

## Async Events (API Calls)

### Events with Data

```dart
abstract class UserEvent {}

class FetchUsers extends UserEvent {}

class FetchUserById extends UserEvent {
  final int id;
  FetchUserById(this.id);
}
```

### States with Loading/Error

```dart
abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final List<User> users;

  UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object> get props => [message];
}
```

### Bloc with API

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final users = data.map((json) => User.fromJson(json)).toList();
        emit(UserLoaded(users));
      } else {
        emit(UserError('Failed to load users'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

### UI with Loading States

```dart
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is UserInitial) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<UserBloc>().add(FetchUsers());
          },
          child: Text('Load Users'),
        ),
      );
    } else if (state is UserLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is UserLoaded) {
      return ListView.builder(
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final user = state.users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      );
    } else if (state is UserError) {
      return Center(
        child: Text('Error: ${state.message}'),
      );
    }
    return SizedBox.shrink();
  },
)
```

---

## Testing Blocs

Blocs are easy to test!

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('CounterBloc', () {
    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = CounterBloc();
    });

    tearDown(() {
      counterBloc.close();
    });

    test('initial state is 0', () {
      expect(counterBloc.state, const CounterState(0));
    });

    blocTest<CounterBloc, CounterState>(
      'emits [1] when IncrementPressed is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(IncrementPressed()),
      expect: () => [const CounterState(1)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits [1, 2, 3] when IncrementPressed is added 3 times',
      build: () => CounterBloc(),
      act: (bloc) => bloc
        ..add(IncrementPressed())
        ..add(IncrementPressed())
        ..add(IncrementPressed()),
      expect: () => [
        const CounterState(1),
        const CounterState(2),
        const CounterState(3),
      ],
    );
  });
}
```

---

## Best Practices

### 1. One Bloc Per Feature

```dart
// Good
UserBloc - handles users
PostBloc - handles posts
AuthBloc - handles authentication

// Bad
AppBloc - handles everything
```

### 2. Keep Events Simple

```dart
// Good
class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

// Bad - too much logic in event
class AddTodoWithValidation extends TodoEvent {
  // Don't do this!
}
```

### 3. Immutable States

```dart
// Good
class TodoState {
  final List<Todo> todos;

  const TodoState({required this.todos});

  TodoState copyWith({List<Todo>? todos}) {
    return TodoState(todos: todos ?? this.todos);
  }
}

// Bad - mutable
class TodoState {
  List<Todo> todos;  // NOT final!
}
```

### 4. Use Equatable

```dart
// Good - prevents unnecessary rebuilds
class CounterState extends Equatable {
  final int count;
  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}

// Without Equatable - rebuilds even when same value
```

### 5. Dispose Blocs

```dart
@override
void dispose() {
  _counterBloc.close();
  super.dispose();
}
```

---

## Common Patterns

### 1. Multiple Blocs

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<UserBloc>(create: (context) => UserBloc()),
    BlocProvider<PostBloc>(create: (context) => PostBloc()),
    BlocProvider<CommentBloc>(create: (context) => CommentBloc()),
  ],
  child: MyApp(),
)
```

### 2. Bloc Communication

```dart
class PostBloc extends Bloc<PostEvent, PostState> {
  final UserBloc userBloc;

  PostBloc(this.userBloc) : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
      final currentUser = userBloc.state; // Access other bloc
      // Fetch posts for current user
    });
  }
}
```

### 3. Conditional Rebuilding

```dart
BlocBuilder<CounterBloc, CounterState>(
  buildWhen: (previous, current) {
    // Only rebuild if count changed by more than 5
    return (current.count - previous.count).abs() > 5;
  },
  builder: (context, state) {
    return Text('${state.count}');
  },
)
```

---

## Key Takeaways

1. **Bloc** = Event → Bloc → State
2. **Events** = Things that happen
3. **States** = Data snapshots
4. **Cubit** = Simpler alternative (no events)
5. **BlocBuilder** = Rebuild UI
6. **BlocListener** = Side effects
7. **Equatable** = Compare states properly
8. **Testing** = Easy with bloc_test
9. **Use for** complex flows and enterprise apps

---

## What's Next?

Tomorrow: **Advanced State Management Patterns**
- Bloc + Riverpod together
- State persistence
- Optimistic updates
- Undo/redo functionality

You've mastered event-driven state management! 🎯✨
