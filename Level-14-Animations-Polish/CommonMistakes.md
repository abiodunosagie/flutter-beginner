# Level 14: Common Mistakes

Learn from these common animation errors!

---

## Mistake #1: Forgetting to Dispose AnimationController

```dart
// ❌ WRONG - Memory leak!
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }
  // Missing dispose!
}

// ✅ RIGHT
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

---

## Mistake #2: Missing vsync

```dart
// ❌ WRONG - Can't use this without mixin
_controller = AnimationController(
  duration: Duration(seconds: 1),
  vsync: this,  // Error: 'this' is not a TickerProvider
);

// ✅ RIGHT - Add the mixin
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {  // ← Add this!
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,  // Now works
    );
  }
}
```

---

## Mistake #3: Animation Not Starting

```dart
// ❌ WRONG - Animation defined but never started
@override
void initState() {
  super.initState();
  _controller = AnimationController(...);
  _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  // Forgot to call forward()!
}

// ✅ RIGHT
@override
void initState() {
  super.initState();
  _controller = AnimationController(...);
  _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  _controller.forward();  // Start it!
}
```

---

## Mistake #4: Using Wrong Mixin for Multiple Animations

```dart
// ❌ WRONG - SingleTicker for multiple controllers
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;  // Error or warning!
}

// ✅ RIGHT - Use TickerProviderStateMixin for multiple
class _MyWidgetState extends State<MyWidget>
    with TickerProviderStateMixin {  // ← No "Single"
  late AnimationController _controller1;
  late AnimationController _controller2;
}
```

---

## Mistake #5: Rebuilding Entire Widget

```dart
// ❌ WRONG - setState rebuilds everything
_controller.addListener(() {
  setState(() {});  // Rebuilds entire widget tree!
});

// ✅ RIGHT - Use AnimatedBuilder
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.scale(
      scale: _animation.value,
      child: child,  // Child not rebuilt
    );
  },
  child: ExpensiveWidget(),  // Built once, reused
)
```

---

## Mistake #6: Hero Tags Not Matching

```dart
// ❌ WRONG - Tags don't match
// Screen A
Hero(
  tag: 'product-image',
  child: Image.network(product.imageUrl),
)

// Screen B
Hero(
  tag: 'product_image',  // Different tag! (underscore vs dash)
  child: Image.network(product.imageUrl),
)

// ✅ RIGHT - Exact match
// Screen A
Hero(
  tag: 'product-${product.id}',
  child: Image.network(product.imageUrl),
)

// Screen B
Hero(
  tag: 'product-${product.id}',  // Same tag
  child: Image.network(product.imageUrl),
)
```

---

## Mistake #7: Wrong Duration for UI Feedback

```dart
// ❌ WRONG - Too slow for button feedback
AnimatedContainer(
  duration: Duration(seconds: 2),  // Feels unresponsive!
  // ...
)

// ✅ RIGHT - Quick for feedback
AnimatedContainer(
  duration: Duration(milliseconds: 150),  // Snappy!
  // ...
)
```

**Guidelines:**
- Button feedback: 100-150ms
- Page transitions: 200-350ms
- Complex animations: 300-500ms

---

## Mistake #8: Ignoring Reduced Motion

```dart
// ❌ WRONG - Animations for everyone
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  // ...
)

// ✅ RIGHT - Respect accessibility settings
AnimatedContainer(
  duration: MediaQuery.of(context).disableAnimations
      ? Duration.zero
      : Duration(milliseconds: 300),
  // ...
)
```

---

## Mistake #9: Animating Wrong Properties

```dart
// ❌ WRONG - Animating color is expensive
AnimatedContainer(
  color: isActive ? Colors.blue : Colors.grey,  // Repaints entire area
)

// ✅ RIGHT - Use opacity when possible
AnimatedOpacity(
  opacity: isActive ? 1.0 : 0.5,  // Just compositing
  child: Container(color: Colors.blue),
)
```

---

## Mistake #10: Animation Curve Misuse

```dart
// ❌ WRONG - Linear feels robotic
_animation = Tween<double>(begin: 0, end: 1).animate(_controller);

// ✅ RIGHT - Add curve for natural motion
_animation = Tween<double>(begin: 0, end: 1).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,  // Fast start, slow end
  ),
);
```

---

## Quick Reference: Animation Types

| Situation | Use |
|-----------|-----|
| Simple property change | `AnimatedContainer`, `AnimatedOpacity`, etc. |
| Custom timing control | `AnimationController` + `AnimatedBuilder` |
| Shared element between screens | `Hero` |
| List item add/remove | `AnimatedList` |
| Child widget change | `AnimatedSwitcher` |
| Physics-based | `AnimatedPhysics`, Spring |

---

**Still stuck? Re-read the Theory files or ask for help!**
