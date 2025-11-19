# Firebase Storage: File Uploads & Downloads

## What is Firebase Storage? (Explain Like I'm 5!)

Imagine you have a **magic photo album in the sky** ☁️📸

When you take a picture with your toy camera, where does it go? Usually, it stays on your camera, right? But what if you want to show that picture to your friend who lives far away? Or what if you lose your camera - oh no! All your pictures are gone!

That's where **Firebase Storage** comes in - it's like a **magical storage box that lives in the clouds** (not real clouds, but super powerful computers far away). Here's how it works:

1. **You take a picture** 📸 - Click! You took a photo of your pet
2. **You send it to the cloud** ☁️ - Whoosh! The picture flies up to the magic storage box
3. **It's safe forever** 💪 - Even if you break your phone, the picture is still there!
4. **Anyone can see it** 👀 - Your friends can see your picture from their phones too!

It's like having a **magical backpack** that:
- Never gets full (unlimited space!)
- Never gets lost (always in the cloud!)
- Can be opened from anywhere (any device!)
- Can hold photos, videos, drawings, anything!

Cool, right? Let's learn how to use this magic! 🎉

---

## Setting Up Firebase Storage

### Step 1: Add Firebase Storage Package

First, add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  firebase_storage: ^11.5.0
  image_picker: ^1.0.4  # For picking images
  image: ^4.1.3  # For image compression
  video_player: ^2.8.1  # For video preview
  path_provider: ^2.1.1  # For file paths
  permission_handler: ^11.0.1  # For permissions
```

Then run:
```bash
flutter pub get
```

### Step 2: Enable Firebase Storage in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click on "Storage" in the left menu
4. Click "Get Started"
5. Choose "Start in test mode" (we'll add security rules later!)
6. Click "Done"

**You're ready!** 🎉

---

## Basic Firebase Storage Service

Let's create a service that handles all our file operations:

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload any file to Firebase Storage
  Future<String> uploadFile(File file, String folderName) async {
    try {
      // Create a unique filename
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String fileExtension = path.extension(file.path);

      // Create a reference to the file location
      Reference ref = _storage.ref().child('$folderName/$fileName$fileExtension');

      // Upload the file
      await ref.putFile(file);

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Upload failed: $e');
    }
  }

  // Get reference to a file
  Reference getFileReference(String path) {
    return _storage.ref().child(path);
  }
}
```

---

## Example 1: Simple Image Upload

Let's start simple - upload one image!

```dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SimpleImageUpload extends StatefulWidget {
  @override
  _SimpleImageUploadState createState() => _SimpleImageUploadState();
}

class _SimpleImageUploadState extends State<SimpleImageUpload> {
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Upload image to Firebase
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload and get URL
      String url = await _storageService.uploadFile(_imageFile!, 'images');

      setState(() {
        _uploadedImageUrl = url;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Image Upload'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show selected image
              if (_imageFile != null)
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                )
              else
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('No image selected'),
                  ),
                ),

              SizedBox(height: 30),

              // Pick image button
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),

              SizedBox(height: 15),

              // Upload button
              if (_imageFile != null)
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadImage,
                  icon: _isUploading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.cloud_upload),
                  label: Text(_isUploading ? 'Uploading...' : 'Upload to Cloud'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),

              SizedBox(height: 20),

              // Show uploaded URL
              if (_uploadedImageUrl != null)
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Upload Success!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Image is now in the cloud!',
                        style: TextStyle(color: Colors.grey[600]),
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
}
```

---

## Example 2: Upload with Progress Tracking

See exactly how much of your file has uploaded!

```dart
class UploadWithProgress extends StatefulWidget {
  @override
  _UploadWithProgressState createState() => _UploadWithProgressState();
}

class _UploadWithProgressState extends State<UploadWithProgress> {
  File? _file;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    // Pick image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _file = File(image.path);
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      // Create a reference
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('uploads/$fileName');

      // Start upload
      UploadTask uploadTask = ref.putFile(_file!);

      // Listen to progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for completion
      await uploadTask;

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload complete! URL: $downloadUrl')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload with Progress')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_file != null)
                Image.file(_file!, height: 200),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                child: Text('Pick and Upload Image'),
              ),

              SizedBox(height: 20),

              // Progress indicator
              if (_isUploading) ...[
                LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                Text(
                  '${(_uploadProgress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Uploading to cloud...'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Example 3: Profile Picture Upload

A real-world example - let users upload their profile picture!

```dart
class ProfilePictureUpload extends StatefulWidget {
  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  String? _profileImageUrl;
  bool _isLoading = false;

  Future<void> _uploadProfilePicture() async {
    final ImagePicker picker = ImagePicker();

    // Show options: Camera or Gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    // Pick image
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload to Firebase Storage
      File file = File(image.path);
      String userId = 'user123'; // Replace with actual user ID
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/$userId.jpg');

      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated!')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture display
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null
                      ? Icon(Icons.person, size: 80, color: Colors.grey[600])
                      : null,
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black54,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _uploadProfilePicture,
              icon: Icon(Icons.camera_alt),
              label: Text('Change Profile Picture'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 4: Photo Gallery App

Upload multiple photos and display them in a gallery!

```dart
class PhotoGalleryApp extends StatefulWidget {
  @override
  _PhotoGalleryAppState createState() => _PhotoGalleryAppState();
}

class _PhotoGalleryAppState extends State<PhotoGalleryApp> {
  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  // Load all images from Firebase Storage
  Future<void> _loadGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Reference ref = FirebaseStorage.instance.ref().child('gallery');
      ListResult result = await ref.listAll();

      List<String> urls = [];
      for (Reference item in result.items) {
        String url = await item.getDownloadURL();
        urls.add(url);
      }

      setState(() {
        _imageUrls = urls;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading gallery: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Upload a new photo
  Future<void> _uploadPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('gallery/$fileName.jpg');

      await ref.putFile(file);

      // Reload gallery
      await _loadGallery();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo added to gallery!')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  // Delete a photo
  Future<void> _deletePhoto(String url) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();

      setState(() {
        _imageUrls.remove(url);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo deleted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Photo Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadGallery,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _imageUrls.isEmpty
              ? Center(
                  child: Text(
                    'No photos yet!\nTap + to add your first photo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () async {
                        // Confirm delete
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Photo?'),
                            content: Text('This cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          _deletePhoto(_imageUrls[index]);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadPhoto,
        child: Icon(Icons.add_a_photo),
        tooltip: 'Add Photo',
      ),
    );
  }
}
```

---

## Example 5: Video Upload with Progress

Upload videos (larger files) with detailed progress tracking!

```dart
class VideoUpload extends StatefulWidget {
  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  File? _videoFile;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _uploadedVideoUrl;

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
        _uploadedVideoUrl = null;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('videos/$fileName.mp4');

      UploadTask uploadTask = ref.putFile(_videoFile!);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });

        print('Upload progress: ${(_uploadProgress * 100).toStringAsFixed(1)}%');
      });

      // Wait for upload to complete
      await uploadTask;

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        _uploadedVideoUrl = downloadUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Upload')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_videoFile != null)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(Icons.video_library, size: 80, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      'Video selected',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _videoFile!.path.split('/').last,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickVideo,
              icon: Icon(Icons.video_library),
              label: Text('Pick Video'),
            ),

            SizedBox(height: 15),

            if (_videoFile != null && !_isUploading)
              ElevatedButton.icon(
                onPressed: _uploadVideo,
                icon: Icon(Icons.cloud_upload),
                label: Text('Upload Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),

            SizedBox(height: 30),

            // Upload progress
            if (_isUploading) ...[
              Text(
                'Uploading...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              LinearProgressIndicator(
                value: _uploadProgress,
                minHeight: 15,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
              SizedBox(height: 10),
              Text(
                '${(_uploadProgress * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Please wait, uploading large file...'),
            ],

            // Success message
            if (_uploadedVideoUrl != null) ...[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 60),
                    SizedBox(height: 10),
                    Text(
                      'Video Uploaded!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Your video is now in the cloud!'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## Example 6: Image Compression Before Upload

Make your images smaller before uploading to save space and time!

```dart
import 'package:image/image.dart' as img;
import 'dart:io';

class ImageCompressionService {
  // Compress image before uploading
  Future<File> compressImage(File file) async {
    // Read the image
    final imageBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Could not decode image');
    }

    // Resize if image is too large
    if (image.width > 1920 || image.height > 1920) {
      image = img.copyResize(
        image,
        width: image.width > image.height ? 1920 : null,
        height: image.height > image.width ? 1920 : null,
      );
    }

    // Compress image (reduce quality)
    final compressedBytes = img.encodeJpg(image, quality: 85);

    // Save compressed image to temporary file
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    // Print file sizes for comparison
    final originalSize = await file.length();
    final compressedSize = compressedBytes.length;
    print('Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB');
    print('Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
    print('Saved: ${((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1)}%');

    return tempFile;
  }
}

// Usage example
class CompressedImageUpload extends StatefulWidget {
  @override
  _CompressedImageUploadState createState() => _CompressedImageUploadState();
}

class _CompressedImageUploadState extends State<CompressedImageUpload> {
  final ImageCompressionService _compressionService = ImageCompressionService();
  File? _originalFile;
  File? _compressedFile;
  bool _isCompressing = false;
  bool _isUploading = false;

  Future<void> _pickAndCompressImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _originalFile = File(image.path);
      _isCompressing = true;
    });

    try {
      // Compress the image
      File compressed = await _compressionService.compressImage(_originalFile!);

      setState(() {
        _compressedFile = compressed;
        _isCompressing = false;
      });
    } catch (e) {
      setState(() {
        _isCompressing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compression failed: $e')),
      );
    }
  }

  Future<void> _uploadCompressedImage() async {
    if (_compressedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('compressed_images/$fileName.jpg');

      await ref.putFile(_compressedFile!);
      String url = await ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compressed image uploaded!')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compressed Upload')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_originalFile != null)
                Image.file(_originalFile!, height: 200),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isCompressing || _isUploading
                    ? null
                    : _pickAndCompressImage,
                child: Text('Pick and Compress Image'),
              ),

              if (_isCompressing)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),

              if (_compressedFile != null && !_isCompressing) ...[
                Text('Image compressed successfully!'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadCompressedImage,
                  child: Text(_isUploading ? 'Uploading...' : 'Upload'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Example 7: Download Files from Storage

Download files from Firebase Storage to your device!

```dart
import 'package:path_provider/path_provider.dart';

class DownloadService {
  // Download file from Firebase Storage
  Future<File?> downloadFile(String downloadUrl, String fileName) async {
    try {
      // Get reference from URL
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);

      // Get app documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';

      // Create file
      File file = File(filePath);

      // Download file
      await ref.writeToFile(file);

      print('File downloaded to: $filePath');
      return file;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  // Download with progress tracking
  Stream<double> downloadFileWithProgress(String downloadUrl, String fileName) async* {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File('${appDocDir.path}/$fileName');

      DownloadTask downloadTask = ref.writeToFile(file);

      await for (TaskSnapshot snapshot in downloadTask.snapshotEvents) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        yield progress;
      }
    } catch (e) {
      print('Error downloading: $e');
      yield -1; // Error indicator
    }
  }
}
```

---

## Example 8: Delete Files from Storage

Remove files you no longer need!

```dart
class DeleteService {
  // Delete file by URL
  Future<bool> deleteFile(String downloadUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();
      print('File deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Delete file by path
  Future<bool> deleteFileByPath(String path) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.delete();
      print('File deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Delete all files in a folder
  Future<int> deleteFolder(String folderPath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(folderPath);
      ListResult result = await ref.listAll();

      int deletedCount = 0;
      for (Reference item in result.items) {
        await item.delete();
        deletedCount++;
      }

      print('Deleted $deletedCount files');
      return deletedCount;
    } catch (e) {
      print('Error deleting folder: $e');
      return 0;
    }
  }
}
```

---

## Firebase Storage Security Rules

**Important!** Protect your files with security rules!

### Basic Security Rules

Go to Firebase Console > Storage > Rules and add these:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow anyone to read
    // Only authenticated users can write
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Advanced Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile pictures - only owner can write
    match /profile_pictures/{userId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Public gallery - authenticated users can upload
    match /gallery/{fileName} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // User documents - only owner can access
    match /user_files/{userId}/{fileName} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Limit file size to 5MB
    match /images/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.resource.size < 5 * 1024 * 1024;
    }

    // Only allow image files
    match /photos/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## Best Practices

### 1. Always Handle Errors

```dart
try {
  String url = await uploadFile(file);
  print('Success: $url');
} catch (e) {
  print('Error: $e');
  // Show error to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Upload failed: $e')),
  );
}
```

### 2. Show Upload Progress for Large Files

```dart
// Always show progress for files > 1MB
if (fileSize > 1024 * 1024) {
  // Show progress indicator
}
```

### 3. Compress Images Before Upload

```dart
// Compress to save bandwidth and storage
File compressed = await compressImage(originalFile);
await uploadFile(compressed);
```

### 4. Use Unique Filenames

```dart
// Use timestamp to avoid filename conflicts
String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
```

### 5. Organize Files in Folders

```dart
// Good structure
/images/profile/{userId}.jpg
/images/posts/{postId}_{timestamp}.jpg
/videos/{userId}/{videoId}.mp4
/documents/{userId}/{fileName}.pdf
```

### 6. Delete Old Files

```dart
// Clean up when user deletes content
await FirebaseStorage.instance.refFromURL(oldUrl).delete();
```

### 7. Handle Permissions

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}
```

### 8. Cache Downloaded Images

```dart
// Use cached_network_image package
CachedNetworkImage(
  imageUrl: downloadUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 9. Set Metadata

```dart
// Add metadata to files
SettableMetadata metadata = SettableMetadata(
  contentType: 'image/jpeg',
  customMetadata: {
    'uploadedBy': 'user123',
    'uploadedAt': DateTime.now().toIso8601String(),
  },
);

await ref.putFile(file, metadata);
```

### 10. Monitor Storage Usage

```dart
// Get file metadata
FullMetadata metadata = await ref.getMetadata();
print('Size: ${metadata.size} bytes');
print('Type: ${metadata.contentType}');
print('Created: ${metadata.timeCreated}');
```

---

## Common Errors and Solutions

### Error: "Permission denied"
**Solution:** Update your Firebase Storage security rules to allow access.

### Error: "Object does not exist"
**Solution:** Check that the file path is correct and the file hasn't been deleted.

### Error: "Network error"
**Solution:** Check internet connection. Implement retry logic for uploads.

### Error: "Out of memory"
**Solution:** Compress large files before uploading. Use streams for very large files.

### Error: "Invalid file type"
**Solution:** Validate file type before upload. Check security rules.

---

## Summary

Firebase Storage is like a **magic photo album in the sky**! ☁️

You learned:
1. How to upload images, videos, and files
2. Track upload progress
3. Download and delete files
4. Compress images to save space
5. Build real apps (profile pictures, galleries)
6. Secure your files with rules
7. Handle errors properly

Now you can store files in the cloud like a pro! 🎉

**Remember:**
- Always compress large images
- Show progress for big uploads
- Handle errors gracefully
- Use security rules to protect files
- Organize files in folders
- Delete unused files to save space

Happy coding! 🚀
