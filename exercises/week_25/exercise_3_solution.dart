/// Exercise 3 Solution: Hero Animations - Image Gallery

import 'package:flutter/material.dart';

class ImageGallery extends StatelessWidget {
  final List<String> images = List.generate(12, (i) => 'Image ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageId = 'image_$index';
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ImageDetail(imageId: imageId, imageName: images[index]))),
          child: Hero(
            tag: imageId,
            child: Container(
              decoration: BoxDecoration(color: Colors.primaries[index % Colors.primaries.length], borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(images[index], style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
            ),
          ),
        );
      },
    );
  }
}

class ImageDetail extends StatelessWidget {
  final String imageId;
  final String imageName;

  const ImageDetail({required this.imageId, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(imageName), backgroundColor: Colors.black),
      body: Center(
        child: Hero(
          tag: imageId,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text(imageName, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: Scaffold(appBar: AppBar(title: Text('Hero Gallery')), body: ImageGallery())));
