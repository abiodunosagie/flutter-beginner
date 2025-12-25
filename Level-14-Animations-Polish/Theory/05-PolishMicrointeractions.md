# Polish & Micro-interactions

## The Simple Explanation

Micro-interactions are tiny details that make your app feel alive - like a button that slightly shrinks when tapped, or a satisfying vibration when completing a task. They're small, but they make a BIG difference!

```
┌─────────────────────────────────────────────────────────────┐
│              MICRO-INTERACTIONS                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITHOUT MICRO-INTERACTIONS:                                 │
│  Tap button → Action happens                                │
│  (Boring, no feedback)                                       │
│                                                              │
│  WITH MICRO-INTERACTIONS:                                    │
│  Tap button → Button shrinks → Ripple effect → Haptic       │
│           → Loading spinner → Success animation             │
│  (Satisfying, professional!)                                 │
│                                                              │
│  "The details are not the details.                          │
│   They make the design." - Charles Eames                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Types of Polish

```
┌─────────────────────────────────────────────────────────────┐
│                  POLISH CATEGORIES                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. LOADING STATES                                           │
│     └── Show something while waiting                        │
│                                                              │
│  2. EMPTY STATES                                             │
│     └── Beautiful "nothing here" screens                    │
│                                                              │
│  3. ERROR STATES                                             │
│     └── Friendly error messages                             │
│                                                              │
│  4. HAPTIC FEEDBACK                                          │
│     └── Vibrations for actions                              │
│                                                              │
│  5. BUTTON FEEDBACK                                          │
│     └── Visual response to taps                             │
│                                                              │
│  6. SCROLL EFFECTS                                           │
│     └── Pull-to-refresh, overscroll                         │
│                                                              │
│  7. TRANSITIONS                                              │
│     └── Smooth screen changes                               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Loading States

### Simple Shimmer Loading

```dart
// Creates a shimmering placeholder while content loads

class ShimmerLoading extends StatefulWidget {
  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
```

### Loading Skeleton Screen

```dart
class SkeletonScreen extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const SkeletonScreen({
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    // Subtitle placeholder
                    Container(
                      height: 12,
                      width: 150,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Animated Loading Indicator

```dart
class PulsingDots extends StatefulWidget {
  @override
  State<PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<PulsingDots>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final animValue = (_controller.value + delay) % 1.0;
            final scale = 0.5 + 0.5 * (1 - (animValue - 0.5).abs() * 2);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
```

---

## Empty States

```dart
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    icon,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Title with fade
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage:
EmptyState(
  icon: Icons.inbox_outlined,
  title: 'No Messages Yet',
  description: 'When you receive messages, they will appear here.',
  buttonText: 'Start a Conversation',
  onButtonPressed: () => Navigator.push(...),
)
```

---

## Haptic Feedback

```dart
import 'package:flutter/services.dart';

// Light tap feedback (for selections)
HapticFeedback.lightImpact();

// Medium tap feedback (for button presses)
HapticFeedback.mediumImpact();

// Heavy tap feedback (for major actions)
HapticFeedback.heavyImpact();

// Selection change (for toggles, switches)
HapticFeedback.selectionClick();

// Success vibration
HapticFeedback.vibrate();

// Example usage in a button:
class HapticButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const HapticButton({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => HapticFeedback.lightImpact(),
      onTap: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: child,
    );
  }
}
```

---

## Animated Button with Press Effect

```dart
class PressableButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const PressableButton({
    required this.onPressed,
    required this.child,
  });

  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.1 : 0.2),
                blurRadius: _isPressed ? 4 : 8,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
```

---

## Pull-to-Refresh

```dart
class RefreshableList extends StatefulWidget {
  @override
  State<RefreshableList> createState() => _RefreshableListState();
}

class _RefreshableListState extends State<RefreshableList> {
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _handleRefresh() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _items = [..._items, 'New Item ${_items.length + 1}'];
    });

    // Success feedback
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: 40,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_items[index]));
        },
      ),
    );
  }
}
```

---

## Success/Error Animations

### Animated Checkmark

```dart
class AnimatedCheckmark extends StatefulWidget {
  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    HapticFeedback.heavyImpact();
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: CheckPainter(progress: _checkAnimation.value),
            ),
          ),
        );
      },
    );
  }
}

class CheckPainter extends CustomPainter {
  final double progress;

  CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = size.width * 0.25;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.7;
    final endX = size.width * 0.75;
    final endY = size.height * 0.35;

    if (progress <= 0.5) {
      // First stroke
      final p = progress * 2;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (midX - startX) * p,
        startY + (midY - startY) * p,
      );
    } else {
      // Complete first stroke + second stroke
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      final p = (progress - 0.5) * 2;
      path.lineTo(
        midX + (endX - midX) * p,
        midY + (endY - midY) * p,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
```

---

## Snackbar with Animation

```dart
void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Text(message),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      animation: CurvedAnimation(
        parent: AnimationController(
          duration: const Duration(milliseconds: 250),
          vsync: ScaffoldMessenger.of(context),
        )..forward(),
        curve: Curves.easeOutCubic,
      ),
    ),
  );
  HapticFeedback.lightImpact();
}
```

---

## Page Transitions

```dart
// Fade transition
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

// Slide up transition
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            );
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}

// Usage:
Navigator.push(context, FadePageRoute(page: DetailScreen()));
Navigator.push(context, SlideUpPageRoute(page: ModalScreen()));
```

---

## List Item Animations

```dart
class AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedListItem({
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// Usage in ListView:
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return AnimatedListItem(
      index: index,
      child: ListTile(title: Text(items[index])),
    );
  },
)
```

---

## Polish Checklist

```
┌─────────────────────────────────────────────────────────────┐
│               APP POLISH CHECKLIST                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LOADING STATES:                                             │
│  □ Skeleton screens for list loading                        │
│  □ Progress indicators for actions                          │
│  □ Shimmer effect for image placeholders                    │
│                                                              │
│  EMPTY STATES:                                               │
│  □ Friendly empty state illustrations                       │
│  □ Clear call-to-action buttons                             │
│  □ Helpful descriptions                                     │
│                                                              │
│  ERROR STATES:                                               │
│  □ User-friendly error messages                             │
│  □ Retry buttons                                            │
│  □ Error illustrations                                      │
│                                                              │
│  FEEDBACK:                                                   │
│  □ Button press animations                                  │
│  □ Haptic feedback on actions                               │
│  □ Success/error animations                                 │
│  □ Pull-to-refresh                                          │
│                                                              │
│  TRANSITIONS:                                                │
│  □ Smooth page transitions                                  │
│  □ Hero animations where appropriate                        │
│  □ List item enter animations                               │
│                                                              │
│  MICRO-INTERACTIONS:                                         │
│  □ Toggle switches animate                                  │
│  □ Icons animate on state change                            │
│  □ Form validation feedback                                 │
│  □ Scroll effects                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│        POLISH & MICRO-INTERACTIONS SUMMARY                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  KEY CONCEPTS:                                               │
│  ├── Loading states reduce perceived wait time              │
│  ├── Empty states guide users on what to do                 │
│  ├── Haptics make actions feel tangible                     │
│  ├── Transitions show spatial relationships                 │
│  └── Micro-interactions delight users                       │
│                                                              │
│  HAPTIC FEEDBACK:                                            │
│  ├── lightImpact() - Selection                              │
│  ├── mediumImpact() - Button press                          │
│  ├── heavyImpact() - Major action                           │
│  └── selectionClick() - Toggle                              │
│                                                              │
│  ANIMATION TIPS:                                             │
│  ├── Keep it fast (100-400ms)                               │
│  ├── Use curves for natural motion                          │
│  ├── Stagger list items                                     │
│  └── Don't animate everything!                              │
│                                                              │
│  REMEMBER:                                                   │
│  Polish is the difference between "works" and "delightful"  │
│  Small details create big impressions!                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Great work completing Level 14!** Your apps are now ready to impress users with smooth, polished animations!
