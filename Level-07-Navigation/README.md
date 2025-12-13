# Level 07: Navigation & Routing

Welcome to Navigation! Learn how to move between screens in your Flutter app.

---

## What You'll Learn

```
┌─────────────────────────────────────────────────────────────┐
│                    NAVIGATION JOURNEY                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   📱 Screen A ──────────────────────> 📱 Screen B          │
│       Home           push()              Details            │
│                                                             │
│   📱 Screen B ──────────────────────> 📱 Screen A          │
│      Details         pop()                Home              │
│                                                             │
│   Think of it like:                                         │
│   - push() = Open a new book on top of another             │
│   - pop() = Close the top book, go back to previous        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Topics Covered

### Theory Files
| File | Topic | What You'll Learn |
|------|-------|-------------------|
| 01 | Basic Navigation | Navigator.push, pop, and the navigation stack |
| 02 | Named Routes | Organizing routes with names |
| 03 | Passing Data | Send data between screens |
| 04 | GoRouter Basics | Modern declarative routing |
| 05 | GoRouter Advanced | Nested routes, guards, redirects |
| 06 | Deep Linking | Open specific screens from URLs |
| 07 | Bottom Navigation | Tab-based navigation patterns |
| 08 | Drawer Navigation | Side menu navigation |

### Examples
| File | Description |
|------|-------------|
| Example01 | Basic push/pop navigation |
| Example02 | Named routes app |
| Example03 | Passing data between screens |
| Example04 | GoRouter simple setup |
| Example05 | GoRouter with authentication |
| Example06 | Bottom navigation with GoRouter |
| Example07 | Complete navigation patterns |

### Exercises
Practice building real navigation flows!

---

## The Navigation Stack - Visual Guide

```
Think of screens like a STACK OF PLATES:

Initial State:
    ┌─────────┐
    │  Home   │  ← You see this
    └─────────┘

After push(Details):
    ┌─────────┐
    │ Details │  ← Now you see this
    ├─────────┤
    │  Home   │  ← Home is hidden underneath
    └─────────┘

After push(Settings):
    ┌─────────┐
    │Settings │  ← Now you see this
    ├─────────┤
    │ Details │  ← Hidden
    ├─────────┤
    │  Home   │  ← Hidden
    └─────────┘

After pop():
    ┌─────────┐
    │ Details │  ← Back to Details
    ├─────────┤
    │  Home   │
    └─────────┘

After pop():
    ┌─────────┐
    │  Home   │  ← Back to Home
    └─────────┘
```

---

## Navigation Methods Quick Reference

### Basic Navigation (Navigator 1.0)

```dart
// Push a new screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Go back
Navigator.pop(context);

// Push and remove all previous
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false,
);

// Replace current screen
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

### Named Routes

```dart
// In MaterialApp
routes: {
  '/': (context) => HomeScreen(),
  '/details': (context) => DetailsScreen(),
  '/settings': (context) => SettingsScreen(),
}

// Navigate
Navigator.pushNamed(context, '/details');
Navigator.pop(context);
```

### GoRouter (Recommended)

```dart
// Setup
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailsScreen(id: id);
      },
    ),
  ],
);

// Navigate
context.go('/details/123');
context.push('/details/123');
context.pop();
```

---

## When to Use What

```
┌─────────────────────────────────────────────────────────────┐
│                    NAVIGATION DECISION TREE                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Is your app simple (2-3 screens)?                          │
│      │                                                      │
│      ├── YES → Use Navigator.push/pop                       │
│      │                                                      │
│      └── NO → Do you need deep linking or web support?      │
│                  │                                          │
│                  ├── YES → Use GoRouter                     │
│                  │                                          │
│                  └── NO → Named routes OR GoRouter          │
│                                                             │
│  RECOMMENDATION: Just learn GoRouter!                       │
│  It works for everything and is the modern standard.        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Package Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0  # Modern routing
```

---

## Learning Path

```
START HERE
    │
    ▼
┌─────────────────────┐
│ 01-BasicNavigation  │  ← Learn push/pop first
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 02-NamedRoutes      │  ← Organize with route names
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 03-PassingData      │  ← Send data between screens
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 04-GoRouterBasics   │  ← Modern routing approach
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 05-GoRouterAdvanced │  ← Guards, redirects, nested
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 06-DeepLinking      │  ← URLs and web support
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 07-BottomNavigation │  ← Tab-based apps
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 08-DrawerNavigation │  ← Side menu apps
└─────────────────────┘
    │
    ▼
  EXERCISES
```

---

## Real-World Navigation Patterns

### Pattern 1: Login Flow
```
App Start
    │
    ▼
Is user logged in?
    │
    ├── NO ──> Login Screen ──> Register? ──> Register Screen
    │                │
    │                ▼
    │          Login Success
    │                │
    └── YES ─────────┴──────> Home Screen
```

### Pattern 2: E-commerce Flow
```
Home ──> Product List ──> Product Detail ──> Cart ──> Checkout ──> Success
  │                              │              │
  │                              ▼              │
  │                         Add to Cart         │
  │                              │              │
  └──────────────────────────────┴──────────────┘
                                 │
                              View Cart
```

### Pattern 3: Settings with Sub-pages
```
Settings
    ├── Account ──> Edit Profile
    │           └── Change Password
    │
    ├── Notifications ──> Push Settings
    │                 └── Email Settings
    │
    └── About ──> Privacy Policy
              └── Terms of Service
```

---

## Common Mistakes to Avoid

```dart
// ❌ DON'T: Pop when there's nothing to pop
Navigator.pop(context);  // Crashes if already at root!

// ✅ DO: Check if you can pop first
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}

// ❌ DON'T: Forget to pass required data
Navigator.pushNamed(context, '/details');  // Missing ID!

// ✅ DO: Pass the data properly
Navigator.pushNamed(context, '/details', arguments: itemId);

// ❌ DON'T: Use context after navigation
Navigator.pop(context);
showSnackBar(context, 'Done!');  // context might be invalid!

// ✅ DO: Show snackbar before navigating
showSnackBar(context, 'Done!');
Navigator.pop(context);
```

---

## Time Estimate

| Section | Estimated Time |
|---------|---------------|
| Theory (8 files) | 3-4 hours |
| Examples | 2-3 hours |
| Exercises | 3-4 hours |
| **Total** | **8-11 hours** |

---

## Prerequisites

Before starting this level, you should understand:
- [x] Flutter widgets (Level 05)
- [x] State management basics (Level 06)
- [x] BuildContext concept
- [x] Async/await for data loading

---

[← Level 06: State Management](../Level-06-State-Management/README.md) | [Level 08: API Integration →](../Level-08-API-Integration/README.md)
