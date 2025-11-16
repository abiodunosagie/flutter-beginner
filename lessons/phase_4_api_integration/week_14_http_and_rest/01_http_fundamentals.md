# Week 14, Day 1-4: HTTP and REST APIs - Connecting to the World

## What is an API?

**API** = **A**pplication **P**rogramming **I**nterface

Think of an API as a **restaurant:**

- **You** (your app) = Customer
- **API** = Waiter/Waitress
- **Server/Database** = Kitchen

**How it works:**
1. You look at the menu (API documentation)
2. You order food (make a request)
3. Waiter takes order to kitchen (API processes request)
4. Kitchen prepares food (server gets data)
5. Waiter brings food back (API returns response)
6. You eat (your app uses the data)

**Real examples:**
- Weather app → Asks weather API for forecast → Displays it
- Instagram → Asks Instagram API for posts → Shows them
- Uber → Sends location to Uber API → Gets nearby drivers

---

## What is REST?

**REST** = **RE**presentational **S**tate **T**ransfer

It's a set of rules for how APIs should work. Most modern APIs are RESTful.

**REST Principles (simplified):**
1. **URLs represent resources** (users, posts, products)
2. **HTTP methods define actions** (GET, POST, PUT, DELETE)
3. **Stateless** (each request is independent)
4. **Returns data** (usually JSON)

---

## HTTP Methods - The CRUD Operations

| HTTP Method | Action | Database Equivalent | Example |
|-------------|--------|---------------------|---------|
| **GET** | Read/Retrieve | SELECT | Get user profile |
| **POST** | Create | INSERT | Create new user |
| **PUT** | Update/Replace | UPDATE | Update user profile |
| **DELETE** | Delete | DELETE | Delete user account |

**Remember:** **C**reate, **R**ead, **U**pdate, **D**elete = **CRUD**

### GET - Retrieve Data

**Purpose:** Get data from the server (doesn't change anything)

**Examples:**
```
GET https://api.example.com/users           → Get all users
GET https://api.example.com/users/123       → Get user with ID 123
GET https://api.example.com/posts?limit=10  → Get 10 posts
```

### POST - Create New Data

**Purpose:** Send data to create something new

**Examples:**
```
POST https://api.example.com/users          → Create a new user
POST https://api.example.com/posts          → Create a new post
```

**Sends data in the body** (JSON)

### PUT - Update Existing Data

**Purpose:** Update an existing resource

**Examples:**
```
PUT https://api.example.com/users/123       → Update user 123
PUT https://api.example.com/posts/456       → Update post 456
```

**Sends updated data in the body** (JSON)

### DELETE - Remove Data

**Purpose:** Delete a resource

**Examples:**
```
DELETE https://api.example.com/users/123    → Delete user 123
DELETE https://api.example.com/posts/456    → Delete post 456
```

---

## Anatomy of an HTTP Request

Every HTTP request has:

### 1. URL (Endpoint)

```
https://api.example.com/users/123
└─────┬─────┘ └───┬───┘ └──┬─┘└┬┘
   Protocol    Domain   Path  ID
```

### 2. Method

GET, POST, PUT, DELETE

### 3. Headers (Metadata)

```
Content-Type: application/json
Authorization: Bearer abc123xyz
Accept: application/json
```

**Common headers:**
- `Content-Type`: What type of data you're sending (usually `application/json`)
- `Authorization`: Your API key or token
- `Accept`: What type of response you want

### 4. Body (For POST/PUT)

The data you're sending (usually JSON):

```json
{
  "name": "Alice",
  "email": "alice@example.com",
  "age": 25
}
```

---

## Anatomy of an HTTP Response

The server sends back:

### 1. Status Code

Tells you if the request succeeded:

| Code | Meaning | Example |
|------|---------|---------|
| **200** | OK - Success | GET request succeeded |
| **201** | Created | POST created new resource |
| **204** | No Content | DELETE succeeded |
| **400** | Bad Request | Invalid data sent |
| **401** | Unauthorized | Not logged in |
| **403** | Forbidden | No permission |
| **404** | Not Found | Resource doesn't exist |
| **500** | Server Error | Server crashed |

**Categories:**
- **2xx** = Success
- **3xx** = Redirection
- **4xx** = Client error (you messed up)
- **5xx** = Server error (server messed up)

### 2. Headers

```
Content-Type: application/json
Date: Mon, 01 Jan 2024 12:00:00 GMT
```

### 3. Body

The actual data (usually JSON):

```json
{
  "id": 123,
  "name": "Alice",
  "email": "alice@example.com"
}
```

---

## Using the `http` Package in Flutter/Dart

### Step 1: Add Dependency

In `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
```

Run:
```bash
flutter pub get
```

Or for pure Dart projects:
```bash
dart pub add http
```

### Step 2: Import the Package

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
```

**Note:** We import as `http` to use it like `http.get()`, `http.post()`, etc.

---

## Making GET Requests

### Simple Example: Get Data

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  // Make GET request
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/1')
  );

  // Check if successful
  if (response.statusCode == 200) {
    // Parse JSON
    Map<String, dynamic> user = jsonDecode(response.body);
    print('Name: ${user['name']}');
    print('Email: ${user['email']}');
  } else {
    print('Error: ${response.statusCode}');
  }
}
```

**Breaking it down:**

1. **`await`** - Wait for response (async operation)
2. **`http.get()`** - Makes GET request
3. **`Uri.parse()`** - Converts string to URI
4. **`response.statusCode`** - Check if successful (200 = OK)
5. **`response.body`** - The JSON string
6. **`jsonDecode()`** - Parse JSON to Map

### Using with Models

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<User> fetchUser(int userId) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$userId')
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

void main() async {
  try {
    User user = await fetchUser(1);
    print('${user.name} - ${user.email}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Fetching a List

```dart
Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users')
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

void main() async {
  List<User> users = await fetchUsers();

  for (User user in users) {
    print(user.name);
  }
}
```

---

## Making POST Requests - Creating Data

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> createUser() async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'name': 'Alice Smith',
      'email': 'alice@example.com',
      'age': 25,
    }),
  );

  if (response.statusCode == 201) {
    print('User created successfully!');
    print('Response: ${response.body}');
  } else {
    print('Failed to create user');
  }
}

void main() async {
  await createUser();
}
```

**Key points:**
- **POST** to create new resource
- **headers** specify we're sending JSON
- **body** contains the JSON data (as string)
- **201** status code means "Created"

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
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 201) {
    print('User created!');
  } else {
    print('Error: ${response.statusCode}');
  }
}

void main() async {
  User newUser = User(
    name: 'Bob Johnson',
    email: 'bob@example.com',
    age: 30,
  );

  await createUser(newUser);
}
```

---

## Making PUT Requests - Updating Data

```dart
Future<void> updateUser(int userId) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': 'Updated Name',
      'email': 'updated@example.com',
    }),
  );

  if (response.statusCode == 200) {
    print('User updated successfully!');
  } else {
    print('Failed to update');
  }
}
```

---

## Making DELETE Requests

```dart
Future<void> deleteUser(int userId) async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    print('User deleted successfully!');
  } else {
    print('Failed to delete user');
  }
}
```

---

## Query Parameters

Add filters or options to GET requests:

```
https://api.example.com/posts?userId=1&limit=10
                              └───────┬───────┘
                              Query Parameters
```

**In Dart:**

```dart
Future<void> fetchPosts() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts').replace(
    queryParameters: {
      'userId': '1',
      'limit': '5',
    },
  );

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> posts = jsonDecode(response.body);
    print('Found ${posts.length} posts');
  }
}
```

**Or build URI directly:**

```dart
final uri = Uri.https(
  'jsonplaceholder.typicode.com',
  '/posts',
  {'userId': '1', 'limit': '5'},
);
```

---

## Error Handling

### Basic Try-Catch

```dart
Future<User> fetchUser(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id')
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;  // Re-throw to let caller handle it
  }
}
```

### Handle Specific Status Codes

```dart
Future<User> fetchUser(int id) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id')
  );

  switch (response.statusCode) {
    case 200:
      return User.fromJson(jsonDecode(response.body));
    case 404:
      throw Exception('User not found');
    case 401:
      throw Exception('Unauthorized - please login');
    case 500:
      throw Exception('Server error - try again later');
    default:
      throw Exception('Unknown error: ${response.statusCode}');
  }
}
```

### Timeout Handling

```dart
Future<User> fetchUser(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id')
    ).timeout(Duration(seconds: 10));  // 10 second timeout

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  } on TimeoutException {
    throw Exception('Request timed out - check your internet connection');
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
```

---

## Authentication - API Keys and Tokens

Many APIs require authentication:

### API Key in Header

```dart
Future<void> fetchData() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/data'),
    headers: {
      'Authorization': 'Bearer YOUR_API_KEY_HERE',
      'Content-Type': 'application/json',
    },
  );

  // ... handle response
}
```

### API Key in Query Parameter

```dart
final uri = Uri.https(
  'api.example.com',
  '/data',
  {'apiKey': 'YOUR_API_KEY'},
);

final response = await http.get(uri);
```

---

## Real API Example: JSONPlaceholder

**JSONPlaceholder** is a free fake API for testing: `https://jsonplaceholder.typicode.com`

### Endpoints:

```
GET    /posts           → All posts
GET    /posts/1         → Post with ID 1
POST   /posts           → Create post
PUT    /posts/1         → Update post 1
DELETE /posts/1         → Delete post 1
GET    /users           → All users
GET    /comments        → All comments
```

### Complete Example:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body, 'userId': 1};
  }
}

// Fetch all posts
Future<List<Post>> fetchPosts() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts')
  );

  if (response.statusCode == 200) {
    List<dynamic> json = jsonDecode(response.body);
    return json.map((p) => Post.fromJson(p)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

// Create new post
Future<Post> createPost(Post post) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(post.toJson()),
  );

  if (response.statusCode == 201) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create post');
  }
}

void main() async {
  // Fetch posts
  print('Fetching posts...');
  List<Post> posts = await fetchPosts();
  print('Found ${posts.length} posts');
  print('First post: ${posts[0].title}');

  // Create new post
  print('\nCreating new post...');
  Post newPost = Post(id: 0, title: 'My Post', body: 'This is great!');
  Post created = await createPost(newPost);
  print('Created post with ID: ${created.id}');
}
```

---

## Best Practices

### 1. Separate API Logic

Create a dedicated API service class:

```dart
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      // ... parse and return
    }
    throw Exception('Failed');
  }

  Future<Post> createPost(Post post) async {
    // ... implementation
  }
}
```

### 2. Handle Errors Properly

Always wrap in try-catch and provide helpful messages.

### 3. Use Timeouts

Prevent indefinite waiting:
```dart
await http.get(uri).timeout(Duration(seconds: 10));
```

### 4. Check Status Codes

Don't assume success - always check the status code.

### 5. Use Environment Variables for API Keys

Never hardcode API keys in your code!

---

## Exercises

### Exercise 1: Fetch and Display Users

Use JSONPlaceholder to fetch all users and print their names.

**URL:** `https://jsonplaceholder.typicode.com/users`

<details>
<summary>Solution</summary>

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users')
  );

  if (response.statusCode == 200) {
    List<dynamic> users = jsonDecode(response.body);
    for (var user in users) {
      print(user['name']);
    }
  } else {
    print('Error: ${response.statusCode}');
  }
}

void main() async {
  await fetchUsers();
}
```
</details>

---

### Exercise 2: Create a Post

Create a new post with your own title and body.

**URL:** `https://jsonplaceholder.typicode.com/posts`

<details>
<summary>Solution</summary>

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> createPost() async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': 'My First API Post',
      'body': 'Learning HTTP requests in Dart!',
      'userId': 1,
    }),
  );

  if (response.statusCode == 201) {
    print('Post created successfully!');
    print('Response: ${response.body}');
  }
}

void main() async {
  await createPost();
}
```
</details>

---

## Key Takeaways

1. **APIs let apps communicate with servers**
2. **REST uses standard HTTP methods:** GET, POST, PUT, DELETE
3. **Status codes tell you what happened:** 2xx = success, 4xx = client error, 5xx = server error
4. **Always handle errors** with try-catch
5. **Use models** for type-safe JSON parsing
6. **Add timeouts** to prevent infinite waiting

---

## What's Next?

Tomorrow:
- **FutureBuilder in Flutter** - Display API data in UI
- **Loading states** - Show spinners while loading
- **Error states** - Handle failures gracefully
- **Pull-to-refresh** - Let users refresh data

You can now talk to APIs! This is huge - you're ready to build real apps! 🌐🚀
