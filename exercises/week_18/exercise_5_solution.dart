/// Week 18, Exercise 5: Complete Landing Page
///
/// ADVANCED LEVEL - SOLUTION
///
/// This combines all sections from previous exercises into one complete page.
/// For full implementations of each section, refer to exercises 1-4.

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
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showNavbar = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final currentPosition = _scrollController.position.pixels;
    setState(() {
      _showNavbar = currentPosition <= _lastScrollPosition || currentPosition < 100;
      _lastScrollPosition = currentPosition;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(),
                FeaturesSection(),
                TestimonialsSection(),
                PricingSection(),
                FooterSection(),
              ],
            ),
          ),

          // Sticky navigation
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: _showNavbar ? 0 : -80,
            left: 0,
            right: 0,
            child: NavigationBar(),
          ),
        ],
      ),
    );
  }
}

// Navigation Bar
class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              // Logo
              Row(
                children: [
                  Icon(Icons.flutter_dash, color: Colors.blue, size: 32),
                  SizedBox(width: 8),
                  Text(
                    'FlutterFlow Pro',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),

              Spacer(),

              // Menu items
              ...['Features', 'Testimonials', 'Pricing'].map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),

              SizedBox(width: 16),

              // CTA Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF667eea),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hero Section (simplified from Exercise 1)
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      padding: EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to FlutterFlow Pro',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Build beautiful apps faster than ever',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Wrap(
                spacing: 16,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF667eea),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    ),
                    child: Text('Get Started', style: TextStyle(fontSize: 18)),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white, width: 2),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    ),
                    child: Text('Learn More', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Features Section (simplified from Exercise 2)
class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.grey.shade50,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Powerful Features',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 48),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _FeatureCard(Icons.speed, 'Fast', Colors.blue),
                  _FeatureCard(Icons.security, 'Secure', Colors.green),
                  _FeatureCard(Icons.devices, 'Cross-Platform', Colors.purple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  _FeatureCard(this.icon, this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Testimonials Section (simplified from Exercise 3)
class TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'What Our Customers Say',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 48),
              _TestimonialCard(
                'Sarah Johnson',
                'CEO, TechStart',
                'FlutterFlow Pro transformed our development process!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String role;
  final String quote;

  _TestimonialCard(this.name, this.role, this.quote);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      constraints: BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (_) => Icon(Icons.star, color: Colors.amber)),
          ),
          SizedBox(height: 16),
          Text('"$quote"', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          SizedBox(height: 16),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(role, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// Pricing Section (simplified from Exercise 4)
class PricingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.grey.shade50,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Choose Your Plan',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 48),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _PricingCard('Basic', 9, false),
                  _PricingCard('Pro', 29, true),
                  _PricingCard('Enterprise', 99, false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String name;
  final int price;
  final bool isRecommended;

  _PricingCard(this.name, this.price, this.isRecommended);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? Colors.blue : Colors.grey.shade300,
          width: isRecommended ? 3 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isRecommended)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'POPULAR',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          SizedBox(height: 16),
          Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(
            '\$$price',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Text('/month', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecommended ? Colors.blue : Colors.white,
              foregroundColor: isRecommended ? Colors.white : Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text('Get Started'),
          ),
        ],
      ),
    );
  }
}

// Footer Section
class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      color: Color(0xFF2C3E50),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FooterColumn(
                    'Product',
                    ['Features', 'Pricing', 'FAQ', 'Documentation'],
                  ),
                  _FooterColumn(
                    'Company',
                    ['About', 'Blog', 'Careers', 'Contact'],
                  ),
                  _FooterColumn(
                    'Legal',
                    ['Privacy', 'Terms', 'Security', 'Cookies'],
                  ),
                ],
              ),
              SizedBox(height: 32),
              Divider(color: Colors.white24),
              SizedBox(height: 24),
              Text(
                '© 2024 FlutterFlow Pro. All rights reserved.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  _FooterColumn(this.title, this.links);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...links.map((link) => Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            link,
            style: TextStyle(color: Colors.white70),
          ),
        )),
      ],
    );
  }
}
