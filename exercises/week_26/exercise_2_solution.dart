/// Exercise 2 Solution: Authentication Guards - Protected Routes

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    await Future.delayed(Duration(seconds: 1));
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        refreshListenable: authService,
        routes: [
          GoRoute(path: '/', name: 'home', builder: (context, state) => HomeScreen(authService: authService)),
          GoRoute(path: '/login', name: 'login', builder: (context, state) => LoginScreen(authService: authService)),
          GoRoute(path: '/dashboard', name: 'dashboard', builder: (context, state) => DashboardScreen(authService: authService)),
        ],
        redirect: (context, state) {
          final isLoggedIn = authService.isLoggedIn;
          final isLoggingIn = state.matchedLocation == '/login';

          if (!isLoggedIn && !isLoggingIn) return '/login';
          if (isLoggedIn && isLoggingIn) return '/dashboard';
          return null;
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final AuthService authService;
  const LoginScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authService.login();
            context.go('/dashboard');
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final AuthService authService;
  const DashboardScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), actions: [IconButton(icon: Icon(Icons.logout), onPressed: () async {await authService.logout(); context.go('/');})]),
      body: Center(child: Text('Protected Dashboard', style: TextStyle(fontSize: 24))),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AuthService authService;
  const HomeScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Home')), body: Center(child: Text('Public Home Screen')));
  }
}

void main() => runApp(MyApp());
