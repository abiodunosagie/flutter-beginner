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
  final List<Map<String, dynamic>> products = [
    {'name': 'Laptop', 'price': '\$999', 'icon': Icons.laptop},
    {'name': 'Phone', 'price': '\$699', 'icon': Icons.phone_android},
    {'name': 'Tablet', 'price': '\$499', 'icon': Icons.tablet},
    {'name': 'Watch', 'price': '\$299', 'icon': Icons.watch},
    {'name': 'Headphones', 'price': '\$199', 'icon': Icons.headphones},
    {'name': 'Camera', 'price': '\$799', 'icon': Icons.camera_alt},
    {'name': 'Keyboard', 'price': '\$129', 'icon': Icons.keyboard},
    {'name': 'Mouse', 'price': '\$79', 'icon': Icons.mouse},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Gallery'),
        backgroundColor: Colors.teal,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(
            product['name'],
            product['price'],
            product['icon'],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(String name, String price, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 50, color: Colors.teal),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
