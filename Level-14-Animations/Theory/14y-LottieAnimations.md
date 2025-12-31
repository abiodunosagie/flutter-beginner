# 14y. Lottie Animations - Professional JSON-Based Animations

## What You'll Learn
Master Lottie animations in Flutter - use professionally designed, lightweight JSON animations created in Adobe After Effects.

---

## The Big Picture

Think of Lottie like using pre-made movie clips:
- **Custom Flutter Animation** = Filming your own movie (hard, time-consuming)
- **Lottie** = Using professional stock footage (easy, beautiful, ready-made)
- **JSON file** = The movie script (lightweight, scalable)
- **LottieFiles.com** = The movie library (thousands of free animations)

```
TRADITIONAL vs LOTTIE
=====================

Traditional Animation:          Lottie Animation:
┌─────────────────────┐        ┌─────────────────────┐
│ 1000+ lines of code │        │ Lottie.asset(       │
│ Complex math        │        │   'loading.json'    │
│ Hard to modify      │        │ )                   │
│ 50KB+ code          │        │ 3 lines!            │
└─────────────────────┘        │ 20KB JSON file      │
                               └─────────────────────┘

Benefits:
✓ Professional quality
✓ Lightweight (vector-based)
✓ Easy to use
✓ Thousands of free animations
✓ Created by designers, not code
```

---

## 1. Installation and Setup

### Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  lottie: ^3.1.0
```

Run:
```bash
flutter pub get
```

### Setup Assets

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/animations/
    - assets/animations/loading.json
    - assets/animations/success.json
    - assets/animations/error.json
```

Create the folder structure:
```
your_project/
├── assets/
│   └── animations/
│       ├── loading.json
│       ├── success.json
│       └── error.json
└── lib/
    └── main.dart
```

---

## 2. Finding Lottie Animations

### Where to Get Animations

1. **LottieFiles.com** (Free)
   - Visit: https://lottiefiles.com
   - Browse thousands of free animations
   - Download JSON file
   - Use in your app

2. **Create Your Own**
   - Use Adobe After Effects
   - Export with Bodymovin plugin
   - Get JSON file

Popular categories:
- Loading spinners
- Success checkmarks
- Error animations
- Empty states
- Onboarding

---

## 3. Basic Lottie Usage

### Example 1: Simple Lottie Animation

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SimpleLottie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Lottie')),
      body: Center(
        child: Lottie.asset(
          'assets/animations/loading.json',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

// Animation plays automatically and loops!
```

### Example 2: Loading from Network

```dart
class NetworkLottie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Lottie')),
      body: Center(
        child: Lottie.network(
          'https://assets5.lottiefiles.com/packages/lf20_l0zjccn9.json',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

// Downloads and plays animation from URL
```

### Example 3: Controlling Size and Fit

```dart
class SizedLottie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sized Lottie')),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.grey[200],
          child: Lottie.asset(
            'assets/animations/success.json',
            fit: BoxFit.contain,  // How to fit in container
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}

// fit options:
// - BoxFit.contain (default)
// - BoxFit.cover
// - BoxFit.fill
// - BoxFit.fitWidth
// - BoxFit.fitHeight
```

---

## 4. Animation Controller - Taking Control

### Example 4: Play Once, No Loop

```dart
class PlayOnce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play Once')),
      body: Center(
        child: Lottie.asset(
          'assets/animations/success.json',
          repeat: false,  // Play once, then stop
        ),
      ),
    );
  }
}
```

### Example 5: Manual Control with AnimationController

```dart
class ControlledLottie extends StatefulWidget {
  @override
  State<ControlledLottie> createState() => _ControlledLottieState();
}

class _ControlledLottieState extends State<ControlledLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Controlled Lottie')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation
          Lottie.asset(
            'assets/animations/loading.json',
            controller: _controller,  // Attach controller
            onLoaded: (composition) {
              // Configure controller with animation duration
              _controller.duration = composition.duration;
            },
          ),

          SizedBox(height: 40),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _controller.forward(),
                child: Text('Play'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _controller.stop(),
                child: Text('Stop'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _controller.reset(),
                child: Text('Reset'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _controller.reverse(),
                child: Text('Reverse'),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Repeat toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Repeat:'),
              Switch(
                value: _controller.isAnimating && _controller.repeat,
                onChanged: (value) {
                  if (value) {
                    _controller.repeat();
                  } else {
                    _controller.stop();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### Example 6: Speed Control

```dart
class SpeedControlLottie extends StatefulWidget {
  @override
  State<SpeedControlLottie> createState() => _SpeedControlLottieState();
}

class _SpeedControlLottieState extends State<SpeedControlLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSpeed(double speed) {
    setState(() {
      _speed = speed;
      // Restart with new speed
      if (_controller.isAnimating) {
        _controller.stop();
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speed Control')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/loading.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.repeat();
            },
          ),

          SizedBox(height: 40),

          Text('Speed: ${_speed.toStringAsFixed(1)}x'),

          Slider(
            value: _speed,
            min: 0.1,
            max: 3.0,
            divisions: 29,
            label: '${_speed.toStringAsFixed(1)}x',
            onChanged: _updateSpeed,
          ),

          // Speed shortcuts
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _updateSpeed(0.5),
                child: Text('0.5x'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _updateSpeed(1.0),
                child: Text('1x'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _updateSpeed(2.0),
                child: Text('2x'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 5. Practical Use Cases

### Example 7: Loading Indicator

```dart
class LottieLoadingIndicator extends StatefulWidget {
  @override
  State<LottieLoadingIndicator> createState() => _LottieLoadingIndicatorState();
}

class _LottieLoadingIndicatorState extends State<LottieLoadingIndicator> {
  bool _isLoading = false;
  String _data = '';

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Simulate network request
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _data = 'Data loaded successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading Example')),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/loading.json',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading data...',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _data.isEmpty ? 'Press button to load' : _data,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text('Load Data'),
                  ),
                ],
              ),
      ),
    );
  }
}
```

### Example 8: Success/Error States

```dart
class SuccessErrorLottie extends StatefulWidget {
  @override
  State<SuccessErrorLottie> createState() => _SuccessErrorLottieState();
}

class _SuccessErrorLottieState extends State<SuccessErrorLottie> {
  String _state = 'idle';  // idle, loading, success, error

  Future<void> _submitForm(bool shouldSucceed) async {
    setState(() => _state = 'loading');

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _state = shouldSucceed ? 'success' : 'error');

    // Reset after 3 seconds
    await Future.delayed(Duration(seconds: 3));
    setState(() => _state = 'idle');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success/Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: _buildAnimation(),
            ),

            SizedBox(height: 40),

            Text(
              _getMessage(),
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),

            if (_state == 'idle') ...[
              ElevatedButton(
                onPressed: () => _submitForm(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Submit (Success)'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _submitForm(false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Submit (Error)'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    switch (_state) {
      case 'loading':
        return Lottie.asset('assets/animations/loading.json');
      case 'success':
        return Lottie.asset(
          'assets/animations/success.json',
          repeat: false,
        );
      case 'error':
        return Lottie.asset(
          'assets/animations/error.json',
          repeat: false,
        );
      default:
        return Icon(Icons.touch_app, size: 100, color: Colors.grey);
    }
  }

  String _getMessage() {
    switch (_state) {
      case 'loading':
        return 'Processing...';
      case 'success':
        return 'Success! Operation completed.';
      case 'error':
        return 'Error! Something went wrong.';
      default:
        return 'Press a button to submit';
    }
  }
}
```

### Example 9: Empty State

```dart
class EmptyStateLottie extends StatefulWidget {
  @override
  State<EmptyStateLottie> createState() => _EmptyStateLottieState();
}

class _EmptyStateLottieState extends State<EmptyStateLottie> {
  List<String> _items = [];

  void _addItem() {
    setState(() {
      _items.add('Item ${_items.length + 1}');
    });
  }

  void _clearItems() {
    setState(() {
      _items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empty State'),
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _clearItems,
            ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty.json',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No items yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add your first item to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _items.removeAt(index));
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## 6. Advanced Features

### Example 10: Custom Animation Delegates

```dart
class CustomDelegateLottie extends StatefulWidget {
  @override
  State<CustomDelegateLottie> createState() => _CustomDelegateLottieState();
}

class _CustomDelegateLottieState extends State<CustomDelegateLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Delegate')),
      body: Center(
        child: Lottie.asset(
          'assets/animations/loading.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;

            // Play only part of the animation
            // Example: Play from 30% to 70%
            _controller.value = 0.3;
            _controller.animateTo(
              0.7,
              duration: Duration(seconds: 1),
            ).then((_) {
              // Loop between 30% and 70%
              _controller.repeat(min: 0.3, max: 0.7);
            });
          },
        ),
      ),
    );
  }
}
```

### Example 11: Interactive Animation

```dart
class InteractiveLottie extends StatefulWidget {
  @override
  State<InteractiveLottie> createState() => _InteractiveLottieState();
}

class _InteractiveLottieState extends State<InteractiveLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);

    if (_isLiked) {
      // Play like animation
      _controller.forward();
    } else {
      // Reverse animation
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interactive Lottie')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _toggleLike,
              child: Lottie.asset(
                'assets/animations/like.json',
                controller: _controller,
                width: 200,
                height: 200,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                },
              ),
            ),

            SizedBox(height: 20),

            Text(
              _isLiked ? 'Liked!' : 'Tap to like',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 12: Progress Bar with Lottie

```dart
class ProgressLottie extends StatefulWidget {
  @override
  State<ProgressLottie> createState() => _ProgressLottieState();
}

class _ProgressLottieState extends State<ProgressLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateProgress(double value) {
    setState(() {
      _progress = value;
      _controller.value = value;  // Sync animation with progress
    });
  }

  Future<void> _simulateProgress() async {
    for (double i = 0; i <= 1.0; i += 0.01) {
      await Future.delayed(Duration(milliseconds: 50));
      _updateProgress(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progress Lottie')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/progress.json',
              controller: _controller,
              width: 300,
              height: 300,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
              },
            ),

            SizedBox(height: 40),

            Text(
              '${(_progress * 100).toInt()}%',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 40),

            Slider(
              value: _progress,
              onChanged: _updateProgress,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _simulateProgress,
              child: Text('Simulate Progress'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 7. Performance Tips

### Tip 1: Preload Animations

```dart
class PreloadedLottie extends StatefulWidget {
  @override
  State<PreloadedLottie> createState() => _PreloadedLottieState();
}

class _PreloadedLottieState extends State<PreloadedLottie> {
  LottieComposition? _composition;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    final composition = await AssetLottie(
      'assets/animations/loading.json',
    ).load();

    setState(() => _composition = composition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preloaded Lottie')),
      body: Center(
        child: _composition == null
            ? CircularProgressIndicator()
            : Lottie(composition: _composition!),
      ),
    );
  }
}
```

### Tip 2: Cache Network Animations

```dart
class CachedNetworkLottie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cached Network Lottie')),
      body: Center(
        child: Lottie.network(
          'https://assets5.lottiefiles.com/packages/lf20_l0zjccn9.json',
          // Animations are automatically cached
          // Use same URL = loaded from cache
        ),
      ),
    );
  }
}
```

### Tip 3: Reduce Animation Complexity

```dart
// When exporting from After Effects:
// 1. Reduce layers
// 2. Simplify shapes
// 3. Remove unnecessary keyframes
// 4. Use solid colors instead of gradients when possible

// Good Lottie file size: 20-100KB
// Large Lottie file: > 500KB (consider optimizing)
```

---

## 8. Complete Shopping App with Lottie

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottie Shop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShoppingHome(),
    );
  }
}

class ShoppingHome extends StatefulWidget {
  @override
  State<ShoppingHome> createState() => _ShoppingHomeState();
}

class _ShoppingHomeState extends State<ShoppingHome> {
  bool _isLoading = true;
  List<Product> _products = [];
  String _status = 'loading';  // loading, success, error, empty

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _status = 'loading';
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Simulate different results (change to test different states)
    final success = true;  // Change to false to test error
    final hasData = true;  // Change to false to test empty

    setState(() {
      _isLoading = false;
      if (!success) {
        _status = 'error';
      } else if (!hasData) {
        _status = 'empty';
      } else {
        _status = 'success';
        _products = List.generate(
          10,
          (i) => Product(
            id: '$i',
            name: 'Product $i',
            price: (i + 1) * 10.0,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lottie Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case 'loading':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading.json',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text('Loading products...', style: TextStyle(fontSize: 18)),
            ],
          ),
        );

      case 'error':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/error.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              SizedBox(height: 20),
              Text(
                'Failed to load products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loadProducts,
                child: Text('Try Again'),
              ),
            ],
          ),
        );

      case 'empty':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/empty.json',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 20),
              Text(
                'No products found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Check back later for new items',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );

      case 'success':
        return ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: _products[index]);
          },
        );

      default:
        return SizedBox();
    }
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    if (_isLiked) {
      _likeController.forward();
    } else {
      _likeController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(widget.product.id),
        ),
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price.toStringAsFixed(2)}'),
        trailing: GestureDetector(
          onTap: _toggleLike,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Lottie.asset(
              'assets/animations/like.json',
              controller: _likeController,
              onLoaded: (composition) {
                _likeController.duration = composition.duration;
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}
```

---

## 9. Common Lottie Animations to Download

### Essential Animations for Your App

```
Loading Animations:
- Spinner
- Progress bar
- Dots loading
- Circular progress

Success Animations:
- Checkmark
- Confetti
- Thumbs up
- Star burst

Error Animations:
- X mark
- Error symbol
- Sad face
- Warning triangle

Empty States:
- Empty box
- No data
- Search not found
- Empty cart

Interactive:
- Like/heart
- Bookmark
- Star rating
- Toggle switch

Onboarding:
- Welcome
- Tutorial steps
- Feature highlights
```

---

## Quick Reference

### Basic Usage

```dart
// Asset
Lottie.asset('assets/animations/loading.json')

// Network
Lottie.network('https://example.com/animation.json')

// Size
Lottie.asset('animation.json', width: 200, height: 200)

// No loop
Lottie.asset('animation.json', repeat: false)

// With controller
Lottie.asset(
  'animation.json',
  controller: _controller,
  onLoaded: (composition) {
    _controller.duration = composition.duration;
  },
)
```

### Animation Control

```dart
_controller.forward()     // Play
_controller.reverse()     // Play backward
_controller.stop()        // Stop
_controller.reset()       // Reset to start
_controller.repeat()      // Loop
_controller.value = 0.5   // Jump to 50%
```

---

## What's Next?

Master Lottie animations! Next:

- **14z. Rive Animations** - Interactive, state-based animations
- **Animation Performance** - Optimize animations
- **Creating Custom Animations** - Make your own

---

## Navigation

- Previous: [14x. Flutter Animate](14x-FlutterAnimate.md)
- Next: [14z. Rive Animations](14z-RiveAnimations.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 20 minutes**

**Remember**: Lottie is like using professional stock footage for your app - beautiful, lightweight, and easy to use. Browse LottieFiles.com, download JSON files, and add professional animations in minutes!
