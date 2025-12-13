# API Integration Cheatsheet

Quick reference for working with APIs in Flutter/Dart.

---

## Setup

### Add Dependency

**pubspec.yaml:**
```yaml
dependencies:
  http: ^1.1.0
```

Then run:
```bash
flutter pub get
```

### Import

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
```

---

## HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| **GET** | Retrieve data | Get user profile |
| **POST** | Create new data | Create new user |
| **PUT** | Update data | Update user info |
| **DELETE** | Delete data | Delete user |

---

## GET Request

### Basic GET

```dart
Future<void> fetchData() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users')
  );

  if (response.statusCode == 200) {
    // Success
    var data = jsonDecode(response.body);
    print(data);
  } else {
    // Error
    print('Error: ${response.statusCode}');
  }
}
```

### GET with Model

```dart
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

Future<User> fetchUser(int id) async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users/$id')
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}
```

### GET List

```dart
Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users')
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
```

---

## POST Request

### Basic POST

```dart
Future<void> createUser() async {
  final response = await http.post(
    Uri.parse('https://api.example.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': 'Alice',
      'email': 'alice@example.com',
      'age': 25,
    }),
  );

  if (response.statusCode == 201) {
    print('User created!');
  } else {
    print('Failed');
  }
}
```

### POST with Model

```dart
class User {
  final String name;
  final String email;
  final int age;

  User({required this.name, required this.email, required this.age});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
    };
  }
}

Future<void> createUser(User user) async {
  final response = await http.post(
    Uri.parse('https://api.example.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 201) {
    print('Success');
  }
}
```

---

## PUT Request

```dart
Future<void> updateUser(int id, String newName) async {
  final response = await http.put(
    Uri.parse('https://api.example.com/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': newName,
    }),
  );

  if (response.statusCode == 200) {
    print('Updated');
  }
}
```

---

## DELETE Request

```dart
Future<void> deleteUser(int id) async {
  final response = await http.delete(
    Uri.parse('https://api.example.com/users/$id')
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    print('Deleted');
  }
}
```

---

## Query Parameters

### Method 1: URI.replace()

```dart
final uri = Uri.parse('https://api.example.com/posts').replace(
  queryParameters: {
    'userId': '1',
    'limit': '10',
  },
);

final response = await http.get(uri);
```

### Method 2: Uri.https()

```dart
final uri = Uri.https(
  'api.example.com',
  '/posts',
  {'userId': '1', 'limit': '10'},
);

final response = await http.get(uri);
```

Result: `https://api.example.com/posts?userId=1&limit=10`

---

## Headers

### Adding Headers

```dart
final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_TOKEN_HERE',
    'Accept': 'application/json',
  },
);
```

### Common Headers

| Header | Purpose | Example |
|--------|---------|---------|
| `Content-Type` | Type of data being sent | `application/json` |
| `Authorization` | Authentication token | `Bearer abc123` |
| `Accept` | Type of response wanted | `application/json` |
| `User-Agent` | Client identification | `MyApp/1.0` |

---

## Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| **200** | OK | Success |
| **201** | Created | Resource created |
| **204** | No Content | Success, no data |
| **400** | Bad Request | Check your data |
| **401** | Unauthorized | Login required |
| **403** | Forbidden | No permission |
| **404** | Not Found | Resource doesn't exist |
| **500** | Server Error | Server problem |

### Handling Status Codes

```dart
switch (response.statusCode) {
  case 200:
    return parseData(response.body);
  case 404:
    throw Exception('Not found');
  case 401:
    throw Exception('Please login');
  case 500:
    throw Exception('Server error');
  default:
    throw Exception('Unknown error: ${response.statusCode}');
}
```

---

## Error Handling

### Basic Try-Catch

```dart
try {
  User user = await fetchUser(1);
  print(user.name);
} catch (e) {
  print('Error: $e');
}
```

### With Timeout

```dart
import 'dart:async';

try {
  final response = await http.get(
    Uri.parse('https://api.example.com/data')
  ).timeout(Duration(seconds: 10));

  // Process response
} on TimeoutException {
  print('Request timed out');
} catch (e) {
  print('Error: $e');
}
```

### Complete Error Handling

```dart
Future<User> fetchUser(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/users/$id')
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } on TimeoutException {
    throw Exception('Request timed out');
  } on FormatException {
    throw Exception('Invalid JSON format');
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
```

---

## JSON Parsing

### Simple Object

**JSON:**
```json
{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com"
}
```

**Dart:**
```dart
Map<String, dynamic> user = jsonDecode(response.body);
String name = user['name'];
```

### Array

**JSON:**
```json
[
  {"id": 1, "name": "Alice"},
  {"id": 2, "name": "Bob"}
]
```

**Dart:**
```dart
List<dynamic> users = jsonDecode(response.body);
String firstName = users[0]['name'];
```

### Nested Object

**JSON:**
```json
{
  "user": {
    "name": "Alice",
    "address": {
      "city": "NYC"
    }
  }
}
```

**Dart:**
```dart
Map<String, dynamic> data = jsonDecode(response.body);
String city = data['user']['address']['city'];
```

---

## Data Models

### Complete Model

```dart
class User {
  final int id;
  final String name;
  final String email;
  final int? age;  // Nullable

  User({
    required this.id,
    required this.name,
    required this.email,
    this.age,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, age: $age)';
  }
}
```

### Parsing List

```dart
List<User> parseUsers(String responseBody) {
  List<dynamic> jsonList = jsonDecode(responseBody);
  return jsonList.map((json) => User.fromJson(json)).toList();
}
```

---

## API Service Class

```dart
class ApiService {
  static const String baseUrl = 'https://api.example.com';

  // GET request
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((u) => User.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // POST request
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  // PUT request
  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // DELETE request
  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id')
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
```

---

## FutureBuilder (Flutter)

```dart
class UserList extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: api.getUsers(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Error state
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Success state
        if (snapshot.hasData) {
          List<User> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
              );
            },
          );
        }

        // Empty state
        return Text('No data');
      },
    );
  }
}
```

---

## Testing APIs

### Free Test APIs

| API | URL | Purpose |
|-----|-----|---------|
| JSONPlaceholder | `jsonplaceholder.typicode.com` | Users, posts, comments |
| ReqRes | `reqres.in/api` | Users with pagination |
| Dog CEO | `dog.ceo/api` | Dog images |
| REST Countries | `restcountries.com/v3.1` | Country data |

### Example Endpoints

```dart
// JSONPlaceholder
'https://jsonplaceholder.typicode.com/users'        // All users
'https://jsonplaceholder.typicode.com/users/1'      // User with ID 1
'https://jsonplaceholder.typicode.com/posts'        // All posts
'https://jsonplaceholder.typicode.com/comments'     // All comments
```

---

## Common Patterns

### Retry Logic

```dart
Future<T> retryRequest<T>(
  Future<T> Function() request,
  {int maxAttempts = 3}
) async {
  for (int i = 0; i < maxAttempts; i++) {
    try {
      return await request();
    } catch (e) {
      if (i == maxAttempts - 1) rethrow;
      await Future.delayed(Duration(seconds: i + 1));
    }
  }
  throw Exception('Max retries exceeded');
}
```

### Caching

```dart
class CachedApiService {
  final Map<String, dynamic> _cache = {};

  Future<dynamic> getCached(String key, Future<dynamic> Function() fetch) async {
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    final data = await fetch();
    _cache[key] = data;
    return data;
  }
}
```

---

## Quick Reference

| Task | Code |
|------|------|
| GET | `http.get(Uri.parse(url))` |
| POST | `http.post(uri, headers: {...}, body: json)` |
| PUT | `http.put(uri, headers: {...}, body: json)` |
| DELETE | `http.delete(Uri.parse(url))` |
| Parse JSON | `jsonDecode(response.body)` |
| Create JSON | `jsonEncode(dartObject)` |
| Timeout | `.timeout(Duration(seconds: 10))` |
| Headers | `headers: {'Key': 'Value'}` |

---

**Keep this handy when working with APIs!**
