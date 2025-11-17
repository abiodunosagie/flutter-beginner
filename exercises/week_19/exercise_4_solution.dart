/// Week 19, Exercise 4: Dashboard with Custom Chart
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(ChartApp());

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Charts',
      debugShowCheckedModeBanner: false,
      home: ChartDashboard(),
    );
  }
}

class ChartDashboard extends StatelessWidget {
  final List<ChartData> data = [
    ChartData('Mon', 20),
    ChartData('Tue', 45),
    ChartData('Wed', 30),
    ChartData('Thu', 60),
    ChartData('Fri', 50),
    ChartData('Sat', 75),
    ChartData('Sun', 65),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
        backgroundColor: Color(0xFF2C3E50),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Performance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: LineChart(data: data),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChart extends StatelessWidget {
  final List<ChartData> data;

  const LineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(data),
      child: Container(),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<ChartData> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Calculate max value
    final maxValue = data.map((d) => d.value).reduce(math.max);
    final padding = 40.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = padding + (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );
    }

    // Draw line chart
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = padding + (chartWidth / (data.length - 1)) * i;
      final y = padding + chartHeight - (data[i].value / maxValue) * chartHeight;
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < data.length; i++) {
      final x = padding + (chartWidth / (data.length - 1)) * i;

      // X-axis labels
      textPainter.text = TextSpan(
        text: data[i].label,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - padding + 10),
      );
    }

    // Y-axis labels
    for (int i = 0; i <= 4; i++) {
      final value = (maxValue / 4) * (4 - i);
      final y = padding + (chartHeight / 4) * i;

      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(5, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
