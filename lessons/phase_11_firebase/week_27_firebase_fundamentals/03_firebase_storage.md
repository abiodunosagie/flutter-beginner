# Firebase Storage: File Uploads & Downloads

## Complete File Upload/Download Guide

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String> uploadImage(File file, String fileName) async {
    final ref = _storage.ref().child('images/$fileName');
    
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    
    return url;
  }

  // Upload with progress
  Stream<double> uploadWithProgress(File file, String path) async* {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);

    await for (final snapshot in uploadTask.snapshotEvents) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      yield progress;
    }
  }

  // Download file
  Future<void> downloadFile(String url, String savePath) async {
    final ref = _storage.refFromURL(url);
    final file = File(savePath);
    
    await ref.writeToFile(file);
  }

  // Delete file
  Future<void> deleteFile(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }

  // List files
  Future<List<String>> listFiles(String path) async {
    final ref = _storage.ref().child(path);
    final result = await ref.listAll();
    
    return Future.wait(
      result.items.map((item) => item.getDownloadURL()),
    );
  }
}

// UI Implementation
class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final _storageService = StorageService();
  File? _selectedFile;
  double _uploadProgress = 0;
  String? _uploadedUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _selectedFile = File(image.path));
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedFile == null) return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    
    _storageService.uploadWithProgress(_selectedFile!, 'images/$fileName').listen(
      (progress) {
        setState(() => _uploadProgress = progress);
      },
      onDone: () async {
        final url = await _storageService.uploadImage(_selectedFile!, fileName);
        setState(() {
          _uploadedUrl = url;
          _uploadProgress = 0;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedFile != null)
              Image.file(_selectedFile!, height: 200),
            
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            
            if (_uploadProgress > 0 && _uploadProgress < 1)
              LinearProgressIndicator(value: _uploadProgress),
            
            if (_selectedFile != null)
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload'),
              ),
            
            if (_uploadedUrl != null)
              Text('Uploaded: $_uploadedUrl'),
          ],
        ),
      ),
    );
  }
}
```

Master file uploads with Firebase Storage! 🚀
