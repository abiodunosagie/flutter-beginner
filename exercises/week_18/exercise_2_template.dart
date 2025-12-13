/// Week 18, Exercise 2: Features Section with Responsive Grid
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Create a features section that showcases product features:
/// 1. Section title and description
/// 2. Grid of feature cards (icon, title, description)
/// 3. Responsive grid: 1 column (mobile), 2 columns (tablet), 3 columns (desktop)
/// 4. Hover effect on cards (optional)
/// 5. Clean, professional styling
///
/// Learning objectives:
/// - Build feature showcases
/// - Create responsive grids
/// - Style feature cards

import 'package:flutter/material.dart';

void main() {
  runApp(FeaturesApp());
}

class FeaturesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Features Section',
      home: Scaffold(
        body: SingleChildScrollView(
          child: FeaturesSection(),
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  // TODO: Create list of features
  // Each feature should have: icon, title, description
  // Example: Speed (Icons.speed), Easy to Use (Icons.touch_app), etc.

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // TODO: Add section title
              // "Powerful Features"

              SizedBox(height: 16),

              // TODO: Add section description
              // "Everything you need to build amazing apps"

              SizedBox(height: 48),

              // TODO: Create responsive grid of feature cards
              // Use GridView.builder or wrap
              // Mobile: 1 column, Tablet: 2 columns, Desktop: 3 columns
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Create _buildFeatureCard method
  // Parameters: icon, title, description, color
  // Should return a Card widget with nice styling
}
