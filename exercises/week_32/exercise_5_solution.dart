/// Week 32, Exercise 5: Production-Ready State Architecture
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const ProductionApp());
}

class ProductionApp extends StatelessWidget {
  const ProductionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Production App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Production State Management')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ArchitectureCard(
            title: 'State Management',
            icon: Icons.architecture,
            items: [
              'Riverpod for dependency injection',
              'StateNotifier for complex state',
              'AsyncNotifier for API calls',
              'Family modifiers for parameterized data',
            ],
          ),
          _ArchitectureCard(
            title: 'Error Handling',
            icon: Icons.error_outline,
            items: [
              'Global error boundary',
              'Retry mechanisms',
              'User-friendly error messages',
              'Error logging/reporting',
            ],
          ),
          _ArchitectureCard(
            title: 'Performance',
            icon: Icons.speed,
            items: [
              'Optimistic updates',
              'Data caching',
              'Selective rebuilds',
              'Code splitting',
            ],
          ),
          _ArchitectureCard(
            title: 'Offline Support',
            icon: Icons.cloud_off,
            items: [
              'Local data persistence',
              'Sync queue for offline changes',
              'Conflict resolution',
              'Network status monitoring',
            ],
          ),
          _ArchitectureCard(
            title: 'Best Practices',
            icon: Icons.check_circle,
            items: [
              'Separation of concerns',
              'Testable architecture',
              'Type safety',
              'Immutable state',
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;

  const _ArchitectureCard({
    required this.title,
    required this.icon,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepOrange),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 20, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

/*
Complete Production Architecture:

lib/
  core/
    providers/
      app_providers.dart      # Global providers
    services/
      api_service.dart        # API abstraction
      storage_service.dart    # Local storage
    models/
      user.dart               # Data models
      app_state.dart          # App-level state
  features/
    auth/
      providers/
        auth_provider.dart
      screens/
        login_screen.dart
    todos/
      providers/
        todos_provider.dart
      screens/
        todos_screen.dart
  main.dart

Key Patterns:

1. Provider Organization:
   - Feature-based providers
   - Global app state
   - Service providers

2. Error Handling:
   - Try-catch in providers
   - Error state in StateNotifier
   - Global error handler

3. State Updates:
   - Immutable state
   - Optimistic UI updates
   - Rollback on error

4. Persistence:
   - Save on state change
   - Load on provider init
   - Background sync

5. Testing:
   - Mock providers
   - Provider overrides
   - Integration tests
*/
