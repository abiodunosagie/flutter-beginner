# Authentication Guards & Redirects with GoRouter

## What You'll Learn

- Implementing authentication guards
- Redirecting based on auth state
- Protected routes
- Login flow with GoRouter
- Refresh listeners for auth changes
- Best practices for secure navigation

## Authentication Flow

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Simple auth service
class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}

// Router with auth guard
class AppRouter {
  final AuthService authService;

  AppRouter(this.authService);

  late final router = GoRouter(
    refreshListenable: authService,  // Listen to auth changes
    redirect: (context, state) {
      final isAuth = authService.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';

      // Redirect to login if not authenticated
      if (!isAuth && !isGoingToLogin) {
        return '/login';
      }

      // Redirect to home if authenticated and going to login
      if (isAuth && isGoingToLogin) {
        return '/';
      }

      return null;  // No redirect
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),
    ],
  );
}

// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);
    // GoRouter automatically redirects to home!
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              // Automatically redirects to login!
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push('/profile'),
          child: Text('Go to Profile'),
        ),
      ),
    );
  }
}
```

## Best Practices

✅ Use `refreshListenable` to react to auth changes
✅ Centralize redirect logic
✅ Handle loading states during auth
✅ Clear sensitive data on logout
✅ Test auth flows thoroughly

## Exercises

### Exercise 1: Basic Auth (Beginner)
Implement login/logout with route protection

### Exercise 2: Role-Based (Intermediate)
Different routes for admin vs user

### Exercise 3: Deep Link Auth (Advanced)
Handle deep links with auth requirements

## What's Next

You've mastered navigation and authentication with GoRouter! Moving to Firebase integration next! 🚀
