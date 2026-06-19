# Error Handling Basics

## The Big Idea In One Sentence

> Network calls fail sometimes, so wrap them in `try/catch`, figure out WHICH kind of failure it was, and show the user a clear message plus what to do next.

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

**Simple Analogy:**
Imagine you're trying to open a door:
- **Bad error**: "Error" (What error? Which door?)
- **Good error**: "This door is locked. Please use your key or call the front desk." (Clear and helpful!)

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

**Think Like a 5-Year-Old:**
- **Network Error**: "The phone line is broken, can't call"
- **400 Error**: "You asked for chocolate, but said it wrong"
- **401 Error**: "You need a password to enter"
- **404 Error**: "That toy doesn't exist in the store"
- **500 Error**: "The store's computer broke"

---

## HTTP Status Codes Explained

```
┌─────────────────────────────────────────────────────────────┐
│                 HTTP STATUS CODES                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CODE   MEANING               WHAT TO DO                    │
│  ──────────────────────────────────────────────────────────│
│  200    OK                    Everything worked!            │
│  201    Created               New item created              │
│  204    No Content            Success, but no data back     │
│                                                             │
│  400    Bad Request           Check your data               │
│  401    Unauthorized          Login required                │
│  403    Forbidden             No permission                 │
│  404    Not Found             Item doesn't exist            │
│  422    Validation Error      Fix form errors               │
│                                                             │
│  500    Server Error          Wait and retry                │
│  502    Bad Gateway           Server issue, retry           │
│  503    Service Unavailable   Server busy, retry            │
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
      // Success!
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

### Visual: Try-Catch Flow

```
┌─────────────────────────────────────────────────────────────┐
│                  TRY-CATCH FLOW                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  try {                                                      │
│    final response = await http.get(...);                    │
│                │                                            │
│                ▼                                            │
│    ┌────────────────────┐                                   │
│    │ SUCCESS?           │                                   │
│    └────────────────────┘                                   │
│         │          │                                        │
│      YES│          │NO (Exception thrown)                   │
│         │          │                                        │
│         ▼          ▼                                        │
│    Return data   Catch blocks check:                        │
│                                                             │
│  } on SocketException {         ← No internet               │
│    print('No internet');                                    │
│                                                             │
│  } on HttpException {           ← HTTP problem              │
│    print('HTTP error');                                     │
│                                                             │
│  } on FormatException {         ← Bad JSON                  │
│    print('Invalid format');                                 │
│                                                             │
│  } catch (e) {                  ← Everything else           │
│    print('Unknown error');                                  │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Creating Custom Exception Classes

Instead of using generic `Exception`, create specific exception types:

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

### Why Custom Exceptions?

```
┌─────────────────────────────────────────────────────────────┐
│           WHY CUSTOM EXCEPTIONS?                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GENERIC EXCEPTION:                                         │
│  try {                                                      │
│    await api.get('/users');                                 │
│  } catch (e) {                                              │
│    // What error? Can't tell!                               │
│    print(e);                                                │
│  }                                                          │
│                                                             │
│  CUSTOM EXCEPTIONS:                                         │
│  try {                                                      │
│    await api.get('/users');                                 │
│  } on NetworkException {                                    │
│    // Show "Check internet" message                         │
│  } on UnauthorizedException {                               │
│    // Redirect to login                                     │
│  } on NotFoundException {                                   │
│    // Show "Not found" page                                 │
│  }                                                          │
│                                                             │
│  Benefits:                                                  │
│  ✓ Handle different errors differently                      │
│  ✓ Show appropriate messages                                │
│  ✓ Take specific actions                                    │
│  ✓ Easier to debug                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
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

## Error Handling with Dio

Dio has better error handling built-in with `DioException`:

```dart
import 'package:dio/dio.dart';

Future<List<dynamic>> fetchUsers() async {
  final dio = Dio();

  try {
    final response = await dio.get('https://api.example.com/users');
    return response.data;
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw NetworkException('Connection timeout - check your internet');

      case DioExceptionType.receiveTimeout:
        throw NetworkException('Server took too long to respond');

      case DioExceptionType.badResponse:
        // Server responded with error status
        _handleBadResponse(e.response);

      case DioExceptionType.cancel:
        throw ApiException('Request was cancelled');

      case DioExceptionType.connectionError:
        throw NetworkException('No internet connection');

      default:
        throw ApiException('Unknown error: ${e.message}');
    }
  }
}

void _handleBadResponse(Response? response) {
  if (response == null) {
    throw ApiException('No response from server');
  }

  switch (response.statusCode) {
    case 400:
      throw ApiException('Bad request - check your data');
    case 401:
      throw UnauthorizedException();
    case 403:
      throw ApiException('Access denied');
    case 404:
      throw NotFoundException();
    case 422:
      throw ValidationException(errors: response.data['errors']);
    case 500:
    case 502:
    case 503:
      throw ServerException();
    default:
      throw ApiException('Error: ${response.statusCode}');
  }
}
```

---

## Showing Errors in UI

```dart
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
      // Fetch users (your API call here)
      final users = await fetchUsers();

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
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Error state
    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    // Success state
    return _buildUsersList();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadUsers,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
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

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              ERROR HANDLING BASICS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WHY ERROR HANDLING:                                        │
│  • Tell users what happened                                 │
│  • Suggest what to do next                                  │
│  • Prevent app crashes                                      │
│  • Improve user experience                                  │
│                                                             │
│  ERROR TYPES:                                               │
│  • Network errors (no internet, timeout)                    │
│  • Client errors (401, 404, 422)                            │
│  • Server errors (500, 502, 503)                            │
│  • Parsing errors (bad JSON)                                │
│                                                             │
│  CUSTOM EXCEPTIONS:                                         │
│  • NetworkException                                         │
│  • UnauthorizedException                                    │
│  • NotFoundException                                        │
│  • ValidationException                                      │
│  • ServerException                                          │
│                                                             │
│  IN UI:                                                     │
│  • Show loading indicator                                   │
│  • Show error message                                       │
│  • Provide "Try Again" button                               │
│  • Redirect to login for 401                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### What We Learned

1. **Why Error Handling**: Users need clear, helpful messages
2. **Error Types**: Network, client (4xx), server (5xx), parsing
3. **Status Codes**: 200=success, 401=login, 404=not found, 500=server error
4. **Custom Exceptions**: Create specific exception classes
5. **Try-Catch**: Handle different errors differently
6. **UI States**: Loading, error, success

### Continue Learning

---

## Quick Quiz

**Q1.** What Dart structure catches errors so the app does not crash?

<details>
<summary>Answer</summary>
`try { ... } catch (e) { ... }` (with optional `on SomeException` clauses for specific types).
</details>

**Q2.** Why make custom exceptions like `UnauthorizedException` instead of plain `Exception`?

<details>
<summary>Answer</summary>
So you can react differently to each kind: for example, send the user to login on `UnauthorizedException` but show "check your internet" on `NetworkException`.
</details>

**Q3.** What should the UI show when a request fails?

<details>
<summary>Answer</summary>
A clear message about what happened and a way forward, like a "Try Again" button.
</details>

---

## Assignment

### Problem 1: Wrap a call

Wrap `await fetchUsers()` in a try/catch that prints a friendly message on any error.

### Problem 2: React by type

Given `on UnauthorizedException` and `on NetworkException`, which one should send the user to the login screen?

### Problem 3: Map a code

The server returns `404`. Which custom exception fits, and what message would you show?

---

## Assignment Answers

### Problem 1: Wrap a call

```dart
try {
  final users = await fetchUsers();
} catch (e) {
  print('Could not load users. Please try again.');
}
```

### Problem 2: React by type

`UnauthorizedException` (a 401) means the user is not logged in, so send them to the login screen. `NetworkException` should show a "check your connection" message instead.

### Problem 3: Map a code

`NotFoundException`. Show something like "We could not find that item." (404 means the resource does not exist.)

---

Continue to: [06b-ErrorPatterns.md](./06b-ErrorPatterns.md) - Learn advanced error handling patterns, retry logic, and user-friendly error messages!

---

[Back to Learning Path](./00-LearningPath.md)

---

## Navigation

⬅️ **Previous:** [Dio Advanced](05c-DioAdvanced.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Error Patterns](06b-ErrorPatterns.md)
