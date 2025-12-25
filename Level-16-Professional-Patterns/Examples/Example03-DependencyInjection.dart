// ============================================
// EXAMPLE 03: DEPENDENCY INJECTION SETUP
// Complete GetIt configuration examples
// ============================================

/*
  This file demonstrates:
  1. Basic GetIt setup
  2. Registration types
  3. Feature-based registration
  4. Environment-based configuration
  5. Testing with DI

  NOTE: Copy this code into a real Flutter project to run it.
*/

// ============================================
// BASIC GETIT SETUP
// ============================================

/*
import 'package:get_it/get_it.dart';

// Global service locator instance
final sl = GetIt.instance;
// OR
final getIt = GetIt.instance;

// Simple setup
void setupBasicDependencies() {
  // Register a singleton (one instance for entire app)
  sl.registerSingleton<ApiClient>(ApiClient());

  // Register a lazy singleton (created on first use)
  sl.registerLazySingleton<Database>(() => Database());

  // Register a factory (new instance each time)
  sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl()));
}

// Usage anywhere in the app
class SomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = sl<ApiClient>();
    final db = sl<Database>();
    final login = sl<LoginUseCase>();  // New instance each time

    // ...
  }
}
*/

// ============================================
// COMPLETE INJECTION CONTAINER
// ============================================

/*
// injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! ============================================
  //! EXTERNAL DEPENDENCIES
  //! ============================================

  // HTTP Client
  sl.registerLazySingleton(() => http.Client());

  // SharedPreferences (async initialization)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Internet connection checker
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! ============================================
  //! CORE
  //! ============================================

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // API Client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClientImpl(
      client: sl(),
      baseUrl: 'https://api.example.com',
    ),
  );

  //! ============================================
  //! FEATURE: AUTH
  //! ============================================

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Controller (Factory - new instance per screen)
  sl.registerFactory(
    () => AuthController(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  //! ============================================
  //! FEATURE: PRODUCTS
  //! ============================================

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));

  // Controller
  sl.registerFactory(
    () => ProductsController(
      getAllProductsUseCase: sl(),
      searchProductsUseCase: sl(),
    ),
  );

  //! ============================================
  //! FEATURE: CART
  //! ============================================

  // Cart is session-scoped (singleton for app lifecycle)
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localStorage: sl()),
  );

  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));

  sl.registerLazySingleton(
    () => CartController(
      addToCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      getCartUseCase: sl(),
    ),
  );
}
*/

// ============================================
// FEATURE-BASED REGISTRATION
// ============================================

/*
// For large apps, split registration into feature modules

// features/auth/di/auth_injection.dart
void registerAuthDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Controller
  sl.registerFactory(() => AuthController(
    loginUseCase: sl(),
    logoutUseCase: sl(),
  ));
}

// features/products/di/products_injection.dart
void registerProductsDependencies(GetIt sl) {
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerFactory(() => ProductsController(sl()));
}

// injection_container.dart
Future<void> init() async {
  // Core dependencies
  await _initCore();

  // Feature dependencies
  registerAuthDependencies(sl);
  registerProductsDependencies(sl);
  registerCartDependencies(sl);
  registerOrdersDependencies(sl);
}

Future<void> _initCore() async {
  sl.registerLazySingleton(() => http.Client());
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(sl()));
}
*/

// ============================================
// ENVIRONMENT-BASED CONFIGURATION
// ============================================

/*
// config/app_config.dart
class AppConfig {
  final String apiBaseUrl;
  final bool enableLogging;
  final bool useMockData;

  const AppConfig({
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.useMockData,
  });
}

const devConfig = AppConfig(
  apiBaseUrl: 'https://dev-api.example.com',
  enableLogging: true,
  useMockData: false,
);

const prodConfig = AppConfig(
  apiBaseUrl: 'https://api.example.com',
  enableLogging: false,
  useMockData: false,
);

const testConfig = AppConfig(
  apiBaseUrl: 'http://localhost:8080',
  enableLogging: true,
  useMockData: true,
);

// injection_container.dart
enum Environment { dev, prod, test }

Future<void> init({Environment env = Environment.dev}) async {
  // Register config based on environment
  final config = switch (env) {
    Environment.dev => devConfig,
    Environment.prod => prodConfig,
    Environment.test => testConfig,
  };

  sl.registerSingleton<AppConfig>(config);

  // Use config for API client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClientImpl(
      client: sl(),
      baseUrl: sl<AppConfig>().apiBaseUrl,
      enableLogging: sl<AppConfig>().enableLogging,
    ),
  );

  // Use mock or real data sources based on config
  if (config.useMockData) {
    sl.registerLazySingleton<ProductRepository>(
      () => MockProductRepository(),
    );
  } else {
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl(), sl()),
    );
  }

  // ... rest of registration
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Choose environment based on build flavor
  const environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  await init(
    env: switch (environment) {
      'prod' => Environment.prod,
      'test' => Environment.test,
      _ => Environment.dev,
    },
  );

  runApp(const MyApp());
}

// Run with: flutter run --dart-define=ENV=prod
*/

// ============================================
// FACTORY WITH PARAMETERS
// ============================================

/*
// Sometimes you need to pass parameters when creating instances

// Register factory with parameters
sl.registerFactoryParam<ProductDetailController, String, void>(
  (productId, _) => ProductDetailController(
    productId: productId,
    getProductUseCase: sl(),
  ),
);

// Usage
final controller = sl<ProductDetailController>(param1: 'product-123');

// For two parameters
sl.registerFactoryParam<OrderController, String, OrderType>(
  (orderId, orderType) => OrderController(
    orderId: orderId,
    orderType: orderType,
    repository: sl(),
  ),
);

// Usage
final orderController = sl<OrderController>(
  param1: 'order-456',
  param2: OrderType.delivery,
);
*/

// ============================================
// DISPOSING RESOURCES
// ============================================

/*
// Register with dispose callback
sl.registerSingleton<Database>(
  Database(),
  dispose: (db) async {
    await db.close();
    print('Database closed');
  },
);

sl.registerSingleton<WebSocketClient>(
  WebSocketClient(),
  dispose: (client) async {
    await client.disconnect();
    print('WebSocket disconnected');
  },
);

// On app shutdown or logout
Future<void> resetDependencies() async {
  await sl.reset();  // Disposes all and clears registry
}

// Or dispose specific type
Future<void> disposeDatabase() async {
  await sl.resetLazySingleton<Database>();
}
*/

// ============================================
// TESTING WITH DEPENDENCY INJECTION
// ============================================

/*
// test/mocks.dart
class MockProductRepository extends Mock implements ProductRepository {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

// test/products_controller_test.dart
void main() {
  late ProductsController controller;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();

    // Reset and register mocks
    sl.reset();
    sl.registerSingleton<ProductRepository>(mockRepository);

    controller = ProductsController(sl());
  });

  tearDown(() {
    sl.reset();
  });

  test('should load products successfully', () async {
    // Arrange
    final products = [
      Product(id: '1', name: 'Test', price: 9.99),
    ];
    when(() => mockRepository.getAllProducts())
        .thenAnswer((_) async => Right(products));

    // Act
    await controller.loadProducts();

    // Assert
    expect(controller.products, products);
    expect(controller.hasError, false);
  });

  test('should handle error', () async {
    // Arrange
    when(() => mockRepository.getAllProducts())
        .thenAnswer((_) async => Left(ServerFailure('Error')));

    // Act
    await controller.loadProducts();

    // Assert
    expect(controller.products, isEmpty);
    expect(controller.hasError, true);
  });
}

// Integration test with test dependencies
void main() {
  setUpAll(() async {
    // Initialize with test environment
    await init(env: Environment.test);
  });

  tearDownAll(() async {
    await sl.reset();
  });

  testWidgets('full integration test', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => sl<ProductsController>(),
        child: const MaterialApp(home: ProductsScreen()),
      ),
    );

    // Test with real (mock) dependencies
  });
}
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │         DEPENDENCY INJECTION PATTERNS                       │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  REGISTRATION TYPES:                                         │
  │  ├── registerSingleton    → Immediate, same instance        │
  │  ├── registerLazySingleton → On first use, same instance   │
  │  ├── registerFactory      → New instance each time         │
  │  └── registerFactoryParam → Factory with parameters        │
  │                                                              │
  │  ORGANIZATION:                                               │
  │  ├── Core dependencies first (http, prefs)                 │
  │  ├── Feature-based modules                                 │
  │  └── Controllers as factories                               │
  │                                                              │
  │  ENVIRONMENTS:                                               │
  │  ├── Dev: Debug logging, dev API                           │
  │  ├── Prod: No logging, prod API                            │
  │  └── Test: Mock data, local server                         │
  │                                                              │
  │  TESTING:                                                    │
  │  ├── sl.reset() to clear all                               │
  │  ├── Register mocks before tests                           │
  │  └── Use Environment.test for integration tests            │
  │                                                              │
  │  BEST PRACTICES:                                             │
  │  ✅ One injection file for small apps                       │
  │  ✅ Feature-based for large apps                            │
  │  ✅ Dispose resources properly                              │
  │  ✅ Use factories for stateful objects                      │
  │  ✅ Use singletons for stateless services                   │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
