# Rive Animations: Interactive State-Driven Animations

## The Big Idea In One Sentence

> Rive is like Lottie but interactive: its animations have a state machine, so they can react to taps, input, and your app's state in real time (a button that morphs, a character that follows the cursor).

## The Simple Explanation

Imagine a toy robot that responds when you touch it - eyes blink when you tap its head, arms wave when you press a button. That's what Rive does - it creates animations that react to YOUR actions in real-time!

```
┌─────────────────────────────────────────────────────────┐
│                   RIVE ANIMATIONS                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  LOTTIE:                                                 │
│  Play animation → Watch → Done                           │
│  (Like watching a movie)                                 │
│                                                          │
│  RIVE:                                                   │
│  User taps → Animation reacts → User hovers → Changes   │
│  (Like playing a video game!)                            │
│                                                          │
│  RIVE has STATE MACHINES:                                │
│  Idle → Hover → Click → Success → Back to Idle          │
│                                                          │
│  Perfect for:                                            │
│  • Interactive buttons                                   │
│  • Character animations                                  │
│  • Game-like interactions                                │
│  • Login screens with feedback                           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What is Rive?

**Rive** is a powerful animation tool that creates interactive, real-time animations with state machines:

```
Rive Features:
✓ State machines (idle, hover, click, etc.)
✓ Runtime inputs (trigger events from code)
✓ Multiple artboards in one file
✓ Skeletal animations (characters)
✓ Vector graphics (scale perfectly)
✓ Smaller file sizes than GIFs/videos
✓ Edit in Rive Editor (rive.app)
```

---

## Setup

### Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  rive: ^0.13.0
```

### Import

```dart
import 'package:rive/rive.dart';
```

---

## Where to Find Rive Animations

### Rive Community

```
https://rive.app/community

FREE animations for:
• Button interactions
• Login/signup forms
• Loading indicators
• Characters
• Icons with states
• Game UI elements

How to download:
1. Browse rive.app/community
2. Find animation you like
3. Click "Get a copy"
4. Download .riv file
```

### Create Your Own

```
https://rive.app/editor

Rive Editor (Web-based):
• Create animations
• Design state machines
• Test interactions
• Export .riv file
```

---

## Basic Usage

### Simple Animation Playback

```dart
// 1. Add .riv file to assets
// pubspec.yaml:
flutter:
  assets:
    - assets/animations/login.riv
    - assets/animations/button.riv

// 2. Display the animation
class SimpleRive extends StatelessWidget {
  const SimpleRive({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.asset(
      'assets/animations/button.riv',
    );
  }
}
```

### Loading from Network

```dart
RiveAnimation.network(
  'https://example.com/animation.riv',
)
```

---

## Understanding State Machines

### What is a State Machine?

```
State Machine = Different animation states

Example: Button States
┌──────────────────────────────────────┐
│  Idle → Hover → Pressed → Success   │
│   ↑                           ↓      │
│   └───────────────────────────┘      │
└──────────────────────────────────────┘

Each state has its own animation!
```

### Using State Machines

```dart
class RiveButton extends StatefulWidget {
  const RiveButton({super.key});

  @override
  State<RiveButton> createState() => _RiveButtonState();
}

class _RiveButtonState extends State<RiveButton> {
  // Controller reference
  StateMachineController? _controller;

  // Input reference (to trigger animations)
  SMIInput<bool>? _pressInput;

  void _onRiveInit(Artboard artboard) {
    // Get the state machine controller
    final controller = StateMachineController.fromArtboard(
      artboard,
      'Button',  // Name of state machine in Rive file
    );

    artboard.addController(controller!);
    setState(() => _controller = controller);

    // Get the input (trigger)
    _pressInput = controller.findInput<bool>('Press') as SMIBool;
  }

  void _onPressed() {
    // Trigger the animation!
    _pressInput?.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: SizedBox(
        width: 200,
        height: 80,
        child: RiveAnimation.asset(
          'assets/animations/button.riv',
          onInit: _onRiveInit,
        ),
      ),
    );
  }
}
```

---

## Runtime Inputs

### Types of Inputs

```dart
// Boolean input (on/off, true/false)
SMIBool? hoverInput;
hoverInput = controller.findInput<bool>('isHover') as SMIBool;
hoverInput.value = true;  // Trigger

// Number input (slider, progress)
SMINumber? progressInput;
progressInput = controller.findInput<double>('progress') as SMINumber;
progressInput.value = 0.5;  // Set to 50%

// Trigger input (one-time event)
SMITrigger? clickInput;
clickInput = controller.findInput<bool>('click') as SMITrigger;
clickInput.fire();  // Trigger once
```

---

## Practical Examples

### Example 1: Interactive Login Button

```dart
class LoginButton extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginButton({super.key, required this.onLogin});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  StateMachineController? _controller;
  SMIBool? _isHovering;
  SMITrigger? _press;
  SMIBool? _isLoading;
  SMITrigger? _success;
  SMITrigger? _fail;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine',
    );

    artboard.addController(controller!);
    _controller = controller;

    // Get all inputs
    _isHovering = controller.findInput<bool>('Hover') as SMIBool;
    _press = controller.findInput<bool>('Press') as SMITrigger;
    _isLoading = controller.findInput<bool>('isLoading') as SMIBool;
    _success = controller.findInput<bool>('success') as SMITrigger;
    _fail = controller.findInput<bool>('fail') as SMITrigger;
  }

  Future<void> _handlePress() async {
    _press?.fire();
    _isLoading?.value = true;

    try {
      // Simulate login
      await Future.delayed(const Duration(seconds: 2));
      widget.onLogin();

      // Show success
      _isLoading?.value = false;
      _success?.fire();
    } catch (e) {
      // Show error
      _isLoading?.value = false;
      _fail?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovering?.value = true,
      onExit: (_) => _isHovering?.value = false,
      child: GestureDetector(
        onTap: _handlePress,
        child: SizedBox(
          width: 300,
          height: 80,
          child: RiveAnimation.asset(
            'assets/animations/login_button.riv',
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}
```

---

### Example 2: Progress Bar with Character

```dart
class AnimatedProgress extends StatefulWidget {
  final double progress;  // 0.0 to 1.0

  const AnimatedProgress({super.key, required this.progress});

  @override
  State<AnimatedProgress> createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress> {
  SMINumber? _progressInput;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'ProgressMachine',
    );

    artboard.addController(controller!);

    // Get progress input
    _progressInput = controller.findInput<double>('progress') as SMINumber;
  }

  @override
  void didUpdateWidget(AnimatedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation when progress changes
    if (widget.progress != oldWidget.progress) {
      _progressInput?.value = widget.progress * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 400,
          height: 200,
          child: RiveAnimation.asset(
            'assets/animations/progress_character.riv',
            onInit: _onRiveInit,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${(widget.progress * 100).toInt()}%',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Usage:
class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double _progress = 0.0;

  void _startDownload() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() => _progress = i / 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedProgress(progress: _progress),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startDownload,
              child: const Text('Start Download'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Example 3: Animated Character with Emotions

```dart
class EmotionalCharacter extends StatefulWidget {
  const EmotionalCharacter({super.key});

  @override
  State<EmotionalCharacter> createState() => _EmotionalCharacterState();
}

class _EmotionalCharacterState extends State<EmotionalCharacter> {
  StateMachineController? _controller;
  SMITrigger? _happy;
  SMITrigger? _sad;
  SMITrigger? _angry;
  SMITrigger? _surprised;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'EmotionMachine',
    );

    artboard.addController(controller!);
    _controller = controller;

    // Get emotion triggers
    _happy = controller.findInput<bool>('happy') as SMITrigger;
    _sad = controller.findInput<bool>('sad') as SMITrigger;
    _angry = controller.findInput<bool>('angry') as SMITrigger;
    _surprised = controller.findInput<bool>('surprised') as SMITrigger;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: RiveAnimation.asset(
            'assets/animations/character.riv',
            onInit: _onRiveInit,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => _happy?.fire(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('😊 Happy'),
            ),
            ElevatedButton(
              onPressed: () => _sad?.fire(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('😢 Sad'),
            ),
            ElevatedButton(
              onPressed: () => _angry?.fire(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('😠 Angry'),
            ),
            ElevatedButton(
              onPressed: () => _surprised?.fire(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('😲 Surprised'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### Example 4: Form Validation with Feedback

```dart
class RivePasswordField extends StatefulWidget {
  const RivePasswordField({super.key});

  @override
  State<RivePasswordField> createState() => _RivePasswordFieldState();
}

class _RivePasswordFieldState extends State<RivePasswordField> {
  final TextEditingController _controller = TextEditingController();
  SMIBool? _isChecking;
  SMITrigger? _success;
  SMITrigger? _fail;
  SMINumber? _look;  // Character looks at cursor position

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'LoginMachine',
    );

    artboard.addController(controller!);

    _isChecking = controller.findInput<bool>('isChecking') as SMIBool;
    _success = controller.findInput<bool>('success') as SMITrigger;
    _fail = controller.findInput<bool>('fail') as SMITrigger;
    _look = controller.findInput<double>('numLook') as SMINumber;
  }

  void _validatePassword(String password) {
    _isChecking?.value = true;

    // Update character's look based on password length
    _look?.value = password.length.toDouble() * 10;

    Future.delayed(const Duration(seconds: 1), () {
      if (password.length >= 8 &&
          password.contains(RegExp(r'[A-Z]')) &&
          password.contains(RegExp(r'[0-9]'))) {
        // Valid password
        _isChecking?.value = false;
        _success?.fire();
      } else {
        // Invalid password
        _isChecking?.value = false;
        _fail?.fire();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 200,
          child: RiveAnimation.asset(
            'assets/animations/teddy.riv',  // Famous Rive login bear!
            onInit: _onRiveInit,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _controller,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              hintText: 'Enter password (8+ chars, 1 uppercase, 1 number)',
            ),
            onChanged: (value) {
              // Update look position
              _look?.value = value.length.toDouble() * 10;
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _validatePassword(_controller.text),
          child: const Text('Validate'),
        ),
      ],
    );
  }
}
```

---

## Multiple Artboards

### Using Different Artboards from Same File

```dart
class MultiArtboard extends StatelessWidget {
  const MultiArtboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First artboard
        SizedBox(
          width: 200,
          height: 200,
          child: RiveAnimation.asset(
            'assets/animations/icons.riv',
            artboard: 'Heart',  // ← Specify artboard name
          ),
        ),

        // Second artboard
        SizedBox(
          width: 200,
          height: 200,
          child: RiveAnimation.asset(
            'assets/animations/icons.riv',
            artboard: 'Star',  // ← Different artboard, same file!
          ),
        ),
      ],
    );
  }
}
```

---

## Complete Shopping App Example

```dart
// Product card with Rive like button
class RiveProductCard extends StatefulWidget {
  final String name;
  final double price;
  final String imageUrl;

  const RiveProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<RiveProductCard> createState() => _RiveProductCardState();
}

class _RiveProductCardState extends State<RiveProductCard> {
  SMIBool? _isLiked;
  bool _addedToCart = false;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'HeartMachine',
    );

    artboard.addController(controller!);
    _isLiked = controller.findInput<bool>('isLiked') as SMIBool;
  }

  Future<void> _addToCart() async {
    setState(() => _addedToCart = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _addedToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                widget.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Rive like button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    _isLiked?.value = !(_isLiked?.value ?? false);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: RiveAnimation.asset(
                      'assets/animations/heart_button.riv',
                      onInit: _onRiveInit,
                    ),
                  ),
                ),
              ),

              // Success overlay
              if (_addedToCart)
                Container(
                  height: 200,
                  color: Colors.black54,
                  child: const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: RiveAnimation.asset(
                        'assets/animations/success.riv',
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Shopping cart with animated count
class AnimatedCartIcon extends StatefulWidget {
  final int itemCount;

  const AnimatedCartIcon({super.key, required this.itemCount});

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon> {
  SMINumber? _countInput;
  SMITrigger? _bump;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'CartMachine',
    );

    artboard.addController(controller!);
    _countInput = controller.findInput<double>('count') as SMINumber;
    _bump = controller.findInput<bool>('bump') as SMITrigger;
  }

  @override
  void didUpdateWidget(AnimatedCartIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.itemCount != oldWidget.itemCount) {
      _countInput?.value = widget.itemCount.toDouble();
      _bump?.fire();  // Bump animation when count changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: RiveAnimation.asset(
        'assets/animations/cart_icon.riv',
        onInit: _onRiveInit,
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              RIVE ANIMATIONS SUMMARY                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT IS IT:                                             │
│  • Interactive, state-driven animations                  │
│  • Created in Rive Editor (rive.app)                     │
│  • Vector graphics (.riv files)                          │
│  • State machines for complex interactions               │
│                                                          │
│  BASIC USAGE:                                            │
│  • RiveAnimation.asset('path/to/file.riv')               │
│  • artboard: 'ArtboardName'                              │
│  • onInit callback to get controller                     │
│                                                          │
│  STATE MACHINES:                                         │
│  • StateMachineController.fromArtboard()                 │
│  • findInput<T>('inputName')                             │
│  • Different states: idle, hover, click, etc.            │
│                                                          │
│  INPUT TYPES:                                            │
│  • SMIBool - Boolean (true/false)                        │
│  • SMINumber - Number value                              │
│  • SMITrigger - One-time event (fire())                  │
│                                                          │
│  COMMON USES:                                            │
│  • Interactive buttons                                   │
│  • Form validation feedback                              │
│  • Progress indicators with characters                   │
│  • Animated characters with emotions                     │
│  • Game-like UI elements                                 │
│                                                          │
│  VS LOTTIE:                                              │
│  • Lottie: Play-once animations                          │
│  • Rive: Interactive, responds to user input             │
│                                                          │
│  RESOURCES:                                              │
│  • rive.app/community - Free animations                  │
│  • rive.app/editor - Create your own                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What's the main difference between Lottie and Rive?

<details>
<summary>Answer</summary>

**Lottie**: Plays animations from start to finish. Good for loading indicators, success/error messages.

**Rive**: Interactive animations with state machines. Responds to user input in real-time. Good for buttons, characters, forms.

</details>

**Q2:** How do you trigger an animation in Rive?

<details>
<summary>Answer</summary>

Use inputs from the state machine:

```dart
// Get the input
SMITrigger? clickInput = controller.findInput<bool>('click') as SMITrigger;

// Trigger it
clickInput.fire();
```

</details>

**Q3:** What are the three types of inputs in Rive?

<details>
<summary>Answer</summary>

1. **SMIBool** - Boolean value (true/false, on/off)
2. **SMINumber** - Number value (progress, count, etc.)
3. **SMITrigger** - One-time event (click, tap, etc.)

</details>

---

**Congratulations!** You've completed Level 14: Animations & Polish!

You now know:
- ✅ Implicit and explicit animations
- ✅ Hero animations
- ✅ Microinteractions
- ✅ flutter_animate for declarative animations
- ✅ Lottie for designer-created animations
- ✅ Rive for interactive state-driven animations

**Next:** Level 15 - Deployment & Publishing

---

## Navigation

## Assignment

### Problem 1: Lottie vs Rive

What is the key difference between Lottie and Rive?

### Problem 2: State machine

In one line, what does a Rive "state machine" let an animation do?

### Problem 3: Pick the tool

You want an animated button that reacts to hover, press, and success states. Lottie or Rive?

---

## Assignment Answers

### Problem 1: Lottie vs Rive

Lottie plays a fixed animation; Rive animations are interactive and can respond to input and app state via a state machine.

### Problem 2: State machine

It lets the animation switch between states (idle, hover, pressed, success) based on inputs, instead of just playing start to finish.

### Problem 3: Pick the tool

**Rive**, because it can react to hover/press/success states interactively. Lottie would just play a set clip.

---

⬅️ **Previous:** [Lottie Animations](07-LottieAnimations.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next Level:** [Level 15 - Deployment & Publishing](../../Level-15-Deployment-Publishing/Theory/00-LearningPath.md)
