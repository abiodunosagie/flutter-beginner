# Lottie Animations: Designer-Quality Animations in Flutter

## The Simple Explanation

Imagine a designer draws a beautiful cartoon animation on their computer, and you can use it in your app - exactly as they designed it! That's what Lottie does - it brings designer-created animations to life in your Flutter app.

```
┌─────────────────────────────────────────────────────────┐
│                  LOTTIE ANIMATIONS                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  DESIGNER creates animation in:                          │
│  • Adobe After Effects                                   │
│  • Figma                                                 │
│  • Other design tools                                    │
│         ↓                                                │
│  EXPORTS to JSON file (.json)                            │
│         ↓                                                │
│  YOU use in Flutter app!                                 │
│                                                          │
│  Result: Professional animations with tiny file size!    │
│  (Vector-based, so scales perfectly!)                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What is Lottie?

**Lottie** is a library that renders Adobe After Effects animations in real-time on mobile:

```
Benefits:
✓ Tiny file sizes (JSON is small!)
✓ Vector graphics (scale to any size)
✓ Smooth 60 FPS animations
✓ Thousands of FREE animations available
✓ Designed by professionals
✓ Works on iOS, Android, Web
```

---

## Setup

### Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  lottie: ^3.1.0
```

### Import

```dart
import 'package:lottie/lottie.dart';
```

---

## Where to Find Lottie Animations

### LottieFiles.com

```
https://lottiefiles.com

FREE animations for:
• Loading spinners
• Success/error icons
• Onboarding illustrations
• Character animations
• Background effects
• And thousands more!

How to download:
1. Browse LottieFiles.com
2. Find animation you like
3. Click "Download" → "Lottie JSON"
4. Save .json file
```

### Popular Free Animations

```
Search for these on LottieFiles.com:
• "loading spinner"
• "success checkmark"
• "error cross"
• "empty state"
• "404 not found"
• "celebration confetti"
• "typing indicator"
• "search"
```

---

## Basic Usage

### Loading from Assets

```dart
// 1. Add JSON file to assets
// pubspec.yaml:
flutter:
  assets:
    - assets/animations/loading.json
    - assets/animations/success.json

// 2. Display the animation
Lottie.asset('assets/animations/loading.json')
```

### Loading from Network

```dart
// Load from URL
Lottie.network(
  'https://assets10.lottiefiles.com/packages/lf20_loading.json',
)
```

### Loading from String

```dart
// If you have JSON as a string
final jsonString = '''{"v":"5.5.7","fr":60,...}''';
Lottie.memory(jsonString)
```

---

## Controlling Animations

### Auto-play (Default)

```dart
// Plays once automatically
Lottie.asset('assets/animations/welcome.json')
```

### Custom Size

```dart
// Set width and height
Lottie.asset(
  'assets/animations/loading.json',
  width: 200,
  height: 200,
)

// Or use in a Container
SizedBox(
  width: 100,
  height: 100,
  child: Lottie.asset('assets/animations/icon.json'),
)
```

### Fit Options

```dart
// How animation fits in its box
Lottie.asset(
  'assets/animations/splash.json',
  fit: BoxFit.cover,    // Fill entire space
)

Lottie.asset(
  'assets/animations/icon.json',
  fit: BoxFit.contain,  // Fit inside (default)
)
```

---

## Using Animation Controller

### Full Control Over Animation

```dart
class ControlledLottie extends StatefulWidget {
  const ControlledLottie({super.key});

  @override
  State<ControlledLottie> createState() => _ControlledLottieState();
}

class _ControlledLottieState extends State<ControlledLottie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/loading.json',
          controller: _controller,
          onLoaded: (composition) {
            // Set duration from the animation file
            _controller.duration = composition.duration;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () => _controller.reverse(),
              child: const Text('Reverse'),
            ),
            ElevatedButton(
              onPressed: () => _controller.repeat(),
              child: const Text('Loop'),
            ),
            ElevatedButton(
              onPressed: () => _controller.stop(),
              child: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Looping Animations

### Infinite Loop

```dart
// Repeat forever
Lottie.asset(
  'assets/animations/loading.json',
  repeat: true,  // ← Loops infinitely!
)
```

### Loop with Reverse

```dart
class ReverseLottie extends StatefulWidget {
  const ReverseLottie({super.key});

  @override
  State<ReverseLottie> createState() => _ReverseLottieState();
}

class _ReverseLottieState extends State<ReverseLottie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    return Lottie.asset(
      'assets/animations/heart.json',
      controller: _controller,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..repeat(reverse: true);  // ← Forward then back, repeat!
      },
    );
  }
}
```

---

## Practical Examples

### Example 1: Loading Screen

```dart
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading animation
            Lottie.asset(
              'assets/animations/loading.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Example 2: Success/Error Feedback

```dart
class FeedbackAnimation extends StatefulWidget {
  const FeedbackAnimation({super.key});

  @override
  State<FeedbackAnimation> createState() => _FeedbackAnimationState();
}

class _FeedbackAnimationState extends State<FeedbackAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isSuccess = true;

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

  void _showFeedback(bool success) {
    setState(() => _isSuccess = success);
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animation changes based on success/error
        SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset(
            _isSuccess
                ? 'assets/animations/success.json'
                : 'assets/animations/error.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
            },
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showFeedback(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Success'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _showFeedback(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Error'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### Example 3: Empty State

```dart
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty_box.json',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 24),
          const Text(
            'No items found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some items to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
```

---

### Example 4: Onboarding Screens

```dart
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String animationPath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.animationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animationPath,
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Usage in PageView
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          OnboardingPage(
            title: 'Welcome!',
            description: 'Discover amazing features',
            animationPath: 'assets/animations/welcome.json',
          ),
          OnboardingPage(
            title: 'Easy to Use',
            description: 'Simple and intuitive interface',
            animationPath: 'assets/animations/easy.json',
          ),
          OnboardingPage(
            title: 'Get Started',
            description: 'Join thousands of happy users',
            animationPath: 'assets/animations/start.json',
          ),
        ],
      ),
    );
  }
}
```

---

### Example 5: Like Button with Animation

```dart
class AnimatedLikeButton extends StatefulWidget {
  const AnimatedLikeButton({super.key});

  @override
  State<AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
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
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Lottie.asset(
        'assets/animations/heart.json',
        controller: _controller,
        width: 100,
        height: 100,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}
```

---

### Example 6: Pull-to-Refresh Indicator

```dart
class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator({super.key});

  Future<void> _onRefresh() async {
    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}

// Or create custom refresh with Lottie:
class LottieRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const LottieRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<LottieRefreshIndicator> createState() =>
      _LottieRefreshIndicatorState();
}

class _LottieRefreshIndicatorState extends State<LottieRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isRefreshing = false;

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

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    _controller.repeat();

    await widget.onRefresh();

    _controller.stop();
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Stack(
        children: [
          widget.child,
          if (_isRefreshing)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  'assets/animations/refresh.json',
                  controller: _controller,
                  width: 100,
                  height: 100,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## Complete Shopping App Example

```dart
// Product Card with Lottie animations
class ProductCard extends StatefulWidget {
  final String name;
  final double price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _likeController;
  bool _isLiked = false;
  bool _addedToCart = false;

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
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeController.forward();
      } else {
        _likeController.reverse();
      }
    });
  }

  Future<void> _addToCart() async {
    setState(() => _addedToCart = true);

    // Show success animation for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _addedToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Product Image
              Image.network(
                widget.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Like Button (top right)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _toggleLike,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      'assets/animations/heart.json',
                      controller: _likeController,
                      onLoaded: (composition) {
                        _likeController.duration = composition.duration;
                      },
                    ),
                  ),
                ),
              ),

              // Success overlay when added to cart
              if (_addedToCart)
                Container(
                  height: 200,
                  color: Colors.black54,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/success.json',
                      width: 100,
                      height: 100,
                      repeat: false,
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Main Shopping Screen
class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ProductCard(
            name: 'Product $index',
            price: 19.99 + (index * 5),
            imageUrl: 'https://picsum.photos/300/300?random=$index',
          );
        },
      ),
    );
  }
}
```

---

## Optimizing Lottie Performance

### Tips for Better Performance

```dart
// 1. Preload animations
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Preload to avoid lag on first use
    precacheImage(
      AssetImage('assets/animations/loading.json'),
      context,
    );
  }
}

// 2. Use smaller animations
// Prefer animations under 100 KB

// 3. Limit simultaneous animations
// Don't play too many Lottie animations at once

// 4. Disable when not visible
class ConditionalLottie extends StatelessWidget {
  final bool isVisible;

  const ConditionalLottie({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Lottie.asset('assets/animations/loading.json')
        : const SizedBox.shrink();  // Don't render when hidden
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│             LOTTIE ANIMATIONS SUMMARY                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT IS IT:                                             │
│  • JSON-based animations                                 │
│  • Created by designers in After Effects                 │
│  • Vector graphics (scale to any size)                   │
│  • Tiny file sizes                                       │
│                                                          │
│  BASIC USAGE:                                            │
│  • Lottie.asset('path/to/file.json')                     │
│  • Lottie.network('https://url.to/file.json')            │
│  • width, height, fit properties                         │
│  • repeat: true for infinite loop                        │
│                                                          │
│  ADVANCED:                                               │
│  • controller for full control                           │
│  • onLoaded callback                                     │
│  • forward(), reverse(), repeat()                        │
│  • Play, pause, stop animations                          │
│                                                          │
│  COMMON USES:                                            │
│  • Loading indicators                                    │
│  • Success/error feedback                                │
│  • Empty states                                          │
│  • Onboarding screens                                    │
│  • Animated buttons                                      │
│  • Splash screens                                        │
│                                                          │
│  RESOURCES:                                              │
│  • LottieFiles.com - Thousands of free animations        │
│  • Keep file sizes under 100 KB                          │
│  • Test on real devices                                  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** Where can you find free Lottie animations?

<details>
<summary>Answer</summary>

**LottieFiles.com** - The largest collection of free Lottie animations. Browse, download, and use in your app!

</details>

**Q2:** How do you make a Lottie animation loop infinitely?

<details>
<summary>Answer</summary>

```dart
Lottie.asset(
  'assets/animations/loading.json',
  repeat: true,  // ← Loops forever
)
```

</details>

**Q3:** How do you control when a Lottie animation plays?

<details>
<summary>Answer</summary>

Use an `AnimationController`:

```dart
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/anim.json',
      controller: _controller,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _controller.forward();  // Play now!
      },
    );
  }
}
```

</details>

---

**Next:** Learn about Rive animations for interactive, state-driven animations.

---

## Navigation

⬅️ **Previous:** [Flutter Animate Package](06-FlutterAnimate.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Rive Animations](08-RiveAnimations.md)
