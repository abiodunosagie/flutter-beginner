# Camera & Image Picker

## The Big Idea In One Sentence

> The `image_picker` package lets the user grab a photo, either by taking one with the camera or choosing one from the gallery, and hands your app the picked file.

## The Simple Explanation

Think of Image Picker like choosing a photo for your profile:
- **Camera:** Take a new selfie 📷
- **Gallery:** Choose an existing photo 🖼️

```
┌─────────────────────────────────────────────────────────┐
│                   IMAGE PICKER                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐        ┌─────────────┐                 │
│  │             │        │             │                 │
│  │   📷        │   OR   │   🖼️        │                 │
│  │   Camera    │        │   Gallery   │                 │
│  │             │        │             │                 │
│  └──────┬──────┘        └──────┬──────┘                 │
│         │                      │                         │
│         └──────────┬───────────┘                         │
│                    │                                     │
│                    ▼                                     │
│              ┌──────────┐                                │
│              │  Image   │                                │
│              │  File    │                                │
│              └──────────┘                                │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Setup

### 1. Add Package

```yaml
dependencies:
  image_picker: ^1.0.4
```

### 2. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for video recording</string>
```

### 3. Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

---

## Basic Usage

### Pick Image from Gallery

```dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

Future<File?> pickFromGallery() async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    return File(image.path);
  }
  return null;
}
```

### Take Photo with Camera

```dart
Future<File?> takePhoto() async {
  final XFile? photo = await picker.pickImage(
    source: ImageSource.camera,
  );

  if (photo != null) {
    return File(photo.path);
  }
  return null;
}
```

---

## Image Quality Options

```dart
final XFile? image = await picker.pickImage(
  source: ImageSource.gallery,

  // Resize image
  maxWidth: 800,   // Max width in pixels
  maxHeight: 800,  // Max height in pixels

  // Compress quality (0-100)
  imageQuality: 85,

  // Prefer front or back camera
  preferredCameraDevice: CameraDevice.front,
);
```

```
WHY RESIZE AND COMPRESS?

Original Photo: 4032 x 3024 pixels, 5 MB
                        ↓
            maxWidth: 800, quality: 85
                        ↓
Resized Photo: 800 x 600 pixels, 150 KB

Benefits:
✓ Faster uploads
✓ Less storage used
✓ Quicker to display
```

---

## Pick Multiple Images

```dart
Future<List<File>> pickMultipleImages() async {
  final List<XFile> images = await picker.pickMultiImage(
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 80,
  );

  return images.map((xfile) => File(xfile.path)).toList();
}
```

---

## Pick Video

```dart
// From gallery
Future<File?> pickVideo() async {
  final XFile? video = await picker.pickVideo(
    source: ImageSource.gallery,
    maxDuration: const Duration(minutes: 5), // Limit length
  );

  if (video != null) {
    return File(video.path);
  }
  return null;
}

// Record with camera
Future<File?> recordVideo() async {
  final XFile? video = await picker.pickVideo(
    source: ImageSource.camera,
    maxDuration: const Duration(seconds: 30),
  );

  if (video != null) {
    return File(video.path);
  }
  return null;
}
```

---

## Complete Example Widget

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  State<ImagePickerDemo> createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedImage = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image preview
            GestureDetector(
              onTap: _showPickerOptions,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Tap to add photo'),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Handling Permissions

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraPermission() async {
  final status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  if (status.isPermanentlyDenied) {
    // User must enable from settings
    await openAppSettings();
    return false;
  }

  return false;
}

// Usage
Future<void> takePhotoWithPermission() async {
  if (await checkCameraPermission()) {
    final image = await _picker.pickImage(source: ImageSource.camera);
    // Use image...
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera permission required')),
    );
  }
}
```

---

## Profile Picture Pattern

```dart
class ProfilePicturePicker extends StatelessWidget {
  final String? currentImageUrl;
  final Function(File) onImagePicked;

  const ProfilePicturePicker({
    super.key,
    this.currentImageUrl,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Profile picture
        CircleAvatar(
          radius: 60,
          backgroundImage: currentImageUrl != null
              ? NetworkImage(currentImageUrl!)
              : null,
          child: currentImageUrl == null
              ? const Icon(Icons.person, size: 60)
              : null,
        ),

        // Edit button
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, size: 20),
              color: Colors.white,
              onPressed: () => _showPicker(context),
            ),
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () async {
              Navigator.pop(context);
              final image = await picker.pickImage(
                source: ImageSource.camera,
                maxWidth: 512,
                maxHeight: 512,
                imageQuality: 75,
              );
              if (image != null) {
                onImagePicked(File(image.path));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final image = await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 512,
                maxHeight: 512,
                imageQuality: 75,
              );
              if (image != null) {
                onImagePicked(File(image.path));
              }
            },
          ),
        ],
      ),
    );
  }
}
```

---

## Common Use Cases

### 1. Document Scanner

```dart
Future<File?> scanDocument() async {
  final image = await _picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1200,  // Higher resolution for documents
    imageQuality: 95, // Better quality for text
  );

  if (image != null) {
    // Process image (crop, enhance, etc.)
    return File(image.path);
  }
  return null;
}
```

### 2. Receipt Upload

```dart
Future<void> uploadReceipt() async {
  final image = await _picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1024,
    imageQuality: 80,
  );

  if (image != null) {
    // Upload to server
    await uploadFile(File(image.path));
  }
}
```

### 3. Multiple Product Photos

```dart
Future<List<File>> addProductPhotos() async {
  final images = await _picker.pickMultiImage(
    maxWidth: 800,
    maxHeight: 800,
    imageQuality: 85,
  );

  // Limit to 5 photos
  final limitedImages = images.take(5).toList();

  return limitedImages.map((x) => File(x.path)).toList();
}
```

---

## Error Handling

```dart
Future<void> pickImageSafely() async {
  try {
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      // User cancelled
      return;
    }

    // Use image...
  } on PlatformException catch (e) {
    if (e.code == 'camera_access_denied') {
      // Permission denied
      _showPermissionDialog();
    } else if (e.code == 'no_available_camera') {
      // No camera on device
      _showNoCameraMessage();
    } else {
      // Other error
      _showErrorMessage(e.message ?? 'Unknown error');
    }
  } catch (e) {
    _showErrorMessage('Failed to pick image: $e');
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│           CAMERA & IMAGE PICKER SUMMARY                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  PACKAGE: image_picker                                   │
│                                                          │
│  PICK IMAGE:                                             │
│  picker.pickImage(source: ImageSource.gallery)          │
│  picker.pickImage(source: ImageSource.camera)           │
│                                                          │
│  PICK MULTIPLE:                                          │
│  picker.pickMultiImage()                                │
│                                                          │
│  PICK VIDEO:                                             │
│  picker.pickVideo(source: ImageSource.camera)           │
│                                                          │
│  OPTIONS:                                                │
│  ├── maxWidth / maxHeight - Resize                      │
│  ├── imageQuality - Compression (0-100)                 │
│  └── preferredCameraDevice - Front/back                 │
│                                                          │
│  REMEMBER:                                               │
│  ├── Add permissions to Info.plist (iOS)                │
│  ├── Add permissions to AndroidManifest (Android)       │
│  └── Handle null (user cancelled)                       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What two sources can `image_picker` get a photo from?

<details>
<summary>Answer</summary>
The camera (`ImageSource.camera`) and the photo gallery (`ImageSource.gallery`).
</details>

**Q2.** What might the picked image be if the user cancels?

<details>
<summary>Answer</summary>
`null`. Always check for null before using the file.
</details>

**Q3.** Why does taking a photo need a permission?

<details>
<summary>Answer</summary>
The camera is sensitive hardware, so the OS asks the user to allow your app to use it.
</details>

---

## Assignment

### Problem 1: Pick the source

The user taps "Choose from gallery." Which `ImageSource` do you pass?

### Problem 2: Handle cancel

After `pickImage`, the result is null. What does that mean and what should you do?

### Problem 3: Then what?

After getting the image file, name one common next step in a real app.

---

## Assignment Answers

### Problem 1: Pick the source

`ImageSource.gallery`.

### Problem 2: Handle cancel

It means the user backed out without picking. Do nothing (or keep the old image), and do not try to use a null file.

### Problem 3: Then what?

Show it on screen (`Image.file(...)`), or upload it to a server / Firebase Storage and save its URL.

---

**Next:** `02-LocationServices.md` - Getting user location
