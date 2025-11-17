/// Week 28, Exercise 5: Complete Firebase App (Storage + Functions + FCM)
///
/// ADVANCED LEVEL
///
/// Create a comprehensive app combining all Firebase features:
/// 1. User authentication (from Week 27)
/// 2. Upload profile picture to Storage with progress
/// 3. Use Cloud Function to generate thumbnail
/// 4. Send notification when upload completes
/// 5. Store metadata in Firestore
/// 6. Display all user uploads
/// 7. Handle all states (loading, error, success)
///
/// Learning objectives:
/// - Integrate multiple Firebase services
/// - Production-ready Firebase app
/// - Complex data flows

import 'package:flutter/material.dart';

void main() async {
  // TODO: Initialize Firebase
  runApp(ComprehensiveApp());
}

class ComprehensiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Firebase App',
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: Add all necessary state variables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          // TODO: Profile picture with upload
          // TODO: Upload progress
          // TODO: List of uploads from Firestore
          // TODO: Notification status
        ],
      ),
    );
  }

  // TODO: Implement all methods:
  // - _pickAndUploadImage()
  // - _callThumbnailFunction()
  // - _saveToFirestore()
  // - _sendNotification()
}
