# Level 14 Exercises: Animations & Polish

Welcome! These exercises teach you how to add smooth animations to your Flutter apps. Each part builds your animation skills step-by-step!

**How these exercises work:**
- Each PART focuses on ONE type of animation
- Within each part, exercises build on each other step-by-step
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, your apps will feel professional and polished!

---

## PART 1: Implicit Animations

Learn the simplest animations - just change a value!

### Exercise 1.1: Animated Color

**Goal:** Animate a container's color change.

**Your Task:** Make color transition smoothly.

```dart
class ColorBox extends StatefulWidget {
  @override
  State<ColorBox> createState() => _ColorBoxState();
}

class _ColorBoxState extends State<ColorBox> {
  bool _isBlue = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isBlue = !_isBlue);
      },
      child: AnimatedContainer(
        // TODO: Set duration to Duration(milliseconds: 300)
        // TODO: Set color to _isBlue ? Colors.blue : Colors.red
        width: 100,
        height: 100,
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
child: AnimatedContainer(
  duration: Duration(milliseconds: 300),
  color: _isBlue ? Colors.blue : Colors.red,
  width: 100,
  height: 100,
)
```

**What it does:**
- AnimatedContainer automatically animates property changes
- When color changes, it smoothly transitions
- Duration controls how long the animation takes
</details>

---

### Exercise 1.2: Animated Size

**Goal:** Animate a container growing and shrinking.

**Your Task:** Make the box expand when tapped.

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
      onTap: () {
        setState(() => _isExpanded = !_isExpanded);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: _isExpanded ? 200 : 100,
        height: _isExpanded ? 200 : 100,
        color: Colors.blue,
        // TODO: Add curve: Curves.easeInOut for smoother animation
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
child: AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _isExpanded ? 200 : 100,
  height: _isExpanded ? 200 : 100,
  color: Colors.blue,
)
```

**Key Points:**
- Width and height animate automatically
- `curve` makes the animation feel more natural
- `Curves.easeInOut` starts slow, speeds up, then slows down
</details>

---

### Exercise 1.3: Animated Opacity

**Goal:** Fade a widget in and out.

**Your Task:** Make text fade in/out on tap.

```dart
class FadingText extends StatefulWidget {
  @override
  State<FadingText> createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          // TODO: Set opacity to _isVisible ? 1.0 : 0.0
          // TODO: Set duration to 500ms
          child: Text('Hello!', style: TextStyle(fontSize: 24)),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => _isVisible = !_isVisible);
          },
          child: Text('Toggle'),
        ),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Hello!', style: TextStyle(fontSize: 24)),
)
```
</details>

---

### Exercise 1.4: Like Button Challenge

**Goal:** Create an animated like button - NO scaffolding!

**Your Task:** Build a heart button that animates when tapped.

**Requirements:**
1. Use AnimatedScale to make heart pop
2. Scale to 1.2 when liked, 1.0 when not
3. Change color from grey to red
4. Use Icons.favorite when liked, Icons.favorite_border when not
5. Animate smoothly in 200ms

Try building this on your own!

<details>
<summary>✅ Solution</summary>

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
      onTap: () {
        setState(() => _isLiked = !_isLiked);
      },
      child: AnimatedScale(
        scale: _isLiked ? 1.2 : 1.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Icon(
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? Colors.red : Colors.grey,
          size: 48,
        ),
      ),
    );
  }
}
```
</details>

---

## PART 2: AnimatedSwitcher

Learn to animate when widgets change.

### Exercise 2.1: Simple Counter Animation

**Goal:** Animate numbers changing.

**Your Task:** Make counter numbers slide when changing.

```dart
class AnimatedCounter extends StatefulWidget {
  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          // TODO: Add this child with key
          child: Text(
            '$_count',
            // TODO: Add key: ValueKey(_count)
            style: TextStyle(fontSize: 48),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => setState(() => _count++),
        ),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 200),
  child: Text(
    '$_count',
    key: ValueKey(_count),
    style: TextStyle(fontSize: 48),
  ),
)
```

**What it does:**
- AnimatedSwitcher detects when child changes
- Uses the key to know child changed
- Automatically fades old out, new in
</details>

---

### Exercise 2.2: Custom Transition

**Goal:** Add a slide transition to the counter.

**Your Task:** Make numbers slide up instead of fade.

```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 200),
  transitionBuilder: (child, animation) {
    // TODO: Return SlideTransition
    // TODO: Offset should start at Offset(0, 0.3) and end at Offset.zero
    // TODO: Use Tween for offset animation
  },
  child: Text(
    '$_count',
    key: ValueKey(_count),
    style: TextStyle(fontSize: 48),
  ),
)
```

<details>
<summary>✅ Solution</summary>

```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 200),
  transitionBuilder: (child, animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
  child: Text(
    '$_count',
    key: ValueKey(_count),
    style: TextStyle(fontSize: 48),
  ),
)
```
</details>

---

### Exercise 2.3: Switcher Challenge

**Goal:** Create content that switches with animation - NO scaffolding!

**Requirements:**
1. Show different widgets based on a boolean
2. When true: show "✓ Success" in green
3. When false: show "X Error" in red
4. Animate the switch with slide + fade
5. Add a button to toggle

Try building this on your own!

<details>
<summary>✅ Reference Solution</summary>

`AnimatedSwitcher` animates the swap automatically when the `child`'s `key` changes:

```dart
class SwitcherDemo extends StatefulWidget {
  const SwitcherDemo({super.key});
  @override
  State<SwitcherDemo> createState() => _SwitcherDemoState();
}

class _SwitcherDemoState extends State<SwitcherDemo> {
  bool _ok = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween(begin: const Offset(0, 0.3), end: Offset.zero)
                .animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: _ok
              ? const Text('✓ Success',
                  key: ValueKey('ok'),
                  style: TextStyle(color: Colors.green, fontSize: 28))
              : const Text('✗ Error',
                  key: ValueKey('err'),
                  style: TextStyle(color: Colors.red, fontSize: 28)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => setState(() => _ok = !_ok),
          child: const Text('Toggle'),
        ),
      ],
    );
  }
}
```

The two `Text` widgets must have **different keys** (`ValueKey('ok')` vs `ValueKey('err')`), otherwise `AnimatedSwitcher` thinks it is the same widget and skips the animation. The `transitionBuilder` combines a slide and a fade.

</details>

---

## PART 3: Hero Animations

Learn to animate widgets between screens.

### Exercise 3.1: Simple Hero

**Goal:** Make an image fly between screens.

**Your Task:** Wrap image in Hero widget.

```dart
// Screen 1
class ImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageDetailScreen(index: index),
              ),
            );
          },
          child: Hero(
            // TODO: Set tag to 'image_$index'
            child: Image.network(
              'https://picsum.photos/id/${index * 10}/200',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

// Screen 2
class ImageDetailScreen extends StatelessWidget {
  final int index;

  ImageDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          // TODO: Set same tag 'image_$index'
          child: Image.network(
            'https://picsum.photos/id/${index * 10}/400',
          ),
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
// Screen 1
child: Hero(
  tag: 'image_$index',
  child: Image.network(
    'https://picsum.photos/id/${index * 10}/200',
    height: 100,
    width: 100,
    fit: BoxFit.cover,
  ),
)

// Screen 2
child: Hero(
  tag: 'image_$index',
  child: Image.network(
    'https://picsum.photos/id/${index * 10}/400',
  ),
)
```

**What it does:**
- Hero widgets with matching tags animate together
- Image smoothly flies from list to detail screen
- Happens automatically during navigation
</details>

---

### Exercise 3.2: Hero Challenge

**Goal:** Create photo gallery with Hero - NO scaffolding!

**Requirements:**
1. Grid of 6 images (3x2)
2. Tap to open full screen
3. Hero animation on image
4. Show image title below full image
5. Tap anywhere to go back

Try building this on your own!

<details>
<summary>✅ Reference Solution</summary>

The same `Hero` tag on the grid image and the full-screen image makes it fly between screens:

```dart
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});
  static const titles = ['One','Two','Three','Four','Five','Six'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.count(
        crossAxisCount: 3,                         // 3 columns -> 3x2 for 6 items
        children: List.generate(6, (i) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => FullScreen(index: i, title: titles[i]),
            )),
            child: Hero(
              tag: 'photo_$i',                      // unique tag per item
              child: Container(
                margin: const EdgeInsets.all(4),
                color: Colors.primaries[i % Colors.primaries.length],
                child: Center(child: Text(titles[i])),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  final int index;
  final String title;
  const FullScreen({super.key, required this.index, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pop(context),        // tap anywhere to go back
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'photo_$index',                // SAME tag = animates
                child: Container(
                  width: 250, height: 250,
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
```

I used colored containers in place of real images so it runs without assets; swap in `Image.asset(...)` inside each `Hero`. The critical part is the matching `tag: 'photo_$i'` on both screens.

</details>

---

## PART 4: Explicit Animations

Learn full control with AnimationController.

### Exercise 4.1: Rotating Icon

**Goal:** Make an icon spin continuously.

**Your Task:** Create a spinning loading indicator.

```dart
class SpinningIcon extends StatefulWidget {
  @override
  State<SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<SpinningIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Create AnimationController with vsync: this
    // TODO: Set duration to 2 seconds
    // TODO: Call _controller.repeat() to loop forever
  }

  @override
  void dispose() {
    // TODO: Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      // TODO: Set turns to _controller
      child: Icon(Icons.refresh, size: 64),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
@override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
  )..repeat();
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
    child: Icon(Icons.refresh, size: 64),
  );
}
```

**What it does:**
- AnimationController generates values from 0 to 1
- repeat() makes it loop infinitely
- RotationTransition rotates based on controller value
- Must dispose controller to prevent memory leaks
</details>

---

### Exercise 4.2: Staggered Animation

**Goal:** Animate multiple properties at different times.

**Your Task:** Make a box that slides in AND fades in.

```dart
class StaggeredBox extends StatefulWidget {
  @override
  State<StaggeredBox> createState() => _StaggeredBoxState();
}

class _StaggeredBoxState extends State<StaggeredBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // TODO: Create _fadeAnimation using Tween(0.0, 1.0)
    // TODO: Use Interval(0.0, 0.5) for first half

    // TODO: Create _slideAnimation using Tween for Offset
    // TODO: Start from Offset(0, 1), end at Offset.zero
    // TODO: Use Interval(0.3, 1.0) for last 70%

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 200,
          height: 200,
          color: Colors.blue,
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
@override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );

  _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5),
    ),
  );

  _slideAnimation = Tween<Offset>(
    begin: Offset(0, 1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ),
  );

  _controller.forward();
}
```

**What it does:**
- Interval staggers animations at different times
- Fade happens in first 50% (0.0 to 0.5)
- Slide happens in last 70% (0.3 to 1.0)
- Creates a polished, layered effect
</details>

---

### Exercise 4.3: Loading Button Challenge

**Goal:** Create a button with loading animation - NO scaffolding!

**Requirements:**
1. Normal state: "Submit" button (full width)
2. Loading state: Button shrinks to circle with spinner
3. Success state: Checkmark icon appears
4. After 1 second, reset to normal
5. Use AnimatedContainer for width/borderRadius

Try building this on your own!

<details>
<summary>✅ Reference Solution</summary>

```dart
enum BtnState { normal, loading, success }

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key});
  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  BtnState _state = BtnState.normal;

  Future<void> _submit() async {
    setState(() => _state = BtnState.loading);
    await Future.delayed(const Duration(seconds: 2)); // pretend work
    setState(() => _state = BtnState.success);
    await Future.delayed(const Duration(seconds: 1)); // show check
    if (mounted) setState(() => _state = BtnState.normal); // reset
  }

  @override
  Widget build(BuildContext context) {
    final isNormal = _state == BtnState.normal;
    return Center(
      child: GestureDetector(
        onTap: isNormal ? _submit : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: isNormal ? 300 : 60,                 // full width -> circle
          height: 60,
          decoration: BoxDecoration(
            color: _state == BtnState.success ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(isNormal ? 8 : 30),
          ),
          child: Center(child: _child()),
        ),
      ),
    );
  }

  Widget _child() {
    switch (_state) {
      case BtnState.normal:
        return const Text('Submit', style: TextStyle(color: Colors.white));
      case BtnState.loading:
        return const SizedBox(
          width: 24, height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        );
      case BtnState.success:
        return const Icon(Icons.check, color: Colors.white);
    }
  }
}
```

`AnimatedContainer` smoothly animates the `width` (300 to 60) and `borderRadius` (8 to 30) whenever `setState` changes the state, turning the bar into a circle. An `enum` tracks the three states cleanly.

</details>

---

## FINAL PROJECT: Animated Onboarding

**Goal:** Create a complete onboarding flow with animations!

**Your Task:** Build a 3-page onboarding - NO help!

### Requirements:

**PageView Setup:**
- 3 pages with different icons, titles, descriptions
- Swipe to navigate between pages
- Page indicator dots (current page highlighted)

**Animations Per Page:**
- Icon bounces in (ScaleTransition)
- Title slides in from right
- Description fades in
- Stagger these 100ms apart

**Navigation:**
- "Next" button on pages 1-2
- "Get Started" button on page 3
- Button animates when changing text

**Polish:**
- Smooth page transitions
- Dots animate when page changes
- Colors match your theme

### Build this using everything you learned!

---

## Submission Checklist

Before moving to the next level:

- [ ] Completed all PART 1 exercises (Implicit Animations)
- [ ] Completed all PART 2 exercises (AnimatedSwitcher)
- [ ] Completed all PART 3 exercises (Hero Animations)
- [ ] Completed all PART 4 exercises (Explicit Animations)
- [ ] Completed the Final Project
- [ ] Animations feel smooth (not too fast/slow)
- [ ] Controllers are disposed properly
- [ ] Curves are used for natural motion
- [ ] No performance issues

---

## Animation Best Practices

```
DURATION GUIDELINES:
- Micro-interactions: 100-200ms (buttons, toggles)
- Transitions: 200-300ms (navigation, reveals)
- Complex animations: 300-500ms (multi-step effects)

CURVES TO USE:
- Curves.easeInOut → Most animations
- Curves.easeOut → Elements entering
- Curves.easeIn → Elements exiting
- Curves.elasticOut → Playful bounces
- Curves.fastOutSlowIn → Material Design standard

PERFORMANCE TIPS:
- Always dispose AnimationControllers
- Use const constructors where possible
- Avoid animating during build
- Use RepaintBoundary for complex scenes
```

---

## Need Help?

Review the theory files about animations in the Theory folder!

---

**Your apps now feel alive and polished!** ✨
