# GoRouter Advanced

Master nested routes, authentication guards, redirects, and more!

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

## Authentication Redirects

### The Problem

```
User not logged in → Goes to /profile → Should redirect to /login
User logged in → Goes to /login → Should redirect to /home
```

### Solution: redirect Parameter

```dart
// Assume we have some auth state
bool isLoggedIn = false;

final router = GoRouter(
  // Global redirect - runs on EVERY navigation
  redirect: (context, state) {
    final loggingIn = state.uri.path == '/login';
    final registering = state.uri.path == '/register';

    // Not logged in?
    if (!isLoggedIn) {
      // Allow login and register pages
      if (loggingIn || registering) return null;
      // Redirect everything else to login
      return '/login';
    }

    // Logged in but trying to access login/register?
    if (loggingIn || registering) {
      return '/';  // Redirect to home
    }

    // No redirect needed
    return null;
  },

  routes: [
    GoRoute(path: '/', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => RegisterScreen()),
    GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
  ],
);
```

### Visual Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    REDIRECT FLOW                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  User Action              Check                  Result     │
│  ───────────────────────────────────────────────────────   │
│                                                             │
│  Go to /profile  ──>  Is logged in?  ──>  NO  ──>  /login  │
│                           │                                 │
│                          YES  ──────────────────>  /profile │
│                                                             │
│  Go to /login    ──>  Is logged in?  ──>  NO  ──>  /login  │
│                           │                                 │
│                          YES  ──────────────────>  /        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Listening to Auth Changes

### With Riverpod

```dart
// Auth state provider
final authProvider = StateProvider<bool>((ref) => false);

// Router that refreshes on auth changes
final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authProvider.notifier).stream,
    ),
    redirect: (context, state) {
      if (!isLoggedIn && state.uri.path != '/login') {
        return '/login';
      }
      if (isLoggedIn && state.uri.path == '/login') {
        return '/';
      }
      return null;
    },
    routes: [...],
  );
});

// Helper class to listen to streams
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}
```

### Simple Approach with ValueNotifier

```dart
// Create a notifier for auth state
final authNotifier = ValueNotifier<bool>(false);

final router = GoRouter(
  refreshListenable: authNotifier,  // Router refreshes when this changes
  redirect: (context, state) {
    final isLoggedIn = authNotifier.value;
    // ... redirect logic
  },
  routes: [...],
);

// When user logs in/out
void login() {
  authNotifier.value = true;  // Triggers router refresh
}

void logout() {
  authNotifier.value = false;  // Triggers router refresh
}
```

---

## Complete Auth Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

// ═══════════════════════════════════════════════════════════════
// AUTH STATE (Simple example)
// ═══════════════════════════════════════════════════════════════

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  void login(String username) {
    _username = username;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _username = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

final authState = AuthState();

// ═══════════════════════════════════════════════════════════════
// ROUTER SETUP
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: authState,  // Refresh on auth changes

  redirect: (context, state) {
    final isLoggedIn = authState.isLoggedIn;
    final isLoggingIn = state.uri.path == '/login';

    // Not logged in and not on login page? → Go to login
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }

    // Logged in but on login page? → Go to home
    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    // No redirect
    return null;
  },

  routes: [
    // Auth routes (no shell)
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),

    // Main app routes (with shell)
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
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
      title: 'Auth Demo',
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS
// ═══════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔐', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  authState.login(_usernameController.text);
                  // Router automatically redirects due to refreshListenable
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path == '/profile') return 1;
    if (path == '/settings') return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/profile'); break;
      case 2: context.go('/settings'); break;
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🏠', style: TextStyle(fontSize: 80)),
          Text('Welcome, ${authState.username}!'),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('👤', style: TextStyle(fontSize: 80)),
          Text('Profile: ${authState.username}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              authState.logout();
              // Router automatically redirects to login
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('⚙️', style: TextStyle(fontSize: 80)),
          Text('Settings'),
        ],
      ),
    );
  }
}
```

---

## Route-Level Redirects

You can also add redirects to specific routes:

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    // Only allow admin users
    if (!isAdmin) {
      return '/unauthorized';
    }
    return null;  // Allow access
  },
  builder: (context, state) => AdminScreen(),
),
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
```

---

## TypedGoRoute (Type-Safe Routes)

### Define Type-Safe Routes

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
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               GOROUTER ADVANCED CHEAT SHEET                  │
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
│  AUTH REDIRECT:                                             │
│  GoRouter(                                                  │
│    refreshListenable: authState,                            │
│    redirect: (ctx, state) {                                 │
│      if (!loggedIn) return '/login';                        │
│      return null;                                           │
│    },                                                       │
│  )                                                          │
│                                                             │
│  CUSTOM TRANSITIONS:                                        │
│  pageBuilder: (ctx, state) => CustomTransitionPage(...)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← GoRouter Basics](./04-GoRouterBasics.md) | [Next: Deep Linking →](./06-DeepLinking.md)
