/// Week 17, Exercise 4: Adaptive Navigation (Sidebar vs Drawer)
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(DashboardApp());
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

// Navigation item model
class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}

// Adaptive Scaffold
class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<NavigationItem> navigationItems;
  final int currentIndex;
  final Function(int) onNavigationChanged;

  const AdaptiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    required this.navigationItems,
    required this.currentIndex,
    required this.onNavigationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        // Desktop: Permanent sidebar
        if (deviceSize.index >= DeviceSize.md.index) {
          return Row(
            children: [
              _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(child: body),
                  ],
                ),
              ),
            ],
          );
        }

        // Mobile/Tablet: Drawer menu
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Color(0xFF2C3E50),
          ),
          drawer: Drawer(
            child: _buildDrawerContent(),
          ),
          body: body,
        );
      },
    );
  }

  // Desktop sidebar
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Color(0xFF2C3E50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.dashboard, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white24, height: 1),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: navigationItems.length,
              itemBuilder: (context, index) {
                final item = navigationItems[index];
                final isSelected = currentIndex == index;
                return _buildNavItem(item, isSelected, index);
              },
            ),
          ),
          Divider(color: Colors.white24, height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'admin@example.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, bool isSelected, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.white),
        title: Text(
          item.label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onTap: () => onNavigationChanged(index),
      ),
    );
  }

  // Desktop top bar
  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Color(0xFF2C3E50),
            child: Text('JD', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Mobile drawer content
  Widget _buildDrawerContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF2C3E50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 35),
              ),
              SizedBox(height: 12),
              Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'admin@example.com',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        ...navigationItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = currentIndex == index;

          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            selected: isSelected,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => onNavigationChanged(index),
          );
        }).toList(),
      ],
    );
  }
}

// Main app
class DashboardApp extends StatefulWidget {
  @override
  _DashboardAppState createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AnalyticsPage(),
    SettingsPage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.home, label: 'Home'),
    NavigationItem(icon: Icons.analytics, label: 'Analytics'),
    NavigationItem(icon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Navigation',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: AdaptiveScaffold(
        title: 'Dashboard',
        currentIndex: _currentIndex,
        onNavigationChanged: (index) {
          setState(() => _currentIndex = index);
        },
        navigationItems: _navigationItems,
        body: _pages[_currentIndex],
      ),
    );
  }
}

// Placeholder pages
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Welcome to your dashboard!',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildStatCard('Total Users', '1,234', Icons.people, Colors.blue),
                _buildStatCard('Revenue', '\$12.5K', Icons.attach_money, Colors.green),
                _buildStatCard('Orders', '423', Icons.shopping_cart, Colors.orange),
                _buildStatCard('Products', '156', Icons.inventory, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'View your performance metrics',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Expanded(
            child: Center(
              child: Icon(Icons.analytics, size: 120, color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Configure your preferences',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  trailing: Switch(value: true, onChanged: (_) {}),
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Dark Mode'),
                  trailing: Switch(value: false, onChanged: (_) {}),
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
