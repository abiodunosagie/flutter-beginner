// Example 4: StatefulWidget Counter
// Understanding state and interactivity

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Counter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CounterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// EXAMPLE 1: Simple Counter
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // State variable - this can change!
  int _counter = 0;

  // Method to increment counter
  void _incrementCounter() {
    setState(() {
      // setState tells Flutter to rebuild the widget
      _counter++;
    });
  }

  // Method to decrement counter
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  // Method to reset counter
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Display the counter
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const SizedBox(height: 40),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton(
                  onPressed: _decrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),

                // Reset button
                ElevatedButton(
                  onPressed: _resetCounter,
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
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // More examples
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoreExamples(),
                  ),
                );
              },
              child: const Text('See More Examples'),
            ),
          ],
        ),
      ),
    );
  }
}

// More Examples Page
class MoreExamples extends StatelessWidget {
  const MoreExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More State Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Toggle Example
          ExampleCard(
            title: '1. Toggle Switch',
            child: ToggleExample(),
          ),
          SizedBox(height: 16),

          // Favorite Example
          ExampleCard(
            title: '2. Favorite Button',
            child: FavoriteExample(),
          ),
          SizedBox(height: 16),

          // Text Input Example
          ExampleCard(
            title: '3. Text Input',
            child: TextInputExample(),
          ),
          SizedBox(height: 16),

          // List Example
          ExampleCard(
            title: '4. Dynamic List',
            child: ListExample(),
          ),
          SizedBox(height: 16),

          // Multi-State Example
          ExampleCard(
            title: '5. Multiple States',
            child: MultiStateExample(),
          ),
        ],
      ),
    );
  }
}

// Card wrapper for examples
class ExampleCard extends StatelessWidget {
  final String title;
  final Widget child;

  const ExampleCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// EXAMPLE 2: Toggle Switch
class ToggleExample extends StatefulWidget {
  const ToggleExample({super.key});

  @override
  State<ToggleExample> createState() => _ToggleExampleState();
}

class _ToggleExampleState extends State<ToggleExample> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _isOn ? 'Notifications: ON' : 'Notifications: OFF',
          style: const TextStyle(fontSize: 16),
        ),
        Switch(
          value: _isOn,
          onChanged: (value) {
            setState(() {
              _isOn = value;
            });
          },
        ),
      ],
    );
  }
}

// EXAMPLE 3: Favorite Button
class FavoriteExample extends StatefulWidget {
  const FavoriteExample({super.key});

  @override
  State<FavoriteExample> createState() => _FavoriteExampleState();
}

class _FavoriteExampleState extends State<FavoriteExample> {
  bool _isFavorite = false;
  int _likeCount = 42;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _likeCount += _isFavorite ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _toggleFavorite,
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.grey,
            size: 32,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$_likeCount likes',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

// EXAMPLE 4: Text Input
class TextInputExample extends StatefulWidget {
  const TextInputExample({super.key});

  @override
  State<TextInputExample> createState() => _TextInputExampleState();
}

class _TextInputExampleState extends State<TextInputExample> {
  final _controller = TextEditingController();
  String _displayText = 'Type something...';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  void _updateText() {
    setState(() {
      _displayText = _controller.text.isEmpty
          ? 'Type something...'
          : 'You typed: ${_controller.text}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Enter text',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.edit),
          ),
          onChanged: (value) {
            setState(() {
              _displayText = value.isEmpty
                  ? 'Type something...'
                  : 'You typed: $value';
            });
          },
        ),
        const SizedBox(height: 12),
        Text(
          _displayText,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// EXAMPLE 5: Dynamic List
class ListExample extends StatefulWidget {
  const ListExample({super.key});

  @override
  State<ListExample> createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  void _addItem() {
    setState(() {
      _items.add('Item ${_items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _addItem,
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ),
        const SizedBox(height: 12),
        ..._items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeItem(index),
              ),
            ),
          );
        }),
        if (_items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No items. Click "Add Item" to start.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

// EXAMPLE 6: Multiple States
class MultiStateExample extends StatefulWidget {
  const MultiStateExample({super.key});

  @override
  State<MultiStateExample> createState() => _MultiStateExampleState();
}

class _MultiStateExampleState extends State<MultiStateExample> {
  int _counter = 0;
  bool _isVisible = true;
  String _selectedColor = 'Blue';
  final List<String> _colors = ['Blue', 'Red', 'Green', 'Purple'];

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      switch (_selectedColor) {
        case 'Red':
          return Colors.red;
        case 'Green':
          return Colors.green;
        case 'Purple':
          return Colors.purple;
        default:
          return Colors.blue;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Counter:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _counter--),
                  icon: const Icon(Icons.remove),
                ),
                Text('$_counter', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () => setState(() => _counter++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        const Divider(),

        // Visibility toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Show Box:', style: TextStyle(fontSize: 16)),
            Switch(
              value: _isVisible,
              onChanged: (value) {
                setState(() {
                  _isVisible = value;
                });
              },
            ),
          ],
        ),
        const Divider(),

        // Color selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Color:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedColor,
              items: _colors.map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Preview
        if (_isVisible)
          Center(
            child: Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                color: getColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Count: $_counter',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        else
          const Center(
            child: Text(
              'Box is hidden',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

/*
 * KEY CONCEPTS:
 *
 * 1. StatefulWidget
 *    - Has two classes: Widget and State
 *    - Widget is immutable configuration
 *    - State holds mutable data
 *
 * 2. State Class
 *    - Extends State<YourWidget>
 *    - Contains mutable variables
 *    - Has build() method
 *
 * 3. setState()
 *    - Must be called to update UI
 *    - Takes a callback function
 *    - Triggers rebuild of widget
 *
 * 4. Lifecycle
 *    - initState(): Called once when created
 *    - build(): Called to render UI
 *    - dispose(): Called when removed (cleanup)
 *
 * 5. Controllers
 *    - TextEditingController for text input
 *    - Must be disposed in dispose()
 *    - Manage text field state
 *
 * 6. Accessing Widget Properties
 *    - Use widget.propertyName
 *    - Properties come from parent widget
 *
 * COMMON PATTERNS:
 *
 * 1. Toggle Pattern
 *    bool isOn = false;
 *    setState(() => isOn = !isOn);
 *
 * 2. Counter Pattern
 *    int count = 0;
 *    setState(() => count++);
 *
 * 3. List Pattern
 *    List<String> items = [];
 *    setState(() => items.add('new'));
 *
 * 4. Input Pattern
 *    final controller = TextEditingController();
 *    Don't forget to dispose!
 *
 * EXERCISES:
 * 1. Create a color picker that changes background
 * 2. Build a todo list with add/remove
 * 3. Make a temperature converter (C to F)
 * 4. Create a simple calculator
 * 5. Build a timer that counts seconds
 */
