// Copy into: lib/domain/fare_calculator.dart
import 'dart:math';

class GeoPointLite {
  final double lat;
  final double lng;
  const GeoPointLite(this.lat, this.lng);
}

class FareCalculator {
  static const base = 2.50;
  static const perKm = 1.20;
  static const perMinute = 0.25;
  static const minFare = 5.00;

  static double distanceKm(GeoPointLite a, GeoPointLite b) {
    const r = 6371.0;
    final dLat = _rad(b.lat - a.lat);
    final dLng = _rad(b.lng - a.lng);
    final x = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(a.lat)) * cos(_rad(b.lat)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(x), sqrt(1 - x));
    return r * c;
  }

  static double estimate({
    required GeoPointLite pickup,
    required GeoPointLite dropoff,
    double avgSpeedKmh = 28,
  }) {
    final km = distanceKm(pickup, dropoff);
    final minutes = (km / avgSpeedKmh) * 60;
    final raw = base + perKm * km + perMinute * minutes;
    final fare = raw < minFare ? minFare : raw;
    return double.parse(fare.toStringAsFixed(2));
  }

  static double _rad(double d) => d * pi / 180;
}
