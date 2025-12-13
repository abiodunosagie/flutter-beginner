/// Week 20, Exercise 1: Basic HTTP Request to Weather API
///
/// BEGINNER LEVEL
///
/// Create a simple app that fetches weather data:
/// 1. Make HTTP GET request to weather API
/// 2. Parse JSON response
/// 3. Display basic weather info (temp, description)
/// 4. Handle loading and error states
/// 5. Use http package
///
/// Learning objectives:
/// - Make API requests
/// - Parse JSON data
/// - Handle async operations

import 'package:flutter/material.dart';
// TODO: Add http package to pubspec.yaml and import

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // TODO: Add state variables for loading, error, weather data

  @override
  void initState() {
    super.initState();
    // TODO: Fetch weather on init
  }

  // TODO: Create fetchWeather() method
  // Use http.get() to fetch from API
  // Parse JSON response
  // Update state with data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Show loading indicator while fetching
            // TODO: Show error message if failed
            // TODO: Show weather data when loaded
          ],
        ),
      ),
    );
  }
}
