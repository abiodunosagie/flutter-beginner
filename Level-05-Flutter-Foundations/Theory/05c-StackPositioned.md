# Level 05 PART 5c: Stack, Positioned, and Advanced Layouts

## For a 5-Year-Old

Imagine you're making a craft project with paper:

**Stack** is like laying sheets of paper on top of each other:
- The first sheet goes on the bottom
- Each new sheet goes on top of the previous one
- You can see all of them if they're different sizes

**Positioned** is like using tape to stick a paper exactly where you want it:
- "Put this 10 cm from the top"
- "Put this 5 cm from the right side"
- You're telling it exactly where to go

**Center** is like putting a sticker right in the middle of a page.

**Align** is like choosing any spot on the page - top-left corner, bottom-right, or anywhere!

---

## Stack: Overlapping Widgets

`Stack` lets you put widgets on top of each other, like layers in a drawing app.

### Basic Stack

```dart
Stack(
  children: [
    // First child = bottom layer
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    // Second child = on top of first
    Container(
      width: 150,
      height: 150,
      color: Colors.red,
    ),
    // Third child = on top of both
    Container(
      width: 100,
      height: 100,
      color: Colors.green,
    ),
  ],
)
```

```
Side view (3D):
              ┌────────┐
              │ Green  │ ← Top layer
          ┌───┴────────┴───┐
          │      Red       │ ← Middle layer
      ┌───┴────────────────┴───┐
      │         Blue           │ ← Bottom layer
      └────────────────────────┘

Top view (what you see):
┌────────────────────────┐
│ ┌────────────────────┐ │ Blue (bottom)
│ │ ┌────────────────┐ │ │
│ │ │ ┌────────────┐ │ │ │ Red (middle)
│ │ │ │   Green   │ │ │ │ Green (top)
│ │ │ │  (100x100)│ │ │ │
│ │ │ └────────────┘ │ │ │
│ │ │   (150x150)    │ │ │
│ │ └────────────────┘ │ │
│ │     (200x200)      │ │
│ └────────────────────┘ │
└────────────────────────┘
```

**Key Rule:** Order matters!
- First child = back (bottom)
- Last child = front (top)

---

## Stack Alignment

By default, children in a Stack are positioned at the top-left corner. You can change this with `alignment`.

### Default (topLeft)

```dart
Stack(
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Container(width: 100, height: 100, color: Colors.red),
  ],
)
```

```
┌──────────────────────┐
│ ┌────────┐           │
│ │  Red   │           │
│ │        │           │
│ └────────┘           │
│        Blue          │
│                      │
│                      │
└──────────────────────┘
↑ Both start at top-left
```

### Center Alignment

```dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Container(width: 100, height: 100, color: Colors.red),
  ],
)
```

```
┌──────────────────────┐
│                      │
│     ┌────────┐       │
│     │  Red   │       │
│     │ (centered)     │
│     └────────┘       │
│        Blue          │
│                      │
└──────────────────────┘
```

### Other Alignments

```dart
// Bottom-right corner
Stack(
  alignment: Alignment.bottomRight,
  children: [...],
)

// Top-center
Stack(
  alignment: Alignment.topCenter,
  children: [...],
)
```

---

## Positioned Widget

`Positioned` lets you place a child at an exact position in the Stack.

### Position from Edges

```dart
Stack(
  children: [
    Container(width: 300, height: 300, color: Colors.grey[300]),
    Positioned(
      top: 20,
      left: 20,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.red,
      ),
    ),
    Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    ),
  ],
)
```

```
┌─────────────────────────────────┐
│ ←20→ ┌────┐                     │
│  ↑20 │Red │                     │
│  ↓   └────┘                     │
│                                 │
│                                 │
│                    ┌────┐ ←20→ │
│                    │Blue│  ↑20 │
│                    └────┘  ↓   │
└─────────────────────────────────┘
```

### Fill an Edge

```dart
Stack(
  children: [
    Container(color: Colors.grey[300]),
    // Stretch across the top
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
        color: Colors.blue,
        child: Center(child: Text('Header')),
      ),
    ),
    // Stretch across the bottom
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
        color: Colors.grey,
        child: Center(child: Text('Footer')),
      ),
    ),
  ],
)
```

```
┌─────────────────────────────────┐
│ [        Header (Blue)        ] │ ← top: 0, left: 0, right: 0
│                                 │
│                                 │
│           Content               │
│                                 │
│                                 │
│ [        Footer (Grey)        ] │ ← bottom: 0, left: 0, right: 0
└─────────────────────────────────┘
```

### Absolute Positioning

```dart
Stack(
  children: [
    Container(color: Colors.grey[300]),
    Positioned(
      top: 100,
      left: 50,
      width: 200,
      height: 100,
      child: Container(
        color: Colors.red,
        child: Center(child: Text('Fixed Position')),
      ),
    ),
  ],
)
```

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│                                 │
│ ←50→ ┌──────────────────┐      │
│  ↑   │  Fixed Position  │      │
│ 100  │    200 x 100     │      │
│  ↓   └──────────────────┘      │
│                                 │
└─────────────────────────────────┘
```

### Common Positioned Patterns

```dart
// Close button in top-right
Positioned(
  top: 10,
  right: 10,
  child: IconButton(
    icon: Icon(Icons.close),
    onPressed: () {},
  ),
)

// Badge on avatar (like notification count)
Stack(
  children: [
    CircleAvatar(radius: 30),
    Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text('3', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
)

// Full-screen overlay
Positioned.fill(
  child: Container(
    color: Colors.black54,  // Semi-transparent black
    child: Center(child: CircularProgressIndicator()),
  ),
)
```

---

## Center and Align

### Center

Centers its child in the available space:

```dart
Center(
  child: Text('I am centered'),
)
```

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│      I am centered              │
│                                 │
│                                 │
└─────────────────────────────────┘
```

`Center` is just a shortcut for:

```dart
Align(
  alignment: Alignment.center,
  child: Text('I am centered'),
)
```

### Align

Position child anywhere in the available space:

```dart
Align(
  alignment: Alignment.topRight,
  child: Text('Top Right'),
)

Align(
  alignment: Alignment.bottomLeft,
  child: Text('Bottom Left'),
)

Align(
  alignment: Alignment.centerLeft,
  child: Text('Center Left'),
)
```

```
┌─────────────────────────────────┐
│                      Top Right  │
│                                 │
│ Center Left                     │
│                                 │
│ Bottom Left                     │
└─────────────────────────────────┘
```

---

## Alignment Coordinate System

Alignment uses coordinates from -1 to 1:

```
(-1,-1)────(0,-1)────(1,-1)
   │          │          │
topLeft    topCenter  topRight
   │          │          │
(-1,0)─────(0,0)─────(1,0)
   │          │          │
centerLeft center  centerRight
   │          │          │
(-1,1)─────(0,1)─────(1,1)
   │          │          │
bottomLeft bottomCenter bottomRight
```

### Named Alignments

```dart
Alignment.topLeft        // (-1, -1)
Alignment.topCenter      // (0, -1)
Alignment.topRight       // (1, -1)

Alignment.centerLeft     // (-1, 0)
Alignment.center         // (0, 0)
Alignment.centerRight    // (1, 0)

Alignment.bottomLeft     // (-1, 1)
Alignment.bottomCenter   // (0, 1)
Alignment.bottomRight    // (1, 1)
```

### Custom Alignments

You can use any value from -1 to 1:

```dart
// Slightly right of center, slightly up
Align(
  alignment: Alignment(0.5, -0.3),
  child: Text('Custom'),
)

// Far left, very bottom
Align(
  alignment: Alignment(-0.9, 0.9),
  child: Text('Custom'),
)
```

```
   -1         0         1
    │         │         │
-1 ─┼─────────┼─────────┼─ -1
    │         │         │
    │    (-0.3, 0.5)    │
    │         ●         │
 0 ─┼─────────┼─────────┼─ 0
    │         │         │
    │                   │
 1 ─┼─────────┼─────────┼─ 1
    │         │         │

Negative x = left
Positive x = right
Negative y = up
Positive y = down
```

---

## Common Layout Patterns

### Pattern 1: Header-Content-Footer

```dart
Column(
  children: [
    // Header (fixed height)
    Container(
      height: 60,
      color: Colors.blue,
      child: Center(
        child: Text(
          'Header',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),

    // Content (fills remaining space)
    Expanded(
      child: Container(
        color: Colors.grey[200],
        child: Center(child: Text('Content Area')),
      ),
    ),

    // Footer (fixed height)
    Container(
      height: 50,
      color: Colors.grey[800],
      child: Center(
        child: Text(
          'Footer',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
)
```

```
┌─────────────────────────────────┐
│         Header (60px)           │ ← Fixed
├─────────────────────────────────┤
│                                 │
│                                 │
│        Content Area             │ ← Expanded
│        (fills space)            │
│                                 │
├─────────────────────────────────┤
│         Footer (50px)           │ ← Fixed
└─────────────────────────────────┘
```

### Pattern 2: Sidebar Layout

```dart
Row(
  children: [
    // Sidebar (fixed width)
    Container(
      width: 200,
      color: Colors.blue[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    ),

    // Main content (flexible)
    Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text('Main Content Area'),
      ),
    ),
  ],
)
```

```
┌──────────────────────────────────────┐
│ Menu      │                          │
│           │                          │
│ Home      │    Main Content Area     │
│ Settings  │                          │
│ Profile   │    (fills remaining)     │
│           │                          │
│  200px    │                          │
└──────────────────────────────────────┘
```

### Pattern 3: Card Grid (2 columns)

```dart
GridView.count(
  crossAxisCount: 2,        // 2 columns
  mainAxisSpacing: 10,      // Vertical gap
  crossAxisSpacing: 10,     // Horizontal gap
  padding: EdgeInsets.all(10),
  children: List.generate(6, (index) {
    return Card(
      color: Colors.blue[100],
      child: Center(
        child: Text(
          'Card ${index + 1}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }),
)
```

```
┌──────────────────────────────────┐
│ ┌──────────┐   ┌──────────┐     │
│ │ Card 1   │   │ Card 2   │     │
│ └──────────┘   └──────────┘     │
│                                  │
│ ┌──────────┐   ┌──────────┐     │
│ │ Card 3   │   │ Card 4   │     │
│ └──────────┘   └──────────┘     │
│                                  │
│ ┌──────────┐   ┌──────────┐     │
│ │ Card 5   │   │ Card 6   │     │
│ └──────────┘   └──────────┘     │
└──────────────────────────────────┘
```

### Pattern 4: Profile Header with Stack

```dart
Stack(
  children: [
    // Background image
    Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
        ),
      ),
    ),

    // Profile info positioned at bottom
    Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40),
          ),
          SizedBox(width: 16),

          // Name and bio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Flutter Developer',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Edit button
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    ),
  ],
)
```

```
┌─────────────────────────────────────┐
│  ╔══════════════════════════════╗  │
│  ║   Blue-Purple Gradient       ║  │
│  ║          (Background)        ║  │
│  ║                              ║  │
│  ║  ●  John Doe              ✎  ║  │
│  ║     Flutter Developer        ║  │
│  ╚══════════════════════════════╝  │
│       ↑ Profile info on top         │
└─────────────────────────────────────┘
```

### Pattern 5: Image with Overlay Text

```dart
Stack(
  children: [
    // Background image
    Image.network(
      'https://example.com/image.jpg',
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
    ),

    // Dark overlay
    Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
      ),
    ),

    // Text on top
    Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beautiful Landscape',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'A scenic view from the mountains',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  ],
)
```

---

## Common Layout Errors and Fixes

### Error 1: Unbounded Height in Column

```dart
// ❌ ERROR: ListView needs bounded height
Column(
  children: [
    Text('Header'),
    ListView(
      children: [/* items */],  // "How tall should I be?" → "Infinite!"
    ),
  ],
)
```

**Error message:** `RenderBox was not laid out`

**Fix:** Wrap in Expanded or give fixed height

```dart
// ✅ FIX 1: Use Expanded
Column(
  children: [
    Text('Header'),
    Expanded(
      child: ListView(
        children: [/* items */],
      ),
    ),
  ],
)

// ✅ FIX 2: Use SizedBox
Column(
  children: [
    Text('Header'),
    SizedBox(
      height: 400,
      child: ListView(
        children: [/* items */],
      ),
    ),
  ],
)
```

### Error 2: Row/Column Overflow

```dart
// ❌ ERROR: Content wider than screen
Row(
  children: [
    Container(width: 200, color: Colors.red),
    Container(width: 200, color: Colors.blue),
    Container(width: 200, color: Colors.green),  // Too much!
  ],
)
```

**Error:** Yellow/black striped overflow indicator

**Fix:** Use Expanded or Flexible

```dart
// ✅ FIX: Share available space
Row(
  children: [
    Expanded(child: Container(color: Colors.red)),
    Expanded(child: Container(color: Colors.blue)),
    Expanded(child: Container(color: Colors.green)),
  ],
)
```

### Error 3: Text Overflow

```dart
// ❌ ERROR: Text too long for container
Row(
  children: [
    Icon(Icons.star),
    Text('Very long text that goes on and on and on...'),
  ],
)
```

**Fix:** Wrap text in Expanded + add overflow handling

```dart
// ✅ FIX
Row(
  children: [
    Icon(Icons.star),
    Expanded(
      child: Text(
        'Very long text that goes on and on and on...',
        overflow: TextOverflow.ellipsis,  // Shows ...
        maxLines: 1,
      ),
    ),
  ],
)
```

### Error 4: Positioned without Stack

```dart
// ❌ ERROR: Positioned must be inside Stack
Column(
  children: [
    Positioned(  // This crashes!
      top: 10,
      child: Text('Error'),
    ),
  ],
)
```

**Fix:** Use Stack

```dart
// ✅ FIX
Stack(
  children: [
    Positioned(
      top: 10,
      child: Text('Works!'),
    ),
  ],
)
```

### Error 5: Nested Scrollables

```dart
// ❌ ERROR: ScrollView inside ScrollView
ListView(
  children: [
    ListView(  // Both want to scroll!
      children: [/* items */],
    ),
  ],
)
```

**Fix:** Use shrinkWrap and disable scroll physics

```dart
// ✅ FIX
ListView(
  children: [
    ListView(
      shrinkWrap: true,  // Only take needed height
      physics: NeverScrollableScrollPhysics(),  // Don't scroll
      children: [/* items */],
    ),
  ],
)
```

---

## Debugging Layout with LayoutBuilder

`LayoutBuilder` lets you see what constraints a widget receives:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    print('Max width: ${constraints.maxWidth}');
    print('Max height: ${constraints.maxHeight}');
    print('Min width: ${constraints.minWidth}');
    print('Min height: ${constraints.minHeight}');

    // Build different layouts based on size
    if (constraints.maxWidth > 600) {
      return Row(children: [/* wide layout */]);
    } else {
      return Column(children: [/* narrow layout */]);
    }
  },
)
```

### Responsive Layout Example

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // Tablet/Desktop: Side-by-side
    if (constraints.maxWidth > 600) {
      return Row(
        children: [
          Expanded(flex: 1, child: Sidebar()),
          Expanded(flex: 2, child: Content()),
        ],
      );
    }
    // Mobile: Stacked
    else {
      return Column(
        children: [
          Sidebar(),
          Expanded(child: Content()),
        ],
      );
    }
  },
)
```

---

## Complete Example: Advanced Layout

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
        body: SafeArea(
          child: Column(
            children: [
              // Header with Stack
              Stack(
                children: [
                  // Background
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                  ),

                  // Title
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Text(
                      'My App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),

                  // Profile section at bottom
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 30),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Good to see you',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildCard('Photos', Icons.photo, Colors.blue),
                      _buildCard('Videos', Icons.videocam, Colors.red),
                      _buildCard('Music', Icons.music_note, Colors.green),
                      _buildCard('Files', Icons.folder, Colors.orange),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home, 'Home', true),
                    _buildNavItem(Icons.search, 'Search', false),
                    _buildNavItem(Icons.favorite, 'Favorites', false),
                    _buildNavItem(Icons.person, 'Profile', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool selected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: selected ? Colors.blue : Colors.grey,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }
}
```

---

## Key Takeaways

1. **Stack** overlays widgets (first = bottom, last = top)
2. **Positioned** places children at exact positions in Stack
3. **Alignment** uses coordinate system (-1 to 1)
4. **Center** is shorthand for `Align(alignment: Alignment.center)`
5. **Common patterns**: header-content-footer, sidebar, grid, overlay
6. **Common errors**: unbounded heights, overflow, missing Stack
7. **LayoutBuilder** helps create responsive layouts
8. **Positioned.fill** creates full-screen overlays

**The Mental Model:**

Think of Stack as layers in Photoshop:
- Each child is a layer
- Positioned lets you move layers around
- Alignment sets the default position

---

## Quick Quiz

**Q1:** In a Stack with three children, which one appears on top?

<details>
<summary>Answer</summary>

The LAST child (the third one) appears on top. In a Stack, children are layered from first (bottom) to last (top).

</details>

**Q2:** What's the difference between Positioned and Align?

<details>
<summary>Answer</summary>

- **Positioned**: Must be inside a Stack. Uses absolute positioning (pixels from edges: top, left, right, bottom)
- **Align**: Can be used anywhere. Uses relative positioning (coordinates from -1 to 1)

</details>

**Q3:** Why use LayoutBuilder?

<details>
<summary>Answer</summary>

LayoutBuilder lets you:
1. See what constraints a widget receives
2. Build different layouts based on available space
3. Create responsive designs (different layouts for phone vs tablet)

</details>

---

**Next:** Learn about common Flutter widgets

**Continue to:** `06-CommonWidgets.md`

---

**Navigation:**
- Previous: `05b-FlexibleExpanded.md`
- **Current: `05c-StackPositioned.md`**
- Next: `06-CommonWidgets.md`
- Overview: `../README.md`
