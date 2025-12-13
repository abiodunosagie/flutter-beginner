/// Week 30, Exercise 1: Prepare Android Release Build
///
/// BEGINNER LEVEL
///
/// Prepare your app for Android release:
/// 1. Update app name in AndroidManifest.xml
/// 2. Set app icon
/// 3. Update version in pubspec.yaml
/// 4. Build release APK
/// 5. Test release build
///
/// Learning objectives:
/// - Android build configuration
/// - Release vs debug builds
/// - Version management

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App Release',
      home: Scaffold(
        appBar: AppBar(title: Text('Release Build Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.android, size: 100, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Release Build v1.0.0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Release Checklist:', 
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text('✓ App name updated'),
                      Text('✓ App icon set'),
                      Text('✓ Version incremented'),
                      Text('✓ Build tested'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Steps to build Android release:

1. Update pubspec.yaml version: version: 1.0.0+1

2. Build APK:
   flutter build apk --release

3. Build App Bundle (recommended):
   flutter build appbundle --release

4. Find output:
   build/app/outputs/flutter-apk/app-release.apk
   build/app/outputs/bundle/release/app-release.aab
*/
