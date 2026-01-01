# Level 16: Real-World Apps Using These Concepts

See how professional architecture scales to millions of users!

---

## Clean Architecture

### How Big Apps Are Built!

**Uber's Architecture**
```
                 ┌─────────────────┐
                 │   Presentation  │  ← UI, Screens, Widgets
                 │     Layer       │
                 └────────┬────────┘
                          │
                 ┌────────▼────────┐
                 │     Domain      │  ← Business Logic, Use Cases
                 │     Layer       │
                 └────────┬────────┘
                          │
                 ┌────────▼────────┐
                 │      Data       │  ← APIs, Databases, Cache
                 │     Layer       │
                 └─────────────────┘
```

**Benefits:**
- Teams work independently on different layers
- Easy to test each layer in isolation
- Can swap implementations (change database, API)
- Business logic is protected from framework changes

---

## Repository Pattern

### Data Access Abstraction!

**Banking App**
```dart
// Domain layer - abstract contract
abstract class AccountRepository {
  Future<Account> getAccount(String id);
  Future<List<Transaction>> getTransactions(String accountId);
  Future<void> transfer(TransferRequest request);
}

// Data layer - implementation
class AccountRepositoryImpl implements AccountRepository {
  final AccountApiService _api;
  final AccountLocalDataSource _local;
  final NetworkChecker _network;

  @override
  Future<Account> getAccount(String id) async {
    try {
      if (await _network.isConnected) {
        final account = await _api.getAccount(id);
        await _local.cacheAccount(account);
        return account;
      }
    } catch (e) {
      // Network failed, try cache
    }
    return await _local.getAccount(id);
  }
}
```

**Why Companies Use This:**
- Uber: Different data sources (local, network, cache)
- Spotify: Seamless offline support
- Banking apps: Security and data integrity

---

## Dependency Injection

### Modular, Testable Code!

**Using get_it**
```dart
// injection_container.dart
final sl = GetIt.instance;

void init() {
  // External services
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => SharedPreferences.getInstance());

  // Data sources
  sl.registerLazySingleton<ApiService>(() => ApiServiceImpl(sl()));
  sl.registerLazySingleton<LocalStorage>(() => LocalStorageImpl(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      apiService: sl(),
      localStorage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));

  // Providers
  sl.registerFactory(() => ProductsProvider(getProducts: sl()));
  sl.registerFactory(() => CartProvider(addToCart: sl()));
}
```

**Benefits:**
- Easy to swap implementations for testing
- Clear dependency graph
- Lazy initialization for performance
- Singletons where needed

---

## Use Cases (Interactors)

### Single Responsibility Business Logic!

**E-commerce App**
```dart
// One class, one job
class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Either<Failure, List<Product>>> call({
    String? category,
    SortOption? sortBy,
    int page = 1,
  }) async {
    try {
      final products = await _repository.getProducts(
        category: category,
        sortBy: sortBy,
        page: page,
      );
      return Right(products);
    } on NetworkException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

class AddToCartUseCase {
  final CartRepository _cartRepository;
  final InventoryRepository _inventoryRepository;

  Future<Either<Failure, CartItem>> call(Product product, int quantity) async {
    // Check inventory
    final inStock = await _inventoryRepository.checkStock(product.id);
    if (inStock < quantity) {
      return Left(InsufficientStockFailure());
    }

    // Add to cart
    final cartItem = await _cartRepository.addItem(product, quantity);
    return Right(cartItem);
  }
}
```

---

## Feature-First Structure

### Scalable Organization!

**Instagram-like App**
```
lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   │
│   ├── feed/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── messaging/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

**Why This Works:**
- Each feature is self-contained
- Easy to add/remove features
- Teams can own features
- Clear boundaries

---

## Error Handling

### Robust Apps!

**Either Pattern**
```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Please check your internet connection');
}

class ServerFailure extends Failure {
  ServerFailure() : super('Server error. Please try again later');
}

class AuthFailure extends Failure {
  AuthFailure() : super('Authentication failed. Please login again');
}

// In use case
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await _repository.getUser(id);
    return Right(user);
  } on NetworkException {
    return Left(NetworkFailure());
  } on AuthException {
    return Left(AuthFailure());
  }
}

// In UI
final result = await getUserUseCase(userId);
result.fold(
  (failure) => showError(failure.message),
  (user) => displayUser(user),
);
```

---

## Real Companies Using These Patterns

| Company | Architecture |
|---------|-------------|
| **Uber** | Clean Architecture + Feature modules |
| **Airbnb** | Component-based architecture |
| **Netflix** | Microservices + BFF pattern |
| **Spotify** | Feature teams with shared components |
| **Google** | Layered architecture |

---

## State Management at Scale

### Enterprise Patterns!

**BLoC Pattern (Uber, Alibaba)**
```dart
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase _getProducts;

  ProductsBloc(this._getProducts) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<FilterProducts>(_onFilterProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    final result = await _getProducts(page: event.page);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}
```

---

## Testing Clean Architecture

### Each Layer is Testable!

```dart
// Test Use Case
test('GetProducts returns products from repository', () async {
  when(() => mockRepository.getProducts())
      .thenAnswer((_) async => [testProduct]);

  final result = await getProductsUseCase();

  expect(result.isRight(), true);
  result.fold(
    (failure) => fail('Should not return failure'),
    (products) => expect(products.length, 1),
  );
});

// Test Repository
test('Repository returns cached data when offline', () async {
  when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
  when(() => mockLocalDataSource.getProducts())
      .thenAnswer((_) async => [cachedProduct]);

  final result = await repository.getProducts();

  expect(result, [cachedProduct]);
  verifyNever(() => mockApiService.getProducts());
});
```

---

## Build Your Architecture Skills!

After this level, you could:

1. **Refactor to Clean Architecture** - Separate layers
2. **Implement Repository Pattern** - Abstract data access
3. **Set up Dependency Injection** - Use get_it
4. **Create Use Cases** - Single responsibility
5. **Handle errors properly** - Either pattern

---

## Architecture Decision Guide

| App Size | Recommended |
|----------|-------------|
| **Small (1-3 screens)** | Simple Provider + Services |
| **Medium (4-10 screens)** | Feature folders + Provider |
| **Large (10+ screens)** | Clean Architecture + BLoC/Riverpod |
| **Enterprise** | Full Clean Architecture + Feature modules |

---

**Professional patterns let your app grow - build for the future!**
