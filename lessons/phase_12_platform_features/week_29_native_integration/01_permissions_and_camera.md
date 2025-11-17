# Platform Permissions & Camera Integration

## What You'll Learn

- Requesting permissions (camera, storage, location)
- Camera and gallery access
- Image picker
- Video recording
- Permission handling best practices

## Setup

```yaml
dependencies:
  permission_handler: ^11.0.1
  image_picker: ^1.0.4
  camera: ^0.10.5
```

## Requesting Permissions

```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Request single permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Permission denied
      return false;
    } else if (status.isPermanentlyDenied) {
      // Open app settings
      openAppSettings();
      return false;
    }

    return false;
  }

  // Check permission status
  Future<bool> isCameraGranted() async {
    return await Permission.camera.isGranted;
  }

  // Request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestMultiple() async {
    return await [
      Permission.camera,
      Permission.photos,
      Permission.microphone,
    ].request();
  }

  // Request with dialog
  Future<bool> requestCameraWithRationale(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      // Show rationale
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Camera Permission'),
          content: Text('We need camera access to take photos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Grant'),
            ),
          ],
        ),
      );

      if (shouldRequest == true) {
        return await requestCameraPermission();
      }
    }

    if (status.isPermanentlyDenied) {
      // Show settings dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Required'),
          content: Text('Please enable camera permission in settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        ),
      );
    }

    return false;
  }
}
```

## Image Picker

```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Take photo with camera
  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }

  // Pick video
  Future<File?> pickVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 60),
    );

    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    return images.map((xfile) => File(xfile.path)).toList();
  }
}
```

## Complete Photo Picker UI

```dart
class PhotoPickerScreen extends StatefulWidget {
  @override
  _PhotoPickerScreenState createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<PhotoPickerScreen> {
  final _imagePickerService = ImagePickerService();
  final _permissionService = PermissionService();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: Icon(Icons.photo_library),
                  label: Text('Gallery'),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    // Request permission
    final hasPermission = await _permissionService
        .requestCameraWithRationale(context);

    if (!hasPermission) return;

    // Pick image
    final image = await _imagePickerService.pickImageFromGallery();

    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _takePhoto() async {
    // Request permission
    final hasPermission = await _permissionService
        .requestCameraWithRationale(context);

    if (!hasPermission) return;

    // Take photo
    final photo = await _imagePickerService.takePhoto();

    if (photo != null) {
      setState(() => _selectedImage = photo);
    }
  }
}
```

## Camera Preview (Advanced)

```dart
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();

    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _takePicture,
                child: Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      // Use image.path to access the photo
      Navigator.pop(context, image.path);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }
}
```

## Best Practices

✅ Always request permissions before accessing features
✅ Show rationale before requesting permissions
✅ Handle permanently denied permissions
✅ Provide fallbacks for denied permissions
✅ Compress images before upload
✅ Handle permission status changes
✅ Test on both Android and iOS

## Platform-Specific Configuration

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select photos</string>
```

## Exercises

### Exercise 1: Simple Photo Upload (Beginner)
Pick image and display it

### Exercise 2: Profile Picture (Intermediate)
Camera + Gallery option with crop

### Exercise 3: Multi-Image Upload (Advanced)
Select multiple images, preview, upload to Firebase

You're accessing native features like a pro! 🚀
