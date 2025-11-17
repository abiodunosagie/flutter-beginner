/// Week 20, Exercise 2: Weather App Feature
///
/// Exercise 2 for Week 20 - Weather API Integration
/// Refer to lesson files for detailed requirements.

import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App Exercise 2',
      home: Scaffold(
        appBar: AppBar(title: Text('Weather Exercise 2')),
        body: Center(
          child: Text('Implement Exercise 2 here'),
        ),
      ),
    );
  }
}
