import 'package:flutter/material.dart';

import 'driver_home_page.dart';
import 'rider_home_page.dart';

class RoleHome extends StatelessWidget {
  const RoleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Hail Starter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'One phone, two roles',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Open Rider on one simulator and Driver on another (or switch tabs). '
              'Matching is in-memory mock — perfect for learning the trip state machine.',
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RiderHomePage()),
                );
              },
              icon: const Icon(Icons.person),
              label: const Text('I am a Rider'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DriverHomePage()),
                );
              },
              icon: const Icon(Icons.local_taxi),
              label: const Text('I am a Driver'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
