/// Week 29, Exercise 2: Camera + Gallery with Permissions
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Handle permissions properly:
/// 1. Add permission_handler package
/// 2. Request camera and storage permissions
/// 3. Handle permission denial
/// 4. Pick from gallery OR take photo
/// 5. Show permission rationale
///
/// Learning objectives:
/// - Request runtime permissions
/// - Handle permission states
/// - Provide user feedback

import 'package:flutter/material.dart';
// TODO: Add permission_handler and image_picker packages

void main() {
  runApp(PermissionsApp());
}

class PermissionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permissions Demo',
      home: CameraPermissionsScreen(),
    );
  }
}

class CameraPermissionsScreen extends StatefulWidget {
  @override
  _CameraPermissionsScreenState createState() => _CameraPermissionsScreenState();
}

class _CameraPermissionsScreenState extends State<CameraPermissionsScreen> {
  // TODO: Implement permission checking and image picking
  // - Check permissions before picking
  // - Request if not granted
  // - Handle permanently denied
  // - Pick image after permission granted

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera & Permissions')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Show permission status
            // TODO: Buttons to request permissions and pick images
          ],
        ),
      ),
    );
  }
}
