# GoRouter Setup

Learn the modern, declarative way to handle navigation in Flutter!

---

## What is GoRouter?

### Think of it Like This

Imagine you're giving directions:

**Old way (Navigator):** "Go through the lobby, up the stairs, turn left..."
**New way (GoRouter):** "Go to Room 304" - it figures out the path!

```
┌─────────────────────────────────────────────────────────────┐
│              NAVIGATOR vs GOROUTER                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NAVIGATOR (Imperative):                                    │
│  "Push this screen, then that screen, then go back..."      │
│  YOU control every step                                     │
│                                                             │
│  GOROUTER (Declarative):                                    │
│  "I want to be at /products/123"                            │
│  IT figures out how to get there                            │
│                                                             │
│  Like GPS: You say WHERE, it figures out HOW               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Why Use GoRouter?

```
┌─────────────────────────────────────────────────────────────┐
│                   GOROUTER BENEFITS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ URL-based navigation (great for web)                    │
│  ✅ Deep linking built-in                                   │
│  ✅ Easy redirects (login guards)                           │
│  ✅ Nested navigation                                       │
│  ✅ Type-safe path parameters                               │
│  ✅ Works on mobile, web, and desktop                       │
│  ✅ Clear route structure                                   │
│  ✅ Browser back/forward buttons work                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Setup

### Step 1: Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
```

### Step 2: Create Router

```dart
import 'package:go_router/go_router.dart';

// Define your router
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => DetailsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
```

### Step 3: Use in MaterialApp

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      routerConfig: router,  // Use the router!
    );
  }
}
```

---

## Basic Navigation

### Navigate to a Route

```dart
// Go to a new screen (adds to stack)
context.push('/details');

// Replace current screen
context.go('/details');

// Go back
context.pop();
```

### Visual Difference: push vs go

```
USING context.push('/details'):
──────────────────────────────
Before:           After:
┌─────────┐      ┌─────────┐
│  Home   │      │ Details │  ← New screen on top
└─────────┘      ├─────────┤
                 │  Home   │  ← Home still there
                 └─────────┘
Back button: Goes to Home

USING context.go('/details'):
─────────────────────────────
Before:           After:
┌─────────┐      ┌─────────┐
│  Home   │      │ Details │  ← Replaced Home
└─────────┘      └─────────┘
Back button: Exits app (nothing to go back to!)
```

---

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ═══════════════════════════════════════════════════════════════
// ROUTER SETUP
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // Home route
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    // Settings route
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),

    // About route
    GoRoute(
      path: '/about',
      builder: (context, state) => AboutScreen(),
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS
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
            Text('🏠', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('Welcome!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),

            // Navigate using context.push
            ElevatedButton(
              onPressed: () => context.push('/settings'),
              child: Text('Go to Settings'),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => context.push('/about'),
              child: Text('About'),
            ),
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
            SizedBox(height: 20),
            Text('Settings', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),

            // Go to home (replaces entire stack)
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
            SizedBox(height: 16),

            // Go back
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

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ℹ️', style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text('About This App', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Version 1.0.0'),
            SizedBox(height: 40),

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

## Navigation Methods Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                  GOROUTER NAVIGATION                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  context.go('/path')                                        │
│  ─────────────────                                          │
│  Navigates to path, replaces current stack                  │
│  Like: "teleport to location"                               │
│  Use for: Tab changes, logout, deep links                   │
│                                                             │
│  context.push('/path')                                      │
│  ────────────────────                                       │
│  Adds new screen to stack                                   │
│  Like: "walk to location, remember where you came from"     │
│  Use for: Drill-down navigation (list → detail)             │
│                                                             │
│  context.pop()                                              │
│  ─────────────                                              │
│  Removes top screen, goes back                              │
│  Like: "walk back to where you came from"                   │
│  Use for: Back buttons, cancel actions                      │
│                                                             │
│  context.pushReplacement('/path')                           │
│  ─────────────────────────────────                          │
│  Replaces current screen only                               │
│  Like: "transform current location into something else"     │
│  Use for: Login → Home (don't want back to login)           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Error Handling

### Custom Error Page

```dart
final router = GoRouter(
  routes: [...],

  // Handle unknown routes
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404', style: TextStyle(fontSize: 80)),
            Text('Page not found'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                  GOROUTER SETUP CHEAT SHEET                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. ADD DEPENDENCY:                                         │
│     go_router: ^14.0.0                                      │
│                                                             │
│  2. CREATE ROUTER:                                          │
│     final router = GoRouter(                                │
│       routes: [                                             │
│         GoRoute(                                            │
│           path: '/',                                        │
│           builder: (context, state) => HomeScreen(),        │
│         ),                                                  │
│       ],                                                    │
│     );                                                      │
│                                                             │
│  3. USE IN APP:                                             │
│     MaterialApp.router(                                     │
│       routerConfig: router,                                 │
│     )                                                       │
│                                                             │
│  4. NAVIGATE:                                               │
│     context.go('/path')      // Replace stack               │
│     context.push('/path')    // Add to stack                │
│     context.pop()            // Go back                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now that you know how to set up GoRouter, let's learn about path parameters and advanced navigation!

**Continue to:** [GoRouter Navigation →](04b-GoRouterNavigation.md)

---

## Navigation

⬅️ **Previous:** [Returning Data](03c-ReturningData.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [GoRouter Navigation](04b-GoRouterNavigation.md)
