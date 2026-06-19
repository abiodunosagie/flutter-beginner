# Persistent Navigation with IndexedStack

## The Big Idea In One Sentence

> `IndexedStack` shows one tab but keeps the others alive in the background, so your scroll position and typed text are still there when you come back.

Learn how to preserve tab state when switching between tabs!

---

## The Problem

### State Loss Issue

When you switch tabs with basic bottom navigation, the previous tab's state is lost!

```
Home tab → Scroll down → Switch to Search → Switch back to Home
PROBLEM: Home scroll position is reset!
```

Visual:

```
WITHOUT State Preservation:
──────────────────────────
Tab 1 → Tab 2
Tab 1 gets destroyed
Tab 2 gets created

Tab 2 → Tab 1
Tab 2 gets destroyed
Tab 1 gets recreated (fresh, state lost!)

WITH State Preservation:
──────────────────────────
Tab 1 → Tab 2
Tab 1 stays hidden but alive
Tab 2 shows

Tab 2 → Tab 1
Tab 2 stays hidden but alive
Tab 1 shows (preserved state!)
```

---

## Solution: IndexedStack

### What is IndexedStack?

A widget that shows only one child at a time but keeps ALL children alive.

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

---

## Complete Example with State Preservation

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(),
          SearchTab(),
          FavoritesTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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

// Tab with scrollable content - state preserved!
class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    print('HomeTab build - counter: $_counter');  // Only builds once!

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            subtitle: Text('Counter: $_counter'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        child: Icon(Icons.add),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('Search Tab')),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Center(child: Text('Favorites Tab')),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Tab')),
    );
  }
}
```

---

## AutomaticKeepAliveClientMixin

### Alternative Approach for Individual Screens

```dart
class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  int _counter = 0;

  // This tells Flutter to keep this widget alive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // MUST call super.build when using AutomaticKeepAliveClientMixin
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item $index'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## With GoRouter

### Using StatefulShellRoute

```dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNav(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavoritesScreen(),
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
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│            PERSISTENT NAVIGATION CHEAT SHEET                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INDEXEDSTACK (Simple):                                     │
│  body: IndexedStack(                                        │
│    index: _currentIndex,                                    │
│    children: [screens...],                                  │
│  )                                                          │
│                                                             │
│  AUTOMATICKEEPALIVECLIENTMIXIN:                             │
│  class MyState extends State<MyTab>                         │
│      with AutomaticKeepAliveClientMixin {                   │
│    @override                                                │
│    bool get wantKeepAlive => true;                          │
│  }                                                          │
│                                                             │
│  GOROUTER:                                                  │
│  StatefulShellRoute.indexedStack(...)                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** With a plain `body: _screens[_currentIndex]`, what happens to a tab's scroll position when you leave and return?

<details>
<summary>Answer</summary>
It is lost. The tab is rebuilt fresh because the old one was thrown away.
</details>

**Q2.** How does `IndexedStack` fix that?

<details>
<summary>Answer</summary>
It keeps all children alive at once and just shows the one at `index`, so their state is preserved.
</details>

**Q3.** What is one trade-off of keeping every tab alive?

<details>
<summary>Answer</summary>
All tabs are built and held in memory at once, so it uses more memory than building one at a time.
</details>

---

## Assignment

### Problem 1: Swap in IndexedStack

You currently have `body: _screens[_currentIndex]`. Rewrite the `body` using `IndexedStack` so state is preserved.

### Problem 2: What stays alive?

With `IndexedStack`, if the user scrolls the Home tab, switches to Search, then back to Home, where is the scroll position?

### Problem 3: When NOT to use it

Give one case where you might prefer building one screen at a time instead of `IndexedStack`.

---

## Assignment Answers

### Problem 1: Swap in IndexedStack

```dart
body: IndexedStack(
  index: _currentIndex,
  children: _screens,
),
```

### Problem 2: What stays alive?

Right where the user left it. `IndexedStack` kept the Home tab alive, so its scroll position is preserved.

### Problem 3: When NOT to use it

When you have many heavy tabs and memory matters, since `IndexedStack` builds and keeps all of them alive at once. (Lazy building one at a time uses less memory.)

---

## Navigation

⬅️ **Previous:** [BottomNavigationBar](07a-BottomNavBar.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Tab Navigation](07c-TabNavigation.md)
