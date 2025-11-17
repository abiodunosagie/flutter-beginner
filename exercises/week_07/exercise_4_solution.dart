// Exercise 4: Social Media Profile (Intermediate-Advanced)
// Create a social media profile page with stats and action buttons

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.blue],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.purple),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Jane Smith',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('Posts', '120'),
                  _buildStatColumn('Followers', '1.2K'),
                  _buildStatColumn('Following', '850'),
                ],
              ),
            ),

            Divider(),

            // Bio
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Flutter developer | Tech enthusiast | Coffee lover\n'
                'Building beautiful apps with Flutter 💙',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Follow'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Message'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Divider(),

            // Recent posts
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recent Posts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.purple),
              title: Text('My latest Flutter project'),
              subtitle: Text('2 hours ago'),
              trailing: Icon(Icons.favorite_border),
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.purple),
              title: Text('Learning new design patterns'),
              subtitle: Text('1 day ago'),
              trailing: Icon(Icons.favorite_border),
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.purple),
              title: Text('Coffee and code'),
              subtitle: Text('3 days ago'),
              trailing: Icon(Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
