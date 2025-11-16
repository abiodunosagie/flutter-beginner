# StreamControllers: Creating Your Own Streams

## What You'll Learn

In this ultra-detailed lesson, you'll master:
- What StreamControllers are and why you need them
- Creating single-subscription vs broadcast streams
- Adding data to streams with `add()` and `addError()`
- Closing streams properly
- Building a real-time chat system
- Building a search-as-you-type feature
- Stream transformers and operators
- Memory management and avoiding leaks
- Best practices for production apps

By the end, you'll create powerful real-time features from scratch!

## Understanding StreamControllers (Like Teaching a 5-Year-Old)

### What is a StreamController?

Imagine you have a TV station:
- **Stream** = The TV channel that viewers watch
- **StreamController** = The control room where you decide what to broadcast

```dart
// YOU are the TV station operator
final controller = StreamController<String>();

// VIEWERS watch your channel
controller.stream.listen((show) {
  print('Watching: $show');
});

// YOU decide what to broadcast
controller.add('News at 6');      // Broadcast news
controller.add('Comedy Show');     // Broadcast comedy
controller.add('Weather Report');  // Broadcast weather

// Output:
// Watching: News at 6
// Watching: Comedy Show
// Watching: Weather Report
```

**In simple terms:**
- `async*` and `yield` = Pre-recorded shows (you can't change them)
- `StreamController` = Live broadcast (you control what goes out in real-time!)

### Why Do We Need StreamControllers?

```dart
// ❌ CAN'T DO THIS: Can't manually add to async* streams
Stream<String> newsStream() async* {
  yield 'News 1';
  yield 'News 2';
  // Can't add new news from outside!
}

// ✅ CAN DO THIS: Full control with StreamController
final newsController = StreamController<String>();

// Add news anytime from anywhere!
newsController.add('Breaking news!');
newsController.add('More news!');
newsController.add('Latest update!');
```

## Step 1: Creating StreamControllers

### Single-Subscription StreamController

Can only have ONE listener:

```dart
// Create controller
final controller = StreamController<int>();

// Add listener
controller.stream.listen((value) {
  print('Received: $value');
});

// Add data
controller.add(1);
controller.add(2);
controller.add(3);

// Close when done
controller.close();

// Output:
// Received: 1
// Received: 2
// Received: 3
```

**Important:** Single-subscription streams can only be listened to ONCE!

```dart
final controller = StreamController<int>();

// First listener - OK ✅
controller.stream.listen((value) => print('Listener 1: $value'));

// Second listener - ERROR! ❌
// controller.stream.listen((value) => print('Listener 2: $value'));
// Bad state: Stream has already been listened to.
```

### Broadcast StreamController

Can have MULTIPLE listeners:

```dart
// Create broadcast controller
final controller = StreamController<int>.broadcast();

// Multiple listeners - all OK! ✅
controller.stream.listen((value) => print('Listener 1: $value'));
controller.stream.listen((value) => print('Listener 2: $value'));
controller.stream.listen((value) => print('Listener 3: $value'));

// Add data - all listeners receive it
controller.add(42);

// Output:
// Listener 1: 42
// Listener 2: 42
// Listener 3: 42
```

## Step 2: StreamController Methods

### Adding Data

```dart
final controller = StreamController<String>();

// Add single value
controller.add('Hello');

// Add multiple values
controller.add('Hello');
controller.add('World');
controller.add('!');

// Add from list
['One', 'Two', 'Three'].forEach(controller.add);
```

### Adding Errors

```dart
final controller = StreamController<int>();

controller.stream.listen(
  (value) => print('Value: $value'),
  onError: (error) => print('Error: $error'),
);

controller.add(1);
controller.add(2);
controller.addError('Something went wrong!');
controller.add(3);

// Output:
// Value: 1
// Value: 2
// Error: Something went wrong!
// Value: 3
```

### Closing Streams

```dart
final controller = StreamController<int>();

controller.stream.listen(
  (value) => print('Value: $value'),
  onDone: () => print('Stream closed!'),
);

controller.add(1);
controller.add(2);
controller.close();  // Close the stream

// Can't add after closing
// controller.add(3);  // ERROR!

// Output:
// Value: 1
// Value: 2
// Stream closed!
```

### Checking Stream State

```dart
final controller = StreamController<int>();

print('Is closed? ${controller.isClosed}');  // false
print('Has listener? ${controller.hasListener}');  // false

controller.stream.listen((value) {});

print('Has listener? ${controller.hasListener}');  // true

controller.close();

print('Is closed? ${controller.isClosed}');  // true
```

## Step 3: Real-World Example - Chat System

Let's build a simple chat system using StreamControllers!

### Create Chat Service

```dart
class ChatService {
  // Broadcast so multiple widgets can listen
  final _messageController = StreamController<ChatMessage>.broadcast();

  // Expose stream (read-only)
  Stream<ChatMessage> get messages => _messageController.stream;

  // List to store all messages
  final List<ChatMessage> _allMessages = [];

  // Send message
  void sendMessage(String text, String userId, String userName) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      userId: userId,
      userName: userName,
      timestamp: DateTime.now(),
    );

    _allMessages.add(message);
    _messageController.add(message);
  }

  // Get all messages as stream
  Stream<List<ChatMessage>> getAllMessages() async* {
    yield _allMessages;

    await for (final message in messages) {
      yield List.from(_allMessages);
    }
  }

  // Simulate receiving messages from server
  void simulateIncomingMessage() {
    final messages = [
      'Hello everyone!',
      'How are you?',
      'This is awesome!',
      'Flutter is great!',
    ];

    var index = 0;

    Timer.periodic(Duration(seconds: 3), (timer) {
      if (index >= messages.length) {
        timer.cancel();
        return;
      }

      sendMessage(
        messages[index],
        'bot',
        'ChatBot',
      );

      index++;
    });
  }

  // Clean up
  void dispose() {
    _messageController.close();
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String userId;
  final String userName;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });
}
```

### Create Chat UI

```dart
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatService = ChatService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatService.simulateIncomingMessage();
  }

  @override
  void dispose() {
    _chatService.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _chatService.sendMessage(
      _messageController.text,
      'user123',
      'John Doe',
    );

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getAllMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.userId == 'user123';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.text,
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
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

## Step 4: Search-as-You-Type with StreamController

Let's build a search feature that searches as you type!

### Create Search Service

```dart
class SearchService {
  final _searchController = StreamController<String>();

  Stream<List<String>> get searchResults {
    return _searchController.stream
        .debounceTime(Duration(milliseconds: 500))  // Wait for typing to stop
        .distinct()  // Ignore duplicate searches
        .asyncMap((query) => _performSearch(query));  // Search
  }

  void search(String query) {
    _searchController.add(query);
  }

  Future<List<String>> _performSearch(String query) async {
    if (query.isEmpty) return [];

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Fake search results
    final allItems = [
      'Apple',
      'Banana',
      'Cherry',
      'Date',
      'Elderberry',
      'Fig',
      'Grape',
    ];

    return allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void dispose() {
    _searchController.close();
  }
}

// Extension for debounce (you'll learn this in a moment)
extension StreamExtensions<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    final controller = StreamController<T>();
    Timer? timer;

    listen(
      (value) {
        timer?.cancel();
        timer = Timer(duration, () {
          controller.add(value);
        });
      },
      onError: controller.addError,
      onDone: () {
        timer?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }
}
```

### Create Search UI

```dart
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchService = SearchService();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchService.search(value);
              },
            ),
          ),

          // Results
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _searchService.searchResults,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Type to search'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final results = snapshot.data!;

                if (results.isEmpty) {
                  return const Center(
                    child: Text('No results found'),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(results[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Step 5: Stream Transformations (Advanced)

### Debounce - Wait for Pause

```dart
Stream<String> debounce(Stream<String> source, Duration duration) {
  final controller = StreamController<String>();
  Timer? timer;

  source.listen(
    (value) {
      timer?.cancel();
      timer = Timer(duration, () {
        controller.add(value);
      });
    },
    onError: controller.addError,
    onDone: controller.close,
  );

  return controller.stream;
}

// Usage:
final searchStream = StreamController<String>();
final debouncedSearch = debounce(
  searchStream.stream,
  Duration(milliseconds: 500),
);

// Only searches after user stops typing for 500ms
```

### Throttle - Limit Rate

```dart
Stream<T> throttle<T>(Stream<T> source, Duration duration) {
  final controller = StreamController<T>();
  Timer? timer;
  bool canEmit = true;

  source.listen(
    (value) {
      if (canEmit) {
        controller.add(value);
        canEmit = false;

        timer = Timer(duration, () {
          canEmit = true;
        });
      }
    },
    onError: controller.addError,
    onDone: controller.close,
  );

  return controller.stream;
}

// Usage: Only emit once every 2 seconds max
final throttled = throttle(
  clickStream.stream,
  Duration(seconds: 2),
);
```

### Combine Streams

```dart
Stream<String> combineStreams(
  Stream<String> stream1,
  Stream<String> stream2,
) async* {
  await for (final value in stream1) {
    yield 'Stream 1: $value';
  }

  await for (final value in stream2) {
    yield 'Stream 2: $value';
  }
}
```

## Step 6: Memory Management - Avoiding Leaks

### Always Close Controllers

```dart
class MyService {
  final _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream;

  void addData(int value) {
    _controller.add(value);
  }

  // ✅ CRITICAL: Always dispose!
  void dispose() {
    _controller.close();
  }
}

// In widget:
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _service = MyService();

  @override
  void dispose() {
    _service.dispose();  // ✅ Clean up!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _service.stream,
      builder: (context, snapshot) { ... },
    );
  }
}
```

### Cancel Stream Subscriptions

```dart
class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = someStream.listen((data) {
      print(data);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();  // ✅ Cancel subscription!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { ... }
}
```

### Use StreamBuilder (Automatic Cleanup)

```dart
// ✅ BEST: StreamBuilder handles cleanup automatically
StreamBuilder<int>(
  stream: myStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('${snapshot.data}');
    }
    return CircularProgressIndicator();
  },
)
```

## Step 7: Best Practices

### 1. Use Broadcast for Multiple Listeners

```dart
// ❌ BAD: Single subscription with multiple listeners
final controller = StreamController<int>();

// This will error on second listener!
// controller.stream.listen(...);
// controller.stream.listen(...);

// ✅ GOOD: Broadcast for multiple listeners
final controller = StreamController<int>.broadcast();

controller.stream.listen(...);  // OK
controller.stream.listen(...);  // OK
controller.stream.listen(...);  // OK
```

### 2. Don't Add After Close

```dart
final controller = StreamController<int>();

controller.close();

// ❌ ERROR!
// controller.add(42);  // Bad state: Cannot add event after closing

// ✅ GOOD: Check before adding
if (!controller.isClosed) {
  controller.add(42);
}
```

### 3. Handle Errors Properly

```dart
final controller = StreamController<int>();

controller.stream.listen(
  (value) => print('Value: $value'),
  onError: (error) {
    // ✅ Always handle errors!
    print('Error: $error');
  },
);

controller.add(1);
controller.addError('Oops!');
controller.add(2);
```

### 4. Use async* for Simple Cases

```dart
// Simple sequential data?
// ✅ Use async* (simpler)
Stream<int> countTo10() async* {
  for (int i = 1; i <= 10; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

// Need manual control? User events? Multiple sources?
// ✅ Use StreamController
final controller = StreamController<int>();

// Can add from anywhere!
onButtonClick() => controller.add(1);
onSwipe() => controller.add(2);
onTimer() => controller.add(3);
```

## Step 8: Complete Real-World Example

Let's build a complete Counter app with undo/redo using StreamControllers!

```dart
class CounterBloc {
  int _counter = 0;
  final List<int> _history = [0];
  int _historyIndex = 0;

  // Controllers
  final _counterController = StreamController<int>.broadcast();
  final _canUndoController = StreamController<bool>.broadcast();
  final _canRedoController = StreamController<bool>.broadcast();

  // Streams
  Stream<int> get counter => _counterController.stream;
  Stream<bool> get canUndo => _canUndoController.stream;
  Stream<bool> get canRedo => _canRedoController.stream;

  // Current value
  int get currentValue => _counter;

  void increment() {
    _counter++;
    _addToHistory(_counter);
  }

  void decrement() {
    _counter--;
    _addToHistory(_counter);
  }

  void undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      _counter = _history[_historyIndex];
      _updateStreams();
    }
  }

  void redo() {
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      _counter = _history[_historyIndex];
      _updateStreams();
    }
  }

  void _addToHistory(int value) {
    // Remove any "future" history
    _history.removeRange(_historyIndex + 1, _history.length);

    // Add new value
    _history.add(value);
    _historyIndex = _history.length - 1;

    _updateStreams();
  }

  void _updateStreams() {
    _counterController.add(_counter);
    _canUndoController.add(_historyIndex > 0);
    _canRedoController.add(_historyIndex < _history.length - 1);
  }

  void dispose() {
    _counterController.close();
    _canUndoController.close();
    _canRedoController.close();
  }
}

// UI
class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final _bloc = CounterBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter with Undo/Redo'),
        actions: [
          StreamBuilder<bool>(
            stream: _bloc.canUndo,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: const Icon(Icons.undo),
                onPressed: snapshot.data! ? _bloc.undo : null,
              );
            },
          ),
          StreamBuilder<bool>(
            stream: _bloc.canRedo,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: const Icon(Icons.redo),
                onPressed: snapshot.data! ? _bloc.redo : null,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter:', style: TextStyle(fontSize: 20)),
            StreamBuilder<int>(
              stream: _bloc.counter,
              initialData: 0,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _bloc.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _bloc.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## Exercises

### Exercise 1: Build a Todo Stream
Create a TodoService with StreamController that:
- Adds todos
- Removes todos
- Toggles completion
- Filters (all, active, completed)

### Exercise 2: Real-time Stock Ticker
Simulate stock prices updating every 2 seconds using StreamController.

### Exercise 3: Debounced Input
Create a search field that only searches 500ms after user stops typing.

### Exercise 4: Multiple Stream Merger
Combine 3 different streams into one output stream.

### Exercise 5: Undo/Redo for Text Editor
Build a text editor with undo/redo functionality using StreamControllers.

## What You've Learned

✅ What StreamControllers are and when to use them
✅ Single-subscription vs broadcast streams
✅ Adding data and errors to streams
✅ Closing streams properly
✅ Building real-time features (chat, search)
✅ Stream transformations (debounce, throttle)
✅ Memory management and avoiding leaks
✅ Best practices for production apps

## Next Steps

In the next lesson, we'll cover:
- **Isolates** - True parallel processing
- **Running heavy computations without freezing UI**
- **Communicating between isolates**
- **When to use isolates vs async/await**

You're mastering real-time programming! 🚀
