# GoRouter Navigation

## The Big Idea In One Sentence

> A path can carry data: a **path parameter** (`/product/:id`) names the thing, **query parameters** (`?sort=new`) add options, and **extra** passes a whole object that does not fit in a URL.

Master path parameters, query parameters, and navigation methods!

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

    // Search with query parameters
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final query = state.uri.queryParameters['query'] ?? '';
        final category = state.uri.queryParameters['category'] ?? 'all';
        return SearchScreen(query: query, category: category);
      },
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
      title: 'GoRouter Navigation Demo',
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

            ElevatedButton(
              onPressed: () => context.push('/products'),
              child: Text('View Products'),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => context.push('/search?query=laptop'),
              child: Text('Search for Laptop'),
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

class SearchScreen extends StatelessWidget {
  final String query;
  final String category;

  const SearchScreen({required this.query, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('Searching for: "$query"'),
            Text('Category: $category'),
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

## Visual Parameter Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    PARAMETER TYPES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PATH PARAMETERS (:name in path):                           │
│  ────────────────────────────────                           │
│  /product/:id → /product/123                                │
│  /user/:username → /user/john                               │
│  /store/:storeId/product/:productId                         │
│                                                             │
│  ✅ Part of the URL structure                               │
│  ✅ Required (route won't match without them)               │
│  ✅ Good for IDs, usernames, slugs                          │
│                                                             │
│  QUERY PARAMETERS (?key=value):                             │
│  ──────────────────────────────                             │
│  /search?query=flutter&sort=newest                          │
│  /products?category=electronics&page=2                      │
│                                                             │
│  ✅ Optional additions to URL                               │
│  ✅ Good for filters, sorting, pagination                   │
│  ✅ Can have multiple values                                │
│                                                             │
│  EXTRA DATA (not in URL):                                   │
│  ────────────────────────                                   │
│  context.push('/product/123', extra: productObject)         │
│                                                             │
│  ✅ Pass complex objects                                    │
│  ✅ Not visible in URL                                      │
│  ✅ Lost on page refresh (web)                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              GOROUTER NAVIGATION CHEAT SHEET                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PATH PARAMETERS:                                           │
│  ────────────────                                           │
│  Route: '/product/:id'                                      │
│  Navigate: context.push('/product/123')                     │
│  Get: state.pathParameters['id']                            │
│                                                             │
│  QUERY PARAMETERS:                                          │
│  ─────────────────                                          │
│  Navigate: context.push('/search?query=flutter&sort=new')   │
│  Get: state.uri.queryParameters['query']                    │
│                                                             │
│  EXTRA DATA:                                                │
│  ───────────                                                │
│  Navigate: context.push('/path', extra: data)               │
│  Get: state.extra as MyType                                 │
│                                                             │
│  NAMED ROUTES:                                              │
│  ─────────────                                              │
│  context.pushNamed('product', pathParameters: {'id': '1'})  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** In the route `'/product/:id'`, what is `:id`?

<details>
<summary>Answer</summary>
A path parameter, a slot in the URL. You read it with `state.pathParameters['id']`.
</details>

**Q2.** Where would you put a sort option like `sort=newest`?

<details>
<summary>Answer</summary>
In a query parameter: `/search?sort=newest`, read with `state.uri.queryParameters['sort']`.
</details>

**Q3.** You want to hand a full `Product` object to the next screen without putting it in the URL. What do you use?

<details>
<summary>Answer</summary>
`extra:` (`context.push('/product/1', extra: product)`), read with `state.extra as Product`.
</details>

---

## Assignment

### Problem 1: Read a path parameter

Inside a `GoRoute` with path `'/user/:name'`, write the line that gets the name out of `state`.

### Problem 2: Navigate with it

Write the `context.push` that opens the user screen for the name `'ada'`.

### Problem 3: Pick the parameter type

For each, choose path parameter, query parameter, or extra:
1. The id of the product being viewed.
2. A page number for a long list.
3. A full `Order` object you do not want shown in the URL.

---

## Assignment Answers

### Problem 1: Read a path parameter

```dart
final name = state.pathParameters['name']!;
```

### Problem 2: Navigate with it

```dart
context.push('/user/ada');
```

### Problem 3: Pick the parameter type

1. **Path parameter** (`/product/:id`), it identifies the screen's main thing.
2. **Query parameter** (`?page=2`), an optional extra.
3. **Extra** (`extra: order`), a complex object kept out of the URL.

---

## Navigation

⬅️ **Previous:** [GoRouter Setup](04a-GoRouterSetup.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Nested Routes](05a-NestedRoutes.md)
