# Riverpod Provider Types: Different Tools for Different Jobs

## The Big Idea In One Sentence

> Riverpod has different provider types for different jobs: `StateProvider` for simple values, `Provider` for read-only or computed values, and `StateNotifierProvider` for complex state with methods.

Think of providers like different containers in a kitchen: some hold a single thing, some compute from others, some hold a whole bundle with rules.

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

## A Note On Async Providers

> Riverpod also has `FutureProvider` (for data that loads once, like a network request) and `StreamProvider` (for data that updates continuously, like a live feed). Both build on **Futures** and **Streams**, which you learn in Level 8 (API) and Level 9. We will come back to them once you know async. For now, the three above (`StateProvider`, `Provider`, `StateNotifierProvider`) cover everything you need.

---

## Quick Comparison

| Provider Type | Use Case | Example |
|--------------|----------|---------|
| `StateProvider` | Simple mutable value | Counter, toggle, index |
| `Provider` | Read-only or computed | Constants, derived values |
| `StateNotifierProvider` | Complex state + methods | Todo list, cart, game |

(The async `FutureProvider` and `StreamProvider` come after you learn async.)

---

## How to Choose?

```
Does it change?
  NO  -> Provider (read-only or computed)
  YES -> Is it a simple value (int, String, bool)?
           YES -> StateProvider
           NO  -> StateNotifierProvider (complex state with methods)
```

---

## Summary

Each provider type is a different tool:
- **StateProvider** = a simple screwdriver (one value, easy to change).
- **Provider** = a ruler (computes or holds a fixed value, you do not change it directly).
- **StateNotifierProvider** = a Swiss Army knife (a whole state object with methods).

Pick the simplest one that fits the job.

---

## Quick Quiz

**Q1.** Which provider type for a simple counter (an int)?

<details>
<summary>Answer</summary>
`StateProvider`. It is for simple mutable values like ints, strings, and bools.
</details>

**Q2.** Which provider type for a value computed from another provider (like "doubled")?

<details>
<summary>Answer</summary>
`Provider`. It can read other providers and return a computed value, which auto-updates.
</details>

**Q3.** Which provider type for a shopping cart with `addItem`, `removeItem`, and `clear`?

<details>
<summary>Answer</summary>
`StateNotifierProvider`. It is for complex state with multiple methods.
</details>

---

## Assignment

Use [dartpad.dev](https://dartpad.dev).

### Problem 1: Pick the type

For each, name the provider type (`StateProvider`, `Provider`, or `StateNotifierProvider`):

1. A dark-mode on/off toggle.
2. A "is the counter even?" value computed from a counter.
3. A todo list with add and remove methods.

### Problem 2: A computed provider

Given `final counterProvider = StateProvider<int>((ref) => 0);`, write a `Provider<int>` called `doubledProvider` that is always double the counter.

### Problem 3: A StateNotifier

Write a `CounterNotifier extends StateNotifier<int>` (starting at 0) with `increment()` and `reset()` methods, and the `StateNotifierProvider` that exposes it.

---

## Assignment Answers

### Problem 1: Pick the type

1. Dark-mode toggle -> `StateProvider` (a simple bool).
2. "Is even?" computed value -> `Provider` (computed from the counter).
3. Todo list with methods -> `StateNotifierProvider` (complex state + methods).

### Problem 2: A computed provider

```dart
final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});
```

It watches `counterProvider` and returns double its value. When the counter changes, `doubledProvider` updates automatically.

### Problem 3: A StateNotifier

```dart
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state = state + 1;
  void reset() => state = 0;
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});
```

The notifier holds the state (an int starting at 0) and changes it through methods by assigning to `state`. The `StateNotifierProvider` exposes it. In a widget you read the value with `ref.watch(counterProvider)` and call methods with `ref.read(counterProvider.notifier).increment()`.

---

## Navigation

⬅️ **Previous:** [Riverpod Introduction](04a-RiverpodIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Consuming Riverpod](04c-ConsumingRiverpod.md)
