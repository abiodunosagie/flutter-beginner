/// Week 17, Exercise 5: Complete Responsive Hero Section
///
/// ADVANCED LEVEL
///
/// Create a professional hero section with:
/// 1. Responsive layout (mobile: stacked, desktop: side-by-side)
/// 2. Animated gradient background
/// 3. Hover effects on buttons (web only)
/// 4. Responsive typography
/// 5. Platform-adaptive spacing
/// 6. Mouse cursor changes on hover
///
/// Requirements:
/// - Mobile: Image on top, content below, centered
/// - Desktop: Content on left (60%), image on right (40%)
/// - Add MouseRegion for hover effects
/// - Use AnimatedContainer for smooth transitions
/// - Implement responsive font sizes
///
/// Learning objectives:
/// - Build production-ready hero sections
/// - Master hover effects for web
/// - Create advanced responsive layouts

import 'package:flutter/material.dart';

void main() {
  runApp(HeroSectionApp());
}

// TODO: Copy ResponsiveBuilder and responsive helper from previous exercises

class HeroSectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Section',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: HeroSection(),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Add responsive builder
      // Mobile: Column layout (image, then content)
      // Desktop: Row layout (content, then image)

      // TODO: Add gradient background

      // TODO: Add max-width constraint for readability

      child: Container(),
    );
  }

  // TODO: Create _buildMobileLayout method

  // TODO: Create _buildDesktopLayout method

  // TODO: Create _buildContent method with responsive typography

  // TODO: Create _buildImage method with placeholder

  // TODO: Create HoverButton widget with MouseRegion
  // Should lift up on hover (-4px translateY)
  // Should change cursor to pointer
}

// TODO: Create HoverButton as separate StatefulWidget
// Track hover state
// Use AnimatedContainer for smooth transitions
// Use MouseRegion for hover detection
