/// Week 28, Exercise 1: Simple Image Upload to Firebase Storage
///
/// BEGINNER LEVEL - SOLUTION

import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(ImageUploadApp());
}

class ImageUploadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImage;
  String? _uploadedUrl;
  bool _isUploading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Upload')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(Icons.image, size: 64, color: Colors.grey),
                ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                ),
              ),

              SizedBox(height: 20),

              if (_selectedImage != null && !_isUploading)
                ElevatedButton.icon(
                  onPressed: _uploadImage,
                  icon: Icon(Icons.cloud_upload),
                  label: Text('Upload to Firebase'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: Colors.green,
                  ),
                ),

              if (_isUploading)
                Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Uploading...'),
                  ],
                ),

              if (_error != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
                    ],
                  ),
                ),

              if (_uploadedUrl != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Upload successful!',
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'URL: $_uploadedUrl',
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      setState(() => _error = null);

      // Uncomment when image_picker is added:
      // final picker = ImagePicker();
      // final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      // if (pickedFile != null) {
      //   setState(() => _selectedImage = File(pickedFile.path));
      // }

      // For demo purposes (simulate picking)
      await Future.delayed(Duration(milliseconds: 500));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image picker requires actual device/emulator'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _error = 'Failed to pick image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
      _error = null;
      _uploadedUrl = null;
    });

    try {
      // Uncomment when Firebase Storage is configured:
      // final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // final ref = FirebaseStorage.instance.ref().child('images/$fileName');

      // await ref.putFile(_selectedImage!);
      // final url = await ref.getDownloadURL();

      // For demo purposes
      await Future.delayed(Duration(seconds: 2));
      final demoUrl = 'https://firebasestorage.googleapis.com/demo/${DateTime.now().millisecondsSinceEpoch}.jpg';

      setState(() {
        _uploadedUrl = demoUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _error = 'Upload failed: $e';
        _isUploading = false;
      });
    }
  }
}
