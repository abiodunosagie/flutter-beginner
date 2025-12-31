# 14z. Rive Animations - Interactive, State-Based Animations

## What You'll Learn
Master Rive animations in Flutter - create interactive, state-based animations that respond to user input and app state in real-time.

---

## The Big Picture

Think of Rive like creating an interactive robot:
- **Lottie** = Playing a movie (pre-recorded, linear)
- **Rive** = Controlling a robot (interactive, responds to commands)
- **State Machines** = Robot's brain (decides what to do based on input)
- **Inputs** = Buttons on remote control (trigger actions)

```
LOTTIE vs RIVE
==============

Lottie (Linear):                Rive (Interactive):
┌────────────────┐             ┌────────────────────┐
│ Play animation │             │ User taps button   │
│      ↓         │             │        ↓           │
│ Animation runs │             │ State changes      │
│      ↓         │             │        ↓           │
│ Animation ends │             │ Animation updates  │
└────────────────┘             │        ↓           │
                               │ Waits for input    │
                               └────────────────────┘

Lottie = Movie                 Rive = Video game character
Play from start to end         Responds to your actions
```

---

## 1. Installation and Setup

### Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  rive: ^0.13.0
```

Run:
```bash
flutter pub get
```

### Setup Assets

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/rive/
    - assets/rive/button.riv
    - assets/rive/character.riv
```

Create folder structure:
```
your_project/
├── assets/
│   └── rive/
│       ├── button.riv
│       ├── character.riv
│       └── toggle.riv
└── lib/
    └── main.dart
```

---

## 2. Getting Rive Animations

### Where to Get Rive Files

1. **Rive Community** (Free)
   - Visit: https://rive.app/community
   - Download .riv files
   - Use in your app

2. **Create Your Own**
   - Use Rive Editor (https://rive.app/editor)
   - Design animations visually
   - Export as .riv file

3. **Learn Rive**
   - Follow tutorials at https://rive.app/learn
   - Create interactive characters
   - Build state machines

---

## 3. Basic Rive Usage

### Example 1: Simple Rive Animation

```dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SimpleRive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Rive')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: RiveAnimation.asset(
            'assets/rive/character.riv',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// Animation plays automatically!
```

### Example 2: Specific Artboard and Animation

```dart
class SpecificAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Specific Animation')),
      body: Center(
        child: RiveAnimation.asset(
          'assets/rive/character.riv',
          artboard: 'MainArtboard',      // Specific artboard
          animations: ['idle'],           // Play 'idle' animation
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
```

---

## 4. State Machines - The Robot's Brain

### Understanding State Machines

```
STATE MACHINE EXAMPLE: Button
==============================

States:
- idle (default)
- hover
- pressed

Transitions:
idle → hover (when mouse enters)
hover → pressed (when clicked)
pressed → idle (when released)

┌─────────┐
│  idle   │ ←─────────────────┐
└────┬────┘                   │
     │ mouse enter            │ mouse leave
     ↓                        │
┌─────────┐                   │
│  hover  │                   │
└────┬────┘                   │
     │ click                  │
     ↓                        │
┌─────────┐                   │
│ pressed │ ──────────────────┘
└─────────┘   release
```

### Example 3: Basic State Machine

```dart
class StateMachineExample extends StatefulWidget {
  @override
  State<StateMachineExample> createState() => _StateMachineExampleState();
}

class _StateMachineExampleState extends State<StateMachineExample> {
  StateMachineController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('State Machine')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: RiveAnimation.asset(
            'assets/rive/button.riv',
            stateMachines: ['ButtonStateMachine'],  // Use state machine
            onInit: (artboard) {
              _controller = StateMachineController.fromArtboard(
                artboard,
                'ButtonStateMachine',
              );
              artboard.addController(_controller!);
            },
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Interactive Inputs

### Example 4: Trigger Input (One-time Action)

```dart
class TriggerInputExample extends StatefulWidget {
  @override
  State<TriggerInputExample> createState() => _TriggerInputExampleState();
}

class _TriggerInputExampleState extends State<TriggerInputExample> {
  SMITrigger? _trigger;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'StateMachine',
    );

    artboard.addController(controller!);

    // Get trigger input
    _trigger = controller.findInput<bool>('Trigger') as SMITrigger;
  }

  void _fireTrigger() {
    // Fire the trigger
    _trigger?.fire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trigger Input')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: RiveAnimation.asset(
              'assets/rive/character.riv',
              stateMachines: ['StateMachine'],
              onInit: _onRiveInit,
            ),
          ),

          SizedBox(height: 40),

          ElevatedButton(
            onPressed: _fireTrigger,
            child: Text('Fire Trigger'),
          ),
        ],
      ),
    );
  }
}

// Trigger fires once per press
// Example: Character jumps when trigger fires
```

### Example 5: Boolean Input (On/Off State)

```dart
class BooleanInputExample extends StatefulWidget {
  @override
  State<BooleanInputExample> createState() => _BooleanInputExampleState();
}

class _BooleanInputExampleState extends State<BooleanInputExample> {
  SMIBool? _boolInput;
  bool _isActive = false;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'StateMachine',
    );

    artboard.addController(controller!);

    // Get boolean input
    _boolInput = controller.findInput<bool>('isActive') as SMIBool;
  }

  void _toggleBoolean() {
    setState(() {
      _isActive = !_isActive;
      _boolInput?.value = _isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boolean Input')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: RiveAnimation.asset(
              'assets/rive/toggle.riv',
              stateMachines: ['StateMachine'],
              onInit: _onRiveInit,
            ),
          ),

          SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Inactive'),
              Switch(
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                    _boolInput?.value = value;
                  });
                },
              ),
              Text('Active'),
            ],
          ),
        ],
      ),
    );
  }
}

// Boolean controls on/off states
// Example: Toggle switch, lights on/off
```

### Example 6: Number Input (Continuous Value)

```dart
class NumberInputExample extends StatefulWidget {
  @override
  State<NumberInputExample> createState() => _NumberInputExampleState();
}

class _NumberInputExampleState extends State<NumberInputExample> {
  SMINumber? _numberInput;
  double _value = 0.0;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'StateMachine',
    );

    artboard.addController(controller!);

    // Get number input
    _numberInput = controller.findInput<double>('Level') as SMINumber;
  }

  void _updateValue(double value) {
    setState(() {
      _value = value;
      _numberInput?.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Input')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: RiveAnimation.asset(
              'assets/rive/meter.riv',
              stateMachines: ['StateMachine'],
              onInit: _onRiveInit,
            ),
          ),

          SizedBox(height: 40),

          Text(
            'Value: ${_value.toInt()}',
            style: TextStyle(fontSize: 24),
          ),

          Slider(
            value: _value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: _updateValue,
          ),
        ],
      ),
    );
  }
}

// Number input for continuous values
// Example: Progress bar, volume control, battery level
```

---

## 6. Multiple Inputs

### Example 7: Character with Multiple Controls

```dart
class MultipleInputsExample extends StatefulWidget {
  @override
  State<MultipleInputsExample> createState() => _MultipleInputsExampleState();
}

class _MultipleInputsExampleState extends State<MultipleInputsExample> {
  // Multiple input types
  SMITrigger? _jumpTrigger;
  SMIBool? _isRunning;
  SMINumber? _speed;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'CharacterStateMachine',
    );

    artboard.addController(controller!);

    // Get all inputs
    _jumpTrigger = controller.findInput<bool>('Jump') as SMITrigger;
    _isRunning = controller.findInput<bool>('IsRunning') as SMIBool;
    _speed = controller.findInput<double>('Speed') as SMINumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character Controls')),
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/rive/character.riv',
              stateMachines: ['CharacterStateMachine'],
              onInit: _onRiveInit,
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Jump button (Trigger)
                ElevatedButton(
                  onPressed: () => _jumpTrigger?.fire(),
                  child: Text('Jump'),
                ),

                SizedBox(height: 20),

                // Run toggle (Boolean)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Walk'),
                    Switch(
                      value: _isRunning?.value ?? false,
                      onChanged: (value) {
                        _isRunning?.value = value;
                      },
                    ),
                    Text('Run'),
                  ],
                ),

                SizedBox(height: 20),

                // Speed slider (Number)
                Text('Speed'),
                Slider(
                  value: _speed?.value ?? 1.0,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (value) {
                    _speed?.value = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 7. Practical Use Cases

### Example 8: Interactive Button

```dart
class InteractiveButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const InteractiveButton({
    required this.onPressed,
    required this.text,
  });

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton> {
  SMIBool? _isHovered;
  SMIBool? _isPressed;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'ButtonStateMachine',
    );

    artboard.addController(controller!);

    _isHovered = controller.findInput<bool>('isHover') as SMIBool;
    _isPressed = controller.findInput<bool>('isPressed') as SMIBool;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _isPressed?.value = true,
      onTapUp: (_) {
        _isPressed?.value = false;
        widget.onPressed();
      },
      onTapCancel: () => _isPressed?.value = false,
      child: MouseRegion(
        onEnter: (_) => _isHovered?.value = true,
        onExit: (_) => _isHovered?.value = false,
        child: SizedBox(
          width: 200,
          height: 80,
          child: Stack(
            children: [
              // Rive animation as background
              RiveAnimation.asset(
                'assets/rive/button.riv',
                stateMachines: ['ButtonStateMachine'],
                onInit: _onRiveInit,
              ),

              // Text overlay
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage:
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InteractiveButton(
          text: 'Click Me!',
          onPressed: () {
            print('Button pressed!');
          },
        ),
      ),
    );
  }
}
```

### Example 9: Loading Progress

```dart
class RiveLoadingProgress extends StatefulWidget {
  @override
  State<RiveLoadingProgress> createState() => _RiveLoadingProgressState();
}

class _RiveLoadingProgressState extends State<RiveLoadingProgress> {
  SMINumber? _progress;
  double _currentProgress = 0.0;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'ProgressStateMachine',
    );

    artboard.addController(controller!);
    _progress = controller.findInput<double>('Progress') as SMINumber;
  }

  Future<void> _simulateLoading() async {
    setState(() => _currentProgress = 0.0);

    for (double i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      setState(() {
        _currentProgress = i;
        _progress?.value = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading Progress')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: RiveAnimation.asset(
              'assets/rive/progress.riv',
              stateMachines: ['ProgressStateMachine'],
              onInit: _onRiveInit,
            ),
          ),

          SizedBox(height: 40),

          Text(
            '${_currentProgress.toInt()}%',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 40),

          ElevatedButton(
            onPressed: _simulateLoading,
            child: Text('Start Loading'),
          ),
        ],
      ),
    );
  }
}
```

### Example 10: Like Button with Animation

```dart
class RiveLikeButton extends StatefulWidget {
  @override
  State<RiveLikeButton> createState() => _RiveLikeButtonState();
}

class _RiveLikeButtonState extends State<RiveLikeButton> {
  SMITrigger? _likeTrigger;
  SMITrigger? _unlikeTrigger;
  SMIBool? _isLiked;
  bool _currentlyLiked = false;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'LikeStateMachine',
    );

    artboard.addController(controller!);

    _likeTrigger = controller.findInput<bool>('Like') as SMITrigger;
    _unlikeTrigger = controller.findInput<bool>('Unlike') as SMITrigger;
    _isLiked = controller.findInput<bool>('IsLiked') as SMIBool;
  }

  void _toggleLike() {
    setState(() {
      _currentlyLiked = !_currentlyLiked;
      _isLiked?.value = _currentlyLiked;

      if (_currentlyLiked) {
        _likeTrigger?.fire();
      } else {
        _unlikeTrigger?.fire();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Like Button')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _toggleLike,
              child: SizedBox(
                width: 200,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/rive/like.riv',
                  stateMachines: ['LikeStateMachine'],
                  onInit: _onRiveInit,
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              _currentlyLiked ? 'Liked!' : 'Tap to like',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 8. Advanced Techniques

### Example 11: Listening to State Changes

```dart
class StateChangeListener extends StatefulWidget {
  @override
  State<StateChangeListener> createState() => _StateChangeListenerState();
}

class _StateChangeListenerState extends State<StateChangeListener> {
  String _currentState = 'Unknown';

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'StateMachine',
    );

    artboard.addController(controller!);

    // Listen for state changes
    controller.addEventListener((event) {
      if (event is RiveStateChangeEvent) {
        setState(() {
          _currentState = event.stateMachineName;
        });
        print('State changed to: ${event.stateMachineName}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('State Changes')),
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/rive/character.riv',
              stateMachines: ['StateMachine'],
              onInit: _onRiveInit,
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Text(
              'Current State: $_currentState',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 12: Nested State Machines

```dart
class NestedStateMachines extends StatefulWidget {
  @override
  State<NestedStateMachines> createState() => _NestedStateMachinesState();
}

class _NestedStateMachinesState extends State<NestedStateMachines> {
  StateMachineController? _mainController;
  StateMachineController? _faceController;

  SMITrigger? _walkTrigger;
  SMIBool? _isSmiling;

  void _onRiveInit(Artboard artboard) {
    // Main body state machine
    _mainController = StateMachineController.fromArtboard(
      artboard,
      'BodyStateMachine',
    );
    artboard.addController(_mainController!);

    // Face state machine (nested)
    _faceController = StateMachineController.fromArtboard(
      artboard,
      'FaceStateMachine',
    );
    artboard.addController(_faceController!);

    // Get inputs from both
    _walkTrigger = _mainController!.findInput<bool>('Walk') as SMITrigger;
    _isSmiling = _faceController!.findInput<bool>('IsSmiling') as SMIBool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nested State Machines')),
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/rive/character.riv',
              onInit: _onRiveInit,
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _walkTrigger?.fire(),
                  child: Text('Walk'),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sad'),
                    Switch(
                      value: _isSmiling?.value ?? false,
                      onChanged: (value) {
                        _isSmiling?.value = value;
                      },
                    ),
                    Text('Happy'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 9. Complete Shopping App Example

```dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive Shop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RiveShopHome(),
    );
  }
}

class RiveShopHome extends StatefulWidget {
  @override
  State<RiveShopHome> createState() => _RiveShopHomeState();
}

class _RiveShopHomeState extends State<RiveShopHome> {
  final List<Product> _products = List.generate(
    10,
    (i) => Product(
      id: '$i',
      name: 'Product $i',
      price: (i + 1) * 10.0,
      isLiked: false,
    ),
  );

  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rive Shop'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return RiveProductCard(
            product: _products[index],
            onLike: (isLiked) {
              setState(() {
                _products[index].isLiked = isLiked;
              });
            },
            onAddToCart: () {
              setState(() => _cartCount++);
            },
          );
        },
      ),
    );
  }
}

class RiveProductCard extends StatefulWidget {
  final Product product;
  final Function(bool) onLike;
  final VoidCallback onAddToCart;

  const RiveProductCard({
    required this.product,
    required this.onLike,
    required this.onAddToCart,
  });

  @override
  State<RiveProductCard> createState() => _RiveProductCardState();
}

class _RiveProductCardState extends State<RiveProductCard> {
  SMITrigger? _likeTrigger;
  SMIBool? _isLiked;
  SMITrigger? _addToCartTrigger;

  void _onLikeInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'LikeStateMachine',
    );
    artboard.addController(controller!);

    _likeTrigger = controller.findInput<bool>('Like') as SMITrigger;
    _isLiked = controller.findInput<bool>('IsLiked') as SMIBool;
    _isLiked?.value = widget.product.isLiked;
  }

  void _onCartInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'CartStateMachine',
    );
    artboard.addController(controller!);

    _addToCartTrigger = controller.findInput<bool>('Add') as SMITrigger;
  }

  void _toggleLike() {
    final newValue = !(_isLiked?.value ?? false);
    _isLiked?.value = newValue;
    _likeTrigger?.fire();
    widget.onLike(newValue);
  }

  void _addToCart() {
    _addToCartTrigger?.fire();
    widget.onAddToCart();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Product image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
            ),

            SizedBox(width: 16),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Like button
            GestureDetector(
              onTap: _toggleLike,
              child: SizedBox(
                width: 50,
                height: 50,
                child: RiveAnimation.asset(
                  'assets/rive/like.riv',
                  stateMachines: ['LikeStateMachine'],
                  onInit: _onLikeInit,
                ),
              ),
            ),

            SizedBox(width: 8),

            // Add to cart button
            GestureDetector(
              onTap: _addToCart,
              child: SizedBox(
                width: 50,
                height: 50,
                child: RiveAnimation.asset(
                  'assets/rive/cart.riv',
                  stateMachines: ['CartStateMachine'],
                  onInit: _onCartInit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  bool isLiked;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.isLiked = false,
  });
}
```

---

## 10. Performance Tips

### Tip 1: Dispose Controllers

```dart
class ProperDisposal extends StatefulWidget {
  @override
  State<ProperDisposal> createState() => _ProperDisposalState();
}

class _ProperDisposalState extends State<ProperDisposal> {
  StateMachineController? _controller;

  @override
  void dispose() {
    _controller?.dispose();  // Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/rive/animation.riv',
      onInit: (artboard) {
        _controller = StateMachineController.fromArtboard(
          artboard,
          'StateMachine',
        );
        artboard.addController(_controller!);
      },
    );
  }
}
```

### Tip 2: Use Specific Artboards

```dart
// ❌ Bad: Loads entire file
RiveAnimation.asset('assets/rive/large_file.riv')

// ✅ Good: Load specific artboard only
RiveAnimation.asset(
  'assets/rive/large_file.riv',
  artboard: 'SmallArtboard',  // Only loads this artboard
)
```

---

## Quick Reference

### Basic Setup

```dart
// Simple animation
RiveAnimation.asset('assets/rive/animation.riv')

// With state machine
RiveAnimation.asset(
  'assets/rive/animation.riv',
  stateMachines: ['StateMachine'],
)

// With controller
RiveAnimation.asset(
  'assets/rive/animation.riv',
  onInit: (artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'StateMachine',
    );
    artboard.addController(controller!);
  },
)
```

### Input Types

```dart
// Trigger (fire once)
SMITrigger trigger = controller.findInput<bool>('TriggerName') as SMITrigger;
trigger.fire();

// Boolean (on/off)
SMIBool bool = controller.findInput<bool>('BoolName') as SMIBool;
bool.value = true;

// Number (continuous)
SMINumber number = controller.findInput<double>('NumberName') as SMINumber;
number.value = 50.0;
```

---

## What's Next?

You've mastered Rive animations! Continue with:

- **Creating Rive Animations** - Use Rive Editor
- **Advanced State Machines** - Complex interactions
- **Animation Performance** - Optimize Rive files

---

## Navigation

- Previous: [14y. Lottie Animations](14y-LottieAnimations.md)
- Next: [Level 15 - Deployment](../../Level-15-Deployment/README.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 25 minutes**

**Remember**: Rive is like programming a robot - create state machines, define inputs, and let your animations respond to user actions in real-time. Visit rive.app to learn more and create your own interactive animations!
