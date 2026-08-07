// Teaching starter — expand into your app under lib/data/
import 'dart:async';

import 'fare_calculator.dart';
import 'trip_lifecycle.dart';

class Trip {
  final String id;
  final String riderId;
  final String? driverId;
  final GeoPointLite pickup;
  final GeoPointLite dropoff;
  final String pickupAddress;
  final String dropoffAddress;
  final double estimatedFare;
  final double distanceKm;
  final TripStatus status;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.riderId,
    required this.driverId,
    required this.pickup,
    required this.dropoff,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.estimatedFare,
    required this.distanceKm,
    required this.status,
    required this.createdAt,
  });

  Trip copyWith({String? driverId, TripStatus? status}) => Trip(
        id: id,
        riderId: riderId,
        driverId: driverId ?? this.driverId,
        pickup: pickup,
        dropoff: dropoff,
        pickupAddress: pickupAddress,
        dropoffAddress: dropoffAddress,
        estimatedFare: estimatedFare,
        distanceKm: distanceKm,
        status: status ?? this.status,
        createdAt: createdAt,
      );
}

class MockTripRepository {
  final _trips = <Trip>[];
  final _controller = StreamController<List<Trip>>.broadcast();

  Stream<List<Trip>> get stream async* {
    yield List.unmodifiable(_trips);
    yield* _controller.stream;
  }

  void _emit() => _controller.add(List.unmodifiable(_trips));

  Future<Trip> requestRide({
    required String riderId,
    required GeoPointLite pickup,
    required GeoPointLite dropoff,
    required String pickupAddress,
    required String dropoffAddress,
  }) async {
    final trip = Trip(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      riderId: riderId,
      driverId: null,
      pickup: pickup,
      dropoff: dropoff,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      estimatedFare: FareCalculator.estimate(pickup: pickup, dropoff: dropoff),
      distanceKm: FareCalculator.distanceKm(pickup, dropoff),
      status: TripStatus.searching,
      createdAt: DateTime.now(),
    );
    _trips.add(trip);
    _emit();
    return trip;
  }

  Future<void> accept({required String tripId, required String driverId}) async {
    final i = _trips.indexWhere((t) => t.id == tripId);
    if (i < 0) throw StateError('missing trip');
    TripLifecycle.assertTransition(_trips[i].status, TripStatus.accepted);
    _trips[i] =
        _trips[i].copyWith(driverId: driverId, status: TripStatus.accepted);
    _emit();
  }

  Future<void> advance({required String tripId, required TripStatus to}) async {
    final i = _trips.indexWhere((t) => t.id == tripId);
    if (i < 0) throw StateError('missing trip');
    TripLifecycle.assertTransition(_trips[i].status, to);
    _trips[i] = _trips[i].copyWith(status: to);
    _emit();
  }

  List<Trip> searching() =>
      _trips.where((t) => t.status == TripStatus.searching).toList();

  void dispose() => _controller.close();
}
