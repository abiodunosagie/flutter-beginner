/// Week 29, Exercise 1: Simple Photo Picker
///
/// BEGINNER LEVEL
///
/// Create an app that picks and displays photos:
/// 1. Add image_picker package
/// 2. Pick image from gallery
/// 3. Display selected image
/// 4. Show placeholder when no image selected
/// 5. Allow picking multiple times
///
/// Learning objectives:
/// - Use image_picker package
/// - Display images from file
/// - Handle null safety

import 'package:flutter/material.dart';
import 'dart:io';
// TODO: Add image_picker package to pubspec.yaml
// import 'package:image_picker/image_picker.dart';

void main() {
  runApp(PhotoPickerApp());
}

class PhotoPickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Picker',
      home: PhotoScreen(),
    );
  }
}

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  // TODO: Add File? _selectedImage state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Show selected image or placeholder

            SizedBox(height: 24),

            // TODO: Button to pick from gallery

            // TODO: Optional: Button to take photo with camera
          ],
        ),
      ),
    );
  }

  // TODO: Implement _pickImage() method
  // - Create ImagePicker instance
  // - Call pickImage with ImageSource.gallery
  // - Update state with selected image file
}
