# Week 7, Day 3-4: Widgets Deep Dive - Building Blocks of Flutter

## 5-Year-Old Explanation

Imagine you're building with LEGO blocks. You have different types of blocks:
- Rectangle blocks for walls
- Window blocks to see through
- Door blocks to walk through
- Wheel blocks to make things move
- Special blocks that light up

You take all these different blocks and snap them together to build a house, a car, or a spaceship!

**In Flutter, widgets are exactly like LEGO blocks!**

Each widget is a building block that does ONE thing:
- A Text widget shows words on the screen
- A Button widget you can press
- An Image widget shows a picture
- A Container widget holds other widgets (like a box)

**The magic:** You stack these widgets together like LEGO to build your entire app!

Want to make a profile screen? Stack together:
- An Image widget (for the profile picture)
- A Text widget (for the name)
- Another Text widget (for the bio)
- A Button widget (to edit the profile)

Everything you see in ANY Flutter app - every button, every text, every image, every color - is made from widgets! Master widgets, and you can build anything!

---

## Everything is a Widget

In Flutter, the UI is built entirely from widgets. Understanding widgets is understanding Flutter.

**Widget = A piece of UI**

Every visible element is a widget:
- Text → Text widget
- Button → ElevatedButton widget
- Image → Image widget
- Layout → Column, Row, Stack widgets

---

## Widget Categories

### 1. Structural Widgets
Provide app structure:
- MaterialApp
- Scaffold
- AppBar

### 2. Display Widgets
Show information:
- Text
- Image
- Icon

### 3. Layout Widgets
Arrange other widgets:
- Container
- Row
- Column
- Stack

### 4. Interactive Widgets
Respond to user input:
- ElevatedButton
- TextButton
- TextField
- GestureDetector

---

## Text Widget

The most basic widget:

```dart
Text('Hello, Flutter!')
```

### Styling Text

```dart
Text(
  'Styled Text',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontStyle: FontStyle.italic,
    letterSpacing: 2.0,
    decoration: TextDecoration.underline,
  ),
)
```

### Text Alignment

```dart
Text(
  'Centered Text',
  textAlign: TextAlign.center,
)

Text(
  'Right Aligned',
  textAlign: TextAlign.right,
)
```

### Max Lines and Overflow

```dart
Text(
  'This is a very long text that might overflow the container if not handled properly',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,  // Shows ...
)
```

---

## Container Widget

The most versatile widget. Like a div in HTML.

### Basic Container

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
  child: Center(
    child: Text('Container'),
  ),
)
```

### Container with Decoration

```dart
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  child: Center(
    child: Text(
      'Styled Container',
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

### Container with Padding and Margin

```dart
Container(
  padding: EdgeInsets.all(20),        // Inside spacing
  margin: EdgeInsets.all(10),         // Outside spacing
  color: Colors.blue,
  child: Text('Padded Text'),
)
```

### Edge Insets Variations

```dart
EdgeInsets.all(20)                    // All sides
EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 10,
)
EdgeInsets.only(
  left: 10,
  top: 20,
  right: 10,
  bottom: 5,
)
EdgeInsets.fromLTRB(10, 20, 10, 5)   // Left, Top, Right, Bottom
```

---

## Row Widget

Arranges children horizontally:

```dart
Row(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

### Main Axis Alignment (Horizontal)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.start,      // Default
  mainAxisAlignment: MainAxisAlignment.end,
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Text('A'),
    Text('B'),
    Text('C'),
  ],
)
```

### Cross Axis Alignment (Vertical)

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text('A'),
    Text('B'),
    Text('C'),
  ],
)
```

### Row with Mixed Content

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Icon(Icons.home, size: 40),
    Text('Home', style: TextStyle(fontSize: 24)),
    ElevatedButton(
      onPressed: () {},
      child: Text('Click'),
    ),
  ],
)
```

---

## Column Widget

Arranges children vertically:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

### Column Example

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Name: John Doe'),
    Text('Age: 25'),
    Text('City: New York'),
  ],
)
```

---

## SizedBox

Creates fixed space or empty box:

```dart
// Spacer
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),  // 20 pixels space
    Text('Second'),
  ],
)

// Fixed size box
SizedBox(
  width: 200,
  height: 100,
  child: Container(color: Colors.blue),
)
```

---

## Expanded and Flexible

### Expanded - Take All Available Space

```dart
Row(
  children: [
    Container(
      width: 50,
      color: Colors.red,
    ),
    Expanded(
      child: Container(color: Colors.blue),  // Takes remaining space
    ),
    Container(
      width: 50,
      color: Colors.green,
    ),
  ],
)
```

### Multiple Expanded with Flex

```dart
Row(
  children: [
    Expanded(
      flex: 1,
      child: Container(color: Colors.red),  // 1/4 of space
    ),
    Expanded(
      flex: 3,
      child: Container(color: Colors.blue),  // 3/4 of space
    ),
  ],
)
```

### Flexible

```dart
Row(
  children: [
    Flexible(
      child: Container(
        color: Colors.red,
        child: Text('Flexible content that wraps'),
      ),
    ),
    Container(
      width: 100,
      color: Colors.blue,
    ),
  ],
)
```

---

## Icon Widget

Display Material Design icons:

```dart
Icon(Icons.home)

Icon(
  Icons.favorite,
  color: Colors.red,
  size: 40,
)

Icon(
  Icons.star,
  color: Colors.amber,
  size: 60,
)
```

### Common Icons

```dart
Icons.home
Icons.search
Icons.settings
Icons.person
Icons.email
Icons.phone
Icons.favorite
Icons.star
Icons.add
Icons.delete
Icons.edit
Icons.check
Icons.close
Icons.arrow_back
Icons.arrow_forward
Icons.menu
```

---

## Image Widget

### From Network

```dart
Image.network(
  'https://picsum.photos/200',
  width: 200,
  height: 200,
)
```

### From Assets

1. Add to pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/images/
```

2. Use in code:
```dart
Image.asset(
  'assets/images/logo.png',
  width: 200,
  height: 200,
)
```

### Image with Fit

```dart
Image.network(
  'https://picsum.photos/400/200',
  width: 300,
  height: 300,
  fit: BoxFit.cover,     // Cover entire box
  fit: BoxFit.contain,   // Fit inside box
  fit: BoxFit.fill,      // Stretch to fill
  fit: BoxFit.fitWidth,  // Fit width
  fit: BoxFit.fitHeight, // Fit height
)
```

---

## CircleAvatar

Display circular images:

```dart
CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('https://picsum.photos/200'),
)

CircleAvatar(
  radius: 50,
  backgroundColor: Colors.blue,
  child: Text(
    'JD',
    style: TextStyle(fontSize: 40, color: Colors.white),
  ),
)
```

---

## Card Widget

Material Design card:

```dart
Card(
  elevation: 5,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Title',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text('Card content goes here'),
      ],
    ),
  ),
)
```

### Styled Card

```dart
Card(
  elevation: 8,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  color: Colors.blue.shade50,
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Text('Styled Card'),
  ),
)
```

---

## ListTile

Pre-built list item:

```dart
ListTile(
  leading: Icon(Icons.person),
  title: Text('John Doe'),
  subtitle: Text('Software Developer'),
  trailing: Icon(Icons.arrow_forward),
  onTap: () {
    print('Tapped!');
  },
)
```

### ListTile in Card

```dart
Card(
  child: ListTile(
    leading: CircleAvatar(
      child: Text('JD'),
    ),
    title: Text('John Doe'),
    subtitle: Text('john@example.com'),
    trailing: Icon(Icons.more_vert),
  ),
)
```

---

## Divider

Horizontal line separator:

```dart
Column(
  children: [
    Text('Item 1'),
    Divider(),
    Text('Item 2'),
    Divider(
      color: Colors.blue,
      thickness: 2,
      indent: 20,
      endIndent: 20,
    ),
    Text('Item 3'),
  ],
)
```

---

## Complete Example: Profile Card

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Card'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Card(
            elevation: 8,
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Name
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Title
                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 20),

                  Divider(),

                  SizedBox(height: 20),

                  // Contact info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.email, color: Colors.teal),
                          SizedBox(height: 5),
                          Text('Email'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.phone, color: Colors.teal),
                          SizedBox(height: 5),
                          Text('Phone'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.location_on, color: Colors.teal),
                          SizedBox(height: 5),
                          Text('Location'),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('120', 'Projects'),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey,
                      ),
                      _buildStat('1.2k', 'Followers'),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey,
                      ),
                      _buildStat('850', 'Following'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
```

---

## Key Takeaways

1. **Everything is a widget** in Flutter
2. **Container** = Most versatile layout widget
3. **Row** = Horizontal arrangement
4. **Column** = Vertical arrangement
5. **Expanded** = Take available space
6. **Card** = Material Design card
7. **ListTile** = Pre-built list item

---

## What's Next

- StatefulWidget and state management
- User input and interactivity
- Navigation between screens
