// ============================================
// EXAMPLE 02: CUSTOM ANIMATIONS
// Explicit animations with full control
// ============================================

/*
  This file demonstrates explicit animations using:
  1. AnimationController
  2. Tween animations
  3. CurvedAnimation
  4. Staggered animations
  5. Chained animations

  NOTE: Copy this code into a real Flutter project to run it.
*/

// ============================================
// BASIC ANIMATION CONTROLLER
// ============================================

/*
import 'package:flutter/material.dart';

class BasicControllerDemo extends StatefulWidget {
  const BasicControllerDemo({super.key});

  @override
  State<BasicControllerDemo> createState() => _BasicControllerDemoState();
}

class _BasicControllerDemoState extends State<BasicControllerDemo>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Create the controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create size animation (50 to 150)
    _sizeAnimation = Tween<double>(
      begin: 50,
      end: 150,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Create color animation
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();  // ALWAYS dispose!
    super.dispose();
  }

  void _playAnimation() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Controller')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return GestureDetector(
              onTap: _playAnimation,
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(
                    _sizeAnimation.value / 4,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Tap!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

// ============================================
// LOOPING ANIMATION
// ============================================

/*
class PulsingCircle extends StatefulWidget {
  const PulsingCircle({super.key});

  @override
  State<PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start looping animation (ping-pong)
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}
*/

// ============================================
// STAGGERED ANIMATIONS
// ============================================

/*
class StaggeredListAnimation extends StatefulWidget {
  const StaggeredListAnimation({super.key});

  @override
  State<StaggeredListAnimation> createState() => _StaggeredListAnimationState();
}

class _StaggeredListAnimationState extends State<StaggeredListAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  final int _itemCount = 5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create staggered animations for each item
    for (int i = 0; i < _itemCount; i++) {
      final start = i * 0.1;  // Each item starts 10% later
      final end = start + 0.5;  // Each animation lasts 50% of total

      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(-1, 0),  // Start from left
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end.clamp(0, 1), curve: Curves.easeOutCubic),
        )),
      );

      _fadeAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end.clamp(0, 1), curve: Curves.easeIn),
        )),
      );
    }

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replay() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staggered Animation')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimations[index],
                child: FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: child,
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('${index + 1}'),
                ),
                title: Text('Item ${index + 1}'),
                subtitle: const Text('Slides in from left'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _replay,
        child: const Icon(Icons.replay),
      ),
    );
  }
}
*/

// ============================================
// CHAINED ANIMATIONS
// ============================================

/*
class ChainedAnimation extends StatefulWidget {
  const ChainedAnimation({super.key});

  @override
  State<ChainedAnimation> createState() => _ChainedAnimationState();
}

class _ChainedAnimationState extends State<ChainedAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Phase 1: Scale up (0% to 30%)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.5)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.5),  // Hold
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    // Phase 2: Rotate (20% to 70%)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2,  // 2 full rotations
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
    ));

    // Phase 3: Color change (50% to 100%)
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.orange,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

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
      appBar: AppBar(title: const Text('Chained Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 3.14159,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/

// ============================================
// SPINNING LOADER
// ============================================

/*
class SpinningLoader extends StatefulWidget {
  final double size;
  final Color color;

  const SpinningLoader({
    super.key,
    this.size = 50,
    this.color = Colors.blue,
  });

  @override
  State<SpinningLoader> createState() => _SpinningLoaderState();
}

class _SpinningLoaderState extends State<SpinningLoader>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();  // Infinite loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.refresh,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}

// Usage:
// const SpinningLoader()
// const SpinningLoader(size: 80, color: Colors.green)
*/

// ============================================
// ANIMATED ICON BUTTON
// ============================================

/*
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = Colors.blue,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Usage:
// AnimatedIconButton(
//   icon: Icons.add,
//   onPressed: () => print('Pressed!'),
// )
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │          CUSTOM ANIMATION EXAMPLES                           │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  BASIC CONTROLLER                                            │
  │  └── Size + color animation with tap trigger                │
  │                                                              │
  │  LOOPING ANIMATION                                           │
  │  └── Pulsing heart with repeat(reverse: true)               │
  │                                                              │
  │  STAGGERED ANIMATIONS                                        │
  │  └── List items slide in one after another                  │
  │  └── Uses Interval for timing                               │
  │                                                              │
  │  CHAINED ANIMATIONS                                          │
  │  └── Scale → Rotate → Color in sequence                     │
  │  └── Uses TweenSequence and Interval                        │
  │                                                              │
  │  SPINNING LOADER                                             │
  │  └── Simple repeating rotation                              │
  │                                                              │
  │  ANIMATED ICON BUTTON                                        │
  │  └── Press effect with scale animation                      │
  │                                                              │
  │  KEY PATTERNS:                                               │
  │  1. SingleTickerProviderStateMixin for vsync                │
  │  2. AnimationController + Tween = Animation                 │
  │  3. CurvedAnimation for easing                              │
  │  4. Interval for timing in staggered animations             │
  │  5. Always dispose() the controller!                        │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
