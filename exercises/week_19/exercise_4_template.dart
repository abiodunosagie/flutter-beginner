/// Week 19, Exercise 4: Dashboard with Custom Chart
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Create a dashboard with a custom line chart (no packages):
/// 1. Draw a simple line chart using CustomPainter
/// 2. Show data points and labels
/// 3. Grid lines for readability
/// 4. Responsive chart that scales with container
/// 5. Display alongside stat cards
///
/// Learning objectives:
/// - Use CustomPainter for charts
/// - Draw graphics in Flutter
/// - Create data visualizations

import 'package:flutter/material.dart';

void main() {
  runApp(ChartApp());
}

// TODO: Create LineChart widget using CustomPainter
// TODO: Create ChartData class for data points

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Charts',
      home: ChartDashboard(),
    );
  }
}

class ChartDashboard extends StatelessWidget {
  // TODO: Create sample data for chart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // TODO: Add title
            // TODO: Create chart container
            // TODO: Build custom line chart
          ],
        ),
      ),
    );
  }
}

// TODO: Create LineChartPainter extends CustomPainter
// Override paint() and shouldRepaint()
