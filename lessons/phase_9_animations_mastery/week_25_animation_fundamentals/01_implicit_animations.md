# Implicit Animations: Easy Beautiful Animations

## What You'll Learn

In this comprehensive lesson, you'll master:
- What animations are and why they matter
- The difference between implicit and explicit animations
- AnimatedContainer for smooth transitions
- AnimatedOpacity for fade effects
- AnimatedPadding, AnimatedAlign, AnimatedPositioned
- AnimatedDefaultTextStyle for text animations
- TweenAnimationBuilder for custom animations
- Curves for natural motion
- Real-world examples and best practices
- 5 progressive exercises

By the end, you'll make your apps feel alive with smooth, professional animations!

## Understanding Animations (Like Teaching a 5-Year-Old)

### What is an Animation?

Imagine a flip book:

**Without Animation (Static):**
```
Page 1: 📦 Box is small and red
... user taps button ...
Page 2: 📦 Box is BIG and blue

Result: Box suddenly changes - looks jarring! ⚡
```

**With Animation (Smooth):**
```
Page 1:  📦 Small red box
Page 2:  📦 Slightly bigger, slightly purple
Page 3:  📦 Medium size, more purple
Page 4:  📦 Almost big, almost blue
Page 5:  📦 BIG blue box!

Result: Smooth transformation - looks beautiful! ✨
```

**In Flutter:**
- **No animation** = Widget jumps from state A to state B
- **Animation** = Widget smoothly transforms over time

### Why Animations Matter

**Bad App (No Animations):**
```
- User taps button
- Screen suddenly appears ⚡
- User confused: "What just happened?"
- Feels cheap and rushed
```

**Good App (With Animations):**
```
- User taps button
- Screen slides in smoothly 🎬
- User understands: "Ah, I'm moving forward"
- Feels polished and professional
```

**Benefits:**
1. **Better UX** - Users understand what's happening
2. **Feels Premium** - App looks professional
3. **Guides Attention** - Shows where to look
4. **Provides Feedback** - Confirms actions worked
5. **Delights Users** - Makes app enjoyable to use

## Part 1: Implicit vs Explicit Animations

### Implicit Animations (Easy)

**What:** Flutter automatically animates changes for you!

**How:** Just change a value, Flutter handles the animation

**Example:**
```dart
// Change this value
double _size = 100;

// Flutter automatically animates from old size to new size!
AnimatedContainer(
  width: _size,
  height: _size,
  duration: Duration(seconds: 1),
)
```

**When to use:** Most of the time! 80% of animations

### Explicit Animations (Advanced)

**What:** You control every detail of the animation

**How:** Use controllers, tickers, and manual animation logic

**When to use:** Complex animations, games, precise control

**Example:**
```dart
// You control when to start, stop, repeat
AnimationController controller = AnimationController(/*...*/);
controller.forward();  // Start animation
controller.reverse();  // Reverse animation
controller.repeat();   // Loop animation
```

**This lesson focuses on IMPLICIT animations** (easier and more common!)

## Part 2: AnimatedContainer - The Swiss Army Knife

`AnimatedContainer` is the most versatile implicit animation widget!

### Basic Example

```dart
class AnimatedBoxDemo extends StatefulWidget {
  @override
  _AnimatedBoxDemoState createState() => _AnimatedBoxDemoState();
}

class _AnimatedBoxDemoState extends State<AnimatedBoxDemo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Container')),
      body: Center(
        child: AnimatedContainer(
          // Animated properties
          width: _isExpanded ? 200 : 100,
          height: _isExpanded ? 200 : 100,
          color: _isExpanded ? Colors.blue : Colors.red,

          // Animation configuration
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,

          // Content
          child: Center(
            child: Text(
              'Tap me!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

**What happens:**
1. Tap button
2. `_isExpanded` changes from false to true
3. Flutter automatically animates:
   - Width: 100 → 200
   - Height: 100 → 200
   - Color: red → blue
4. Takes 500ms with smooth easing

### Properties You Can Animate

```dart
AnimatedContainer(
  // Size
  width: _width,
  height: _height,

  // Colors
  color: _color,

  // Border
  decoration: BoxDecoration(
    border: Border.all(color: _borderColor, width: _borderWidth),
    borderRadius: BorderRadius.circular(_borderRadius),
    boxShadow: [
      BoxShadow(
        color: _shadowColor,
        blurRadius: _blurRadius,
        spreadRadius: _spreadRadius,
      ),
    ],
  ),

  // Spacing
  padding: EdgeInsets.all(_padding),
  margin: EdgeInsets.all(_margin),

  // Alignment
  alignment: _alignment,

  // Transform
  transform: Matrix4.rotationZ(_rotation),

  // Animation config
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,

  child: YourWidget(),
)
```

### Complete Example: Morphing Card

```dart
class MorphingCard extends StatefulWidget {
  @override
  _MorphingCardState createState() => _MorphingCardState();
}

class _MorphingCardState extends State<MorphingCard> {
  bool _isCompact = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Morphing Card')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isCompact = !_isCompact;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,

            // Animated size
            width: _isCompact ? 150 : 300,
            height: _isCompact ? 150 : 400,

            // Animated decoration
            decoration: BoxDecoration(
              color: _isCompact ? Colors.blue : Colors.purple,
              borderRadius: BorderRadius.circular(_isCompact ? 75 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: _isCompact ? 10 : 30,
                  spreadRadius: _isCompact ? 2 : 5,
                ),
              ],
            ),

            // Content
            child: _isCompact
                ? Icon(Icons.add, size: 48, color: Colors.white)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 80, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'Expanded!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tap to collapse',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
```

## Part 3: AnimatedOpacity - Fade In/Out

Perfect for showing and hiding widgets smoothly!

### Basic Example

```dart
class FadeDemo extends StatefulWidget {
  @override
  _FadeDemoState createState() => _FadeDemoState();
}

class _FadeDemoState extends State<FadeDemo> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fade Animation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Hello!',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              child: Text(_isVisible ? 'Hide' : 'Show'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Fade In on Load

```dart
class FadeInWidget extends StatefulWidget {
  final Widget child;

  FadeInWidget({required this.child});

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade in after a short delay
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeIn,
      child: widget.child,
    );
  }
}

// Usage
FadeInWidget(
  child: Text('This fades in!', style: TextStyle(fontSize: 24)),
)
```

### Sequential Fade-In List

```dart
class SequentialFadeList extends StatefulWidget {
  @override
  _SequentialFadeListState createState() => _SequentialFadeListState();
}

class _SequentialFadeListState extends State<SequentialFadeList> {
  final List<bool> _visibilities = List.generate(5, (_) => false);

  @override
  void initState() {
    super.initState();
    _startSequentialFade();
  }

  void _startSequentialFade() {
    for (int i = 0; i < _visibilities.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        if (mounted) {
          setState(() {
            _visibilities[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sequential Fade')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return AnimatedOpacity(
            opacity: _visibilities[index] ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            child: Card(
              margin: EdgeInsets.all(16),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Fades in sequentially'),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

## Part 4: Other Implicit Animation Widgets

### AnimatedPadding

```dart
class PaddingDemo extends StatefulWidget {
  @override
  _PaddingDemoState createState() => _PaddingDemoState();
}

class _PaddingDemoState extends State<PaddingDemo> {
  bool _hasLargePadding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Padding')),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            child: AnimatedPadding(
              padding: _hasLargePadding
                  ? EdgeInsets.all(100)
                  : EdgeInsets.all(10),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Watch my padding!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasLargePadding = !_hasLargePadding;
              });
            },
            child: Text('Toggle Padding'),
          ),
        ],
      ),
    );
  }
}
```

### AnimatedAlign

```dart
class AlignDemo extends StatefulWidget {
  @override
  _AlignDemoState createState() => _AlignDemoState();
}

class _AlignDemoState extends State<AlignDemo> {
  Alignment _alignment = Alignment.topLeft;

  void _changeAlignment() {
    final alignments = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomRight,
      Alignment.bottomLeft,
      Alignment.center,
    ];

    final currentIndex = alignments.indexOf(_alignment);
    final nextIndex = (currentIndex + 1) % alignments.length;

    setState(() {
      _alignment = alignments[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Align')),
      body: Container(
        width: double.infinity,
        height: 400,
        color: Colors.grey[300],
        child: AnimatedAlign(
          alignment: _alignment,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Icon(Icons.star, color: Colors.white, size: 40),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeAlignment,
        child: Icon(Icons.navigation),
      ),
    );
  }
}
```

### AnimatedPositioned

Use with Stack for precise positioning:

```dart
class PositionedDemo extends StatefulWidget {
  @override
  _PositionedDemoState createState() => _PositionedDemoState();
}

class _PositionedDemoState extends State<PositionedDemo> {
  bool _isMoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Positioned')),
      body: Stack(
        children: [
          AnimatedPositioned(
            left: _isMoved ? 200 : 50,
            top: _isMoved ? 400 : 100,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Center(
                child: Icon(Icons.rocket_launch, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isMoved = !_isMoved;
          });
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
```

### AnimatedDefaultTextStyle

```dart
class TextStyleDemo extends StatefulWidget {
  @override
  _TextStyleDemoState createState() => _TextStyleDemoState();
}

class _TextStyleDemoState extends State<TextStyleDemo> {
  bool _isLarge = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Text Style')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isLarge = !_isLarge;
            });
          },
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: _isLarge ? 48 : 24,
              color: _isLarge ? Colors.red : Colors.blue,
              fontWeight: _isLarge ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text('Tap me!'),
          ),
        ),
      ),
    );
  }
}
```

## Part 5: Animation Curves

Curves make animations feel natural and realistic!

### Understanding Curves

```dart
// LINEAR (Robot-like - constant speed)
Curves.linear
// ___/
//   /  Same speed throughout

// EASE IN (Starts slow, ends fast)
Curves.easeIn
//     _/
// __/    Accelerates

// EASE OUT (Starts fast, ends slow)
Curves.easeOut
// _
//  \__   Decelerates

// EASE IN OUT (Slow, fast, slow)
Curves.easeInOut
//   __
// _/  \__  Smooth and natural

// BOUNCE (Bounces at the end)
Curves.bounceOut
// \_/\_   Fun and playful

// ELASTIC (Overshoots and comes back)
Curves.elasticOut
//  /\_   Springy effect
```

### Common Curves

```dart
class CurvesDemo extends StatefulWidget {
  @override
  _CurvesDemoState createState() => _CurvesDemoState();
}

class _CurvesDemoState extends State<CurvesDemo> {
  final Map<String, Curve> _curves = {
    'linear': Curves.linear,
    'easeIn': Curves.easeIn,
    'easeOut': Curves.easeOut,
    'easeInOut': Curves.easeInOut,
    'bounceOut': Curves.bounceOut,
    'elasticOut': Curves.elasticOut,
    'easeInBack': Curves.easeInBack,
    'easeOutBack': Curves.easeOutBack,
  };

  String _selectedCurve = 'easeInOut';
  bool _isMoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Curves')),
      body: Column(
        children: [
          // Curve selector
          Padding(
            padding: EdgeInsets.all(16),
            child: DropdownButton<String>(
              value: _selectedCurve,
              isExpanded: true,
              items: _curves.keys.map((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurve = newValue!;
                });
              },
            ),
          ),

          // Animation demo
          Expanded(
            child: Stack(
              children: [
                AnimatedPositioned(
                  left: _isMoved ? MediaQuery.of(context).size.width - 100 : 0,
                  top: 100,
                  duration: Duration(seconds: 1),
                  curve: _curves[_selectedCurve]!,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.circle, color: Colors.white, size: 40),
                  ),
                ),
              ],
            ),
          ),

          // Control button
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isMoved = !_isMoved;
                });
              },
              child: Text('Animate'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Best Curves for Different Situations

```dart
// Showing something (appearing)
Curves.easeOut        // Decelerates at end - feels natural

// Hiding something (disappearing)
Curves.easeIn         // Accelerates - feels like falling away

// Moving between states
Curves.easeInOut      // Smooth throughout

// Fun interactions (buttons, cards)
Curves.bounceOut      // Playful bounce
Curves.elasticOut     // Springy feel

// Emphasis (draw attention)
Curves.easeOutBack    // Slight overshoot - eye-catching
```

## Part 6: TweenAnimationBuilder (Custom Animations)

For when built-in widgets aren't enough!

### Basic Example

```dart
class CounterAnimation extends StatefulWidget {
  @override
  _CounterAnimationState createState() => _CounterAnimationState();
}

class _CounterAnimationState extends State<CounterAnimation> {
  int _targetValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: _targetValue),
              duration: Duration(seconds: 2),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _targetValue += 100;
                });
              },
              child: Text('Add 100'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Color Transition

```dart
class ColorTransition extends StatefulWidget {
  @override
  _ColorTransitionState createState() => _ColorTransitionState();
}

class _ColorTransitionState extends State<ColorTransition> {
  Color _targetColor = Colors.red;

  void _changeColor() {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.orange];
    _targetColor = colors[DateTime.now().second % colors.length];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Transition')),
      body: Center(
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(begin: Colors.red, end: _targetColor),
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          builder: (context, color, child) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color!.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Center(
            child: Text(
              'Tap me!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeColor,
        child: Icon(Icons.palette),
      ),
    );
  }
}
```

### Progress Indicator

```dart
class AnimatedProgress extends StatefulWidget {
  @override
  _AnimatedProgressState createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress> {
  double _progress = 0.0;

  void _updateProgress() {
    setState(() {
      _progress = (_progress + 0.2).clamp(0.0, 1.0);
      if (_progress >= 1.0) _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Progress')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _progress),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Column(
                  children: [
                    // Progress bar
                    Container(
                      width: 300,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[300],
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
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
                    // Percentage text
                    Text(
                      '${(value * 100).toInt()}%',
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
              onPressed: _updateProgress,
              child: Text('Increase Progress'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Part 7: Real-World Examples

### Animated Like Button

```dart
class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  int _likeCount = 42;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isLiked ? Colors.red.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.grey,
              size: 28,
            ),
          ),
          SizedBox(width: 8),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: _likeCount - 1, end: _likeCount),
            duration: Duration(milliseconds: 200),
            builder: (context, value, child) {
              return Text(
                '$value',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isLiked ? Colors.red : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Animated Card Flip

```dart
class FlipCard extends StatefulWidget {
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _showFront = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFront = !_showFront;
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _showFront ? 0 : 3.14159),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            alignment: Alignment.center,
            child: value < 1.5708  // Half way through flip
                ? _buildFrontCard()
                : Transform(
                    transform: Matrix4.identity()..rotateY(3.14159),
                    alignment: Alignment.center,
                    child: _buildBackCard(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Center(
        child: Text(
          'FRONT',
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Center(
        child: Text(
          'BACK',
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
}
```

## Exercises

### Exercise 1: Animated Button (Beginner)

Create a button that animates when tapped.

**Requirements:**
- Button grows slightly when tapped (scale effect)
- Changes color when pressed
- Returns to normal when released
- Use AnimatedContainer

### Exercise 2: Loading Indicator (Beginner-Intermediate)

Build a custom loading indicator.

**Requirements:**
- Three dots that fade in/out sequentially
- Continuous animation (loops forever)
- Use AnimatedOpacity
- Smooth transitions

### Exercise 3: Expandable Card (Intermediate)

Create a card that expands to show more details.

**Requirements:**
- Compact view shows title and icon
- Tapping expands to show description
- Smooth size transition
- Border radius changes during animation
- Use AnimatedContainer

### Exercise 4: Animated Dashboard (Intermediate-Advanced)

Build a dashboard with animated statistics.

**Requirements:**
- Multiple stat cards (users, revenue, orders)
- Numbers count up from 0 when screen loads
- Sequential animation (cards appear one by one)
- Progress bars fill up smoothly
- Use TweenAnimationBuilder

### Exercise 5: Shopping Cart Button (Advanced)

Create an "Add to Cart" button with animations.

**Requirements:**
- Button pulses when item added
- Shows item count badge
- Badge animates in/out
- Count increases with animation
- Color changes based on cart state
- Combine multiple implicit animations

## What You've Learned

✅ What animations are and why they matter
✅ Difference between implicit and explicit animations
✅ AnimatedContainer for versatile transitions
✅ AnimatedOpacity for fade effects
✅ AnimatedPadding, AnimatedAlign, AnimatedPositioned
✅ Animation curves for natural motion
✅ TweenAnimationBuilder for custom animations
✅ Real-world examples (like button, card flip)
✅ Best practices for smooth animations

## Next Steps

In the next lesson, we'll explore **Explicit Animations** where you get full control with AnimationController, Tween, and advanced animation techniques!

You're making your apps come alive! 🚀
