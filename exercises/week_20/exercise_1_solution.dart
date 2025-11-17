/// Week 20, Exercise 1: Basic HTTP Request to Weather API
///
/// BEGINNER LEVEL - SOLUTION
///
/// Note: This uses a mock API. In production, use OpenWeatherMap API.

import 'package:flutter/material.dart';
import 'dart:convert';

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

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;
  String? error;
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Simulate API call with mock data
      await Future.delayed(Duration(seconds: 2));

      // Mock weather data
      final mockData = {
        'name': 'London',
        'main': {'temp': 15.5, 'feels_like': 14.2, 'humidity': 72},
        'weather': [
          {'main': 'Clouds', 'description': 'scattered clouds', 'icon': '03d'}
        ],
        'wind': {'speed': 5.2}
      };

      setState(() {
        weatherData = mockData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to fetch weather: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(error!, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchWeather,
                        child: Text('Retry'),
                      ),
                    ],
                  )
                : _buildWeatherDisplay(),
      ),
    );
  }

  Widget _buildWeatherDisplay() {
    if (weatherData == null) return SizedBox();

    final name = weatherData!['name'];
    final temp = weatherData!['main']['temp'];
    final description = weatherData!['weather'][0]['description'];
    final humidity = weatherData!['main']['humidity'];
    final windSpeed = weatherData!['wind']['speed'];

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '${temp.toStringAsFixed(1)}°C',
            style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDetailCard('Humidity', '$humidity%', Icons.water_drop),
              _buildDetailCard('Wind', '${windSpeed}m/s', Icons.air),
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: fetchWeather,
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
