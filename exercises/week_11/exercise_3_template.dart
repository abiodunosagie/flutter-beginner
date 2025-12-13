// Week 11, Exercise 3: Shopping Cart with Riverpod (Complex State)
// Difficulty: Intermediate
//
// Instructions:
// 1. Create Product and CartItem models
// 2. Create CartState class with items list and computed properties (total, itemCount)
// 3. Create CartNotifier with methods: addProduct, removeProduct, increaseQuantity, decreaseQuantity, clear
// 4. Create a products provider with sample products
// 5. Build two screens: ProductsScreen and CartScreen
// 6. Implement add to cart functionality with quantity management
//
// Learning objectives:
// - Managing complex state with multiple models
// - Computed properties in state
// - Navigation with state
// - Handling quantities and totals
//
// TODO: Import necessary packages

void main() {
  // TODO: Wrap with ProviderScope
  runApp(MyApp());
}

// TODO: Create Product model
class Product {
  // Fields: id, name, price
}

// TODO: Create CartItem model
class CartItem {
  // Fields: product, quantity
  // Include copyWith method
}

// TODO: Create CartState class
class CartState {
  // Field: items (List<CartItem>)
  // Computed properties: total, itemCount
  // Include copyWith method
}

// TODO: Create CartNotifier extending StateNotifier<CartState>
class CartNotifier extends StateNotifier<CartState> {
  // Initialize with empty cart
  // TODO: Implement methods:
  // - addProduct(Product product) - add or increase quantity
  // - removeProduct(String productId)
  // - increaseQuantity(String productId)
  // - decreaseQuantity(String productId)
  // - clear()
}

// TODO: Create providers
// - cartProvider
// - productsProvider (with sample data)

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      home: ProductsScreen(),
    );
  }
}

// TODO: Create ProductsScreen (ConsumerWidget)
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Display products with "Add to Cart" buttons
    // TODO: Show cart icon with item count badge
    // TODO: Navigate to CartScreen when cart icon is tapped

    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Container(),
    );
  }
}

// TODO: Create CartScreen (ConsumerWidget)
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Display cart items with quantity controls
    // TODO: Show total at the bottom
    // TODO: Add clear cart button
    // TODO: Handle empty cart state

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Container(),
    );
  }
}
