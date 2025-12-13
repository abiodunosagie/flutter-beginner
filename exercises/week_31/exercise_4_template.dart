/// Week 31, Exercise 4: Optimize Image Loading
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Implement efficient image loading:
/// 1. Use cached_network_image package
/// 2. Implement image caching
/// 3. Add placeholders and error widgets
/// 4. Optimize image sizes
///
/// Learning objectives:
/// - Image optimization
/// - Memory management
/// - Caching strategies

import 'package:flutter/material.dart';

void main() {
  runApp(ImageOptimizationApp());
}

class ImageOptimizationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Optimization',
      home: ImageGalleryScreen(),
    );
  }
}

class ImageGalleryScreen extends StatelessWidget {
  // TODO: Implement optimized image loading
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Gallery')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 50,
        itemBuilder: (context, index) {
          // TODO: Use cached_network_image
          return Container(color: Colors.grey);
        },
      ),
    );
  }
}
