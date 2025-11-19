# Geolocation & Google Maps Integration

## Understanding Location Services (5-Year-Old Analogy)

Imagine you're on a treasure hunt in a big park!

**GPS is like your magic compass** that always knows exactly where you are in the park. When you want to find the treasure, you need three things:

1. **Your Current Location** - Like asking "Where am I standing right now?" Your phone's GPS tells you!
2. **The Map** - Like having a picture of the whole park so you can see all the paths and playgrounds
3. **Markers** - Like putting stickers on your map to remember where you found cool things!

When you're walking, your magic compass keeps updating to show you moving on the map - just like a dot that follows you around! And if you want to remember the path you took, you can draw a line connecting all the places you walked. That's exactly what apps like Google Maps do for cars, bikes, and people walking!

## Complete Setup Guide

### Step 1: Add Dependencies

Add these packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^10.1.0
  google_maps_flutter: ^2.5.0
  permission_handler: ^11.0.1
```

Run:
```bash
flutter pub get
```

### Step 2: Android Configuration

**android/app/src/main/AndroidManifest.xml:**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET"/>

    <application ...>
        <!-- Add Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_ANDROID_API_KEY_HERE"/>

        <!-- Your activities -->
    </application>
</manifest>
```

**android/build.gradle:**

```gradle
buildscript {
    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

### Step 3: iOS Configuration

**ios/Runner/Info.plist:**

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show you on the map</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to track your route</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location for background tracking</string>
```

**ios/Runner/AppDelegate.swift:**

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Getting Google Maps API Keys

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable "Maps SDK for Android" and "Maps SDK for iOS"
4. Go to Credentials → Create Credentials → API Key
5. Create separate keys for Android and iOS
6. Restrict keys to specific platforms for security

## Location Service Implementation

### Example 1: Basic Location Service

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check current permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current location with error handling
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Calculate distance between two points (in meters)
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
```

### Example 2: Permission Handler Widget

```dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionScreen extends StatefulWidget {
  @override
  _LocationPermissionScreenState createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  String _statusMessage = 'Checking location permissions...';
  LocationPermission? _permission;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    setState(() {
      _permission = permission;
      _statusMessage = _getStatusMessage(permission);
    });
  }

  String _getStatusMessage(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return 'Location permission denied. Tap to request.';
      case LocationPermission.deniedForever:
        return 'Location permission permanently denied. Please enable in settings.';
      case LocationPermission.whileInUse:
        return 'Location permission granted for app usage.';
      case LocationPermission.always:
        return 'Location permission granted always.';
      default:
        return 'Unknown permission status.';
    }
  }

  Future<void> _requestPermission() async {
    if (_permission == LocationPermission.deniedForever) {
      // Open app settings
      await Geolocator.openAppSettings();
    } else {
      LocationPermission permission = await Geolocator.requestPermission();
      setState(() {
        _permission = permission;
        _statusMessage = _getStatusMessage(permission);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Permissions')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _permission == LocationPermission.whileInUse ||
                      _permission == LocationPermission.always
                  ? Icons.location_on
                  : Icons.location_off,
              size: 100,
              color: _permission == LocationPermission.whileInUse ||
                      _permission == LocationPermission.always
                  ? Colors.green
                  : Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (_permission != LocationPermission.whileInUse &&
                _permission != LocationPermission.always)
              ElevatedButton(
                onPressed: _requestPermission,
                child: Text(
                  _permission == LocationPermission.deniedForever
                      ? 'Open Settings'
                      : 'Request Permission',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

## Google Maps Integration

### Example 3: Basic Map Screen

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class BasicMapScreen extends StatefulWidget {
  @override
  _BasicMapScreenState createState() => _BasicMapScreenState();
}

class _BasicMapScreenState extends State<BasicMapScreen> {
  GoogleMapController? _controller;
  Position? _currentPosition;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position? position = await LocationService().getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });

      // Animate camera to current location
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Location')),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _getCurrentLocation();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
```

### Example 4: Adding Custom Markers

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkersMap extends StatefulWidget {
  @override
  _CustomMarkersMapState createState() => _CustomMarkersMapState();
}

class _CustomMarkersMapState extends State<CustomMarkersMap> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  // Sample locations (stores, restaurants, etc.)
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Coffee Shop',
      'lat': 37.7749,
      'lng': -122.4194,
      'type': 'restaurant',
    },
    {
      'name': 'Gym',
      'lat': 37.7849,
      'lng': -122.4094,
      'type': 'fitness',
    },
    {
      'name': 'Park',
      'lat': 37.7649,
      'lng': -122.4294,
      'type': 'park',
    },
  ];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    for (var location in _locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location['name']),
          position: LatLng(location['lat'], location['lng']),
          infoWindow: InfoWindow(
            title: location['name'],
            snippet: 'Tap for more info',
          ),
          icon: _getMarkerIcon(location['type']),
          onTap: () => _onMarkerTapped(location),
        ),
      );
    }
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    // You can customize marker colors based on type
    switch (type) {
      case 'restaurant':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'fitness':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'park':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _onMarkerTapped(Map<String, dynamic> location) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              location['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Type: ${location['type']}'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to location details or start navigation
              },
              icon: Icon(Icons.directions),
              label: Text('Get Directions'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Markers')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (controller) => _controller = controller,
      ),
    );
  }
}
```

### Example 5: Drawing Polylines (Routes)

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineMapScreen extends StatefulWidget {
  @override
  _PolylineMapScreenState createState() => _PolylineMapScreenState();
}

class _PolylineMapScreenState extends State<PolylineMapScreen> {
  GoogleMapController? _controller;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  // Sample route coordinates (e.g., running route)
  final List<LatLng> _routeCoordinates = [
    LatLng(37.7749, -122.4194),
    LatLng(37.7779, -122.4164),
    LatLng(37.7809, -122.4134),
    LatLng(37.7839, -122.4104),
    LatLng(37.7869, -122.4074),
  ];

  @override
  void initState() {
    super.initState();
    _createRoute();
  }

  void _createRoute() {
    // Create polyline
    _polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: _routeCoordinates,
        color: Colors.blue,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );

    // Add start marker
    _markers.add(
      Marker(
        markerId: MarkerId('start'),
        position: _routeCoordinates.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Start'),
      ),
    );

    // Add end marker
    _markers.add(
      Marker(
        markerId: MarkerId('end'),
        position: _routeCoordinates.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'End'),
      ),
    );

    setState(() {});
  }

  double _calculateRouteDistance() {
    double totalDistance = 0;
    for (int i = 0; i < _routeCoordinates.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        _routeCoordinates[i].latitude,
        _routeCoordinates[i].longitude,
        _routeCoordinates[i + 1].latitude,
        _routeCoordinates[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              double distance = _calculateRouteDistance();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Route Info'),
                  content: Text(
                    'Total Distance: ${(distance / 1000).toStringAsFixed(2)} km',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _routeCoordinates.first,
          zoom: 13,
        ),
        polylines: _polylines,
        markers: _markers,
        onMapCreated: (controller) => _controller = controller,
      ),
    );
  }
}
```

### Example 6: Drawing Polygons (Areas)

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonMapScreen extends StatefulWidget {
  @override
  _PolygonMapScreenState createState() => _PolygonMapScreenState();
}

class _PolygonMapScreenState extends State<PolygonMapScreen> {
  Set<Polygon> _polygons = {};

  // Define delivery zones
  final List<List<LatLng>> _deliveryZones = [
    // Zone 1 (Premium area)
    [
      LatLng(37.7749, -122.4194),
      LatLng(37.7849, -122.4194),
      LatLng(37.7849, -122.4094),
      LatLng(37.7749, -122.4094),
    ],
    // Zone 2 (Standard area)
    [
      LatLng(37.7649, -122.4294),
      LatLng(37.7749, -122.4294),
      LatLng(37.7749, -122.4194),
      LatLng(37.7649, -122.4194),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _createPolygons();
  }

  void _createPolygons() {
    _polygons.add(
      Polygon(
        polygonId: PolygonId('zone1'),
        points: _deliveryZones[0],
        fillColor: Colors.green.withOpacity(0.3),
        strokeColor: Colors.green,
        strokeWidth: 2,
        consumeTapEvents: true,
        onTap: () => _showZoneInfo('Premium Zone', 'Free delivery'),
      ),
    );

    _polygons.add(
      Polygon(
        polygonId: PolygonId('zone2'),
        points: _deliveryZones[1],
        fillColor: Colors.blue.withOpacity(0.3),
        strokeColor: Colors.blue,
        strokeWidth: 2,
        consumeTapEvents: true,
        onTap: () => _showZoneInfo('Standard Zone', '\$5 delivery fee'),
      ),
    );

    setState(() {});
  }

  void _showZoneInfo(String zoneName, String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$zoneName: $info')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery Zones')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        polygons: _polygons,
      ),
    );
  }
}
```

## Real-Time Location Tracking

### Example 7: Live Location Tracker

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LiveLocationTracker extends StatefulWidget {
  @override
  _LiveLocationTrackerState createState() => _LiveLocationTrackerState();
}

class _LiveLocationTrackerState extends State<LiveLocationTracker> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  List<LatLng> _routePath = [];
  Set<Polyline> _polylines = {};
  bool _isTracking = false;
  double _totalDistance = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _startTime = DateTime.now();
      _routePath.clear();
      _totalDistance = 0;
    });

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      setState(() {
        // Calculate distance if we have a previous position
        if (_routePath.isNotEmpty) {
          LatLng lastPoint = _routePath.last;
          _totalDistance += Geolocator.distanceBetween(
            lastPoint.latitude,
            lastPoint.longitude,
            position.latitude,
            position.longitude,
          );
        }

        // Add new position to route
        _routePath.add(LatLng(position.latitude, position.longitude));
        _currentPosition = position;

        // Update polyline
        _polylines = {
          Polyline(
            polylineId: PolylineId('tracking'),
            points: _routePath,
            color: Colors.blue,
            width: 5,
          ),
        };

        // Move camera to current position
        _controller?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      });
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    setState(() {
      _isTracking = false;
    });
  }

  String _getElapsedTime() {
    if (_startTime == null) return '00:00:00';
    Duration elapsed = DateTime.now().difference(_startTime!);
    String hours = elapsed.inHours.toString().padLeft(2, '0');
    String minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Tracking')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 15,
            ),
            myLocationEnabled: true,
            polylines: _polylines,
            onMapCreated: (controller) => _controller = controller,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time: ${_getElapsedTime()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (_currentPosition != null)
                      Text(
                        'Speed: ${_currentPosition!.speed.toStringAsFixed(1)} m/s',
                        style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isTracking ? _stopTracking : _startTracking,
        icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
        label: Text(_isTracking ? 'Stop' : 'Start'),
        backgroundColor: _isTracking ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
```

## Real-World Application Examples

### Example 8: Taxi App (Ride Tracking)

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiTrackingScreen extends StatefulWidget {
  @override
  _TaxiTrackingScreenState createState() => _TaxiTrackingScreenState();
}

class _TaxiTrackingScreenState extends State<TaxiTrackingScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  LatLng _pickupLocation = LatLng(37.7749, -122.4194);
  LatLng _dropoffLocation = LatLng(37.7849, -122.4094);
  LatLng _driverLocation = LatLng(37.7699, -122.4244);

  @override
  void initState() {
    super.initState();
    _setupRide();
  }

  void _setupRide() {
    // Pickup marker
    _markers.add(
      Marker(
        markerId: MarkerId('pickup'),
        position: _pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Pickup Location'),
      ),
    );

    // Dropoff marker
    _markers.add(
      Marker(
        markerId: MarkerId('dropoff'),
        position: _dropoffLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Dropoff Location'),
      ),
    );

    // Driver marker
    _markers.add(
      Marker(
        markerId: MarkerId('driver'),
        position: _driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: 'Driver'),
      ),
    );

    // Route polyline
    _polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: [_pickupLocation, _dropoffLocation],
        color: Colors.blue,
        width: 5,
      ),
    );

    setState(() {});
  }

  double _getEstimatedTime() {
    double distance = Geolocator.distanceBetween(
      _driverLocation.latitude,
      _driverLocation.longitude,
      _pickupLocation.latitude,
      _pickupLocation.longitude,
    );
    // Assume average speed of 40 km/h in city
    return (distance / 1000) / 40 * 60; // minutes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Ride')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation,
              zoom: 13,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _controller = controller,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver Arriving',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Estimated time: ${_getEstimatedTime().toStringAsFixed(0)} min'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(child: Icon(Icons.person)),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Toyota Camry - ABC 123'),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 9: Store Locator App

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class StoreLocatorScreen extends StatefulWidget {
  @override
  _StoreLocatorScreenState createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends State<StoreLocatorScreen> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  Set<Marker> _markers = {};

  final List<Map<String, dynamic>> _stores = [
    {
      'name': 'Main Store',
      'address': '123 Main St',
      'lat': 37.7749,
      'lng': -122.4194,
      'hours': '9 AM - 9 PM',
    },
    {
      'name': 'Downtown Store',
      'address': '456 Market St',
      'lat': 37.7849,
      'lng': -122.4094,
      'hours': '8 AM - 10 PM',
    },
    {
      'name': 'West Side Store',
      'address': '789 West Ave',
      'lat': 37.7649,
      'lng': -122.4294,
      'hours': '10 AM - 8 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _createStoreMarkers();
  }

  Future<void> _getCurrentLocation() async {
    Position? position = await LocationService().getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
      _sortStoresByDistance();
    }
  }

  void _createStoreMarkers() {
    for (var store in _stores) {
      _markers.add(
        Marker(
          markerId: MarkerId(store['name']),
          position: LatLng(store['lat'], store['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _showStoreDetails(store),
        ),
      );
    }
    setState(() {});
  }

  void _sortStoresByDistance() {
    if (_currentPosition == null) return;

    _stores.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        a['lat'],
        a['lng'],
      );
      double distanceB = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        b['lat'],
        b['lng'],
      );
      return distanceA.compareTo(distanceB);
    });
    setState(() {});
  }

  void _showStoreDetails(Map<String, dynamic> store) {
    double? distance;
    if (_currentPosition != null) {
      distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        store['lat'],
        store['lng'],
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              store['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text(store['address'])),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 20),
                SizedBox(width: 8),
                Text(store['hours']),
              ],
            ),
            if (distance != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.directions_walk, size: 20),
                  SizedBox(width: 8),
                  Text('${(distance / 1000).toStringAsFixed(1)} km away'),
                ],
              ),
            ],
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Launch directions
                    },
                    icon: Icon(Icons.directions),
                    label: Text('Directions'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Call store
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Call'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find a Store')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              markers: _markers,
              myLocationEnabled: true,
              onMapCreated: (controller) => _controller = controller,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _stores.length,
              itemBuilder: (context, index) {
                var store = _stores[index];
                double? distance;
                if (_currentPosition != null) {
                  distance = Geolocator.distanceBetween(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                    store['lat'],
                    store['lng'],
                  );
                }

                return ListTile(
                  leading: Icon(Icons.store, color: Colors.orange),
                  title: Text(store['name']),
                  subtitle: Text(store['address']),
                  trailing: distance != null
                      ? Text('${(distance / 1000).toStringAsFixed(1)} km')
                      : null,
                  onTap: () {
                    _controller?.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(store['lat'], store['lng']),
                        15,
                      ),
                    );
                    _showStoreDetails(store);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 10: Fitness Tracker (Running App)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class FitnessTrackerScreen extends StatefulWidget {
  @override
  _FitnessTrackerScreenState createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  GoogleMapController? _controller;
  StreamSubscription<Position>? _positionStream;
  List<LatLng> _runPath = [];
  Set<Polyline> _polylines = {};

  bool _isRunning = false;
  bool _isPaused = false;
  DateTime? _startTime;
  Duration _pausedDuration = Duration.zero;
  DateTime? _pauseStartTime;

  double _totalDistance = 0;
  double _currentSpeed = 0;
  double _averageSpeed = 0;
  int _calories = 0;

  void _startRun() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _startTime = DateTime.now();
      _runPath.clear();
      _totalDistance = 0;
      _calories = 0;
    });

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (!_isPaused) {
        setState(() {
          if (_runPath.isNotEmpty) {
            LatLng lastPoint = _runPath.last;
            double distance = Geolocator.distanceBetween(
              lastPoint.latitude,
              lastPoint.longitude,
              position.latitude,
              position.longitude,
            );
            _totalDistance += distance;
          }

          _runPath.add(LatLng(position.latitude, position.longitude));
          _currentSpeed = position.speed * 3.6; // Convert to km/h

          // Calculate average speed
          if (_startTime != null) {
            Duration runDuration = DateTime.now().difference(_startTime!) - _pausedDuration;
            _averageSpeed = (_totalDistance / 1000) / (runDuration.inSeconds / 3600);
          }

          // Estimate calories (rough estimate: 60 cal per km for average person)
          _calories = (_totalDistance / 1000 * 60).round();

          _polylines = {
            Polyline(
              polylineId: PolylineId('run'),
              points: _runPath,
              color: Colors.red,
              width: 5,
            ),
          };

          _controller?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        });
      }
    });
  }

  void _pauseRun() {
    setState(() {
      _isPaused = true;
      _pauseStartTime = DateTime.now();
    });
  }

  void _resumeRun() {
    setState(() {
      _isPaused = false;
      if (_pauseStartTime != null) {
        _pausedDuration += DateTime.now().difference(_pauseStartTime!);
      }
    });
  }

  void _stopRun() {
    _positionStream?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
    _showRunSummary();
  }

  void _showRunSummary() {
    Duration totalDuration = DateTime.now().difference(_startTime!) - _pausedDuration;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Run Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km'),
            Text('Time: ${_formatDuration(totalDuration)}'),
            Text('Avg Speed: ${_averageSpeed.toStringAsFixed(1)} km/h'),
            Text('Calories: $_calories kcal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _runPath.clear();
                _polylines.clear();
              });
            },
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save run data
              Navigator.pop(context);
            },
            child: Text('Save Run'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _getElapsedTime() {
    if (_startTime == null) return '00:00:00';
    Duration elapsed = DateTime.now().difference(_startTime!) - _pausedDuration;
    if (_isPaused && _pauseStartTime != null) {
      elapsed = _pauseStartTime!.difference(_startTime!) - _pausedDuration;
    }
    return _formatDuration(elapsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fitness Tracker')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 15,
            ),
            myLocationEnabled: true,
            polylines: _polylines,
            onMapCreated: (controller) => _controller = controller,
          ),
          if (_isRunning)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: _isPaused ? Colors.orange[100] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _getElapsedTime(),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _isPaused ? Colors.orange : Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Distance', '${(_totalDistance / 1000).toStringAsFixed(2)} km'),
                          _buildStat('Speed', '${_currentSpeed.toStringAsFixed(1)} km/h'),
                          _buildStat('Calories', '$_calories'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _isRunning
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'pause',
                  onPressed: _isPaused ? _resumeRun : _pauseRun,
                  child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  backgroundColor: Colors.orange,
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'stop',
                  onPressed: _stopRun,
                  child: Icon(Icons.stop),
                  backgroundColor: Colors.red,
                ),
              ],
            )
          : FloatingActionButton.extended(
              onPressed: _startRun,
              icon: Icon(Icons.play_arrow),
              label: Text('Start Run'),
              backgroundColor: Colors.green,
            ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
```

## Best Practices and Battery Optimization

### 1. Choose Appropriate Location Accuracy

```dart
// For fitness tracking - High accuracy
LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 5, // Update every 5 meters
)

// For general location - Balanced
LocationSettings(
  accuracy: LocationAccuracy.medium,
  distanceFilter: 50, // Update every 50 meters
)

// For coarse location - Battery efficient
LocationSettings(
  accuracy: LocationAccuracy.low,
  distanceFilter: 100, // Update every 100 meters
)
```

### 2. Use Distance Filter

Only get updates when the user moves a significant distance:

```dart
final locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 10, // Only update if moved 10+ meters
);
```

### 3. Stop Tracking When Not Needed

Always cancel location streams when done:

```dart
@override
void dispose() {
  _positionStream?.cancel();
  super.dispose();
}
```

### 4. Background Location Best Practices

- Only use background location when absolutely necessary
- Request "When In Use" permission first
- Explain to users why you need background location
- Consider using geofencing instead of continuous tracking

### 5. Cache Location Data

Don't request location repeatedly for the same screen:

```dart
Position? _cachedPosition;
DateTime? _cacheTime;

Future<Position?> getCachedLocation() async {
  // Use cached location if less than 5 minutes old
  if (_cachedPosition != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < Duration(minutes: 5)) {
    return _cachedPosition;
  }

  _cachedPosition = await Geolocator.getCurrentPosition();
  _cacheTime = DateTime.now();
  return _cachedPosition;
}
```

### 6. Handle Permission States Properly

```dart
Future<bool> handleLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enable location services')),
    );
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions denied')),
      );
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location permissions permanently denied'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => Geolocator.openAppSettings(),
        ),
      ),
    );
    return false;
  }

  return true;
}
```

### 7. Optimize Map Performance

```dart
GoogleMap(
  // Only render visible markers
  markers: _getVisibleMarkers(),

  // Disable animations if not needed
  rotateGesturesEnabled: false,
  tiltGesturesEnabled: false,

  // Use lite mode for static maps
  liteModeEnabled: true,

  // Reduce map complexity
  buildingsEnabled: false,
  trafficEnabled: false,
)
```

### 8. Use Geofencing Instead of Continuous Tracking

For location-based alerts, use geofencing:

```dart
// Trigger when user enters/exits a region
// More battery efficient than continuous tracking
```

## Common Issues and Solutions

### Issue 1: Location Permission Denied
- Always check permission before requesting location
- Provide clear explanation of why location is needed
- Handle "denied forever" case by opening settings

### Issue 2: Location Inaccurate
- Use `LocationAccuracy.high` for precise location
- Wait for multiple position updates to stabilize
- Consider using GPS + Network location

### Issue 3: Map Not Showing
- Verify API key is correct
- Check API key restrictions in Google Cloud Console
- Ensure billing is enabled for your project
- Check internet connectivity

### Issue 4: High Battery Drain
- Use appropriate distance filters
- Stop tracking when app is in background (unless needed)
- Use lower accuracy when high precision isn't required
- Implement proper lifecycle management

## Summary

You've learned how to:
- Set up geolocator and Google Maps packages
- Handle location permissions for Android and iOS
- Get current location and track real-time movement
- Display custom markers, polylines, and polygons
- Build real-world apps (taxi, store locator, fitness tracker)
- Optimize battery usage and performance
- Handle common issues and edge cases

Location features open up endless possibilities for creating engaging, location-aware applications!
