# Week 10, Day 4-7: Responsive Design - Adaptive Flutter UIs

## 5-Year-Old Explanation

Imagine you have a magic coloring book. When you look at it on a small piece of paper, the pictures are arranged in ONE column (stacked on top of each other). But when you look at it on a BIG piece of paper, the same pictures spread out into TWO or THREE columns side by side!

The pictures are the same, but they rearrange themselves to fit the paper size perfectly. That's responsive design!

**Real-world example:**
Think about water in different containers:
- Pour water into a tall, thin glass → It's tall and thin
- Pour the same water into a wide bowl → It spreads out wide
- The water (your content) stays the same, but its shape changes to fit!

**In Flutter apps:**
- On a phone (small screen) → Show one thing at a time, stacked vertically
- On a tablet (bigger screen) → Show two things side by side
- On a computer (huge screen) → Show three or four things side by side!

Your app is smart enough to check: "How big is this screen?" and then rearrange itself automatically!

Without responsive design: Your app looks perfect on your phone but TERRIBLE on an iPad - things are tiny or stretched weird. With responsive design: Your app looks perfect EVERYWHERE - phone, tablet, computer, even on a TV!

---

## What is Responsive Design?

**Responsive Design** = UI adapts to different screen sizes.

**Why it matters:**
- 📱 Phones (small)
- 📱 Tablets (medium)
- 💻 Desktop (large)
- 🖥️ Ultra-wide monitors (extra large)

**Same code, different layouts!**

---

## MediaQuery - Screen Information

**MediaQuery** = Get device screen information.

### Basic Usage

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      width: screenWidth * 0.8,  // 80% of screen width
      height: screenHeight * 0.5,  // 50% of screen height
      color: Colors.blue,
    );
  }
}
```

### MediaQuery Properties

```dart
final mediaQuery = MediaQuery.of(context);

// Screen dimensions
mediaQuery.size.width            // Screen width in pixels
mediaQuery.size.height           // Screen height in pixels

// Device pixel ratio (for high-DPI screens)
mediaQuery.devicePixelRatio      // 1.0, 2.0, 3.0, etc.

// Orientation
mediaQuery.orientation           // portrait or landscape

// Padding (safe areas)
mediaQuery.padding.top           // Status bar height
mediaQuery.padding.bottom        // Bottom navigation/home indicator
mediaQuery.viewInsets.bottom     // Keyboard height when visible

// Text scale factor
mediaQuery.textScaleFactor       // User's text size preference
```

---

## Breakpoints - Screen Size Categories

### Define Breakpoints

```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < Breakpoints.mobile) {
    return DeviceType.mobile;
  } else if (width < Breakpoints.tablet) {
    return DeviceType.tablet;
  } else {
    return DeviceType.desktop;
  }
}
```

### Use Breakpoints

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return MobileLayout();
      case DeviceType.tablet:
        return TabletLayout();
      case DeviceType.desktop:
        return DesktopLayout();
    }
  }
}
```

---

## LayoutBuilder - Build Based on Constraints

**LayoutBuilder** = Build widget based on parent constraints.

### Basic Example

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Wide screen
      return Row(
        children: [
          Expanded(child: Sidebar()),
          Expanded(child: MainContent()),
        ],
      );
    } else {
      // Narrow screen
      return Column(
        children: [
          MainContent(),
        ],
      );
    }
  },
)
```

### Constraints Properties

```dart
LayoutBuilder(
  builder: (context, constraints) {
    print(constraints.maxWidth);    // Maximum width
    print(constraints.minWidth);    // Minimum width
    print(constraints.maxHeight);   // Maximum height
    print(constraints.minHeight);   // Minimum height

    return Container();
  },
)
```

---

## Responsive Grid

### Adaptive Column Count

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveGrid({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;

        if (constraints.maxWidth >= 1200) {
          columns = 4;  // Desktop
        } else if (constraints.maxWidth >= 900) {
          columns = 3;  // Tablet landscape
        } else if (constraints.maxWidth >= 600) {
          columns = 2;  // Tablet portrait
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

// Usage
ResponsiveGrid(
  children: List.generate(20, (i) {
    return Container(
      color: Colors.primaries[i % Colors.primaries.length],
      child: Center(child: Text('Item $i')),
    );
  }),
)
```

---

## Responsive Text

### Scale Text Based on Screen

```dart
class ResponsiveText extends StatelessWidget {
  final String text;

  const ResponsiveText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double fontSize = 16;  // Default

    if (width >= 1200) {
      fontSize = 24;  // Desktop
    } else if (width >= 900) {
      fontSize = 20;  // Tablet
    } else if (width >= 600) {
      fontSize = 18;  // Large phone
    }

    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
```

### Respect User Text Scale

```dart
Text(
  'Hello',
  style: TextStyle(
    fontSize: 16 * MediaQuery.of(context).textScaleFactor,
  ),
)
```

---

## OrientationBuilder - Portrait vs Landscape

```dart
OrientationBuilder(
  builder: (context, orientation) {
    if (orientation == Orientation.portrait) {
      return Column(
        children: [
          Image.network('photo.jpg'),
          Text('Portrait mode'),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: Image.network('photo.jpg')),
          Expanded(child: Text('Landscape mode')),
        ],
      );
    }
  },
)
```

---

## Real-World Example: Dashboard

```dart
class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: MediaQuery.of(context).size.width < 900 ? _buildDrawer() : null,
      body: Row(
        children: [
          // Sidebar (only on tablet/desktop)
          if (MediaQuery.of(context).size.width >= 900)
            Container(
              width: 250,
              color: Colors.grey[200],
              child: _buildDrawerContent(),
            ),

          // Main content
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _buildMainContent(constraints.maxWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: _buildDrawerContent(),
    );
  }

  Widget _buildDrawerContent() {
    return ListView(
      children: [
        DrawerHeader(
          child: Text('Menu'),
          decoration: BoxDecoration(color: Colors.blue),
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
    );
  }

  Widget _buildMainContent(double width) {
    int columns = 1;

    if (width >= 1200) {
      columns = 3;
    } else if (width >= 600) {
      columns = 2;
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildStatCard(
          title: 'Stat ${index + 1}',
          value: '${(index + 1) * 100}',
          icon: Icons.bar_chart,
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
```

**Result:**
- **Mobile:** Drawer menu, 1 column grid
- **Tablet:** Drawer menu, 2 column grid
- **Desktop:** Permanent sidebar, 3 column grid

---

## Responsive Padding and Spacing

```dart
class ResponsiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Adaptive padding
    double padding = 16;
    if (width >= 900) {
      padding = 32;  // More padding on larger screens
    }

    return Container(
      padding: EdgeInsets.all(padding),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text('Responsive padding'),
        ),
      ),
    );
  }
}
```

---

## AspectRatio for Consistency

```dart
// Maintains 16:9 ratio across all screens
AspectRatio(
  aspectRatio: 16 / 9,
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('16:9 Video')),
  ),
)
```

---

## FractionallySizedBox

```dart
// Always 80% of parent width, regardless of screen size
FractionallySizedBox(
  widthFactor: 0.8,
  child: Container(
    height: 100,
    color: Colors.blue,
  ),
)
```

---

## Safe Area - Handle Notches and Gestures

```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        Text('Content respects safe areas'),
        // Won't be hidden by notch or gesture bar
      ],
    ),
  ),
)
```

---

## Complete Responsive App Example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive App',
      home: ResponsiveHomePage(),
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return DesktopLayout();
        } else if (constraints.maxWidth >= 600) {
          return TabletLayout();
        } else {
          return MobileLayout();
        }
      },
    );
  }
}

// Mobile Layout
class MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mobile Layout')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            ...List.generate(3, (i) => _buildCard('Card ${i + 1}')),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Mobile view', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildCard(String title) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('This is a card in mobile layout'),
          ],
        ),
      ),
    );
  }
}

// Tablet Layout
class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tablet Layout')),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(6, (i) => _buildCard('Card ${i + 1}')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Tablet view', style: TextStyle(color: Colors.grey)),
          ],
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text('New'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCard(String title) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.blue),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Desktop Layout
class DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Permanent sidebar
          Container(
            width: 250,
            color: Colors.grey[200],
            child: AppDrawerContent(),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Desktop Layout',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(icon: Icon(Icons.search), onPressed: () {}),
                          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
                          SizedBox(width: 16),
                          CircleAvatar(child: Text('U')),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content area
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      children: List.generate(9, (i) => _buildCard('Card ${i + 1}')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Desktop view',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Shared Drawer
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: AppDrawerContent(),
    );
  }
}

class AppDrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 30,
                child: Text('U'),
              ),
              SizedBox(height: 12),
              Text(
                'User Name',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {},
        ),
      ],
    );
  }
}
```

**Result:**
- **Mobile (< 600px):** Single column, drawer menu
- **Tablet (600-900px):** 2-column grid, drawer menu
- **Desktop (> 900px):** 3-column grid, permanent sidebar, top navigation

---

## Best Practices

### 1. Use Percentages, Not Fixed Sizes

```dart
// BAD
Container(width: 300, height: 200)

// GOOD
Container(
  width: MediaQuery.of(context).size.width * 0.8,
  height: MediaQuery.of(context).size.width * 0.5,
)
```

### 2. Test on Multiple Screen Sizes

- Use Flutter DevTools device simulator
- Test on physical devices
- Use responsive preview extensions

### 3. Consider Orientation

```dart
OrientationBuilder(
  builder: (context, orientation) {
    return orientation == Orientation.portrait
        ? PortraitLayout()
        : LandscapeLayout();
  },
)
```

### 4. Respect Safe Areas

```dart
SafeArea(
  child: YourContent(),
)
```

### 5. Use Flexible Layouts

```dart
// Adapts to available space
Row(
  children: [
    Flexible(child: Widget1()),
    Flexible(child: Widget2()),
  ],
)
```

---

## Key Takeaways

1. **MediaQuery** = Get screen information
2. **Breakpoints** = Define size categories
3. **LayoutBuilder** = Build based on constraints
4. **Responsive grids** = Adaptive column count
5. **OrientationBuilder** = Portrait vs landscape
6. **SafeArea** = Handle notches and gestures
7. **Test on multiple sizes** = Ensure it works everywhere
8. **Percentages over fixed** = More flexible

---

## What's Next?

You've completed **Phase 3: Flutter UI Mastery**!

**Tomorrow:** Start **Phase 4 Advanced Topics**
- Animations
- Custom painters
- Advanced gestures
- Performance optimization

You've mastered responsive design! Your apps work everywhere! 📱💻🖥️✨
