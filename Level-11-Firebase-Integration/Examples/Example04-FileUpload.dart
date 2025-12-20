// Example 04: Firebase Storage - File Upload
// Upload images and files to Firebase Storage

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const StorageDemoScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STORAGE DEMO SCREEN
// ═══════════════════════════════════════════════════════════════

class StorageDemoScreen extends StatefulWidget {
  const StorageDemoScreen({super.key});

  @override
  State<StorageDemoScreen> createState() => _StorageDemoScreenState();
}

class _StorageDemoScreenState extends State<StorageDemoScreen> {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  List<UploadedFile> _uploadedFiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUploadedFiles();
  }

  Future<void> _loadUploadedFiles() async {
    setState(() => _isLoading = true);

    try {
      final listResult = await _storage.ref('uploads').listAll();
      final files = <UploadedFile>[];

      for (final item in listResult.items) {
        final url = await item.getDownloadURL();
        final metadata = await item.getMetadata();
        files.add(UploadedFile(
          name: item.name,
          url: url,
          size: metadata.size ?? 0,
          contentType: metadata.contentType ?? 'unknown',
        ));
      }

      setState(() => _uploadedFiles = files);
    } catch (e) {
      // Folder might not exist yet
      print('Error loading files: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    _uploadFile(File(pickedFile.path));
  }

  Future<void> _uploadFile(File file) async {
    final fileName =
        'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('uploads/$fileName');

    // Show upload dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UploadProgressDialog(
        uploadTask: ref.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        ),
        onComplete: (url) {
          Navigator.pop(context);
          _loadUploadedFiles();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload complete!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onError: (error) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteFile(String name) async {
    try {
      await _storage.ref('uploads/$name').delete();
      _loadUploadedFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUploadedFiles,
          ),
        ],
      ),
      body: Column(
        children: [
          // Upload buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickAndUploadImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickAndUploadImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Uploaded files list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _uploadedFiles.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No files uploaded yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Tap Camera or Gallery to upload',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _uploadedFiles.length,
                        itemBuilder: (context, index) {
                          final file = _uploadedFiles[index];
                          return UploadedFileCard(
                            file: file,
                            onDelete: () => _confirmDelete(file),
                            onTap: () => _showFullImage(file),
                          );
                        },
                      ),
          ),

          // Storage info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${_uploadedFiles.length} file${_uploadedFiles.length == 1 ? '' : 's'} uploaded',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(UploadedFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File?'),
        content: Text('Are you sure you want to delete "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFile(file.name);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFullImage(UploadedFile file) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(file.name),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Image.network(
              file.url,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Size: ${_formatBytes(file.size)}'),
                  Text('Type: ${file.contentType}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// ═══════════════════════════════════════════════════════════════
// UPLOADED FILE MODEL
// ═══════════════════════════════════════════════════════════════

class UploadedFile {
  final String name;
  final String url;
  final int size;
  final String contentType;

  UploadedFile({
    required this.name,
    required this.url,
    required this.size,
    required this.contentType,
  });
}

// ═══════════════════════════════════════════════════════════════
// UPLOAD PROGRESS DIALOG
// ═══════════════════════════════════════════════════════════════

class UploadProgressDialog extends StatefulWidget {
  final UploadTask uploadTask;
  final Function(String url) onComplete;
  final Function(String error) onError;

  const UploadProgressDialog({
    super.key,
    required this.uploadTask,
    required this.onComplete,
    required this.onError,
  });

  @override
  State<UploadProgressDialog> createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<UploadProgressDialog> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _listenToUpload();
  }

  void _listenToUpload() {
    widget.uploadTask.snapshotEvents.listen(
      (TaskSnapshot snapshot) {
        setState(() {
          _progress = snapshot.bytesTransferred / snapshot.totalBytes;
        });

        if (snapshot.state == TaskState.success) {
          _onSuccess();
        }
      },
      onError: (error) {
        widget.onError(error.toString());
      },
    );
  }

  Future<void> _onSuccess() async {
    final url = await widget.uploadTask.snapshot.ref.getDownloadURL();
    widget.onComplete(url);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uploading...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 16),
          Text('${(_progress * 100).toStringAsFixed(0)}%'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.uploadTask.cancel();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// UPLOADED FILE CARD
// ═══════════════════════════════════════════════════════════════

class UploadedFileCard extends StatelessWidget {
  final UploadedFile file;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UploadedFileCard({
    super.key,
    required this.file,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.network(
                file.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stack) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),

            // Delete button
            Positioned(
              top: 4,
              right: 4,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  color: Colors.white,
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),

            // File name
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black54,
                child: Text(
                  file.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Picking Images
 *    - ImagePicker for camera/gallery
 *    - Compress with maxWidth/maxHeight
 *
 * 2. Uploading Files
 *    - ref.putFile(file) for File objects
 *    - SettableMetadata for content type
 *
 * 3. Upload Progress
 *    - uploadTask.snapshotEvents stream
 *    - bytesTransferred / totalBytes for progress
 *
 * 4. Getting Download URL
 *    - ref.getDownloadURL() after upload
 *    - Use in Image.network()
 *
 * 5. Listing Files
 *    - ref.listAll() to get all files in folder
 *    - Get URL and metadata for each
 *
 * 6. Deleting Files
 *    - ref.delete()
 *
 * ═══════════════════════════════════════════════════════════════
 * IOS SETUP REQUIRED:
 * ═══════════════════════════════════════════════════════════════
 *
 * Add to ios/Runner/Info.plist:
 *
 * <key>NSCameraUsageDescription</key>
 * <string>We need camera access to take photos</string>
 * <key>NSPhotoLibraryUsageDescription</key>
 * <string>We need photo library access to upload pictures</string>
 *
 * ═══════════════════════════════════════════════════════════════
 * PACKAGES NEEDED:
 * ═══════════════════════════════════════════════════════════════
 *
 * dependencies:
 *   firebase_storage: ^11.6.0
 *   image_picker: ^1.0.4
 *
 */
