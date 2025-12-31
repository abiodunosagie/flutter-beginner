# Passing Data Between Screens - Basics

Learn the simplest way to send information from one screen to another!

---

## Why Pass Data?

### Think of it Like This

Imagine you're at a restaurant:
- You ORDER food (Screen A sends data)
- The KITCHEN receives your order (Screen B receives data)
- The kitchen knows what to make because you passed the order information!

```
┌─────────────────┐         order: "Pizza"        ┌─────────────────┐
│                 │ ─────────────────────────────>│                 │
│   CUSTOMER      │                               │    KITCHEN      │
│   (Screen A)    │                               │   (Screen B)    │
│                 │                               │                 │
└─────────────────┘                               └─────────────────┘
```

---

## Method 1: Constructor Parameters (Simplest)

### Passing Data FORWARD

```dart
// When navigating, pass data to the constructor
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsScreen(
      productId: '123',        // Pass the ID
      productName: 'Widget',   // Pass the name
      price: 29.99,           // Pass the price
    ),
  ),
);
```

### Receiving Data

```dart
class DetailsScreen extends StatelessWidget {
  // Define parameters to receive
  final String productId;
  final String productName;
  final double price;

  // Constructor requires these parameters
  const DetailsScreen({
    required this.productId,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product ID: $productId'),
            Text('Name: $productName'),
            Text('Price: \$${price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
```

---

## Complete Example: Product List

```dart
import 'package:flutter/material.dart';

// Product model
class Product {
  final String id;
  final String name;
  final double price;
  final String emoji;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
  });
}

// Sample products
final products = [
  Product(id: '1', name: 'Apple', price: 1.99, emoji: '🍎'),
  Product(id: '2', name: 'Pizza', price: 9.99, emoji: '🍕'),
  Product(id: '3', name: 'Coffee', price: 4.99, emoji: '☕'),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passing Data Demo',
      home: ProductListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 1: Product List
// ═══════════════════════════════════════════════════════════════

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Text(product.emoji, style: TextStyle(fontSize: 40)),
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // ─────────────────────────────────────────
              // PASS DATA: Send entire product object
              // ─────────────────────────────────────────
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 2: Product Details
// ═══════════════════════════════════════════════════════════════

class ProductDetailScreen extends StatelessWidget {
  // Receive the product
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(product.emoji, style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text(product.name, style: TextStyle(fontSize: 28)),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text('Product ID: ${product.id}'),
          ],
        ),
      ),
    );
  }
}
```

---

## Why Constructor Parameters?

```
┌─────────────────────────────────────────────────────────────┐
│              CONSTRUCTOR PARAMETERS BENEFITS                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ Type-safe - Compile-time checks                         │
│  ✅ Required parameters - Can't forget to pass             │
│  ✅ Clear - Easy to see what data screen needs             │
│  ✅ IDE support - Auto-complete, refactoring               │
│  ✅ Simple - No boilerplate code                           │
│                                                             │
│  BEST FOR:                                                  │
│  • Passing single objects or few parameters                 │
│  • When using MaterialPageRoute directly                    │
│  • Simple navigation flows                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Passing Multiple Types

### You Can Pass Anything!

```dart
// Pass primitive types
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      id: 123,              // int
      name: 'Widget',       // String
      price: 29.99,        // double
      isAvailable: true,   // bool
    ),
  ),
);

// Pass objects
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UserScreen(user: myUser),
  ),
);

// Pass lists
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CartScreen(items: cartItems),
  ),
);

// Pass functions (callbacks)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PickerScreen(
      onSelected: (value) {
        print('Selected: $value');
      },
    ),
  ),
);
```

---

## Visual Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DATA FLOW PATTERN                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SCREEN A (Sender)                                          │
│  ┌────────────────────────────────────────┐                 │
│  │  List of Products                      │                 │
│  │                                        │                 │
│  │  [Product 1] ──────┐                   │                 │
│  │  [Product 2]       │ User taps         │                 │
│  │  [Product 3]       │                   │                 │
│  └────────────────────┼────────────────────┘                 │
│                       │                                     │
│                       ▼                                     │
│           Navigator.push(                                   │
│             builder: (context) =>                           │
│               DetailScreen(product: product1)               │
│           )                                                 │
│                       │                                     │
│                       ▼                                     │
│  SCREEN B (Receiver)                                        │
│  ┌────────────────────────────────────────┐                 │
│  │  Product Details                       │                 │
│  │                                        │                 │
│  │  Name: Product 1                       │                 │
│  │  Price: $9.99                          │                 │
│  │  Description: ...                      │                 │
│  └────────────────────────────────────────┘                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              CONSTRUCTOR PASSING CHEAT SHEET                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SENDING DATA:                                              │
│  ─────────────                                              │
│  Navigator.push(                                            │
│    context,                                                 │
│    MaterialPageRoute(                                       │
│      builder: (context) => DetailScreen(                    │
│        id: '123',           // Pass data here               │
│        name: 'Widget',                                      │
│      ),                                                     │
│    ),                                                       │
│  );                                                         │
│                                                             │
│  RECEIVING DATA:                                            │
│  ───────────────                                            │
│  class DetailScreen extends StatelessWidget {               │
│    final String id;          // Declare fields             │
│    final String name;                                       │
│                                                             │
│    const DetailScreen({      // Constructor                │
│      required this.id,       // Receive data               │
│      required this.name,                                    │
│    });                                                      │
│                                                             │
│    @override                                                │
│    Widget build(BuildContext context) {                     │
│      return Text(name);      // Use the data               │
│    }                                                        │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now that you know the basics of passing data forward, let's learn about passing data with named routes!

**Continue to:** [Route Arguments →](03b-RouteArguments.md)

---

## Navigation

⬅️ **Previous:** [Named Routes](02-NamedRoutes.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Route Arguments](03b-RouteArguments.md)
