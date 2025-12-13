/// Exercise 4: Deep Linking - Handle Web URLs
/// Implement deep linking to handle external URLs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Create routes that handle URL parameters
// TODO: Implement query parameter parsing
// TODO: Add deep link testing

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          // TODO: Define routes with parameters
          // Example: /products/:id?category=electronics&sort=price
        ],
      ),
    );
  }
}
