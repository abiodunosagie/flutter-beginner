# GoRouter Basics

Learn the modern, declarative way to handle navigation in Flutter!

---

## What is GoRouter?

### Think of it Like This

Imagine you're giving directions:

**Old way (Navigator):** "Go through the lobby, up the stairs, turn left..."
**New way (GoRouter):** "Go to Room 304" - it figures out the path!

```
┌─────────────────────────────────────────────────────────────┐
│              NAVIGATOR vs GOROUTER                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NAVIGATOR (Imperative):                                    │
│  "Push this screen, then that screen, then go back..."      │
│  YOU control every step                                     │
│                                                             │
│  GOROUTER (Declarative):                                    │
│  "I want to be at /products/123"                            │
│  IT figures out how to get there                            │
│                                                             │
│  Like GPS: You say WHERE, it figures out HOW               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Why Use GoRouter?

```
┌─────────────────────────────────────────────────────────────┐
│                   GOROUTER BENEFITS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ URL-based navigation (great for web)                    │
│  ✅ Deep linking built-in                                   │
│  ✅ Easy redirects (login guards)                           │
│  ✅ Nested navigation                                       │
│  ✅ Type-safe path parameters                               │
│  ✅ Works on mobile, web, and desktop                       │
│  ✅ Clear route structure                                   │
│  ✅ Browser back/forward buttons work                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Setup

### Step 1: Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
```

### Step 2: Create Router

```dart
import 'package:go_router/go_router.dart';

// Define your router
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => DetailsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
```

### Step 3: Use in MaterialApp

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      routerConfig: router,  // Use the router!
    );
  }
}
```

---

## Basic Navigation

### Navigate to a Route

```dart
// Go to a new screen (adds to stack)
context.push('/details');

// Replace current screen
context.go('/details');

// Go back
context.pop();
```

### Visual Difference: push vs go

```
USING context.push('/details'):
──────────────────────────────
Before:           After:
┌─────────┐      ┌─────────┐
│  Home   │      │ Details │  ← New screen on top
└─────────┘      ├─────────┤
                 │  Home   │  ← Home still there
                 └─────────┘
Back button: Goes to Home

USING context.go('/details'):
─────────────────────────────
Before:           After:
┌─────────┐      ┌─────────┐
│  Home   │      │ Details │  ← Replaced Home
└─────────┘      └─────────┘
Back button: Exits app (nothing to go back to!)
```

---

## Path Parameters

### What are Path Parameters?

Like variables in your URL:
- `/products/123` - 123 is the product ID
- `/users/john` - john is the username

```dart
GoRoute(
  path: '/product/:id',  // :id is a parameter
  builder: (context, state) {
    // Get the parameter value
    final productId = state.pathParameters['id']!;
    return ProductScreen(id: productId);
  },
),
```

### Navigate with Parameters

```dart
// Go to product with ID 123
context.push('/product/123');

// Go to product with ID 456
context.push('/product/456');
```

### Multiple Parameters

```dart
GoRoute(
  path: '/store/:storeId/product/:productId',
  builder: (context, state) {
    final storeId = state.pathParameters['storeId']!;
    final productId = state.pathParameters['productId']!;
    return ProductScreen(storeId: storeId, productId: productId);
  },
),

// Navigate
context.push('/store/amazon/product/iphone');
```

---

## Query Parameters

### What are Query Parameters?

Extra information after `?` in the URL:
- `/search?query=flutter&sort=newest`

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    // Get query parameters
    final query = state.uri.queryParameters['query'] ?? '';
    final sort = state.uri.queryParameters['sort'] ?? 'relevance';
    return SearchScreen(query: query, sort: sort);
  },
),
```

### Navigate with Query Parameters

```dart
// Search for "flutter" sorted by newest
context.push('/search?query=flutter&sort=newest');

// Search with just a query
context.push('/search?query=dart');
```

---

## Extra Data

### Passing Objects (Not in URL)

Sometimes you need to pass complex data that shouldn't be in the URL:

```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    // Get path parameter
    final id = state.pathParameters['id']!;

    // Get extra data (optional)
    final product = state.extra as Product?;

    return ProductScreen(id: id, product: product);
  },
),
```

### Navigate with Extra Data

```dart
// With extra data
context.push(
  '/product/123',
  extra: product,  // Pass the entire Product object
);

// Without extra data
context.push('/product/123');  // Screen will load product by ID
```

---

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

class Product {
  final String id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

final products = [
  Product(id: '1', name: 'Laptop', price: 999.99),
  Product(id: '2', name: 'Phone', price: 699.99),
  Product(id: '3', name: 'Tablet', price: 499.99),
];

// ═══════════════════════════════════════════════════════════════
// ROUTER SETUP
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // Home route
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    // Products list
    GoRoute(
      path: '/products',
      builder: (context, state) => ProductListScreen(),
    ),

    // Product detail with ID parameter
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        // Find product or pass from extra
        final product = state.extra as Product? ??
            products.firstWhere((p) => p.id == id);
        return ProductDetailScreen(product: product);
      },
    ),

    // Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🏠', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('Welcome!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),

            // Navigate using context.push
            ElevatedButton(
              onPressed: () => context.push('/products'),
              child: Text('View Products'),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => context.push('/settings'),
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

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
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate with path parameter and extra data
              context.push('/product/${product.id}', extra: product);
            },
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
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
            Text('📦', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(product.name, style: TextStyle(fontSize: 28)),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('⚙️', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('Settings', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),

            // Go to home (replaces entire stack)
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Navigation Methods Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                  GOROUTER NAVIGATION                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  context.go('/path')                                        │
│  ─────────────────                                          │
│  Navigates to path, replaces current stack                  │
│  Like: "teleport to location"                               │
│  Use for: Tab changes, logout, deep links                   │
│                                                             │
│  context.push('/path')                                      │
│  ────────────────────                                       │
│  Adds new screen to stack                                   │
│  Like: "walk to location, remember where you came from"     │
│  Use for: Drill-down navigation (list → detail)             │
│                                                             │
│  context.pop()                                              │
│  ─────────────                                              │
│  Removes top screen, goes back                              │
│  Like: "walk back to where you came from"                   │
│  Use for: Back buttons, cancel actions                      │
│                                                             │
│  context.pushReplacement('/path')                           │
│  ─────────────────────────────────                          │
│  Replaces current screen only                               │
│  Like: "transform current location into something else"     │
│  Use for: Login → Home (don't want back to login)           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Current Location

### Get Current Path

```dart
// Get the current location
final location = GoRouterState.of(context).uri.toString();
print(location);  // e.g., '/products/123?tab=reviews'

// Get just the path
final path = GoRouterState.of(context).uri.path;
print(path);  // e.g., '/products/123'
```

### Check Current Route

```dart
final currentPath = GoRouterState.of(context).uri.path;

if (currentPath == '/') {
  // We're at home
}

if (currentPath.startsWith('/products')) {
  // We're somewhere in products
}
```

---

## Named Routes (Optional)

You can also give routes names:

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',  // Give it a name
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductScreen(id: id);
      },
    ),
  ],
);

// Navigate by name
context.pushNamed(
  'product',
  pathParameters: {'id': '123'},
);

// This is equivalent to:
context.push('/product/123');
```

---

## Error Handling

### Custom Error Page

```dart
final router = GoRouter(
  routes: [...],

  // Handle unknown routes
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404', style: TextStyle(fontSize: 80)),
            Text('Page not found'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                  GOROUTER CHEAT SHEET                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SETUP:                                                     │
│  final router = GoRouter(routes: [...]);                    │
│  MaterialApp.router(routerConfig: router)                   │
│                                                             │
│  ROUTES:                                                    │
│  GoRoute(                                                   │
│    path: '/product/:id',                                    │
│    builder: (context, state) {                              │
│      final id = state.pathParameters['id']!;                │
│      return ProductScreen(id: id);                          │
│    },                                                       │
│  )                                                          │
│                                                             │
│  NAVIGATION:                                                │
│  context.go('/path')      // Replace stack                  │
│  context.push('/path')    // Add to stack                   │
│  context.pop()            // Go back                        │
│                                                             │
│  PARAMETERS:                                                │
│  Path: /product/:id → state.pathParameters['id']            │
│  Query: ?sort=new → state.uri.queryParameters['sort']       │
│  Extra: push('/x', extra: data) → state.extra               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Passing Data](./03-PassingData.md) | [Next: GoRouter Advanced →](./05-GoRouterAdvanced.md)
