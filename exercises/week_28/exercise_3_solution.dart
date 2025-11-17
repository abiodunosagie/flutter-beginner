/// Week 28, Exercise 3: Firebase Cloud Functions Integration
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';
// import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(CloudFunctionsApp());
}

class CloudFunctionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Functions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
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
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cloud Functions Demo')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Cloud Function',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This function converts text to uppercase',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text',
                hintText: 'Type something...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _callToUpperCaseFunction,
              icon: Icon(Icons.cloud),
              label: Text('Call Cloud Function'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 24),

            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Calling cloud function...'),
                  ],
                ),
              ),

            if (_error != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(_error!, style: TextStyle(color: Colors.red.shade900)),
                  ],
                ),
              ),

            if (_result != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Result',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _result!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _callToUpperCaseFunction() async {
    if (_textController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter some text');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      // Real Firebase Functions call:
      // final functions = FirebaseFunctions.instance;
      // final callable = functions.httpsCallable('toUpperCase');
      // final response = await callable.call({
      //   'text': _textController.text,
      // });
      // final result = response.data['result'];

      // Demo simulation
      await Future.delayed(Duration(seconds: 2));
      final result = _textController.text.toUpperCase();

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Function call failed: $e';
        _isLoading = false;
      });
    }
  }
}

/*
Example Cloud Function (functions/index.js):

const functions = require('firebase-functions');

exports.toUpperCase = functions.https.onCall((data, context) => {
  const text = data.text;
  if (!text) {
    throw new functions.https.HttpsError('invalid-argument', 'Text is required');
  }

  return {
    result: text.toUpperCase(),
    processedAt: new Date().toISOString()
  };
});
*/
