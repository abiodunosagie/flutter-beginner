/// Week 21, Exercise 2: Flutter Web Deployment & Optimization
///
/// Exercise 2 for Week 21 - Deployment and PWA Features
/// Refer to lesson files for detailed requirements.

import 'package:flutter/material.dart';

void main() {
  runApp(DeploymentApp());
}

class DeploymentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deployment Exercise 2',
      home: Scaffold(
        appBar: AppBar(title: Text('Deployment Exercise 2')),
        body: Center(
          child: Text('Implement Exercise 2 here'),
        ),
      ),
    );
  }
}
