# Level 8: Real-World Apps Using These Concepts

See how API integration connects apps to the world!

---

## HTTP Requests

### Fetching Data from Servers!

**Weather App**
```dart
class WeatherService {
  final String apiKey = 'your_api_key';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getCurrentWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
```

**News App**
```dart
class NewsService {
  Future<List<Article>> getTopHeadlines() async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=us'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    final data = jsonDecode(response.body);
    return (data['articles'] as List)
        .map((json) => Article.fromJson(json))
        .toList();
  }
}
```

---

## JSON Parsing

### Turning Server Data into Dart Objects!

**Instagram User Profile**
```dart
// Server sends this JSON:
// {
//   "id": "12345",
//   "username": "flutterdev",
//   "full_name": "Flutter Developer",
//   "followers_count": 10500,
//   "following_count": 500,
//   "is_verified": true
// }

class UserProfile {
  final String id;
  final String username;
  final String fullName;
  final int followersCount;
  final int followingCount;
  final bool isVerified;

  UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.followersCount,
    required this.followingCount,
    required this.isVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      isVerified: json['is_verified'],
    );
  }
}
```

---

## RESTful APIs

### Standard Web Communication!

**E-commerce API**
```dart
class ProductApi {
  final String baseUrl = 'https://api.mystore.com';

  // GET /products - List all products
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    // Parse and return list
  }

  // GET /products/123 - Get single product
  Future<Product> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    // Parse and return product
  }

  // POST /orders - Create order
  Future<Order> createOrder(OrderRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    // Parse and return order
  }

  // PUT /orders/123 - Update order
  Future<Order> updateOrder(String id, OrderUpdate update) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$id'),
      body: jsonEncode(update.toJson()),
    );
  }

  // DELETE /orders/123 - Cancel order
  Future<void> cancelOrder(String id) async {
    await http.delete(Uri.parse('$baseUrl/orders/$id'));
  }
}
```

---

## Authentication Headers

### Secure API Calls!

**Any Authenticated App**
```dart
class ApiClient {
  String? _authToken;

  Future<Response> get(String endpoint) async {
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
    );
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
    );
    _authToken = jsonDecode(response.body)['token'];
  }
}
```

---

## Error Handling

### When Things Go Wrong!

**Production App**
```dart
class ApiService {
  Future<Product> getProduct(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
      ).timeout(Duration(seconds: 10));

      switch (response.statusCode) {
        case 200:
          return Product.fromJson(jsonDecode(response.body));
        case 401:
          throw UnauthorizedException('Please log in again');
        case 404:
          throw NotFoundException('Product not found');
        case 500:
          throw ServerException('Server error, try later');
        default:
          throw ApiException('Unknown error: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Connection timed out');
    }
  }
}
```

---

## Pagination

### Loading Data in Chunks!

**Infinite Scroll (Twitter/Instagram)**
```dart
class FeedService {
  int _page = 1;
  bool _hasMore = true;

  Future<List<Post>> loadMore() async {
    if (!_hasMore) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/feed?page=$_page&limit=20'),
    );

    final data = jsonDecode(response.body);
    _hasMore = data['has_more'];
    _page++;

    return (data['posts'] as List)
        .map((json) => Post.fromJson(json))
        .toList();
  }

  void reset() {
    _page = 1;
    _hasMore = true;
  }
}
```

---

## Real Apps and Their APIs

| App | APIs Used |
|-----|----------|
| **Uber** | Maps API, Payments API, Real-time tracking |
| **Spotify** | Music streaming, User profiles, Playlists |
| **Instagram** | Image upload, User data, Feed, Stories |
| **Weather apps** | OpenWeatherMap, AccuWeather |
| **News apps** | NewsAPI, RSS feeds |
| **Finance apps** | Stock APIs, Banking APIs |

---

## Caching

### Don't Re-fetch Everything!

**Offline-First Pattern**
```dart
class ProductRepository {
  final ApiService _api;
  final LocalStorage _cache;

  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    // Try cache first
    if (!forceRefresh) {
      final cached = await _cache.getProducts();
      if (cached != null && !cached.isStale) {
        return cached.data;
      }
    }

    // Fetch from API
    try {
      final products = await _api.getProducts();
      await _cache.saveProducts(products);
      return products;
    } catch (e) {
      // Return stale cache if network fails
      final cached = await _cache.getProducts();
      if (cached != null) return cached.data;
      rethrow;
    }
  }
}
```

---

## Image Upload

### Sending Files to Server!

**Profile Photo Upload**
```dart
Future<String> uploadProfilePhoto(File image) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/upload/profile-photo'),
  );

  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(await http.MultipartFile.fromPath('photo', image.path));

  final response = await request.send();
  final responseData = await response.stream.bytesToString();

  return jsonDecode(responseData)['url'];
}
```

---

## Build It Yourself!

After this level, you could build:

1. **Weather App** - Fetch weather from API
2. **News Reader** - Load articles from news API
3. **Movie Browser** - Use TMDB API for movies
4. **Recipe App** - Fetch recipes from API
5. **Crypto Tracker** - Real-time crypto prices

---

## Popular Free APIs to Practice

| API | What It Provides |
|-----|-----------------|
| **JSONPlaceholder** | Fake REST API for testing |
| **OpenWeatherMap** | Weather data |
| **NewsAPI** | News articles |
| **TMDB** | Movie database |
| **PokeAPI** | Pokemon data |
| **REST Countries** | Country information |

---

**APIs connect your app to the world - master them to build anything!**
