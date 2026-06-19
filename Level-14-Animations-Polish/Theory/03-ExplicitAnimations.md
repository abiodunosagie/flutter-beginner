# Explicit Animations

## The Big Idea In One Sentence

> Explicit animations give you full control with an `AnimationController` (you start, stop, reverse, repeat), which you must create in a State with a ticker and `dispose` when done.

## The Simple Explanation

Explicit animations give you full control - like driving a car instead of being a passenger. You control when it starts, stops, loops, and exactly how it moves!

```
┌─────────────────────────────────────────────────────────────┐
│          IMPLICIT vs EXPLICIT ANIMATIONS                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  IMPLICIT (Passenger):                                       │
│  "I want to be at position 200"                             │
│  Flutter: "Got it, I'll take you there smoothly"            │
│                                                              │
│  EXPLICIT (Driver):                                          │
│  "Start engine, go forward, speed up, slow down, stop"      │
│  Flutter: "You're in control!"                              │
│                                                              │
│  EXPLICIT gives you:                                         │
│  ✓ Play, pause, stop, reverse                               │
│  ✓ Looping and repeating                                    │
│  ✓ Precise timing control                                   │
│  ✓ Listen to animation progress                             │
│  ✓ Coordinate multiple animations                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## The Building Blocks

```
┌─────────────────────────────────────────────────────────────┐
│            EXPLICIT ANIMATION COMPONENTS                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. AnimationController (The Engine)                         │
│     └── Drives the animation, goes from 0.0 to 1.0          │
│                                                              │
│  2. Tween (The Mapper)                                       │
│     └── Maps 0.0-1.0 to your actual values (0-360 degrees)  │
│                                                              │
│  3. Animation (The Value)                                    │
│     └── The current animated value you use in widgets       │
│                                                              │
│  4. AnimatedWidget or AnimatedBuilder (The Renderer)         │
│     └── Rebuilds UI when animation changes                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘

  Controller (0→1) → Tween (map values) → Animation → Widget
```

---

## Basic Setup

```dart
class BasicAnimation extends StatefulWidget {
  @override
  State<BasicAnimation> createState() => _BasicAnimationState();
}

class _BasicAnimationState extends State<BasicAnimation>
    with SingleTickerProviderStateMixin {  // Required for vsync!

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Step 1: Create the controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,  // Syncs with screen refresh rate
    );

    // Step 2: Create the animation with a Tween
    _animation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(_controller);

    // Step 3: Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();  // ALWAYS dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Step 4: Use AnimatedBuilder to rebuild on changes
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          color: Colors.blue,
          child: child,
        );
      },
      child: const Center(
        child: Text('Growing!', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
```

---

## AnimationController in Detail

```dart
// Creating a controller:
_controller = AnimationController(
  duration: const Duration(milliseconds: 500),  // Total duration
  vsync: this,  // Required: sync with display

  // Optional:
  lowerBound: 0.0,  // Default: 0.0
  upperBound: 1.0,  // Default: 1.0
  value: 0.5,       // Starting value (default: lowerBound)
);

// Controller methods:
_controller.forward();           // Play 0 → 1
_controller.forward(from: 0.5);  // Play from middle
_controller.reverse();           // Play 1 → 0
_controller.reverse(from: 0.5);  // Reverse from middle
_controller.reset();             // Jump to 0
_controller.stop();              // Pause at current position

_controller.repeat();                    // Loop: 0→1, 0→1, 0→1...
_controller.repeat(reverse: true);       // Ping-pong: 0→1→0→1→0...
_controller.repeat(min: 0.2, max: 0.8);  // Loop within range

_controller.animateTo(0.7);              // Animate to specific value
_controller.animateTo(0.7, duration: Duration(milliseconds: 200));

// Controller properties:
_controller.value;        // Current value (0.0 to 1.0)
_controller.status;       // AnimationStatus enum
_controller.isAnimating;  // true if running
_controller.isCompleted;  // true if at 1.0
_controller.isDismissed;  // true if at 0.0
```

---

## Tweens Explained

Tweens map the controller's 0-1 range to your actual values:

```dart
// Double tween (most common)
Tween<double>(begin: 0, end: 200)

// Color tween
ColorTween(begin: Colors.red, end: Colors.blue)

// Offset tween (for position)
Tween<Offset>(
  begin: const Offset(0, 0),
  end: const Offset(100, 50),
)

// Size tween
Tween<Size>(
  begin: const Size(50, 50),
  end: const Size(200, 200),
)

// Border radius tween
BorderRadiusTween(
  begin: BorderRadius.circular(0),
  end: BorderRadius.circular(20),
)

// EdgeInsets tween (padding/margin)
EdgeInsetsTween(
  begin: EdgeInsets.zero,
  end: const EdgeInsets.all(20),
)

// Decoration tween
DecorationTween(
  begin: BoxDecoration(color: Colors.red),
  end: BoxDecoration(color: Colors.blue),
)
```

---

## Using Curves with Tweens

```dart
// Add a curve to control how the animation moves:

_animation = Tween<double>(
  begin: 0,
  end: 200,
).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,  // How it moves forward
    reverseCurve: Curves.easeIn,  // How it moves backward
  ),
);

// Common curves:
// Curves.linear       - Constant speed
// Curves.easeIn       - Slow start
// Curves.easeOut      - Slow end
// Curves.easeInOut    - Slow start and end
// Curves.bounceOut    - Bouncy finish
// Curves.elasticOut   - Springy effect
// Curves.decelerate   - Starts fast, slows down
// Curves.fastOutSlowIn - Material Design standard
```

---

## Listening to Animation Changes

```dart
@override
void initState() {
  super.initState();
  _controller = AnimationController(...);

  // Listen to every frame (value changes)
  _controller.addListener(() {
    print('Value: ${_controller.value}');
    // Call setState if not using AnimatedBuilder
    // setState(() {});
  });

  // Listen to status changes
  _controller.addStatusListener((status) {
    switch (status) {
      case AnimationStatus.forward:
        print('Animation is playing forward');
        break;
      case AnimationStatus.reverse:
        print('Animation is playing backward');
        break;
      case AnimationStatus.completed:
        print('Animation finished at end');
        // Maybe reverse automatically:
        _controller.reverse();
        break;
      case AnimationStatus.dismissed:
        print('Animation finished at start');
        // Maybe play again:
        _controller.forward();
        break;
    }
  });
}
```

---

## AnimatedBuilder vs AnimatedWidget

### AnimatedBuilder (Inline)

```dart
// Good for: One-off animations, simple cases

@override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: _animation,
    builder: (context, child) {
      return Transform.rotate(
        angle: _animation.value,
        child: child,  // Use child for performance!
      );
    },
    child: const Icon(Icons.refresh, size: 100),  // Doesn't rebuild
  );
}
```

### AnimatedWidget (Reusable)

```dart
// Good for: Reusable animated widgets

class RotatingIcon extends AnimatedWidget {
  const RotatingIcon({
    super.key,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: animation.value,
      child: const Icon(Icons.refresh, size: 100),
    );
  }
}

// Usage:
RotatingIcon(animation: _animation)
```

---

## Multiple Animations Together

```dart
class MultipleAnimations extends StatefulWidget {
  @override
  State<MultipleAnimations> createState() => _MultipleAnimationsState();
}

class _MultipleAnimationsState extends State<MultipleAnimations>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Different tweens for different properties
    _sizeAnimation = Tween<double>(begin: 50, end: 200)
        .animate(_controller);

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0)
        .animate(_controller);

    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.blue)
        .animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,  // Listen to controller, all anims update
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: _sizeAnimation.value,
            height: _sizeAnimation.value,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}
```

---

## Staggered Animations

Different parts animate at different times:

```dart
class StaggeredAnimation extends StatefulWidget {
  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // First: Size grows (0% to 40% of duration)
    _sizeAnimation = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Second: Opacity fades in (30% to 70% of duration)
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    // Third: Slides up (60% to 100% of duration)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: _sizeAnimation.value,
              height: _sizeAnimation.value,
              color: Colors.purple,
              child: const Center(
                child: Text(
                  'Staggered!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

```
INTERVAL TIMING:
────────────────────────────────────────────────>
0%        30%       40%       60%       70%     100%
|         |         |         |         |        |
|----SIZE----|
          |--------OPACITY--------|
                              |-------SLIDE------|
```

---

## Pre-built Transition Widgets

Flutter provides transition widgets for common animations:

```dart
// FadeTransition
FadeTransition(
  opacity: _opacityAnimation,
  child: widget,
)

// SlideTransition
SlideTransition(
  position: _offsetAnimation,  // Tween<Offset>
  child: widget,
)

// ScaleTransition
ScaleTransition(
  scale: _scaleAnimation,
  child: widget,
)

// RotationTransition
RotationTransition(
  turns: _rotationAnimation,  // 0.5 = 180 degrees
  child: widget,
)

// SizeTransition
SizeTransition(
  sizeFactor: _sizeAnimation,
  child: widget,
)

// DecoratedBoxTransition
DecoratedBoxTransition(
  decoration: _decorationAnimation,
  child: widget,
)
```

---

## Complete Example: Animated Menu

```dart
class AnimatedMenu extends StatefulWidget {
  @override
  State<AnimatedMenu> createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final List<Animation<double>> _itemAnimations = [];
  bool _isOpen = false;

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.settings,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create staggered animations for each item
    for (int i = 0; i < _icons.length; i++) {
      final start = i * 0.1;  // Each item starts 10% later
      final end = start + 0.6;  // Each lasts 60% of total duration

      _itemAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end.clamp(0, 1), curve: Curves.easeOut),
          ),
        ),
      );
    }
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Menu items
        ...List.generate(_icons.length, (index) {
          return AnimatedBuilder(
            animation: _itemAnimations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -70.0 * (index + 1) * _itemAnimations[index].value,
                ),
                child: Opacity(
                  opacity: _itemAnimations[index].value,
                  child: child,
                ),
              );
            },
            child: FloatingActionButton(
              mini: true,
              heroTag: 'fab_$index',
              onPressed: () {},
              child: Icon(_icons[index]),
            ),
          );
        }),

        // Main FAB
        FloatingActionButton(
          onPressed: _toggleMenu,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 0.5 * 3.14159,  // 90 degrees
                child: Icon(_isOpen ? Icons.close : Icons.add),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

---

## Multiple Controllers

Use `TickerProviderStateMixin` for multiple controllers:

```dart
class MultiControllerExample extends StatefulWidget {
  @override
  State<MultiControllerExample> createState() => _MultiControllerExampleState();
}

class _MultiControllerExampleState extends State<MultiControllerExample>
    with TickerProviderStateMixin {  // Note: TickerProviderStateMixin, not Single

  late AnimationController _scaleController;
  late AnimationController _colorController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _colorController.dispose();
    super.dispose();
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│          EXPLICIT ANIMATIONS SUMMARY                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  COMPONENTS:                                                 │
│  ├── AnimationController - Drives the animation             │
│  ├── Tween - Maps 0-1 to your values                        │
│  ├── CurvedAnimation - Adds easing/curves                   │
│  └── AnimatedBuilder - Rebuilds widget on changes           │
│                                                              │
│  CONTROLLER METHODS:                                         │
│  ├── forward(), reverse() - Play animation                  │
│  ├── repeat() - Loop animation                              │
│  ├── stop() - Pause animation                               │
│  └── addStatusListener() - React to completion              │
│                                                              │
│  STAGGERED ANIMATIONS:                                       │
│  └── Use Interval() to time different parts                 │
│                                                              │
│  TRANSITION WIDGETS:                                         │
│  ├── FadeTransition                                         │
│  ├── SlideTransition                                        │
│  ├── ScaleTransition                                        │
│  └── RotationTransition                                     │
│                                                              │
│  ALWAYS REMEMBER:                                            │
│  1. Use vsync mixin (SingleTicker or Ticker)                │
│  2. Dispose controllers in dispose()                        │
│  3. Use child parameter in AnimatedBuilder                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** When do you need explicit animations instead of implicit?

<details>
<summary>Answer</summary>
When you need control: repeating, reversing, looping, or syncing multiple animations, things implicit widgets cannot do.
</details>

**Q2.** What object drives an explicit animation?

<details>
<summary>Answer</summary>
An `AnimationController` (often with `SingleTickerProviderStateMixin` for its `vsync`).
</details>

**Q3.** Why must you call `controller.dispose()`?

<details>
<summary>Answer</summary>
To free its ticker/resources and avoid memory leaks when the widget is removed.
</details>

---

## Assignment

### Problem 1: Implicit or explicit?

You want a loading icon that spins forever. Which kind of animation, and why?

### Problem 2: The lifecycle

Name the two State methods where you create and destroy an `AnimationController`.

### Problem 3: Start it

Which controller method makes it run once forward?

---

## Assignment Answers

### Problem 1: Implicit or explicit?

**Explicit.** A forever-spinning icon needs to repeat/loop, which an `AnimationController` (`.repeat()`) handles but implicit widgets cannot.

### Problem 2: The lifecycle

Create it in `initState`, and dispose it in `dispose`.

### Problem 3: Start it

`controller.forward()`.

---

**Next:** `04-HeroAnimations.md` - Beautiful screen-to-screen transitions
