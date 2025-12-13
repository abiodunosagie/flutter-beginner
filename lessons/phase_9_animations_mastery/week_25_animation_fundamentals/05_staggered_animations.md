# Staggered Animations: Orchestrating Multiple Animations

## What You'll Learn

In this comprehensive lesson, you'll master:
- What staggered animations are and why they're powerful
- Creating sequential animations with Interval
- Using TweenSequence for complex timing
- Coordinating multiple widgets
- Page transition animations
- List item stagger effects
- Real-world examples (onboarding, reveals)
- Best practices
- 5 progressive exercises

By the end, you'll create perfectly timed animation sequences!

## 5-Year-Old Explanation

### What is a Staggered Animation?

Imagine a marching band:

**Bad Animation (All at Once):**
```
🎺🥁🎸🎷 All instruments start playing at EXACT same time
Result: CHAOS! 💥 Can't appreciate each instrument
```

**Good Animation (Staggered):**
```
First:  🎺 Trumpet starts...
Then:   🥁 Drums join in...
Then:   🎸 Guitar joins in...
Finally: 🎷 Saxophone completes the band!

Result: HARMONY! ✨ Each entrance is noticeable
```

**In Flutter:**
```dart
// Instead of everything animating at once:
opacity: 0 → 1 (all widgets)
scale: 0 → 1 (all widgets)
position: left → center (all widgets)

// Stagger them:
Widget 1: opacity 0→1 (0.0s - 0.3s)
Widget 2: opacity 0→1 (0.1s - 0.4s)
Widget 3: opacity 0→1 (0.2s - 0.5s)
Widget 4: opacity 0→1 (0.3s - 0.6s)

Each widget "follows" the previous one! ✨
```

### Why Stagger Animations?

**Benefits:**
1. **Guides Attention** - User sees elements appear in order
2. **Feels Premium** - Professional, polished app
3. **Easier to Follow** - Not overwhelming
4. **Creates Flow** - Natural progression
5. **Delights Users** - Satisfying to watch!

## Part 1: Interval - The Foundation

**Interval** divides animation time into segments.

### Basic Example

```dart
class StaggeredDemo extends StatefulWidget {
  @override
  _StaggeredDemoState createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<StaggeredDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // First box animates from 0.0s to 1.0s (first third)
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.33, curve: Curves.easeOut),
      ),
    );

    // Second box animates from 1.0s to 2.0s (middle third)
    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.33, 0.66, curve: Curves.easeOut),
      ),
    );

    // Third box animates from 2.0s to 3.0s (last third)
    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.66, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staggered Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: _animation1.value,
                  child: Container(
                    width: 200,
                    height: 60,
                    color: Colors.red,
                    child: Center(child: Text('First', style: TextStyle(color: Colors.white))),
                  ),
                ),
                SizedBox(height: 20),
                Opacity(
                  opacity: _animation2.value,
                  child: Container(
                    width: 200,
                    height: 60,
                    color: Colors.green,
                    child: Center(child: Text('Second', style: TextStyle(color: Colors.white))),
                  ),
                ),
                SizedBox(height: 20),
                Opacity(
                  opacity: _animation3.value,
                  child: Container(
                    width: 200,
                    height: 60,
                    color: Colors.blue,
                    child: Center(child: Text('Third', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

**How Interval Works:**
```dart
Interval(0.0, 0.33)  // Start at 0%, end at 33% of total duration
Interval(0.33, 0.66) // Start at 33%, end at 66% of total duration
Interval(0.66, 1.0)  // Start at 66%, end at 100% of total duration
```

### Overlapping Intervals

```dart
// Overlapping creates smoother transitions
_animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Interval(0.0, 0.4, curve: Curves.easeOut),  // 0s - 1.2s
  ),
);

_animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Interval(0.2, 0.6, curve: Curves.easeOut),  // 0.6s - 1.8s (overlaps!)
  ),
);

_animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Interval(0.4, 0.8, curve: Curves.easeOut),  // 1.2s - 2.4s (overlaps!)
  ),
);
```

## Part 2: Multiple Property Animations

Animate multiple properties per widget!

```dart
class MultiPropertyStagger extends StatefulWidget {
  @override
  _MultiPropertyStaggerState createState() => _MultiPropertyStaggerState();
}

class _MultiPropertyStaggerState extends State<MultiPropertyStagger>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade in (first)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Scale up (second, overlaps with fade)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Slide in (third, overlaps with scale)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi-Property Stagger')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Hello!',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

## Part 3: List Item Stagger

Animate list items appearing one by one!

```dart
class StaggeredList extends StatefulWidget {
  @override
  _StaggeredListState createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final int itemCount = 8;
  List<Animation<double>> _itemAnimations = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create animation for each item
    for (int i = 0; i < itemCount; i++) {
      final start = (i / itemCount) * 0.5;  // Start at 0%, 6.25%, 12.5%, etc.
      final end = start + 0.5;  // Each animation lasts 50% of total time

      _itemAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staggered List')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Opacity(
                opacity: _itemAnimations[index].value,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    50 * (1 - _itemAnimations[index].value),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Item ${index + 1}'),
                      subtitle: Text('This item fades and slides in'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

## Part 4: Onboarding Screens

Perfect for app tutorials!

```dart
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _descriptionAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Stagger each element
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    _descriptionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Opacity(
                    opacity: _iconAnimation.value,
                    child: Transform.scale(
                      scale: _iconAnimation.value,
                      child: Icon(
                        Icons.check_circle,
                        size: 120,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Title
                  Opacity(
                    opacity: _titleAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _titleAnimation.value)),
                      child: Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description
                  Opacity(
                    opacity: _descriptionAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _descriptionAnimation.value)),
                      child: Text(
                        'This is an example of staggered animations. '
                        'Each element appears in sequence.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),

                  // Button
                  Opacity(
                    opacity: _buttonAnimation.value,
                    child: Transform.scale(
                      scale: _buttonAnimation.value,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          child: Text(
                            'Get Started',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## Part 5: Page Transition Animation

Custom page transitions with stagger!

```dart
class StaggeredPageRoute extends PageRouteBuilder {
  final Widget page;

  StaggeredPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Background fade
            final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(0.0, 0.5),
              ),
            );

            // Slide from bottom
            final slideAnimation = Tween<Offset>(
              begin: Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(0.3, 1.0, curve: Curves.easeOut),
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 800),
        );
}

// Usage
Navigator.push(
  context,
  StaggeredPageRoute(page: NextScreen()),
);
```

## Part 6: TweenSequence - Complex Timing

For when you need precise control over multi-stage animations!

```dart
class TweenSequenceDemo extends StatefulWidget {
  @override
  _TweenSequenceDemoState createState() => _TweenSequenceDemoState();
}

class _TweenSequenceDemoState extends State<TweenSequenceDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    // Complex sequence: grow, shrink, grow again!
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,  // Takes 25% of time
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 0.5)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,  // Takes 25% of time
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.2)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,  // Takes 50% of time
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TweenSequence')),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          _controller.forward();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

## Part 7: Best Practices

### 1. Use Overlapping Intervals

```dart
// ❌ No overlap - feels choppy
Interval(0.0, 0.25)
Interval(0.25, 0.5)
Interval(0.5, 0.75)

// ✅ Overlap - smooth flow
Interval(0.0, 0.4)
Interval(0.2, 0.6)
Interval(0.4, 0.8)
```

### 2. Reasonable Delays

```dart
// ❌ Too slow - boring
duration: Duration(seconds: 10)

// ❌ Too fast - can't see
duration: Duration(milliseconds: 100)

// ✅ Just right
duration: Duration(milliseconds: 800-1500)
```

### 3. Don't Overdo It

```dart
// ❌ Too many staggered elements
20 items stagger = User waits 5 seconds

// ✅ Reasonable amount
5-8 items stagger = Nice effect
```

## Exercises

### Exercise 1: Staggered Cards (Beginner)

Create 3 cards that fade and slide in sequentially.

**Requirements:**
- 3 cards in column
- Each fades in (opacity 0 → 1)
- Each slides up from below
- 200ms delay between each
- Use Interval

### Exercise 2: Animated Form (Beginner-Intermediate)

Build a login form with staggered appearance.

**Requirements:**
- Logo appears first (scale up)
- Email field fades in second
- Password field fades in third
- Login button appears last
- All with smooth timing

### Exercise 3: Grid Reveal (Intermediate)

Create a grid where items appear in a wave pattern.

**Requirements:**
- 3x3 grid of items
- Reveal diagonally (top-left to bottom-right)
- Each item scales from 0 to 1
- Smooth overlapping intervals
- Replay button

### Exercise 4: Stats Dashboard (Intermediate-Advanced)

Build a stats dashboard with animated reveal.

**Requirements:**
- Title fades in first
- 4 stat cards appear sequentially
- Numbers count up from 0
- Progress bars fill up
- Everything perfectly timed

### Exercise 5: Complex Sequence (Advanced)

Create a multi-stage animation sequence.

**Requirements:**
- Logo bounces in (elastic curve)
- Logo rotates 360°
- Logo shrinks and moves to corner
- Content fades in below
- Use TweenSequence
- Smooth transitions between stages

## What You've Learned

✅ What staggered animations are
✅ Using Interval for sequential timing
✅ Overlapping intervals for smooth flow
✅ Animating multiple properties
✅ List item stagger effects
✅ Onboarding screen animations
✅ Custom page transitions
✅ TweenSequence for complex timing
✅ Best practices for professional feel

## Conclusion: Phase 9 Complete!

Congratulations! You've mastered **Animations Mastery**:

1. **Implicit Animations** - Easy automatic animations
2. **Explicit Animations** - Full control with AnimationController
3. **Hero Animations** - Magical screen transitions
4. **CustomPainter** - Drawing custom animations
5. **Staggered Animations** - Orchestrating sequences

Your apps now feel alive and professional!

## Next Steps

Next up: **Phase 10: Navigation with GoRouter** - Master routing, deep linking, and navigation 2.0!

You're creating amazing animated experiences! 🚀
