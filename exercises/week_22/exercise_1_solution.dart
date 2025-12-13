/// Exercise 1 Solution: Test a Shopping Cart
///
/// This solution demonstrates:
/// - Proper class design with immutability where appropriate
/// - Handling duplicate items by updating quantity
/// - Defensive programming (checking for empty states)
/// - Clear, testable methods

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  }) {
    if (price < 0) {
      throw ArgumentError('Price cannot be negative');
    }
    if (quantity < 1) {
      throw ArgumentError('Quantity must be at least 1');
    }
  }

  double get itemTotal => price * quantity;

  // Create a copy with updated quantity
  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.productId == productId &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}

class ShoppingCart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere(
      (i) => i.productId == item.productId,
    );

    if (existingIndex != -1) {
      // Item exists, update quantity
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
    } else {
      // New item
      _items.add(item);
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  double getTotal() {
    return _items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  int getItemCount() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void clear() {
    _items.clear();
  }

  bool containsProduct(String productId) {
    return _items.any((item) => item.productId == productId);
  }
}

// Example usage:
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

  print('Total: \$${cart.getTotal().toStringAsFixed(2)}'); // $6.51
  print('Item count: ${cart.getItemCount()}'); // 9

  // Add more apples (quantity should update)
  cart.addItem(CartItem(
    productId: '1',
    name: 'Apple',
    price: 0.99,
    quantity: 2,
  ));

  print('Total after adding more apples: \$${cart.getTotal().toStringAsFixed(2)}'); // $8.49
  print('Item count: ${cart.getItemCount()}'); // 11

  cart.removeItem('1');
  print('Total after removing apples: \$${cart.getTotal().toStringAsFixed(2)}'); // $3.54

  cart.clear();
  print('Total after clear: \$${cart.getTotal().toStringAsFixed(2)}'); // $0.00
}
