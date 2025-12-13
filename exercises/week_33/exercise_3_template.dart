/// Week 33, Exercise 3: Feature Flags System
///
/// INTERMEDIATE LEVEL
///
/// Create a feature flags system that changes per flavor:
/// 1. Implement feature flags that enable/disable features per flavor
/// 2. Create UI that shows/hides features based on flags
/// 3. Debug drawer that only shows in dev flavor
/// 4. Feature toggle management system
/// 5. Runtime feature flag updates (dev/staging only)
///
/// Learning objectives:
/// - Feature flag implementation
/// - Conditional UI based on flavor
/// - Debug tools for development
/// - Feature rollout strategies
/// - A/B testing preparation
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev
/// - flutter run --dart-define=FLAVOR=staging
/// - flutter run --dart-define=FLAVOR=prod

import 'package:flutter/material.dart';

// TODO: Create AppFlavor enum

// TODO: Create FeatureFlags class
// class FeatureFlags {
//   final bool showDebugInfo;
//   final bool enableNewUI;
//   final bool enablePremiumFeatures;
//   final bool enableAnalytics;
//   final bool enableCrashReporting;
//   final bool showDebugDrawer;
//   final bool enableExperimentalFeatures;
//
//   FeatureFlags({
//     required this.showDebugInfo,
//     required this.enableNewUI,
//     required this.enablePremiumFeatures,
//     required this.enableAnalytics,
//     required this.enableCrashReporting,
//     required this.showDebugDrawer,
//     required this.enableExperimentalFeatures,
//   });
//
//   // TODO: Factory constructor for each flavor
//   // factory FeatureFlags.forFlavor(AppFlavor flavor) {
//   //   switch (flavor) {
//   //     case AppFlavor.dev:
//   //       return FeatureFlags(...); // All features enabled
//   //     case AppFlavor.staging:
//   //       return FeatureFlags(...); // Some features enabled
//   //     case AppFlavor.prod:
//   //       return FeatureFlags(...); // Only production-ready features
//   //   }
//   // }
// }

// TODO: Create AppConfig class
// class AppConfig {
//   final AppFlavor flavor;
//   final FeatureFlags features;
//
//   AppConfig({required this.flavor, required this.features});
//
//   static AppConfig? _instance;
//   static AppConfig get instance => _instance!;
//   static void initialize({required AppConfig config}) {
//     _instance = config;
//   }
// }

void main() {
  // TODO: Initialize AppConfig with flavor and feature flags

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Flags Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get feature flags from AppConfig
    // final features = AppConfig.instance.features;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Flags Demo'),
        actions: [
          // TODO: Show debug icon only if debug drawer is enabled
          // if (features.showDebugDrawer)
          //   IconButton(
          //     icon: Icon(Icons.bug_report),
          //     onPressed: () {
          //       // Open debug drawer
          //     },
          //   ),
        ],
      ),
      // TODO: Add debug drawer (only for dev flavor)
      // endDrawer: features.showDebugDrawer ? DebugDrawer() : null,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // TODO: Feature 1 - Only show if enabled
          // if (features.enableNewUI)
          Card(
            child: ListTile(
              leading: Icon(Icons.new_releases),
              title: Text('New UI Feature'),
              subtitle: Text('This feature uses the new design'),
            ),
          ),

          // TODO: Feature 2 - Premium features
          // if (features.enablePremiumFeatures)
          Card(
            child: ListTile(
              leading: Icon(Icons.star),
              title: Text('Premium Feature'),
              subtitle: Text('Only for premium users'),
            ),
          ),

          // TODO: Feature 3 - Experimental
          // if (features.enableExperimentalFeatures)
          Card(
            child: ListTile(
              leading: Icon(Icons.science),
              title: Text('Experimental Feature'),
              subtitle: Text('Still in testing'),
            ),
          ),

          // TODO: Show debug info card if enabled
          // if (features.showDebugInfo)
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Debug Information',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Flavor: ???'),
                  Text('Build: ???'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Create DebugDrawer widget (only shown in dev)
// class DebugDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.red),
//             child: Text('Debug Menu',
//                 style: TextStyle(color: Colors.white, fontSize: 24)),
//           ),
//           // TODO: Add debug options
//           // - View feature flags
//           // - Toggle features (in dev only)
//           // - View logs
//           // - Clear cache
//         ],
//       ),
//     );
//   }
// }

/*
FEATURE FLAG BEST PRACTICES:

1. Feature flags should be environment-specific
2. Use flags to gradually roll out features
3. Keep flags temporary - remove after feature is stable
4. Document each flag and its purpose
5. Use analytics to track feature usage
6. Have a kill switch for problematic features
7. Test with flags both on and off

COMMON USE CASES:
- A/B testing
- Gradual feature rollout
- Quick feature disable in emergency
- Beta features for specific users
- Platform-specific features
- Experimental features in dev only

ADVANCED CONCEPTS:
- Remote config integration
- User-specific flags
- Percentage-based rollouts
- Time-based flags
- Geographic flags
*/
