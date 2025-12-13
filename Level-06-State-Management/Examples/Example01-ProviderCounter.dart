// Example 01: Provider Counter
// A complete counter app using Provider

// pubspec.yaml dependencies:
// provider: ^6.1.1

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ═══════════════════════════════════════════════════════════════
// STEP 1: Create the State Class (ChangeNotifier)
// ═══════════════════════════════════════════════════════════════

/// Counter state class that extends ChangeNotifier
/// This is where all our counter data and logic lives
class CounterProvider extends ChangeNotifier {
  // Private variable - only this class can directly modify it
  int _count = 0;

  // Public getter - anyone can read the count
  int get count => _count;

  // Computed property - is the count even?
  bool get isEven => _count % 2 == 0;

  // Computed property - count doubled
  int get doubled => _count * 2;

  /// Increment the counter by 1
  void increment() {
    _count++;
    notifyListeners(); // Tell all listeners: "I changed!"
  }

  /// Decrement the counter by 1 (minimum 0)
  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  /// Reset the counter to 0
  void reset() {
    _count = 0;
    notifyListeners();
  }

  /// Set counter to specific value
  void setValue(int value) {
    if (value >= 0) {
      _count = value;
      notifyListeners();
    }
  }

  /// Increment by custom amount
  void incrementBy(int amount) {
    _count += amount;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 2: Wrap App with Provider
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    // ChangeNotifierProvider makes CounterProvider available
    // to all widgets below it in the tree
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 3: Use the Provider in Widgets
// ═══════════════════════════════════════════════════════════════

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Reset button in app bar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // context.read<T>() - for calling methods (no rebuild)
              context.read<CounterProvider>().reset();
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // ─────────────────────────────────────────────
            // Method 1: Using Consumer widget
            // ─────────────────────────────────────────────
            Consumer<CounterProvider>(
              builder: (context, counter, child) {
                return Text(
                  '${counter.count}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                );
              },
            ),

            const SizedBox(height: 10),

            // ─────────────────────────────────────────────
            // Method 2: Using context.watch()
            // ─────────────────────────────────────────────
            Builder(
              builder: (context) {
                // context.watch<T>() - rebuilds when state changes
                final counter = context.watch<CounterProvider>();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      label: 'Doubled',
                      value: '${counter.doubled}',
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      label: counter.isEven ? 'Even' : 'Odd',
                      value: counter.isEven ? '✓' : '✗',
                      color: counter.isEven ? Colors.green : Colors.orange,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterProvider>().decrement();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.remove, size: 30),
                ),

                const SizedBox(width: 20),

                // Reset button
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterProvider>().reset();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Reset'),
                ),

                const SizedBox(width: 20),

                // Increment button
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterProvider>().increment();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.add, size: 30),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Quick increment buttons
            Wrap(
              spacing: 10,
              children: [
                _QuickButton(label: '+5', amount: 5),
                _QuickButton(label: '+10', amount: 10),
                _QuickButton(label: '+100', amount: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Helper Widgets
// ═══════════════════════════════════════════════════════════════

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final int amount;

  const _QuickButton({
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.read<CounterProvider>().incrementBy(amount);
      },
      child: Text(label),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. ChangeNotifier
 *    - Base class for state that can notify listeners
 *    - Call notifyListeners() after changing state
 *
 * 2. ChangeNotifierProvider
 *    - Wraps app to make state available
 *    - create: (context) => YourProvider()
 *
 * 3. context.watch<T>()
 *    - Gets state AND listens for changes
 *    - Widget rebuilds when state changes
 *    - Use in build() method for DISPLAYING data
 *
 * 4. context.read<T>()
 *    - Gets state WITHOUT listening
 *    - Widget does NOT rebuild
 *    - Use in callbacks for CALLING METHODS
 *
 * 5. Consumer<T>
 *    - Widget that rebuilds when state changes
 *    - More explicit than context.watch
 *    - Has 'child' parameter for optimization
 *
 * 6. Computed Properties
 *    - isEven, doubled - derived from _count
 *    - Calculate on-the-fly, no separate state
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a "multiply by 2" button
 * 2. Add a maximum value (can't go above 100)
 * 3. Add a history of previous values
 * 4. Add undo/redo functionality
 * 5. Save count to SharedPreferences
 *
 */
