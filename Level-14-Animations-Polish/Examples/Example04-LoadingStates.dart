// ============================================
// EXAMPLE 04: LOADING STATES & POLISH
// Professional UI polish and feedback
// ============================================

/*
  This file demonstrates:
  1. Skeleton loading screens
  2. Custom loading indicators
  3. Button feedback animations
  4. Success/error animations
  5. Haptic feedback

  NOTE: Copy this code into a real Flutter project to run it.
*/

// ============================================
// SKELETON LOADING SCREEN
// ============================================

/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Shimmer effect for skeleton loading
class ShimmerWidget extends StatefulWidget {
  final Widget child;

  const ShimmerWidget({super.key, required this.child});

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
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
              colors: const [
                Color(0xFFEBEBEB),
                Color(0xFFF5F5F5),
                Color(0xFFEBEBEB),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

// Skeleton card for list loading
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar skeleton
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
                  // Title skeleton
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle skeleton
                  Container(
                    height: 12,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Skeleton list
class SkeletonList extends StatelessWidget {
  final int itemCount;

  const SkeletonList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}
*/

// ============================================
// PULSING DOTS LOADER
// ============================================

/*
class PulsingDots extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingDots({
    super.key,
    this.color = Colors.blue,
    this.size = 12,
  });

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
            // Stagger each dot
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;

            // Scale: small -> big -> small
            final scale = 0.5 + 0.5 * (1 - (value - 0.5).abs() * 2);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color,
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
*/

// ============================================
// ANIMATED BUTTON WITH LOADING STATE
// ============================================

/*
class LoadingButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;

  const LoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;

    HapticFeedback.mediumImpact();

    setState(() => _isLoading = true);

    try {
      await widget.onPressed();
      HapticFeedback.lightImpact();
    } catch (e) {
      HapticFeedback.heavyImpact();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isLoading ? 56 : 200,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_isLoading ? 28 : 12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(widget.text),
      ),
    );
  }
}

// Usage:
// LoadingButton(
//   text: 'Submit',
//   onPressed: () async {
//     await Future.delayed(Duration(seconds: 2));
//   },
// )
*/

// ============================================
// SUCCESS CHECKMARK ANIMATION
// ============================================

/*
class AnimatedCheckmark extends StatefulWidget {
  final double size;
  final Color color;

  const AnimatedCheckmark({
    super.key,
    this.size = 80,
    this.color = Colors.green,
  });

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Circle grows first (0% to 50%)
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Check draws second (40% to 100%)
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
          scale: _circleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: CheckPainter(
                progress: _checkAnimation.value,
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Checkmark points (relative to size)
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
      // First stroke complete + second stroke
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
*/

// ============================================
// PRESS EFFECT BUTTON
// ============================================

/*
class PressEffectButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const PressEffectButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  State<PressEffectButton> createState() => _PressEffectButtonState();
}

class _PressEffectButtonState extends State<PressEffectButton> {
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
          transform: Matrix4.identity()
            ..translate(0.0, _isPressed ? 2.0 : 0.0),
          child: widget.child,
        ),
      ),
    );
  }
}

// Usage:
// PressEffectButton(
//   onPressed: () => print('Pressed!'),
//   child: Container(
//     padding: EdgeInsets.all(16),
//     color: Colors.blue,
//     child: Text('Press Me'),
//   ),
// )
*/

// ============================================
// EMPTY STATE WITH ANIMATION
// ============================================

/*
class AnimatedEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AnimatedEmptyState({
    super.key,
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
              duration: const Duration(milliseconds: 600),
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

            // Animated title
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Animated description
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),

            if (buttonText != null) ...[
              const SizedBox(height: 24),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      child: Text(buttonText!),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage:
// AnimatedEmptyState(
//   icon: Icons.inbox_outlined,
//   title: 'No Messages',
//   description: 'Your inbox is empty',
//   buttonText: 'Compose',
//   onButtonPressed: () {},
// )
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │           LOADING STATES & POLISH EXAMPLES                   │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  SKELETON LOADING:                                           │
  │  └── ShimmerWidget + SkeletonCard                           │
  │  └── Placeholder content while loading                      │
  │                                                              │
  │  PULSING DOTS:                                               │
  │  └── Three dots that pulse in sequence                      │
  │  └── Great for inline loading indicators                    │
  │                                                              │
  │  LOADING BUTTON:                                             │
  │  └── Button shrinks to circle when loading                  │
  │  └── Shows spinner during async operation                   │
  │                                                              │
  │  SUCCESS CHECKMARK:                                          │
  │  └── Circle scales up with elastic curve                    │
  │  └── Checkmark draws inside                                 │
  │                                                              │
  │  PRESS EFFECT:                                               │
  │  └── Button shrinks slightly on press                       │
  │  └── Adds depth with transform                              │
  │                                                              │
  │  EMPTY STATE:                                                │
  │  └── Animated icon and text                                 │
  │  └── Guides user on what to do                              │
  │                                                              │
  │  HAPTIC FEEDBACK:                                            │
  │  └── lightImpact()  - Selections                            │
  │  └── mediumImpact() - Button presses                        │
  │  └── heavyImpact()  - Major actions/errors                  │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
