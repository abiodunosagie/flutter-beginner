/// Week 33, Exercise 3: Feature Flags System - SOLUTION
///
/// INTERMEDIATE LEVEL
///
/// This solution demonstrates:
/// 1. Complete feature flags implementation
/// 2. Conditional UI based on feature flags
/// 3. Debug drawer for development
/// 4. Feature toggle management
/// 5. Feature flag viewer and runtime toggles
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev
/// - flutter run --dart-define=FLAVOR=staging
/// - flutter run --dart-define=FLAVOR=prod

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// App Flavor Enum
enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor fromString(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev,
    );
  }
}

// Individual Feature Flag
class Feature {
  final String key;
  final String name;
  final String description;
  bool isEnabled;

  Feature({
    required this.key,
    required this.name,
    required this.description,
    required this.isEnabled,
  });

  Feature copyWith({bool? isEnabled}) {
    return Feature(
      key: key,
      name: name,
      description: description,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

// Feature Flags Manager
class FeatureFlags extends ChangeNotifier {
  Map<String, Feature> _features = {};

  FeatureFlags({required Map<String, Feature> features}) {
    _features = features;
  }

  // Factory for development flavor
  factory FeatureFlags.dev() {
    return FeatureFlags(
      features: {
        'debug_info': Feature(
          key: 'debug_info',
          name: 'Debug Info',
          description: 'Show debug information on screen',
          isEnabled: true,
        ),
        'debug_drawer': Feature(
          key: 'debug_drawer',
          name: 'Debug Drawer',
          description: 'Show debug drawer with dev tools',
          isEnabled: true,
        ),
        'new_ui': Feature(
          key: 'new_ui',
          name: 'New UI',
          description: 'Enable redesigned user interface',
          isEnabled: true,
        ),
        'premium_features': Feature(
          key: 'premium_features',
          name: 'Premium Features',
          description: 'Enable premium tier features',
          isEnabled: true,
        ),
        'experimental': Feature(
          key: 'experimental',
          name: 'Experimental Features',
          description: 'Bleeding edge experimental features',
          isEnabled: true,
        ),
        'analytics': Feature(
          key: 'analytics',
          name: 'Analytics',
          description: 'Send analytics data',
          isEnabled: false, // Usually off in dev to avoid polluting data
        ),
        'crash_reporting': Feature(
          key: 'crash_reporting',
          name: 'Crash Reporting',
          description: 'Report crashes to monitoring service',
          isEnabled: false,
        ),
        'dark_mode': Feature(
          key: 'dark_mode',
          name: 'Dark Mode',
          description: 'Enable dark mode theme',
          isEnabled: true,
        ),
      },
    );
  }

  // Factory for staging flavor
  factory FeatureFlags.staging() {
    return FeatureFlags(
      features: {
        'debug_info': Feature(
          key: 'debug_info',
          name: 'Debug Info',
          description: 'Show debug information on screen',
          isEnabled: true,
        ),
        'debug_drawer': Feature(
          key: 'debug_drawer',
          name: 'Debug Drawer',
          description: 'Show debug drawer with dev tools',
          isEnabled: true, // Keep debug tools in staging
        ),
        'new_ui': Feature(
          key: 'new_ui',
          name: 'New UI',
          description: 'Enable redesigned user interface',
          isEnabled: true, // Test new UI in staging
        ),
        'premium_features': Feature(
          key: 'premium_features',
          name: 'Premium Features',
          description: 'Enable premium tier features',
          isEnabled: true,
        ),
        'experimental': Feature(
          key: 'experimental',
          name: 'Experimental Features',
          description: 'Bleeding edge experimental features',
          isEnabled: false, // No experimental features in staging
        ),
        'analytics': Feature(
          key: 'analytics',
          name: 'Analytics',
          description: 'Send analytics data',
          isEnabled: true, // Test analytics in staging
        ),
        'crash_reporting': Feature(
          key: 'crash_reporting',
          name: 'Crash Reporting',
          description: 'Report crashes to monitoring service',
          isEnabled: true,
        ),
        'dark_mode': Feature(
          key: 'dark_mode',
          name: 'Dark Mode',
          description: 'Enable dark mode theme',
          isEnabled: true,
        ),
      },
    );
  }

  // Factory for production flavor
  factory FeatureFlags.prod() {
    return FeatureFlags(
      features: {
        'debug_info': Feature(
          key: 'debug_info',
          name: 'Debug Info',
          description: 'Show debug information on screen',
          isEnabled: false,
        ),
        'debug_drawer': Feature(
          key: 'debug_drawer',
          name: 'Debug Drawer',
          description: 'Show debug drawer with dev tools',
          isEnabled: false, // Never in production
        ),
        'new_ui': Feature(
          key: 'new_ui',
          name: 'New UI',
          description: 'Enable redesigned user interface',
          isEnabled: false, // Gradual rollout
        ),
        'premium_features': Feature(
          key: 'premium_features',
          name: 'Premium Features',
          description: 'Enable premium tier features',
          isEnabled: true,
        ),
        'experimental': Feature(
          key: 'experimental',
          name: 'Experimental Features',
          description: 'Bleeding edge experimental features',
          isEnabled: false, // Never in production
        ),
        'analytics': Feature(
          key: 'analytics',
          name: 'Analytics',
          description: 'Send analytics data',
          isEnabled: true,
        ),
        'crash_reporting': Feature(
          key: 'crash_reporting',
          name: 'Crash Reporting',
          description: 'Report crashes to monitoring service',
          isEnabled: true,
        ),
        'dark_mode': Feature(
          key: 'dark_mode',
          name: 'Dark Mode',
          description: 'Enable dark mode theme',
          isEnabled: true,
        ),
      },
    );
  }

  // Get feature status
  bool isEnabled(String key) {
    return _features[key]?.isEnabled ?? false;
  }

  // Get all features
  List<Feature> getAllFeatures() {
    return _features.values.toList();
  }

  // Toggle feature (only in dev/staging)
  void toggleFeature(String key, bool value) {
    if (_features.containsKey(key)) {
      _features[key]!.isEnabled = value;
      notifyListeners();
      debugPrint('🎚️ Feature toggled: $key = $value');
    }
  }

  // Convenience getters
  bool get showDebugInfo => isEnabled('debug_info');
  bool get showDebugDrawer => isEnabled('debug_drawer');
  bool get enableNewUI => isEnabled('new_ui');
  bool get enablePremiumFeatures => isEnabled('premium_features');
  bool get enableExperimental => isEnabled('experimental');
  bool get enableAnalytics => isEnabled('analytics');
  bool get enableCrashReporting => isEnabled('crash_reporting');
  bool get enableDarkMode => isEnabled('dark_mode');
}

// App Configuration
class AppConfig {
  final AppFlavor flavor;
  final FeatureFlags features;
  final Color themeColor;

  AppConfig({
    required this.flavor,
    required this.features,
    required this.themeColor,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized');
    }
    return _instance!;
  }

  static void initialize({required AppConfig config}) {
    _instance = config;
    _logConfiguration(config);
  }

  static void _logConfiguration(AppConfig config) {
    debugPrint('═══════════════════════════════════════');
    debugPrint('🎯 Feature Flags Configuration');
    debugPrint('═══════════════════════════════════════');
    debugPrint('Flavor: ${config.flavor.name}');
    debugPrint('Features:');
    for (var feature in config.features.getAllFeatures()) {
      final status = feature.isEnabled ? '✓' : '✗';
      debugPrint('  $status ${feature.name}: ${feature.isEnabled}');
    }
    debugPrint('═══════════════════════════════════════');
  }

  bool get isProduction => flavor == AppFlavor.prod;
  bool get isDevelopment => flavor == AppFlavor.dev;
  bool get isStaging => flavor == AppFlavor.staging;
}

void main() {
  // Read flavor from environment
  const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  final flavor = AppFlavor.fromString(flavorString);

  // Create feature flags based on flavor
  final features = _createFeatureFlags(flavor);

  // Initialize app configuration
  AppConfig.initialize(
    config: AppConfig(
      flavor: flavor,
      features: features,
      themeColor: _getThemeColor(flavor),
    ),
  );

  runApp(MyApp());
}

FeatureFlags _createFeatureFlags(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return FeatureFlags.dev();
    case AppFlavor.staging:
      return FeatureFlags.staging();
    case AppFlavor.prod:
      return FeatureFlags.prod();
  }
}

Color _getThemeColor(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return Colors.red;
    case AppFlavor.staging:
      return Colors.orange;
    case AppFlavor.prod:
      return Colors.blue;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return AnimatedBuilder(
      animation: config.features,
      builder: (context, child) {
        return MaterialApp(
          title: 'Feature Flags Demo',
          debugShowCheckedModeBanner: !config.isProduction,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: config.themeColor,
            brightness: Brightness.light,
          ),
          darkTheme: config.features.enableDarkMode
              ? ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: config.themeColor,
                )
              : null,
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    final features = config.features;

    return AnimatedBuilder(
      animation: features,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Feature Flags Demo'),
            backgroundColor: config.themeColor,
            foregroundColor: Colors.white,
            actions: [
              // Flavor badge
              Center(
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    config.flavor.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          endDrawer: features.showDebugDrawer ? DebugDrawer() : null,
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Header
              Text(
                'Available Features',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),

              // New UI Feature
              if (features.enableNewUI)
                FeatureCard(
                  icon: Icons.new_releases,
                  title: 'New UI Feature',
                  description: 'Experience our redesigned interface',
                  color: Colors.purple,
                  onTap: () => _showFeatureDialog(context, 'New UI'),
                ),

              // Premium Features
              if (features.enablePremiumFeatures)
                FeatureCard(
                  icon: Icons.star,
                  title: 'Premium Features',
                  description: 'Access exclusive premium content',
                  color: Colors.amber,
                  onTap: () => _showFeatureDialog(context, 'Premium'),
                ),

              // Experimental Features
              if (features.enableExperimental)
                FeatureCard(
                  icon: Icons.science,
                  title: 'Experimental Features',
                  description: 'Try our latest experimental features',
                  color: Colors.orange,
                  badge: 'BETA',
                  onTap: () => _showFeatureDialog(context, 'Experimental'),
                ),

              // Dark Mode
              if (features.enableDarkMode)
                FeatureCard(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  description: 'Toggle dark mode theme',
                  color: Colors.indigo,
                  onTap: () => _showFeatureDialog(context, 'Dark Mode'),
                ),

              // Debug Info Card
              if (features.showDebugInfo)
                Card(
                  color: Colors.orange.shade50,
                  margin: EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bug_report, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Debug Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        _buildDebugInfo('Flavor', config.flavor.name.toUpperCase()),
                        _buildDebugInfo('Build Mode', kDebugMode ? 'Debug' : 'Release'),
                        _buildDebugInfo('Analytics', features.enableAnalytics ? 'Enabled' : 'Disabled'),
                        _buildDebugInfo('Crash Reporting', features.enableCrashReporting ? 'Enabled' : 'Disabled'),
                        SizedBox(height: 8),
                        if (features.showDebugDrawer)
                          OutlinedButton.icon(
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: Icon(Icons.settings),
                            label: Text('Open Debug Menu'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Info Card
              SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'About Feature Flags',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Features shown here depend on the current app flavor. '
                        'Different features are enabled in dev, staging, and production.',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      if (features.showDebugDrawer) ...[
                        SizedBox(height: 8),
                        Text(
                          'Tap the menu icon to access debug tools and toggle features.',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDebugInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(featureName),
        content: Text('This is the $featureName feature in action!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String? badge;
  final VoidCallback? onTap;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (badge != null) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class DebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    final features = config.features;

    return Drawer(
      child: AnimatedBuilder(
        animation: features,
        builder: (context, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.red.shade700],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.bug_report, color: Colors.white, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Debug Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      config.flavor.name.toUpperCase(),
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Feature Toggles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...features.getAllFeatures().map((feature) {
                return SwitchListTile(
                  title: Text(feature.name),
                  subtitle: Text(feature.description),
                  value: feature.isEnabled,
                  onChanged: config.isProduction
                      ? null // Disable toggles in production
                      : (value) {
                          features.toggleFeature(feature.key, value);
                        },
                  secondary: Icon(
                    feature.isEnabled ? Icons.check_circle : Icons.cancel,
                    color: feature.isEnabled ? Colors.green : Colors.grey,
                  ),
                );
              }).toList(),
              Divider(),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Clear Cache'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cache cleared!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.list_alt),
                title: Text('View Logs'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logs viewer not implemented')),
                  );
                },
              ),
              if (!config.isProduction)
                ListTile(
                  leading: Icon(Icons.warning_amber),
                  title: Text('Reset to Defaults'),
                  onTap: () {
                    // Reset features to default for current flavor
                    final newFeatures = _createFeatureFlags(config.flavor);
                    for (var feature in newFeatures.getAllFeatures()) {
                      features.toggleFeature(feature.key, feature.isEnabled);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Features reset to defaults')),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
