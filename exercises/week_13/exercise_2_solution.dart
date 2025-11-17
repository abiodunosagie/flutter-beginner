// Week 13, Exercise 2: Parse Array and Filter Data
// Difficulty: Beginner-Intermediate
// Solution

import 'dart:convert';

void main() {
  String jsonString = '''
  [
    {"id": 1, "name": "Laptop", "price": 899.99, "inStock": true},
    {"id": 2, "name": "Mouse", "price": 29.99, "inStock": true},
    {"id": 3, "name": "Keyboard", "price": 79.99, "inStock": false},
    {"id": 4, "name": "Monitor", "price": 249.99, "inStock": true},
    {"id": 5, "name": "USB Cable", "price": 9.99, "inStock": true}
  ]
  ''';

  // Parse the JSON array
  List<dynamic> products = jsonDecode(jsonString);

  // Count total products
  print('Total products: ${products.length}');
  print('');

  // Filter products over $100
  print('Products over \$100:');
  for (var product in products) {
    if (product['price'] > 100) {
      print('- ${product['name']}: \$${product['price']}');
    }
  }
  print('');

  // Calculate total value
  double totalValue = 0;
  for (var product in products) {
    totalValue += product['price'];
  }
  print('Total inventory value: \$${totalValue.toStringAsFixed(2)}');
}
