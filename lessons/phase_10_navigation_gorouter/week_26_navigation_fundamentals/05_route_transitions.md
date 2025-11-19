# Custom Route Transitions with GoRouter

## Imagine You're 5 Years Old...

You know how different doors open in different ways?

- **Sliding doors** at the supermarket - they slide open from the side! Whoosh!
- **Magic portals** in cartoons - they appear with sparkles and grow bigger!
- **Elevator doors** - they slide open from both sides at once!
- **Fairy tale books** - pages that flip and fade away to the next story!

That's EXACTLY what route transitions are! When you go from one screen to another in your app, you can make it happen in magical ways - sliding, fading, growing, spinning, or even combining them all!

Think of your app like a storybook. When you turn the page, do you want it to:
- Slide smoothly like a magic carpet?
- Fade away like disappearing ink?
- Pop up like a Jack-in-the-box?
- Spin around like a merry-go-round?

Let's learn how to make ALL of these magical page turns! ✨

## What You'll Learn
- Understanding built-in transitions (slide, fade, scale, rotation)
- Creating custom transitions with CustomTransitionPage
- Page-specific transitions in GoRouter
- Controlling transition duration and animation curves
- Hero animations that fly between screens
- Combining multiple transitions for wow effects
- Platform-specific transitions (iOS vs Android)
- Performance tips and best practices
- 10+ complete working examples!

## Built-in Transitions

Flutter gives us some ready-made transitions out of the box! Let's explore them:

### 1. Fade Transition (Disappearing Ink!)

Like when a ghost fades away in a cartoon:

```dart
GoRoute(
  path: '/profile',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Makes the new page fade in from invisible to visible
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
)
```

### 2. Slide Transition (Sliding Doors!)

Like those cool automatic doors at the mall:

```dart
GoRoute(
  path: '/settings',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: SettingsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from right to left
        const begin = Offset(1.0, 0.0); // Start off-screen to the right
        const end = Offset.zero;         // End at normal position
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  },
)
```

### 3. Scale Transition (Growing Like a Balloon!)

Like blowing up a balloon from tiny to big:

```dart
GoRoute(
  path: '/details',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: DetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Start small and grow to full size
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  },
)
```

### 4. Rotation Transition (Spinning Wheel!)

Like a merry-go-round spinning into view:

```dart
GoRoute(
  path: '/about',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: AboutScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Spin once while appearing (0 to 1 full rotation)
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
    );
  },
)
```

## Custom Transitions with CustomTransitionPage

Now let's create our own magical transitions!

### Example 1: Slide from Bottom (Like Opening a Drawer!)

```dart
GoRoute(
  path: '/comments',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: CommentsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide up from bottom
        const begin = Offset(0.0, 1.0); // Start below screen
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  },
)
```

### Example 2: Scale with Fade (Magical Appearance!)

Combine growing and fading for extra magic:

```dart
GoRoute(
  path: '/dialog',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: DialogScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Start small and invisible, grow big and visible
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut, // Bouncy effect!
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  },
)
```

### Example 3: Slide from Left (Swipe Back!)

Perfect for going back to previous screen:

```dart
GoRoute(
  path: '/previous',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: PreviousScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from left to right
        const begin = Offset(-1.0, 0.0); // Start off-screen left
        const end = Offset.zero;

        return SlideTransition(
          position: Tween(begin: begin, end: end).animate(animation),
          child: child,
        );
      },
    );
  },
)
```

### Example 4: Slide from Top (Like a Notification!)

```dart
GoRoute(
  path: '/notification',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: NotificationScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide down from top
        const begin = Offset(0.0, -1.0); // Start above screen
        const end = Offset.zero;

        return SlideTransition(
          position: Tween(begin: begin, end: end).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.bounceOut, // Add a little bounce!
            ),
          ),
          child: child,
        );
      },
    );
  },
)
```

### Example 5: Rotation with Scale (Spinning and Growing!)

```dart
GoRoute(
  path: '/special',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: SpecialScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 0.5).animate(animation),
            child: child,
          ),
        );
      },
    );
  },
)
```

## Transition Duration and Curves

### Controlling Speed (Fast, Slow, or Just Right!)

You can control HOW LONG the transition takes:

```dart
GoRoute(
  path: '/slow-fade',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: SlowScreen(),
      // Make transition last 2 seconds (slow)
      transitionDuration: const Duration(seconds: 2),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
)

GoRoute(
  path: '/quick-slide',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: QuickScreen(),
      // Make transition last 200 milliseconds (fast!)
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  },
)
```

### Animation Curves (The Motion Style!)

Curves make animations feel different - like going fast then slow, or bouncing!

```dart
// Linear - Same speed all the way (boring!)
curve: Curves.linear

// EaseInOut - Start slow, speed up, slow down (smooth!)
curve: Curves.easeInOut

// BounceOut - Bounces at the end (playful!)
curve: Curves.bounceOut

// ElasticOut - Springs back like a rubber band (elastic!)
curve: Curves.elasticOut

// FastOutSlowIn - Quick start, gentle landing (natural!)
curve: Curves.fastOutSlowIn
```

Example with different curves:

```dart
GoRoute(
  path: '/bouncy',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: BouncyScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.bounceOut, // Bouncy landing!
            ),
          ),
          child: child,
        );
      },
    );
  },
)
```

## Hero Animations with Routes

Hero animations are SUPER magical! A widget "flies" from one screen to another!

### Example 6: Flying Image Hero

```dart
// First Screen
class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.push('/photo/$index'),
            child: Hero(
              tag: 'photo-$index', // Unique tag for each photo
              child: Image.network('https://picsum.photos/200/200?random=$index'),
            ),
          );
        },
      ),
    );
  }
}

// Second Screen
class PhotoDetailScreen extends StatelessWidget {
  final String photoId;

  PhotoDetailScreen({required this.photoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Details')),
      body: Center(
        child: Hero(
          tag: 'photo-$photoId', // Same tag as first screen!
          child: Image.network('https://picsum.photos/400/400?random=$photoId'),
        ),
      ),
    );
  }
}

// In your router
GoRoute(
  path: '/photo/:id',
  builder: (context, state) {
    final photoId = state.pathParameters['id']!;
    return PhotoDetailScreen(photoId: photoId);
  },
)
```

### Example 7: Flying Text Hero

```dart
// List Screen
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Hero(
            tag: 'product-icon-$index',
            child: Icon(Icons.shopping_bag, size: 40),
          ),
          title: Hero(
            tag: 'product-title-$index',
            child: Text(
              'Product $index',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () => context.push('/product/$index'),
        );
      },
    );
  }
}

// Detail Screen
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Column(
        children: [
          Hero(
            tag: 'product-icon-$productId',
            child: Icon(Icons.shopping_bag, size: 200),
          ),
          SizedBox(height: 20),
          Hero(
            tag: 'product-title-$productId',
            child: Text(
              'Product $productId',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Combining Multiple Transitions

Let's create SUPER fancy transitions by combining effects!

### Example 8: Fade + Slide + Scale Combo

```dart
GoRoute(
  path: '/fancy',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: FancyScreen(),
      transitionDuration: Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.0).animate(animation),
              child: child,
            ),
          ),
        );
      },
    );
  },
)
```

### Example 9: Slide with Blur Effect

```dart
import 'dart:ui';

GoRoute(
  path: '/blurred',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: BlurredScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: (1 - animation.value) * 10,
              sigmaY: (1 - animation.value) * 10,
            ),
            child: child,
          ),
        );
      },
    );
  },
)
```

### Example 10: Rotation with Slide (Flip Card!)

```dart
GoRoute(
  path: '/flip',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: FlipScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: RotationTransition(
            turns: Tween(begin: 0.25, end: 0.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  },
)
```

## Platform-Specific Transitions

Make your app feel native on iOS and Android!

### Example 11: Adaptive Transition

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

GoRoute(
  path: '/adaptive',
  pageBuilder: (context, state) {
    // Use different transitions for iOS and Android
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS style: Slide from right
      return CustomTransitionPage(
        child: AdaptiveScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(
              begin: Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    } else {
      // Android style: Fade and scale
      return CustomTransitionPage(
        child: AdaptiveScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween(begin: 0.9, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
      );
    }
  },
)
```

## Reusable Transition Helper Class

Let's make a toolbox of transitions we can reuse!

### Example 12: Complete Transition Library

```dart
class AppTransitions {
  // Fade transition
  static CustomTransitionPage fade(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Slide from right
  static CustomTransitionPage slideRight(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  // Slide from left
  static CustomTransitionPage slideLeft(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  // Slide from bottom
  static CustomTransitionPage slideUp(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }

  // Scale transition
  static CustomTransitionPage scale(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }

  // Scale with fade
  static CustomTransitionPage scaleAndFade(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Rotation transition
  static CustomTransitionPage rotation(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }

  // Slide and fade combo
  static CustomTransitionPage slideAndFade(
    Widget child, {
    Duration? duration,
    Offset begin = const Offset(0, 0.3),
  }) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: begin, end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

// Using in your router
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) {
        return AppTransitions.slideRight(ProfileScreen());
      },
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return AppTransitions.slideUp(SettingsScreen());
      },
    ),
    GoRoute(
      path: '/dialog',
      pageBuilder: (context, state) {
        return AppTransitions.scaleAndFade(DialogScreen());
      },
    ),
  ],
);
```

## Best Practices and Performance Tips

### 1. Keep Transitions Short and Sweet
```dart
// Good: 300-400ms feels snappy
transitionDuration: Duration(milliseconds: 300)

// Too slow: User gets impatient
transitionDuration: Duration(seconds: 2) // ❌ Too long!
```

### 2. Use Appropriate Curves
```dart
// For most transitions
curve: Curves.easeInOut // Smooth and natural

// For playful apps
curve: Curves.bounceOut // Fun but use sparingly!

// For entering screens
curve: Curves.easeOut // Slow down as it arrives

// For leaving screens
curve: Curves.easeIn // Speed up as it leaves
```

### 3. Match Platform Conventions
```dart
// iOS: Slide from right (horizontal)
// Android: Fade with slight scale

// Be consistent with platform expectations!
```

### 4. Hero Animation Tips
```dart
// ✅ DO: Use unique tags
Hero(tag: 'user-${user.id}', child: UserAvatar())

// ❌ DON'T: Reuse tags
Hero(tag: 'avatar', child: UserAvatar()) // Multiple heroes will conflict!

// ✅ DO: Keep hero widgets simple
Hero(tag: 'image', child: Image.network(url))

// ❌ DON'T: Make hero widgets too complex
Hero(tag: 'complex', child: ComplexWidgetTree()) // May lag
```

### 5. Performance Optimization
```dart
// Use const constructors when possible
const CustomTransitionPage(...)

// Avoid heavy animations on old devices
transitionDuration: Duration(
  milliseconds: isLowEndDevice ? 150 : 300
)

// Keep widget trees simple during transitions
// Complex layouts + animations = lag!
```

### 6. Accessibility Considerations
```dart
// Users with motion sensitivity might want reduced animations
final bool reduceMotion = MediaQuery.of(context).disableAnimations;

if (reduceMotion) {
  // Use instant transitions or very quick fades
  transitionDuration: Duration(milliseconds: 1)
} else {
  // Normal animated transitions
  transitionDuration: Duration(milliseconds: 300)
}
```

### 7. Test on Real Devices
```dart
// Emulators are fast - real devices show the truth!
// Test your transitions on:
// - Old Android phones
// - Budget devices
// - Different screen sizes
// - Various animation settings
```

## Common Patterns

### Modal/Dialog Style (Slide Up with Fade)
```dart
GoRoute(
  path: '/modal',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: ModalScreen(),
    );
  },
)
```

### Card Expansion Style
```dart
GoRoute(
  path: '/expand',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      transitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: ExpandedScreen(),
    );
  },
)
```

## Your Turn to Practice!

Try creating these transitions:
1. A "bounce in" transition for a celebration screen
2. A slide from the top-right corner (diagonal!)
3. A zoom out transition (start big, shrink to normal)
4. A transition that combines rotation and fade
5. An adaptive transition that changes based on route direction

## Summary

You learned how to create magical page transitions:
- **Built-in transitions**: Fade, Slide, Scale, Rotation
- **Custom transitions**: Mix and match for unique effects
- **Hero animations**: Flying widgets between screens
- **Platform-specific**: Feel native on iOS and Android
- **Performance tips**: Keep it fast and smooth
- **10+ complete examples**: Ready to copy and customize!

Remember: Transitions should enhance the user experience, not slow it down. Keep them quick (300-400ms), smooth, and purposeful!

Now you can make your app navigation feel as magical as turning pages in a storybook! ✨
