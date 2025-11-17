/// Week 30, Exercise 2: Configure App Signing
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(SigningDemoApp());
}

class SigningDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Signing Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SigningInfoScreen(),
    );
  }
}

class SigningInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Signing Guide')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildStepCard(
            '1. Generate Keystore',
            'Create a keystore file to sign your app',
            'keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload',
            Colors.blue,
          ),
          _buildStepCard(
            '2. Create key.properties',
            'Store signing credentials (add to .gitignore!)',
            'storePassword=myPassword\nkeyPassword=myPassword\nkeyAlias=upload\nstoreFile=/path/to/keystore.jks',
            Colors.green,
          ),
          _buildStepCard(
            '3. Update build.gradle',
            'Configure signing in android/app/build.gradle',
            'signingConfigs {\n  release {\n    keyAlias keystoreProperties["keyAlias"]\n  }\n}',
            Colors.orange,
          ),
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Security Warning', 
                           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('• Never commit keystore to version control'),
                  Text('• Keep passwords secure'),
                  Text('• Backup keystore safely'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String title, String description, String code, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(code, style: TextStyle(fontFamily: 'monospace', fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
