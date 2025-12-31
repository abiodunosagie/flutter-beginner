# Loading Indicators

Learn how to show loading indicators and provide visual feedback to users!

---

## Why Loading States Matter

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│              WHY LOADING STATES MATTER                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Imagine clicking a button and NOTHING happens...           │
│                                                             │
│  WITHOUT Loading State:                                     │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │  [Submit]               │  User clicks...                │
│  │                         │  Nothing visible happens       │
│  │                         │  User clicks again...          │
│  │                         │  And again... 😤               │
│  │                         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  WITH Loading State:                                        │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │  [⏳ Submitting...]     │  User sees progress!           │
│  │                         │  Knows it's working            │
│  │                         │  Waits patiently 😊            │
│  │                         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  Loading states = User trust + Better UX                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## The Three States of Async Data

```
┌─────────────────────────────────────────────────────────────┐
│                 THREE STATES OF DATA                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  State 1: LOADING                                           │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │    ⏳ Loading...        │  Show spinner/skeleton         │
│  │                         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  State 2: SUCCESS (Data loaded)                             │
│  ┌─────────────────────────┐                                │
│  │  ✓ John                 │                                │
│  │  ✓ Jane                 │  Show the actual data          │
│  │  ✓ Bob                  │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  State 3: ERROR                                             │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │  ❌ Failed to load      │  Show error + retry option     │
│  │     [Try Again]         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  Your app should handle ALL THREE states!                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Loading Indicators

### Different Types of Loading Indicators

```dart
// 1. Circular Progress (most common)
const CircularProgressIndicator()

// 2. Linear Progress (for known progress)
LinearProgressIndicator(value: 0.5)  // 50%

// 3. Circular with color
const CircularProgressIndicator(
  color: Colors.blue,
  strokeWidth: 3,
)

// 4. Centered loading
const Center(
  child: CircularProgressIndicator(),
)

// 5. Loading with text
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    CircularProgressIndicator(),
    SizedBox(height: 16),
    Text('Loading...'),
  ],
)

// 6. Full screen loading overlay
Stack(
  children: [
    YourContent(),
    if (isLoading)
      Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
  ],
)
```

### Visual: Loading Indicator Types

```
┌─────────────────────────────────────────────────────────────┐
│              LOADING INDICATOR TYPES                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. CIRCULAR (Indeterminate)                                │
│     ⏳  - Unknown duration                                  │
│         - Most common                                       │
│         - Use for API calls                                 │
│                                                             │
│  2. LINEAR (Determinate)                                    │
│     [████████░░░░░░░░] 50%                                  │
│         - Known progress (0-100%)                           │
│         - Use for file uploads/downloads                    │
│                                                             │
│  3. OVERLAY                                                 │
│     ┌─────────────────────┐                                │
│     │      ⏳ ← Dims      │                                │
│     │   entire screen     │                                │
│     └─────────────────────┘                                │
│         - Blocks interaction                                │
│         - Use for critical operations                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Circular Progress Indicator

### Basic Usage

```dart
import 'package:flutter/material.dart';

class LoadingExample extends StatelessWidget {
  const LoadingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

### Customized Circular Indicator

```dart
class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // Custom color and size
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: Colors.blue,
              backgroundColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading your data...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
```

---

## Linear Progress Indicator

### Indeterminate (Unknown Progress)

```dart
class IndeterminateProgress extends StatelessWidget {
  const IndeterminateProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading...'),
          SizedBox(height: 16),
          LinearProgressIndicator(),
        ],
      ),
    );
  }
}
```

### Determinate (Known Progress)

```dart
class DeterminateProgress extends StatefulWidget {
  const DeterminateProgress({super.key});

  @override
  State<DeterminateProgress> createState() => _DeterminateProgressState();
}

class _DeterminateProgressState extends State<DeterminateProgress> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  Future<void> _simulateProgress() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _progress = i / 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Progress: ${(_progress * 100).toInt()}%'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[200],
                color: Colors.blue,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Skeleton Loading (Shimmer Effect)

### What is Skeleton Loading?

```
┌─────────────────────────────────────────────────────────────┐
│               SKELETON LOADING (SHIMMER)                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Instead of a boring spinner, show a PREVIEW of content:    │
│                                                             │
│  LOADING:                       LOADED:                     │
│  ┌─────────────────────┐        ┌─────────────────────┐    │
│  │ ┌──┐ ▓▓▓▓▓▓▓▓▓▓▓▓   │        │ ┌──┐ John Doe       │    │
│  │ └──┘ ▓▓▓▓▓▓▓▓       │        │ └──┘ john@email.com │    │
│  │ ───────────────────  │        │ ─────────────────── │    │
│  │ ┌──┐ ▓▓▓▓▓▓▓▓▓▓▓▓   │        │ ┌──┐ Jane Smith     │    │
│  │ └──┘ ▓▓▓▓▓▓▓        │        │ └──┘ jane@email.com │    │
│  │ ───────────────────  │        │ ─────────────────── │    │
│  │ ┌──┐ ▓▓▓▓▓▓▓▓▓▓▓    │        │ ┌──┐ Bob Wilson     │    │
│  │ └──┘ ▓▓▓▓▓▓▓▓▓      │        │ └──┘ bob@email.com  │    │
│  └─────────────────────┘        └─────────────────────┘    │
│                                                             │
│  ▓▓▓▓ = Animated gray boxes that shimmer                    │
│                                                             │
│  WHY? Users perceive it as faster than a spinner!           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Simple Skeleton Implementation

```dart
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// User card skeleton
class UserCardSkeleton extends StatelessWidget {
  const UserCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar skeleton
            const SkeletonLoader(width: 48, height: 48, borderRadius: 24),
            const SizedBox(width: 16),
            // Text skeletons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonLoader(width: 150, height: 16),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 100, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// List of skeletons while loading
class UsersScreenWithSkeleton extends StatelessWidget {
  const UsersScreenWithSkeleton({super.key});

  Future<List<dynamic>> fetchUsers() async {
    // Your API call here
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show skeleton list
          return ListView.builder(
            itemCount: 5,  // Show 5 skeleton items
            itemBuilder: (context, index) => const UserCardSkeleton(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Show actual data
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final user = snapshot.data![index];
            return UserCard(user: user);
          },
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user['name'] ?? ''),
        subtitle: Text(user['email'] ?? ''),
      ),
    );
  }
}
```

---

## Button Loading State

### Loading Button Example

```dart
class SubmitButton extends StatefulWidget {
  final Future<void> Function() onSubmit;

  const SubmitButton({super.key, required this.onSubmit});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    setState(() => _isLoading = true);

    try {
      await widget.onSubmit();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePress,  // Disable when loading
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Submit'),
    );
  }
}

// Usage
class SubmitButtonExample extends StatelessWidget {
  const SubmitButtonExample({super.key});

  Future<void> _handleSubmit() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SubmitButton(
          onSubmit: _handleSubmit,
        ),
      ),
    );
  }
}
```

### Visual: Button States

```
┌─────────────────────────────────────────────────────────────┐
│                    BUTTON LOADING STATES                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  STATE          │ BUTTON APPEARANCE                         │
│  ────────────────────────────────────────────────────────── │
│                                                             │
│  Normal         │ ┌─────────────┐                           │
│                 │ │   Submit    │  Blue, clickable          │
│                 │ └─────────────┘                           │
│                                                             │
│  Loading        │ ┌─────────────┐                           │
│                 │ │     ⏳      │  Gray, disabled           │
│                 │ └─────────────┘                           │
│                                                             │
│  Success        │ ┌─────────────┐                           │
│                 │ │     ✓       │  Green, briefly           │
│                 │ └─────────────┘                           │
│                                                             │
│  Error          │ ┌─────────────┐                           │
│                 │ │  Try Again  │  Red or normal            │
│                 │ └─────────────┘                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              LOADING INDICATORS CHEAT SHEET                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TYPES OF INDICATORS:                                       │
│  • CircularProgressIndicator() → Spinner                    │
│  • LinearProgressIndicator()   → Progress bar               │
│  • Skeleton widgets            → Content preview            │
│                                                             │
│  WHEN TO USE EACH:                                          │
│  • Circular → Unknown duration (API calls)                  │
│  • Linear   → Known progress (file uploads)                 │
│  • Skeleton → List/grid loading                             │
│                                                             │
│  BUTTON LOADING:                                            │
│  • Disable button while loading                             │
│  • Show spinner inside button                               │
│  • Re-enable after completion                               │
│                                                             │
│  BEST PRACTICES:                                            │
│  ✓ Always show SOME feedback                                │
│  ✓ Disable actions while loading                            │
│  ✓ Use skeleton loaders for lists                           │
│  ✓ Keep spinners centered and visible                       │
│  ✓ Add descriptive text when helpful                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

---

## Navigation

⬅️ **Previous:** [Error Patterns](06b-ErrorPatterns.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [FutureBuilder](07b-FutureBuilder.md)
