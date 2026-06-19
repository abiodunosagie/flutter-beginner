# BottomNavigationBar Widget

## The Big Idea In One Sentence

> A bottom nav bar is like TV channel buttons: you keep an index in state, the bar stays put, and `body: _screens[index]` swaps which screen shows.

Learn how to create tab-based navigation with bottom navigation bars!

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

## BottomNavigationBar Properties

### Key Properties

```dart
BottomNavigationBar(
  currentIndex: 0,                              // Currently selected tab
  onTap: (index) { /* handle tap */ },         // Callback when tab tapped
  type: BottomNavigationBarType.fixed,         // or .shifting
  backgroundColor: Colors.white,                 // Bar background
  selectedItemColor: Colors.blue,               // Selected icon/label color
  unselectedItemColor: Colors.grey,             // Unselected icon/label color
  selectedFontSize: 14.0,                       // Selected label size
  unselectedFontSize: 12.0,                     // Unselected label size
  showSelectedLabels: true,                      // Show selected labels
  showUnselectedLabels: true,                    // Show unselected labels
  elevation: 8.0,                               // Shadow elevation
  items: [...],                                 // Navigation items
)
```

### Navigation Types

```dart
// FIXED: All items always visible (for 3-5 items)
type: BottomNavigationBarType.fixed,

// SHIFTING: Selected item is emphasized (animated)
type: BottomNavigationBarType.shifting,
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

// Use it
BottomNavigationBarItem(
  icon: _buildIconWithBadge(Icons.shopping_cart, 5),
  label: 'Cart',
)
```

---

## Complete Styled Example

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Nav Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarTheme(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeTab(),
    SearchTab(),
    FavoritesTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('5'),
              child: Icon(Icons.favorite_outline),
            ),
            activeIcon: Badge(
              label: Text('5'),
              child: Icon(Icons.favorite),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🏠', style: TextStyle(fontSize: 80)),
            Text('Home Screen'),
          ],
        ),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('🔍 Search')),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Center(child: Text('❤️ Favorites')),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('👤 Profile')),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           BOTTOMNAVIGATIONBAR CHEAT SHEET                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BASIC SETUP:                                               │
│  body: _screens[_currentIndex]                              │
│  bottomNavigationBar: BottomNavigationBar(...)              │
│                                                             │
│  PROPERTIES:                                                │
│  • currentIndex - Currently selected tab                    │
│  • onTap - Callback when tab tapped                         │
│  • items - List of BottomNavigationBarItem                  │
│  • type - fixed or shifting                                 │
│                                                             │
│  MATERIAL 3:                                                │
│  NavigationBar instead of BottomNavigationBar               │
│  NavigationDestination instead of BottomNavigationBarItem   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Which property tells the bar which tab is currently selected?

<details>
<summary>Answer</summary>
`currentIndex`.
</details>

**Q2.** What goes inside `onTap` to switch tabs?

<details>
<summary>Answer</summary>
`setState(() { _currentIndex = index; })`, which rebuilds with the new screen.
</details>

**Q3.** With 4 or more items, what `type` should you set so all labels stay visible?

<details>
<summary>Answer</summary>
`BottomNavigationBarType.fixed`.
</details>

---

## Assignment

### Problem 1: Show the right screen

You have `final _screens = [HomeTab(), SearchTab(), ProfileTab()];` and `int _currentIndex = 0;`. What do you put in `Scaffold(body: ...)` to show the selected tab?

### Problem 2: Handle the tap

Write the `onTap` callback that updates the selected tab.

### Problem 3: Spot the missing piece

The bar shows but tapping does nothing. The code sets `_currentIndex = index;` directly inside `onTap`. What is missing?

---

## Assignment Answers

### Problem 1: Show the right screen

```dart
body: _screens[_currentIndex],
```

### Problem 2: Handle the tap

```dart
onTap: (index) {
  setState(() {
    _currentIndex = index;
  });
},
```

### Problem 3: Spot the missing piece

It is missing `setState`. Setting `_currentIndex = index;` alone changes the value but does not rebuild the screen. Wrap it in `setState(() { ... })`.

---

## Navigation

⬅️ **Previous:** [Platform Links](06b-PlatformLinks.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Persistent Navigation](07b-PersistentNav.md)
