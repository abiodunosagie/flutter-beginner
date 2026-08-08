import 'package:flutter/material.dart';

import '../data/mock_trip_repository.dart';
import '../domain/trip_lifecycle.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  static const driverId = 'driver-demo';
  final _repo = MockTripRepository.instance;
  String? _error;

  Future<void> _accept(String tripId) async {
    try {
      await _repo.accept(tripId: tripId, driverId: driverId);
      setState(() => _error = null);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _advance(String tripId, TripStatus to) async {
    try {
      await _repo.advance(tripId: tripId, to: to);
      setState(() => _error = null);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver')),
      body: StreamBuilder<List<Trip>>(
        stream: _repo.watch(),
        builder: (context, snap) {
          final trips = snap.data ?? [];
          final open = trips.where((t) => t.status == TripStatus.searching).toList();
          final mine = trips.where((t) => t.driverId == driverId).toList();
          final active = mine.cast<Trip?>().firstWhere(
                (t) =>
                    t != null &&
                    t.status != TripStatus.completed &&
                    t.status != TripStatus.cancelled,
                orElse: () => null,
              );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Open requests', style: Theme.of(context).textTheme.titleMedium),
              if (open.isEmpty)
                const ListTile(title: Text('No riders searching yet')),
              ...open.map(
                (t) => Card(
                  child: ListTile(
                    title: Text('${t.pickupAddress} → ${t.dropoffAddress}'),
                    subtitle: Text('\$${t.estimatedFare.toStringAsFixed(2)} · ${t.distanceKm.toStringAsFixed(1)} km'),
                    trailing: FilledButton(
                      onPressed: () => _accept(t.id),
                      child: const Text('Accept'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Active trip', style: Theme.of(context).textTheme.titleMedium),
              if (active == null)
                const ListTile(title: Text('No active trip'))
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Status: ${active.status.name}'),
                        Text('Fare: \$${active.estimatedFare.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (TripLifecycle.canTransition(active.status, TripStatus.driverArriving))
                              FilledButton(
                                onPressed: () => _advance(active.id, TripStatus.driverArriving),
                                child: const Text('Arriving'),
                              ),
                            if (TripLifecycle.canTransition(active.status, TripStatus.inProgress))
                              FilledButton(
                                onPressed: () => _advance(active.id, TripStatus.inProgress),
                                child: const Text('Start trip'),
                              ),
                            if (TripLifecycle.canTransition(active.status, TripStatus.completed))
                              FilledButton(
                                onPressed: () => _advance(active.id, TripStatus.completed),
                                child: const Text('Complete'),
                              ),
                            if (TripLifecycle.canTransition(active.status, TripStatus.cancelled))
                              OutlinedButton(
                                onPressed: () => _advance(active.id, TripStatus.cancelled),
                                child: const Text('Cancel'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
            ],
          );
        },
      ),
    );
  }
}
