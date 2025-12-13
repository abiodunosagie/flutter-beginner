/// Week 32, Exercise 4: Riverpod Family and Caching
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Implement data caching with Riverpod family:
/// 1. Use family modifier for parameterized providers
/// 2. Implement caching strategy
/// 3. Handle cache invalidation
/// 4. Optimize provider rebuilds
///
/// Learning objectives:
/// - Riverpod family modifier
/// - Caching strategies
/// - Provider optimization

import 'package:flutter/material.dart';

void main() {
  runApp(CachingApp());
}

// TODO: Implement providers with family modifier
// TODO: Add caching logic
// TODO: Handle cache invalidation

class CachingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caching Demo',
      home: UserListScreen(),
    );
  }
}
