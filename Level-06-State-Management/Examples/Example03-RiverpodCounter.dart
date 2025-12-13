// Example 03: Riverpod Counter
// A complete counter app using Riverpod

// pubspec.yaml dependencies:
// flutter_riverpod: ^2.4.9

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ═══════════════════════════════════════════════════════════════
// PROVIDERS (Define globally - outside any class!)
// ═══════════════════════════════════════════════════════════════

/// Simple counter using StateProvider
/// StateProvider is perfect for simple values (int, bool, String)
final counterProvider = StateProvider<int>((ref) => 0);

/// Computed value: Is the counter even?
/// Provider (without State) is for read-only/computed values
final isEvenProvider = Provider<bool>((ref) {
  // Watch the counter - this provider updates when counter changes
  final count = ref.watch(counterProvider);
  return count % 2 == 0;
});

/// Computed value: Counter doubled
final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

/// Computed value: Counter squared
final squaredProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * count;
});

/// Counter history using StateNotifier for more complex state
class CounterHistoryNotifier extends StateNotifier<List<int>> {
  CounterHistoryNotifier() : super([0]); // Start with 0 in history

  void addValue(int value) {
    // Create new list with added value (immutable update)
    state = [...state, value];
  }

  void clear() {
    state = [0];
  }

  int get lastValue => state.isNotEmpty ? state.last : 0;
}

final counterHistoryProvider =
    StateNotifierProvider<CounterHistoryNotifier, List<int>>((ref) {
  return CounterHistoryNotifier();
});

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    // ProviderScope is required at the root of your app
    // This is ALL the setup Riverpod needs!
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN PAGE (ConsumerWidget instead of StatelessWidget)
// ═══════════════════════════════════════════════════════════════

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ─────────────────────────────────────────────────────────
    // ref.watch - Listen for changes, rebuild when value changes
    // ─────────────────────────────────────────────────────────
    final count = ref.watch(counterProvider);
    final isEven = ref.watch(isEvenProvider);
    final doubled = ref.watch(doubledProvider);
    final squared = ref.watch(squaredProvider);
    final history = ref.watch(counterHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ─────────────────────────────────────────────────
              // ref.read - Get value once, don't listen
              // Use for calling methods/modifying state
              // ─────────────────────────────────────────────────
              ref.read(counterProvider.notifier).state = 0;
              ref.read(counterHistoryProvider.notifier).clear();
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Main Counter Display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Text(
                        'Counter Value',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isEven ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isEven ? 'EVEN' : 'ODD',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Computed Values
              Row(
                children: [
                  Expanded(
                    child: _ComputedCard(
                      label: 'Doubled',
                      value: doubled,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ComputedCard(
                      label: 'Squared',
                      value: squared,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrement
                  _CircleButton(
                    icon: Icons.remove,
                    color: Colors.red,
                    onPressed: () {
                      ref.read(counterProvider.notifier).state--;
                      ref.read(counterHistoryProvider.notifier)
                          .addValue(ref.read(counterProvider));
                    },
                  ),

                  const SizedBox(width: 20),

                  // Reset
                  ElevatedButton(
                    onPressed: () {
                      ref.read(counterProvider.notifier).state = 0;
                      ref.read(counterHistoryProvider.notifier).clear();
                    },
                    child: const Text('Reset'),
                  ),

                  const SizedBox(width: 20),

                  // Increment
                  _CircleButton(
                    icon: Icons.add,
                    color: Colors.green,
                    onPressed: () {
                      ref.read(counterProvider.notifier).state++;
                      ref.read(counterHistoryProvider.notifier)
                          .addValue(ref.read(counterProvider));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick buttons
              Wrap(
                spacing: 8,
                children: [
                  _QuickButton(
                    label: '+5',
                    onPressed: () {
                      ref.read(counterProvider.notifier).update((state) => state + 5);
                      ref.read(counterHistoryProvider.notifier)
                          .addValue(ref.read(counterProvider));
                    },
                  ),
                  _QuickButton(
                    label: '+10',
                    onPressed: () {
                      ref.read(counterProvider.notifier).update((state) => state + 10);
                      ref.read(counterHistoryProvider.notifier)
                          .addValue(ref.read(counterProvider));
                    },
                  ),
                  _QuickButton(
                    label: 'x2',
                    onPressed: () {
                      ref.read(counterProvider.notifier).update((state) => state * 2);
                      ref.read(counterHistoryProvider.notifier)
                          .addValue(ref.read(counterProvider));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // History Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${history.length} values',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: history.reversed.take(20).map((value) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '$value',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

class _ComputedCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ComputedCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: const CircleBorder(),
      ),
      child: Icon(icon, size: 30),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _QuickButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. ProviderScope
 *    - Wraps the entire app
 *    - Required for Riverpod to work
 *    - Simpler than Provider setup!
 *
 * 2. StateProvider
 *    - For simple mutable values
 *    - Access state: ref.watch(provider)
 *    - Modify state: ref.read(provider.notifier).state = newValue
 *    - Update based on current: ref.read(provider.notifier).update((s) => s + 1)
 *
 * 3. Provider (computed/read-only)
 *    - For derived/computed values
 *    - Automatically updates when dependencies change
 *    - isEvenProvider depends on counterProvider
 *
 * 4. StateNotifierProvider
 *    - For complex state with methods
 *    - Like ChangeNotifier but immutable
 *    - Access notifier: ref.read(provider.notifier)
 *
 * 5. ConsumerWidget
 *    - Replaces StatelessWidget
 *    - build() receives WidgetRef ref
 *    - Use ref.watch and ref.read
 *
 * 6. ref.watch vs ref.read
 *    - watch: Listen and rebuild on change (in build)
 *    - read: Get value once, no listening (in callbacks)
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add min/max limits
 * 2. Add undo functionality using history
 * 3. Persist counter value to SharedPreferences
 * 4. Add animations when value changes
 * 5. Create a second counter that's independent
 *
 */
