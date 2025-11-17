/// Week 18, Exercise 3: Testimonials Section
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(TestimonialsApp());
}

class TestimonialsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testimonials',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: TestimonialsSection(),
        ),
      ),
    );
  }
}

class Testimonial {
  final String name;
  final String role;
  final String quote;
  final int rating;
  final Color avatarColor;

  Testimonial({
    required this.name,
    required this.role,
    required this.quote,
    required this.rating,
    required this.avatarColor,
  });
}

class TestimonialsSection extends StatelessWidget {
  final List<Testimonial> testimonials = [
    Testimonial(
      name: 'Sarah Johnson',
      role: 'CEO, TechStart',
      quote: 'FlutterFlow Pro has completely transformed how we build apps. The speed and quality are unmatched. Highly recommended!',
      rating: 5,
      avatarColor: Colors.blue,
    ),
    Testimonial(
      name: 'Michael Chen',
      role: 'Developer, AppWorks',
      quote: 'Best investment we\'ve made. The responsive design features saved us countless hours of development time.',
      rating: 5,
      avatarColor: Colors.green,
    ),
    Testimonial(
      name: 'Emily Rodriguez',
      role: 'Product Manager',
      quote: 'The ease of use combined with powerful features makes this a game-changer for our team. 5 stars!',
      rating: 5,
      avatarColor: Colors.purple,
    ),
    Testimonial(
      name: 'David Park',
      role: 'Freelance Developer',
      quote: 'I can now deliver projects 3x faster. The support team is also incredibly helpful and responsive.',
      rating: 5,
      avatarColor: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section title
              Text(
                'What Our Customers Say',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              // Subtitle
              Text(
                'Don\'t just take our word for it',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48),

              // Responsive grid of testimonials
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns = 1;
                  if (constraints.maxWidth >= 900) {
                    columns = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: columns == 1 ? 1.5 : 1.2,
                    ),
                    itemCount: testimonials.length,
                    itemBuilder: (context, index) {
                      return _buildTestimonialCard(testimonials[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars rating
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < testimonial.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 24,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Quote
          Expanded(
            child: Text(
              '"${testimonial.quote}"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Author info
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: testimonial.avatarColor.withOpacity(0.2),
                child: Text(
                  testimonial.name[0],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: testimonial.avatarColor,
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Name and role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      testimonial.role,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
