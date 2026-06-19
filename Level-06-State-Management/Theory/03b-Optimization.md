# Optimization and Best Practices

## The Big Idea In One Sentence

> To avoid wasteful rebuilds, watch only the exact piece of data a widget needs (`context.select`), and use `Consumer` with a `child` to keep the parts that do not change from rebuilding.

`watch` is simple but rebuilds on any change. These tools make Provider apps fast.

---

## The Problem: Too Many Rebuilds

Imagine you have a user with lots of information:

```dart
class UserProvider extends ChangeNotifier {
  String name = 'John';
  int age = 25;
  String email = 'john@example.com';
  String address = '123 Main St';
  String phone = '555-1234';
  // ... many more fields
}
```

### What Happens with context.watch?

```dart
@override
Widget build(BuildContext context) {
  final user = context.watch<UserProvider>();
  return Text(user.name);  // Only shows name
}
```

**Problem:** This widget rebuilds when **ANY** field changes!

```
Name changes → Rebuilds ✅ (needed)
Age changes  → Rebuilds ❌ (not needed!)
Email changes → Rebuilds ❌ (not needed!)
```

We're only showing `name`, but rebuilding for everything!

---

## Solution: Selector

Use `context.select` to watch only specific fields:

```dart
@override
Widget build(BuildContext context) {
  // Only watch the name field!
  final name = context.select<UserProvider, String>((user) => user.name);
  return Text(name);
}
```

Now it only rebuilds when `name` changes!

```
Name changes → Rebuilds ✅ (needed)
Age changes  → No rebuild ✅ (not needed)
Email changes → No rebuild ✅ (not needed)
```

---

## How Selector Works

```
context.select<UserProvider, String>((user) => user.name)
                │            │         │
                │            │         └── Selector function
                │            └── Return type (String)
                └── Provider type

"Give me the name from UserProvider"
"Only rebuild if name changes"
```

### Multiple Selectors

```dart
class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Each selector rebuilds independently
    final name = context.select<UserProvider, String>((u) => u.name);
    final age = context.select<UserProvider, int>((u) => u.age);

    return Column(
      children: [
        Text('Name: $name'),  // Rebuilds when name changes
        Text('Age: $age'),    // Rebuilds when age changes
      ],
    );
  }
}
```

---

## Consumer Widget: Partial Rebuilds

Sometimes you have a mix of dynamic and static content:

```dart
@override
Widget build(BuildContext context) {
  return Consumer<Counter>(
    builder: (context, counter, child) {
      return Column(
        children: [
          Text('${counter.count}'),  // Rebuilds when count changes
          child!,  // Does NOT rebuild!
        ],
      );
    },
    child: const ExpensiveWidget(),  // Built once!
  );
}
```

### Breaking It Down

```
Consumer<Counter>(
  builder: (context, counter, child) {
    // counter = the state (rebuilds when it changes)
    // child = static widget (never rebuilds)
    return Row(children: [
      Text('${counter.count}'),  // Dynamic
      child!,  // Static
    ]);
  },
  child: const VeryExpensiveWidget(),  // Define static content here
)
```

---

## context.watch vs Consumer

Both work, but have different uses:

### context.watch - Simple and Clean

```dart
@override
Widget build(BuildContext context) {
  final counter = context.watch<Counter>();
  return Text('${counter.count}');
}
```

**Pros:**
- ✅ Clean, easy syntax
- ✅ Less code
- ✅ Easy to read

**Cons:**
- ❌ Whole widget rebuilds
- ❌ Can't optimize with static children

### Consumer - More Control

```dart
@override
Widget build(BuildContext context) {
  return Consumer<Counter>(
    builder: (context, counter, child) {
      return Text('${counter.count}');
    },
  );
}
```

**Pros:**
- ✅ Can use `child` parameter for optimization
- ✅ More explicit

**Cons:**
- ❌ More verbose
- ❌ Nested code

### When to Use Which?

| Situation | Use |
|-----------|-----|
| Simple widget, everything depends on state | `context.watch` |
| Mix of dynamic and static content | `Consumer` with `child` |
| Performance critical (expensive widgets) | `Consumer` with `child` |
| Multiple providers | Multiple `context.watch` |

---

## Best Practices

### 1. Keep Providers Focused (Single Responsibility)

```dart
// ❌ BAD: One giant provider
class AppProvider extends ChangeNotifier {
  User? user;
  List<Product> products;
  Cart cart;
  Settings settings;
  // Everything in one place = messy!
}

// ✅ GOOD: Separate providers
class UserProvider extends ChangeNotifier { /* user stuff */ }
class ProductProvider extends ChangeNotifier { /* product stuff */ }
class CartProvider extends ChangeNotifier { /* cart stuff */ }
class SettingsProvider extends ChangeNotifier { /* settings stuff */ }
```

### 2. Use Private Variables with Getters

```dart
// ❌ BAD: Public variables
class Counter extends ChangeNotifier {
  int count = 0;  // Anyone can change without notifyListeners!
}

// Someone could do:
counter.count = 10;  // Changed but no rebuild!

// ✅ GOOD: Private with getter
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;  // Read-only

  void increment() {
    _count++;
    notifyListeners();  // Controlled update
  }
}
```

### 3. Return Unmodifiable Collections

```dart
// ❌ BAD: Mutable list
class TodoProvider extends ChangeNotifier {
  final List<String> _todos = [];

  List<String> get todos => _todos;  // Can be modified outside!
}

// Someone could do:
provider.todos.add('Hack!');  // Changed without notifyListeners!

// ✅ GOOD: Unmodifiable list
class TodoProvider extends ChangeNotifier {
  final List<String> _todos = [];

  List<String> get todos => List.unmodifiable(_todos);  // Safe!
}
```

### 4. Don't Call notifyListeners in Constructor

```dart
// ❌ BAD
class Counter extends ChangeNotifier {
  Counter() {
    notifyListeners();  // Will cause issues!
  }
}

// ✅ GOOD
class Counter extends ChangeNotifier {
  Counter();  // Just initialize

  void init() {
    // Do setup if needed
    notifyListeners();  // Call later
  }
}
```

---

## Common Mistakes and Fixes

### Mistake 1: Using watch in Callbacks

```dart
// ❌ WRONG
onPressed: () {
  final counter = context.watch<Counter>();  // Don't watch here!
  counter.increment();
}

// ✅ CORRECT
onPressed: () {
  context.read<Counter>().increment();  // Use read!
}
```

### Mistake 2: Forgetting notifyListeners

```dart
// ❌ WRONG
void updateName(String name) {
  _name = name;
  // Forgot notifyListeners()! UI won't update!
}

// ✅ CORRECT
void updateName(String name) {
  _name = name;
  notifyListeners();  // 🔔 Tell listeners!
}
```

### Mistake 3: Provider Not Found

```
Error: Could not find the correct Provider<Counter> above this widget
```

**Cause:** Provider is not above the widget that needs it

```dart
// ❌ WRONG: Provider below widget
MaterialApp(
  home: CounterPage(),  // Tries to access Counter
  // Provider is not above!
)

// ✅ CORRECT: Provider above
ChangeNotifierProvider(
  create: (_) => Counter(),
  child: MaterialApp(
    home: CounterPage(),  // Can access Counter ✅
  ),
)
```

### Mistake 4: Modifying State Directly

```dart
// ❌ WRONG
class TodoProvider extends ChangeNotifier {
  List<String> todos = [];  // Public!
}

// Widget does:
provider.todos.add('New');  // No notifyListeners!

// ✅ CORRECT
class TodoProvider extends ChangeNotifier {
  final List<String> _todos = [];

  List<String> get todos => List.unmodifiable(_todos);

  void addTodo(String todo) {
    _todos.add(todo);
    notifyListeners();  // ✅ Proper notification
  }
}
```

---

## Performance Checklist

✅ **Use `context.select`** when watching only specific fields
✅ **Use Consumer with `child`** for expensive static widgets
✅ **Keep providers focused** (single responsibility)
✅ **Use private variables** with getters
✅ **Return unmodifiable collections**
✅ **Only call notifyListeners()** when state actually changes

---

## Summary

| Concept | Purpose |
|---------|---------|
| `context.select` | Rebuild only for specific field changes |
| `Consumer` with `child` | Optimize with static content |
| Private variables | Prevent unauthorized modifications |
| Unmodifiable collections | Prevent external changes |
| Single responsibility | Keep providers focused |

---

## Key Takeaways

1. **Use `context.select`** to watch only specific fields
2. **Use Consumer's `child`** for expensive static widgets
3. **Keep providers small** and focused on one thing
4. **Always use private variables** with getters
5. **Return unmodifiable** collections to prevent bugs

---

## Quick Quiz

**Q1.** Why can `context.watch<UserProvider>()` cause extra rebuilds?

<details>
<summary>Answer</summary>
It rebuilds the widget whenever **any** field of the provider changes, even fields the widget does not use.
</details>

**Q2.** How do you rebuild only when one field changes?

<details>
<summary>Answer</summary>
Use `context.select`, e.g. `context.select<UserProvider, String>((u) => u.name)`. It rebuilds only when `name` changes.
</details>

**Q3.** What is the `child` of a `Consumer` for?

<details>
<summary>Answer</summary>
It is a widget built once and passed in, so it does not rebuild when the watched data changes. Use it for expensive parts that do not depend on the state.
</details>

---

## Assignment

### Problem 1: Watch one field

A `UserProvider` has `name`, `age`, and `email`. Write the line that reads **only** `name` so a widget rebuilds just when the name changes.

### Problem 2: Spot the inefficiency

Why might this rebuild more than it needs to, and how would you fix it?

```dart
final user = context.watch<UserProvider>();
return Text(user.name);
```

### Problem 3: Consumer with a static child

Explain, in your own words, how `Consumer`'s `child` parameter saves work.

### Problem 4: Best practice

Why should a provider return `List.unmodifiable(_items)` from its getter instead of `_items` directly?

---

## Assignment Answers

### Problem 1: Watch one field

```dart
final name = context.select<UserProvider, String>((u) => u.name);
```

This rebuilds the widget only when `name` changes, ignoring changes to `age` or `email`.

### Problem 2: Spot the inefficiency

`context.watch<UserProvider>()` makes the widget rebuild whenever **any** field of `UserProvider` changes, but the widget only shows `name`. So changing `age` or `email` rebuilds it for nothing. Fix it with `select`:

```dart
final name = context.select<UserProvider, String>((u) => u.name);
return Text(name);
```

### Problem 3: Consumer with a static child

`Consumer` rebuilds its `builder` when the watched data changes. Anything you pass as `child` is built once, outside the builder, and handed in. So an expensive widget that does not depend on the state goes in `child` and is not rebuilt every time, saving work.

### Problem 4: Best practice

If the getter returns `_items` directly, outside code could call `.add` or `.remove` on it, changing the provider's data without going through a method and without `notifyListeners`. That breaks the rules and the UI would not update. `List.unmodifiable(_items)` hands back a read-only view, so the only way to change the list is through the provider's own methods.

---

**Next:** `04a-RiverpodIntro.md`, Provider's safer, more powerful cousin.

---

## Navigation

⬅️ **Previous:** [Multiple Providers](03a-MultipleProviders.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Riverpod Introduction](04a-RiverpodIntro.md)
