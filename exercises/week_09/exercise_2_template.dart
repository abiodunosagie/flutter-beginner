// Exercise 2: GridView Product Gallery (Beginner-Intermediate)
// Create a responsive product gallery using GridView

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Gallery',
      home: ProductGallery(),
    );
  }
}

class ProductGallery extends StatelessWidget {
  // TODO: Create a list of products (at least 8)
  // Each product should have: name, price, icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Gallery'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // TODO: Set crossAxisCount to 2
          // TODO: Set crossAxisSpacing to 16
          // TODO: Set mainAxisSpacing to 16
          // TODO: Set childAspectRatio to 0.8
        ),
        // TODO: Set itemCount to products length
        itemBuilder: (context, index) {
          // TODO: Return _buildProductCard for each product
        },
      ),
    );
  }

  // TODO: Create _buildProductCard method that takes product data
  // and returns a Card with:
  // - Product icon
  // - Product name
  // - Product price
}
