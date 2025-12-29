# Level 08: API Integration Exercises

## How These Exercises Work

Each skill is broken into **small steps**. Complete each step before moving to the next. By the end, you'll combine everything into a complete app!

```
THE PROGRESSIVE LEARNING PATH:

Step 1: Learn one tiny piece ──────────────► Practice it
Step 2: Learn next tiny piece ─────────────► Practice it
Step 3: Learn next tiny piece ─────────────► Practice it
...
Final: Combine ALL pieces ─────────────────► Build complete app!
```

---

# PART 1: DATA MODELS

## Exercise 1.1: Create Model Properties

**Goal:** Define the properties of a User model.

**Your Task:** Fill in the properties for a User class.

```dart
// The API returns this JSON:
// {
//   "id": 1,
//   "name": "John Doe",
//   "email": "john@example.com",
//   "phone": "123-456-7890"
// }

class User {
  // TODO: Add 4 properties
  // - id (int)
  // - name (String)
  // - email (String)
  // - phone (String)
}
```

<details>
<summary>✅ Solution</summary>

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
}
```

</details>

---

## Exercise 1.2: Add Constructor

**Goal:** Add a constructor to your User model.

**Your Task:** Create a constructor that requires all properties.

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  // TODO: Add constructor
  // Use the 'required' keyword for all parameters
}
```

<details>
<summary>✅ Solution</summary>

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}
```

</details>

---

## Exercise 1.3: Create fromJson Factory

**Goal:** Convert JSON data to a User object.

**Your Task:** Write the fromJson factory constructor.

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // TODO: Create factory fromJson
  // Input: Map<String, dynamic> json
  // Output: User object
  //
  // JSON keys are: 'id', 'name', 'email', 'phone'
}
```

<details>
<summary>✅ Solution</summary>

```dart
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
  );
}
```

</details>

---

## Exercise 1.4: Create toJson Method

**Goal:** Convert a User object back to JSON.

**Your Task:** Write the toJson method.

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  // TODO: Create toJson method
  // Output: Map<String, dynamic>
}
```

<details>
<summary>✅ Solution</summary>

```dart
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
  };
}
```

</details>

---

## Exercise 1.5: Handle Nullable Fields

**Goal:** Handle optional/nullable fields from API.

Sometimes APIs return null for some fields. Let's handle that.

**Your Task:** Make phone nullable and handle it in fromJson.

```dart
// API might return:
// {
//   "id": 1,
//   "name": "John Doe",
//   "email": "john@example.com",
//   "phone": null  <-- could be null!
// }

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;  // Now nullable!

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,  // Not required anymore
  });

  // TODO: Update fromJson to handle nullable phone
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      // TODO: Handle phone being null
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],  // Dart handles null automatically for nullable types
  );
}

// OR with explicit null check:
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'] as String?,
  );
}
```

</details>

---

## Exercise 1.6: Complete Model Challenge

**Goal:** Build a complete Post model from scratch WITHOUT looking at solutions.

**Your Task:** Create a complete Post model for this API response:

```json
{
  "id": 1,
  "userId": 1,
  "title": "My First Post",
  "body": "This is the content...",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

Requirements:
- All properties with correct types
- Constructor with required parameters (createdAt can be nullable)
- fromJson factory
- toJson method

```dart
// TODO: Create complete Post model below
class Post {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime? createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
```

</details>

---

# PART 2: HTTP REQUESTS

## Exercise 2.1: Simple GET Request

**Goal:** Make your first HTTP GET request.

**Your Task:** Complete the function to fetch data from an API.

```dart
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  // TODO: Make a GET request to this URL:
  // https://jsonplaceholder.typicode.com/posts/1

  // Step 1: Create the URL using Uri.parse()

  // Step 2: Make the GET request using http.get()

  // Step 3: Print the response body
}
```

<details>
<summary>✅ Solution</summary>

```dart
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  // Step 1: Create the URL
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  // Step 2: Make the GET request
  final response = await http.get(url);

  // Step 3: Print the response body
  print(response.body);
}
```

</details>

---

## Exercise 2.2: Check Response Status

**Goal:** Check if the request was successful.

**Your Task:** Add status code checking.

```dart
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  // TODO: Check if status code is 200 (success)
  // If success: print "Success!" and the body
  // If not: print "Error: " and the status code
}
```

<details>
<summary>✅ Solution</summary>

```dart
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print('Success!');
    print(response.body);
  } else {
    print('Error: ${response.statusCode}');
  }
}
```

</details>

---

## Exercise 2.3: Parse JSON Response

**Goal:** Convert JSON string to Dart Map.

**Your Task:** Parse the JSON response.

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // TODO: Convert response.body (String) to Map
    // Use json.decode() from dart:convert
    // Then print the 'title' field
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print('Title: ${data['title']}');
  }
}
```

</details>

---

## Exercise 2.4: Return a Model Object

**Goal:** Return a typed object instead of raw data.

**Your Task:** Return a Post object from the API.

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
}

// TODO: Change return type to Future<Post>
// TODO: Return a Post object instead of printing
Future<void> fetchPost() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // TODO: Create and return Post object
  }
  // TODO: Throw exception if not successful
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<Post> fetchPost() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Post.fromJson(data);
  } else {
    throw Exception('Failed to load post: ${response.statusCode}');
  }
}
```

</details>

---

## Exercise 2.5: Fetch a List of Items

**Goal:** Fetch and parse multiple items.

**Your Task:** Fetch a list of posts.

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final int id;
  final String title;

  Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title']);
  }
}

// TODO: Fetch list of posts from:
// https://jsonplaceholder.typicode.com/posts
//
// The API returns an array: [ {post1}, {post2}, ... ]
// Convert each item to a Post object

Future<List<Post>> fetchPosts() async {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<List<Post>> fetchPosts() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}
```

</details>

---

## Exercise 2.6: Make a POST Request

**Goal:** Send data to create a new resource.

**Your Task:** Create a new post via POST request.

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO: Create a function to POST a new post
// URL: https://jsonplaceholder.typicode.com/posts
//
// Required headers: {'Content-Type': 'application/json'}
// Body should be JSON with: title, body, userId
//
// Return the created Post (API returns it with new id)

Future<Post> createPost({
  required String title,
  required String body,
  required int userId,
}) async {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<Post> createPost({
  required String title,
  required String body,
  required int userId,
}) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'title': title,
      'body': body,
      'userId': userId,
    }),
  );

  if (response.statusCode == 201) {  // 201 = Created
    final data = json.decode(response.body);
    return Post.fromJson(data);
  } else {
    throw Exception('Failed to create post');
  }
}
```

</details>

---

## Exercise 2.7: Complete API Service Challenge

**Goal:** Build a complete API service WITHOUT looking at solutions.

**Your Task:** Create a UserService with all CRUD operations.

API Endpoints:
- GET https://jsonplaceholder.typicode.com/users
- GET https://jsonplaceholder.typicode.com/users/{id}
- POST https://jsonplaceholder.typicode.com/users
- PUT https://jsonplaceholder.typicode.com/users/{id}
- DELETE https://jsonplaceholder.typicode.com/users/{id}

```dart
class User {
  final int? id;
  final String name;
  final String email;

  User({this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };
}

// TODO: Create complete UserService with:
// - getUsers() -> List<User>
// - getUser(int id) -> User
// - createUser(User user) -> User
// - updateUser(User user) -> User
// - deleteUser(int id) -> void

class UserService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
class UserService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users');
  }

  Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load user');
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create user');
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update user');
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
```

</details>

---

# PART 3: UI INTEGRATION

## Exercise 3.1: Display Loading State

**Goal:** Show a loading spinner while fetching data.

**Your Task:** Add loading state to a widget.

```dart
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;  // TODO: Use this!

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    // TODO: Set loading to true before fetching

    final posts = await PostService().getPosts();

    // TODO: Set loading to false and update posts
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Show CircularProgressIndicator when loading
    // Show ListView when not loading

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_posts[index].title));
        },
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    final posts = await PostService().getPosts();

    setState(() {
      _isLoading = false;
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_posts[index].title));
              },
            ),
    );
  }
}
```

</details>

---

## Exercise 3.2: Handle Errors

**Goal:** Display error messages to the user.

**Your Task:** Add error handling to the screen.

```dart
class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;  // TODO: Use this!

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;  // Clear previous error
    });

    // TODO: Wrap in try-catch
    // On error: set _error to error message
    // Always: set _isLoading to false

    final posts = await PostService().getPosts();

    setState(() {
      _isLoading = false;
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // TODO: Add error state
    // Show error message with a "Retry" button

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(_posts[index].title));
      },
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final posts = await PostService().getPosts();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(_posts[index].title));
      },
    );
  }
}
```

</details>

---

## Exercise 3.3: Use FutureBuilder

**Goal:** Simplify async UI with FutureBuilder.

**Your Task:** Rewrite using FutureBuilder.

```dart
class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    // TODO: Use FutureBuilder to:
    // 1. Call PostService().getPost(postId)
    // 2. Show loading spinner during ConnectionState.waiting
    // 3. Show error if snapshot.hasError
    // 4. Show post details if snapshot.hasData

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: const Center(child: Text('Use FutureBuilder!')),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: FutureBuilder<Post>(
        future: PostService().getPost(postId),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Success state
          final post = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(post.body),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

</details>

---

## Exercise 3.4: Pull to Refresh

**Goal:** Add pull-to-refresh functionality.

**Your Task:** Make the list refreshable.

```dart
class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await PostService().getPosts();
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      // TODO: Wrap ListView in RefreshIndicator
      // onRefresh should call _loadPosts
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_posts[index].title));
        },
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Posts')),
    body: RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_posts[index].title));
        },
      ),
    ),
  );
}
```

</details>

---

# PART 4: FINAL PROJECT

## Exercise 4.1: Pokemon App - Complete Challenge

Now combine EVERYTHING you learned to build a complete app!

**Goal:** Build a Pokemon viewer app from scratch.

**API:** https://pokeapi.co/api/v2/pokemon?limit=20

**Requirements:**
1. ✅ Pokemon model with id, name, imageUrl
2. ✅ PokemonService with getPokemonList()
3. ✅ List screen with loading, error, and data states
4. ✅ Pull to refresh
5. ✅ Tap to see detail (use Navigator)

**Pokemon Image URL Format:**
```
https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png
```

**API Response Format:**
```json
{
  "results": [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"},
    {"name": "ivysaur", "url": "https://pokeapi.co/api/v2/pokemon/2/"}
  ]
}
```

**Build it step by step:**

### Step 1: Create Pokemon Model
```dart
class Pokemon {
  // Properties: id, name, imageUrl
  // Constructor
  // fromJson factory (extract id from URL or use index + 1)
}
```

### Step 2: Create PokemonService
```dart
class PokemonService {
  Future<List<Pokemon>> getPokemonList() async {
    // GET request
    // Parse JSON
    // Return list of Pokemon
  }
}
```

### Step 3: Create PokemonListScreen
```dart
class PokemonListScreen extends StatefulWidget {
  // State: _pokemon list, _isLoading, _error
  // initState: call _loadPokemon
  // build: show loading/error/list
}
```

### Step 4: Add Pull to Refresh

### Step 5: Add Navigation to Detail

---

**Try to build this WITHOUT looking at the solution!**

Practice makes perfect. If you get stuck:
1. Re-read the relevant exercise above
2. Try for 10 more minutes
3. Only then look at the solution

<details>
<summary>✅ Complete Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const PokemonApp());

// ═══════════════════════════════════════════════════════════════
// MODEL
// ═══════════════════════════════════════════════════════════════

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json, int index) {
    final id = index + 1;
    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SERVICE
// ═══════════════════════════════════════════════════════════════

class PokemonService {
  static const baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> getPokemonList({int limit = 20}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results.asMap().entries.map((entry) {
        return Pokemon.fromJson(entry.value, entry.key);
      }).toList();
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS
// ═══════════════════════════════════════════════════════════════

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final _service = PokemonService();

  List<Pokemon> _pokemon = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pokemon = await _service.getPokemonList();
      setState(() {
        _pokemon = pokemon;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _pokemon.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _pokemon.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPokemon,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPokemon,
      child: ListView.builder(
        itemCount: _pokemon.length,
        itemBuilder: (context, index) {
          final pokemon = _pokemon[index];
          return ListTile(
            leading: Image.network(
              pokemon.imageUrl,
              width: 50,
              height: 50,
              errorBuilder: (_, __, ___) => const Icon(Icons.catching_pokemon),
            ),
            title: Text(
              pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
            ),
            subtitle: Text('#${pokemon.id.toString().padLeft(3, '0')}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PokemonDetailScreen(pokemon: pokemon),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              pokemon.imageUrl,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Text(
              pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// APP
// ═══════════════════════════════════════════════════════════════

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Viewer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const PokemonListScreen(),
    );
  }
}
```

</details>

---

## Congratulations!

You've completed all the API Integration exercises!

**What you learned:**
- ✅ Creating data models with fromJson/toJson
- ✅ Making GET and POST requests
- ✅ Parsing JSON responses
- ✅ Handling loading and error states
- ✅ Using FutureBuilder
- ✅ Pull to refresh
- ✅ Building complete API-powered apps

**Next Steps:**
1. Try building the Weather App (use OpenWeatherMap API)
2. Try building a GitHub Profile Viewer
3. Move on to Level 09: Local Storage

---

[← Back to Level 08 README](../README.md) | [Level 09: Local Storage →](../../Level-09-Local-Storage/README.md)
