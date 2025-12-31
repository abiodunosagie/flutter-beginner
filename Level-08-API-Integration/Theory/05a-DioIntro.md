# Dio Package Introduction

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

**Simple Analogy:**
Imagine http is like sending a letter. You write it, put it in the mailbox, and hope it gets there. Dio is like using a professional delivery service with tracking, insurance, and custom features!

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

**Think About It:**
- Learning to make a sandwich → http package (simple!)
- Running a restaurant → Dio (need professional tools!)

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

**Analogy:**
`baseUrl` is like your home address. Instead of writing the full address every time, you just say "living room", "bedroom", etc. Dio prepends your home address automatically!

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

**Why Dio is Better:**
- No need for `Uri.parse()` - just use strings!
- No need for `json.decode()` - Dio does it automatically!
- Less code to write, less things to remember!

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

**Notice:**
- No `json.encode()` needed! Dio handles it!
- Use `DioException` instead of generic exceptions
- Response data is already a Map, not a String!

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

## Summary: Why Use Dio?

```
┌─────────────────────────────────────────────────────────────┐
│                   DIO ADVANTAGES                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ Automatic JSON parsing (no json.decode/encode)          │
│  ✓ BaseUrl configuration (no Uri.parse)                    │
│  ✓ Better error handling (DioException types)              │
│  ✓ Interceptors (add tokens, log requests)                 │
│  ✓ Request cancellation                                    │
│  ✓ Upload/download progress                                │
│  ✓ Timeout configuration                                   │
│  ✓ FormData support for file uploads                       │
│  ✓ Built-in retry mechanism                                │
│  ✓ Better TypeScript-like typing                           │
│                                                             │
│  CODE COMPARISON:                                           │
│  ────────────────                                           │
│  http: 5-10 lines per request                              │
│  Dio: 2-3 lines per request                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### What We Learned

1. **Dio vs http**: Dio is more powerful and easier to use
2. **Setup**: Just add to pubspec.yaml and import
3. **BaseOptions**: Configure once, use everywhere
4. **Automatic JSON**: No more manual parsing!
5. **All HTTP Methods**: GET, POST, PUT, PATCH, DELETE
6. **DioException**: Better error handling than http

### Continue Learning

Continue to: [05b-DioFeatures.md](./05b-DioFeatures.md) - Learn about Interceptors and advanced Dio features!

---

[Back to Learning Path](./00-LearningPath.md)

---

## Navigation

⬅️ **Previous:** [Http Advanced](04c-HttpAdvanced.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Dio Features](05b-DioFeatures.md)
