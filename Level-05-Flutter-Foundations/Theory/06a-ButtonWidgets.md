# Level 05 PART 6a: Button Widgets - All the Buttons You Need

## For a 5-Year-Old

Imagine you're building a toy remote control:
- **Big raised buttons** that you can really press (like a doorbell)
- **Flat buttons** that don't stick out (like drawn buttons on paper)
- **Buttons with borders** (like buttons outlined with a marker)
- **Tiny icon buttons** (like the play button on your tablet)
- **Round floating buttons** (like the big red button on a game controller)
- **Menu buttons** that show more choices when you tap them

Flutter has ALL these button types! Each one looks different and is perfect for different jobs. Let's learn them all!

---

## Button Types Overview

Flutter provides 6 main button types:

| Button Type | Use When | Appearance |
|-------------|----------|------------|
| **ElevatedButton** | Primary action (most important) | Raised with shadow |
| **TextButton** | Secondary action | Flat, just text |
| **OutlinedButton** | Medium importance | Border outline |
| **IconButton** | Toolbar actions | Just an icon |
| **FloatingActionButton** | Main screen action | Circular, floating |
| **PopupMenuButton** | Show menu options | Opens popup menu |

---

## ElevatedButton - The Primary Button

**Best for:** The MOST important action on a screen (Save, Submit, Next, etc.)

### Basic Usage

```dart
ElevatedButton(
  onPressed: () {
    print('Button pressed!');
  },
  child: Text('Click Me'),
)
```

### With Icon

```dart
ElevatedButton.icon(
  onPressed: () {
    print('Saved!');
  },
  icon: Icon(Icons.save),
  label: Text('Save'),
)
```

### Full Styling

```dart
ElevatedButton(
  onPressed: () {
    print('Custom styled button!');
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,        // Background color
    foregroundColor: Colors.white,       // Text/icon color

    // Padding
    padding: EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),

    // Size
    minimumSize: Size(200, 50),

    // Shape
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),

    // Elevation (shadow)
    elevation: 8,
    shadowColor: Colors.blue.withOpacity(0.5),

    // Text style
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  child: Text('Styled Button'),
)
```

### Button States

```dart
class ButtonStatesExample extends StatefulWidget {
  @override
  State<ButtonStatesExample> createState() => _ButtonStatesExampleState();
}

class _ButtonStatesExampleState extends State<ButtonStatesExample> {
  bool isEnabled = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Enabled button
        ElevatedButton(
          onPressed: isEnabled && !isLoading
              ? () async {
                  setState(() => isLoading = true);
                  await Future.delayed(Duration(seconds: 2));
                  setState(() => isLoading = false);
                }
              : null, // null = disabled
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text('Submit'),
        ),

        SizedBox(height: 16),

        // Toggle enable/disable
        SwitchListTile(
          title: Text('Button Enabled'),
          value: isEnabled,
          onChanged: (value) {
            setState(() => isEnabled = value);
          },
        ),
      ],
    );
  }
}
```

### Disabled State

```dart
ElevatedButton(
  onPressed: null,  // null = disabled (grayed out)
  child: Text('Disabled Button'),
)
```

---

## TextButton - The Subtle Button

**Best for:** Less important actions (Cancel, Skip, Learn More)

### Basic Usage

```dart
TextButton(
  onPressed: () {
    print('Text button pressed');
  },
  child: Text('Cancel'),
)
```

### With Icon

```dart
TextButton.icon(
  onPressed: () {
    print('Learn more');
  },
  icon: Icon(Icons.help_outline),
  label: Text('Learn More'),
)
```

### Styled TextButton

```dart
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
    padding: EdgeInsets.all(16),
    textStyle: TextStyle(fontSize: 16),

    // Add background when pressed
    backgroundColor: Colors.transparent,

    // Shape
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('Text Button'),
)
```

### Common Pattern: Dialog Buttons

```dart
AlertDialog(
  title: Text('Confirm Delete'),
  content: Text('Are you sure you want to delete this item?'),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel'),
    ),
    ElevatedButton(
      onPressed: () {
        // Delete item
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text('Delete'),
    ),
  ],
)
```

---

## OutlinedButton - The Bordered Button

**Best for:** Medium importance actions (Add to Cart, Follow, etc.)

### Basic Usage

```dart
OutlinedButton(
  onPressed: () {
    print('Outlined button pressed');
  },
  child: Text('Outlined'),
)
```

### With Icon

```dart
OutlinedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.shopping_cart),
  label: Text('Add to Cart'),
)
```

### Custom Border Style

```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.blue,

    // Border
    side: BorderSide(
      color: Colors.blue,
      width: 2,
    ),

    // Padding
    padding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),

    // Shape
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),

    // Background when pressed
    backgroundColor: Colors.blue.withOpacity(0.1),
  ),
  child: Text('Custom Border'),
)
```

### Pill-Shaped Button

```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.green),
    shape: StadiumBorder(), // Pill shape
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  ),
  child: Text('Pill Button'),
)
```

---

## IconButton - Icon-Only Buttons

**Best for:** Toolbar actions, small UI elements

### Basic Usage

```dart
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {
    print('Favorite pressed');
  },
)
```

### Styled IconButton

```dart
IconButton(
  icon: Icon(Icons.delete),
  color: Colors.red,
  iconSize: 30,
  tooltip: 'Delete',  // Shows on hover/long press
  splashRadius: 24,   // Ripple size
  onPressed: () {
    print('Delete pressed');
  },
)
```

### Toggle Icon Button

```dart
class ToggleIconButton extends StatefulWidget {
  @override
  State<ToggleIconButton> createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
      ),
      color: isFavorite ? Colors.red : Colors.grey,
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
```

### AppBar Action Buttons

```dart
AppBar(
  title: Text('My App'),
  actions: [
    IconButton(
      icon: Icon(Icons.search),
      tooltip: 'Search',
      onPressed: () {
        // Open search
      },
    ),
    IconButton(
      icon: Icon(Icons.filter_list),
      tooltip: 'Filter',
      onPressed: () {
        // Open filter
      },
    ),
    IconButton(
      icon: Icon(Icons.more_vert),
      tooltip: 'More options',
      onPressed: () {
        // Show menu
      },
    ),
  ],
)
```

---

## FloatingActionButton - The Main Action Button

**Best for:** The primary action on a screen (Add, Create, Compose)

### Basic FAB

```dart
FloatingActionButton(
  onPressed: () {
    print('FAB pressed');
  },
  child: Icon(Icons.add),
)
```

### Extended FAB (with label)

```dart
FloatingActionButton.extended(
  onPressed: () {
    print('Extended FAB pressed');
  },
  icon: Icon(Icons.add),
  label: Text('Add Item'),
)
```

### Styled FAB

```dart
FloatingActionButton(
  onPressed: () {},
  backgroundColor: Colors.pink,
  foregroundColor: Colors.white,
  elevation: 8,
  highlightElevation: 12,  // When pressed
  child: Icon(Icons.edit),
)
```

### Mini FAB

```dart
FloatingActionButton(
  onPressed: () {},
  mini: true,  // Smaller size
  child: Icon(Icons.add),
)
```

### FAB in Scaffold

```dart
Scaffold(
  appBar: AppBar(title: Text('My App')),
  body: Center(child: Text('Content')),

  // FAB position
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Add new item
    },
    child: Icon(Icons.add),
  ),

  // FAB location (optional)
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  // Options:
  // - FloatingActionButtonLocation.endFloat (default)
  // - FloatingActionButtonLocation.centerFloat
  // - FloatingActionButtonLocation.startFloat
  // - FloatingActionButtonLocation.endDocked
  // - FloatingActionButtonLocation.centerDocked
)
```

### Multiple FABs (Speed Dial)

```dart
class SpeedDialFab extends StatefulWidget {
  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isExpanded) ...[
          FloatingActionButton(
            mini: true,
            onPressed: () {
              print('Option 1');
              setState(() => isExpanded = false);
            },
            child: Icon(Icons.photo),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              print('Option 2');
              setState(() => isExpanded = false);
            },
            child: Icon(Icons.video_call),
          ),
          SizedBox(height: 16),
        ],
        FloatingActionButton(
          onPressed: () {
            setState(() => isExpanded = !isExpanded);
          },
          child: Icon(isExpanded ? Icons.close : Icons.add),
        ),
      ],
    );
  }
}
```

---

## PopupMenuButton - Menu Button

**Best for:** Showing multiple action options

### Basic Popup Menu

```dart
PopupMenuButton<String>(
  onSelected: (value) {
    print('Selected: $value');
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'edit',
      child: Text('Edit'),
    ),
    PopupMenuItem(
      value: 'delete',
      child: Text('Delete'),
    ),
    PopupMenuItem(
      value: 'share',
      child: Text('Share'),
    ),
  ],
)
```

### With Icons

```dart
PopupMenuButton<String>(
  icon: Icon(Icons.more_vert),
  onSelected: (value) {
    switch (value) {
      case 'edit':
        // Edit action
        break;
      case 'delete':
        // Delete action
        break;
      case 'share':
        // Share action
        break;
    }
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          Icon(Icons.edit, size: 20),
          SizedBox(width: 12),
          Text('Edit'),
        ],
      ),
    ),
    PopupMenuItem(
      value: 'delete',
      child: Row(
        children: [
          Icon(Icons.delete, size: 20, color: Colors.red),
          SizedBox(width: 12),
          Text('Delete', style: TextStyle(color: Colors.red)),
        ],
      ),
    ),
    PopupMenuDivider(),  // Divider line
    PopupMenuItem(
      value: 'share',
      child: Row(
        children: [
          Icon(Icons.share, size: 20),
          SizedBox(width: 12),
          Text('Share'),
        ],
      ),
    ),
  ],
)
```

### AppBar Overflow Menu

```dart
AppBar(
  title: Text('My App'),
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) {
        print('Menu: $value');
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'settings', child: Text('Settings')),
        PopupMenuItem(value: 'help', child: Text('Help')),
        PopupMenuItem(value: 'about', child: Text('About')),
      ],
    ),
  ],
)
```

---

## Custom Button Widgets

### Create Your Own Button Style

```dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon),
            SizedBox(width: 8),
          ],
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Usage:
PrimaryButton(
  text: 'Save Changes',
  icon: Icons.save,
  onPressed: () {
    // Save action
  },
)
```

### Gradient Button

```dart
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const GradientButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.pink],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Complete Example: Button Showcase App

```dart
import 'package:flutter/material.dart';

void main() => runApp(ButtonShowcaseApp());

class ButtonShowcaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ButtonShowcasePage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ButtonShowcasePage extends StatefulWidget {
  @override
  State<ButtonShowcasePage> createState() => _ButtonShowcasePageState();
}

class _ButtonShowcasePageState extends State<ButtonShowcasePage> {
  bool isLoading = false;
  bool isFavorite = false;
  int counter = 0;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Showcase'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSnackBar('Search pressed'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _showSnackBar('Menu: $value'),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'help', child: Text('Help')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Elevated Buttons', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showSnackBar('Elevated button pressed'),
              child: Text('Elevated Button'),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showSnackBar('Save pressed'),
              icon: Icon(Icons.save),
              label: Text('Save'),
            ),

            SizedBox(height: 24),
            Text('Text Buttons', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _showSnackBar('Text button pressed'),
              child: Text('Text Button'),
            ),
            TextButton.icon(
              onPressed: () => _showSnackBar('Learn more pressed'),
              icon: Icon(Icons.help_outline),
              label: Text('Learn More'),
            ),

            SizedBox(height: 24),
            Text('Outlined Buttons', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _showSnackBar('Outlined button pressed'),
              child: Text('Outlined Button'),
            ),
            OutlinedButton.icon(
              onPressed: () => _showSnackBar('Add to cart'),
              icon: Icon(Icons.shopping_cart),
              label: Text('Add to Cart'),
            ),

            SizedBox(height: 24),
            Text('Icon Buttons', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  color: isFavorite ? Colors.red : Colors.grey,
                  onPressed: () {
                    setState(() => isFavorite = !isFavorite);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => _showSnackBar('Share pressed'),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => _showSnackBar('Delete pressed'),
                ),
              ],
            ),

            SizedBox(height: 24),
            Text('Loading State', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                setState(() => isLoading = true);
                await Future.delayed(Duration(seconds: 2));
                setState(() => isLoading = false);
                _showSnackBar('Completed!');
              },
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Submit'),
            ),

            SizedBox(height: 24),
            Text('Counter: $counter', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => counter++);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## Best Practices

### 1. Choose the Right Button Type

```dart
// PRIMARY action - use ElevatedButton
ElevatedButton(
  onPressed: () => _saveChanges(),
  child: Text('Save'),
)

// SECONDARY action - use TextButton
TextButton(
  onPressed: () => Navigator.pop(context),
  child: Text('Cancel'),
)

// ALTERNATIVE action - use OutlinedButton
OutlinedButton(
  onPressed: () => _saveAsDraft(),
  child: Text('Save as Draft'),
)
```

### 2. Use Loading States

```dart
ElevatedButton(
  onPressed: isLoading ? null : _handleSubmit,
  child: isLoading
    ? CircularProgressIndicator()
    : Text('Submit'),
)
```

### 3. Provide Feedback

```dart
ElevatedButton(
  onPressed: () {
    // Do action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action completed!')),
    );
  },
  child: Text('Do Action'),
)
```

### 4. Add Tooltips to IconButtons

```dart
IconButton(
  icon: Icon(Icons.delete),
  tooltip: 'Delete item',  // Shows on hover/long press
  onPressed: () {},
)
```

### 5. Consistent Styling

```dart
// Create theme for consistent buttons
ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
)
```

---

## Summary

You now know:
- **6 button types** and when to use each
- How to style buttons with colors, shapes, padding
- Button states (enabled, disabled, loading)
- Creating custom button widgets
- Best practices for professional apps

**Key Takeaways:**
- Use **ElevatedButton** for primary actions
- Use **TextButton** for secondary actions
- Use **OutlinedButton** for alternative actions
- Use **IconButton** for toolbar/compact UI
- Use **FAB** for the main screen action
- Use **PopupMenuButton** for multiple options

---

**Next:** Learn about Input Widgets

**Continue to:** `06b-InputWidgets.md`
