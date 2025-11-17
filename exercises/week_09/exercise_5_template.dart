// Exercise 5: Advanced Layout - Dashboard with Mixed Layouts (Advanced)
// Create a dashboard combining Stack, GridView, Wrap, and custom widgets

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // TODO: Create SliverAppBar with:
          // - expandedHeight: 200
          // - flexibleSpace with gradient background
          // - title
          // - floating and pinned properties

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO: Add section title "Statistics"

                  // TODO: Create GridView with 4 stat cards showing:
                  // - Users count
                  // - Revenue
                  // - Orders
                  // - Products

                  // TODO: Add section title "Quick Actions"

                  // TODO: Create Wrap widget with action chips:
                  // - New Order
                  // - Add Product
                  // - View Reports
                  // - Settings
                  // - Support

                  // TODO: Add section title "Recent Activity"

                  // TODO: Create list of recent activity items (3-5 items)
                  // Use ListTile or custom widget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Create _buildStatCard method
  // Parameters: String title, String value, IconData icon, Color color
  // Returns a Card with Stack containing gradient and stats

  // TODO: Create _buildActionChip method
  // Parameters: String label, IconData icon
  // Returns a styled Chip widget
}
