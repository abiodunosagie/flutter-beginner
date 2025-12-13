# Week 17, Day 3-5: Web-Specific Responsive Layouts (No Packages!)

## 5-Year-Old Explanation

Imagine you have a photo that you want to hang on different walls:
- Tiny bathroom wall → Make the photo small to fit
- Living room wall → Make it bigger
- Entire movie theater screen → Make it HUGE!

The photo is the same, but it changes size to fit perfectly wherever you put it!

Web responsive layouts are the same - your app needs to look perfect whether someone views it on:
- A tiny phone (like a bathroom wall)
- A tablet (like a living room wall)
- A huge computer monitor (like a movie theater!)

The difference between mobile and web is like the difference between fitting a photo in a lunchbox versus fitting it on a billboard. Web screens can be MASSIVE - some are 10 times bigger than phones! Your app needs to be smart enough to rearrange itself for any size screen.

---

## Web Responsiveness is Different

**Mobile responsiveness:**
- 320px to 414px wide
- Portrait mostly
- Touch input

**Web responsiveness:**
- 320px to 3840px+ wide (4K monitors!)
- Landscape mostly
- Mouse + keyboard

**Challenge:** Same Flutter code must work beautifully on ALL screen sizes!

---

## The Smart Breakpoint System

### Define Your Breakpoints

**Think of breakpoints like clothes sizes:**
- **XS** = Phone (< 600px)
- **SM** = Tablet portrait (600-900px)
- **MD** = Tablet landscape / Small laptop (900-1200px)
- **LG** = Desktop (1200-1600px)
- **XL** = Large desktop (> 1600px)

```dart
// lib/core/responsive/breakpoints.dart
class Breakpoints {
  static const double xs = 0;
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}
```

---

## The Responsive Builder (No Packages!)

### Create Your Own Responsive Widget

```dart
// lib/core/responsive/responsive_builder.dart
import 'package:flutter/material.dart';
import 'breakpoints.dart';

enum DeviceSize { xs, sm, md, lg, xl }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceSize) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  static DeviceSize getDeviceSize(double width) {
    if (width < Breakpoints.sm) return DeviceSize.xs;
    if (width < Breakpoints.md) return DeviceSize.sm;
    if (width < Breakpoints.lg) return DeviceSize.md;
    if (width < Breakpoints.xl) return DeviceSize.lg;
    return DeviceSize.xl;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceSize = getDeviceSize(constraints.maxWidth);
        return builder(context, deviceSize);
      },
    );
  }
}
```

### Usage

```dart
ResponsiveBuilder(
  builder: (context, deviceSize) {
    switch (deviceSize) {
      case DeviceSize.xs:
        return MobileLayout();
      case DeviceSize.sm:
        return TabletLayout();
      case DeviceSize.md:
      case DeviceSize.lg:
      case DeviceSize.xl:
        return DesktopLayout();
    }
  },
)
```

---

## Smart Responsive Values

### Responsive Spacing

```dart
// lib/core/responsive/responsive_values.dart
import 'package:flutter/material.dart';
import 'responsive_builder.dart';

class ResponsiveValue<T> {
  final T xs;
  final T? sm;
  final T? md;
  final T? lg;
  final T? xl;

  ResponsiveValue({
    required this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  T getValue(DeviceSize size) {
    switch (size) {
      case DeviceSize.xs:
        return xs;
      case DeviceSize.sm:
        return sm ?? xs;
      case DeviceSize.md:
        return md ?? sm ?? xs;
      case DeviceSize.lg:
        return lg ?? md ?? sm ?? xs;
      case DeviceSize.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
    }
  }
}

// Helper to get responsive values
T responsive<T>(
  BuildContext context, {
  required T xs,
  T? sm,
  T? md,
  T? lg,
  T? xl,
}) {
  final width = MediaQuery.of(context).size.width;
  final size = ResponsiveBuilder.getDeviceSize(width);

  return ResponsiveValue<T>(
    xs: xs,
    sm: sm,
    md: md,
    lg: lg,
    xl: xl,
  ).getValue(size);
}
```

### Usage

```dart
// Responsive padding
Container(
  padding: EdgeInsets.all(
    responsive(
      context,
      xs: 16,    // Mobile: 16px
      sm: 24,    // Tablet: 24px
      lg: 32,    // Desktop: 32px
    ),
  ),
)

// Responsive font size
Text(
  'Title',
  style: TextStyle(
    fontSize: responsive(
      context,
      xs: 24,    // Mobile: 24px
      sm: 32,    // Tablet: 32px
      lg: 48,    // Desktop: 48px
    ),
  ),
)

// Responsive column count
GridView.count(
  crossAxisCount: responsive(
    context,
    xs: 1,     // Mobile: 1 column
    sm: 2,     // Tablet: 2 columns
    md: 3,     // Desktop: 3 columns
    lg: 4,     // Large: 4 columns
  ),
)
```

---

## Responsive Grid System (Like Bootstrap!)

### Create a Grid System from Scratch

```dart
// lib/core/responsive/responsive_grid.dart
import 'package:flutter/material.dart';
import 'responsive_builder.dart';

class ResponsiveGridRow extends StatelessWidget {
  final List<ResponsiveGridCol> children;
  final double spacing;

  const ResponsiveGridRow({
    Key? key,
    required this.children,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceSize = ResponsiveBuilder.getDeviceSize(constraints.maxWidth);

        // Calculate columns for each child
        final List<Widget> items = [];

        for (var child in children) {
          final span = child.getSpan(deviceSize);

          items.add(
            Flexible(
              flex: span,
              child: Padding(
                padding: EdgeInsets.all(spacing / 2),
                child: child.child,
              ),
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );
      },
    );
  }
}

class ResponsiveGridCol {
  final Widget child;
  final int xs;
  final int? sm;
  final int? md;
  final int? lg;
  final int? xl;

  const ResponsiveGridCol({
    required this.child,
    this.xs = 12,  // Full width by default
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  int getSpan(DeviceSize size) {
    switch (size) {
      case DeviceSize.xs:
        return xs;
      case DeviceSize.sm:
        return sm ?? xs;
      case DeviceSize.md:
        return md ?? sm ?? xs;
      case DeviceSize.lg:
        return lg ?? md ?? sm ?? xs;
      case DeviceSize.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
    }
  }
}
```

### Usage (Like Bootstrap Grid!)

```dart
// 12-column grid system
ResponsiveGridRow(
  spacing: 16,
  children: [
    ResponsiveGridCol(
      xs: 12,  // Full width on mobile
      md: 6,   // Half width on tablet
      lg: 4,   // Third width on desktop
      child: Card(child: Text('Column 1')),
    ),
    ResponsiveGridCol(
      xs: 12,
      md: 6,
      lg: 4,
      child: Card(child: Text('Column 2')),
    ),
    ResponsiveGridCol(
      xs: 12,
      md: 12,
      lg: 4,
      child: Card(child: Text('Column 3')),
    ),
  ],
)
```

---

## Adaptive Navigation (Sidebar vs Mobile Menu)

### Smart Navigation Widget

```dart
// lib/widgets/adaptive_navigation.dart
import 'package:flutter/material.dart';
import '../core/responsive/responsive_builder.dart';

class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<NavigationItem> navigationItems;
  final int currentIndex;
  final Function(int) onNavigationChanged;

  const AdaptiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    required this.navigationItems,
    required this.currentIndex,
    required this.onNavigationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        // Desktop: Permanent sidebar
        if (deviceSize.index >= DeviceSize.md.index) {
          return Row(
            children: [
              _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(child: body),
                  ],
                ),
              ),
            ],
          );
        }

        // Mobile/Tablet: Drawer menu
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          drawer: Drawer(
            child: _buildDrawerContent(),
          ),
          body: body,
        );
      },
    );
  }

  // Desktop sidebar
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Color(0xFF2C3E50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationItems[index];
                final isSelected = currentIndex == index;

                return _buildNavItem(item, isSelected, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, bool isSelected, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.white),
        title: Text(item.label, style: TextStyle(color: Colors.white)),
        selected: isSelected,
        onTap: () => onNavigationChanged(index),
      ),
    );
  }

  // Desktop top bar
  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          SizedBox(width: 8),
          IconButton(icon: Icon(Icons.notifications_outlined), onPressed: () {}),
          SizedBox(width: 8),
          CircleAvatar(child: Text('U')),
        ],
      ),
    );
  }

  // Mobile drawer content
  Widget _buildDrawerContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF2C3E50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(radius: 30, child: Text('U')),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        ...navigationItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = currentIndex == index;

          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            selected: isSelected,
            onTap: () => onNavigationChanged(index),
          );
        }).toList(),
      ],
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
```

### Usage

```dart
class DashboardApp extends StatefulWidget {
  @override
  _DashboardAppState createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AnalyticsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Dashboard',
      currentIndex: _currentIndex,
      onNavigationChanged: (index) {
        setState(() => _currentIndex = index);
      },
      navigationItems: [
        NavigationItem(icon: Icons.home, label: 'Home'),
        NavigationItem(icon: Icons.analytics, label: 'Analytics'),
        NavigationItem(icon: Icons.settings, label: 'Settings'),
      ],
      body: _pages[_currentIndex],
    );
  }
}
```

**Result:**
- **Mobile:** Hamburger menu → Drawer
- **Tablet:** Hamburger menu → Drawer
- **Desktop:** Permanent sidebar + top bar

---

## Responsive Container with Max Width

### Smart Container for Web

```dart
// lib/widgets/responsive_container.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // On web, limit max width for readability
    // On mobile, use full width
    final effectiveMaxWidth = kIsWeb && maxWidth != null
        ? maxWidth!
        : double.infinity;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? 32 : 16,
        ),
        child: child,
      ),
    );
  }
}
```

### Usage

```dart
ResponsiveContainer(
  maxWidth: 1200,
  child: Column(
    children: [
      Text('This content never gets wider than 1200px'),
      Text('Makes reading easier on large screens!'),
    ],
  ),
)
```

---

## Complete Example: Responsive Hero Section

```dart
// lib/widgets/hero_section.dart
import 'package:flutter/material.dart';
import '../core/responsive/responsive_builder.dart';
import '../core/responsive/responsive_values.dart';

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        final isMobile = deviceSize == DeviceSize.xs;

        return Container(
          padding: EdgeInsets.all(
            responsive(context, xs: 24, sm: 48, lg: 64),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
            ),
          ),
        );
      },
    );
  }

  // Mobile: Stack vertically
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImage(),
        SizedBox(height: 32),
        _buildContent(context, textAlign: TextAlign.center),
      ],
    );
  }

  // Desktop: Side by side
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _buildContent(context, textAlign: TextAlign.left),
        ),
        SizedBox(width: 64),
        Expanded(
          flex: 4,
          child: _buildImage(),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, {required TextAlign textAlign}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Build Amazing Web Apps',
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive(context, xs: 32, sm: 40, lg: 56),
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Create beautiful, responsive websites with Flutter. No HTML, CSS, or JavaScript required!',
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: responsive(context, xs: 16, sm: 18, lg: 20),
            height: 1.6,
          ),
        ),
        SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: textAlign == TextAlign.center
              ? WrapAlignment.center
              : WrapAlignment.start,
          children: [
            _buildButton(
              'Get Started',
              isPrimary: true,
              onTap: () {},
            ),
            _buildButton(
              'Learn More',
              isPrimary: false,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.web,
        size: 200,
        color: Colors.white,
      ),
    );
  }

  Widget _buildButton(String text, {required bool isPrimary, required VoidCallback onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Color(0xFF667eea) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
```

**Result:**
- **Mobile:** Image on top, text below, centered
- **Desktop:** Text on left, image on right, larger fonts

---

## Responsive Typography System

```dart
// lib/core/responsive/responsive_typography.dart
import 'package:flutter/material.dart';
import 'responsive_values.dart';

class ResponsiveTypography {
  static TextStyle h1(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 32, sm: 40, lg: 56),
      fontWeight: FontWeight.bold,
      height: 1.2,
    );
  }

  static TextStyle h2(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 28, sm: 32, lg: 40),
      fontWeight: FontWeight.bold,
      height: 1.3,
    );
  }

  static TextStyle h3(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 24, sm: 28, lg: 32),
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
  }

  static TextStyle body1(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 16, sm: 17, lg: 18),
      height: 1.6,
    );
  }

  static TextStyle body2(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 14, sm: 15, lg: 16),
      height: 1.5,
    );
  }
}

// Usage
Text('Heading', style: ResponsiveTypography.h1(context))
Text('Body text', style: ResponsiveTypography.body1(context))
```

---

## Testing Responsiveness

### In Chrome DevTools

1. **Run app:**
   ```bash
   flutter run -d chrome
   ```

2. **Open DevTools:** Press `F12`

3. **Toggle device toolbar:** Click phone icon or press `Ctrl+Shift+M`

4. **Test different sizes:**
   - iPhone SE (375px)
   - iPad (768px)
   - Desktop (1920px)
   - 4K (3840px)

5. **Custom size:**
   - Select "Responsive"
   - Drag to resize
   - Watch layout adapt!

---

## Best Practices

### 1. Mobile-First Design

```dart
// Start with mobile layout, add desktop features
ResponsiveBuilder(
  builder: (context, size) {
    // Base: Mobile
    Widget layout = MobileLayout();

    // Add tablet features
    if (size.index >= DeviceSize.sm.index) {
      layout = TabletLayout();
    }

    // Add desktop features
    if (size.index >= DeviceSize.lg.index) {
      layout = DesktopLayout();
    }

    return layout;
  },
)
```

### 2. Never Use Fixed Pixel Widths on Web

```dart
// ❌ BAD: Breaks on different screen sizes
Container(width: 300, height: 200)

// ✅ GOOD: Responsive
Container(
  width: responsive(context, xs: 300, lg: 400),
  height: responsive(context, xs: 200, lg: 300),
)

// ✅ BETTER: Percentage-based
Container(
  width: MediaQuery.of(context).size.width * 0.8,
)
```

### 3. Use ConstrainedBox for Max Widths

```dart
// Prevent content from getting too wide
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 1200),
  child: YourContent(),
)
```

### 4. Test All Breakpoints

**Always test:**
- Mobile (320px, 375px, 414px)
- Tablet (768px, 1024px)
- Desktop (1366px, 1920px)
- Large (2560px, 3840px)

---

## Key Takeaways

1. **No packages needed** = Build responsive system from scratch
2. **Breakpoints** = Define screen size categories
3. **ResponsiveBuilder** = Custom widget for adaptive layouts
4. **responsive()** helper = Get values based on screen size
5. **Grid system** = Bootstrap-like 12-column grid
6. **Adaptive navigation** = Sidebar on desktop, drawer on mobile
7. **Max width** = Limit content width on large screens
8. **Mobile-first** = Start small, enhance for larger screens

---

## What's Next?

Tomorrow: **Building a Complete Landing Page**
- Hero section with animations
- Features section with grid
- Testimonials carousel
- Contact form
- Footer with links
- Fully responsive from scratch!

You've mastered responsive web layouts! Ready to build real websites! 🎨✨
