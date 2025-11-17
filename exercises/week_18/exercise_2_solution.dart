/// Week 18, Exercise 2: Features Section with Responsive Grid
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(FeaturesApp());
}

class FeaturesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Features Section',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          child: FeaturesSection(),
        ),
      ),
    );
  }
}

class Feature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class FeaturesSection extends StatelessWidget {
  final List<Feature> features = [
    Feature(
      icon: Icons.speed,
      title: 'Lightning Fast',
      description: 'Optimized performance for smooth user experience across all devices',
      color: Colors.blue,
    ),
    Feature(
      icon: Icons.touch_app,
      title: 'Easy to Use',
      description: 'Intuitive interface designed for maximum productivity and ease',
      color: Colors.green,
    ),
    Feature(
      icon: Icons.security,
      title: 'Secure & Safe',
      description: 'Enterprise-grade security to keep your data protected at all times',
      color: Colors.orange,
    ),
    Feature(
      icon: Icons.devices,
      title: 'Multi-Platform',
      description: 'Works seamlessly on web, mobile, and desktop platforms',
      color: Colors.purple,
    ),
    Feature(
      icon: Icons.cloud_done,
      title: 'Cloud Sync',
      description: 'Automatic cloud synchronization keeps your work up to date',
      color: Colors.teal,
    ),
    Feature(
      icon: Icons.support_agent,
      title: '24/7 Support',
      description: 'Round-the-clock customer support to help you succeed',
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section title
              Text(
                'Powerful Features',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              // Section description
              Text(
                'Everything you need to build amazing apps',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48),

              // Responsive grid of features
              LayoutBuilder(
                builder: (context, constraints) {
                  // Determine columns based on width
                  int columns = 1;
                  if (constraints.maxWidth >= 900) {
                    columns = 3;
                  } else if (constraints.maxWidth >= 600) {
                    columns = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      return _buildFeatureCard(features[index]);
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

  Widget _buildFeatureCard(Feature feature) {
    return FeatureCard(feature: feature);
  }
}

class FeatureCard extends StatefulWidget {
  final Feature feature;

  const FeatureCard({Key? key, required this.feature}) : super(key: key);

  @override
  _FeatureCardState createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.feature.color.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
            border: Border.all(
              color: _isHovered
                  ? widget.feature.color.withOpacity(0.3)
                  : Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.feature.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.feature.icon,
                  size: 32,
                  color: widget.feature.color,
                ),
              ),

              SizedBox(height: 20),

              // Title
              Text(
                widget.feature.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),

              SizedBox(height: 12),

              // Description
              Text(
                widget.feature.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
