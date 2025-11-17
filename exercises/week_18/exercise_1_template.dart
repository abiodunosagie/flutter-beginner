/// Week 18, Exercise 1: Landing Page - Hero Section with CTA
///
/// BEGINNER LEVEL
///
/// Create a simple landing page hero section:
/// 1. Gradient background
/// 2. Main headline and subheadline
/// 3. Two call-to-action buttons (primary and secondary)
/// 4. Simple centered layout
/// 5. Responsive text sizes
///
/// Learning objectives:
/// - Build hero sections
/// - Use gradient backgrounds
/// - Create call-to-action buttons

import 'package:flutter/material.dart';

void main() {
  runApp(LandingPageApp());
}

class LandingPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            // More sections will be added in later exercises
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Set minimum height to screen height
      // TODO: Add gradient background (blue to purple)
      // TODO: Add padding

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add main headline
            // "Welcome to FlutterFlow Pro"
            // fontSize: 48, fontWeight: bold, color: white

            SizedBox(height: 16),

            // TODO: Add subheadline
            // "Build beautiful apps faster than ever"
            // fontSize: 20, color: white with opacity

            SizedBox(height: 32),

            // TODO: Add two buttons in a row
            // Primary: "Get Started" (white background)
            // Secondary: "Learn More" (transparent with border)
          ],
        ),
      ),
    );
  }
}
