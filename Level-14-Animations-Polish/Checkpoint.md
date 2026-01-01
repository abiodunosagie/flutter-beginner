# Level 14 Checkpoint: Animations & Polish

Before moving to Level 15, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Animation Types
When would you use each?

| Type | Use When |
|------|----------|
| Implicit animation | ___ |
| Explicit animation | ___ |
| Hero animation | ___ |
| Physics-based animation | ___ |

<details>
<summary>Check Answers</summary>

| Type | Use When |
|------|----------|
| Implicit animation | Simple property changes (size, color, opacity) |
| Explicit animation | Complex, custom, or repeating animations |
| Hero animation | Shared element between pages |
| Physics-based animation | Natural, spring-like motion |

</details>

---

### 2. AnimationController
What does each part do?

```dart
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

<details>
<summary>Check Answer</summary>

- **SingleTickerProviderStateMixin**: Provides vsync for smooth 60fps
- **AnimationController**: Controls the animation (start, stop, reverse)
- **duration**: How long the animation takes
- **vsync: this**: Syncs with screen refresh rate
- **Tween**: Defines start and end values
- **CurvedAnimation**: Applies easing curve
- **dispose()**: MUST dispose controller to prevent memory leaks

</details>

---

### 3. Implicit Animations
What does each widget animate?

```dart
AnimatedContainer()
AnimatedOpacity()
AnimatedScale()
AnimatedSlide()
AnimatedSwitcher()
AnimatedList()
```

<details>
<summary>Check Answers</summary>

- **AnimatedContainer**: Size, padding, margin, color, decoration
- **AnimatedOpacity**: Fade in/out (0.0 to 1.0)
- **AnimatedScale**: Grow/shrink
- **AnimatedSlide**: Move position (as Offset)
- **AnimatedSwitcher**: Crossfade between different children
- **AnimatedList**: Animate list item add/remove

</details>

---

### 4. Curves
Match the curve to its effect:

| Curve | Effect |
|-------|--------|
| Curves.linear | ___ |
| Curves.easeIn | ___ |
| Curves.easeOut | ___ |
| Curves.easeInOut | ___ |
| Curves.bounceOut | ___ |
| Curves.elasticOut | ___ |

<details>
<summary>Check Answers</summary>

| Curve | Effect |
|-------|--------|
| Curves.linear | Constant speed |
| Curves.easeIn | Start slow, end fast |
| Curves.easeOut | Start fast, end slow |
| Curves.easeInOut | Slow-fast-slow |
| Curves.bounceOut | Bounces at end |
| Curves.elasticOut | Springs past target, settles |

</details>

---

### 5. Hero Animation
What makes this work?

```dart
// Screen A
Hero(
  tag: 'product-123',
  child: Image.network(product.imageUrl),
)

// Screen B
Hero(
  tag: 'product-123',
  child: Image.network(product.imageUrl),
)
```

<details>
<summary>Check Answer</summary>

- **Same tag**: Both Hero widgets have identical tag 'product-123'
- **Navigation**: When navigating between screens, Flutter finds matching tags
- **Automatic animation**: Image "flies" from position A to position B
- **Shared element**: Creates illusion of same image moving

The tag must be unique - use product ID to avoid conflicts.

</details>

---

### 6. Staggered Animation
What does this code produce?

```dart
final controller = AnimationController(
  duration: Duration(milliseconds: 1000),
  vsync: this,
);

final opacity = Tween(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: controller,
    curve: Interval(0.0, 0.5),  // First half
  ),
);

final scale = Tween(begin: 0.5, end: 1.0).animate(
  CurvedAnimation(
    parent: controller,
    curve: Interval(0.5, 1.0),  // Second half
  ),
);
```

<details>
<summary>Check Answer</summary>

Creates a staggered animation:
1. **0-500ms**: Opacity fades from 0 to 1
2. **500-1000ms**: Scale grows from 0.5 to 1.0

The `Interval` defines what portion of the controller's duration this animation uses.

This creates a sequence: fade in first, then scale up.

</details>

---

## Hands-On Check

### Task 1: Animated Button
Create a button that scales down when pressed:

```dart
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  // Scales to 0.95 on press
  // Returns to 1.0 on release
  // Smooth animation
}
```

<details>
<summary>Example Solution</summary>

```dart
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
```

</details>

---

### Task 2: Fade-in List
Animate products appearing one by one:

```dart
class FadeInList extends StatefulWidget {
  final List<Widget> children;

  // Each item fades in with 100ms delay
}
```

<details>
<summary>Example Solution</summary>

```dart
class FadeInList extends StatefulWidget {
  final List<Widget> children;

  const FadeInList({super.key, required this.children});

  @override
  State<FadeInList> createState() => _FadeInListState();
}

class _FadeInListState extends State<FadeInList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100 * widget.children.length + 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        final start = index / (widget.children.length + 3);
        final end = (index + 1) / (widget.children.length + 3);

        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Opacity(
            opacity: animation.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - animation.value)),
              child: child,
            ),
          ),
          child: widget.children[index],
        );
      }),
    );
  }
}
```

</details>

---

### Task 3: Loading Shimmer
Create a shimmer effect for loading states:

```dart
class Shimmer extends StatefulWidget {
  final double width;
  final double height;

  // Animated gradient that moves left to right
  // Repeating animation
}
```

<details>
<summary>Example Solution</summary>

```dart
class Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const Shimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(2 * _controller.value, 0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| AnimationController | _________________ |
| Tween | _________________ |
| Curve | _________________ |
| vsync | _________________ |
| Implicit animation | _________________ |
| Hero animation | _________________ |
| Staggered animation | _________________ |

---

## Ready for Level 15?

### I can confidently:
- [ ] Use AnimatedContainer and other implicit animations
- [ ] Create AnimationController with proper lifecycle
- [ ] Define Tweens for different value types
- [ ] Apply curves for natural motion
- [ ] Build Hero animations between screens
- [ ] Create staggered animations with Interval
- [ ] Implement loading shimmer effects
- [ ] Respect reduced motion accessibility setting

### Capstone Progress:
- [ ] Product cards animate on tap
- [ ] Add to cart shows success animation
- [ ] Page transitions are smooth
- [ ] Loading states use shimmer
- [ ] List items animate in

---

## If You're Stuck

**Common issues at this level:**

1. **Animation not playing**
   - Did you call `controller.forward()`?
   - Check that controller is initialized in initState

2. **Memory leak warning**
   - Always dispose AnimationController
   - Dispose in dispose() method

3. **Janky animations**
   - Use const widgets where possible
   - Check for unnecessary rebuilds
   - Profile with Flutter DevTools

4. **Hero animation not working**
   - Tags must match exactly
   - Both screens need Hero widget
   - Can't have duplicate tags

---

**Ready to level up? Head to Level 15: App Deployment!**
