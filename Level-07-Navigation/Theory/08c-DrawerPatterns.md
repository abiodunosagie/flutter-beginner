# Drawer Navigation Patterns

## The Big Idea In One Sentence

> A `Scaffold` can have a left `drawer` and a right `endDrawer`, and the smart pattern is bottom nav for your main screens plus a drawer for secondary stuff like settings and logout.

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

## Quick Quiz

**Q1.** What is the property for a right-side drawer, and how do you open it?

<details>
<summary>Answer</summary>
`endDrawer:` on the `Scaffold`, opened with `Scaffold.of(context).openEndDrawer()`.
</details>

**Q2.** You have 4 main screens users switch between constantly. Drawer or bottom nav?

<details>
<summary>Answer</summary>
Bottom nav. It is best for 3 to 5 main destinations that users switch between often.
</details>

**Q3.** Where should secondary items like Settings, Help, and Logout usually live?

<details>
<summary>Answer</summary>
In a drawer, while the bottom nav holds the main destinations.
</details>

---

## Assignment

### Problem 1: Two drawers

A shop screen needs a left menu and a right "Filters" panel. Which two `Scaffold` properties do you use?

### Problem 2: Pick the pattern

An app has 3 main tabs plus Settings, Help, and Logout. Describe the navigation setup.

### Problem 3: Open the filter panel

Write the line (inside an AppBar action button) that opens the right-side drawer.

---

## Assignment Answers

### Problem 1: Two drawers

`drawer:` for the left menu and `endDrawer:` for the right Filters panel.

### Problem 2: Pick the pattern

Use a **bottom navigation bar** for the 3 main tabs, and a **drawer** for the secondary items (Settings, Help, Logout). This is the "use both" pattern.

### Problem 3: Open the filter panel

```dart
Scaffold.of(context).openEndDrawer();
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
