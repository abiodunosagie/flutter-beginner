# Level 16 Checkpoint: Professional Patterns

Congratulations on reaching the final level! Make sure you understand these concepts.

---

## Quick Quiz

### 1. Clean Architecture Layers
What belongs in each layer?

| Layer | Contains |
|-------|----------|
| Presentation | ___ |
| Domain | ___ |
| Data | ___ |

<details>
<summary>Check Answers</summary>

| Layer | Contains |
|-------|----------|
| Presentation | UI, Widgets, BLoC/Provider, ViewModels |
| Domain | Entities, Use Cases, Repository interfaces |
| Data | API clients, DTOs, Repository implementations, Data sources |

**Key rule:** Domain has NO dependencies on other layers!

</details>

---

### 2. Dependency Direction
Which way do dependencies flow?

```
Presentation → ??? → ???
```

<details>
<summary>Check Answer</summary>

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain depends on NOTHING

This is "Dependency Inversion" - Domain defines interfaces, Data implements them.

</details>

---

### 3. Repository Pattern
What's the purpose?

```dart
// Domain layer
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

// Data layer
class ProductRepositoryImpl implements ProductRepository {
  final ApiService api;
  final LocalDatabase db;

  @override
  Future<List<Product>> getProducts() async {
    try {
      return await api.getProducts();
    } catch (e) {
      return await db.getCachedProducts();
    }
  }
}
```

<details>
<summary>Check Answer</summary>

**Repository pattern:**
- Abstracts data sources (API, database, cache)
- Domain only knows the interface
- Implementation can switch sources transparently
- Makes testing easier (mock the interface)

Benefits:
- Offline-first capability
- Easy to add caching
- Data source changes don't affect business logic

</details>

---

### 4. Use Cases
Why use them?

```dart
class AddToCartUseCase {
  final CartRepository cartRepo;
  final ProductRepository productRepo;

  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    // Validate product exists
    final product = await productRepo.getById(params.productId);
    if (product == null) return Left(ProductNotFoundFailure());

    // Check stock
    if (product.stock < params.quantity) {
      return Left(InsufficientStockFailure());
    }

    // Add to cart
    return cartRepo.addItem(product, params.quantity);
  }
}
```

<details>
<summary>Check Answer</summary>

**Use cases (Interactors):**
- Single responsibility - one action per use case
- Contains business logic
- Orchestrates multiple repositories
- Easy to test in isolation
- Reusable across UI (mobile, web, etc.)

Without use cases, business logic ends up scattered in widgets or providers.

</details>

---

### 5. Either Type
What does this return?

```dart
Future<Either<Failure, User>> login(String email, String password);

// Using it:
final result = await login(email, password);

result.fold(
  (failure) => showError(failure.message),
  (user) => navigateToHome(user),
);
```

<details>
<summary>Check Answer</summary>

**Either<L, R>:**
- Returns one of two types: Left (failure) or Right (success)
- Left = error/failure case
- Right = success case
- Forces you to handle both cases

Better than try/catch because:
- Explicit about what can go wrong
- Compiler ensures you handle failures
- No forgotten exception handling

</details>

---

### 6. Dependency Injection
What does get_it provide?

```dart
final sl = GetIt.instance;

void setup() {
  // Singleton - one instance forever
  sl.registerSingleton<ApiService>(ApiServiceImpl());

  // Lazy singleton - created on first use
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // Factory - new instance each time
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(sl()),
  );
}
```

<details>
<summary>Check Answer</summary>

**Dependency Injection benefits:**
- Decouples creation from usage
- Easy to swap implementations
- Simplifies testing (inject mocks)
- Manages object lifecycle

**Registration types:**
- `registerSingleton`: One instance, created immediately
- `registerLazySingleton`: One instance, created when first requested
- `registerFactory`: New instance every time

</details>

---

## Hands-On Check

### Task 1: Create Domain Entity
Create a Product entity (pure business object):

```dart
// lib/features/products/domain/entities/product.dart
class Product {
  // Properties that matter to business logic
  // No JSON, no database, no framework dependencies
}
```

<details>
<summary>Example Solution</summary>

```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.stock,
  });

  bool get isInStock => stock > 0;

  bool get isLowStock => stock > 0 && stock <= 5;

  double get discountedPrice => price * 0.9; // Example business logic

  bool get isHighRated => rating >= 4.0;
}
```

</details>

---

### Task 2: Create Repository Interface
Define what operations are available:

```dart
// lib/features/products/domain/repositories/product_repository.dart
abstract class ProductRepository {
  // Define methods without implementation
}
```

<details>
<summary>Example Solution</summary>

```dart
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);

  Future<Either<Failure, List<Product>>> searchProducts(String query);

  Future<Either<Failure, List<String>>> getCategories();
}
```

</details>

---

### Task 3: Create Use Case
Implement a specific business operation:

```dart
// lib/features/products/domain/usecases/get_products.dart
class GetProductsUseCase {
  // Single responsibility
  // Returns Either<Failure, List<Product>>
}
```

<details>
<summary>Example Solution</summary>

```dart
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call({
    String? category,
    String? searchQuery,
    SortOption? sortBy,
  }) async {
    // Get products based on filters
    Either<Failure, List<Product>> result;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      result = await repository.searchProducts(searchQuery);
    } else if (category != null && category != 'all') {
      result = await repository.getProductsByCategory(category);
    } else {
      result = await repository.getProducts();
    }

    // Apply sorting
    return result.map((products) {
      switch (sortBy) {
        case SortOption.priceAsc:
          return products..sort((a, b) => a.price.compareTo(b.price));
        case SortOption.priceDesc:
          return products..sort((a, b) => b.price.compareTo(a.price));
        case SortOption.rating:
          return products..sort((a, b) => b.rating.compareTo(a.rating));
        default:
          return products;
      }
    });
  }
}

enum SortOption { priceAsc, priceDesc, rating, newest }
```

</details>

---

### Task 4: Set Up Dependency Injection
Wire everything together:

```dart
// lib/core/di/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // Register all dependencies
}
```

<details>
<summary>Example Solution</summary>

```dart
final sl = GetIt.instance;

Future<void> init() async {
  //! External
  sl.registerLazySingleton(() => Dio());
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! Features - Products

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(prefs: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));

  // BLoC
  sl.registerFactory(() => ProductsBloc(getProducts: sl()));
  sl.registerFactory(() => ProductDetailBloc(getProductById: sl()));
}
```

</details>

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        PRESENTATION                         │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐                   │
│  │ Screens │   │ Widgets │   │  BLoC   │                   │
│  └────┬────┘   └────┬────┘   └────┬────┘                   │
│       │             │             │                         │
│       └─────────────┴─────────────┘                         │
│                     │ uses                                  │
├─────────────────────┼───────────────────────────────────────┤
│                     ▼            DOMAIN                     │
│            ┌─────────────┐                                  │
│            │  Use Cases  │                                  │
│            └──────┬──────┘                                  │
│                   │ uses                                    │
│            ┌──────▼──────┐                                  │
│            │  Entities   │                                  │
│            └──────┬──────┘                                  │
│                   │ defines                                 │
│            ┌──────▼──────┐                                  │
│            │ Repository  │ (interface)                      │
│            │ Interfaces  │                                  │
│            └──────┬──────┘                                  │
│                   │                                         │
├───────────────────┼─────────────────────────────────────────┤
│                   │ implements      DATA                    │
│            ┌──────▼──────┐                                  │
│            │ Repository  │                                  │
│            │   Impl      │                                  │
│            └──────┬──────┘                                  │
│       ┌───────────┼───────────┐                             │
│  ┌────▼────┐ ┌────▼────┐ ┌────▼────┐                       │
│  │   API   │ │   DB    │ │  Cache  │                       │
│  └─────────┘ └─────────┘ └─────────┘                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Clean Architecture | _________________ |
| Dependency Injection | _________________ |
| Repository Pattern | _________________ |
| Use Case | _________________ |
| Entity vs Model | _________________ |
| Either type | _________________ |
| Service Locator | _________________ |

---

## Final Checklist

### I can confidently:
- [ ] Organize code by feature (feature-first structure)
- [ ] Separate Presentation, Domain, and Data layers
- [ ] Create domain entities without framework dependencies
- [ ] Define repository interfaces in domain layer
- [ ] Implement repositories in data layer
- [ ] Create focused, single-responsibility use cases
- [ ] Use Either type for error handling
- [ ] Set up dependency injection with get_it
- [ ] Write testable, maintainable code

### ShopEase Professional Edition:
- [ ] Feature-first folder structure
- [ ] Domain entities for Product, Cart, Order, User
- [ ] Repository interfaces with Either returns
- [ ] Use cases for all business operations
- [ ] Dependency injection configured
- [ ] All tests passing with new architecture

---

## You've Completed the Course!

```
┌────────────────────────────────────────────────────────────┐
│                                                             │
│   🎓 CONGRATULATIONS! 🎓                                    │
│                                                             │
│   You've completed all 16 levels!                          │
│                                                             │
│   You've learned:                                          │
│   ✓ Dart programming fundamentals                         │
│   ✓ Flutter widget development                            │
│   ✓ State management with Provider                        │
│   ✓ Navigation with go_router                             │
│   ✓ API integration with Dio                              │
│   ✓ Firebase backend integration                          │
│   ✓ Native platform features                              │
│   ✓ Testing and quality assurance                         │
│   ✓ Animations and polish                                 │
│   ✓ App Store deployment                                  │
│   ✓ Professional architecture patterns                    │
│                                                             │
│   You're now a Flutter developer!                          │
│                                                             │
│   Keep building. Keep learning. Keep growing.              │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## What's Next?

1. **Build your own apps** - Apply what you've learned
2. **Contribute to open source** - Learn from others
3. **Explore advanced topics** - GraphQL, WebSockets, Riverpod 2.0
4. **Share your knowledge** - Write blogs, create tutorials
5. **Stay updated** - Follow Flutter releases and community

**Your Flutter journey has just begun!**
