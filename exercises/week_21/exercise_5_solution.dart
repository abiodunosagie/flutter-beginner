/// Week 21, Exercise 5: Flutter Web Deployment & Optimization - SOLUTION
///
/// This demonstrates deployment and optimization concepts.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() => runApp(DeploymentApp());

class DeploymentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Deployment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DeploymentPage(),
    );
  }
}

class DeploymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deployment & Optimization'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch, size: 80, color: Colors.blue),
                SizedBox(height: 24),
                Text(
                  'Deployment Exercise 5',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Flutter Web Deployment Topics:',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
                ),
                SizedBox(height: 24),
                _buildFeature('Build for Production', 'flutter build web --release'),
                _buildFeature('Deploy to GitHub Pages', 'Free hosting for static sites'),
                _buildFeature('Progressive Web App', 'Install to home screen'),
                _buildFeature('Performance Optimization', 'Lazy loading & code splitting'),
                _buildFeature('SEO & Meta Tags', 'Better search visibility'),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kIsWeb ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: kIsWeb ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        kIsWeb ? Icons.check_circle : Icons.info,
                        color: kIsWeb ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        kIsWeb ? 'Running on Web!' : 'Running on Mobile/Desktop',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kIsWeb ? Colors.green.shade900 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 16, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
