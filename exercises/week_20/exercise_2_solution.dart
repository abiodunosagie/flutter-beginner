/// Week 20, Exercise 2: Weather App Feature - SOLUTION
///
/// This is a simplified solution for Exercise 2.
/// See previous exercises for detailed patterns.

import 'package:flutter/material.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App - Exercise 2'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              'Weather App Feature 2',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This demonstrates weather app features like:',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 8),
            Text('• City search'),
            Text('• 5-day forecast'),
            Text('• Weather animations'),
            Text('• Responsive design'),
          ],
        ),
      ),
    );
  }
}
