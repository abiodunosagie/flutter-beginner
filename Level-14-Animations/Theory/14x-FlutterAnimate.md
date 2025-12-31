# 14x. Flutter Animate Package - Declarative Animations Made Easy

## What You'll Learn
Master the `flutter_animate` package - create beautiful, declarative animations with minimal code using a chainable, intuitive API.

---

## The Big Picture

Think of `flutter_animate` like adding magic effects to a photo:
- **Traditional Flutter Animation** = Using Photoshop (powerful but complex)
- **flutter_animate** = Using Instagram filters (easy, beautiful, declarative)
- **Effect Chaining** = Applying multiple filters in sequence
- **Adapters** = Fine-tuning each filter's settings

```
TRADITIONAL vs FLUTTER_ANIMATE
==============================

Traditional:                    flutter_animate:
┌──────────────────────┐       ┌──────────────────────┐
│ AnimationController  │       │ Text('Hello')        │
│ Tween                │       │   .animate()         │
│ AnimatedBuilder      │       │   .fadeIn()          │
│ Transform            │       │   .slideX()          │
│ 50+ lines of code    │       │ 4 lines of code!     │
└──────────────────────┘       └──────────────────────┘
```

---

## 1. Installation and Setup

### Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_animate: ^4.5.0
```

Run:
```bash
flutter pub get
```

### Basic Import

```dart
import 'package:flutter_animate/flutter_animate.dart';
```

---

## 2. Basic Animations - Your First Magic

### The Toy Box Analogy

Imagine animating toys coming out of a box:
- **fadeIn()** = Toy appears from invisible to visible
- **slideX()** = Toy slides from left to right
- **scale()** = Toy grows from tiny to full size
- **rotate()** = Toy spins around

### Example 1: Simple Fade In

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FadeInExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fade In Example')),
      body: Center(
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ).animate()  // Add this!
         .fadeIn(),  // Fades from 0 to 1 opacity
      ),
    );
  }
}

// That's it! Text fades in on first render.
```

### Example 2: Slide Animation

```dart
class SlideExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slide Example')),
      body: Center(
        child: Container(
          width: 200,
          height: 100,
          color: Colors.blue,
          child: Center(
            child: Text('Sliding Box', style: TextStyle(color: Colors.white)),
          ),
        )
          .animate()
          .slideX(begin: -1, end: 0),  // Slides from left (-1) to center (0)
      ),
    );
  }
}

// begin: -1 = Start off-screen to the left
// begin: 1 = Start off-screen to the right
// end: 0 = End at original position
```

### Example 3: Scale Animation

```dart
class ScaleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scale Example')),
      body: Center(
        child: Icon(
          Icons.favorite,
          size: 100,
          color: Colors.red,
        )
          .animate()
          .scale(begin: Offset(0, 0), end: Offset(1, 1)),  // Grows from 0 to full size
      ),
    );
  }
}
```

### Example 4: Rotate Animation

```dart
class RotateExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rotate Example')),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.green,
        )
          .animate()
          .rotate(begin: 0, end: 1),  // Rotates 0 to 360 degrees (1 = full rotation)
      ),
    );
  }
}
```

---

## 3. Chaining Effects - Combining Magic

### The Assembly Line Analogy

Imagine a toy moving through an assembly line:
1. **Station 1**: Paint (fade in)
2. **Station 2**: Move (slide)
3. **Station 3**: Decorate (scale)

### Example 5: Multiple Effects in Sequence

```dart
class ChainedAnimations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chained Animations')),
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              'Magic!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        )
          .animate()
          .fadeIn(duration: 600.ms)        // First: Fade in (600ms)
          .then(delay: 200.ms)              // Wait 200ms
          .slideX(begin: -0.2, end: 0)      // Then: Slide (default 300ms)
          .then()                            // No delay
          .scale(begin: Offset(1, 1), end: Offset(1.2, 1.2))  // Then: Grow slightly
          .then()
          .shake(),                          // Then: Shake effect!
      ),
    );
  }
}

// Timeline:
// 0-600ms:    Fade in
// 600-800ms:  Wait
// 800-1100ms: Slide
// 1100-1400ms: Scale
// 1400-1700ms: Shake
```

### Example 6: Parallel Effects

```dart
class ParallelAnimations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parallel Animations')),
      body: Center(
        child: Text(
          'Animated Text',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        )
          .animate()
          .fadeIn(duration: 1000.ms)    // Fade and slide happen together
          .slideY(begin: -0.3, end: 0, duration: 1000.ms),
        // Both effects run simultaneously for 1000ms
      ),
    );
  }
}
```

---

## 4. Timing and Curves - Controlling Speed

### The Car Acceleration Analogy

Curves control how animation speeds up or slows down:
- **Linear** = Constant speed (like cruise control)
- **EaseIn** = Slow start, then speed up (like accelerating)
- **EaseOut** = Fast start, then slow down (like braking)
- **EaseInOut** = Slow start, speed up, then slow down (smooth driving)

### Example 7: Different Curves

```dart
class CurvesExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Curves Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Linear - constant speed
          _buildAnimatedBox(
            'Linear',
            Colors.red,
            Curves.linear,
          ),

          // EaseIn - starts slow
          _buildAnimatedBox(
            'EaseIn',
            Colors.blue,
            Curves.easeIn,
          ),

          // EaseOut - ends slow
          _buildAnimatedBox(
            'EaseOut',
            Colors.green,
            Curves.easeOut,
          ),

          // Bounce - bouncy effect
          _buildAnimatedBox(
            'Bounce',
            Colors.orange,
            Curves.bounceOut,
          ),

          // Elastic - elastic effect
          _buildAnimatedBox(
            'Elastic',
            Colors.purple,
            Curves.elasticOut,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBox(String label, Color color, Curve curve) {
    return Row(
      children: [
        SizedBox(width: 20),
        Container(
          width: 60,
          height: 60,
          color: color,
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        )
          .animate(onComplete: (controller) => controller.repeat())
          .slideX(
            begin: 0,
            end: 1,
            duration: 2000.ms,
            curve: curve,
          ),
      ],
    );
  }
}
```

---

## 5. Advanced Effects Library

### Example 8: Shimmer Effect (Loading)

```dart
class ShimmerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shimmer Loading')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Shimmer placeholder for image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            )
              .animate(onComplete: (controller) => controller.repeat())
              .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5)),

            SizedBox(height: 20),

            // Shimmer placeholder for title
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey[300],
            )
              .animate(onComplete: (controller) => controller.repeat())
              .shimmer(duration: 1500.ms),

            SizedBox(height: 10),

            // Shimmer placeholder for text
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.grey[300],
            )
              .animate(onComplete: (controller) => controller.repeat())
              .shimmer(duration: 1500.ms),
          ],
        ),
      ),
    );
  }
}
```

### Example 9: Shake Effect (Error)

```dart
class ShakeExample extends StatefulWidget {
  @override
  State<ShakeExample> createState() => _ShakeExampleState();
}

class _ShakeExampleState extends State<ShakeExample> {
  final _controller = TextEditingController();
  bool _shouldShake = false;

  void _validatePassword() {
    if (_controller.text.length < 6) {
      setState(() => _shouldShake = true);
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() => _shouldShake = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shake on Error')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Password (min 6 chars)',
                border: OutlineInputBorder(),
              ),
            )
              .animate(target: _shouldShake ? 1 : 0)
              .shake(duration: 500.ms),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _validatePassword,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 10: Flip Effect

```dart
class FlipExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flip Effect')),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              'Flip Me!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        )
          .animate(onComplete: (controller) => controller.repeat(reverse: true))
          .flip(duration: 2000.ms),
      ),
    );
  }
}
```

---

## 6. Custom Animations with Adapters

### Example 11: Custom Color Animation

```dart
class CustomColorAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Color')),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
        )
          .animate(onComplete: (controller) => controller.repeat(reverse: true))
          .custom(
            duration: 2000.ms,
            builder: (context, value, child) {
              // value goes from 0 to 1
              final color = Color.lerp(
                Colors.blue,
                Colors.red,
                value,
              )!;

              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
      ),
    );
  }
}
```

### Example 12: Custom Size Animation

```dart
class CustomSizeAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Size')),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.green,
        )
          .animate(onComplete: (controller) => controller.repeat(reverse: true))
          .custom(
            duration: 1500.ms,
            begin: 100,
            end: 200,
            builder: (context, value, child) {
              return Container(
                width: value,
                height: value,
                color: Colors.green,
              );
            },
          ),
      ),
    );
  }
}
```

---

## 7. Complete UI Examples

### Example 13: Animated List with Stagger

```dart
class StaggeredListExample extends StatelessWidget {
  final items = List.generate(10, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staggered List')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(items[index]),
            subtitle: Text('Description for ${items[index]}'),
          )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: (100 * index).ms,  // Stagger by 100ms each
            )
            .slideX(
              begin: -0.2,
              end: 0,
              delay: (100 * index).ms,
            );
        },
      ),
    );
  }
}

// Timeline:
// Item 0: Starts at 0ms
// Item 1: Starts at 100ms
// Item 2: Starts at 200ms
// Item 3: Starts at 300ms
// ...creates a cascading effect!
```

### Example 14: Animated Card

```dart
class AnimatedCardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Card')),
      body: Center(
        child: Card(
          elevation: 8,
          child: Container(
            width: 300,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon animates first
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                )
                  .animate()
                  .scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

                SizedBox(height: 20),

                // Title fades in after icon
                Text(
                  'Success!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, delay: 300.ms),

                SizedBox(height: 10),

                // Message fades in last
                Text(
                  'Your action was completed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms),

                SizedBox(height: 20),

                // Button slides up
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Continue'),
                )
                  .animate()
                  .fadeIn(delay: 900.ms)
                  .slideY(begin: 0.5, end: 0, delay: 900.ms),
              ],
            ),
          ),
        )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
      ),
    );
  }
}
```

### Example 15: Product Card with Hover Effect

```dart
class ProductCardHover extends StatefulWidget {
  @override
  State<ProductCardHover> createState() => _ProductCardHoverState();
}

class _ProductCardHoverState extends State<ProductCardHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Card')),
      body: Center(
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Card(
            elevation: _isHovered ? 16 : 4,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Icon(Icons.shopping_bag, size: 80)),
                  )
                    .animate(target: _isHovered ? 1 : 0)
                    .scale(
                      begin: Offset(1, 1),
                      end: Offset(1.05, 1.05),
                      duration: 200.ms,
                    ),

                  SizedBox(height: 16),

                  // Product Title
                  Text(
                    'Amazing Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  // Price
                  Text(
                    '\$99.99',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Add to Cart'),
                    ),
                  )
                    .animate(target: _isHovered ? 1 : 0)
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: 200.ms,
                    )
                    .fadeIn(duration: 200.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 8. Performance Tips

### Tip 1: Use Target for Interactive Animations

```dart
// ❌ BAD: Rebuilding widget creates new animation
class BadInteractive extends StatefulWidget {
  @override
  State<BadInteractive> createState() => _BadInteractiveState();
}

class _BadInteractiveState extends State<BadInteractive> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      )
        // New animation created on every setState!
        .animate()
        .scale(
          begin: Offset(1, 1),
          end: _isPressed ? Offset(0.9, 0.9) : Offset(1, 1),
        ),
    );
  }
}

// ✅ GOOD: Use target parameter
class GoodInteractive extends StatefulWidget {
  @override
  State<GoodInteractive> createState() => _GoodInteractiveState();
}

class _GoodInteractiveState extends State<GoodInteractive> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      )
        .animate(target: _isPressed ? 1 : 0)  // Reuses animation controller
        .scale(
          begin: Offset(1, 1),
          end: Offset(0.9, 0.9),
          duration: 100.ms,
        ),
    );
  }
}
```

### Tip 2: Const Animations

```dart
// ✅ Define animation once, reuse everywhere
class AnimationConstants {
  static final fadeInSlide = (Widget widget) => widget
      .animate()
      .fadeIn(duration: 600.ms)
      .slideY(begin: 0.1, end: 0);

  static final scaleIn = (Widget widget) => widget
      .animate()
      .scale(
        begin: Offset(0.8, 0.8),
        end: Offset(1, 1),
        duration: 400.ms,
        curve: Curves.easeOut,
      );
}

// Use:
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimationConstants.fadeInSlide(Text('Title 1')),
        AnimationConstants.fadeInSlide(Text('Title 2')),
        AnimationConstants.scaleIn(Icon(Icons.star)),
      ],
    );
  }
}
```

---

## 9. Available Effects Quick Reference

```dart
// Basic Effects
.fadeIn()           // Opacity 0 → 1
.fadeOut()          // Opacity 1 → 0
.scale()            // Size change
.rotate()           // Rotation
.flip()             // 3D flip
.slideX()           // Horizontal slide
.slideY()           // Vertical slide
.move()             // Custom movement

// Visual Effects
.blur()             // Blur effect
.shimmer()          // Shimmer/shine effect
.tint()             // Color tint
.saturate()         // Color saturation
.desaturate()       // Remove color

// Interactive Effects
.shake()            // Shake/vibrate
.elevation()        // Shadow depth

// Custom
.custom()           // Custom animation builder
.callback()         // Execute code at specific time

// Timing
.then()             // Sequential animations
duration: 500.ms    // Duration
delay: 200.ms       // Delay before starting
curve: Curves.ease  // Animation curve
```

---

## 10. Complete Shopping App Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Shop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AnimatedShopHome(),
    );
  }
}

class AnimatedShopHome extends StatelessWidget {
  final products = List.generate(
    20,
    (i) => Product(
      id: '$i',
      name: 'Product $i',
      price: (i + 1) * 10.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Shop')
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return AnimatedProductCard(
            product: products[index],
            index: index,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.shopping_cart),
      )
        .animate()
        .fadeIn(delay: 1000.ms)
        .scale(
          begin: Offset(0, 0),
          end: Offset(1, 1),
          delay: 1000.ms,
          curve: Curves.elasticOut,
        ),
    );
  }
}

class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final int index;

  const AnimatedProductCard({
    required this.product,
    required this.index,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Center(
                    child: Icon(Icons.shopping_bag, size: 60, color: Colors.grey[400]),
                  ),
                ),

                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                  )
                    .animate(target: _isFavorite ? 1 : 0)
                    .scale(
                      begin: Offset(1, 1),
                      end: Offset(1.3, 1.3),
                      duration: 200.ms,
                    ),
                ),
              ],
            ),
          ),

          // Product Info
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(
        duration: 600.ms,
        delay: (widget.index * 100).ms,  // Stagger effect
      )
      .slideY(
        begin: 0.3,
        end: 0,
        duration: 600.ms,
        delay: (widget.index * 100).ms,
      );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
```

---

## Quick Reference

### Basic Setup

```dart
// 1. Add to widget
Text('Hello').animate()

// 2. Add effect
Text('Hello').animate().fadeIn()

// 3. Chain effects
Text('Hello')
  .animate()
  .fadeIn()
  .slideX()
  .scale()

// 4. Add timing
Text('Hello')
  .animate()
  .fadeIn(duration: 600.ms, delay: 200.ms)
```

### Common Patterns

```dart
// Staggered list
.animate()
.fadeIn(delay: (index * 100).ms)

// Repeat animation
.animate(onComplete: (c) => c.repeat())

// Reverse animation
.animate(onComplete: (c) => c.repeat(reverse: true))

// Interactive animation
.animate(target: isPressed ? 1 : 0)
```

---

## What's Next?

Master `flutter_animate`! Next:

- **14y. Lottie Animations** - JSON-based animations
- **14z. Rive Animations** - Interactive animations
- **Advanced Animation Patterns**

---

## Navigation

- Previous: [14c. Optimization Techniques](14c-OptimizationTechniques.md)
- Next: [14y. Lottie Animations](14y-LottieAnimations.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 20 minutes**

**Remember**: `flutter_animate` is like magic for animations - declarative, chainable, and beautiful. Just add `.animate()` and chain effects to create stunning animations with minimal code!
