# The Dio Package

Learn about Dio - the powerful HTTP client for advanced API needs!

---

## What is Dio?

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│               http vs Dio - COMPARISON                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Think of it like shipping packages:                        │
│                                                             │
│  http package = Regular Mail                                │
│  ┌──────────────────────────┐                               │
│  │ • Simple and works       │                               │
│  │ • Basic tracking         │                               │
│  │ • One package at a time  │                               │
│  │ • Manual retries         │                               │
│  └──────────────────────────┘                               │
│                                                             │
│  Dio package = FedEx Premium                                │
│  ┌──────────────────────────┐                               │
│  │ • Advanced tracking      │                               │
│  │ • Automatic retries      │                               │
│  │ • Multiple packages      │                               │
│  │ • Custom handling        │                               │
│  │ • Interceptors (hooks)   │                               │
│  │ • Progress monitoring    │                               │
│  │ • Cancel requests        │                               │
│  │ • Timeout handling       │                               │
│  └──────────────────────────┘                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## When to Use Which?

```
┌─────────────────────────────────────────────────────────────┐
│                 CHOOSING http vs Dio                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  USE http WHEN:                                             │
│  • Simple GET/POST requests                                 │
│  • Learning APIs for the first time                         │
│  • Small projects with few API calls                        │
│  • You want minimal dependencies                            │
│                                                             │
│  USE Dio WHEN:                                              │
│  • Need to intercept requests/responses                     │
│  • Want automatic JSON parsing                              │
│  • Need request cancellation                                │
│  • Want upload/download progress                            │
│  • Need automatic retries                                   │
│  • Working on larger apps                                   │
│  • Need timeout configuration                               │
│  • Want to add auth tokens globally                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Setup

### Step 1: Add to pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0  # Add this line
```

### Step 2: Run flutter pub get

```bash
flutter pub get
```

### Step 3: Import

```dart
import 'package:dio/dio.dart';
```

---

## Basic Dio Usage

### Creating a Dio Instance

```dart
import 'package:dio/dio.dart';

// Simple way
final dio = Dio();

// With options (recommended)
final dio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
  headers: {
    'Content-Type': 'application/json',
  },
));
```

### Visual: Dio Instance

```
┌─────────────────────────────────────────────────────────────┐
│                    DIO CONFIGURATION                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Dio(BaseOptions(                                           │
│    baseUrl: '...',       ← Prepended to all requests        │
│    connectTimeout: ...,  ← Max time to establish connection │
│    receiveTimeout: ...,  ← Max time to receive data         │
│    headers: {...},       ← Default headers for all requests │
│  ))                                                         │
│                                                             │
│  EXAMPLE:                                                   │
│  baseUrl: 'https://api.example.com'                         │
│                                                             │
│  Then:                                                      │
│  dio.get('/users')  →  https://api.example.com/users        │
│  dio.get('/posts')  →  https://api.example.com/posts        │
│                                                             │
│  No need to repeat the base URL every time!                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## GET Requests with Dio

```dart
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
));

// Simple GET
Future<void> fetchUsers() async {
  try {
    final response = await dio.get('/users');

    // Dio automatically parses JSON!
    // response.data is already a List, not a String
    List<dynamic> users = response.data;

    for (var user in users) {
      print(user['name']);
    }
  } catch (e) {
    print('Error: $e');
  }
}

// GET with query parameters
Future<void> fetchUsersFiltered() async {
  final response = await dio.get(
    '/users',
    queryParameters: {
      'page': 1,
      'limit': 10,
    },
  );

  print(response.data);
}

// GET single item
Future<void> fetchUser(int id) async {
  final response = await dio.get('/users/$id');
  print(response.data['name']);
}
```

### Visual: Dio vs http

```
┌─────────────────────────────────────────────────────────────┐
│               Dio vs http - CODE COMPARISON                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WITH http:                                                 │
│  ──────────                                                 │
│  final response = await http.get(                           │
│    Uri.parse('https://api.com/users'),                      │
│  );                                                         │
│  if (response.statusCode == 200) {                          │
│    final data = json.decode(response.body);  // Manual!     │
│  }                                                          │
│                                                             │
│  WITH Dio:                                                  │
│  ─────────                                                  │
│  final response = await dio.get('/users');                  │
│  final data = response.data;  // Already parsed!            │
│                                                             │
│  Dio is cleaner and does more automatically!                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## POST Requests with Dio

```dart
// Create new data
Future<void> createUser() async {
  try {
    final response = await dio.post(
      '/users',
      data: {  // No need for json.encode()!
        'name': 'John Doe',
        'email': 'john@example.com',
        'username': 'johndoe',
      },
    );

    print('Created user: ${response.data}');
    print('Status: ${response.statusCode}');  // 201
  } on DioException catch (e) {
    print('Error: ${e.message}');
  }
}
```

---

## PUT and PATCH Requests

```dart
// PUT - Replace entire resource
Future<void> updateUser(int id) async {
  final response = await dio.put(
    '/users/$id',
    data: {
      'name': 'Updated Name',
      'email': 'updated@example.com',
      'username': 'updateduser',
    },
  );

  print('Updated: ${response.data}');
}

// PATCH - Update partial data
Future<void> patchUser(int id) async {
  final response = await dio.patch(
    '/users/$id',
    data: {
      'email': 'newemail@example.com',  // Only update email
    },
  );

  print('Patched: ${response.data}');
}
```

---

## DELETE Requests

```dart
Future<void> deleteUser(int id) async {
  try {
    final response = await dio.delete('/users/$id');
    print('Deleted successfully');
  } on DioException catch (e) {
    print('Failed to delete: ${e.message}');
  }
}
```

---

## Interceptors - Dio's Superpower!

### What are Interceptors?

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

### Creating an Interceptor

```dart
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    // Continue with the response
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    // Continue with the error
    handler.next(err);
  }
}

// Add to Dio
final dio = Dio();
dio.interceptors.add(LoggingInterceptor());
```

### Auth Token Interceptor (Very Common!)

```dart
class AuthInterceptor extends Interceptor {
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add token to every request automatically!
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Token expired - could refresh here or redirect to login
      print('Token expired! Need to re-authenticate.');
    }
    handler.next(err);
  }
}

// Usage
final authInterceptor = AuthInterceptor();
final dio = Dio();
dio.interceptors.add(authInterceptor);

// After user logs in:
authInterceptor.setToken('user-jwt-token');

// All requests now automatically have the token!
dio.get('/protected-route');  // Has Authorization header
```

---

## Error Handling with Dio

```dart
Future<void> fetchDataWithErrorHandling() async {
  try {
    final response = await dio.get('/users/999');
    print(response.data);
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timeout - check your internet');
        break;
      case DioExceptionType.receiveTimeout:
        print('Server took too long to respond');
        break;
      case DioExceptionType.badResponse:
        // Server responded with error status
        print('Server error: ${e.response?.statusCode}');
        print('Message: ${e.response?.data}');
        break;
      case DioExceptionType.cancel:
        print('Request was cancelled');
        break;
      case DioExceptionType.connectionError:
        print('No internet connection');
        break;
      default:
        print('Unknown error: ${e.message}');
    }
  }
}
```

### Visual: Dio Error Types

```
┌─────────────────────────────────────────────────────────────┐
│                    DIO ERROR TYPES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ERROR TYPE           │ MEANING                             │
│  ────────────────────────────────────────────────────────── │
│  connectionTimeout    │ Couldn't connect to server          │
│  sendTimeout          │ Couldn't send request in time       │
│  receiveTimeout       │ Server response too slow            │
│  badResponse          │ Server returned 4xx or 5xx          │
│  cancel               │ You cancelled the request           │
│  connectionError      │ Network issues / no internet        │
│  badCertificate       │ SSL certificate problem             │
│  unknown              │ Something else went wrong           │
│                                                             │
│  For badResponse, check:                                    │
│  e.response?.statusCode  →  400, 401, 404, 500, etc.        │
│  e.response?.data        →  Error message from server       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Request Cancellation

```dart
// Create a cancel token
final cancelToken = CancelToken();

// Start a long request
Future<void> fetchLargeData() async {
  try {
    final response = await dio.get(
      '/large-data',
      cancelToken: cancelToken,
    );
    print(response.data);
  } on DioException catch (e) {
    if (CancelToken.isCancel(e)) {
      print('Request cancelled by user');
    }
  }
}

// Cancel it when needed (e.g., user navigates away)
void cancelRequest() {
  cancelToken.cancel('User cancelled');
}
```

### Visual: Request Cancellation

```
┌─────────────────────────────────────────────────────────────┐
│                REQUEST CANCELLATION                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  USE CASE: User starts download, then navigates away        │
│                                                             │
│  ┌─────────┐                           ┌─────────┐         │
│  │  App    │ ──── GET /big-file ─────→ │ Server  │         │
│  │         │                           │         │         │
│  │ User    │                           │ Sending │         │
│  │ clicks  │                           │ data... │         │
│  │ "Back"  │                           │         │         │
│  │         │                           │         │         │
│  │ Cancel! │ ──── CANCEL TOKEN ──────X │         │         │
│  └─────────┘                           └─────────┘         │
│                                                             │
│  Without cancellation: App keeps downloading in background  │
│  With cancellation: Request stops immediately, saves data   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Upload/Download Progress

```dart
// File upload with progress
Future<void> uploadFile(String filePath) async {
  FormData formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      filePath,
      filename: 'upload.jpg',
    ),
  });

  await dio.post(
    '/upload',
    data: formData,
    onSendProgress: (sent, total) {
      double progress = sent / total * 100;
      print('Upload progress: ${progress.toStringAsFixed(0)}%');
    },
  );
}

// File download with progress
Future<void> downloadFile(String url, String savePath) async {
  await dio.download(
    url,
    savePath,
    onReceiveProgress: (received, total) {
      if (total != -1) {
        double progress = received / total * 100;
        print('Download progress: ${progress.toStringAsFixed(0)}%');
      }
    },
  );
}
```

---

## Complete Dio Service Example

```dart
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      _ErrorInterceptor(),
    ]);
  }

  // Set auth token (call after login)
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // GET all users
  Future<List<dynamic>> getUsers() async {
    final response = await _dio.get('/users');
    return response.data;
  }

  // GET single user
  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await _dio.get('/users/$id');
    return response.data;
  }

  // POST create user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    final response = await _dio.post('/users', data: data);
    return response.data;
  }

  // PUT update user
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> data) async {
    final response = await _dio.put('/users/$id', data: data);
    return response.data;
  }

  // DELETE user
  Future<void> deleteUser(int id) async {
    await _dio.delete('/users/$id');
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(err.response?.statusCode);
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      default:
        message = 'Something went wrong.';
    }

    print('API Error: $message');
    handler.next(err);
  }

  String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Not found.';
      case 500:
        return 'Server error. Try again later.';
      default:
        return 'Error: $statusCode';
    }
  }
}

// Usage
void main() async {
  final api = ApiService();

  // Get all users
  final users = await api.getUsers();
  print('Got ${users.length} users');

  // Create a user
  final newUser = await api.createUser({
    'name': 'John Doe',
    'email': 'john@example.com',
  });
  print('Created: ${newUser['id']}');
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    DIO CHEAT SHEET                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SETUP:                                                     │
│  dependencies:                                              │
│    dio: ^5.4.0                                              │
│                                                             │
│  CREATE INSTANCE:                                           │
│  final dio = Dio(BaseOptions(                               │
│    baseUrl: 'https://api.com',                              │
│    connectTimeout: Duration(seconds: 5),                    │
│  ));                                                        │
│                                                             │
│  REQUESTS:                                                  │
│  dio.get('/path')           // Auto-parses JSON!            │
│  dio.post('/path', data: {})                                │
│  dio.put('/path', data: {})                                 │
│  dio.patch('/path', data: {})                               │
│  dio.delete('/path')                                        │
│                                                             │
│  QUERY PARAMS:                                              │
│  dio.get('/path', queryParameters: {'key': 'value'})        │
│                                                             │
│  INTERCEPTORS:                                              │
│  dio.interceptors.add(MyInterceptor())                      │
│                                                             │
│  ERROR HANDLING:                                            │
│  on DioException catch (e) {                                │
│    e.type       // Error type                               │
│    e.response   // Server response (if any)                 │
│    e.message    // Error message                            │
│  }                                                          │
│                                                             │
│  CANCELLATION:                                              │
│  final token = CancelToken();                               │
│  dio.get('/path', cancelToken: token);                      │
│  token.cancel();                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← http Package](./04-HttpPackage.md) | [Next: Error Handling →](./06-ErrorHandling.md)
