/// Week 28, Exercise 1: Simple Image Upload to Firebase Storage
///
/// BEGINNER LEVEL
///
/// Create an app that uploads images to Firebase Storage:
/// 1. Add firebase_storage and image_picker packages
/// 2. Pick image from gallery
/// 3. Upload image to Firebase Storage
/// 4. Get download URL
/// 5. Display uploaded image
/// 6. Handle loading and error states
///
/// Learning objectives:
/// - Use Firebase Storage
/// - Pick images from device
/// - Upload files
/// - Get download URLs

import 'package:flutter/material.dart';
// TODO: Add packages to pubspec.yaml:
// firebase_storage, image_picker
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

void main() async {
  // TODO: Initialize Firebase
  runApp(ImageUploadApp());
}

class ImageUploadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload',
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // TODO: Add state variables
  // File? _selectedImage;
  // String? _uploadedUrl;
  // bool _isUploading = false;
  // String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Upload')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Show selected image if exists
              // if (_selectedImage != null)
              //   Image.file(_selectedImage!, height: 200),

              SizedBox(height: 20),

              // TODO: Pick Image button
              ElevatedButton(
                onPressed: null, // TODO: _pickImage
                child: Text('Pick Image'),
              ),

              SizedBox(height: 20),

              // TODO: Upload button (only if image selected)

              // TODO: Show loading indicator while uploading

              // TODO: Show error if exists

              // TODO: Show uploaded image URL if exists
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Implement _pickImage() method
  // - Create ImagePicker instance
  // - Pick image from gallery
  // - Update state with selected image

  // TODO: Implement _uploadImage() method
  // - Get reference to Firebase Storage
  // - Create unique file name (use timestamp)
  // - Upload file with putFile()
  // - Get download URL
  // - Update state with URL
  // - Handle errors
}
