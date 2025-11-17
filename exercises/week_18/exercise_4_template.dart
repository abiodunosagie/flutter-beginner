/// Week 18, Exercise 4: Pricing Section with Cards
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Create a pricing section with subscription plans:
/// 1. Three pricing tiers (Basic, Pro, Enterprise)
/// 2. Each card shows: plan name, price, features list, CTA button
/// 3. Highlight the "recommended" plan
/// 4. Responsive grid layout
/// 5. Hover effects on cards
///
/// Learning objectives:
/// - Design pricing tables
/// - Highlight recommended options
/// - Create conversion-focused layouts

import 'package:flutter/material.dart';

void main() {
  runApp(PricingApp());
}

class PricingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pricing',
      home: Scaffold(
        body: SingleChildScrollView(
          child: PricingSection(),
        ),
      ),
    );
  }
}

// TODO: Create PricingPlan class
// Properties: name, price, features (List<String>), isRecommended, buttonText

class PricingSection extends StatelessWidget {
  // TODO: Create list of 3 pricing plans
  // Basic: $9/month, Pro: $29/month (recommended), Enterprise: $99/month

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Add padding and styling
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // TODO: Add section title
              // "Choose Your Plan"

              SizedBox(height: 16),

              // TODO: Add subtitle
              // "Select the perfect plan for your needs"

              SizedBox(height: 48),

              // TODO: Create responsive grid of pricing cards
              // Mobile: 1 column, Tablet: 2 columns, Desktop: 3 columns
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Create _buildPricingCard method
  // Show badge for recommended plan
  // Display all features with checkmarks
  // Add prominent CTA button
}
