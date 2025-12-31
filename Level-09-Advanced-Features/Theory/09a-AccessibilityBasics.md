# Accessibility Basics: Making Apps Everyone Can Use

## The Simple Explanation

Imagine you have a friend who can't see well, or can't hear, or has trouble using their hands:

```
WITHOUT ACCESSIBILITY:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  Your Friend:  "What does this button do?"               │
│                                                          │
│  App:          [Silent... no help]                       │
│                                                          │
│  Your Friend:  "I can't use this app!"  😢               │
│                                                          │
└─────────────────────────────────────────────────────────┘

WITH ACCESSIBILITY:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  Your Friend:  "What does this button do?"               │
│                                                          │
│  App:          "Submit button. Tap to send your form."   │
│                                                          │
│  Your Friend:  "Perfect! I can use this!"  😊            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Accessibility (a11y) = Making your app usable by EVERYONE, including people with disabilities!**

(a11y means "a" + 11 letters + "y" = accessibility)

---

## Why Does Accessibility Matter?

```
┌─────────────────────────────────────────────────────────┐
│                WHO NEEDS ACCESSIBILITY?                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  👁️  Blind or low vision users                          │
│      • 285 million people worldwide                      │
│      • Use screen readers (TalkBack, VoiceOver)          │
│                                                          │
│  👂  Deaf or hard of hearing users                       │
│      • 466 million people worldwide                      │
│      • Need captions and visual feedback                 │
│                                                          │
│  ✋  Motor disabilities                                  │
│      • Difficulty tapping small buttons                  │
│      • Need larger touch targets                         │
│                                                          │
│  🧠  Cognitive disabilities                              │
│      • Need clear, simple language                       │
│      • Benefit from consistent patterns                  │
│                                                          │
│  👴  Aging population                                    │
│      • Everyone gets older!                              │
│      • May have multiple disabilities                    │
│                                                          │
│  📱  EVERYONE benefits!                                  │
│      • Easier to use in bright sunlight                  │
│      • Easier with one hand                              │
│      • Faster navigation                                 │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What is a Screen Reader?

A screen reader is software that reads your app out loud:

```
┌─────────────────────────────────────────────────────────┐
│                    HOW SCREEN READERS WORK               │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. User navigates by swiping:                           │
│                                                          │
│     [Button 1] ← User here                               │
│     [Button 2]                                           │
│     [Text Field]                                         │
│                                                          │
│  2. Screen reader speaks:                                │
│                                                          │
│     🔊 "Button 1. Submit. Button. Double tap to          │
│         activate."                                       │
│                                                          │
│  3. User double-taps to activate                         │
│                                                          │
│  4. Action happens!                                      │
│                                                          │
├─────────────────────────────────────────────────────────┤
│  POPULAR SCREEN READERS:                                 │
│  • Android: TalkBack                                     │
│  • iOS: VoiceOver                                        │
│  • Web: JAWS, NVDA                                       │
└─────────────────────────────────────────────────────────┘
```

---

## The Semantics Widget

The `Semantics` widget tells screen readers what things are and what they do:

### Basic Example

```dart
// ❌ BAD: Screen reader doesn't know what this is
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
)

// ✅ GOOD: Screen reader announces "Blue square. Image."
Semantics(
  label: 'Blue square',
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)
```

### Semantics Properties

```dart
Semantics(
  // LABEL: What is this?
  label: 'Profile picture',

  // HINT: How do I use it?
  hint: 'Double tap to change your picture',

  // VALUE: What's the current state?
  value: 'John Smith',

  // Is this a button?
  button: true,

  // Is this an image?
  image: true,

  // Is this a text field?
  textField: true,

  // Is this a header?
  header: true,

  child: YourWidget(),
)
```

---

## Making Buttons Accessible

### Default Button (Already Good!)

Most Flutter widgets already have built-in accessibility:

```dart
ElevatedButton(
  onPressed: () {
    print('Button pressed');
  },
  child: const Text('Submit'),
)

// Screen reader automatically announces:
// 🔊 "Submit. Button. Double tap to activate."
```

### Custom Button (Needs Semantics)

```dart
// ❌ BAD: Custom button without semantics
GestureDetector(
  onTap: () {
    print('Tapped');
  },
  child: Container(
    padding: const EdgeInsets.all(16),
    color: Colors.blue,
    child: const Text('Submit'),
  ),
)

// Screen reader says:
// 🔊 "Submit." (Doesn't say it's a button or how to activate it!)

// ✅ GOOD: Add Semantics
Semantics(
  button: true,
  label: 'Submit',
  hint: 'Double tap to submit the form',
  onTap: () {
    print('Tapped');
  },
  child: GestureDetector(
    onTap: () {
      print('Tapped');
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue,
      child: const Text('Submit'),
    ),
  ),
)

// Screen reader says:
// 🔊 "Submit. Button. Double tap to submit the form."
```

---

## Making Images Accessible

### Decorative Images

```dart
// For images that are just decoration (not important)
Semantics(
  excludeSemantics: true,  // Skip this in screen reader
  child: Image.asset('decorative_pattern.png'),
)

// Screen reader: [Skips this entirely]
```

### Informative Images

```dart
// For images that convey information
Semantics(
  label: 'Profile picture of John Smith wearing a blue shirt',
  image: true,
  child: Image.network('profile.jpg'),
)

// Screen reader says:
// 🔊 "Profile picture of John Smith wearing a blue shirt. Image."
```

---

## Making Text Fields Accessible

```dart
TextField(
  decoration: const InputDecoration(
    labelText: 'Email',           // Screen reader reads this
    hintText: 'Enter your email', // And this
  ),
)

// Screen reader automatically announces:
// When focused: 🔊 "Email. Enter your email. Text field."
// When typing: 🔊 [Reads each character]
```

### Custom Text Field

```dart
Semantics(
  label: 'Email address',
  hint: 'Enter your email to sign in',
  textField: true,
  child: Container(
    // Your custom text field
  ),
)
```

---

## Grouping Related Content

Use `Semantics` to group related items:

```dart
// ❌ BAD: Screen reader reads each item separately
Row(
  children: [
    Icon(Icons.star),
    Text('4.5'),
    Text('stars'),
  ],
)

// Screen reader says:
// 🔊 "Star icon"
// 🔊 "4.5"
// 🔊 "stars"
// (Confusing! User has to piece it together)

// ✅ GOOD: Group them together
Semantics(
  label: '4.5 stars',
  child: Row(
    children: [
      ExcludeSemantics(child: Icon(Icons.star)),
      ExcludeSemantics(child: Text('4.5')),
      ExcludeSemantics(child: Text('stars')),
    ],
  ),
)

// Screen reader says:
// 🔊 "4.5 stars"
// (Much clearer!)
```

---

## Complete Example: Accessible Login Form

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessible Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _isLoading = true;
    });

    // Simulate login
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Semantics(
              header: true,
              child: const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Sign in to continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Email field - Already accessible!
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Password field - Already accessible!
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Login button with loading state
            Semantics(
              // Update label based on loading state
              label: _isLoading ? 'Logging in...' : 'Login',
              hint: _isLoading
                  ? 'Please wait'
                  : 'Double tap to sign in',
              button: true,
              enabled: !_isLoading,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Login'),
              ),
            ),

            const SizedBox(height: 16),

            // Forgot password link
            Semantics(
              link: true,
              hint: 'Double tap to reset your password',
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset link sent!'),
                    ),
                  );
                },
                child: const Text('Forgot Password?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### How Screen Reader Reads This Form

```
User navigates through form:

1. 🔊 "Welcome Back. Heading."
2. 🔊 "Sign in to continue."
3. 🔊 "Email. Enter your email address. Text field."
4. 🔊 "Password. Enter your password. Secure text field."
5. 🔊 "Login. Button. Double tap to sign in."
6. 🔊 "Forgot Password? Link. Double tap to reset your password."
```

---

## Common Accessibility Mistakes

### Mistake 1: No Labels

```dart
// ❌ BAD
IconButton(
  icon: const Icon(Icons.add),
  onPressed: () {},
)

// Screen reader: 🔊 "Button" (What button?)

// ✅ GOOD
IconButton(
  icon: const Icon(Icons.add),
  tooltip: 'Add new item',  // This becomes the label!
  onPressed: () {},
)

// Screen reader: 🔊 "Add new item. Button."
```

### Mistake 2: Low Contrast Text

```dart
// ❌ BAD: Light gray on white (hard to read)
Text(
  'Important message',
  style: TextStyle(color: Colors.grey[300]),
)

// ✅ GOOD: Dark gray on white (easy to read)
Text(
  'Important message',
  style: TextStyle(color: Colors.grey[800]),
)
```

### Mistake 3: Tiny Touch Targets

```dart
// ❌ BAD: Too small to tap easily
GestureDetector(
  onTap: () {},
  child: const SizedBox(
    width: 20,
    height: 20,
    child: Icon(Icons.close, size: 16),
  ),
)

// ✅ GOOD: Minimum 48x48 pixels
GestureDetector(
  onTap: () {},
  child: const SizedBox(
    width: 48,   // Minimum recommended size
    height: 48,
    child: Icon(Icons.close, size: 24),
  ),
)
```

### Mistake 4: No Focus Indicators

```dart
// ❌ BAD: Can't see which item is focused
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    overlayColor: Colors.transparent,  // Hides focus
  ),
  child: const Text('Button'),
)

// ✅ GOOD: Clear focus indicator (default behavior)
TextButton(
  onPressed: () {},
  // Don't override overlayColor - keep default focus indicator
  child: const Text('Button'),
)
```

---

## ExcludeSemantics Widget

Hide things from screen reader that aren't useful:

```dart
// Example: Star rating display
Row(
  children: [
    // Hide individual stars
    ExcludeSemantics(
      child: Row(
        children: const [
          Icon(Icons.star, color: Colors.yellow),
          Icon(Icons.star, color: Colors.yellow),
          Icon(Icons.star, color: Colors.yellow),
          Icon(Icons.star, color: Colors.yellow),
          Icon(Icons.star_half, color: Colors.yellow),
        ],
      ),
    ),
    const SizedBox(width: 8),
    // Announce the rating instead
    Semantics(
      label: '4.5 out of 5 stars',
      child: const Text('4.5'),
    ),
  ],
)

// Screen reader: 🔊 "4.5 out of 5 stars"
// (Instead of reading each star icon separately)
```

---

## MergeSemantics Widget

Combine multiple widgets into one announcement:

```dart
// Combine icon + text into single announcement
MergeSemantics(
  child: Row(
    children: const [
      Icon(Icons.warning, color: Colors.red),
      SizedBox(width: 8),
      Text('Error: Invalid email'),
    ],
  ),
)

// Screen reader: 🔊 "Warning: Error: Invalid email"
// (Reads everything together as one unit)
```

---

## Testing Accessibility

### Manual Testing

1. **Enable TalkBack (Android):**
   - Settings → Accessibility → TalkBack → Turn on
   - Navigate by swiping left/right
   - Activate by double-tapping

2. **Enable VoiceOver (iOS):**
   - Settings → Accessibility → VoiceOver → Turn on
   - Navigate by swiping left/right
   - Activate by double-tapping

3. **What to test:**
   - Can you navigate to everything?
   - Are labels clear and descriptive?
   - Can you complete all tasks?
   - Do images have descriptions?

### Testing in Flutter

```dart
// Check if screen reader is enabled
final isScreenReaderEnabled = MediaQuery.of(context).accessibleNavigation;

if (isScreenReaderEnabled) {
  // Maybe show extra hints
  print('Screen reader is active');
}
```

---

## Quick Reference: Semantic Properties

```dart
Semantics(
  // WHO/WHAT
  label: 'Submit button',           // What is this?
  value: 'Form completed',          // Current state
  hint: 'Double tap to submit',     // How to use

  // TYPE
  button: true,                     // Is it a button?
  header: true,                     // Is it a heading?
  image: true,                      // Is it an image?
  link: true,                       // Is it a link?
  textField: true,                  // Is it a text input?

  // STATE
  enabled: true,                    // Can it be used?
  checked: true,                    // Is it checked?
  selected: true,                   // Is it selected?
  hidden: false,                    // Is it hidden?

  // ACTIONS
  onTap: () {},                     // Tap action
  onLongPress: () {},               // Long press action
  onScrollUp: () {},                // Scroll actions

  // BEHAVIOR
  excludeSemantics: true,           // Hide children

  child: YourWidget(),
)
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│           ACCESSIBILITY BASICS SUMMARY                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: Making apps usable by everyone                    │
│                                                          │
│  KEY WIDGETS:                                            │
│  • Semantics - Add accessibility info                    │
│  • ExcludeSemantics - Hide from screen reader            │
│  • MergeSemantics - Combine announcements                │
│                                                          │
│  IMPORTANT PROPERTIES:                                   │
│  • label - What is this?                                 │
│  • hint - How do I use it?                               │
│  • value - Current state                                 │
│                                                          │
│  BEST PRACTICES:                                         │
│  ✅ Use standard widgets (already accessible)            │
│  ✅ Add labels to custom widgets                         │
│  ✅ Group related content                                │
│  ✅ Minimum 48x48 touch targets                          │
│  ✅ Test with screen readers                             │
│                                                          │
│  COMMON MISTAKES:                                        │
│  ❌ No labels on icons                                   │
│  ❌ Low contrast text                                    │
│  ❌ Tiny touch targets                                   │
│  ❌ No focus indicators                                  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What's Next?

You've learned the basics! Next up:
- **Accessibility Testing** - Testing with real screen readers
- **WCAG Guidelines** - Official accessibility standards
- **Accessibility Patterns** - Common solutions to common problems

---

[⬅️ Previous: Responsive Design](./08-ResponsiveDesign.md) | [⬆️ Learning Path](./00-LearningPath.md) | [➡️ Next: Accessibility Testing](./09b-AccessibilityTesting.md)
