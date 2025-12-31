# Accessibility Testing: Making Sure It Actually Works

## The Simple Explanation

Imagine you made a toy for your friend, but you never tried it to see if it works:

```
WITHOUT TESTING:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  You:          "I made this toy! It should work!"        │
│                                                          │
│  Your Friend:  "But... I can't figure out how to         │
│                 use it..."  😢                           │
│                                                          │
│  Result:       Toy sits unused in the corner             │
│                                                          │
└─────────────────────────────────────────────────────────┘

WITH TESTING:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  You:          "Let me try using it first..."            │
│                [Tests the toy]                           │
│                "Oh! This part is confusing!"             │
│                [Fixes it]                                │
│                                                          │
│  Your Friend:  "This is perfect! Thank you!"  😊         │
│                                                          │
│  Result:       Everyone can play with the toy!           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Accessibility Testing = Actually trying your app the way people with disabilities use it!**

---

## Why Test Accessibility?

```
┌─────────────────────────────────────────────────────────┐
│         WHAT HAPPENS WITHOUT TESTING?                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  😱 Buttons have no labels                               │
│  😱 Images are invisible to screen readers               │
│  😱 Users get stuck and can't navigate                   │
│  😱 Forms are impossible to complete                     │
│  😱 Your app excludes millions of users                  │
│  😱 You might violate accessibility laws                 │
│                                                          │
│  BUT WITH TESTING:                                       │
│                                                          │
│  ✅ Everyone can use your app                            │
│  ✅ You find and fix problems early                      │
│  ✅ Your app is more user-friendly for ALL users         │
│  ✅ You comply with accessibility standards              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Testing with TalkBack (Android)

TalkBack is Android's built-in screen reader.

### Enabling TalkBack

```
STEP 1: Open Settings
┌─────────────────────┐
│  ⚙️  Settings        │
│  └─ Accessibility   │
│     └─ TalkBack     │
└─────────────────────┘

STEP 2: Turn on TalkBack
┌─────────────────────┐
│  TalkBack           │
│  [OFF] → [ON]       │
└─────────────────────┘

STEP 3: Complete tutorial
(TalkBack shows you how to use it)
```

### Using TalkBack

```
┌─────────────────────────────────────────────────────────┐
│              TALKBACK GESTURES                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Navigate Forward:                                       │
│  ────────────────────────────────────                    │
│  Swipe RIGHT →                                           │
│  Moves to next item                                      │
│                                                          │
│  Navigate Backward:                                      │
│  ────────────────────────────────────                    │
│  Swipe LEFT ←                                            │
│  Moves to previous item                                  │
│                                                          │
│  Activate (Click):                                       │
│  ────────────────────────────────────                    │
│  DOUBLE TAP anywhere                                     │
│  Activates the focused item                              │
│                                                          │
│  Scroll:                                                 │
│  ────────────────────────────────────                    │
│  Swipe UP/DOWN with TWO FINGERS                          │
│  Scrolls the current screen                              │
│                                                          │
│  Reading Controls:                                       │
│  ────────────────────────────────────                    │
│  Swipe UP then DOWN (quick)                              │
│  Opens reading controls menu                             │
│                                                          │
│  Stop TalkBack:                                          │
│  ────────────────────────────────────                    │
│  Hold both volume keys for 3 seconds                     │
│  Turns TalkBack off                                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### What TalkBack Reads

```dart
// Example button
ElevatedButton(
  onPressed: () {},
  child: const Text('Submit'),
)

// TalkBack announces:
// 🔊 "Submit. Button. Double tap to activate."
//     ^^^^^^  ^^^^^^  ^^^^^^^^^^^^^^^^^^^^^
//     Label   Type    Instructions
```

### Testing Your App with TalkBack

```
1. Open your app with TalkBack enabled

2. Try to complete common tasks:
   ┌────────────────────────────────┐
   │  ✓ Can I navigate to login?    │
   │  ✓ Can I fill out the form?    │
   │  ✓ Can I submit the form?      │
   │  ✓ Can I see the results?      │
   └────────────────────────────────┘

3. Check each screen element:
   ┌────────────────────────────────┐
   │  ✓ Does it have a label?       │
   │  ✓ Is the label clear?         │
   │  ✓ Can I activate it?          │
   │  ✓ Do I know what it does?     │
   └────────────────────────────────┘

4. Look for problems:
   ❌ "Unlabeled button" (No label)
   ❌ "Button" (Label not descriptive)
   ❌ Can't reach important content
   ❌ Items in wrong order
```

---

## Testing with VoiceOver (iOS)

VoiceOver is iOS's built-in screen reader.

### Enabling VoiceOver

```
STEP 1: Open Settings
┌─────────────────────┐
│  ⚙️  Settings        │
│  └─ Accessibility   │
│     └─ VoiceOver    │
└─────────────────────┘

STEP 2: Turn on VoiceOver
┌─────────────────────┐
│  VoiceOver          │
│  [OFF] → [ON]       │
└─────────────────────┘

SHORTCUT: Triple-click side button
```

### Using VoiceOver

```
┌─────────────────────────────────────────────────────────┐
│              VOICEOVER GESTURES                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Navigate Forward:                                       │
│  ────────────────────────────────────                    │
│  Swipe RIGHT →                                           │
│  Moves to next item                                      │
│                                                          │
│  Navigate Backward:                                      │
│  ────────────────────────────────────                    │
│  Swipe LEFT ←                                            │
│  Moves to previous item                                  │
│                                                          │
│  Activate (Click):                                       │
│  ────────────────────────────────────                    │
│  DOUBLE TAP anywhere                                     │
│  Activates the focused item                              │
│                                                          │
│  Scroll:                                                 │
│  ────────────────────────────────────                    │
│  Swipe UP/DOWN with THREE FINGERS                        │
│  Scrolls the current screen                              │
│                                                          │
│  Rotor (Settings):                                       │
│  ────────────────────────────────────                    │
│  Rotate TWO FINGERS (like turning a dial)                │
│  Changes navigation mode                                 │
│                                                          │
│  Stop VoiceOver:                                         │
│  ────────────────────────────────────                    │
│  Triple-click side button                                │
│  Turns VoiceOver off                                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## WCAG 2.1 Guidelines

WCAG (Web Content Accessibility Guidelines) are the international standards for accessibility.

### The Four Principles: POUR

```
┌─────────────────────────────────────────────────────────┐
│                  WCAG PRINCIPLES (POUR)                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  P - PERCEIVABLE                                         │
│  ────────────────────────────────────────────            │
│  Users must be able to perceive the information          │
│                                                          │
│  ✅ Text alternatives for images                         │
│  ✅ Captions for videos                                  │
│  ✅ Content works without color alone                    │
│  ✅ Text can be resized                                  │
│                                                          │
│  O - OPERABLE                                            │
│  ────────────────────────────────────────────            │
│  Users must be able to operate the interface             │
│                                                          │
│  ✅ All features work with keyboard/screen reader        │
│  ✅ Users have enough time to read/use content           │
│  ✅ No flashing content (seizure risk)                   │
│  ✅ Easy navigation                                      │
│                                                          │
│  U - UNDERSTANDABLE                                      │
│  ────────────────────────────────────────────            │
│  Users must be able to understand the information        │
│                                                          │
│  ✅ Text is readable                                     │
│  ✅ Interface is predictable                             │
│  ✅ Input assistance (error messages, labels)            │
│  ✅ Consistent navigation                                │
│                                                          │
│  R - ROBUST                                              │
│  ────────────────────────────────────────────            │
│  Content works with current and future technologies      │
│                                                          │
│  ✅ Works with assistive technologies                    │
│  ✅ Valid, clean code                                    │
│  ✅ Proper semantic markup                               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### WCAG Conformance Levels

```
┌─────────────────────────────────────────────────────────┐
│                WCAG CONFORMANCE LEVELS                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Level A (Minimum)                                       │
│  ─────────────────────────────────────                   │
│  Basic accessibility features                            │
│  Essential for some users                                │
│                                                          │
│  Level AA (Recommended) ⭐                               │
│  ─────────────────────────────────────                   │
│  Addresses major barriers                                │
│  Required by most laws                                   │
│  THIS IS YOUR TARGET!                                    │
│                                                          │
│  Level AAA (Gold Standard)                               │
│  ─────────────────────────────────────                   │
│  Highest level of accessibility                          │
│  Not always achievable for all content                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## WCAG Guideline 1: Perceivable

### 1.1 Text Alternatives

```dart
// ❌ FAIL: Image with no description
Image.asset('product.jpg')

// ✅ PASS: Image with text alternative
Semantics(
  label: 'Blue running shoes, size 10',
  image: true,
  child: Image.asset('product.jpg'),
)
```

### 1.3 Adaptable

```dart
// ❌ FAIL: Information only shown through color
Container(
  color: Colors.red,  // Error shown only by color
  child: const Text('Invalid'),
)

// ✅ PASS: Information shown through text AND color
Container(
  color: Colors.red[50],
  child: Row(
    children: const [
      Icon(Icons.error, color: Colors.red),
      Text('Error: Invalid input'),
    ],
  ),
)
```

### 1.4 Distinguishable

#### Contrast Ratios

```
┌─────────────────────────────────────────────────────────┐
│                 COLOR CONTRAST RATIOS                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Normal Text (< 18pt):                                   │
│  • Level AA:  4.5:1 minimum                              │
│  • Level AAA: 7:1 minimum                                │
│                                                          │
│  Large Text (≥ 18pt or bold ≥ 14pt):                     │
│  • Level AA:  3:1 minimum                                │
│  • Level AAA: 4.5:1 minimum                              │
│                                                          │
│  Examples:                                               │
│  ✅ Black on white:     21:1 (Perfect!)                  │
│  ✅ Dark gray on white: 7:1  (AAA pass)                  │
│  ❌ Light gray on white: 2:1 (FAIL)                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

```dart
// ❌ FAIL: Low contrast (2.5:1)
Text(
  'Important message',
  style: TextStyle(color: Colors.grey[400]),  // Too light!
)

// ✅ PASS: Good contrast (7:1)
Text(
  'Important message',
  style: TextStyle(color: Colors.grey[800]),  // Dark enough
)
```

---

## WCAG Guideline 2: Operable

### 2.1 Keyboard Accessible

All functionality must work without a mouse (or without touching the screen):

```dart
// ✅ GOOD: All Flutter buttons work with keyboard/screen reader
ElevatedButton(
  onPressed: () {},
  child: const Text('Submit'),
)

// ✅ GOOD: Custom button with proper semantics
Semantics(
  button: true,
  onTap: () {},
  child: GestureDetector(
    onTap: () {},
    child: Container(
      child: const Text('Custom Button'),
    ),
  ),
)
```

### 2.4 Navigable

#### Focus Order

```dart
// Focus order should match visual order
Column(
  children: [
    TextField(decoration: InputDecoration(labelText: 'Name')),     // 1st
    TextField(decoration: InputDecoration(labelText: 'Email')),    // 2nd
    TextField(decoration: InputDecoration(labelText: 'Password')), // 3rd
    ElevatedButton(onPressed: () {}, child: Text('Submit')),       // 4th
  ],
)

// Screen reader navigates in the same order:
// 1. 🔊 "Name. Text field."
// 2. 🔊 "Email. Text field."
// 3. 🔊 "Password. Secure text field."
// 4. 🔊 "Submit. Button."
```

### 2.5 Touch Target Size

```
┌─────────────────────────────────────────────────────────┐
│              TOUCH TARGET SIZES                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Minimum Size: 48 x 48 pixels                            │
│  Recommended: 44 x 44 points (iOS)                       │
│              48 x 48 dp (Android)                        │
│                                                          │
│  Why?                                                    │
│  • Average finger is 40-50 pixels wide                   │
│  • Gives 4-8px error margin                              │
│  • Works for people with motor disabilities              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

```dart
// ❌ FAIL: Too small (24x24)
IconButton(
  iconSize: 16,
  padding: EdgeInsets.all(4),  // Total: 24x24
  icon: const Icon(Icons.close),
  onPressed: () {},
)

// ✅ PASS: Proper size (48x48)
IconButton(
  icon: const Icon(Icons.close),
  onPressed: () {},
  // Default size is 48x48 - perfect!
)

// ✅ PASS: Custom button with minimum size
GestureDetector(
  onTap: () {},
  child: Container(
    width: 48,   // Minimum size
    height: 48,
    alignment: Alignment.center,
    child: const Icon(Icons.close, size: 24),
  ),
)
```

---

## WCAG Guideline 3: Understandable

### 3.1 Readable

```dart
// ✅ GOOD: Clear, simple language
const Text('Your order has been placed')

// ❌ BAD: Unnecessarily complex
const Text('Your requisition has been successfully processed')
```

### 3.2 Predictable

```dart
// ✅ GOOD: Consistent navigation
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Navigation always in the same place
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
```

### 3.3 Input Assistance

```dart
// ✅ GOOD: Clear labels and error messages
TextField(
  decoration: InputDecoration(
    labelText: 'Email address',
    hintText: 'example@email.com',
    errorText: _emailError,  // "Please enter a valid email"
    helperText: 'We will never share your email',
  ),
  onChanged: (value) {
    setState(() {
      if (!value.contains('@')) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }
    });
  },
)
```

---

## Complete Accessibility Testing Checklist

```dart
import 'package:flutter/material.dart';

/// Example of a fully accessible form with testing checklist
class AccessibleFormExample extends StatefulWidget {
  const AccessibleFormExample({super.key});

  @override
  State<AccessibleFormExample> createState() => _AccessibleFormExampleState();
}

class _AccessibleFormExampleState extends State<AccessibleFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms to continue'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessible Form'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ✅ Header with semantic markup
            Semantics(
              header: true,
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Name field with label, hint, and validation
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'John Smith',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ✅ Email field with proper keyboard type and validation
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'john@example.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // ✅ Checkbox with clear label
            Semantics(
              label: 'Agree to terms and conditions',
              checked: _agreedToTerms,
              child: CheckboxListTile(
                title: const Text('I agree to the terms and conditions'),
                value: _agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Submit button with proper size and semantics
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),  // Good touch target
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Sign Up'),
            ),

            const SizedBox(height: 16),

            // ✅ Link with proper semantics
            Semantics(
              link: true,
              hint: 'Double tap to view terms',
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Terms and Conditions'),
                      content: const Text('Terms content here...'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('View Terms and Conditions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
TESTING CHECKLIST FOR THIS FORM:

📱 SCREEN READER TESTING:
  ✅ Can navigate to all fields
  ✅ Labels are announced
  ✅ Input types are correct
  ✅ Validation errors are announced
  ✅ Checkbox state is announced
  ✅ Button is clearly identified

🎨 VISUAL TESTING:
  ✅ Text has good contrast (4.5:1 minimum)
  ✅ Focus indicators are visible
  ✅ Touch targets are 48x48 minimum
  ✅ Works at 200% zoom

⌨️ KEYBOARD TESTING:
  ✅ Can navigate with Tab key
  ✅ Can activate with Enter/Space
  ✅ Focus order is logical

📏 SIZE TESTING:
  ✅ All buttons are at least 48x48 pixels
  ✅ Text is at least 12pt (16dp)
  ✅ Can resize text without breaking layout

🌈 COLOR TESTING:
  ✅ Errors shown with icon + text, not just color
  ✅ Required fields marked with text, not just red
  ✅ Works in grayscale mode
*/
```

---

## Automated Accessibility Testing

Flutter provides tools to check accessibility in tests:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Login button is accessible', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {},
            child: const Text('Login'),
          ),
        ),
      ),
    );

    // ✅ Check that screen reader can find the button
    expect(
      find.bySemanticsLabel('Login'),
      findsOneWidget,
    );

    // ✅ Check minimum touch target size
    final button = tester.getSize(find.byType(ElevatedButton));
    expect(button.width, greaterThanOrEqualTo(48.0));
    expect(button.height, greaterThanOrEqualTo(48.0));
  });

  testWidgets('Image has text alternative', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Semantics(
            label: 'Company logo',
            child: Image.asset('logo.png'),
          ),
        ),
      ),
    );

    // ✅ Check that image has a label
    expect(
      find.bySemanticsLabel('Company logo'),
      findsOneWidget,
    );
  });
}
```

---

## Accessibility Debugging

### Flutter Inspector

```
1. Run your app in debug mode
2. Open Flutter DevTools
3. Select "Widget Inspector"
4. Enable "Show Semantics"

You'll see:
┌─────────────────────────────────┐
│  Semantics Tree                  │
│  ├─ Button: "Submit"            │
│  ├─ Text Field: "Email"         │
│  └─ Image: "Profile picture"    │
└─────────────────────────────────┘

This shows exactly what screen readers see!
```

### Semantics Debugger

```dart
import 'package:flutter/rendering.dart';

void main() {
  // Enable semantics debugger
  debugDumpSemanticsTree();

  runApp(const MyApp());
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│        ACCESSIBILITY TESTING SUMMARY                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  SCREEN READERS:                                         │
│  • Android: TalkBack                                     │
│  • iOS: VoiceOver                                        │
│  • Navigate by swiping                                   │
│  • Activate by double-tapping                            │
│                                                          │
│  WCAG 2.1 PRINCIPLES (POUR):                             │
│  • Perceivable - Can users perceive it?                  │
│  • Operable - Can users operate it?                      │
│  • Understandable - Can users understand it?             │
│  • Robust - Does it work with assistive tech?            │
│                                                          │
│  KEY REQUIREMENTS:                                       │
│  ✅ 4.5:1 contrast ratio (normal text)                   │
│  ✅ 48x48 minimum touch targets                          │
│  ✅ Text alternatives for images                         │
│  ✅ Clear labels for interactive elements                │
│  ✅ Logical focus order                                  │
│  ✅ Error messages that are clear                        │
│                                                          │
│  TESTING CHECKLIST:                                      │
│  □ Test with screen reader enabled                       │
│  □ Check contrast ratios                                 │
│  □ Verify touch target sizes                             │
│  □ Test keyboard navigation                              │
│  □ Validate with automated tests                         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What's Next?

Now that you know how to test, let's look at common accessibility patterns and best practices!

---

[⬅️ Previous: Accessibility Basics](./09a-AccessibilityBasics.md) | [⬆️ Learning Path](./00-LearningPath.md) | [➡️ Next: Accessibility Patterns](./09c-AccessibilityPatterns.md)
