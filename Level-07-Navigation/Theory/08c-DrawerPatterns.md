# Drawer Navigation Patterns

Learn about EndDrawer, combining navigation patterns, and best practices!

---

## Right-Side Drawer (End Drawer)

```dart
Scaffold(
  appBar: AppBar(
    title: Text('My App'),
    actions: [
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    ],
  ),

  // Left drawer (default)
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Main Menu')),
        ListTile(title: Text('Home')),
        ListTile(title: Text('Settings')),
      ],
    ),
  ),

  // Right drawer
  endDrawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Filters')),
        ListTile(title: Text('Category')),
        ListTile(title: Text('Price Range')),
        ListTile(title: Text('Rating')),
      ],
    ),
  ),

  body: Center(child: Text('Content')),
)
```

---

## Drawer with GoRouter

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithDrawer(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (_, __) => HomeContent()),
        GoRoute(path: '/profile', builder: (_, __) => ProfileContent()),
        GoRoute(path: '/settings', builder: (_, __) => SettingsContent()),
      ],
    ),
  ],
);

class ScaffoldWithDrawer extends StatelessWidget {
  final Widget child;

  const ScaffoldWithDrawer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle(context))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('My App'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }

  String _getTitle(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path == '/') return 'Home';
    if (path == '/profile') return 'Profile';
    return 'App';
  }
}
```

---

## Drawer vs Bottom Navigation

```
┌─────────────────────────────────────────────────────────────┐
│           WHEN TO USE DRAWER VS BOTTOM NAV                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  USE DRAWER WHEN:                                           │
│  ─────────────────                                          │
│  • You have 5+ main navigation items                        │
│  • Navigation items have sub-items                          │
│  • You need user account section                            │
│  • Space is limited on mobile                               │
│  • Desktop/tablet app                                       │
│                                                             │
│  USE BOTTOM NAV WHEN:                                       │
│  ──────────────────                                         │
│  • You have 3-5 main destinations                           │
│  • Users frequently switch between sections                 │
│  • All items are equally important                          │
│  • Mobile-first design                                      │
│                                                             │
│  USE BOTH WHEN:                                             │
│  ─────────────                                              │
│  • Bottom nav for primary destinations                      │
│  • Drawer for secondary items (settings, help, logout)      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                DRAWER PATTERNS CHEAT SHEET                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  END DRAWER (right side):                                   │
│  Scaffold(endDrawer: Drawer(...))                           │
│  Scaffold.of(context).openEndDrawer()                       │
│                                                             │
│  WITH GOROUTER:                                             │
│  Use ShellRoute to wrap screens with persistent drawer      │
│                                                             │
│  BEST PRACTICES:                                            │
│  • Close drawer after navigation (Navigator.pop)            │
│  • Show selected state for current page                     │
│  • Use dividers to group related items                      │
│  • Bottom nav for main screens, drawer for secondary        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Congratulations!

You've completed Level 07 - Navigation! You now know:
- Basic navigation and named routes
- Passing and returning data between screens
- GoRouter for modern navigation
- Deep linking for all platforms
- Bottom navigation patterns
- Drawer navigation

**Back to:** [Learning Path](00-LearningPath.md) | **Level 07 Complete!**

---

## Navigation

⬅️ **Previous:** [Custom Drawer](08b-CustomDrawer.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Level Complete!** Return to [README](../README.md)
