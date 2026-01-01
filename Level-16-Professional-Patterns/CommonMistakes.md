# Level 16: Common Mistakes

Learn from these common architecture errors!

---

## Mistake #1: Domain Layer Depends on Data Layer

```dart
// ❌ WRONG - Domain imports from data
// lib/domain/usecases/get_products.dart
import '../data/models/product_model.dart';  // Wrong!

class GetProducts {
  final ProductModel product;  // Domain shouldn't know about models!
}

// ✅ RIGHT - Domain only uses entities
// lib/domain/usecases/get_products.dart
import '../entities/product.dart';

class GetProducts {
  final Product product;  // Uses domain entity
}
```

---

## Mistake #2: Business Logic in UI

```dart
// ❌ WRONG - Logic in widget
class CartScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    // Business logic in UI!
    final subtotal = cart.items.fold(0.0, (sum, item) =>
        sum + item.price * item.quantity);
    final tax = subtotal * 0.1;
    final shipping = subtotal > 50 ? 0 : 5.99;
    final total = subtotal + tax + shipping;

    return Text('Total: $total');
  }
}

// ✅ RIGHT - Logic in domain/use case
class CalculateCartTotal {
  double call(List<CartItem> items) {
    final subtotal = items.fold(0.0, (sum, item) =>
        sum + item.price * item.quantity);
    final tax = subtotal * 0.1;
    final shipping = subtotal > 50 ? 0 : 5.99;
    return subtotal + tax + shipping;
  }
}
```

---

## Mistake #3: Not Using Repository Interface

```dart
// ❌ WRONG - Use case depends on concrete implementation
class GetProducts {
  final ProductApiService api;  // Concrete class!

  GetProducts(this.api);
}

// ✅ RIGHT - Depend on abstraction
// In domain layer:
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

class GetProducts {
  final ProductRepository repository;  // Interface!

  GetProducts(this.repository);
}

// In data layer:
class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService api;

  Future<List<Product>> getProducts() => api.getProducts();
}
```

---

## Mistake #4: Entity With Framework Dependencies

```dart
// ❌ WRONG - Entity depends on Flutter
import 'package:flutter/material.dart';

class Product {
  final String name;
  final Color themeColor;  // Flutter dependency!
}

// ✅ RIGHT - Pure Dart entity
class Product {
  final String name;
  final int colorValue;  // Store as int, convert in UI
}

// In UI:
Color get themeColor => Color(product.colorValue);
```

---

## Mistake #5: get_it Not Initialized

```dart
// ❌ WRONG - Using before init
void main() {
  runApp(MyApp());  // get_it not initialized!
}

class HomeScreen extends StatelessWidget {
  final api = sl<ApiService>();  // Error: not registered!
}

// ✅ RIGHT - Initialize before runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();  // Set up get_it
  runApp(MyApp());
}
```

---

## Mistake #6: Wrong Registration Type

```dart
// ❌ WRONG - Factory for shared state
sl.registerFactory(() => CartProvider());
// Each widget gets NEW CartProvider - state not shared!

// ✅ RIGHT - Singleton for shared state
sl.registerLazySingleton(() => CartProvider());

// Factory is for things you want fresh each time (like BLoCs)
sl.registerFactory(() => ProductDetailBloc(sl()));
```

---

## Mistake #7: Ignoring Either Failures

```dart
// ❌ WRONG - Not handling left case
final result = await getProducts();
final products = result.right;  // Crashes if Left!

// ✅ RIGHT - Handle both cases
final result = await getProducts();

result.fold(
  (failure) => emit(ProductsError(failure.message)),
  (products) => emit(ProductsLoaded(products)),
);
```

---

## Mistake #8: Fat Use Cases

```dart
// ❌ WRONG - Use case does too much
class ProcessOrder {
  Future<Order> call(OrderParams params) async {
    // Validates cart
    // Processes payment
    // Creates order
    // Sends email
    // Updates inventory
    // Clears cart
    // 500 lines of code...
  }
}

// ✅ RIGHT - Single responsibility
class ValidateCart { ... }
class ProcessPayment { ... }
class CreateOrder { ... }
class SendOrderEmail { ... }
class UpdateInventory { ... }
class ClearCart { ... }

// Orchestrate in BLoC or Controller
```

---

## Mistake #9: Testing Concrete Instead of Abstract

```dart
// ❌ WRONG - Hard to test
class ProductsBloc {
  final ApiService api;  // Concrete - hard to mock

  ProductsBloc() : api = ApiService();  // Created internally!
}

// ✅ RIGHT - Injectable dependencies
class ProductsBloc {
  final ProductRepository repository;  // Abstract

  ProductsBloc({required this.repository});  // Injected
}

// In tests:
final bloc = ProductsBloc(repository: MockProductRepository());
```

---

## Mistake #10: Circular Dependencies

```dart
// ❌ WRONG - A depends on B, B depends on A
class CartProvider {
  final UserProvider userProvider;  // Needs UserProvider
}

class UserProvider {
  final CartProvider cartProvider;  // Needs CartProvider!
}

// ✅ RIGHT - Break the cycle
// Option 1: Use events/callbacks
// Option 2: Create mediator
// Option 3: Restructure dependencies

class CartProvider {
  final String Function() getCurrentUserId;  // Function, not provider
}
```

---

## Architecture Layers Summary

| Layer | Contains | Depends On |
|-------|----------|------------|
| Presentation | UI, BLoC, ViewModel | Domain |
| Domain | Entities, Use Cases, Repo interfaces | Nothing |
| Data | Repos, DataSources, Models | Domain |

---

**Still stuck? Re-read the Theory files or ask for help!**
