# Using Multiple Providers

## The Big Idea In One Sentence

> Real apps have several pieces of state (user, cart, settings), and `MultiProvider` lets you share them all cleanly with one list instead of deeply nested providers.

You learned one provider. Now you manage several.

---

## Why Multiple Providers?

Think of a shopping app. It needs to manage:

```
┌─────────────────────────────────────────┐
│                                         │
│  👤 USER DATA                           │
│  • Who is logged in?                    │
│  • User preferences                     │
│                                         │
│  🛒 SHOPPING CART                       │
│  • What's in the cart?                  │
│  • Total price                          │
│                                         │
│  ⚙️  APP SETTINGS                        │
│  • Dark mode on/off?                    │
│  • Font size                            │
│                                         │
│  🔔 NOTIFICATIONS                        │
│  • Unread count                         │
│  • Messages                             │
│                                         │
└─────────────────────────────────────────┘
```

Each of these needs its own Provider!

---

## The Wrong Way: Nesting Providers

```dart
// ❌ UGLY: Nested providers (hard to read!)
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
```

This is like Russian nesting dolls - confusing!

---

## The Right Way: MultiProvider

```dart
// ✅ CLEAN: MultiProvider (easy to read!)
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

Much cleaner! Like a list instead of nesting.

---

## Complete Example: E-Commerce App

Let's build a mini shopping app with three providers:

### Provider 1: User Data

```dart
class UserProvider extends ChangeNotifier {
  String _name = 'Guest';
  bool _isLoggedIn = false;

  String get name => _name;
  bool get isLoggedIn => _isLoggedIn;

  void login(String name) {
    _name = name;
    _isLoggedIn = true;
    notifyListeners();  // 🔔 Tell everyone!
  }

  void logout() {
    _name = 'Guest';
    _isLoggedIn = false;
    notifyListeners();  // 🔔 Tell everyone!
  }
}
```

### Provider 2: Shopping Cart

```dart
class CartProvider extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);  // Read-only!
  int get itemCount => _items.length;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();  // 🔔 Cart changed!
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();  // 🔔 Cart changed!
  }

  void clearCart() {
    _items.clear();
    notifyListeners();  // 🔔 Cart cleared!
  }
}
```

### Provider 3: App Settings

```dart
class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  double _fontSize = 16.0;

  bool get darkMode => _darkMode;
  double get fontSize => _fontSize;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();  // 🔔 Theme changed!
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();  // 🔔 Font size changed!
  }
}
```

### Setting Up MultiProvider

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

### Using Multiple Providers in a Widget

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch multiple providers independently!
    final user = context.watch<UserProvider>();
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user.name}'),
        actions: [
          // Cart badge
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
          // User section
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.isLoggedIn ? 'Logged in' : 'Guest'),
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

          // Cart section
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text('Items in cart: ${cart.itemCount}'),
            trailing: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().addItem('Product ${cart.itemCount + 1}');
              },
              child: const Text('Add Item'),
            ),
          ),

          // Settings section
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: settings.darkMode,
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

## ProxyProvider: When Providers Depend on Each Other

Sometimes one provider needs data from another!

### Example: Cart Needs User ID

```dart
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
    // Step 1: Create UserProvider (independent)
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),

    // Step 2: Create CartProvider (depends on UserProvider)
    ChangeNotifierProxyProvider<UserProvider, CartProvider>(
      create: (_) => CartProvider(''),  // Initial empty
      update: (_, user, cart) => CartProvider(user.userId),
      //          ^^^^            Get userId from UserProvider
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
│    userId = "123"                       │
│         │                               │
│         │ provides userId               │
│         ▼                               │
│    CartProvider                         │
│    userId = "123" ← from UserProvider   │
│                                         │
└─────────────────────────────────────────┘
```

When `UserProvider.userId` changes, `CartProvider` automatically gets the new value!

---

## Different Provider Types

Provider offers different types for different needs:

### 1. ChangeNotifierProvider (Most Common)

For classes that extend `ChangeNotifier`:

```dart
ChangeNotifierProvider(
  create: (context) => MyNotifier(),
  child: MyApp(),
)
```

### 2. Provider (Simple Data)

For data that doesn't change:

```dart
// Simple value
Provider<String>(
  create: (_) => 'Hello World',
  child: MyApp(),
)

// Service class
Provider<ApiService>(
  create: (_) => ApiService(),
  child: MyApp(),
)
```

> There are also `FutureProvider` and `StreamProvider` for data that arrives over time (from the internet, or a live stream). Those build on Futures and Streams, which you learn in Level 8 (API) and Level 9. We will skip them for now and come back when you know async.

---

## Summary

| Concept | Purpose |
|---------|---------|
| `MultiProvider` | Use multiple providers cleanly |
| `ProxyProvider` | Provider depends on another provider |
| `Provider` | Simple/immutable data |

---

## Key Takeaways

1. **Use MultiProvider** for multiple providers (cleaner than nesting)
2. **Each provider** should handle one responsibility (user, cart, settings)
3. **ProxyProvider** lets one provider depend on another
4. Async provider types (Future, Stream) come later, after you learn async

---

## Quick Quiz

**Q1.** Why use `MultiProvider` instead of nesting providers?

<details>
<summary>Answer</summary>
It is much cleaner: a flat list of providers instead of providers nested deep inside each other.
</details>

**Q2.** How many responsibilities should one provider handle?

<details>
<summary>Answer</summary>
One. Keep separate providers for separate concerns (a UserProvider, a CartProvider, a SettingsProvider), not one giant provider for everything.
</details>

**Q3.** What is `ProxyProvider` for?

<details>
<summary>Answer</summary>
For when one provider needs data from another (for example, a cart that needs the current user's id).
</details>

---

## Assignment

### Problem 1: Convert nesting to MultiProvider

Rewrite this using `MultiProvider`:

```dart
ChangeNotifierProvider(
  create: (_) => UserProvider(),
  child: ChangeNotifierProvider(
    create: (_) => CartProvider(),
    child: const MyApp(),
  ),
)
```

### Problem 2: Watch two providers

In a widget, write the two lines that read both a `UserProvider` and a `CartProvider` for display.

### Problem 3: Split the responsibilities

You have one giant `AppState` provider holding the user, the cart, and the theme. Why is that a bad idea, and what would you do instead?

### Problem 4: Spot the smell

What is wrong with putting `FutureProvider` in this lesson's app right now?

---

## Assignment Answers

### Problem 1: Convert nesting to MultiProvider

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ],
  child: const MyApp(),
)
```

The two providers become a flat list, much easier to read than nesting.

### Problem 2: Watch two providers

```dart
final user = context.watch<UserProvider>();
final cart = context.watch<CartProvider>();
```

You watch each provider separately. The widget rebuilds when either one changes.

### Problem 3: Split the responsibilities

One giant provider for everything means any change (even the theme) notifies every widget that uses the provider, causing extra rebuilds, and the class becomes huge and hard to maintain. Split it into a `UserProvider`, a `CartProvider`, and a `SettingsProvider`, each handling one thing. Widgets then watch only the provider they need.

### Problem 4: Spot the smell

`FutureProvider` is for data that arrives from a `Future` (like a network call). You have not learned Futures or async yet (that is Level 8). Using it now would mean using tools you do not understand. Stick to `ChangeNotifierProvider` until you learn async, then come back to it.

---

**Next:** `03b-Optimization.md`, where you make rebuilds even more efficient.

---

## Navigation

⬅️ **Previous:** [Consuming State](02d-ConsumingState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Optimization](03b-Optimization.md)
