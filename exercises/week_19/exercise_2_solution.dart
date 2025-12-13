/// Week 19, Exercise 2: Dashboard with Statistics Cards
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() => runApp(StatsApp());

class StatCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double percentageChange;

  StatCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.percentageChange,
  });
}

class StatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Stats',
      debugShowCheckedModeBanner: false,
      home: StatsDashboard(),
    );
  }
}

class StatsDashboard extends StatelessWidget {
  final List<StatCardData> stats = [
    StatCardData(
      title: 'Total Revenue',
      value: '\$45,231',
      icon: Icons.attach_money,
      color: Colors.green,
      percentageChange: 12.5,
    ),
    StatCardData(
      title: 'Active Users',
      value: '2,543',
      icon: Icons.people,
      color: Colors.blue,
      percentageChange: 8.2,
    ),
    StatCardData(
      title: 'Total Orders',
      value: '1,423',
      icon: Icons.shopping_cart,
      color: Colors.orange,
      percentageChange: -3.4,
    ),
    StatCardData(
      title: 'Products',
      value: '234',
      icon: Icons.inventory,
      color: Colors.purple,
      percentageChange: 5.1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xFF2C3E50),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Here\'s what\'s happening with your business today.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                int columns = 1;
                if (constraints.maxWidth >= 1200) {
                  columns = 4;
                } else if (constraints.maxWidth >= 900) {
                  columns = 3;
                } else if (constraints.maxWidth >= 600) {
                  columns = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) => StatCard(data: stats[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatefulWidget {
  final StatCardData data;

  const StatCard({Key? key, required this.data}) : super(key: key);

  @override
  _StatCardState createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.data.percentageChange >= 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.data.color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 15 : 8,
              offset: Offset(0, _isHovered ? 4 : 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.data.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(widget.data.icon, color: widget.data.color, size: 24),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${widget.data.percentageChange.abs()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              widget.data.value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.data.color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.data.title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
