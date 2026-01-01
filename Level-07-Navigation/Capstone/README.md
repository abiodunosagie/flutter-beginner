# Level 07 Capstone: App Navigation Flow

## What You're Building

In this level, you'll create the **complete navigation structure** - bottom tabs, product details, checkout flow, and more!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 07 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase Navigation Map                                    │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    │   │
│   │   │ Home │────│Search│────│ Cart │────│Profile│   │   │
│   │   └──┬───┘    └──┬───┘    └──┬───┘    └──┬───┘    │   │
│   │      │           │           │           │         │   │
│   │      ▼           ▼           ▼           ▼         │   │
│   │   ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    │   │
│   │   │Detail│    │Filter│    │Check │    │Orders│    │   │
│   │   │ Page │    │ Page │    │ out  │    │      │    │   │
│   │   └──────┘    └──────┘    └──┬───┘    └──────┘    │   │
│   │                              │                     │   │
│   │                              ▼                     │   │
│   │                           ┌──────┐                 │   │
│   │                           │Success│                │   │
│   │                           └──────┘                 │   │
│   │                                                     │   │
│   │   [🏠 Home] [🔍 Search] [🛒 Cart] [👤 Profile]     │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Router Configuration (go_router)

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    // Shell route for bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'product/:id',
              builder: (context, state) {
                final productId = state.pathParameters['id']!;
                return ProductDetailScreen(productId: productId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
          routes: [
            GoRoute(
              path: 'checkout',
              builder: (context, state) => const CheckoutScreen(),
            ),
            GoRoute(
              path: 'success',
              builder: (context, state) => const OrderSuccessScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'orders',
              builder: (context, state) => const OrderHistoryScreen(),
            ),
            GoRoute(
              path: 'orders/:orderId',
              builder: (context, state) {
                final orderId = state.pathParameters['orderId']!;
                return OrderDetailScreen(orderId: orderId);
              },
            ),
          ],
        ),
      ],
    ),
    // Auth routes (outside shell)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
  redirect: (context, state) {
    // Redirect to login if not authenticated for protected routes
    final isLoggedIn = context.read<UserProvider>().isLoggedIn;
    final isProtected = state.matchedLocation.startsWith('/cart/checkout') ||
        state.matchedLocation.startsWith('/profile');

    if (isProtected && !isLoggedIn) {
      return '/login?redirect=${state.matchedLocation}';
    }
    return null;
  },
);
```

### Task 2: Main Shell with Bottom Navigation

```dart
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Badge(
              label: Consumer<CartProvider>(
                builder: (context, cart, _) => Text('${cart.itemCount}'),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

### Task 3: Product Detail Screen

```dart
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image with app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-$productId',
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          // Product info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
                  Text(product.formattedPrice, style: priceStyle),
                  RatingStars(rating: product.rating),
                  Text(product.description),
                  // Size selector, color selector, etc.
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AddToCartBar(product: product),
    );
  }
}
```

### Task 4: Checkout Flow

```dart
class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _placeOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('Shipping'),
            content: ShippingAddressForm(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Payment'),
            content: PaymentMethodForm(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Review'),
            content: OrderReview(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  void _placeOrder() {
    // Process order and navigate to success
    context.go('/cart/success');
  }
}
```

---

## Navigation Cheat Sheet

```dart
// Navigate to route
context.go('/cart');

// Navigate with parameter
context.go('/product/${product.id}');

// Push (can go back)
context.push('/product/${product.id}');

// Go back
context.pop();

// Go back with result
context.pop(result);

// Replace current route
context.replace('/cart/success');
```

---

## Deep Linking URLs

```
shopease://                     → Home
shopease://product/123          → Product Detail
shopease://cart                 → Cart
shopease://cart/checkout        → Checkout
shopease://profile              → Profile
shopease://profile/orders       → Order History
shopease://profile/orders/456   → Order Detail
```

---

## Success Criteria

- [ ] Bottom navigation works correctly
- [ ] Product detail opens with hero animation
- [ ] Checkout stepper flow works
- [ ] Protected routes redirect to login
- [ ] Deep links work on iOS and Android
- [ ] Back button behavior is correct
- [ ] Cart badge updates in navigation

---

## Files to Create

```
shopease/
└── lib/
    ├── router/
    │   └── app_router.dart         ◄── Create
    │
    └── screens/
        ├── main_shell.dart         ◄── Create
        ├── home/
        ├── search/
        │   └── search_screen.dart  ◄── Create
        ├── cart/
        │   └── checkout_screen.dart ◄── Create
        └── profile/
            ├── profile_screen.dart  ◄── Create
            └── orders/
                └── order_history.dart ◄── Create
```

---

**Your ShopEase app now has professional navigation!**
