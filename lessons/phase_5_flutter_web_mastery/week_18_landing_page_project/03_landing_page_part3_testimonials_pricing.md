# Week 18: Complete Landing Page - Part 3 (Testimonials & Pricing)

## What We're Building

**Testimonials carousel** and **pricing section**:
- 🗣️ Customer testimonial cards
- 🎠 Auto-rotating carousel (no packages!)
- 💰 Pricing comparison cards
- 🔄 Monthly/Yearly toggle
- ⭐ Highlighted "popular" plan

---

## Step 1: Testimonial Model

**lib/models/testimonial.dart**
```dart
class Testimonial {
  final String name;
  final String role;
  final String company;
  final String avatar;
  final String testimonial;
  final int rating;

  Testimonial({
    required this.name,
    required this.role,
    required this.company,
    required this.avatar,
    required this.testimonial,
    required this.rating,
  });
}
```

---

## Step 2: Pricing Plan Model

**lib/models/pricing_plan.dart**
```dart
class PricingPlan {
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isPopular;

  PricingPlan({
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
  });

  double getPrice(bool isYearly) {
    return isYearly ? yearlyPrice / 12 : monthlyPrice;
  }

  double getTotalPrice(bool isYearly) {
    return isYearly ? yearlyPrice : monthlyPrice;
  }

  int getSavingsPercent() {
    final yearlySavings = (monthlyPrice * 12) - yearlyPrice;
    return ((yearlySavings / (monthlyPrice * 12)) * 100).round();
  }
}
```

---

## Step 3: Testimonial Card Widget

**lib/widgets/testimonial_card.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/testimonial.dart';

class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const TestimonialCard({Key? key, required this.testimonial})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < testimonial.rating ? Icons.star : Icons.star_border,
                color: AppColors.accent,
                size: 20,
              );
            }),
          ),

          SizedBox(height: 20),

          // Testimonial text
          Text(
            '"${testimonial.testimonial}"',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textPrimary,
              height: 1.8,
              fontStyle: FontStyle.italic,
            ),
          ),

          SizedBox(height: 24),

          // User info
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  testimonial.name[0],
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                      style: AppTypography.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${testimonial.role} at ${testimonial.company}',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.textSecondary,
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
```

---

## Step 4: Custom Carousel (No Packages!)

**lib/widgets/testimonials_carousel.dart**
```dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/testimonial.dart';
import 'testimonial_card.dart';

class TestimonialsCarousel extends StatefulWidget {
  final List<Testimonial> testimonials;

  const TestimonialsCarousel({Key? key, required this.testimonials})
      : super(key: key);

  @override
  _TestimonialsCarouselState createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<TestimonialsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85, // Show a bit of adjacent cards
    );

    // Auto-rotate every 5 seconds
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < widget.testimonials.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        Container(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.testimonials.length,
            itemBuilder: (context, index) {
              return TestimonialCard(
                testimonial: widget.testimonials[index],
              );
            },
          ),
        ),

        SizedBox(height: 24),

        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.testimonials.length,
            (index) => _buildIndicator(index == _currentPage),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
```

---

## Step 5: Pricing Card Widget

**lib/widgets/pricing_card.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/pricing_plan.dart';
import 'hover_animated_button.dart';

class PricingCard extends StatefulWidget {
  final PricingPlan plan;
  final bool isYearly;

  const PricingCard({
    Key? key,
    required this.plan,
    required this.isYearly,
  }) : super(key: key);

  @override
  _PricingCardState createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final price = widget.plan.getPrice(widget.isYearly);
    final savingsPercent = widget.plan.getSavingsPercent();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: widget.plan.isPopular ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.plan.isPopular
                ? AppColors.primaryDark
                : Colors.grey[200]!,
            width: widget.plan.isPopular ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.plan.isPopular
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 30 : 15,
              offset: Offset(0, _isHovered ? 15 : 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Popular badge
            if (widget.plan.isPopular)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption(context).copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.plan.isPopular) SizedBox(height: 40),

                  // Plan name
                  Text(
                    widget.plan.name,
                    style: AppTypography.h3(context).copyWith(
                      color: widget.plan.isPopular
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Description
                  Text(
                    widget.plan.description,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: widget.plan.isPopular
                          ? AppColors.textWhite.withOpacity(0.9)
                          : AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 24),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$',
                        style: AppTypography.h3(context).copyWith(
                          color: widget.plan.isPopular
                              ? AppColors.textWhite
                              : AppColors.primary,
                        ),
                      ),
                      Text(
                        price.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: widget.plan.isPopular
                              ? AppColors.textWhite
                              : AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          '/month',
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: widget.plan.isPopular
                                ? AppColors.textWhite.withOpacity(0.8)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Savings badge
                  if (widget.isYearly && savingsPercent > 0) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Save $savingsPercent%',
                        style: AppTypography.caption(context).copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 32),

                  // Features list
                  ...widget.plan.features.map((feature) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: widget.plan.isPopular
                                ? AppColors.textWhite
                                : AppColors.success,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTypography.bodyMedium(context).copyWith(
                                color: widget.plan.isPopular
                                    ? AppColors.textWhite
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  Spacer(),

                  SizedBox(height: 24),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: HoverAnimatedButton(
                      text: 'Get Started',
                      isPrimary: !widget.plan.isPopular,
                      onTap: () {
                        print('Selected: ${widget.plan.name}');
                      },
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
}
```

---

## Step 6: Testimonials Section

**lib/sections/testimonials_section.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/responsive/responsive_values.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';
import '../widgets/testimonials_carousel.dart';
import '../models/testimonial.dart';

class TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        vertical: responsive(context, xs: 60, sm: 80, lg: 100),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            SectionHeader(
              badge: 'Testimonials',
              title: 'Loved by thousands of users',
              description:
                  'See what our customers have to say about their experience with FlutterFlow Pro.',
            ),

            SizedBox(height: responsive(context, xs: 40, sm: 60, lg: 80)),

            TestimonialsCarousel(
              testimonials: _getTestimonials(),
            ),
          ],
        ),
      ),
    );
  }

  List<Testimonial> _getTestimonials() {
    return [
      Testimonial(
        name: 'Sarah Johnson',
        role: 'Product Manager',
        company: 'TechCorp',
        avatar: 'S',
        rating: 5,
        testimonial:
            'FlutterFlow Pro has transformed how our team collaborates. The real-time sync is a game-changer for remote work.',
      ),
      Testimonial(
        name: 'Michael Chen',
        role: 'Lead Developer',
        company: 'StartupXYZ',
        avatar: 'M',
        rating: 5,
        testimonial:
            'The best productivity tool I\'ve ever used. It\'s fast, intuitive, and has everything we need to ship features quickly.',
      ),
      Testimonial(
        name: 'Emily Rodriguez',
        role: 'Designer',
        company: 'CreativeStudio',
        avatar: 'E',
        rating: 5,
        testimonial:
            'Beautiful interface, powerful features. Our design team can\'t imagine working without it anymore.',
      ),
    ];
  }
}
```

---

## Step 7: Pricing Section

**lib/sections/pricing_section.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/responsive/responsive_builder.dart';
import '../core/responsive/responsive_values.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';
import '../widgets/pricing_card.dart';
import '../models/pricing_plan.dart';

class PricingSection extends StatefulWidget {
  @override
  _PricingSectionState createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  bool _isYearly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: responsive(context, xs: 60, sm: 80, lg: 100),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            SectionHeader(
              badge: 'Pricing',
              title: 'Simple, transparent pricing',
              description:
                  'Choose the perfect plan for your needs. All plans include a 14-day free trial.',
            ),

            SizedBox(height: 40),

            // Monthly/Yearly toggle
            _buildBillingToggle(),

            SizedBox(height: responsive(context, xs: 40, sm: 60, lg: 80)),

            // Pricing cards
            _buildPricingCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton('Monthly', !_isYearly),
          _buildToggleButton('Yearly', _isYearly),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isYearly = label == 'Yearly';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.textWhite : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCards(BuildContext context) {
    final plans = _getPricingPlans();

    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        final isMobile = deviceSize == DeviceSize.xs;

        if (isMobile) {
          return Column(
            children: plans.map((plan) {
              return Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: PricingCard(plan: plan, isYearly: _isYearly),
              );
            }).toList(),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: plans.map((plan) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: PricingCard(plan: plan, isYearly: _isYearly),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  List<PricingPlan> _getPricingPlans() {
    return [
      PricingPlan(
        name: 'Starter',
        description: 'Perfect for individuals',
        monthlyPrice: 9,
        yearlyPrice: 90,
        features: [
          '5 Projects',
          '10 GB Storage',
          'Basic Analytics',
          'Email Support',
        ],
      ),
      PricingPlan(
        name: 'Professional',
        description: 'Best for teams',
        monthlyPrice: 29,
        yearlyPrice: 290,
        isPopular: true,
        features: [
          'Unlimited Projects',
          '100 GB Storage',
          'Advanced Analytics',
          'Priority Support',
          'Team Collaboration',
          'Custom Integrations',
        ],
      ),
      PricingPlan(
        name: 'Enterprise',
        description: 'For large organizations',
        monthlyPrice: 99,
        yearlyPrice: 990,
        features: [
          'Everything in Pro',
          'Unlimited Storage',
          'Dedicated Support',
          'Custom SLA',
          'SSO & Advanced Security',
          'Onboarding & Training',
        ],
      ),
    ];
  }
}
```

---

## Step 8: Update Main App

**lib/main.dart** (update)
```dart
import 'sections/testimonials_section.dart';  // Add
import 'sections/pricing_section.dart';       // Add

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            FeaturesSection(),
            TestimonialsSection(),  // Add
            PricingSection(),        // Add
          ],
        ),
      ),
    );
  }
}
```

---

## Test Everything

```bash
flutter run -d chrome
```

**What to test:**
1. Testimonials auto-rotate every 5 seconds
2. Click carousel indicators to switch
3. Toggle Monthly/Yearly pricing
4. Hover over pricing cards
5. "Most Popular" badge on middle plan
6. Savings percentage appears on yearly
7. Responsive on all screen sizes

---

## Key Takeaways

1. **Custom carousel** = Built without packages using PageView
2. **Auto-rotation** = Timer for automatic slides
3. **Pricing toggle** = State management for billing cycle
4. **Popular badge** = Visual hierarchy for recommendations
5. **Savings calculation** = Dynamic percentage display
6. **Responsive layout** = Stack on mobile, row on desktop

---

## What's Next?

**Part 4:** Contact Form & Footer
- Working contact form with validation
- Newsletter signup
- Footer with links and social media
- Smooth scroll to sections
- Final touches and deployment prep

Almost done with the landing page! 🎉✨
