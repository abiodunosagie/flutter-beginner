# Streams Explained: Real-Time Data Flow

## The Simple Explanation

Remember Futures? A Future is like ordering **one pizza** - you wait, you get it, done!

A Stream is like a **pizza subscription** - pizzas keep coming every week, as long as you're subscribed!

```
FUTURE (One-time delivery):
┌─────────────────────────────────────────┐
│                                         │
│   Order ──────────► 🍕 (one pizza)     │
│                                         │
│   Done! No more pizzas.                 │
│                                         │
└─────────────────────────────────────────┘

STREAM (Ongoing subscription):
┌─────────────────────────────────────────┐
│                                         │
│   Subscribe ────► 🍕 (week 1)          │
│              ────► 🍕 (week 2)          │
│              ────► 🍕 (week 3)          │
│              ────► 🍕 (week 4)          │
│              ────► ...keeps coming!     │
│                                         │
│   Unsubscribe to stop!                  │
│                                         │
└─────────────────────────────────────────┘
```

**A Stream is a sequence of values over time!**

---

## Real-Life Stream Examples

Think about things that give you data continuously:

```
┌─────────────────────────────────────────────────────────┐
│                   STREAMS IN REAL LIFE                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  📺 TV Channel                                           │
│     → Images keep coming until you change channel        │
│                                                          │
│  🎵 Music Streaming                                      │
│     → Song data keeps flowing until you pause            │
│                                                          │
│  💬 Chat Messages                                        │
│     → New messages arrive whenever someone sends one     │
│                                                          │
│  📍 GPS Location                                         │
│     → Position updates as you move                       │
│                                                          │
│  ⏱️ Stopwatch                                            │
│     → Seconds tick by continuously                       │
│                                                          │
│  🌡️ Temperature Sensor                                   │
│     → Readings update every few seconds                  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Future vs Stream: The Difference

| Feature | Future | Stream |
|---------|--------|--------|
| How many values? | ONE | MANY (over time) |
| When does it end? | After delivering value | When you close it |
| Use case | Single request | Continuous updates |
| Example | Fetch user profile | Real-time chat |
| Widget | FutureBuilder | StreamBuilder |

```
Future<int>     → Returns ONE integer, then done
Stream<int>     → Returns MANY integers over time

Future<String>  → One message
Stream<String>  → Chat messages as they arrive

Future<Location> → Current location once
Stream<Location> → Location updates as you move
```

---

## Creating Streams

### Way 1: Stream.periodic (Timer-like)

```dart
// Emits a value every second
Stream<int> countStream() {
  return Stream.periodic(
    const Duration(seconds: 1),
    (count) => count,  // 0, 1, 2, 3, ...
  );
}
```

### Way 2: async* and yield

```dart
// yield = give out one value
Stream<int> countUp(int max) async* {
  for (int i = 0; i <= max; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;  // Send this value to listeners
  }
}

// Usage:
countUp(5);  // Emits: 0, 1, 2, 3, 4, 5 (one per second)
```

### Way 3: StreamController

```dart
// Create a controller
final controller = StreamController<String>();

// Send values into the stream
controller.sink.add('Hello');
controller.sink.add('World');

// Listen to values
controller.stream.listen((value) {
  print('Got: $value');
});

// Don't forget to close when done!
controller.close();
```

---

## Listening to Streams

### Method 1: listen()

```dart
Stream<int> numbers = countStream();

// Subscribe to the stream
numbers.listen(
  (value) {
    print('Got number: $value');
  },
  onError: (error) {
    print('Error: $error');
  },
  onDone: () {
    print('Stream finished!');
  },
);
```

### Method 2: await for

```dart
Future<void> printNumbers() async {
  Stream<int> numbers = countStream();

  await for (int number in numbers) {
    print('Got number: $number');
  }

  print('Stream finished!');
}
```

### Visual: How Listening Works

```
Stream:      ──[1]──[2]──[3]──[4]──[done]──►

             ↓    ↓    ↓    ↓    ↓
listen():   Got 1 Got 2 Got 3 Got 4 Stream finished!
```

---

## StreamBuilder: Streams in Widgets

Just like FutureBuilder, but for streams:

```dart
class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  Stream<int> countStream() {
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => count,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: countStream(),
      builder: (context, snapshot) {
        // Check connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Starting...');
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Show the latest value
        return Text(
          'Count: ${snapshot.data}',
          style: const TextStyle(fontSize: 48),
        );
      },
    );
  }
}
```

### Snapshot States for Streams

```
ConnectionState for Streams:
┌─────────────────────────────────────────────────┐
│                                                 │
│  .waiting  ──► No data yet (initial state)      │
│                                                 │
│  .active   ──► Stream is open, data flowing     │
│                                                 │
│  .done     ──► Stream closed, no more data      │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Practical Example: Chat Messages

```dart
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Controller to add messages
  final _messagesController = StreamController<String>.broadcast();

  // Text controller for input
  final _textController = TextEditingController();

  // Store messages
  final List<String> _messages = [];

  void _sendMessage() {
    final message = _textController.text;
    if (message.isNotEmpty) {
      _messagesController.sink.add(message);
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _messagesController.close();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<String>(
              stream: _messagesController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _messages.add(snapshot.data!);
                }

                return ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_messages[index]),
                    );
                  },
                );
              },
            ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Stream Transformations

You can transform streams like you transform lists:

### map - Transform each value

```dart
Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

// Double each number
Stream<int> doubled = numbers.map((n) => n * 2);
// Emits: 2, 4, 6, 8, 10
```

### where - Filter values

```dart
Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

// Only even numbers
Stream<int> evens = numbers.where((n) => n % 2 == 0);
// Emits: 2, 4
```

### take - Take first N values

```dart
Stream<int> numbers = countStream();  // 0, 1, 2, 3, 4, ...

// Only first 5
Stream<int> first5 = numbers.take(5);
// Emits: 0, 1, 2, 3, 4 (then done)
```

### Visual: Transformations

```
Original:    ──[1]──[2]──[3]──[4]──[5]──►

.map(x*2):   ──[2]──[4]──[6]──[8]──[10]──►

.where(even):──────[2]──────[4]──────────►

.take(3):    ──[1]──[2]──[3]──(done)
```

---

## Single vs Broadcast Streams

### Single Subscription Stream

Only ONE listener allowed:

```dart
// Creates single subscription stream
final controller = StreamController<int>();

// First listener - OK!
controller.stream.listen((data) => print('Listener 1: $data'));

// Second listener - ERROR!
controller.stream.listen((data) => print('Listener 2: $data'));
// Bad state: Stream has already been listened to
```

### Broadcast Stream

Multiple listeners allowed:

```dart
// Creates broadcast stream
final controller = StreamController<int>.broadcast();

// First listener - OK!
controller.stream.listen((data) => print('Listener 1: $data'));

// Second listener - Also OK!
controller.stream.listen((data) => print('Listener 2: $data'));

controller.sink.add(42);
// Output:
// Listener 1: 42
// Listener 2: 42
```

### When to Use What?

```
Single Subscription:
• File reading
• HTTP responses
• One-time data flow

Broadcast:
• UI updates
• Events that multiple widgets need
• User input streams
```

---

## StreamController: Controlling Your Stream

Think of StreamController like a TV remote + TV:

```dart
class StreamController<T> {
  // The SINK - where you PUT data (like changing channel)
  Sink<T> sink;

  // The STREAM - where data COMES OUT (like watching TV)
  Stream<T> stream;
}
```

### Usage Pattern

```dart
class DataService {
  // Create controller
  final _controller = StreamController<String>.broadcast();

  // Expose only the stream (read-only)
  Stream<String> get dataStream => _controller.stream;

  // Method to add data
  void addData(String data) {
    _controller.sink.add(data);
  }

  // Method to add error
  void addError(String error) {
    _controller.sink.addError(error);
  }

  // Don't forget to dispose!
  void dispose() {
    _controller.close();
  }
}

// Usage:
final service = DataService();

service.dataStream.listen((data) {
  print('Got: $data');
});

service.addData('Hello');  // Prints: Got: Hello
service.addData('World');  // Prints: Got: World
```

---

## Real-World Example: Countdown Timer

```dart
class CountdownTimer extends StatefulWidget {
  final int seconds;

  const CountdownTimer({super.key, required this.seconds});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = _createCountdown();
  }

  Stream<int> _createCountdown() async* {
    for (int i = widget.seconds; i >= 0; i--) {
      yield i;
      if (i > 0) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Starting...');
        }

        final remaining = snapshot.data!;

        if (remaining == 0) {
          return const Text(
            'Time\'s up!',
            style: TextStyle(
              fontSize: 48,
              color: Colors.red,
            ),
          );
        }

        return Text(
          '$remaining',
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

// Usage:
CountdownTimer(seconds: 10)  // Counts: 10, 9, 8, ... 1, 0, Time's up!
```

---

## Common Mistakes

### Mistake 1: Not Closing Streams

```dart
// ❌ WRONG: Memory leak!
class MyWidget extends StatefulWidget { ... }

class _MyWidgetState extends State<MyWidget> {
  final _controller = StreamController<int>();

  @override
  void dispose() {
    // Forgot to close controller!
    super.dispose();
  }
}

// ✅ CORRECT: Always close!
@override
void dispose() {
  _controller.close();  // Close the controller
  super.dispose();
}
```

### Mistake 2: Creating Stream in build()

```dart
// ❌ WRONG: Creates new stream every rebuild
Widget build(BuildContext context) {
  return StreamBuilder(
    stream: countStream(),  // New stream every time!
    builder: (context, snapshot) { ... },
  );
}

// ✅ CORRECT: Create in initState
late Stream<int> _stream;

@override
void initState() {
  super.initState();
  _stream = countStream();  // Created once
}

Widget build(BuildContext context) {
  return StreamBuilder(
    stream: _stream,  // Same stream
    builder: (context, snapshot) { ... },
  );
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│                   STREAMS SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: A sequence of values over time                    │
│        (like a pizza subscription vs one pizza)          │
│                                                          │
│  VS FUTURE:                                              │
│  • Future = ONE value later                              │
│  • Stream = MANY values over time                        │
│                                                          │
│  CREATING:                                               │
│  • Stream.periodic - Emit values at intervals            │
│  • async* + yield - Custom stream logic                  │
│  • StreamController - Manual control                     │
│                                                          │
│  LISTENING:                                              │
│  • .listen() - Callback for each value                   │
│  • await for - Loop through values                       │
│  • StreamBuilder - In widgets                            │
│                                                          │
│  TYPES:                                                  │
│  • Single subscription - One listener only               │
│  • Broadcast - Multiple listeners OK                     │
│                                                          │
│  REMEMBER:                                               │
│  • Always close StreamControllers in dispose()!          │
│  • Create streams in initState, not build()              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What's the main difference between a Future and a Stream?

<details>
<summary>Answer</summary>

- **Future**: Returns ONE value, then it's done
- **Stream**: Returns MANY values over time, until you close it

Think of it as: Future = one pizza delivery, Stream = pizza subscription

</details>

**Q2:** What does `yield` do in a Stream?

<details>
<summary>Answer</summary>

`yield` sends one value out to whoever is listening to the stream. It's like saying "here's the next value!" without ending the stream.

```dart
Stream<int> numbers() async* {
  yield 1;  // Sends 1
  yield 2;  // Sends 2
  yield 3;  // Sends 3
}
```

</details>

**Q3:** Why do we need to close StreamControllers?

<details>
<summary>Answer</summary>

If you don't close them:
1. Memory leaks - resources are never released
2. The stream never ends - listeners keep waiting
3. Your app may slow down over time

Always close in `dispose()`:
```dart
@override
void dispose() {
  _controller.close();
  super.dispose();
}
```

</details>

---

**Next:** Let's learn about Responsive Design!

---

**Continue to:** `08-ResponsiveDesign.md`
