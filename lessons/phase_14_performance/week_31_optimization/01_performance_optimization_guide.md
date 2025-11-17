# Flutter Performance Optimization: Complete Guide

## What You'll Learn

- Identifying performance bottlenecks
- Using Flutter DevTools
- Reducing widget rebuilds
- Optimizing lists and images
- Memory management
- Build mode differences
- Best practices for 60 FPS

## Understanding Performance

**Target: 60 FPS (frames per second)**
- 1 frame = 16.67ms
- If any frame takes > 16.67ms = Jank (stuttering)

## Flutter DevTools

### Installation

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Or use built-in: `flutter run` then press `v`

### Key Tools

1. **Performance** - Frame rendering timeline
2. **Memory** - Memory usage and leaks
3. **CPU Profiler** - Which functions are slow
4. **Network** - API calls monitoring
5. **Widget Inspector** - Widget tree visualization

## Common Performance Issues

### 1. Unnecessary Rebuilds

#### Problem

```dart
// ❌ BAD: Entire screen rebuilds on every state change
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget(),  // Rebuilds unnecessarily!
        Text('$_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

#### Solution 1: Const Constructors

```dart
// ✅ GOOD: Use const for widgets that never change
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(),  // Never rebuilds!
        Text('$_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: const Text('Increment'),  // const here too!
        ),
      ],
    );
  }
}
```

#### Solution 2: Extract Stateful Widget

```dart
// ✅ GOOD: Move changing part to separate widget
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget(),  // Never rebuilds!
        CounterWidget(),    // Only this rebuilds
      ],
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

### 2. Large Lists

#### Problem

```dart
// ❌ BAD: Creates ALL widgets at once
ListView(
  children: List.generate(
    10000,
    (index) => ListTile(title: Text('Item $index')),
  ),
)
```

#### Solution: ListView.builder

```dart
// ✅ GOOD: Only builds visible items
ListView.builder(
  itemCount: 10000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
)
```

### 3. Large Images

#### Problem

```dart
// ❌ BAD: Loads full resolution image
Image.asset('assets/huge_image.jpg')  // 4000x3000px for 100x100 widget!
```

#### Solution: Resize Images

```dart
// ✅ GOOD: Specify size
Image.asset(
  'assets/huge_image.jpg',
  width: 100,
  height: 100,
  cacheWidth: 100,  // Decode at this width
  cacheHeight: 100,
)
```

### 4. Expensive Operations in build()

#### Problem

```dart
// ❌ BAD: Heavy computation in build
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final result = expensiveCalculation();  // Runs on every rebuild!
    return Text('Result: $result');
  }

  int expensiveCalculation() {
    // Simulate heavy work
    int sum = 0;
    for (int i = 0; i < 1000000; i++) {
      sum += i;
    }
    return sum;
  }
}
```

#### Solution: Use Isolates for Heavy Work

```dart
// ✅ GOOD: Move to isolate
import 'package:flutter/foundation.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int? _result;

  @override
  void initState() {
    super.initState();
    _calculateAsync();
  }

  Future<void> _calculateAsync() async {
    final result = await compute(_expensiveCalculation, null);
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Text('Result: ${_result ?? "Calculating..."}');
  }
}

int _expensiveCalculation(_) {
  int sum = 0;
  for (int i = 0; i < 1000000; i++) {
    sum += i;
  }
  return sum;
}
```

### 5. No Keys in Dynamic Lists

#### Problem

```dart
// ❌ BAD: No keys when list changes
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

#### Solution: Use Keys

```dart
// ✅ GOOD: Keys help Flutter identify widgets
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id),  // Unique key!
      title: Text(items[index].name),
    );
  },
)
```

## Performance Best Practices

### 1. Use const Everywhere Possible

```dart
const Text('Hello')  // ✅
const Icon(Icons.home)  // ✅
const SizedBox(height: 16)  // ✅
const Padding(padding: EdgeInsets.all(8), child: ...)  // ✅
```

### 2. Use ListView.builder for Long Lists

```dart
// Lists > 20 items
ListView.builder(...)  // ✅
GridView.builder(...)  // ✅
```

### 3. Optimize Images

```dart
// Resize before adding to assets
// Use cacheWidth/cacheHeight
Image.network(
  url,
  cacheWidth: 400,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();
  },
)
```

### 4. Use RepaintBoundary

```dart
// Prevents unnecessary repaints
RepaintBoundary(
  child: ComplexWidget(),
)
```

### 5. Lazy Load Data

```dart
// Don't load everything at once
Future<void> _loadMore() async {
  if (_isLoading) return;

  setState(() => _isLoading = true);

  final newItems = await fetchItems(page: _currentPage);

  setState(() {
    _items.addAll(newItems);
    _currentPage++;
    _isLoading = false;
  });
}
```

## Build Modes

### Debug Mode

```bash
flutter run
```

- ✅ Hot reload
- ✅ DevTools
- ❌ Slow (unoptimized)
- ❌ Large app size

### Profile Mode

```bash
flutter run --profile
```

- ✅ Production-like performance
- ✅ DevTools available
- ❌ No hot reload

**Use for performance testing!**

### Release Mode

```bash
flutter run --release
```

- ✅ Fully optimized
- ✅ Smallest size
- ❌ No debugging

**Use for final testing and deployment!**

## Memory Optimization

### 1. Dispose Controllers

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();  // ✅ Always dispose!
    _animController.dispose();  // ✅ Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

### 2. Cancel Streams

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = someStream.listen((data) {
      // Handle data
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();  // ✅ Always cancel!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### 3. Image Caching

```dart
// Use cached_network_image package
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 400,  // Limit cache size
  memCacheHeight: 400,
)
```

## Performance Checklist

### Before Release

- [ ] Test in profile mode
- [ ] No jank in DevTools timeline
- [ ] No memory leaks in DevTools
- [ ] All images optimized
- [ ] Lists use .builder
- [ ] Const used everywhere possible
- [ ] Controllers disposed properly
- [ ] Streams canceled
- [ ] Heavy work in isolates
- [ ] Build times < 100ms (check DevTools)

## Measuring Performance

### Frame Rendering

```dart
// Add to main()
void main() {
  WidgetsBinding.instance.addTimingsCallback((timings) {
    for (final timing in timings) {
      final ms = timing.totalSpan.inMilliseconds;
      if (ms > 16) {
        print('Slow frame: ${ms}ms');
      }
    }
  });

  runApp(MyApp());
}
```

## Common Mistakes

❌ Using setState() in initState()
❌ Not disposing controllers
❌ Heavy work in build()
❌ No keys in lists
❌ Large images without caching
❌ Not using const
❌ Testing only in debug mode
❌ Ignoring DevTools warnings

## Exercises

### Exercise 1: Optimize List (Beginner)
Convert ListView to ListView.builder

### Exercise 2: Find and Fix (Intermediate)
Use DevTools to find slow widgets

### Exercise 3: Image Optimization (Advanced)
Implement efficient image loading with caching

You're building blazing-fast apps! 🚀
