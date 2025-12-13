# GoRouter Basics: Modern Flutter Navigation

## What You'll Learn

- What GoRouter is and why it's powerful
- Setting up GoRouter in your Flutter app
- Defining routes declaratively
- Navigating between screens
- Passing data between routes
- Error handling (404 pages)
- Best practices
- 5 progressive exercises

By the end, you'll handle navigation like a pro!

## Understanding GoRouter (Like Teaching a 5-Year-Old)

### Old Way vs New Way

**Old Way (Navigator 1.0):**
```
You: "I want to go to the store"
Navigator: *Physically pushes you there*
You: "Now go to the park"
Navigator: *Pushes you again*
You: "Go back"
Navigator: *Pops you back*

Problem: Hard to know where you are, can't bookmark locations
```

**New Way (GoRouter):**
```
You: "Go to /store"
GoRouter: *Takes you to store screen*
You: "Go to /park"
GoRouter: *Takes you to park screen*
You: Can share link: myapp.com/park
You: Can bookmark it!
You: Back button just works!

Benefits: Clear URLs, deep linking, web support!
```

### Why GoRouter?

✅ **Declarative routing** - Define all routes in one place
✅ **Type-safe** - Compile-time route checking
✅ **Deep linking** - Handle web URLs automatically
✅ **Nested routes** - Tab bars, bottom nav with separate stacks
✅ **Redirects** - Authentication guards, conditional routing
✅ **Web support** - URLs in browser work perfectly

## Part 1: Setup

### Add Dependency

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^13.0.0
```

### Basic Setup

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'GoRouter Demo',
    );
  }

  // Define router
  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => DetailsScreen(),
      ),
    ],
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate using context.go()
            context.go('/details');
          },
          child: Text('Go to Details'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Go back
            context.pop();
          },
          child: Text('Go Back'),
        ),
      ),
    );
  }
}
```

## Part 2: Navigation Methods

### context.go() vs context.push()

```dart
// go() - Replace current page (no back button)
context.go('/profile');

// push() - Push new page on stack (shows back button)
context.push('/profile');

// pop() - Go back
context.pop();

// goNamed() - Navigate by route name
context.goNamed('profile');

// pushNamed() - Push by route name
context.pushNamed('profile');
```

## Part 3: Route Parameters

### Path Parameters

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/user/:id',  // :id is a parameter
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return UserScreen(userId: id);
      },
    ),
    GoRoute(
      path: '/product/:category/:id',  // Multiple parameters
      builder: (context, state) {
        final category = state.pathParameters['category']!;
        final id = state.pathParameters['id']!;
        return ProductScreen(category: category, productId: id);
      },
    ),
  ],
);

// Navigate with parameters
context.go('/user/123');
context.go('/product/electronics/456');
```

### Query Parameters

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final filter = state.uri.queryParameters['filter'] ?? 'all';
    return SearchScreen(query: query, filter: filter);
  },
)

// Navigate with query params
context.go('/search?q=flutter&filter=new');
```

### Extra Data (Not in URL)

```dart
GoRoute(
  path: '/details',
  builder: (context, state) {
    final user = state.extra as User;  // Extra data
    return DetailsScreen(user: user);
  },
)

// Pass extra data
final user = User(name: 'John', age: 30);
context.push('/details', extra: user);
```

## Part 4: Named Routes

More maintainable for large apps!

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',  // Give it a name
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/user/:id',
      name: 'user',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return UserScreen(userId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);

// Navigate by name
context.goNamed('home');
context.pushNamed('user', pathParameters: {'id': '123'});
context.pushNamed(
  'user',
  pathParameters: {'id': '456'},
  queryParameters: {'tab': 'posts'},
);
```

## Part 5: Error Handling (404 Page)

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => AboutScreen(),
    ),
  ],
  // Handle unknown routes
  errorBuilder: (context, state) => NotFoundScreen(),
);

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('404')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('The page you requested does not exist.'),
            SizedBox(height: 30),
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

## Part 6: Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'GoRouter Example',
    );
  }
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) => ProductListScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'productDetails',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => NotFoundScreen(),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.goNamed('products'),
              child: Text('View Products'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goNamed('cart'),
              child: Text('View Cart'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goNamed('profile'),
              child: Text('View Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Map<String, String>> products = [
    {'id': '1', 'name': 'Product 1'},
    {'id': '2', 'name': 'Product 2'},
    {'id': '3', 'name': 'Product 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']!),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.pushNamed(
                'productDetails',
                pathParameters: {'id': product['id']!},
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  ProductDetailsScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $productId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Product Details for ID: $productId',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.goNamed('cart'),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Center(child: Text('Your cart is empty')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('User Profile')),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('404')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text('Page Not Found', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed('home'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Exercises

### Exercise 1: Simple Navigation (Beginner)
Create a 3-screen app: Home → About → Contact
- Use GoRouter with named routes
- Navigate between screens
- Handle back navigation

### Exercise 2: Product Catalog (Beginner-Intermediate)
Build a product listing with details
- List of products with IDs
- Tap product to view details
- Pass product ID via path parameter
- Show 404 for invalid IDs

### Exercise 3: Blog App (Intermediate)
Create a blog with categories and posts
- Home screen
- Category list (/categories)
- Posts in category (/category/:id)
- Post details (/post/:id)
- Search with query params (/search?q=flutter)

### Exercise 4: E-Commerce (Intermediate-Advanced)
Build multi-level navigation
- Home → Categories → Products → Product Details
- Cart screen (accessible from anywhere)
- Pass product objects as extra data
- Implement proper 404 handling

### Exercise 5: Social Media (Advanced)
Complex nested structure
- Feed → Profile → Posts → Comments
- Direct messages
- Search with filters
- Handle deep links properly
- Error pages for invalid users/posts

## Best Practices

✅ Use named routes for maintainability
✅ Handle 404 errors gracefully
✅ Use path parameters for IDs
✅ Use query parameters for optional filters
✅ Keep route definitions centralized
✅ Use const constructors where possible

## What's Next

Next lesson: **Nested Navigation & Tab Bars** with ShellRoute!

You're mastering modern Flutter navigation! 🚀
