/// Exercise 1 Solution: Implicit Animations - Animated UI Card

import 'package:flutter/material.dart';

class AnimatedCard extends StatefulWidget {
  const AnimatedCard({Key? key}) : super(key: key);

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isExpanded ? 300 : 150,
        height: _isExpanded ? 400 : 150,
        decoration: BoxDecoration(
          color: _isExpanded ? Colors.blue : Colors.purple,
          borderRadius: BorderRadius.circular(_isExpanded ? 20 : 75),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: _isExpanded ? 20 : 10, spreadRadius: _isExpanded ? 5 : 2)],
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _isExpanded ? 1.0 : 0.7,
            child: Icon(_isExpanded ? Icons.check_circle : Icons.add, size: _isExpanded ? 80 : 48, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Animated Card')), body: Center(child: AnimatedCard()))));
