/// Exercise 2: Explicit Animations - Loading Spinner
/// Create custom loading spinner using AnimationController

import 'package:flutter/material.dart';

// TODO: Create CustomSpinner with AnimationController
// TODO: Implement rotation animation
// TODO: Add scale pulsing effect

class CustomSpinner extends StatefulWidget {
  const CustomSpinner({Key? key}) : super(key: key);

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize controller and animations
  }

  @override
  Widget build(BuildContext context) => Container();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: CustomSpinner()))));
