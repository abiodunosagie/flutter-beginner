// ============================================
// EXAMPLE 02: REPOSITORY PATTERN
// Complete repository implementation examples
// ============================================

/*
  This file demonstrates various repository patterns:
  1. Basic repository with caching
  2. Repository with pagination
  3. Repository with offline support
  4. Repository with error handling (Either)

  NOTE: Copy this code into a real Flutter project to run it.
*/

// ============================================
// BASIC REPOSITORY WITH CACHING
// ============================================

/*
// --- Entity ---
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock < 10;
}

// --- Model ---
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'image_url': imageUrl,
    'stock': stock,
  };

  Product toEntity() => Product(
    id: id,
    name: name,
    price: price,
    imageUrl: imageUrl,
    stock: stock,
  );
}

// --- Repository Interface ---
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(String id);
  Future<List<Product>> getProductsByCategory(String category);
  Future<List<Product>> searchProducts(String query);
}

// --- Data Sources ---
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProduct(String id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<ProductModel>> searchProducts(String query);
}

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<ProductModel?> getCachedProduct(String id);
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<DateTime?> getLastCacheTime();
  Future<void> setLastCacheTime(DateTime time);
}

// --- Repository Implementation ---
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  static const cacheDuration = Duration(minutes: 5);

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    // Check if cache is still valid
    final lastCacheTime = await localDataSource.getLastCacheTime();
    final cacheIsValid = lastCacheTime != null &&
        DateTime.now().difference(lastCacheTime) < cacheDuration;

    if (cacheIsValid) {
      // Return cached data
      final cachedProducts = await localDataSource.getCachedProducts();
      return cachedProducts.map((m) => m.toEntity()).toList();
    }

    // Cache expired or empty, fetch fresh data
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        await localDataSource.setLastCacheTime(DateTime.now());
        return remoteProducts.map((m) => m.toEntity()).toList();
      } catch (e) {
        // Network error, fallback to cache
        return _getFromCache();
      }
    } else {
      // Offline, use cache
      return _getFromCache();
    }
  }

  Future<List<Product>> _getFromCache() async {
    final cached = await localDataSource.getCachedProducts();
    if (cached.isEmpty) {
      throw CacheException('No cached products available');
    }
    return cached.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> getProduct(String id) async {
    // Try cache first for single product
    final cachedProduct = await localDataSource.getCachedProduct(id);

    if (cachedProduct != null) {
      // Refresh in background
      _refreshProduct(id);
      return cachedProduct.toEntity();
    }

    // Not in cache, must fetch
    if (await networkInfo.isConnected) {
      final remoteProduct = await remoteDataSource.getProduct(id);
      await localDataSource.cacheProduct(remoteProduct);
      return remoteProduct.toEntity();
    } else {
      throw NetworkException('Cannot load product offline');
    }
  }

  Future<void> _refreshProduct(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteProduct = await remoteDataSource.getProduct(id);
        await localDataSource.cacheProduct(remoteProduct);
      }
    } catch (_) {
      // Silent fail for background refresh
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    // For filtered queries, always try network first
    if (await networkInfo.isConnected) {
      final products = await remoteDataSource.getProductsByCategory(category);
      return products.map((m) => m.toEntity()).toList();
    }

    // Offline: Filter cached products
    final allCached = await localDataSource.getCachedProducts();
    // Note: This assumes we have category info in the cache
    return allCached.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    if (await networkInfo.isConnected) {
      final products = await remoteDataSource.searchProducts(query);
      return products.map((m) => m.toEntity()).toList();
    }

    // Offline: Search in cache
    final allCached = await localDataSource.getCachedProducts();
    final lowerQuery = query.toLowerCase();
    return allCached
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .map((m) => m.toEntity())
        .toList();
  }
}
*/

// ============================================
// REPOSITORY WITH PAGINATION
// ============================================

/*
// --- Paginated Result ---
class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  PaginatedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
  bool get isEmpty => items.isEmpty;
}

// --- Repository Interface ---
abstract class PaginatedProductRepository {
  Future<PaginatedResult<Product>> getProducts({
    required int page,
    int pageSize = 20,
    String? category,
    String? sortBy,
    bool ascending = true,
  });
}

// --- Implementation ---
class PaginatedProductRepositoryImpl implements PaginatedProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  PaginatedProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaginatedResult<Product>> getProducts({
    required int page,
    int pageSize = 20,
    String? category,
    String? sortBy,
    bool ascending = true,
  }) async {
    final response = await remoteDataSource.getProductsPaginated(
      page: page,
      limit: pageSize,
      category: category,
      sortBy: sortBy,
      ascending: ascending,
    );

    return PaginatedResult(
      items: response.data.map((m) => m.toEntity()).toList(),
      page: page,
      pageSize: pageSize,
      totalCount: response.total,
      totalPages: (response.total / pageSize).ceil(),
    );
  }
}

// --- Controller with Pagination ---
class ProductsController extends ChangeNotifier {
  final PaginatedProductRepository repository;

  ProductsController(this.repository);

  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadProducts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 0;
      _products = [];
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repository.getProducts(page: _currentPage + 1);

      _products.addAll(result.items);
      _currentPage = result.page;
      _hasMore = result.hasNextPage;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadProducts(refresh: true);
}
*/

// ============================================
// REPOSITORY WITH EITHER ERROR HANDLING
// ============================================

/*
import 'package:dartz/dartz.dart';

// --- Failures ---
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No connection']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Not found']) : super(message);
}

// --- Repository Interface ---
abstract class SafeProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, Product>> createProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}

// --- Implementation ---
class SafeProductRepositoryImpl implements SafeProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SafeProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (!await networkInfo.isConnected) {
      // Offline - try cache
      try {
        final cached = await localDataSource.getCachedProducts();
        if (cached.isEmpty) {
          return const Left(CacheFailure('No cached data available'));
        }
        return Right(cached.map((m) => m.toEntity()).toList());
      } catch (e) {
        return const Left(CacheFailure('Failed to read cache'));
      }
    }

    // Online - fetch from API
    try {
      final products = await remoteDataSource.getAllProducts();
      await localDataSource.cacheProducts(products);
      return Right(products.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache as fallback
      try {
        final cached = await localDataSource.getCachedProducts();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    if (!await networkInfo.isConnected) {
      final cached = await localDataSource.getCachedProduct(id);
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return const Left(NetworkFailure('Cannot load while offline'));
    }

    try {
      final product = await remoteDataSource.getProduct(id);
      await localDataSource.cacheProduct(product);
      return Right(product.toEntity());
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return const Left(NotFoundFailure('Product not found'));
      }
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot create while offline'));
    }

    try {
      final model = ProductModel.fromEntity(product);
      final created = await remoteDataSource.createProduct(model);
      await localDataSource.cacheProduct(created);
      return Right(created.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot update while offline'));
    }

    try {
      final model = ProductModel.fromEntity(product);
      final updated = await remoteDataSource.updateProduct(model);
      await localDataSource.cacheProduct(updated);
      return Right(updated.toEntity());
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return const Left(NotFoundFailure('Product not found'));
      }
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Cannot delete while offline'));
    }

    try {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.removeProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return const Left(NotFoundFailure('Product not found'));
      }
      return Left(ServerFailure(e.message));
    }
  }
}

// --- Using Either in Controller ---
class SafeProductsController extends ChangeNotifier {
  final SafeProductRepository repository;

  List<Product> _products = [];
  bool _isLoading = false;
  Failure? _failure;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  Failure? get failure => _failure;
  bool get hasError => _failure != null;

  SafeProductsController(this.repository);

  Future<void> loadProducts() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final result = await repository.getAllProducts();

    result.fold(
      (failure) => _failure = failure,
      (products) => _products = products,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteProduct(String id) async {
    final result = await repository.deleteProduct(id);

    return result.fold(
      (failure) {
        _failure = failure;
        notifyListeners();
        return false;
      },
      (_) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
        return true;
      },
    );
  }
}
*/

// ============================================
// REPOSITORY WITH OPTIMISTIC UPDATES
// ============================================

/*
class OptimisticRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  OptimisticRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Optimistic update: Update UI immediately, sync later
  Future<Either<Failure, void>> updateStock(String productId, int newStock) async {
    // 1. Get current state (for rollback)
    final originalProduct = await localDataSource.getCachedProduct(productId);
    if (originalProduct == null) {
      return const Left(NotFoundFailure());
    }

    // 2. Optimistically update local cache
    final updatedProduct = ProductModel(
      id: originalProduct.id,
      name: originalProduct.name,
      price: originalProduct.price,
      imageUrl: originalProduct.imageUrl,
      stock: newStock,
    );
    await localDataSource.cacheProduct(updatedProduct);

    // 3. Sync with server
    try {
      await remoteDataSource.updateProduct(updatedProduct);
      return const Right(null);
    } catch (e) {
      // 4. Rollback on failure
      await localDataSource.cacheProduct(originalProduct);
      return Left(ServerFailure('Failed to update: $e'));
    }
  }

  // Optimistic delete: Remove from UI immediately
  Future<Either<Failure, void>> deleteProduct(String id) async {
    // 1. Get current state (for rollback)
    final originalProduct = await localDataSource.getCachedProduct(id);

    // 2. Optimistically remove from cache
    await localDataSource.removeProduct(id);

    // 3. Sync with server
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      // 4. Rollback on failure
      if (originalProduct != null) {
        await localDataSource.cacheProduct(originalProduct);
      }
      return Left(ServerFailure('Failed to delete: $e'));
    }
  }
}
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │           REPOSITORY PATTERNS OVERVIEW                      │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  BASIC REPOSITORY:                                           │
  │  ├── Cache-first strategy for reads                         │
  │  ├── Network-first with cache fallback                      │
  │  └── Background refresh for single items                    │
  │                                                              │
  │  PAGINATED REPOSITORY:                                       │
  │  ├── Returns PaginatedResult with metadata                  │
  │  ├── Controller manages page state                          │
  │  └── Supports load-more pattern                             │
  │                                                              │
  │  EITHER ERROR HANDLING:                                      │
  │  ├── Explicit success/failure types                         │
  │  ├── No uncaught exceptions                                 │
  │  └── Typed failure handling                                 │
  │                                                              │
  │  OPTIMISTIC UPDATES:                                         │
  │  ├── Update UI immediately                                  │
  │  ├── Sync with server in background                         │
  │  └── Rollback on failure                                    │
  │                                                              │
  │  CACHING STRATEGIES:                                         │
  │  ├── Time-based expiry                                      │
  │  ├── Cache + refresh                                        │
  │  ├── Network-first with cache fallback                      │
  │  └── Offline-first with sync                                │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
