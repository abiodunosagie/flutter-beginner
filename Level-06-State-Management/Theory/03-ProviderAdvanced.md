# Provider Advanced: Multiple Providers and Patterns

Now that you understand the basics, let's learn more powerful Provider patterns!

---

## Multiple Providers

Most real apps need more than one type of data. You might need:
- User information
- Shopping cart
- App settings
- Notifications

### Using MultiProvider

Instead of nesting providers (ugly!), use `MultiProvider`:

```dart
// ❌ UGLY: Nested providers
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
          child: MyApp(),  // So deeply nested!
        ),
      ),
    ),
  );
}

// ✅ CLEAN: MultiProvider
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Complete Example: E-Commerce App

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────
// PROVIDER 1: User
// ─────────────────────────────────────
class UserProvider extends ChangeNotifier {
  String _name = 'Guest';
  bool _isLoggedIn = false;

  String get name => _name;
  bool get isLoggedIn => _isLoggedIn;

  void login(String name) {
    _name = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _name = 'Guest';
    _isLoggedIn = false;
    notifyListeners();
  }
}

// ─────────────────────────────────────
// PROVIDER 2: Cart
// ─────────────────────────────────────
class CartProvider extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// ─────────────────────────────────────
// PROVIDER 3: Settings
// ─────────────────────────────────────
class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  double _fontSize = 16.0;

  bool get darkMode => _darkMode;
  double get fontSize => _fontSize;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
}

// ─────────────────────────────────────
// MAIN APP
// ─────────────────────────────────────
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch settings for theme
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Multi-Provider Demo',
      theme: settings.darkMode ? ThemeData.dark() : ThemeData.light(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Each provider is accessed independently
    final user = context.watch<UserProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user.name}'),
        actions: [
          // Cart icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Login/Logout section
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.isLoggedIn ? 'Logged in as ${user.name}' : 'Not logged in'),
            trailing: ElevatedButton(
              onPressed: () {
                if (user.isLoggedIn) {
                  context.read<UserProvider>().logout();
                } else {
                  context.read<UserProvider>().login('John');
                }
              },
              child: Text(user.isLoggedIn ? 'Logout' : 'Login'),
            ),
          ),

          // Add to cart section
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Add items to cart'),
            trailing: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addItem('Item ${cart.itemCount + 1}');
              },
              child: const Text('Add Item'),
            ),
          ),

          // Settings section
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: context.watch<SettingsProvider>().darkMode,
              onChanged: (_) {
                context.read<SettingsProvider>().toggleDarkMode();
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

## Provider Types

Provider offers different types for different needs:

### 1. ChangeNotifierProvider (Most Common)

For classes that extend `ChangeNotifier`:

```dart
ChangeNotifierProvider(
  create: (context) => MyNotifier(),
  child: MyApp(),
)
```

### 2. Provider (Simple/Immutable Data)

For data that doesn't change or classes without `ChangeNotifier`:

```dart
// For simple values
Provider<String>(
  create: (_) => 'Hello World',
  child: MyApp(),
)

// For services
Provider<ApiService>(
  create: (_) => ApiService(),
  child: MyApp(),
)
```

### 3. FutureProvider (Async Data)

For data that comes from a Future:

```dart
FutureProvider<User>(
  create: (_) => fetchUser(),  // Returns Future<User>
  initialData: User.guest(),    // Show while loading
  child: MyApp(),
)

// In widget
class UserDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return Text('Welcome, ${user.name}');
  }
}
```

### 4. StreamProvider (Stream Data)

For data from a Stream (like real-time updates):

```dart
StreamProvider<int>(
  create: (_) => Stream.periodic(
    Duration(seconds: 1),
    (count) => count,
  ),
  initialData: 0,
  child: MyApp(),
)
```

---

## Selector: Optimize Rebuilds

Sometimes you only care about ONE piece of data, not the whole object:

```dart
class UserProvider extends ChangeNotifier {
  String name = 'John';
  int age = 25;
  String email = 'john@example.com';
  // ... many more fields
}
```

### Problem: Rebuilding Too Much

```dart
// ❌ This rebuilds when ANY field changes
@override
Widget build(BuildContext context) {
  final user = context.watch<UserProvider>();
  return Text(user.name);  // Only shows name, but rebuilds for age, email too!
}
```

### Solution: Selector

```dart
// ✅ This rebuilds ONLY when name changes
@override
Widget build(BuildContext context) {
  final name = context.select<UserProvider, String>((user) => user.name);
  return Text(name);  // Only rebuilds when name changes!
}
```

### Selector Explained

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  context.select<UserProvider, String>((u) => u.name)│
│                  │            │        │            │
│                  │            │        │            │
│          Provider type    Return   Selector        │
│                          type     function         │
│                                                     │
│  "Give me the name from UserProvider"               │
│  "Only rebuild if name changes"                     │
│                                                     │
└─────────────────────────────────────────────────────┘
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
        Text('Name: $name'),
        Text('Age: $age'),
      ],
    );
  }
}
```

---

## ProxyProvider: Dependent Providers

Sometimes one provider needs data from another:

```dart
// Cart needs to know the current user
class CartProvider extends ChangeNotifier {
  final String userId;  // Needs this from UserProvider!

  CartProvider(this.userId);

  // ... cart methods
}
```

### Using ProxyProvider

```dart
MultiProvider(
  providers: [
    // First: UserProvider (independent)
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),

    // Second: CartProvider (depends on UserProvider)
    ChangeNotifierProxyProvider<UserProvider, CartProvider>(
      create: (_) => CartProvider(''),  // Initial empty
      update: (_, user, cart) => CartProvider(user.userId),
    ),
  ],
  child: MyApp(),
)
```

### Visualized

```
┌─────────────────────────────────────────┐
│                                         │
│    UserProvider                         │
│    (userId: "123")                      │
│           │                             │
│           │ provides userId             │
│           ▼                             │
│    CartProvider                         │
│    (userId: "123") ← from UserProvider  │
│                                         │
└─────────────────────────────────────────┘
```

---

## Consumer vs context.watch

Both do similar things but have different use cases:

### context.watch - Cleaner, Simpler

```dart
@override
Widget build(BuildContext context) {
  final counter = context.watch<Counter>();

  return Text('${counter.count}');
}
```

**Pros:**
- Clean syntax
- Less code
- Easy to understand

**Cons:**
- Whole widget rebuilds
- Can't optimize easily

### Consumer - More Control

```dart
@override
Widget build(BuildContext context) {
  return Consumer<Counter>(
    builder: (context, counter, child) {
      return Row(
        children: [
          Text('${counter.count}'),  // Rebuilds
          child!,  // Does NOT rebuild!
        ],
      );
    },
    child: const ExpensiveWidget(),  // Built once!
  );
}
```

**Pros:**
- `child` parameter for optimization
- Only partial rebuild
- More explicit

**Cons:**
- More verbose
- Nested code

### When to Use Which?

| Situation | Use |
|-----------|-----|
| Simple widget, all content depends on state | `context.watch` |
| Mix of dynamic and static content | `Consumer` |
| Performance critical | `Consumer` with `child` |
| Multiple providers | Multiple `context.watch` calls |

---

## Provider Best Practices

### 1. Keep Providers Focused

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

### 2. Don't Call notifyListeners() in Constructor

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
    notifyListeners();  // Call later if needed
  }
}
```

### 3. Use Private Variables with Getters

```dart
// ❌ BAD: Public variables
class Counter extends ChangeNotifier {
  int count = 0;  // Anyone can change without notifyListeners!
}

// ✅ GOOD: Private with getter
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;  // Read-only access

  void increment() {
    _count++;
    notifyListeners();  // Controlled updates
  }
}
```

### 4. Return Unmodifiable Collections

```dart
// ❌ BAD: Mutable list returned
class TodoProvider extends ChangeNotifier {
  List<String> get todos => _todos;  // Can be modified outside!
}

// ✅ GOOD: Unmodifiable list
class TodoProvider extends ChangeNotifier {
  List<String> get todos => List.unmodifiable(_todos);
}
```

---

## Common Mistakes and Fixes

### Mistake 1: Using watch in callbacks

```dart
// ❌ WRONG
onPressed: () {
  final counter = context.watch<Counter>();  // Don't watch in callbacks!
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
  // Forgot notifyListeners()!
}

// ✅ CORRECT
void updateName(String name) {
  _name = name;
  notifyListeners();
}
```

### Mistake 3: Provider Not Found Error

```
Error: Could not find the correct Provider<Counter> above this widget
```

**Cause:** Trying to access a provider that doesn't exist above the widget

```dart
// ❌ WRONG: Provider below the widget that needs it
MaterialApp(
  home: CounterPage(),  // Tries to access Counter
)
// Provider is not above MaterialApp!

// ✅ CORRECT: Provider above
ChangeNotifierProvider(
  create: (_) => Counter(),
  child: MaterialApp(
    home: CounterPage(),  // Can access Counter
  ),
)
```

---

## Summary

| Concept | Purpose |
|---------|---------|
| `MultiProvider` | Use multiple providers cleanly |
| `Provider` | Simple/immutable data |
| `FutureProvider` | Async data from Future |
| `StreamProvider` | Real-time stream data |
| `context.select` | Rebuild only for specific changes |
| `ProxyProvider` | Provider depends on another |
| `Consumer` | Optimize with child parameter |

---

## Quick Quiz

**Q1:** How do you provide multiple providers cleanly?

<details>
<summary>Answer</summary>

Use `MultiProvider`:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => Provider1()),
    ChangeNotifierProvider(create: (_) => Provider2()),
  ],
  child: MyApp(),
)
```

</details>

**Q2:** How do you prevent unnecessary rebuilds when you only need one field?

<details>
<summary>Answer</summary>

Use `context.select`:
```dart
final name = context.select<User, String>((user) => user.name);
```
This only rebuilds when `name` changes, not when other fields change.

</details>

**Q3:** What's the benefit of Consumer's child parameter?

<details>
<summary>Answer</summary>

The `child` parameter lets you define widgets that DON'T rebuild when the provider changes. Pass expensive widgets as `child` to avoid rebuilding them:
```dart
Consumer<Counter>(
  builder: (context, counter, child) {
    return Column(children: [
      Text('${counter.count}'),  // Rebuilds
      child!,  // Does NOT rebuild
    ]);
  },
  child: const ExpensiveWidget(),  // Built once
)
```

</details>

---

**Next:** Learn Riverpod - a more powerful and type-safe alternative!

---

**Continue to:** `04-RiverpodBasics.md`
