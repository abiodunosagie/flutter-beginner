# Custom Drawer Design

## The Big Idea In One Sentence

> Flutter ships ready-made drawer pieces: `UserAccountsDrawerHeader` for the profile banner and your own small `DrawerItem` widget to keep menu rows tidy and highlight the selected one.

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

## Quick Quiz

**Q1.** Which built-in widget gives you a polished profile header (name, email, avatar)?

<details>
<summary>Answer</summary>
`UserAccountsDrawerHeader`.
</details>

**Q2.** Why make your own `DrawerItem` widget instead of repeating `ListTile` code?

<details>
<summary>Answer</summary>
To avoid repetition and keep the selected-item styling in one place, so every row looks and behaves the same.
</details>

**Q3.** What is the Material 3 version of the drawer called?

<details>
<summary>Answer</summary>
`NavigationDrawer`, using `NavigationDrawerDestination` items.
</details>

---

## Assignment

### Problem 1: Use the header

Write a `UserAccountsDrawerHeader` showing the name "Ada Lovelace" and email "ada@math.com".

### Problem 2: Reuse a widget

You have a custom `DrawerItem(icon:, title:, onTap:)`. Write one for a "Home" row using `Icons.home`.

### Problem 3: Why a custom widget?

Name one benefit of a reusable `DrawerItem` over copy-pasting `ListTile`s.

---

## Assignment Answers

### Problem 1: Use the header

```dart
UserAccountsDrawerHeader(
  accountName: Text('Ada Lovelace'),
  accountEmail: Text('ada@math.com'),
  currentAccountPicture: CircleAvatar(child: Text('AL')),
),
```

### Problem 2: Reuse a widget

```dart
DrawerItem(
  icon: Icons.home,
  title: 'Home',
  onTap: () => Navigator.pop(context),
),
```

### Problem 3: Why a custom widget?

Any one: less repeated code, one place to change the styling, and consistent selected-state highlighting across all rows.

---

## Navigation

⬅️ **Previous:** [Drawer Basics](08a-DrawerBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Drawer Patterns](08c-DrawerPatterns.md)
