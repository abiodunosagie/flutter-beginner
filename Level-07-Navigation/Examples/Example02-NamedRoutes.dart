// Example 02: Named Routes
// Organize navigation using route names

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
// ROUTE CONSTANTS (Best Practice - avoid typos!)
// ═══════════════════════════════════════════════════════════════

class AppRoutes {
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/product';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Private constructor
  AppRoutes._();
}

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),

      // ─────────────────────────────────────────
      // DEFINE ALL ROUTES HERE
      // ─────────────────────────────────────────
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.products: (context) => const ProductsScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },

      // Handle routes that need arguments
      onGenerateRoute: (settings) {
        // Handle /product route with arguments
        if (settings.name == AppRoutes.productDetail) {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              id: args?['id'] ?? '0',
              name: args?['name'] ?? 'Unknown',
            ),
          );
        }
        return null;
      },

      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
      },

      initialRoute: AppRoutes.home,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME SCREEN
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏪', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              const Text(
                'My Shop',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Using Named Routes for Navigation',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              _MenuButton(
                icon: Icons.shopping_bag,
                label: 'View Products',
                route: AppRoutes.products,
              ),
              const SizedBox(height: 12),
              _MenuButton(
                icon: Icons.shopping_cart,
                label: 'View Cart',
                route: AppRoutes.cart,
              ),
              const SizedBox(height: 12),
              _MenuButton(
                icon: Icons.person,
                label: 'Profile',
                route: AppRoutes.profile,
              ),
              const SizedBox(height: 12),
              _MenuButton(
                icon: Icons.settings,
                label: 'Settings',
                route: AppRoutes.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PRODUCTS SCREEN
// ═══════════════════════════════════════════════════════════════

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static const products = [
    {'id': '1', 'name': 'Laptop', 'price': 999.99, 'emoji': '💻'},
    {'id': '2', 'name': 'Phone', 'price': 699.99, 'emoji': '📱'},
    {'id': '3', 'name': 'Headphones', 'price': 199.99, 'emoji': '🎧'},
    {'id': '4', 'name': 'Watch', 'price': 299.99, 'emoji': '⌚'},
    {'id': '5', 'name': 'Tablet', 'price': 499.99, 'emoji': '📟'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: Text(
                product['emoji'] as String,
                style: const TextStyle(fontSize: 40),
              ),
              title: Text(product['name'] as String),
              subtitle: Text('\$${product['price']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // ─────────────────────────────────────────
                // NAVIGATE WITH ARGUMENTS
                // ─────────────────────────────────────────
                Navigator.pushNamed(
                  context,
                  AppRoutes.productDetail,
                  arguments: {
                    'id': product['id'],
                    'name': product['name'],
                    'price': product['price'],
                    'emoji': product['emoji'],
                  },
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
// PRODUCT DETAIL SCREEN (receives arguments)
// ═══════════════════════════════════════════════════════════════

class ProductDetailScreen extends StatelessWidget {
  final String id;
  final String name;

  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // Get full arguments if passed
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final emoji = args?['emoji'] ?? '📦';
    final price = args?['price'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              'Product ID: $id',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name added to cart!')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CART SCREEN
// ═══════════════════════════════════════════════════════════════

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text(
              'Your Cart',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Your cart is empty',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.products);
              },
              child: const Text('Browse Products'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ═══════════════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Text('JD', style: TextStyle(fontSize: 36, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════════

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Go back to home and clear stack
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 404 NOT FOUND SCREEN
// ═══════════════════════════════════════════════════════════════

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Page Not Found'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGET: Menu Button
// ═══════════════════════════════════════════════════════════════

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Route Constants
 *    - Define routes as constants to avoid typos
 *    - Easy to refactor route names
 *
 * 2. routes Map
 *    - Define all simple routes in MaterialApp
 *    - Map route names to screen widgets
 *
 * 3. onGenerateRoute
 *    - Handle routes that need parameters
 *    - Parse arguments and create screens
 *
 * 4. onUnknownRoute
 *    - Handle 404 / unknown routes
 *    - Show error page for invalid routes
 *
 * 5. Navigator.pushNamed()
 *    - Navigate using route name
 *    - Pass arguments with 'arguments' parameter
 *
 * 6. Navigator.pushNamedAndRemoveUntil()
 *    - Navigate and clear stack
 *    - Useful for logout flows
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a checkout flow with multiple steps
 * 2. Implement order history screen
 * 3. Add wishlist functionality
 * 4. Create a search screen with query parameters
 *
 */
