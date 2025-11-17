/// Week 29, Exercise 2: Camera + Gallery with Permissions
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(PermissionsApp());
}

class PermissionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permissions Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CameraPermissionsScreen(),
    );
  }
}

class CameraPermissionsScreen extends StatefulWidget {
  @override
  _CameraPermissionsScreenState createState() => _CameraPermissionsScreenState();
}

class _CameraPermissionsScreenState extends State<CameraPermissionsScreen> {
  File? _image;
  String _permissionStatus = 'Not checked';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera & Permissions')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null)
                Container(
                  height: 250,
                  width: 250,
                  child: Image.file(_image!, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 250,
                  width: 250,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              SizedBox(height: 20),
              Text('Permission Status: $_permissionStatus'),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _checkAndPickImage,
                icon: Icon(Icons.camera),
                label: Text('Take Photo'),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _checkAndPickGallery,
                icon: Icon(Icons.photo_library),
                label: Text('Pick from Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkAndPickImage() async {
    // Check permissions (use permission_handler package in real app)
    setState(() => _permissionStatus = 'Camera permission granted (demo)');
    // Then pick image
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Use permission_handler package on device')),
    );
  }

  Future<void> _checkAndPickGallery() async {
    setState(() => _permissionStatus = 'Storage permission granted (demo)');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Use permission_handler package on device')),
    );
  }
}
