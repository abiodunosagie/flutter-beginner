/// Week 33, Exercise 5: Production-Ready Multi-Flavor Setup - SOLUTION
///
/// ADVANCED LEVEL
///
/// This solution demonstrates a complete production-ready flavor system with:
/// 1. Comprehensive configuration management
/// 2. Secrets management
/// 3. Full logging and monitoring
/// 4. Remote config integration
/// 5. Error handling and crash reporting
/// 6. CI/CD-ready structure
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev --dart-define-from-file=.env.dev
/// - flutter run --dart-define=FLAVOR=staging --dart-define-from-file=.env.staging
/// - flutter run --dart-define=FLAVOR=prod --dart-define-from-file=.env.prod

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:developer' as developer;

// ============================================================================
// ENUMS AND CONSTANTS
// ============================================================================

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

  bool get isDevelopment => this == AppFlavor.dev;
  bool get isStaging => this == AppFlavor.staging;
  bool get isProduction => this == AppFlavor.prod;
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical;

  bool get isDebug => this == LogLevel.debug;
  bool get isInfo => index >= LogLevel.info.index;
  bool get isWarning => index >= LogLevel.warning.index;
  bool get isError => index >= LogLevel.error.index;
}

// ============================================================================
// CONFIGURATION CLASSES
// ============================================================================

/// Base configuration interface
abstract class EnvConfig {
  AppFlavor get flavor;

  // API Configuration
  String get apiBaseUrl;
  String get apiKey;
  Duration get apiTimeout;
  int get apiMaxRetries;

  // Firebase Configuration (mocked for this example)
  String get firebaseApiKey;
  String get firebaseAppId;
  String get firebaseProjectId;
  String get firebaseMessagingSenderId;

  // Feature Flags
  Map<String, bool> get localFeatureFlags;
  bool get enableRemoteConfig;

  // Services
  bool get enableAnalytics;
  bool get enableCrashReporting;
  bool get enablePerformanceMonitoring;

  // Payment Configuration
  String get stripePublishableKey;
  String get paymentMerchantId;
  bool get isPaymentTestMode;

  // Logging
  LogLevel get logLevel;
  bool get enableNetworkLogging;
  bool get enablePerformanceLogging;
  bool get enableVerboseLogging;

  // Security
  List<String> get certificatePins;
  bool get enableSSLPinning;

  // UI
  Color get primaryColor;
  String get appName;
  bool get showDebugBanner;

  /// Validate configuration on startup
  void validate() {
    final errors = <String>[];

    // Validate required fields
    if (apiBaseUrl.isEmpty) errors.add('API base URL is required');
    if (apiKey.isEmpty && flavor.isProduction) {
      errors.add('API key is required for production');
    }
    if (firebaseProjectId.isEmpty) errors.add('Firebase project ID is required');
    if (stripePublishableKey.isEmpty && flavor.isProduction) {
      errors.add('Stripe key is required for production');
    }

    // Validate production-specific requirements
    if (flavor.isProduction) {
      if (!stripePublishableKey.startsWith('pk_live_')) {
        errors.add('Production must use live Stripe key');
      }
      if (enableVerboseLogging) {
        errors.add('Verbose logging must be disabled in production');
      }
      if (showDebugBanner) {
        errors.add('Debug banner must be disabled in production');
      }
    }

    // Validate non-production specific requirements
    if (!flavor.isProduction) {
      if (stripePublishableKey.isNotEmpty &&
          !stripePublishableKey.startsWith('pk_test_')) {
        errors.add('Non-production environments must use test Stripe key');
      }
    }

    if (errors.isNotEmpty) {
      throw ConfigurationException(
        'Configuration validation failed:\n${errors.map((e) => '  - $e').join('\n')}',
      );
    }
  }
}

/// Development environment configuration
class DevEnvConfig implements EnvConfig {
  @override
  final AppFlavor flavor = AppFlavor.dev;

  @override
  String get apiBaseUrl => 'https://dev-api.example.com';

  @override
  String get apiKey => SecretsManager.getOptionalSecret('API_KEY') ?? 'dev_default_key';

  @override
  Duration get apiTimeout => Duration(seconds: 60);

  @override
  int get apiMaxRetries => 1;

  @override
  String get firebaseApiKey => SecretsManager.getOptionalSecret('FIREBASE_API_KEY') ?? 'dev_firebase_key';

  @override
  String get firebaseAppId => '1:123456789:android:dev-app-id';

  @override
  String get firebaseProjectId => 'myapp-dev';

  @override
  String get firebaseMessagingSenderId => '123456789';

  @override
  Map<String, bool> get localFeatureFlags => {
        'new_ui': true,
        'premium_features': true,
        'experimental_features': true,
        'debug_tools': true,
      };

  @override
  bool get enableRemoteConfig => false; // Use local flags in dev

  @override
  bool get enableAnalytics => false; // Don't pollute analytics in dev

  @override
  bool get enableCrashReporting => false;

  @override
  bool get enablePerformanceMonitoring => false;

  @override
  String get stripePublishableKey =>
      SecretsManager.getOptionalSecret('STRIPE_KEY') ?? 'pk_test_dev_default';

  @override
  String get paymentMerchantId => 'merchant.dev.myapp';

  @override
  bool get isPaymentTestMode => true;

  @override
  LogLevel get logLevel => LogLevel.debug;

  @override
  bool get enableNetworkLogging => true;

  @override
  bool get enablePerformanceLogging => true;

  @override
  bool get enableVerboseLogging => true;

  @override
  List<String> get certificatePins => []; // No pinning in dev

  @override
  bool get enableSSLPinning => false;

  @override
  Color get primaryColor => Colors.red;

  @override
  String get appName => 'MyApp Dev';

  @override
  bool get showDebugBanner => true;

  @override
  void validate() {
    // Dev has relaxed validation
    if (apiBaseUrl.isEmpty) {
      throw ConfigurationException('API base URL is required');
    }
  }
}

/// Staging environment configuration
class StagingEnvConfig implements EnvConfig {
  @override
  final AppFlavor flavor = AppFlavor.staging;

  @override
  String get apiBaseUrl => 'https://staging-api.example.com';

  @override
  String get apiKey => SecretsManager.getOptionalSecret('API_KEY') ?? 'staging_default_key';

  @override
  Duration get apiTimeout => Duration(seconds: 30);

  @override
  int get apiMaxRetries => 2;

  @override
  String get firebaseApiKey => SecretsManager.getOptionalSecret('FIREBASE_API_KEY') ?? 'staging_firebase_key';

  @override
  String get firebaseAppId => '1:987654321:android:staging-app-id';

  @override
  String get firebaseProjectId => 'myapp-staging';

  @override
  String get firebaseMessagingSenderId => '987654321';

  @override
  Map<String, bool> get localFeatureFlags => {
        'new_ui': true,
        'premium_features': true,
        'experimental_features': false, // No experimental in staging
        'debug_tools': true,
      };

  @override
  bool get enableRemoteConfig => true; // Test remote config in staging

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  String get stripePublishableKey =>
      SecretsManager.getOptionalSecret('STRIPE_KEY') ?? 'pk_test_staging_default';

  @override
  String get paymentMerchantId => 'merchant.staging.myapp';

  @override
  bool get isPaymentTestMode => true;

  @override
  LogLevel get logLevel => LogLevel.info;

  @override
  bool get enableNetworkLogging => true;

  @override
  bool get enablePerformanceLogging => true;

  @override
  bool get enableVerboseLogging => false;

  @override
  List<String> get certificatePins => []; // Optional pinning in staging

  @override
  bool get enableSSLPinning => false;

  @override
  Color get primaryColor => Colors.orange;

  @override
  String get appName => 'MyApp Staging';

  @override
  bool get showDebugBanner => true;

  @override
  void validate() {
    // Staging uses base validation
    final base = _BaseValidator();
    base.validate(this);
  }
}

/// Production environment configuration
class ProdEnvConfig implements EnvConfig {
  @override
  final AppFlavor flavor = AppFlavor.prod;

  @override
  String get apiBaseUrl => 'https://api.example.com';

  @override
  String get apiKey => SecretsManager.getRequiredSecret('API_KEY');

  @override
  Duration get apiTimeout => Duration(seconds: 15);

  @override
  int get apiMaxRetries => 3;

  @override
  String get firebaseApiKey => SecretsManager.getRequiredSecret('FIREBASE_API_KEY');

  @override
  String get firebaseAppId => '1:555666777:android:prod-app-id';

  @override
  String get firebaseProjectId => 'myapp-prod';

  @override
  String get firebaseMessagingSenderId => '555666777';

  @override
  Map<String, bool> get localFeatureFlags => {
        'new_ui': false, // Gradual rollout
        'premium_features': true,
        'experimental_features': false,
        'debug_tools': false,
      };

  @override
  bool get enableRemoteConfig => true;

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  String get stripePublishableKey => SecretsManager.getRequiredSecret('STRIPE_KEY');

  @override
  String get paymentMerchantId => 'merchant.myapp';

  @override
  bool get isPaymentTestMode => false;

  @override
  LogLevel get logLevel => LogLevel.warning;

  @override
  bool get enableNetworkLogging => false;

  @override
  bool get enablePerformanceLogging => true;

  @override
  bool get enableVerboseLogging => false;

  @override
  List<String> get certificatePins => [
        // Production certificate pins
        'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
      ];

  @override
  bool get enableSSLPinning => true;

  @override
  Color get primaryColor => Colors.blue;

  @override
  String get appName => 'MyApp';

  @override
  bool get showDebugBanner => false;

  @override
  void validate() {
    final base = _BaseValidator();
    base.validate(this);

    // Additional production-specific validation
    final errors = <String>[];

    if (!stripePublishableKey.startsWith('pk_live_')) {
      errors.add('Production must use live Stripe key (pk_live_...)');
    }

    if (enableVerboseLogging) {
      errors.add('Verbose logging must be disabled in production');
    }

    if (errors.isNotEmpty) {
      throw ConfigurationException(
        'Production configuration validation failed:\n${errors.map((e) => '  - $e').join('\n')}',
      );
    }
  }
}

class _BaseValidator {
  void validate(EnvConfig config) {
    final errors = <String>[];

    if (config.apiBaseUrl.isEmpty) errors.add('API base URL is required');
    if (config.firebaseProjectId.isEmpty) errors.add('Firebase project ID is required');

    if (errors.isNotEmpty) {
      throw ConfigurationException(
        'Configuration validation failed:\n${errors.map((e) => '  - $e').join('\n')}',
      );
    }
  }
}

// ============================================================================
// EXCEPTIONS
// ============================================================================

class ConfigurationException implements Exception {
  final String message;
  ConfigurationException(this.message);

  @override
  String toString() => 'ConfigurationException: $message';
}

// ============================================================================
// SECRETS MANAGEMENT
// ============================================================================

class SecretsManager {
  static String getRequiredSecret(String key) {
    const value = String.fromEnvironment(key);
    if (value.isEmpty) {
      throw ConfigurationException(
        'Required secret "$key" not found. '
        'Pass it via: --dart-define=$key=value',
      );
    }
    return value;
  }

  static String? getOptionalSecret(String key, {String? defaultValue}) {
    const value = String.fromEnvironment(key);
    if (value.isEmpty) {
      return defaultValue;
    }
    return value;
  }

  static bool hasSecret(String key) {
    const value = String.fromEnvironment(key);
    return value.isNotEmpty;
  }
}

// ============================================================================
// LOGGING SERVICE
// ============================================================================

class LoggingService {
  final EnvConfig config;
  final String _prefix;

  LoggingService(this.config, {String prefix = 'APP'}) : _prefix = prefix;

  void debug(String message, [Map<String, dynamic>? data]) {
    if (config.logLevel.isDebug) {
      _log(LogLevel.debug, message, data);
    }
  }

  void info(String message, [Map<String, dynamic>? data]) {
    if (config.logLevel.isInfo) {
      _log(LogLevel.info, message, data);
    }
  }

  void warning(String message, [Map<String, dynamic>? data]) {
    if (config.logLevel.isWarning) {
      _log(LogLevel.warning, message, data);
    }
  }

  void error(String message, [dynamic error, StackTrace? stackTrace, Map<String, dynamic>? data]) {
    if (config.logLevel.isError) {
      _log(LogLevel.error, message, data);
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null && config.enableVerboseLogging) {
        debugPrint('  Stack trace:\n$stackTrace');
      }
    }
  }

  void _log(LogLevel level, String message, Map<String, dynamic>? data) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(8);
    final output = '[$timestamp] [$_prefix] [$levelStr] $message';

    debugPrint(output);

    if (data != null && config.enableVerboseLogging) {
      debugPrint('  Data: $data');
    }

    // In production, ship logs to remote service
    if (config.flavor.isProduction && level.isError) {
      _shipToRemoteLogging(level, message, data);
    }
  }

  void _shipToRemoteLogging(LogLevel level, String message, Map<String, dynamic>? data) {
    // In a real app, send to service like Datadog, Sentry, etc.
    developer.log(
      message,
      name: _prefix,
      level: level.index,
      error: data,
    );
  }
}

// ============================================================================
// ANALYTICS SERVICE
// ============================================================================

class AnalyticsService {
  final EnvConfig config;
  final LoggingService logger;

  AnalyticsService(this.config, this.logger);

  Future<void> initialize() async {
    if (!config.enableAnalytics) {
      logger.info('Analytics disabled for ${config.flavor.name}');
      return;
    }

    logger.info('Initializing analytics for ${config.flavor.name}');
    // In a real app: await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    if (!config.enableAnalytics) return;

    logger.debug('Analytics event: $name', parameters);
    // In a real app: await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }

  Future<void> setUserProperty(String name, String value) async {
    if (!config.enableAnalytics) return;

    logger.debug('Analytics user property: $name = $value');
    // In a real app: await FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
  }

  Future<void> setUserId(String userId) async {
    if (!config.enableAnalytics) return;

    logger.debug('Analytics user ID: $userId');
    // In a real app: await FirebaseAnalytics.instance.setUserId(id: userId);
  }
}

// ============================================================================
// REMOTE CONFIG SERVICE
// ============================================================================

class RemoteConfigService {
  final EnvConfig config;
  final LoggingService logger;
  final Map<String, dynamic> _cache = {};
  bool _initialized = false;

  RemoteConfigService(this.config, this.logger);

  Future<void> initialize() async {
    if (!config.enableRemoteConfig) {
      logger.info('Remote config disabled for ${config.flavor.name}');
      return;
    }

    logger.info('Initializing remote config');

    try {
      // In a real app:
      // final remoteConfig = FirebaseRemoteConfig.instance;
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(...));
      // await remoteConfig.fetchAndActivate();

      // For this example, use local flags
      _cache.addAll(config.localFeatureFlags);
      _initialized = true;

      logger.info('Remote config initialized successfully');
    } catch (e, stack) {
      logger.error('Failed to initialize remote config', e, stack);
      // Fallback to local flags
      _cache.addAll(config.localFeatureFlags);
    }
  }

  bool getFeatureFlag(String key, bool defaultValue) {
    // Try remote config first
    if (_cache.containsKey(key)) {
      return _cache[key] as bool;
    }

    // Fallback to local flags
    if (config.localFeatureFlags.containsKey(key)) {
      return config.localFeatureFlags[key]!;
    }

    return defaultValue;
  }

  String getString(String key, String defaultValue) {
    return _cache[key]?.toString() ?? defaultValue;
  }

  int getInt(String key, int defaultValue) {
    final value = _cache[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  double getDouble(String key, double defaultValue) {
    final value = _cache[key];
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
}

// ============================================================================
// CRASH REPORTING SERVICE
// ============================================================================

class CrashReportingService {
  final EnvConfig config;
  final LoggingService logger;

  CrashReportingService(this.config, this.logger);

  Future<void> initialize() async {
    if (!config.enableCrashReporting) {
      logger.info('Crash reporting disabled for ${config.flavor.name}');
      return;
    }

    logger.info('Initializing crash reporting');
    // In a real app:
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  void recordError(dynamic error, StackTrace? stack, {bool fatal = false}) {
    if (!config.enableCrashReporting) return;

    logger.error('Recording crash', error, stack);
    // In a real app:
    // FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
  }

  void log(String message) {
    if (!config.enableCrashReporting) return;

    // In a real app:
    // FirebaseCrashlytics.instance.log(message);
  }
}

// ============================================================================
// APP INITIALIZER
// ============================================================================

class AppInitializer {
  static late EnvConfig config;
  static late LoggingService logger;
  static late AnalyticsService analytics;
  static late RemoteConfigService remoteConfig;
  static late CrashReportingService crashReporting;

  static Future<void> initialize(EnvConfig envConfig) async {
    config = envConfig;

    // 1. Validate configuration
    logger = LoggingService(config);
    logger.info('═══════════════════════════════════════════════════');
    logger.info('🚀 Initializing ${config.appName}');
    logger.info('Environment: ${config.flavor.name.toUpperCase()}');
    logger.info('═══════════════════════════════════════════════════');

    try {
      config.validate();
      logger.info('✓ Configuration validated successfully');
    } catch (e) {
      logger.error('✗ Configuration validation failed', e);
      rethrow;
    }

    // 2. Initialize services
    analytics = AnalyticsService(config, logger);
    remoteConfig = RemoteConfigService(config, logger);
    crashReporting = CrashReportingService(config, logger);

    // 3. Setup global error handlers
    _setupErrorHandlers();

    // 4. Initialize Firebase (mocked)
    await _initializeFirebase();

    // 5. Initialize analytics
    await analytics.initialize();

    // 6. Initialize crash reporting
    await crashReporting.initialize();

    // 7. Fetch remote config
    await remoteConfig.initialize();

    // 8. Set analytics properties
    await analytics.setUserProperty('environment', config.flavor.name);

    // 9. Log initialization complete
    logger.info('═══════════════════════════════════════════════════');
    logger.info('✓ Initialization complete');
    logger.info('═══════════════════════════════════════════════════');

    // 10. Log configuration summary
    _logConfigurationSummary();
  }

  static void _setupErrorHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.error('Flutter error', details.exception, details.stack);
      crashReporting.recordError(details.exception, details.stack, fatal: true);
    };
  }

  static Future<void> _initializeFirebase() async {
    logger.info('Initializing Firebase');
    logger.info('  Project: ${config.firebaseProjectId}');
    logger.info('  App ID: ${config.firebaseAppId}');

    // In a real app:
    // await Firebase.initializeApp(
    //   options: FirebaseOptions(
    //     apiKey: config.firebaseApiKey,
    //     appId: config.firebaseAppId,
    //     messagingSenderId: config.firebaseMessagingSenderId,
    //     projectId: config.firebaseProjectId,
    //   ),
    // );

    logger.info('✓ Firebase initialized');
  }

  static void _logConfigurationSummary() {
    if (!config.enableVerboseLogging) return;

    logger.debug('Configuration Summary:');
    logger.debug('  API URL: ${config.apiBaseUrl}');
    logger.debug('  API Timeout: ${config.apiTimeout.inSeconds}s');
    logger.debug('  Payment Mode: ${config.isPaymentTestMode ? "TEST" : "LIVE"}');
    logger.debug('  Analytics: ${config.enableAnalytics ? "Enabled" : "Disabled"}');
    logger.debug('  Crash Reporting: ${config.enableCrashReporting ? "Enabled" : "Disabled"}');
    logger.debug('  Remote Config: ${config.enableRemoteConfig ? "Enabled" : "Disabled"}');
    logger.debug('  Log Level: ${config.logLevel.name}');
    logger.debug('  SSL Pinning: ${config.enableSSLPinning ? "Enabled" : "Disabled"}');
  }
}

// ============================================================================
// MAIN APP
// ============================================================================

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Read flavor from environment
      const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
      final flavor = AppFlavor.fromString(flavorString);

      // Create environment configuration
      final config = _createConfig(flavor);

      // Initialize app
      await AppInitializer.initialize(config);

      // Run app
      runApp(ProductionReadyApp(config: config));
    },
    (error, stack) {
      // Global error handler
      debugPrint('❌ Uncaught error: $error');
      debugPrint('Stack trace:\n$stack');

      // In production, log to crash reporting
      if (AppInitializer.config.enableCrashReporting) {
        AppInitializer.crashReporting.recordError(error, stack, fatal: true);
      }
    },
  );
}

EnvConfig _createConfig(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return DevEnvConfig();
    case AppFlavor.staging:
      return StagingEnvConfig();
    case AppFlavor.prod:
      return ProdEnvConfig();
  }
}

// ============================================================================
// UI
// ============================================================================

class ProductionReadyApp extends StatelessWidget {
  final EnvConfig config;

  const ProductionReadyApp({required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: ThemeData(
        primaryColor: config.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: config.primaryColor),
        appBarTheme: AppBarTheme(
          backgroundColor: config.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppInitializer.config;
    final remoteConfig = AppInitializer.remoteConfig;

    return Scaffold(
      appBar: AppBar(
        title: Text('Production-Ready App'),
        actions: [
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Environment Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, color: config.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Environment Configuration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    _buildInfoRow('Flavor', config.flavor.name.toUpperCase()),
                    _buildInfoRow('App Name', config.appName),
                    _buildInfoRow('API URL', config.apiBaseUrl),
                    _buildInfoRow('Firebase Project', config.firebaseProjectId),
                    _buildInfoRow('Payment Mode', config.isPaymentTestMode ? 'TEST' : 'LIVE'),
                    _buildInfoRow('Log Level', config.logLevel.name.toUpperCase()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Services Status
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 24),
                    _buildServiceRow('Analytics', config.enableAnalytics),
                    _buildServiceRow('Crash Reporting', config.enableCrashReporting),
                    _buildServiceRow('Performance Monitoring', config.enablePerformanceMonitoring),
                    _buildServiceRow('Remote Config', config.enableRemoteConfig),
                    _buildServiceRow('Network Logging', config.enableNetworkLogging),
                    _buildServiceRow('SSL Pinning', config.enableSSLPinning),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Feature Flags
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feature Flags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 24),
                    ...config.localFeatureFlags.entries.map((entry) {
                      final remoteValue = remoteConfig.getFeatureFlag(entry.key, entry.value);
                      return _buildServiceRow(entry.key, remoteValue);
                    }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Actions
            ElevatedButton.icon(
              onPressed: () async {
                AppInitializer.logger.info('Test button clicked');
                AppInitializer.analytics.logEvent('button_clicked', {
                  'button_name': 'test_button',
                  'screen': 'home',
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Event logged!')),
                );
              },
              icon: Icon(Icons.send),
              label: Text('Test Analytics Event'),
            ),
            SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  throw Exception('Test exception for crash reporting');
                } catch (e, stack) {
                  AppInitializer.crashReporting.recordError(e, stack);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Test error logged!')),
                  );
                }
              },
              icon: Icon(Icons.bug_report),
              label: Text('Test Error Logging'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(String name, bool enabled) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name.replaceAll('_', ' ').toUpperCase()),
          Row(
            children: [
              Icon(
                enabled ? Icons.check_circle : Icons.cancel,
                color: enabled ? Colors.green : Colors.grey,
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                enabled ? 'Enabled' : 'Disabled',
                style: TextStyle(
                  color: enabled ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
