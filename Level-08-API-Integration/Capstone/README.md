# Level 08 Capstone: Real Product Data from API

## What You're Building

In this level, you'll connect ShopEase to a **real API** to fetch product data dynamically!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 08 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Before (Static Data):                                      │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  final products = [                                 │   │
│   │    Product(name: 'T-Shirt', price: 29.99),         │   │
│   │    Product(name: 'Jeans', price: 79.99),           │   │
│   │  ];                                                 │   │
│   │  // 😢 Hardcoded, never changes                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   After (API Data):                                          │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   ShopEase App          FakeStore API               │   │
│   │   ┌─────────┐          ┌─────────────┐             │   │
│   │   │         │ ──GET──▶ │  /products  │             │   │
│   │   │         │          │             │             │   │
│   │   │ Display │ ◀──JSON── │  Real Data  │             │   │
│   │   │ Products│          │  200+ items │             │   │
│   │   └─────────┘          └─────────────┘             │   │
│   │                                                     │   │
│   │   ✅ Real data, updated from server!               │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## API We'll Use

**FakeStore API** - Free, no API key needed!

```
Base URL: https://fakestoreapi.com

Endpoints:
  GET /products           → All products
  GET /products/1         → Single product
  GET /products/categories → All categories
  GET /products/category/electronics → Products by category
  POST /carts             → Create cart
  POST /auth/login        → Login user
```

---

## Your Tasks

### Task 1: API Service

Create a service class that handles all API calls:

```dart
// lib/services/api_service.dart

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Get single product
  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // Login user
  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return response.data['token'];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

### Task 2: Update Product Model for JSON

```dart
// lib/models/product.dart

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // Factory constructor for JSON parsing
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }

  // Getters for UI
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get imageUrl => image;  // Alias for consistency
  String get name => title;      // Alias for consistency
}

class Rating {
  final double rate;
  final int count;

  const Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}
```

### Task 3: Custom Exception Handling

```dart
// lib/services/api_exception.dart

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet.',
          errorCode: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection.',
          errorCode: 'NO_INTERNET',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        switch (statusCode) {
          case 400:
            return ApiException(
              message: data?['message'] ?? 'Invalid request.',
              statusCode: 400,
              errorCode: 'BAD_REQUEST',
            );
          case 401:
            return ApiException(
              message: 'Please login to continue.',
              statusCode: 401,
              errorCode: 'UNAUTHORIZED',
            );
          case 404:
            return ApiException(
              message: 'Product not found.',
              statusCode: 404,
              errorCode: 'NOT_FOUND',
            );
          case 500:
            return ApiException(
              message: 'Server error. Please try again later.',
              statusCode: 500,
              errorCode: 'SERVER_ERROR',
            );
          default:
            return ApiException(
              message: 'Something went wrong.',
              statusCode: statusCode,
            );
        }

      default:
        return ApiException(
          message: 'Something went wrong.',
        );
    }
  }

  @override
  String toString() => message;
}
```

### Task 4: Update ProductsProvider

```dart
// lib/providers/products_provider.dart

class ProductsProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  ProductsProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Getters
  List<Product> get products => _filteredProducts;
  List<String> get categories => ['all', ..._categories];
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'all' ||
          product.category == _selectedCategory;
      final matchesSearch = product.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
      _categories = await _apiService.getCategories();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An unexpected error occurred.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get single product
  Future<Product?> getProduct(int id) async {
    try {
      return await _apiService.getProduct(id);
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  // Filter by category
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search products
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Retry failed request
  Future<void> retry() async {
    await loadProducts();
  }
}
```

### Task 5: Loading and Error UI

```dart
// lib/screens/home/home_screen.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load products when screen opens
    Future.microtask(() {
      context.read<ProductsProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShopEase')),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading products...'),
                ],
              ),
            );
          }

          // Error state
          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.retry(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (provider.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No products found'),
                ],
              ),
            );
          }

          // Success state - show products
          return RefreshIndicator(
            onRefresh: () => provider.loadProducts(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
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

---

## API Response Example

```json
// GET /products
[
  {
    "id": 1,
    "title": "Fjallraven - Foldsack No. 1 Backpack",
    "price": 109.95,
    "description": "Your perfect pack for everyday use...",
    "category": "men's clothing",
    "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
    "rating": {
      "rate": 3.9,
      "count": 120
    }
  },
  // ... more products
]
```

---

## Testing Your API

```dart
void main() async {
  final api = ApiService();

  // Test get all products
  final products = await api.getProducts();
  print('Loaded ${products.length} products');

  // Test get single product
  final product = await api.getProduct(1);
  print('Product: ${product.title}');

  // Test categories
  final categories = await api.getCategories();
  print('Categories: $categories');
}
```

---

## Success Criteria

- [ ] Products load from API on app start
- [ ] Loading spinner shows while fetching
- [ ] Error message shows on failure
- [ ] Retry button works
- [ ] Pull-to-refresh works
- [ ] Product detail shows full info
- [ ] Categories filter correctly
- [ ] Search works with API data
- [ ] Images load with placeholders

---

## Bonus Challenge

- [ ] Add pagination (load more on scroll)
- [ ] Cache products locally with Hive
- [ ] Add offline support
- [ ] Implement search with debounce

---

## Files to Create

```
shopease/
└── lib/
    ├── services/
    │   ├── api_service.dart      ◄── Create
    │   └── api_exception.dart    ◄── Create
    │
    ├── models/
    │   └── product.dart          ◄── Update with fromJson
    │
    └── providers/
        └── products_provider.dart ◄── Update with API calls
```

---

## Dependencies to Add

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.4.0
  flutter:
    sdk: flutter
```

---

**Your ShopEase app now shows real products!**
