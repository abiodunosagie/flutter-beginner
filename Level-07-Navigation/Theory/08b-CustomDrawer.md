# Custom Drawer Design

Learn how to create beautiful, custom drawer menus!

---

## UserAccountsDrawerHeader

### Professional User Header

```dart
drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
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
        decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
            image: NetworkImage('https://example.com/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        onDetailsPressed: () {
          // Show account switcher
        },
      ),
      // Menu items...
    ],
  ),
)
```

---

## Custom Drawer Item Widget

```dart
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItem({
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
```

---

## NavigationDrawer (Material 3)

```dart
Scaffold(
  body: Row(
    children: [
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
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ],
      ),
      Expanded(child: _screens[_selectedIndex]),
    ],
  ),
);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                CUSTOM DRAWER CHEAT SHEET                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  USER HEADER:                                               │
│  UserAccountsDrawerHeader(                                  │
│    accountName: Text('John'),                               │
│    accountEmail: Text('john@email.com'),                    │
│    currentAccountPicture: CircleAvatar(...),                │
│  )                                                          │
│                                                             │
│  MATERIAL 3:                                                │
│  NavigationDrawer with NavigationDrawerDestination          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now let's learn about advanced drawer patterns!

**Continue to:** [Drawer Patterns →](08c-DrawerPatterns.md)

---

## Navigation

⬅️ **Previous:** [Drawer Basics](08a-DrawerBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Drawer Patterns](08c-DrawerPatterns.md)
