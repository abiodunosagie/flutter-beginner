# Location Services

## The Big Idea In One Sentence

> Location packages (like `geolocator`) ask permission, then give you the device's latitude and longitude, so your app knows where the user is.

## The Simple Explanation

Location is like GPS in your car - it tells you exactly where you are on Earth using coordinates (latitude and longitude).

```
┌─────────────────────────────────────────────────────────┐
│                    LOCATION                              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│         🌍 Earth                                         │
│          ╱╲                                              │
│         ╱  ╲                                             │
│        ╱ 📍 ╲  ← You are here!                          │
│       ╱      ╲                                           │
│      ╱────────╲                                          │
│                                                          │
│  Your location:                                          │
│  Latitude:  40.7128° N  (how far north/south)           │
│  Longitude: 74.0060° W  (how far east/west)             │
│                                                          │
│  Like coordinates on a map!                              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Setup

### 1. Add Package

```yaml
dependencies:
  geolocator: ^10.1.0
  geocoding: ^2.1.1  # Optional: Convert coordinates to addresses
```

### 2. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<!-- For "when in use" permission -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby places</string>

<!-- For "always" permission (background tracking) -->
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to track your workouts</string>
```

### 3. Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Approximate location (city-level) -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- Precise location (street-level) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

<!-- Background location (Android 10+) -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
```

---

## Checking & Requesting Permission

```dart
import 'package:geolocator/geolocator.dart';

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Step 1: Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are disabled
    return false;
  }

  // Step 2: Check permission status
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Request permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permission denied
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permission permanently denied
    // User must enable from settings
    return false;
  }

  // Permission granted!
  return true;
}
```

---

## Getting Current Location

### One-Time Location

```dart
Future<Position?> getCurrentLocation() async {
  // Check permission first
  final hasPermission = await handleLocationPermission();
  if (!hasPermission) return null;

  // Get current position
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  print('Latitude: ${position.latitude}');
  print('Longitude: ${position.longitude}');
  print('Accuracy: ${position.accuracy} meters');

  return position;
}
```

### Location Accuracy Options

```dart
// Different accuracy levels
LocationAccuracy.lowest      // ~3000m - Uses less battery
LocationAccuracy.low         // ~500m
LocationAccuracy.medium      // ~100m
LocationAccuracy.high        // ~10m - Most accurate
LocationAccuracy.best        // Best possible
LocationAccuracy.bestForNavigation  // For navigation apps
```

---

## Continuous Location Updates

```dart
StreamSubscription<Position>? _positionStream;

void startLocationUpdates() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters moved
  );

  _positionStream = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    print('New position: ${position.latitude}, ${position.longitude}');
    // Update UI or store position
  });
}

void stopLocationUpdates() {
  _positionStream?.cancel();
}

// Don't forget to cancel in dispose!
@override
void dispose() {
  stopLocationUpdates();
  super.dispose();
}
```

---

## Calculate Distance

```dart
// Distance between two points in meters
double distanceInMeters = Geolocator.distanceBetween(
  startLatitude,
  startLongitude,
  endLatitude,
  endLongitude,
);

// Convert to kilometers
double distanceInKm = distanceInMeters / 1000;

// Example: Distance from New York to Los Angeles
double distance = Geolocator.distanceBetween(
  40.7128, -74.0060,  // New York
  34.0522, -118.2437, // Los Angeles
);
print('Distance: ${(distance / 1000).toStringAsFixed(0)} km');
// Output: Distance: 3940 km
```

---

## Geocoding (Coordinates ↔ Address)

### Coordinates to Address

```dart
import 'package:geocoding/geocoding.dart';

Future<String?> getAddressFromCoordinates(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.country}';
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

// Example
final address = await getAddressFromCoordinates(40.7128, -74.0060);
// Returns: "Broadway, New York, United States"
```

### Address to Coordinates

```dart
Future<Location?> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isNotEmpty) {
      return locations.first;
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

// Example
final location = await getCoordinatesFromAddress('Times Square, New York');
// Returns: Location with lat: 40.758, lng: -73.985
```

---

## Complete Location Service

```dart
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  StreamSubscription<Position>? _positionStream;

  // Check if location is available
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Request permission
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    if (!await requestPermission()) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Start tracking
  void startTracking(Function(Position) onLocationUpdate) {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(onLocationUpdate);
  }

  // Stop tracking
  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // Get address from coordinates
  Future<String?> getAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return '${p.street}, ${p.locality}, ${p.country}';
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
    return null;
  }

  // Calculate distance between two points
  double getDistance(
    double startLat, double startLng,
    double endLat, double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // Open location settings
  Future<void> openSettings() async {
    await Geolocator.openLocationSettings();
  }
}
```

---

## Location Widget Example

```dart
class LocationDisplay extends StatefulWidget {
  const LocationDisplay({super.key});

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
  final _locationService = LocationService();
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  String? _error;

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if location is enabled
      if (!await _locationService.isLocationEnabled()) {
        setState(() => _error = 'Location services are disabled');
        return;
      }

      // Get position
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        setState(() => _error = 'Location permission denied');
        return;
      }

      // Get address
      final address = await _locationService.getAddress(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _currentAddress = address;
      });
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
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
                  'Your Location',
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
                padding: const EdgeInsets.all(8),
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
              Text('Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}'),
              Text('Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}'),
              Text('Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(0)} m'),
              if (_currentAddress != null) ...[
                const SizedBox(height: 8),
                Text('Address: $_currentAddress'),
              ],
            ] else
              const Text('Tap button to get location'),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _getLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Get My Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Common Use Cases

### 1. Find Nearby Places

```dart
// Filter places within 5km
List<Place> findNearbyPlaces(Position userLocation, List<Place> allPlaces) {
  const maxDistanceKm = 5.0;

  return allPlaces.where((place) {
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      place.latitude,
      place.longitude,
    );
    return distance <= maxDistanceKm * 1000; // Convert to meters
  }).toList();
}
```

### 2. Fitness Tracker

```dart
class WorkoutTracker {
  final List<Position> _route = [];
  double _totalDistance = 0;

  void addPosition(Position position) {
    if (_route.isNotEmpty) {
      final lastPosition = _route.last;
      _totalDistance += Geolocator.distanceBetween(
        lastPosition.latitude,
        lastPosition.longitude,
        position.latitude,
        position.longitude,
      );
    }
    _route.add(position);
  }

  double get totalDistanceKm => _totalDistance / 1000;
  List<Position> get route => List.unmodifiable(_route);
}
```

### 3. Store Locator

```dart
// Sort stores by distance
List<Store> sortByDistance(Position userLocation, List<Store> stores) {
  stores.sort((a, b) {
    final distA = Geolocator.distanceBetween(
      userLocation.latitude, userLocation.longitude,
      a.latitude, a.longitude,
    );
    final distB = Geolocator.distanceBetween(
      userLocation.latitude, userLocation.longitude,
      b.latitude, b.longitude,
    );
    return distA.compareTo(distB);
  });
  return stores;
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│             LOCATION SERVICES SUMMARY                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  PACKAGE: geolocator + geocoding                        │
│                                                          │
│  GET LOCATION:                                           │
│  Geolocator.getCurrentPosition()                        │
│                                                          │
│  TRACK LOCATION:                                         │
│  Geolocator.getPositionStream()                         │
│                                                          │
│  CALCULATE DISTANCE:                                     │
│  Geolocator.distanceBetween(lat1, lng1, lat2, lng2)     │
│                                                          │
│  GEOCODING:                                              │
│  placemarkFromCoordinates() - Coords → Address          │
│  locationFromAddress() - Address → Coords               │
│                                                          │
│  PERMISSIONS:                                            │
│  ├── iOS: Add to Info.plist                             │
│  ├── Android: Add to AndroidManifest                    │
│  └── Always check before using!                         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What two numbers describe a location?

<details>
<summary>Answer</summary>
Latitude and longitude.
</details>

**Q2.** What is the first thing you must do before reading location?

<details>
<summary>Answer</summary>
Ask for (and check) location permission. The user has to allow it.
</details>

**Q3.** What should your app do if the user denies location permission?

<details>
<summary>Answer</summary>
Handle it gracefully: explain why you need it and offer a fallback, instead of crashing or silently failing.
</details>

---

## Assignment

### Problem 1: The steps

List the two steps to get the user's current position.

### Problem 2: Denied

The user taps "Don't allow." What should happen next in your app?

### Problem 3: What you get

After a successful read, what two values do you have to work with?

---

## Assignment Answers

### Problem 1: The steps

1. Request/check location permission. 2. If granted, read the current position (latitude and longitude).

### Problem 2: Denied

Show a friendly message explaining the feature needs location, and let the app keep working without it (or offer a manual option). Do not crash.

### Problem 3: What you get

Latitude and longitude (the device's coordinates), which you can show on a map or send to an API.

---

**Next:** `03-LocalNotifications.md` - Alerting users
