# Level 08: API Integration Exercises

Master API calls through hands-on practice!

---

## Exercise 1: Pokemon Viewer (Beginner)

### The Goal
Build an app that fetches Pokemon data from the PokeAPI and displays it.

### API Endpoint
```
https://pokeapi.co/api/v2/pokemon?limit=20
https://pokeapi.co/api/v2/pokemon/{id}
```

### What You'll Build

```
┌─────────────────────────────────────────────────────────────┐
│  LIST VIEW                           DETAIL VIEW            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐           ┌───────────────────┐   │
│  │ 🔴 Pokemon List     │           │ ← Pikachu         │   │
│  ├─────────────────────┤           ├───────────────────┤   │
│  │ #1 Bulbasaur   >    │   tap    │                   │   │
│  │ #2 Ivysaur     >    │  ────>   │    [Image]        │   │
│  │ #3 Venusaur    >    │          │                   │   │
│  │ #4 Charmander  >    │          │  Height: 4        │   │
│  │ #5 Charmeleon  >    │          │  Weight: 60       │   │
│  │ #6 Charizard   >    │          │  Types: Electric  │   │
│  │ ...                 │          │                   │   │
│  └─────────────────────┘           └───────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Viewer',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const PokemonListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Pokemon Model
// ═══════════════════════════════════════════════════════════════

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  // TODO: Add more fields (height, weight, types)

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // TODO: Create fromJson factory
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Hint: Image URL format:
    // https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{id}.png
    throw UnimplementedError();
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create API Service
// ═══════════════════════════════════════════════════════════════

class PokemonService {
  static const baseUrl = 'https://pokeapi.co/api/v2';

  // TODO: Implement getPokemonList
  Future<List<Pokemon>> getPokemonList({int limit = 20}) async {
    // Hint: GET /pokemon?limit=20
    // Response has { results: [ {name, url} ] }
    // Extract ID from URL or use index + 1
    throw UnimplementedError();
  }

  // TODO: Implement getPokemonDetail
  Future<Pokemon> getPokemonDetail(int id) async {
    // Hint: GET /pokemon/{id}
    // Response has { id, name, height, weight, types, sprites }
    throw UnimplementedError();
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create Pokemon List Screen
// ═══════════════════════════════════════════════════════════════

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  // TODO: Add state variables (loading, error, pokemon list)
  // TODO: Implement initState to load data
  // TODO: Build UI with loading, error, and list states

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokemon')),
      body: const Center(child: Text('Implement me!')),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 4: Create Pokemon Detail Screen
// ═══════════════════════════════════════════════════════════════

class PokemonDetailScreen extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailScreen({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    // TODO: Use FutureBuilder to fetch and display Pokemon details
    return Scaffold(
      appBar: AppBar(title: const Text('Pokemon Detail')),
      body: const Center(child: Text('Implement me!')),
    );
  }
}
```

### Success Checklist
- [ ] Pokemon list loads and displays
- [ ] Each item shows number, name, and small image
- [ ] Tapping item navigates to detail screen
- [ ] Detail screen shows full info (name, image, height, weight, types)
- [ ] Loading indicator while fetching
- [ ] Error message with retry on failure

---

## Exercise 2: Weather App (Intermediate)

### The Goal
Build a weather app that fetches current weather for a city.

### API
Use OpenWeatherMap API (free tier):
```
https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric
```

Note: You'll need to sign up for a free API key at openweathermap.org

### What You'll Build

```
┌─────────────────────────────────────────────────────────────┐
│                    WEATHER APP                               │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🔍 Enter city name...              [Search]        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │              New York, US                           │   │
│  │                  ☀️                                 │   │
│  │               25°C                                  │   │
│  │             Clear Sky                               │   │
│  │                                                     │   │
│  │  💨 Wind: 5 m/s    💧 Humidity: 65%                 │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Requirements
1. Search input for city name
2. Display current temperature, description, icon
3. Show additional details (wind, humidity, feels like)
4. Handle city not found error
5. Remember last searched city

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Weather Model
// ═══════════════════════════════════════════════════════════════

class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  // TODO: Implement fromJson
  // API Response structure:
  // {
  //   "name": "London",
  //   "sys": {"country": "GB"},
  //   "main": {"temp": 20.5, "feels_like": 19.2, "humidity": 65},
  //   "weather": [{"description": "clear sky", "icon": "01d"}],
  //   "wind": {"speed": 5.2}
  // }
  factory Weather.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  // Icon URL
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create Weather Service
// ═══════════════════════════════════════════════════════════════

class WeatherService {
  // TODO: Replace with your API key
  static const apiKey = 'YOUR_API_KEY';
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeather(String city) async {
    // TODO: Implement API call
    // Handle 404 for city not found
    throw UnimplementedError();
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create Weather Screen
// ═══════════════════════════════════════════════════════════════

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _controller = TextEditingController();
  final _service = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  // TODO: Implement search functionality
  // TODO: Build UI with search bar and weather display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: const Center(child: Text('Implement me!')),
    );
  }
}
```

### Success Checklist
- [ ] Search bar accepts city name
- [ ] Weather displays after successful search
- [ ] Shows all weather details (temp, description, wind, humidity)
- [ ] Weather icon displays correctly
- [ ] "City not found" error shown for invalid cities
- [ ] Loading indicator during fetch

---

## Exercise 3: Todo API (Intermediate)

### The Goal
Build a Todo app that syncs with a REST API.

### API Endpoint
```
https://jsonplaceholder.typicode.com/todos
```

### Requirements
1. List todos with checkboxes
2. Add new todos (POST)
3. Toggle todo completion (PATCH)
4. Delete todos (DELETE)
5. Filter by completed/incomplete

### What You'll Build

```
┌─────────────────────────────────────────────────────────────┐
│  📝 My Todos                                    [+]         │
├─────────────────────────────────────────────────────────────┤
│  [All] [Active] [Completed]                                 │
├─────────────────────────────────────────────────────────────┤
│  ☑️ Learn Dart                              [🗑️]           │
│  ☐ Build Flutter app                        [🗑️]           │
│  ☐ Master API calls                         [🗑️]           │
│  ☑️ Read documentation                      [🗑️]           │
│  ...                                                        │
└─────────────────────────────────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const TodoApp());

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Todo Model
// ═══════════════════════════════════════════════════════════════

class Todo {
  final int? id;
  final String title;
  final bool completed;
  final int userId;

  Todo({
    this.id,
    required this.title,
    this.completed = false,
    this.userId = 1,
  });

  // TODO: Implement fromJson and toJson

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    int? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create Todo Service with full CRUD
// ═══════════════════════════════════════════════════════════════

class TodoService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  // TODO: GET /todos?_limit=20
  Future<List<Todo>> getTodos() async {
    throw UnimplementedError();
  }

  // TODO: POST /todos
  Future<Todo> createTodo(Todo todo) async {
    throw UnimplementedError();
  }

  // TODO: PATCH /todos/{id}
  Future<Todo> updateTodo(Todo todo) async {
    throw UnimplementedError();
  }

  // TODO: DELETE /todos/{id}
  Future<void> deleteTodo(int id) async {
    throw UnimplementedError();
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create Todos Screen with filtering
// ═══════════════════════════════════════════════════════════════

enum TodoFilter { all, active, completed }

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  // TODO: Implement state and methods
  // TODO: Build UI with filter chips and todo list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: const Center(child: Text('Implement me!')),
    );
  }
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const TodosScreen(),
    );
  }
}
```

### Success Checklist
- [ ] Todos load and display with checkboxes
- [ ] Add new todo via dialog/input
- [ ] Toggle completion updates UI immediately
- [ ] Delete with confirmation
- [ ] Filter tabs work correctly
- [ ] Optimistic UI updates (update locally, then sync)

---

## Exercise 4: GitHub Profile Viewer (Advanced)

### The Goal
Build an app that fetches GitHub user profiles and repositories.

### API Endpoints
```
https://api.github.com/users/{username}
https://api.github.com/users/{username}/repos
```

### What You'll Build

```
┌─────────────────────────────────────────────────────────────┐
│  🔍 Search GitHub user...                     [Search]      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  [Avatar]                                           │   │
│  │                                                     │   │
│  │  John Doe (@johndoe)                               │   │
│  │  Senior Developer                                   │   │
│  │  📍 San Francisco                                   │   │
│  │                                                     │   │
│  │  Followers: 1.2K  Following: 500  Repos: 45        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Popular Repositories:                                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📁 awesome-project                         ⭐ 234   │   │
│  │    A really cool project                            │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │ 📁 flutter-app                            ⭐ 156    │   │
│  │    My Flutter application                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Requirements
1. Search for GitHub users by username
2. Display user profile (avatar, name, bio, location, stats)
3. List top repositories sorted by stars
4. Navigate to repo detail
5. Handle rate limiting errors

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const GitHubApp());

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Models (GitHubUser, Repository)
// ═══════════════════════════════════════════════════════════════

class GitHubUser {
  final String login;
  final String? name;
  final String avatarUrl;
  final String? bio;
  final String? location;
  final int followers;
  final int following;
  final int publicRepos;

  GitHubUser({
    required this.login,
    this.name,
    required this.avatarUrl,
    this.bio,
    this.location,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });

  // TODO: Implement fromJson
}

class Repository {
  final int id;
  final String name;
  final String? description;
  final int stars;
  final int forks;
  final String? language;
  final String htmlUrl;

  Repository({
    required this.id,
    required this.name,
    this.description,
    required this.stars,
    required this.forks,
    this.language,
    required this.htmlUrl,
  });

  // TODO: Implement fromJson
  // Note: stars is "stargazers_count" in API
  // Note: htmlUrl is "html_url" in API
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create GitHub Service
// ═══════════════════════════════════════════════════════════════

class GitHubService {
  static const baseUrl = 'https://api.github.com';

  Future<GitHubUser> getUser(String username) async {
    // TODO: GET /users/{username}
    throw UnimplementedError();
  }

  Future<List<Repository>> getRepos(String username, {int limit = 10}) async {
    // TODO: GET /users/{username}/repos?sort=stars&per_page={limit}
    throw UnimplementedError();
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create GitHub Profile Screen
// ═══════════════════════════════════════════════════════════════

class GitHubProfileScreen extends StatefulWidget {
  const GitHubProfileScreen({super.key});

  @override
  State<GitHubProfileScreen> createState() => _GitHubProfileScreenState();
}

class _GitHubProfileScreenState extends State<GitHubProfileScreen> {
  // TODO: Implement search and display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Profile')),
      body: const Center(child: Text('Implement me!')),
    );
  }
}

class GitHubApp extends StatelessWidget {
  const GitHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Viewer',
      theme: ThemeData.dark(),
      home: const GitHubProfileScreen(),
    );
  }
}
```

### Success Checklist
- [ ] Search finds GitHub users
- [ ] Profile displays with avatar and stats
- [ ] Repositories list sorted by stars
- [ ] Tap repo opens in browser
- [ ] Handle user not found (404)
- [ ] Handle rate limit (403)

---

## Exercise 5: News Reader (Advanced)

### The Goal
Build a news reader app with categories and bookmarks.

### API
Use NewsAPI.org (free tier):
```
https://newsapi.org/v2/top-headlines?country=us&apiKey={KEY}
https://newsapi.org/v2/top-headlines?country=us&category={cat}&apiKey={KEY}
```

### Requirements
1. Display news headlines with images
2. Category tabs (business, technology, sports, etc.)
3. Pull to refresh
4. Offline support (cache last fetched)
5. Bookmark articles (local storage)
6. Share articles

### What You'll Build

```
┌─────────────────────────────────────────────────────────────┐
│  📰 News                                      [🔖] [🔄]     │
├─────────────────────────────────────────────────────────────┤
│  [All] [Business] [Tech] [Sports] [Health]                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐   │
│  │ [Image                                         ]    │   │
│  │                                                     │   │
│  │ Tech Giant Announces New Product                    │   │
│  │ BBC News • 2 hours ago                     [🔖][↗️] │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ [Image                                         ]    │   │
│  │                                                     │   │
│  │ Market Hits Record High                             │   │
│  │ CNN • 4 hours ago                          [🔖][↗️] │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const NewsApp());

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Article Model
// ═══════════════════════════════════════════════════════════════

class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? source;
  final DateTime? publishedAt;
  bool isBookmarked;

  Article({
    this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.source,
    this.publishedAt,
    this.isBookmarked = false,
  });

  // TODO: Implement fromJson
  // API response:
  // {
  //   "title": "...",
  //   "description": "...",
  //   "url": "...",
  //   "urlToImage": "...",
  //   "source": {"name": "..."},
  //   "publishedAt": "2024-01-01T12:00:00Z"
  // }
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create News Service
// ═══════════════════════════════════════════════════════════════

class NewsService {
  // TODO: Replace with your API key
  static const apiKey = 'YOUR_API_KEY';
  static const baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> getTopHeadlines({String? category}) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create News Screen with categories
// ═══════════════════════════════════════════════════════════════

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Implement TabController for categories
  // TODO: Implement article loading and display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: const Center(child: Text('Implement me!')),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 4: Create Article Card Widget
// ═══════════════════════════════════════════════════════════════

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement card with image, title, source, actions
    return const Card(child: Text('Implement me!'));
  }
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const NewsScreen(),
    );
  }
}
```

### Success Checklist
- [ ] Headlines load by category
- [ ] Tab bar for category navigation
- [ ] Article cards display image, title, source
- [ ] Pull to refresh works
- [ ] Bookmark toggle works
- [ ] Share opens share sheet
- [ ] Tap opens article URL

---

## Summary: API Integration Patterns

```
┌─────────────────────────────────────────────────────────────┐
│              API INTEGRATION CHEAT SHEET                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  REQUEST PATTERN:                                           │
│  final response = await http.get(Uri.parse(url));           │
│  if (response.statusCode == 200) {                          │
│    final data = json.decode(response.body);                 │
│    return Model.fromJson(data);                             │
│  }                                                          │
│  throw Exception('Failed');                                 │
│                                                             │
│  MODEL PATTERN:                                             │
│  class Model {                                              │
│    final String field;                                      │
│    Model({required this.field});                            │
│    factory Model.fromJson(json) => Model(field: json['f']); │
│    Map toJson() => {'field': field};                        │
│  }                                                          │
│                                                             │
│  UI PATTERN:                                                │
│  if (isLoading) return CircularProgressIndicator();         │
│  if (error != null) return ErrorWidget(error);              │
│  return DataWidget(data);                                   │
│                                                             │
│  ERROR PATTERN:                                             │
│  try { ... }                                                │
│  on SocketException { /* no internet */ }                   │
│  catch (e) { /* other error */ }                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Back to Level 08 README](../README.md) | [Level 09: Local Storage →](../../Level-09-Local-Storage/README.md)
