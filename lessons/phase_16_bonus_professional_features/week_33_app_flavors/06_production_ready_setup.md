# Production-Ready Multi-Flavor Setup - Complete Guide

## Understanding Production-Ready Setup (5-Year-Old Explanation)

Imagine you're running a bakery that makes three types of cakes:

**Practice Cakes (Dev):**
- Made in your home kitchen
- You taste-test everything
- Can make mistakes (nobody sees them!)
- Quick and messy

**Sample Cakes (Staging):**
- Made in a real kitchen
- Friends taste-test
- Must look professional
- Almost like the real thing

**Wedding Cakes (Production):**
- Made in certified commercial kitchen
- Delivered to real customers
- Zero mistakes allowed
- Automated quality checks
- Everything documented

**Same recipe, but EVERYTHING else is different: the kitchen, tools, process, and checks!**

A production-ready Flutter app is similar. It's not just about different API URLs - it's about having a complete, automated, professional system that ensures quality and safety!

## What Makes a Setup "Production-Ready"?

### The Checklist

✅ **Separate environments** that can't affect each other
✅ **Automated builds** (CI/CD) - no manual steps
✅ **Automated testing** before deployment
✅ **Secret management** - no secrets in code
✅ **Error tracking** - know when things break
✅ **Analytics** - understand user behavior
✅ **Versioning** - track every release
✅ **Documentation** - team can understand and use it
✅ **Rollback capability** - undo bad releases
✅ **Monitoring** - watch app health in real-time

Let's build all of this!

## Complete Project: FoodDelivery App

We'll create a production-ready food delivery app with all best practices!

### Project Goals

1. Three completely isolated environments (dev, staging, prod)
2. Automated builds and testing
3. Proper secret management
4. Error tracking and analytics
5. Easy for team members to use
6. Safe deployment process

## Step 1: Project Structure (The Foundation)

```
fooddelivery_app/
├── .github/
│   └── workflows/
│       ├── dev.yml           # Auto-deploy dev
│       ├── staging.yml       # Auto-deploy staging
│       └── production.yml    # Manual prod deployment
├── android/
│   └── app/
│       ├── build.gradle      # Flavor configuration
│       └── src/
│           ├── dev/          # Dev resources
│           ├── staging/      # Staging resources
│           └── prod/         # Production resources
├── ios/
│   ├── Runner/
│   │   ├── Info-dev.plist
│   │   ├── Info-staging.plist
│   │   ├── Info-prod.plist
│   │   ├── Firebase-dev/
│   │   ├── Firebase-staging/
│   │   └── Firebase-prod/
│   └── Flutter/
│       └── Config/
│           ├── dev.xcconfig
│           ├── staging.xcconfig
│           └── prod.xcconfig
├── lib/
│   ├── config/
│   │   ├── flavor.dart
│   │   ├── app_config.dart
│   │   ├── feature_flags.dart
│   │   └── secrets.dart
│   ├── core/
│   │   ├── error_handler.dart
│   │   ├── logger.dart
│   │   └── analytics.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── firebase_service.dart
│   ├── models/
│   ├── screens/
│   ├── widgets/
│   ├── my_app.dart
│   ├── main_dev.dart
│   ├── main_staging.dart
│   └── main_prod.dart
├── test/
│   └── widget_test.dart
├── scripts/
│   ├── run_dev.sh
│   ├── run_staging.sh
│   ├── build_dev.sh
│   ├── build_staging.sh
│   └── build_production.sh
├── .env.dev              # Dev secrets (committed)
├── .env.staging          # Staging secrets (committed)
├── .env.prod.example     # Template (committed)
├── .gitignore           # Excludes .env.prod
├── FLAVORS.md           # Team documentation
└── pubspec.yaml
```

## Step 2: Complete Configuration System

### Core Flavor Configuration

**lib/config/flavor.dart:**

```dart
/// Available app flavors (environments)
enum Flavor {
  dev,
  staging,
  prod,
}

extension FlavorExtension on Flavor {
  bool get isDev => this == Flavor.dev;
  bool get isStaging => this == Flavor.staging;
  bool get isProd => this == Flavor.prod;

  String get name {
    switch (this) {
      case Flavor.dev:
        return 'Development';
      case Flavor.staging:
        return 'Staging';
      case Flavor.prod:
        return 'Production';
    }
  }

  String get shortName {
    switch (this) {
      case Flavor.dev:
        return 'DEV';
      case Flavor.staging:
        return 'STG';
      case Flavor.prod:
        return 'PROD';
    }
  }

  String get displayName {
    switch (this) {
      case Flavor.dev:
        return 'FoodDelivery DEV';
      case Flavor.staging:
        return 'FoodDelivery STAGING';
      case Flavor.prod:
        return 'FoodDelivery';
    }
  }
}
```

### Complete App Configuration

**lib/config/app_config.dart:**

```dart
import 'package:flutter/foundation.dart';
import 'flavor.dart';

/// Centralized configuration for the entire application
class AppConfig {
  // Core settings
  final Flavor flavor;
  final String appName;
  final String bundleId;

  // API configuration
  final String apiBaseUrl;
  final String apiKey;
  final Duration apiTimeout;

  // Firebase configuration
  final String firebaseProjectId;

  // Payment configuration
  final String stripePublicKey;
  final bool useStripeTestMode;

  // Feature flags
  final bool enableDebugMode;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;
  final bool showDebugBanner;

  // Logging configuration
  final bool verboseLogging;
  final bool logApiCalls;
  final bool logNavigationEvents;

  // App behavior
  final bool requireAuth;
  final int maxRetryAttempts;
  final Duration cacheExpiration;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.bundleId,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.apiTimeout,
    required this.firebaseProjectId,
    required this.stripePublicKey,
    required this.useStripeTestMode,
    required this.enableDebugMode,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
    required this.showDebugBanner,
    required this.verboseLogging,
    required this.logApiCalls,
    required this.logNavigationEvents,
    required this.requireAuth,
    required this.maxRetryAttempts,
    required this.cacheExpiration,
  });

  factory AppConfig.forFlavor(Flavor flavor) {
    // Get API key from compile-time constant for security
    const apiKey = String.fromEnvironment('API_KEY');
    const stripeKey = String.fromEnvironment('STRIPE_KEY');

    switch (flavor) {
      case Flavor.dev:
        return AppConfig._(
          flavor: flavor,
          appName: flavor.displayName,
          bundleId: 'com.example.fooddelivery.dev',
          apiBaseUrl: const String.fromEnvironment(
            'API_URL',
            defaultValue: 'https://dev-api.fooddelivery.com',
          ),
          apiKey: apiKey.isEmpty ? 'dev_key_12345' : apiKey,
          apiTimeout: const Duration(seconds: 30),
          firebaseProjectId: 'fooddelivery-dev',
          stripePublicKey: stripeKey.isEmpty ? 'pk_test_dev' : stripeKey,
          useStripeTestMode: true,
          enableDebugMode: true,
          enableAnalytics: false,  // Don't track dev usage
          enableCrashReporting: false,  // Don't report dev crashes
          enablePerformanceMonitoring: false,
          showDebugBanner: true,
          verboseLogging: true,
          logApiCalls: true,
          logNavigationEvents: true,
          requireAuth: false,  // Easy testing
          maxRetryAttempts: 5,
          cacheExpiration: const Duration(minutes: 5),
        );

      case Flavor.staging:
        return AppConfig._(
          flavor: flavor,
          appName: flavor.displayName,
          bundleId: 'com.example.fooddelivery.staging',
          apiBaseUrl: const String.fromEnvironment(
            'API_URL',
            defaultValue: 'https://staging-api.fooddelivery.com',
          ),
          apiKey: apiKey.isEmpty ? 'staging_key_67890' : apiKey,
          apiTimeout: const Duration(seconds: 20),
          firebaseProjectId: 'fooddelivery-staging',
          stripePublicKey: stripeKey.isEmpty ? 'pk_test_staging' : stripeKey,
          useStripeTestMode: true,
          enableDebugMode: true,
          enableAnalytics: true,  // Track QA usage
          enableCrashReporting: true,  // Report staging crashes
          enablePerformanceMonitoring: true,
          showDebugBanner: true,
          verboseLogging: false,
          logApiCalls: true,
          logNavigationEvents: false,
          requireAuth: true,  // Test real auth flow
          maxRetryAttempts: 3,
          cacheExpiration: const Duration(minutes: 15),
        );

      case Flavor.prod:
        // Validate required secrets in production
        if (apiKey.isEmpty) {
          throw Exception('API_KEY must be provided for production builds');
        }
        if (stripeKey.isEmpty || !stripeKey.startsWith('pk_live')) {
          throw Exception('Production Stripe key required (must start with pk_live)');
        }

        return AppConfig._(
          flavor: flavor,
          appName: flavor.displayName,
          bundleId: 'com.example.fooddelivery',
          apiBaseUrl: const String.fromEnvironment(
            'API_URL',
            defaultValue: 'https://api.fooddelivery.com',
          ),
          apiKey: apiKey,
          apiTimeout: const Duration(seconds: 10),
          firebaseProjectId: 'fooddelivery-prod',
          stripePublicKey: stripeKey,
          useStripeTestMode: false,
          enableDebugMode: false,
          enableAnalytics: true,  // Track real users
          enableCrashReporting: true,  // Report all crashes
          enablePerformanceMonitoring: true,
          showDebugBanner: false,
          verboseLogging: false,
          logApiCalls: false,  // Only log errors
          logNavigationEvents: false,
          requireAuth: true,
          maxRetryAttempts: 3,
          cacheExpiration: const Duration(hours: 1),
        );
    }
  }

  static late AppConfig instance;

  static void initialize(Flavor flavor) {
    instance = AppConfig.forFlavor(flavor);
    _validate();
  }

  static void _validate() {
    // Validate configuration
    if (instance.apiBaseUrl.isEmpty) {
      throw Exception('API base URL cannot be empty');
    }

    // Production-specific validations
    if (instance.flavor.isProd) {
      if (instance.apiBaseUrl.contains('dev') ||
          instance.apiBaseUrl.contains('staging')) {
        throw Exception('Production app pointing to non-prod API!');
      }

      if (instance.firebaseProjectId.contains('dev') ||
          instance.firebaseProjectId.contains('staging')) {
        throw Exception('Production app using non-prod Firebase!');
      }

      if (instance.useStripeTestMode) {
        throw Exception('Production app using Stripe test mode!');
      }
    }

    if (kDebugMode) {
      print('✅ Configuration validated for ${instance.flavor.name}');
      print('   API: ${instance.apiBaseUrl}');
      print('   Firebase: ${instance.firebaseProjectId}');
    }
  }
}
```

## Step 3: Error Handling and Logging

### Professional Error Handler

**lib/core/error_handler.dart:**

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'logger.dart';

class ErrorHandler {
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      recordError(details.exception, details.stack);
    };

    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      recordError(error, stack);
      return true;
    };

    AppLogger.info('Error handler initialized for ${AppConfig.instance.flavor.name}');
  }

  /// Record an error (sends to Crashlytics in staging/prod)
  static void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    final config = AppConfig.instance;

    // Log error
    AppLogger.error(
      reason ?? 'An error occurred',
      error,
      stackTrace,
    );

    // Send to Crashlytics in staging/prod
    if (config.enableCrashReporting) {
      try {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          reason: reason,
          fatal: fatal,
        );
      } catch (e) {
        AppLogger.error('Failed to record error to Crashlytics', e);
      }
    }
  }

  /// Log a message to Crashlytics
  static void log(String message) {
    if (AppConfig.instance.enableCrashReporting) {
      FirebaseCrashlytics.instance.log(message);
    }
  }

  /// Set user identifier for crash reports
  static void setUserId(String userId) {
    if (AppConfig.instance.enableCrashReporting) {
      FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
  }

  /// Set custom key for crash reports
  static void setCustomKey(String key, dynamic value) {
    if (AppConfig.instance.enableCrashReporting) {
      FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
    }
  }
}
```

### Professional Logger

**lib/core/logger.dart:**

```dart
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as log;
import '../config/app_config.dart';

class AppLogger {
  static late log.Logger _logger;
  static late AppConfig _config;

  static void initialize() {
    _config = AppConfig.instance;

    _logger = log.Logger(
      printer: log.PrettyPrinter(
        methodCount: _config.verboseLogging ? 2 : 0,
        errorMethodCount: 5,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: _getLogLevel(),
    );

    info('Logger initialized for ${_config.flavor.name}');
  }

  static log.Level _getLogLevel() {
    switch (_config.flavor) {
      case Flavor.dev:
        return log.Level.verbose;
      case Flavor.staging:
        return log.Level.info;
      case Flavor.prod:
        return log.Level.warning;
    }
  }

  static void verbose(String message) {
    if (_config.verboseLogging) {
      _logger.v(message);
    }
  }

  static void debug(String message) {
    if (_config.enableDebugMode) {
      _logger.d(message);
    }
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(message, error, stackTrace);
  }

  static void apiCall(String method, String endpoint, {int? statusCode}) {
    if (_config.logApiCalls) {
      final status = statusCode != null ? ' [$statusCode]' : '';
      debug('🌐 $method $endpoint$status');
    }
  }

  static void navigation(String from, String to) {
    if (_config.logNavigationEvents) {
      debug('📍 Navigation: $from → $to');
    }
  }
}
```

### Analytics Service

**lib/core/analytics.dart:**

```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import '../config/app_config.dart';
import 'logger.dart';

class Analytics {
  static late FirebaseAnalytics _analytics;
  static late FirebaseAnalyticsObserver _observer;

  static FirebaseAnalyticsObserver get observer => _observer;

  static void initialize() {
    _analytics = FirebaseAnalytics.instance;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);

    AppLogger.info('Analytics initialized');
  }

  /// Log an event
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (!AppConfig.instance.enableAnalytics) {
      AppLogger.debug('Analytics disabled, skipping event: $name');
      return;
    }

    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      AppLogger.debug('📊 Analytics: $name ${parameters ?? ''}');
    } catch (e) {
      AppLogger.error('Failed to log analytics event', e);
    }
  }

  /// Log screen view
  static Future<void> logScreenView(String screenName) async {
    await logEvent(
      name: 'screen_view',
      parameters: {'screen_name': screenName},
    );
  }

  /// Set user properties
  static Future<void> setUserId(String userId) async {
    if (AppConfig.instance.enableAnalytics) {
      await _analytics.setUserId(id: userId);
    }
  }

  /// Set user property
  static Future<void> setUserProperty(String name, String value) async {
    if (AppConfig.instance.enableAnalytics) {
      await _analytics.setUserProperty(name: name, value: value);
    }
  }

  // Predefined events
  static Future<void> logLogin(String method) async {
    await logEvent(name: 'login', parameters: {'method': method});
  }

  static Future<void> logSignUp(String method) async {
    await logEvent(name: 'sign_up', parameters: {'method': method});
  }

  static Future<void> logPurchase({
    required double value,
    required String currency,
    required String orderId,
  }) async {
    await logEvent(
      name: 'purchase',
      parameters: {
        'value': value,
        'currency': currency,
        'transaction_id': orderId,
      },
    );
  }

  static Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required double price,
  }) async {
    await logEvent(
      name: 'add_to_cart',
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
        'price': price,
      },
    );
  }
}
```

## Step 4: Entry Points with Complete Initialization

**lib/main_dev.dart:**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'core/error_handler.dart';
import 'core/logger.dart';
import 'core/analytics.dart';
import 'my_app.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  AppConfig.initialize(Flavor.dev);

  // Initialize logger
  AppLogger.initialize();
  AppLogger.info('Starting ${AppConfig.instance.appName}...');

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    AppLogger.info('Firebase initialized');
  } catch (e, stack) {
    AppLogger.error('Failed to initialize Firebase', e, stack);
  }

  // Initialize error handling
  ErrorHandler.initialize();

  // Initialize analytics
  Analytics.initialize();

  // Run the app
  runApp(const MyApp());
}
```

**lib/main_staging.dart:**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'core/error_handler.dart';
import 'core/logger.dart';
import 'core/analytics.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(Flavor.staging);
  AppLogger.initialize();
  AppLogger.info('Starting ${AppConfig.instance.appName}...');

  await Firebase.initializeApp();
  ErrorHandler.initialize();
  Analytics.initialize();

  runApp(const MyApp());
}
```

**lib/main_prod.dart:**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'core/error_handler.dart';
import 'core/logger.dart';
import 'core/analytics.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(Flavor.prod);
  AppLogger.initialize();
  AppLogger.info('Starting ${AppConfig.instance.appName}...');

  await Firebase.initializeApp();

  // Validate production setup
  _validateProductionSetup();

  ErrorHandler.initialize();
  Analytics.initialize();

  runApp(const MyApp());
}

void _validateProductionSetup() {
  final config = AppConfig.instance;

  assert(!config.enableDebugMode, 'Debug mode enabled in production!');
  assert(!config.showDebugBanner, 'Debug banner visible in production!');
  assert(config.requireAuth, 'Auth not required in production!');
  assert(!config.useStripeTestMode, 'Using Stripe test mode in production!');

  AppLogger.info('✅ Production setup validated');
}
```

## Step 5: Build Scripts (Automation)

### Development Build Script

**scripts/run_dev.sh:**

```bash
#!/bin/bash

echo "🚀 Running FoodDelivery in DEV mode..."

flutter run \
  --flavor dev \
  -t lib/main_dev.dart \
  --dart-define=API_KEY=dev_key_12345 \
  --dart-define=STRIPE_KEY=pk_test_dev \
  --dart-define=API_URL=https://dev-api.fooddelivery.com

```

### Staging Build Script

**scripts/run_staging.sh:**

```bash
#!/bin/bash

echo "🚀 Running FoodDelivery in STAGING mode..."

flutter run \
  --flavor staging \
  -t lib/main_staging.dart \
  --dart-define=API_KEY=staging_key_67890 \
  --dart-define=STRIPE_KEY=pk_test_staging \
  --dart-define=API_URL=https://staging-api.fooddelivery.com
```

### Production Build Script

**scripts/build_production.sh:**

```bash
#!/bin/bash

set -e  # Exit on error

echo "🏭 Building FoodDelivery for PRODUCTION..."

# Check if required environment variables are set
if [ -z "$PROD_API_KEY" ]; then
    echo "❌ Error: PROD_API_KEY environment variable not set"
    exit 1
fi

if [ -z "$PROD_STRIPE_KEY" ]; then
    echo "❌ Error: PROD_STRIPE_KEY environment variable not set"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Run tests
echo "🧪 Running tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "❌ Tests failed! Aborting build."
    exit 1
fi

# Build Android
echo "🤖 Building Android APK..."
flutter build apk \
  --flavor prod \
  -t lib/main_prod.dart \
  --release \
  --dart-define=API_KEY=$PROD_API_KEY \
  --dart-define=STRIPE_KEY=$PROD_STRIPE_KEY \
  --dart-define=API_URL=https://api.fooddelivery.com

# Build iOS (if on Mac)
if [ "$(uname)" == "Darwin" ]; then
    echo "🍎 Building iOS IPA..."
    flutter build ios \
      --flavor prod \
      -t lib/main_prod.dart \
      --release \
      --dart-define=API_KEY=$PROD_API_KEY \
      --dart-define=STRIPE_KEY=$PROD_STRIPE_KEY \
      --dart-define=API_URL=https://api.fooddelivery.com
fi

echo "✅ Production build completed successfully!"
echo "📦 Android APK: build/app/outputs/flutter-apk/app-prod-release.apk"
if [ "$(uname)" == "Darwin" ]; then
    echo "📦 iOS: build/ios/iphoneos/Runner.app"
fi
```

**Make scripts executable:**

```bash
chmod +x scripts/run_dev.sh
chmod +x scripts/run_staging.sh
chmod +x scripts/build_production.sh
```

## Step 6: CI/CD with GitHub Actions

### Development Auto-Deploy

**.github/workflows/dev.yml:**

```yaml
name: Development Build and Deploy

on:
  push:
    branches: [ develop ]
  pull_request:
    branches: [ develop ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run analyzer
      run: flutter analyze

    - name: Run tests
      run: flutter test

    - name: Build Dev APK
      run: |
        flutter build apk \
          --flavor dev \
          -t lib/main_dev.dart \
          --dart-define=API_KEY=dev_key_12345 \
          --dart-define=STRIPE_KEY=pk_test_dev \
          --dart-define=API_URL=https://dev-api.fooddelivery.com

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: dev-apk
        path: build/app/outputs/flutter-apk/app-dev-release.apk

    - name: Send Slack notification
      if: always()
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        text: 'Dev build ${{ job.status }}'
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Staging Deploy

**.github/workflows/staging.yml:**

```yaml
name: Staging Build and Deploy

on:
  push:
    branches: [ staging ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test

    - name: Build Staging APK
      run: |
        flutter build apk \
          --flavor staging \
          -t lib/main_staging.dart \
          --dart-define=API_KEY=${{ secrets.STAGING_API_KEY }} \
          --dart-define=STRIPE_KEY=${{ secrets.STAGING_STRIPE_KEY }} \
          --dart-define=API_URL=https://staging-api.fooddelivery.com

    - name: Upload to Firebase App Distribution
      uses: wzieba/Firebase-Distribution-Github-Action@v1
      with:
        appId: ${{ secrets.FIREBASE_APP_ID_STAGING }}
        serviceCredentialsFileContent: ${{ secrets.FIREBASE_CREDENTIALS }}
        groups: qa-team
        file: build/app/outputs/flutter-apk/app-staging-release.apk

    - name: Notify QA team
      uses: 8398a7/action-slack@v3
      with:
        status: success
        text: 'New staging build available for testing!'
        webhook_url: ${{ secrets.SLACK_WEBHOOK_QA }}
```

### Production Deploy (Manual Approval)

**.github/workflows/production.yml:**

```yaml
name: Production Build and Deploy

on:
  workflow_dispatch:  # Manual trigger only
    inputs:
      version:
        description: 'Version number (e.g., 1.2.3)'
        required: true

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run analyzer
      run: flutter analyze

    - name: Run tests
      run: flutter test

    - name: Integration tests
      run: flutter test integration_test/

  build-android:
    needs: validate
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'

    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '11'

    - name: Install dependencies
      run: flutter pub get

    - name: Build Production APK
      run: |
        flutter build apk \
          --flavor prod \
          -t lib/main_prod.dart \
          --release \
          --dart-define=API_KEY=${{ secrets.PROD_API_KEY }} \
          --dart-define=STRIPE_KEY=${{ secrets.PROD_STRIPE_KEY }} \
          --dart-define=API_URL=https://api.fooddelivery.com

    - name: Sign APK
      uses: r0adkll/sign-android-release@v1
      with:
        releaseDirectory: build/app/outputs/flutter-apk
        signingKeyBase64: ${{ secrets.ANDROID_SIGNING_KEY }}
        alias: ${{ secrets.ANDROID_KEY_ALIAS }}
        keyStorePassword: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
        keyPassword: ${{ secrets.ANDROID_KEY_PASSWORD }}

    - name: Upload to Google Play
      uses: r0adkll/upload-google-play@v1
      with:
        serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
        packageName: com.example.fooddelivery
        releaseFiles: build/app/outputs/flutter-apk/app-prod-release.apk
        track: production
        status: completed

  build-ios:
    needs: validate
    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Build iOS
      run: |
        flutter build ios \
          --flavor prod \
          -t lib/main_prod.dart \
          --release \
          --dart-define=API_KEY=${{ secrets.PROD_API_KEY }} \
          --dart-define=STRIPE_KEY=${{ secrets.PROD_STRIPE_KEY }} \
          --dart-define=API_URL=https://api.fooddelivery.com \
          --no-codesign

    - name: Build and upload to TestFlight
      uses: apple-actions/upload-testflight-build@v1
      with:
        app-path: build/ios/iphoneos/Runner.app
        issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
        api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
        api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}

  notify:
    needs: [build-android, build-ios]
    runs-on: ubuntu-latest
    steps:
    - name: Notify team
      uses: 8398a7/action-slack@v3
      with:
        status: success
        text: '🎉 Production v${{ github.event.inputs.version }} deployed successfully!'
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Step 7: Environment Variables and Secrets

### Development (.env.dev - Committed)

```env
# Development Environment
FLAVOR=dev
APP_NAME=FoodDelivery DEV
API_URL=https://dev-api.fooddelivery.com
API_KEY=dev_key_12345
STRIPE_KEY=pk_test_dev_abc123
FIREBASE_PROJECT=fooddelivery-dev
SENTRY_DSN=https://dev@sentry.io/123
```

### Staging (.env.staging - Committed)

```env
# Staging Environment
FLAVOR=staging
APP_NAME=FoodDelivery STAGING
API_URL=https://staging-api.fooddelivery.com
API_KEY=staging_key_67890
STRIPE_KEY=pk_test_staging_xyz789
FIREBASE_PROJECT=fooddelivery-staging
SENTRY_DSN=https://staging@sentry.io/456
```

### Production Template (.env.prod.example - Committed)

```env
# Production Environment Template
# Copy to .env.prod and fill in real values
# NEVER commit .env.prod to git!

FLAVOR=prod
APP_NAME=FoodDelivery
API_URL=https://api.fooddelivery.com
API_KEY=YOUR_PRODUCTION_API_KEY_HERE
STRIPE_KEY=pk_live_YOUR_KEY_HERE
FIREBASE_PROJECT=fooddelivery-prod
SENTRY_DSN=https://prod@sentry.io/YOUR_PROJECT
```

### .gitignore Configuration

```
# Environment files
.env.prod
.env.*.local
*.key
*.jks

# Android signing
android/key.properties
android/app/release/

# iOS signing
ios/Runner/GoogleService-Info.plist
*.mobileprovision
*.p12

# Secrets
secrets/
credentials/
```

## Step 8: Team Documentation

### FLAVORS.md

```markdown
# FoodDelivery App Flavors Guide

## Quick Start

### Development
```bash
# Quick run
./scripts/run_dev.sh

# Or manually
flutter run --flavor dev -t lib/main_dev.dart
```

- **Purpose**: Daily development
- **Firebase**: fooddelivery-dev
- **API**: https://dev-api.fooddelivery.com
- **Features**: All debug features enabled
- **Payments**: Stripe test mode

### Staging
```bash
# Quick run
./scripts/run_staging.sh

# Or manually
flutter run --flavor staging -t lib/main_staging.dart
```

- **Purpose**: QA testing, client demos
- **Firebase**: fooddelivery-staging
- **API**: https://staging-api.fooddelivery.com
- **Features**: Production-like behavior
- **Payments**: Stripe test mode

### Production
```bash
# Build (requires secrets)
export PROD_API_KEY="your_key"
export PROD_STRIPE_KEY="pk_live_your_key"
./scripts/build_production.sh
```

- **Purpose**: Real users, real money
- **Firebase**: fooddelivery-prod
- **API**: https://api.fooddelivery.com
- **Features**: Stable features only
- **Payments**: **REAL** Stripe live mode

## Setup for New Team Members

### 1. Clone Repository
```bash
git clone https://github.com/yourcompany/fooddelivery-app.git
cd fooddelivery-app
```

### 2. Install Flutter
- Follow: https://flutter.dev/docs/get-started/install
- Run: `flutter doctor`

### 3. Install Dependencies
```bash
flutter pub get
cd ios && pod install && cd ..
```

### 4. Setup Firebase
- Download Firebase configs for dev/staging
- Place in correct folders (see Project Structure)
- Ask team lead if you need access

### 5. Make Scripts Executable
```bash
chmod +x scripts/*.sh
```

### 6. Run Development Build
```bash
./scripts/run_dev.sh
```

## Building for Release

### Android APK
```bash
flutter build apk --flavor [dev|staging|prod] -t lib/main_[flavor].dart --release
```

### iOS IPA
```bash
flutter build ios --flavor [dev|staging|prod] -t lib/main_[flavor].dart --release
```

## Troubleshooting

### Error: "Scheme not found"
- Open `ios/Runner.xcworkspace` in Xcode
- Check that schemes are marked as "Shared"

### Error: "Wrong Firebase project"
- Check `google-services.json` in flavor folder
- Verify `GoogleService-Info.plist` path in Xcode

### Error: "API key missing"
- For dev/staging: Keys are in code (safe)
- For production: Must set environment variables

## CI/CD

### Automatic Deploys
- **Dev**: Auto-deploys on push to `develop` branch
- **Staging**: Auto-deploys on push to `staging` branch
- **Production**: Manual trigger only (GitHub Actions)

### Triggering Production Deploy
1. Go to Actions tab in GitHub
2. Select "Production Build and Deploy"
3. Click "Run workflow"
4. Enter version number
5. Confirm

## Security

### DO NOT:
- ❌ Commit .env.prod
- ❌ Hardcode API keys
- ❌ Share production credentials in Slack
- ❌ Use production Firebase in development

### DO:
- ✅ Use environment variables for secrets
- ✅ Use .env.dev and .env.staging (committed)
- ✅ Keep production keys in CI/CD secrets
- ✅ Test in dev/staging first

## Getting Help

- **Technical issues**: Ask in #flutter-dev Slack
- **Firebase access**: Contact DevOps team
- **Production secrets**: Contact team lead
- **Build failures**: Check GitHub Actions logs

## Important Links

- [Firebase Console](https://console.firebase.google.com)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Sentry Dashboard](https://sentry.io)
- [API Documentation](https://docs.fooddelivery.com)
```

## Step 9: Common Errors and Solutions

### Error 1: "Multiple Firebase projects initialized"

**Error:**
```
Firebase app named '[DEFAULT]' already exists
```

**Solution:**
Make sure you only call `Firebase.initializeApp()` once:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {  // Check if already initialized
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}
```

### Error 2: "Production secrets in Git"

**Prevention:**
Create pre-commit hook:

```bash
# .git/hooks/pre-commit
#!/bin/bash

# Check for sensitive files
if git diff --cached --name-only | grep -E "\.env\.prod$|key\.properties|\.jks$"; then
    echo "❌ ERROR: Attempting to commit sensitive files!"
    echo "Files detected:"
    git diff --cached --name-only | grep -E "\.env\.prod$|key\.properties|\.jks$"
    exit 1
fi

# Check for hardcoded secrets
if git diff --cached | grep -E "pk_live_|sk_live_|prod_key_|password.*="; then
    echo "❌ ERROR: Potential secrets detected in code!"
    echo "Lines found:"
    git diff --cached | grep -E "pk_live_|sk_live_|prod_key_|password.*="
    exit 1
fi

exit 0
```

### Error 3: "Wrong flavor running"

**Verification:**
Add debug screen:

```dart
class FlavorDebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(title: Text('Flavor Debug')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Flavor', config.flavor.name),
            _buildRow('App Name', config.appName),
            _buildRow('Bundle ID', config.bundleId),
            _buildRow('API URL', config.apiBaseUrl),
            _buildRow('Firebase', config.firebaseProjectId),
            _buildRow('Debug Mode', config.enableDebugMode.toString()),
            _buildRow('Analytics', config.enableAnalytics.toString()),
            if (!config.flavor.isProd)
              _buildRow('API Key', config.apiKey.substring(0, 10) + '...'),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
```

### Error 4: "Tests failing in CI but pass locally"

**Common causes:**
1. Environment variables not set in CI
2. Missing dependencies
3. Different Flutter versions

**Solution:**
Add to CI workflow:

```yaml
- name: Debug environment
  run: |
    flutter doctor -v
    flutter --version
    echo "API_KEY length: ${#API_KEY}"

- name: Run tests with verbose output
  run: flutter test --reporter expanded
```

## Step 10: Deployment Checklist

### Pre-Production Checklist

Before deploying to production:

- ✅ All tests passing (unit, widget, integration)
- ✅ Code reviewed and approved
- ✅ Tested thoroughly in staging
- ✅ No hardcoded secrets in code
- ✅ Analytics configured and tested
- ✅ Crash reporting working
- ✅ Performance monitoring enabled
- ✅ API endpoints correct (production URLs)
- ✅ Firebase project correct (production)
- ✅ Stripe in live mode (not test)
- ✅ App version incremented
- ✅ Release notes written
- ✅ Rollback plan documented
- ✅ Team notified of deployment
- ✅ Monitoring dashboard ready

### Post-Deployment Checklist

After deploying:

- ✅ App installs successfully
- ✅ User can log in
- ✅ Core features work
- ✅ Payments processing correctly
- ✅ Analytics receiving events
- ✅ No spike in crash reports
- ✅ Performance metrics normal
- ✅ Monitor for 24-48 hours

## Pro Tips

### 1. Version Management

Use semantic versioning in `pubspec.yaml`:

```yaml
version: 1.2.3+45
# 1.2.3 = Marketing version (shown to users)
# 45 = Build number (auto-increment in CI)
```

Auto-increment in CI:

```bash
# Get current version
CURRENT_VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //')
MAJOR=$(echo $CURRENT_VERSION | cut -d. -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d. -f2)
PATCH=$(echo $CURRENT_VERSION | cut -d. -f3 | cut -d+ -f1)
BUILD=$(echo $CURRENT_VERSION | cut -d+ -f2)

# Increment build number
NEW_BUILD=$((BUILD + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"

# Update pubspec.yaml
sed -i "s/version: .*/version: $NEW_VERSION/" pubspec.yaml
```

### 2. Feature Toggle Service

For A/B testing:

```dart
class FeatureToggleService {
  static Future<void> initialize() async {
    if (AppConfig.instance.flavor.isProd) {
      // Fetch from Firebase Remote Config
      await _fetchRemoteToggles();
    }
  }

  static bool isFeatureEnabled(String featureKey) {
    // Check remote config in production
    // Check local flags in dev/staging
    return _remoteConfig.getBool(featureKey);
  }
}
```

### 3. Gradual Rollout

In Google Play Console:
1. Start with 5% rollout
2. Monitor crash reports
3. Increase to 25% if stable
4. Increase to 50%
5. Full rollout after 48 hours

### 4. Monitoring Dashboard

Set up dashboard with:
- Active users (last 24h)
- Crash-free rate (should be >99%)
- API response times
- Payment success rate
- User retention metrics

## Conclusion

Congratulations! You now have a production-ready multi-flavor setup that includes:

✅ **Complete separation** of dev/staging/prod environments
✅ **Automated builds** with CI/CD
✅ **Proper error handling** and crash reporting
✅ **Analytics** and monitoring
✅ **Secret management** (no secrets in code)
✅ **Team documentation** (easy onboarding)
✅ **Deployment safety** (tests, validation, gradual rollout)

This is the same setup used by professional teams at major companies!

**You're now a Flutter Flavor Grandmaster!** 🎉🚀

## Additional Resources

- [Flutter CI/CD Best Practices](https://flutter.dev/docs/deployment/cd)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Google Play Publishing](https://developer.android.com/distribute)
- [App Store Submission](https://developer.apple.com/app-store/submissions/)
- [Sentry Flutter SDK](https://docs.sentry.io/platforms/flutter/)

Keep building amazing apps! 🎨📱
