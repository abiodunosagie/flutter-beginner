/// Week 20, Exercise 3: Weather App Feature
///
/// Exercise 3 for Week 20 - Weather API Integration
/// Refer to lesson files for detailed requirements.

import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App Exercise 3',
      home: Scaffold(
        appBar: AppBar(title: Text('Weather Exercise 3')),
        body: Center(
          child: Text('Implement Exercise 3 here'),
        ),
      ),
    );
  }
}
