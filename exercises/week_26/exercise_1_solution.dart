/// Exercise 1 Solution: GoRouter Basics - Multi-Screen App

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router, title: 'GoRouter Basics');
  }

  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', name: 'home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/profile/:userId', name: 'profile', builder: (context, state) => ProfileScreen(userId: state.pathParameters['userId']!)),
      GoRoute(path: '/settings', name: 'settings', builder: (context, state) => SettingsScreen()),
    ],
    errorBuilder: (context, state) => NotFoundScreen(),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => context.push('/profile/123'), child: Text('Go to Profile')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.push('/settings'), child: Text('Go to Settings')),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Profile')), body: Center(child: Text('User ID: $userId', style: TextStyle(fontSize: 24))));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Settings')), body: Center(child: Text('Settings Screen')));
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('404')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size: 80, color: Colors.red), Text('Page Not Found'), ElevatedButton(onPressed: () => context.go('/'), child: Text('Go Home'))])));
  }
}

void main() => runApp(MyApp());
