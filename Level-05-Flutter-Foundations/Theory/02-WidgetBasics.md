# Widget Basics: Building Blocks of Flutter

## Everything Is a Widget

In Flutter, **widgets** are the core building blocks. Every visual element is a widget:

```dart
// Text is a widget
Text('Hello')

// An icon is a widget
Icon(Icons.star)

// A button is a widget
ElevatedButton(onPressed: () {}, child: Text('Click'))

// Even spacing is a widget
SizedBox(height: 20)

// Layout is widgets
Column(children: [...])
Row(children: [...])
```

---

## The Widget Tree

Widgets nest inside each other to form a **tree**:

```dart
MaterialApp(                          // Root
  home: Scaffold(                     // Page structure
    appBar: AppBar(                   // Top bar
      title: Text('My App'),          // Bar title
    ),
    body: Center(                     // Centering
      child: Column(                  // Vertical layout
        children: [
          Text('Hello'),              // First item
          Icon(Icons.star),           // Second item
          ElevatedButton(             // Third item
            onPressed: () {},
            child: Text('Click Me'),
          ),
        ],
      ),
    ),
  ),
)
```

### Visual Widget Tree

```
MaterialApp
    │
    └── Scaffold
            │
            ├── AppBar
            │      └── Text('My App')
            │
            └── Center
                   └── Column
                          ├── Text('Hello')
                          ├── Icon(star)
                          └── ElevatedButton
                                  └── Text('Click Me')
```

---

## Widget Anatomy

Every widget is a class:

```dart
class MyWidget extends StatelessWidget {
  // 1. Constructor (with optional parameters)
  const MyWidget({
    super.key,
    required this.title,
    this.color = Colors.blue,
  });

  // 2. Properties
  final String title;
  final Color color;

  // 3. Build method (returns the UI)
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Text(title),
    );
  }
}
```

---

## The `key` Parameter

Every widget can have a `key` to help Flutter identify it:

```dart
// Without key (usually fine)
Text('Hello')

// With key (helps with lists, animations)
Text('Hello', key: ValueKey('greeting'))
```

**When to use keys:**
- Items in a list that can reorder
- Widgets that need to preserve state
- Animations between widgets

```dart
// Example: List items
ListView(
  children: items.map((item) =>
    ListTile(
      key: ValueKey(item.id),  // Helps Flutter track items
      title: Text(item.name),
    ),
  ).toList(),
)
```

---

## Common Widget Properties

### child vs children

Some widgets take one child:
```dart
Container(
  child: Text('Single child'),
)

Center(
  child: Icon(Icons.star),
)
```

Some widgets take multiple children:
```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)

Row(
  children: [
    Icon(Icons.star),
    Text('Rating'),
  ],
)
```

---

## Essential Widgets

### Text

```dart
Text(
  'Hello, Flutter!',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Container

A versatile box widget:

```dart
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 20),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 5,
        offset: Offset(2, 2),
      ),
    ],
  ),
  child: Text('Styled Box'),
)
```

### Icon

```dart
Icon(
  Icons.favorite,
  size: 48,
  color: Colors.red,
)
```

### Image

```dart
// From assets
Image.asset('assets/images/logo.png')

// From network
Image.network('https://example.com/image.png')

// With properties
Image.asset(
  'assets/photo.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### SizedBox

For exact sizing or spacing:

```dart
// Fixed size
SizedBox(
  width: 100,
  height: 50,
  child: Text('Fixed'),
)

// Spacing between widgets
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),  // 20px gap
    Text('Second'),
  ],
)
```

---

## Layout Widgets

### Center

Centers its child:

```dart
Center(
  child: Text('I am centered'),
)
```

### Padding

Adds space around a widget:

```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Text('With padding'),
)

// Different padding per side
Padding(
  padding: EdgeInsets.only(
    top: 10,
    bottom: 20,
    left: 15,
    right: 15,
  ),
  child: Text('Custom padding'),
)
```

### Column

Vertical layout:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,  // Vertical alignment
  crossAxisAlignment: CrossAxisAlignment.start, // Horizontal alignment
  children: [
    Text('Top'),
    Text('Middle'),
    Text('Bottom'),
  ],
)
```

### Row

Horizontal layout:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.star),
    Text('Rating'),
    Text('4.5'),
  ],
)
```

### Stack

Overlapping widgets:

```dart
Stack(
  children: [
    Image.asset('background.jpg'),
    Positioned(
      bottom: 10,
      right: 10,
      child: Text('Overlay'),
    ),
  ],
)
```

---

## Interactive Widgets

### ElevatedButton

```dart
ElevatedButton(
  onPressed: () {
    print('Button pressed!');
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),
  child: Text('Click Me'),
)
```

### TextButton

```dart
TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)
```

### IconButton

```dart
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
  color: Colors.red,
)
```

### GestureDetector

For custom tap handling:

```dart
GestureDetector(
  onTap: () => print('Tapped!'),
  onDoubleTap: () => print('Double tapped!'),
  onLongPress: () => print('Long pressed!'),
  child: Container(
    color: Colors.blue,
    padding: EdgeInsets.all(20),
    child: Text('Tap me'),
  ),
)
```

---

## Scaffold: App Structure

`Scaffold` provides the basic app structure:

```dart
Scaffold(
  // Top bar
  appBar: AppBar(
    title: Text('My App'),
    actions: [
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
    ],
  ),

  // Main content
  body: Center(
    child: Text('Content here'),
  ),

  // Floating button
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),

  // Bottom navigation
  bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  ),

  // Side drawer
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Menu')),
        ListTile(title: Text('Item 1')),
        ListTile(title: Text('Item 2')),
      ],
    ),
  ),
)
```

---

## Const Widgets

Use `const` for widgets that never change:

```dart
// ✅ Good: const for static widgets
const Text('Hello')
const Icon(Icons.star)
const SizedBox(height: 20)

// In a class
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});  // const constructor

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static'),
        SizedBox(height: 10),
        Icon(Icons.check),
      ],
    );
  }
}
```

**Benefits of const:**
- Better performance (reuses widget instances)
- Helps identify what can change
- Required for some optimizations

---

## Widget Composition

Build complex UIs by combining simple widgets:

```dart
// A custom card widget
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Usage
InfoCard(
  title: 'Flutter',
  subtitle: 'Build beautiful apps',
  icon: Icons.flutter_dash,
)
```

---

## Summary

| Widget | Purpose |
|--------|---------|
| `Text` | Display text |
| `Container` | Box with styling |
| `Row` | Horizontal layout |
| `Column` | Vertical layout |
| `Stack` | Overlapping widgets |
| `Center` | Center a widget |
| `Padding` | Add space around widget |
| `SizedBox` | Exact size or spacing |
| `Scaffold` | App page structure |
| `AppBar` | Top navigation bar |

---

## Quick Quiz

**Q1:** What's the difference between `child` and `children`?

<details>
<summary>Answer</summary>

- `child`: Takes a single widget
- `children`: Takes a list of widgets

```dart
Center(child: Text('One'))
Column(children: [Text('A'), Text('B')])
```

</details>

**Q2:** When should you use `const`?

<details>
<summary>Answer</summary>

Use `const` for widgets that never change - no dynamic values in their constructor. It improves performance by reusing widget instances.

</details>

**Q3:** What does `Scaffold` provide?

<details>
<summary>Answer</summary>

`Scaffold` provides the basic structure for a Material Design app page: AppBar, body, floating action button, drawer, bottom navigation bar, and snackbar support.

</details>

---

**Next:** Learn about StatelessWidgets in depth.

---

**Continue to:** `03-StatelessWidgets.md`
