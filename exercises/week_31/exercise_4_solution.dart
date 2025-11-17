/// Week 31, Exercise 4: Optimize Image Loading
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const ImageOptimizationApp());
}

class ImageOptimizationApp extends StatelessWidget {
  const ImageOptimizationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Optimization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ImageGalleryScreen(),
    );
  }
}

class ImageGalleryScreen extends StatelessWidget {
  const ImageGalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Optimized Image Gallery')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 50,
        itemBuilder: (context, index) {
          return const OptimizedImage();
        },
      ),
    );
  }
}

class OptimizedImage extends StatelessWidget {
  const OptimizedImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In real app: use cached_network_image package
    // CachedNetworkImage(
    //   imageUrl: 'https://picsum.photos/200',
    //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
    //   errorWidget: (context, url, error) => Icon(Icons.error),
    //   memCacheWidth: 200, // Limit cache size
    //   memCacheHeight: 200,
    // )

    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 40, color: Colors.grey),
            SizedBox(height: 4),
            Text('Optimized', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

/*
Image Optimization Tips:

1. Use CachedNetworkImage:
   - Automatic caching
   - Memory management
   - Placeholders

2. Limit Cache Size:
   - memCacheWidth
   - memCacheHeight

3. Compress Images:
   - Use appropriate formats
   - Serve correct sizes

4. Lazy Loading:
   - Only load visible images
   - Use ListView.builder
*/
