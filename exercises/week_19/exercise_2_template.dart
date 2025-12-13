/// Week 19, Exercise 2: Dashboard with Statistics Cards
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Create a dashboard overview page with:
/// 1. Grid of stat cards showing key metrics
/// 2. Each card: icon, title, value, percentage change
/// 3. Color-coded based on metric type
/// 4. Responsive grid layout
/// 5. Hover effects on cards
///
/// Learning objectives:
/// - Display dashboard metrics
/// - Create stat cards
/// - Build responsive grids

import 'package:flutter/material.dart';

void main() {
  runApp(StatsApp());
}

// TODO: Create StatCard data class
// Properties: title, value, icon, color, percentageChange

class StatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Stats',
      home: StatsDashboard(),
    );
  }
}

class StatsDashboard extends StatelessWidget {
  // TODO: Create list of stat cards
  // Example: Revenue, Users, Orders, Products

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Add welcome message

            SizedBox(height: 24),

            // TODO: Create responsive grid of stat cards
            // Mobile: 1 column, Tablet: 2 columns, Desktop: 4 columns
          ],
        ),
      ),
    );
  }

  // TODO: Create _buildStatCard widget
  // Should include icon, title, value, and trend indicator
}
