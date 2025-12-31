# Using BLoC in Widgets: Connecting Kitchen to Dining Room

Now that we've built our "kitchen" (the BLoC), let's connect it to the "dining room" (the UI) so customers can place orders and get their food!

---

## The Two Steps

Using BLoC in your app requires two steps:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   STEP 1: Provide the BLoC                          │
│   Make it available to widgets                      │
│   (Open the restaurant)                             │
│                                                     │
│   STEP 2: Consume the BLoC                          │
│   • Display state (BlocBuilder)                     │
│   • Send events (context.read)                      │
│   • React to changes (BlocListener)                 │
│   (Let customers order and eat)                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Step 1: Providing the BLoC

Use `BlocProvider` to make your BLoC available to widgets:

### At App Level (Global)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => CounterBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}
```

### At Screen Level (Local)

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: CounterPage(),
    );
  }
}
```

### Multiple BLoCs

```dart
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => SettingsBloc()),
      ],
      child: MyApp(),
    ),
  );
}
```

---

## Step 2: Displaying State with BlocBuilder

`BlocBuilder` rebuilds your UI when state changes. It's like watching the kitchen and updating the menu when a new dish is ready!

### Basic Example

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Center(
        // BlocBuilder rebuilds when state changes
        child: BlocBuilder<CounterBloc, int>(
          //                ^^^^^^^^^^^  ^^^
          //                BLoC type    State type
          builder: (context, count) {
            //                ^^^^
            //            Current state
            return Text(
              '$count',
              style: TextStyle(fontSize: 72),
            );
          },
        ),
      ),
    );
  }
}
```

### Visual Flow

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   State changes: 0 → 1 → 2 → 3                      │
│                                                     │
│   BlocBuilder listens:                              │
│   • State = 0  → build() called → Shows "0"         │
│   • State = 1  → build() called → Shows "1"         │
│   • State = 2  → build() called → Shows "2"         │
│   • State = 3  → build() called → Shows "3"         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Sending Events: Adding Events to BLoC

Use `context.read<T>().add()` to send events to the BLoC:

### Basic Example

```dart
ElevatedButton(
  onPressed: () {
    // Get BLoC and send event
    context.read<CounterBloc>().add(Increment());
  },
  child: Icon(Icons.add),
)
```

### Alternative: BlocProvider.of

```dart
ElevatedButton(
  onPressed: () {
    // Older style (still works)
    BlocProvider.of<CounterBloc>(context).add(Increment());
  },
  child: Icon(Icons.add),
)
```

---

## Complete Counter Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// Events
// ─────────────────────────────────────
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) {
      if (state > 0) emit(state - 1);
    });
    on<Reset>((event, emit) => emit(0));
  }
}

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC Counter'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<CounterBloc>().add(Reset());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:'),
            SizedBox(height: 20),

            // Display state
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) {
                return Text(
                  '$count',
                  style: TextStyle(fontSize: 72),
                );
              },
            ),

            SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Decrement());
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Increment());
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

---

## BlocListener: React to State Changes

Use `BlocListener` when you need to DO something in response to state changes (not display something). Like getting a notification when food is ready!

### Common Use Cases

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   BlocListener is for:                              │
│   • Show snackbars                                  │
│   • Navigate to another screen                      │
│   • Show dialogs                                    │
│   • Log analytics                                   │
│   • Play sounds                                     │
│                                                     │
│   NOT for displaying data on screen!                │
│   (Use BlocBuilder for that)                        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Example: Show Snackbar

```dart
BlocListener<CounterBloc, int>(
  listener: (context, count) {
    if (count == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You reached 10!')),
      );
    }
  },
  child: CounterPage(),
)
```

### Example: Navigate on State

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
    if (state is AuthFailure) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(state.error),
        ),
      );
    }
  },
  child: LoginForm(),
)
```

---

## BlocConsumer: Builder + Listener Combined

When you need BOTH to display state AND react to changes:

```dart
BlocConsumer<CounterBloc, int>(
  // React to changes (side effects)
  listener: (context, count) {
    if (count == 10) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Achievement!'),
          content: Text('You reached 10!'),
        ),
      );
    }
  },

  // Build UI
  builder: (context, count) {
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () {
            context.read<CounterBloc>().add(Increment());
          },
          child: Text('+'),
        ),
      ],
    );
  },
)
```

---

## When to Use Which?

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   BlocBuilder                                       │
│   ────────────                                      │
│   • Display data on screen                          │
│   • Text, icons, colors based on state              │
│   • Rebuilds widget when state changes              │
│                                                     │
│   Example: Show counter value                       │
│                                                     │
│   ──────────────────────────────────────────────    │
│                                                     │
│   BlocListener                                      │
│   ──────────────                                    │
│   • Show snackbars                                  │
│   • Navigate to screens                             │
│   • Show dialogs                                    │
│   • Log events                                      │
│   • Does NOT rebuild widget                         │
│                                                     │
│   Example: Navigate when logged in                  │
│                                                     │
│   ──────────────────────────────────────────────    │
│                                                     │
│   BlocConsumer                                      │
│   ──────────────                                    │
│   • When you need BOTH                              │
│   • Display data AND react to changes               │
│                                                     │
│   Example: Show count AND alert at 10               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Accessing BLoCs: context.read vs context.watch

### context.read<T>() - "Get BLoC Once"

```dart
// Good for sending events (onPressed, etc.)
ElevatedButton(
  onPressed: () {
    context.read<CounterBloc>().add(Increment());
  },
  child: Text('+'),
)
```

### context.watch<T>() - "Listen for Changes"

```dart
// Good in build() method (rebuilds on change)
@override
Widget build(BuildContext context) {
  final count = context.watch<CounterBloc>().state;
  return Text('$count');
}
```

### Comparison

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   context.read<T>()                                 │
│   ──────────────────                                │
│   • Gets BLoC once                                  │
│   • No listening, no rebuilds                       │
│   • Use in callbacks (onPressed)                    │
│   • For ACTIONS (adding events)                     │
│                                                     │
│   context.watch<T>()                                │
│   ───────────────────                               │
│   • Listens for changes                             │
│   • Widget rebuilds when state changes              │
│   • Use in build() method                           │
│   • For DISPLAYING state                            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Advanced: buildWhen and listenWhen

Control when to rebuild or listen:

### buildWhen (Optimize Rebuilds)

```dart
BlocBuilder<CounterBloc, int>(
  // Only rebuild when count is even
  buildWhen: (previous, current) {
    return current % 2 == 0;
  },
  builder: (context, count) {
    return Text('Even count: $count');
  },
)
```

### listenWhen (Optimize Listening)

```dart
BlocListener<CounterBloc, int>(
  // Only listen when count > 5
  listenWhen: (previous, current) {
    return current > 5;
  },
  listener: (context, count) {
    print('Count is high: $count');
  },
  child: MyWidget(),
)
```

---

## Complete Todo Example with All Concepts

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// Models
// ─────────────────────────────────────
class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, this.completed = false});

  Todo copyWith({bool? completed}) {
    return Todo(id: id, title: title, completed: completed ?? this.completed);
  }
}

// ─────────────────────────────────────
// Events
// ─────────────────────────────────────
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

// ─────────────────────────────────────
// State
// ─────────────────────────────────────
class TodoState {
  final List<Todo> todos;

  TodoState({this.todos = const []});

  int get completedCount => todos.where((t) => t.completed).length;
  int get pendingCount => todos.where((t) => !t.completed).length;
}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    final todo = Todo(id: DateTime.now().toString(), title: event.title);
    emit(TodoState(todos: [...state.todos, todo]));
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    emit(TodoState(todos: updatedTodos));
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.where((t) => t.id != event.id).toList();
    emit(TodoState(todos: updatedTodos));
  }
}

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    BlocProvider(
      create: (_) => TodoBloc(),
      child: MyApp(),
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
      appBar: AppBar(title: Text('BLoC Todos')),
      body: BlocConsumer<TodoBloc, TodoState>(
        // Listener: React to changes
        listener: (context, state) {
          if (state.completedCount > 0 && state.completedCount % 5 == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${state.completedCount} tasks done!')),
            );
          }
        },

        // Builder: Display UI
        builder: (context, state) {
          return Column(
            children: [
              // Stats
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.blue.shade100,
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

| Concept | Purpose | Usage |
|---------|---------|-------|
| `BlocProvider` | Make BLoC available | Wrap app or screen |
| `BlocBuilder` | Display state | Rebuilds when state changes |
| `BlocListener` | React to state | Side effects (no rebuild) |
| `BlocConsumer` | Both builder + listener | Display + react |
| `context.read<T>()` | Get BLoC once | For sending events |
| `context.watch<T>()` | Listen for changes | For displaying state |

Now you know how to connect your BLoC to your UI! Next, we'll learn advanced async patterns.

---

## Navigation

⬅️ **Previous:** [Creating BLoCs](06b-CreatingBloc.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Async with BLoC](07a-AsyncBloc.md)
