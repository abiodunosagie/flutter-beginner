# Nested Navigation with ShellRoute

## 5-Year-Old Explanation

Imagine you have a toy house with three rooms: Kitchen, Bedroom, and Playroom.

**Simple navigation (bad):**
You're in the Kitchen building a LEGO tower. Then you go to the Bedroom to get a toy. When you come back to the Kitchen... YOUR LEGO TOWER IS GONE! You have to start over!

**Nested navigation (good):**
You're in the Kitchen building a LEGO tower. You go to the Bedroom to get a toy. When you come back to the Kitchen... YOUR LEGO TOWER IS STILL THERE! Each room remembers what you were doing!

In apps, nested navigation means each tab (Kitchen, Bedroom, Playroom) remembers where you were. If you're deep in Settings, then switch to Home tab, then come back to Settings - you're still in the same spot! No need to navigate all the way back.

---

## What You'll Learn

- Creating nested navigation with ShellRoute
- Bottom navigation with separate stacks
- Tab bars with independent navigation
- Preserving state across tabs
- Complex nested structures
- Best practices

## Understanding Nested Navigation

**Problem with Simple Navigation:**
```
Home → Profile → Settings
When you tap back from Settings, you go to Profile, then Home
But what if Home has a BottomNavigationBar?
Tapping tabs loses your place in each tab!
```

**Solution: Nested Navigation**
```
Each tab has its own navigation stack:
Tab 1 (Home):     Home → Details → Comments
Tab 2 (Search):   Search → Results → Profile
Tab 3 (Profile):  Profile → Settings → Edit

Switching tabs preserves each stack! ✨
```

## ShellRoute Basics

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
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
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);

// Scaffold with bottom navigation
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  ScaffoldWithNavBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
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

## Complete Example with Nested Routes

```dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        // Home tab with nested routes
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'details/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return DetailsScreen(id: id);
              },
            ),
          ],
        ),

        // Search tab with nested routes
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchScreen(),
          routes: [
            GoRoute(
              path: 'results',
              builder: (context, state) {
                final query = state.uri.queryParameters['q'] ?? '';
                return SearchResultsScreen(query: query);
              },
            ),
          ],
        ),

        // Profile tab with nested routes
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
          routes: [
            GoRoute(
              path: 'settings',
              builder: (context, state) => SettingsScreen(),
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) => EditProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// Navigate to nested routes
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            onTap: () {
              // Navigate to details WITHIN home tab
              context.push('/home/details/$index');
            },
          );
        },
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final String id;

  DetailsScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details $id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Item $id details', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Tab Bar with Nested Navigation

```dart
final router = GoRouter(
  initialLocation: '/feed',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('My App'),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.feed), text: 'Feed'),
                  Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
                  Tab(icon: Icon(Icons.message), text: 'Messages'),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      context.go('/feed');
                      break;
                    case 1:
                      context.go('/notifications');
                      break;
                    case 2:
                      context.go('/messages');
                      break;
                  }
                },
              ),
            ),
            body: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/feed',
          builder: (context, state) => FeedScreen(),
          routes: [
            GoRoute(
              path: 'post/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return PostScreen(id: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => NotificationsScreen(),
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => MessagesScreen(),
          routes: [
            GoRoute(
              path: 'chat/:userId',
              builder: (context, state) {
                final userId = state.pathParameters['userId']!;
                return ChatScreen(userId: userId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
```

## Multiple ShellRoutes

```dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    // Main app shell (with bottom nav)
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
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
      ],
    ),

    // Admin shell (different layout)
    ShellRoute(
      builder: (context, state, child) {
        return AdminScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => AdminDashboard(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => AdminUsersScreen(),
        ),
      ],
    ),
  ],
);
```

## Preserving State

ShellRoute automatically preserves state when switching tabs!

```dart
// State is preserved!
Tab 1: Scrolled to item 50 → Switch to Tab 2 → Back to Tab 1 → Still at item 50! ✨
```

## Best Practices

✅ Use ShellRoute for persistent UI elements (nav bars)
✅ Keep nested routes shallow (max 2-3 levels)
✅ Use named routes for maintainability
✅ Handle back button properly
✅ Test navigation flows thoroughly

## Exercises

### Exercise 1: Bottom Nav App (Beginner)
Create app with 3 tabs, each with 2 nested screens

### Exercise 2: E-Commerce (Intermediate)
Products → Categories → Items → Details with bottom nav

### Exercise 3: Social Media (Advanced)
Feed, Search, Notifications, Profile with deep nesting

You're mastering complex navigation! 🚀
