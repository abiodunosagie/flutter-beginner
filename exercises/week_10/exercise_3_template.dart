// Exercise 3: Responsive Grid Layout (Intermediate)
// Create a grid that adapts based on screen width

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Grid',
      home: ResponsiveGridScreen(),
    );
  }
}

class ResponsiveGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Grid'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // TODO: Determine number of columns based on width:
            // - width < 600: 2 columns (mobile)
            // - width >= 600 && width < 900: 3 columns (tablet)
            // - width >= 900: 4 columns (desktop)

            int columns = 2; // Replace with logic

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                // TODO: Return a Card with item number and icon
              },
            );
          },
        ),
      ),
    );
  }
}
