# Repository Pattern

## The Big Idea In One Sentence

> A repository is the single doorway to your data: the rest of the app asks it for things and never knows whether they come from an API, a cache, or a database, which you also met in Level 8.

## The Simple Explanation

The Repository Pattern is like a librarian. When you need a book, you ask the librarian - not the publisher, not the warehouse, not the printing press. The librarian handles all that complexity for you. You just say "I need this book" and get it!

```
┌─────────────────────────────────────────────────────────────┐
│                  REPOSITORY ANALOGY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITHOUT REPOSITORY:                                         │
│                                                              │
│  You → "I need user data"                                   │
│      ↓                                                       │
│  "Is it in the API?"                                        │
│      ↓                                                       │
│  "What's the endpoint?"                                      │
│      ↓                                                       │
│  "How do I parse JSON?"                                      │
│      ↓                                                       │
│  "What if API fails?"                                        │
│      ↓                                                       │
│  "Should I cache it?"                                        │
│                                                              │
│  ... complicated! 😫                                         │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITH REPOSITORY:                                            │
│                                                              │
│  You → "I need user data" → Repository → User               │
│                                                              │
│  That's it! 😊                                               │
│                                                              │
│  Repository handles:                                         │
│  • API calls                                                │
│  • Caching                                                  │
│  • Error handling                                           │
│  • Data transformation                                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Concepts

```
┌─────────────────────────────────────────────────────────────┐
│              REPOSITORY PATTERN STRUCTURE                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                    ┌─────────────────┐                      │
│                    │   Use Cases /   │                      │
│                    │   Controllers   │                      │
│                    └────────┬────────┘                      │
│                             │                                │
│                             ▼                                │
│                    ┌─────────────────┐                      │
│                    │   Repository    │ ← Interface          │
│                    │   (Interface)   │   (in Domain)        │
│                    └────────┬────────┘                      │
│                             │                                │
│                             ▼                                │
│                    ┌─────────────────┐                      │
│                    │   Repository    │ ← Implementation     │
│                    │   (Impl)        │   (in Data)          │
│                    └────────┬────────┘                      │
│                    ┌────────┴────────┐                      │
│                    ▼                 ▼                       │
│           ┌─────────────┐    ┌─────────────┐               │
│           │   Remote    │    │   Local     │               │
│           │   Source    │    │   Source    │               │
│           │   (API)     │    │   (Cache)   │               │
│           └─────────────┘    └─────────────┘               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic Implementation

### Step 1: Define Entity (Domain Layer)

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
}
```

### Step 2: Define Repository Interface (Domain Layer)

```dart
// domain/repositories/user_repository.dart

// This is a CONTRACT - it says WHAT can be done, not HOW
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getAllUsers();
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}
```

### Step 3: Define Model (Data Layer)

```dart
// data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String createdAt;  // String from API

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  // From JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
    );
  }

  // To JSON (API request)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'created_at': createdAt,
  };

  // Convert to Entity
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    createdAt: DateTime.parse(createdAt),
  );

  // Create from Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt.toIso8601String(),
    );
  }
}
```

### Step 4: Define Data Sources

```dart
// data/datasources/user_remote_datasource.dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getAllUsers();
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> getUser(String id) async {
    final response = await client.get('/users/$id');
    return UserModel.fromJson(response);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await client.get('/users');
    return (response as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  // ... other methods
}

// data/datasources/user_local_datasource.dart
abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser(String id);
  Future<List<UserModel>> getCachedUsers();
  Future<void> cacheUser(UserModel user);
  Future<void> cacheUsers(List<UserModel> users);
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences prefs;

  UserLocalDataSourceImpl(this.prefs);

  @override
  Future<UserModel?> getCachedUser(String id) async {
    final jsonString = prefs.getString('user_$id');
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  // ... other methods
}
```

### Step 5: Implement Repository

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<User> getUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        // Online: Get from API
        final remoteUser = await remoteDataSource.getUser(id);
        // Cache for offline use
        await localDataSource.cacheUser(remoteUser);
        // Return as entity
        return remoteUser.toEntity();
      } catch (e) {
        // API failed, try cache
        return _getUserFromCache(id);
      }
    } else {
      // Offline: Get from cache
      return _getUserFromCache(id);
    }
  }

  Future<User> _getUserFromCache(String id) async {
    final cachedUser = await localDataSource.getCachedUser(id);
    if (cachedUser != null) {
      return cachedUser.toEntity();
    }
    throw CacheException('User not found in cache');
  }

  @override
  Future<List<User>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getAllUsers();
        await localDataSource.cacheUsers(remoteUsers);
        return remoteUsers.map((m) => m.toEntity()).toList();
      } catch (e) {
        return _getUsersFromCache();
      }
    } else {
      return _getUsersFromCache();
    }
  }

  Future<List<User>> _getUsersFromCache() async {
    final cached = await localDataSource.getCachedUsers();
    return cached.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createUser(User user) async {
    final model = UserModel.fromEntity(user);
    await remoteDataSource.createUser(model);
    await localDataSource.cacheUser(model);
  }

  // ... other methods
}
```

---

## Using the Repository

```dart
// In a Use Case
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> execute(String id) => repository.getUser(id);
}

// In a Controller
class UserController extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;

  User? user;
  bool isLoading = false;
  String? error;

  UserController(this.getUserUseCase);

  Future<void> loadUser(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await getUserUseCase.execute(id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## Advanced Patterns

### Caching Strategies

```dart
// Strategy 1: Cache First (Good for static data)
Future<List<Product>> getProducts() async {
  // Try cache first
  final cached = await localDataSource.getCachedProducts();
  if (cached.isNotEmpty) {
    // Return cached data immediately
    // Refresh in background (optional)
    _refreshProducts();
    return cached.map((m) => m.toEntity()).toList();
  }

  // No cache, must fetch
  return _fetchProducts();
}

// Strategy 2: Network First (Good for dynamic data)
Future<User> getUser(String id) async {
  try {
    // Try network first
    final remote = await remoteDataSource.getUser(id);
    await localDataSource.cacheUser(remote);
    return remote.toEntity();
  } catch (e) {
    // Network failed, use cache
    final cached = await localDataSource.getCachedUser(id);
    if (cached != null) return cached.toEntity();
    rethrow;
  }
}

// Strategy 3: Cache with Expiry
Future<User> getUserWithExpiry(String id) async {
  final cached = await localDataSource.getCachedUser(id);
  final cacheTime = await localDataSource.getCacheTime(id);

  final isExpired = cacheTime != null &&
      DateTime.now().difference(cacheTime).inMinutes > 5;

  if (cached != null && !isExpired) {
    return cached.toEntity();
  }

  // Fetch fresh data
  final remote = await remoteDataSource.getUser(id);
  await localDataSource.cacheUser(remote);
  await localDataSource.setCacheTime(id, DateTime.now());
  return remote.toEntity();
}
```

### Pagination

```dart
abstract class ProductRepository {
  Future<PaginatedResult<Product>> getProducts({
    required int page,
    required int pageSize,
    String? category,
    String? searchQuery,
  });
}

class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => page * pageSize < totalCount;
  int get totalPages => (totalCount / pageSize).ceil();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<PaginatedResult<Product>> getProducts({
    required int page,
    required int pageSize,
    String? category,
    String? searchQuery,
  }) async {
    final response = await remoteDataSource.getProducts(
      page: page,
      limit: pageSize,
      category: category,
      search: searchQuery,
    );

    return PaginatedResult(
      items: response.data.map((m) => m.toEntity()).toList(),
      totalCount: response.total,
      page: page,
      pageSize: pageSize,
    );
  }
}
```

### Optimistic Updates

```dart
class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> toggleComplete(String taskId) async {
    // Get current state
    final task = await localDataSource.getTask(taskId);
    if (task == null) throw TaskNotFoundException();

    // Optimistically update local state
    final updatedTask = task.copyWith(isComplete: !task.isComplete);
    await localDataSource.updateTask(updatedTask);

    try {
      // Sync with server
      await remoteDataSource.updateTask(updatedTask);
    } catch (e) {
      // Rollback on failure
      await localDataSource.updateTask(task);
      rethrow;
    }
  }
}
```

---

## Error Handling

```dart
// Define failure types
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error']) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure([String message = 'Cache error']) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = 'No internet connection']) : super(message);
}

// Use Either type (from dartz package)
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final remote = await remoteDataSource.getUser(id);
      await localDataSource.cacheUser(remote);
      return Right(remote.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

// Usage
final result = await repository.getUser('123');
result.fold(
  (failure) => showError(failure.message),
  (user) => showUser(user),
);
```

---

## Testing Repositories

```dart
class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}
class MockLocalDataSource extends Mock implements UserLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late UserRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('getUser', () {
    test('should return user from remote when online', () async {
      // Arrange
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.getUser('1')).thenAnswer(
        (_) async => UserModel(id: '1', name: 'Test', email: 'test@test.com'),
      );
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async {});

      // Act
      final user = await repository.getUser('1');

      // Assert
      expect(user.name, 'Test');
      verify(() => mockLocal.cacheUser(any())).called(1);
    });

    test('should return cached user when offline', () async {
      // Arrange
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedUser('1')).thenAnswer(
        (_) async => UserModel(id: '1', name: 'Cached', email: 'c@c.com'),
      );

      // Act
      final user = await repository.getUser('1');

      // Assert
      expect(user.name, 'Cached');
      verifyNever(() => mockRemote.getUser(any()));
    });
  });
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              REPOSITORY PATTERN SUMMARY                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STRUCTURE:                                                  │
│  ├── Entity (Domain) - Pure business object                │
│  ├── Model (Data) - API/DB representation                  │
│  ├── Repository Interface (Domain) - Contract              │
│  ├── Repository Impl (Data) - Implementation               │
│  └── Data Sources - Remote (API) and Local (Cache)         │
│                                                              │
│  RESPONSIBILITIES:                                           │
│  ├── Abstract data access                                   │
│  ├── Handle caching                                         │
│  ├── Manage offline support                                 │
│  └── Transform data (Model ↔ Entity)                       │
│                                                              │
│  BENEFITS:                                                   │
│  ├── Clean separation of concerns                           │
│  ├── Easy to test with mocks                                │
│  ├── Swap data sources without changing logic               │
│  └── Single source of truth for data                        │
│                                                              │
│  PATTERNS:                                                   │
│  ├── Cache-first, Network-first strategies                  │
│  ├── Pagination support                                     │
│  ├── Optimistic updates                                     │
│  └── Error handling with Either type                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does a repository hide from the rest of the app?

<details>
<summary>Answer</summary>
Where the data comes from (API, cache, local DB). Callers just ask for data and get model objects.
</details>

**Q2.** Why define it as an interface (abstract class)?

<details>
<summary>Answer</summary>
So you can swap implementations, a real one in production and a mock/fake in tests, behind the same contract.
</details>

**Q3.** How does the repository pattern support caching or offline mode?

<details>
<summary>Answer</summary>
The repository can decide internally to return cached/local data or fetch fresh from the network, without callers changing.
</details>

---

## Assignment

### Problem 1: The doorway

A controller needs the list of articles. Should it call the API directly or the repository? Why?

### Problem 2: Add caching

You want to cache articles for 5 minutes. Which layer changes, and do callers change?

### Problem 3: Interface benefit

Name one thing an abstract `ArticleRepository` lets you do.

---

## Assignment Answers

### Problem 1: The doorway

The repository. The controller should not know about HTTP/URLs; it just asks the repository, which handles the data source.

### Problem 2: Add caching

Only the repository implementation changes (it checks the cache first). Callers do not change, they still call the same method.

### Problem 3: Interface benefit

Swap in a mock for tests, or provide multiple implementations (API, cached, local) without touching the code that uses it.

---

**Next:** `05-ErrorHandling.md` - Graceful failure strategies
