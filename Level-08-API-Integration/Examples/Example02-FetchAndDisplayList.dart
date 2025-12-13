/// Example 02: Fetch and Display List in Flutter
///
/// This example shows how to fetch a list of items from an API
/// and display them in a Flutter ListView with proper loading states.
///
/// To run: flutter run -t lib/main.dart (after copying to a Flutter project)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ═══════════════════════════════════════════════════════════════════════════
// WHAT THIS EXAMPLE COVERS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Fetching a list from an API
// 2. Displaying loading state
// 3. Handling errors gracefully
// 4. Showing data in a ListView
// 5. Pull-to-refresh functionality
//
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API List Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UsersListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// USERS LIST SCREEN
// ═══════════════════════════════════════════════════════════════════════════
//
// Visual Flow:
// ┌─────────────────────────────────────────────────────────────┐
// │                                                             │
// │  STATE 1: Loading        STATE 2: Data        STATE 3: Error
// │  ┌─────────────┐        ┌─────────────┐      ┌─────────────┐
// │  │             │        │ ✓ John      │      │ ❌ Error     │
// │  │    ⏳       │   →    │ ✓ Jane      │ OR   │ [Retry]     │
// │  │  Loading    │        │ ✓ Bob       │      │             │
// │  │             │        │ ...         │      │             │
// │  └─────────────┘        └─────────────┘      └─────────────┘
// │                                                             │
// └─────────────────────────────────────────────────────────────┘

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  // State variables for the three states
  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  /// Fetches users from the API
  Future<void> _loadUsers() async {
    // Set loading state
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Make API call
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      // Check response
      if (response.statusCode == 200) {
        // Parse and store data
        setState(() {
          _users = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users (${response.statusCode})');
      }
    } catch (e) {
      // Handle error
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Refresh button in app bar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  /// Builds the appropriate widget based on current state
  Widget _buildBody() {
    // STATE 1: Loading
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading users...'),
          ],
        ),
      );
    }

    // STATE 3: Error
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // STATE 2: Success - Show list with pull-to-refresh
    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: _users.isEmpty
          ? const Center(child: Text('No users found'))
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return UserListTile(user: user);
              },
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// USER LIST TILE WIDGET
// ═══════════════════════════════════════════════════════════════════════════
//
// A single user item in the list:
// ┌─────────────────────────────────────────────────────────────┐
// │ ┌────┐                                                  > │
// │ │ JD │  John Doe                                          │
// │ └────┘  john@example.com                                   │
// └─────────────────────────────────────────────────────────────┘

class UserListTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            _getInitials(user['name']),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email']),
            Text(
              user['company']['name'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          _showUserDetails(context, user);
        },
      ),
    );
  }

  /// Gets initials from a name (e.g., "John Doe" → "JD")
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isNotEmpty ? name[0] : '?';
  }

  /// Shows user details in a bottom sheet
  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.person, 'Username', user['username']),
              _buildDetailRow(Icons.email, 'Email', user['email']),
              _buildDetailRow(Icons.phone, 'Phone', user['phone']),
              _buildDetailRow(Icons.web, 'Website', user['website']),
              _buildDetailRow(
                Icons.location_city,
                'City',
                user['address']['city'],
              ),
              _buildDetailRow(
                Icons.business,
                'Company',
                user['company']['name'],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// Builds a detail row with icon, label, and value
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY TAKEAWAYS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Always handle THREE states: Loading, Success, Error
//
// 2. Use setState() to trigger UI updates when:
//    - Starting to load (_isLoading = true)
//    - Data received (_users = data, _isLoading = false)
//    - Error occurred (_error = message, _isLoading = false)
//
// 3. Use RefreshIndicator for pull-to-refresh functionality
//
// 4. Show meaningful error messages with retry option
//
// 5. Extract reusable widgets (like UserListTile) for cleaner code
//
// 6. Use Card + ListTile for consistent list item styling
//
// ═══════════════════════════════════════════════════════════════════════════
