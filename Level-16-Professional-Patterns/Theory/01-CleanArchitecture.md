# Clean Architecture

## The Big Idea In One Sentence

> Clean Architecture splits your app into rings (UI, business logic, data) where the rules only point inward, so your core logic does not depend on Flutter, the database, or any API and is easy to test and change.

## The Simple Explanation

Clean Architecture is like organizing a restaurant. The dining room (UI) doesn't cook food. The kitchen (business logic) doesn't serve customers. The pantry (data) just stores ingredients. Each area has one job!

```
┌─────────────────────────────────────────────────────────────┐
│                  RESTAURANT ANALOGY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DINING ROOM (Presentation Layer)                           │
│  └── Takes orders, serves food, handles customers           │
│  └── In Flutter: Widgets, Screens, Controllers              │
│                                                              │
│  KITCHEN (Domain Layer)                                      │
│  └── Recipes, cooking rules, food preparation               │
│  └── In Flutter: Business logic, Use Cases, Entities        │
│                                                              │
│  PANTRY (Data Layer)                                         │
│  └── Stores ingredients, restocks supplies                  │
│  └── In Flutter: APIs, Databases, Caches                    │
│                                                              │
│  WHY THIS MATTERS:                                           │
│  • Change the dining room decor without touching the kitchen│
│  • Switch ingredient suppliers without changing recipes      │
│  • Test each area independently                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## The Three Layers

### Layer 1: Presentation

```dart
// PRESENTATION LAYER
// What: UI and user interaction
// Contains: Widgets, Screens, Controllers/ViewModels
// Depends on: Domain layer

// Example: Profile Screen
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Uses controller from domain layer
    final controller = context.read<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: controller.when(
        loading: () => CircularProgressIndicator(),
        error: (e) => Text('Error: $e'),
        data: (user) => ProfileContent(user: user),
      ),
    );
  }
}
```

### Layer 2: Domain

```dart
// DOMAIN LAYER
// What: Business logic and rules
// Contains: Entities, Use Cases, Repository interfaces
// Depends on: Nothing! (Pure Dart)

// Entity (business object)
class User {
  final String id;
  final String name;
  final String email;
  final bool isPremium;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isPremium,
  });

  // Business logic lives here
  bool get canAccessPremiumFeatures => isPremium;
}

// Repository interface (contract)
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> updateUser(User user);
}

// Use Case (single business action)
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> execute(String userId) {
    return repository.getUser(userId);
  }
}
```

### Layer 3: Data

```dart
// DATA LAYER
// What: Data access and storage
// Contains: Repository implementations, Models, Data sources
// Depends on: Domain layer (implements interfaces)

// Model (API representation)
class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isPremium;

  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      email = json['email'],
      isPremium = json['is_premium'] ?? false;

  // Convert to domain entity
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    isPremium: isPremium,
  );
}

// Repository implementation
class UserRepositoryImpl implements UserRepository {
  final ApiClient api;
  final LocalDatabase db;

  UserRepositoryImpl({required this.api, required this.db});

  @override
  Future<User> getUser(String id) async {
    try {
      // Try API first
      final response = await api.get('/users/$id');
      final model = UserModel.fromJson(response);
      return model.toEntity();
    } catch (e) {
      // Fallback to local database
      final cached = await db.getUser(id);
      return cached.toEntity();
    }
  }
}
```

---

## The Dependency Rule

```
THE GOLDEN RULE:

Dependencies point INWARD only!

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│        Outer layers depend on inner layers                  │
│        Inner layers know NOTHING about outer layers         │
│                                                              │
│                    ┌───────────────┐                        │
│                    │    Domain     │  ← Knows nothing       │
│                    │   (center)    │                        │
│                    └───────────────┘                        │
│                          ▲                                   │
│                          │                                   │
│              ┌───────────────────────┐                      │
│              │         Data          │  ← Knows Domain      │
│              │                       │                      │
│              └───────────────────────┘                      │
│                          ▲                                   │
│                          │                                   │
│          ┌───────────────────────────────┐                  │
│          │        Presentation           │  ← Knows Domain  │
│          │                               │     (not Data!)  │
│          └───────────────────────────────┘                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘

WHY?
• Domain layer can be reused (mobile, web, server)
• Changes in UI don't affect business logic
• Changes in API don't affect UI
• Easy to swap implementations
```

---

## Folder Structure

```
lib/
├── core/                         # Shared across features
│   ├── error/
│   │   ├── exceptions.dart      # Technical errors
│   │   └── failures.dart        # User-facing errors
│   ├── network/
│   │   └── api_client.dart
│   └── utils/
│       └── extensions.dart
│
├── features/                     # Feature-based organization
│   │
│   ├── auth/                     # Auth feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login.dart
│   │   │       ├── logout.dart
│   │   │       └── register.dart
│   │   │
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           └── auth_form.dart
│   │
│   └── home/                     # Home feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── injection_container.dart      # Dependency injection
└── main.dart
```

---

## Entities vs Models

```
┌─────────────────────────────────────────────────────────────┐
│              ENTITY vs MODEL                                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ENTITY (Domain Layer)                                       │
│  ├── Pure business object                                   │
│  ├── Contains business logic                                │
│  ├── No serialization (no fromJson/toJson)                  │
│  └── Independent of data source                             │
│                                                              │
│  MODEL (Data Layer)                                          │
│  ├── Data transfer object                                   │
│  ├── Contains serialization                                 │
│  ├── Maps to/from Entity                                    │
│  └── Specific to data source (API, DB)                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

```dart
// ENTITY - Domain Layer
class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Business logic
  double get totalValue => price * quantity;
  bool get isInStock => quantity > 0;
  bool get isLowStock => quantity > 0 && quantity < 5;
}

// MODEL - Data Layer
class ProductModel {
  final String id;
  final String name;
  final double price;
  final int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Serialization
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'],  // API uses different name
      name: json['product_name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['stock_qty'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': id,
    'product_name': name,
    'price': price,
    'stock_qty': quantity,
  };

  // Convert to Entity
  Product toEntity() => Product(
    id: id,
    name: name,
    price: price,
    quantity: quantity,
  );

  // Create from Entity
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
    );
  }
}
```

---

## Use Cases

```dart
// USE CASE PATTERN
// One class = One business action
// Makes testing easy
// Documents what your app can do

// Base class (optional but helpful)
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// No parameters needed
class NoParams {}

// Example: Get All Products
class GetAllProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) {
    return repository.getAllProducts();
  }
}

// Example: Get Product by ID
class GetProductUseCase implements UseCase<Product, String> {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  @override
  Future<Product> call(String productId) {
    return repository.getProduct(productId);
  }
}

// Example: Add to Cart (complex params)
class AddToCartParams {
  final String productId;
  final int quantity;

  AddToCartParams({required this.productId, required this.quantity});
}

class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  final CartRepository cartRepository;
  final ProductRepository productRepository;

  AddToCartUseCase(this.cartRepository, this.productRepository);

  @override
  Future<Cart> call(AddToCartParams params) async {
    // Business logic here
    final product = await productRepository.getProduct(params.productId);

    if (!product.isInStock) {
      throw OutOfStockException(product.name);
    }

    return cartRepository.addItem(params.productId, params.quantity);
  }
}
```

---

## Repository Pattern

```dart
// DOMAIN: Repository Interface (Contract)
// Lives in domain layer
// Defines WHAT can be done, not HOW

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(String id);
  Future<void> saveProduct(Product product);
  Future<void> deleteProduct(String id);
}

// DATA: Repository Implementation
// Lives in data layer
// Defines HOW things are done

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
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        // Get from API
        final models = await remoteDataSource.getAllProducts();
        // Cache locally
        await localDataSource.cacheProducts(models);
        // Convert to entities
        return models.map((m) => m.toEntity()).toList();
      } catch (e) {
        // API failed, try cache
        return _getFromCache();
      }
    } else {
      // Offline, use cache
      return _getFromCache();
    }
  }

  Future<List<Product>> _getFromCache() async {
    final cached = await localDataSource.getCachedProducts();
    return cached.map((m) => m.toEntity()).toList();
  }

  // ... other methods
}
```

---

## Benefits Summary

```
┌─────────────────────────────────────────────────────────────┐
│           CLEAN ARCHITECTURE BENEFITS                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TESTABILITY:                                                │
│  ├── Test each layer independently                          │
│  ├── Mock dependencies easily                               │
│  └── Domain logic tested without UI or API                  │
│                                                              │
│  MAINTAINABILITY:                                            │
│  ├── Clear where to find things                             │
│  ├── Changes isolated to one layer                          │
│  └── New team members understand quickly                    │
│                                                              │
│  FLEXIBILITY:                                                │
│  ├── Swap API without changing UI                           │
│  ├── Change database without changing logic                 │
│  └── Reuse domain layer across platforms                    │
│                                                              │
│  SCALABILITY:                                                │
│  ├── Add features without breaking existing code            │
│  ├── Multiple teams can work on different layers            │
│  └── App grows without becoming a mess                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## When to Use Clean Architecture

```
USE CLEAN ARCHITECTURE WHEN:
✅ App will be maintained long-term
✅ Multiple developers on the project
✅ Complex business logic
✅ Need to support multiple platforms
✅ High test coverage required

MAYBE SKIP WHEN:
⚠️ Simple prototype or MVP
⚠️ Solo developer, small app
⚠️ Very short timeline
⚠️ Learning Flutter basics

COMPROMISE:
You don't have to do it all at once!
Start with separation of concerns,
add layers as complexity grows.
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│             CLEAN ARCHITECTURE SUMMARY                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  THREE LAYERS:                                               │
│  ├── Presentation: UI, Widgets, Controllers                 │
│  ├── Domain: Entities, Use Cases, Repo interfaces          │
│  └── Data: Models, API, Database, Repo implementations      │
│                                                              │
│  KEY RULES:                                                  │
│  ├── Dependencies point inward                              │
│  ├── Domain knows nothing about other layers                │
│  ├── Data implements Domain interfaces                      │
│  └── Presentation uses Domain, not Data                     │
│                                                              │
│  KEY PATTERNS:                                               │
│  ├── Entity vs Model                                        │
│  ├── Use Case (one action per class)                        │
│  ├── Repository (interface + implementation)                │
│  └── Dependency Injection (wire it all together)            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** In Clean Architecture, which way do dependencies point?

<details>
<summary>Answer</summary>
Inward: outer layers (UI, data) depend on the inner core (business logic), never the other way around.
</details>

**Q2.** Why should core business logic not import Flutter or your database package?

<details>
<summary>Answer</summary>
So the rules stay independent and testable, and you can swap the UI or data source without rewriting the logic.
</details>

**Q3.** What is the main payoff of this extra structure?

<details>
<summary>Answer</summary>
Easier testing and change: each layer is isolated, so you can replace or test one without breaking the others.
</details>

---

## Assignment

### Problem 1: Which layer?

Sort into UI, business logic, or data: a widget, a "calculate discount" rule, an API client.

### Problem 2: Dependency direction

Can the business logic layer import the UI layer? Why or why not?

### Problem 3: When worth it?

Is Clean Architecture worth it for a tiny weekend app? Briefly say why or why not.

---

## Assignment Answers

### Problem 1: Which layer?

Widget → UI; "calculate discount" rule → business logic; API client → data.

### Problem 2: Dependency direction

No. Dependencies point inward, so the inner business logic must not depend on the outer UI. The UI depends on the logic, not the reverse.

### Problem 3: When worth it?

For a tiny app it is usually overkill, the extra layers add boilerplate. It pays off in larger, long-lived apps with a team, where testability and change matter.

---

**Next:** `02-StateManagement.md` - Professional state management patterns
