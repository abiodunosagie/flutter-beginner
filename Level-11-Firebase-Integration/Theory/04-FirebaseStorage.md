# Firebase Storage: Files in the Cloud

## The Simple Explanation

Firebase Storage is like Google Drive for your app:
- Upload files (images, documents, videos)
- Download files
- Share files with URLs

```
┌─────────────────────────────────────────────────────────┐
│                  FIREBASE STORAGE                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│   📱 Your App                                            │
│       │                                                  │
│       │ Upload image                                     │
│       ▼                                                  │
│   ☁️ Firebase Storage                                    │
│   ├── profile_pictures/                                 │
│   │   ├── user_123.jpg                                  │
│   │   └── user_456.jpg                                  │
│   └── uploads/                                          │
│       ├── document.pdf                                  │
│       └── photo.png                                     │
│       │                                                  │
│       │ Get download URL                                │
│       ▼                                                  │
│   🔗 https://firebasestorage.googleapis.com/...         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Enable Firebase Storage

### In Firebase Console:

1. Click **Storage** in the left menu
2. Click **Get Started**
3. Choose **Start in test mode** (for learning)
4. Select a location

---

## Setup

### Add Package

```yaml
dependencies:
  firebase_storage: ^11.6.0
  image_picker: ^1.0.4  # For picking images
```

### iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to upload pictures</string>
```

### Android Configuration

Already configured automatically.

---

## Basic Operations

### Get Storage Reference

```dart
import 'package:firebase_storage/firebase_storage.dart';

// Get storage instance
final storage = FirebaseStorage.instance;

// Reference to root
final rootRef = storage.ref();

// Reference to a folder
final profilePicsRef = storage.ref('profile_pictures');

// Reference to a specific file
final userPicRef = storage.ref('profile_pictures/user_123.jpg');
```

---

## Uploading Files

### Upload from File Path

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFile(File file, String path) async {
  try {
    // Create reference
    final ref = FirebaseStorage.instance.ref(path);

    // Upload file
    await ref.putFile(file);

    // Get download URL
    final downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Upload failed: $e');
    rethrow;
  }
}
```

### Upload with Progress

```dart
Future<String> uploadWithProgress(
  File file,
  String path,
  Function(double) onProgress,
) async {
  final ref = FirebaseStorage.instance.ref(path);

  // Start upload
  final uploadTask = ref.putFile(file);

  // Listen to progress
  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    final progress = snapshot.bytesTransferred / snapshot.totalBytes;
    onProgress(progress); // 0.0 to 1.0
  });

  // Wait for completion
  await uploadTask;

  // Return download URL
  return await ref.getDownloadURL();
}
```

### Upload from Memory (Uint8List)

```dart
Future<String> uploadBytes(Uint8List bytes, String path) async {
  final ref = FirebaseStorage.instance.ref(path);
  await ref.putData(bytes);
  return await ref.getDownloadURL();
}
```

---

## Complete Profile Picture Example

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureUploader extends StatefulWidget {
  const ProfilePictureUploader({super.key});

  @override
  State<ProfilePictureUploader> createState() => _ProfilePictureUploaderState();
}

class _ProfilePictureUploaderState extends State<ProfilePictureUploader> {
  String? _imageUrl;
  bool _isUploading = false;
  double _uploadProgress = 0;

  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentPhoto();
  }

  void _loadCurrentPhoto() {
    _imageUrl = _auth.currentUser?.photoURL;
  }

  Future<void> _pickAndUploadImage() async {
    // Pick image from gallery
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      final file = File(pickedFile.path);
      final userId = _auth.currentUser!.uid;
      final path = 'profile_pictures/$userId.jpg';

      // Create reference
      final ref = _storage.ref(path);

      // Start upload
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Listen to progress
      uploadTask.snapshotEvents.listen((snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for completion
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      // Update user profile
      await _auth.currentUser!.updatePhotoURL(downloadUrl);

      setState(() {
        _imageUrl = downloadUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated!')),
      );
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile picture
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _imageUrl != null
                  ? NetworkImage(_imageUrl!)
                  : null,
              child: _imageUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),

            // Upload progress overlay
            if (_isUploading)
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: _uploadProgress,
                  strokeWidth: 4,
                ),
              ),

            // Edit button
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 18,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: _isUploading ? null : _pickAndUploadImage,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Progress text
        if (_isUploading)
          Text('Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%'),
      ],
    );
  }
}
```

---

## Downloading Files

### Get Download URL

```dart
Future<String> getDownloadUrl(String path) async {
  final ref = FirebaseStorage.instance.ref(path);
  return await ref.getDownloadURL();
}

// Use in Image widget
Image.network(downloadUrl)
```

### Download to Memory

```dart
Future<Uint8List?> downloadFile(String path) async {
  final ref = FirebaseStorage.instance.ref(path);
  final bytes = await ref.getData();
  return bytes;
}
```

### Download to Local File

```dart
import 'package:path_provider/path_provider.dart';

Future<File> downloadToFile(String storagePath) async {
  final ref = FirebaseStorage.instance.ref(storagePath);

  // Get local directory
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/downloaded_file');

  // Download
  await ref.writeToFile(file);

  return file;
}
```

---

## Deleting Files

```dart
Future<void> deleteFile(String path) async {
  try {
    await FirebaseStorage.instance.ref(path).delete();
    print('File deleted');
  } catch (e) {
    print('Delete failed: $e');
  }
}
```

---

## Listing Files

```dart
Future<List<String>> listFiles(String folder) async {
  final ref = FirebaseStorage.instance.ref(folder);
  final result = await ref.listAll();

  // Get all file names
  final names = result.items.map((item) => item.name).toList();

  return names;
}

// List with download URLs
Future<List<Map<String, String>>> listFilesWithUrls(String folder) async {
  final ref = FirebaseStorage.instance.ref(folder);
  final result = await ref.listAll();

  final files = <Map<String, String>>[];

  for (final item in result.items) {
    final url = await item.getDownloadURL();
    files.add({
      'name': item.name,
      'url': url,
    });
  }

  return files;
}
```

---

## Complete Storage Service

```dart
// services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  // Upload file with progress callback
  Future<String> uploadFile({
    required File file,
    required String path,
    String? contentType,
    Function(double)? onProgress,
  }) async {
    final ref = _storage.ref(path);

    final metadata = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;

    final uploadTask = ref.putFile(file, metadata);

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
    }

    await uploadTask;
    return await ref.getDownloadURL();
  }

  // Upload bytes
  Future<String> uploadBytes({
    required Uint8List bytes,
    required String path,
    String? contentType,
  }) async {
    final ref = _storage.ref(path);

    final metadata = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;

    await ref.putData(bytes, metadata);
    return await ref.getDownloadURL();
  }

  // Get download URL
  Future<String> getDownloadUrl(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }

  // Delete file
  Future<void> deleteFile(String path) async {
    await _storage.ref(path).delete();
  }

  // Check if file exists
  Future<bool> fileExists(String path) async {
    try {
      await _storage.ref(path).getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get file metadata
  Future<FullMetadata> getMetadata(String path) async {
    return await _storage.ref(path).getMetadata();
  }
}
```

---

## File Naming Best Practices

```dart
// Good file naming patterns

// Profile pictures
'profile_pictures/${userId}.jpg'

// User uploads with timestamp
'uploads/${userId}/${DateTime.now().millisecondsSinceEpoch}_${filename}'

// Unique ID approach
'images/${uuid.v4()}.jpg'

// Organized by date
'uploads/${userId}/${year}/${month}/${day}/${filename}'
```

---

## Handling Image Types

```dart
String getContentType(String filename) {
  final extension = filename.split('.').last.toLowerCase();

  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    case 'pdf':
      return 'application/pdf';
    default:
      return 'application/octet-stream';
  }
}
```

---

## Security Rules

Secure your storage in Firebase Console:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // Profile pictures: only owner can write
    match /profile_pictures/{userId}.{ext} {
      allow read: if true;  // Anyone can view
      allow write: if request.auth != null
                   && request.auth.uid == userId;
    }

    // User uploads: only owner can read/write
    match /uploads/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }

    // Limit file size (e.g., 5MB)
    match /{allPaths=**} {
      allow write: if request.resource.size < 5 * 1024 * 1024;
    }
  }
}
```

---

## Common Patterns

### Caching Downloaded Images

```dart
// Use cached_network_image package for caching
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: downloadUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

### Compressing Before Upload

```dart
import 'package:image_picker/image_picker.dart';

final pickedFile = await ImagePicker().pickImage(
  source: ImageSource.gallery,
  maxWidth: 1024,        // Max width in pixels
  maxHeight: 1024,       // Max height in pixels
  imageQuality: 85,      // Quality 0-100
);
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│               STORAGE SUMMARY                            │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  UPLOAD                                                  │
│  ├── ref.putFile(file)     - Upload from file           │
│  ├── ref.putData(bytes)    - Upload from memory         │
│  └── Get URL: ref.getDownloadURL()                      │
│                                                          │
│  DOWNLOAD                                                │
│  ├── ref.getDownloadURL()  - Get URL for Image.network  │
│  ├── ref.getData()         - Download to memory         │
│  └── ref.writeToFile(file) - Download to local file     │
│                                                          │
│  MANAGE                                                  │
│  ├── ref.delete()          - Delete file                │
│  ├── ref.listAll()         - List files in folder       │
│  └── ref.getMetadata()     - Get file info              │
│                                                          │
│  PROGRESS                                                │
│  └── uploadTask.snapshotEvents.listen()                 │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Congratulations!** You now know how to:
- Set up Firebase
- Authenticate users
- Store data in Firestore
- Upload files to Storage

**Next:** Check out the Examples folder for complete working code!
