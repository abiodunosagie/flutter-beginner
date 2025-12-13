/// Week 17, Exercise 2: Responsive Builder from Scratch
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Create a responsive system without packages:
/// 1. Define breakpoint constants (xs, sm, md, lg, xl)
/// 2. Create DeviceSize enum
/// 3. Build ResponsiveBuilder widget using LayoutBuilder
/// 4. Create a demo page that shows different layouts per device size
/// 5. Display current screen width and device size
///
/// Learning objectives:
/// - Understand breakpoint systems
/// - Use LayoutBuilder for responsive design
/// - Create reusable responsive widgets

import 'package:flutter/material.dart';

void main() {
  runApp(ResponsiveApp());
}

// TODO: Create Breakpoints class with constants
// xs: 0, sm: 600, md: 900, lg: 1200, xl: 1600

// TODO: Create DeviceSize enum
// Values: xs, sm, md, lg, xl

// TODO: Create ResponsiveBuilder widget
// Should take a builder function that receives BuildContext and DeviceSize
// Use LayoutBuilder to get constraints.maxWidth
// Return builder with appropriate DeviceSize

class ResponsiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Builder',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: ResponsiveDemoPage(),
    );
  }
}

class ResponsiveDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Builder Demo'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Use LayoutBuilder to show current width

              SizedBox(height: 24),

              // TODO: Use ResponsiveBuilder to show different layouts
              // xs: Show mobile icon and "Mobile Layout"
              // sm: Show tablet icon and "Tablet Layout"
              // md/lg/xl: Show desktop icon and "Desktop Layout"

              SizedBox(height: 32),

              // TODO: Show color-coded device size indicator
              // Different color for each device size
            ],
          ),
        ),
      ),
    );
  }
}
