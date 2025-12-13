// Exercise 4: Adaptive Layout - Mobile vs Desktop (Intermediate-Advanced)
// Create different layouts for mobile and desktop screens

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Layout',
      home: AdaptiveLayoutScreen(),
    );
  }
}

class AdaptiveLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('Adaptive Layout'),
        backgroundColor: Colors.indigo,
      ),
      drawer: !isDesktop ? Drawer(child: _buildSidebarContent()) : null,
      body: Row(
        children: [
          // Sidebar for desktop
          if (isDesktop)
            Container(
              width: 250,
              color: Colors.indigo[50],
              child: _buildSidebarContent(),
            ),

          // Main content
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return _buildMainContent(constraints.maxWidth);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.indigo),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.dashboard, size: 48, color: Colors.white),
              SizedBox(height: 8),
              Text(
                'Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.analytics),
          title: Text('Analytics'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Users'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMainContent(double maxWidth) {
    final isMobile = maxWidth < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Dashboard Overview',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Screen width: ${maxWidth.toInt()}px (${isMobile ? "Mobile" : "Desktop"} layout)',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),

          // Stats cards
          isMobile
              ? Column(
                  children: [
                    _buildStatCard('Users', '1,234', Icons.people),
                    SizedBox(height: 16),
                    _buildStatCard('Revenue', '\$12,345', Icons.attach_money),
                    SizedBox(height: 16),
                    _buildStatCard('Orders', '856', Icons.shopping_cart),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildStatCard('Users', '1,234', Icons.people)),
                    SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Revenue', '\$12,345', Icons.attach_money)),
                    SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Orders', '856', Icons.shopping_cart)),
                  ],
                ),

          SizedBox(height: 24),

          // Recent activity
          Text(
            'Recent Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...List.generate(5, (index) {
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                  backgroundColor: Colors.indigo,
                ),
                title: Text('Activity ${index + 1}'),
                subtitle: Text('${index + 1} hours ago'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.indigo),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
