# Dependency Injection

## The Big Idea In One Sentence

> Dependency injection means a class receives what it needs from outside instead of creating it itself, and pro apps often use a tool (like get_it) to wire everything in one place.

## The Simple Explanation

Dependency Injection (DI) is like a restaurant that doesn't grow its own vegetables. Instead of the kitchen producing everything, ingredients are delivered by suppliers. The kitchen just says "I need tomatoes" and tomatoes appear!

```
┌─────────────────────────────────────────────────────────────┐
│              WITHOUT DEPENDENCY INJECTION                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  class Kitchen {                                             │
│    void cook() {                                             │
│      final tomatoes = TomatoFarm().harvest();  // ❌         │
│      final cheese = DairyFarm().getCheese();   // ❌         │
│      // Kitchen knows too much about farms!                 │
│    }                                                         │
│  }                                                           │
│                                                              │
│  Problems:                                                   │
│  • Can't test kitchen without real farms                    │
│  • Can't swap tomato suppliers easily                       │
│  • Kitchen is tightly coupled to farms                      │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│              WITH DEPENDENCY INJECTION                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  class Kitchen {                                             │
│    final TomatoSupplier tomatoes;  // ✅ Injected            │
│    final CheeseSupplier cheese;    // ✅ Injected            │
│                                                              │
│    Kitchen(this.tomatoes, this.cheese);                     │
│                                                              │
│    void cook() {                                             │
│      final t = tomatoes.get();                              │
│      final c = cheese.get();                                │
│    }                                                         │
│  }                                                           │
│                                                              │
│  Benefits:                                                   │
│  • Test with mock suppliers                                 │
│  • Swap suppliers easily                                    │
│  • Kitchen only cares about cooking                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Why Dependency Injection?

```
┌─────────────────────────────────────────────────────────────┐
│              BENEFITS OF DEPENDENCY INJECTION                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TESTABILITY:                                                │
│  └── Replace real services with mocks in tests              │
│                                                              │
│  FLEXIBILITY:                                                │
│  └── Swap implementations without changing code             │
│      (e.g., switch from REST to GraphQL)                    │
│                                                              │
│  SINGLE RESPONSIBILITY:                                      │
│  └── Classes don't create their dependencies                │
│                                                              │
│  MAINTAINABILITY:                                            │
│  └── Changes in one place propagate everywhere              │
│                                                              │
│  REUSABILITY:                                                │
│  └── Same class works with different dependencies           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Manual Dependency Injection

Start simple - pass dependencies through constructors.

```dart
// Repository interface
abstract class UserRepository {
  Future<User> getUser(String id);
}

// Real implementation
class ApiUserRepository implements UserRepository {
  final ApiClient client;

  ApiUserRepository(this.client);

  @override
  Future<User> getUser(String id) async {
    final response = await client.get('/users/$id');
    return User.fromJson(response);
  }
}

// Use case with injected dependency
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);  // Dependency injected!

  Future<User> execute(String id) => repository.getUser(id);
}

// Controller with injected dependencies
class UserController extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;

  UserController(this.getUserUseCase);

  User? user;
  bool isLoading = false;

  Future<void> loadUser(String id) async {
    isLoading = true;
    notifyListeners();

    user = await getUserUseCase.execute(id);

    isLoading = false;
    notifyListeners();
  }
}

// Wire it all together manually
void main() {
  final client = ApiClient();
  final repository = ApiUserRepository(client);
  final useCase = GetUserUseCase(repository);
  final controller = UserController(useCase);

  runApp(
    ChangeNotifierProvider.value(
      value: controller,
      child: MyApp(),
    ),
  );
}
```

---

## GetIt Service Locator

GetIt is a simple service locator for Dart/Flutter.

### Basic Setup

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

// Register dependencies
void setupDependencies() {
  // Singleton - same instance every time
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Lazy Singleton - created when first accessed
  getIt.registerLazySingleton<UserRepository>(
    () => ApiUserRepository(getIt<ApiClient>()),
  );

  // Factory - new instance every time
  getIt.registerFactory<GetUserUseCase>(
    () => GetUserUseCase(getIt<UserRepository>()),
  );
}

// Use in main.dart
void main() {
  setupDependencies();
  runApp(MyApp());
}

// Access anywhere in your app
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final useCase = getIt<GetUserUseCase>();
    // ...
  }
}
```

### Registration Types

```dart
// SINGLETON
// Same instance throughout app lifecycle
// Use for: Database, API client, shared services
getIt.registerSingleton<ApiClient>(ApiClient());

// LAZY SINGLETON
// Created when first accessed, then reused
// Use for: Heavy objects not needed immediately
getIt.registerLazySingleton<Database>(() => Database());

// FACTORY
// New instance every time
// Use for: Use cases, controllers that need fresh state
getIt.registerFactory<LoginUseCase>(() => LoginUseCase(
  getIt<AuthRepository>(),
));

// FACTORY WITH PARAMS
// Pass parameters when creating
getIt.registerFactoryParam<UserController, String, void>(
  (userId, _) => UserController(userId, getIt<UserRepository>()),
);

// Usage:
final controller = getIt<UserController>(param1: 'user123');
```

### Complete GetIt Setup

```dart
// injection_container.dart

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;  // 'sl' = service locator

Future<void> init() async {
  //! External
  sl.registerLazySingleton(() => http.Client());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! Features - Auth
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Controllers/Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();  // Initialize dependencies
  runApp(MyApp());
}
```

---

## Injectable Package

Injectable generates GetIt registration code automatically.

### Setup

```yaml
# pubspec.yaml
dependencies:
  get_it: ^7.6.0
  injectable: ^2.1.0

dev_dependencies:
  build_runner: ^2.4.0
  injectable_generator: ^2.1.0
```

### Using Annotations

```dart
// Mark classes with annotations

// Singleton
@singleton
class ApiClient {
  // ...
}

// Lazy singleton
@lazySingleton
class Database {
  // ...
}

// Factory
@injectable
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);
}

// Register as interface implementation
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final ApiClient client;

  UserRepositoryImpl(this.client);
}
```

### Generate Code

```bash
# Run code generator
flutter pub run build_runner build

# Or watch for changes
flutter pub run build_runner watch
```

### injection.dart

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// main.dart
void main() {
  configureDependencies();
  runApp(MyApp());
}
```

---

## Testing with DI

DI makes testing much easier!

```dart
// Real implementation
@LazySingleton(as: UserRepository)
class ApiUserRepository implements UserRepository {
  final ApiClient client;

  ApiUserRepository(this.client);

  @override
  Future<User> getUser(String id) async {
    final response = await client.get('/users/$id');
    return User.fromJson(response);
  }
}

// Mock for testing
class MockUserRepository implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    return User(id: id, name: 'Test User', email: 'test@test.com');
  }
}

// In tests
void main() {
  late GetUserUseCase useCase;

  setUp(() {
    // Inject mock instead of real repository
    useCase = GetUserUseCase(MockUserRepository());
  });

  test('should return user', () async {
    final user = await useCase.execute('123');
    expect(user.name, 'Test User');
  });
}

// Or with GetIt
void main() {
  setUp(() {
    // Reset and register mocks
    getIt.reset();
    getIt.registerSingleton<UserRepository>(MockUserRepository());
  });

  test('should work with mock', () async {
    final useCase = GetUserUseCase(getIt<UserRepository>());
    final user = await useCase.execute('123');
    expect(user.name, 'Test User');
  });
}
```

---

## Environment-Based Injection

Different dependencies for different environments.

```dart
// Define environments
const dev = Environment('dev');
const prod = Environment('prod');
const test = Environment('test');

// Register different implementations per environment
@dev
@LazySingleton(as: ApiClient)
class DevApiClient implements ApiClient {
  final baseUrl = 'https://dev-api.example.com';
}

@prod
@LazySingleton(as: ApiClient)
class ProdApiClient implements ApiClient {
  final baseUrl = 'https://api.example.com';
}

@test
@LazySingleton(as: ApiClient)
class MockApiClient implements ApiClient {
  final baseUrl = 'mock';
}

// main.dart
void main() {
  configureDependencies(environment: 'prod');  // or 'dev', 'test'
  runApp(MyApp());
}
```

---

## Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│             DEPENDENCY INJECTION BEST PRACTICES              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DO:                                                         │
│  ✅ Depend on abstractions (interfaces), not implementations │
│  ✅ Register dependencies in one place                       │
│  ✅ Use factories for stateful objects                       │
│  ✅ Use singletons for stateless services                    │
│  ✅ Keep the DI setup organized by feature                   │
│                                                              │
│  DON'T:                                                      │
│  ❌ Access GetIt directly in business logic                  │
│  ❌ Create circular dependencies                             │
│  ❌ Over-inject (not everything needs DI)                    │
│  ❌ Mix DI patterns (pick one and stick with it)            │
│                                                              │
│  WHEN TO USE:                                                │
│  ✅ Services (API, Database, Auth)                           │
│  ✅ Repositories                                             │
│  ✅ Use Cases                                                │
│  ✅ Controllers/BLoCs                                        │
│                                                              │
│  WHEN NOT TO USE:                                            │
│  ❌ Simple widgets                                           │
│  ❌ Static utilities                                         │
│  ❌ Value objects/entities                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Common Patterns

### Scoped Dependencies

```dart
// Module-scoped dependencies
void registerAuthModule() {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
    instanceName: 'auth',
  );
}

void registerUserModule() {
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
    instanceName: 'user',
  );
}

// Feature flags or configuration
getIt.registerSingleton<AppConfig>(
  AppConfig(
    apiUrl: Environment.apiUrl,
    debugMode: kDebugMode,
  ),
);
```

### Disposing Resources

```dart
// Register with disposal
getIt.registerSingleton<Database>(
  Database(),
  dispose: (db) => db.close(),
);

// On app shutdown
await getIt.reset();  // Calls all dispose functions
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           DEPENDENCY INJECTION SUMMARY                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WHAT IT IS:                                                 │
│  └── Providing dependencies from outside, not creating them │
│                                                              │
│  WHY USE IT:                                                 │
│  ├── Testability (mock dependencies)                        │
│  ├── Flexibility (swap implementations)                     │
│  └── Maintainability (single source of truth)               │
│                                                              │
│  HOW TO DO IT:                                               │
│  ├── Manual: Constructor injection                          │
│  ├── GetIt: Service locator pattern                         │
│  └── Injectable: Code generation                            │
│                                                              │
│  REGISTRATION TYPES:                                         │
│  ├── Singleton: Same instance always                        │
│  ├── Lazy Singleton: Created on first access                │
│  └── Factory: New instance each time                        │
│                                                              │
│  BEST PRACTICES:                                             │
│  ├── Depend on interfaces                                   │
│  ├── Centralize registration                                │
│  ├── Use appropriate scope                                  │
│  └── Don't over-engineer                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What is dependency injection in one line? (You saw this in Level 8 too.)

<details>
<summary>Answer</summary>
Giving a class what it needs from outside (usually via the constructor) instead of building it inside.
</details>

**Q2.** What does a DI tool like `get_it` do for you?

<details>
<summary>Answer</summary>
It registers and provides your services/repositories from one central place, so you do not hand-wire them everywhere.
</details>

**Q3.** How does DI help testing?

<details>
<summary>Answer</summary>
You can inject a mock/fake in tests instead of the real dependency, so tests run fast and predictably.
</details>

---

## Assignment

### Problem 1: Inject it

Rewrite so the class receives its dependency: `class Service { final repo = Repo(); }`.

### Problem 2: Why a container?

Name one benefit of registering dependencies in a DI container (like get_it).

### Problem 3: Test swap

In a test, what do you inject instead of the real repository?

---

## Assignment Answers

### Problem 1: Inject it

```dart
class Service {
  final Repo repo;
  Service(this.repo);
}
```

### Problem 2: Why a container?

You configure everything in one place, get shared single instances easily, and change wiring without editing every class that uses it.

### Problem 3: Test swap

A mock/fake repository, so the test runs without real I/O and with predictable data.

---

**Next:** `04-RepositoryPattern.md` - Abstracting data access
