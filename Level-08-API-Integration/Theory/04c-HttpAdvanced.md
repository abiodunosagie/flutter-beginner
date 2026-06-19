# The http Package - Part 3: Headers and Authentication

## The Big Idea In One Sentence

> Headers are extra notes on your request, and the most important one proves who you are: usually `Authorization: Bearer <token>` so the server lets you in.

Learn about HTTP headers, authentication, and advanced request patterns!

---

## Adding Headers

### What are Headers?

Headers are like the envelope information on a letter - they tell the server extra information about your request.

```
┌─────────────────────────────────────────────────────────────┐
│                    COMMON HEADERS                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  HEADER              │ PURPOSE                              │
│  ────────────────────────────────────────────────────────── │
│  Content-Type        │ What format you're SENDING           │
│    application/json  │                                      │
│                                                             │
│  Accept              │ What format you WANT back            │
│    application/json  │                                      │
│                                                             │
│  Authorization       │ Prove who you are                    │
│    Bearer <token>    │                                      │
│                                                             │
│  X-API-Key           │ API authentication key               │
│    <your-key>        │                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Using Headers

```dart
Future<void> fetchWithHeaders() async {
  final url = Uri.parse('https://api.example.com/protected');

  final response = await http.get(
    url,
    headers: {
      // Authentication
      'Authorization': 'Bearer your-token-here',

      // Content negotiation
      'Accept': 'application/json',

      // Custom headers
      'X-Custom-Header': 'custom-value',

      // API keys (some APIs use this)
      'X-API-Key': 'your-api-key',
    },
  );

  // Process response...
}
```

---

## Authentication Patterns

### 1. API Key Authentication

```dart
class ApiService {
  static const String apiKey = 'your-api-key-here';

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
      Uri.parse('https://api.example.com/data'),
      headers: {
        'X-API-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch data');
  }
}
```

### 2. Bearer Token Authentication

```dart
class AuthService {
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Future<Map<String, dynamic>> fetchProtectedData() async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('https://api.example.com/protected'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 401) {
      throw Exception('Token expired or invalid');
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Failed to fetch data');
  }
}

// Usage:
void main() async {
  final service = AuthService();

  // After user logs in, set the token
  service.setToken('user-jwt-token-here');

  // Now make authenticated requests
  final data = await service.fetchProtectedData();
}
```

### 3. Basic Authentication

```dart
import 'dart:convert';

Future<void> basicAuthRequest() async {
  String username = 'user';
  String password = 'pass123';

  // Encode credentials
  String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  final response = await http.get(
    Uri.parse('https://api.example.com/data'),
    headers: {
      'Authorization': basicAuth,
    },
  );

  if (response.statusCode == 200) {
    print('Success!');
  }
}
```

---

## Timeout Handling

```dart
Future<Map<String, dynamic>> fetchWithTimeout() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/data'),
    ).timeout(
      const Duration(seconds: 10),  // Wait maximum 10 seconds
      onTimeout: () {
        throw Exception('Request timed out');
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch data');
  } on Exception catch (e) {
    print('Error: $e');
    rethrow;
  }
}
```

---

## Complete Authenticated Service

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;
  String? _authToken;

  ApiClient({required this.baseUrl});

  // Set auth token after login
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token on logout
  void clearAuthToken() {
    _authToken = null;
  }

  // Get default headers
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // GET request
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // DELETE request
  Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    _handleResponse(response);
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error - Please try again later');
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }
}

// Usage:
void main() async {
  final api = ApiClient(baseUrl: 'https://api.example.com');

  // Login and get token
  final loginData = await api.post('/auth/login', {
    'email': 'user@example.com',
    'password': 'password123',
  });

  // Set token for future requests
  api.setAuthToken(loginData['token']);

  // Now all requests are authenticated!
  final users = await api.get('/users');
  print('Fetched ${users.length} users');

  // Create new resource
  final newPost = await api.post('/posts', {
    'title': 'Hello',
    'body': 'World',
  });

  // Logout
  api.clearAuthToken();
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               http PACKAGE - ADVANCED                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  HEADERS:                                                   │
│  headers: {                                                 │
│    'Content-Type': 'application/json',                      │
│    'Authorization': 'Bearer token',                         │
│    'X-API-Key': 'key',                                      │
│  }                                                          │
│                                                             │
│  AUTHENTICATION:                                            │
│  • API Key: X-API-Key header                                │
│  • Bearer Token: Authorization: Bearer <token>              │
│  • Basic Auth: base64(username:password)                    │
│                                                             │
│  TIMEOUT:                                                   │
│  http.get(url).timeout(Duration(seconds: 10))               │
│                                                             │
│  BEST PRACTICES:                                            │
│  • Create a reusable API client class                       │
│  • Store auth tokens securely                               │
│  • Handle 401 errors (re-login)                             │
│  • Use timeouts for all requests                            │
│  • Check status codes properly                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Excellent! You now know how to use the http package effectively. Next, you'll learn about Dio - a more powerful HTTP client!

---

## Quick Quiz

**Q1.** What header usually carries a login token?

<details>
<summary>Answer</summary>
`Authorization`, with the value `Bearer <token>`.
</details>

**Q2.** A protected request returns `401`. What does that mean?

<details>
<summary>Answer</summary>
Unauthorized: the token is missing, wrong, or expired. The user needs to log in again.
</details>

**Q3.** Why add `.timeout(Duration(seconds: 10))` to a request?

<details>
<summary>Answer</summary>
So the app does not wait forever if the network hangs; it fails after 10 seconds and you can show an error.
</details>

---

## Assignment

### Problem 1: Add the token

Write the `headers` map for an authenticated GET, sending a bearer token stored in `token`.

### Problem 2: React to 401

In a response handler, what should happen when you get `401`?

### Problem 3: Why a reusable client?

Give one reason to put all this in one `ApiClient` class instead of repeating headers in every call.

---

## Assignment Answers

### Problem 1: Add the token

```dart
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
},
```

### Problem 2: React to 401

Treat it as "not logged in": throw/handle an auth error and send the user to log in again (and clear the old token).

### Problem 3: Why a reusable client?

Any one: the auth header is set in one place, every request stays consistent, and you fix bugs or change the base URL once instead of in dozens of calls.

---

**Continue to:** [05a-DioIntro.md](./05a-DioIntro.md) - Discover the powerful Dio package!

---

[← Previous: HTTP Methods](./04b-HttpMethods.md) | [⬆️ Back to Learning Path](./00-LearningPath.md) | [➡️ Next: Dio Introduction](./05a-DioIntro.md)

---

## Navigation

⬅️ **Previous:** [Http Methods](04b-HttpMethods.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Dio Introduction](05a-DioIntro.md)
