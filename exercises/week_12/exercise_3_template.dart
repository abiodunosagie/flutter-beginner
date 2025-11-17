// Week 12, Exercise 3: Shopping Cart Persistence with Hive
// Difficulty: Intermediate
//
// Instructions:
// 1. Add hive and hive_flutter dependencies
// 2. Create Product model with HiveType annotation
// 3. Create CartItem model with HiveType annotation
// 4. Generate adapters using build_runner
// 5. Initialize Hive and register adapters in main()
// 6. Create CartNotifier that reads/writes to Hive box
// 7. Build UI with products and persistent cart
//
// Learning objectives:
// - Setting up Hive
// - Creating Hive type adapters
// - Persisting complex objects
// - Automatic persistence on changes
//
// TODO: Import necessary packages
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// NOTE: After creating models with @HiveType annotations,
// run: flutter pub run build_runner build

void main() async {
  // TODO: Initialize Hive
  // TODO: Register adapters
  // TODO: Open cart box
  // TODO: Run app with ProviderScope
}

// TODO: Create Product model with @HiveType(typeId: 0)
// part 'exercise_3_solution.g.dart';  // Generated file

// TODO: Create CartItem model with @HiveType(typeId: 1)

// TODO: Create CartNotifier that uses Hive box
class CartNotifier extends StateNotifier<List<CartItem>> {
  // Take Box<CartItem> in constructor
  // Initialize state from box.values.toList()

  // TODO: Implement methods that save to box:
  // - addProduct(Product product)
  // - removeProduct(String productId)
  // - increaseQuantity(String productId)
  // - decreaseQuantity(String productId)
  // - clear()

  // TODO: Add total getter
}

// TODO: Create providers
// - cartProvider
// - productsProvider

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Persistence',
      home: ProductsScreen(),
    );
  }
}

// TODO: Create ProductsScreen and CartScreen
// Similar to Week 11 Exercise 3, but with Hive persistence
