# Query Parameters and Transitions

Learn about query parameters and custom page transitions!

---

## Query Parameters in Detail

### What are Query Parameters?

Extra information after `?` in the URL that's optional:
- `/search?query=flutter&sort=newest&page=2`

```
┌─────────────────────────────────────────────────────────────┐
│                  QUERY PARAMETERS                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PATH: /search?query=flutter&sort=newest                    │
│                │      │              │                      │
│                │      │              └─ Parameter: sort     │
│                │      └──────────────── Parameter: query    │
│                └───────────────────────  Base path          │
│                                                             │
│  ✅ Optional (page works without them)                      │
│  ✅ Multiple values supported                               │
│  ✅ Great for filters, sorting, pagination                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Using Query Parameters

```dart
GoRoute(
  path: '/products',
  builder: (context, state) {
    // Get query parameters
    final category = state.uri.queryParameters['category'] ?? 'all';
    final sortBy = state.uri.queryParameters['sort'] ?? 'name';
    final page = int.tryParse(
      state.uri.queryParameters['page'] ?? '1'
    ) ?? 1;

    return ProductsScreen(
      category: category,
      sortBy: sortBy,
      page: page,
    );
  },
),

// Navigate with different query combinations
context.push('/products?category=electronics&sort=price&page=1');
context.push('/products?category=books');
context.push('/products');  // Uses defaults
```

---

## Transitions

### Custom Page Transitions

```dart
GoRoute(
  path: '/details',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: DetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade transition
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
),
```

### Common Transitions

```dart
// Slide from right
transitionsBuilder: (context, animation, _, child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

// Slide from bottom
transitionsBuilder: (context, animation, _, child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

// Scale
transitionsBuilder: (context, animation, _, child) {
  return ScaleTransition(
    scale: animation,
    child: child,
  );
}

// Rotation
transitionsBuilder: (context, animation, _, child) {
  return RotationTransition(
    turns: animation,
    child: child,
  );
}
```

---

## Complete Transitions Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    // Fade transition
    GoRoute(
      path: '/fade',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailScreen(title: 'Fade', color: Colors.blue),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    // Slide transition
    GoRoute(
      path: '/slide',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailScreen(title: 'Slide', color: Colors.green),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),

    // Scale transition
    GoRoute(
      path: '/scale',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailScreen(title: 'Scale', color: Colors.orange),
          transitionsBuilder: (context, animation, _, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Transitions Demo',
      routerConfig: router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transitions Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push('/fade'),
              child: Text('Fade Transition'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/slide'),
              child: Text('Slide Transition'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/scale'),
              child: Text('Scale Transition'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title;
  final Color color;

  const DetailScreen({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: color),
      body: Container(
        color: color.withOpacity(0.1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$title Transition',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## TypedGoRoute (Type-Safe Routes)

### Why Use TypedGoRoute?

```
┌─────────────────────────────────────────────────────────────┐
│                  TYPEDGOROUTE BENEFITS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ Type-safe navigation - compile-time checking            │
│  ✅ Auto-complete for parameters                            │
│  ✅ Refactoring support                                     │
│  ✅ No string-based paths to remember                       │
│  ✅ Parameter validation                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Basic Example

```dart
import 'package:go_router/go_router.dart';

// Generate routes with types
part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomeScreen();
  }
}

@TypedGoRoute<ProductRoute>(path: '/product/:id')
class ProductRoute extends GoRouteData {
  final String id;

  ProductRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductScreen(id: id);
  }
}

// Use like this:
ProductRoute(id: '123').go(context);
ProductRoute(id: '123').push(context);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│            QUERY PARAMS & TRANSITIONS CHEAT SHEET            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  QUERY PARAMETERS:                                          │
│  final value = state.uri.queryParameters['key'] ?? default; │
│  Navigate: context.push('/path?key=value&foo=bar')          │
│                                                             │
│  CUSTOM TRANSITIONS:                                        │
│  pageBuilder: (ctx, state) => CustomTransitionPage(         │
│    child: MyScreen(),                                       │
│    transitionsBuilder: (ctx, anim, _, child) {              │
│      return FadeTransition(opacity: anim, child: child);    │
│    },                                                       │
│  )                                                          │
│                                                             │
│  COMMON TRANSITIONS:                                        │
│  • FadeTransition - fade in/out                             │
│  • SlideTransition - slide from direction                   │
│  • ScaleTransition - grow/shrink                            │
│  • RotationTransition - rotate                              │
│                                                             │
│  TYPEDGOROUTE:                                              │
│  Type-safe routes with compile-time checking                │
│  Requires code generation                                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Awesome! You've mastered GoRouter. Now let's learn about deep linking!

**Continue to:** [Deep Link Basics →](06a-DeepLinkBasics.md)

---

## Navigation

⬅️ **Previous:** [Route Guards](05b-RouteGuards.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Deep Link Basics](06a-DeepLinkBasics.md)
