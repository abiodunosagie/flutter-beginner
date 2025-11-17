/// Week 17, Exercise 4: Adaptive Navigation (Sidebar vs Drawer)
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Create an adaptive scaffold that shows:
/// - Mobile/Tablet: AppBar with Drawer menu
/// - Desktop: Permanent sidebar with top bar
///
/// Requirements:
/// 1. Create NavigationItem class for menu items
/// 2. Build AdaptiveScaffold widget
/// 3. Desktop layout: Row with sidebar + content area
/// 4. Mobile layout: Scaffold with Drawer
/// 5. Handle navigation between different pages
/// 6. Show active/selected state
///
/// Learning objectives:
/// - Build platform-adaptive navigation
/// - Manage navigation state
/// - Create professional layouts

import 'package:flutter/material.dart';

void main() {
  runApp(DashboardApp());
}

// TODO: Copy ResponsiveBuilder from previous exercises

// TODO: Create NavigationItem class
// Properties: icon, label

// TODO: Create AdaptiveScaffold widget
// Parameters: title, body, navigationItems, currentIndex, onNavigationChanged
// Use ResponsiveBuilder to switch between mobile and desktop layouts

class DashboardApp extends StatefulWidget {
  @override
  _DashboardAppState createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  int _currentIndex = 0;

  // TODO: Create list of pages (Home, Analytics, Settings)

  // TODO: Create list of navigation items

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Navigation',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        // TODO: Use AdaptiveScaffold here
        body: Container(),
      ),
    );
  }
}

// TODO: Create placeholder pages (HomePage, AnalyticsPage, SettingsPage)
