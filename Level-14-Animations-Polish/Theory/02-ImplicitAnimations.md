# Implicit Animations

## The Simple Explanation

Implicit animations are like magic - you just change a value, and Flutter automatically animates the change! No controllers, no complexity.

```
┌─────────────────────────────────────────────────────────────┐
│              IMPLICIT ANIMATIONS                             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  HOW IT WORKS:                                               │
│                                                              │
│  1. Tell Flutter what to animate:                           │
│     AnimatedContainer(width: currentWidth, ...)             │
│                                                              │
│  2. Change the value:                                        │
│     setState(() => currentWidth = 200);                     │
│                                                              │
│  3. Flutter animates automatically!                          │
│     100 ~~~smooth transition~~~> 200                        │
│                                                              │
│  That's it! No controllers needed!                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## AnimatedContainer

The most versatile implicit animation widget. Animates almost any property!

```dart
class ExpandingBox extends StatefulWidget {
  @override
  State<ExpandingBox> createState() => _ExpandingBoxState();
}

class _ExpandingBoxState extends State<ExpandingBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        // Required: How long should the animation take?
        duration: const Duration(milliseconds: 300),

        // Optional: How should it move?
        curve: Curves.easeInOut,

        // Animate size
        width: _isExpanded ? 200 : 100,
        height: _isExpanded ? 200 : 100,

        // Animate color
        color: _isExpanded ? Colors.blue : Colors.red,

        // Animate decoration
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isExpanded ? 20 : 10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: _isExpanded ? 20 : 5,
              offset: Offset(0, _isExpanded ? 10 : 2),
            ),
          ],
        ),

        // Animate padding
        padding: EdgeInsets.all(_isExpanded ? 20 : 10),

        // Animate margin
        margin: EdgeInsets.all(_isExpanded ? 20 : 10),

        // Animate alignment
        alignment: _isExpanded ? Alignment.center : Alignment.topLeft,

        child: const Text('Tap me!'),
      ),
    );
  }
}
```

```
WHAT ANIMATEDCONTAINER CAN ANIMATE:
├── width, height
├── color
├── padding, margin
├── alignment
├── decoration (border, shadow, borderRadius)
├── constraints
└── transform
```

---

## AnimatedOpacity

Fade widgets in and out smoothly.

```dart
class FadingWidget extends StatefulWidget {
  @override
  State<FadingWidget> createState() => _FadingWidgetState();
}

class _FadingWidgetState extends State<FadingWidget> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _isVisible = !_isVisible),
          child: Text(_isVisible ? 'Hide' : 'Show'),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _isVisible ? 1.0 : 0.0,
          curve: Curves.easeInOut,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.purple,
            child: const Center(
              child: Text(
                'I can fade!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

```
OPACITY VALUES:
├── 0.0 = Completely invisible
├── 0.5 = 50% transparent
└── 1.0 = Fully visible

NOTE: Widget still takes up space when invisible!
      Use AnimatedCrossFade to collapse space.
```

---

## AnimatedPositioned

Animate widget position within a Stack.

```dart
class MovingWidget extends StatefulWidget {
  @override
  State<MovingWidget> createState() => _MovingWidgetState();
}

class _MovingWidgetState extends State<MovingWidget> {
  bool _moved = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          left: _moved ? 200 : 50,
          top: _moved ? 200 : 50,
          child: GestureDetector(
            onTap: () => setState(() => _moved = !_moved),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('Move!'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

```
ANIMATEDPOSITIONED PROPERTIES:
├── left, right   - Horizontal position
├── top, bottom   - Vertical position
├── width, height - Size
└── Must be inside a Stack!
```

---

## AnimatedCrossFade

Smoothly transition between two widgets.

```dart
class CrossFadeExample extends StatefulWidget {
  @override
  State<CrossFadeExample> createState() => _CrossFadeExampleState();
}

class _CrossFadeExampleState extends State<CrossFadeExample> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _showFirst = !_showFirst),
          child: const Text('Switch'),
        ),
        const SizedBox(height: 20),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),

          // Which one to show?
          crossFadeState: _showFirst
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,

          // First widget
          firstChild: Container(
            width: 200,
            height: 100,
            color: Colors.blue,
            child: const Center(
              child: Text('First', style: TextStyle(color: Colors.white)),
            ),
          ),

          // Second widget
          secondChild: Container(
            width: 200,
            height: 150,  // Different height is OK!
            color: Colors.green,
            child: const Center(
              child: Text('Second', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
```

```
CROSSFADE vs OPACITY:
┌────────────────────────────────────────────────────────────┐
│                                                             │
│  AnimatedOpacity:                                           │
│  └── Fades ONE widget in/out                               │
│  └── Widget still takes space when invisible               │
│                                                             │
│  AnimatedCrossFade:                                         │
│  └── Transitions between TWO widgets                       │
│  └── Handles different sizes smoothly                      │
│  └── Space collapses/expands as needed                     │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## AnimatedDefaultTextStyle

Animate text style changes.

```dart
class AnimatedText extends StatefulWidget {
  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  bool _large = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _large = !_large),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: _large ? 32 : 16,
          fontWeight: _large ? FontWeight.bold : FontWeight.normal,
          color: _large ? Colors.purple : Colors.grey,
        ),
        child: const Text('Tap to change style!'),
      ),
    );
  }
}
```

---

## AnimatedPadding

Animate padding changes.

```dart
class AnimatedPaddingExample extends StatefulWidget {
  @override
  State<AnimatedPaddingExample> createState() => _AnimatedPaddingExampleState();
}

class _AnimatedPaddingExampleState extends State<AnimatedPaddingExample> {
  bool _padded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _padded = !_padded),
          child: const Text('Toggle Padding'),
        ),
        Container(
          color: Colors.grey[300],
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(_padded ? 50 : 10),
            child: Container(
              color: Colors.blue,
              child: const Text('I have animated padding!'),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## AnimatedAlign

Animate alignment changes.

```dart
class AnimatedAlignExample extends StatefulWidget {
  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  Alignment _alignment = Alignment.topLeft;

  final List<Alignment> _alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];
  int _index = 0;

  void _changeAlignment() {
    setState(() {
      _index = (_index + 1) % _alignments.length;
      _alignment = _alignments[_index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeAlignment,
      child: Container(
        width: 300,
        height: 300,
        color: Colors.grey[200],
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: _alignment,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
```

---

## AnimatedRotation

Animate rotation smoothly.

```dart
class SpinningWidget extends StatefulWidget {
  @override
  State<SpinningWidget> createState() => _SpinningWidgetState();
}

class _SpinningWidgetState extends State<SpinningWidget> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _turns += 0.25), // 90 degrees
          child: const Text('Rotate 90°'),
        ),
        const SizedBox(height: 50),
        AnimatedRotation(
          duration: const Duration(milliseconds: 500),
          turns: _turns,  // 1 turn = 360 degrees
          curve: Curves.easeInOut,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: const Icon(Icons.arrow_upward, size: 50),
          ),
        ),
      ],
    );
  }
}
```

```
ROTATION VALUES:
├── 0.0   = No rotation
├── 0.25  = 90 degrees
├── 0.5   = 180 degrees
├── 0.75  = 270 degrees
└── 1.0   = 360 degrees (full rotation)
```

---

## AnimatedScale

Animate size scaling.

```dart
class ScalingWidget extends StatefulWidget {
  @override
  State<ScalingWidget> createState() => _ScalingWidgetState();
}

class _ScalingWidgetState extends State<ScalingWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _scale,
          min: 0.5,
          max: 2.0,
          onChanged: (value) => setState(() => _scale = value),
        ),
        AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _scale,
          curve: Curves.easeOut,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.green,
            child: const Center(
              child: Text('Scale me!'),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## AnimatedSlide

Animate position offset.

```dart
class SlidingWidget extends StatefulWidget {
  @override
  State<SlidingWidget> createState() => _SlidingWidgetState();
}

class _SlidingWidgetState extends State<SlidingWidget> {
  bool _slid = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _slid = !_slid),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _slid
            ? const Offset(1, 0)   // Move right by 1x widget width
            : const Offset(0, 0),  // Original position
        curve: Curves.easeInOut,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.orange,
          child: const Center(
            child: Text('Slide!'),
          ),
        ),
      ),
    );
  }
}
```

```
OFFSET VALUES:
├── Offset(0, 0)  = Original position
├── Offset(1, 0)  = Right by 1x width
├── Offset(-1, 0) = Left by 1x width
├── Offset(0, 1)  = Down by 1x height
└── Offset(0, -1) = Up by 1x height
```

---

## AnimatedSwitcher

Animate when switching between different widgets.

```dart
class SwitcherExample extends StatefulWidget {
  @override
  State<SwitcherExample> createState() => _SwitcherExampleState();
}

class _SwitcherExampleState extends State<SwitcherExample> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: const Text('Increment'),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: Text(
            '$_count',
            // KEY IS REQUIRED! Tells Flutter when to animate
            key: ValueKey<int>(_count),
            style: const TextStyle(fontSize: 48),
          ),
        ),
      ],
    );
  }
}
```

```
IMPORTANT: AnimatedSwitcher needs a KEY!
┌────────────────────────────────────────────────────────────┐
│                                                             │
│  The key tells Flutter "this is a NEW widget"              │
│  Without key: Flutter thinks it's the same widget          │
│  With key: Flutter knows to animate the switch             │
│                                                             │
│  key: ValueKey<int>(_count)                                │
│  key: ValueKey<String>(text)                               │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## TweenAnimationBuilder

Create custom implicit animations for any value!

```dart
class CustomTweenExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 300),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Container(
          width: value,
          height: value,
          color: Colors.blue,
          child: child,  // Reuse the child for performance
        );
      },
      child: const Center(
        child: Text(
          'Growing!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
```

---

## Complete Example: Profile Card

```dart
class AnimatedProfileCard extends StatefulWidget {
  @override
  State<AnimatedProfileCard> createState() => _AnimatedProfileCardState();
}

class _AnimatedProfileCardState extends State<AnimatedProfileCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: _isExpanded ? 300 : 200,
        height: _isExpanded ? 200 : 80,
        padding: EdgeInsets.all(_isExpanded ? 20 : 10),
        decoration: BoxDecoration(
          color: _isExpanded ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(_isExpanded ? 20 : 10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isExpanded ? 0.3 : 0.1),
              blurRadius: _isExpanded ? 15 : 5,
              offset: Offset(0, _isExpanded ? 8 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: _isExpanded ? 60 : 40,
                  height: _isExpanded ? 60 : 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isExpanded ? Colors.white : Colors.blue,
                  ),
                  child: Icon(
                    Icons.person,
                    color: _isExpanded ? Colors.blue : Colors.white,
                    size: _isExpanded ? 30 : 20,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: TextStyle(
                    fontSize: _isExpanded ? 20 : 14,
                    fontWeight: FontWeight.bold,
                    color: _isExpanded ? Colors.white : Colors.black87,
                  ),
                  child: const Text('John Doe'),
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isExpanded ? 1.0 : 0.0,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 400),
                padding: EdgeInsets.only(top: _isExpanded ? 20 : 0),
                child: const Text(
                  'Flutter Developer\nLoves animations!',
                  style: TextStyle(color: Colors.white70),
                ),
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

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│          IMPLICIT ANIMATIONS SUMMARY                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  KEY WIDGETS:                                                │
│  ├── AnimatedContainer     - Size, color, decoration        │
│  ├── AnimatedOpacity       - Fade in/out                    │
│  ├── AnimatedPositioned    - Move in Stack                  │
│  ├── AnimatedCrossFade     - Switch widgets                 │
│  ├── AnimatedDefaultTextStyle - Text style                  │
│  ├── AnimatedPadding       - Padding changes                │
│  ├── AnimatedAlign         - Alignment changes              │
│  ├── AnimatedRotation      - Spinning                       │
│  ├── AnimatedScale         - Size scaling                   │
│  ├── AnimatedSlide         - Offset position                │
│  ├── AnimatedSwitcher      - Widget transitions             │
│  └── TweenAnimationBuilder - Custom animations              │
│                                                              │
│  REQUIRED PROPERTIES:                                        │
│  ├── duration - How long the animation takes                │
│  └── The value being animated                               │
│                                                              │
│  OPTIONAL:                                                   │
│  └── curve - How the animation moves                        │
│                                                              │
│  REMEMBER:                                                   │
│  • Change values in setState()                              │
│  • Flutter animates automatically!                          │
│  • AnimatedSwitcher needs a key                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Next:** `03-ExplicitAnimations.md` - Full control with AnimationController
