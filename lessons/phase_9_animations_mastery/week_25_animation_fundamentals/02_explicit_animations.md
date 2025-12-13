# Explicit Animations: Full Control with AnimationController

## What You'll Learn

In this comprehensive lesson, you'll master:
- What explicit animations are and when to use them
- AnimationController - the heart of explicit animations
- Tween - defining animation ranges
- AnimatedBuilder for efficient rebuilds
- Controlling animations (play, pause, reverse, repeat)
- Multiple animations with one controller
- Custom curves and timing
- Physics-based animations
- Real-world examples and best practices
- 5 progressive exercises

By the end, you'll have complete control over your animations!

## 5-Year-Old Explanation

### Implicit vs Explicit

**Implicit Animation = Automatic Car:**
```
You: "Drive to the store"
Car: *drives itself there* ✨
You: Just set destination, car handles everything
```

**Explicit Animation = Manual Car:**
```
You: *Press gas pedal*
You: *Turn steering wheel*
You: *Shift gears*
You: Complete control over every aspect! 🎮
```

**In Flutter:**

**Implicit (Easy, Limited Control):**
```dart
AnimatedContainer(
  width: _size,  // Just change this value
  duration: Duration(seconds: 1),  // Flutter animates automatically
)
```

**Explicit (More Code, Full Control):**
```dart
// You control EVERYTHING
controller.forward();   // Start
controller.reverse();   // Go backwards
controller.repeat();    // Loop forever
controller.stop();      // Pause
controller.value = 0.5; // Jump to middle
```

### When to Use Explicit Animations

✅ **Use Explicit When:**
- Need to control timing precisely (pause, reverse, repeat)
- Multiple widgets animate together
- Complex sequences (animate A, then B, then C)
- Physics-based animations (bouncing, dragging)
- Games or interactive animations
- Need to listen to animation progress

❌ **Use Implicit When:**
- Simple transitions (size, color, opacity changes)
- Don't need precise control
- One-off animations
- Quick and easy is priority

## Part 1: AnimationController Basics

### Setting Up AnimationController

```dart
class BouncingBall extends StatefulWidget {
  @override
  _BouncingBallState createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall>
    with SingleTickerProviderStateMixin {  // IMPORTANT!

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),  // How long animation takes
      vsync: this,  // Prevents animation when screen off (saves battery)
    );
  }

  @override
  void dispose() {
    _controller.dispose();  // ALWAYS dispose to prevent memory leaks!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Controller')),
      body: Center(
        child: Text('Controller value: ${_controller.value}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.forward();  // Start animation
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

**Important Parts:**
1. **SingleTickerProviderStateMixin** - Required for animations
2. **vsync: this** - Syncs animation with screen refresh
3. **dispose()** - MUST dispose controller to prevent memory leaks
4. **late** keyword - Controller initialized in initState()

### Controller Properties

```dart
// Value (0.0 to 1.0)
_controller.value;  // Current value (0.0 = start, 1.0 = end)

// Status
_controller.status;  // forward, reverse, completed, dismissed

// Duration
_controller.duration;  // How long animation takes

// Check state
_controller.isAnimating;   // true if currently animating
_controller.isCompleted;   // true if value == 1.0
_controller.isDismissed;   // true if value == 0.0
```

### Controller Methods

```dart
// Basic controls
_controller.forward();   // Animate from current value to 1.0
_controller.reverse();   // Animate from current value to 0.0
_controller.reset();     // Jump to 0.0 (no animation)
_controller.stop();      // Pause animation

// Advanced controls
_controller.repeat();    // Loop forever
_controller.repeat(reverse: true);  // Bounce back and forth

_controller.forward(from: 0.0);    // Start from specific value
_controller.animateTo(0.5);        // Animate to specific value
_controller.animateBack(0.0);      // Animate backwards to value

// Fling (physics-based)
_controller.fling(velocity: 2.0);  // Throw with velocity
```

## Part 2: Tween - Defining Animation Ranges

**Tween** = "In-between" - Defines start and end values

### Basic Tween Usage

```dart
class AnimatedBox extends StatefulWidget {
  @override
  _AnimatedBoxState createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Tween: Maps controller value (0.0-1.0) to size (50.0-200.0)
    _sizeAnimation = Tween<double>(
      begin: 50.0,   // When controller.value = 0.0
      end: 200.0,    // When controller.value = 1.0
    ).animate(_controller);

    // Examples of controller → size mapping:
    // controller.value = 0.0  →  size = 50.0
    // controller.value = 0.5  →  size = 125.0
    // controller.value = 1.0  →  size = 200.0
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tween Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _sizeAnimation,
          builder: (context, child) {
            return Container(
              width: _sizeAnimation.value,
              height: _sizeAnimation.value,
              color: Colors.blue,
              child: child,
            );
          },
          child: Center(
            child: Text(
              '${_sizeAnimation.value.toInt()}',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _controller.forward(),
            child: Icon(Icons.play_arrow),
            heroTag: 'forward',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _controller.reverse(),
            child: Icon(Icons.arrow_back),
            heroTag: 'reverse',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _controller.repeat(reverse: true),
            child: Icon(Icons.repeat),
            heroTag: 'repeat',
          ),
        ],
      ),
    );
  }
}
```

### Different Types of Tweens

```dart
// Double values (size, opacity, etc.)
Tween<double>(begin: 0.0, end: 1.0)

// Integer values (counts, indices)
IntTween(begin: 0, end: 100)

// Colors
ColorTween(begin: Colors.red, end: Colors.blue)

// Offset (position)
Tween<Offset>(
  begin: Offset(0, 0),
  end: Offset(100, 100),
)

// BorderRadius
Tween<BorderRadius>(
  begin: BorderRadius.circular(0),
  end: BorderRadius.circular(50),
)

// Size
SizeTween(
  begin: Size(100, 100),
  end: Size(200, 300),
)

// Alignment
AlignmentTween(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

### Multiple Tweens with One Controller

```dart
class MultiTweenExample extends StatefulWidget {
  @override
  _MultiTweenExampleState createState() => _MultiTweenExampleState();
}

class _MultiTweenExampleState extends State<MultiTweenExample>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Size grows from 50 to 200
    _sizeAnimation = Tween<double>(
      begin: 50.0,
      end: 200.0,
    ).animate(_controller);

    // Color changes from red to blue
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(_controller);

    // Rotates full circle (0 to 2π radians)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 6.28319,  // 2π (360 degrees)
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multiple Tweens')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _colorAnimation.value!.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${(_controller.value * 100).toInt()}%',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

## Part 3: AnimatedBuilder - Efficient Rebuilds

**AnimatedBuilder** rebuilds ONLY the animated part, not the whole widget!

### Why AnimatedBuilder?

```dart
// ❌ BAD: Rebuilds entire widget tree
class BadExample extends StatefulWidget {
  @override
  _BadExampleState createState() => _BadExampleState();
}

class _BadExampleState extends State<BadExample>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Listen to animation and call setState on EVERY frame!
    _controller.addListener(() {
      setState(() {});  // Rebuilds EVERYTHING - expensive! 💸
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bad Example')),
      body: Column(
        children: [
          ExpensiveWidget(),  // Rebuilds unnecessarily!
          Container(
            width: _controller.value * 200,
            height: _controller.value * 200,
            color: Colors.blue,
          ),
          AnotherExpensiveWidget(),  // Also rebuilds!
        ],
      ),
    );
  }
}


// ✅ GOOD: Only rebuilds animated part
class GoodExample extends StatefulWidget {
  @override
  _GoodExampleState createState() => _GoodExampleState();
}

class _GoodExampleState extends State<GoodExample>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Good Example')),
      body: Column(
        children: [
          ExpensiveWidget(),  // Never rebuilds!
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Only THIS rebuilds
              return Container(
                width: _controller.value * 200,
                height: _controller.value * 200,
                color: Colors.blue,
              );
            },
          ),
          AnotherExpensiveWidget(),  // Never rebuilds!
        ],
      ),
    );
  }
}
```

### AnimatedBuilder with Child Optimization

```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Container(
      width: _controller.value * 200,
      height: _controller.value * 200,
      color: Colors.blue,
      child: child,  // This child NEVER rebuilds!
    );
  },
  child: ExpensiveChildWidget(),  // Built once, reused every frame
)
```

## Part 4: Curves with Explicit Animations

```dart
class CurvedAnimation extends StatefulWidget {
  @override
  _CurvedAnimationState createState() => _CurvedAnimationState();
}

class _CurvedAnimationState extends State<CurvedAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Apply curve to animation
    _animation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,  // Fun bouncy effect!
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
      appBar: AppBar(title: Text('Curved Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: _animation.value,
              height: 100,
              color: Colors.blue,
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

### Different Curves for Forward and Reverse

```dart
_animation = Tween<double>(
  begin: 0,
  end: 300,
).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,      // Curve when going forward
    reverseCurve: Curves.easeOut,  // Different curve when reversing
  ),
);
```

## Part 5: Animation Status Listeners

Listen to animation state changes:

```dart
class StatusListenerExample extends StatefulWidget {
  @override
  _StatusListenerExampleState createState() => _StatusListenerExampleState();
}

class _StatusListenerExampleState extends State<StatusListenerExample>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Listen to status changes
    _controller.addStatusListener((status) {
      setState(() {
        switch (status) {
          case AnimationStatus.forward:
            _status = 'Running Forward ▶️';
            break;
          case AnimationStatus.reverse:
            _status = 'Running Reverse ◀️';
            break;
          case AnimationStatus.completed:
            _status = 'Completed ✅';
            // Auto-reverse when completed
            _controller.reverse();
            break;
          case AnimationStatus.dismissed:
            _status = 'Dismissed (at start) 🔄';
            // Auto-forward when dismissed
            _controller.forward();
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Status Listener')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '${(_controller.value * 100).toInt()}%',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.forward(),
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

## Part 6: Real-World Examples

### Loading Spinner

```dart
class CustomSpinner extends StatefulWidget {
  @override
  _CustomSpinnerState createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();  // Loop forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading Spinner')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    colors: [
                      Colors.blue,
                      Colors.blue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### Pulsing Heart

```dart
class PulsingHeart extends StatefulWidget {
  @override
  _PulsingHeartState createState() => _PulsingHeartState();
}

class _PulsingHeartState extends State<PulsingHeart>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
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
      appBar: AppBar(title: Text('Pulsing Heart')),
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 100,
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### Slide-In Menu

```dart
class SlideInMenu extends StatefulWidget {
  @override
  _SlideInMenuState createState() => _SlideInMenuState();
}

class _SlideInMenuState extends State<SlideInMenu>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0),  // Start off-screen left
      end: Offset.zero,      // End at normal position
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slide Menu'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleMenu,
        ),
      ),
      body: Stack(
        children: [
          // Main content
          Center(
            child: Text('Main Content'),
          ),

          // Sliding menu
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 250,
              color: Colors.blue,
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue[700]),
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text('Home', style: TextStyle(color: Colors.white)),
                    onTap: _toggleMenu,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text('Settings', style: TextStyle(color: Colors.white)),
                    onTap: _toggleMenu,
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.white),
                    title: Text('About', style: TextStyle(color: Colors.white)),
                    onTap: _toggleMenu,
                  ),
                ],
              ),
            ),
          ),

          // Overlay (tap to close menu)
          if (_controller.value > 0)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.3 * _controller.value),
              ),
            ),
        ],
      ),
    );
  }
}
```

### Progress Bar

```dart
class AnimatedProgressBar extends StatefulWidget {
  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
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
      appBar: AppBar(title: Text('Progress Bar')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Column(
                    children: [
                      // Progress bar
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Percentage
                      Text(
                        '${(_progressAnimation.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
                child: Text('Start Progress'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Part 7: Physics-Based Animations

Animations that simulate real physics!

```dart
class SpringAnimation extends StatefulWidget {
  @override
  _SpringAnimationState createState() => _SpringAnimationState();
}

class _SpringAnimationState extends State<SpringAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateWithPhysics() {
    _controller.animateWith(
      SpringSimulation(
        SpringDescription(
          mass: 1,           // Weight of object
          stiffness: 100,    // How stiff the spring
          damping: 10,       // How much resistance
        ),
        0,    // Start value
        1,    // End value
        0,    // Initial velocity
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spring Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _controller.value * 200),
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
          _animateWithPhysics();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

## Exercises

### Exercise 1: Animated Button (Beginner)

Create a button that scales up when pressed.

**Requirements:**
- Button scales to 1.2x when pressed
- Scales back to 1.0 when released
- Use AnimationController and ScaleTransition
- Smooth animation with curve

### Exercise 2: Loading Dots (Beginner-Intermediate)

Build a loading indicator with 3 dots that bounce sequentially.

**Requirements:**
- Three dots in a row
- Each dot bounces up and down
- Sequential timing (dot 1, then dot 2, then dot 3)
- Loop forever
- Use multiple AnimationControllers or intervals

### Exercise 3: Drawer with Overlay (Intermediate)

Create a custom drawer that slides in from the left.

**Requirements:**
- Drawer slides in with SlideTransition
- Dark overlay fades in behind it
- Tap overlay to close drawer
- Smooth curves for natural feel
- Handle back button to close

### Exercise 4: Circular Progress (Intermediate-Advanced)

Build a circular progress indicator.

**Requirements:**
- Circle that fills clockwise
- Percentage in center
- Color changes based on progress (red → yellow → green)
- Use CustomPaint with AnimationController
- Start/stop/reset buttons

### Exercise 5: Page Transition (Advanced)

Create custom page transition animation.

**Requirements:**
- Current page slides out to left
- New page slides in from right
- Fade effect during transition
- Use SlideTransition and FadeTransition
- Work with Navigator

## What You've Learned

✅ AnimationController - heart of explicit animations
✅ Tween - mapping controller values to widget values
✅ AnimatedBuilder - efficient rebuilds
✅ Multiple animations with one controller
✅ Animation curves for natural motion
✅ Status listeners for animation events
✅ Physics-based animations
✅ Real-world examples (spinners, menus, progress bars)
✅ Best practices for performance

## Next Steps

In the next lesson, we'll explore **Hero Animations** - beautiful transitions between screens!

You're mastering animation control! 🚀
