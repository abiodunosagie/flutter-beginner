// Exercise 5: E-Commerce Product Grid (Advanced)
// Create a product grid with categories, search bar, and product cards

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Shop',
      home: ProductGridScreen(),
    );
  }
}

class ProductGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Shop'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // TODO: Create search bar
          // - Container with padding
          // - TextField with decoration (hint: "Search products...")
          // - prefixIcon: Icons.search

          // TODO: Create horizontal category chips
          // - SingleChildScrollView with horizontal scroll
          // - Row of chips: All, Electronics, Clothing, Books, Toys
          // - Use Chip widget with label

          // TODO: Create product grid
          // - Expanded widget
          // - GridView.builder with 2 columns
          // - Create 8 products using _buildProductCard
          // - Each product should have: image, name, price, rating
        ],
      ),
    );
  }

  // TODO: Create _buildProductCard method
  // Parameters: String name, String price, double rating, IconData icon
  // Returns Card with:
  // - Product icon/image
  // - Product name
  // - Price
  // - Star rating
  // - Add to cart button
}
