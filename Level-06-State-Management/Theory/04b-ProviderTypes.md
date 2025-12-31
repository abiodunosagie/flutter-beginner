# Riverpod Provider Types: Different Tools for Different Jobs

Think of providers like different types of containers in your kitchen. Some hold things that never change (like a jar of sugar), some hold things you can change (like a cookie jar you fill and empty), and some hold things that take time to get (like ordering pizza)!

---

## The Five Main Provider Types

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Provider           Read-only / Computed values    │
│   ──────────         (Like a recipe - never changes)│
│                                                     │
│   StateProvider      Simple mutable values          │
│   ───────────────    (Like a cookie jar)            │
│                                                     │
│   StateNotifierProvider  Complex state with methods │
│   ───────────────────────  (Like a game controller) │
│                                                     │
│   FutureProvider     Async data (one-time)          │
│   ────────────────   (Like ordering pizza)          │
│                                                     │
│   StreamProvider     Real-time data (continuous)    │
│   ────────────────   (Like a live score ticker)     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 1. StateProvider: The Simple Cookie Jar

Use `StateProvider` for simple values that change, like numbers, strings, or booleans.

### When to Use

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Perfect for:                                      │
│   • Counter (int)                                   │
│   • Toggle switches (bool)                          │
│   • Selected index (int)                            │
│   • Theme mode (bool isDarkMode)                    │
│   • Simple text input (String)                      │
│                                                     │
│   NOT good for:                                     │
│   • Lists of items                                  │
│   • Complex objects with methods                    │
│   • Data requiring validation                       │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Example: Counter

```dart
// Create a StateProvider
final counterProvider = StateProvider<int>((ref) => 0);
//                                      ^^^       ^^^
//                                      Type   Initial value

// In your widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the value
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () {
            // Modify the value
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
```

### Example: Theme Toggle

```dart
// Dark mode provider
final isDarkModeProvider = StateProvider<bool>((ref) => false);

class ThemeToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Switch(
      value: isDark,
      onChanged: (value) {
        // Set new value
        ref.read(isDarkModeProvider.notifier).state = value;
      },
    );
  }
}
```

### Modifying StateProvider Values

```dart
// Three ways to modify

// 1. Direct assignment
ref.read(counterProvider.notifier).state = 10;

// 2. Increment/decrement
ref.read(counterProvider.notifier).state++;
ref.read(counterProvider.notifier).state--;

// 3. Update based on previous value
ref.read(counterProvider.notifier).update((state) => state + 5);
```

---

## 2. Provider: The Recipe Book (Read-Only)

Use `Provider` for values that don't change OR are computed from other providers.

### When to Use

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Perfect for:                                      │
│   • Configuration values                            │
│   • Dependency injection (services)                 │
│   • Computed/calculated values                      │
│   • Values derived from other providers             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Example: Simple Constant

```dart
// A value that never changes
final greetingProvider = Provider<String>((ref) {
  return 'Hello, World!';
});

// Use it
class GreetingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    return Text(greeting);  // Shows "Hello, World!"
  }
}
```

### Example: Computed Value

```dart
// Base provider
final counterProvider = StateProvider<int>((ref) => 0);

// Provider that computes from counterProvider
final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;  // Always double of counter
});

// Another computed provider
final isEvenProvider = Provider<bool>((ref) {
  final count = ref.watch(counterProvider);
  return count % 2 == 0;  // Is the counter even?
});

// Use them together
class ComputedExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final doubled = ref.watch(doubledProvider);
    final isEven = ref.watch(isEvenProvider);

    return Column(
      children: [
        Text('Count: $count'),
        Text('Doubled: $doubled'),
        Text('Is even: $isEven'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

## 3. StateNotifierProvider: The Game Controller

Use `StateNotifierProvider` for complex state with multiple operations.

### When to Use

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Perfect for:                                      │
│   • Todo lists (add, remove, toggle)                │
│   • Shopping carts (add item, update quantity)      │
│   • User profiles (update name, email, avatar)      │
│   • Game state (move player, score points)          │
│                                                     │
│   Any time you have:                                │
│   • Multiple related values                         │
│   • Multiple operations                             │
│   • Complex state logic                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Example: Shopping Cart

```dart
// Step 1: Define your state class
class CartState {
  final List<String> items;
  final double total;

  CartState({
    required this.items,
    required this.total,
  });

  // Create a copy with changes
  CartState copyWith({
    List<String>? items,
    double? total,
  }) {
    return CartState(
      items: items ?? this.items,
      total: total ?? this.total,
    );
  }
}

// Step 2: Create the StateNotifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: [], total: 0.0));

  void addItem(String item, double price) {
    state = state.copyWith(
      items: [...state.items, item],
      total: state.total + price,
    );
  }

  void removeItem(int index, double price) {
    final newItems = [...state.items];
    newItems.removeAt(index);
    state = state.copyWith(
      items: newItems,
      total: state.total - price,
    );
  }

  void clear() {
    state = CartState(items: [], total: 0.0);
  }
}

// Step 3: Create the provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Step 4: Use in widget
class CartWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Column(
      children: [
        Text('Items: ${cart.items.length}'),
        Text('Total: \$${cart.total.toStringAsFixed(2)}'),
        ...cart.items.map((item) => Text(item)),
        ElevatedButton(
          onPressed: () {
            ref.read(cartProvider.notifier).addItem('Apple', 1.99);
          },
          child: Text('Add Apple'),
        ),
      ],
    );
  }
}
```

---

## 4. FutureProvider: Ordering Pizza (Async One-Time)

Use `FutureProvider` for data that takes time to load, like API calls or database queries.

### When to Use

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Perfect for:                                      │
│   • Loading user data from API                      │
│   • Fetching settings from database                 │
│   • Reading files                                   │
│   • One-time async operations                       │
│                                                     │
│   It's like ordering pizza:                         │
│   • You place the order (start)                     │
│   • Wait (loading)                                  │
│   • Get pizza or error (done)                       │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Example: Loading User

```dart
// Define a model
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}

// Create FutureProvider
final userProvider = FutureProvider<User>((ref) async {
  // Simulate API call
  await Future.delayed(Duration(seconds: 2));

  // Could throw error:
  // throw Exception('Failed to load user');

  return User(name: 'John', age: 25);
});

// Use in widget
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    // Handle loading, error, and data states
    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (user) => Text('Welcome, ${user.name}!'),
    );
  }
}
```

---

## 5. StreamProvider: Live Sports Score (Real-Time)

Use `StreamProvider` for data that updates continuously over time.

### When to Use

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Perfect for:                                      │
│   • Live chat messages                              │
│   • Real-time notifications                         │
│   • Stock prices                                    │
│   • Timer/countdown                                 │
│   • Firebase Firestore snapshots                    │
│                                                     │
│   It's like a live score ticker:                    │
│   • Continuous updates                              │
│   • Never "done" loading                            │
│   • Can get many values over time                   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Example: Timer

```dart
// Create a StreamProvider
final timerProvider = StreamProvider<int>((ref) {
  // Emit a new number every second
  return Stream.periodic(
    Duration(seconds: 1),
    (count) => count,  // 0, 1, 2, 3, ...
  );
});

// Use in widget
class TimerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);

    return timerAsync.when(
      loading: () => Text('Starting timer...'),
      error: (error, stack) => Text('Error: $error'),
      data: (seconds) => Text('Seconds: $seconds'),
    );
  }
}
```

### Example: Chat Messages Stream

```dart
// Simulate chat stream
final chatProvider = StreamProvider<String>((ref) {
  return Stream.periodic(
    Duration(seconds: 3),
    (count) => 'Message ${count + 1}',
  );
});

class ChatWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageAsync = ref.watch(chatProvider);

    return messageAsync.when(
      loading: () => Text('Connecting...'),
      error: (e, s) => Text('Connection error'),
      data: (message) => Text('Latest: $message'),
    );
  }
}
```

---

## Quick Comparison

| Provider Type | Use Case | Example |
|--------------|----------|---------|
| `StateProvider` | Simple mutable value | Counter, toggle, index |
| `Provider` | Read-only or computed | Constants, derived values |
| `StateNotifierProvider` | Complex state + methods | Todo list, cart, game |
| `FutureProvider` | One-time async | API call, file read |
| `StreamProvider` | Continuous async | Live chat, timer, updates |

---

## How to Choose?

```
Ask yourself:

Does it change?
  NO  → Provider (read-only)
  YES → Continue...

Is it a simple value (int, String, bool)?
  YES → StateProvider
  NO  → Continue...

Does it involve waiting for data?
  YES → Is it continuous updates?
    YES → StreamProvider
    NO  → FutureProvider
  NO  → StateNotifierProvider
```

---

## Visual Summary

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   SIMPLE VALUE                                      │
│   ┌─────────────┐                                   │
│   │ StateProvider│  counter: 5 → 6 → 7             │
│   └─────────────┘                                   │
│                                                     │
│   COMPUTED VALUE                                    │
│   ┌─────────────┐                                   │
│   │  Provider   │  doubled: 10 → 12 → 14           │
│   └─────────────┘  (auto-updates!)                 │
│                                                     │
│   COMPLEX STATE                                     │
│   ┌─────────────────────────┐                       │
│   │ StateNotifierProvider   │  cart: {              │
│   │   - addItem()           │    items: [...],     │
│   │   - removeItem()        │    total: 29.99      │
│   │   - clear()             │  }                   │
│   └─────────────────────────┘                       │
│                                                     │
│   ONE-TIME ASYNC                                    │
│   ┌─────────────────┐                               │
│   │ FutureProvider  │  Loading... → User(John)     │
│   └─────────────────┘                               │
│                                                     │
│   CONTINUOUS ASYNC                                  │
│   ┌─────────────────┐                               │
│   │ StreamProvider  │  0 → 1 → 2 → 3 → ...         │
│   └─────────────────┘                               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Summary

Each provider type is like a different tool in your toolbox:
- **StateProvider** = Simple screwdriver (one job, easy to use)
- **Provider** = Ruler (measures/computes, doesn't change)
- **StateNotifierProvider** = Swiss Army knife (many tools in one)
- **FutureProvider** = Microwave (wait once, get result)
- **StreamProvider** = Running water (continuous flow)

Choose the right tool for the job, and your code will be clean and easy to understand!

---

## Navigation

⬅️ **Previous:** [Riverpod Introduction](04a-RiverpodIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Consuming Riverpod](04c-ConsumingRiverpod.md)
