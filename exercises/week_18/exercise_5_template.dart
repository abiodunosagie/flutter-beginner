/// Week 18, Exercise 5: Complete Landing Page
///
/// ADVANCED LEVEL
///
/// Combine all sections into a complete landing page:
/// 1. Navigation bar with links
/// 2. Hero section
/// 3. Features section
/// 4. Testimonials section
/// 5. Pricing section
/// 6. Contact/Footer section
/// 7. Smooth scrolling between sections
/// 8. Fully responsive throughout
///
/// Learning objectives:
/// - Build complete web pages
/// - Manage multiple sections
/// - Create professional layouts
/// - Implement navigation

import 'package:flutter/material.dart';

void main() {
  runApp(CompleteLandingPage());
}

class CompleteLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Landing Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Add navigation bar (optional: make it sticky)

      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: Add HeroSection()
            // TODO: Add FeaturesSection()
            // TODO: Add TestimonialsSection()
            // TODO: Add PricingSection()
            // TODO: Add FooterSection()
          ],
        ),
      ),
    );
  }
}

// TODO: Copy and adapt sections from previous exercises
// - HeroSection (Exercise 1)
// - FeaturesSection (Exercise 2)
// - TestimonialsSection (Exercise 3)
// - PricingSection (Exercise 4)

// TODO: Create NavigationBar widget
// Should include logo and menu items (Features, Testimonials, Pricing, Contact)

// TODO: Create FooterSection widget
// Include: company info, quick links, social media icons, copyright
