# Nested Routes and ShellRoute

Learn how to create nested navigation and persistent UI!

---

## Nested Routes (Sub-Routes)

### Think of it Like This

Imagine a house with rooms:
- House = Parent route
- Rooms = Child routes

```
/settings                   ← Settings page
/settings/profile           ← Profile page (inside settings)
/settings/notifications     ← Notifications (inside settings)
/settings/privacy           ← Privacy (inside settings)
```

### Visual Structure

```
┌─────────────────────────────────────────────────────────────┐
│  /settings                                                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────────────────────────────┐  │
│  │  Side Menu  │  │                                     │  │
│  │             │  │     Content Area                    │  │
│  │  • Profile  │  │                                     │  │
│  │  • Notifs   │  │  (Shows Profile, Notifications,     │  │
│  │  • Privacy  │  │   or Privacy based on sub-route)    │  │
│  │             │  │                                     │  │
│  └─────────────┘  └─────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Code Example

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    // Parent route with nested children
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
      routes: [
        // These are NESTED under /settings
        GoRoute(
          path: 'profile',  // Full path: /settings/profile
          builder: (context, state) => ProfileSettingsScreen(),
        ),
        GoRoute(
          path: 'notifications',  // Full path: /settings/notifications
          builder: (context, state) => NotificationSettingsScreen(),
        ),
        GoRoute(
          path: 'privacy',  // Full path: /settings/privacy
          builder: (context, state) => PrivacySettingsScreen(),
        ),
      ],
    ),
  ],
);
```

---

## ShellRoute - Persistent UI

### What is ShellRoute?

A shell that wraps multiple screens with shared UI (like a bottom navigation bar).

```
┌─────────────────────────────────────────────────────────────┐
│                    SHELLROUTE CONCEPT                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WITHOUT ShellRoute:                                        │
│  Each screen must add its own bottom nav                    │
│  Nav bar rebuilds on every navigation                       │
│                                                             │
│  WITH ShellRoute:                                           │
│  One shell wraps all screens                                │
│  Nav bar stays, only content changes                        │
│                                                             │
│  ┌─────────────────────────────────────────┐                │
│  │                                         │                │
│  │        CONTENT CHANGES HERE             │                │
│  │                                         │                │
│  ├─────────────────────────────────────────┤                │
│  │  [Home]  [Search]  [Profile]            │  ← Stays!     │
│  └─────────────────────────────────────────┘                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### ShellRoute Example

```dart
final router = GoRouter(
  routes: [
    // Shell wraps these routes with bottom nav
    ShellRoute(
      builder: (context, state, child) {
        // 'child' is the current screen
        return ScaffoldWithBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),

    // These routes are OUTSIDE the shell (no bottom nav)
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailScreen(id: id);
      },
    ),
  ],
);

// The shell widget
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,  // The current screen goes here
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateIndex(context),
        onTap: (index) => _onTap(context, index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
}
```

---

## Complete ShellRoute Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

// ═══════════════════════════════════════════════════════════════
// ROUTER WITH SHELL
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeContent(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchContent(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileContent(),
        ),
      ],
    ),

    // Routes outside shell
    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailsScreen(id: id);
      },
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShellRoute Demo',
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHELL WIDGET
// ═══════════════════════════════════════════════════════════════

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getIndex(context),
        onTap: (i) => _onTap(context, i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path == '/search') return 1;
    if (path == '/profile') return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/search'); break;
      case 2: context.go('/profile'); break;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// CONTENT SCREENS (Inside shell - have bottom nav)
// ═══════════════════════════════════════════════════════════════

class HomeContent extends StatelessWidget {
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
            ElevatedButton(
              onPressed: () => context.push('/details/123'),
              child: Text('View Details (No Nav Bar)'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('🔍 Search')),
    );
  }
}

class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('👤 Profile')),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DETAIL SCREEN (Outside shell - no bottom nav)
// ═══════════════════════════════════════════════════════════════

class DetailsScreen extends StatelessWidget {
  final String id;
  const DetailsScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details $id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail page has no bottom nav'),
            Text('ID: $id'),
            SizedBox(height: 20),
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

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               NESTED ROUTES CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NESTED ROUTES:                                             │
│  GoRoute(                                                   │
│    path: '/settings',                                       │
│    routes: [                                                │
│      GoRoute(path: 'profile', ...),  // /settings/profile   │
│    ],                                                       │
│  )                                                          │
│                                                             │
│  SHELL ROUTE (persistent UI):                               │
│  ShellRoute(                                                │
│    builder: (ctx, state, child) => Shell(child: child),     │
│    routes: [...],                                           │
│  )                                                          │
│                                                             │
│  USE CASES:                                                 │
│  • Nested: Settings with sub-pages                          │
│  • Shell: Bottom nav that persists across screens           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now that you know nested routes and ShellRoute, let's learn about route guards and authentication!

**Continue to:** [Route Guards →](05b-RouteGuards.md)

---

## Navigation

⬅️ **Previous:** [GoRouter Navigation](04b-GoRouterNavigation.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Route Guards](05b-RouteGuards.md)
