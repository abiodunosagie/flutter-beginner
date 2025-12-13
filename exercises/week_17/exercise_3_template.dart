/// Week 17, Exercise 3: Responsive Grid System (Like Bootstrap)
///
/// INTERMEDIATE LEVEL
///
/// Create a 12-column responsive grid system:
/// 1. Create ResponsiveGridRow widget
/// 2. Create ResponsiveGridCol widget with span properties (xs, sm, md, lg, xl)
/// 3. Build a demo page with responsive card grid
/// 4. Cards should be:
///    - 1 column on mobile (xs: 12)
///    - 2 columns on tablet (sm: 6)
///    - 3 columns on desktop (md: 4)
///    - 4 columns on large desktop (lg: 3)
///
/// Learning objectives:
/// - Build flexible grid systems
/// - Understand column spans
/// - Create responsive card layouts

import 'package:flutter/material.dart';

void main() {
  runApp(GridSystemApp());
}

// TODO: Copy your Breakpoints and ResponsiveBuilder from Exercise 2

// TODO: Create ResponsiveGridRow widget
// Should accept List<ResponsiveGridCol> children
// Use LayoutBuilder to determine current device size
// Use Row with Flexible widgets based on column spans

// TODO: Create ResponsiveGridCol widget
// Properties: xs, sm, md, lg, xl (column spans out of 12)
// Default xs = 12 (full width on mobile)
// Method to get appropriate span based on device size

class GridSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Grid',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: GridDemoPage(),
    );
  }
}

class GridDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Grid System'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: Add title

              SizedBox(height: 8),

              // TODO: Add description

              SizedBox(height: 24),

              // TODO: Create ResponsiveGridRow with 6 cards
              // Each card should have:
              // xs: 12 (full width mobile)
              // sm: 6 (half width tablet)
              // md: 4 (third width desktop)
              // lg: 3 (quarter width large)

              SizedBox(height: 32),

              // TODO: Create another grid demonstrating different layouts
              // Try mixing different column spans
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Create helper method to build a demo card
  // Should accept title, icon, and color
}
