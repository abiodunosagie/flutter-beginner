# Named Routes in Flutter

Organize your navigation with route names instead of creating screens inline!

---

## What are Named Routes?

### Think of it Like This

Imagine a building directory:
- Instead of saying "Go to the room with the red door on floor 3"
- You just say "Go to Room 301"

Named routes are like room numbers for your screens!

```
WITHOUT Named Routes:              WITH Named Routes:
─────────────────────────         ─────────────────────────
Navigator.push(                    Navigator.pushNamed(
  context,                           context,
  MaterialPageRoute(                 '/details',
    builder: (context) =>          );
      DetailsScreen(),
  ),
);

"Go to the screen built by         "Go to '/details'"
 the DetailsScreen widget"
```

---

## Setting Up Named Routes

### Step 1: Define Routes in MaterialApp

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',

      // ─────────────────────────────────
      // Define all your routes here
      // ─────────────────────────────────
      routes: {
        '/': (context) => HomeScreen(),           // Home route
        '/details': (context) => DetailsScreen(), // Details route
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) => ProfileScreen(),
      },

      // Optional: Starting route (defaults to '/')
      initialRoute: '/',
    );
  }
}
```

### Visual Map of Routes

```
┌─────────────────────────────────────────────────────────────┐
│                       ROUTE MAP                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Route Name        │        Screen                         │
│   ─────────────────────────────────────────────────        │
│   '/'               │   HomeScreen()                        │
│   '/details'        │   DetailsScreen()                     │
│   '/settings'       │   SettingsScreen()                    │
│   '/profile'        │   ProfileScreen()                     │
│   '/profile/edit'   │   EditProfileScreen()                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Using Named Routes

### Navigate to a Named Route

```dart
// Go to details screen
Navigator.pushNamed(context, '/details');

// Go to settings
Navigator.pushNamed(context, '/settings');

// Go to nested route
Navigator.pushNamed(context, '/profile/edit');
```

### Go Back

```dart
// Same as before!
Navigator.pop(context);
```

### Other Methods with Named Routes

```dart
// Replace current route
Navigator.pushReplacementNamed(context, '/home');

// Clear stack and go to route
Navigator.pushNamedAndRemoveUntil(
  context,
  '/home',
  (route) => false,
);

// Pop until reaching a specific route
Navigator.popUntil(context, ModalRoute.withName('/home'));
```

---

## Complete Example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      theme: ThemeData(primarySwatch: Colors.blue),

      // Define all routes
      routes: {
        '/': (context) => HomeScreen(),
        '/products': (context) => ProductsScreen(),
        '/cart': (context) => CartScreen(),
        '/settings': (context) => SettingsScreen(),
      },

      initialRoute: '/',
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME SCREEN
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
            _NavButton(
              label: 'View Products',
              route: '/products',
              icon: Icons.shopping_bag,
            ),
            SizedBox(height: 20),
            _NavButton(
              label: 'View Cart',
              route: '/cart',
              icon: Icons.shopping_cart,
            ),
            SizedBox(height: 20),
            _NavButton(
              label: 'Settings',
              route: '/settings',
              icon: Icons.settings,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String route;
  final IconData icon;

  const _NavButton({
    required this.label,
    required this.route,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// OTHER SCREENS
// ═══════════════════════════════════════════════════════════════

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🛍️', style: TextStyle(fontSize: 80)),
            Text('Products Page', style: TextStyle(fontSize: 24)),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🛒', style: TextStyle(fontSize: 80)),
            Text('Cart Page', style: TextStyle(fontSize: 24)),
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
            Text('Settings Page', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
```

---

## Route Constants (Best Practice)

### Problem: Typos!

```dart
// Easy to make typos
Navigator.pushNamed(context, '/detials');  // Oops! 'details' not 'detials'
```

### Solution: Use Constants

```dart
// routes.dart - Define all route names
class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  // Private constructor - can't create instance
  AppRoutes._();
}

// Now use like this:
Navigator.pushNamed(context, AppRoutes.details);  // No typos!
```

### Complete Setup with Constants

```dart
// routes.dart
class AppRoutes {
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String settings = '/settings';

  AppRoutes._();

  // Define all routes in one place
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomeScreen(),
    products: (context) => ProductsScreen(),
    productDetail: (context) => ProductDetailScreen(),
    cart: (context) => CartScreen(),
    checkout: (context) => CheckoutScreen(),
    settings: (context) => SettingsScreen(),
  };
}

// main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoutes.routes,  // Use the routes map
      initialRoute: AppRoutes.home,
    );
  }
}

// Anywhere in your app
Navigator.pushNamed(context, AppRoutes.products);
```

---

## onGenerateRoute - For Dynamic Routes

Sometimes you need routes that can't be pre-defined:

```dart
MaterialApp(
  // Regular routes
  routes: {
    '/': (context) => HomeScreen(),
  },

  // Handle routes not in the routes map
  onGenerateRoute: (settings) {
    // settings.name = the route name (e.g., '/product/123')
    // settings.arguments = any data passed

    // Handle '/product/:id' pattern
    if (settings.name!.startsWith('/product/')) {
      final productId = settings.name!.split('/').last;
      return MaterialPageRoute(
        builder: (context) => ProductScreen(id: productId),
      );
    }

    // Handle '/user/:id' pattern
    if (settings.name!.startsWith('/user/')) {
      final userId = settings.name!.split('/').last;
      return MaterialPageRoute(
        builder: (context) => UserScreen(id: userId),
      );
    }

    // Unknown route
    return MaterialPageRoute(
      builder: (context) => NotFoundScreen(),
    );
  },

  // Called when route not found anywhere
  onUnknownRoute: (settings) {
    return MaterialPageRoute(
      builder: (context) => NotFoundScreen(),
    );
  },
);
```

### Using Dynamic Routes

```dart
// Navigate to product with ID 123
Navigator.pushNamed(context, '/product/123');

// Navigate to user with ID 456
Navigator.pushNamed(context, '/user/456');
```

---

## Comparison: push() vs pushNamed()

```
┌─────────────────────────────────────────────────────────────┐
│           Navigator.push() vs Navigator.pushNamed()          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Navigator.push():                                          │
│  ─────────────────                                          │
│  ✅ Works without setup                                     │
│  ✅ Can pass constructor parameters directly                │
│  ❌ Creates tight coupling                                  │
│  ❌ Route definition scattered throughout app               │
│                                                             │
│  Navigator.pushNamed():                                     │
│  ─────────────────────                                      │
│  ✅ All routes defined in one place                         │
│  ✅ Easy to see app structure                               │
│  ✅ Less code when navigating                               │
│  ❌ Requires setup in MaterialApp                           │
│  ❌ Passing data requires arguments                         │
│                                                             │
│  RECOMMENDATION:                                            │
│  Use named routes for apps with 5+ screens                  │
│  Use Navigator.push() for simple 2-3 screen apps           │
│  Use GoRouter for the best of both worlds!                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Common Patterns

### Pattern 1: Route Groups

```dart
class AppRoutes {
  // Auth routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // Main routes
  static const String home = '/';
  static const String feed = '/feed';
  static const String explore = '/explore';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/profile/settings';

  // Product routes
  static const String products = '/products';
  static const String productDetail = '/products/detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
}
```

### Pattern 2: Route Generator Helper

```dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(HomeScreen(), settings);

      case '/products':
        return _buildRoute(ProductsScreen(), settings);

      case '/product':
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          ProductDetailScreen(id: args['id']),
          settings,
        );

      default:
        return _buildRoute(NotFoundScreen(), settings);
    }
  }

  static MaterialPageRoute _buildRoute(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => screen,
      settings: settings,
    );
  }
}

// Use in MaterialApp
MaterialApp(
  onGenerateRoute: AppRouter.generateRoute,
  initialRoute: '/',
)
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    NAMED ROUTES SUMMARY                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. DEFINE routes in MaterialApp:                           │
│     routes: {                                               │
│       '/': (context) => HomeScreen(),                       │
│       '/details': (context) => DetailsScreen(),             │
│     }                                                       │
│                                                             │
│  2. NAVIGATE using route names:                             │
│     Navigator.pushNamed(context, '/details')                │
│                                                             │
│  3. USE CONSTANTS to avoid typos:                           │
│     class AppRoutes {                                       │
│       static const details = '/details';                    │
│     }                                                       │
│                                                             │
│  4. HANDLE DYNAMIC routes with onGenerateRoute              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---


---

## Navigation

⬅️ **Previous:** [Basic Navigation](01-BasicNavigation.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Passing Basics](03a-PassingBasics.md)
