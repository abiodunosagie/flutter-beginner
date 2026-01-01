# Riverpod Advanced: Powerful Patterns

Now let's explore advanced Riverpod patterns that make complex apps manageable!

---

## AsyncValue: Handling Async State

When using `FutureProvider` or `StreamProvider`, Riverpod gives you `AsyncValue` - a special wrapper that handles loading, error, and data states:

```dart
// Define a FutureProvider
final userProvider = FutureProvider<User>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return User(name: 'John', age: 25);
});

// Use it in a widget
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    // Handle all states with .when()
    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (user) => Text('Welcome, ${user.name}!'),
    );
  }
}
```

### AsyncValue States Explained

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Future starts                                     │
│        │                                            │
│        ▼                                            │
│   ┌─────────────┐                                   │
│   │  LOADING    │  ← Show spinner                   │
│   └─────────────┘                                   │
│        │                                            │
│        ├──── Success ────┐                          │
│        │                 │                          │
│        ▼                 ▼                          │
│   ┌─────────────┐   ┌─────────────┐                 │
│   │   ERROR     │   │    DATA     │                 │
│   │  (failed)   │   │  (success)  │                 │
│   └─────────────┘   └─────────────┘                 │
│        │                 │                          │
│        ▼                 ▼                          │
│   Show error msg    Show the data                   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Other Ways to Handle AsyncValue

```dart
// Method 1: .when() - Handle all cases
userAsync.when(
  loading: () => LoadingWidget(),
  error: (e, s) => ErrorWidget(e),
  data: (user) => UserCard(user),
);

// Method 2: .maybeWhen() - Handle some cases
userAsync.maybeWhen(
  data: (user) => UserCard(user),
  orElse: () => LoadingWidget(),  // Loading and error
);

// Method 3: .value - Get data directly (might be null!)
final user = userAsync.value;
if (user != null) {
  // Use user
}

// Method 4: Check states manually
if (userAsync.isLoading) {
  return LoadingWidget();
}
if (userAsync.hasError) {
  return ErrorWidget(userAsync.error);
}
return UserCard(userAsync.value!);
```

---

## Family Providers: Dynamic Parameters

Sometimes you need a provider that takes parameters:

```dart
// Without family: Can't pass parameters!
final userProvider = FutureProvider<User>((ref) async {
  // How do I know WHICH user to fetch??
});

// With family: Pass parameters!
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return await fetchUser(userId);  // Now we know which user!
});

// Use with parameter
class UserProfile extends ConsumerWidget {
  final String userId;

  const UserProfile({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass the parameter
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
      data: (user) => Text('User: ${user.name}'),
    );
  }
}
```

### Multiple Parameters

```dart
// Use a record (Dart 3) or class for multiple params
final productProvider = FutureProvider.family<Product, ({String category, int id})>(
  (ref, params) async {
    return fetchProduct(params.category, params.id);
  },
);

// Usage
ref.watch(productProvider((category: 'electronics', id: 123)));
```

---

## AutoDispose: Clean Up Resources

By default, providers stay alive forever. Use `autoDispose` to clean them up when not used:

```dart
// Without autoDispose: Stays in memory forever
final dataProvider = FutureProvider<Data>((ref) async {
  return fetchData();  // Cached forever!
});

// With autoDispose: Cleaned up when no one watches
final dataProvider = FutureProvider.autoDispose<Data>((ref) async {
  return fetchData();  // Cleaned up when widget is disposed!
});
```

### When to Use AutoDispose

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   USE autoDispose when:                             │
│   • Data is screen-specific                         │
│   • Fetching data that changes often                │
│   • Using websockets or streams                     │
│   • Memory is a concern                             │
│                                                     │
│   DON'T use autoDispose when:                       │
│   • Data should be cached (user info)               │
│   • Multiple screens share the data                 │
│   • Data rarely changes                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Keeping AutoDispose Alive Temporarily

```dart
final dataProvider = FutureProvider.autoDispose<Data>((ref) async {
  // Keep alive for 5 seconds after last listener
  ref.keepAlive();

  // Or cancel keep alive after some time
  final link = ref.keepAlive();
  Future.delayed(Duration(seconds: 30), () {
    link.close();  // Now can be disposed
  });

  return fetchData();
});
```

---

## Notifier and AsyncNotifier (Riverpod 2.0+)

The newer way to write state notifiers:

### Notifier (Sync State)

```dart
// Define the notifier
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;  // Initial state

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// Create provider
final counterProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});

// Use in widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          child: Text('Add'),
        ),
      ],
    );
  }
}
```

### AsyncNotifier (Async State)

```dart
// Define async notifier
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    // This runs when provider is first accessed
    return await fetchUser();
  }

  Future<void> updateName(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await updateUserName(name);
      return user;
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchUser());
  }
}

// Create provider
final userProvider = AsyncNotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

// Use in widget
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Column(
        children: [
          Text('Error: $e'),
          ElevatedButton(
            onPressed: () => ref.read(userProvider.notifier).refresh(),
            child: Text('Retry'),
          ),
        ],
      ),
      data: (user) => Text('Hello, ${user.name}'),
    );
  }
}
```

---

## Combining Providers

Providers can depend on each other:

```dart
// Base providers
final userIdProvider = StateProvider<String>((ref) => '');
final isLoggedInProvider = StateProvider<bool>((ref) => false);

// Dependent provider - watches others
final userProvider = FutureProvider<User?>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return null;

  final userId = ref.watch(userIdProvider);
  if (userId.isEmpty) return null;

  return await fetchUser(userId);
});

// Computed provider
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
isLoggedInProvider ──┐
                     │
                     ▼
userIdProvider ────► userProvider ────► greetingProvider
                         │
                         ▼
                   (fetches from API)
```

---

## ref.listen: Side Effects

Use `ref.listen` to react to changes without rebuilding:

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for changes and show snackbar
    ref.listen<int>(counterProvider, (previous, next) {
      if (next == 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You reached 10!')),
        );
      }
    });

    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

### Common Use Cases for ref.listen

```dart
// Show error message
ref.listen<AsyncValue<User>>(userProvider, (prev, next) {
  if (next.hasError) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('${next.error}'),
      ),
    );
  }
});

// Navigate on state change
ref.listen<AuthState>(authProvider, (prev, next) {
  if (next.isLoggedIn) {
    Navigator.pushReplacement(context, HomeRoute());
  }
});

// Log changes
ref.listen<int>(counterProvider, (prev, next) {
  print('Counter changed from $prev to $next');
});
```

---

## Select: Optimize Rebuilds

Only rebuild when specific parts change:

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

// Without select: Rebuilds when ANY field changes
class BadWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Text(user.name);  // Rebuilds for age/email changes too!
  }
}

// With select: Only rebuilds when name changes
class GoodWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(userProvider.select((user) => user.name));
    return Text(name);  // Only rebuilds when name changes!
  }
}
```

---

## Invalidate and Refresh

### ref.invalidate - Mark as Stale

```dart
// Force provider to rebuild next time it's accessed
ElevatedButton(
  onPressed: () {
    ref.invalidate(userProvider);  // Will re-fetch next time
  },
  child: Text('Refresh'),
)
```

### ref.refresh - Invalidate and Return New Value

```dart
// Invalidate AND immediately get new value
ElevatedButton(
  onPressed: () async {
    final newUser = await ref.refresh(userProvider.future);
    print('New user: ${newUser.name}');
  },
  child: Text('Refresh'),
)
```

---

## Testing Riverpod

One of Riverpod's biggest advantages is easy testing:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('counter increments', () {
    // Create a container (like ProviderScope)
    final container = ProviderContainer();

    // Read the initial value
    expect(container.read(counterProvider), 0);

    // Modify the value
    container.read(counterProvider.notifier).state++;

    // Check the new value
    expect(container.read(counterProvider), 1);

    // Clean up
    container.dispose();
  });

  test('override provider for testing', () {
    // Override with fake data
    final container = ProviderContainer(
      overrides: [
        userProvider.overrideWithValue(
          AsyncValue.data(User(name: 'Test', age: 30)),
        ),
      ],
    );

    final user = container.read(userProvider).value;
    expect(user?.name, 'Test');
  });
}
```

---

## Complete Example: Todo App with Riverpod

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
class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void add(String title) {
    state = [
      ...state,
      Todo(
        id: DateTime.now().toString(),
        title: title,
      ),
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
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

// Computed providers
final completedCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((t) => t.completed).length;
});

final pendingCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((t) => !t.completed).length;
});

// Filter provider
enum TodoFilter { all, completed, pending }

final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

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

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    final completed = ref.watch(completedCountProvider);
    final pending = ref.watch(pendingCountProvider);
    final currentFilter = ref.watch(filterProvider);

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
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter todo'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(todosProvider.notifier).add(controller.text);
                  Navigator.pop(context);
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
| `AsyncValue` | Handle loading/error/data states |
| `.family` | Providers with parameters |
| `.autoDispose` | Clean up when not used |
| `Notifier` | Modern sync state class |
| `AsyncNotifier` | Modern async state class |
| `ref.listen` | React to changes (side effects) |
| `.select` | Optimize rebuilds |
| `ref.invalidate` | Force refresh |

---

## Quick Quiz

**Q1:** How do you handle loading and error states with FutureProvider?

<details>
<summary>Answer</summary>

Use the `when` method on AsyncValue:
```dart
ref.watch(provider).when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
  data: (data) => Text('Data: $data'),
);
```

</details>

**Q2:** When would you use `.family`?

<details>
<summary>Answer</summary>

Use `.family` when you need to pass parameters to a provider, like fetching a specific user by ID:
```dart
final userProvider = FutureProvider.family<User, String>((ref, userId) {
  return fetchUser(userId);
});

// Usage: ref.watch(userProvider('user123'))
```

</details>

---

**Next:** Learn professional Riverpod patterns used in production apps!

---

**Continue to:** `05b-RiverpodProPatterns.md`
