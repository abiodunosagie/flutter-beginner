# Flutter Animate Package: Easy Declarative Animations

## The Big Idea In One Sentence

> The `flutter_animate` package lets you add and chain animations by just tacking them onto a widget, like `Text('Hi').animate().fadeIn().slideX()`, no controllers needed.

## The Simple Explanation

Imagine you have magic stickers that make things move! Instead of writing complicated code, you just stick them on your widgets and they automatically animate. That's what flutter_animate does!

```
┌─────────────────────────────────────────────────────────┐
│             FLUTTER_ANIMATE PACKAGE                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  NORMAL WAY (Complex):                                   │
│  • Create AnimationController                            │
│  • Create Tween                                          │
│  • Create Animation                                      │
│  • Use AnimatedBuilder                                   │
│  • Remember to dispose!                                  │
│  Result: 30+ lines of code 😫                           │
│                                                          │
│  FLUTTER_ANIMATE WAY (Easy):                             │
│  Text('Hello').animate().fadeIn()                        │
│  Result: 1 line of code! 🎉                             │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Setup

### Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_animate: ^4.5.0
```

### Import

```dart
import 'package:flutter_animate/flutter_animate.dart';
```

---

## Basic Usage

### Fade In Animation

```dart
// Instead of this (20 lines):
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Hello'),
)

// Use this (1 line):
Text('Hello').animate().fadeIn()
```

### Multiple Effects

```dart
// Chain multiple effects together!
Text('Hello')
    .animate()
    .fadeIn()        // First fade in
    .slideX()        // Then slide horizontally
    .scale();        // Then scale up
```

---

## Built-in Effects

### Fade Effects

```dart
// Fade in (0% → 100% opacity)
Text('Fade In').animate().fadeIn()

// Fade out (100% → 0% opacity)
Text('Fade Out').animate().fadeOut()

// Fade in AND out
Text('Fade')
    .animate()
    .fadeIn(duration: 600.ms)
    .then()
    .fadeOut(duration: 600.ms)

// Custom fade (30% → 80% opacity)
Text('Custom')
    .animate()
    .fade(begin: 0.3, end: 0.8)
```

### Scale Effects

```dart
// Scale up from 0 to 100%
Text('Scale Up').animate().scale()

// Scale from 50% to 150%
Text('Bounce')
    .animate()
    .scale(begin: Offset(0.5, 0.5), end: Offset(1.5, 1.5))

// Scale only width
Text('Stretch')
    .animate()
    .scaleX(begin: 0.5, end: 1.5)

// Scale only height
Text('Grow')
    .animate()
    .scaleY(begin: 0.0, end: 1.0)
```

### Slide Effects

```dart
// Slide in from left
Text('From Left')
    .animate()
    .slideX(begin: -1, end: 0)  // -1 = one screen width left

// Slide in from right
Text('From Right')
    .animate()
    .slideX(begin: 1, end: 0)   // 1 = one screen width right

// Slide in from top
Text('From Top')
    .animate()
    .slideY(begin: -1, end: 0)

// Slide in from bottom
Text('From Bottom')
    .animate()
    .slideY(begin: 1, end: 0)

// Diagonal slide
Text('Diagonal')
    .animate()
    .slide(begin: Offset(-1, -1), end: Offset.zero)
```

### Rotate Effects

```dart
// Rotate 360 degrees
Icon(Icons.refresh)
    .animate()
    .rotate(begin: 0, end: 1)  // 0-1 = 0-360 degrees

// Rotate multiple times
Icon(Icons.star)
    .animate(onComplete: (controller) => controller.repeat())
    .rotate(begin: 0, end: 2)  // 2 = 720 degrees (two full rotations)

// Rotate backwards
Icon(Icons.undo)
    .animate()
    .rotate(begin: 0, end: -1)  // Negative = counterclockwise
```

### Blur Effects

```dart
// Blur in (blurry → sharp)
Image.asset('photo.jpg')
    .animate()
    .blur(begin: Offset(10, 10), end: Offset.zero)

// Blur out (sharp → blurry)
Image.asset('photo.jpg')
    .animate()
    .blur(begin: Offset.zero, end: Offset(10, 10))
```

### Color Effects

```dart
// Tint with color
Text('Colorize')
    .animate()
    .tint(color: Colors.blue)

// Saturate (make more vivid)
Image.asset('photo.jpg')
    .animate()
    .saturate()

// Desaturate (make grayscale)
Image.asset('photo.jpg')
    .animate()
    .desaturate()
```

---

## Timing and Duration

### Custom Duration

```dart
// Default is 300ms
Text('Fast').animate().fadeIn()  // 300ms

// Custom duration
Text('Slow')
    .animate()
    .fadeIn(duration: 2.seconds)  // 2000ms

// Multiple durations
Text('Mixed')
    .animate()
    .fadeIn(duration: 500.ms)
    .scale(duration: 1.seconds)
```

### Delay

```dart
// Wait before starting
Text('Delayed')
    .animate()
    .fadeIn(delay: 500.ms)  // Wait 500ms, then fade in

// Staggered animations
Column(
  children: [
    Text('First').animate().fadeIn(),
    Text('Second').animate().fadeIn(delay: 100.ms),
    Text('Third').animate().fadeIn(delay: 200.ms),
    Text('Fourth').animate().fadeIn(delay: 300.ms),
  ],
)
```

### Curves

```dart
// Different motion curves
Text('Linear')
    .animate()
    .fadeIn(curve: Curves.linear)  // Constant speed

Text('Ease')
    .animate()
    .fadeIn(curve: Curves.easeInOut)  // Slow-fast-slow

Text('Bounce')
    .animate()
    .slideY(curve: Curves.bounceOut)  // Bouncy!

Text('Elastic')
    .animate()
    .scale(curve: Curves.elasticOut)  // Springy!
```

---

## Sequencing Animations

### Using .then()

```dart
// One after another
Text('Sequential')
    .animate()
    .fadeIn(duration: 500.ms)      // First: fade in
    .then()                         // Wait for previous to finish
    .slideX(duration: 500.ms)      // Then: slide
    .then()
    .scale(duration: 500.ms);      // Finally: scale

// Visual timeline:
// 0-500ms:   fadeIn
// 500-1000ms: slideX
// 1000-1500ms: scale
```

### Simultaneous Animations

```dart
// All at once (don't use .then())
Text('Together')
    .animate()
    .fadeIn(duration: 500.ms)
    .slideX(duration: 500.ms)
    .scale(duration: 500.ms);

// All three effects happen at the same time!
```

### Custom Sequence

```dart
// Complex sequence
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
)
    .animate()
    // Step 1: Fade in
    .fadeIn(duration: 300.ms)
    .then(delay: 200.ms)  // Pause 200ms
    // Step 2: Slide and scale together
    .slideX(begin: -1, duration: 500.ms)
    .scale(begin: Offset(0.5, 0.5), duration: 500.ms)
    .then(delay: 100.ms)  // Pause 100ms
    // Step 3: Rotate
    .rotate(end: 1, duration: 600.ms);
```

---

## Advanced Effects

### Shimmer Effect

```dart
// Loading shimmer
Container(
  width: 200,
  height: 100,
  color: Colors.grey[300],
)
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(duration: 1500.ms, color: Colors.white);
```

### Shake Effect

```dart
// Shake on error
TextField()
    .animate()
    .shake(duration: 500.ms, hz: 4);  // Shake 4 times per second

// Error message shake
Text('Invalid password!')
    .animate(onPlay: (controller) => controller.forward())
    .shake();
```

### Flip Effect

```dart
// Flip horizontally
Card(child: Text('Flip Me'))
    .animate()
    .flipH(begin: 0, end: 1);  // 0-1 = 0-180 degrees

// Flip vertically
Card(child: Text('Flip Me'))
    .animate()
    .flipV(begin: 0, end: 1);
```

### Swap Effect

```dart
// Swap between two widgets
Container(
  child: isLoggedIn
      ? Text('Welcome!').animate().swap(
          duration: 500.ms,
          builder: (child) => Text('Please log in'),
        )
      : Text('Please log in'),
)
```

---

## Practical Examples

### Example 1: Animated Welcome Screen

```dart
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo: Scale in with bounce
            FlutterLogo(size: 100)
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 40),

            // Title: Fade in, then slide
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 20),

            // Subtitle: Fade in later
            const Text(
              'Get started with your journey',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 600.ms),

            const SizedBox(height: 60),

            // Button: Final element
            ElevatedButton(
              onPressed: () {},
              child: const Text('Get Started'),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 900.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
```

---

### Example 2: Animated Product Card

```dart
class ProductCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image: Fade and scale in
          Image.network(imageUrl)
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                curve: Curves.easeOut,
              ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name: Slide from left
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 8),

                // Price: Fade in last
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms),
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

### Example 3: Loading Skeleton

```dart
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(duration: 1500.ms),

        const SizedBox(height: 16),

        // Title placeholder
        Container(
          width: 200,
          height: 20,
          color: Colors.grey[300],
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(duration: 1500.ms, delay: 200.ms),

        const SizedBox(height: 8),

        // Subtitle placeholder
        Container(
          width: 150,
          height: 16,
          color: Colors.grey[300],
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(duration: 1500.ms, delay: 400.ms),
      ],
    );
  }
}
```

---

### Example 4: Animated List with Stagger

```dart
class AnimatedTodoList extends StatelessWidget {
  final List<String> todos = [
    'Buy groceries',
    'Walk the dog',
    'Read a book',
    'Exercise',
    'Call mom',
  ];

  AnimatedTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(todos[index]),
        )
            .animate()
            .fadeIn(
              duration: 500.ms,
              delay: (100 * index).ms,  // Stagger: 0ms, 100ms, 200ms, 300ms...
            )
            .slideX(
              begin: -0.3,
              duration: 500.ms,
              delay: (100 * index).ms,
            );
      },
    );
  }
}
```

---

## Animation Controllers

### Access the Controller

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Controlled')
            .animate(
              onInit: (controller) => _controller = controller,
            )
            .fadeIn(),

        ElevatedButton(
          onPressed: () => _controller.forward(),
          child: const Text('Play'),
        ),
        ElevatedButton(
          onPressed: () => _controller.reverse(),
          child: const Text('Reverse'),
        ),
      ],
    );
  }
}
```

### Loop Animation

```dart
// Repeat forever
Icon(Icons.favorite)
    .animate(onPlay: (controller) => controller.repeat())
    .scale(end: const Offset(1.2, 1.2))
    .then()
    .scale(end: const Offset(1.0, 1.0));

// Repeat with reverse
Container(color: Colors.blue)
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .fadeIn()
    .fadeOut();
```

---

## Custom Effects

### Create Your Own Effect

```dart
extension CustomAnimations on Widget {
  // Wobble effect
  Widget wobble() {
    return animate()
        .rotate(begin: 0, end: 0.05)
        .then()
        .rotate(begin: 0.05, end: -0.05)
        .then()
        .rotate(begin: -0.05, end: 0);
  }

  // Pulse effect
  Widget pulse() {
    return animate(onPlay: (controller) => controller.repeat())
        .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1))
        .then()
        .scale(begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0));
  }
}

// Usage:
Text('Wobble').wobble()
Icon(Icons.favorite).pulse()
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│          FLUTTER_ANIMATE PACKAGE SUMMARY                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  BASIC EFFECTS:                                          │
│  • fadeIn() / fadeOut()                                  │
│  • scale() / scaleX() / scaleY()                         │
│  • slide() / slideX() / slideY()                         │
│  • rotate()                                              │
│  • blur()                                                │
│                                                          │
│  ADVANCED EFFECTS:                                       │
│  • shimmer() - Loading effect                            │
│  • shake() - Error feedback                              │
│  • flip() - Card flip                                    │
│  • tint() - Color overlay                                │
│                                                          │
│  SEQUENCING:                                             │
│  • .then() - Run next after current                      │
│  • delay - Wait before starting                          │
│  • No .then() - Run simultaneously                       │
│                                                          │
│  TIMING:                                                 │
│  • duration: 500.ms                                      │
│  • delay: 200.ms                                         │
│  • curve: Curves.easeInOut                               │
│                                                          │
│  CONTROL:                                                │
│  • onPlay - Auto-play control                            │
│  • onInit - Get controller reference                     │
│  • controller.repeat() - Loop                            │
│  • controller.reverse() - Play backwards                 │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** How do you make effects run one after another?

<details>
<summary>Answer</summary>

Use `.then()` between effects:

```dart
Text('Hello')
    .animate()
    .fadeIn()
    .then()      // Wait for fadeIn to finish
    .slideX()
    .then()      // Wait for slideX to finish
    .scale();
```

</details>

**Q2:** How do you create a repeating animation?

<details>
<summary>Answer</summary>

Use `onPlay` callback with `controller.repeat()`:

```dart
Icon(Icons.refresh)
    .animate(onPlay: (controller) => controller.repeat())
    .rotate();
```

</details>

**Q3:** How do you stagger animations in a list?

<details>
<summary>Answer</summary>

Use index-based delay:

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'))
        .animate()
        .fadeIn(delay: (100 * index).ms);  // 0ms, 100ms, 200ms...
  },
)
```

</details>

---

**Next:** Learn about Lottie animations for designer-created animations.

---

## Navigation

## Assignment

### Problem 1: Fade in

Using flutter_animate, write the expression to fade in a `Text('Hello')`.

### Problem 2: Chain two

How would you make that text fade in AND slide in?

### Problem 3: Why use it?

In one line, what does flutter_animate save you compared to an AnimationController?

---

## Assignment Answers

### Problem 1: Fade in

```dart
Text('Hello').animate().fadeIn();
```

### Problem 2: Chain two

```dart
Text('Hello').animate().fadeIn().slideX();
```

You chain effects with `.` and they run together/in sequence.

### Problem 3: Why use it?

It removes the boilerplate: no controller, no ticker, no dispose, just chain effects onto the widget.

---

⬅️ **Previous:** [Polish & Microinteractions](05-PolishMicrointeractions.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Lottie Animations](07-LottieAnimations.md)
