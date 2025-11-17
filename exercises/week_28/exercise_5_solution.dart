/// Week 28, Exercise 5: Complete Firebase App (Storage + Functions + FCM)
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';
import 'dart:io';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(ComprehensiveApp());
}

class ComprehensiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Firebase App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: ProfileScreen(),
    );
  }
}

class Upload {
  final String id;
  final String url;
  final String thumbnailUrl;
  final DateTime uploadedAt;

  Upload({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.uploadedAt,
  });
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  List<Upload> _uploads = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUploads();
  }

  Future<void> _loadUploads() async {
    // Load from Firestore
    // final snapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(currentUserId)
    //     .collection('uploads')
    //     .orderBy('uploadedAt', descending: true)
    //     .get();

    // Demo data
    setState(() {
      _uploads = [
        Upload(
          id: '1',
          url: 'https://via.placeholder.com/300',
          thumbnailUrl: 'https://via.placeholder.com/100',
          uploadedAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Show notification settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.deepOrange.shade50,
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null,
                        child: _selectedImage == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickAndUploadImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isUploading) ...[
                    SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          LinearProgressIndicator(value: _uploadProgress),
                          SizedBox(height: 8),
                          Text('Uploading ${(_uploadProgress * 100).toInt()}%'),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('john@example.com'),
                ],
              ),
            ),

            if (_error != null)
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(child: Text(_error!)),
                  ],
                ),
              ),

            // Uploads Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.photo_library),
                      SizedBox(width: 8),
                      Text(
                        'My Uploads',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text('${_uploads.length}', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 16),
                  _uploads.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.cloud_upload, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No uploads yet'),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _uploads.length,
                          itemBuilder: (context, index) {
                            final upload = _uploads[index];
                            return GestureDetector(
                              onTap: () => _showImageDialog(upload),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: Icon(Icons.image, size: 48, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    // Pick image
    // final picker = ImagePicker();
    // final image = await picker.pickImage(source: ImageSource.gallery);
    // if (image == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _error = null;
    });

    try {
      // 1. Upload to Storage with progress
      // final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // final ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
      // final uploadTask = ref.putFile(File(image.path));

      // await for (final snapshot in uploadTask.snapshotEvents) {
      //   final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      //   setState(() => _uploadProgress = progress);
      // }

      // Simulate upload
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(Duration(milliseconds: 200));
        setState(() => _uploadProgress = i / 100);
      }

      // 2. Get download URL
      // final url = await ref.getDownloadURL();

      // 3. Call Cloud Function to generate thumbnail
      // final functions = FirebaseFunctions.instance;
      // final result = await functions.httpsCallable('generateThumbnail').call({
      //   'imageUrl': url,
      // });
      // final thumbnailUrl = result.data['thumbnailUrl'];

      // 4. Save to Firestore
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(currentUserId)
      //     .collection('uploads')
      //     .add({
      //   'url': url,
      //   'thumbnailUrl': thumbnailUrl,
      //   'uploadedAt': FieldValue.serverTimestamp(),
      // });

      // 5. Send FCM notification
      // await functions.httpsCallable('sendUploadNotification').call({
      //   'userId': currentUserId,
      // });

      setState(() => _isUploading = false);
      await _loadUploads();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload complete! Notification sent.'),
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

  void _showImageDialog(Upload upload) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 300,
              color: Colors.grey.shade200,
              child: Center(child: Icon(Icons.image, size: 100)),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Uploaded: ${_formatDate(upload.uploadedAt)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
