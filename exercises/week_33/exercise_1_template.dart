/// Week 33, Exercise 1: Simple Flavor Setup
///
/// BEGINNER LEVEL
///
/// Create a basic Flutter app with different flavors (dev, staging, prod):
/// 1. Configure three flavors in your app
/// 2. Display the current flavor name on the screen
/// 3. Show different app names for each flavor
/// 4. Use different app icons (optional for this exercise)
///
/// Learning objectives:
/// - Understanding what flavors are
/// - Basic flavor configuration
/// - Accessing flavor information at runtime
/// - Different app configurations per flavor
///
/// SETUP INSTRUCTIONS:
/// To run with different flavors, use:
/// - flutter run --flavor dev
/// - flutter run --flavor staging
/// - flutter run --flavor prod
///
/// Note: This template shows the Dart code. You'll also need to:
/// 1. Update android/app/build.gradle with flavor configurations
/// 2. Update ios/Runner.xcodeproj with schemes (for iOS)
/// 3. Create flavor-specific configurations

import 'package:flutter/material.dart';

// TODO: Create an enum for different app flavors
// enum AppFlavor { dev, staging, prod }

// TODO: Create a FlavorConfig class to hold flavor-specific values
// class FlavorConfig {
//   final AppFlavor flavor;
//   final String appName;
//   final String appSuffix;
//
//   FlavorConfig({
//     required this.flavor,
//     required this.appName,
//     required this.appSuffix,
//   });
//
//   // TODO: Add a static instance to hold current flavor
//   // static FlavorConfig? _instance;
//
//   // TODO: Add a static getter to access the current instance
//   // static FlavorConfig get instance => _instance!;
//
//   // TODO: Add a static method to initialize the flavor
//   // static void initialize({required FlavorConfig config}) {
//   //   _instance = config;
//   // }
// }

void main() {
  // TODO: Initialize the flavor configuration
  // For dev:
  // FlavorConfig.initialize(
  //   config: FlavorConfig(
  //     flavor: AppFlavor.dev,
  //     appName: 'MyApp Dev',
  //     appSuffix: '.dev',
  //   ),
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Use the flavor-specific app name
      title: 'My App', // Replace with FlavorConfig.instance.appName
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get the current flavor information
    // final flavor = FlavorConfig.instance.flavor;
    // final appName = FlavorConfig.instance.appName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flavor Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Display the current flavor name
            Text(
              'Current Flavor: ???',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // TODO: Display the app name for this flavor
            Text(
              'App Name: ???',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // TODO: Add a colored badge based on flavor
            // Dev = Red, Staging = Orange, Prod = Green
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey, // TODO: Change based on flavor
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ENVIRONMENT BADGE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            // TODO: Show additional flavor-specific information
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flavor Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // TODO: Add flavor-specific details
                    Text('Package Suffix: ???'),
                    Text('Build Type: ???'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Helper method to get color based on flavor
  // Color _getFlavorColor(AppFlavor flavor) {
  //   switch (flavor) {
  //     case AppFlavor.dev:
  //       return Colors.red;
  //     case AppFlavor.staging:
  //       return Colors.orange;
  //     case AppFlavor.prod:
  //       return Colors.green;
  //   }
  // }
}

/*
ANDROID BUILD.GRADLE CONFIGURATION (android/app/build.gradle):

Add this inside the android block:

    flavorDimensions "environment"

    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp Dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp Staging"
        }
        prod {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }

IOS CONFIGURATION:
For iOS, you'll need to create different schemes in Xcode for each flavor.
This is more involved and typically done through the Xcode UI.

ALTERNATIVE: Use command line arguments:
You can also pass the flavor as a compile-time constant:
flutter run --dart-define=FLAVOR=dev
*/
