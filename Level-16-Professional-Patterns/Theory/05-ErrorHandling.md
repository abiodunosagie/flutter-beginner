# Error Handling Strategies

## The Simple Explanation

Error handling is like having a plan B (and C and D) for when things go wrong. Your app will encounter errors - the question is whether it crashes or handles them gracefully!

```
┌─────────────────────────────────────────────────────────────┐
│                    ERROR HANDLING                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITHOUT PROPER ERROR HANDLING:                              │
│                                                              │
│  User: *taps button*                                        │
│  App: *crashes* 💥                                          │
│  User: "What happened?!" 😤                                 │
│                                                              │
│  WITH PROPER ERROR HANDLING:                                 │
│                                                              │
│  User: *taps button*                                        │
│  App: "Oops! No internet. Try again?" 📡                    │
│  User: "Oh okay, I'll connect to WiFi" 👍                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Types of Errors

```
┌─────────────────────────────────────────────────────────────┐
│                    ERROR CATEGORIES                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  EXPECTED ERRORS (Handle gracefully)                         │
│  ├── Network errors (no internet, timeout)                  │
│  ├── API errors (404, 500, validation)                      │
│  ├── User input errors (invalid email)                      │
│  ├── Business logic errors (out of stock)                   │
│  └── Permission errors (camera denied)                      │
│                                                              │
│  UNEXPECTED ERRORS (Log and recover)                         │
│  ├── Null pointer exceptions                                │
│  ├── Type errors                                            │
│  ├── State errors                                           │
│  └── Programming bugs                                       │
│                                                              │
│  FATAL ERRORS (Show error screen)                            │
│  ├── Out of memory                                          │
│  ├── Storage full                                           │
│  └── Critical initialization failure                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Defining Exceptions and Failures

### Exceptions (Low-Level)

```dart
// Exceptions for technical errors (Data Layer)
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Request timed out']);
}

// Usage in Data Layer
class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw ServerException('Not found', 404);
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error', response.statusCode);
      } else {
        throw ServerException('Request failed', response.statusCode);
      }
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    }
  }
}
```

### Failures (High-Level)

```dart
// Failures for business logic (Domain Layer)
// These are user-friendly error representations

abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Something went wrong'])
      : super(message, 'SERVER_ERROR');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Please check your internet connection'])
      : super(message, 'NETWORK_ERROR');
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Could not load saved data'])
      : super(message, 'CACHE_ERROR');
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message)
      : super(message, 'VALIDATION_ERROR');
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication required'])
      : super(message, 'AUTH_ERROR');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message, 'NOT_FOUND');
}
```

---

## The Either Pattern

Using the `Either` type to represent success or failure explicitly.

### Setup

```yaml
# pubspec.yaml
dependencies:
  dartz: ^0.10.1
  # or
  fpdart: ^1.1.0
```

### Basic Usage

```dart
import 'package:dartz/dartz.dart';

// Either<LeftType, RightType>
// Left = Failure (by convention)
// Right = Success (by convention)

abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, void>> createUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final userModel = await remoteDataSource.getUser(id);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return Left(NotFoundFailure('User not found'));
      }
      return Left(ServerFailure(e.message));
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
```

### Using Either in Use Cases

```dart
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<Either<Failure, User>> execute(String id) {
    return repository.getUser(id);
  }
}

// In controller
class UserController extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;

  User? user;
  String? errorMessage;
  bool isLoading = false;

  UserController(this.getUserUseCase);

  Future<void> loadUser(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getUserUseCase.execute(id);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        user = null;
      },
      (userData) {
        user = userData;
        errorMessage = null;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
```

---

## Result Type (Alternative to Either)

A simpler alternative without external packages.

```dart
// Custom Result type
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

// Usage
abstract class UserRepository {
  Future<Result<User>> getUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Result<User>> getUser(String id) async {
    try {
      final user = await remoteDataSource.getUser(id);
      return Success(user.toEntity());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    }
  }
}

// In controller
Future<void> loadUser(String id) async {
  final result = await repository.getUser(id);

  switch (result) {
    case Success(:final data):
      user = data;
      errorMessage = null;
    case Error(:final failure):
      user = null;
      errorMessage = failure.message;
  }
}
```

---

## Global Error Handling

### FlutterError Handler

```dart
void main() {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to crash reporting service
    FirebaseCrashlytics.instance.recordFlutterError(details);

    // In debug, print to console
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  // Handle errors outside Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;  // Handled
  };

  runApp(MyApp());
}
```

### ErrorWidget Replacement

```dart
void main() {
  // Show custom error widget instead of red screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18),
              ),
              if (kDebugMode)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    details.exceptionAsString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(MyApp());
}
```

### Zone Error Handling

```dart
void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(MyApp());
    },
    (error, stackTrace) {
      // Handle all uncaught errors
      print('Caught error: $error');
      print('Stack trace: $stackTrace');
      // Log to crash reporting
    },
  );
}
```

---

## UI Error Handling

### Error Display Widgets

```dart
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? details;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage != null) {
          return ErrorView(
            message: controller.errorMessage!,
            onRetry: () => controller.loadUser('123'),
          );
        }

        if (controller.user == null) {
          return const ErrorView(message: 'No user found');
        }

        return UserProfile(user: controller.user!);
      },
    );
  }
}
```

### SnackBar for Non-Fatal Errors

```dart
class ErrorHandler {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

---

## Async Error Handling Patterns

### AsyncValue Pattern

```dart
// Similar to Riverpod's AsyncValue
sealed class AsyncState<T> {
  const AsyncState();
}

class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

class AsyncError<T> extends AsyncState<T> {
  final Object error;
  final StackTrace? stackTrace;
  const AsyncError(this.error, [this.stackTrace]);
}

class AsyncData<T> extends AsyncState<T> {
  final T data;
  const AsyncData(this.data);
}

// Controller using AsyncState
class ProductsController extends ChangeNotifier {
  AsyncState<List<Product>> state = const AsyncLoading();

  final GetProductsUseCase getProductsUseCase;

  ProductsController(this.getProductsUseCase) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncLoading();
    notifyListeners();

    final result = await getProductsUseCase.execute();

    state = result.fold(
      (failure) => AsyncError(failure),
      (products) => AsyncData(products),
    );
    notifyListeners();
  }
}

// Widget using pattern matching
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductsController>();

    return switch (controller.state) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => ErrorView(
          message: (error as Failure).message,
          onRetry: controller.loadProducts,
        ),
      AsyncData(:final data) => ProductList(products: data),
    };
  }
}
```

---

## Error Handling Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│           ERROR HANDLING BEST PRACTICES                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DO:                                                         │
│  ✅ Use typed errors (Failure classes)                       │
│  ✅ Provide user-friendly messages                           │
│  ✅ Log technical details for debugging                      │
│  ✅ Offer recovery options (retry button)                    │
│  ✅ Handle errors at appropriate levels                      │
│  ✅ Use Either/Result for explicit error handling            │
│                                                              │
│  DON'T:                                                      │
│  ❌ Show technical errors to users                           │
│  ❌ Catch and ignore errors                                  │
│  ❌ Use generic catch-all handlers                           │
│  ❌ Let the app crash without logging                        │
│  ❌ Show error dialogs for minor issues                      │
│                                                              │
│  ERROR MESSAGE TIPS:                                         │
│  ✅ "Unable to connect. Check your internet."               │
│  ❌ "SocketException: Connection refused"                    │
│                                                              │
│  ✅ "Could not save changes. Please try again."             │
│  ❌ "Error 500: Internal Server Error"                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              ERROR HANDLING SUMMARY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  EXCEPTION vs FAILURE:                                       │
│  ├── Exception: Technical, low-level (Data Layer)          │
│  └── Failure: User-friendly (Domain Layer)                  │
│                                                              │
│  EITHER/RESULT PATTERN:                                      │
│  ├── Explicit success/failure handling                      │
│  ├── No uncaught exceptions                                 │
│  └── Type-safe error handling                               │
│                                                              │
│  GLOBAL HANDLERS:                                            │
│  ├── FlutterError.onError for framework errors              │
│  ├── runZonedGuarded for uncaught errors                    │
│  └── ErrorWidget.builder for custom error UI                │
│                                                              │
│  UI ERROR HANDLING:                                          │
│  ├── ErrorView for full-screen errors                       │
│  ├── SnackBar for non-fatal errors                          │
│  └── Dialog for important decisions                         │
│                                                              │
│  KEY PRINCIPLES:                                             │
│  ├── Handle errors at appropriate level                     │
│  ├── User-friendly messages                                 │
│  ├── Log for debugging                                      │
│  └── Always offer recovery options                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Congratulations!** You've completed the Theory section of Level 16!

Continue to the Examples to see these patterns in action.
