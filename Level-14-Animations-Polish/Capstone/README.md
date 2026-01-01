# Level 14 Capstone: Animations & Visual Polish

## What You're Building

In this level, you'll add **beautiful animations and visual polish** to make ShopEase feel premium and professional!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 14 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase Animations                                        │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   1. Product Card Hover/Tap                         │   │
│   │   ┌─────────┐       ┌─────────┐                    │   │
│   │   │   📦    │  ───▶ │   📦    │ ↑ Scale up        │   │
│   │   │ Normal  │       │ Pressed │   + shadow        │   │
│   │   └─────────┘       └─────────┘                    │   │
│   │                                                     │   │
│   │   2. Add to Cart Animation                          │   │
│   │   ┌─────────┐       ┌─────────┐                    │   │
│   │   │  [Add]  │  ───▶ │  ✓ ──▶🛒│ Fly to cart      │   │
│   │   └─────────┘       └─────────┘                    │   │
│   │                                                     │   │
│   │   3. Page Transitions                               │   │
│   │   ┌─────┐           ┌─────┐                        │   │
│   │   │ A   │──slide──▶ │  B  │                        │   │
│   │   └─────┘   fade    └─────┘                        │   │
│   │                                                     │   │
│   │   4. Loading Shimmer                                │   │
│   │   ┌─────────────────────┐                          │   │
│   │   │ ▓▓▓░░░░░░▓▓▓░░░░░░ │ ← Shimmer effect        │   │
│   │   └─────────────────────┘                          │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Animated Product Card

Create a product card that responds to touch with smooth animations:

```dart
// lib/widgets/animated_product_card.dart

class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const AnimatedProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _elevationAnimation.value,
              child: child,
            ),
          );
        },
        child: _buildCardContent(),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero image for page transition
        Hero(
          tag: 'product-${widget.product.id}',
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.product.name, maxLines: 2),
              Text(widget.product.formattedPrice),
              AddToCartButton(
                product: widget.product,
                onPressed: widget.onAddToCart,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

### Task 2: Add to Cart Animation

Create a fun animation when adding items to cart:

```dart
// lib/widgets/add_to_cart_button.dart

class AddToCartButton extends StatefulWidget {
  final Product product;
  final VoidCallback? onPressed;

  const AddToCartButton({
    super.key,
    required this.product,
    this.onPressed,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _bounceController;
  late Animation<double> _checkAnimation;
  late Animation<double> _bounceAnimation;
  bool _isAdded = false;

  @override
  void initState() {
    super.initState();

    // Checkmark animation
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOut),
    );

    // Bounce animation
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAdded) return;

    setState(() => _isAdded = true);
    _checkController.forward();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    widget.onPressed?.call();

    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isAdded = false);
        _checkController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_checkAnimation, _bounceAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: ElevatedButton.icon(
            onPressed: _handleTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAdded ? Colors.green : null,
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isAdded
                  ? const Icon(Icons.check, key: ValueKey('check'))
                  : const Icon(Icons.add_shopping_cart, key: ValueKey('cart')),
            ),
            label: Text(_isAdded ? 'Added!' : 'Add to Cart'),
          ),
        );
      },
    );
  }
}
```

### Task 3: Page Transitions

Create custom page transitions for navigation:

```dart
// lib/router/page_transitions.dart

class SlideUpTransition extends CustomTransitionPage {
  SlideUpTransition({
    required super.child,
    super.key,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

class FadeScaleTransition extends CustomTransitionPage {
  FadeScaleTransition({
    required super.child,
    super.key,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 250),
        );
}

// Use in router
GoRoute(
  path: '/product/:id',
  pageBuilder: (context, state) {
    return FadeScaleTransition(
      key: state.pageKey,
      child: ProductDetailScreen(productId: state.pathParameters['id']!),
    );
  },
),
```

### Task 4: Shimmer Loading Effect

Create a shimmer effect for loading states:

```dart
// lib/widgets/shimmer_loading.dart

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 2).animate(
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Product card shimmer
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoading(
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: 120, height: 16),
                const SizedBox(height: 8),
                ShimmerLoading(width: 80, height: 14),
                const SizedBox(height: 8),
                ShimmerLoading(width: double.infinity, height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Task 5: Staggered List Animation

Animate products appearing one by one:

```dart
// lib/widgets/staggered_product_grid.dart

class StaggeredProductGrid extends StatefulWidget {
  final List<Product> products;

  const StaggeredProductGrid({super.key, required this.products});

  @override
  State<StaggeredProductGrid> createState() => _StaggeredProductGridState();
}

class _StaggeredProductGridState extends State<StaggeredProductGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100 * widget.products.length),
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
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final startTime = index / widget.products.length;
        final endTime = (index + 1) / widget.products.length;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = Interval(
              startTime,
              endTime,
              curve: Curves.easeOut,
            ).transform(_controller.value);

            return Opacity(
              opacity: progress,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - progress)),
                child: child,
              ),
            );
          },
          child: AnimatedProductCard(product: widget.products[index]),
        );
      },
    );
  }
}
```

---

## Animation Types Quick Reference

```
┌────────────────────────────────────────────────────────────┐
│                  ANIMATION TYPES                            │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  IMPLICIT (Simple - use AnimatedFoo widgets)               │
│  ───────────────────────────────────────────               │
│  • AnimatedContainer - size, color, padding                │
│  • AnimatedOpacity - fade in/out                           │
│  • AnimatedScale - grow/shrink                             │
│  • AnimatedSlide - move position                           │
│                                                             │
│  EXPLICIT (Complex - use AnimationController)              │
│  ─────────────────────────────────────────────             │
│  • Custom timing and curves                                │
│  • Multiple animations in sync                             │
│  • Repeating animations                                    │
│  • Gesture-driven animations                               │
│                                                             │
│  HERO (Page transitions)                                   │
│  ─────────────────────────                                 │
│  • Shared element between pages                            │
│  • Automatic flight animation                              │
│                                                             │
│  PHYSICS-BASED                                             │
│  ────────────────                                          │
│  • Spring animations                                       │
│  • Friction-based decay                                    │
│  • Natural, realistic motion                               │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## Success Criteria

- [ ] Product cards animate on tap (scale + elevation)
- [ ] Add to cart shows checkmark animation
- [ ] Hero animation works on product images
- [ ] Page transitions are smooth
- [ ] Loading shows shimmer effect
- [ ] Products animate in with stagger
- [ ] Animations don't cause jank (60fps)
- [ ] Animations respect reduced motion setting

---

## Accessibility Note

```dart
// Respect user's reduced motion preference
bool get reduceMotion =>
    MediaQuery.of(context).disableAnimations;

// Use in animations
Duration get animationDuration =>
    reduceMotion ? Duration.zero : const Duration(milliseconds: 300);
```

---

## Files to Create

```
shopease/
└── lib/
    ├── widgets/
    │   ├── animated_product_card.dart   ◄── Create
    │   ├── add_to_cart_button.dart      ◄── Create
    │   ├── shimmer_loading.dart         ◄── Create
    │   └── staggered_product_grid.dart  ◄── Create
    │
    └── router/
        └── page_transitions.dart        ◄── Create
```

---

**Your ShopEase app now feels alive and premium!**
