# Dio Features: Interceptors

## The Big Idea In One Sentence

> An interceptor is a checkpoint that runs before every request and after every response, so you can add your auth token, log, or handle errors in ONE place instead of in every call.

Master Dio's most powerful feature - Interceptors!

---

## What are Interceptors?

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│                    INTERCEPTORS                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Think of interceptors like SECURITY CHECKPOINTS:           │
│                                                             │
│  Your Request                                               │
│       │                                                     │
│       ▼                                                     │
│  ┌───────────────────────┐                                  │
│  │ REQUEST INTERCEPTOR   │  ← Add auth token                │
│  │ (Before sending)      │  ← Log request                   │
│  └───────────────────────┘  ← Modify headers                │
│       │                                                     │
│       ▼                                                     │
│    INTERNET → SERVER → INTERNET                             │
│       │                                                     │
│       ▼                                                     │
│  ┌───────────────────────┐                                  │
│  │ RESPONSE INTERCEPTOR  │  ← Log response                  │
│  │ (After receiving)     │  ← Transform data                │
│  └───────────────────────┘  ← Handle errors                 │
│       │                                                     │
│       ▼                                                     │
│  Your Code receives data                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Simple Analogy:**
Imagine sending a letter through the post office. An interceptor is like a helper at the post office who:
- BEFORE sending: Adds stamps, checks address, wraps it nicely
- AFTER receiving: Opens it for you, translates it, removes envelope

---

## Creating a Logging Interceptor

This interceptor prints what's happening with your requests:

```dart
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('╔═══════════════════════════════════════');
    print('║ REQUEST');
    print('╠═══════════════════════════════════════');
    print('║ Method: ${options.method}');
    print('║ URL: ${options.baseUrl}${options.path}');
    print('║ Headers: ${options.headers}');
    print('║ Data: ${options.data}');
    print('╚═══════════════════════════════════════');

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('╔═══════════════════════════════════════');
    print('║ RESPONSE');
    print('╠═══════════════════════════════════════');
    print('║ Status: ${response.statusCode}');
    print('║ Data: ${response.data}');
    print('╚═══════════════════════════════════════');

    // Continue with the response
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('╔═══════════════════════════════════════');
    print('║ ERROR');
    print('╠═══════════════════════════════════════');
    print('║ Status: ${err.response?.statusCode}');
    print('║ Message: ${err.message}');
    print('║ Type: ${err.type}');
    print('╚═══════════════════════════════════════');

    // Continue with the error
    handler.next(err);
  }
}

// Add to Dio
final dio = Dio();
dio.interceptors.add(LoggingInterceptor());

// Now every request will be logged!
await dio.get('/users');  // Prints request and response details
```

**What happens:**
```
When you call: dio.get('/users')

╔═══════════════════════════════════════
║ REQUEST
╠═══════════════════════════════════════
║ Method: GET
║ URL: https://api.example.com/users
║ Headers: {Content-Type: application/json}
║ Data: null
╚═══════════════════════════════════════

... request happens ...

╔═══════════════════════════════════════
║ RESPONSE
╠═══════════════════════════════════════
║ Status: 200
║ Data: [{id: 1, name: John}, ...]
╚═══════════════════════════════════════
```

---

## Auth Token Interceptor (Very Important!)

This automatically adds your login token to every request:

```dart
class AuthInterceptor extends Interceptor {
  String? _token;

  // Set token after user logs in
  void setToken(String token) {
    _token = token;
    print('✓ Token set: ${token.substring(0, 10)}...');
  }

  // Clear token when user logs out
  void clearToken() {
    _token = null;
    print('✗ Token cleared');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add token to every request automatically!
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
      print('🔒 Added auth token to ${options.path}');
    } else {
      print('⚠️  No token available for ${options.path}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      print('🚫 Token expired! Need to re-authenticate.');
      // Could trigger logout or token refresh here
    }
    handler.next(err);
  }
}

// Usage
final authInterceptor = AuthInterceptor();
final dio = Dio();
dio.interceptors.add(authInterceptor);

// After user logs in successfully:
authInterceptor.setToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');

// Now ALL requests automatically have the auth token!
await dio.get('/protected-route');      // ✓ Has Authorization header
await dio.get('/user/profile');         // ✓ Has Authorization header
await dio.post('/user/settings', data: {...});  // ✓ Has Authorization header

// When user logs out:
authInterceptor.clearToken();
```

### Visual: How Auth Interceptor Works

```
┌─────────────────────────────────────────────────────────────┐
│              AUTH INTERCEPTOR FLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. USER LOGS IN                                            │
│     └→ authInterceptor.setToken("abc123...")                │
│                                                             │
│  2. YOU MAKE REQUEST                                        │
│     └→ dio.get('/profile')                                  │
│                                                             │
│  3. INTERCEPTOR CATCHES IT                                  │
│     Request: GET /profile                                   │
│     Headers: {}                                             │
│              ↓                                              │
│     Interceptor adds:                                       │
│     Headers: {Authorization: "Bearer abc123..."}            │
│              ↓                                              │
│     Modified request sent to server!                        │
│                                                             │
│  4. SERVER RESPONSE                                         │
│     200 OK → Pass to your code                              │
│     401 Unauthorized → Interceptor detects, logs out user   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Why This is Amazing:**
- Write `setToken()` once when user logs in
- EVERY request automatically has the token
- No need to manually add `Authorization` header each time!
- Automatically detects when token expires (401 error)

---

## Built-in Log Interceptor (Quick & Easy)

Dio has a built-in logging interceptor:

```dart
final dio = Dio();

// Add Dio's built-in logger
dio.interceptors.add(LogInterceptor(
  request: true,          // Log requests
  requestHeader: true,    // Log request headers
  requestBody: true,      // Log request body
  responseHeader: true,   // Log response headers
  responseBody: true,     // Log response body
  error: true,            // Log errors
  logPrint: print,        // Custom print function (optional)
));

// Now every request is automatically logged!
await dio.get('/users');
```

**Output:**
```
*** Request ***
uri: https://api.example.com/users
method: GET
headers:
  Content-Type: application/json

*** Response ***
statusCode: 200
data: [{"id": 1, "name": "John"}, ...]
```

---

## Multiple Interceptors

You can add multiple interceptors - they run in order:

```dart
final dio = Dio();

// Add multiple interceptors
dio.interceptors.addAll([
  LogInterceptor(requestBody: true, responseBody: true),
  AuthInterceptor(),
  CustomHeaderInterceptor(),
  ErrorHandlerInterceptor(),
]);
```

### Visual: Multiple Interceptors

```
┌─────────────────────────────────────────────────────────────┐
│              MULTIPLE INTERCEPTORS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Your Request: dio.get('/users')                            │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ 1. LogInterceptor   │  → Logs the request                │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ 2. AuthInterceptor  │  → Adds Bearer token               │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ 3. CustomHeaders    │  → Adds custom headers             │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│    ═══════════                                              │
│    SENT TO SERVER                                           │
│    ═══════════                                              │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ 3. CustomHeaders    │  → Processes response              │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ 2. AuthInterceptor  │  → Checks for 401 errors           │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────┐                                    │
│  │ 1. LogInterceptor   │  → Logs the response               │
│  └─────────────────────┘                                    │
│       │                                                     │
│       ▼                                                     │
│  Your code gets response                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Error Handler Interceptor

Handle errors globally instead of in every request:

```dart
class ErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = _getErrorMessage(err);

    // Show user-friendly message
    print('❌ $message');

    // Could show a snackbar/dialog here
    // showErrorDialog(message);

    handler.next(err);
  }

  String _getErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response?.statusCode);

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }

  String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Not found. The resource doesn\'t exist.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'Error: $statusCode';
    }
  }
}

// Usage
final dio = Dio();
dio.interceptors.add(ErrorHandlerInterceptor());

// Now errors are handled globally!
try {
  await dio.get('/users/999999');
} catch (e) {
  // Error message already printed by interceptor
  // You can still handle specific errors here if needed
}
```

---

## Practical Example: Complete API Service with Interceptors

```dart
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  final AuthInterceptor _authInterceptor = AuthInterceptor();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Add all interceptors
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      _authInterceptor,
      ErrorHandlerInterceptor(),
    ]);
  }

  // Login and set token
  Future<void> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    String token = response.data['token'];
    _authInterceptor.setToken(token);
  }

  // Logout and clear token
  void logout() {
    _authInterceptor.clearToken();
  }

  // All these methods automatically have auth token!
  Future<List<dynamic>> getUsers() async {
    final response = await _dio.get('/users');
    return response.data;
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await _dio.get('/user/profile');
    return response.data;
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.put('/user/profile', data: data);
  }
}

// Usage
void main() async {
  final api = ApiService();

  // Login once
  await api.login('user@example.com', 'password123');

  // All these requests automatically have the auth token!
  final users = await api.getUsers();
  final profile = await api.getUserProfile();
  await api.updateProfile({'name': 'New Name'});

  // Logout
  api.logout();
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                INTERCEPTOR CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WHAT ARE INTERCEPTORS?                                     │
│  • Code that runs BEFORE/AFTER every request                │
│  • Modify requests (add headers, log, transform)            │
│  • Handle responses globally                                │
│  • Catch errors in one place                                │
│                                                             │
│  COMMON USE CASES:                                          │
│  1. Add auth tokens automatically                           │
│  2. Log all requests/responses                              │
│  3. Handle errors globally                                  │
│  4. Add custom headers to all requests                      │
│  5. Transform request/response data                         │
│  6. Retry failed requests                                   │
│                                                             │
│  BASIC STRUCTURE:                                           │
│  class MyInterceptor extends Interceptor {                  │
│    @override                                                │
│    void onRequest(...) { }  // Before sending               │
│                                                             │
│    @override                                                │
│    void onResponse(...) { }  // After receiving             │
│                                                             │
│    @override                                                │
│    void onError(...) { }  // When error occurs              │
│  }                                                          │
│                                                             │
│  ADD TO DIO:                                                │
│  dio.interceptors.add(MyInterceptor());                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### What We Learned

1. **Interceptors**: Code that runs before/after every request
2. **Logging Interceptor**: See what's happening with your requests
3. **Auth Interceptor**: Automatically add auth tokens
4. **Error Handler**: Handle errors in one place
5. **Multiple Interceptors**: Chain them together
6. **Built-in Logger**: Use Dio's `LogInterceptor` for quick logging

### Continue Learning

---

## Quick Quiz

**Q1.** When does an interceptor's `onRequest` run?

<details>
<summary>Answer</summary>
Just before the request is sent, so you can change it (for example, add a header).
</details>

**Q2.** What is the classic use for an interceptor?

<details>
<summary>Answer</summary>
Automatically adding the auth token (`Authorization: Bearer ...`) to every request.
</details>

**Q3.** You must call something to let the request continue down the chain. What is it?

<details>
<summary>Answer</summary>
`handler.next(...)` (e.g. `handler.next(options)` in `onRequest`).
</details>

---

## Assignment

### Problem 1: Add the token

Inside `onRequest`, write the line that adds a bearer token (in `_token`) to the request headers.

### Problem 2: Keep it moving

After modifying `options`, what must you call so the request is actually sent?

### Problem 3: Why bother?

Give one reason an auth interceptor beats adding the header by hand in every request.

---

## Assignment Answers

### Problem 1: Add the token

```dart
options.headers['Authorization'] = 'Bearer $_token';
```

### Problem 2: Keep it moving

```dart
handler.next(options);
```

Without it, the request stalls at the interceptor.

### Problem 3: Why bother?

You set it once and every request gets the token automatically, so you cannot forget it on a call, and you change it in one place if the scheme changes.

---

Continue to: [05c-DioAdvanced.md](./05c-DioAdvanced.md) - Learn about request cancellation, file uploads, and more advanced Dio features!

---

[Back to Learning Path](./00-LearningPath.md)

---

## Navigation

⬅️ **Previous:** [Dio Introduction](05a-DioIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Dio Advanced](05c-DioAdvanced.md)
