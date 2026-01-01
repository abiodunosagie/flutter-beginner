# Level 08 Checkpoint: API Integration

Before moving to Level 09, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. HTTP Basics
Match the HTTP method to its purpose:

| Method | Purpose |
|--------|---------|
| GET | ___ |
| POST | ___ |
| PUT | ___ |
| DELETE | ___ |
| PATCH | ___ |

<details>
<summary>Check Answers</summary>

| Method | Purpose |
|--------|---------|
| GET | Retrieve data |
| POST | Create new data |
| PUT | Replace/update entire resource |
| DELETE | Remove data |
| PATCH | Partial update |

</details>

---

### 2. Dio Setup
What does this configuration do?

```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 10),
  headers: {'Content-Type': 'application/json'},
));

dio.interceptors.add(LogInterceptor(requestBody: true));
```

<details>
<summary>Check Answer</summary>

- **baseUrl**: All requests will be relative to this URL
- **connectTimeout**: Fails if can't connect within 10 seconds
- **headers**: Adds Content-Type to all requests
- **LogInterceptor**: Logs all requests and responses for debugging

</details>

---

### 3. JSON Parsing
Convert this JSON to a Dart class:

```json
{
  "id": 1,
  "title": "Product Name",
  "price": 29.99,
  "category": "electronics",
  "rating": {
    "rate": 4.5,
    "count": 120
  }
}
```

<details>
<summary>Example Solution</summary>

```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      rating: Rating.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'category': category,
    'rating': rating.toJson(),
  };
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}
```

</details>

---

### 4. Error Handling
What errors should you handle?

```dart
Future<List<Product>> getProducts() async {
  try {
    final response = await dio.get('/products');
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  } on DioException catch (e) {
    // What types of errors can occur?
  }
}
```

<details>
<summary>Check Answers</summary>

```dart
on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw ApiException('Connection timeout');

    case DioExceptionType.connectionError:
      throw ApiException('No internet connection');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 400: throw ApiException('Bad request');
        case 401: throw ApiException('Unauthorized');
        case 404: throw ApiException('Not found');
        case 500: throw ApiException('Server error');
        default: throw ApiException('Request failed');
      }

    default:
      throw ApiException('Something went wrong');
  }
}
```

</details>

---

### 5. Async/Await
What's the output order?

```dart
void loadData() async {
  print('1. Starting');

  final future = fetchProducts();
  print('2. Future created');

  final products = await future;
  print('3. Got ${products.length} products');

  print('4. Done');
}

loadData();
print('5. After loadData call');
```

<details>
<summary>Check Answer</summary>

```
1. Starting
2. Future created
5. After loadData call
3. Got X products
4. Done
```

Key insight: `await` pauses the async function, but the caller continues. The function returns a Future immediately.

</details>

---

### 6. Loading States
What's wrong with this code?

```dart
class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();  // Problem?
  }

  Future<void> loadProducts() async {
    final result = await api.getProducts();
    products = result;  // Problem?
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(products[index]),
    );
  }
}
```

<details>
<summary>Check Answers</summary>

Two problems:

1. **No setState**: Changes to `products` won't rebuild UI
2. **No loading state**: User sees empty list while loading

```dart
class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await api.getProducts();
      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return CircularProgressIndicator();
    if (error != null) return ErrorWidget(error: error, onRetry: loadProducts);
    return ListView.builder(...);
  }
}
```

</details>

---

## Hands-On Check

### Task 1: Create API Service
Create a service class for the FakeStore API:

```dart
class ApiService {
  // Implement:
  // - getProducts() → List<Product>
  // - getProduct(id) → Product
  // - getCategories() → List<String>
  // - getProductsByCategory(category) → List<Product>
}
```

<details>
<summary>Example Solution</summary>

```dart
class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

</details>

---

### Task 2: Handle Loading States
Update provider to handle loading, error, and success states:

```dart
class ProductsProvider extends ChangeNotifier {
  // Properties for:
  // - products list
  // - isLoading flag
  // - error message
  // - selected category

  // Methods:
  // - loadProducts()
  // - selectCategory(category)
  // - retry()
}
```

<details>
<summary>Example Solution</summary>

```dart
class ProductsProvider extends ChangeNotifier {
  final ApiService _api;

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'all';

  ProductsProvider({ApiService? api}) : _api = api ?? ApiService();

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get selectedCategory => _selectedCategory;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_selectedCategory == 'all') {
        _products = await _api.getProducts();
      } else {
        _products = await _api.getProductsByCategory(_selectedCategory);
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      loadProducts();
    }
  }

  Future<void> retry() => loadProducts();
}
```

</details>

---

### Task 3: Build UI with States
Create a screen that shows loading, error, or products:

```dart
class ProductsScreen extends StatelessWidget {
  // Show:
  // - Loading spinner when loading
  // - Error message with retry button on error
  // - Product grid when loaded
  // - Pull-to-refresh
}
```

<details>
<summary>Example Solution</summary>

```dart
class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductsProvider>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadProducts,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: provider.products[index]);
              },
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

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| REST API | _________________ |
| JSON | _________________ |
| HTTP status code | _________________ |
| async/await | _________________ |
| Future | _________________ |
| Serialization | _________________ |
| Interceptor | _________________ |

---

## Ready for Level 09?

### I can confidently:
- [ ] Make HTTP requests with Dio
- [ ] Parse JSON into Dart objects
- [ ] Handle different error types
- [ ] Implement loading, error, and success states
- [ ] Use async/await properly
- [ ] Create and use custom exceptions
- [ ] Add pull-to-refresh functionality

### Capstone Progress:
- [ ] Products load from FakeStore API
- [ ] Loading spinner shows while fetching
- [ ] Error handling with retry button
- [ ] Categories filter products
- [ ] Pull-to-refresh works

---

## If You're Stuck

**Common issues at this level:**

1. **JSON parsing errors**
   - Check field names match exactly
   - Use correct types (num for numbers)
   - Handle nullable fields

2. **"Connection refused" errors**
   - Check URL is correct
   - Ensure device has internet
   - Check for CORS issues (web)

3. **App freezes during API call**
   - Make sure you're using async/await
   - Don't block the main thread

4. **Data not updating in UI**
   - Call notifyListeners after updating data
   - Use watch, not read, for display

---

**Ready to level up? Head to Level 09: Advanced Features!**
