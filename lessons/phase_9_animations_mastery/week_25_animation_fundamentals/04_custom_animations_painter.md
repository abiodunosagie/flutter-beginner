# Custom Animations with CustomPainter

## What You'll Learn

In this comprehensive lesson, you'll master:
- What CustomPainter is and when to use it
- Drawing basics (lines, circles, paths, text)
- Animating custom drawings
- Creating progress indicators
- Drawing charts and graphs
- Particle effects and visualizations
- Performance optimization
- Real-world examples
- 5 progressive exercises

By the end, you'll create stunning custom animations from scratch!

## 5-Year-Old Explanation

### What is CustomPainter?

Imagine you have a magical canvas and paintbrush:

**Regular Widgets = LEGO Blocks:**
```
Container() = Blue square block 🟦
Text() = Letter blocks 🔤
Icon() = Shaped blocks ⭐

You build by stacking pre-made blocks
```

**CustomPainter = Blank Canvas:**
```
You have: Blank canvas 🎨 + Paintbrush 🖌️

You can draw ANYTHING:
- Squiggly lines
- Custom shapes
- Gradients
- Animations
- Your imagination is the limit! ✨
```

**When to Use CustomPainter:**
- ✅ Drawing custom shapes
- ✅ Charts and graphs
- ✅ Progress indicators
- ✅ Particle effects
- ✅ Games
- ✅ Complex animations

## Part 1: CustomPainter Basics

### Simple Circle

```dart
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create paint (like choosing paint color)
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Draw circle at center
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),  // Center point
      50,  // Radius
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Using it
class CircleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Circle')),
      body: Center(
        child: CustomPaint(
          size: Size(200, 200),
          painter: CirclePainter(),
        ),
      ),
    );
  }
}
```

### Drawing Different Shapes

```dart
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;

    // 1. Draw Line
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(20, 20),
      Offset(180, 20),
      paint,
    );

    // 2. Draw Rectangle
    canvas.drawRect(
      Rect.fromLTWH(20, 40, 160, 80),  // left, top, width, height
      paint,
    );

    // 3. Draw Circle (filled)
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(100, 180),
      30,
      paint,
    );

    // 4. Draw Oval
    canvas.drawOval(
      Rect.fromLTWH(20, 220, 160, 60),
      paint,
    );

    // 5. Draw Arc (partial circle)
    canvas.drawArc(
      Rect.fromLTWH(20, 300, 160, 160),
      0,  // Start angle (radians)
      3.14,  // Sweep angle (π = 180°)
      true,  // Use center
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```

### Paint Properties

```dart
final paint = Paint()
  // Color
  ..color = Colors.blue

  // Style (fill or stroke)
  ..style = PaintingStyle.fill  // or .stroke

  // Stroke width (for stroke style)
  ..strokeWidth = 5

  // Cap (line endings)
  ..strokeCap = StrokeCap.round  // or .square, .butt

  // Anti-aliasing (smooth edges)
  ..isAntiAlias = true

  // Blend mode
  ..blendMode = BlendMode.srcOver

  // Shader (gradient)
  ..shader = LinearGradient(
    colors: [Colors.red, Colors.blue],
  ).createShader(Rect.fromLTWH(0, 0, 200, 200));
```

## Part 2: Animating CustomPainter

### Animated Circle

```dart
class AnimatedCirclePainter extends CustomPainter {
  final double progress;  // 0.0 to 1.0

  AnimatedCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final radius = 50 * progress;  // Radius grows with progress

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(AnimatedCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;  // Repaint when progress changes
  }
}

// Using with animation
class AnimatedCircleDemo extends StatefulWidget {
  @override
  _AnimatedCircleDemoState createState() => _AnimatedCircleDemoState();
}

class _AnimatedCircleDemoState extends State<AnimatedCircleDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Circle')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(200, 200),
              painter: AnimatedCirclePainter(progress: _controller.value),
            );
          },
        ),
      ),
    );
  }
}
```

### Circular Progress Indicator

```dart
class CircularProgressPainter extends CustomPainter {
  final double progress;  // 0.0 to 1.0

  CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle (gray)
    final bgPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc (blue)
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,  // Start at top (-90° in radians)
      2 * 3.14159 * progress,  // Sweep based on progress
      false,
      progressPaint,
    );

    // Draw percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Usage
class CircularProgressDemo extends StatefulWidget {
  @override
  _CircularProgressDemoState createState() => _CircularProgressDemoState();
}

class _CircularProgressDemoState extends State<CircularProgressDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
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
      appBar: AppBar(title: Text('Circular Progress')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(200, 200),
                  painter: CircularProgressPainter(progress: _controller.value),
                );
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _controller.reset();
                _controller.forward();
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Part 3: Drawing Paths

Paths let you draw complex shapes!

### Custom Shape

```dart
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius / 2;

    // Draw 5-pointed star
    for (int i = 0; i < 5; i++) {
      double angle = (i * 4 * 3.14159 / 5) - (3.14159 / 2);

      // Outer point
      double x = center.dx + outerRadius * cos(angle);
      double y = center.dy + outerRadius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Inner point
      angle += 2 * 3.14159 / 5;
      x = center.dx + innerRadius * cos(angle);
      y = center.dy + innerRadius * sin(angle);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```

### Animated Wave

```dart
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start bottom left
    path.moveTo(0, size.height);

    // Draw wave
    for (double x = 0; x <= size.width; x++) {
      double y = size.height / 2 +
          30 * sin((x / size.width * 2 * 3.14159) + (animationValue * 2 * 3.14159));

      path.lineTo(x, y);
    }

    // Complete path to bottom right and back
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Animated wave demo
class WaveDemo extends StatefulWidget {
  @override
  _WaveDemoState createState() => _WaveDemoState();
}

class _WaveDemoState extends State<WaveDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
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
    return Scaffold(
      appBar: AppBar(title: Text('Wave Animation')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(double.infinity, 200),
            painter: WavePainter(animationValue: _controller.value),
          );
        },
      ),
    );
  }
}
```

## Part 4: Bar Chart Example

```dart
class BarChartPainter extends CustomPainter {
  final List<double> data;
  final double animationValue;

  BarChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final barWidth = size.width / (data.length * 2);
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxValue) * size.height * animationValue;
      final x = (i * 2 + 0.5) * barWidth;
      final y = size.height - barHeight;

      // Draw bar
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        paint,
      );

      // Draw value on top
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].toInt().toString(),
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, y - 20),
      );
    }
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Usage
class BarChartDemo extends StatefulWidget {
  @override
  _BarChartDemoState createState() => _BarChartDemoState();
}

class _BarChartDemoState extends State<BarChartDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final List<double> data = [45, 78, 62, 90, 55, 73];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
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
    return Scaffold(
      appBar: AppBar(title: Text('Bar Chart')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(300, 200),
                painter: BarChartPainter(
                  data: data,
                  animationValue: _controller.value,
                ),
              );
            },
          ),
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

## Part 5: Particle Effects

```dart
class Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });

  void update(Size size) {
    position += velocity;

    // Bounce off edges
    if (position.dx < 0 || position.dx > size.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > size.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      paint.color = particle.color;
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class ParticleDemo extends StatefulWidget {
  @override
  _ParticleDemoState createState() => _ParticleDemoState();
}

class _ParticleDemoState extends State<ParticleDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  List<Particle> particles = [];
  final random = Random();

  @override
  void initState() {
    super.initState();

    // Create particles
    for (int i = 0; i < 50; i++) {
      particles.add(Particle(
        position: Offset(
          random.nextDouble() * 300,
          random.nextDouble() * 400,
        ),
        velocity: Offset(
          random.nextDouble() * 4 - 2,
          random.nextDouble() * 4 - 2,
        ),
        radius: random.nextDouble() * 5 + 2,
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
      ));
    }

    _controller = AnimationController(
      duration: Duration(seconds: 100),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (var particle in particles) {
          particle.update(Size(300, 400));
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
      appBar: AppBar(title: Text('Particle Effect')),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          color: Colors.black,
          child: CustomPaint(
            painter: ParticlePainter(particles: particles),
          ),
        ),
      ),
    );
  }
}
```

## Part 6: Performance Tips

### 1. Use shouldRepaint Wisely

```dart
@override
bool shouldRepaint(MyPainter oldDelegate) {
  // Only repaint if data changed
  return oldDelegate.data != data;
}
```

### 2. Cache Expensive Calculations

```dart
class OptimizedPainter extends CustomPainter {
  Path? _cachedPath;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate path only once
    _cachedPath ??= _buildComplexPath(size);

    canvas.drawPath(_cachedPath!, paint);
  }

  Path _buildComplexPath(Size size) {
    // Expensive calculation done once
    return Path()../* complex path building */;
  }
}
```

### 3. Use RepaintBoundary

```dart
// Prevents unnecessary repaints
RepaintBoundary(
  child: CustomPaint(
    painter: MyPainter(),
  ),
)
```

## Exercises

### Exercise 1: Loading Dots (Beginner)

Create animated loading dots using CustomPainter.

**Requirements:**
- Three dots in a row
- Each dot bounces up and down
- Sequential animation
- Use CustomPainter to draw circles

### Exercise 2: Speedometer (Beginner-Intermediate)

Build a speedometer gauge.

**Requirements:**
- Semi-circle gauge (180°)
- Needle that rotates
- Value from 0-100
- Animate needle to target value
- Draw using arcs and lines

### Exercise 3: Line Chart (Intermediate)

Create an animated line chart.

**Requirements:**
- Plot points from data array
- Connect points with smooth line
- Animate line drawing from left to right
- Show dots at each point
- Grid lines in background

### Exercise 4: Ripple Effect (Intermediate-Advanced)

Build a ripple animation like water ripples.

**Requirements:**
- Tap screen to create ripple
- Multiple expanding circles
- Fade out as they expand
- Multiple ripples at once
- Use CustomPainter with animation

### Exercise 5: Fireworks (Advanced)

Create a fireworks animation.

**Requirements:**
- Tap to launch firework
- Particles explode outward
- Particles fall with gravity
- Multiple colors
- Fade out effect
- Realistic physics

## What You've Learned

✅ CustomPainter basics (paint, canvas, size)
✅ Drawing shapes (circles, rectangles, paths)
✅ Animating custom drawings
✅ Creating progress indicators
✅ Drawing charts and graphs
✅ Particle effects
✅ Performance optimization
✅ Real-world examples

## Next Steps

In the next lesson, we'll explore **Staggered Animations** - orchestrating multiple animations together!

You're creating stunning custom visuals! 🚀
