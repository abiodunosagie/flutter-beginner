/// Exercise 3: Hero Animations - Image Gallery
/// Create image gallery with hero transitions between screens

import 'package:flutter/material.dart';

// TODO: Create gallery grid with Hero widgets
// TODO: Implement detail screen with hero animation
// TODO: Add smooth transitions

class ImageGallery extends StatelessWidget {
  final List<String> images = List.generate(12, (i) => 'Image ${i + 1}');

  @override
  Widget build(BuildContext context) {
    // TODO: Build grid with Hero widgets
    return Container();
  }
}

class ImageDetail extends StatelessWidget {
  final String imageId;
  const ImageDetail({required this.imageId});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement detail view with Hero
    return Container();
  }
}

void main() => runApp(MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Gallery')), body: ImageGallery())));
