/// Exercise 5: Custom Route Transitions
/// Create custom animations for route transitions

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Implement custom page transitions
// TODO: Create slide, fade, scale transitions
// TODO: Add different transitions for different routes

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          // TODO: Use pageBuilder with CustomTransitionPage
        ],
      ),
    );
  }
}
