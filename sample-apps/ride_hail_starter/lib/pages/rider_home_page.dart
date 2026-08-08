import 'package:flutter/material.dart';

import '../data/mock_trip_repository.dart';
import '../domain/fare_calculator.dart';
import '../domain/trip_lifecycle.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  static const riderId = 'rider-demo';
  final _repo = MockTripRepository.instance;

  // Demo coordinates (Lagos-ish)
  static const pickup = GeoPointLite(6.5244, 3.3792);
  static const dropoff = GeoPointLite(6.4654, 3.4064);

  Trip? _active;
  String? _error;
  bool _busy = false;

  Future<void> _request() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final trip = await _repo.requestRide(
        riderId: riderId,
        pickup: pickup,
        dropoff: dropoff,
        pickupAddress: 'Pickup: Island',
        dropoffAddress: 'Dropoff: Mainland',
      );
      setState(() => _active = trip);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _cancel() async {
    final trip = _active;
    if (trip == null) return;
    try {
      await _repo.advance(tripId: trip.id, to: TripStatus.cancelled);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fare = FareCalculator.estimate(pickup: pickup, dropoff: dropoff);
    final km = FareCalculator.distanceKm(pickup, dropoff);

    return Scaffold(
      appBar: AppBar(title: const Text('Rider')),
      body: StreamBuilder<List<Trip>>(
        stream: _repo.watch(),
        builder: (context, snap) {
          final trips = snap.data ?? [];
          final mine = trips.where((t) => t.riderId == riderId).toList();
          final current = mine.cast<Trip?>().firstWhere(
                (t) =>
                    t != null &&
                    t.status != TripStatus.completed &&
                    t.status != TripStatus.cancelled,
                orElse: () => null,
              );
          final active = current ?? _active;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Island → Mainland'),
                  subtitle: Text('${km.toStringAsFixed(1)} km · est. \$${fare.toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 12),
              if (active == null)
                FilledButton(
                  onPressed: _busy ? null : _request,
                  child: Text(_busy ? 'Requesting…' : 'Request ride'),
                )
              else ...[
                _StatusCard(trip: active),
                const SizedBox(height: 8),
                if (TripLifecycle.canTransition(active.status, TripStatus.cancelled))
                  OutlinedButton(
                    onPressed: _cancel,
                    child: const Text('Cancel ride'),
                  ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              Text('Your trips', style: Theme.of(context).textTheme.titleMedium),
              ...mine.map(
                (t) => ListTile(
                  dense: true,
                  title: Text(t.status.name),
                  subtitle: Text('Fare \$${t.estimatedFare.toStringAsFixed(2)} · ${t.id}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${trip.status.name}', style: Theme.of(context).textTheme.titleMedium),
            Text('Driver: ${trip.driverId ?? 'searching…'}'),
            Text('Fare: \$${trip.estimatedFare.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
