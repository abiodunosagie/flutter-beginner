// Exercise 3: Product List with Cards (Intermediate)
// Create a list of product cards with images, names, and prices

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Our Products'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // TODO: Create 3 product cards using the _buildProductCard method
              // Product 1: Laptop, $999, Icons.laptop
              // Product 2: Phone, $699, Icons.phone_android
              // Product 3: Tablet, $499, Icons.tablet
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Create _buildProductCard method that returns a Card widget
  // Parameters: String name, String price, IconData icon
  // Card should have:
  // - elevation: 4
  // - margin: EdgeInsets.only(bottom: 16)
  // - Padding with all(16)
  // - Row containing icon and product details
}
