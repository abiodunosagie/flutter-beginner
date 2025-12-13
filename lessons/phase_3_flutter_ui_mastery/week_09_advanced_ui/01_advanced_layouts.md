# Week 9, Day 1-2: Advanced Layouts - Stack, Positioned, and Flexible

## Beyond Row and Column

You've learned Row and Column. Now let's master **advanced layouts** for complex UIs.

**What you'll learn:**
- Stack (layering widgets)
- Positioned (precise placement)
- Flexible and Expanded (proportional sizing)
- Wrap (automatic wrapping)
- GridView (grids)

---

## Stack - Layering Widgets

**Stack** = Place widgets on top of each other (like stacking cards).

**Real-world analogy:**
- Layers in Photoshop
- Cards stacked on a table
- Background image with text overlay

### Basic Stack

```dart
Stack(
  children: [
    Container(color: Colors.red, width: 200, height: 200),
    Container(color: Colors.blue, width: 150, height: 150),
    Container(color: Colors.green, width: 100, height: 100),
  ],
)
```

**Result:**
- Red box at bottom (200x200)
- Blue box on top (150x150)
- Green box on top (100x100)
- All positioned at top-left by default

### Stack with Alignment

```dart
Stack(
  alignment: Alignment.center,  // Center all children
  children: [
    Container(
      width: 300,
      height: 300,
      color: Colors.blue,
    ),
    Container(
      width: 200,
      height: 200,
      color: Colors.red,
    ),
    Container(
      width: 100,
      height: 100,
      color: Colors.green,
    ),
  ],
)
```

**Alignment options:**
```dart
Alignment.topLeft
Alignment.topCenter
Alignment.topRight
Alignment.centerLeft
Alignment.center
Alignment.centerRight
Alignment.bottomLeft
Alignment.bottomCenter
Alignment.bottomRight
```

---

## Positioned - Precise Control

**Positioned** = Control exact position within Stack.

### Basic Positioned

```dart
Stack(
  children: [
    // Background
    Container(
      width: 300,
      height: 300,
      color: Colors.grey[300],
    ),

    // Top-left corner
    Positioned(
      top: 10,
      left: 10,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.red,
      ),
    ),

    // Bottom-right corner
    Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    ),

    // Center
    Positioned(
      top: 125,
      left: 125,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.green,
      ),
    ),
  ],
)
```

### Positioned.fill

Fill entire parent:

```dart
Stack(
  children: [
    // Background image
    Positioned.fill(
      child: Image.network(
        'https://picsum.photos/400/400',
        fit: BoxFit.cover,
      ),
    ),

    // Text overlay
    Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.black54,
        child: Text(
          'Beautiful Image',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ),
  ],
)
```

### Positioned with Dynamic Sizing

```dart
Positioned(
  top: 20,
  left: 20,
  right: 20,  // Width = parent width - 40
  child: Container(
    height: 100,
    color: Colors.blue,
  ),
)
```

---

## Real-World Example: Profile Card

```dart
class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      child: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Profile picture
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  image: DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Name
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Text(
              'John Doe',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Title
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Text(
              'Flutter Developer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),

          // Stats
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('120', 'Posts'),
                _buildStat('1.2K', 'Followers'),
                _buildStat('850', 'Following'),
              ],
            ),
          ),

          // Edit button
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
```

---

## Flexible and Expanded - Proportional Sizing

### Expanded - Fill Available Space

```dart
Row(
  children: [
    Container(width: 50, height: 50, color: Colors.red),
    Expanded(
      child: Container(height: 50, color: Colors.blue),  // Fills remaining space
    ),
    Container(width: 50, height: 50, color: Colors.green),
  ],
)
```

**Result:** Blue container takes all space between red and green.

### Multiple Expanded

```dart
Row(
  children: [
    Expanded(
      child: Container(height: 50, color: Colors.red),
    ),
    Expanded(
      child: Container(height: 50, color: Colors.blue),
    ),
    Expanded(
      child: Container(height: 50, color: Colors.green),
    ),
  ],
)
```

**Result:** Each takes 1/3 of space (equal distribution).

### Expanded with flex

```dart
Row(
  children: [
    Expanded(
      flex: 1,  // Takes 1/6 of space
      child: Container(height: 50, color: Colors.red),
    ),
    Expanded(
      flex: 2,  // Takes 2/6 of space
      child: Container(height: 50, color: Colors.blue),
    ),
    Expanded(
      flex: 3,  // Takes 3/6 of space
      child: Container(height: 50, color: Colors.green),
    ),
  ],
)
```

**Calculation:**
- Total flex = 1 + 2 + 3 = 6
- Red = 1/6 of width
- Blue = 2/6 of width
- Green = 3/6 of width

### Flexible - Proportional but NOT Forced

```dart
Row(
  children: [
    Flexible(
      flex: 1,
      child: Container(height: 50, color: Colors.red),
    ),
    Flexible(
      flex: 2,
      child: Container(height: 50, color: Colors.blue),
    ),
  ],
)
```

**Difference:**
- **Expanded** = MUST fill space (forced)
- **Flexible** = CAN fill space (optional)

---

## Wrap - Automatic Wrapping

**Wrap** = Like Row/Column but wraps to next line when space runs out.

**Think of it like:**
- Text wrapping in a paragraph
- Items in a store shelf (move to next shelf when full)

### Basic Wrap

```dart
Wrap(
  spacing: 10,  // Horizontal space between items
  runSpacing: 10,  // Vertical space between lines
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Mobile')),
    Chip(label: Text('Web')),
    Chip(label: Text('Desktop')),
    Chip(label: Text('Development')),
    Chip(label: Text('Programming')),
  ],
)
```

**Result:** Chips wrap to next line when row is full.

### Wrap Alignment

```dart
Wrap(
  alignment: WrapAlignment.center,  // Horizontal alignment
  runAlignment: WrapAlignment.center,  // Vertical alignment
  spacing: 8,
  runSpacing: 8,
  children: [
    _buildTag('Flutter'),
    _buildTag('Dart'),
    _buildTag('Mobile'),
    _buildTag('Web'),
  ],
)

Widget _buildTag(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}
```

---

## GridView - Grid Layouts

### GridView.count

Fixed number of columns:

```dart
GridView.count(
  crossAxisCount: 2,  // 2 columns
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: [
    _buildGridItem('Item 1', Colors.red),
    _buildGridItem('Item 2', Colors.blue),
    _buildGridItem('Item 3', Colors.green),
    _buildGridItem('Item 4', Colors.orange),
    _buildGridItem('Item 5', Colors.purple),
    _buildGridItem('Item 6', Colors.teal),
  ],
)

Widget _buildGridItem(String title, Color color) {
  return Container(
    color: color,
    child: Center(
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
  );
}
```

### GridView.extent

Maximum item width:

```dart
GridView.extent(
  maxCrossAxisExtent: 150,  // Max 150px wide
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: List.generate(20, (index) {
    return Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(child: Text('$index')),
    );
  }),
)
```

**Result:** Auto-adjusts columns based on screen width (responsive!).

### GridView.builder

For large lists (only builds visible items):

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: 100,
  itemBuilder: (context, index) {
    return Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(
        child: Text('$index', style: TextStyle(color: Colors.white)),
      ),
    );
  },
)
```

---

## Real-World Example: Photo Gallery

```dart
class PhotoGallery extends StatelessWidget {
  final List<String> photos = List.generate(
    20,
    (index) => 'https://picsum.photos/200/200?random=$index',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Gallery')),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Show full image
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Image.network(photos[index]),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(photos[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## LayoutBuilder - Responsive Layouts

Build different layouts based on available space:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Desktop layout
      return Row(
        children: [
          Expanded(flex: 1, child: Sidebar()),
          Expanded(flex: 3, child: MainContent()),
        ],
      );
    } else {
      // Mobile layout
      return Column(
        children: [
          MainContent(),
        ],
      );
    }
  },
)
```

---

## AspectRatio - Maintain Proportions

```dart
AspectRatio(
  aspectRatio: 16 / 9,  // 16:9 ratio (like video)
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('16:9')),
  ),
)
```

---

## FractionallySizedBox - Percentage Sizing

```dart
FractionallySizedBox(
  widthFactor: 0.8,  // 80% of parent width
  heightFactor: 0.5,  // 50% of parent height
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('80% x 50%')),
  ),
)
```

---

## Complete Example: Dashboard

```dart
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Users', '1,234', Icons.people),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Revenue', '\$12K', Icons.attach_money),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Chart area
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Chart Placeholder')),
              ),
            ),

            SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Activity list
            ...List.generate(5, (index) {
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Activity ${index + 1}'),
                  subtitle: Text('2 hours ago'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
```

---

## Key Takeaways

1. **Stack** = Layer widgets on top of each other
2. **Positioned** = Control exact position in Stack
3. **Expanded** = Fill available space (forced)
4. **Flexible** = Use available space (optional)
5. **Wrap** = Automatically wrap to next line
6. **GridView** = Grid layouts
7. **LayoutBuilder** = Responsive layouts
8. **AspectRatio** = Maintain proportions

---

## What's Next?

Tomorrow: **Custom Widgets & Composition**
- Building reusable widgets
- Widget composition
- Best practices
- Creating widget libraries

You've mastered advanced layouts! 🎨✨
