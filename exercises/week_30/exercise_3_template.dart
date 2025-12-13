/// Week 30, Exercise 3: iOS Build and Archive
///
/// INTERMEDIATE LEVEL
///
/// Build and archive for iOS:
/// 1. Open ios/Runner.xcworkspace in Xcode
/// 2. Configure Bundle ID and Team
/// 3. Set version and build number
/// 4. Build for release
/// 5. Archive the app
///
/// Learning objectives:
/// - iOS build process
/// - Xcode configuration
/// - App archiving

import 'package:flutter/material.dart';

void main() {
  runApp(IOSBuildApp());
}

class IOSBuildApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Build',
      home: Scaffold(
        appBar: AppBar(title: Text('iOS Build Guide')),
        body: Center(child: Text('iOS build instructions - see comments')),
      ),
    );
  }
}

/*
iOS Build Steps:

1. Open Xcode: ios/Runner.xcworkspace
2. Select Runner target
3. Set Bundle Identifier
4. Select Team (Apple Developer Account)
5. Update Version/Build in General tab
6. Product → Archive
7. Distribute App → App Store Connect
*/
