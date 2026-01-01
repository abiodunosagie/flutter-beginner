# Level 16 Capstone: Professional Patterns & Best Practices

## What You're Building

In this final level, you'll refactor ShopEase using **professional-grade architecture patterns** that real companies use!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 16 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase Professional Architecture                         │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │        ┌─────────────────────────────────┐         │   │
│   │        │       Presentation Layer        │         │   │
│   │        │  (Screens, Widgets, ViewModels) │         │   │
│   │        └───────────────┬─────────────────┘         │   │
│   │                        │                            │   │
│   │        ┌───────────────▼─────────────────┐         │   │
│   │        │        Domain Layer             │         │   │
│   │        │  (Use Cases, Entities, Repos)   │         │   │
│   │        └───────────────┬─────────────────┘         │   │
│   │                        │                            │   │
│   │        ┌───────────────▼─────────────────┐         │   │
│   │        │         Data Layer              │         │   │
│   │        │  (API, Database, Cache, DTOs)   │         │   │
│   │        └─────────────────────────────────┘         │   │
│   │                                                     │   │
│   │   Key Patterns:                                     │   │
│   │   • Repository Pattern                              │   │
│   │   • Dependency Injection                            │   │
│   │   • Use Cases / Interactors                         │   │
│   │   • Feature-First Organization                      │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Feature-First Folder Structure

Reorganize the codebase by feature rather than by type:

```
lib/
├── core/                          # Shared across features
│   ├── di/                        # Dependency injection
│   │   └── injection_container.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── extensions.dart
│
├── features/
│   ├── products/                  # Product feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── product_remote_datasource.dart
│   │   │   │   └── product_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── product_model.dart
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_products.dart
│   │   │       └── get_product_by_id.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── products_bloc.dart
│   │       │   ├── products_event.dart
│   │       │   └── products_state.dart
│   │       ├── screens/
│   │       │   └── products_screen.dart
│   │       └── widgets/
│   │           └── product_card.dart
│   │
│   ├── cart/                      # Cart feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── auth/                      # Auth feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

### Task 2: Repository Pattern

Abstract data sources behind repository interfaces:

```dart
// lib/features/products/domain/repositories/product_repository.dart

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
```

```dart
// lib/features/products/data/repositories/product_repository_impl.dart

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts.map((m) => m.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return Right(localProducts.map((m) => m.toEntity()).toList());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    } on NotFoundException {
      return Left(NotFoundFailure());
    }
  }
}
```

### Task 3: Use Cases

Create focused, single-responsibility use cases:

```dart
// lib/features/products/domain/usecases/get_products.dart

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call({
    String? category,
    String? searchQuery,
  }) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      return repository.searchProducts(searchQuery);
    }
    if (category != null && category != 'all') {
      return repository.getProductsByCategory(category);
    }
    return repository.getProducts();
  }
}
```

```dart
// lib/features/cart/domain/usecases/add_to_cart.dart

class AddToCart {
  final CartRepository repository;
  final ProductRepository productRepository;

  AddToCart({
    required this.repository,
    required this.productRepository,
  });

  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    // Verify product exists
    final productResult = await productRepository.getProductById(params.productId);

    return productResult.fold(
      (failure) => Left(failure),
      (product) async {
        // Check stock availability
        if (product.stock < params.quantity) {
          return Left(InsufficientStockFailure());
        }

        // Add to cart
        return repository.addItem(
          productId: params.productId,
          quantity: params.quantity,
        );
      },
    );
  }
}

class AddToCartParams {
  final int productId;
  final int quantity;

  AddToCartParams({required this.productId, this.quantity = 1});
}
```

### Task 4: Dependency Injection with get_it

```dart
// lib/core/di/injection_container.dart

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Products
  // Bloc
  sl.registerFactory(
    () => ProductsBloc(getProducts: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Cart
  sl.registerFactory(() => CartBloc(addToCart: sl(), removeFromCart: sl()));
  sl.registerLazySingleton(() => AddToCart(repository: sl(), productRepository: sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
```

### Task 5: Error Handling with Either

```dart
// lib/core/error/failures.dart

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure() : super('Server error. Please try again later.');
}

class CacheFailure extends Failure {
  const CacheFailure() : super('Unable to load cached data.');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection.');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super('Item not found.');
}

class InsufficientStockFailure extends Failure {
  const InsufficientStockFailure() : super('Not enough items in stock.');
}
```

```dart
// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

class CacheException implements Exception {}

class NotFoundException implements Exception {}
```

### Task 6: BLoC Pattern with States

```dart
// lib/features/products/presentation/bloc/products_bloc.dart

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;

  ProductsBloc({required this.getProducts}) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    final result = await getProducts();

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    final result = await getProducts(searchQuery: event.query);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products, searchQuery: event.query)),
    );
  }
}
```

```dart
// lib/features/products/presentation/bloc/products_state.dart

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final String? searchQuery;
  final String? category;

  ProductsLoaded(this.products, {this.searchQuery, this.category});
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
```

### Task 7: DTOs and Entity Mapping

```dart
// lib/features/products/data/models/product_model.dart

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: RatingModel.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
    'rating': rating.toJson(),
  };

  // Convert to domain entity
  Product toEntity() => Product(
    id: id,
    name: title,
    price: price,
    description: description,
    category: category,
    imageUrl: image,
    rating: rating.rate,
    reviewCount: rating.count,
  );

  // Create from domain entity
  factory ProductModel.fromEntity(Product entity) => ProductModel(
    id: entity.id,
    title: entity.name,
    price: entity.price,
    description: entity.description,
    category: entity.category,
    image: entity.imageUrl,
    rating: RatingModel(rate: entity.rating, count: entity.reviewCount),
  );
}
```

---

## Architecture Overview

```
┌────────────────────────────────────────────────────────────┐
│                 CLEAN ARCHITECTURE                          │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  PRESENTATION (UI)                                          │
│  ─────────────────                                          │
│  • Screens & Widgets                                        │
│  • BLoC / Provider / Riverpod                              │
│  • Handles user input                                       │
│  • Displays data                                            │
│           │                                                 │
│           ▼                                                 │
│  DOMAIN (Business Logic)                                    │
│  ────────────────────────                                   │
│  • Entities (pure business objects)                        │
│  • Use Cases (application-specific rules)                  │
│  • Repository interfaces                                    │
│  • No dependencies on other layers!                        │
│           │                                                 │
│           ▼                                                 │
│  DATA (External World)                                      │
│  ──────────────────────                                     │
│  • Repository implementations                               │
│  • Data sources (API, DB, Cache)                           │
│  • Models/DTOs                                              │
│  • Data mapping                                             │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

## Success Criteria

- [ ] Feature-first folder structure implemented
- [ ] Repository pattern abstracts data sources
- [ ] Use cases encapsulate business logic
- [ ] Dependency injection with get_it working
- [ ] Either type used for error handling
- [ ] BLoC pattern with proper states
- [ ] DTOs separate from domain entities
- [ ] All tests still passing
- [ ] App runs without errors

---

## Dependencies to Add

```yaml
# pubspec.yaml
dependencies:
  # Dependency Injection
  get_it: ^7.6.0

  # Functional Programming
  dartz: ^0.10.1

  # BLoC
  flutter_bloc: ^8.1.3

  # Network
  dio: ^5.4.0
  internet_connection_checker: ^1.0.0

  # Local Storage
  shared_preferences: ^2.2.2
```

---

## Files to Create

```
shopease/
└── lib/
    ├── core/
    │   ├── di/
    │   │   └── injection_container.dart    ◄── Create
    │   ├── error/
    │   │   ├── exceptions.dart             ◄── Create
    │   │   └── failures.dart               ◄── Create
    │   └── network/
    │       └── network_info.dart           ◄── Create
    │
    └── features/
        ├── products/
        │   ├── data/                        ◄── Restructure
        │   ├── domain/                      ◄── Create
        │   └── presentation/                ◄── Restructure
        │
        ├── cart/
        │   ├── data/
        │   ├── domain/
        │   └── presentation/
        │
        └── auth/
            ├── data/
            ├── domain/
            └── presentation/
```

---

## What You've Built

```
┌────────────────────────────────────────────────────────────┐
│                                                             │
│   🎉 CONGRATULATIONS! 🎉                                    │
│                                                             │
│   You've built a COMPLETE e-commerce app with:             │
│                                                             │
│   ✅ Level 01-04: Dart fundamentals & data models          │
│   ✅ Level 05: Flutter UI components                       │
│   ✅ Level 06: State management with Provider              │
│   ✅ Level 07: Navigation with go_router                   │
│   ✅ Level 08: API integration with Dio                    │
│   ✅ Level 09: Accessibility & i18n                        │
│   ✅ Level 10: Full integration                            │
│   ✅ Level 11: Firebase backend                            │
│   ✅ Level 12: Platform features                           │
│   ✅ Level 13: Comprehensive testing                       │
│   ✅ Level 14: Smooth animations                           │
│   ✅ Level 15: Store deployment                            │
│   ✅ Level 16: Professional architecture                   │
│                                                             │
│   You're now ready to build production Flutter apps!       │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

**Your ShopEase app is now production-grade! Go build amazing things!**
