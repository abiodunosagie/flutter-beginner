/// Week 29, Exercise 3: Geolocation and Google Maps
///
/// INTERMEDIATE LEVEL
///
/// Implement location features:
/// 1. Add geolocator and google_maps_flutter packages
/// 2. Get current location
/// 3. Display location on Google Map
/// 4. Add markers
/// 5. Handle location permissions
///
/// Learning objectives:
/// - Use device location
/// - Display Google Maps
/// - Add map markers

import 'package:flutter/material.dart';
// TODO: Add geolocator and google_maps_flutter packages

void main() {
  runApp(MapsApp());
}

class MapsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Demo',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // TODO: Implement location and map features
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location & Maps')),
      body: Center(child: Text('Implement Google Maps here')),
    );
  }
}
