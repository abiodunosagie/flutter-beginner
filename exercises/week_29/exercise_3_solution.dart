/// Week 29, Exercise 3: Geolocation and Google Maps
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(MapsApp());
}

class MapsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _location = 'Unknown';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location & Maps')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Column(
              children: [
                Text('Current Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(_location),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: Icon(Icons.my_location),
                  label: Text('Get Location'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Google Maps would appear here'),
                  SizedBox(height: 8),
                  Text('Add google_maps_flutter package', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    // Use geolocator package in real app
    setState(() => _location = '37.7749° N, 122.4194° W (Demo)');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location retrieved (demo)')),
    );
  }
}
