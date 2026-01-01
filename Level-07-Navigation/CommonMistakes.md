# Level 07: Common Mistakes

Learn from these common navigation errors!

---

## Mistake #1: Using MaterialApp Instead of MaterialApp.router

```dart
// ❌ WRONG - go_router won't work
MaterialApp(
  home: HomeScreen(),
)

// ✅ RIGHT
MaterialApp.router(
  routerConfig: router,
)
```

---

## Mistake #2: Wrong Path Parameter Syntax

```dart
// ❌ WRONG
GoRoute(
  path: '/product/{id}',  // Wrong: curly braces
  builder: ...
)

// ✅ RIGHT
GoRoute(
  path: '/product/:id',  // Correct: colon prefix
  builder: (context, state) {
    final id = state.pathParameters['id'];
    return ProductScreen(id: id!);
  },
)
```

---

## Mistake #3: Forgetting Leading Slash

```dart
// ❌ WRONG
context.go('product/123');  // Missing leading slash

// ✅ RIGHT
context.go('/product/123');
```

---

## Mistake #4: Using `go` When `push` is Needed

```dart
// ❌ WRONG - Can't go back
context.go('/product/123');  // Replaces entire stack

// ✅ RIGHT - For details that should stack
context.push('/product/123');  // Adds to stack, can pop back
```

**Remember:**
- `go` = navigate to location (like tabs)
- `push` = add to stack (like details)
- `pop` = go back

---

## Mistake #5: Nested Route Without Parent Path

```dart
// ❌ WRONG - Path not properly nested
GoRoute(
  path: '/',
  builder: ...,
  routes: [
    GoRoute(
      path: '/product/:id',  // Don't include parent path!
      builder: ...,
    ),
  ],
)

// ✅ RIGHT
GoRoute(
  path: '/',
  builder: ...,
  routes: [
    GoRoute(
      path: 'product/:id',  // Relative to parent
      builder: ...,
    ),
  ],
)
```

---

## Mistake #6: Redirect Infinite Loop

```dart
// ❌ WRONG - Loops forever
redirect: (context, state) {
  final isLoggedIn = false;
  if (!isLoggedIn) {
    return '/login';  // Goes to /login
  }
  return null;
}
// But /login also triggers redirect → loop!

// ✅ RIGHT - Exclude the redirect target
redirect: (context, state) {
  final isLoggedIn = false;
  final isGoingToLogin = state.matchedLocation == '/login';

  if (!isLoggedIn && !isGoingToLogin) {
    return '/login';
  }
  return null;
}
```

---

## Mistake #7: Bottom Nav Not Updating

```dart
// ❌ WRONG - Selected index hardcoded
NavigationBar(
  selectedIndex: 0,  // Always shows first tab
  onDestinationSelected: (index) {
    context.go(routes[index]);
  },
)

// ✅ RIGHT - Calculate from current location
NavigationBar(
  selectedIndex: _calculateIndex(context),
  onDestinationSelected: (index) {
    context.go(routes[index]);
  },
)

int _calculateIndex(BuildContext context) {
  final location = GoRouterState.of(context).matchedLocation;
  if (location.startsWith('/cart')) return 1;
  if (location.startsWith('/profile')) return 2;
  return 0;
}
```

---

## Mistake #8: ShellRoute Without Child

```dart
// ❌ WRONG - Forgetting to use child
ShellRoute(
  builder: (context, state, child) {
    return Scaffold(
      body: HomeScreen(),  // Wrong: ignoring child!
      bottomNavigationBar: BottomNav(),
    );
  },
)

// ✅ RIGHT - Use the child
ShellRoute(
  builder: (context, state, child) {
    return Scaffold(
      body: child,  // This is the current route's widget
      bottomNavigationBar: BottomNav(),
    );
  },
)
```

---

## Mistake #9: Passing Complex Objects Wrong

```dart
// ❌ WRONG - Object in path
context.go('/product/${product.toJson()}');  // Don't do this!

// ✅ RIGHT - Use extra for objects
context.go('/product/${product.id}', extra: product);

// In route:
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final product = state.extra as Product?;
    final id = state.pathParameters['id']!;
    // Use product if available, otherwise fetch by id
    return ProductScreen(product: product, id: id);
  },
)
```

---

## Mistake #10: Null Safety with Parameters

```dart
// ❌ WRONG - Might be null
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];  // String?
    return ProductScreen(id: id);  // Error if expecting non-null
  },
)

// ✅ RIGHT - Handle null
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    if (id == null) {
      return ErrorScreen(message: 'Product ID required');
    }
    return ProductScreen(id: id);
  },
)
```

---

## Quick Reference: Navigation Methods

| Method | Effect |
|--------|--------|
| `context.go('/path')` | Navigate, replace stack |
| `context.push('/path')` | Add to stack |
| `context.pop()` | Go back one |
| `context.replace('/path')` | Replace current only |
| `context.goNamed('name')` | Go by route name |
| `context.pushNamed('name')` | Push by route name |

---

**Still stuck? Re-read the Theory files or ask for help!**
