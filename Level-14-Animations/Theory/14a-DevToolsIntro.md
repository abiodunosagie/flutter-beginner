# 14a. Flutter DevTools Introduction

## What You'll Learn
Master Flutter DevTools - the debugging and performance tool that helps you understand what's happening inside your app, find bugs, and make your app faster.

---

## The Big Picture

Think of DevTools like a doctor's medical equipment:
- **Your App** = The patient
- **DevTools** = X-ray, thermometer, stethoscope all in one
- **Widget Inspector** = X-ray to see inside your UI
- **Performance View** = Heart monitor to check app health
- **Memory View** = Blood test to find memory leaks
- **Network View** = Checking what your app is talking to

```
YOUR APP WITHOUT DEVTOOLS          YOUR APP WITH DEVTOOLS
========================          ======================

      "It's slow!"                  Performance View
           ↓                        ┌──────────────┐
      "Where?"                      │ Frame 1: 8ms │
           ↓                        │ Frame 2: 45ms│ ← Found it!
      "I don't know..."             │ Frame 3: 9ms │
                                    └──────────────┘

      "Memory leak!"                Memory View
           ↓                        ┌──────────────┐
      "Where?"                      │ Images: 50MB │ ← Problem!
           ↓                        │ Widgets: 2MB │
      "No idea..."                  └──────────────┘
```

---

## 1. What is Flutter DevTools?

### The Swiss Army Knife for Flutter Development

DevTools is a suite of debugging and performance tools that help you:
- See your widget tree visually
- Find performance bottlenecks
- Track memory usage
- Debug network requests
- Monitor app logs
- Inspect state changes

### DevTools Interface Overview

```
FLUTTER DEVTOOLS
================

┌─────────────────────────────────────────────────────────┐
│ 🏠 Home │ Inspector │ Performance │ Memory │ Network    │ ← Tabs
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────────┐         ┌────────────────────┐    │
│  │  Widget Tree    │         │  Properties Panel  │    │
│  │  ┌────────────┐ │         │  ┌──────────────┐  │    │
│  │  │ MyApp      │ │         │  │ Color: Red   │  │    │
│  │  │ ├─HomePage │ │  ←──→   │  │ Size: 100x50 │  │    │
│  │  │ ├─Text     │ │         │  │ Padding: 8   │  │    │
│  │  └────────────┘ │         │  └──────────────┘  │    │
│  └─────────────────┘         └────────────────────┘    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Installing and Launching DevTools

### Method 1: From VS Code (Easiest)

```dart
// 1. Run your app in debug mode (F5)
// 2. Look for "Dart DevTools" in the status bar
// 3. Click it to open DevTools in browser

// Or use Command Palette:
// Cmd/Ctrl + Shift + P
// Type: "Dart: Open DevTools"
```

### Method 2: From Command Line

```bash
# Install DevTools globally
flutter pub global activate devtools

# Run your app
flutter run

# In another terminal, start DevTools
flutter pub global run devtools

# Or use the shortcut when app is running
# Press 'v' in the terminal where flutter run is active
```

### Method 3: From Android Studio / IntelliJ

```dart
// 1. Run your app in debug mode
// 2. Click the "Dart DevTools" button in the run toolbar
// 3. Or: View → Tool Windows → Flutter Inspector
```

---

## 3. The Widget Inspector - X-Ray Vision for Your UI

### The LEGO Analogy

Imagine you built a LEGO house:
- **Widget Inspector** = Taking the house apart to see each brick
- **Select Widget Mode** = Clicking on any brick to see its details
- **Widget Tree** = The instruction manual showing how bricks connect
- **Layout Explorer** = Seeing the size and position of each brick

### Example 1: Inspecting a Simple Screen

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DevTools Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Click Me!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Using Widget Inspector

```
WIDGET INSPECTOR VIEW
=====================

Widget Tree                          Details Panel
┌──────────────────┐                ┌────────────────────────┐
│ MyApp            │                │ Selected: Container    │
│ └─MaterialApp    │                ├────────────────────────┤
│   └─HomePage     │                │ Size: 200 x 100        │
│     └─Scaffold   │                │ Color: Colors.red      │
│       ├─AppBar   │                │ Border Radius: 10      │
│       └─Center   │ ← Select this  ├────────────────────────┤
│         └─Column │                │ Properties:            │
│           ├─Container  ◀━━━━━━━━━━│ • width: 200           │
│           │ └─Text     │          │ • height: 100          │
│           ├─SizedBox   │          │ • decoration: BoxDec..│
│           └─Button     │          └────────────────────────┘
└──────────────────┘

Actions:
🔍 Select Widget Mode - Click on screen to select widget
📐 Show Guidelines - See padding/margins visually
🎨 Show Paint Baselines - See text baselines
📏 Show Sizes - See widget dimensions on screen
```

### Example 2: Debugging Layout Issues

```dart
class LayoutProblem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Layout Debug')),
      body: Column(
        children: [
          // Problem: This text is invisible!
          // Why? It has no height constraint
          Text('Hidden Text!'),

          // This works because Expanded gives it space
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Center(child: Text('Visible Text')),
            ),
          ),
        ],
      ),
    );
  }
}
```

Using Widget Inspector to Debug:

```
1. Run the app - you see "Hidden Text!" is missing

2. Open Widget Inspector

3. Click "Select Widget Mode"

4. Widget tree shows:
   Column
   ├─ Text (⚠️ Size: 0x0) ← Found the problem!
   └─ Expanded
      └─ Container (Size: 392x656)

5. Select the Text widget

6. Details panel shows:
   Size: 0 x 0  ← This is why it's invisible!
   Constraints: BoxConstraints(0.0<=w<=392.0, 0.0<=h<=Infinity)

7. Fix: Wrap in Expanded or give explicit height
```

### Example 3: Inspecting Padding and Margins

```dart
class PaddingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(30),
          color: Colors.blue,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            color: Colors.red,
            child: Text('Nested Padding'),
          ),
        ),
      ),
    );
  }
}
```

In Widget Inspector:

```
Enable "Show Guidelines" to see:

┌──────────────────────────────────────┐
│  20px margin (white space)           │
│  ┌────────────────────────────────┐  │
│  │ 30px padding (blue)            │  │
│  │  ┌──────────────────────────┐  │  │
│  │  │ 40px H / 20px V (red)    │  │  │
│  │  │  ┌────────────────────┐  │  │  │
│  │  │  │ Text             │  │  │  │
│  │  │  └────────────────────┘  │  │  │
│  │  └──────────────────────────┘  │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘

Guidelines show each layer's spacing visually!
```

---

## 4. The Logging View - Watching Your App's Diary

### The Security Camera Analogy

Logs are like security camera footage:
- **print()** = Basic camera recording everything
- **debugPrint()** = Camera with timestamps
- **log()** = Professional security system with categories
- **DevTools Logging** = Command center viewing all cameras

### Example 4: Using Logs Effectively

```dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LoggingExample extends StatefulWidget {
  @override
  State<LoggingExample> createState() => _LoggingExampleState();
}

class _LoggingExampleState extends State<LoggingExample> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;

      // Method 1: Basic print (use for simple debugging)
      print('Counter incremented to $_counter');

      // Method 2: debugPrint (better for production, won't crash if too many logs)
      debugPrint('Debug: Counter is now $_counter');

      // Method 3: developer.log (BEST - most features)
      developer.log(
        'Counter updated',
        name: 'CounterApp',
        error: _counter > 10 ? 'Counter too high!' : null,
        level: _counter > 10 ? 900 : 500,  // 500 = INFO, 900 = WARNING
      );

      // Method 4: Conditional logging (only in debug mode)
      if (kDebugMode) {
        print('This only shows in debug builds');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    developer.log('HomePage initialized', name: 'CounterApp');
  }

  @override
  void dispose() {
    developer.log('HomePage disposed', name: 'CounterApp');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logging Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter'),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Viewing Logs in DevTools

```
LOGGING VIEW
============

Filter by:  [All Levels ▼]  [All Tags ▼]  [Search...]

┌────────────────────────────────────────────────────────┐
│ ⓘ INFO    09:41:23.456  CounterApp                     │
│   HomePage initialized                                  │
├────────────────────────────────────────────────────────┤
│ ⓘ INFO    09:41:25.123  CounterApp                     │
│   Counter updated                                       │
├────────────────────────────────────────────────────────┤
│ ⚠️ WARNING 09:41:30.789  CounterApp                     │
│   Counter updated                                       │
│   Error: Counter too high!                             │
└────────────────────────────────────────────────────────┘

Benefits:
✓ Timestamps for every log
✓ Filter by level (INFO, WARNING, ERROR)
✓ Filter by name/tag
✓ Click to see full details
✓ Copy logs easily
```

### Example 5: Structured Logging

```dart
class ApiService {
  Future<User?> fetchUser(String userId) async {
    developer.log(
      'Fetching user',
      name: 'API',
      time: DateTime.now(),
      error: null,
      level: 500,  // INFO
      sequenceNumber: 1,
      zone: Zone.current,
    );

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      developer.log(
        'User fetched successfully',
        name: 'API',
        level: 500,
      );

      return User(id: userId, name: 'John Doe');
    } catch (e, stackTrace) {
      developer.log(
        'Failed to fetch user',
        name: 'API',
        error: e,
        stackTrace: stackTrace,
        level: 1000,  // ERROR
      );

      return null;
    }
  }
}

class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
}
```

---

## 5. App Size Analysis

### The Backpack Analogy

Your app is like a backpack:
- **App Size Tool** = Weighing each item in your backpack
- **Large assets** = Heavy textbooks (images, videos)
- **Code** = Notebooks (your Dart/Flutter code)
- **Dependencies** = Extra supplies (packages you added)

### Example 6: Analyzing App Size

```bash
# Build your app with size analysis
flutter build apk --analyze-size

# Or for iOS
flutter build ios --analyze-size
```

Output in DevTools:

```
APP SIZE BREAKDOWN
==================

Total Size: 15.2 MB

Breakdown:
┌─────────────────────────────────────────┐
│ Code: 2.5 MB                  16%  ████ │
│ Assets: 8.0 MB                53%  ██████████████│
│ Flutter Engine: 3.5 MB        23%  ██████ │
│ Native Libraries: 1.2 MB       8%  ██ │
└─────────────────────────────────────────┘

Top Asset Contributors:
1. images/background.png     3.2 MB  ← Optimize this!
2. images/logo.png            1.8 MB
3. fonts/custom-font.ttf      1.5 MB
4. animations/intro.json      0.8 MB

Recommendations:
⚠️ background.png is very large - consider compressing
⚠️ You have 15 unused images - remove them
✓ Code size is good
```

### Optimizing Based on Analysis

```dart
// ❌ Bad: Using large PNG
Image.asset('images/background.png')  // 3.2 MB

// ✅ Good: Use compressed images or lazy loading
Image.asset('images/background_compressed.jpg')  // 500 KB

// ✅ Good: Load large images conditionally
class OptimizedImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use smaller image on small screens
    final screenWidth = MediaQuery.of(context).size.width;

    return Image.asset(
      screenWidth < 600
          ? 'images/background_small.jpg'    // 200 KB
          : 'images/background_large.jpg',   // 800 KB
    );
  }
}
```

---

## 6. Timeline View - The Stopwatch

### Example 7: Understanding Frame Rendering

```dart
class AnimationExample extends StatefulWidget {
  @override
  State<AnimationExample> createState() => _AnimationExampleState();
}

class _AnimationExampleState extends State<AnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }
}
```

In Timeline View:

```
TIMELINE VIEW (Performance Tab)
================================

Frame Rendering Times:
┌────────────────────────────────────────────┐
│ Frame 1:  8ms  ████                    ✓   │ Good!
│ Frame 2:  7ms  ███                     ✓   │ Good!
│ Frame 3: 45ms  ██████████████████████  ❌  │ Janky!
│ Frame 4:  9ms  ████                    ✓   │ Good!
└────────────────────────────────────────────┘

Target: 16ms (60 FPS)
Janky frames: 1/4 (25%)

Click Frame 3 to see details:
┌────────────────────────────────────┐
│ Build:   5ms                       │
│ Layout:  3ms                       │
│ Paint:   2ms                       │
│ Shader Compilation: 35ms  ← PROBLEM!│
└────────────────────────────────────┘

Why janky? First time using a shader takes longer.
Solution: Warm up shaders in advance.
```

---

## 7. Network View - The Mailman Tracker

### Example 8: Monitoring Network Requests

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkExample extends StatefulWidget {
  @override
  State<NetworkExample> createState() => _NetworkExampleState();
}

class _NetworkExampleState extends State<NetworkExample> {
  List<dynamic> _posts = [];
  bool _loading = false;

  Future<void> _fetchPosts() async {
    setState(() => _loading = true);

    developer.log('Starting API call', name: 'Network');

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      developer.log(
        'API call completed',
        name: 'Network',
        error: response.statusCode != 200 ? 'Status: ${response.statusCode}' : null,
      );

      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body);
        });
      }
    } catch (e) {
      developer.log('API call failed', name: 'Network', error: e);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loading ? null : _fetchPosts,
            child: Text(_loading ? 'Loading...' : 'Fetch Posts'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_posts[index]['title']),
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

In Network View:

```
NETWORK VIEW
============

Filter: [All] [GET] [POST] [Search...]

┌──────────────────────────────────────────────────────────┐
│ ✓ GET /posts                              200 OK   1.2s  │
│   https://jsonplaceholder.typicode.com/posts             │
│   ┌──────────────────────────────────────────────────┐   │
│   │ Request Headers:                                 │   │
│   │   User-Agent: Dart/2.18                         │   │
│   │   Accept: application/json                      │   │
│   │                                                  │   │
│   │ Response Headers:                               │   │
│   │   Content-Type: application/json                │   │
│   │   Content-Length: 27913                         │   │
│   │                                                  │   │
│   │ Response Body: (Click to view full)             │   │
│   │   [{"id":1,"title":"Post 1",...}, {...}]       │   │
│   └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘

Timing Breakdown:
┌──────────────────┐
│ DNS:      50ms   │
│ Connect:  100ms  │
│ Send:     10ms   │
│ Wait:     800ms  │ ← Server processing
│ Receive:  240ms  │
└──────────────────┘
```

---

## 8. Debugging Common Issues with DevTools

### Issue 1: Widget Not Showing

```dart
// Problem: Text doesn't appear
Column(
  children: [
    Text('Invisible!'),  // ❌ Has no height in unbounded Column
  ],
)

// Using DevTools:
// 1. Open Widget Inspector
// 2. Find Text widget in tree
// 3. See: Size: 0x0
// 4. Details panel shows: RenderObject has no size

// Solution:
Column(
  children: [
    Expanded(child: Text('Visible!')),  // ✅
  ],
)
```

### Issue 2: Memory Growing

```dart
// Problem: List keeps growing
class MemoryLeak extends StatefulWidget {
  @override
  State<MemoryLeak> createState() => _MemoryLeakState();
}

class _MemoryLeakState extends State<MemoryLeak> {
  final List<String> _data = [];

  @override
  void initState() {
    super.initState();
    // ❌ This runs forever, adding data continuously
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _data.add('Item ${_data.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) => Text(_data[index]),
    );
  }
}

// Using DevTools Memory view:
// 1. Watch memory grow continuously
// 2. Take heap snapshot
// 3. See _data list growing
// 4. Find Timer not canceled

// Solution:
class _MemoryLeakFixedState extends State<MemoryLeak> {
  final List<String> _data = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_data.length < 100) {  // ✅ Stop after 100
        setState(() {
          _data.add('Item ${_data.length}');
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // ✅ Cancel timer!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) => Text(_data[index]),
    );
  }
}
```

---

## 9. DevTools Shortcuts and Tips

### Essential Keyboard Shortcuts

```
DEVTOOLS SHORTCUTS
==================

General:
- Cmd/Ctrl + F           Search in current view
- Cmd/Ctrl + P           Open file
- Esc                    Close panel

Widget Inspector:
- Click on screen        Select widget in app
- Click in tree          Highlight widget in app
- Cmd/Ctrl + Click       Jump to source code

Performance:
- R                      Refresh timeline
- C                      Clear timeline
- Space                  Start/stop recording

Console:
- Cmd/Ctrl + K           Clear console
- Cmd/Ctrl + L           Filter logs
```

### Pro Tips

```dart
// Tip 1: Use `debugFillProperties` for better inspector info
class MyWidget extends StatelessWidget {
  final String title;
  final int count;

  MyWidget({required this.title, required this.count});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(IntProperty('count', count));
    // Now these show in DevTools Inspector!
  }

  @override
  Widget build(BuildContext context) {
    return Text('$title: $count');
  }
}

// Tip 2: Use `debugPrintBeginFrameBanner` to see frame boundaries
void main() {
  debugPrintBeginFrameBanner = true;  // Shows frame starts in logs
  runApp(MyApp());
}

// Tip 3: Use Timeline events for custom profiling
import 'dart:developer';

void expensiveOperation() {
  Timeline.startSync('MyExpensiveOp');  // Shows in Performance view!

  // Do expensive work
  for (int i = 0; i < 1000000; i++) {
    // ...
  }

  Timeline.finishSync();
}
```

---

## 10. Complete DevTools Workflow Example

### Scenario: App is Slow, Find and Fix

```dart
// Step 1: Run app and notice it's slow
class SlowApp extends StatefulWidget {
  @override
  State<SlowApp> createState() => _SlowAppState();
}

class _SlowAppState extends State<SlowApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slow App')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          // ❌ Problem: Expensive computation in build!
          final fibonacci = _calculateFibonacci(35);

          return ListTile(
            title: Text('Item $index'),
            subtitle: Text('Fibonacci: $fibonacci'),
          );
        },
      ),
    );
  }

  int _calculateFibonacci(int n) {
    if (n <= 1) return n;
    return _calculateFibonacci(n - 1) + _calculateFibonacci(n - 2);
  }
}

// Step 2: Open Performance tab in DevTools
// Step 3: Scroll the list
// Step 4: See in timeline:
//   Frame times: 500ms, 450ms, 480ms (all WAY over 16ms!)

// Step 5: Click on a slow frame, see:
//   Build: 450ms ← Problem is in build phase!

// Step 6: Click "Track Widget Builds"
// Step 7: See: ListTile building takes 450ms due to _calculateFibonacci

// Step 8: Fix - cache the result!
class _SlowAppFixedState extends State<SlowApp> {
  late final int _fibResult;  // ✅ Calculate once

  @override
  void initState() {
    super.initState();
    _fibResult = _calculateFibonacci(35);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fast App')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          // ✅ Use cached result
          return ListTile(
            title: Text('Item $index'),
            subtitle: Text('Fibonacci: $_fibResult'),
          );
        },
      ),
    );
  }

  int _calculateFibonacci(int n) {
    if (n <= 1) return n;
    return _calculateFibonacci(n - 1) + _calculateFibonacci(n - 2);
  }
}

// Step 9: Run again, check Performance tab
// Step 10: See frame times: 8ms, 7ms, 9ms (all under 16ms!)
// Step 11: Problem fixed! 🎉
```

---

## Quick Reference

### DevTools Tabs

```
Tab              Purpose                      When to Use
──────────────────────────────────────────────────────────────
Inspector        View widget tree             Layout issues, widget properties
Performance      Monitor frame rendering      App is janky/slow
Memory          Track memory usage           Memory leaks, high usage
Network         Monitor API calls            API debugging, slow requests
Logging         View app logs                General debugging
App Size        Analyze build size           Reduce app download size
```

### Common Problems and Solutions

```
Problem                      DevTools Tab      What to Look For
─────────────────────────────────────────────────────────────────
Widget not visible           Inspector         Size: 0x0, unbounded constraints
Layout overflow             Inspector         Red overflow indicators
Slow scrolling              Performance       Frame times > 16ms
Memory growing              Memory            Heap size increasing
API taking long             Network           Request timing breakdown
Missing logs                Logging           Check log level filters
Large app size              App Size          Big assets, unused code
```

---

## Practice Exercise

Debug this app using DevTools:

```dart
class BuggyApp extends StatefulWidget {
  @override
  State<BuggyApp> createState() => _BuggyAppState();
}

class _BuggyAppState extends State<BuggyApp> {
  final List<String> _items = List.generate(100, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buggy App')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          // Bug 1: Expensive operation in build
          _sortItems();

          // Bug 2: Creating new widget every time
          return GestureDetector(
            onTap: () {
              // Bug 3: setState called too often
              setState(() {
                _items.add('New item');
              });
            },
            child: Container(
              // Bug 4: No height constraint
              child: Column(
                children: [
                  Text(_items[index]),
                  // Bug 5: Unbounded ListView in unbounded Column
                  ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, i) => Text('Sub $i'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sortItems() {
    _items.sort();  // Sorting on every build!
  }
}
```

Use DevTools to find:
1. Which frame is slow (Performance tab)
2. Why it's slow (Widget rebuild tracking)
3. Memory leak (Memory tab)
4. Layout issues (Inspector)

---

## What's Next?

Now you can use DevTools! Next topics:

- **14b. Performance Profiling** - Deep dive into performance optimization
- **14c. Optimization Techniques** - Make your app faster
- **Memory Debugging** - Find and fix memory leaks

---

## Navigation

- Previous: [Level 13 - Testing](../../Level-13-Testing/README.md)
- Next: [14b. Performance Profiling](14b-PerformanceProfiling.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 20 minutes**

**Remember**: DevTools is your X-ray vision for Flutter apps. When something's wrong, DevTools will help you see inside and find the problem. Use it often, and you'll become a debugging superhero!
