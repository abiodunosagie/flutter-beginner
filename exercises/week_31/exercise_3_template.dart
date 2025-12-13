/// Week 31, Exercise 3: Use DevTools to Find Performance Issues
///
/// INTERMEDIATE LEVEL
///
/// Profile and optimize app performance:
/// 1. Run app in profile mode
/// 2. Use Flutter DevTools
/// 3. Find slow widgets
/// 4. Optimize based on findings
///
/// Learning objectives:
/// - Flutter DevTools
/// - Performance profiling
/// - Identifying bottlenecks

import 'package:flutter/material.dart';

void main() {
  runApp(PerformanceTestApp());
}

// TODO: Create app with performance issues to profile
class PerformanceTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Test',
      home: SlowScreen(),
    );
  }
}

class SlowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Add intentionally slow operations
    return Scaffold(
      appBar: AppBar(title: Text('Profile This Screen')),
      body: Center(child: Text('Use DevTools')),
    );
  }
}
