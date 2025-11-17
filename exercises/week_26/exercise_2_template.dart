/// Exercise 2: Authentication Guards - Protected Routes
/// Implement authentication-based route guards with GoRouter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO: Create AuthService to manage login state
// TODO: Implement redirect logic for protected routes
// TODO: Add login/logout functionality

class AuthService {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    // TODO: Implement login
  }

  Future<void> logout() async {
    // TODO: Implement logout
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          // TODO: Define public and protected routes
        ],
        redirect: (context, state) {
          // TODO: Implement redirect logic
          return null;
        },
      ),
    );
  }
}
