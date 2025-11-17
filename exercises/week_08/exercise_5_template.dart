// Exercise 5: Shopping Cart with State Management (Advanced)
// Create a shopping cart where users can add items, adjust quantities, and see total

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      home: ShoppingCartScreen(),
    );
  }
}

// Product model
class Product {
  final String name;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  // TODO: Create List<Product> _cart with initial empty list

  // TODO: Create available products list (3-4 products)
  // Example: Laptop $999, Mouse $29, Keyboard $79

  // TODO: Create method _addToCart(Product product) that adds product to cart

  // TODO: Create method _increaseQuantity(int index) that increases quantity

  // TODO: Create method _decreaseQuantity(int index) that decreases quantity
  // If quantity becomes 0, remove the item

  // TODO: Create method _removeFromCart(int index) that removes item

  // TODO: Create method _calculateTotal() that returns total price (double)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          // TODO: Create section showing available products
          // Use horizontal ListView with product cards
          // Each card should have Add button to add to cart

          Divider(thickness: 2),

          // TODO: Add "Cart Items" header text

          // TODO: Create Expanded ListView showing cart items
          // Each item should show:
          // - Product name and price
          // - Quantity controls (-, quantity, +)
          // - Remove button

          // TODO: Create bottom section showing total
          // Container with padding showing "Total: $XX.XX"
        ],
      ),
    );
  }
}
