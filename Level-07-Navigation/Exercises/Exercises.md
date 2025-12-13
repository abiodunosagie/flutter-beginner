# Level 07: Navigation Exercises

Master Flutter navigation through hands-on practice!

---

## Exercise 1: Basic Navigation - Photo Gallery (Beginner)

### The Goal
Build a photo gallery that navigates between a grid view and full-screen photo view.

### Think of it Like This
Imagine a photo album:
- Flip through thumbnails (grid view)
- Tap a photo to see it full-size
- Close to go back to thumbnails

### What You'll Build

```
┌─────────────────────────────────────────────────────────────┐
│  GRID VIEW                          FULL VIEW               │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐           ┌───────────────────┐   │
│  │ 📷 Gallery          │           │ ← Photo 3         │   │
│  ├─────────────────────┤           ├───────────────────┤   │
│  │ ┌───┬───┬───┐       │   tap    │                   │   │
│  │ │ 1 │ 2 │ 3 │       │  ────>   │    [Full Size     │   │
│  │ ├───┼───┼───┤       │          │     Photo #3]     │   │
│  │ │ 4 │ 5 │ 6 │       │          │                   │   │
│  │ ├───┼───┼───┤       │          │   Photo Title     │   │
│  │ │ 7 │ 8 │ 9 │       │          │   Description     │   │
│  │ └───┴───┴───┘       │          │                   │   │
│  └─────────────────────┘           └───────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';

// Sample photo data
class Photo {
  final String id;
  final String title;
  final String url;
  final String description;

  const Photo({
    required this.id,
    required this.title,
    required this.url,
    required this.description,
  });
}

final photos = [
  const Photo(id: '1', title: 'Sunset', url: '🌅', description: 'Beautiful sunset at the beach'),
  const Photo(id: '2', title: 'Mountains', url: '🏔️', description: 'Snow-capped mountains'),
  const Photo(id: '3', title: 'Forest', url: '🌲', description: 'Dense green forest'),
  const Photo(id: '4', title: 'Ocean', url: '🌊', description: 'Calm ocean waves'),
  const Photo(id: '5', title: 'City', url: '🌆', description: 'City skyline at dusk'),
  const Photo(id: '6', title: 'Desert', url: '🏜️', description: 'Golden sand dunes'),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      home: const GalleryScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Gallery Screen with Grid
// ═══════════════════════════════════════════════════════════════

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];

          // TODO: Make this tappable to navigate to PhotoDetailScreen
          // Pass the photo object to the detail screen
          return GestureDetector(
            onTap: () {
              // TODO: Navigator.push to PhotoDetailScreen
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(photo.url, style: const TextStyle(fontSize: 40)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create Photo Detail Screen
// ═══════════════════════════════════════════════════════════════

class PhotoDetailScreen extends StatelessWidget {
  // TODO: Accept Photo as parameter

  const PhotoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Display full photo with title and description
    // Include a back button
    return Scaffold(
      appBar: AppBar(title: const Text('Photo')),
      body: const Center(
        child: Text('Implement photo detail'),
      ),
    );
  }
}
```

### Success Checklist
- [ ] Grid displays all photos
- [ ] Tapping a photo navigates to detail screen
- [ ] Photo data is passed correctly
- [ ] Back button returns to gallery
- [ ] App bar shows photo title

---

## Exercise 2: Named Routes - E-commerce Flow (Intermediate)

### The Goal
Build a shopping flow: Products → Product Detail → Cart → Checkout

### What You'll Build

```
Flow: Home → Products → Product → Cart → Checkout → Success
                              ↓
                        Add to Cart
```

### Starter Code

```dart
import 'package:flutter/material.dart';

// Route constants
class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const productDetail = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const success = '/success';

  AppRoutes._();
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce',
      // TODO: Define routes map
      routes: {
        // TODO: Add all routes
      },
      // TODO: Handle product detail with arguments using onGenerateRoute
      onGenerateRoute: (settings) {
        // TODO: Implement
        return null;
      },
      initialRoute: AppRoutes.home,
    );
  }
}

// TODO: Create these screens:
// 1. HomeScreen - with "Shop Now" button
// 2. ProductsScreen - list of products, tap to go to detail
// 3. ProductDetailScreen - show product, "Add to Cart" button
// 4. CartScreen - show cart items, "Checkout" button
// 5. CheckoutScreen - form for details, "Place Order" button
// 6. SuccessScreen - confirmation, "Continue Shopping" clears stack
```

### Requirements
1. Use AppRoutes constants for all navigation
2. Pass product data to ProductDetailScreen
3. Cart should show item count in app bar
4. After checkout success, "Continue Shopping" should clear the stack
5. Back button from Success should NOT go back to checkout

### Success Checklist
- [ ] All routes defined correctly
- [ ] Product data passed via arguments
- [ ] Cart updates when adding items
- [ ] Checkout flow completes
- [ ] "Continue Shopping" clears navigation stack

---

## Exercise 3: GoRouter - Blog App (Intermediate)

### The Goal
Build a blog app with GoRouter featuring:
- Home with recent posts
- Posts list with category filter
- Post detail with comments
- Author profiles

### Route Structure

```
/                       → Home
/posts                  → All posts
/posts?category=tech    → Posts filtered by category
/post/:id               → Post detail
/post/:id/comments      → Post comments
/author/:username       → Author profile
/search?q=flutter       → Search results
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Models
class Post {
  final String id;
  final String title;
  final String excerpt;
  final String authorUsername;
  final String category;

  const Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.authorUsername,
    required this.category,
  });
}

// Sample data
final posts = [
  const Post(id: '1', title: 'Getting Started with Flutter', excerpt: 'Learn the basics...', authorUsername: 'jane', category: 'flutter'),
  const Post(id: '2', title: 'State Management Guide', excerpt: 'Compare different...', authorUsername: 'john', category: 'flutter'),
  const Post(id: '3', title: 'Web Development Tips', excerpt: 'Best practices...', authorUsername: 'jane', category: 'web'),
];

// TODO: Define the router
final router = GoRouter(
  initialLocation: '/',
  routes: [
    // TODO: Add all routes
    // - Home route
    // - Posts route (with optional category query param)
    // - Post detail route (with :id path param)
    // - Post comments route (nested under post)
    // - Author route (with :username path param)
    // - Search route (with ?q query param)
  ],
  errorBuilder: (context, state) {
    // TODO: Error page
    return const Scaffold(body: Center(child: Text('404')));
  },
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Blog App',
      routerConfig: router,
    );
  }
}

// TODO: Create these screens:
// 1. HomeScreen - recent posts, navigation to all posts
// 2. PostsScreen - list with category filter chips
// 3. PostDetailScreen - full post content, link to comments
// 4. CommentsScreen - list of comments
// 5. AuthorScreen - author info and their posts
// 6. SearchScreen - search input and results
```

### Success Checklist
- [ ] All routes work correctly
- [ ] Path parameters extract correctly
- [ ] Query parameters filter posts
- [ ] Nested comments route works
- [ ] Search updates URL with query
- [ ] 404 page shows for unknown routes

---

## Exercise 4: Bottom Navigation - Social App (Intermediate)

### The Goal
Build a social app with bottom navigation:
- Feed tab with posts
- Messages tab with conversations
- Notifications tab
- Profile tab with settings

### Requirements
- Each tab preserves its state when switching
- Nested navigation within tabs
- Some screens full-screen (no bottom nav)

### Route Structure

```
Tabs (with bottom nav):
/feed                   → Feed
/feed/post/:id          → Post detail (with nav)
/messages               → Messages list
/messages/:id           → Conversation (with nav)
/notifications          → Notifications
/profile                → Profile
/profile/edit           → Edit profile (with nav)
/profile/settings       → Settings (with nav)

Full screen (no bottom nav):
/compose                → New post
/camera                 → Take photo
/login                  → Login screen
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Create router with StatefulShellRoute
final router = GoRouter(
  initialLocation: '/feed',
  routes: [
    // TODO: StatefulShellRoute.indexedStack for tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // TODO: Return scaffold with bottom nav
        return Placeholder();
      },
      branches: [
        // TODO: Feed branch
        // TODO: Messages branch
        // TODO: Notifications branch
        // TODO: Profile branch
      ],
    ),

    // TODO: Full-screen routes (outside shell)
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Social App',
      routerConfig: router,
    );
  }
}

// TODO: Create MainScaffold with bottom navigation

// TODO: Create tab screens:
// - FeedTab (with post list)
// - MessagesTab (with conversation list)
// - NotificationsTab
// - ProfileTab

// TODO: Create full-screen screens:
// - ComposeScreen
// - CameraScreen
```

### Success Checklist
- [ ] Four tabs with bottom navigation
- [ ] Tab state preserved when switching
- [ ] Nested routes show bottom nav
- [ ] Full-screen routes hide bottom nav
- [ ] Double-tap tab returns to root
- [ ] Notifications show badge count

---

## Exercise 5: Auth Flow with Redirects (Advanced)

### The Goal
Build an app with proper authentication flow:
- Redirect to login if not authenticated
- Redirect to home if already authenticated
- Protected routes
- "Remember" deep link destination after login

### Requirements

```
NOT LOGGED IN:
- /login, /register → Allow
- /*, /profile, /settings → Redirect to /login
- Save intended destination

AFTER LOGIN:
- Redirect to saved destination (or home)

LOGGED IN:
- /login, /register → Redirect to /
- All other routes → Allow

LOGOUT:
- Clear auth state
- Redirect to /login
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ═══════════════════════════════════════════════════════════════
// AUTH STATE
// ═══════════════════════════════════════════════════════════════

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _pendingDeepLink;

  bool get isLoggedIn => _isLoggedIn;
  String? get pendingDeepLink => _pendingDeepLink;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _pendingDeepLink = null;
    notifyListeners();
  }

  void savePendingDeepLink(String? link) {
    _pendingDeepLink = link;
  }

  String? consumePendingDeepLink() {
    final link = _pendingDeepLink;
    _pendingDeepLink = null;
    return link;
  }
}

final authState = AuthState();

// ═══════════════════════════════════════════════════════════════
// ROUTER WITH AUTH REDIRECT
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: authState,

  redirect: (context, state) {
    // TODO: Implement redirect logic
    // 1. Check if user is logged in
    // 2. If not logged in and not on login/register, save destination and redirect to login
    // 3. If logged in and on login/register, redirect to pending deep link or home
    // 4. Otherwise, no redirect

    return null;
  },

  routes: [
    // TODO: Define routes
    // Auth routes: /login, /register
    // Protected routes: /, /profile, /settings, /dashboard
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Auth Demo',
      routerConfig: router,
    );
  }
}

// TODO: Create screens:
// - LoginScreen (with login button that calls authState.login())
// - RegisterScreen
// - HomeScreen
// - ProfileScreen
// - SettingsScreen
// - DashboardScreen

// Each protected screen should have a logout button
```

### Test Scenarios

1. **Cold start not logged in:**
   - Open app → Should see login screen

2. **Deep link not logged in:**
   - Open `myapp://profile` → Login screen
   - Login → Should go to profile (not home!)

3. **Already logged in:**
   - Open `myapp://login` → Should redirect to home

4. **Logout:**
   - Tap logout → Should go to login
   - Press back → Should NOT go back to protected screen

### Success Checklist
- [ ] Unauthenticated users redirected to login
- [ ] Deep link destination saved before login
- [ ] After login, go to saved destination
- [ ] Authenticated users can't access login
- [ ] Logout clears auth and redirects
- [ ] Back button doesn't bypass auth

---

## Bonus Challenge: Multi-Platform Navigation

Build an app that uses:
- **Mobile:** Bottom navigation
- **Tablet:** Navigation rail
- **Desktop:** Side drawer

```dart
// Detect platform/screen size and show appropriate navigation
class AdaptiveNavigation extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  // TODO: Implement adaptive layout that changes based on screen width
  // < 600px: Bottom navigation
  // 600-900px: Navigation rail
  // > 900px: Permanent side drawer
}
```

---

## Summary: Navigation Patterns

```
┌─────────────────────────────────────────────────────────────┐
│              NAVIGATION PATTERN CHEAT SHEET                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BASIC NAVIGATION:                                          │
│  Navigator.push(context, MaterialPageRoute(...))            │
│  Navigator.pop(context)                                     │
│                                                             │
│  NAMED ROUTES:                                              │
│  Navigator.pushNamed(context, '/route', arguments: data)    │
│                                                             │
│  GOROUTER:                                                  │
│  context.push('/path')      // Add to stack                 │
│  context.go('/path')        // Replace stack                │
│  context.pop()              // Go back                      │
│                                                             │
│  PATH PARAMS: /user/:id → state.pathParameters['id']        │
│  QUERY PARAMS: /search?q=x → state.uri.queryParameters['q'] │
│  EXTRA DATA: push('/x', extra: obj) → state.extra           │
│                                                             │
│  BOTTOM NAV: StatefulShellRoute.indexedStack                │
│  AUTH: redirect + refreshListenable                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Back to Level 07 README](../README.md) | [Level 08: API Integration →](../../Level-08-API-Integration/README.md)
