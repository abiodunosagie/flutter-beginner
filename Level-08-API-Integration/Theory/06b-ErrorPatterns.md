# Advanced Error Handling Patterns

## The Big Idea In One Sentence

> Handle errors in ONE place, turn them into friendly messages, and retry only the failures worth retrying (network/server), waiting a little longer each time.

Master advanced error handling patterns, retry logic, and user-friendly error messages!

---

## Smart Error Handling Service

Create a reusable API service that handles all errors automatically:

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

### Visual: Smart Error Handling Flow

```
┌─────────────────────────────────────────────────────────────┐
│            SMART ERROR HANDLING FLOW                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  api.get('/users')                                          │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ _handleRequest()    │  Catches network errors            │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ _handleResponse()   │  Converts status codes             │
│  └─────────────────────┘  to specific exceptions            │
│       │                                                     │
│       ▼                                                     │
│  200 → Return data                                          │
│  401 → throw UnauthorizedException                          │
│  404 → throw NotFoundException                              │
│  500 → throw ServerException                                │
│                                                             │
│  Your Code:                                                 │
│  try {                                                      │
│    final users = await api.get('/users');                   │
│  } on UnauthorizedException {                               │
│    // Show login screen                                     │
│  } on NotFoundException {                                   │
│    // Show not found page                                   │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## User-Friendly Error Messages

Never show technical errors to users! Convert them to friendly messages:

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

  static Color colorForException(ApiException e) {
    if (e is NetworkException) return Colors.orange;
    if (e is UnauthorizedException) return Colors.red;
    if (e is NotFoundException) return Colors.blue;
    if (e is ServerException) return Colors.purple;
    return Colors.red;
  }
}
```

### Visual: Error Message Transformation

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
│  ✓ Tell what happened (in simple terms)                     │
│  ✓ Are specific and clear                                   │
│  ✓ Suggest what to do next                                  │
│  ✓ Don't show technical jargon                              │
│  ✓ Are polite and helpful                                   │
│                                                             │
│  BAD: "Error 500: Internal Server Error"                    │
│        "SocketException: Failed host lookup"                │
│                                                             │
│  GOOD: "We're having technical difficulties. Try again."    │
│        "Check your internet connection and try again."      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Retry Logic with Exponential Backoff

Automatically retry failed requests with increasing delays:

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
        rethrow;  // Tried enough times, give up
      }
      print('Network error. Retry attempt $attempts of $maxRetries');
      await Future.delayed(delay * attempts);  // Exponential backoff
    } on ServerException {
      attempts++;
      if (attempts >= maxRetries) {
        rethrow;
      }
      print('Server error. Retry attempt $attempts of $maxRetries');
      await Future.delayed(delay * attempts);
    } catch (e) {
      rethrow;  // Don't retry other errors (401, 404, validation, etc.)
    }
  }

  throw ApiException('Max retries exceeded');
}

// Usage
Future<void> loadData() async {
  try {
    final users = await fetchWithRetry(
      request: () => api.get<List<dynamic>>('/users'),
      maxRetries: 3,
      delay: Duration(seconds: 2),
    );
    print('Got ${users.length} users');
  } on ApiException catch (e) {
    print('Failed after retries: ${ErrorMessages.forException(e)}');
  }
}
```

### Visual: Retry Logic with Exponential Backoff

```
┌─────────────────────────────────────────────────────────────┐
│                    RETRY LOGIC                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Request #1 (t=0s)                                          │
│      │                                                      │
│      ▼                                                      │
│  ┌─────────┐    FAIL (Network Error)                        │
│  │ Server  │ ─────────→ Wait 2 seconds (delay × 1)          │
│  └─────────┘                │                               │
│                             ▼                               │
│  Request #2 (t=2s)                                          │
│      │                                                      │
│      ▼                                                      │
│  ┌─────────┐    FAIL (Server Error)                         │
│  │ Server  │ ─────────→ Wait 4 seconds (delay × 2)          │
│  └─────────┘                │                               │
│                             ▼                               │
│  Request #3 (t=6s)                                          │
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
│                                                             │
│  WHY? Gives server time to recover from issues.             │
│                                                             │
│  DON'T RETRY:                                               │
│  ✗ 401 Unauthorized (login required)                        │
│  ✗ 404 Not Found (it won't appear later)                    │
│  ✗ 422 Validation Error (fix input first)                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Think Like a 5-Year-Old:**
If you knock on a door and nobody answers:
- Wait 2 seconds, knock again
- If still no answer, wait 4 seconds, knock again
- If still no answer, wait 8 seconds, knock again
- After 3 tries, give up and tell mom!

---

## Complete Error Widget

A reusable error widget with retry functionality:

```dart
import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final ApiException error;
  final VoidCallback onRetry;
  final String? customMessage;

  const ErrorDisplayWidget({
    required this.error,
    required this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final message = customMessage ?? ErrorMessages.forException(error);
    final icon = ErrorMessages.iconForException(error);
    final color = ErrorMessages.colorForException(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: color,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            if (error is UnauthorizedException) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
                child: const Text('Go to Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic>? _users;
  bool _isLoading = false;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await fetchWithRetry(
        request: () => api.get<List<dynamic>>('/users'),
      );

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ErrorDisplayWidget(
        error: _error!,
        onRetry: _loadUsers,
      );
    }

    return ListView.builder(
      itemCount: _users!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_users![index]['name']),
          subtitle: Text(_users![index]['email']),
        );
      },
    );
  }
}
```

---

## Global Error Handler with Dio

Handle all errors in one place using Dio interceptors:

```dart
import 'package:dio/dio.dart';

class GlobalErrorHandler extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error for developers
    print('═══════════════════════════════════');
    print('API ERROR');
    print('Type: ${err.type}');
    print('URL: ${err.requestOptions.uri}');
    print('Status: ${err.response?.statusCode}');
    print('Message: ${err.message}');
    print('═══════════════════════════════════');

    // Convert DioException to our custom exceptions
    final apiException = _convertDioException(err);

    // Show user-friendly error message
    final userMessage = ErrorMessages.forException(apiException);
    print('User will see: $userMessage');

    // Continue with the error (let calling code handle it)
    handler.next(err);
  }

  ApiException _convertDioException(DioException e) {
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
      case 502:
      case 503:
        return ServerException();
      default:
        return ApiException('Error: ${response.statusCode}');
    }
  }
}

// Setup
final dio = Dio();
dio.interceptors.add(GlobalErrorHandler());
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
│  ✓ Log errors for debugging (in development)                │
│  ✓ Provide retry options for network errors                 │
│  ✓ Handle 401 by redirecting to login                       │
│  ✓ Show specific actions users can take                     │
│  ✓ Use exponential backoff for retries                      │
│  ✓ Validate input before sending to server                  │
│                                                             │
│  DON'T:                                                     │
│  ✗ Show raw error messages to users                         │
│  ✗ Ignore errors (catch but do nothing)                     │
│  ✗ Retry non-recoverable errors (401, 404, 422)             │
│  ✗ Leave users stuck with no options                        │
│  ✗ Crash the app on errors                                  │
│  ✗ Retry forever (set max retries)                          │
│  ✗ Show stack traces in production                          │
│                                                             │
│  ALWAYS ASK: "What should the user do now?"                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│          ADVANCED ERROR HANDLING CHEAT SHEET                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SMART API SERVICE:                                         │
│  • Converts status codes to exceptions automatically        │
│  • Extracts error messages from API responses               │
│  • Handles network errors globally                          │
│                                                             │
│  USER-FRIENDLY MESSAGES:                                    │
│  • Convert technical errors to simple language              │
│  • Include appropriate icons and colors                     │
│  • Suggest next steps to users                              │
│                                                             │
│  RETRY LOGIC:                                               │
│  • Use exponential backoff (2s, 4s, 8s)                     │
│  • Only retry network/server errors                         │
│  • Don't retry client errors (401, 404, 422)                │
│  • Set max retries (usually 3)                              │
│                                                             │
│  ERROR WIDGET:                                              │
│  • Show appropriate icon                                    │
│  • Display friendly message                                 │
│  • Provide "Try Again" button                               │
│  • Handle 401 with "Go to Login" button                     │
│                                                             │
│  GLOBAL HANDLER (DIO):                                      │
│  • Use interceptor for logging                              │
│  • Convert all errors to custom exceptions                  │
│  • Log for developers, show friendly messages to users      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### What We Learned

1. **Smart API Service**: Centralized error handling for all requests
2. **User-Friendly Messages**: Convert technical errors to helpful messages
3. **Retry Logic**: Automatically retry failed requests with exponential backoff
4. **Error Widget**: Reusable UI component for displaying errors
5. **Global Handler**: Handle all Dio errors in one place
6. **Best Practices**: Do's and don'ts of error handling

### Key Takeaways

- **Never show technical errors to users** - always convert to friendly messages
- **Retry smartly** - only network/server errors, use exponential backoff
- **Give users options** - "Try Again", "Go to Login", etc.
- **Log for debugging** - but only in development, not production
- **Handle 401 specially** - always redirect to login

---

## Quick Quiz

**Q1.** What is "exponential backoff"?

<details>
<summary>Answer</summary>
Waiting longer between each retry (2s, then 4s, then 8s) to give the server time to recover.
</details>

**Q2.** Which errors should you NOT retry?

<details>
<summary>Answer</summary>
Client errors like 401 (login needed), 404 (does not exist), and 422 (bad input). Retrying will not fix them.
</details>

**Q3.** Why convert a `SocketException` into a message like "Check your internet connection"?

<details>
<summary>Answer</summary>
Users should see plain, helpful language, not technical jargon or stack traces.
</details>

---

## Assignment

### Problem 1: Retry or not?

For each, retry or do not retry?
1. 500 Server Error.
2. 401 Unauthorized.
3. No internet (network error).

### Problem 2: Friendly message

Rewrite this for a user: "Error 503: Service Unavailable".

### Problem 3: Cap the retries

Why must a retry loop have a `maxRetries` limit?

---

## Assignment Answers

### Problem 1: Retry or not?

1. **Retry** (server may recover).
2. **Do not retry** (the user must log in; retrying changes nothing).
3. **Retry** (the connection may come back).

### Problem 2: Friendly message

Something like: "Our servers are busy right now. Please try again in a few minutes."

### Problem 3: Cap the retries

Without a limit, a request that always fails would retry forever, draining battery and data and never letting the user move on. A cap (e.g. 3) means you eventually give up and show an error.

---

## Next Steps

You now know error handling! Continue to: [07a-LoadingIndicators.md](./07a-LoadingIndicators.md) - Learn how to show loading states and keep users informed!

---

[Back to Learning Path](./00-LearningPath.md)

---

## Navigation

⬅️ **Previous:** [Error Basics](06a-ErrorBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Loading Indicators](07a-LoadingIndicators.md)
