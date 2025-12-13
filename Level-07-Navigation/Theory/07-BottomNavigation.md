# Bottom Navigation in Flutter

Create tab-based apps with persistent bottom navigation bars!

---

## What is Bottom Navigation?

### Think of it Like This

Imagine a TV remote with preset channel buttons:
- Button 1 → News channel
- Button 2 → Sports channel
- Button 3 → Movie channel

You can switch instantly between channels without "going back".

```
┌─────────────────────────────────────────────────────────────┐
│                    BOTTOM NAVIGATION                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────────────────────────────────┐          │
│  │                                               │          │
│  │                                               │          │
│  │              CONTENT AREA                     │          │
│  │         (Changes per tab)                     │          │
│  │                                               │          │
│  │                                               │          │
│  ├───────────────────────────────────────────────┤          │
│  │  🏠      🔍      ❤️      👤                  │          │
│  │ Home   Search  Favorites Profile              │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Tapping "Search" → Shows search content                    │
│  Tapping "Home" → Shows home content                        │
│  The bar STAYS, only content changes!                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Method 1: Basic BottomNavigationBar

### Simple Implementation

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // All the screens for each tab
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show current screen based on selected tab
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,  // Required for 4+ items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Individual screens
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('🏠 Home Content')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('🔍 Search Content')),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Center(child: Text('❤️ Favorites Content')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('👤 Profile Content')),
    );
  }
}
```

---

## Method 2: Preserving Tab State

### Problem with Basic Approach

When you switch tabs, the previous tab's state is lost!

```
Home tab → Scroll down → Switch to Search → Switch back to Home
PROBLEM: Home scroll position is reset!
```

### Solution: IndexedStack

```dart
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all screens alive!
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          SearchScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          // ... same items
        ],
      ),
    );
  }
}
```

### Visual Comparison

```
WITHOUT IndexedStack:              WITH IndexedStack:
───────────────────────           ───────────────────────
Tab 1 → Tab 2                     Tab 1 → Tab 2
Tab 1 gets destroyed              Tab 1 stays hidden but alive
Tab 2 gets created                Tab 2 shows

Tab 2 → Tab 1                     Tab 2 → Tab 1
Tab 2 gets destroyed              Tab 2 stays hidden but alive
Tab 1 gets recreated (fresh!)     Tab 1 shows (preserved state!)
```

---

## Method 3: With GoRouter (Recommended)

### Using ShellRoute for Bottom Navigation

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

// ═══════════════════════════════════════════════════════════════
// ROUTER SETUP
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    // ShellRoute wraps tabs with bottom nav
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNav(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => FavoritesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),

    // Routes OUTSIDE the shell (no bottom nav)
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// SHELL WITH BOTTOM NAV
// ═══════════════════════════════════════════════════════════════

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNav({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/favorites')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bottom Nav Demo',
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS (Inside Shell - have bottom nav)
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Product 1'),
            onTap: () => context.push('/product/1'),  // Goes outside shell
          ),
          ListTile(
            title: Text('Product 2'),
            onTap: () => context.push('/product/2'),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('🔍 Search')),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Center(child: Text('❤️ Favorites')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('👤 Profile')),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS (Outside Shell - no bottom nav)
// ═══════════════════════════════════════════════════════════════

class ProductDetailScreen extends StatelessWidget {
  final String id;
  const ProductDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $id')),
      body: Center(child: Text('Product details for #$id')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('⚙️ Settings')),
    );
  }
}
```

---

## StatefulShellRoute (Preserving State)

### Keep Each Tab's Navigation Stack

```dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNav(navigationShell: navigationShell);
      },
      branches: [
        // Home branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomeScreen(),
              routes: [
                GoRoute(
                  path: 'detail/:id',  // /home/detail/123
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return HomeDetailScreen(id: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Search branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => SearchScreen(),
              routes: [
                GoRoute(
                  path: 'results',  // /search/results
                  builder: (context, state) => SearchResultsScreen(),
                ),
              ],
            ),
          ],
        ),

        // Favorites branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavoritesScreen(),
            ),
          ],
        ),

        // Profile branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',  // /profile/edit
                  builder: (context, state) => EditProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNav({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,  // The current branch's content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // goBranch preserves the navigation stack of each branch!
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

### What StatefulShellRoute Does

```
HOME TAB:
Home → Home Detail → Home Detail 2
        │
        │  Switch to SEARCH TAB
        ▼
SEARCH TAB:
Search → Search Results
        │
        │  Switch back to HOME TAB
        ▼
HOME TAB (state preserved!):
Home → Home Detail → Home Detail 2  ← Still here!
```

---

## NavigationBar (Material 3)

### Modern Alternative

```dart
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      selectedIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
)
```

---

## Badges on Navigation Items

### Show Notification Counts

```dart
BottomNavigationBarItem(
  icon: Badge(
    label: Text('3'),
    child: Icon(Icons.notifications_outlined),
  ),
  activeIcon: Badge(
    label: Text('3'),
    child: Icon(Icons.notifications),
  ),
  label: 'Notifications',
)
```

### Custom Badge Widget

```dart
Widget _buildIconWithBadge(IconData icon, int count) {
  return Stack(
    children: [
      Icon(icon),
      if (count > 0)
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              count > 99 ? '99+' : '$count',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  );
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               BOTTOM NAVIGATION CHEAT SHEET                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BASIC (no state preservation):                             │
│  body: _screens[_currentIndex]                              │
│                                                             │
│  WITH STATE (preserves scroll, etc.):                       │
│  body: IndexedStack(index: i, children: screens)            │
│                                                             │
│  WITH GOROUTER:                                             │
│  ShellRoute(                                                │
│    builder: (ctx, state, child) => Shell(child: child),     │
│    routes: [/* tab routes */],                              │
│  )                                                          │
│                                                             │
│  WITH GOROUTER + STATE:                                     │
│  StatefulShellRoute.indexedStack(                           │
│    branches: [                                              │
│      StatefulShellBranch(routes: [/* home routes */]),      │
│      StatefulShellBranch(routes: [/* search routes */]),    │
│    ],                                                       │
│  )                                                          │
│                                                             │
│  MATERIAL 3:                                                │
│  NavigationBar instead of BottomNavigationBar               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Deep Linking](./06-DeepLinking.md) | [Next: Drawer Navigation →](./08-DrawerNavigation.md)
