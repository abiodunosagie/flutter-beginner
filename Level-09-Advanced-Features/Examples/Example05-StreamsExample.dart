// Example 05: Streams Example
// Real-time data with Streams and StreamBuilder

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streams Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const StreamDemoPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STREAM DEMO PAGE
// ═══════════════════════════════════════════════════════════════

class StreamDemoPage extends StatefulWidget {
  const StreamDemoPage({super.key});

  @override
  State<StreamDemoPage> createState() => _StreamDemoPageState();
}

class _StreamDemoPageState extends State<StreamDemoPage> {
  // ─────────────────────────────────────────────────────────────
  // EXAMPLE 1: Simple Countdown Stream
  // Like a kitchen timer counting down!
  // ─────────────────────────────────────────────────────────────

  Stream<int> countdownStream(int start) async* {
    for (int i = start; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      yield i; // Send this number to whoever is listening
    }
  }

  // ─────────────────────────────────────────────────────────────
  // EXAMPLE 2: Stock Price Stream (Simulated)
  // Like watching stock prices change in real-time!
  // ─────────────────────────────────────────────────────────────

  late StreamController<double> _stockController;
  Timer? _stockTimer;
  double _currentPrice = 150.00;

  void _startStockUpdates() {
    _stockController = StreamController<double>.broadcast();

    // Simulate price changes every 2 seconds
    _stockTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Random price change between -5 and +5
      final change = (DateTime.now().millisecond % 11) - 5;
      _currentPrice += change;
      if (_currentPrice < 100) _currentPrice = 100;
      if (_currentPrice > 200) _currentPrice = 200;

      _stockController.add(_currentPrice);
    });
  }

  // ─────────────────────────────────────────────────────────────
  // EXAMPLE 3: Message Stream (Like a chat!)
  // ─────────────────────────────────────────────────────────────

  final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _messageController.add(message);
      _textController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _startStockUpdates();

    // Listen to messages and add to list
    _messageController.stream.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    _stockTimer?.cancel();
    _stockController.close();
    _messageController.close();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Streams Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer), text: 'Countdown'),
              Tab(icon: Icon(Icons.trending_up), text: 'Stock'),
              Tab(icon: Icon(Icons.chat), text: 'Chat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCountdownTab(),
            _buildStockTab(),
            _buildChatTab(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TAB 1: COUNTDOWN
  // ─────────────────────────────────────────────────────────────

  Widget _buildCountdownTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Countdown Timer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Watch the stream emit values!',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // StreamBuilder - Listens to a stream and rebuilds when data arrives
          StreamBuilder<int>(
            stream: countdownStream(10), // Start from 10
            builder: (context, snapshot) {
              // Handle different states
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Done!',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
              }

              // Show the current countdown value
              return Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal.shade100,
                      border: Border.all(color: Colors.teal, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        '${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'seconds remaining',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // Explanation
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('1. Stream emits numbers: 10, 9, 8...'),
                Text('2. StreamBuilder listens'),
                Text('3. UI rebuilds with each new number'),
                Text('4. Stream completes when done'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TAB 2: STOCK PRICES
  // ─────────────────────────────────────────────────────────────

  Widget _buildStockTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'AAPL Stock Price',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Updates every 2 seconds (simulated)',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // StreamBuilder for stock prices
          StreamBuilder<double>(
            stream: _stockController.stream,
            initialData: _currentPrice,
            builder: (context, snapshot) {
              final price = snapshot.data ?? 150.0;
              final isUp = price >= 150;

              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                            color: isUp ? Colors.green : Colors.red,
                            size: 48,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isUp ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isUp
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isUp ? 'Above Average' : 'Below Average',
                          style: TextStyle(
                            color: isUp ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Explanation
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Real-world uses:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('- Live stock prices'),
                Text('- Cryptocurrency rates'),
                Text('- Sports scores'),
                Text('- Weather updates'),
                Text('- Live location tracking'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TAB 3: CHAT (USER-GENERATED STREAM)
  // ─────────────────────────────────────────────────────────────

  Widget _buildChatTab() {
    return Column(
      children: [
        // Message list
        Expanded(
          child: _messages.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Send a message below!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _messages[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Info box
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Each message is added to a Stream, '
                  'then the listener updates the UI!',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // Message input
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () => _sendMessage(_textController.text),
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. What is a Stream?
 *    - Like a conveyor belt that delivers data over time
 *    - Data comes piece by piece, not all at once
 *    - Perfect for: real-time updates, user events, timers
 *
 * 2. Creating Streams
 *
 *    Method 1 - async* and yield:
 *    ```dart
 *    Stream<int> countDown(int from) async* {
 *      for (int i = from; i >= 0; i--) {
 *        await Future.delayed(Duration(seconds: 1));
 *        yield i;  // Emit this value
 *      }
 *    }
 *    ```
 *
 *    Method 2 - StreamController:
 *    ```dart
 *    final controller = StreamController<String>();
 *    controller.add('Hello');  // Add data
 *    controller.stream;        // Get the stream
 *    controller.close();       // Close when done
 *    ```
 *
 * 3. StreamBuilder Widget
 *    - Listens to a stream
 *    - Rebuilds UI when new data arrives
 *    - Handles: waiting, data, error, done states
 *
 *    ```dart
 *    StreamBuilder<int>(
 *      stream: myStream,
 *      builder: (context, snapshot) {
 *        if (snapshot.hasData) {
 *          return Text('${snapshot.data}');
 *        }
 *        return CircularProgressIndicator();
 *      },
 *    )
 *    ```
 *
 * 4. Stream vs Future
 *
 *    Future:
 *    - One value, one time
 *    - Like ordering pizza - you wait, get one pizza
 *
 *    Stream:
 *    - Multiple values over time
 *    - Like a pizza subscription - pizzas keep coming!
 *
 * ═══════════════════════════════════════════════════════════════
 * STREAM STATES:
 * ═══════════════════════════════════════════════════════════════
 *
 * ConnectionState.none     - No stream yet
 * ConnectionState.waiting  - Waiting for first data
 * ConnectionState.active   - Receiving data
 * ConnectionState.done     - Stream finished
 *
 * ═══════════════════════════════════════════════════════════════
 * COMMON STREAM METHODS:
 * ═══════════════════════════════════════════════════════════════
 *
 * stream.listen()   - Subscribe to stream
 * stream.map()      - Transform each value
 * stream.where()    - Filter values
 * stream.take(n)    - Only take first n values
 * stream.skip(n)    - Skip first n values
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Create a stream that emits random colors
 * 2. Build a live search with debouncing
 * 3. Create a Pomodoro timer with streams
 * 4. Build a typing indicator for chat
 * 5. Implement infinite scroll with streams
 *
 */
