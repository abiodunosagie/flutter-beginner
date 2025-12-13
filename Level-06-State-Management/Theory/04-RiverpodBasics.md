# Riverpod Basics: Provider's Powerful Cousin

Riverpod (which is "Provider" rearranged!) is a more modern state management solution. Think of it as Provider 2.0 with superpowers!

---

## Why Riverpod?

Riverpod fixes several problems with Provider:

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│   PROVIDER PROBLEMS          RIVERPOD SOLUTIONS        │
│   ────────────────          ─────────────────          │
│                                                        │
│   ❌ Needs BuildContext      ✅ Works anywhere          │
│                                                        │
│   ❌ Runtime errors          ✅ Compile-time errors     │
│      ("Provider not found")     (caught before run)    │
│                                                        │
│   ❌ Hard to test            ✅ Easy to test            │
│                                                        │
│   ❌ Provider depends on     ✅ Providers are global    │
│      widget tree position       and independent        │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## Setting Up Riverpod

### Step 1: Add the Package

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
```

Run:
```bash
flutter pub get
```

### Step 2: Wrap Your App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // This is the ONLY setup needed!
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

That's it! Much simpler than Provider!

---

## The Big Difference: Providers Are Global

In Riverpod, providers are defined **outside** of widgets:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define provider GLOBALLY (outside any class)
final counterProvider = StateProvider<int>((ref) => 0);

// Now ANY widget can access it!
```

### Visualized

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   PROVIDER (old way)          RIVERPOD              │
│   ─────────────────          ────────               │
│                                                     │
│   Provider must be in        Providers are GLOBAL   │
│   widget tree                                       │
│                                                     │
│   ┌─────────────┐           final counterProvider   │
│   │ Provider    │           = StateProvider(...)    │
│   │   │         │                    │              │
│   │   ▼         │           Available everywhere!   │
│   │ App         │              │    │    │          │
│   │   │         │              ▼    ▼    ▼          │
│   │   ▼         │           ┌────┐┌────┐┌────┐      │
│   │ Widget      │           │ A  ││ B  ││ C  │      │
│   └─────────────┘           └────┘└────┘└────┘      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Provider Types in Riverpod

Riverpod has different provider types for different needs:

### 1. Provider (Simple Read-Only)

For values that don't change or are computed:

```dart
// A simple value
final greetingProvider = Provider<String>((ref) {
  return 'Hello, World!';
});

// A computed value
final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});
```

### 2. StateProvider (Simple Mutable State)

For simple values that change (like int, String, bool):

```dart
// Counter that can be modified
final counterProvider = StateProvider<int>((ref) => 0);

// Theme toggle
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// Selected item
final selectedIndexProvider = StateProvider<int>((ref) => 0);
```

### 3. StateNotifierProvider (Complex State)

For complex state with multiple operations:

```dart
// First, create a StateNotifier class
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);  // Initial state = 0

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
  void setValue(int value) => state = value;
}

// Then create the provider
final counterNotifierProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});
```

### 4. FutureProvider (Async Data)

For data from Futures (API calls, database, etc.):

```dart
final userProvider = FutureProvider<User>((ref) async {
  // Simulate API call
  await Future.delayed(Duration(seconds: 2));
  return User(name: 'John', age: 25);
});
```

### 5. StreamProvider (Real-time Data)

For data from Streams:

```dart
final timerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(
    Duration(seconds: 1),
    (count) => count,
  );
});
```

---

## Reading Providers

In Riverpod, widgets need to extend special classes to read providers:

### ConsumerWidget (StatelessWidget replacement)

```dart
// Instead of StatelessWidget, use ConsumerWidget
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //                               ^^^^^^^^^^
    // This 'ref' is how you access providers!

    final count = ref.watch(counterProvider);

    return Text('Count: $count');
  }
}
```

### ConsumerStatefulWidget (StatefulWidget replacement)

```dart
class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    // Access ref through 'ref' property
    final count = ref.watch(counterProvider);

    return Text('Count: $count');
  }
}
```

### Consumer Widget (For specific parts)

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final count = ref.watch(counterProvider);
        return Text('Count: $count');
      },
    );
  }
}
```

---

## ref.watch vs ref.read

Just like Provider, Riverpod has two ways to get data:

### ref.watch - Listen for Changes

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // watch = Rebuild when value changes
  final count = ref.watch(counterProvider);

  return Text('$count');  // Updates automatically!
}
```

### ref.read - Get Once, Don't Listen

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return ElevatedButton(
    onPressed: () {
      // read = Just get the value, don't listen
      ref.read(counterProvider.notifier).state++;
    },
    child: Text('Increment'),
  );
}
```

### Visual Comparison

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ref.watch(provider)                               │
│   ───────────────────                               │
│   • Listens for changes                             │
│   • Widget rebuilds when value changes              │
│   • Use in build() method                           │
│   • For DISPLAYING data                             │
│                                                     │
│   ref.read(provider)                                │
│   ──────────────────                                │
│   • Gets value once                                 │
│   • No listening, no rebuilds                       │
│   • Use in callbacks (onPressed, etc.)              │
│   • For ACTIONS/METHODS                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Complete Example: Counter with Riverpod

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────
// STEP 1: Define Providers (globally)
// ─────────────────────────────────────

// Simple counter
final counterProvider = StateProvider<int>((ref) => 0);

// Computed value that depends on counter
final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

// Check if counter is even
final isEvenProvider = Provider<bool>((ref) {
  final count = ref.watch(counterProvider);
  return count % 2 == 0;
});

// ─────────────────────────────────────
// STEP 2: Wrap App with ProviderScope
// ─────────────────────────────────────

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Counter',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// STEP 3: Use Providers in Widgets
// ─────────────────────────────────────

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WATCH these providers - rebuild when they change
    final count = ref.watch(counterProvider);
    final doubled = ref.watch(doubledProvider);
    final isEven = ref.watch(isEvenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count: $count',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'Doubled: $doubled',
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isEven ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEven ? 'EVEN' : 'ODD',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // READ to modify - don't watch in callbacks!
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
                  },
                  child: const Icon(Icons.add),
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

## StateNotifier: For Complex State

When you have complex state with multiple operations, use `StateNotifier`:

```dart
// ─────────────────────────────────────
// Define the state class (immutable)
// ─────────────────────────────────────
class TodoState {
  final List<String> todos;
  final bool isLoading;

  TodoState({
    required this.todos,
    this.isLoading = false,
  });

  // Create a copy with changes
  TodoState copyWith({
    List<String>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─────────────────────────────────────
// Create the StateNotifier
// ─────────────────────────────────────
class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(TodoState(todos: []));

  void addTodo(String todo) {
    state = state.copyWith(
      todos: [...state.todos, todo],
    );
  }

  void removeTodo(int index) {
    final newTodos = [...state.todos];
    newTodos.removeAt(index);
    state = state.copyWith(todos: newTodos);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  Future<void> loadTodos() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      todos: ['Learn Dart', 'Learn Flutter', 'Build App'],
      isLoading: false,
    );
  }
}

// ─────────────────────────────────────
// Create the provider
// ─────────────────────────────────────
final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier();
});

// ─────────────────────────────────────
// Use in widget
// ─────────────────────────────────────
class TodoList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoProvider);

    if (todoState.isLoading) {
      return const CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: todoState.todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(todoState.todos[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(todoProvider.notifier).removeTodo(index);
            },
          ),
        );
      },
    );
  }
}
```

---

## Modifying StateProvider

For `StateProvider`, use `.notifier.state`:

```dart
// Get the current value
final count = ref.watch(counterProvider);

// Modify the value
ref.read(counterProvider.notifier).state++;  // Increment
ref.read(counterProvider.notifier).state = 10;  // Set directly

// Update based on previous value
ref.read(counterProvider.notifier).update((state) => state + 5);
```

---

## Provider Dependencies

Providers can depend on other providers:

```dart
// Base provider
final userNameProvider = StateProvider<String>((ref) => 'John');

// Provider that depends on userName
final greetingProvider = Provider<String>((ref) {
  final name = ref.watch(userNameProvider);  // Watch another provider!
  return 'Hello, $name!';
});

// In widget
class GreetingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    return Text(greeting);  // Shows "Hello, John!"
  }
}
```

### Dependency Chain

```
userNameProvider: "John"
        │
        │ depends on
        ▼
greetingProvider: "Hello, John!"
        │
        │ depends on
        ▼
formalGreetingProvider: "Dear Hello, John!, welcome!"

When userName changes, ALL dependent providers update!
```

---

## Summary

| Concept | Purpose |
|---------|---------|
| `ProviderScope` | Wraps app, enables Riverpod |
| `ConsumerWidget` | Widget that can read providers |
| `ref.watch` | Read + listen for changes |
| `ref.read` | Read once, no listening |
| `StateProvider` | Simple mutable state |
| `StateNotifierProvider` | Complex state with methods |
| `Provider` | Read-only or computed values |
| `FutureProvider` | Async data |

---

## Quick Quiz

**Q1:** What's the main difference between Provider and Riverpod?

<details>
<summary>Answer</summary>

In Riverpod, providers are defined globally (outside widgets) and don't need BuildContext to access. This makes them:
- Easier to test
- Available anywhere
- Compile-time safe (no "provider not found" runtime errors)
- Independent of widget tree

</details>

**Q2:** When do you use StateProvider vs StateNotifierProvider?

<details>
<summary>Answer</summary>

- **StateProvider**: Simple values (int, String, bool) with basic operations
- **StateNotifierProvider**: Complex state (objects) with multiple methods

Use StateProvider for a counter. Use StateNotifierProvider for a todo list with add/remove/update operations.

</details>

**Q3:** How do you modify a StateProvider's value?

<details>
<summary>Answer</summary>

```dart
// Direct assignment
ref.read(counterProvider.notifier).state = 10;

// Increment/decrement
ref.read(counterProvider.notifier).state++;

// Update based on previous value
ref.read(counterProvider.notifier).update((state) => state * 2);
```

</details>

---

**Next:** Learn advanced Riverpod patterns!

---

**Continue to:** `05-RiverpodAdvanced.md`
