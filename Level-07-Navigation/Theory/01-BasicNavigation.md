# Basic Navigation in Flutter

Learn how to move between screens using Navigator.push and Navigator.pop!

---

## What is Navigation?

### Think of it Like This

Imagine you're reading a book:
- **Opening a new chapter** = Pushing a new screen
- **Closing the book to go back** = Popping the current screen
- **The bookmark remembers where you were** = The navigation stack

```
YOUR PHONE IS LIKE A STACK OF PAPERS:

When you open your app:
    ┌─────────────────┐
    │    HOME PAGE    │  ← You see this paper on top
    └─────────────────┘

When you tap on "View Details":
    ┌─────────────────┐
    │  DETAILS PAGE   │  ← New paper placed on top
    ├─────────────────┤
    │    HOME PAGE    │  ← Previous paper is hidden
    └─────────────────┘

When you press the back button:
    ┌─────────────────┐
    │    HOME PAGE    │  ← Top paper removed, you see home again
    └─────────────────┘
```

---

## The Navigator Widget

Flutter uses a `Navigator` widget to manage your screens (called "routes").

```
Navigator = The person organizing your papers
Route = Each paper (screen)
Stack = The pile of papers
```

### Key Methods

| Method | What It Does | Real-Life Example |
|--------|--------------|-------------------|
| `push()` | Add new screen on top | Opening a new browser tab |
| `pop()` | Remove current screen | Pressing the back button |
| `pushReplacement()` | Replace current screen | Logging out and going to login |
| `pushAndRemoveUntil()` | Go somewhere and clear history | Going home after checkout |

---

## Basic Push Navigation

### The Simplest Way to Navigate

```dart
// From HomeScreen, go to DetailsScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsScreen(),
  ),
);
```

### Breaking It Down

```dart
Navigator.push(        // "Hey Navigator, add a new screen!"
  context,             // "Here's where I am right now"
  MaterialPageRoute(   // "This is what kind of transition I want"
    builder: (context) => DetailsScreen(),  // "This is the new screen"
  ),
);
```

### Visual Flow

```
BEFORE push():              AFTER push():
┌──────────────┐           ┌──────────────┐
│              │           │              │
│   HOME       │           │   DETAILS    │  ← Now visible
│   SCREEN     │           │   SCREEN     │
│              │           │              │
│  [Go to      │           │              │
│   Details]   │           │    [Back]    │
│              │           │              │
└──────────────┘           ├──────────────┤
                           │   HOME       │  ← Hidden behind
                           │   SCREEN     │
                           └──────────────┘
```

---

## Basic Pop Navigation

### Going Back to the Previous Screen

```dart
// Go back to the previous screen
Navigator.pop(context);
```

That's it! Just one line.

### When to Use Pop

```dart
// In your DetailsScreen
class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        // The back arrow is automatic!
        // But you can also add a custom back button:
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Go back!
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);  // Another way to go back
          },
          child: Text('Go Back'),
        ),
      ),
    );
  }
}
```

---

## Complete Example: Two Screen App

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      home: HomeScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 1: HOME
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🏠',
              style: TextStyle(fontSize: 80),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome Home!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // ─────────────────────────────────
                // PUSH: Go to Details screen
                // ─────────────────────────────────
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(),
                  ),
                );
              },
              child: Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 2: DETAILS
// ═══════════════════════════════════════════════════════════════

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.green,
        // Note: Back button appears automatically!
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '📋',
              style: TextStyle(fontSize: 80),
            ),
            SizedBox(height: 20),
            Text(
              'Here are the details!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // ─────────────────────────────────
                // POP: Go back to Home screen
                // ─────────────────────────────────
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Other Navigation Methods

### 1. Push Replacement

Replace the current screen instead of adding on top.

```
REGULAR PUSH:              PUSH REPLACEMENT:

Before:                    Before:
┌─────────┐               ┌─────────┐
│ Screen A│               │ Screen A│
└─────────┘               └─────────┘

After pushReplacement to Screen B:

Regular push:              pushReplacement:
┌─────────┐               ┌─────────┐
│ Screen B│               │ Screen B│  ← Replaced A!
├─────────┤               └─────────┘
│ Screen A│
└─────────┘               (Screen A is gone!)
```

```dart
// Use when: Login -> Home (don't want user to go back to login)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
);
```

### 2. Push and Remove Until

Go to a screen and remove all screens behind it.

```dart
// Use when: Checkout complete -> Home (clear cart, details, etc.)
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false,  // Remove ALL routes
);
```

```
Before:                    After pushAndRemoveUntil(Home):
┌─────────┐
│ Checkout│
├─────────┤
│  Cart   │               ┌─────────┐
├─────────┤               │  Home   │  ← Only Home remains
│ Details │               └─────────┘
├─────────┤
│  Home   │               (Everything else removed!)
└─────────┘
```

### 3. Pop Until

Pop screens until a condition is met.

```dart
// Pop until you reach the home screen
Navigator.popUntil(context, (route) => route.isFirst);
```

---

## Checking If You Can Pop

Sometimes you need to check before popping:

```dart
// Check if there's a screen to go back to
if (Navigator.canPop(context)) {
  Navigator.pop(context);
} else {
  // We're at the root screen!
  print("Can't go back any further!");
}
```

### Why This Matters

```dart
// ❌ DANGEROUS: Might crash if already at root
Navigator.pop(context);

// ✅ SAFE: Only pops if possible
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}

// ✅ ALSO SAFE: maybePop won't crash
Navigator.maybePop(context);  // Does nothing if can't pop
```

---

## Page Transitions

### Default Transitions

```dart
// Material Design transition (Android style)
MaterialPageRoute(builder: (context) => NewScreen())

// Cupertino transition (iOS style)
CupertinoPageRoute(builder: (context) => NewScreen())
```

### Custom Transition

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 500),
  ),
);
```

### Common Transitions

```
┌─────────────────────────────────────────────────────────────┐
│                    TRANSITION TYPES                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SLIDE (default for Material):                              │
│  ┌─────┐          ┌─────┬─────┐          ┌─────┐           │
│  │  A  │    →     │  A  │  B  │    →     │  B  │           │
│  └─────┘          └─────┴─────┘          └─────┘           │
│  Screen A         B slides in           Screen B            │
│                                                             │
│  FADE:                                                      │
│  ┌─────┐          ┌─────┐               ┌─────┐            │
│  │  A  │    →     │ A/B │    →          │  B  │            │
│  └─────┘          └─────┘               └─────┘            │
│  Screen A         Fading...             Screen B            │
│                                                             │
│  SCALE:                                                     │
│  ┌─────┐          ┌──┬──┐               ┌─────┐            │
│  │  A  │    →     │  │B │    →          │  B  │            │
│  └─────┘          └──┴──┘               └─────┘            │
│  Screen A         B grows               Screen B            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Common Patterns

### Pattern 1: Navigate After Async Operation

```dart
ElevatedButton(
  onPressed: () async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Do some work
    await saveData();

    // Close loading dialog
    Navigator.pop(context);

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen()),
    );
  },
  child: Text('Save'),
)
```

### Pattern 2: Confirm Before Going Back

```dart
// Override the back button behavior
return WillPopScope(
  onWillPop: () async {
    // Show confirmation dialog
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('You have unsaved changes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Leave'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  },
  child: Scaffold(
    // Your screen content
  ),
);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    NAVIGATION CHEAT SHEET                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Navigator.push()         │  Add new screen on top          │
│  Navigator.pop()          │  Go back to previous screen     │
│  Navigator.pushReplacement│  Replace current screen         │
│  Navigator.pushAndRemove- │  Go somewhere and clear         │
│    Until()                │  all history                    │
│  Navigator.popUntil()     │  Pop until condition met        │
│  Navigator.canPop()       │  Check if we can go back        │
│  Navigator.maybePop()     │  Pop if possible, else nothing  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Practice Time!

Try building:
1. A 3-screen app (Home → List → Details)
2. Add a "Go to Home" button from Details that clears the stack
3. Add custom slide/fade transitions

---


---

## Navigation

⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Named Routes](02-NamedRoutes.md)
