/// Week 17, Exercise 1: Basic Flutter Web App with Platform Detection
///
/// BEGINNER LEVEL - SOLUTION

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyWebApp());
}

class MyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web Exercise 1'),
      ),
      body: Center(
        child: Container(
          // Platform-specific padding
          padding: EdgeInsets.all(kIsWeb ? 32 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Platform detection indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kIsWeb ? Colors.blue.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  kIsWeb ? 'Running on Web 🌐' : 'Running on Mobile 📱',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kIsWeb ? Colors.blue.shade900 : Colors.green.shade900,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Welcome icon
              Icon(
                Icons.web,
                size: 100,
                color: Colors.blue,
              ),

              SizedBox(height: 24),

              // Welcome message
              Text(
                'Welcome to Flutter Web!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              // Description
              Text(
                'This app adapts to different platforms',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32),

              // Interactive button
              ElevatedButton(
                onPressed: () {
                  final platform = kIsWeb ? 'Web' : 'Mobile';
                  print('Button clicked on $platform!');

                  // Also show in console for web debugging
                  if (kIsWeb) {
                    print('Tip: Open Chrome DevTools (F12) to see console logs');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb ? 48 : 32,
                    vertical: kIsWeb ? 20 : 16,
                  ),
                ),
                child: Text(
                  'Click Me',
                  style: TextStyle(
                    fontSize: kIsWeb ? 18 : 16,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Additional info
              Text(
                kIsWeb
                    ? 'Press F12 to open DevTools'
                    : 'Check your IDE console for output',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
