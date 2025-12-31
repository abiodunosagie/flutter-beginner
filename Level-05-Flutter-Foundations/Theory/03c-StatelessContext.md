# BuildContext: Connecting Your Widget to the App

## For 5-Year-Olds: Your Address

Imagine you live in a house. To get mail, people need to know:
- Your house number
- Your street
- Your city
- Your country

This "address" tells people where to find you.

**BuildContext is like your widget's address:**

```
App
 └─ Home Screen
     └─ Column
         └─ Your Widget ← "BuildContext points here!"
```

BuildContext tells your widget:
- Where it is in the widget tree
- How to talk to its parents
- How to find nearby widgets (like Theme or Navigator)

```dart
@override
Widget build(BuildContext context) {
//                       ^^^^^^^
//    Your widget's "address" in the tree
```

---

## What Is BuildContext?

**BuildContext** is a reference to the location of a widget in the widget tree.

Think of it as:
- A GPS coordinate for your widget
- A way to look up information from parent widgets
- Access to app-wide services (theme, navigation, etc.)

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 'context' knows:
    // - Where this widget is in the tree
    // - What theme the app is using
    // - How big the screen is
    // - How to navigate to other screens

    return Text('Hello');
  }
}
```

### Visual: Widget Tree with Context

```
MaterialApp (Theme: Blue)
  ↓
Scaffold
  ↓
Column
  ↓
MyWidget ← BuildContext here knows:
           - Theme is blue
           - Parent is Column
           - Screen size
           - Navigation stack
```

---

## Using BuildContext: Theme

Access the app's theme using `Theme.of(context)`:

### Getting Theme Colors

```dart
class ThemedCard extends StatelessWidget {
  const ThemedCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor,  // Uses app's primary color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'I use the theme color!',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,  // Contrasting text color
        ),
      ),
    );
  }
}
```

**How It Works:**
```
1. Widget asks context: "What's my theme?"
2. Context looks up the tree to MaterialApp
3. MaterialApp says: "Theme is blue"
4. Widget uses blue color
```

### Using Text Styles from Theme

```dart
class ThemedText extends StatelessWidget {
  final String text;

  const ThemedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: textTheme.headlineMedium),  // Large header
        Text(text, style: textTheme.bodyLarge),       // Body text
        Text(text, style: textTheme.labelSmall),      // Small label
      ],
    );
  }
}
```

### Customizing Theme Styles

```dart
class StyledButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const StyledButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
```

---

## Using BuildContext: Screen Size

Get screen dimensions using `MediaQuery.of(context)`:

### Getting Screen Size

```dart
class ResponsiveBox extends StatelessWidget {
  const ResponsiveBox({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      width: screenWidth * 0.8,   // 80% of screen width
      height: screenHeight * 0.3, // 30% of screen height
      color: Colors.blue,
      child: Center(
        child: Text('Width: ${screenWidth.toInt()}px'),
      ),
    );
  }
}
```

### Responsive Design

```dart
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Different layouts for different screen sizes
    if (width < 600) {
      // Phone: Vertical layout
      return Column(
        children: const [
          SidebarContent(),
          MainContent(),
        ],
      );
    } else {
      // Tablet/Desktop: Horizontal layout
      return Row(
        children: const [
          SidebarContent(),
          Expanded(child: MainContent()),
        ],
      );
    }
  }
}

class SidebarContent extends StatelessWidget {
  const SidebarContent({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: 200,
    color: Colors.grey[300],
    child: const Center(child: Text('Sidebar')),
  );
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    child: const Center(child: Text('Main Content')),
  );
}
```

**Result:**
```
Phone (< 600px):      Tablet/Desktop (≥ 600px):
┌──────────┐          ┌────────┬──────────────┐
│ Sidebar  │          │Sidebar │ Main Content │
├──────────┤          │        │              │
│  Main    │          │        │              │
│ Content  │          │        │              │
└──────────┘          └────────┴──────────────┘
```

### Other MediaQuery Properties

```dart
class MediaQueryExample extends StatelessWidget {
  const MediaQueryExample({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screen width: ${mediaQuery.size.width}'),
        Text('Screen height: ${mediaQuery.size.height}'),
        Text('Pixel ratio: ${mediaQuery.devicePixelRatio}'),
        Text('Orientation: ${mediaQuery.orientation}'),
        Text('Padding (safe area): ${mediaQuery.padding}'),
        Text('Dark mode: ${mediaQuery.platformBrightness == Brightness.dark}'),
      ],
    );
  }
}
```

---

## Using BuildContext: Navigation

Navigate between screens using `Navigator.of(context)`:

### Basic Navigation

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to another screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DetailScreen(),
              ),
            );
          },
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Go back to previous screen
            Navigator.of(context).pop();
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
```

### Passing Data Between Screens

```dart
class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Laptop'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductDetail(
                    name: 'Laptop',
                    price: 999.99,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Phone'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductDetail(
                    name: 'Phone',
                    price: 699.99,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  final String name;
  final double price;

  const ProductDetail({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '\$$price',
              style: const TextStyle(fontSize: 32, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Using BuildContext: Dialogs and Snackbars

### Showing Dialogs

```dart
class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Perform delete action
                    print('Item deleted');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Delete Item'),
    );
  }
}
```

### Showing Snackbars

```dart
class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: const Text('Save Changes'),
    );
  }
}
```

### Custom Snackbar with Action

```dart
class UndoableDelete extends StatelessWidget {
  const UndoableDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                print('Undo delete');
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      },
      child: const Text('Delete with Undo'),
    );
  }
}
```

### Showing Bottom Sheets

```dart
class OptionsButton extends StatelessWidget {
  const OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Share'),
                    onTap: () {
                      Navigator.pop(context);
                      print('Share tapped');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.pop(context);
                      print('Edit tapped');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context);
                      print('Delete tapped');
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Text('Show Options'),
    );
  }
}
```

---

## Real-World Example: Complete Screen

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access theme
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Access screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: isSmallScreen ? 50 : 70,
              backgroundColor: theme.primaryColor,
              child: Icon(
                Icons.person,
                size: isSmallScreen ? 50 : 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              'John Doe',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              'john.doe@example.com',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to edit profile
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Show logout confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logged out successfully'),
                                ),
                              );
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}
```

---

## Common BuildContext Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `Theme.of(context)` | Get app theme | `Theme.of(context).primaryColor` |
| `MediaQuery.of(context)` | Get screen info | `MediaQuery.of(context).size.width` |
| `Navigator.of(context)` | Navigate screens | `Navigator.of(context).push(...)` |
| `ScaffoldMessenger.of(context)` | Show snackbars | `ScaffoldMessenger.of(context).showSnackBar(...)` |
| `showDialog(context: ...)` | Show dialogs | `showDialog(context: context, builder: ...)` |
| `showModalBottomSheet(context: ...)` | Show bottom sheets | `showModalBottomSheet(context: context, builder: ...)` |

---

## Common Mistakes

### Mistake 1: Using Context Outside build()

```dart
// ❌ WRONG: Context not available in constructor
class BadWidget extends StatelessWidget {
  BadWidget({super.key}) {
    Theme.of(context);  // ERROR: context doesn't exist here!
  }

  @override
  Widget build(BuildContext context) {
    return Text('Hello');
  }
}

// ✅ RIGHT: Use context inside build()
class GoodWidget extends StatelessWidget {
  const GoodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  // Works!
    return Text('Hello');
  }
}
```

### Mistake 2: Wrong Context for Navigation

```dart
// ❌ Might not work as expected
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(...);  // context is from MaterialApp!
          },
          child: const Text('Navigate'),
        ),
      ),
    );
  }
}

// ✅ Better: Use Builder or separate widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            // This context is from inside Scaffold
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(...);  // Works correctly!
              },
              child: const Text('Navigate'),
            );
          },
        ),
      ),
    );
  }
}
```

---

## Key Takeaways

| Concept | Description |
|---------|-------------|
| BuildContext | Widget's location in the tree |
| Theme.of(context) | Access app theme and colors |
| MediaQuery.of(context) | Get screen size and properties |
| Navigator.of(context) | Navigate between screens |
| showDialog() | Display alert dialogs |
| ScaffoldMessenger | Show snackbars |
| Context scope | Only use context inside build() |

---

## Quick Quiz

**Q1:** What is BuildContext?

<details>
<summary>Answer</summary>

BuildContext is a reference to a widget's location in the widget tree. It allows the widget to access information from parent widgets (like theme, screen size) and services (like navigation).

</details>

**Q2:** How do you get the screen width?

<details>
<summary>Answer</summary>

```dart
final width = MediaQuery.of(context).size.width;
```

MediaQuery provides access to screen dimensions, orientation, pixel ratio, and more.

</details>

**Q3:** What's the difference between Navigator.push() and Navigator.pop()?

<details>
<summary>Answer</summary>

- `Navigator.push()` - Navigates TO a new screen (adds to stack)
- `Navigator.pop()` - Goes BACK to previous screen (removes from stack)

Think of it like a stack of papers: push adds a new paper on top, pop removes the top paper.

</details>

**Q4:** When can you use context?

<details>
<summary>Answer</summary>

You can only use context inside the `build()` method (or methods called from build). You CANNOT use context in the constructor or outside the widget class. Context is only available when the widget is part of the widget tree.

</details>

---

**Next:** Learn about StatefulWidget to create interactive widgets that can change.

---

## Navigation

⬅️ **Previous:** [StatelessWidget Properties](03b-StatelessProperties.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [StatefulWidget Intro](04a-StatefulIntro.md)
