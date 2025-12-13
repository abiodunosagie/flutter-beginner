# Error Handling for API Calls

Learn how to gracefully handle errors when things go wrong with network requests!

---

## Why Error Handling Matters

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│              WHY ERROR HANDLING MATTERS                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Imagine ordering food online:                              │
│                                                             │
│  WITHOUT Error Handling:                                    │
│  ┌────────────────────────────────────────┐                │
│  │ "Order failed"                          │                │
│  │                                         │                │
│  │ [???]                                   │                │
│  │                                         │                │
│  │ What happened? Is it my fault?          │                │
│  │ Should I try again?                     │                │
│  └────────────────────────────────────────┘                │
│                                                             │
│  WITH Good Error Handling:                                  │
│  ┌────────────────────────────────────────┐                │
│  │ "Payment failed - Card declined"        │                │
│  │                                         │                │
│  │ Your card couldn't be charged.          │                │
│  │ Please check your card details.         │                │
│  │                                         │                │
│  │ [Try Different Card] [Cancel Order]     │                │
│  └────────────────────────────────────────┘                │
│                                                             │
│  Users need to know: WHAT happened and WHAT to do next!     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Types of API Errors

```
┌─────────────────────────────────────────────────────────────┐
│                    TYPES OF ERRORS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. NETWORK ERRORS (Can't reach server)                     │
│     • No internet connection                                │
│     • Server is down                                        │
│     • Timeout (took too long)                               │
│                                                             │
│  2. CLIENT ERRORS (4xx - Our fault)                         │
│     • 400 Bad Request - Invalid data                        │
│     • 401 Unauthorized - Not logged in                      │
│     • 403 Forbidden - No permission                         │
│     • 404 Not Found - Resource doesn't exist                │
│     • 422 Validation Error - Invalid input                  │
│                                                             │
│  3. SERVER ERRORS (5xx - Their fault)                       │
│     • 500 Internal Server Error - Server broke              │
│     • 502 Bad Gateway - Server communication issue          │
│     • 503 Service Unavailable - Server overloaded           │
│                                                             │
│  4. PARSING ERRORS (Bad data)                               │
│     • Invalid JSON format                                   │
│     • Missing expected fields                               │
│     • Wrong data types                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic Error Handling with http Package

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<List<dynamic>> fetchUsers() async {
  try {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    // Check status code
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else if (response.statusCode == 404) {
      throw Exception('Users not found');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error - Please try again later');
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  } on SocketException {
    // No internet
    throw Exception('No internet connection');
  } on HttpException {
    // HTTP error
    throw Exception('HTTP error occurred');
  } on FormatException {
    // JSON parsing error
    throw Exception('Invalid response format');
  } catch (e) {
    // Any other error
    throw Exception('Something went wrong: $e');
  }
}
```

---

## Creating Custom Exception Classes

```dart
// Define custom exceptions for different error types
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([String message = 'Network error occurred'])
      : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized - Please login'])
      : super(message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'Resource not found'])
      : super(message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException([String message = 'Server error - Try again later'])
      : super(message, statusCode: 500);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException({
    String message = 'Validation failed',
    this.errors,
  }) : super(message, statusCode: 422);
}
```

### Visual: Exception Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                 EXCEPTION HIERARCHY                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Exception (Dart built-in)                                  │
│      │                                                      │
│      └── ApiException (our base class)                      │
│              │                                              │
│              ├── NetworkException                           │
│              │      • No internet                           │
│              │      • Timeout                               │
│              │                                              │
│              ├── UnauthorizedException (401)                │
│              │      • Not logged in                         │
│              │      • Token expired                         │
│              │                                              │
│              ├── NotFoundException (404)                    │
│              │      • Resource doesn't exist                │
│              │                                              │
│              ├── ValidationException (422)                  │
│              │      • Invalid form data                     │
│              │      • Missing fields                        │
│              │                                              │
│              └── ServerException (500)                      │
│                     • Server crashed                        │
│                     • Database error                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Smart Error Handling Service

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Generic request handler with error handling
  Future<T> _handleRequest<T>(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      return _handleResponse<T>(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException catch (e) {
      throw NetworkException('HTTP error: ${e.message}');
    } on FormatException {
      throw ApiException('Invalid response format');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  // Handle response based on status code
  T _handleResponse<T>(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return json.decode(response.body) as T;
        } catch (e) {
          throw ApiException('Failed to parse response');
        }

      case 204:
        return null as T;  // No content

      case 400:
        throw ApiException(_getErrorMessage(response) ?? 'Bad request');

      case 401:
        throw UnauthorizedException(_getErrorMessage(response));

      case 403:
        throw ApiException('Access denied');

      case 404:
        throw NotFoundException(_getErrorMessage(response));

      case 422:
        final errors = _getValidationErrors(response);
        throw ValidationException(errors: errors);

      case 500:
      case 502:
      case 503:
        throw ServerException();

      default:
        throw ApiException('Request failed: ${response.statusCode}');
    }
  }

  // Extract error message from response body
  String? _getErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? body['error'];
    } catch (e) {
      return null;
    }
  }

  // Extract validation errors
  Map<String, dynamic>? _getValidationErrors(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['errors'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // GET request
  Future<T> get<T>(String path) async {
    return _handleRequest<T>(() async {
      return http.get(Uri.parse('$baseUrl$path'));
    });
  }

  // POST request
  Future<T> post<T>(String path, Map<String, dynamic> data) async {
    return _handleRequest<T>(() async {
      return http.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
    });
  }
}
```

---

## Using Error Handling in Widgets

```dart
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService _api = ApiService(baseUrl: 'https://api.example.com');

  List<dynamic> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _api.get<List<dynamic>>('/users');
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } on NetworkException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
      _showRetrySnackBar();
    } on UnauthorizedException {
      // Navigate to login
      Navigator.of(context).pushReplacementNamed('/login');
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    }
  }

  void _showRetrySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load users'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _loadUsers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    return _buildUsersList();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(_errorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadUsers,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text(user['email']),
        );
      },
    );
  }
}
```

---

## Error Handling with Dio

```dart
import 'package:dio/dio.dart';

class DioApiService {
  late final Dio _dio;

  DioApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Add error interceptor
    _dio.interceptors.add(ErrorInterceptor());
  }

  Future<T> get<T>(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');

      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      case DioExceptionType.cancel:
        return ApiException('Request cancelled');

      default:
        return ApiException('Network error occurred');
    }
  }

  ApiException _handleBadResponse(Response? response) {
    if (response == null) {
      return ApiException('No response from server');
    }

    switch (response.statusCode) {
      case 401:
        return UnauthorizedException();
      case 404:
        return NotFoundException();
      case 422:
        return ValidationException(errors: response.data['errors']);
      case 500:
        return ServerException();
      default:
        return ApiException('Error: ${response.statusCode}');
    }
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error for debugging
    print('API ERROR: ${err.type} - ${err.message}');
    print('URL: ${err.requestOptions.uri}');
    print('Response: ${err.response?.data}');

    // Continue with the error
    handler.next(err);
  }
}
```

---

## User-Friendly Error Messages

```dart
class ErrorMessages {
  static String forException(ApiException e) {
    if (e is NetworkException) {
      return 'Unable to connect. Please check your internet connection and try again.';
    }
    if (e is UnauthorizedException) {
      return 'Your session has expired. Please log in again.';
    }
    if (e is NotFoundException) {
      return 'The requested item could not be found.';
    }
    if (e is ServerException) {
      return 'Our servers are having issues. Please try again in a few minutes.';
    }
    if (e is ValidationException) {
      return 'Please check your input and try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  static IconData iconForException(ApiException e) {
    if (e is NetworkException) return Icons.wifi_off;
    if (e is UnauthorizedException) return Icons.lock;
    if (e is NotFoundException) return Icons.search_off;
    if (e is ServerException) return Icons.cloud_off;
    return Icons.error_outline;
  }
}
```

### Visual: User-Friendly Messages

```
┌─────────────────────────────────────────────────────────────┐
│              USER-FRIENDLY ERROR MESSAGES                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DEVELOPER ERROR          USER-FRIENDLY MESSAGE             │
│  ─────────────────────────────────────────────────────────  │
│  SocketException          "Check your internet connection"  │
│  401 Unauthorized         "Please log in again"             │
│  404 Not Found            "This item no longer exists"      │
│  500 Server Error         "Try again in a few minutes"      │
│  FormatException          "Something went wrong"            │
│                                                             │
│  GOOD ERROR MESSAGES:                                       │
│  ✓ Tell what happened                                       │
│  ✓ Are specific                                             │
│  ✓ Suggest what to do next                                  │
│  ✓ Don't show technical details                             │
│                                                             │
│  BAD: "Error 500: Internal Server Error"                    │
│  GOOD: "We're having technical difficulties. Try again."    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Retry Logic

```dart
Future<T> fetchWithRetry<T>({
  required Future<T> Function() request,
  int maxRetries = 3,
  Duration delay = const Duration(seconds: 2),
}) async {
  int attempts = 0;

  while (attempts < maxRetries) {
    try {
      return await request();
    } on NetworkException {
      attempts++;
      if (attempts >= maxRetries) {
        rethrow;
      }
      print('Retry attempt $attempts of $maxRetries');
      await Future.delayed(delay * attempts);  // Exponential backoff
    } on ServerException {
      attempts++;
      if (attempts >= maxRetries) {
        rethrow;
      }
      await Future.delayed(delay * attempts);
    } catch (e) {
      rethrow;  // Don't retry other errors
    }
  }

  throw ApiException('Max retries exceeded');
}

// Usage
Future<void> loadData() async {
  final users = await fetchWithRetry(
    request: () => api.get<List<dynamic>>('/users'),
    maxRetries: 3,
  );
}
```

### Visual: Retry Logic

```
┌─────────────────────────────────────────────────────────────┐
│                    RETRY LOGIC                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Request #1                                                 │
│      │                                                      │
│      ▼                                                      │
│  ┌─────────┐    FAIL                                        │
│  │ Server  │ ─────────→ Wait 2 seconds                      │
│  └─────────┘                │                               │
│                             ▼                               │
│  Request #2                                                 │
│      │                                                      │
│      ▼                                                      │
│  ┌─────────┐    FAIL                                        │
│  │ Server  │ ─────────→ Wait 4 seconds (exponential)        │
│  └─────────┘                │                               │
│                             ▼                               │
│  Request #3                                                 │
│      │                                                      │
│      ▼                                                      │
│  ┌─────────┐    SUCCESS!                                    │
│  │ Server  │ ─────────→ Return data                         │
│  └─────────┘                                                │
│                                                             │
│  EXPONENTIAL BACKOFF:                                       │
│  Retry 1: 2 seconds                                         │
│  Retry 2: 4 seconds                                         │
│  Retry 3: 8 seconds                                         │
│  (Gives server time to recover)                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Error Handling Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│              ERROR HANDLING BEST PRACTICES                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DO:                                                        │
│  ✓ Create custom exception classes                          │
│  ✓ Show user-friendly messages                              │
│  ✓ Log errors for debugging                                 │
│  ✓ Provide retry options for network errors                 │
│  ✓ Handle 401 by redirecting to login                       │
│  ✓ Show specific actions users can take                     │
│                                                             │
│  DON'T:                                                     │
│  ✗ Show raw error messages to users                         │
│  ✗ Ignore errors (catch but do nothing)                     │
│  ✗ Retry non-recoverable errors                             │
│  ✗ Leave users stuck with no options                        │
│  ✗ Crash the app on errors                                  │
│                                                             │
│  ALWAYS ASK: "What should the user do now?"                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              ERROR HANDLING CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TRY-CATCH PATTERN:                                         │
│  try {                                                      │
│    final data = await api.get('/users');                    │
│  } on NetworkException catch (e) {                          │
│    // Handle network errors                                 │
│  } on UnauthorizedException {                               │
│    // Redirect to login                                     │
│  } on ApiException catch (e) {                              │
│    // Handle other API errors                               │
│  }                                                          │
│                                                             │
│  STATUS CODE HANDLING:                                      │
│  200-299 → Success                                          │
│  400     → Bad request (check input)                        │
│  401     → Unauthorized (login again)                       │
│  403     → Forbidden (no permission)                        │
│  404     → Not found                                        │
│  422     → Validation error                                 │
│  500+    → Server error (retry later)                       │
│                                                             │
│  USER MESSAGE PATTERN:                                      │
│  1. What happened (simple terms)                            │
│  2. What user can do (action button)                        │
│  3. Optional: try again later                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Dio Package](./05-DioPackage.md) | [Next: Loading States →](./07-LoadingStates.md)
