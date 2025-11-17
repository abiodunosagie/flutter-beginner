# Custom Route Transitions with GoRouter

## What You'll Learn
- Custom page transitions
- Slide, fade, scale animations
- Transition builders
- Platform-specific transitions
- Best practices

## Basic Custom Transition

```dart
GoRoute(
  path: '/details',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: DetailsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
)
```

## Slide Transition

```dart
GoRoute(
  path: '/profile',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
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

## Complete Transitions Example

```dart
class TransitionType {
  static CustomTransitionPage fade(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static CustomTransitionPage slideRight(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage scale(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}

// Usage in routes
GoRoute(
  path: '/details',
  pageBuilder: (context, state) => TransitionType.slideRight(DetailsScreen()),
)
```

You now have complete GoRouter mastery! 🚀
