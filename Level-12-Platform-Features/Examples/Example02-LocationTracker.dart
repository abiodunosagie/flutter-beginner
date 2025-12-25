// Example 02: Location Tracker
// Get user location and calculate distances

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;
  final List<Position> _trackingHistory = [];

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════
  // CHECK & REQUEST PERMISSION
  // ══════════════════════════════════════════════════════════

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _error = 'Location services are disabled.');
      return false;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _error = 'Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _error =
        'Location permissions are permanently denied. '
        'Please enable in Settings.');
      return false;
    }

    return true;
  }

  // ══════════════════════════════════════════════════════════
  // GET CURRENT LOCATION
  // ══════════════════════════════════════════════════════════

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (!await _handlePermission()) {
        setState(() => _isLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  // ══════════════════════════════════════════════════════════
  // CONTINUOUS TRACKING
  // ══════════════════════════════════════════════════════════

  Future<void> _startTracking() async {
    if (!await _handlePermission()) return;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    setState(() {
      _isTracking = true;
      _trackingHistory.clear();
    });

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _trackingHistory.add(position);
      });
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    setState(() => _isTracking = false);
  }

  // ══════════════════════════════════════════════════════════
  // CALCULATE DISTANCE
  // ══════════════════════════════════════════════════════════

  double _calculateTotalDistance() {
    if (_trackingHistory.length < 2) return 0;

    double total = 0;
    for (int i = 1; i < _trackingHistory.length; i++) {
      total += Geolocator.distanceBetween(
        _trackingHistory[i - 1].latitude,
        _trackingHistory[i - 1].longitude,
        _trackingHistory[i].latitude,
        _trackingHistory[i].longitude,
      );
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ════════════════════════════════════════════════
            // CURRENT LOCATION CARD
            // ════════════════════════════════════════════════

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        const Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!)),
                          ],
                        ),
                      )
                    else if (_currentPosition != null) ...[
                      _buildLocationRow(
                        'Latitude',
                        _currentPosition!.latitude.toStringAsFixed(6),
                      ),
                      _buildLocationRow(
                        'Longitude',
                        _currentPosition!.longitude.toStringAsFixed(6),
                      ),
                      _buildLocationRow(
                        'Accuracy',
                        '${_currentPosition!.accuracy.toStringAsFixed(0)} meters',
                      ),
                      _buildLocationRow(
                        'Altitude',
                        '${_currentPosition!.altitude.toStringAsFixed(0)} meters',
                      ),
                      _buildLocationRow(
                        'Speed',
                        '${(_currentPosition!.speed * 3.6).toStringAsFixed(1)} km/h',
                      ),
                    ] else
                      const Text(
                        'Tap button to get location',
                        style: TextStyle(color: Colors.grey),
                      ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _getCurrentLocation,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Get Location'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ════════════════════════════════════════════════
            // TRACKING CARD
            // ════════════════════════════════════════════════

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          color: _isTracking ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Location Tracking',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_isTracking)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_isTracking) ...[
                      _buildLocationRow(
                        'Points recorded',
                        '${_trackingHistory.length}',
                      ),
                      _buildLocationRow(
                        'Distance traveled',
                        '${(_calculateTotalDistance() / 1000).toStringAsFixed(2)} km',
                      ),
                    ],

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: _isTracking
                          ? ElevatedButton.icon(
                              onPressed: _stopTracking,
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop Tracking'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _startTracking,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Tracking'),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ════════════════════════════════════════════════
            // DISTANCE CALCULATOR
            // ════════════════════════════════════════════════

            const DistanceCalculator(),

            const SizedBox(height: 16),

            // ════════════════════════════════════════════════
            // OPEN SETTINGS
            // ════════════════════════════════════════════════

            OutlinedButton.icon(
              onPressed: () => Geolocator.openLocationSettings(),
              icon: const Icon(Icons.settings),
              label: const Text('Open Location Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DISTANCE CALCULATOR WIDGET
// ═══════════════════════════════════════════════════════════════

class DistanceCalculator extends StatelessWidget {
  const DistanceCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    // Example: Distance from New York to Los Angeles
    const nyLat = 40.7128;
    const nyLng = -74.0060;
    const laLat = 34.0522;
    const laLng = -118.2437;

    final distance = Geolocator.distanceBetween(nyLat, nyLng, laLat, laLng);
    final distanceKm = (distance / 1000).toStringAsFixed(0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.straighten, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Distance Example',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.location_city, size: 32),
                      const SizedBox(height: 4),
                      const Text('New York'),
                      Text(
                        '${nyLat.toStringAsFixed(2)}°, ${nyLng.toStringAsFixed(2)}°',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.arrow_forward, color: Colors.blue),
                    Text(
                      '$distanceKm km',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.location_city, size: 32),
                      const SizedBox(height: 4),
                      const Text('Los Angeles'),
                      Text(
                        '${laLat.toStringAsFixed(2)}°, ${laLng.toStringAsFixed(2)}°',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * SETUP REQUIRED
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add to pubspec.yaml:
 *    dependencies:
 *      geolocator: ^10.1.0
 *
 * 2. iOS - Add to ios/Runner/Info.plist:
 *    <key>NSLocationWhenInUseUsageDescription</key>
 *    <string>We need location to show your position</string>
 *
 * 3. Android - Add to android/app/src/main/AndroidManifest.xml:
 *    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
 *    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
 *
 * ═══════════════════════════════════════════════════════════════
 */
