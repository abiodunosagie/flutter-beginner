/// Exercise 5 Solution: Staggered Animations - List Item Reveal

import 'package:flutter/material.dart';

class StaggeredList extends StatefulWidget {
  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;
  final int itemCount = 10;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);

    _itemAnimations = List.generate(itemCount, (index) {
      final start = index * 0.1;
      final end = start + 0.3;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Interval(start, end > 1.0 ? 1.0 : end, curve: Curves.easeOut)),
      );
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _itemAnimations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _itemAnimations[index].value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - _itemAnimations[index].value)),
                child: Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Item ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Staggered animation demo'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Staggered List')), body: StaggeredList())));
