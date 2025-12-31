# Best Practices

Learn best practices for API integration including caching, offline support, retry logic, and more!

---

## Caching Strategies

### In-Memory Caching

```dart
class CachedUserRepository implements UserRepository {
  final UserRepository _repository;
  List<User>? _cachedUsers;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(minutes: 5);

  CachedUserRepository(this._repository);

  @override
  Future<List<User>> getUsers() async {
    // Check if cache is still valid
    if (_cachedUsers != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheDuration) {
        print('Returning cached users');
        return _cachedUsers!;
      }
    }

    // Fetch fresh data
    print('Fetching fresh users');
    _cachedUsers = await _repository.getUsers();
    _cacheTime = DateTime.now();
    return _cachedUsers!;
  }

  @override
  Future<User> getUser(int id) async {
    // Try to find in cache first
    if (_cachedUsers != null) {
      try {
        return _cachedUsers!.firstWhere((user) => user.id == id);
      } catch (e) {
        // Not in cache, fetch from repository
      }
    }

    return await _repository.getUser(id);
  }

  @override
  Future<User> createUser(User user) async {
    final newUser = await _repository.createUser(user);
    // Invalidate cache
    _cachedUsers = null;
    _cacheTime = null;
    return newUser;
  }

  @override
  Future<User> updateUser(int id, User user) async {
    final updated = await _repository.updateUser(id, user);
    // Invalidate cache
    _cachedUsers = null;
    _cacheTime = null;
    return updated;
  }

  @override
  Future<void> deleteUser(int id) async {
    await _repository.deleteUser(id);
    // Invalidate cache
    _cachedUsers = null;
    _cacheTime = null;
  }

  /// Manually clear cache
  void clearCache() {
    _cachedUsers = null;
    _cacheTime = null;
  }
}
```

### Persistent Caching (with shared_preferences)

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersistentCachedRepository implements UserRepository {
  final UserRepository _repository;
  static const String _cacheKey = 'users_cache';
  static const String _cacheTimeKey = 'users_cache_time';
  final Duration _cacheDuration = const Duration(hours: 1);

  PersistentCachedRepository(this._repository);

  @override
  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();

    // Check cache
    final cacheTimeStr = prefs.getString(_cacheTimeKey);
    if (cacheTimeStr != null) {
      final cacheTime = DateTime.parse(cacheTimeStr);
      final age = DateTime.now().difference(cacheTime);

      if (age < _cacheDuration) {
        final cachedJson = prefs.getString(_cacheKey);
        if (cachedJson != null) {
          final List<dynamic> jsonList = json.decode(cachedJson);
          return jsonList.map((json) => User.fromJson(json)).toList();
        }
      }
    }

    // Fetch fresh data
    final users = await _repository.getUsers();

    // Save to cache
    final jsonList = users.map((user) => user.toJson()).toList();
    await prefs.setString(_cacheKey, json.encode(jsonList));
    await prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());

    return users;
  }

  @override
  Future<User> getUser(int id) => _repository.getUser(id);

  @override
  Future<User> createUser(User user) async {
    final newUser = await _repository.createUser(user);
    await _clearCache();
    return newUser;
  }

  @override
  Future<User> updateUser(int id, User user) async {
    final updated = await _repository.updateUser(id, user);
    await _clearCache();
    return updated;
  }

  @override
  Future<void> deleteUser(int id) async {
    await _repository.deleteUser(id);
    await _clearCache();
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimeKey);
  }
}
```

---

## Retry Logic

### Automatic Retry with Exponential Backoff

```dart
class RetryableApiClient extends ApiClient {
  final int maxRetries;
  final Duration initialDelay;

  RetryableApiClient({
    required String baseUrl,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  }) : super(baseUrl: baseUrl);

  @override
  Future<dynamic> get(String endpoint) async {
    return _retryRequest(() => super.get(endpoint));
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    return _retryRequest(() => super.post(endpoint, data));
  }

  Future<T> _retryRequest<T>(Future<T> Function() request) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await request();
      } catch (e) {
        attempt++;

        if (attempt >= maxRetries) {
          // Max retries reached, throw the error
          rethrow;
        }

        // Check if error is retryable
        if (!_isRetryable(e)) {
          rethrow;
        }

        print('Retry attempt $attempt after ${delay.inSeconds}s...');
        await Future.delayed(delay);

        // Exponential backoff: double the delay each time
        delay *= 2;
      }
    }
  }

  bool _isRetryable(dynamic error) {
    // Retry on network errors or server errors (500+)
    if (error is ApiException) {
      return error.statusCode >= 500;
    }
    return true;  // Retry on other errors (like network timeouts)
  }
}
```

---

## Offline Support

### Check Connectivity

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineFirstRepository implements UserRepository {
  final UserRepository _remoteRepo;
  final UserRepository _localRepo;  // Local database repository

  OfflineFirstRepository({
    required UserRepository remoteRepo,
    required UserRepository localRepo,
  })  : _remoteRepo = remoteRepo,
        _localRepo = localRepo;

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<User>> getUsers() async {
    if (await _isOnline()) {
      try {
        // Fetch from remote and update local
        final users = await _remoteRepo.getUsers();
        await _saveToLocal(users);
        return users;
      } catch (e) {
        // Remote failed, fallback to local
        print('Remote failed, using local data');
        return await _localRepo.getUsers();
      }
    } else {
      // Offline, use local data
      return await _localRepo.getUsers();
    }
  }

  @override
  Future<User> createUser(User user) async {
    if (await _isOnline()) {
      return await _remoteRepo.createUser(user);
    } else {
      // Queue for later sync
      throw Exception('Cannot create user while offline');
    }
  }

  Future<void> _saveToLocal(List<User> users) async {
    // Save to local database
    for (var user in users) {
      await _localRepo.createUser(user);
    }
  }

  @override
  Future<User> getUser(int id) => _remoteRepo.getUser(id);

  @override
  Future<User> updateUser(int id, User user) => _remoteRepo.updateUser(id, user);

  @override
  Future<void> deleteUser(int id) => _remoteRepo.deleteUser(id);
}
```

---

## Error Handling Best Practices

### Structured Error Types

```dart
/// Base error class
abstract class AppError {
  final String message;
  AppError(this.message);
}

/// Network errors
class NetworkError extends AppError {
  NetworkError([String message = 'Network error occurred'])
      : super(message);
}

/// Server errors
class ServerError extends AppError {
  final int statusCode;
  ServerError(this.statusCode, [String? message])
      : super(message ?? 'Server error: $statusCode');
}

/// Parse errors
class ParseError extends AppError {
  ParseError([String message = 'Failed to parse data']) : super(message);
}

/// Not found errors
class NotFoundError extends AppError {
  NotFoundError([String message = 'Resource not found']) : super(message);
}

/// Unauthorized errors
class UnauthorizedError extends AppError {
  UnauthorizedError([String message = 'Unauthorized']) : super(message);
}
```

### Enhanced API Client with Error Types

```dart
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkError('Request timed out');
    } on SocketException {
      throw NetworkError('No internet connection');
    } catch (e) {
      throw NetworkError('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return json.decode(response.body);
        } catch (e) {
          throw ParseError('Failed to parse response');
        }
      case 401:
        throw UnauthorizedError();
      case 404:
        throw NotFoundError();
      case 500:
      case 502:
      case 503:
        throw ServerError(response.statusCode);
      default:
        throw ServerError(
          response.statusCode,
          'Unexpected error: ${response.statusCode}',
        );
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkError('Request timed out');
    } on SocketException {
      throw NetworkError('No internet connection');
    } catch (e) {
      if (e is AppError) rethrow;
      throw NetworkError('Network error: $e');
    }
  }
}
```

### User-Friendly Error Messages

```dart
class ErrorHandler {
  static String getUserMessage(dynamic error) {
    if (error is NetworkError) {
      return 'Unable to connect. Please check your internet connection.';
    } else if (error is ServerError) {
      return 'Server is having issues. Please try again later.';
    } else if (error is UnauthorizedError) {
      return 'You need to log in to continue.';
    } else if (error is NotFoundError) {
      return 'The requested item was not found.';
    } else if (error is ParseError) {
      return 'Something went wrong. Please try again.';
    } else {
      return 'An unexpected error occurred.';
    }
  }

  static void showErrorSnackbar(BuildContext context, dynamic error) {
    final message = getUserMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
```

---

## Request Debouncing

### Debounced Search

```dart
import 'dart:async';

class SearchController extends ChangeNotifier {
  final UserRepository repository;
  Timer? _debounce;

  SearchController({required this.repository});

  List<User> _results = [];
  bool _isSearching = false;
  String _query = '';

  List<User> get results => _results;
  bool get isSearching => _isSearching;
  String get query => _query;

  void search(String query) {
    _query = query;

    // Cancel previous timer
    _debounce?.cancel();

    if (query.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    // Wait 500ms before searching
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    _isSearching = true;
    notifyListeners();

    try {
      final allUsers = await repository.getUsers();
      _results = allUsers
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      _results = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
```

---

## API Versioning

### Version Headers

```dart
class VersionedApiClient extends ApiClient {
  final String apiVersion;

  VersionedApiClient({
    required String baseUrl,
    this.apiVersion = 'v1',
  }) : super(baseUrl: baseUrl);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'API-Version': apiVersion,
      };

  @override
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$apiVersion$endpoint');
    final response = await http.get(url, headers: _headers);
    return _handleResponse(response);
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$apiVersion$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }
}
```

---

## Authentication

### Token-Based Authentication

```dart
class AuthenticatedApiClient extends ApiClient {
  String? _token;

  AuthenticatedApiClient({required String baseUrl}) : super(baseUrl: baseUrl);

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  @override
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 401) {
      // Token expired or invalid
      _token = null;
      throw UnauthorizedError('Please log in again');
    }

    return _handleResponse(response);
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(data),
    );

    if (response.statusCode == 401) {
      _token = null;
      throw UnauthorizedError('Please log in again');
    }

    return _handleResponse(response);
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                 BEST PRACTICES SUMMARY                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   CACHING:                                                   │
│   ✓ In-memory caching for frequently accessed data           │
│   ✓ Persistent caching for offline support                   │
│   ✓ Cache invalidation on mutations                          │
│   ✓ TTL (Time To Live) for cache freshness                   │
│                                                              │
│   RETRY LOGIC:                                               │
│   ✓ Automatic retry for failed requests                      │
│   ✓ Exponential backoff to avoid overwhelming server         │
│   ✓ Max retry limit to prevent infinite loops                │
│   ✓ Only retry retryable errors (network, 5xx)               │
│                                                              │
│   OFFLINE SUPPORT:                                           │
│   ✓ Check connectivity before requests                       │
│   ✓ Fallback to local data when offline                      │
│   ✓ Queue mutations for later sync                           │
│   ✓ Show appropriate offline UI                              │
│                                                              │
│   ERROR HANDLING:                                            │
│   ✓ Use custom error types                                   │
│   ✓ Provide user-friendly error messages                     │
│   ✓ Handle timeouts and network errors                       │
│   ✓ Log errors for debugging                                 │
│                                                              │
│   OPTIMIZATION:                                              │
│   ✓ Debounce search and input requests                       │
│   ✓ Cancel in-flight requests when needed                    │
│   ✓ Use pagination for large datasets                        │
│   ✓ Implement request cancellation                           │
│                                                              │
│   SECURITY:                                                  │
│   ✓ Use HTTPS for all requests                               │
│   ✓ Implement authentication (tokens)                        │
│   ✓ Never log sensitive data                                 │
│   ✓ Validate and sanitize all inputs                         │
│                                                              │
│   API DESIGN:                                                │
│   ✓ Version your API                                         │
│   ✓ Use consistent error formats                             │
│   ✓ Implement proper HTTP status codes                       │
│   ✓ Document all endpoints                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** Why do we use caching?

<details>
<summary>Answer</summary>

Caching improves app performance and user experience by:
- Reducing network requests (faster load times)
- Reducing server load
- Enabling offline functionality
- Reducing data usage
</details>

**Q2:** What is exponential backoff?

<details>
<summary>Answer</summary>

Exponential backoff is a retry strategy where the wait time between retries doubles each time:
- 1st retry: wait 1 second
- 2nd retry: wait 2 seconds
- 3rd retry: wait 4 seconds
- 4th retry: wait 8 seconds

This prevents overwhelming the server with rapid retries.
</details>

**Q3:** Why should we debounce search requests?

<details>
<summary>Answer</summary>

Debouncing prevents making a request on every keystroke. Instead, we wait until the user stops typing (e.g., 500ms) before making the request. This:
- Reduces unnecessary API calls
- Improves performance
- Reduces server load
- Saves user's data
</details>

---

---

## Navigation

⬅️ **Previous:** [Service Layer](09b-ServiceLayer.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
