# Lesson 6: Media Messages - Images, Videos & Files

## 5-Year-Old Analogy 🎈

Imagine you want to show your friend your new toy:

**Text Messages**: Like describing the toy with words - "It's red and has wheels"
**Picture Messages**: Like drawing the toy - much better!
**Video Messages**: Like showing the toy moving - even cooler!
**File Messages**: Like giving them the toy's instruction manual

With media messages, you can share pictures of your birthday, videos of your pet, or send files like homework - not just words!

## What We'll Build

In this lesson, we'll implement:
- ✅ Image messages (camera + gallery)
- ✅ Video messages
- ✅ File messages (PDF, documents)
- ✅ Firebase Storage integration
- ✅ Upload progress indicators
- ✅ Image compression
- ✅ Thumbnail generation
- ✅ Media preview & fullscreen view
- ✅ Download & share functionality

## Step 1: Firebase Storage Service

Create `lib/services/storage_service.dart`:

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Upload image to Firebase Storage
  Future<String> uploadImage({
    required File file,
    required String chatId,
    Function(double)? onProgress,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Compress image before uploading
      final compressedFile = await _compressImage(file);

      // Generate unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final storagePath = 'chats/$chatId/images/$fileName';

      // Create reference
      final ref = _storage.ref().child(storagePath);

      // Upload with progress tracking
      final uploadTask = ref.putFile(
        compressedFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': currentUserId!,
            'chatId': chatId,
          },
        ),
      );

      // Listen to progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
        print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });

      // Wait for completion
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ Image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading image: $e');
      rethrow;
    }
  }

  /// Upload video to Firebase Storage
  Future<String> uploadVideo({
    required File file,
    required String chatId,
    Function(double)? onProgress,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check file size (limit to 100MB)
      final fileSize = await file.length();
      if (fileSize > 100 * 1024 * 1024) {
        throw Exception('Video file too large (max 100MB)');
      }

      // Generate unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final storagePath = 'chats/$chatId/videos/$fileName';

      // Create reference
      final ref = _storage.ref().child(storagePath);

      // Upload with progress tracking
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'video/mp4',
          customMetadata: {
            'uploadedBy': currentUserId!,
            'chatId': chatId,
          },
        ),
      );

      // Listen to progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      // Wait for completion
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ Video uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading video: $e');
      rethrow;
    }
  }

  /// Upload file (PDF, documents, etc.)
  Future<String> uploadFile({
    required File file,
    required String chatId,
    Function(double)? onProgress,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check file size (limit to 25MB)
      final fileSize = await file.length();
      if (fileSize > 25 * 1024 * 1024) {
        throw Exception('File too large (max 25MB)');
      }

      // Generate unique filename
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final storagePath = 'chats/$chatId/files/$fileName';

      // Create reference
      final ref = _storage.ref().child(storagePath);

      // Detect content type
      final extension = path.extension(file.path).toLowerCase();
      final contentType = _getContentType(extension);

      // Upload with progress tracking
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: contentType,
          customMetadata: {
            'uploadedBy': currentUserId!,
            'chatId': chatId,
            'fileName': path.basename(file.path),
          },
        ),
      );

      // Listen to progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      // Wait for completion
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ File uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading file: $e');
      rethrow;
    }
  }

  /// Delete file from storage
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      print('✅ File deleted from storage');
    } catch (e) {
      print('Error deleting file: $e');
      // Don't throw - deletion is not critical
    }
  }

  /// Compress image before uploading
  Future<File> _compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = '${splitted}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
        minWidth: 1920,
        minHeight: 1080,
      );

      if (compressedFile == null) {
        return file; // Return original if compression fails
      }

      final compressedFileObj = File(compressedFile.path);
      final originalSize = await file.length();
      final compressedSize = await compressedFileObj.length();

      print('Original size: ${originalSize / 1024} KB');
      print('Compressed size: ${compressedSize / 1024} KB');
      print(
          'Saved: ${((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1)}%');

      return compressedFileObj;
    } catch (e) {
      print('Error compressing image: $e');
      return file; // Return original if compression fails
    }
  }

  /// Get content type from file extension
  String _getContentType(String extension) {
    switch (extension) {
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
        return 'application/msword';
      case '.xls':
      case '.xlsx':
        return 'application/vnd.ms-excel';
      case '.ppt':
      case '.pptx':
        return 'application/vnd.ms-powerpoint';
      case '.txt':
        return 'text/plain';
      case '.zip':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }

  /// Generate thumbnail for video
  Future<File?> generateVideoThumbnail(File videoFile) async {
    // TODO: Implement video thumbnail generation
    // Use video_thumbnail package
    return null;
  }

  /// Get file size in human-readable format
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
```

## Step 2: Enhanced Message Service with Media

Update `lib/services/message_service.dart` to add media methods:

```dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'storage_service.dart';

// Add to MessageService class:

final StorageService _storageService = StorageService();

/// Send image message
Future<String> sendImageMessage({
  required String chatId,
  required XFile imageFile,
  String? caption,
  Function(double)? onProgress,
}) async {
  if (currentUserId == null) {
    throw Exception('User not authenticated');
  }

  try {
    // Upload image to storage
    final imageUrl = await _storageService.uploadImage(
      file: File(imageFile.path),
      chatId: chatId,
      onProgress: onProgress,
    );

    // Create message
    final messageData = {
      'senderId': currentUserId,
      'text': caption ?? '',
      'type': MessageType.image.name,
      'mediaUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    };

    // Add to messages
    final docRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update chat's last message
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': caption?.isNotEmpty == true ? caption : '📷 Photo',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': currentUserId,
    });

    print('✅ Image message sent: ${docRef.id}');
    return docRef.id;
  } catch (e) {
    print('❌ Error sending image message: $e');
    rethrow;
  }
}

/// Send video message
Future<String> sendVideoMessage({
  required String chatId,
  required File videoFile,
  String? caption,
  Function(double)? onProgress,
}) async {
  if (currentUserId == null) {
    throw Exception('User not authenticated');
  }

  try {
    // Upload video to storage
    final videoUrl = await _storageService.uploadVideo(
      file: videoFile,
      chatId: chatId,
      onProgress: onProgress,
    );

    // Create message
    final messageData = {
      'senderId': currentUserId,
      'text': caption ?? '',
      'type': MessageType.video.name,
      'mediaUrl': videoUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    };

    // Add to messages
    final docRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update chat's last message
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': caption?.isNotEmpty == true ? caption : '🎥 Video',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': currentUserId,
    });

    print('✅ Video message sent: ${docRef.id}');
    return docRef.id;
  } catch (e) {
    print('❌ Error sending video message: $e');
    rethrow;
  }
}

/// Send file message
Future<String> sendFileMessage({
  required String chatId,
  required File file,
  String? caption,
  Function(double)? onProgress,
}) async {
  if (currentUserId == null) {
    throw Exception('User not authenticated');
  }

  try {
    // Upload file to storage
    final fileUrl = await _storageService.uploadFile(
      file: file,
      chatId: chatId,
      onProgress: onProgress,
    );

    final fileName = path.basename(file.path);

    // Create message
    final messageData = {
      'senderId': currentUserId,
      'text': caption ?? fileName,
      'type': MessageType.file.name,
      'mediaUrl': fileUrl,
      'fileName': fileName,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    };

    // Add to messages
    final docRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update chat's last message
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': '📎 $fileName',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': currentUserId,
    });

    print('✅ File message sent: ${docRef.id}');
    return docRef.id;
  } catch (e) {
    print('❌ Error sending file message: $e');
    rethrow;
  }
}
```

## Step 3: Media Picker Widget

Create `lib/widgets/media_picker.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MediaPicker extends StatelessWidget {
  final Function(XFile) onImageSelected;
  final Function(File) onVideoSelected;
  final Function(File) onFileSelected;

  const MediaPicker({
    super.key,
    required this.onImageSelected,
    required this.onVideoSelected,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),

          // Title
          Text(
            'Send Media',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),

          // Options grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                color: Colors.purple,
                onTap: () => _pickImageFromGallery(context),
              ),
              _buildOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                color: Colors.blue,
                onTap: () => _pickImageFromCamera(context),
              ),
              _buildOption(
                icon: Icons.videocam,
                label: 'Video',
                color: Colors.red,
                onTap: () => _pickVideo(context),
              ),
              _buildOption(
                icon: Icons.insert_drive_file,
                label: 'Document',
                color: Colors.orange,
                onTap: () => _pickFile(context),
              ),
              _buildOption(
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Location sharing coming soon!')),
                  );
                },
              ),
              _buildOption(
                icon: Icons.person,
                label: 'Contact',
                color: Colors.teal,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contact sharing coming soon!')),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        Navigator.pop(context);
        onImageSelected(image);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        Navigator.pop(context);
        onImageSelected(image);
      }
    } catch (e) {
      print('Error taking photo: $e');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take photo')),
      );
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(minutes: 2),
      );

      if (video != null) {
        Navigator.pop(context);
        onVideoSelected(File(video.path));
      }
    } catch (e) {
      print('Error picking video: $e');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick video')),
      );
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        Navigator.pop(context);
        onFileSelected(file);
      }
    } catch (e) {
      print('Error picking file: $e');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file')),
      );
    }
  }
}
```

## Step 4: Image Preview Screen

Create `lib/screens/image_preview_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String? caption;

  const ImagePreviewScreen({
    super.key,
    required this.imageUrl,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // TODO: Download image
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image downloaded')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // TODO: Share image
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.white, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (caption != null && caption!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.black87,
              child: Text(
                caption!,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
```

## Step 5: Upload Progress Dialog

Create `lib/widgets/upload_progress_dialog.dart`:

```dart
import 'package:flutter/material.dart';

class UploadProgressDialog extends StatelessWidget {
  final double progress;
  final String message;

  const UploadProgressDialog({
    super.key,
    required this.progress,
    this.message = 'Uploading...',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(value: progress),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UploadProgressDialog(progress: 0),
    );
  }

  static void update(BuildContext context, double progress) {
    // Update existing dialog
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UploadProgressDialog(progress: progress),
      );
    }
  }

  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
```

## Step 6: Update Message Input for Media

Update the `MessageInput` widget to support media:

```dart
// In MessageInput widget, add this method:

void _showMediaPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => MediaPicker(
      onImageSelected: (image) => widget.onSendImage?.call(image),
      onVideoSelected: (video) => widget.onSendVideo?.call(video),
      onFileSelected: (file) => widget.onSendFile?.call(file),
    ),
  );
}

// Update the attachment button:
IconButton(
  icon: Icon(Icons.add_circle_outline),
  color: Colors.grey[700],
  onPressed: widget.enabled ? () => _showMediaPicker(context) : null,
),
```

## Step 7: Update Chat Screen to Handle Media

Add these methods to your chat screen:

```dart
Future<void> _handleImageSelected(XFile image) async {
  // Show upload progress
  double uploadProgress = 0;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => UploadProgressDialog(
      progress: uploadProgress,
      message: 'Uploading image...',
    ),
  );

  try {
    await _messageService.sendImageMessage(
      chatId: widget.chatId,
      imageFile: image,
      onProgress: (progress) {
        uploadProgress = progress;
        // Update dialog
        UploadProgressDialog.update(context, progress);
      },
    );

    Navigator.pop(context); // Close progress dialog
    _scrollToBottom();
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send image'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> _handleVideoSelected(File video) async {
  double uploadProgress = 0;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => UploadProgressDialog(
      progress: uploadProgress,
      message: 'Uploading video...',
    ),
  );

  try {
    await _messageService.sendVideoMessage(
      chatId: widget.chatId,
      videoFile: video,
      onProgress: (progress) {
        uploadProgress = progress;
        UploadProgressDialog.update(context, progress);
      },
    );

    Navigator.pop(context);
    _scrollToBottom();
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send video'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

## Required Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies...

  # Image handling
  image_picker: ^1.0.5
  cached_network_image: ^3.3.0
  flutter_image_compress: ^2.1.0
  photo_view: ^0.14.0

  # File handling
  file_picker: ^6.1.1
  path: ^1.8.3

  # Video thumbnail (optional)
  video_thumbnail: ^0.5.3
```

## Firebase Storage Security Rules

Update Firebase Storage rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }

    // Function to check file size
    function isValidSize(maxSizeMB) {
      return request.resource.size < maxSizeMB * 1024 * 1024;
    }

    // Function to check if file is an image
    function isImage() {
      return request.resource.contentType.matches('image/.*');
    }

    // Function to check if file is a video
    function isVideo() {
      return request.resource.contentType.matches('video/.*');
    }

    // Chat images
    match /chats/{chatId}/images/{fileName} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() &&
                     isImage() &&
                     isValidSize(10); // 10MB max
    }

    // Chat videos
    match /chats/{chatId}/videos/{fileName} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() &&
                     isVideo() &&
                     isValidSize(100); // 100MB max
    }

    // Chat files
    match /chats/{chatId}/files/{fileName} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() &&
                     isValidSize(25); // 25MB max
    }
  }
}
```

## Verification Steps

### Test Image Messages
1. Click attachment button
2. Select "Gallery"
3. Choose image
4. Upload progress shows
5. Image appears in chat
6. Tap image to view fullscreen

### Test Video Messages
1. Select "Video"
2. Choose video
3. Upload progress shows
4. Video thumbnail appears
5. Tap to play

### Test File Messages
1. Select "Document"
2. Choose PDF/document
3. Upload progress shows
4. File shows with icon and name
5. Tap to download

## Common Issues and Solutions

### Issue 1: Images Too Large

**Solution**: Compress before upload
```dart
await FlutterImageCompress.compressAndGetFile(
  file.path,
  targetPath,
  quality: 70,
);
```

### Issue 2: Upload Fails

**Solution**: Add retry logic
```dart
try {
  await uploadImage();
} catch (e) {
  // Show retry button
  showRetryDialog();
}
```

### Issue 3: Slow Uploads

**Solution**: Show progress and allow background upload
```dart
// Listen to upload progress
uploadTask.snapshotEvents.listen((snapshot) {
  final progress = snapshot.bytesTransferred / snapshot.totalBytes;
  updateUI(progress);
});
```

## Performance Tips

1. **Compress images** before uploading
2. **Generate thumbnails** for videos
3. **Lazy load** media in chat
4. **Cache** downloaded media
5. **Limit file sizes** to prevent abuse

## Next Steps

In the next lesson, we'll add:
1. Push notifications for new messages
2. FCM integration
3. Background message handling

## Key Takeaways

1. **Firebase Storage** handles media files efficiently
2. **Compression** saves bandwidth and storage
3. **Progress indicators** improve UX
4. **Security rules** protect your storage
5. **Error handling** prevents frustration

Remember: Good media handling makes or breaks a chat app! 🚀
