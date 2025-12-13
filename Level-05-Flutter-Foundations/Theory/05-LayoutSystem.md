# Flutter Layout System: How Widgets Are Positioned

## The Big Idea

Flutter's layout system is based on one simple concept:

```
Constraints go DOWN ↓
Sizes go UP ↑
Parent sets position
```

Think of it like a negotiation:
1. Parent tells child: "You can be this big"
2. Child decides: "I'll be this size"
3. Parent places child in position

---

## Constraints

A **constraint** is the rules a parent gives to its child:

```dart
// "You must be between 100-200 pixels wide"
// "You must be between 50-100 pixels tall"
BoxConstraints(
  minWidth: 100,
  maxWidth: 200,
  minHeight: 50,
  maxHeight: 100,
)
```

### Tight vs Loose Constraints

```dart
// Tight: Child MUST be exactly this size
BoxConstraints.tight(Size(100, 100))
// minWidth = maxWidth = 100
// minHeight = maxHeight = 100

// Loose: Child can be any size up to max
BoxConstraints.loose(Size(100, 100))
// minWidth = 0, maxWidth = 100
// minHeight = 0, maxHeight = 100
```

### Visualizing Constraints

```
Parent Container (300x200)
┌───────────────────────────────┐
│                               │
│   "You can be 0-300 wide"     │
│   "You can be 0-200 tall"     │
│                               │
│      Child decides size       │
│      ┌─────────────┐          │
│      │ 150 x 100   │          │
│      └─────────────┘          │
│                               │
└───────────────────────────────┘
```

---

## The Layout Process

Every widget goes through this:

```
1. Receive constraints from parent
           │
           ▼
2. Layout children (pass down constraints)
           │
           ▼
3. Determine own size (within constraints)
           │
           ▼
4. Position children
           │
           ▼
5. Report size to parent
```

---

## Row and Column: Main Axis vs Cross Axis

### Column (Vertical)

```dart
Column(
  mainAxisAlignment: ...,   // Vertical (↕)
  crossAxisAlignment: ...,  // Horizontal (↔)
  children: [...],
)
```

```
       ↑
       │ Main Axis (vertical)
       ↓

 ←───────→ Cross Axis (horizontal)

┌─────────────────────┐
│     ┌───────┐       │
│     │ Child │       │
│     └───────┘       │
│         │           │
│     ┌───────┐       │
│     │ Child │       │
│     └───────┘       │
│         │           │
│     ┌───────┐       │
│     │ Child │       │
│     └───────┘       │
└─────────────────────┘
```

### Row (Horizontal)

```dart
Row(
  mainAxisAlignment: ...,   // Horizontal (↔)
  crossAxisAlignment: ...,  // Vertical (↕)
  children: [...],
)
```

```
 ←─────────────────────→ Main Axis (horizontal)

       ↑
       │ Cross Axis (vertical)
       ↓

┌─────────────────────────────────┐
│  ┌───────┐ ┌───────┐ ┌───────┐  │
│  │ Child │ │ Child │ │ Child │  │
│  └───────┘ └───────┘ └───────┘  │
└─────────────────────────────────┘
```

---

## MainAxisAlignment Options

Controls spacing along the main axis:

```dart
// start (default)
// ┌──────────────────────┐
// │ [A][B][C]            │
// └──────────────────────┘

// end
// ┌──────────────────────┐
// │            [A][B][C] │
// └──────────────────────┘

// center
// ┌──────────────────────┐
// │      [A][B][C]       │
// └──────────────────────┘

// spaceBetween
// ┌──────────────────────┐
// │ [A]      [B]     [C] │
// └──────────────────────┘

// spaceEvenly
// ┌──────────────────────┐
// │   [A]    [B]    [C]  │
// └──────────────────────┘

// spaceAround
// ┌──────────────────────┐
// │  [A]    [B]    [C]   │
// └──────────────────────┘
```

### Code Example

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Container(width: 50, height: 50, color: Colors.green),
    Container(width: 50, height: 50, color: Colors.blue),
  ],
)
```

---

## CrossAxisAlignment Options

Controls alignment perpendicular to main axis:

```dart
// In a Column (controls horizontal alignment):

// start
// ┌──────────────────┐
// │ [Child         ] │
// │ [Child ]         │
// │ [Child   ]       │
// └──────────────────┘

// center
// ┌──────────────────┐
// │   [Child     ]   │
// │     [Child ]     │
// │    [Child  ]     │
// └──────────────────┘

// end
// ┌──────────────────┐
// │ [         Child] │
// │         [Child ] │
// │       [Child   ] │
// └──────────────────┘

// stretch
// ┌──────────────────┐
// │ [    Child     ] │
// │ [    Child     ] │
// │ [    Child     ] │
// └──────────────────┘
```

---

## MainAxisSize

Controls how much space the Row/Column takes:

```dart
// max (default): Take all available space
Column(
  mainAxisSize: MainAxisSize.max,
  children: [...],
)

// min: Take only needed space
Column(
  mainAxisSize: MainAxisSize.min,
  children: [...],
)
```

```
MainAxisSize.max          MainAxisSize.min
┌───────────────┐         ┌───────────────┐
│ [Child]       │         │ [Child]       │
│ [Child]       │         │ [Child]       │
│ [Child]       │         │ [Child]       │
│               │         └───────────────┘
│               │         (only as tall as needed)
│               │
└───────────────┘
(fills available height)
```

---

## Expanded and Flexible

### Expanded: Fill Available Space

```dart
Row(
  children: [
    Container(width: 50, color: Colors.red),
    Expanded(
      child: Container(color: Colors.green),  // Takes remaining space
    ),
    Container(width: 50, color: Colors.blue),
  ],
)
```

```
┌────────────────────────────────┐
│ [Red] [    Green        ] [Blue] │
│  50px   fills the rest    50px │
└────────────────────────────────┘
```

### Flex Factor

```dart
Row(
  children: [
    Expanded(
      flex: 2,  // Gets 2 parts
      child: Container(color: Colors.red),
    ),
    Expanded(
      flex: 1,  // Gets 1 part
      child: Container(color: Colors.blue),
    ),
  ],
)
```

```
Total = 3 parts
Red = 2/3 of space
Blue = 1/3 of space

┌──────────────────────────────┐
│ [    Red     ] [   Blue   ]  │
│     2/3           1/3        │
└──────────────────────────────┘
```

### Flexible vs Expanded

```dart
// Flexible: CAN expand but doesn't have to
Flexible(
  child: Container(...),  // May be smaller than available
)

// Expanded: WILL expand to fill space
Expanded(
  child: Container(...),  // Always fills available
)
```

---

## Container

A versatile box with many properties:

```dart
Container(
  // Size
  width: 200,
  height: 100,

  // Spacing outside
  margin: EdgeInsets.all(10),

  // Spacing inside
  padding: EdgeInsets.all(16),

  // Decoration (color, border, shadow)
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black),
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 5,
        offset: Offset(2, 2),
      ),
    ],
  ),

  // Alignment of child
  alignment: Alignment.center,

  // The content
  child: Text('Hello'),
)
```

### Container Without Size

When you don't specify width/height:

```dart
// Takes size of child
Container(
  color: Colors.red,
  child: Text('Hello'),  // Container wraps text
)

// Expands to fill parent (if no child)
Container(
  color: Colors.red,  // Fills available space
)
```

---

## SizedBox

For exact sizes or spacing:

```dart
// Exact size
SizedBox(
  width: 100,
  height: 50,
  child: Container(color: Colors.red),
)

// Spacing in a list
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),  // 20px gap
    Text('Second'),
    SizedBox(height: 20),  // 20px gap
    Text('Third'),
  ],
)

// Fill available space
SizedBox.expand(
  child: Container(color: Colors.blue),
)
```

---

## Padding vs Margin

```dart
// Padding: Space INSIDE
Container(
  padding: EdgeInsets.all(16),
  child: Text('Content'),
)

// Margin: Space OUTSIDE
Container(
  margin: EdgeInsets.all(16),
  child: Text('Content'),
)
```

```
MARGIN                    PADDING
┌──────────────────┐      ┌──────────────────┐
│   ┌──────────┐   │      │                  │
│   │ Content  │   │      │   ┌──────────┐   │
│   └──────────┘   │      │   │ Content  │   │
│   ↑ margin       │      │   └──────────┘   │
└──────────────────┘      │   ↑ padding      │
                          └──────────────────┘
```

---

## EdgeInsets Options

```dart
// All sides same
EdgeInsets.all(16)

// Horizontal and vertical
EdgeInsets.symmetric(horizontal: 20, vertical: 10)

// Individual sides
EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5)

// From LTRB
EdgeInsets.fromLTRB(10, 20, 10, 5)  // left, top, right, bottom
```

---

## Stack: Overlapping Widgets

Place widgets on top of each other:

```dart
Stack(
  children: [
    // Bottom layer (back)
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    // Top layer (front)
    Positioned(
      top: 20,
      left: 20,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
      ),
    ),
  ],
)
```

```
┌────────────────────────┐
│ ┌────────────┐         │
│ │   Red      │  Blue   │
│ │            │         │
│ └────────────┘         │
│                        │
│                        │
└────────────────────────┘
```

### Positioned Widget

```dart
Stack(
  children: [
    Container(color: Colors.grey),
    Positioned(
      top: 10,      // 10px from top
      right: 10,    // 10px from right
      child: Icon(Icons.close),
    ),
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,     // Stretch horizontally
      child: Container(height: 50, color: Colors.black54),
    ),
  ],
)
```

### Stack Alignment

```dart
Stack(
  alignment: Alignment.center,  // Default position for children
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Container(width: 100, height: 100, color: Colors.red),  // Centered
  ],
)
```

---

## Center

Centers its child in available space:

```dart
Center(
  child: Text('I am centered'),
)
```

Same as:

```dart
Align(
  alignment: Alignment.center,
  child: Text('I am centered'),
)
```

---

## Align

Position child anywhere:

```dart
Align(
  alignment: Alignment.topRight,
  child: Text('Top Right'),
)

Align(
  alignment: Alignment.bottomCenter,
  child: Text('Bottom Center'),
)

// Custom alignment (-1 to 1 for each axis)
Align(
  alignment: Alignment(0.5, -0.5),  // Slightly right, slightly up
  child: Text('Custom'),
)
```

```
Alignment values:
(-1,-1)────(0,-1)────(1,-1)
   │          │          │
   │  topLeft │ topRight │
   │          │          │
(-1,0)─────(0,0)─────(1,0)
   │          │          │
   │  center  │          │
   │          │          │
(-1,1)─────(0,1)─────(1,1)
   │          │          │
   │ bottomLeft│ bottomRight
```

---

## Common Layout Patterns

### Pattern 1: Header-Content-Footer

```dart
Column(
  children: [
    // Header (fixed)
    Container(
      height: 60,
      color: Colors.blue,
      child: Center(child: Text('Header')),
    ),

    // Content (flexible)
    Expanded(
      child: ListView(
        children: [/* content */],
      ),
    ),

    // Footer (fixed)
    Container(
      height: 50,
      color: Colors.grey,
      child: Center(child: Text('Footer')),
    ),
  ],
)
```

### Pattern 2: Sidebar Layout

```dart
Row(
  children: [
    // Sidebar (fixed)
    Container(
      width: 200,
      color: Colors.blue[100],
      child: Column(/* menu items */),
    ),

    // Main content (flexible)
    Expanded(
      child: Container(/* content */),
    ),
  ],
)
```

### Pattern 3: Card Grid

```dart
GridView.count(
  crossAxisCount: 2,  // 2 columns
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: [
    Card(child: Center(child: Text('1'))),
    Card(child: Center(child: Text('2'))),
    Card(child: Center(child: Text('3'))),
    Card(child: Center(child: Text('4'))),
  ],
)
```

### Pattern 4: Profile Header

```dart
Row(
  children: [
    CircleAvatar(radius: 30),
    SizedBox(width: 16),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Status message'),
        ],
      ),
    ),
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)
```

---

## Common Layout Errors

### Error 1: Unbounded Height in Column

```dart
// ❌ ERROR: ListView needs bounded height
Column(
  children: [
    ListView(),  // Tries to be infinitely tall!
  ],
)

// ✅ FIX: Wrap in Expanded
Column(
  children: [
    Expanded(
      child: ListView(),
    ),
  ],
)
```

### Error 2: Row/Column Overflow

```dart
// ❌ ERROR: Content too wide
Row(
  children: [
    Text('Very long text that goes on and on and on...'),
  ],
)

// ✅ FIX: Wrap in Expanded or Flexible
Row(
  children: [
    Expanded(
      child: Text(
        'Very long text...',
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
```

### Error 3: Nested Scrollables

```dart
// ❌ ERROR: Scroll inside scroll
ListView(
  children: [
    ListView(),  // Another scrollable!
  ],
)

// ✅ FIX: Use shrinkWrap or give fixed height
ListView(
  children: [
    ListView(
      shrinkWrap: true,  // Takes only needed height
      physics: NeverScrollableScrollPhysics(),  // Disable inner scroll
    ),
  ],
)
```

---

## Debugging Layout

### Using LayoutBuilder

```dart
LayoutBuilder(
  builder: (context, constraints) {
    print('Max width: ${constraints.maxWidth}');
    print('Max height: ${constraints.maxHeight}');

    return Container();
  },
)
```

### Visual Debugging

In your IDE or Flutter DevTools:
- Flutter Inspector shows widget tree
- Select widget to see constraints
- "Debug Paint" shows layout boundaries

---

## Summary

| Widget | Purpose |
|--------|---------|
| Row | Horizontal layout |
| Column | Vertical layout |
| Stack | Overlapping widgets |
| Container | Box with styling |
| SizedBox | Exact size/spacing |
| Expanded | Fill remaining space |
| Flexible | Can expand (optional) |
| Padding | Space inside |
| Center | Center child |
| Align | Position anywhere |

---

## Quick Quiz

**Q1:** What's the difference between mainAxisAlignment and crossAxisAlignment?

<details>
<summary>Answer</summary>

- **mainAxisAlignment**: Controls spacing along the primary direction (vertical for Column, horizontal for Row)
- **crossAxisAlignment**: Controls alignment perpendicular to the main axis (horizontal for Column, vertical for Row)

</details>

**Q2:** When would you use Expanded vs Flexible?

<details>
<summary>Answer</summary>

- **Expanded**: When you want a widget to fill ALL remaining space. It must expand.
- **Flexible**: When you want a widget to be ABLE to expand but not required to. It can be smaller if its content is smaller.

</details>

**Q3:** Why do you get an error when putting ListView inside Column?

<details>
<summary>Answer</summary>

Column gives its children unbounded (infinite) height constraints. ListView also wants to be as tall as possible. Since neither knows when to stop, you get an error. Fix by wrapping ListView in Expanded, which gives it bounded constraints.

</details>

---

**Next:** Reference guide for common Flutter widgets.

---

**Continue to:** `06-CommonWidgets.md`
