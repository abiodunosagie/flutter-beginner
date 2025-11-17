/// Week 18, Exercise 4: Pricing Section with Cards
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(PricingApp());
}

class PricingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pricing',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          child: PricingSection(),
        ),
      ),
    );
  }
}

class PricingPlan {
  final String name;
  final double price;
  final List<String> features;
  final bool isRecommended;
  final String buttonText;
  final Color color;

  PricingPlan({
    required this.name,
    required this.price,
    required this.features,
    this.isRecommended = false,
    required this.buttonText,
    required this.color,
  });
}

class PricingSection extends StatelessWidget {
  final List<PricingPlan> plans = [
    PricingPlan(
      name: 'Basic',
      price: 9,
      buttonText: 'Get Started',
      color: Colors.blue,
      features: [
        '1 User',
        '5 Projects',
        'Basic Support',
        '1GB Storage',
        'Mobile App Access',
      ],
    ),
    PricingPlan(
      name: 'Pro',
      price: 29,
      isRecommended: true,
      buttonText: 'Start Free Trial',
      color: Colors.purple,
      features: [
        '5 Users',
        'Unlimited Projects',
        'Priority Support',
        '50GB Storage',
        'All Platform Access',
        'Advanced Analytics',
        'Custom Branding',
      ],
    ),
    PricingPlan(
      name: 'Enterprise',
      price: 99,
      buttonText: 'Contact Sales',
      color: Colors.orange,
      features: [
        'Unlimited Users',
        'Unlimited Projects',
        '24/7 Dedicated Support',
        '500GB Storage',
        'All Platform Access',
        'Advanced Analytics',
        'Custom Branding',
        'API Access',
        'SSO Integration',
      ],
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
                'Choose Your Plan',
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
                'Select the perfect plan for your needs',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48),

              // Responsive pricing grid
              LayoutBuilder(
                builder: (context, constraints) {
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
                      childAspectRatio: columns == 1 ? 0.8 : 0.75,
                    ),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      return PricingCard(plan: plans[index]);
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
}

class PricingCard extends StatefulWidget {
  final PricingPlan plan;

  const PricingCard({Key? key, required this.plan}) : super(key: key);

  @override
  _PricingCardState createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          0,
          _isHovered ? -12 : 0,
          0,
        ),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.plan.isRecommended
                  ? widget.plan.color
                  : Colors.grey.shade300,
              width: widget.plan.isRecommended ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.plan.color.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: _isHovered ? 30 : 15,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recommended badge
              if (widget.plan.isRecommended)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.plan.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (widget.plan.isRecommended) SizedBox(height: 16),

              // Plan name
              Text(
                widget.plan.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),

              SizedBox(height: 16),

              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.plan.color,
                    ),
                  ),
                  Text(
                    '${widget.plan.price.toInt()}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: widget.plan.color,
                    ),
                  ),
                  SizedBox(width: 4),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      '/month',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Features list
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.plan.features.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: widget.plan.color,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.plan.features[index],
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 24),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => print('${widget.plan.name} selected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.plan.isRecommended
                        ? widget.plan.color
                        : Colors.white,
                    foregroundColor: widget.plan.isRecommended
                        ? Colors.white
                        : widget.plan.color,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: widget.plan.color,
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.plan.buttonText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
