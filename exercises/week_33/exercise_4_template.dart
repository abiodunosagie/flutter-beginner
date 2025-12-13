/// Week 33, Exercise 4: Complete E-Commerce App with Flavors
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Build a mini e-commerce app with complete flavor support:
/// 1. Different Firebase projects per flavor (dev/staging/prod)
/// 2. Different payment modes (test vs live) with Stripe/PayPal
/// 3. Different app themes per flavor
/// 4. Environment-specific feature sets
/// 5. Proper error handling and logging per flavor
/// 6. Analytics and crash reporting configuration
///
/// Learning objectives:
/// - Real-world multi-flavor app structure
/// - Third-party service integration per flavor
/// - Payment gateway flavor configuration
/// - Firebase multi-environment setup
/// - Production-ready error handling
/// - Theme customization per flavor
///
/// Required packages:
/// - firebase_core: ^2.24.0
/// - firebase_analytics: ^10.7.0
/// - firebase_crashlytics: ^3.4.0
/// - flutter_stripe: ^10.0.0 (for payments)
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev --dart-define=STRIPE_KEY=pk_test_xxx
/// - flutter run --dart-define=FLAVOR=staging --dart-define=STRIPE_KEY=pk_test_xxx
/// - flutter run --dart-define=FLAVOR=prod --dart-define=STRIPE_KEY=pk_live_xxx

import 'package:flutter/material.dart';

// TODO: Create AppFlavor enum

// TODO: Create FirebaseConfig class
// class FirebaseConfig {
//   final String apiKey;
//   final String appId;
//   final String projectId;
//   final String messagingSenderId;
//
//   FirebaseConfig({
//     required this.apiKey,
//     required this.appId,
//     required this.projectId,
//     required this.messagingSenderId,
//   });
//
//   // TODO: Factory for each flavor
//   // factory FirebaseConfig.forFlavor(AppFlavor flavor) {
//   //   switch (flavor) {
//   //     case AppFlavor.dev:
//   //       return FirebaseConfig(
//   //         apiKey: 'dev-api-key',
//   //         appId: 'dev-app-id',
//   //         projectId: 'myapp-dev',
//   //         messagingSenderId: 'dev-sender-id',
//   //       );
//   //     // Add other flavors...
//   //   }
//   // }
// }

// TODO: Create PaymentConfig class
// class PaymentConfig {
//   final String stripePublishableKey;
//   final String merchantId;
//   final bool isTestMode;
//   final String currency;
//
//   PaymentConfig({
//     required this.stripePublishableKey,
//     required this.merchantId,
//     required this.isTestMode,
//     required this.currency,
//   });
//
//   // TODO: Factory for each flavor
//   // factory PaymentConfig.forFlavor(AppFlavor flavor, String stripeKey) {
//   //   switch (flavor) {
//   //     case AppFlavor.dev:
//   //       return PaymentConfig(
//   //         stripePublishableKey: stripeKey, // Test key
//   //         merchantId: 'merchant.dev.myapp',
//   //         isTestMode: true,
//   //         currency: 'USD',
//   //       );
//   //     // Add other flavors...
//   //   }
//   // }
// }

// TODO: Create AppThemeConfig class
// class AppThemeConfig {
//   final Color primaryColor;
//   final Color secondaryColor;
//   final String logoPath;
//   final bool showWatermark;
//
//   AppThemeConfig({
//     required this.primaryColor,
//     required this.secondaryColor,
//   required this.logoPath,
//     required this.showWatermark,
//   });
//
//   // TODO: Factory for each flavor
//   // Different colors and branding per flavor
// }

// TODO: Create Product model
// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final String imageUrl;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.imageUrl,
//   });
// }

// TODO: Create AppConfig class combining all configurations
// class AppConfig {
//   final AppFlavor flavor;
//   final FirebaseConfig firebase;
//   final PaymentConfig payment;
//   final AppThemeConfig theme;
//   final bool enableAnalytics;
//   final bool enableCrashReporting;
//
//   AppConfig({
//     required this.flavor,
//     required this.firebase,
//     required this.payment,
//     required this.theme,
//     required this.enableAnalytics,
//     required this.enableCrashReporting,
//   });
//
//   static AppConfig? _instance;
//   static AppConfig get instance => _instance!;
//   static void initialize({required AppConfig config}) {
//     _instance = config;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Read flavor and configuration from environment
  // const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  // const stripeKey = String.fromEnvironment('STRIPE_KEY', defaultValue: '');

  // TODO: Initialize Firebase for the current flavor
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(...),
  // );

  // TODO: Initialize AppConfig

  // TODO: Initialize Stripe with flavor-specific keys

  // TODO: Setup analytics if enabled

  // TODO: Setup crash reporting if enabled

  runApp(ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get theme configuration
    // final themeConfig = AppConfig.instance.theme;

    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        // TODO: Use flavor-specific theme colors
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // TODO: Mock product list
  final List<dynamic> products = [
    // Add mock products
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Get current config
    // final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          // TODO: Show flavor badge
          // TODO: Show cart icon with badge
        ],
      ),
      body: Column(
        children: [
          // TODO: If dev/staging, show environment banner
          // if (!config.isProduction)
          //   Container(
          //     color: Colors.red,
          //     padding: EdgeInsets.all(8),
          //     child: Row(
          //       children: [
          //         Icon(Icons.warning, color: Colors.white),
          //         Text('TEST MODE - ${config.flavor.name}'),
          //       ],
          //     ),
          //   ),

          // TODO: Product grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 0, // TODO: products.length
              itemBuilder: (context, index) {
                // TODO: Build product card
                return Card(
                  child: Text('Product'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Create ProductCard widget

// TODO: Create ProductDetailScreen

// TODO: Create CartScreen

// TODO: Create CheckoutScreen with flavor-specific payment handling
// class CheckoutScreen extends StatefulWidget {
//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   // TODO: Implement checkout with Stripe
//   // - Use test keys for dev/staging
//   // - Use live keys for production
//   // - Show test mode indicator
//   // - Handle payment processing
//
//   Future<void> _processPayment() async {
//     final paymentConfig = AppConfig.instance.payment;
//
//     if (paymentConfig.isTestMode) {
//       // Show test mode warning
//     }
//
//     // Process payment with Stripe
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Checkout')),
//       body: Container(
//         // TODO: Checkout UI
//       ),
//     );
//   }
// }

/*
FIREBASE CONFIGURATION FILES:

Create separate google-services.json files for each flavor:
- android/app/src/dev/google-services.json
- android/app/src/staging/google-services.json
- android/app/src/prod/google-services.json

Similarly for iOS:
- ios/Runner/Dev/GoogleService-Info.plist
- ios/Runner/Staging/GoogleService-Info.plist
- ios/Runner/Prod/GoogleService-Info.plist

STRIPE CONFIGURATION:
Keep test keys for dev/staging:
- pk_test_...
- sk_test_...

Use live keys only for production:
- pk_live_...
- sk_live_...

BEST PRACTICES:
1. Never commit API keys to git
2. Use different Firebase projects per flavor
3. Always show test mode indicators in dev/staging
4. Disable real payments in dev/staging
5. Use different app bundle IDs per flavor
6. Test payment flows in staging before production
7. Enable extra logging in dev/staging
8. Use different analytics properties per flavor

SECURITY CONSIDERATIONS:
- Store sensitive keys in CI/CD secrets
- Use --dart-define for runtime configuration
- Validate payment amounts server-side
- Implement proper error handling
- Log security events to monitoring service
*/
