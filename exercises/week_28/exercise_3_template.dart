/// Week 28, Exercise 3: Firebase Cloud Functions Integration
///
/// INTERMEDIATE LEVEL
///
/// Integrate Firebase Cloud Functions with your Flutter app:
/// 1. Add cloud_functions package
/// 2. Create callable function to process data
/// 3. Call function from Flutter
/// 4. Handle function responses
/// 5. Show loading and error states
/// 6. Example: Image processing, data validation, etc.
///
/// Learning objectives:
/// - Use Firebase Cloud Functions
/// - Call serverless functions from Flutter
/// - Handle async function calls

import 'package:flutter/material.dart';
// TODO: Add cloud_functions package
// import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  // TODO: Initialize Firebase
  runApp(CloudFunctionsApp());
}

class CloudFunctionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Functions',
      home: FunctionsScreen(),
    );
  }
}

class FunctionsScreen extends StatefulWidget {
  @override
  _FunctionsScreenState createState() => _FunctionsScreenState();
}

class _FunctionsScreenState extends State<FunctionsScreen> {
  final _textController = TextEditingController();
  bool _isLoading = false;
  String? _result;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cloud Functions')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // TODO: Input field for data to send to function

            SizedBox(height: 16),

            // TODO: Button to call cloud function

            SizedBox(height: 24),

            // TODO: Show loading indicator

            // TODO: Show error if exists

            // TODO: Show result from function
          ],
        ),
      ),
    );
  }

  // TODO: Implement _callFunction() method
  // - Get FirebaseFunctions instance
  // - Create HttpsCallable with function name
  // - Call function with parameters
  // - Handle response
  // - Update UI with result
}
