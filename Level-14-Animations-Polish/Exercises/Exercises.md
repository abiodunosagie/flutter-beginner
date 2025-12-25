# Level 14: Animations & Polish - Exercises

Practice creating smooth, delightful animations!

---

## Exercise 1: Animated Like Button (Beginner)

**Goal:** Create a heart button that animates when tapped.

```
WHAT TO BUILD:

  Before Tap          After Tap
     ♡                  ❤️
   (gray)            (red + bigger)

  The heart should:
  1. Scale up briefly
  2. Change color to red
  3. Scale back to normal size
```

**Requirements:**
- Use `AnimatedScale` and `AnimatedContainer`
- Heart grows to 1.3x then settles at 1.0x
- Color changes from gray to red
- Animation duration: 200ms

**Starter Code:**
```dart
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    // TODO: Implement animated like button
    // Hint: Use AnimatedScale for the pop effect
    // Hint: Use Icon with color animation

    return GestureDetector(
      onTap: () {
        setState(() {
          _isLiked = !_isLiked;
        });
      },
      child: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : Colors.grey,
        size: 32,
      ),
    );
  }
}
```

**Expected Behavior:**
- Tap → Heart pops bigger → Settles to normal size
- Color animates smoothly from gray to red
- Tap again → Reverse animation

---

## Exercise 2: Expanding Card (Beginner)

**Goal:** Create a card that expands to show more content.

```
COLLAPSED:                    EXPANDED:
┌──────────────────┐          ┌──────────────────┐
│ Title            │          │ Title            │
│ Tap to expand ▼  │   →      │                  │
└──────────────────┘          │ Full description │
                              │ here with more   │
                              │ details...       │
                              │                  │
                              │ Tap to close ▲   │
                              └──────────────────┘
```

**Requirements:**
- Use `AnimatedContainer` for height change
- Use `AnimatedCrossFade` for content switch
- Smooth 300ms animation
- Arrow icon rotates with `AnimatedRotation`

**Starter Code:**
```dart
class ExpandingCard extends StatefulWidget {
  final String title;
  final String description;

  const ExpandingCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ExpandingCard> createState() => _ExpandingCardState();
}

class _ExpandingCardState extends State<ExpandingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // TODO: Create expanding card
    // Hint: AnimatedContainer for the card height
    // Hint: AnimatedRotation for the arrow (0.5 = 180 degrees)
    // Hint: AnimatedCrossFade to switch between short/full content

    return Card(
      child: Column(
        children: [
          // Title row with arrow
          // Content area
        ],
      ),
    );
  }
}
```

---

## Exercise 3: Animated Counter (Intermediate)

**Goal:** Create a counter where numbers animate in/out.

```
ANIMATION:
         ↑ (new number slides in from bottom)
       [ 5 ]
         ↓ (old number slides out to top)

  Each digit change should animate separately!
```

**Requirements:**
- Use `AnimatedSwitcher` with custom transition
- Numbers slide in from bottom, out to top
- Duration: 200ms
- Include + and - buttons

**Starter Code:**
```dart
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({super.key});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TODO: Wrap count display in AnimatedSwitcher
        // Hint: Use SlideTransition for the transition
        // Hint: Key the Text widget with ValueKey(_count)

        Text(
          '$_count',
          style: const TextStyle(fontSize: 48),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => setState(() => _count--),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => _count++),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Exercise 4: Staggered List Animation (Intermediate)

**Goal:** Create a list where items animate in one after another.

```
ANIMATION SEQUENCE:

  Time 0ms:   [ Item 1 slides in →→→ ]
  Time 100ms: [ Item 1 ][ Item 2 slides in →→→ ]
  Time 200ms: [ Item 1 ][ Item 2 ][ Item 3 slides in →→→ ]
  ...and so on
```

**Requirements:**
- Use explicit animation with `AnimationController`
- Each item has slide + fade animation
- Items start animating 100ms apart (staggered)
- Add a "Replay" button

**Starter Code:**
```dart
class StaggeredList extends StatefulWidget {
  const StaggeredList({super.key});

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final List<String> _items = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];

  @override
  void initState() {
    super.initState();
    // TODO: Create AnimationController with duration 1500ms
    // TODO: Start the animation
  }

  @override
  void dispose() {
    // TODO: Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          // TODO: Create staggered animation for each item
          // Hint: Use Interval with different start times
          // Hint: start = index * 0.1, end = start + 0.4

          return ListTile(
            title: Text(_items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Reset and replay animation
        },
        child: const Icon(Icons.replay),
      ),
    );
  }
}
```

---

## Exercise 5: Hero Image Gallery (Intermediate)

**Goal:** Create a photo grid with Hero transitions to detail view.

```
GALLERY SCREEN:              DETAIL SCREEN:
┌─────┬─────┬─────┐          ┌─────────────────┐
│ 📷1 │ 📷2 │ 📷3 │          │                 │
├─────┼─────┼─────┤   →      │      📷1        │
│ 📷4 │ 📷5 │ 📷6 │  Tap     │    (enlarged)   │
└─────┴─────┴─────┘          │                 │
                             │ Photo Title     │
                             │ Description...  │
                             └─────────────────┘

Image flies smoothly from grid to full screen!
```

**Requirements:**
- Use `Hero` widget with matching tags
- Wrap Image AND title text in separate Heroes
- Use `Material` widget wrapper for text Heroes
- Tap anywhere on detail screen to go back

**Starter Code:**
```dart
// Photo Model
class Photo {
  final String id;
  final String url;
  final String title;

  const Photo({required this.id, required this.url, required this.title});
}

// Sample photos (use picsum.photos for demo images)
const photos = [
  Photo(id: '1', url: 'https://picsum.photos/id/10/200', title: 'Nature'),
  Photo(id: '2', url: 'https://picsum.photos/id/20/200', title: 'Beach'),
  Photo(id: '3', url: 'https://picsum.photos/id/30/200', title: 'Mountains'),
];

// TODO: Create GalleryScreen with GridView
// TODO: Create PhotoDetailScreen with full image
// TODO: Add Hero widgets to both screens with matching tags
```

---

## Exercise 6: Loading Button (Intermediate)

**Goal:** Create a button that shows loading state.

```
STATES:

  IDLE:        ┌──────────────────┐
               │     Submit       │
               └──────────────────┘

  LOADING:            ┌────┐
                      │ ◐  │  (spinning)
                      └────┘

  SUCCESS:            ┌────┐
                      │ ✓  │  (checkmark appears)
                      └────┘
```

**Requirements:**
- Button width animates (wide → small circle → wide)
- BorderRadius animates (rounded rect → circle → rounded rect)
- Show spinner during loading
- Show checkmark on success (then reset)
- Use haptic feedback at each state change

**Starter Code:**
```dart
class LoadingButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _handlePress() async {
    // TODO: Set loading state
    // TODO: Add haptic feedback
    // TODO: Call onPressed
    // TODO: Show success state
    // TODO: Reset after delay
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Use AnimatedContainer for width/borderRadius
    // TODO: Show different content based on state
    // TODO: Disable button when loading

    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePress,
      child: Text(widget.text),
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
```

---

## Exercise 7: Animated Navigation Bar (Advanced)

**Goal:** Create a custom bottom nav with animated indicator.

```
NAVIGATION BAR:

  ┌─────────────────────────────────────────┐
  │   🏠      🔍      ❤️      👤           │
  │   ━━                                    │  ← Indicator slides
  └─────────────────────────────────────────┘

  When tapping Search:

  ┌─────────────────────────────────────────┐
  │   🏠      🔍      ❤️      👤           │
  │          ━━                             │  ← Indicator animated here
  └─────────────────────────────────────────┘
```

**Requirements:**
- Sliding indicator under selected item
- Selected icon scales up slightly
- Use `AnimatedPositioned` for indicator
- Use `AnimatedScale` for icons
- Smooth 200ms animations

**Starter Code:**
```dart
class AnimatedNavBar extends StatefulWidget {
  final Function(int) onItemSelected;

  const AnimatedNavBar({super.key, required this.onItemSelected});

  @override
  State<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.favorite,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Create nav bar with Stack
    // TODO: Add Row of icon buttons
    // TODO: Add AnimatedPositioned indicator
    // TODO: Use AnimatedScale for selected icon

    return Container(
      height: 60,
      color: Colors.white,
      child: Stack(
        children: [
          // Icon buttons row
          // Sliding indicator
        ],
      ),
    );
  }
}
```

---

## Exercise 8: Animated Onboarding (Advanced)

**Goal:** Create a multi-page onboarding with animations.

```
PAGE 1:                      PAGE 2:
┌──────────────────┐         ┌──────────────────┐
│                  │         │                  │
│    🎨            │  Swipe  │        📱        │
│  (bounces in)    │   →     │   (slides in)    │
│                  │         │                  │
│  Welcome!        │         │  Easy to use     │
│  Description...  │         │  Description...  │
│                  │         │                  │
│  ● ○ ○           │         │  ○ ● ○           │
│                  │         │                  │
│     [Next]       │         │     [Next]       │
└──────────────────┘         └──────────────────┘
```

**Requirements:**
- Use `PageView` for swiping
- Each page has staggered animations (icon → title → description)
- Page indicator dots animate
- "Next" button on last page changes to "Get Started"
- Icon on each page has unique entrance animation

**Starter Code:**
```dart
class AnimatedOnboarding extends StatefulWidget {
  const AnimatedOnboarding({super.key});

  @override
  State<AnimatedOnboarding> createState() => _AnimatedOnboardingState();
}

class _AnimatedOnboardingState extends State<AnimatedOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.palette,
      title: 'Welcome',
      description: 'Beautiful design at your fingertips',
    ),
    OnboardingPage(
      icon: Icons.phone_android,
      title: 'Easy to Use',
      description: 'Simple and intuitive interface',
    ),
    OnboardingPage(
      icon: Icons.rocket_launch,
      title: 'Get Started',
      description: 'Begin your journey today',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Create PageView with animated pages
    // TODO: Add page indicator dots
    // TODO: Add Next/Get Started button

    return Scaffold(
      body: Column(
        children: [
          // PageView
          // Page indicators
          // Button
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}

// TODO: Create AnimatedOnboardingPage widget with staggered animations
```

---

## Bonus Challenges

### Challenge A: Parallax Scroll Effect
Create a ListView where background images move slower than foreground content.

### Challenge B: Ripple Effect Button
Create a custom button with an expanding ripple animation on tap.

### Challenge C: Animated Theme Switch
Create a theme toggle that animates the entire app's colors smoothly.

### Challenge D: Card Flip Animation
Create a card that flips to reveal content on the back.

---

## Animation Checklist

Use this checklist when implementing animations:

```
□ Is the animation duration appropriate?
  - Micro-interactions: 100-200ms
  - Transitions: 200-300ms
  - Complex animations: 300-500ms

□ Does the animation have proper easing?
  - Use Curves.easeInOut for most animations
  - Use Curves.elasticOut for bouncy effects

□ Is the animation performant?
  - Avoid animating during layout
  - Use RepaintBoundary for complex animations

□ Does the animation provide feedback?
  - Visual confirmation of user actions
  - Loading indicators for async operations

□ Is haptic feedback included where appropriate?
  - Button presses
  - Toggle switches
  - Important actions

□ Are animation controllers disposed?
  - Always dispose in dispose() method
```

---

## Quick Reference

```
IMPLICIT ANIMATIONS:
├── AnimatedContainer    → Size, color, padding
├── AnimatedOpacity      → Fade in/out
├── AnimatedScale        → Grow/shrink
├── AnimatedRotation     → Spin
├── AnimatedAlign        → Move position
├── AnimatedCrossFade    → Switch between widgets
└── AnimatedSwitcher     → Replace with animation

EXPLICIT ANIMATIONS:
├── AnimationController  → The engine
├── Tween               → Start to end values
├── CurvedAnimation     → Add easing curves
├── Interval            → Stagger timing
└── AnimatedBuilder     → Rebuild on animation

TRANSITIONS:
├── Hero                → Shared element
├── SlideTransition     → Slide in/out
├── FadeTransition      → Fade in/out
├── ScaleTransition     → Scale in/out
└── RotationTransition  → Rotate in/out
```

---

**Congratulations!** You've completed Level 14!

**Next Level:** Level 15 - App Deployment (Publishing Your App)
