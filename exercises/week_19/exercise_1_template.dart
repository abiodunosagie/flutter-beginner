/// Week 19, Exercise 1: Dashboard Layout with Sidebar
///
/// BEGINNER LEVEL
///
/// Create a basic dashboard layout:
/// 1. Sidebar with menu items
/// 2. Main content area
/// 3. Top bar with title and user avatar
/// 4. Responsive: drawer on mobile, sidebar on desktop
/// 5. Simple navigation between pages
///
/// Learning objectives:
/// - Build dashboard layouts
/// - Create sidebar navigation
/// - Manage dashboard state

import 'package:flutter/material.dart';

void main() {
  runApp(DashboardApp());
}

class DashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: DashboardHome(),
    );
  }
}

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedIndex = 0;

  // TODO: Create list of menu items with icons and labels

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      // TODO: Add drawer for mobile
      // TODO: Build layout based on screen size
      // Desktop: Row with sidebar + content
      // Mobile: Regular scaffold with drawer
      body: Container(),
    );
  }

  // TODO: Create _buildSidebar method
  // Should include logo, menu items, and user info

  // TODO: Create _buildTopBar method
  // Should include page title and action buttons

  // TODO: Create _buildContent method
  // Show different content based on selected index
}
