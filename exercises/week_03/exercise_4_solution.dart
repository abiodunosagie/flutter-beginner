// Exercise 4: Inventory System (SOLUTION)

void main() {
  print('=== Inventory Management System ===\n');

  // Create inventory
  Map<String, Map<String, dynamic>> inventory = {
    'Laptop': {'quantity': 15, 'price': 999.99},
    'Mouse': {'quantity': 50, 'price': 25.99},
    'Keyboard': {'quantity': 3, 'price': 79.99},
    'Monitor': {'quantity': 8, 'price': 299.99},
    'Headphones': {'quantity': 2, 'price': 149.99},
  };

  print('✓ Inventory initialized with ${inventory.length} products\n');

  // Add new product
  inventory['Webcam'] = {'quantity': 12, 'price': 89.99};
  print('✓ Added new product: Webcam\n');

  // Update quantity (sale)
  inventory['Mouse']!['quantity'] -= 10;
  print('✓ Sold 10 Mice\n');

  // Calculate total inventory value
  double totalValue = 0;
  inventory.forEach((product, details) {
    double productValue = details['quantity'] * details['price'];
    totalValue += productValue;
  });
  print('Total Inventory Value: \$${totalValue.toStringAsFixed(2)}\n');

  // Low stock alerts
  print('Low Stock Alerts (< 5 items):');
  bool hasLowStock = false;
  inventory.forEach((product, details) {
    if (details['quantity'] < 5) {
      print('⚠️  $product: ${details['quantity']} remaining');
      hasLowStock = true;
    }
  });
  if (!hasLowStock) {
    print('✓ All items well stocked');
  }

  // Display full inventory
  print('\nFull Inventory:');
  inventory.forEach((product, details) {
    double value = details['quantity'] * details['price'];
    print('$product: ${details['quantity']} @ \$${details['price']} = \$${value.toStringAsFixed(2)}');
  });
}
