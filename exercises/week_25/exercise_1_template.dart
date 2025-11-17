/// Exercise 1: Implicit Animations - Animated UI Card
/// Create an interactive card with smooth implicit animations

import 'package:flutter/material.dart';

// TODO: Create AnimatedCard widget with:
// - AnimatedContainer for size/color changes
// - AnimatedOpacity for fade effects
// - Tap to expand/collapse functionality

class AnimatedCard extends StatefulWidget {
  const AnimatedCard({Key? key}) : super(key: key);

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // TODO: Implement AnimatedContainer with smooth transitions
    return Container();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: AnimatedCard()))));
