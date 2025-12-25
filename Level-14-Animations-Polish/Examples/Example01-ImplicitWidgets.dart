// ============================================
// EXAMPLE 01: IMPLICIT ANIMATION WIDGETS
// Easy animations with built-in Flutter widgets
// ============================================

import 'package:flutter/material.dart';

void main() => runApp(const ImplicitAnimationsApp());

class ImplicitAnimationsApp extends StatelessWidget {
  const ImplicitAnimationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Implicit Animations',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ImplicitAnimationsDemo(),
    );
  }
}

class ImplicitAnimationsDemo extends StatelessWidget {
  const ImplicitAnimationsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionTitle('AnimatedContainer'),
          AnimatedContainerDemo(),
          SizedBox(height: 32),
          _SectionTitle('AnimatedOpacity'),
          AnimatedOpacityDemo(),
          SizedBox(height: 32),
          _SectionTitle('AnimatedCrossFade'),
          AnimatedCrossFadeDemo(),
          SizedBox(height: 32),
          _SectionTitle('AnimatedAlign'),
          AnimatedAlignDemo(),
          SizedBox(height: 32),
          _SectionTitle('AnimatedRotation'),
          AnimatedRotationDemo(),
          SizedBox(height: 32),
          _SectionTitle('AnimatedScale'),
          AnimatedScaleDemo(),
          SizedBox(height: 32),
          _SectionTitle('AnimatedSwitcher'),
          AnimatedSwitcherDemo(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================
// ANIMATED CONTAINER DEMO
// ============================================

class AnimatedContainerDemo extends StatefulWidget {
  const AnimatedContainerDemo({super.key});

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Shrink' : 'Expand'),
        ),
        const SizedBox(height: 16),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: _expanded ? 200 : 100,
            height: _expanded ? 200 : 100,
            decoration: BoxDecoration(
              color: _expanded ? Colors.blue : Colors.orange,
              borderRadius: BorderRadius.circular(_expanded ? 20 : 10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_expanded ? 0.3 : 0.1),
                  blurRadius: _expanded ? 15 : 5,
                  offset: Offset(0, _expanded ? 8 : 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _expanded ? 'BIG!' : 'small',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _expanded ? 24 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// ANIMATED OPACITY DEMO
// ============================================

class AnimatedOpacityDemo extends StatefulWidget {
  const AnimatedOpacityDemo({super.key});

  @override
  State<AnimatedOpacityDemo> createState() => _AnimatedOpacityDemoState();
}

class _AnimatedOpacityDemoState extends State<AnimatedOpacityDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? 'Fade Out' : 'Fade In'),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _visible ? 1.0 : 0.0,
          curve: Curves.easeInOut,
          child: Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'I can fade!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// ANIMATED CROSS FADE DEMO
// ============================================

class AnimatedCrossFadeDemo extends StatefulWidget {
  const AnimatedCrossFadeDemo({super.key});

  @override
  State<AnimatedCrossFadeDemo> createState() => _AnimatedCrossFadeDemoState();
}

class _AnimatedCrossFadeDemoState extends State<AnimatedCrossFadeDemo> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _showFirst = !_showFirst),
          child: const Text('Switch'),
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          crossFadeState: _showFirst
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            width: 150,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.thumb_up, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Yes!', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          secondChild: Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.thumb_down, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text('No!', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// ANIMATED ALIGN DEMO
// ============================================

class AnimatedAlignDemo extends StatefulWidget {
  const AnimatedAlignDemo({super.key});

  @override
  State<AnimatedAlignDemo> createState() => _AnimatedAlignDemoState();
}

class _AnimatedAlignDemoState extends State<AnimatedAlignDemo> {
  Alignment _alignment = Alignment.topLeft;

  final List<Alignment> _alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];
  int _index = 0;

  void _moveNext() {
    setState(() {
      _index = (_index + 1) % _alignments.length;
      _alignment = _alignments[_index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _moveNext,
          child: const Text('Move'),
        ),
        const SizedBox(height: 16),
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            alignment: _alignment,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// ANIMATED ROTATION DEMO
// ============================================

class AnimatedRotationDemo extends StatefulWidget {
  const AnimatedRotationDemo({super.key});

  @override
  State<AnimatedRotationDemo> createState() => _AnimatedRotationDemoState();
}

class _AnimatedRotationDemoState extends State<AnimatedRotationDemo> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _turns -= 0.25),
              child: const Icon(Icons.rotate_left),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => setState(() => _turns += 0.25),
              child: const Icon(Icons.rotate_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedRotation(
          turns: _turns,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('${(_turns * 360).round()}°'),
      ],
    );
  }
}

// ============================================
// ANIMATED SCALE DEMO
// ============================================

class AnimatedScaleDemo extends StatefulWidget {
  const AnimatedScaleDemo({super.key});

  @override
  State<AnimatedScaleDemo> createState() => _AnimatedScaleDemoState();
}

class _AnimatedScaleDemoState extends State<AnimatedScaleDemo> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _scale,
          min: 0.5,
          max: 1.5,
          onChanged: (value) => setState(() => _scale = value),
        ),
        Text('Scale: ${_scale.toStringAsFixed(2)}'),
        const SizedBox(height: 16),
        AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// ANIMATED SWITCHER DEMO
// ============================================

class AnimatedSwitcherDemo extends StatefulWidget {
  const AnimatedSwitcherDemo({super.key});

  @override
  State<AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: const Text('Increment'),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<int>(_count), // KEY IS REQUIRED!
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$_count',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │          IMPLICIT ANIMATION EXAMPLES                         │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  AnimatedContainer                                           │
  │  └── Size, color, decoration, padding, margin               │
  │                                                              │
  │  AnimatedOpacity                                             │
  │  └── Fade in/out with opacity 0.0 to 1.0                    │
  │                                                              │
  │  AnimatedCrossFade                                           │
  │  └── Switch between two widgets smoothly                    │
  │                                                              │
  │  AnimatedAlign                                               │
  │  └── Move widget to different alignments                    │
  │                                                              │
  │  AnimatedRotation                                            │
  │  └── Rotate with turns (1 turn = 360°)                      │
  │                                                              │
  │  AnimatedScale                                               │
  │  └── Scale up/down (1.0 = normal size)                      │
  │                                                              │
  │  AnimatedSwitcher                                            │
  │  └── Animate widget replacement (needs KEY!)                │
  │                                                              │
  │  ALL NEED:                                                   │
  │  ├── duration: Duration(milliseconds: X)                    │
  │  └── The value(s) to animate                                │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
