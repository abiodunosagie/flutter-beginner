/// ============================================================================
/// EXAMPLE 07: REAL-WORLD API APP - COMPLETE ARCHITECTURE
/// ============================================================================
///
/// This is THE MOST IMPORTANT example in API Integration!
/// It shows how professional Flutter apps actually work:
///
/// API → Model → Repository → Service/Controller → UI
///
/// We'll build a complete Users app that you can run and modify.
///
/// To run:
/// 1. Create a new Flutter project
/// 2. Add http package to pubspec.yaml: http: ^1.1.0
/// 3. Copy this file to lib/main.dart
/// 4. Run: flutter run
///
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// ============================================================================
/// STEP 1: UNDERSTANDING THE ARCHITECTURE
/// ============================================================================
///
/// Think of it like a restaurant:
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │                    RESTAURANT ANALOGY                                    │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │                                                                          │
/// │   CUSTOMER     WAITER      KITCHEN     SUPPLIER     FARM                │
/// │   (You)        (UI)        (Service)   (Repository) (API)               │
/// │                                                                          │
/// │   "I want      Takes       Prepares    Gets         Provides            │
/// │    pizza!"     order       food        ingredients  raw food            │
/// │                                                                          │
/// │                                                                          │
/// │   In Flutter:                                                            │
/// │                                                                          │
/// │   USER         WIDGET      CONTROLLER  REPOSITORY   API SERVER          │
/// │   (Taps        (Shows      (Manages    (Fetches &   (jsonplaceholder)   │
/// │    button)     data)       state)      parses)                          │
/// │                                                                          │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// WHY THIS SEPARATION?
/// 1. TESTABLE - Mock the repository, test the controller
/// 2. REUSABLE - Use same repository for different UIs
/// 3. MAINTAINABLE - Change API? Only update repository
/// 4. ORGANIZED - Each layer has ONE job
///

// ============================================================================
// STEP 2: DATA MODELS (What our data looks like)
// ============================================================================

/// A User in our app
///
/// JSON from API:
/// {
///   "id": 1,
///   "name": "Leanne Graham",
///   "username": "Bret",
///   "email": "Sincere@april.biz",
///   "phone": "1-770-736-8031 x56442",
///   "website": "hildegard.org"
/// }
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
  });

  /// Convert JSON Map → User Object
  ///
  /// This is called when we RECEIVE data from the API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      website: json['website'],
    );
  }

  /// Convert User Object → JSON Map
  ///
  /// This is called when we SEND data to the API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
    };
  }

  @override
  String toString() => 'User(id: $id, name: $name)';
}

// ============================================================================
// STEP 3: API CLIENT (Low-level HTTP calls)
// ============================================================================

/// Handles raw HTTP requests
///
/// This class knows HOW to make HTTP calls, but doesn't know
/// anything about Users or our business logic.
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │  ApiClient Responsibilities:                                             │
/// │  ✅ Make GET, POST, PUT, DELETE requests                                │
/// │  ✅ Handle HTTP headers                                                 │
/// │  ✅ Parse JSON                                                          │
/// │  ❌ Know about User model (that's Repository's job)                     │
/// │  ❌ Handle business logic (that's Controller's job)                     │
/// └─────────────────────────────────────────────────────────────────────────┘
class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({
    required this.baseUrl,
    http.Client? client,
  }) : httpClient = client ?? http.Client();

  /// GET request
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('📡 GET: $url');

    final response = await httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    return _handleResponse(response);
  }

  /// POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('📡 POST: $url');
    print('📦 Data: $data');

    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  /// PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('📡 PUT: $url');

    final response = await httpClient.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  /// DELETE request
  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('📡 DELETE: $url');

    final response = await httpClient.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException('Delete failed', response.statusCode);
    }
  }

  /// Handle response and errors
  dynamic _handleResponse(http.Response response) {
    print('✅ Status: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    }

    // Handle errors
    switch (response.statusCode) {
      case 400:
        throw ApiException('Bad request', response.statusCode);
      case 401:
        throw ApiException('Unauthorized - Please log in', response.statusCode);
      case 403:
        throw ApiException('Forbidden - No permission', response.statusCode);
      case 404:
        throw ApiException('Not found', response.statusCode);
      case 500:
        throw ApiException('Server error - Try later', response.statusCode);
      default:
        throw ApiException('Request failed', response.statusCode);
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

// ============================================================================
// STEP 4: REPOSITORY (Data access layer)
// ============================================================================

/// Repository handles all data operations for Users
///
/// The Repository is the "single source of truth" for User data.
/// It knows:
/// - HOW to get users from the API
/// - HOW to convert JSON to User objects
/// - HOW to cache data (optional)
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │  Repository Responsibilities:                                            │
/// │  ✅ Convert API responses to User models                                │
/// │  ✅ Provide clean interface for data access                             │
/// │  ✅ Could add caching, offline support, etc.                            │
/// │  ❌ Know about UI (that's Widget's job)                                 │
/// │  ❌ Manage app state (that's Controller's job)                          │
/// └─────────────────────────────────────────────────────────────────────────┘

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(int id);
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl({required this.apiClient});

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await apiClient.get('/users');

      // Convert List of JSON to List of Users
      final List<dynamic> jsonList = response as List<dynamic>;
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw RepositoryException('Failed to load users: $e');
    }
  }

  @override
  Future<User> getUser(int id) async {
    try {
      final response = await apiClient.get('/users/$id');
      return User.fromJson(response);
    } catch (e) {
      throw RepositoryException('Failed to load user: $e');
    }
  }

  @override
  Future<User> createUser(User user) async {
    try {
      final response = await apiClient.post('/users', user.toJson());
      return User.fromJson(response);
    } catch (e) {
      throw RepositoryException('Failed to create user: $e');
    }
  }

  @override
  Future<User> updateUser(User user) async {
    try {
      final response = await apiClient.put('/users/${user.id}', user.toJson());
      return User.fromJson(response);
    } catch (e) {
      throw RepositoryException('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await apiClient.delete('/users/$id');
    } catch (e) {
      throw RepositoryException('Failed to delete user: $e');
    }
  }
}

/// Custom exception for Repository errors
class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

// ============================================================================
// STEP 5: CONTROLLER (State management)
// ============================================================================

/// Controller manages the state and business logic
///
/// The Controller:
/// - Uses the Repository to get data
/// - Manages loading, error, and success states
/// - Notifies the UI when state changes
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │  Controller Responsibilities:                                            │
/// │  ✅ Call repository methods                                             │
/// │  ✅ Manage loading/error/success states                                 │
/// │  ✅ Notify UI of changes (via ChangeNotifier)                           │
/// │  ✅ Handle business logic (sorting, filtering, etc.)                    │
/// │  ❌ Know about HTTP (that's ApiClient's job)                            │
/// │  ❌ Build widgets (that's Widget's job)                                 │
/// └─────────────────────────────────────────────────────────────────────────┘

class UsersController extends ChangeNotifier {
  final UserRepository repository;

  UsersController({required this.repository});

  // State
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  User? _selectedUser;

  // Getters (read-only access to state)
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get selectedUser => _selectedUser;
  bool get hasError => _error != null;

  /// Load all users
  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();

    try {
      _users = await repository.getUsers();
      print('📋 Loaded ${_users.length} users');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Load single user details
  Future<void> loadUser(int id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedUser = await repository.getUser(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new user
  Future<bool> createUser(User user) async {
    _setLoading(true);
    _clearError();

    try {
      final createdUser = await repository.createUser(user);
      _users.insert(0, createdUser);  // Add to start of list
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing user
  Future<bool> updateUser(User user) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedUser = await repository.updateUser(user);

      // Update in list
      final index = _users.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        _users[index] = updatedUser;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete user
  Future<bool> deleteUser(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await repository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}

// ============================================================================
// STEP 6: DEPENDENCY INJECTION (Wiring it all together)
// ============================================================================

/// In a real app, you'd use GetIt or Provider for this.
/// Here we'll do it manually to show the concept.
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │  DEPENDENCY INJECTION = BUILDING WITH LEGOS                              │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │                                                                          │
/// │  Without DI (bad):                                                       │
/// │  class Controller {                                                      │
/// │    final repo = UserRepositoryImpl();  // Creates its own!              │
/// │  }                                                                       │
/// │  Problem: Can't swap repo for testing!                                  │
/// │                                                                          │
/// │  With DI (good):                                                         │
/// │  class Controller {                                                      │
/// │    final UserRepository repo;                                            │
/// │    Controller({required this.repo});  // Given from outside!            │
/// │  }                                                                       │
/// │  Benefit: Pass mock repo for testing!                                   │
/// │                                                                          │
/// └─────────────────────────────────────────────────────────────────────────┘

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Lazy singletons
  ApiClient? _apiClient;
  UserRepository? _userRepository;
  UsersController? _usersController;

  /// Get ApiClient (creates once, reuses)
  ApiClient get apiClient {
    _apiClient ??= ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    );
    return _apiClient!;
  }

  /// Get UserRepository
  UserRepository get userRepository {
    _userRepository ??= UserRepositoryImpl(apiClient: apiClient);
    return _userRepository!;
  }

  /// Get UsersController
  UsersController get usersController {
    _usersController ??= UsersController(repository: userRepository);
    return _usersController!;
  }

  /// Reset for testing
  void reset() {
    _apiClient = null;
    _userRepository = null;
    _usersController = null;
  }
}

// Global instance for easy access
final sl = ServiceLocator();

// ============================================================================
// STEP 7: UI WIDGETS
// ============================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-World API App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const UsersScreen(),
    );
  }
}

/// Main screen showing list of users
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Get controller from service locator
  final controller = sl.usersController;

  @override
  void initState() {
    super.initState();

    // Listen for changes
    controller.addListener(_onControllerChange);

    // Load data on start
    controller.loadUsers();
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {}); // Rebuild when controller changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadUsers,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }

  Widget _buildBody() {
    // Show loading
    if (controller.isLoading && controller.users.isEmpty) {
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

    // Show error
    if (controller.hasError && controller.users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                controller.error ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: controller.loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // Show empty state
    if (controller.users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No users found'),
          ],
        ),
      );
    }

    // Show users list
    return RefreshIndicator(
      onRefresh: controller.loadUsers,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          return UserListTile(
            user: user,
            onTap: () => _showUserDetails(user),
            onEdit: () => _showEditDialog(user),
            onDelete: () => _confirmDelete(user),
          );
        },
      ),
    );
  }

  void _showCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => UserFormSheet(
        onSubmit: (user) async {
          final success = await controller.createUser(user);
          if (success && mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User created!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditDialog(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => UserFormSheet(
        user: user,
        onSubmit: (updatedUser) async {
          final success = await controller.updateUser(updatedUser);
          if (success && mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User updated!'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(Icons.person, 'Username', user.username),
            _detailRow(Icons.email, 'Email', user.email),
            if (user.phone != null)
              _detailRow(Icons.phone, 'Phone', user.phone!),
            if (user.website != null)
              _detailRow(Icons.web, 'Website', user.website!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: $value'),
        ],
      ),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User?'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.deleteUser(user.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// List tile for a user
class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(user.name[0].toUpperCase()),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        onTap: onTap,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
        ),
      ),
    );
  }
}

/// Form for creating/editing users
class UserFormSheet extends StatefulWidget {
  final User? user;
  final Future<void> Function(User user) onSubmit;

  const UserFormSheet({
    super.key,
    this.user,
    required this.onSubmit,
  });

  @override
  State<UserFormSheet> createState() => _UserFormSheetState();
}

class _UserFormSheetState extends State<UserFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _usernameController = TextEditingController(text: widget.user?.username ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _websiteController = TextEditingController(text: widget.user?.website ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final user = User(
      id: widget.user?.id ?? 0,
      name: _nameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      website: _websiteController.text.isEmpty ? null : _websiteController.text,
    );

    await widget.onSubmit(user);

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.user == null ? 'Create User' : 'Edit User',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: (v) => v!.isEmpty ? 'Username is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.web),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.user == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// WHAT YOU LEARNED
// ============================================================================
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │  COMPLETE ARCHITECTURE FLOW:                                             │
// ├─────────────────────────────────────────────────────────────────────────┤
// │                                                                          │
// │  1. MODEL (User)                                                         │
// │     └── Defines data structure with fromJson/toJson                     │
// │                                                                          │
// │  2. API CLIENT                                                           │
// │     └── Makes HTTP requests (GET, POST, PUT, DELETE)                    │
// │     └── Handles errors and parsing                                      │
// │                                                                          │
// │  3. REPOSITORY                                                           │
// │     └── Uses ApiClient to fetch data                                    │
// │     └── Converts JSON to Models                                         │
// │     └── Provides clean interface                                        │
// │                                                                          │
// │  4. CONTROLLER                                                           │
// │     └── Uses Repository for data                                        │
// │     └── Manages loading/error/success states                            │
// │     └── Notifies UI of changes                                          │
// │                                                                          │
// │  5. SERVICE LOCATOR (DI)                                                 │
// │     └── Creates and provides dependencies                               │
// │     └── Makes testing possible                                          │
// │                                                                          │
// │  6. UI (Widgets)                                                         │
// │     └── Gets controller from service locator                            │
// │     └── Listens to controller changes                                   │
// │     └── Displays loading/error/data                                     │
// │                                                                          │
// │                                                                          │
// │  THE FLOW:                                                               │
// │  User Tap → Controller.loadUsers() → Repository.getUsers()              │
// │           → ApiClient.get('/users') → API Server                        │
// │           ← JSON Response ← Repository (converts to User)               │
// │           ← Controller (updates state) ← UI (rebuilds)                  │
// │                                                                          │
// └─────────────────────────────────────────────────────────────────────────┘
//
// ============================================================================
