# Week 11, Day 2-4: Riverpod - Modern State Management

## 5-Year-Old Explanation

Imagine you have a magical announcement system in your house (like a speaker in every room):

**Old way (without Riverpod):**
- You have to walk to each room to tell everyone dinner is ready
- You have to remember who you told and who you didn't
- Sometimes you forget to tell someone
- It's exhausting!

**New way (with Riverpod):**
- You speak into ONE microphone
- EVERY room hears it automatically
- Everyone gets the same message at the same time
- You don't have to remember anything!

Riverpod is like that magical announcement system for your Flutter app!

**How it works:**
- You put information in ONE place (a provider)
- ANY widget in your app can listen to it
- When the information changes, ALL listening widgets update automatically
- You don't have to pass information through a chain of widgets!

**Real example:**
Say your app has a user's name. Without Riverpod:
```
HomePage → needs name → asks ProfilePage
ProfilePage → asks SettingsPage
SettingsPage → asks UserWidget
UserWidget → finally has the name!
```

With Riverpod:
```
UserProvider (has the name) ← ANY widget can ask directly!
```

It's like having a library where everyone can look up the same book, instead of passing the book from person to person!

---

## What is Riverpod?

**Riverpod** = Improved version of Provider
- **Compile-time safety** - Catch errors before runtime
- **No BuildContext** - Access state anywhere
- **Better testing** - Easy to mock and test
- **No ProviderNotFoundError** - Type-safe

**Why Riverpod?**
- Most modern approach
- Great documentation
- Active development
- Growing community

---

## Setup

### 1. Add Dependencies

**pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0

dev_dependencies:
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
```

Run:
```bash
flutter pub get
```

### 2. Wrap App with ProviderScope

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

---

## Provider Types

### 1. Provider (Immutable)

For values that never change:

```dart
// Define provider
final nameProvider = Provider<String>((ref) {
  return 'John Doe';
});

final ageProvider = Provider<int>((ref) {
  return 25;
});

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider);
    final age = ref.watch(ageProvider);

    return Text('$name is $age years old');
  }
}
```

### 2. StateProvider (Simple State)

For simple mutable state:

```dart
// Define provider
final counterProvider = StateProvider<int>((ref) {
  return 0;  // Initial value
});

// Use in widget
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$count', style: TextStyle(fontSize: 48)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
                  },
                  child: Icon(Icons.add),
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

### 3. StateNotifierProvider (Complex State)

For complex state with methods:

```dart
// State class
class Counter {
  final int value;

  Counter(this.value);

  Counter copyWith({int? value}) {
    return Counter(value ?? this.value);
  }
}

// StateNotifier
class CounterNotifier extends StateNotifier<Counter> {
  CounterNotifier() : super(Counter(0));

  void increment() {
    state = state.copyWith(value: state.value + 1);
  }

  void decrement() {
    state = state.copyWith(value: state.value - 1);
  }

  void reset() {
    state = Counter(0);
  }
}

// Provider
final counterProvider = StateNotifierProvider<CounterNotifier, Counter>((ref) {
  return CounterNotifier();
});

// Use in widget
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${counter.value}', style: TextStyle(fontSize: 48)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).decrement();
                  },
                  child: Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).reset();
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).increment();
                  },
                  child: Icon(Icons.add),
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

## ConsumerWidget vs Consumer

### ConsumerWidget

Entire widget rebuilds:

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(someProvider);

    return Text('$value');  // Rebuilds entire widget
  }
}
```

### Consumer

Only part rebuilds:

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Static text'),  // Never rebuilds
        Consumer(
          builder: (context, ref, child) {
            final value = ref.watch(someProvider);
            return Text('$value');  // Only this rebuilds
          },
        ),
      ],
    );
  }
}
```

---

## ref.watch vs ref.read vs ref.listen

### ref.watch
Rebuilds when provider changes:

```dart
final value = ref.watch(provider);  // Rebuilds on change
```

### ref.read
One-time read (no rebuild):

```dart
ref.read(provider.notifier).someMethod();  // Call method only
```

### ref.listen
Listen to changes without rebuilding:

```dart
ref.listen(provider, (previous, next) {
  // Show snackbar, navigate, etc.
  if (next.isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred')),
    );
  }
});
```

---

## Complete Example: Shopping Cart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

// State
class CartState {
  final List<CartItem> items;

  CartState(this.items);

  CartState.empty() : items = [];

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items ?? this.items);
  }

  double get total {
    return items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

// StateNotifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState.empty());

  void addProduct(Product product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Increase quantity
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      );
    }
  }

  void removeProduct(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  void increaseQuantity(String productId) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void decreaseQuantity(String productId) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void clear() {
    state = CartState.empty();
  }
}

// Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Products Provider
final productsProvider = Provider<List<Product>>((ref) {
  return [
    Product(id: '1', name: 'Laptop', price: 999.99),
    Product(id: '2', name: 'Mouse', price: 29.99),
    Product(id: '3', name: 'Keyboard', price: 79.99),
    Product(id: '4', name: 'Monitor', price: 299.99),
  ];
});

// UI
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsScreen(),
    );
  }
}

class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.itemCount}'),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text('Add'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
              },
              child: Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text('Cart is empty', style: TextStyle(fontSize: 20)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                            '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  ref.read(cartProvider.notifier).decreaseQuantity(item.product.id);
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  ref.read(cartProvider.notifier).increaseQuantity(item.product.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  ref.read(cartProvider.notifier).removeProduct(item.product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${cart.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cart.items.isEmpty
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Checkout not implemented')),
                              );
                            },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Checkout', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
```

---

## Key Takeaways

1. **ProviderScope** wraps app
2. **ConsumerWidget** or **Consumer** to read providers
3. **ref.watch()** for reactive values
4. **ref.read()** for one-time access
5. **StateNotifier** for complex state
6. **Immutability** - Always create new state

---

## What's Next

Tomorrow: **Bloc pattern** - Event-driven state management
