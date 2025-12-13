// Example 05: BLoC Counter
// A complete counter app using BLoC pattern

// pubspec.yaml dependencies:
// flutter_bloc: ^8.1.3
// bloc: ^8.1.2

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ═══════════════════════════════════════════════════════════════
// EVENTS - What can happen?
// ═══════════════════════════════════════════════════════════════

/// Base event class - all events extend this
abstract class CounterEvent {}

/// Increment the counter
class Increment extends CounterEvent {}

/// Decrement the counter
class Decrement extends CounterEvent {}

/// Reset the counter to zero
class Reset extends CounterEvent {}

/// Set counter to specific value
class SetValue extends CounterEvent {
  final int value;
  SetValue(this.value);
}

/// Increment by a custom amount
class IncrementBy extends CounterEvent {
  final int amount;
  IncrementBy(this.amount);
}

// ═══════════════════════════════════════════════════════════════
// STATE - What the UI shows
// ═══════════════════════════════════════════════════════════════

/// For this simple example, state is just an int
/// For complex apps, you'd create a state class

// ═══════════════════════════════════════════════════════════════
// BLOC - The brain that processes events and emits states
// ═══════════════════════════════════════════════════════════════

class CounterBloc extends Bloc<CounterEvent, int> {
  // Constructor: super(0) sets initial state to 0
  CounterBloc() : super(0) {
    // Register event handlers
    // "When X event happens, run Y handler"

    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
    on<SetValue>(_onSetValue);
    on<IncrementBy>(_onIncrementBy);
  }

  // Event handlers
  void _onIncrement(Increment event, Emitter<int> emit) {
    emit(state + 1); // Emit new state = current state + 1
  }

  void _onDecrement(Decrement event, Emitter<int> emit) {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void _onReset(Reset event, Emitter<int> emit) {
    emit(0);
  }

  void _onSetValue(SetValue event, Emitter<int> emit) {
    if (event.value >= 0) {
      emit(event.value);
    }
  }

  void _onIncrementBy(IncrementBy event, Emitter<int> emit) {
    emit(state + event.amount);
  }
}

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    // BlocProvider makes the BLoC available to all widgets below
    BlocProvider(
      create: (context) => CounterBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN PAGE
// ═══════════════════════════════════════════════════════════════

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Add event to BLoC
              context.read<CounterBloc>().add(Reset());
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

            // ─────────────────────────────────────────────────
            // BlocBuilder - Rebuilds when state changes
            // ─────────────────────────────────────────────────
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) {
                return Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Computed values (is even, doubled)
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) {
                final isEven = count % 2 == 0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      label: 'Doubled',
                      value: '${count * 2}',
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      label: isEven ? 'Even' : 'Odd',
                      value: isEven ? '✓' : '✗',
                      color: isEven ? Colors.green : Colors.orange,
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
                // Decrement
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Decrement());
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

                // Reset
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Reset());
                  },
                  child: const Text('Reset'),
                ),

                const SizedBox(width: 20),

                // Increment
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Increment());
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

            const SizedBox(height: 20),

            // Quick increment buttons
            Wrap(
              spacing: 8,
              children: [
                _QuickButton(
                  label: '+5',
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementBy(5));
                  },
                ),
                _QuickButton(
                  label: '+10',
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementBy(10));
                  },
                ),
                _QuickButton(
                  label: '=50',
                  onPressed: () {
                    context.read<CounterBloc>().add(SetValue(50));
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ─────────────────────────────────────────────────
            // BlocListener - React to state changes (side effects)
            // ─────────────────────────────────────────────────
            BlocListener<CounterBloc, int>(
              listener: (context, count) {
                // Show snackbar when reaching milestones
                if (count == 10 || count == 50 || count == 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🎉 You reached $count!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const SizedBox(), // Listener needs a child
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
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
 * 1. Events
 *    - Represent things that happen
 *    - Increment, Decrement, Reset, SetValue, IncrementBy
 *    - Can carry data (SetValue has a value parameter)
 *
 * 2. Bloc
 *    - Extends Bloc<Event, State>
 *    - Initial state in super()
 *    - on<Event>() registers handlers
 *    - emit() sends new states
 *
 * 3. BlocProvider
 *    - Makes Bloc available to widget tree
 *    - create: (context) => YourBloc()
 *
 * 4. BlocBuilder
 *    - Rebuilds UI when state changes
 *    - builder: (context, state) => Widget
 *
 * 5. BlocListener
 *    - Reacts to state changes (side effects)
 *    - Doesn't rebuild - just listens
 *    - Good for navigation, snackbars, etc.
 *
 * 6. context.read<Bloc>().add(Event)
 *    - How to send events to Bloc
 *    - read = get without listening
 *
 * ═══════════════════════════════════════════════════════════════
 * BLOC FLOW:
 * ═══════════════════════════════════════════════════════════════
 *
 *   User taps button
 *         │
 *         ▼
 *   context.read<CounterBloc>().add(Increment())
 *         │
 *         ▼
 *   CounterBloc receives Increment event
 *         │
 *         ▼
 *   _onIncrement handler runs
 *         │
 *         ▼
 *   emit(state + 1)
 *         │
 *         ▼
 *   BlocBuilder rebuilds with new state
 *         │
 *         ▼
 *   UI shows updated count
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a MultiplyBy event
 * 2. Add max/min limits with validation
 * 3. Create a complex state class with history
 * 4. Add loading state simulation
 * 5. Implement undo/redo with event history
 *
 */
