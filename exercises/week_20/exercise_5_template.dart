/// Week 20, Exercise 5: Weather App Feature
///
/// Exercise 5 for Week 20 - Weather API Integration
/// Refer to lesson files for detailed requirements.

import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App Exercise 5',
      home: Scaffold(
        appBar: AppBar(title: Text('Weather Exercise 5')),
        body: Center(
          child: Text('Implement Exercise 5 here'),
        ),
      ),
    );
  }
}
