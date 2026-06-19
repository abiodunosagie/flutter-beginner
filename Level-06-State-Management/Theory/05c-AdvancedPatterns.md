# Riverpod Advanced Patterns: Pro Techniques

## The Big Idea In One Sentence

> A few pro tools round out Riverpod: providers can **depend on each other**, `ref.listen` runs **side effects** (like a snackbar) without rebuilding, `.select` rebuilds only on the part you care about, and `ref.invalidate`/`ref.refresh` force a reload.

These are the finishing touches that make Riverpod apps clean and efficient. (Some examples touch async, which is Level 8; focus on the pattern.)

---

## Combining Providers: Building Chains

Providers can depend on other providers, creating powerful combinations. It's like building with LEGO blocks - each piece connects to others!

### Simple Dependency

```dart
// Base provider
final userIdProvider = StateProvider<String>((ref) => '');

// Provider that depends on userId
final userProvider = FutureProvider<User?>((ref) async {
  // Watch another provider
  final userId = ref.watch(userIdProvider);

  if (userId.isEmpty) return null;

  return await fetchUser(userId);
});

// Provider that depends on user
final greetingProvider = Provider<String>((ref) {
  final userAsync = ref.watch(userProvider);

  return userAsync.when(
    loading: () => 'Loading...',
    error: (_, __) => 'Error loading user',
    data: (user) => user != null ? 'Hello, ${user.name}!' : 'Please log in',
  );
});
```

### Dependency Graph

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   userIdProvider: "user123"                         │
│           │                                         │
│           │ watches                                 │
│           ▼                                         │
│   userProvider: User(name: "John")                  │
│           │                                         │
│           │ watches                                 │
│           ▼                                         │
│   greetingProvider: "Hello, John!"                  │
│                                                     │
│   When userId changes:                              │
│   • userProvider auto-updates                       │
│   • greetingProvider auto-updates                   │
│   • All widgets watching them rebuild!              │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## ref.listen: Side Effects Without Rebuilding

Use `ref.listen` when you want to REACT to changes but NOT rebuild the widget. Perfect for showing snackbars, dialogs, or navigation!

### Basic Example

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for changes (doesn't rebuild widget)
    ref.listen<int>(counterProvider, (previous, next) {
      // previous = old value
      // next = new value

      if (next == 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You reached 10!')),
        );
      }
    });

    // Watch for displaying (rebuilds widget)
    final count = ref.watch(counterProvider);

    return Text('Count: $count');
  }
}
```

### ref.listen vs ref.watch

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ref.watch                                         │
│   ──────────                                        │
│   • Rebuilds widget when value changes              │
│   • Use for DISPLAYING data                         │
│   • Returns the value                               │
│                                                     │
│   ref.listen                                        │
│   ───────────                                       │
│   • Executes callback when value changes            │
│   • Does NOT rebuild widget                         │
│   • Use for SIDE EFFECTS                            │
│   • Doesn't return anything                         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Common Use Cases

```dart
// Navigate on state change
ref.listen<AuthState>(authProvider, (prev, next) {
  if (next.isLoggedIn) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
});

// Show error dialog
ref.listen<AsyncValue<User>>(userProvider, (prev, next) {
  if (next.hasError) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('${next.error}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
});

// Log analytics
ref.listen<int>(counterProvider, (prev, next) {
  print('Counter changed from $prev to $next');
  analytics.logEvent(name: 'counter_changed', parameters: {
    'previous': prev,
    'current': next,
  });
});
```

---

## .select: Optimize Rebuilds

Only rebuild when specific parts of state change. Like watching just the minute hand on a clock instead of the whole clock!

### The Problem

```dart
class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, required this.email});
}

final userProvider = StateProvider<User>((ref) => User(
  name: 'John',
  age: 25,
  email: 'john@email.com',
));

// BAD: Rebuilds even when only age changes
class NameDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    print('Rebuilt!');  // Prints when ANY field changes
    return Text(user.name);
  }
}
```

### The Solution: .select

```dart
// GOOD: Only rebuilds when name changes
class NameDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the name field
    final name = ref.watch(userProvider.select((user) => user.name));
    print('Rebuilt!');  // Only prints when name changes!
    return Text(name);
  }
}
```

### More Examples

```dart
// Watch only age
final age = ref.watch(userProvider.select((user) => user.age));

// Watch only email
final email = ref.watch(userProvider.select((user) => user.email));

// Watch a computed value
final isAdult = ref.watch(userProvider.select((user) => user.age >= 18));

// Watch multiple fields (returns a record)
final nameAndAge = ref.watch(userProvider.select((user) => (user.name, user.age)));
```

---

## ref.invalidate and ref.refresh: Force Updates

Sometimes you need to manually refresh data, like hitting the refresh button!

### ref.invalidate - "Mark as Stale"

```dart
// Marks provider as needing to be rebuilt
// Will rebuild next time it's accessed
ElevatedButton(
  onPressed: () {
    ref.invalidate(userProvider);
    // Provider will refetch next time it's watched
  },
  child: Text('Invalidate'),
)
```

### ref.refresh - "Invalidate and Get New Value Now"

```dart
// Invalidates AND immediately gets new value
ElevatedButton(
  onPressed: () async {
    // For FutureProvider, use .future to get the actual Future
    final newUser = await ref.refresh(userProvider.future);
    print('New user: ${newUser.name}');
  },
  child: Text('Refresh Now'),
)
```

### Visual Comparison

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ref.invalidate(provider)                          │
│   ─────────────────────────                         │
│   • Marks provider as "needs refresh"               │
│   • Doesn't immediately refetch                     │
│   • Refetches when next accessed                    │
│                                                     │
│   ref.refresh(provider)                             │
│   ──────────────────────                            │
│   • Invalidates AND immediately refetches           │
│   • Returns the new value                           │
│   • Use when you need data right away               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Testing Riverpod Providers

One of Riverpod's biggest strengths is easy testing!

### Basic Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('counter increments', () {
    // Create a container (like ProviderScope for tests)
    final container = ProviderContainer();

    // Read initial value
    expect(container.read(counterProvider), 0);

    // Modify value
    container.read(counterProvider.notifier).state++;

    // Check new value
    expect(container.read(counterProvider), 1);

    // Clean up
    container.dispose();
  });
}
```

### Override Providers for Testing

```dart
test('override provider with fake data', () {
  final container = ProviderContainer(
    overrides: [
      // Replace real provider with fake data
      userProvider.overrideWithValue(
        AsyncValue.data(User(name: 'Test User', age: 30)),
      ),
    ],
  );

  final user = container.read(userProvider).value;
  expect(user?.name, 'Test User');

  container.dispose();
});
```

### Test with Dependencies

```dart
test('dependent providers update correctly', () {
  final container = ProviderContainer();

  // Set base provider
  container.read(userNameProvider.notifier).state = 'Alice';

  // Check dependent provider
  final greeting = container.read(greetingProvider);
  expect(greeting, 'Hello, Alice!');

  container.dispose();
});
```

---

## Complete Todo App Example

Let's build a complete todo app using all the patterns we've learned!

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────
// Models
// ─────────────────────────────────────
class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, this.completed = false});

  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

// ─────────────────────────────────────
// State Notifier
// ─────────────────────────────────────
class TodosNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];

  void add(String title) {
    state = [
      ...state,
      Todo(id: DateTime.now().toString(), title: title),
    ];
  }

  void toggle(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

// ─────────────────────────────────────
// Providers
// ─────────────────────────────────────
final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(() {
  return TodosNotifier();
});

// Computed: completed count
final completedCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((t) => t.completed).length;
});

// Computed: pending count
final pendingCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((t) => !t.completed).length;
});

// Filter
enum TodoFilter { all, completed, pending }

final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

// Computed: filtered todos
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  final filter = ref.watch(filterProvider);

  switch (filter) {
    case TodoFilter.completed:
      return todos.where((t) => t.completed).toList();
    case TodoFilter.pending:
      return todos.where((t) => !t.completed).toList();
    case TodoFilter.all:
    default:
      return todos;
  }
});

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(const ProviderScope(child: TodoApp()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Todo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TodoPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    final completed = ref.watch(completedCountProvider);
    final pending = ref.watch(pendingCountProvider);
    final currentFilter = ref.watch(filterProvider);

    // Listen for achievements
    ref.listen<int>(completedCountProvider, (prev, next) {
      if (next > 0 && next % 5 == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Achievement: $next tasks completed!')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Todos'),
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Completed: $completed'),
                Text('Pending: $pending'),
              ],
            ),
          ),

          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: TodoFilter.values.map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(filter.name.toUpperCase()),
                    selected: currentFilter == filter,
                    onSelected: (_) {
                      ref.read(filterProvider.notifier).state = filter;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Todo list
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('No todos yet!'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (_) {
                            ref.read(todosProvider.notifier).toggle(todo.id);
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
                            ref.read(todosProvider.notifier).remove(todo.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
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
                  ref.read(todosProvider.notifier).add(controller.text);
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

## Summary of Advanced Patterns

| Pattern | Purpose | Example |
|---------|---------|---------|
| Provider dependencies | Chain providers together | `userProvider` watches `userIdProvider` |
| `ref.listen` | Side effects without rebuilding | Show snackbar, navigate |
| `.select` | Optimize rebuilds | Only rebuild when name changes |
| `ref.invalidate` | Mark for refresh | Refresh on pull-to-refresh |
| `ref.refresh` | Immediately refresh | Force reload data |
| Testing | Easy provider testing | Override with fake data |

---

## Key Takeaways

1. **Combine providers** to build powerful state chains
2. Use **ref.listen** for side effects (dialogs, navigation)
3. Use **.select** to prevent unnecessary rebuilds
4. Use **ref.invalidate/refresh** to force updates
5. **Testing** providers is super easy with `ProviderContainer`

These patterns will help you build professional, scalable Flutter apps with Riverpod!

---

## Quick Quiz

**Q1.** What is `ref.listen` for?

<details>
<summary>Answer</summary>
Running a side effect when a provider changes (show a snackbar, navigate, log), without rebuilding the widget. Use it in `build`, but it does not return a value to display.
</details>

**Q2.** How is `.select` different from a plain `ref.watch`?

<details>
<summary>Answer</summary>
`.select` rebuilds only when the specific part you pick changes, instead of on any change to the whole provider.
</details>

**Q3.** What is the difference between `ref.invalidate` and `ref.refresh`?

<details>
<summary>Answer</summary>
`invalidate` marks the provider as stale so it rebuilds next time it is read; `refresh` invalidates **and** immediately gives you the new value.
</details>

---

## Assignment

These are about choosing the right tool (mostly conceptual).

### Problem 1: Pick the tool

Which Riverpod tool fits each job: provider dependency, `ref.listen`, `.select`, or `ref.refresh`?

1. Show a snackbar when an error value appears.
2. Rebuild a widget only when the user's **name** changes, not their whole profile.
3. A "filtered list" that depends on both a "search text" provider and a "items" provider.
4. A pull-to-refresh that reloads the data now.

### Problem 2: ref.listen vs ref.watch

You want to navigate to a new screen when `loggedInProvider` becomes true. Should you use `ref.watch` or `ref.listen`? Why?

### Problem 3: Select for performance

A `userProvider` holds name, age, and email. Write the line that rebuilds a widget only when `name` changes.

---

## Assignment Answers

### Problem 1: Pick the tool

1. Snackbar on error -> `ref.listen` (a side effect, no rebuild needed).
2. Rebuild only on name change -> `.select`.
3. Filtered list depending on two providers -> a provider dependency (a new provider that watches both).
4. Pull-to-refresh reload now -> `ref.refresh`.

### Problem 2: ref.listen vs ref.watch

Use `ref.listen`. Navigating is a **side effect**, not something you display. `ref.watch` is for building UI from a value; if you tried to navigate inside `build`, it would fire during a rebuild, which is wrong. `ref.listen` runs your callback only when the value actually changes, which is exactly when you want to navigate.

### Problem 3: Select for performance

```dart
final name = ref.watch(userProvider.select((u) => u.name));
```

This rebuilds the widget only when `name` changes, ignoring changes to `age` or `email`.

---

## Navigation

⬅️ **Previous:** [Modifiers](05b-Modifiers.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [BLoC Introduction](06a-BlocIntro.md)
