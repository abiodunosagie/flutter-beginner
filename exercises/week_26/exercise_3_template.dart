/// Exercise 3: Nested Navigation - Bottom Navigation with Tabs
/// Create app with bottom navigation and separate navigation stacks

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Implement ShellRoute for bottom navigation
// TODO: Create separate navigation stacks for each tab
// TODO: Maintain state when switching tabs

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          // TODO: Implement nested routes with ShellRoute
        ],
      ),
    );
  }
}
