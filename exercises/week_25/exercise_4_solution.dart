/// Exercise 4 Solution: Custom Painter - Drawing Animations

import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedDrawing extends StatefulWidget {
  @override
  State<AnimatedDrawing> createState() => _AnimatedDrawingState();
}

class _AnimatedDrawingState extends State<AnimatedDrawing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 3), vsync: this)..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(painter: WavePainter(animationValue: _controller.value), size: Size(300, 300));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue..strokeWidth = 3..style = PaintingStyle.stroke;
    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 4;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + sin((x / waveLength + animationValue * 2 * pi) * 2 * pi) * waveHeight;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    final circlePaint = Paint()..color = Colors.red..style = PaintingStyle.fill;
    final circleX = size.width / 2 + cos(animationValue * 2 * pi) * (size.width / 3);
    final circleY = size.height / 2 + sin(animationValue * 2 * pi) * (size.height / 3);
    canvas.drawCircle(Offset(circleX, circleY), 10, circlePaint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => animationValue != oldDelegate.animationValue;
}

void main() => runApp(MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Custom Painter')), body: Center(child: AnimatedDrawing()))));
