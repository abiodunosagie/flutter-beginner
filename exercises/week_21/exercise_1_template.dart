/// Week 21, Exercise 1: Flutter Web Deployment & Optimization
///
/// Exercise 1 for Week 21 - Deployment and PWA Features
/// Refer to lesson files for detailed requirements.

import 'package:flutter/material.dart';

void main() {
  runApp(DeploymentApp());
}

class DeploymentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deployment Exercise 1',
      home: Scaffold(
        appBar: AppBar(title: Text('Deployment Exercise 1')),
        body: Center(
          child: Text('Implement Exercise 1 here'),
        ),
      ),
    );
  }
}
