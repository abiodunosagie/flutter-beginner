/// Week 18, Exercise 3: Testimonials Section
///
/// INTERMEDIATE LEVEL
///
/// Create a testimonials section to show customer reviews:
/// 1. Section title
/// 2. List/grid of testimonial cards
/// 3. Each testimonial has: avatar, name, role, quote, rating
/// 4. Responsive layout
/// 5. Professional styling with shadows
///
/// Learning objectives:
/// - Display social proof
/// - Create testimonial cards
/// - Work with user-generated content layouts

import 'package:flutter/material.dart';

void main() {
  runApp(TestimonialsApp());
}

class TestimonialsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testimonials',
      home: Scaffold(
        body: SingleChildScrollView(
          child: TestimonialsSection(),
        ),
      ),
    );
  }
}

// TODO: Create Testimonial class
// Properties: name, role, quote, rating (1-5), avatarColor

class TestimonialsSection extends StatelessWidget {
  // TODO: Create list of 3-4 testimonials with sample data

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Add styling and padding
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // TODO: Add section title
              // "What Our Customers Say"

              SizedBox(height: 16),

              // TODO: Add subtitle
              // "Don't just take our word for it"

              SizedBox(height: 48),

              // TODO: Create responsive grid/list of testimonial cards
              // Mobile: 1 column, Desktop: 2-3 columns
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Create _buildTestimonialCard method
  // Should include: avatar, quote, name, role, star rating
}
