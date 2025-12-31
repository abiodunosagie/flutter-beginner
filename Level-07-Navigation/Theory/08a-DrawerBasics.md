# Drawer Navigation Basics

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
│  │                  │        │  ────────  │            │    │
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

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                  DRAWER BASICS CHEAT SHEET                   │
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
│  DRAWER HEADER:                                             │
│  DrawerHeader(                                              │
│    decoration: BoxDecoration(color: Colors.blue),           │
│    child: Text('Header'),                                   │
│  )                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now let's learn about custom drawer designs!

**Continue to:** [Custom Drawer →](08b-CustomDrawer.md)

---

## Navigation

⬅️ **Previous:** [Tab Navigation](07c-TabNavigation.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Custom Drawer](08b-CustomDrawer.md)
