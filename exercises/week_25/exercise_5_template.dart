/// Exercise 5: Staggered Animations - List Item Reveal
/// Create staggered entrance animations for list items

import 'package:flutter/material.dart';

// TODO: Create StaggeredList widget
// TODO: Implement sequential item animations
// TODO: Add slide + fade effects for each item

class StaggeredList extends StatefulWidget {
  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    // TODO: Create staggered animations
  }

  @override
  Widget build(BuildContext context) => Container();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(body: StaggeredList())));
