/// Week 28, Exercise 2: Image Upload with Progress Indicator
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Enhance the image upload with progress tracking:
/// 1. Show upload progress percentage
/// 2. Use UploadTask to track progress
/// 3. Display progress bar (LinearProgressIndicator)
/// 4. Allow canceling upload
/// 5. Show upload speed/bytes transferred
/// 6. Handle pause/resume (optional)
///
/// Learning objectives:
/// - Track upload progress
/// - Use UploadTask streams
/// - Better UX with progress feedback

import 'package:flutter/material.dart';
// TODO: Add packages: firebase_storage, image_picker
import 'dart:io';

void main() async {
  // TODO: Initialize Firebase
  runApp(ImageUploadApp());
}

class ImageUploadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload with Progress',
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
  // TODO: Add UploadTask? _uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload with Progress')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Image preview

            // TODO: Pick image button

            SizedBox(height: 20),

            // TODO: Upload button

            // TODO: Show progress bar when uploading
            // if (_isUploading)
            //   Column(
            //     children: [
            //       LinearProgressIndicator(value: _uploadProgress),
            //       SizedBox(height: 8),
            //       Text('${(_uploadProgress * 100).toStringAsFixed(1)}%'),
            //     ],
            //   ),

            // TODO: Cancel button while uploading

            // TODO: Show success message and URL
          ],
        ),
      ),
    );
  }

  // TODO: Implement _pickImage()

  // TODO: Implement _uploadWithProgress()
  // - Create storage reference
  // - Start putFile() to get UploadTask
  // - Listen to uploadTask.snapshotEvents
  // - Update progress: bytesTransferred / totalBytes
  // - Get download URL on completion

  // TODO: Implement _cancelUpload()
  // - Call _uploadTask?.cancel()
}
