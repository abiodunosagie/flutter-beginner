# Route Arguments

Learn how to pass data using named routes and route arguments!

---

## What are Route Arguments?

### Think of it Like This

Imagine sending a package through the mail:
- Constructor parameters = Hand-delivering to specific person
- Route arguments = Putting package in mailbox with an address

```
┌─────────────────────────────────────────────────────────────┐
│                   ROUTE ARGUMENTS CONCEPT                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  When you navigate to a named route:                        │
│                                                             │
│  Navigator.pushNamed(                                       │
│    context,                                                 │
│    '/details',           ← Route name (the "address")       │
│    arguments: product,   ← Data (the "package")            │
│  );                                                         │
│                                                             │
│  The route receives the package when it arrives!            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Method 2: Named Route Arguments

### Passing Data with Named Routes

```dart
// Navigate and pass arguments
Navigator.pushNamed(
  context,
  '/details',
  arguments: {
    'productId': '123',
    'productName': 'Widget',
    'price': 29.99,
  },
);

// OR pass an object
Navigator.pushNamed(
  context,
  '/details',
  arguments: product,  // Pass the whole Product object
);
```

### Receiving Arguments

```dart
class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ─────────────────────────────────────────
    // GET ARGUMENTS from the route
    // ─────────────────────────────────────────
    final args = ModalRoute.of(context)!.settings.arguments;

    // If you passed a Map:
    if (args is Map<String, dynamic>) {
      final productId = args['productId'];
      final productName = args['productName'];
      final price = args['price'];

      return Scaffold(
        appBar: AppBar(title: Text(productName)),
        body: Center(child: Text('Price: \$$price')),
      );
    }

    // If you passed a Product object:
    if (args is Product) {
      return Scaffold(
        appBar: AppBar(title: Text(args.name)),
        body: Center(child: Text('Price: \$${args.price}')),
      );
    }

    // Fallback if no arguments
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(child: Text('No product data')),
    );
  }
}
```

---

## Better Approach: onGenerateRoute

### Why Use onGenerateRoute?

```
┌─────────────────────────────────────────────────────────────┐
│               ONGENERATEROUTE BENEFITS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ Centralized route handling                              │
│  ✅ Type-safe argument extraction                           │
│  ✅ Better error handling                                   │
│  ✅ Easier to maintain                                      │
│  ✅ Can validate arguments before building screen           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Implementation

```dart
MaterialApp(
  onGenerateRoute: (settings) {
    // Extract route name
    if (settings.name == '/details') {
      // Extract and validate arguments
      final product = settings.arguments as Product;

      return MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      );
    }

    // Handle /user route
    if (settings.name == '/user') {
      final userId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) => UserScreen(userId: userId),
      );
    }

    // Default/unknown route
    return MaterialPageRoute(builder: (context) => HomeScreen());
  },
);
```

---

## Complete Example: Named Routes with Arguments

```dart
import 'package:flutter/material.dart';

// Model
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

final products = [
  Product(id: '1', name: 'Laptop', price: 999.99, emoji: '💻'),
  Product(id: '2', name: 'Phone', price: 699.99, emoji: '📱'),
  Product(id: '3', name: 'Tablet', price: 499.99, emoji: '📋'),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Arguments Demo',

      // Define named routes
      routes: {
        '/': (context) => ProductListScreen(),
      },

      // Handle routes with arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          );
        }

        // Unknown route
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Page not found')),
          ),
        );
      },
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
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Text(product.emoji, style: TextStyle(fontSize: 40)),
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // ─────────────────────────────────────────
                // NAVIGATE with arguments
                // ─────────────────────────────────────────
                Navigator.pushNamed(
                  context,
                  '/product',
                  arguments: product,  // Pass the product
                );
              },
            ),
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
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                product.emoji,
                style: TextStyle(fontSize: 100),
              ),
            ),
            SizedBox(height: 20),
            Text(
              product.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Product ID: ${product.id}',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Argument Types You Can Pass

### Different Data Types

```dart
// 1. Simple types
Navigator.pushNamed(
  context,
  '/profile',
  arguments: 'user123',  // String
);

// 2. Maps
Navigator.pushNamed(
  context,
  '/settings',
  arguments: {
    'theme': 'dark',
    'notifications': true,
    'fontSize': 16,
  },
);

// 3. Custom objects
Navigator.pushNamed(
  context,
  '/product',
  arguments: Product(id: '1', name: 'Widget', price: 9.99),
);

// 4. Lists
Navigator.pushNamed(
  context,
  '/cart',
  arguments: [item1, item2, item3],
);
```

---

## Safe Argument Extraction

### Helper Function for Type Safety

```dart
// Helper to safely extract arguments
T? getArgument<T>(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  if (args is T) return args;
  return null;
}

// Use in screen
class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = getArgument<Product>(context);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Invalid product data')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(child: Text('\$${product.price}')),
    );
  }
}
```

---

## Visual Comparison

```
┌─────────────────────────────────────────────────────────────┐
│         CONSTRUCTOR vs ROUTE ARGUMENTS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CONSTRUCTOR PARAMETERS:                                    │
│  ──────────────────────                                     │
│  Navigator.push(                                            │
│    context,                                                 │
│    MaterialPageRoute(                                       │
│      builder: (c) => DetailScreen(data: data),              │
│    ),                                                       │
│  );                                                         │
│                                                             │
│  ✅ Type-safe                                               │
│  ✅ Compile-time checks                                     │
│  ❌ Can't use with named routes easily                      │
│                                                             │
│  ROUTE ARGUMENTS:                                           │
│  ────────────────                                           │
│  Navigator.pushNamed(                                       │
│    context,                                                 │
│    '/details',                                              │
│    arguments: data,                                         │
│  );                                                         │
│                                                             │
│  ✅ Works with named routes                                 │
│  ✅ Centralized in onGenerateRoute                          │
│  ❌ Runtime type checks needed                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              ROUTE ARGUMENTS CHEAT SHEET                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SENDING ARGUMENTS:                                         │
│  ──────────────────                                         │
│  Navigator.pushNamed(                                       │
│    context,                                                 │
│    '/details',                                              │
│    arguments: myData,  ← Any type                          │
│  );                                                         │
│                                                             │
│  RECEIVING ARGUMENTS:                                       │
│  ────────────────────                                       │
│  final args = ModalRoute.of(context)!.settings.arguments;   │
│  final product = args as Product;                           │
│                                                             │
│  USING ONGENERATEROUTE:                                     │
│  ──────────────────────                                     │
│  onGenerateRoute: (settings) {                              │
│    if (settings.name == '/details') {                       │
│      final data = settings.arguments as MyType;             │
│      return MaterialPageRoute(                              │
│        builder: (c) => DetailScreen(data: data),            │
│      );                                                     │
│    }                                                        │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now that you know how to pass data with named routes, let's learn about returning data when navigating back!

**Continue to:** [Returning Data →](03c-ReturningData.md)

---

## Navigation

⬅️ **Previous:** [Passing Basics](03a-PassingBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Returning Data](03c-ReturningData.md)
