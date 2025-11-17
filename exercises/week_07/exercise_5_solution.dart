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
  final List<Map<String, dynamic>> products = [
    {'name': 'Laptop Pro', 'price': '\$1,299', 'rating': 4.5, 'icon': Icons.laptop},
    {'name': 'Smartphone X', 'price': '\$899', 'rating': 4.8, 'icon': Icons.phone_android},
    {'name': 'Tablet Plus', 'price': '\$599', 'rating': 4.3, 'icon': Icons.tablet},
    {'name': 'Headphones', 'price': '\$199', 'rating': 4.6, 'icon': Icons.headphones},
    {'name': 'Smart Watch', 'price': '\$349', 'rating': 4.4, 'icon': Icons.watch},
    {'name': 'Camera HD', 'price': '\$799', 'rating': 4.7, 'icon': Icons.camera_alt},
    {'name': 'Keyboard RGB', 'price': '\$129', 'rating': 4.2, 'icon': Icons.keyboard},
    {'name': 'Mouse Pro', 'price': '\$79', 'rating': 4.5, 'icon': Icons.mouse},
  ];

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
          // Search bar
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // Category chips
          Container(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryChip('All', true),
                  _buildCategoryChip('Electronics', false),
                  _buildCategoryChip('Clothing', false),
                  _buildCategoryChip('Books', false),
                  _buildCategoryChip('Toys', false),
                ],
              ),
            ),
          ),

          // Product grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(
                  product['name'],
                  product['price'],
                  product['rating'],
                  product['icon'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.deepOrange : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, String price, double rating, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepOrange[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(icon, size: 64, color: Colors.deepOrange),
            ),
          ),

          // Product details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('$rating'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
