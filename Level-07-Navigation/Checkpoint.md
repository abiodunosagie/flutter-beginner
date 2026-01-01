# Level 07 Checkpoint: Navigation

Before moving to Level 08, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Navigator Basics
What's the difference?

```dart
// Option A
Navigator.push(context, MaterialPageRoute(
  builder: (context) => DetailScreen(),
));

// Option B
Navigator.pushNamed(context, '/detail');

// Option C
context.go('/detail');

// Option D
context.push('/detail');
```

<details>
<summary>Check Answers</summary>

- **A**: Direct push - creates route inline
- **B**: Named route - uses route table in MaterialApp
- **C**: go_router go - replaces current location (no back)
- **D**: go_router push - adds to stack (can go back)

</details>

---

### 2. go_router Setup
What's missing in this router configuration?

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        // How do I get the id?
        return ProductScreen(id: ???);
      },
    ),
  ],
);
```

<details>
<summary>Check Answer</summary>

```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;  // ← Get path parameter
    return ProductScreen(id: id);
  },
),
```

For query parameters: `state.uri.queryParameters['search']`

</details>

---

### 3. ShellRoute
What is ShellRoute used for?

```dart
ShellRoute(
  builder: (context, state, child) => MainShell(child: child),
  routes: [
    GoRoute(path: '/', builder: ...),
    GoRoute(path: '/search', builder: ...),
    GoRoute(path: '/cart', builder: ...),
  ],
)
```

<details>
<summary>Check Answer</summary>

ShellRoute wraps multiple routes in a shared layout (like bottom navigation).

- The `child` parameter is the current route's content
- The shell (MainShell) stays constant while routes change
- Perfect for tabs, drawers, persistent app bars

</details>

---

### 4. Navigation Methods
When would you use each?

```dart
context.go('/home');           // When?
context.push('/product/123');  // When?
context.pop();                 // When?
context.replace('/success');   // When?
```

<details>
<summary>Check Answers</summary>

- **go**: Navigate to a new location, clearing the stack (like bottom nav tabs)
- **push**: Add a screen on top (user expects to go back)
- **pop**: Go back to previous screen
- **replace**: Replace current screen (checkout → success, no going back to checkout)

</details>

---

### 5. Route Guards (Redirect)
What does this redirect do?

```dart
GoRouter(
  redirect: (context, state) {
    final isLoggedIn = context.read<UserProvider>().isLoggedIn;
    final isGoingToLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isGoingToLogin) {
      return '/login?redirect=${state.matchedLocation}';
    }
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }
    return null;
  },
  routes: [...],
)
```

<details>
<summary>Check Answer</summary>

This redirect:
1. If user is NOT logged in AND not already going to login → redirect to login
2. Saves the original destination as a query parameter
3. If user IS logged in AND going to login → redirect to home
4. Otherwise, allow navigation (return null)

This is an authentication guard pattern.

</details>

---

### 6. Passing Data
What are the different ways to pass data between screens?

<details>
<summary>Check Answer</summary>

**1. Path Parameters** (for IDs):
```dart
GoRoute(path: '/product/:id', ...)
context.go('/product/123');
```

**2. Query Parameters** (for filters, optional data):
```dart
context.go('/search?category=electronics&sort=price');
state.uri.queryParameters['category']
```

**3. Extra (for complex objects)**:
```dart
context.go('/product/123', extra: product);
state.extra as Product
```

**4. State Management** (for shared data):
```dart
context.read<CartProvider>().selectedProduct
```

</details>

---

## Hands-On Check

### Task 1: Create Route Configuration
Set up routes for a shop app:

```dart
// Routes needed:
// /           → HomeScreen
// /product/:id → ProductScreen
// /cart       → CartScreen
// /cart/checkout → CheckoutScreen
// /profile    → ProfileScreen
```

<details>
<summary>Example Solution</summary>

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
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
                final id = state.pathParameters['id']!;
                return ProductScreen(productId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
          routes: [
            GoRoute(
              path: 'checkout',
              builder: (context, state) => const CheckoutScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
```

</details>

---

### Task 2: Bottom Navigation Shell
Create a shell with bottom navigation:

```dart
class MainShell extends StatelessWidget {
  final Widget child;

  // Implement:
  // - Bottom navigation with 3-4 tabs
  // - Current tab highlighted based on location
  // - Tap changes location
}
```

<details>
<summary>Example Solution</summary>

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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/cart')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/cart');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
}
```

</details>

---

### Task 3: Auth Guard
Implement a redirect that protects checkout:

```dart
// Requirements:
// - /cart/checkout requires login
// - If not logged in, redirect to /login
// - After login, return to checkout
```

<details>
<summary>Example Solution</summary>

```dart
GoRouter(
  redirect: (context, state) {
    final isLoggedIn = context.read<UserProvider>().isLoggedIn;
    final location = state.matchedLocation;

    // Protect checkout
    if (location.startsWith('/cart/checkout') && !isLoggedIn) {
      return '/login?redirect=$location';
    }

    return null;  // Allow navigation
  },
  routes: [
    // ... your routes
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final redirect = state.uri.queryParameters['redirect'];
        return LoginScreen(redirectTo: redirect);
      },
    ),
  ],
)

// In LoginScreen after successful login:
void _onLoginSuccess() {
  final redirect = widget.redirectTo ?? '/';
  context.go(redirect);
}
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Navigation stack | _________________ |
| push vs go | _________________ |
| Path parameter | _________________ |
| Query parameter | _________________ |
| ShellRoute | _________________ |
| Route guard | _________________ |
| Deep linking | _________________ |

---

## Ready for Level 08?

### I can confidently:
- [ ] Set up go_router in my app
- [ ] Define routes with path parameters
- [ ] Use ShellRoute for bottom navigation
- [ ] Navigate with go, push, pop, replace
- [ ] Pass data via path params, query params, or extra
- [ ] Implement authentication guards
- [ ] Handle deep links

### Capstone Progress:
- [ ] I set up complete app navigation
- [ ] Bottom navigation works correctly
- [ ] Product detail screen receives product ID
- [ ] Checkout flow protects against unauthorized access
- [ ] Back button behavior is correct

---

## If You're Stuck

**Common issues at this level:**

1. **"No GoRouter found in context"**
   - Make sure MaterialApp.router is used, not MaterialApp
   - Router must be configured with routerConfig

2. **Bottom nav not highlighting**
   - Check your selectedIndex calculation
   - Make sure you're matching the right paths

3. **Nested routes not working**
   - Child routes need their parent path prefix
   - `/product/:id` under `/` becomes full path `/product/:id`

4. **Redirect loop**
   - Make sure redirect returns null for allowed routes
   - Check your conditions carefully

---

**Ready to level up? Head to Level 08: API Integration!**
