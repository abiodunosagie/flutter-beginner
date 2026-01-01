# Level 14: Real-World Apps Using These Concepts

See how animations make apps feel magical!

---

## Implicit Animations

### Effortless Polish!

**Like Button (Instagram)**
```dart
class LikeButton extends StatefulWidget {
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isLiked = !_isLiked),
      child: AnimatedScale(
        scale: _isLiked ? 1.2 : 1.0,
        duration: Duration(milliseconds: 150),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(_isLiked),
            color: _isLiked ? Colors.red : Colors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }
}
```

**Expandable Card (Airbnb)**
```dart
class ExpandableCard extends StatefulWidget {
  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 300 : 150,
        child: Card(
          child: Column(
            children: [
              Image.network(imageUrl),
              AnimatedCrossFade(
                firstChild: Text('Show more'),
                secondChild: Text(fullDescription),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Hero Animations

### Seamless Transitions!

**Product Detail (Amazon, eBay)**
```dart
// Product grid
GridView.builder(
  itemBuilder: (context, index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: products[index]),
        ),
      ),
      child: Hero(
        tag: 'product-${products[index].id}',
        child: Image.network(products[index].imageUrl),
      ),
    );
  },
)

// Product detail
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'product-${product.id}',
            child: Image.network(product.imageUrl),
          ),
          // ... rest of details
        ],
      ),
    );
  }
}
```

---

## Explicit Animations

### Full Control!

**Pull to Refresh Indicator**
```dart
class RefreshIndicator extends StatefulWidget {
  @override
  State<RefreshIndicator> createState() => _RefreshIndicatorState();
}

class _RefreshIndicatorState extends State<RefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(Icons.refresh, size: 32),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

**Typing Indicator (WhatsApp)**
```dart
class TypingIndicator extends StatefulWidget {
  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0),
        _buildDot(1),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = ((_controller.value + delay) % 1.0);
        final bounce = sin(value * pi);

        return Transform.translate(
          offset: Offset(0, -4 * bounce),
          child: Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
```

---

## Staggered Animations

### Choreographed Motion!

**List Item Entrance (Twitter, Slack)**
```dart
class StaggeredList extends StatefulWidget {
  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final start = index / items.length;
        final end = (index + 1) / items.length;

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _controller,
              curve: Interval(start, end),
            ),
            child: ListTile(title: Text(items[index])),
          ),
        );
      },
    );
  }
}
```

---

## Shimmer Loading

### Better Than Spinners!

**Content Placeholder (Facebook, LinkedIn)**
```dart
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
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
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
```

---

## Page Transitions

### Smooth Navigation!

**Custom Route Transition**
```dart
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            );
          },
        );
}
```

---

## Real Apps Animation Examples

| App | Signature Animation |
|-----|-------------------|
| **Instagram** | Double-tap heart animation |
| **Twitter** | Pull-to-refresh bird animation |
| **Uber** | Car moving on map |
| **Airbnb** | Image gallery transitions |
| **Spotify** | Now playing bar slide-up |
| **Apple Music** | Album art transitions |

---

## Lottie Animations

### Designer-Created Animations!

```dart
class LottieSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/success.json',
      width: 200,
      height: 200,
      repeat: false,
    );
  }
}
```

---

## Animation Performance Tips

| Tip | Why It Matters |
|-----|---------------|
| **Use const widgets** | Prevents rebuilds |
| **Animate transforms** | GPU-accelerated |
| **Avoid opacity on large areas** | Can be expensive |
| **Use RepaintBoundary** | Isolates repaints |
| **Profile with DevTools** | Find bottlenecks |

---

## Build It Yourself!

After this level, you could:

1. **Add microinteractions** - Button press feedback
2. **Create loading skeletons** - Shimmer placeholders
3. **Build onboarding** - Animated page indicators
4. **Polish navigation** - Custom page transitions
5. **Make delightful moments** - Success celebrations

---

**Animations are the difference between a good app and a great app!**
