/// Week 19, Exercise 1: Dashboard Layout with Sidebar
///
/// BEGINNER LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() => runApp(DashboardApp());

class DashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: DashboardHome(),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String label;

  MenuItem(this.icon, this.label);
}

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedIndex = 0;

  final List<MenuItem> menuItems = [
    MenuItem(Icons.dashboard, 'Dashboard'),
    MenuItem(Icons.analytics, 'Analytics'),
    MenuItem(Icons.people, 'Users'),
    MenuItem(Icons.settings, 'Settings'),
  ];

  final List<String> pageNames = ['Dashboard', 'Analytics', 'Users', 'Settings'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            _buildSidebar(),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageNames[_selectedIndex]),
        backgroundColor: Color(0xFF2C3E50),
      ),
      drawer: Drawer(child: _buildDrawerContent()),
      body: _buildContent(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Color(0xFF2C3E50),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.dashboard, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white24),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = _selectedIndex == index;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.1) : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(item.icon, color: Colors.white),
                    title: Text(item.label, style: TextStyle(color: Colors.white)),
                    onTap: () => setState(() => _selectedIndex = index),
                  ),
                );
              },
            ),
          ),
          Divider(color: Colors.white24),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Admin User', style: TextStyle(color: Colors.white)),
                    Text('admin@example.com',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                child: Icon(Icons.person, size: 35, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text('Admin User', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        ...menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            selected: _selectedIndex == index,
            onTap: () {
              setState(() => _selectedIndex = index);
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }

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
        children: [
          Text(
            pageNames[_selectedIndex],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_outlined), onPressed: () {}),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Color(0xFF2C3E50),
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItems[_selectedIndex].icon, size: 80, color: Colors.grey.shade300),
            SizedBox(height: 16),
            Text(
              '${pageNames[_selectedIndex]} Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Content for ${pageNames[_selectedIndex].toLowerCase()} will go here',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
