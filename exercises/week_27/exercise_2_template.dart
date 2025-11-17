/// Week 27, Exercise 2: Google Sign-In Integration
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Add Google Sign-In to your authentication app:
/// 1. Add google_sign_in package
/// 2. Configure Google Sign-In (Android & iOS)
/// 3. Create sign in with Google button
/// 4. Implement Google authentication flow
/// 5. Handle Google auth errors
/// 6. Sign out from both Firebase and Google
///
/// Learning objectives:
/// - Integrate Google Sign-In
/// - Handle OAuth flow
/// - Manage multiple auth providers

import 'package:flutter/material.dart';
// TODO: Add these packages to pubspec.yaml
// firebase_core: ^2.24.2
// firebase_auth: ^4.16.0
// google_sign_in: ^6.1.6

void main() async {
  // TODO: Initialize Firebase
  runApp(AuthApp());
}

class AuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Error message display

            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),

            if (_isLoading)
              CircularProgressIndicator()
            else
              Column(
                children: [
                  // TODO: Email sign in button

                  SizedBox(height: 16),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  SizedBox(height: 16),

                  // TODO: Add Google Sign-In button with Google logo
                  // Use OutlinedButton.icon with Google branding
                ],
              ),
          ],
        ),
      ),
    );
  }

  // TODO: Implement _signInWithGoogle() method
  // 1. Create GoogleSignIn instance
  // 2. Call signIn() to get GoogleSignInAccount
  // 3. Get authentication from GoogleSignInAccount
  // 4. Create Firebase credential with Google tokens
  // 5. Sign in to Firebase with credential
  // 6. Navigate to home screen
  // 7. Handle errors appropriately
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // TODO: Sign out from both Firebase AND Google
              // await FirebaseAuth.instance.signOut();
              // await GoogleSignIn().signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
