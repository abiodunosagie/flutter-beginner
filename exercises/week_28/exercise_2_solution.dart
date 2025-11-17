/// Week 28, Exercise 2: Image Upload with Progress Indicator
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

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
      title: 'Upload with Progress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
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
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _uploadedUrl;
  String? _error;
  // UploadTask? _uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload with Progress')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                )
              else
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No image selected', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),

              SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Pick Image from Gallery'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),

              SizedBox(height: 16),

              if (_selectedImage != null && !_isUploading)
                ElevatedButton.icon(
                  onPressed: _uploadWithProgress,
                  icon: Icon(Icons.cloud_upload),
                  label: Text('Upload to Firebase Storage'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                  ),
                ),

              if (_isUploading) ...[
                SizedBox(height: 24),
                LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                ),
                SizedBox(height: 12),
                Text(
                  '${(_uploadProgress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Uploading...'),
                SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _cancelUpload,
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel Upload'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],

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
                        child: Text(_error!, style: TextStyle(color: Colors.red.shade900)),
                      ),
                    ],
                  ),
                ),

              if (_uploadedUrl != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, size: 48, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        'Upload Complete!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _uploadedUrl!,
                        style: TextStyle(fontSize: 11),
                        maxLines: 3,
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
      setState(() {
        _error = null;
        _uploadedUrl = null;
      });

      // final picker = ImagePicker();
      // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      // if (pickedFile != null) {
      //   setState(() => _selectedImage = File(pickedFile.path));
      // }

      // Demo simulation
      await Future.delayed(Duration(milliseconds: 300));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image picker requires actual device')),
      );
    } catch (e) {
      setState(() => _error = 'Failed to pick image: $e');
    }
  }

  Future<void> _uploadWithProgress() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _error = null;
      _uploadedUrl = null;
    });

    try {
      // Real Firebase Storage implementation:
      // final fileName = 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      // _uploadTask = ref.putFile(_selectedImage!);

      // await for (final snapshot in _uploadTask!.snapshotEvents) {
      //   final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      //   setState(() => _uploadProgress = progress);
      // }

      // final url = await ref.getDownloadURL();

      // Demo simulation with progress
      for (int i = 0; i <= 100; i += 5) {
        await Future.delayed(Duration(milliseconds: 100));
        if (!_isUploading) break; // Check if cancelled
        setState(() => _uploadProgress = i / 100);
      }

      if (_isUploading) {
        final demoUrl = 'https://firebasestorage.googleapis.com/demo/${DateTime.now().millisecondsSinceEpoch}.jpg';
        setState(() {
          _uploadedUrl = demoUrl;
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Upload failed: $e';
        _isUploading = false;
      });
    }
  }

  void _cancelUpload() {
    // _uploadTask?.cancel();
    setState(() {
      _isUploading = false;
      _uploadProgress = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload cancelled')),
    );
  }
}
