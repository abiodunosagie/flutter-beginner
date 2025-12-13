// Exercise 4: Product Inventory (SOLUTION)

class Product {
  String name;
  double price;
  int quantity;
  String sku;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.sku,
  });

  double getTotalValue() {
    return price * quantity;
  }

  @override
  String toString() {
    return '$name (SKU: $sku) - \$${price.toStringAsFixed(2)} x $quantity = \$${getTotalValue().toStringAsFixed(2)}';
  }
}

class Inventory {
  List<Product> _products = [];

  void addProduct(Product product) {
    _products.add(product);
    print('✓ Added ${product.name} to inventory');
  }

  bool removeProduct(String sku) {
    int initialLength = _products.length;
    _products.removeWhere((product) => product.sku == sku);
    if (_products.length < initialLength) {
      print('✓ Removed product with SKU: $sku');
      return true;
    }
    print('❌ Product not found: $sku');
    return false;
  }

  double calculateTotalValue() {
    double total = 0;
    for (Product product in _products) {
      total += product.getTotalValue();
    }
    return total;
  }

  Product? searchByName(String name) {
    for (Product product in _products) {
      if (product.name.toLowerCase() == name.toLowerCase()) {
        return product;
      }
    }
    return null;
  }

  Product? searchBySKU(String sku) {
    for (Product product in _products) {
      if (product.sku == sku) {
        return product;
      }
    }
    return null;
  }

  void displayInventory() {
    print('\n=== Inventory List ===');
    if (_products.isEmpty) {
      print('Inventory is empty');
      return;
    }
    for (int i = 0; i < _products.length; i++) {
      print('${i + 1}. ${_products[i]}');
    }
  }
}

void main() {
  print('=== Product Inventory System ===\n');

  Inventory inventory = Inventory();

  // Add products
  inventory.addProduct(Product(name: 'Laptop', price: 999.99, quantity: 10, sku: 'LAP001'));
  inventory.addProduct(Product(name: 'Mouse', price: 29.99, quantity: 50, sku: 'MOU001'));
  inventory.addProduct(Product(name: 'Keyboard', price: 79.99, quantity: 25, sku: 'KEY001'));
  inventory.addProduct(Product(name: 'Monitor', price: 299.99, quantity: 15, sku: 'MON001'));

  // Display inventory
  inventory.displayInventory();

  // Calculate total value
  print('\nTotal Inventory Value: \$${inventory.calculateTotalValue().toStringAsFixed(2)}');

  // Search by name
  print('\n--- Search by Name ---');
  Product? found = inventory.searchByName('Mouse');
  if (found != null) {
    print('Found: $found');
  }

  // Search by SKU
  print('\n--- Search by SKU ---');
  Product? foundBySKU = inventory.searchBySKU('LAP001');
  if (foundBySKU != null) {
    print('Found: $foundBySKU');
  }

  // Remove product
  print('\n--- Remove Product ---');
  inventory.removeProduct('MOU001');

  // Display updated inventory
  inventory.displayInventory();
  print('\nUpdated Total Value: \$${inventory.calculateTotalValue().toStringAsFixed(2)}');
}
