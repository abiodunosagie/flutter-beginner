# Animation Basics

## The Simple Explanation

Animations are like flipbooks - many slightly different images shown quickly make things look like they're moving! Flutter handles all the "pages" for you.

```
┌─────────────────────────────────────────────────────────────┐
│                 HOW ANIMATIONS WORK                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Frame 1    Frame 2    Frame 3    Frame 4    Frame 5        │
│    □          □          □          □          □            │
│    ↑         ↗          →          ↘          ↓            │
│   LEFT    CENTER-L   CENTER    CENTER-R    RIGHT           │
│                                                              │
│  Flutter shows these VERY fast (60 times per second)        │
│  Result: Smooth motion!                                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Animation Core Concepts

```
┌─────────────────────────────────────────────────────────────┐
│               KEY ANIMATION TERMS                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DURATION                                                    │
│  └── How long the animation takes                           │
│      Example: Duration(milliseconds: 300)                   │
│                                                              │
│  CURVE                                                       │
│  └── How the animation accelerates/decelerates              │
│      Example: Curves.easeInOut                              │
│                                                              │
│  TWEEN (In-Between)                                          │
│  └── The start and end values to animate between            │
│      Example: Tween(begin: 0.0, end: 1.0)                   │
│                                                              │
│  CONTROLLER                                                  │
│  └── The engine that drives the animation                   │
│      Controls: play, pause, reverse, repeat                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Implicit vs Explicit Animations

### Implicit Animations (Easy!)

```dart
// Just change a value, Flutter animates automatically!

AnimatedContainer(
  duration: Duration(milliseconds: 300),
  width: isExpanded ? 200 : 100,  // Change this...
  height: isExpanded ? 200 : 100, // ...and this animates!
  color: isExpanded ? Colors.blue : Colors.red,
  child: Text('Hello'),
)
```

```
IMPLICIT ANIMATION FLOW:

  State Changes → Flutter Detects → Animates Automatically
       ↓                ↓                    ↓
  isExpanded      "Oh, width          Smoothly transitions
  = true          changed!"           100 → 200
```

### Explicit Animations (Full Control!)

```dart
// You control everything!

class MyAnimation extends StatefulWidget {
  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create the controller (the engine)
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,  // Syncs with screen refresh
    );

    // Create the animation (what values to animate)
    _animation = Tween<double>(
      begin: 0,
      end: 200,
    ).animate(_controller);

    // Start it!
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();  // ALWAYS dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          color: Colors.blue,
        );
      },
    );
  }
}
```

---

## Animation Duration Guidelines

```
┌─────────────────────────────────────────────────────────────┐
│              RECOMMENDED DURATIONS                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  MICRO-INTERACTIONS (buttons, toggles)                       │
│  └── 100-200ms                                              │
│      Fast and snappy                                        │
│                                                              │
│  SIMPLE TRANSITIONS (fade, slide)                            │
│  └── 200-300ms                                              │
│      Noticeable but not slow                                │
│                                                              │
│  PAGE TRANSITIONS                                            │
│  └── 300-500ms                                              │
│      Gives context about navigation                         │
│                                                              │
│  COMPLEX ANIMATIONS (multi-step, choreographed)              │
│  └── 500-1000ms                                             │
│      Enough time to appreciate the effect                   │
│                                                              │
│  LOADING INDICATORS                                          │
│  └── Can be longer/infinite                                 │
│      User expects to wait                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘

  TOO FAST (< 100ms) = Users can't see it
  TOO SLOW (> 500ms) = Feels laggy
```

---

## Understanding Curves

Curves control how an animation progresses over time:

```dart
// Different curves, different feels

AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.linear,      // Constant speed (robotic)
  // curve: Curves.easeIn,   // Starts slow, ends fast
  // curve: Curves.easeOut,  // Starts fast, ends slow
  // curve: Curves.easeInOut, // Slow-fast-slow (natural)
  // curve: Curves.bounceOut, // Bouncy ending
  // curve: Curves.elasticOut, // Springy effect
  width: isExpanded ? 200 : 100,
)
```

### Visual Comparison

```
LINEAR:
Speed ━━━━━━━━━━━━━━━━━
      ════════════════

EASE IN:
Speed             ━━━━
      ━━━━━━━━━━━━
      Slow → Fast

EASE OUT:
Speed ━━━━
          ━━━━━━━━━━━━
      Fast → Slow

EASE IN OUT:
Speed      ━━━━
      ━━━━      ━━━━
      Slow → Fast → Slow

BOUNCE OUT:
Speed ━━━━    ━  ━
          ━━━  ━  ━
      Fast → Bounce → Settle
```

---

## The vsync Parameter

```dart
// You'll see this in explicit animations:

_controller = AnimationController(
  duration: Duration(seconds: 1),
  vsync: this,  // What is this?
);
```

```
┌─────────────────────────────────────────────────────────────┐
│                    VSYNC EXPLAINED                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  vsync = "vertical sync"                                     │
│                                                              │
│  Your screen refreshes 60 times per second (60 FPS)         │
│  vsync makes sure animation updates sync with the screen    │
│                                                              │
│  WITHOUT vsync:                                              │
│    Animation might run when screen not ready                │
│    = Wasted work, possible jitter                           │
│                                                              │
│  WITH vsync:                                                 │
│    Animation only updates when screen refreshes             │
│    = Smooth, efficient animations                           │
│                                                              │
│  HOW TO USE:                                                 │
│    with SingleTickerProviderStateMixin  ← One animation    │
│    with TickerProviderStateMixin        ← Multiple animations│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Animation Value Range

```dart
// AnimationController goes from 0.0 to 1.0 by default

_controller = AnimationController(
  duration: Duration(seconds: 1),
  vsync: this,
);

// At start: _controller.value = 0.0
// Halfway:  _controller.value = 0.5
// At end:   _controller.value = 1.0

// Use a Tween to map to different values:
final sizeAnimation = Tween<double>(
  begin: 50,   // When controller is 0.0
  end: 200,    // When controller is 1.0
).animate(_controller);

// Now:
// At start: sizeAnimation.value = 50
// Halfway:  sizeAnimation.value = 125
// At end:   sizeAnimation.value = 200
```

```
┌────────────────────────────────────────────────────────────┐
│                                                             │
│  Controller: 0.0 ─────────────────────────────────> 1.0    │
│                                                             │
│  Tween maps this to YOUR values:                           │
│                                                             │
│  Size:      50 ─────────────────────────────────> 200      │
│  Opacity:  0.0 ─────────────────────────────────> 1.0      │
│  Color:   Red ─────────────────────────────────> Blue      │
│  Position: Left ────────────────────────────────> Right    │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## Controller Methods

```dart
// Common AnimationController methods:

_controller.forward();    // Play 0 → 1
_controller.reverse();    // Play 1 → 0
_controller.reset();      // Jump to 0
_controller.stop();       // Pause at current position

_controller.repeat();     // Loop forever 0 → 1 → 0 → 1...
_controller.repeat(reverse: true);  // Ping-pong: 0 → 1 → 0 → 1...

_controller.animateTo(0.5);  // Animate to specific value

// Check status:
_controller.status;  // AnimationStatus.forward, .reverse, .completed, .dismissed
_controller.isAnimating;  // true if currently running
_controller.value;  // Current value (0.0 to 1.0)
```

---

## Listening to Animations

```dart
// React to animation changes:

@override
void initState() {
  super.initState();
  _controller = AnimationController(...);

  // Called every frame during animation
  _controller.addListener(() {
    print('Current value: ${_controller.value}');
    setState(() {});  // Trigger rebuild
  });

  // Called when animation status changes
  _controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      print('Animation finished!');
      _controller.reverse();  // Play backwards
    }
  });
}
```

---

## When to Use Which

```
┌─────────────────────────────────────────────────────────────┐
│           CHOOSING THE RIGHT APPROACH                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  USE IMPLICIT ANIMATIONS WHEN:                               │
│  ✓ Animating a single property change                       │
│  ✓ Animation triggers from state change                     │
│  ✓ You want simple, quick animations                        │
│  ✓ You don't need to control timing/looping                 │
│                                                              │
│  USE EXPLICIT ANIMATIONS WHEN:                               │
│  ✓ You need to loop or repeat                               │
│  ✓ Multiple properties animate with different timing        │
│  ✓ You need to pause/resume/reverse                         │
│  ✓ Animation should start automatically                     │
│  ✓ Complex choreographed sequences                          │
│                                                              │
│  RULE OF THUMB:                                              │
│  Start with implicit. Only use explicit when needed.        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Common Mistakes

```
❌ MISTAKE: Forgetting to dispose controller
   FIX: Always dispose in dispose() method

❌ MISTAKE: Using setState in AnimatedBuilder
   FIX: AnimatedBuilder handles rebuilds automatically

❌ MISTAKE: Too many simultaneous animations
   FIX: Limit to 2-3 animations at a time

❌ MISTAKE: Animation too slow
   FIX: Keep most animations under 500ms

❌ MISTAKE: Missing vsync mixin
   FIX: Add SingleTickerProviderStateMixin or TickerProviderStateMixin
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│            ANIMATION BASICS SUMMARY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  KEY CONCEPTS:                                               │
│  ├── Duration - How long (milliseconds)                     │
│  ├── Curve - How it moves (easeInOut, bounce)               │
│  ├── Tween - Start and end values                           │
│  └── Controller - Engine that drives animation              │
│                                                              │
│  TWO APPROACHES:                                             │
│  ├── Implicit - Easy, automatic (AnimatedContainer)         │
│  └── Explicit - Full control (AnimationController)          │
│                                                              │
│  BEST DURATIONS:                                             │
│  ├── Micro-interactions: 100-200ms                          │
│  ├── Transitions: 200-300ms                                 │
│  └── Page changes: 300-500ms                                │
│                                                              │
│  ALWAYS REMEMBER:                                            │
│  1. Dispose controllers!                                    │
│  2. Use vsync for efficiency                                │
│  3. Start simple, add complexity only if needed             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Next:** `02-ImplicitAnimations.md` - Easy animations with built-in widgets
