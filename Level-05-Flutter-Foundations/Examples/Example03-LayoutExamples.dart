// Example 3: Layout Examples
// Understanding Row, Column, Stack, and more

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layout Examples',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const LayoutShowcase(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LayoutShowcase extends StatelessWidget {
  const LayoutShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Layout Examples'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Row'),
              Tab(text: 'Column'),
              Tab(text: 'Stack'),
              Tab(text: 'Expanded'),
              Tab(text: 'Patterns'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RowExamples(),
            ColumnExamples(),
            StackExamples(),
            ExpandedExamples(),
            LayoutPatterns(),
          ],
        ),
      ),
    );
  }
}

// ROW EXAMPLES
class RowExamples extends StatelessWidget {
  const RowExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Row
          const Text(
            'Basic Row:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            child: Row(
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MainAxisAlignment.start
          const Text(
            'MainAxisAlignment.start (default):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MainAxisAlignment.center
          const Text(
            'MainAxisAlignment.center:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MainAxisAlignment.end
          const Text(
            'MainAxisAlignment.end:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MainAxisAlignment.spaceBetween
          const Text(
            'MainAxisAlignment.spaceBetween:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MainAxisAlignment.spaceEvenly
          const Text(
            'MainAxisAlignment.spaceEvenly:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MainAxisAlignment.spaceAround
          const Text(
            'MainAxisAlignment.spaceAround:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _colorBox(Colors.red, 'A'),
                _colorBox(Colors.green, 'B'),
                _colorBox(Colors.blue, 'C'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// COLUMN EXAMPLES
class ColumnExamples extends StatelessWidget {
  const ColumnExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CrossAxisAlignment examples
          const Text(
            'CrossAxisAlignment in Column:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CrossAxisAlignment.start
              Expanded(
                child: Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('start', style: TextStyle(fontSize: 10)),
                      _smallBox(Colors.red),
                      _smallBox(Colors.green),
                      _smallBox(Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // CrossAxisAlignment.center
              Expanded(
                child: Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('center', style: TextStyle(fontSize: 10)),
                      _smallBox(Colors.red),
                      _smallBox(Colors.green),
                      _smallBox(Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // CrossAxisAlignment.end
              Expanded(
                child: Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('end', style: TextStyle(fontSize: 10)),
                      _smallBox(Colors.red),
                      _smallBox(Colors.green),
                      _smallBox(Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // CrossAxisAlignment.stretch
              Expanded(
                child: Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('stretch', style: TextStyle(fontSize: 10)),
                      Container(height: 30, color: Colors.red),
                      const SizedBox(height: 4),
                      Container(height: 30, color: Colors.green),
                      const SizedBox(height: 4),
                      Container(height: 30, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // MainAxisSize
          const Text(
            'MainAxisSize:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MainAxisSize.max
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text('max (fills parent)'),
                      _smallBox(Colors.red),
                      _smallBox(Colors.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // MainAxisSize.min
              Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('min (wraps content)'),
                    _smallBox(Colors.red),
                    _smallBox(Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// STACK EXAMPLES
class StackExamples extends StatelessWidget {
  const StackExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Stack
          const Text(
            'Basic Stack (overlapping):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                Container(width: 150, height: 150, color: Colors.red),
                Container(width: 120, height: 120, color: Colors.green),
                Container(width: 90, height: 90, color: Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stack with alignment
          const Text(
            'Stack with alignment:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 120, height: 120, color: Colors.red),
                Container(width: 80, height: 80, color: Colors.green),
                Container(width: 40, height: 40, color: Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stack with Positioned
          const Text(
            'Stack with Positioned:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(width: 50, height: 50, color: Colors.red),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(width: 50, height: 50, color: Colors.green),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(width: 50, height: 50, color: Colors.blue),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(width: 50, height: 50, color: Colors.orange),
                ),
                const Center(
                  child: Text('Center', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Practical Example: Profile with badge
          const Text(
            'Practical: Avatar with badge',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// EXPANDED EXAMPLES
class ExpandedExamples extends StatelessWidget {
  const ExpandedExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // One Expanded
          const Text(
            'One Expanded (fills remaining):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Row(
              children: [
                Container(width: 50, color: Colors.red),
                Expanded(child: Container(color: Colors.green)),
                Container(width: 50, color: Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Equal Expanded
          const Text(
            'Equal Expanded (flex: 1 each):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(child: Container(color: Colors.red)),
                Expanded(child: Container(color: Colors.green)),
                Expanded(child: Container(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Different flex values
          const Text(
            'Different flex values (2:1:1):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.red,
                    child: const Center(child: Text('flex: 2')),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green,
                    child: const Center(child: Text('flex: 1')),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                    child: const Center(child: Text('flex: 1')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Expanded vs Flexible
          const Text(
            'Expanded vs Flexible:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Expanded (always fills):'),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: const Text('Expanded'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Flexible (can be smaller):'),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    color: Colors.green,
                    child: const Text('Flexible'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Expanded in Column
          const Text(
            'Expanded in Column:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            color: Colors.grey[200],
            child: Column(
              children: [
                Container(
                  height: 40,
                  color: Colors.red,
                  child: const Center(child: Text('Fixed Header')),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    child: const Center(child: Text('Expanded Content')),
                  ),
                ),
                Container(
                  height: 40,
                  color: Colors.blue,
                  child: const Center(child: Text('Fixed Footer')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// COMMON LAYOUT PATTERNS
class LayoutPatterns extends StatelessWidget {
  const LayoutPatterns({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pattern 1: Profile Row
          const Text(
            'Pattern: Profile Row',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'john@example.com',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Pattern 2: Icon + Label Row
          const Text(
            'Pattern: Icon + Label',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 8),
              Text('123 Main Street, City'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.phone, color: Colors.green),
              SizedBox(width: 8),
              Text('+1 234 567 8900'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.email, color: Colors.blue),
              SizedBox(width: 8),
              Text('contact@example.com'),
            ],
          ),
          const SizedBox(height: 24),

          // Pattern 3: Action Bar
          const Text(
            'Pattern: Action Bar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(height: 4),
                    Text('Like'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(height: 4),
                    Text('Comment'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.share),
                    SizedBox(height: 4),
                    Text('Share'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pattern 4: Stats Row
          const Text(
            'Pattern: Stats Row',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '254',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Posts', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text(
                    '12.4K',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Followers', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text(
                    '867',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Following', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pattern 5: Form Field Row
          const Text(
            'Pattern: Label + Input',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(
                width: 80,
                child: Text('Name:'),
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper function for colored boxes
Widget _colorBox(Color color, String label) {
  return Container(
    width: 50,
    height: 50,
    color: color,
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _smallBox(Color color) {
  return Container(
    width: 40,
    height: 30,
    margin: const EdgeInsets.all(2),
    color: color,
  );
}

/*
 * KEY CONCEPTS:
 *
 * 1. Row Widget
 *    - Horizontal layout
 *    - mainAxisAlignment: horizontal alignment
 *    - crossAxisAlignment: vertical alignment
 *
 * 2. Column Widget
 *    - Vertical layout
 *    - mainAxisAlignment: vertical alignment
 *    - crossAxisAlignment: horizontal alignment
 *
 * 3. Stack Widget
 *    - Overlapping widgets
 *    - Use Positioned for exact placement
 *    - Great for badges, overlays
 *
 * 4. Expanded Widget
 *    - Fills remaining space
 *    - flex property for proportions
 *    - Must be child of Row, Column, or Flex
 *
 * 5. Flexible Widget
 *    - Can expand but doesn't have to
 *    - Use when content size matters
 *
 * EXERCISES:
 * 1. Create a card with image, title, and description
 * 2. Build a navigation bar with icons
 * 3. Make a profile header with avatar and stats
 * 4. Create a two-column layout
 */
