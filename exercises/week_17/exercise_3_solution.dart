/// Week 17, Exercise 3: Responsive Grid System (Like Bootstrap)
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(GridSystemApp());
}

// Breakpoints
class Breakpoints {
  static const double xs = 0;
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}

// Device size enum
enum DeviceSize { xs, sm, md, lg, xl }

// Responsive builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceSize deviceSize) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

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

// Responsive Grid Column
class ResponsiveGridCol {
  final Widget child;
  final int xs;
  final int? sm;
  final int? md;
  final int? lg;
  final int? xl;

  const ResponsiveGridCol({
    required this.child,
    this.xs = 12, // Full width by default
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

// Responsive Grid Row
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

        // Group children into rows based on their spans
        List<Widget> rows = [];
        List<ResponsiveGridCol> currentRow = [];
        int currentRowSpan = 0;

        for (var child in children) {
          final span = child.getSpan(deviceSize);

          // If adding this child would exceed 12 columns, start new row
          if (currentRowSpan + span > 12 && currentRow.isNotEmpty) {
            rows.add(_buildRow(currentRow, deviceSize));
            currentRow = [child];
            currentRowSpan = span;
          } else {
            currentRow.add(child);
            currentRowSpan += span;
          }
        }

        // Add remaining children
        if (currentRow.isNotEmpty) {
          rows.add(_buildRow(currentRow, deviceSize));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }

  Widget _buildRow(List<ResponsiveGridCol> cols, DeviceSize deviceSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cols.map((col) {
          final span = col.getSpan(deviceSize);
          return Flexible(
            flex: span,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: col.child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

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
              Text(
                'Responsive Grid System',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Resize your browser to see the grid adapt! Like Bootstrap\'s 12-column system.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 24),

              // Equal width cards that adapt
              ResponsiveGridRow(
                spacing: 16,
                children: [
                  ResponsiveGridCol(
                    xs: 12, // Full width on mobile
                    sm: 6,  // Half width on tablet
                    md: 4,  // Third width on desktop
                    lg: 3,  // Quarter width on large
                    child: _buildCard(
                      'Analytics',
                      Icons.analytics,
                      Colors.blue,
                      '2,543',
                      'Total Views',
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    sm: 6,
                    md: 4,
                    lg: 3,
                    child: _buildCard(
                      'Users',
                      Icons.people,
                      Colors.green,
                      '1,234',
                      'Active Users',
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    sm: 6,
                    md: 4,
                    lg: 3,
                    child: _buildCard(
                      'Revenue',
                      Icons.attach_money,
                      Colors.orange,
                      '\$12.5K',
                      'This Month',
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    sm: 6,
                    md: 4,
                    lg: 3,
                    child: _buildCard(
                      'Orders',
                      Icons.shopping_cart,
                      Colors.purple,
                      '423',
                      'Total Orders',
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    sm: 6,
                    md: 4,
                    lg: 3,
                    child: _buildCard(
                      'Products',
                      Icons.inventory,
                      Colors.red,
                      '156',
                      'In Stock',
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    sm: 6,
                    md: 4,
                    lg: 3,
                    child: _buildCard(
                      'Reviews',
                      Icons.star,
                      Colors.amber,
                      '4.8',
                      'Average Rating',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              Text(
                'Mixed Layout Example',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),

              // Different layout - featured card + smaller cards
              ResponsiveGridRow(
                spacing: 16,
                children: [
                  // Featured card - larger on desktop
                  ResponsiveGridCol(
                    xs: 12,
                    md: 8,
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Featured Section',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This takes 8 columns on desktop, full width on mobile',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Sidebar card
                  ResponsiveGridCol(
                    xs: 12,
                    md: 4,
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Sidebar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '4 columns on desktop',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    IconData icon,
    Color color,
    String value,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade400),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
