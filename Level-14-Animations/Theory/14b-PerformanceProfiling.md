# 14b. Performance Profiling - Making Your App Lightning Fast

## What You'll Learn
Master performance profiling with Flutter DevTools - find bottlenecks, optimize rendering, reduce jank, and make your app run at smooth 60 FPS.

---

## The Big Picture

Think of performance profiling like being a race car mechanic:
- **Your App** = The race car
- **FPS (Frames Per Second)** = Speed of the car
- **Jank** = Car stuttering/bumping
- **Performance Profiler** = Diagnostic tools to find what's slowing the car
- **Optimization** = Tuning the engine to go faster

```
APP PERFORMANCE LEVELS
======================

Level 1: Janky (Bad)            Level 2: Smooth (Good)
┌──────────────────┐            ┌──────────────────┐
│ 20 FPS           │            │ 60 FPS           │
│ ▮   ▮   ▮   ▮   │            │ ▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮ │
│ Stuttering       │   ──────>  │ Buttery smooth   │
│ Slow scrolling   │            │ Fast scrolling   │
│ Users unhappy 😞 │            │ Users happy 😊   │
└──────────────────┘            └──────────────────┘

Target: 60 FPS = 16.67ms per frame
```

---

## 1. Understanding Frames and FPS

### The Flip Book Analogy

Imagine making a flip book animation:
- **1 page** = 1 frame
- **60 pages per second** = 60 FPS (smooth animation)
- **20 pages per second** = 20 FPS (choppy animation)
- **Drawing too slowly** = Jank (missed frames)

### Frame Budget

```
THE 16.67ms FRAME BUDGET
========================

For 60 FPS, each frame must complete in 16.67ms:

Frame Timeline:
0ms ───────────────────────────────────── 16.67ms
     ↑                                    ↑
   Start                               Deadline

What happens in a frame:
┌─────────────────────────────────────────┐
│ Build:   5ms   │████████             │  │
│ Layout:  3ms   │█████                │  │
│ Paint:   4ms   │███████              │  │
│ Composite: 2ms │███                  │  │
├─────────────────────────────────────────┤
│ Total:  14ms   ✓ Under 16.67ms!         │
└─────────────────────────────────────────┘

Janky frame (over budget):
┌─────────────────────────────────────────┐
│ Build:  25ms   │████████████████████████│ ❌
├─────────────────────────────────────────┤
│ Total:  30ms   ✗ OVER 16.67ms - JANK!   │
└─────────────────────────────────────────┘
```

---

## 2. Opening the Performance Tab

### Setup for Performance Testing

```dart
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

void main() {
  // Enable performance overlay in debug mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Show performance overlay (optional)
      showPerformanceOverlay: true,  // Shows FPS on screen
      home: PerformanceTestPage(),
    );
  }
}
```

### Steps to Profile

```
1. Run your app in PROFILE mode (important!):
   flutter run --profile

   Why profile mode?
   - Debug mode is slower (has debugging overhead)
   - Release mode can't connect to DevTools
   - Profile mode = real performance + DevTools access

2. Open DevTools Performance tab

3. Click "Record" button (or it starts automatically)

4. Interact with your app (scroll, tap, navigate)

5. Click "Stop" to see the results
```

---

## 3. Reading the Performance Timeline

### Understanding the Timeline View

```
PERFORMANCE TIMELINE
====================

FPS Chart (top):
60 ┤     ╭─────────────────────────────╮
50 ┤     │                             │
40 ┤     │                             ╰─╮  ← Dip = Jank!
30 ┤     │                               │
20 ┤     │                               ╰╮
10 ┤     │                                │
 0 ┴─────┴────────────────────────────────┴──→ Time

Frame Times:
┌─────────────────────────────────────────┐
│ Frame 1:  12ms  ████████           ✓    │
│ Frame 2:  14ms  █████████          ✓    │
│ Frame 3:  45ms  ████████████████████  ❌ │ ← Click to investigate
│ Frame 4:  10ms  ██████             ✓    │
└─────────────────────────────────────────┘

Selected Frame Details (Frame 3):
┌──────────────────────────────────────┐
│ Build:        5ms                    │
│ Layout:       8ms                    │
│ Paint:       30ms  ← PROBLEM!        │
│ Composite:    2ms                    │
└──────────────────────────────────────┘
```

### Example 1: Simple Scrolling Performance Test

```dart
class ScrollPerformanceTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scroll Performance')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('$index')),
            title: Text('Item $index'),
            subtitle: Text('Description for item $index'),
          );
        },
      ),
    );
  }
}

// Expected Performance:
// ✓ All frames should be under 16ms
// ✓ Smooth scrolling at 60 FPS
```

Run this and check Performance tab:

```
GOOD PERFORMANCE:
┌────────────────────────────────────────┐
│ Frame times: 8ms, 9ms, 10ms, 8ms...   │
│ FPS: 60                                │
│ Jank: 0%                               │
└────────────────────────────────────────┘
```

---

## 4. Common Performance Problems

### Problem 1: Expensive Build Methods

```dart
// ❌ BAD: Expensive computation in build
class ExpensiveBuildBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This runs EVERY time widget rebuilds!
    final result = _calculateExpensiveValue();

    return Scaffold(
      body: Center(
        child: Text('Result: $result'),
      ),
    );
  }

  int _calculateExpensiveValue() {
    developer.Timeline.startSync('ExpensiveCalculation');

    int result = 0;
    for (int i = 0; i < 10000000; i++) {
      result += i;
    }

    developer.Timeline.finishSync();
    return result;
  }
}

// Performance Timeline shows:
// ┌───────────────────────────────────────┐
// │ Frame: 150ms                          │
// │ Build: 148ms                          │
// │   └─ ExpensiveCalculation: 145ms  ❌  │
// └───────────────────────────────────────┘

// ✅ GOOD: Cache expensive computations
class ExpensiveBuildGood extends StatefulWidget {
  @override
  State<ExpensiveBuildGood> createState() => _ExpensiveBuildGoodState();
}

class _ExpensiveBuildGoodState extends State<ExpensiveBuildGood> {
  late final int _cachedResult;  // Calculate once!

  @override
  void initState() {
    super.initState();
    _cachedResult = _calculateExpensiveValue();
  }

  @override
  Widget build(BuildContext context) {
    // Just use the cached result
    return Scaffold(
      body: Center(
        child: Text('Result: $_cachedResult'),
      ),
    );
  }

  int _calculateExpensiveValue() {
    int result = 0;
    for (int i = 0; i < 10000000; i++) {
      result += i;
    }
    return result;
  }
}

// Performance Timeline shows:
// ┌───────────────────────────────────────┐
// │ Frame: 8ms                            │
// │ Build: 5ms                       ✓    │
// └───────────────────────────────────────┘
```

### Problem 2: Rebuilding Too Many Widgets

```dart
// ❌ BAD: Entire screen rebuilds on counter change
class RebuildTooMuchBad extends StatefulWidget {
  @override
  State<RebuildTooMuchBad> createState() => _RebuildTooMuchBadState();
}

class _RebuildTooMuchBadState extends State<RebuildTooMuchBad> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    print('🔄 Building entire screen!');  // This prints every tap!

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Column(
        children: [
          // These rebuild unnecessarily
          ExpensiveHeader(),
          ExpensiveImage(),
          ExpensiveSidebar(),

          // Only this needs to rebuild
          Text('Count: $_counter'),

          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: Text('Increment'),
          ),
        ],
      ),
    );
  }
}

class ExpensiveHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveHeader');
    return Container(height: 100, color: Colors.blue);
  }
}

class ExpensiveImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveImage');
    return Container(height: 200, color: Colors.red);
  }
}

class ExpensiveSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveSidebar');
    return Container(height: 100, color: Colors.green);
  }
}

// Output when tapping button:
// 🔄 Building entire screen!
//   🔨 Building ExpensiveHeader
//   🔨 Building ExpensiveImage
//   🔨 Building ExpensiveSidebar

// ✅ GOOD: Only rebuild what changed
class RebuildTooMuchGood extends StatefulWidget {
  @override
  State<RebuildTooMuchGood> createState() => _RebuildTooMuchGoodState();
}

class _RebuildTooMuchGoodState extends State<RebuildTooMuchGood> {
  @override
  Widget build(BuildContext context) {
    print('🔄 Building entire screen!');

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Column(
        children: [
          // These are const - never rebuild!
          const ExpensiveHeaderConst(),
          const ExpensiveImageConst(),
          const ExpensiveSidebarConst(),

          // Only this part rebuilds
          CounterDisplay(),
        ],
      ),
    );
  }
}

class ExpensiveHeaderConst extends StatelessWidget {
  const ExpensiveHeaderConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveHeaderConst');
    return Container(height: 100, color: Colors.blue);
  }
}

class ExpensiveImageConst extends StatelessWidget {
  const ExpensiveImageConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveImageConst');
    return Container(height: 200, color: Colors.red);
  }
}

class ExpensiveSidebarConst extends StatelessWidget {
  const ExpensiveSidebarConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveSidebarConst');
    return Container(height: 100, color: Colors.green);
  }
}

class CounterDisplay extends StatefulWidget {
  @override
  State<CounterDisplay> createState() => _CounterDisplayState();
}

class _CounterDisplayState extends State<CounterDisplay> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building CounterDisplay');
    return Column(
      children: [
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// Output when tapping button:
// 🔄 Building entire screen! (first time only)
//   🔨 Building ExpensiveHeaderConst (first time only)
//   🔨 Building ExpensiveImageConst (first time only)
//   🔨 Building ExpensiveSidebarConst (first time only)
//   🔨 Building CounterDisplay ← Only this rebuilds on tap!
```

### Problem 3: Large Images Without Optimization

```dart
// ❌ BAD: Loading huge images
class LargeImagesBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return Image.asset(
          'assets/huge_image.png',  // 5MB image!
          width: 100,
          height: 100,
          // No caching, no optimization
        );
      },
    );
  }
}

// Performance issues:
// - Loading 5MB image to show as 100x100
// - Loading same image 100 times
// - Memory grows to 500MB!

// ✅ GOOD: Optimize images
class LargeImagesGood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return Image.asset(
          'assets/thumbnail_100x100.png',  // Pre-resized 10KB image
          width: 100,
          height: 100,
          cacheWidth: 100,  // Resize in memory
          cacheHeight: 100,
        );
      },
    );
  }
}

// Better performance:
// - Loading 10KB image instead of 5MB
// - Image cached, loaded once
// - Memory: ~1MB total
```

---

## 5. Using Timeline Events for Custom Profiling

### Example 2: Profiling Custom Operations

```dart
import 'dart:developer';

class CustomProfiling extends StatefulWidget {
  @override
  State<CustomProfiling> createState() => _CustomProfilingState();
}

class _CustomProfilingState extends State<CustomProfiling> {
  List<Map<String, dynamic>> _data = [];

  Future<void> _loadData() async {
    // Start profiling this operation
    Timeline.startSync('LoadData');

    try {
      // Simulate data loading
      Timeline.startSync('FetchFromAPI');
      await Future.delayed(Duration(seconds: 1));
      final apiData = List.generate(1000, (i) => {'id': i, 'name': 'Item $i'});
      Timeline.finishSync();  // End FetchFromAPI

      // Process data
      Timeline.startSync('ProcessData');
      final processed = apiData.map((item) {
        return {
          ...item,
          'processed': true,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }).toList();
      Timeline.finishSync();  // End ProcessData

      // Update UI
      Timeline.startSync('UpdateUI');
      setState(() {
        _data = processed;
      });
      Timeline.finishSync();  // End UpdateUI

    } finally {
      Timeline.finishSync();  // End LoadData
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Profiling')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loadData,
            child: Text('Load Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index]['name']),
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

In Performance Timeline:

```
TIMELINE WITH CUSTOM EVENTS
============================

Click on "Load Data" button, see in timeline:

┌────────────────────────────────────────────────┐
│ LoadData                        1250ms         │
│ ├─ FetchFromAPI                 1000ms         │
│ ├─ ProcessData                    240ms        │
│ └─ UpdateUI                        10ms        │
└────────────────────────────────────────────────┘

Insights:
✓ API call takes most time (1000ms) - expected
✓ Processing is fast (240ms) - good
✓ UI update is quick (10ms) - excellent
```

---

## 6. Shader Compilation Jank

### The First-Time Rendering Problem

```dart
// Shader compilation causes first-frame jank
class ShaderJankExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(  // Uses shader
              colors: [Colors.blue, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Performance Timeline shows:
// First frame:  80ms (shader compilation!)
// Second frame:  8ms (shader cached)
// Third frame:   8ms

// ✅ Solution: Warm up shaders
import 'package:flutter/scheduler.dart';

class ShaderWarmup extends StatefulWidget {
  @override
  State<ShaderWarmup> createState() => _ShaderWarmupState();
}

class _ShaderWarmupState extends State<ShaderWarmup> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _warmupShaders();
  }

  Future<void> _warmupShaders() async {
    // Render content off-screen first
    await Future.delayed(Duration(milliseconds: 100));
    if (mounted) {
      setState(() => _showContent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showContent) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Now all frames: 8ms, 8ms, 8ms (smooth!)
```

---

## 7. ListView Performance Optimization

### Problem: Building All Items at Once

```dart
// ❌ BAD: Creates all 10,000 widgets immediately
class ListViewBad extends StatelessWidget {
  final items = List.generate(10000, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: items.map((item) {
          // All 10,000 widgets created NOW!
          return ExpensiveListItem(title: item);
        }).toList(),
      ),
    );
  }
}

class ExpensiveListItem extends StatelessWidget {
  final String title;
  const ExpensiveListItem({required this.title});

  @override
  Widget build(BuildContext context) {
    // Expensive to build
    return Container(
      height: 100,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Center(child: Text(title)),
    );
  }
}

// Performance:
// Initial build: 3000ms (building 10,000 widgets!)
// Memory: 150MB
// Scroll: Janky

// ✅ GOOD: Build items on-demand with ListView.builder
class ListViewGood extends StatelessWidget {
  final items = List.generate(10000, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Only builds items visible on screen!
          return ExpensiveListItem(title: items[index]);
        },
      ),
    );
  }
}

// Performance:
// Initial build: 50ms (building ~10 visible widgets)
// Memory: 5MB
// Scroll: Smooth 60 FPS

// ✅ EVEN BETTER: Add keys for better recycling
class ListViewBest extends StatelessWidget {
  final items = List.generate(10000, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemExtent: 116,  // Fixed height helps performance
        itemBuilder: (context, index) {
          return ExpensiveListItem(
            key: ValueKey(items[index]),  // Unique key
            title: items[index],
          );
        },
      ),
    );
  }
}
```

---

## 8. Animation Performance

### Example 3: Expensive Animation

```dart
// ❌ BAD: Rebuilds everything on each frame
class AnimationBad extends StatefulWidget {
  @override
  State<AnimationBad> createState() => _AnimationBadState();
}

class _AnimationBadState extends State<AnimationBad>
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // ENTIRE screen rebuilds 60 times per second!
          print('🔄 Building entire screen');

          return Column(
            children: [
              // These rebuild unnecessarily
              ExpensiveHeader(),
              ExpensiveImage(),

              // Only this needs to animate
              Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                ),
              ),

              ExpensiveFooter(),
            ],
          );
        },
      ),
    );
  }
}

class ExpensiveHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveHeader');
    return Container(height: 100, color: Colors.red);
  }
}

class ExpensiveImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveImage');
    return Container(height: 200, color: Colors.green);
  }
}

class ExpensiveFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveFooter');
    return Container(height: 100, color: Colors.yellow);
  }
}

// Performance Timeline shows:
// Frame times: 30ms, 28ms, 32ms (all OVER 16ms - janky!)

// ✅ GOOD: Only animate what needs to animate
class AnimationGood extends StatefulWidget {
  @override
  State<AnimationGood> createState() => _AnimationGoodState();
}

class _AnimationGoodState extends State<AnimationGood>
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
    print('🔄 Building screen');

    return Scaffold(
      body: Column(
        children: [
          // These are const - NEVER rebuild
          const ExpensiveHeaderConst(),
          const ExpensiveImageConst(),

          // Only this animates
          AnimatedRotatingBox(controller: _controller),

          const ExpensiveFooterConst(),
        ],
      ),
    );
  }
}

class AnimatedRotatingBox extends StatelessWidget {
  final AnimationController controller;
  const AnimatedRotatingBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        print('  🔨 Building AnimatedRotatingBox');
        return Transform.rotate(
          angle: controller.value * 2 * 3.14159,
          child: child,  // Child is const, doesn't rebuild!
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      ),
    );
  }
}

class ExpensiveHeaderConst extends StatelessWidget {
  const ExpensiveHeaderConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveHeaderConst');
    return Container(height: 100, color: Colors.red);
  }
}

class ExpensiveImageConst extends StatelessWidget {
  const ExpensiveImageConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveImageConst');
    return Container(height: 200, color: Colors.green);
  }
}

class ExpensiveFooterConst extends StatelessWidget {
  const ExpensiveFooterConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('  🔨 Building ExpensiveFooterConst');
    return Container(height: 100, color: Colors.yellow);
  }
}

// Performance Timeline shows:
// Frame times: 8ms, 9ms, 7ms (all under 16ms - smooth!)
```

---

## 9. Complete Performance Analysis Example

### The Shopping Cart App

```dart
// Complete example with performance issues and fixes
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

void main() => runApp(ShoppingApp());

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Performance',
      home: ProductListPage(),
    );
  }
}

// ❌ Version 1: With Performance Issues
class ProductListPageSlow extends StatefulWidget {
  @override
  State<ProductListPageSlow> createState() => _ProductListPageSlowState();
}

class _ProductListPageSlowState extends State<ProductListPageSlow> {
  List<Product> _products = [];
  List<Product> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    // Problem 1: Expensive operation in setState
    setState(() {
      developer.Timeline.startSync('LoadProducts');
      _products = List.generate(1000, (i) {
        // Problem 2: Creating complex objects in loop
        return Product(
          id: i.toString(),
          name: 'Product $i',
          price: (i * 10).toDouble(),
          description: 'This is product number $i with lots of details...',
          imageUrl: 'https://example.com/product_$i.jpg',
          rating: (i % 5) + 1.0,
          reviews: List.generate(10, (j) => 'Review $j'),
        );
      });
      developer.Timeline.finishSync();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
      // Problem 3: Entire list rebuilds just for cart badge update
    });
  }

  @override
  Widget build(BuildContext context) {
    developer.Timeline.startSync('BuildProductList');

    final result = Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          // Problem 4: Cart badge causes full rebuild
          Stack(
            children: [
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  child: Text('${_cart.length}'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          // Problem 5: No keys, makes recycling inefficient
          return ProductCard(
            product: _products[index],
            onAddToCart: () => _addToCart(_products[index]),
          );
        },
      ),
    );

    developer.Timeline.finishSync();
    return result;
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    developer.Timeline.startSync('BuildProductCard');

    // Problem 6: Complex layout for each card
    final result = Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem 7: Loading image every time
            Image.network(
              product.imageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              product.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('\$${product.price.toStringAsFixed(2)}'),
            // Problem 8: Rendering all reviews
            ...product.reviews.map((review) => Text(review, style: TextStyle(fontSize: 12))),
            Row(
              children: [
                // Problem 9: Building stars dynamically each time
                ...List.generate(5, (i) {
                  return Icon(
                    i < product.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ],
            ),
            ElevatedButton(
              onPressed: onAddToCart,
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );

    developer.Timeline.finishSync();
    return result;
  }
}

// ✅ Version 2: Optimized
class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final List<Product> _products;  // Fix 1: Load once, make final
  final List<Product> _cart = [];

  @override
  void initState() {
    super.initState();
    // Fix 2: Load outside setState
    _products = _generateProducts();
  }

  List<Product> _generateProducts() {
    return List.generate(1000, (i) {
      return Product(
        id: i.toString(),
        name: 'Product $i',
        price: (i * 10).toDouble(),
        description: 'Product $i',
        imageUrl: 'https://via.placeholder.com/200',  // Use placeholder
        rating: (i % 5) + 1.0,
        reviews: [], // Fix 3: Don't generate unused data
      );
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Fix 4: Extract to separate widget
          CartBadge(itemCount: _cart.length),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemExtent: 300,  // Fix 5: Fixed height for better performance
        itemBuilder: (context, index) {
          return ProductCardOptimized(
            key: ValueKey(_products[index].id),  // Fix 6: Add key
            product: _products[index],
            onAddToCart: () => _addToCart(_products[index]),
          );
        },
      ),
    );
  }
}

// Fix 7: Separate widget for cart badge (only this rebuilds)
class CartBadge extends StatelessWidget {
  final int itemCount;
  const CartBadge({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        if (itemCount > 0)
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 10,
              child: Text('$itemCount', style: TextStyle(fontSize: 10)),
            ),
          ),
      ],
    );
  }
}

class ProductCardOptimized extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCardOptimized({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fix 8: Cached network image with loading
            Image.network(
              product.imageUrl,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('\$${product.price.toStringAsFixed(2)}'),
            // Fix 9: Use pre-built rating widget
            RatingStars(rating: product.rating),
            ElevatedButton(
              onPressed: onAddToCart,
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

// Fix 10: Reusable const rating widget
class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final List<String> reviews;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });
}
```

Performance Comparison:

```
BEFORE OPTIMIZATION:
┌──────────────────────────────────────┐
│ Initial load:  850ms                 │
│ Scroll frames: 45ms, 38ms, 50ms      │
│ FPS:          20-30                  │
│ Memory:       180MB                  │
│ Jank:         65%                    │
└──────────────────────────────────────┘

AFTER OPTIMIZATION:
┌──────────────────────────────────────┐
│ Initial load:  120ms                 │
│ Scroll frames: 8ms, 9ms, 10ms        │
│ FPS:          60                     │
│ Memory:       45MB                   │
│ Jank:         0%                     │
└──────────────────────────────────────┘

Improvement: 7x faster, 4x less memory, 0 jank!
```

---

## 10. Performance Checklist

### Before Releasing Your App

```
PERFORMANCE CHECKLIST
=====================

Build Phase:
☐ No expensive computations in build()
☐ Use const constructors where possible
☐ Extract widgets to avoid unnecessary rebuilds
☐ Use ListView.builder, not ListView with children
☐ Add keys to list items

Images:
☐ Images are compressed (use WebP or JPEG)
☐ Use appropriate image sizes (not loading 4K for thumbnails)
☐ Use cached_network_image package for network images
☐ Consider lazy loading for images

Animations:
☐ Use AnimatedBuilder with const child
☐ Keep animated area small
☐ Use Transform instead of layout changes
☐ Avoid animating expensive properties (size, layout)

State Management:
☐ Only setState on widgets that need to update
☐ Use separate StatefulWidget for frequently changing parts
☐ Consider Provider/Riverpod for complex state

Lists:
☐ Use ListView.builder for long lists
☐ Set itemExtent if items have fixed height
☐ Add keys for better widget recycling
☐ Consider lazy loading for data

Profile Mode Testing:
☐ Test in profile mode (flutter run --profile)
☐ Test on real devices (especially low-end)
☐ Check Performance tab for jank
☐ Verify all frames under 16ms
☐ Check memory doesn't grow indefinitely
```

---

## Quick Reference

### Frame Budget

```
60 FPS = 16.67ms per frame
30 FPS = 33.33ms per frame (janky!)

Frame breakdown:
- Build:     < 5ms
- Layout:    < 3ms
- Paint:     < 5ms
- Composite: < 2ms
```

### Common Fixes

```
Problem                   Solution
─────────────────────────────────────────────────────
Expensive build           Cache results, compute in initState
Too many rebuilds         Use const, extract widgets
Large images              Compress, resize, lazy load
Slow scrolling            Use ListView.builder, add keys
Janky animations          Animate small area, use Transform
Memory growing            Cancel streams/timers in dispose
```

---

## Practice Exercise

Optimize this slow app:

```dart
class SlowApp extends StatefulWidget {
  @override
  State<SlowApp> createState() => _SlowAppState();
}

class _SlowAppState extends State<SlowApp> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slow App')),
      body: Column(
        children: [
          // Expensive header
          Container(
            height: 200,
            child: CustomPaint(
              painter: ExpensivePainter(),
            ),
          ),
          // Counter that changes frequently
          Text('Count: $_counter'),
          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: Text('Increment'),
          ),
          // Large list
          Expanded(
            child: ListView(
              children: List.generate(1000, (i) {
                return ListTile(title: Text('Item $i'));
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpensivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Expensive drawing
    for (int i = 0; i < 1000; i++) {
      canvas.drawCircle(
        Offset(i.toDouble(), i.toDouble()),
        5,
        Paint()..color = Colors.blue,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

Find and fix:
1. What rebuilds unnecessarily?
2. What's slow in the Performance tab?
3. How can you make it 60 FPS?

---

## What's Next?

Master performance profiling! Next:

- **14c. Optimization Techniques** - Advanced optimization patterns
- **Memory Profiling** - Find and fix memory leaks
- **Build Performance** - Speed up development

---

## Navigation

- Previous: [14a. DevTools Introduction](14a-DevToolsIntro.md)
- Next: [14c. Optimization Techniques](14c-OptimizationTechniques.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 25 minutes**

**Remember**: Performance profiling is like being a detective with a magnifying glass - examine every frame, find the bottlenecks, and optimize! Your users will thank you with smooth, fast experiences.
