/// Week 17, Exercise 2: Responsive Builder from Scratch
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(ResponsiveApp());
}

// Breakpoint constants
class Breakpoints {
  static const double xs = 0;
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}

// Device size enum
enum DeviceSize { xs, sm, md, lg, xl }

// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceSize deviceSize) builder;

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
  // Helper to get device size info
  String getDeviceSizeLabel(DeviceSize size) {
    switch (size) {
      case DeviceSize.xs:
        return 'Extra Small (Mobile)';
      case DeviceSize.sm:
        return 'Small (Large Mobile / Tablet Portrait)';
      case DeviceSize.md:
        return 'Medium (Tablet Landscape)';
      case DeviceSize.lg:
        return 'Large (Desktop)';
      case DeviceSize.xl:
        return 'Extra Large (Large Desktop)';
    }
  }

  IconData getDeviceIcon(DeviceSize size) {
    switch (size) {
      case DeviceSize.xs:
        return Icons.phone_android;
      case DeviceSize.sm:
        return Icons.tablet_android;
      case DeviceSize.md:
        return Icons.tablet_mac;
      case DeviceSize.lg:
        return Icons.laptop;
      case DeviceSize.xl:
        return Icons.desktop_windows;
    }
  }

  Color getDeviceColor(DeviceSize size) {
    switch (size) {
      case DeviceSize.xs:
        return Colors.red;
      case DeviceSize.sm:
        return Colors.orange;
      case DeviceSize.md:
        return Colors.yellow.shade700;
      case DeviceSize.lg:
        return Colors.green;
      case DeviceSize.xl:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Builder Demo'),
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceSize) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Show current width
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Screen Width',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${constraints.maxWidth.toInt()}px',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: getDeviceColor(deviceSize),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 32),

                    // Device size indicator
                    Icon(
                      getDeviceIcon(deviceSize),
                      size: 120,
                      color: getDeviceColor(deviceSize),
                    ),

                    SizedBox(height: 24),

                    // Device label
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: getDeviceColor(deviceSize).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: getDeviceColor(deviceSize),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        getDeviceSizeLabel(deviceSize),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: getDeviceColor(deviceSize),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Layout demonstration
                    Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Layout',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildLayoutInfo(deviceSize),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Breakpoint guide
                    Text(
                      'Resize your browser to see different layouts!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLayoutInfo(DeviceSize size) {
    String description;
    List<String> features;

    switch (size) {
      case DeviceSize.xs:
        description = 'Mobile-optimized layout';
        features = [
          'Single column layout',
          'Larger touch targets',
          'Bottom navigation',
          'Hamburger menu',
        ];
        break;
      case DeviceSize.sm:
        description = 'Tablet-optimized layout';
        features = [
          'Two column layout',
          'Expanded cards',
          'Side drawer menu',
          'Medium spacing',
        ];
        break;
      case DeviceSize.md:
      case DeviceSize.lg:
      case DeviceSize.xl:
        description = 'Desktop-optimized layout';
        features = [
          'Multi-column grid',
          'Permanent sidebar',
          'Hover effects',
          'Keyboard shortcuts',
        ];
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 12),
        ...features.map((feature) => Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 20, color: Colors.green),
              SizedBox(width: 8),
              Text(feature),
            ],
          ),
        )),
      ],
    );
  }
}
