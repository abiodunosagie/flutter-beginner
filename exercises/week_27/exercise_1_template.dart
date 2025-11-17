/// Week 27, Exercise 1: Email/Password Authentication
///
/// BEGINNER LEVEL
///
/// Create a simple authentication app with email/password:
/// 1. Set up Firebase in your Flutter app
/// 2. Create sign up screen with email and password fields
/// 3. Create sign in screen
/// 4. Implement sign up functionality
/// 5. Implement sign in functionality
/// 6. Handle loading and error states
/// 7. Navigate to home screen on successful auth
///
/// Learning objectives:
/// - Initialize Firebase
/// - Use FirebaseAuth for authentication
/// - Handle async auth operations
/// - Manage auth state

import 'package:flutter/material.dart';
// TODO: Add firebase_core and firebase_auth to pubspec.yaml
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // TODO: Initialize Firebase
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(AuthApp());
}

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Auth',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TODO: Add controllers for email and password
  // TODO: Add state variables for loading and error message

  @override
  void dispose() {
    // TODO: Dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Show error message if exists

            // TODO: Add email TextField

            SizedBox(height: 16),

            // TODO: Add password TextField (obscureText: true)

            SizedBox(height: 24),

            // TODO: Show loading indicator when loading
            // TODO: Otherwise show Sign In and Sign Up buttons
          ],
        ),
      ),
    );
  }

  // TODO: Implement _signIn() method
  // - Set loading to true
  // - Try to sign in with FirebaseAuth.instance.signInWithEmailAndPassword()
  // - On success, navigate to HomeScreen
  // - On error, show error message
  // - Set loading to false

  // TODO: Implement _signUp() method
  // - Set loading to true
  // - Try to create user with FirebaseAuth.instance.createUserWithEmailAndPassword()
  // - On success, navigate to HomeScreen
  // - On error, show error message
  // - Set loading to false
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // TODO: Add sign out button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // TODO: Sign out and navigate back to login
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome! You are signed in.'),
      ),
    );
  }
}
