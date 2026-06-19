# Route Guards and Authentication

## The Big Idea In One Sentence

> A `redirect` is a bouncer: before any screen opens, it checks a rule (like "are you logged in?") and either sends you somewhere else (return a path) or lets you through (return `null`).

Learn how to protect routes and handle authentication with redirects!

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

### With ValueNotifier

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

## Role-Based Access

```dart
enum UserRole { guest, user, admin }

class AuthService {
  UserRole currentRole = UserRole.guest;

  bool canAccessRoute(String path) {
    if (path.startsWith('/admin')) {
      return currentRole == UserRole.admin;
    }
    if (path.startsWith('/user')) {
      return currentRole == UserRole.user || currentRole == UserRole.admin;
    }
    return true;  // Public routes
  }
}

final authService = AuthService();

final router = GoRouter(
  redirect: (context, state) {
    if (!authService.canAccessRoute(state.uri.path)) {
      return '/unauthorized';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/user/profile', builder: (_, __) => ProfileScreen()),
    GoRoute(path: '/admin/dashboard', builder: (_, __) => AdminDashboard()),
    GoRoute(path: '/unauthorized', builder: (_, __) => UnauthorizedScreen()),
  ],
);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               ROUTE GUARDS CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GLOBAL REDIRECT:                                           │
│  GoRouter(                                                  │
│    refreshListenable: authState,                            │
│    redirect: (ctx, state) {                                 │
│      if (!loggedIn) return '/login';                        │
│      return null;                                           │
│    },                                                       │
│  )                                                          │
│                                                             │
│  ROUTE-LEVEL REDIRECT:                                      │
│  GoRoute(                                                   │
│    path: '/admin',                                          │
│    redirect: (ctx, state) {                                 │
│      if (!isAdmin) return '/unauthorized';                  │
│      return null;                                           │
│    },                                                       │
│  )                                                          │
│                                                             │
│  REFRESH ON CHANGE:                                         │
│  Use ChangeNotifier or ValueNotifier with refreshListenable │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** In a `redirect`, what does returning `null` mean?

<details>
<summary>Answer</summary>
"No redirect, let the user through to the screen they asked for."
</details>

**Q2.** What does returning a path string (like `'/login'`) do?

<details>
<summary>Answer</summary>
It sends the user to that path instead of the one they asked for.
</details>

**Q3.** Why set `refreshListenable: authState`?

<details>
<summary>Answer</summary>
So the router re-runs its redirect when the auth state changes (login/logout), instantly sending the user to the right screen.
</details>

---

## Assignment

### Problem 1: Write the rule

Write a global `redirect` that sends a user to `/login` when they are not logged in (use a `bool isLoggedIn`), and lets them through otherwise. Allow the `/login` page itself.

### Problem 2: Let them through

In a redirect, what exactly do you return when the user is allowed to stay?

### Problem 3: Find the trap

A student writes a redirect that always returns `/login`. What goes wrong, even for the login page?

---

## Assignment Answers

### Problem 1: Write the rule

```dart
redirect: (context, state) {
  final loggingIn = state.uri.path == '/login';
  if (!isLoggedIn && !loggingIn) return '/login';
  return null;
},
```

### Problem 2: Let them through

Return `null`. That tells GoRouter not to redirect.

### Problem 3: Find the trap

Always returning `/login` causes an infinite redirect loop: the login page itself gets redirected to the login page, again and again. You must allow the login path through (return `null` when already on `/login`).

---

## Navigation

⬅️ **Previous:** [Nested Routes](05a-NestedRoutes.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Query Parameters](05c-QueryParams.md)
