/// Exercise 1: Test a Shopping Cart
///
/// Level: Beginner
///
/// Task:
/// Create a ShoppingCart class with the following functionality:
/// - Add items to cart
/// - Remove items from cart
/// - Calculate total price
/// - Get item count
/// - Clear cart
///
/// Then write comprehensive tests for all functionality.
///
/// Requirements:
/// 1. Create CartItem class with productId, name, price, quantity
/// 2. Create ShoppingCart class with methods:
///    - addItem(CartItem item)
///    - removeItem(String productId)
///    - double getTotal()
///    - int getItemCount()
///    - void clear()
/// 3. Write tests in test/week_22/exercise_1_test.dart covering:
///    - Adding items
///    - Removing items
///    - Calculating total
///    - Handling empty cart
///    - Handling duplicate items (update quantity)

// TODO: Implement CartItem class
class CartItem {
  // TODO: Add properties: productId, name, price, quantity

  // TODO: Add constructor

  // TODO: Add method to calculate item total (price * quantity)
}

// TODO: Implement ShoppingCart class
class ShoppingCart {
  // TODO: Add private list to store items

  // TODO: Implement addItem method
  void addItem(CartItem item) {
    throw UnimplementedError();
  }

  // TODO: Implement removeItem method
  void removeItem(String productId) {
    throw UnimplementedError();
  }

  // TODO: Implement getTotal method
  double getTotal() {
    throw UnimplementedError();
  }

  // TODO: Implement getItemCount method
  int getItemCount() {
    throw UnimplementedError();
  }

  // TODO: Implement clear method
  void clear() {
    throw UnimplementedError();
  }
}

// Example usage (for reference):
void main() {
  final cart = ShoppingCart();

  cart.addItem(CartItem(
    productId: '1',
    name: 'Apple',
    price: 0.99,
    quantity: 3,
  ));

  cart.addItem(CartItem(
    productId: '2',
    name: 'Banana',
    price: 0.59,
    quantity: 6,
  ));

  print('Total: \$${cart.getTotal()}');
  print('Item count: ${cart.getItemCount()}');

  cart.removeItem('1');
  print('Total after removing apples: \$${cart.getTotal()}');
}
