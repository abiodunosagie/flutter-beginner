/// Week 30, Exercise 2: Configure App Signing
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Set up proper app signing:
/// 1. Generate keystore
/// 2. Configure key.properties
/// 3. Update build.gradle
/// 4. Sign release build
/// 5. Verify signature
///
/// Learning objectives:
/// - Android app signing
/// - Keystore management
/// - Security best practices

import 'package:flutter/material.dart';

void main() {
  runApp(SigningDemoApp());
}

class SigningDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Signing',
      home: SigningInfoScreen(),
    );
  }
}

class SigningInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Signing Setup')),
      body: Center(
        child: Text('Configure signing - see comments'),
      ),
    );
  }
}

/*
Steps to configure signing:

1. Generate keystore:
   keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

2. Create android/key.properties:
   storePassword=<password>
   keyPassword=<password>
   keyAlias=my-key-alias
   storeFile=<path-to-keystore>

3. Update android/app/build.gradle:
   Add signing configuration

4. Build signed APK:
   flutter build apk --release
*/
