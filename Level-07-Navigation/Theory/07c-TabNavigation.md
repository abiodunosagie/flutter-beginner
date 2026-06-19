# Tab Navigation with TabBar

## The Big Idea In One Sentence

> `TabBar` shows the tab buttons (usually at the top) and `TabBarView` shows their pages, and `DefaultTabController` wires them together so swiping and tapping just work.

Learn about TabBar, TabBarView, and combining navigation patterns!

---

## TabBar and TabBarView

### What is TabBar?

A material design widget for tabbed navigation, commonly used at the top of the screen.

```
┌─────────────────────────────────────────────────────────────┐
│  TABBAR vs BOTTOM NAVIGATION                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TABBAR (Top):                                              │
│  ┌───────────────────────────────────────────┐              │
│  │  [Tab 1] [Tab 2] [Tab 3]                 │              │
│  ├───────────────────────────────────────────┤              │
│  │                                           │              │
│  │        Content for selected tab           │              │
│  │                                           │              │
│  └───────────────────────────────────────────┘              │
│                                                             │
│  BOTTOM NAVIGATION (Bottom):                                │
│  ┌───────────────────────────────────────────┐              │
│  │                                           │              │
│  │        Content for selected tab           │              │
│  │                                           │              │
│  ├───────────────────────────────────────────┤              │
│  │  [Home] [Search] [Profile]                │              │
│  └───────────────────────────────────────────┘              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic TabBar Example

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TabScreen());
  }
}

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,  // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('TabBar Demo'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Home Content')),
            Center(child: Text('Search Content')),
            Center(child: Text('Profile Content')),
          ],
        ),
      ),
    );
  }
}
```

---

## With TabController (More Control)

```dart
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        print('Tab changed to: ${_tabController.index}');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabBar Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.search), text: 'Search'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeTab(),
          SearchTab(),
          ProfileTab(),
        ],
      ),
    );
  }
}
```

---

## Combining Bottom Nav + TabBar

```dart
class CombinedNavScreen extends StatefulWidget {
  @override
  _CombinedNavScreenState createState() => _CombinedNavScreenState();
}

class _CombinedNavScreenState extends State<CombinedNavScreen> {
  int _bottomIndex = 0;

  final List<Widget> _screens = [
    HomeWithTabs(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_bottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (index) => setState(() => _bottomIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Home screen has its own tabs
class HomeWithTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Feed'),
              Tab(text: 'Stories'),
              Tab(text: 'Live'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Feed')),
            Center(child: Text('Stories')),
            Center(child: Text('Live')),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('Search')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile')),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                TAB NAVIGATION CHEAT SHEET                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DEFAULT TABCONTROLLER:                                     │
│  DefaultTabController(                                      │
│    length: 3,                                               │
│    child: Scaffold(                                         │
│      appBar: AppBar(                                        │
│        bottom: TabBar(tabs: [...]),                         │
│      ),                                                     │
│      body: TabBarView(children: [...]),                     │
│    ),                                                       │
│  )                                                          │
│                                                             │
│  MANUAL TABCONTROLLER:                                      │
│  TabController _controller = TabController(                 │
│    length: 3,                                               │
│    vsync: this,  // Requires SingleTickerProviderStateMixin │
│  );                                                         │
│                                                             │
│  COMBINING:                                                 │
│  • Bottom nav for main sections                             │
│  • TabBar within sections for sub-categories                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What do `TabBar` and `TabBarView` each show?

<details>
<summary>Answer</summary>
`TabBar` shows the tab buttons; `TabBarView` shows the page for the selected tab.
</details>

**Q2.** What is the easiest way to connect them without writing a controller yourself?

<details>
<summary>Answer</summary>
Wrap them in a `DefaultTabController(length: n, child: ...)`.
</details>

**Q3.** When you make your own `TabController`, why must the state class use `SingleTickerProviderStateMixin`?

<details>
<summary>Answer</summary>
The controller needs a `vsync` (a ticker) to drive the tab animation; that mixin provides it.
</details>

---

## Assignment

### Problem 1: Count the tabs

You have 3 tabs. What number must `DefaultTabController(length: ...)` and the `tabs`/`children` lists all agree on?

### Problem 2: Build the skeleton

Write the minimal `DefaultTabController` + `Scaffold` with a `TabBar` of two tabs ('A', 'B') and a matching `TabBarView`.

### Problem 3: Spot the crash

An app sets `DefaultTabController(length: 2)` but the `TabBar` has 3 `Tab` widgets. What goes wrong?

---

## Assignment Answers

### Problem 1: Count the tabs

All three must be **3**: the controller length, the number of `Tab`s, and the number of `TabBarView` children.

### Problem 2: Build the skeleton

```dart
DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(
      bottom: const TabBar(
        tabs: [Tab(text: 'A'), Tab(text: 'B')],
      ),
    ),
    body: const TabBarView(
      children: [
        Center(child: Text('A')),
        Center(child: Text('B')),
      ],
    ),
  ),
)
```

### Problem 3: Spot the crash

The counts do not match: `length` is 2 but there are 3 tabs. Flutter throws an error because the controller and the tabs/children must have the same count. Set `length: 3`.

---

## Navigation

⬅️ **Previous:** [Persistent Navigation](07b-PersistentNav.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Drawer Basics](08a-DrawerBasics.md)
