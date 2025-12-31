# Consuming Riverpod: Reading and Using Providers

Now that you know the different provider types, let's learn how to actually USE them in your widgets! Think of this as learning how to open and use those different containers we talked about.

---

## Three Ways to Consume Providers

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   1. ConsumerWidget                                 │
│      Replaces StatelessWidget                       │
│      Best for: Most widgets                         │
│                                                     │
│   2. ConsumerStatefulWidget                         │
│      Replaces StatefulWidget                        │
│      Best for: Widgets with lifecycle methods       │
│                                                     │
│   3. Consumer                                       │
│      Wraps part of a widget                         │
│      Best for: Optimizing specific parts            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 1. ConsumerWidget: The Most Common Way

Instead of `StatelessWidget`, use `ConsumerWidget` to access providers:

### Basic Example

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define provider
final counterProvider = StateProvider<int>((ref) => 0);

// OLD WAY (StatelessWidget - can't access providers)
class OldCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Can't access providers here!
    return Text('???');
  }
}

// NEW WAY (ConsumerWidget - can access providers)
class NewCounter extends ConsumerWidget {
  const NewCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //                               ^^^^^^^^^^
    //                    This 'ref' is the magic key!

    // Now we can access providers!
    final count = ref.watch(counterProvider);

    return Text('Count: $count');
  }
}
```

### Breaking It Down

```dart
class MyWidget extends ConsumerWidget {
  //                 ^^^^^^^^^^^^^^
  // 1. Extend ConsumerWidget (not StatelessWidget)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //                                ^^^^^^^^^^
    // 2. build() gets an extra parameter: ref

    final value = ref.watch(someProvider);
    //            ^^^^^^^^^^^^^^^^^^^^^^^^
    // 3. Use ref to access providers

    return Text('Value: $value');
  }
}
```

---

## 2. ConsumerStatefulWidget: For Stateful Widgets

When you need `initState()`, `dispose()`, or other lifecycle methods:

### Basic Example

```dart
// Define provider
final counterProvider = StateProvider<int>((ref) => 0);

// Step 1: Extend ConsumerStatefulWidget
class CounterWithState extends ConsumerStatefulWidget {
  const CounterWithState({super.key});

  @override
  ConsumerState<CounterWithState> createState() => _CounterWithStateState();
}

// Step 2: State class extends ConsumerState
class _CounterWithStateState extends ConsumerState<CounterWithState> {
  //                               ^^^^^^^^^^^^^
  // ConsumerState (not State)

  @override
  void initState() {
    super.initState();
    // Can use ref here!
    final count = ref.read(counterProvider);
    print('Initial count: $count');
  }

  @override
  Widget build(BuildContext context) {
    // Access ref through the 'ref' property
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('Increment'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    print('Widget disposed');
    super.dispose();
  }
}
```

---

## 3. Consumer: For Specific Parts

Use `Consumer` when you only need providers in a small part of your widget:

### Example: Optimize Rebuilds

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),  // This never changes
      ),
      body: Column(
        children: [
          Text('Welcome!'),  // This never changes

          // Only this part needs to rebuild
          Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterProvider);
              return Text('Count: $count');
            },
          ),

          // This never changes
          ElevatedButton(
            onPressed: () {},
            child: Text('Static Button'),
          ),
        ],
      ),
    );
  }
}
```

### With a Child (Optimization)

```dart
Consumer(
  // 'child' doesn't rebuild when provider changes
  child: ExpensiveWidget(),  // This is built once

  builder: (context, ref, child) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),  // Rebuilds on changes
        child!,  // Reuses same ExpensiveWidget instance
      ],
    );
  },
)
```

---

## ref.watch vs ref.read: The Golden Rule

This is SUPER important! Understanding when to use each is key to Riverpod.

### ref.watch - "Keep Me Updated!"

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ref.watch(provider)                               │
│   ──────────────────                                │
│                                                     │
│   • WATCHES for changes                             │
│   • Widget REBUILDS when value changes              │
│   • Use in build() method                           │
│   • For DISPLAYING data                             │
│                                                     │
│   Example: Showing a counter on screen              │
│                                                     │
└─────────────────────────────────────────────────────┘
```

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // WATCH - Widget rebuilds when counter changes
  final count = ref.watch(counterProvider);

  return Text('$count');  // Updates automatically!
}
```

### ref.read - "Just Get It Once!"

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ref.read(provider)                                │
│   ─────────────────                                 │
│                                                     │
│   • Gets value ONCE                                 │
│   • NO listening, NO rebuilds                       │
│   • Use in callbacks (onPressed, etc.)              │
│   • For ACTIONS and METHODS                         │
│                                                     │
│   Example: Incrementing a counter when button       │
│   is pressed                                        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

```dart
ElevatedButton(
  onPressed: () {
    // READ - Just modify, don't watch
    ref.read(counterProvider.notifier).state++;
  },
  child: Text('Add'),
)
```

### Never Use ref.read in build()!

```dart
// ❌ BAD - Widget won't update!
@override
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.read(counterProvider);  // WRONG!
  return Text('$count');  // Won't update when counter changes
}

// ✅ GOOD - Widget updates when counter changes
@override
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.watch(counterProvider);  // CORRECT!
  return Text('$count');  // Updates automatically
}
```

---

## Modifying StateProvider

For `StateProvider`, access the state through `.notifier.state`:

### Reading the Value

```dart
// In build() method - use watch
final count = ref.watch(counterProvider);

// In callback - use read
ref.read(counterProvider.notifier).state++;
```

### Modifying the Value

```dart
final counterProvider = StateProvider<int>((ref) => 0);

// Method 1: Direct assignment
ref.read(counterProvider.notifier).state = 10;

// Method 2: Increment/decrement
ref.read(counterProvider.notifier).state++;
ref.read(counterProvider.notifier).state--;

// Method 3: Update based on previous value
ref.read(counterProvider.notifier).update((state) => state + 5);

// Method 4: Calculate new value
ref.read(counterProvider.notifier).state =
  ref.read(counterProvider.notifier).state * 2;
```

---

## Provider Dependencies

Providers can watch other providers! Think of it like a recipe that uses ingredients from other recipes.

### Example: Dependent Providers

```dart
// Base provider (ingredient)
final userNameProvider = StateProvider<String>((ref) => 'John');

// Dependent provider (recipe using ingredient)
final greetingProvider = Provider<String>((ref) {
  // This provider watches userNameProvider
  final name = ref.watch(userNameProvider);
  return 'Hello, $name!';
});

// Another dependent provider
final formalGreetingProvider = Provider<String>((ref) {
  // This watches greetingProvider (which watches userNameProvider)
  final greeting = ref.watch(greetingProvider);
  return 'Dear $greeting, welcome to our app!';
});
```

### Dependency Chain

```
userNameProvider: "John"
        │
        │ watches
        ▼
greetingProvider: "Hello, John!"
        │
        │ watches
        ▼
formalGreetingProvider: "Dear Hello, John!, welcome to our app!"

When userName changes to "Alice":
• greetingProvider auto-updates to "Hello, Alice!"
• formalGreetingProvider auto-updates to "Dear Hello, Alice!, welcome to our app!"
```

### Using Dependent Providers

```dart
class GreetingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);

    return Column(
      children: [
        Text(greeting),
        ElevatedButton(
          onPressed: () {
            // Change the base provider
            ref.read(userNameProvider.notifier).state = 'Alice';
            // greetingProvider automatically updates!
          },
          child: Text('Change Name'),
        ),
      ],
    );
  }
}
```

---

## Complete Counter Example

Let's put it all together with a complete example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────
// STEP 1: Define Providers
// ─────────────────────────────────────

// Simple counter
final counterProvider = StateProvider<int>((ref) => 0);

// Computed: double of counter
final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

// Computed: is counter even?
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
      home: const CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// STEP 3: Use Providers in Widget
// ─────────────────────────────────────

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WATCH providers - rebuild when they change
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
            // Display count
            Text(
              'Count: $count',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),

            // Display computed value
            Text(
              'Doubled: $doubled',
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Display even/odd
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

            // Buttons to modify state
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton(
                  onPressed: () {
                    // READ to modify - don't watch in callbacks!
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),

                // Reset button
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),

                // Increment button
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

## Common Patterns

### Pattern 1: Multiple Providers

```dart
class DashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch multiple providers
    final user = ref.watch(userProvider);
    final cart = ref.watch(cartProvider);
    final settings = ref.watch(settingsProvider);

    return Column(
      children: [
        Text('User: ${user.name}'),
        Text('Cart items: ${cart.items.length}'),
        Text('Dark mode: ${settings.isDarkMode}'),
      ],
    );
  }
}
```

### Pattern 2: Conditional Provider Access

```dart
class ConditionalWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    if (isLoggedIn) {
      // Only watch userProvider if logged in
      final user = ref.watch(userProvider);
      return Text('Welcome, ${user.name}!');
    } else {
      return Text('Please log in');
    }
  }
}
```

### Pattern 3: Passing Provider Values to Children

```dart
class ParentWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    // Pass value to regular (non-Consumer) widget
    return ChildWidget(count: count);
  }
}

class ChildWidget extends StatelessWidget {
  final int count;

  const ChildWidget({required this.count});

  @override
  Widget build(BuildContext context) {
    return Text('Count from parent: $count');
  }
}
```

---

## Summary

| Concept | When to Use |
|---------|-------------|
| `ConsumerWidget` | Most widgets that need providers |
| `ConsumerStatefulWidget` | When you need lifecycle methods |
| `Consumer` | Optimize specific parts of a widget |
| `ref.watch` | In build() to display data |
| `ref.read` | In callbacks to perform actions |
| `.notifier.state` | To modify StateProvider |
| Provider dependencies | When one value depends on another |

---

## Quick Reference

```dart
// Access in ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);  // Display
    return Text('$value');
  }
}

// Modify StateProvider
ref.read(provider.notifier).state = newValue;  // Set
ref.read(provider.notifier).state++;           // Increment
ref.read(provider.notifier).update((s) => s + 5);  // Update

// Provider depending on another
final computed = Provider<int>((ref) {
  final base = ref.watch(baseProvider);
  return base * 2;
});
```

---

## Navigation

⬅️ **Previous:** [Provider Types](04b-ProviderTypes.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Async with Riverpod](05a-AsyncValue.md)
