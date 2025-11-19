# Authentication Guards & Redirects with GoRouter

## Explain It Like I'm Five 🎉

Imagine you're having a birthday party at your house:

**The Bouncer at the Door:**
- Some rooms in your house are for everyone (the living room where you open presents)
- But your bedroom is ONLY for you - it's private!
- Your mom acts like a "bouncer" - she checks who can go where
- If your friend tries to go to your bedroom, she says "Sorry, that's private!"
- And she redirects them back to the living room

**In Apps:**
- Your app has some pages everyone can see (like the login page)
- But some pages are ONLY for logged-in users (like a dashboard)
- A "guard" checks if you're logged in before letting you see those pages
- If you're not logged in, it sends you back to the login page
- Once you log in, it remembers where you wanted to go and takes you there!

Think of authentication guards as security guards at a fancy club - they check your ID (login) before letting you in!

## What You'll Learn

- Understanding authentication guards and why they're critical
- Creating an authentication state management system
- Implementing redirect logic in GoRouter
- Protecting routes that require login
- Role-based access control (admin vs regular user)
- Remembering the intended destination after login
- Building a complete real-world authentication flow
- Security best practices for production apps
- Handling edge cases and error scenarios

## What Are Route Guards?

### The Concept

A **route guard** is a piece of code that runs BEFORE a route is displayed. It decides:
- ✅ "Yes, you can see this page"
- ❌ "No, you need to log in first"
- 🔄 "Redirect you somewhere else"

Think of it as a checkpoint at an airport - everyone has to go through security before boarding!

### Why We Need Them

**Without Guards:**
```dart
// Bad: Anyone can access any page!
GoRoute(
  path: '/admin-dashboard',
  builder: (context, state) => AdminDashboard(),
),
// Problem: Even non-admins can access the admin dashboard!
```

**With Guards:**
```dart
// Good: Check authentication first!
redirect: (context, state) {
  if (!isLoggedIn && goingToProtectedRoute) {
    return '/login'; // Stop! Go log in first
  }
  return null; // All good, proceed!
}
```

### Common Use Cases

1. **Login Required**: User must be authenticated
2. **Role-Based**: User must have specific permissions (admin, premium, etc.)
3. **Onboarding**: First-time users see tutorial
4. **Subscription**: Premium features need active subscription
5. **Age Verification**: Adult content requires age check

## Creating an Authentication State Notifier

### Code Example 1: Simple Auth Service

```dart
import 'package:flutter/material.dart';

/// A simple authentication service that manages login state
/// This extends ChangeNotifier so GoRouter can listen to changes
class AuthService extends ChangeNotifier {
  // Private variable to store authentication state
  bool _isAuthenticated = false;

  // Store the current user's information
  String? _userEmail;

  // Public getter - other classes can read but not modify directly
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;

  /// Simulate a login process
  /// In a real app, this would call an API
  Future<void> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // In real app: validate credentials with backend
    // For now, accept any non-empty email/password
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userEmail = email;

      // IMPORTANT: Notify all listeners (like GoRouter)
      // This triggers the router to re-evaluate redirects!
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  /// Log out the current user
  Future<void> logout() async {
    _isAuthenticated = false;
    _userEmail = null;

    // Notify listeners - router will redirect to login
    notifyListeners();
  }

  /// Check if a user is logged in
  /// Useful for conditional UI elements
  bool get hasUser => _userEmail != null;
}
```

### Code Example 2: Advanced Auth Service with Roles

```dart
import 'package:flutter/material.dart';

/// User roles in our app
enum UserRole {
  guest,      // Not logged in
  user,       // Regular user
  premium,    // Paid subscriber
  admin,      // Administrator
}

/// User data model
class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}

/// Advanced authentication service with role-based access
class AdvancedAuthService extends ChangeNotifier {
  AppUser? _currentUser;

  // Getter for current user
  AppUser? get currentUser => _currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  // Get user's role (returns guest if not logged in)
  UserRole get userRole => _currentUser?.role ?? UserRole.guest;

  // Check if user has specific role or higher
  bool hasRole(UserRole requiredRole) {
    if (!isAuthenticated) return false;

    // Role hierarchy: admin > premium > user > guest
    final roleValues = {
      UserRole.guest: 0,
      UserRole.user: 1,
      UserRole.premium: 2,
      UserRole.admin: 3,
    };

    return roleValues[userRole]! >= roleValues[requiredRole]!;
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Mock user creation based on email
    // In real app, this data comes from your backend
    _currentUser = AppUser(
      id: '123',
      email: email,
      name: email.split('@').first,
      // Admin if email contains 'admin', otherwise regular user
      role: email.contains('admin') ? UserRole.admin : UserRole.user,
    );

    notifyListeners();
  }

  /// Logout current user
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  /// Upgrade to premium (simulated)
  Future<void> upgradeToPremium() async {
    if (_currentUser == null) return;

    await Future.delayed(Duration(seconds: 1));

    _currentUser = AppUser(
      id: _currentUser!.id,
      email: _currentUser!.email,
      name: _currentUser!.name,
      role: UserRole.premium,
    );

    notifyListeners();
  }
}
```

## Implementing Redirect Logic in GoRouter

### Code Example 3: Basic Redirect

```dart
import 'package:go_router/go_router.dart';

/// Create router with authentication guard
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    // CRITICAL: Listen to auth changes
    // When authService calls notifyListeners(), router re-evaluates
    refreshListenable: authService,

    // This function runs BEFORE every navigation
    redirect: (BuildContext context, GoRouterState state) {
      // Get current auth status
      final isAuthenticated = authService.isAuthenticated;

      // Where is the user trying to go?
      final isGoingToLogin = state.matchedLocation == '/login';

      // GUARD LOGIC:

      // Case 1: Not logged in and NOT going to login page
      // -> Redirect to login
      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }

      // Case 2: Logged in but trying to visit login page
      // -> Redirect to home (already logged in!)
      if (isAuthenticated && isGoingToLogin) {
        return '/';
      }

      // Case 3: Everything is fine
      // -> Return null to allow navigation
      return null;
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
```

### Code Example 4: Advanced Redirect with Roles

```dart
import 'package:go_router/go_router.dart';

/// Router with role-based access control
GoRouter createAdvancedRouter(AdvancedAuthService authService) {
  return GoRouter(
    refreshListenable: authService,

    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final location = state.matchedLocation;

      // Define public routes (accessible to everyone)
      final publicRoutes = ['/login', '/signup', '/about'];
      final isPublicRoute = publicRoutes.contains(location);

      // Define admin-only routes
      final adminRoutes = ['/admin', '/admin/users', '/admin/settings'];
      final isAdminRoute = adminRoutes.any((route) => location.startsWith(route));

      // Define premium-only routes
      final premiumRoutes = ['/premium-features', '/analytics'];
      final isPremiumRoute = premiumRoutes.any((route) => location.startsWith(route));

      // GUARD LOGIC:

      // 1. Not authenticated and trying to access protected route
      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      // 2. Authenticated but trying to access login/signup
      if (isAuthenticated && (location == '/login' || location == '/signup')) {
        return '/';
      }

      // 3. Trying to access admin route without admin role
      if (isAdminRoute && !authService.hasRole(UserRole.admin)) {
        return '/unauthorized'; // Show "you don't have permission" page
      }

      // 4. Trying to access premium route without premium/admin role
      if (isPremiumRoute && !authService.hasRole(UserRole.premium)) {
        return '/upgrade'; // Show upgrade page
      }

      // All checks passed!
      return null;
    },

    routes: [
      // Public routes
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
      GoRoute(path: '/about', builder: (context, state) => AboutScreen()),

      // Protected routes
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),

      // Premium routes
      GoRoute(path: '/premium-features', builder: (context, state) => PremiumScreen()),
      GoRoute(path: '/analytics', builder: (context, state) => AnalyticsScreen()),

      // Admin routes
      GoRoute(path: '/admin', builder: (context, state) => AdminDashboard()),
      GoRoute(path: '/admin/users', builder: (context, state) => AdminUsersScreen()),

      // Error routes
      GoRoute(path: '/unauthorized', builder: (context, state) => UnauthorizedScreen()),
      GoRoute(path: '/upgrade', builder: (context, state) => UpgradeScreen()),
    ],
  );
}
```

## Remembering Intended Route After Login

One of the best UX practices is to remember where the user wanted to go!

### Code Example 5: Remember and Redirect

```dart
import 'package:go_router/go_router.dart';

/// Router that remembers where user wanted to go
GoRouter createSmartRouter(AuthService authService) {
  return GoRouter(
    refreshListenable: authService,

    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final location = state.matchedLocation;

      // Check if it's a public route
      final isPublicRoute = location == '/login' || location == '/signup';

      if (!isAuthenticated && !isPublicRoute) {
        // SMART PART: Save where they wanted to go!
        // We pass it as a query parameter to the login page
        return '/login?redirect=${Uri.encodeComponent(location)}';
      }

      if (isAuthenticated && location.startsWith('/login')) {
        // Check if there's a redirect parameter
        final redirect = state.uri.queryParameters['redirect'];

        // If yes, send them where they originally wanted to go!
        if (redirect != null) {
          return redirect;
        }

        // Otherwise, just go home
        return '/';
      }

      return null;
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
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
    ],
  );
}
```

## Complete Login/Logout Flow

### Code Example 6: Login Screen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo or title
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 32),

                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                Text(
                  'Please login to continue',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_errorMessage != null) SizedBox(height: 16),

                // Login button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                SizedBox(height: 16),

                // Helpful hint for demo
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Accounts:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('• admin@test.com - Admin user'),
                      Text('• user@test.com - Regular user'),
                      Text('• Any password works!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading
    setState(() => _isLoading = true);

    try {
      // Get auth service
      final authService = Provider.of<AdvancedAuthService>(
        context,
        listen: false,
      );

      // Attempt login
      await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Success! GoRouter will automatically redirect
      // No need to manually navigate - the router handles it!

    } catch (error) {
      // Show error message
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }
}
```

### Code Example 7: Home Screen with Logout

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user info
    final authService = Provider.of<AdvancedAuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User info card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.name ?? "User"}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text('Email: ${user?.email ?? "Unknown"}'),
                    SizedBox(height: 4),
                    Chip(
                      label: Text(user?.role.toString().split('.').last ?? 'Guest'),
                      backgroundColor: _getRoleColor(user?.role),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Navigation buttons
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => context.push('/profile'),
              icon: Icon(Icons.person),
              label: Text('View Profile'),
            ),
            SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () => context.push('/settings'),
              icon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
            SizedBox(height: 8),

            // Premium-only button
            if (authService.hasRole(UserRole.premium))
              ElevatedButton.icon(
                onPressed: () => context.push('/premium-features'),
                icon: Icon(Icons.star),
                label: Text('Premium Features'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
              ),
            SizedBox(height: 8),

            // Admin-only button
            if (authService.hasRole(UserRole.admin))
              ElevatedButton.icon(
                onPressed: () => context.push('/admin'),
                icon: Icon(Icons.admin_panel_settings),
                label: Text('Admin Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red.shade100;
      case UserRole.premium:
        return Colors.amber.shade100;
      case UserRole.user:
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Logout
      final authService = Provider.of<AdvancedAuthService>(
        context,
        listen: false,
      );
      await authService.logout();

      // GoRouter automatically redirects to login!
      // No manual navigation needed
    }
  }
}
```

## Real-World App with Protected Dashboard

### Code Example 8: Complete App Structure

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create auth service
    final authService = AdvancedAuthService();

    return ChangeNotifierProvider.value(
      value: authService,
      child: MaterialApp.router(
        title: 'Auth Guard Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        // Use GoRouter
        routerConfig: createAdvancedRouter(authService),
      ),
    );
  }
}
```

### Code Example 9: Protected Dashboard Screen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AdvancedAuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          // Show user avatar
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              child: Text(
                authService.currentUser?.name.substring(0, 1).toUpperCase() ?? '?',
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authService.currentUser?.name ?? 'User'),
              accountEmail: Text(authService.currentUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  authService.currentUser?.name.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => context.go('/'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => context.go('/profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => context.go('/settings'),
            ),
            Divider(),
            if (authService.hasRole(UserRole.admin))
              ListTile(
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Admin Panel'),
                onTap: () => context.go('/admin'),
              ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await authService.logout();
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildAnalytics();
      case 2:
        return _buildNotifications();
      default:
        return Container();
    }
  }

  Widget _buildOverview() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      children: [
        _buildStatCard('Total Users', '1,234', Icons.people, Colors.blue),
        _buildStatCard('Revenue', '\$12,345', Icons.attach_money, Colors.green),
        _buildStatCard('Active Sessions', '456', Icons.wifi, Colors.orange),
        _buildStatCard('Support Tickets', '23', Icons.help, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics() {
    return Center(
      child: Text('Analytics content here'),
    );
  }

  Widget _buildNotifications() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Icon(Icons.notifications)),
          title: Text('Notification ${index + 1}'),
          subtitle: Text('This is a sample notification'),
          trailing: Text('${index + 1}h ago'),
        );
      },
    );
  }
}
```

### Code Example 10: Admin-Only Screen

```dart
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Admin Area - Handle with care!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            ListTile(
              leading: Icon(Icons.people),
              title: Text('Manage Users'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/admin/users'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('System Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/admin/settings'),
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('View Reports'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/admin/reports'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Code Example 11: Unauthorized Screen

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Access Denied'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 120,
                color: Colors.red.shade300,
              ),
              SizedBox(height: 32),

              Text(
                'Access Denied',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              Text(
                'You don\'t have permission to access this page.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 8),

              Text(
                'Please contact an administrator if you believe this is an error.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: Icon(Icons.home),
                label: Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Best Practices and Security Considerations

### Security Best Practices

**1. Never Trust Client-Side Checks Alone**
```dart
// ❌ BAD: Client-side check only
if (isAdmin) {
  showAdminButton(); // Hackers can bypass this!
}

// ✅ GOOD: Also validate on backend
// Client: Hide UI for better UX
// Backend: Actually enforce the rule
```

**2. Use Secure Token Storage**
```dart
// ✅ Store tokens securely
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save token
await storage.write(key: 'auth_token', value: token);

// Read token
final token = await storage.read(key: 'auth_token');
```

**3. Implement Token Expiration**
```dart
class TokenManager {
  DateTime? _tokenExpiry;

  bool get isTokenValid {
    if (_tokenExpiry == null) return false;
    return DateTime.now().isBefore(_tokenExpiry!);
  }

  void saveToken(String token, int expiresInSeconds) {
    _tokenExpiry = DateTime.now().add(
      Duration(seconds: expiresInSeconds),
    );
    // Save token...
  }
}
```

**4. Clear Sensitive Data on Logout**
```dart
Future<void> logout() async {
  // Clear in-memory data
  _currentUser = null;

  // Clear secure storage
  await storage.deleteAll();

  // Clear any cached data
  await clearCache();

  // Notify listeners
  notifyListeners();
}
```

### Performance Best Practices

**1. Avoid Redundant Redirects**
```dart
// ✅ Return null when no redirect needed
redirect: (context, state) {
  if (shouldRedirect) {
    return '/new-location';
  }
  return null; // Important! Allows navigation to proceed
}
```

**2. Use refreshListenable Wisely**
```dart
// ✅ Only notify when auth state actually changes
void login() {
  final wasAuthenticated = _isAuthenticated;
  _isAuthenticated = true;

  if (wasAuthenticated != _isAuthenticated) {
    notifyListeners(); // Only notify on actual change
  }
}
```

**3. Minimize Redirect Logic Complexity**
```dart
// ✅ Keep redirect logic simple and fast
redirect: (context, state) {
  // Quick checks only
  // Avoid heavy computations or async operations
  return isAuthenticated ? null : '/login';
}
```

### UX Best Practices

**1. Show Loading States**
```dart
// ✅ Give feedback during authentication
if (_isLoading) {
  return CircularProgressIndicator();
}
```

**2. Preserve Navigation Intent**
```dart
// ✅ Remember where user wanted to go
'/login?redirect=/premium-features'
```

**3. Clear Error Messages**
```dart
// ✅ Helpful error messages
'Your session has expired. Please log in again.'

// ❌ Unhelpful
'Error 401'
```

## Common Pitfalls to Avoid

### Pitfall 1: Forgetting refreshListenable
```dart
// ❌ BAD: Router won't react to auth changes
GoRouter(
  redirect: (context, state) {
    return authService.isAuthenticated ? null : '/login';
  },
  // Missing refreshListenable!
);

// ✅ GOOD: Router reacts to changes
GoRouter(
  refreshListenable: authService, // Now it works!
  redirect: (context, state) {
    return authService.isAuthenticated ? null : '/login';
  },
);
```

### Pitfall 2: Infinite Redirect Loops
```dart
// ❌ BAD: Creates infinite loop!
redirect: (context, state) {
  if (!isAuthenticated) {
    return '/login'; // But what if we're already at /login?
  }
}

// ✅ GOOD: Check current location
redirect: (context, state) {
  if (!isAuthenticated && state.matchedLocation != '/login') {
    return '/login';
  }
  return null;
}
```

### Pitfall 3: Not Handling Edge Cases
```dart
// ✅ Handle all scenarios
redirect: (context, state) {
  final location = state.matchedLocation;

  // Scenario 1: Not logged in
  if (!isAuthenticated && !_isPublicRoute(location)) {
    return '/login';
  }

  // Scenario 2: Logged in but at login page
  if (isAuthenticated && location == '/login') {
    return '/';
  }

  // Scenario 3: Insufficient permissions
  if (_requiresAdmin(location) && !isAdmin) {
    return '/unauthorized';
  }

  // All good!
  return null;
}
```

## Testing Your Authentication Guards

```dart
// Example test
void main() {
  testWidgets('Redirects to login when not authenticated', (tester) async {
    final authService = AuthService();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: authService,
        child: MaterialApp.router(
          routerConfig: createRouter(authService),
        ),
      ),
    );

    // Should be on login page
    expect(find.text('Login'), findsOneWidget);

    // Login
    await authService.login('test@test.com', 'password');
    await tester.pumpAndSettle();

    // Should now be on home page
    expect(find.text('Home'), findsOneWidget);
  });
}
```

## Summary

You've learned how to:
- ✅ Understand authentication guards as security checkpoints
- ✅ Create authentication state management with ChangeNotifier
- ✅ Implement redirect logic in GoRouter
- ✅ Protect routes based on authentication status
- ✅ Add role-based access control
- ✅ Remember and restore intended navigation destination
- ✅ Build complete login/logout flows
- ✅ Create real-world protected dashboards
- ✅ Follow security and UX best practices
- ✅ Avoid common pitfalls and edge cases

Authentication guards are your app's security system - they ensure users only access what they're allowed to see!

## Exercises

### Exercise 1: Basic Auth (Beginner)
Create a simple app with:
- Login page (accept any email/password)
- Home page (protected)
- Profile page (protected)
- Logout functionality

### Exercise 2: Role-Based Access (Intermediate)
Extend Exercise 1 with:
- Three user roles: guest, user, admin
- Admin-only dashboard
- Premium-only features page
- Appropriate redirects for unauthorized access

### Exercise 3: Deep Link Auth (Advanced)
Build an app that:
- Handles deep links to protected routes
- Remembers the intended destination
- Redirects after successful login
- Shows appropriate errors for unauthorized deep links

## What's Next

Now that you've mastered authentication guards, you're ready to integrate real authentication services like Firebase Auth! 🚀

Next up: **Firebase Authentication Integration** where you'll learn to connect to a real backend!
