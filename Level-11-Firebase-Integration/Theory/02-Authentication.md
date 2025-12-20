# Firebase Authentication: User Login & Signup

## The Simple Explanation

Authentication is like a bouncer at a club:
- **Sign Up:** Get your name on the list
- **Log In:** Show your ID to get in
- **Log Out:** Leave the club
- **Password Reset:** Forgot your ID? Get a new one!

```
┌─────────────────────────────────────────────────────────┐
│                 AUTHENTICATION FLOW                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│   New User                    Returning User            │
│      │                             │                     │
│      ▼                             ▼                     │
│  ┌────────┐                  ┌────────┐                 │
│  │Sign Up │                  │Log In  │                 │
│  └───┬────┘                  └───┬────┘                 │
│      │                           │                       │
│      ▼                           ▼                       │
│  Firebase creates            Firebase checks            │
│  new account                 credentials                 │
│      │                           │                       │
│      └─────────┬─────────────────┘                       │
│                ▼                                         │
│         ┌─────────────┐                                  │
│         │  Main App   │                                  │
│         └─────────────┘                                  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Enable Authentication in Firebase

### Step 1: Go to Firebase Console

1. Open your project in Firebase Console
2. Click **Authentication** in the left menu
3. Click **Get Started**
4. Under **Sign-in method**, enable **Email/Password**

```
┌─────────────────────────────────────────────────────────┐
│             Authentication > Sign-in method              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Provider              Status                            │
│  ─────────────────────────────────────                  │
│  ✓ Email/Password      Enabled    ← Turn this on        │
│  ○ Google              Disabled                          │
│  ○ Facebook            Disabled                          │
│  ○ Apple               Disabled                          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Basic Auth Operations

### 1. Sign Up (Create Account)

```dart
import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> signUp(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User created: ${credential.user?.email}');
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('Password is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('Account already exists for this email');
    }
    return null;
  }
}
```

### 2. Log In (Sign In)

```dart
Future<UserCredential?> logIn(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('Logged in: ${credential.user?.email}');
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found with this email');
    } else if (e.code == 'wrong-password') {
      print('Wrong password');
    }
    return null;
  }
}
```

### 3. Log Out (Sign Out)

```dart
Future<void> logOut() async {
  await FirebaseAuth.instance.signOut();
  print('Logged out!');
}
```

### 4. Password Reset

```dart
Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    print('Password reset email sent!');
  } on FirebaseAuthException catch (e) {
    print('Error: ${e.message}');
  }
}
```

---

## Check Current User

```dart
// Get current user (null if not logged in)
User? currentUser = FirebaseAuth.instance.currentUser;

if (currentUser != null) {
  print('User is logged in: ${currentUser.email}');
} else {
  print('No user logged in');
}
```

---

## Listen to Auth State

This is the most important concept! Use this to show different screens:

```dart
// In your main app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          // User is logged in
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          // User is NOT logged in
          return const LoginScreen();
        },
      ),
    );
  }
}
```

```
AUTH STATE FLOW:

App Starts
    │
    ▼
┌─────────────────┐
│ Check Auth State│
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
 Logged In   Not Logged In
    │         │
    ▼         ▼
HomeScreen   LoginScreen
```

---

## Complete Auth Service

```dart
// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success, no error
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    }
  }

  // Log in
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    }
  }

  // Log out
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e.code);
    }
  }

  // Convert error codes to friendly messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak (min 6 characters)';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'An error occurred. Please try again';
    }
  }
}
```

---

## Login Screen Example

```dart
// screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isLogin = true; // true = login, false = signup
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    String? error;

    if (_isLogin) {
      error = await _authService.logIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      error = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }

    setState(() {
      _isLoading = false;
      _error = error;
    });

    // If no error, auth state will change automatically
    // and StreamBuilder will show HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo or title
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isLogin ? 'Welcome Back!' : 'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),

                  // Error message
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_error!)),
                        ],
                      ),
                    ),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isLogin && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isLogin ? 'Log In' : 'Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle login/signup
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _error = null;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Sign Up"
                          : 'Already have an account? Log In',
                    ),
                  ),

                  // Forgot password (only in login mode)
                  if (_isLogin)
                    TextButton(
                      onPressed: () {
                        // Show forgot password dialog
                        _showForgotPasswordDialog();
                      },
                      child: const Text('Forgot Password?'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final error = await _authService.resetPassword(
                emailController.text.trim(),
              );
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error ?? 'Password reset email sent!',
                    ),
                  ),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
```

---

## User Properties

Once logged in, you can access user information:

```dart
User? user = FirebaseAuth.instance.currentUser;

if (user != null) {
  String? email = user.email;
  String uid = user.uid;           // Unique user ID
  bool verified = user.emailVerified;
  String? photoURL = user.photoURL;
  String? displayName = user.displayName;
}
```

### Update User Profile

```dart
// Update display name
await user.updateDisplayName('John Doe');

// Update photo URL
await user.updatePhotoURL('https://example.com/photo.jpg');

// Send email verification
await user.sendEmailVerification();
```

---

## Auth Error Codes Reference

```
┌─────────────────────────────────────────────────────────┐
│              COMMON AUTH ERROR CODES                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  SIGN UP ERRORS:                                         │
│  ├── weak-password       (< 6 characters)               │
│  ├── email-already-in-use (account exists)              │
│  └── invalid-email       (bad format)                   │
│                                                          │
│  LOG IN ERRORS:                                          │
│  ├── user-not-found      (no account)                   │
│  ├── wrong-password      (incorrect password)           │
│  ├── user-disabled       (account disabled)             │
│  └── too-many-requests   (rate limited)                 │
│                                                          │
│  OTHER ERRORS:                                           │
│  ├── network-request-failed (no internet)               │
│  └── operation-not-allowed (method not enabled)         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│             AUTHENTICATION SUMMARY                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  SIGN UP                                                 │
│  FirebaseAuth.instance.createUserWithEmailAndPassword() │
│                                                          │
│  LOG IN                                                  │
│  FirebaseAuth.instance.signInWithEmailAndPassword()     │
│                                                          │
│  LOG OUT                                                 │
│  FirebaseAuth.instance.signOut()                        │
│                                                          │
│  CHECK USER                                              │
│  FirebaseAuth.instance.currentUser                      │
│                                                          │
│  LISTEN TO CHANGES                                       │
│  FirebaseAuth.instance.authStateChanges()               │
│                                                          │
│  KEY POINT:                                              │
│  Use authStateChanges() to show login vs main screens   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Next:** `03-CloudFirestore.md` - Storing data in the cloud
