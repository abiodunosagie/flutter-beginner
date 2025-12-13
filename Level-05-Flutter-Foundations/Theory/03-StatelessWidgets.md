# StatelessWidget: Simple, Unchanging Widgets

## What Is a StatelessWidget?

A **StatelessWidget** is a widget that **never changes** after it's built. Think of it like a photograph - once taken, it stays the same.

```dart
// This text will always say "Hello"
// It cannot change by itself
class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello');
  }
}
```

---

## When to Use StatelessWidget

Use StatelessWidget when your UI:

| Situation | Use StatelessWidget? |
|-----------|---------------------|
| Displays static text | ✅ Yes |
| Shows an icon | ✅ Yes |
| Layout containers | ✅ Yes |
| Content from constructor only | ✅ Yes |
| Needs to update on user tap | ❌ No (use StatefulWidget) |
| Has a counter that changes | ❌ No (use StatefulWidget) |
| Animates | ❌ No (use StatefulWidget) |

---

## Basic Structure

Every StatelessWidget has the same pattern:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  // 1. Constructor (optional parameters go here)
  const MyWidget({super.key});

  // 2. Build method (returns what to display)
  @override
  Widget build(BuildContext context) {
    return Text('I am a StatelessWidget');
  }
}
```

### Breaking It Down

```dart
class MyWidget extends StatelessWidget {
//    ^^^^^^^^            ^^^^^^^^^^^^^^
//    Your name           What it extends
```

```dart
const MyWidget({super.key});
//              ^^^^^^^^^
//              Passes the key to parent class
```

```dart
@override
Widget build(BuildContext context) {
// ^^^^^^                  ^^^^^^^
// Must return a Widget    Location info
```

---

## Adding Properties

StatelessWidgets can receive data through their constructor:

```dart
class Greeting extends StatelessWidget {
  // Property to store the name
  final String name;

  // Constructor requires the name
  const Greeting({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// Usage:
Greeting(name: 'Alice')  // Shows: Hello, Alice!
Greeting(name: 'Bob')    // Shows: Hello, Bob!
```

### Multiple Properties

```dart
class ProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final String? bio;  // Optional (nullable)

  const ProfileCard({
    super.key,
    required this.name,
    required this.age,
    this.bio,  // No 'required' = optional
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        Text('Age: $age'),
        if (bio != null) Text(bio!),
      ],
    );
  }
}

// Usage:
ProfileCard(name: 'Alice', age: 25)
ProfileCard(name: 'Bob', age: 30, bio: 'Flutter developer')
```

---

## Why Use `const`?

The `const` keyword makes your widget more efficient:

```dart
// ✅ Good: const constructor
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  // ...
}

// Usage with const
const MyWidget()  // Reuses same instance
```

### When You CAN Use const

```dart
// All properties are final and compile-time constants
class StaticGreeting extends StatelessWidget {
  final String text;

  const StaticGreeting({
    super.key,
    this.text = 'Hello',  // Default value is constant
  });

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

// These work:
const StaticGreeting()
const StaticGreeting(text: 'Hi')
```

### When You CANNOT Use const

```dart
// If you need non-constant values
class DynamicGreeting extends StatelessWidget {
  final DateTime timestamp;  // Can't be const

  const DynamicGreeting({
    super.key,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Created at: $timestamp');
  }
}

// Must use without const:
DynamicGreeting(timestamp: DateTime.now())
```

---

## Real-World Examples

### Example 1: Welcome Banner

```dart
class WelcomeBanner extends StatelessWidget {
  final String username;

  const WelcomeBanner({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.waving_hand, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Text(
            'Welcome back, $username!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Info Card

```dart
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage:
InfoCard(
  icon: Icons.people,
  title: 'Followers',
  value: '1,234',
  color: Colors.purple,
)
```

### Example 3: Custom Button

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;  // Function type
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
    );
  }
}

// Usage:
CustomButton(
  label: 'Save',
  icon: Icons.save,
  onPressed: () {
    print('Saved!');
  },
)
```

---

## Composition: Building Complex UIs

StatelessWidgets can contain other widgets:

```dart
class UserProfile extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const UserProfile({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 16),
            // Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Action
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
```

---

## Using BuildContext

The `context` parameter gives you access to:

### Theme Colors

```dart
@override
Widget build(BuildContext context) {
  // Get theme colors
  final primaryColor = Theme.of(context).primaryColor;
  final textTheme = Theme.of(context).textTheme;

  return Text(
    'Styled Text',
    style: textTheme.headlineMedium?.copyWith(
      color: primaryColor,
    ),
  );
}
```

### Screen Size

```dart
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth * 0.8,  // 80% of screen width
    height: 100,
    color: Colors.blue,
  );
}
```

### Navigation

```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NextPage()),
      );
    },
    child: const Text('Go to Next Page'),
  );
}
```

---

## Common Patterns

### Pattern 1: Conditional Content

```dart
class StatusBadge extends StatelessWidget {
  final bool isOnline;

  const StatusBadge({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOnline ? 'Online' : 'Offline',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
```

### Pattern 2: List of Items

```dart
class TagList extends StatelessWidget {
  final List<String> tags;

  const TagList({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: tags.map((tag) => Chip(label: Text(tag))).toList(),
    );
  }
}

// Usage:
TagList(tags: ['Flutter', 'Dart', 'Mobile'])
```

### Pattern 3: Default Values

```dart
class Avatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String fallbackInitial;

  const Avatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.fallbackInitial = '?',
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      child: Text(fallbackInitial),
    );
  }
}
```

---

## Common Mistakes

### Mistake 1: Trying to Change Data

```dart
// ❌ WRONG: Trying to modify a property
class BadWidget extends StatelessWidget {
  String name = 'Alice';  // Not final!

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        name = 'Bob';  // This won't update the UI!
      },
      child: Text(name),
    );
  }
}

// ✅ RIGHT: Use StatefulWidget for changing data
// (We'll learn this in the next lesson)
```

### Mistake 2: Missing const Constructor

```dart
// ❌ Not optimal
class MyWidget extends StatelessWidget {
  MyWidget({super.key});  // Missing const
  // ...
}

// ✅ Better
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});  // Has const
  // ...
}
```

### Mistake 3: Not Using final for Properties

```dart
// ❌ WRONG
class BadWidget extends StatelessWidget {
  String name;  // Should be final!
  // ...
}

// ✅ RIGHT
class GoodWidget extends StatelessWidget {
  final String name;  // Immutable
  // ...
}
```

---

## Summary

| Concept | Description |
|---------|-------------|
| StatelessWidget | Widget that doesn't change |
| build() | Method that returns the UI |
| BuildContext | Widget's location in the tree |
| const constructor | Improves performance |
| final properties | Immutable data from constructor |

---

## Quick Quiz

**Q1:** When should you use StatelessWidget?

<details>
<summary>Answer</summary>

Use StatelessWidget when your widget's appearance depends only on its constructor parameters and never changes during its lifetime. Examples: static text, icons, layout containers, display-only cards.

</details>

**Q2:** Why should properties in StatelessWidget be `final`?

<details>
<summary>Answer</summary>

Properties should be `final` because StatelessWidgets are immutable - they can't change. If you need changing data, use StatefulWidget instead. Making properties `final` enforces this immutability.

</details>

**Q3:** What is `BuildContext` used for?

<details>
<summary>Answer</summary>

`BuildContext` tells the widget its position in the widget tree. It's used to:
- Access theme data (`Theme.of(context)`)
- Get screen size (`MediaQuery.of(context)`)
- Navigate (`Navigator.of(context)`)
- Show dialogs and snackbars

</details>

---

**Next:** Learn how to create interactive widgets with StatefulWidget.

---

**Continue to:** `04-StatefulWidgets.md`
