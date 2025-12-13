/// Week 20, Exercise 4: Weather App Feature
///
/// Exercise 4 for Week 20 - Weather API Integration
/// Refer to lesson files for detailed requirements.

import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App Exercise 4',
      home: Scaffold(
        appBar: AppBar(title: Text('Weather Exercise 4')),
        body: Center(
          child: Text('Implement Exercise 4 here'),
        ),
      ),
    );
  }
}
