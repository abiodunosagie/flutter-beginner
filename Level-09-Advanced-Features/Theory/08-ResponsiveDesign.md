# Responsive Design: Apps That Fit Any Screen

## The Big Idea In One Sentence

> Responsive design means your layout measures the screen size (with `MediaQuery` or `LayoutBuilder`) and rearranges itself, so it looks right on a tiny phone and a wide tablet.

## The Simple Explanation

Imagine you have a photo that you want to put in different frames:

```
FIXED SIZE (Not Responsive):
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  Small Frame:         Big Frame:                         │
│  ┌───────┐           ┌───────────────────┐              │
│  │ Photo │           │ Photo             │              │
│  │ gets  │           │ is tiny!          │              │
│  │ cut   │           │                   │              │
│  │ off!  │           │                   │              │
│  └───────┘           └───────────────────┘              │
│                                                          │
│  😢 Doesn't fit properly in either!                      │
│                                                          │
└─────────────────────────────────────────────────────────┘

RESPONSIVE (Adapts to frame):
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  Small Frame:         Big Frame:                         │
│  ┌───────┐           ┌───────────────────┐              │
│  │ Photo │           │    Photo fills    │              │
│  │ fits  │           │    the whole      │              │
│  │ nice! │           │    frame nicely!  │              │
│  └───────┘           └───────────────────┘              │
│                                                          │
│  😊 Fits perfectly in BOTH!                              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Responsive design = Your app looks good on ANY screen size!**

---

## Why Does This Matter?

Your app needs to work on:

```
📱 Small phone         (360px wide)
📱 Large phone         (428px wide)
📱 Tablet portrait     (768px wide)
📱 Tablet landscape    (1024px wide)
💻 Desktop             (1920px wide)

One app, MANY screen sizes!
```

---

## Getting Screen Size

Flutter gives you the screen size through MediaQuery:

```dart
Widget build(BuildContext context) {
  // Get screen information
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  print('Screen: ${screenWidth}x${screenHeight}');
  // Example: "Screen: 390x844" for iPhone 14
}
```

---

## Method 1: Responsive Breakpoints

Define different layouts for different screen sizes:

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Desktop: 1024px and above
    if (width >= 1024) {
      return desktop;
    }

    // Tablet: 600px to 1024px
    if (width >= 600) {
      return tablet ?? mobile;
    }

    // Mobile: less than 600px
    return mobile;
  }
}
```

### Using Responsive Layout

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        // Phone layout: single column
        mobile: ListView(
          children: [
            ProductCard(product: products[0]),
            ProductCard(product: products[1]),
            ProductCard(product: products[2]),
          ],
        ),

        // Tablet layout: two columns
        tablet: GridView.count(
          crossAxisCount: 2,
          children: products.map((p) => ProductCard(product: p)).toList(),
        ),

        // Desktop layout: three columns with sidebar
        desktop: Row(
          children: [
            // Sidebar
            SizedBox(
              width: 250,
              child: NavigationPanel(),
            ),
            // Main content: 3 columns
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: products.map((p) => ProductCard(product: p)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Visual: Different Layouts

```
MOBILE (< 600px):          TABLET (600-1024px):
┌──────────────┐           ┌──────────────────────┐
│    Card 1    │           │  Card 1  │  Card 2  │
│    Card 2    │           │  Card 3  │  Card 4  │
│    Card 3    │           │  Card 5  │  Card 6  │
│    Card 4    │           └──────────────────────┘
│    ...       │
└──────────────┘

DESKTOP (>= 1024px):
┌──────────────────────────────────────────┐
│ Sidebar │  Card 1  │  Card 2  │  Card 3 │
│         │  Card 4  │  Card 5  │  Card 6 │
│  Menu   │  Card 7  │  Card 8  │  Card 9 │
│  Items  │                               │
└──────────────────────────────────────────┘
```

---

## Method 2: Flexible and Expanded

Let widgets share space proportionally:

### Expanded: Take All Available Space

```dart
Row(
  children: [
    Container(
      width: 100,  // Fixed width
      color: Colors.red,
    ),
    Expanded(
      child: Container(
        color: Colors.blue,  // Takes ALL remaining space
      ),
    ),
  ],
)
```

```
┌──────────┬───────────────────────────────────────┐
│  100px   │         Remaining space               │
│  (red)   │            (blue)                     │
└──────────┴───────────────────────────────────────┘
```

### Expanded with flex: Share Space

```dart
Row(
  children: [
    Expanded(
      flex: 1,  // Takes 1 part
      child: Container(color: Colors.red),
    ),
    Expanded(
      flex: 2,  // Takes 2 parts
      child: Container(color: Colors.blue),
    ),
    Expanded(
      flex: 1,  // Takes 1 part
      child: Container(color: Colors.green),
    ),
  ],
)
```

```
┌────────────┬──────────────────────────┬────────────┐
│    25%     │          50%             │    25%     │
│   (red)    │         (blue)           │  (green)   │
└────────────┴──────────────────────────┴────────────┘
     1 part  +      2 parts       +      1 part = 4 parts
```

### Flexible: Take Only What You Need

```dart
Row(
  children: [
    Flexible(
      child: Text('This is a very long text that might not fit'),
    ),
    Container(width: 50, color: Colors.red),
  ],
)
```

Flexible takes only as much space as needed (up to maximum).

---

## Method 3: LayoutBuilder

Get the actual available space for a widget:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // constraints.maxWidth = available width
    // constraints.maxHeight = available height

    if (constraints.maxWidth < 400) {
      return MobileLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### When to Use LayoutBuilder

```dart
class AdaptiveCard extends StatelessWidget {
  const AdaptiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Card adapts based on its container size
        // (not the whole screen)

        if (constraints.maxWidth < 300) {
          // Small container: compact layout
          return const CompactCard();
        } else {
          // Large container: expanded layout
          return const ExpandedCard();
        }
      },
    );
  }
}
```

---

## Method 4: FractionallySizedBox

Size widgets as a percentage of parent:

```dart
FractionallySizedBox(
  widthFactor: 0.8,   // 80% of parent width
  heightFactor: 0.5,  // 50% of parent height
  child: Container(
    color: Colors.blue,
  ),
)
```

```
Parent (100%):
┌────────────────────────────────────────────────────┐
│                                                    │
│     Child (80% x 50%):                             │
│     ┌──────────────────────────────────────┐       │
│     │                                      │       │
│     │                                      │       │
│     └──────────────────────────────────────┘       │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## Method 5: AspectRatio

Keep consistent proportions:

```dart
AspectRatio(
  aspectRatio: 16 / 9,  // Width / Height ratio
  child: Container(
    color: Colors.blue,
  ),
)
```

```
16:9 ratio (like a TV):
┌────────────────────────────────────────┐
│                                        │
│            16 units wide               │
│               9 tall                   │
│                                        │
└────────────────────────────────────────┘

1:1 ratio (square):
┌─────────────┐
│             │
│   Square!   │
│             │
└─────────────┘
```

---

## Method 6: Wrap for Flexible Grids

Items that wrap to next line when they don't fit:

```dart
Wrap(
  spacing: 8,        // Horizontal space between items
  runSpacing: 8,     // Vertical space between lines
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Mobile')),
    Chip(label: Text('Web')),
    Chip(label: Text('Desktop')),
    Chip(label: Text('Cross-platform')),
  ],
)
```

```
Wide screen:
┌─────────────────────────────────────────────┐
│ [Flutter] [Dart] [Mobile] [Web] [Desktop]   │
│ [Cross-platform]                            │
└─────────────────────────────────────────────┘

Narrow screen:
┌───────────────────┐
│ [Flutter] [Dart]  │
│ [Mobile] [Web]    │
│ [Desktop]         │
│ [Cross-platform]  │
└───────────────────┘
```

---

## Responsive Text

Text size that adapts to screen:

### Using MediaQuery

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.05,
    // 5% of screen width
  ),
)
```

### Better: Use a helper function

```dart
double responsiveFont(BuildContext context, double factor) {
  final width = MediaQuery.of(context).size.width;

  if (width < 600) {
    return width * factor;  // Mobile
  } else if (width < 1024) {
    return width * factor * 0.8;  // Tablet
  } else {
    return width * factor * 0.6;  // Desktop
  }
}

// Usage:
Text(
  'Hello',
  style: TextStyle(
    fontSize: responsiveFont(context, 0.06),
  ),
)
```

---

## Responsive Padding and Spacing

```dart
class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double padding;
    if (width < 600) {
      padding = 16;  // Mobile: small padding
    } else if (width < 1024) {
      padding = 32;  // Tablet: medium padding
    } else {
      padding = 64;  // Desktop: large padding
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}
```

---

## Complete Example: Responsive Product Grid

```dart
import 'package:flutter/material.dart';

class ProductGridPage extends StatelessWidget {
  const ProductGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine number of columns based on width
          int columns;
          if (constraints.maxWidth < 600) {
            columns = 2;  // Mobile
          } else if (constraints.maxWidth < 900) {
            columns = 3;  // Small tablet
          } else if (constraints.maxWidth < 1200) {
            columns = 4;  // Large tablet
          } else {
            columns = 5;  // Desktop
          }

          return GridView.builder(
            padding: EdgeInsets.all(
              constraints.maxWidth < 600 ? 8 : 16,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ProductCard(index: index);
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final int index;

  const ProductCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 48),
              ),
            ),
          ),

          // Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product $index',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${(index + 1) * 10}.99',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Responsive Navigation

Different navigation for different sizes:

```dart
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;

  const ResponsiveScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Desktop: Side navigation
    if (width >= 1024) {
      return Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: (index) {},
          ),
          Expanded(child: body),
        ],
      );
    }

    // Mobile/Tablet: Bottom navigation
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              RESPONSIVE DESIGN SUMMARY                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: Making your app look good on ALL screen sizes     │
│                                                          │
│  METHODS:                                                │
│  1. MediaQuery - Get screen size                         │
│  2. LayoutBuilder - Get container size                   │
│  3. Expanded/Flexible - Share space proportionally       │
│  4. FractionallySizedBox - Size as percentage            │
│  5. AspectRatio - Keep proportions                       │
│  6. Wrap - Items wrap to next line                       │
│                                                          │
│  BREAKPOINTS:                                            │
│  • Mobile:  < 600px                                      │
│  • Tablet:  600px - 1024px                               │
│  • Desktop: >= 1024px                                    │
│                                                          │
│  BEST PRACTICES:                                         │
│  • Use Expanded over fixed sizes                         │
│  • Test on multiple screen sizes                         │
│  • Use LayoutBuilder for reusable components             │
│  • Adjust columns in grids based on width                │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What's the difference between MediaQuery and LayoutBuilder?

<details>
<summary>Answer</summary>

- **MediaQuery**: Gives you the **whole screen** size
- **LayoutBuilder**: Gives you the **parent container** size

Use MediaQuery for global layouts, LayoutBuilder for reusable components that need to adapt to their container.

</details>

**Q2:** How do you make a widget take 50% of available width?

<details>
<summary>Answer</summary>

Several ways:

```dart
// Method 1: FractionallySizedBox
FractionallySizedBox(
  widthFactor: 0.5,
  child: Container(),
)

// Method 2: Expanded with flex in Row
Row(
  children: [
    Expanded(flex: 1, child: Container()),  // 50%
    Expanded(flex: 1, child: Container()),  // 50%
  ],
)
```

</details>

**Q3:** What widget makes items wrap to the next line when they don't fit?

<details>
<summary>Answer</summary>

**Wrap** widget!

```dart
Wrap(
  children: [
    Chip(label: Text('Tag 1')),
    Chip(label: Text('Tag 2')),
    Chip(label: Text('Tag 3')),
    // Wraps to next line when needed
  ],
)
```

</details>

---

**Congratulations!** You've completed Level 9: Advanced Features!

## Assignment

### Problem 1: Get the width

Write the expression that gets the current screen width.

### Problem 2: Phone or tablet?

Write an `if` that treats a width of 600 or more as "tablet" and shows a different layout. (Pseudocode is fine.)

### Problem 3: MediaQuery vs LayoutBuilder

In one line each: what does `MediaQuery` measure, and what does `LayoutBuilder` measure?

---

## Assignment Answers

### Problem 1: Get the width

```dart
final width = MediaQuery.of(context).size.width;
```

### Problem 2: Phone or tablet?

```dart
if (MediaQuery.of(context).size.width >= 600) {
  // tablet layout
} else {
  // phone layout
}
```

### Problem 3: MediaQuery vs LayoutBuilder

- `MediaQuery` measures the whole screen (and things like padding/insets).
- `LayoutBuilder` measures the space the parent gives this particular widget.

---

**Next Level:** Level 10 - Final Project

---

[← Back to Level 09 README](../README.md)
