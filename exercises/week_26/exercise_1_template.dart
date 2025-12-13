/// Exercise 1: GoRouter Basics - Multi-Screen App
/// Create a basic app with GoRouter navigation between 3+ screens

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Define routes for Home, Profile, Settings screens
// TODO: Implement navigation with context.go() and context.push()
// TODO: Add error/404 page handling

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'GoRouter Basics',
    );
  }

  static final _router = GoRouter(
    routes: [
      // TODO: Define routes
    ],
  );
}

void main() => runApp(MyApp());
