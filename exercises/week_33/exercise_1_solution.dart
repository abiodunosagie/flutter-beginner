/// Week 33, Exercise 1: Simple Flavor Setup - SOLUTION
///
/// BEGINNER LEVEL
///
/// This solution demonstrates:
/// 1. Creating an enum for app flavors
/// 2. FlavorConfig class to manage flavor-specific settings
/// 3. Displaying current flavor information
/// 4. Different UI elements based on flavor
///
/// To run:
/// - flutter run --flavor dev --dart-define=FLAVOR=dev
/// - flutter run --flavor staging --dart-define=FLAVOR=staging
/// - flutter run --flavor prod --dart-define=FLAVOR=prod

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Enum to define all available app flavors
enum AppFlavor {
  dev,
  staging,
  prod;

  // Helper method to get flavor from string
  static AppFlavor fromString(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev, // Default to dev if not found
    );
  }
}

// FlavorConfig holds all flavor-specific configuration
class FlavorConfig {
  final AppFlavor flavor;
  final String appName;
  final String appSuffix;
  final Color primaryColor;

  FlavorConfig({
    required this.flavor,
    required this.appName,
    required this.appSuffix,
    required this.primaryColor,
  });

  // Singleton instance
  static FlavorConfig? _instance;

  // Getter to access the current flavor configuration
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig not initialized. Call FlavorConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  // Check if instance is initialized
  static bool get isInitialized => _instance != null;

  // Initialize the flavor configuration
  static void initialize({required FlavorConfig config}) {
    _instance = config;
    debugPrint('🎯 Flavor initialized: ${config.flavor.name}');
    debugPrint('📱 App Name: ${config.appName}');
    debugPrint('📦 Package Suffix: ${config.appSuffix}');
  }

  // Helper method to get display name
  String get displayName {
    switch (flavor) {
      case AppFlavor.dev:
        return 'Development';
      case AppFlavor.staging:
        return 'Staging';
      case AppFlavor.prod:
        return 'Production';
    }
  }

  // Helper method to get description
  String get description {
    switch (flavor) {
      case AppFlavor.dev:
        return 'For development and testing';
      case AppFlavor.staging:
        return 'For QA and pre-release testing';
      case AppFlavor.prod:
        return 'Production release for end users';
    }
  }

  // Helper to check if running in production
  bool get isProduction => flavor == AppFlavor.prod;

  // Helper to check if running in development
  bool get isDevelopment => flavor == AppFlavor.dev;
}

void main() {
  // Read flavor from compile-time constant
  // Pass via: flutter run --dart-define=FLAVOR=dev
  const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  final flavor = AppFlavor.fromString(flavorString);

  // Initialize flavor configuration based on the current flavor
  switch (flavor) {
    case AppFlavor.dev:
      FlavorConfig.initialize(
        config: FlavorConfig(
          flavor: AppFlavor.dev,
          appName: 'MyApp Dev',
          appSuffix: '.dev',
          primaryColor: Colors.red,
        ),
      );
      break;
    case AppFlavor.staging:
      FlavorConfig.initialize(
        config: FlavorConfig(
          flavor: AppFlavor.staging,
          appName: 'MyApp Staging',
          appSuffix: '.staging',
          primaryColor: Colors.orange,
        ),
      );
      break;
    case AppFlavor.prod:
      FlavorConfig.initialize(
        config: FlavorConfig(
          flavor: AppFlavor.prod,
          appName: 'MyApp',
          appSuffix: '',
          primaryColor: Colors.green,
        ),
      );
      break;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;

    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: !config.isProduction,
      theme: ThemeData(
        primarySwatch: _getMaterialColor(config.primaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }

  // Helper to create MaterialColor from Color
  MaterialColor _getMaterialColor(Color color) {
    final Map<int, Color> colorSwatch = {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    };
    return MaterialColor(color.value, colorSwatch);
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;
    final flavor = config.flavor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flavor Demo'),
        actions: [
          // Show flavor badge in app bar
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                flavor.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main flavor display
              Center(
                child: Column(
                  children: [
                    Icon(
                      _getFlavorIcon(flavor),
                      size: 80,
                      color: config.primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      config.displayName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: config.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      config.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Flavor badge
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: config.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: config.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    flavor.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Flavor details card
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flavor Configuration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(height: 24),
                      _buildInfoRow('App Name', config.appName),
                      _buildInfoRow('Package Suffix', config.appSuffix.isEmpty ? 'None' : config.appSuffix),
                      _buildInfoRow('Environment', config.displayName),
                      _buildInfoRow('Is Production', config.isProduction ? 'Yes' : 'No'),
                      _buildInfoRow('Is Development', config.isDevelopment ? 'Yes' : 'No'),
                      _buildInfoRow(
                        'Debug Mode',
                        kDebugMode ? 'Enabled' : 'Disabled',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Build information card
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Build Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(height: 24),
                      _buildInfoRow('Build Mode', kDebugMode ? 'Debug' : 'Release'),
                      _buildInfoRow('Profile Mode', kProfileMode ? 'Yes' : 'No'),
                      _buildInfoRow('Release Mode', kReleaseMode ? 'Yes' : 'No'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Usage instructions
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
                            'How to Run',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildCommandText('flutter run --dart-define=FLAVOR=dev'),
                      _buildCommandText('flutter run --dart-define=FLAVOR=staging'),
                      _buildCommandText('flutter run --dart-define=FLAVOR=prod'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandText(String command) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        command,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  IconData _getFlavorIcon(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return Icons.code;
      case AppFlavor.staging:
        return Icons.science;
      case AppFlavor.prod:
        return Icons.rocket_launch;
    }
  }
}
