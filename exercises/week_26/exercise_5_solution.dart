/// Exercise 5 Solution: Custom Route Transitions

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }

  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
      GoRoute(
        path: '/slide',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: SlideScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/fade',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: FadeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/scale',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ScaleScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        ),
      ),
    ],
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Transitions')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => context.push('/slide'), child: Text('Slide Transition')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.push('/fade'), child: Text('Fade Transition')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.push('/scale'), child: Text('Scale Transition')),
          ],
        ),
      ),
    );
  }
}

class SlideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Slide')), body: Center(child: Text('Slide Transition', style: TextStyle(fontSize: 24))));
}

class FadeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Fade')), body: Center(child: Text('Fade Transition', style: TextStyle(fontSize: 24))));
}

class ScaleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Scale')), body: Center(child: Text('Scale Transition', style: TextStyle(fontSize: 24))));
}

void main() => runApp(MyApp());
