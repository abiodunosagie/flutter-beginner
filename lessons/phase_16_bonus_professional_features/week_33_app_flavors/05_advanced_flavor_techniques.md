# Advanced Flavor Techniques - Complete Guide

## Understanding Advanced Techniques (5-Year-Old Explanation)

Imagine you're a spy with three different identities:

**Training Identity (Dev):**
- Fake badge with your photo
- Practice gadgets that beep but don't work
- Training manual visible in your pocket
- Can see secret notes on the wall

**Test Mission Identity (Staging):**
- Almost-real badge
- Real-looking gadgets (but safety mode on)
- Hidden manual
- Most secret notes hidden

**Real Spy Identity (Production):**
- Official government badge
- Real gadgets (DANGEROUS!)
- No manual (you're a pro now!)
- All secrets completely hidden

**Same spy (you), but EVERYTHING changes based on the mission!**

In advanced Flutter flavors, we don't just change API URLs. We change:
- Which services connect to (Firebase projects)
- Which features exist (feature flags)
- How the app looks (dynamic icons, colors)
- Which code even gets included (conditional imports)
- How secrets are stored (security!)

## Advanced Technique 1: Multiple Firebase Projects

In real apps, you NEVER want development testing to touch production data!

### The Problem

```dart
// BAD: One Firebase project for all environments 😱
await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: "AIza...",  // Which environment???
    projectId: "my-app",  // Production data at risk!
  ),
);
```

**Dangers:**
- ❌ Test users appear in production analytics
- ❌ Test data pollutes production database
- ❌ Might accidentally send push notifications to real users!
- ❌ Development experiments affect production performance

### The Solution: Separate Firebase Projects

**Create three Firebase projects:**
1. `myapp-dev` (Development)
2. `myapp-staging` (Staging)
3. `myapp-production` (Production)

### Step 1: Download Firebase Config Files

For each project, download configuration files:

**For Android:**
1. Go to Firebase Console → Project Settings
2. Download `google-services.json`
3. Rename them:
   - `google-services-dev.json`
   - `google-services-staging.json`
   - `google-services-prod.json`

**For iOS:**
1. Download `GoogleService-Info.plist`
2. Rename them:
   - `GoogleService-Info-dev.plist`
   - `GoogleService-Info-staging.plist`
   - `GoogleService-Info-prod.plist`

### Step 2: Organize Firebase Files

**Android Structure:**
```
android/app/src/
├── dev/
│   └── google-services.json  ← Dev Firebase config
├── staging/
│   └── google-services.json  ← Staging Firebase config
└── prod/
    └── google-services.json  ← Production Firebase config
```

**iOS Structure:**
```
ios/Runner/
├── Firebase-dev/
│   └── GoogleService-Info.plist
├── Firebase-staging/
│   └── GoogleService-Info.plist
└── Firebase-prod/
    └── GoogleService-Info.plist
```

### Step 3: Configure Android to Use Correct File

**In `android/app/build.gradle`, at the BOTTOM:**

```gradle
// Apply Google Services plugin (Firebase)
// This reads google-services.json from the flavor folder!
apply plugin: 'com.google.gms.google-services'
```

**That's it!** Android automatically picks the right `google-services.json` based on flavor!

**5-Year-Old Analogy:**
Like having three different toy boxes (dev, staging, prod). When you pick a flavor, Android opens the right toy box and uses those toys (Firebase settings)!

### Step 4: Configure iOS to Use Correct File

In Xcode:

1. Select `Runner` target
2. `Build Phases` tab
3. Click `+` → `New Run Script Phase`
4. Name it: `Setup Firebase Config`
5. Add this script:

```bash
#!/bin/sh

# Determine which Firebase config to use based on configuration
if [[ "${CONFIGURATION}" == *"dev"* ]]; then
    CONFIG_FILE="${SRCROOT}/Runner/Firebase-dev/GoogleService-Info.plist"
elif [[ "${CONFIGURATION}" == *"staging"* ]]; then
    CONFIG_FILE="${SRCROOT}/Runner/Firebase-staging/GoogleService-Info.plist"
elif [[ "${CONFIGURATION}" == *"prod"* ]]; then
    CONFIG_FILE="${SRCROOT}/Runner/Firebase-prod/GoogleService-Info.plist"
else
    echo "⚠️  Unknown configuration: ${CONFIGURATION}"
    exit 1
fi

# Copy the correct Firebase config to the app bundle
cp "${CONFIG_FILE}" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

echo "✅ Using Firebase config: ${CONFIG_FILE}"
```

**What this does:**
- Checks which configuration you're building (dev, staging, or prod)
- Copies the correct Firebase config file into the app
- Now your app connects to the right Firebase project!

### Step 5: Initialize Firebase in Dart

**Update your main files:**

```dart
// lib/main_dev.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize config
  AppConfig.initialize(Flavor.dev);

  // Initialize Firebase (reads GoogleService-Info.plist or google-services.json)
  await Firebase.initializeApp();

  // Optional: Verify we're using the correct Firebase project
  if (AppConfig.instance.debugMode) {
    final projectId = Firebase.app().options.projectId;
    print('🔥 Connected to Firebase project: $projectId');
    assert(projectId.contains('dev'), 'Wrong Firebase project in dev!');
  }

  runApp(const MyApp());
}
```

**Verification:**
```dart
// Add a debug screen to verify Firebase connection
class DebugFirebasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final options = Firebase.app().options;

    return Scaffold(
      appBar: AppBar(title: Text('Firebase Debug')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project ID: ${options.projectId}'),
            Text('App ID: ${options.appId}'),
            Text('API Key: ${options.apiKey.substring(0, 10)}...'),
            Text('Storage Bucket: ${options.storageBucket}'),
          ],
        ),
      ),
    );
  }
}
```

**Now each flavor uses its own Firebase!** 🎉

## Advanced Technique 2: Feature Flags

Feature flags let you enable/disable features per flavor. Perfect for:
- Testing experimental features in dev only
- A/B testing in staging
- Hiding unfinished features in production

### Simple Feature Flags

**Add to `lib/config/app_config.dart`:**

```dart
class AppConfig {
  // ... existing fields ...

  // Feature flags
  final bool enableExperimentalUI;
  final bool enableBetaFeatures;
  final bool showPerformanceOverlay;
  final bool enableCrashReporting;
  final bool allowGuestCheckout;
  final bool enableDarkMode;

  AppConfig._({
    // ... existing parameters ...
    required this.enableExperimentalUI,
    required this.enableBetaFeatures,
    required this.showPerformanceOverlay,
    required this.enableCrashReporting,
    required this.allowGuestCheckout,
    required this.enableDarkMode,
  });

  factory AppConfig.forFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return AppConfig._(
          // ... existing config ...
          enableExperimentalUI: true,   // Try everything in dev!
          enableBetaFeatures: true,     // All beta features visible
          showPerformanceOverlay: true, // Show performance stats
          enableCrashReporting: false,  // Don't report dev crashes
          allowGuestCheckout: true,     // Test all flows
          enableDarkMode: true,         // Test dark mode
        );

      case Flavor.staging:
        return AppConfig._(
          // ... existing config ...
          enableExperimentalUI: false,  // More stable in staging
          enableBetaFeatures: true,     // QA tests beta features
          showPerformanceOverlay: false,
          enableCrashReporting: true,   // Report staging crashes
          allowGuestCheckout: true,     // Test checkout flows
          enableDarkMode: true,
        );

      case Flavor.prod:
        return AppConfig._(
          // ... existing config ...
          enableExperimentalUI: false,  // Only stable features
          enableBetaFeatures: false,    // No beta in production
          showPerformanceOverlay: false,
          enableCrashReporting: true,   // Report all crashes
          allowGuestCheckout: false,    // Require login
          enableDarkMode: true,         // Feature is ready!
        );
    }
  }
}
```

### Using Feature Flags in Your App

**Example: Experimental UI:**

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    // Show different UI based on feature flag
    if (config.enableExperimentalUI) {
      return _buildExperimentalCard();  // New fancy design
    } else {
      return _buildStandardCard();  // Proven design
    }
  }

  Widget _buildStandardCard() {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('\$${product.price}'),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildExperimentalCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              product.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Example: Beta Features:**

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          // Always visible
          Text('Welcome to our app!'),

          // Only visible in dev/staging
          if (config.enableBetaFeatures)
            Container(
              color: Colors.orange.shade100,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '🚀 BETA FEATURES',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewExperimentalFeature(),
                      ),
                    ),
                    child: Text('Try New Feature'),
                  ),
                ],
              ),
            ),

          // Rest of your UI
        ],
      ),
    );
  }
}
```

**Example: Guest Checkout:**

```dart
class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Column(
        children: [
          // Checkout form...

          // Only show guest checkout option in dev/staging
          if (config.allowGuestCheckout)
            TextButton(
              onPressed: () => _checkoutAsGuest(context),
              child: Text('Continue as Guest'),
            )
          else
            Text(
              'Please sign in to complete your order',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  void _checkoutAsGuest(BuildContext context) {
    // Guest checkout logic
  }
}
```

### Advanced: Remote Feature Flags

For production, use remote feature flags (like Firebase Remote Config):

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteFeatureFlags {
  static late FirebaseRemoteConfig _remoteConfig;

  static Future<void> initialize() async {
    _remoteConfig = FirebaseRemoteConfig.instance;

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // Set defaults (used if fetch fails)
    await _remoteConfig.setDefaults({
      'enable_dark_mode': false,
      'enable_new_checkout': false,
      'show_promotional_banner': false,
    });

    // Fetch and activate
    await _remoteConfig.fetchAndActivate();
  }

  static bool get enableDarkMode => _remoteConfig.getBool('enable_dark_mode');
  static bool get enableNewCheckout => _remoteConfig.getBool('enable_new_checkout');
  static bool get showPromotionalBanner => _remoteConfig.getBool('show_promotional_banner');
}
```

**Initialize in main:**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Only use remote config in production
  if (AppConfig.instance.flavor.isProd) {
    await RemoteFeatureFlags.initialize();
  }

  runApp(MyApp());
}
```

## Advanced Technique 3: Dynamic App Icons and Colors

Change your app's appearance based on flavor!

### Different Colors Per Flavor

```dart
class AppTheme {
  static ThemeData getTheme(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return ThemeData(
          primarySwatch: Colors.orange,  // Orange = development
          scaffoldBackgroundColor: Colors.orange.shade50,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        );

      case Flavor.staging:
        return ThemeData(
          primarySwatch: Colors.purple,  // Purple = staging
          scaffoldBackgroundColor: Colors.purple.shade50,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        );

      case Flavor.prod:
        return ThemeData(
          primarySwatch: Colors.blue,  // Blue = production
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );
    }
  }
}
```

**Use in your app:**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.appName,
      theme: AppTheme.getTheme(AppConfig.instance.flavor),  // Dynamic theme!
      home: HomePage(),
    );
  }
}
```

### Flavor Banner (Visual Indicator)

Add a corner banner in dev/staging:

```dart
class FlavorBanner extends StatelessWidget {
  final Widget child;

  const FlavorBanner({required this.child});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    // No banner in production
    if (config.flavor.isProd) {
      return child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: config.flavor.name.toUpperCase(),
        location: BannerLocation.topEnd,
        color: _getBannerColor(config.flavor),
        child: child,
      ),
    );
  }

  Color _getBannerColor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return Colors.orange;
      case Flavor.staging:
        return Colors.purple;
      case Flavor.prod:
        return Colors.blue;
    }
  }
}
```

**Wrap your app:**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlavorBanner(  // Add banner!
      child: MaterialApp(
        title: AppConfig.instance.appName,
        home: HomePage(),
      ),
    );
  }
}
```

**Now dev/staging apps show a corner banner!** 🎨

### App Icon Badge in Code

Show a badge overlay on app icon:

```dart
import 'package:flutter/services.dart';

class FlavorIcon {
  static Future<void> setAppIcon(Flavor flavor) async {
    if (flavor == Flavor.prod) return;  // No badge in production

    // Use different icon based on flavor
    final iconName = flavor == Flavor.dev ? 'dev_icon' : 'staging_icon';

    try {
      await MethodChannel('flavor_channel').invokeMethod(
        'setAppIcon',
        {'icon': iconName},
      );
    } catch (e) {
      print('Failed to set app icon: $e');
    }
  }
}
```

**Note:** This requires native code implementation (advanced topic).

## Advanced Technique 4: Environment-Specific Dependencies

Sometimes you want different packages per flavor!

### Conditional Imports

**Example: Different analytics in dev vs prod:**

```dart
// lib/services/analytics_service.dart
import 'analytics_interface.dart';

// Conditionally import based on flavor
import 'analytics_dev.dart'
    if (dart.library.io) 'analytics_prod.dart';

class AnalyticsService {
  static final Analytics analytics = getAnalytics();
}
```

**Create interface:**

```dart
// lib/services/analytics_interface.dart
abstract class Analytics {
  void logEvent(String name, Map<String, dynamic> parameters);
  void setUserId(String id);
}
```

**Development version (fake analytics):**

```dart
// lib/services/analytics_dev.dart
import 'analytics_interface.dart';

class DevAnalytics implements Analytics {
  @override
  void logEvent(String name, Map<String, dynamic> parameters) {
    print('📊 [DEV] Analytics event: $name');
    print('   Parameters: $parameters');
  }

  @override
  void setUserId(String id) {
    print('📊 [DEV] User ID set: $id');
  }
}

Analytics getAnalytics() => DevAnalytics();
```

**Production version (real analytics):**

```dart
// lib/services/analytics_prod.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'analytics_interface.dart';

class ProdAnalytics implements Analytics {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void logEvent(String name, Map<String, dynamic> parameters) {
    _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  void setUserId(String id) {
    _analytics.setUserId(id: id);
  }
}

Analytics getAnalytics() => ProdAnalytics();
```

**Now analytics are free (no network calls) in dev!**

### Conditional Code with kDebugMode

```dart
import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message) {
    // Only log in debug mode
    if (kDebugMode) {
      print('🔍 $message');
    }
  }

  static void logError(String error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      // Detailed logging in debug
      print('❌ ERROR: $error');
      if (stackTrace != null) {
        print('Stack trace:\n$stackTrace');
      }
    } else {
      // Send to crash reporting in production
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
```

## Advanced Technique 5: Secrets Management

Never hardcode secrets in your source code!

### Method 1: Environment Variables

**.env.dev** (committed to git):
```env
API_URL=https://dev-api.myapp.com
API_KEY=dev_key_12345
STRIPE_KEY=pk_test_abc123
SENTRY_DSN=https://dev-sentry.io/123
```

**.env.prod** (NOT committed to git):
```env
API_URL=https://api.myapp.com
API_KEY=prod_key_REAL_SECRET
STRIPE_KEY=pk_live_REAL_SECRET
SENTRY_DSN=https://sentry.io/REAL_PROJECT
```

**Update `.gitignore`:**
```
# Never commit production secrets!
.env.prod
.env.*.local
```

**Load in Dart:**

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load environment file based on flavor
  final envFile = const String.fromEnvironment(
    'ENV_FILE',
    defaultValue: '.env.dev',
  );

  await dotenv.load(fileName: envFile);

  final apiKey = dotenv.env['API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('API_KEY not found in environment!');
  }

  runApp(MyApp());
}
```

**Run with:**
```bash
flutter run --dart-define=ENV_FILE=.env.dev
```

### Method 2: Native Secrets (Most Secure)

**Android (build.gradle):**

```gradle
android {
    defaultConfig {
        // Read from local.properties (not committed)
        def localProperties = new Properties()
        def localPropertiesFile = rootProject.file('local.properties')
        if (localPropertiesFile.exists()) {
            localPropertiesFile.withReader('UTF-8') { reader ->
                localProperties.load(reader)
            }
        }

        resValue "string", "api_key", localProperties.getProperty('api.key', 'dev_key')
    }

    productFlavors {
        dev {
            resValue "string", "api_key", "dev_key_12345"
        }
        prod {
            // Read from secure source, never hardcode!
            resValue "string", "api_key", System.getenv("PROD_API_KEY") ?: ""
        }
    }
}
```

**iOS (xcconfig file):**

```xcconfig
// config/secrets-dev.xcconfig
API_KEY = dev_key_12345
STRIPE_KEY = pk_test_abc123

// config/secrets-prod.xcconfig (NOT COMMITTED)
API_KEY = ${PROD_API_KEY}  // From environment variable
STRIPE_KEY = ${PROD_STRIPE_KEY}
```

**Read in Dart:**

```dart
import 'package:flutter/services.dart';

class Secrets {
  static const platform = MethodChannel('secrets_channel');

  static Future<String> getApiKey() async {
    try {
      final String key = await platform.invokeMethod('getApiKey');
      return key;
    } catch (e) {
      throw Exception('Failed to get API key: $e');
    }
  }
}
```

**Android native code (MainActivity.kt):**

```kotlin
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "secrets_channel")
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "getApiKey" -> {
                    val apiKey = getString(R.string.api_key)
                    result.success(apiKey)
                }
                else -> result.notImplemented()
            }
        }
}
```

### Method 3: Secure Storage

Use `flutter_secure_storage` for runtime secrets:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureConfig {
  static const _storage = FlutterSecureStorage();

  static Future<void> storeApiKey(String key) async {
    await _storage.write(key: 'api_key', value: key);
  }

  static Future<String?> getApiKey() async {
    return await _storage.read(key: 'api_key');
  }

  static Future<void> deleteApiKey() async {
    await _storage.delete(key: 'api_key');
  }
}
```

**Initialize on first run:**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if API key exists in secure storage
  String? apiKey = await SecureConfig.getApiKey();

  if (apiKey == null) {
    // First run - store the key
    final config = AppConfig.instance;
    await SecureConfig.storeApiKey(config.apiKey);
  }

  runApp(MyApp());
}
```

## Advanced Technique 6: Flavor-Specific Logging

Different logging strategies per flavor:

```dart
import 'package:logger/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppLogger {
  static late Logger _logger;

  static void initialize(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        // Verbose logging in dev
        _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
          ),
          level: Level.verbose,
        );
        break;

      case Flavor.staging:
        // Info level in staging
        _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 5,
            colors: true,
            printEmojis: true,
          ),
          level: Level.info,
        );
        break;

      case Flavor.prod:
        // Only warnings and errors in production
        _logger = Logger(
          printer: SimplePrinter(),
          level: Level.warning,
          output: CrashlyticsOutput(),  // Send to Crashlytics
        );
        break;
    }
  }

  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }
}

/// Custom output that sends logs to Crashlytics in production
class CrashlyticsOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      // Also print to console
      print(line);

      // Send errors to Crashlytics
      if (event.level.index >= Level.error.index) {
        FirebaseCrashlytics.instance.log(line);
      }
    }
  }
}
```

## Complete Real-World Example: Food Delivery App

Let's combine everything into a production-ready food delivery app!

### Project Structure

```
lib/
├── config/
│   ├── flavor.dart
│   ├── app_config.dart
│   ├── feature_flags.dart
│   └── app_logger.dart
├── services/
│   ├── api_service.dart
│   ├── firebase_service.dart
│   └── analytics_service.dart
├── models/
│   ├── restaurant.dart
│   └── order.dart
├── screens/
│   ├── home_page.dart
│   ├── restaurant_detail.dart
│   └── checkout_page.dart
├── widgets/
│   ├── flavor_banner.dart
│   └── debug_drawer.dart
├── my_app.dart
├── main_dev.dart
├── main_staging.dart
└── main_prod.dart
```

### Complete Feature Flags System

```dart
// lib/config/feature_flags.dart
import 'app_config.dart';
import 'flavor.dart';

class FeatureFlags {
  // UI Features
  static bool get useExperimentalUI => _getValue('experimental_ui');
  static bool get showNewDesign => _getValue('new_design');

  // Functionality
  static bool get enableGuestCheckout => _getValue('guest_checkout');
  static bool get enableScheduledOrders => _getValue('scheduled_orders');
  static bool get enableLoyaltyProgram => _getValue('loyalty_program');

  // Payment
  static bool get enableApplePay => _getValue('apple_pay');
  static bool get enableGooglePay => _getValue('google_pay');
  static bool get enableCryptoPay => _getValue('crypto_pay');  // Future!

  // Social Features
  static bool get enableSocialSharing => _getValue('social_sharing');
  static bool get enableReferralProgram => _getValue('referral_program');

  // Debug Features
  static bool get showDebugInfo => _getValue('debug_info');
  static bool get showPerformanceOverlay => _getValue('performance_overlay');
  static bool get enableDevTools => _getValue('dev_tools');

  // Map of feature flags per flavor
  static final Map<String, Map<Flavor, bool>> _features = {
    'experimental_ui': {
      Flavor.dev: true,
      Flavor.staging: false,
      Flavor.prod: false,
    },
    'new_design': {
      Flavor.dev: true,
      Flavor.staging: true,
      Flavor.prod: false,  // Not ready yet
    },
    'guest_checkout': {
      Flavor.dev: true,
      Flavor.staging: true,
      Flavor.prod: false,  // Require login in production
    },
    'scheduled_orders': {
      Flavor.dev: true,
      Flavor.staging: true,
      Flavor.prod: true,  // Feature is live!
    },
    'loyalty_program': {
      Flavor.dev: true,
      Flavor.staging: true,
      Flavor.prod: true,
    },
    'apple_pay': {
      Flavor.dev: false,  // Use fake payments in dev
      Flavor.staging: true,  // Test real payments
      Flavor.prod: true,
    },
    'google_pay': {
      Flavor.dev: false,
      Flavor.staging: true,
      Flavor.prod: true,
    },
    'crypto_pay': {
      Flavor.dev: true,  // Experiment in dev
      Flavor.staging: false,
      Flavor.prod: false,  // Not ready for production
    },
    'social_sharing': {
      Flavor.dev: true,
      Flavor.staging: true,
      Flavor.prod: true,
    },
    'referral_program': {
      Flavor.dev: true,
      Flavor.staging: false,  // Testing phase
      Flavor.prod: false,
    },
    'debug_info': {
      Flavor.dev: true,
      Flavor.staging: true,
      Flavor.prod: false,
    },
    'performance_overlay': {
      Flavor.dev: true,
      Flavor.staging: false,
      Flavor.prod: false,
    },
    'dev_tools': {
      Flavor.dev: true,
      Flavor.staging: false,
      Flavor.prod: false,
    },
  };

  static bool _getValue(String feature) {
    final flavor = AppConfig.instance.flavor;
    return _features[feature]?[flavor] ?? false;
  }

  /// Get all enabled features for current flavor
  static List<String> getEnabledFeatures() {
    final flavor = AppConfig.instance.flavor;
    return _features.entries
        .where((entry) => entry.value[flavor] == true)
        .map((entry) => entry.key)
        .toList();
  }
}
```

### Debug Drawer (Development Tool)

```dart
// lib/widgets/debug_drawer.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../config/feature_flags.dart';
import 'package:firebase_core/firebase_core.dart';

class DebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Only show in dev/staging
    final config = AppConfig.instance;
    if (config.flavor.isProd) {
      return SizedBox.shrink();
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: _getFlavorColor()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔧 Debug Tools',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(
                  config.flavor.name,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          _buildSection('Environment'),
          _buildInfoTile('Flavor', config.flavor.name),
          _buildInfoTile('API URL', config.apiBaseUrl),
          _buildInfoTile('Firebase', Firebase.app().options.projectId),
          Divider(),
          _buildSection('Feature Flags'),
          ...FeatureFlags.getEnabledFeatures()
              .map((feature) => _buildFeatureTile(feature)),
          Divider(),
          _buildSection('Actions'),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Clear Cache'),
            onTap: () => _clearCache(context),
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reload App'),
            onTap: () => _reloadApp(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label, style: TextStyle(fontSize: 12)),
      subtitle: Text(value, style: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildFeatureTile(String feature) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.check_circle, color: Colors.green, size: 16),
      title: Text(feature, style: TextStyle(fontSize: 12)),
    );
  }

  Color _getFlavorColor() {
    switch (AppConfig.instance.flavor) {
      case Flavor.dev:
        return Colors.orange;
      case Flavor.staging:
        return Colors.purple;
      case Flavor.prod:
        return Colors.blue;
    }
  }

  void _clearCache(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cache cleared!')),
    );
  }

  void _reloadApp(BuildContext context) {
    Navigator.pop(context);
    // Implementation would restart the app
  }
}
```

## Common Errors & Solutions

### Error 1: "Firebase project mismatch"

**Error:**
```
FirebaseException: Firebase project 'prod' doesn't match 'dev'
```

**Solution:**
- Check that correct `google-services.json` / `GoogleService-Info.plist` is copied
- For Android: Check flavor folders have correct files
- For iOS: Verify run script copies correct file
- Clean and rebuild: `flutter clean && flutter pub get`

### Error 2: "Feature flag returns null"

**Solution:**
- Provide default values in feature flag map
- Add null checks:
```dart
static bool _getValue(String feature) {
  return _features[feature]?[AppConfig.instance.flavor] ?? false;
}
```

### Error 3: "Secrets exposed in Git"

**Prevention:**
- Update `.gitignore` BEFORE committing secrets
- Use environment variables in CI/CD
- Use git pre-commit hooks to check for secrets:

```bash
# .git/hooks/pre-commit
#!/bin/bash
if git diff --cached | grep -E "(prod_key|secret|password|pk_live)"; then
    echo "❌ Attempting to commit secrets!"
    exit 1
fi
```

### Error 4: "Wrong Firebase project in production build"

**Solution:**
Add validation in production builds:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(Flavor.prod);
  await Firebase.initializeApp();

  // Validate Firebase project
  final projectId = Firebase.app().options.projectId;
  if (!projectId.contains('production') && !projectId.contains('prod')) {
    throw Exception('Wrong Firebase project in production: $projectId');
  }

  runApp(MyApp());
}
```

## Verification Checklist

✅ Multiple Firebase projects configured (dev, staging, prod)
✅ Each flavor connects to correct Firebase project
✅ Feature flags system implemented
✅ Feature flags work correctly per flavor
✅ Different themes/colors per flavor
✅ Flavor banner visible in dev/staging
✅ Secrets not hardcoded in source code
✅ Production secrets in `.gitignore`
✅ Debug drawer accessible in dev/staging
✅ Logging configured per flavor
✅ Analytics properly separated by flavor
✅ Can build and run all three flavors
✅ Each flavor behaves correctly

## Pro Tips

### 1. Use Assert for Safety Checks

```dart
void main() {
  AppConfig.initialize(Flavor.prod);

  assert(() {
    // This only runs in debug mode
    if (AppConfig.instance.flavor.isProd) {
      if (AppConfig.instance.apiUrl.contains('dev')) {
        throw Exception('Using dev API in production!');
      }
    }
    return true;
  }());

  runApp(MyApp());
}
```

### 2. Create Flavor Detection Utility

```dart
extension FlavorContext on BuildContext {
  Flavor get flavor => AppConfig.instance.flavor;
  bool get isDev => flavor.isDev;
  bool get isStaging => flavor.isStaging;
  bool get isProd => flavor.isProd;
}

// Usage:
if (context.isDev) {
  // Show debug info
}
```

### 3. Automate Secret Injection in CI/CD

```yaml
# .github/workflows/build.yml
- name: Inject secrets
  run: |
    echo "API_KEY=${{ secrets.PROD_API_KEY }}" >> .env.prod
    echo "STRIPE_KEY=${{ secrets.STRIPE_KEY }}" >> .env.prod
```

### 4. Document Your Flavors

Create `FLAVORS.md` in your project root:

```markdown
# App Flavors Guide

## Development
- **Command**: `flutter run --flavor dev -t lib/main_dev.dart`
- **Firebase**: myapp-dev
- **API**: https://dev-api.myapp.com
- **Features**: All features enabled, verbose logging

## Staging
- **Command**: `flutter run --flavor staging -t lib/main_staging.dart`
- **Firebase**: myapp-staging
- **API**: https://staging-api.myapp.com
- **Features**: Production-like, QA testing

## Production
- **Command**: `flutter build apk --flavor prod -t lib/main_prod.dart --release`
- **Firebase**: myapp-production
- **API**: https://api.myapp.com
- **Features**: Only stable features, minimal logging
```

## Next Lesson

Excellent work! You've mastered advanced flavor techniques! 🎉

In the final lesson, we'll build a **complete production-ready setup** including:
- Full working multi-flavor app
- CI/CD integration
- Deployment strategies
- Best practices and common pitfalls

**You're almost a flavor grandmaster!** 🚀
