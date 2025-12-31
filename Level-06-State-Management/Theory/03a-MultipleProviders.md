# Part 1: Using Multiple Providers

Most real apps need more than one type of state. Let's learn how to manage multiple providers cleanly!

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

### 3. FutureProvider (Async Data)

For data from a Future (like API calls):

```dart
FutureProvider<User>(
  create: (_) => fetchUser(),  // Returns Future<User>
  initialData: User.guest(),    // Show while loading
  child: MyApp(),
)

// In widget
final user = context.watch<User>();
```

### 4. StreamProvider (Stream Data)

For real-time updates:

```dart
StreamProvider<int>(
  create: (_) => Stream.periodic(
    Duration(seconds: 1),
    (count) => count,  // Timer that counts up
  ),
  initialData: 0,
  child: MyApp(),
)
```

---

## Summary

| Concept | Purpose |
|---------|---------|
| `MultiProvider` | Use multiple providers cleanly |
| `ProxyProvider` | Provider depends on another provider |
| `Provider` | Simple/immutable data |
| `FutureProvider` | Async data from Future |
| `StreamProvider` | Real-time stream data |

---

## Key Takeaways

1. **Use MultiProvider** for multiple providers (cleaner than nesting)
2. **Each provider** should handle one responsibility (user, cart, settings)
3. **ProxyProvider** lets one provider depend on another
4. **Different types** for different needs (ChangeNotifier, Future, Stream)

---

**Next:** Learn how to optimize rebuilds with Selector!

---

## Navigation

⬅️ **Previous:** [Consuming State](02d-ConsumingState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Optimization](03b-Optimization.md)
