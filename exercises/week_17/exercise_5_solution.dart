/// Week 17, Exercise 5: Complete Responsive Hero Section
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(HeroSectionApp());
}

// Breakpoints and ResponsiveBuilder
class Breakpoints {
  static const double xs = 0;
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}

enum DeviceSize { xs, sm, md, lg, xl }

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

// Responsive value helper
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

// Main app
class HeroSectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Section',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HeroSection(),
      ),
    );
  }
}

// Hero Section
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        final isMobile = deviceSize == DeviceSize.xs;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.all(
                  responsive(context, xs: 24, sm: 48, lg: 64),
                ),
                child: isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
              ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(context),
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
          child: _buildImage(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, {required TextAlign textAlign}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated tag
        AnimatedContainer(
          duration: Duration(milliseconds: 600),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Text(
            '🚀 New: Flutter Web Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(height: 24),

        // Main heading
        Text(
          'Build Amazing\nWeb Apps',
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive(context, xs: 32, sm: 40, md: 48, lg: 56),
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        SizedBox(height: 16),

        // Subheading
        Text(
          'Create beautiful, responsive websites with Flutter. Write once, run everywhere. No HTML, CSS, or JavaScript required!',
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: responsive(context, xs: 16, sm: 18, lg: 20),
            height: 1.6,
          ),
        ),

        SizedBox(height: 32),

        // Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: textAlign == TextAlign.center
              ? WrapAlignment.center
              : WrapAlignment.start,
          children: [
            HoverButton(
              text: 'Get Started',
              isPrimary: true,
              onTap: () => print('Get Started clicked'),
            ),
            HoverButton(
              text: 'Learn More',
              isPrimary: false,
              onTap: () => print('Learn More clicked'),
            ),
          ],
        ),

        SizedBox(height: 32),

        // Features
        Wrap(
          spacing: 24,
          runSpacing: 16,
          alignment: textAlign == TextAlign.center
              ? WrapAlignment.center
              : WrapAlignment.start,
          children: [
            _buildFeature(Icons.speed, 'Fast Performance'),
            _buildFeature(Icons.devices, 'Multi-Platform'),
            _buildFeature(Icons.palette, 'Beautiful UI'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: responsive(context, xs: 300, lg: 400),
        maxHeight: responsive(context, xs: 300, lg: 400),
      ),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.web,
          size: responsive(context, xs: 150, lg: 200),
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

// Hover Button Widget
class HoverButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onTap;

  const HoverButton({
    Key? key,
    required this.text,
    required this.isPrimary,
    required this.onTap,
  }) : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            0,
            _isHovered ? -4 : 0,
            0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? Colors.white
                : Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isPrimary
                  ? Color(0xFF667eea)
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
