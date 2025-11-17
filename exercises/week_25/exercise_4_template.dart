/// Exercise 4: Custom Painter - Drawing Animations
/// Create custom animated drawings using CustomPainter

import 'package:flutter/material.dart';

// TODO: Create AnimatedCirclePainter
// TODO: Implement wave animation
// TODO: Add progress indicator animation

class AnimatedDrawing extends StatefulWidget {
  @override
  State<AnimatedDrawing> createState() => _AnimatedDrawingState();
}

class _AnimatedDrawingState extends State<AnimatedDrawing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize animation
  }

  @override
  Widget build(BuildContext context) => Container();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: AnimatedDrawing()))));
