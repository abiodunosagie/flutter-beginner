# Layout Basics: Organizing Your Widgets

## Think of Organizing Your Room

Imagine arranging toys in your room:
- **Row** = Line them up left to right →
- **Column** = Stack them top to bottom ↓
- **Center** = Put one toy in the middle of the room
- **Padding** = Give toys some breathing room
- **Scaffold** = The room itself (walls, ceiling, floor)

Let's learn how to organize widgets like organizing toys!

---

## Row: Line Things Up Horizontally

`Row` places widgets in a horizontal line (left to right →).

### Basic Row

```dart
Row(
  children: [
    Icon(Icons.star),
    Icon(Icons.star),
    Icon(Icons.star),
  ],
)
```

Result: ⭐⭐⭐ (three stars in a line)

### Row with Different Widgets

```dart
Row(
  children: [
    Icon(Icons.person, size: 30),
    SizedBox(width: 10),  // Spacing
    Text('John Doe'),
    SizedBox(width: 10),
    Icon(Icons.verified, color: Colors.blue),
  ],
)
```

Result: 👤 John Doe ✓

### Row Spacing (mainAxisAlignment)

Control how widgets are spaced:

```dart
// Packed at start (default)
Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Container(width: 50, height: 50, color: Colors.green),
    Container(width: 50, height: 50, color: Colors.blue),
  ],
)
```

```
start                  center                 end
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│[R][G][B]       │     │    [R][G][B]   │     │       [R][G][B]│
└────────────────┘     └────────────────┘     └────────────────┘

spaceBetween           spaceEvenly            spaceAround
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│[R]   [G]   [B] │     │ [R]  [G]  [B]  │     │ [R]  [G]  [B]  │
└────────────────┘     └────────────────┘     └────────────────┘
```

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.person),
  ],
)
```

### Row Alignment (crossAxisAlignment)

Control vertical alignment within the row:

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,  // top
  // crossAxisAlignment: CrossAxisAlignment.center,  // middle (default)
  // crossAxisAlignment: CrossAxisAlignment.end,  // bottom
  children: [
    Container(width: 50, height: 100, color: Colors.red),
    Container(width: 50, height: 50, color: Colors.green),
    Container(width: 50, height: 150, color: Colors.blue),
  ],
)
```

```
start (top)         center (middle)      end (bottom)
┌────────────┐      ┌────────────┐       ┌────────────┐
│[R][G]      │      │[R]         │       │[R]         │
│[R]   [B]   │      │[R][G][B]   │       │[R]         │
│[R]   [B]   │      │[R]   [B]   │       │[R][G][B]   │
│      [B]   │      │      [B]   │       │      [B]   │
└────────────┘      └────────────┘       └────────────┘
```

---

## Column: Stack Things Vertically

`Column` places widgets in a vertical stack (top to bottom ↓).

### Basic Column

```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

Result:
```
First
Second
Third
```

### Column Spacing (mainAxisAlignment)

Control vertical spacing:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.cloud, size: 50),
    Icon(Icons.ac_unit, size: 50),
    Icon(Icons.wb_sunny, size: 50),
  ],
)
```

```
start               center              end
┌──────┐           ┌──────┐            ┌──────┐
│[Icon]│           │      │            │      │
│[Icon]│           │[Icon]│            │      │
│[Icon]│           │[Icon]│            │[Icon]│
│      │           │[Icon]│            │[Icon]│
└──────┘           └──────┘            │[Icon]│
                                       └──────┘

spaceBetween       spaceEvenly         spaceAround
┌──────┐           ┌──────┐            ┌──────┐
│[Icon]│           │      │            │      │
│      │           │[Icon]│            │[Icon]│
│[Icon]│           │      │            │      │
│      │           │[Icon]│            │[Icon]│
│[Icon]│           │      │            │      │
└──────┘           │[Icon]│            │[Icon]│
                   └──────┘            └──────┘
```

### Column Alignment (crossAxisAlignment)

Control horizontal alignment:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,  // left
  // crossAxisAlignment: CrossAxisAlignment.center,  // center (default)
  // crossAxisAlignment: CrossAxisAlignment.end,  // right
  children: [
    Container(width: 100, height: 50, color: Colors.red),
    Container(width: 150, height: 50, color: Colors.green),
    Container(width: 80, height: 50, color: Colors.blue),
  ],
)
```

```
start (left)        center              end (right)
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│[Red      ]   │    │  [  Red   ]  │    │   [      Red]│
│[Green       ]│    │  [ Green  ]  │    │   [    Green]│
│[Blue  ]      │    │  [  Blue  ]  │    │   [     Blue]│
└──────────────┘    └──────────────┘    └──────────────┘
```

---

## Understanding MainAxis vs CrossAxis

This is super important!

### In Row (Horizontal)

```
     Cross Axis (vertical ↕)
           ↓
    ┌──────────────────┐
    │     ┌───┐        │
←───┤─────│ W │────────┤───→  Main Axis (horizontal ↔)
    │     └───┘        │
    └──────────────────┘
```

- **MainAxis** = Horizontal (where widgets line up)
- **CrossAxis** = Vertical (perpendicular direction)

### In Column (Vertical)

```
           ↑
           │ Main Axis (vertical ↕)
           │
    ┌──────┼──────┐
    │    ┌─┴─┐    │
←───┼────│ W │────┼───→  Cross Axis (horizontal ↔)
    │    └───┘    │
    └─────────────┘
```

- **MainAxis** = Vertical (where widgets stack)
- **CrossAxis** = Horizontal (perpendicular direction)

---

## Center: Put Widget in the Middle

`Center` puts its child in the center of available space.

### Basic Center

```dart
Center(
  child: Text('I am centered!'),
)
```

### Center with Container

```dart
Container(
  width: 300,
  height: 200,
  color: Colors.grey[300],
  child: Center(
    child: Text(
      'Centered Text',
      style: TextStyle(fontSize: 24),
    ),
  ),
)
```

```
┌─────────────────────────┐
│                         │
│                         │
│      Centered Text      │
│                         │
│                         │
└─────────────────────────┘
```

---

## Padding: Add Space Around Widget

`Padding` adds space inside a container around its child.

### All Sides Equal

```dart
Padding(
  padding: EdgeInsets.all(16),  // 16 pixels on all sides
  child: Text('Padded text'),
)
```

### Symmetric Padding

```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: 20,  // Left and right
    vertical: 10,    // Top and bottom
  ),
  child: Text('Padded text'),
)
```

### Different Each Side

```dart
Padding(
  padding: EdgeInsets.only(
    left: 10,
    top: 20,
    right: 10,
    bottom: 5,
  ),
  child: Text('Custom padding'),
)
```

### Visual Padding Example

```
No Padding              With Padding
┌────────────┐          ┌────────────┐
│Text here   │          │            │
└────────────┘          │ Text here  │
                        │            │
                        └────────────┘
```

### EdgeInsets Options

```dart
// All sides
EdgeInsets.all(16)

// Horizontal and vertical
EdgeInsets.symmetric(horizontal: 20, vertical: 10)

// Individual sides
EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5)

// From Left-Top-Right-Bottom
EdgeInsets.fromLTRB(10, 20, 10, 5)

// No padding
EdgeInsets.zero
```

---

## Scaffold: The App Structure

`Scaffold` provides the basic structure for a Material Design app.

### Basic Scaffold

```dart
Scaffold(
  appBar: AppBar(
    title: Text('My App'),
  ),
  body: Center(
    child: Text('Content goes here'),
  ),
)
```

### Complete Scaffold

```dart
Scaffold(
  // Top bar
  appBar: AppBar(
    title: Text('My App'),
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {},
      ),
    ],
  ),

  // Main content
  body: Center(
    child: Text('Hello, World!'),
  ),

  // Floating button (bottom right)
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),

  // Bottom navigation
  bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ],
  ),

  // Side drawer
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Menu',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {},
        ),
      ],
    ),
  ),
)
```

### Scaffold Visual Structure

```
┌────────────────────────────────┐
│ AppBar (title, actions)        │
├────────────────────────────────┤
│                                │
│         Body (content)         │
│                                │
│                                │
│                          [+]   │← FloatingActionButton
├────────────────────────────────┤
│  [Home]  [Search]  [Profile]   │← BottomNavigationBar
└────────────────────────────────┘
```

---

## Practical Examples

### Example 1: Simple Profile Header

```dart
Row(
  children: [
    CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
    ),
    SizedBox(width: 16),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alice Johnson',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Flutter Developer',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  ],
)
```

### Example 2: Icon with Label

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.favorite, color: Colors.red, size: 40),
    SizedBox(height: 4),
    Text('Favorite'),
  ],
)
```

### Example 3: Action Bar

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Column(
      children: [
        Icon(Icons.thumb_up, color: Colors.blue),
        SizedBox(height: 4),
        Text('Like'),
      ],
    ),
    Column(
      children: [
        Icon(Icons.comment, color: Colors.grey),
        SizedBox(height: 4),
        Text('Comment'),
      ],
    ),
    Column(
      children: [
        Icon(Icons.share, color: Colors.grey),
        SizedBox(height: 4),
        Text('Share'),
      ],
    ),
  ],
)
```

### Example 4: Card Layout

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
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
      Text(
        'This is the card description. It can have multiple lines of text.',
        style: TextStyle(color: Colors.grey[600]),
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('CANCEL'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text('OK'),
          ),
        ],
      ),
    ],
  ),
)
```

---

## Common Layout Patterns

### Pattern 1: Header-Content Structure

```dart
Column(
  children: [
    // Header
    Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue,
      child: Row(
        children: [
          Icon(Icons.menu, color: Colors.white),
          SizedBox(width: 16),
          Text(
            'Title',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    ),

    // Content
    Padding(
      padding: EdgeInsets.all(16),
      child: Text('Content goes here'),
    ),
  ],
)
```

### Pattern 2: List Item

```dart
Padding(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Row(
    children: [
      Icon(Icons.folder, size: 40, color: Colors.blue),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '24 items',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      Icon(Icons.chevron_right, color: Colors.grey),
    ],
  ),
)
```

---

## Summary: Key Takeaways

| Widget | Purpose | Key Property |
|--------|---------|--------------|
| `Row` | Horizontal layout | `mainAxisAlignment` |
| `Column` | Vertical layout | `mainAxisAlignment` |
| `Center` | Center child | - |
| `Padding` | Space around | `EdgeInsets` |
| `Scaffold` | App structure | `appBar`, `body`, `drawer` |

---

## Quick Quiz

**Q1:** What's the difference between `Row` and `Column`?

<details>
<summary>Answer</summary>

- **Row**: Arranges widgets horizontally (left to right →)
- **Column**: Arranges widgets vertically (top to bottom ↓)

Both use the same properties (`mainAxisAlignment`, `crossAxisAlignment`), but the main axis direction is different.

</details>

**Q2:** How do you add space between widgets in a `Column`?

<details>
<summary>Answer</summary>

Use `SizedBox` with height:

```dart
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),  // 20 pixels of space
    Text('Second'),
  ],
)
```

Or use `mainAxisAlignment`:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Text('First'),
    Text('Second'),
  ],
)
```

</details>

**Q3:** What does `Scaffold` provide?

<details>
<summary>Answer</summary>

`Scaffold` provides the basic structure for a Material Design app:
- `appBar` - Top navigation bar
- `body` - Main content area
- `floatingActionButton` - Circular button (usually bottom right)
- `drawer` - Side menu
- `bottomNavigationBar` - Bottom tab bar

It's the foundation for most Flutter screens!

</details>

---

**Next:** Learn how to build your own custom stateless widgets!

---

## Navigation

⬅️ **Previous:** [Basic Display Widgets](02b-BasicWidgets.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Stateless Widget Introduction](03a-StatelessIntro.md)
