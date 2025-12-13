# Drawer Navigation in Flutter

Create side menu navigation for your apps!

---

## What is a Drawer?

### Think of it Like This

Imagine a hidden closet that slides out from the wall:
- It's hidden until you need it
- Pull it out to see all your options
- Close it when you're done

```
┌─────────────────────────────────────────────────────────────┐
│                      DRAWER CONCEPT                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CLOSED:                      OPEN:                         │
│  ┌──────────────────┐        ┌───────────┬────────────┐    │
│  │ ☰  App Title     │        │           │            │    │
│  ├──────────────────┤        │  👤 John  │  Content   │    │
│  │                  │        │  ────────│            │    │
│  │                  │        │  🏠 Home  │  (dimmed)  │    │
│  │    Content       │        │  ⚙️ Set   │            │    │
│  │                  │        │  ℹ️ About │            │    │
│  │                  │        │  🚪 Log   │            │    │
│  │                  │        │           │            │    │
│  └──────────────────┘        └───────────┴────────────┘    │
│                                                             │
│  Tap ☰ hamburger menu or swipe from left to open           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic Drawer

### Simple Implementation

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        // Hamburger menu icon is automatic when drawer is present!
      ),

      // Add drawer here
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,  // Remove default padding
          children: [
            // Header section
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text('JD', style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'john@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Menu items
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);  // Close drawer
                // Navigate to home
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to about
              },
            ),

            Divider(),  // Separator line

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Handle logout
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Text('Main Content'),
      ),
    );
  }
}
```

---

## Opening and Closing Drawer

### Programmatic Control

```dart
// Open drawer
Scaffold.of(context).openDrawer();

// Close drawer
Navigator.pop(context);
// OR
Scaffold.of(context).closeDrawer();

// Check if drawer is open
Scaffold.of(context).isDrawerOpen;
```

### With GlobalKey

```dart
class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('My App'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(...),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Text('Open Drawer'),
        ),
      ),
    );
  }
}
```

---

## Navigation Drawer (Material 3)

### Modern Design

```dart
Scaffold(
  body: Row(
    children: [
      // NavigationDrawer for tablets/desktop
      NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('Menu', style: Theme.of(context).textTheme.titleSmall),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Home'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: Text('About'),
          ),
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ],
      ),
      // Main content
      Expanded(child: _screens[_selectedIndex]),
    ],
  ),
);
```

---

## Complete Drawer Example with Navigation

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN SCREEN WITH DRAWER
// ═══════════════════════════════════════════════════════════════

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _title = 'Home';

  final List<Widget> _screens = [
    HomeContent(),
    ProfileContent(),
    SettingsContent(),
    HelpContent(),
  ];

  final List<String> _titles = ['Home', 'Profile', 'Settings', 'Help'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _title = _titles[index];
    });
    Navigator.pop(context);  // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            // User Account Header
            UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('john.doe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('JD', style: TextStyle(fontSize: 24)),
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('AB'),
                ),
              ],
              decoration: BoxDecoration(color: Colors.blue),
              onDetailsPressed: () {
                // Show account switcher
              },
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.home,
                    title: 'Home',
                    isSelected: _selectedIndex == 0,
                    onTap: () => _onItemTapped(0),
                  ),
                  _DrawerItem(
                    icon: Icons.person,
                    title: 'Profile',
                    isSelected: _selectedIndex == 1,
                    onTap: () => _onItemTapped(1),
                  ),
                  _DrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    isSelected: _selectedIndex == 2,
                    onTap: () => _onItemTapped(2),
                  ),

                  Divider(),

                  _DrawerItem(
                    icon: Icons.help,
                    title: 'Help',
                    isSelected: _selectedIndex == 3,
                    onTap: () => _onItemTapped(3),
                  ),
                  _DrawerItem(
                    icon: Icons.feedback,
                    title: 'Send Feedback',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeedbackDialog();
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.grey),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => _showLogoutDialog(),
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: _screens[_selectedIndex],
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Feedback'),
        content: TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Navigator.pop(context);  // Close drawer first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DRAWER ITEM WIDGET
// ═══════════════════════════════════════════════════════════════

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: onTap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CONTENT SCREENS
// ═══════════════════════════════════════════════════════════════

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🏠', style: TextStyle(fontSize: 80)),
          Text('Home Screen', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('👤', style: TextStyle(fontSize: 80)),
          Text('Profile Screen', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('⚙️', style: TextStyle(fontSize: 80)),
          Text('Settings Screen', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}

class HelpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('❓', style: TextStyle(fontSize: 80)),
          Text('Help Screen', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
```

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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    // Routes outside the drawer shell
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
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
              child: Text('My App', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _DrawerItem(
              icon: Icons.home,
              title: 'Home',
              isSelected: _isSelected(context, '/'),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            _DrawerItem(
              icon: Icons.person,
              title: 'Profile',
              isSelected: _isSelected(context, '/profile'),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
            _DrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              isSelected: _isSelected(context, '/settings'),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
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
    if (path == '/settings') return 'Settings';
    return 'App';
  }

  bool _isSelected(BuildContext context, String path) {
    return GoRouterState.of(context).uri.path == path;
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
│                  DRAWER CHEAT SHEET                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BASIC DRAWER:                                              │
│  Scaffold(                                                  │
│    drawer: Drawer(child: ListView(...)),                    │
│  )                                                          │
│                                                             │
│  OPEN/CLOSE:                                                │
│  Scaffold.of(context).openDrawer()                          │
│  Navigator.pop(context)  // or closeDrawer()                │
│                                                             │
│  USER HEADER:                                               │
│  UserAccountsDrawerHeader(                                  │
│    accountName: Text('John'),                               │
│    accountEmail: Text('john@email.com'),                    │
│    currentAccountPicture: CircleAvatar(...),                │
│  )                                                          │
│                                                             │
│  END DRAWER (right side):                                   │
│  Scaffold(endDrawer: Drawer(...))                           │
│  Scaffold.of(context).openEndDrawer()                       │
│                                                             │
│  MATERIAL 3:                                                │
│  NavigationDrawer with NavigationDrawerDestination          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Bottom Navigation](./07-BottomNavigation.md) | [Back to Level 07 README →](../README.md)
