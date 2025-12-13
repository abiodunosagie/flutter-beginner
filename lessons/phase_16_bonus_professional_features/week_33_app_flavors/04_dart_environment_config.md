# Managing Environment Configuration in Dart - Complete Guide

## Understanding Environment Configuration (5-Year-Old Explanation)

Imagine you're a secret agent with three different gadgets for three different missions:

**Training Mission (Dev):**
- Practice phone (makes fake calls)
- Toy laser (just lights up, doesn't cut)
- Plastic badge (looks real but says "TRAINING")

**Dress Rehearsal Mission (Staging):**
- Almost-real phone (calls test numbers)
- Training laser (safe mode enabled)
- Official-looking badge (says "REHEARSAL")

**Real Mission (Production):**
- Real phone (calls real people!)
- Real laser (BE CAREFUL!)
- Official badge (the real deal!)

**Same agent (you), different gadgets (configuration) for different situations!**

In Flutter, environment configuration means:
- Your **code** stays the same (the agent)
- Your **settings** change based on flavor (the gadgets)
- Each flavor uses different API endpoints, keys, features, etc.

## Why Environment Configuration Matters

### The Problem Without Proper Configuration

```dart
// BAD: Hardcoded values everywhere! 😱
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',  // Which version is this?
      home: HomePage(
        apiUrl: 'https://api.myapp.com',  // Always production?? 😱
        apiKey: 'prod-key-abc123',  // Using production key in dev?? 💀
      ),
    );
  }
}
```

**Problems:**
- ❌ Might accidentally test on production servers (DISASTER!)
- ❌ Production API keys exposed in code
- ❌ Can't easily switch between environments
- ❌ Hard to maintain and update

### The Solution: Environment Configuration

```dart
// GOOD: Configuration that adapts to flavor! 🎉
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appName,  // Different per flavor
      home: HomePage(
        apiUrl: Config.apiUrl,  // Different per flavor
        apiKey: Config.apiKey,  // Different per flavor
      ),
    );
  }
}
```

**Benefits:**
- ✅ Safe testing environment
- ✅ Secrets properly managed
- ✅ Easy to add new environments
- ✅ Clear, maintainable code

## Method 1: Enum-Based Configuration (Simple & Good for Beginners)

This is the simplest approach and works great for most apps!

### Step 1: Create Flavor Enum

Create: `lib/config/flavor.dart`

```dart
/// Defines the available app flavors (environments)
enum Flavor {
  dev,      // Development - for daily coding
  staging,  // Staging - for testing and demos
  prod,     // Production - for real users
}

/// Extension to add helpful methods to Flavor enum
extension FlavorExtension on Flavor {
  /// Returns true if current flavor is development
  bool get isDev => this == Flavor.dev;

  /// Returns true if current flavor is staging
  bool get isStaging => this == Flavor.staging;

  /// Returns true if current flavor is production
  bool get isProd => this == Flavor.prod;

  /// Returns the flavor name as a string
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

  /// Returns a developer-friendly description
  String get description {
    switch (this) {
      case Flavor.dev:
        return 'Development environment for testing';
      case Flavor.staging:
        return 'Staging environment for QA and demos';
      case Flavor.prod:
        return 'Production environment for real users';
    }
  }
}
```

**5-Year-Old Explanation:**
Think of this as a list of your superhero costumes. Each costume (flavor) has a name and special properties!

### Step 2: Create Configuration Class

Create: `lib/config/app_config.dart`

```dart
import 'flavor.dart';

/// Central configuration for the entire app
/// Contains all environment-specific settings
class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final String apiKey;
  final bool debugShowBanner;
  final bool enableLogging;
  final int apiTimeout;

  /// Private constructor (we control how this is created)
  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.debugShowBanner,
    required this.enableLogging,
    required this.apiTimeout,
  });

  /// Factory constructor - creates the right config for each flavor
  factory AppConfig.forFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return AppConfig._(
          flavor: flavor,
          appName: 'MyApp DEV',
          apiBaseUrl: 'https://dev-api.myapp.com',
          apiKey: 'dev_key_12345',
          debugShowBanner: true,  // Show "DEBUG" banner
          enableLogging: true,     // Show all logs
          apiTimeout: 30,          // Longer timeout for debugging
        );

      case Flavor.staging:
        return AppConfig._(
          flavor: flavor,
          appName: 'MyApp STAGING',
          apiBaseUrl: 'https://staging-api.myapp.com',
          apiKey: 'staging_key_67890',
          debugShowBanner: true,   // Show "DEBUG" banner
          enableLogging: true,      // Show logs for QA
          apiTimeout: 20,           // Moderate timeout
        );

      case Flavor.prod:
        return AppConfig._(
          flavor: flavor,
          appName: 'MyApp',
          apiBaseUrl: 'https://api.myapp.com',
          apiKey: 'prod_key_SECRET',  // Real API key (should come from env)
          debugShowBanner: false,      // Hide debug banner
          enableLogging: false,        // Only log errors
          apiTimeout: 10,              // Fast timeout
        );
    }
  }

  /// Current active configuration (set during app startup)
  static late AppConfig instance;

  /// Initialize the app configuration
  static void initialize(Flavor flavor) {
    instance = AppConfig.forFlavor(flavor);
  }
}
```

**5-Year-Old Explanation:**
This is like your **gadget selector**. When you pick a mission (flavor), it automatically gives you the right tools (settings) for that mission!

### Step 3: Create Entry Points for Each Flavor

The magic happens here! We create separate entry files for each flavor.

**Create: `lib/main_dev.dart`**

```dart
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'my_app.dart';

void main() {
  // Initialize configuration for DEVELOPMENT
  AppConfig.initialize(Flavor.dev);

  // Run the app
  runApp(const MyApp());
}
```

**Create: `lib/main_staging.dart`**

```dart
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'my_app.dart';

void main() {
  // Initialize configuration for STAGING
  AppConfig.initialize(Flavor.staging);

  // Run the app
  runApp(const MyApp());
}
```

**Create: `lib/main_prod.dart`**

```dart
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'my_app.dart';

void main() {
  // Initialize configuration for PRODUCTION
  AppConfig.initialize(Flavor.prod);

  // Run the app
  runApp(const MyApp());
}
```

**5-Year-Old Explanation:**
Think of these as three different **starting gates** for a race:
- Gate 1 (dev): Starts with practice mode activated
- Gate 2 (staging): Starts with rehearsal mode activated
- Gate 3 (prod): Starts with real mode activated

Same race track (your app), different starting configurations!

### Step 4: Update Your Main App Widget

**Update: `lib/my_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'config/app_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access configuration anywhere in the app!
    final config = AppConfig.instance;

    return MaterialApp(
      title: config.appName,  // Different title per flavor

      // Show debug banner in dev/staging, hide in production
      debugShowCheckedModeBanner: config.debugShowBanner,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: HomePage(),
    );
  }
}
```

### Step 5: Use Configuration Throughout Your App

**Example: API Service**

Create: `lib/services/api_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  final AppConfig _config = AppConfig.instance;

  /// Makes a GET request to the API
  Future<Map<String, dynamic>> get(String endpoint) async {
    // Build URL using config
    final url = Uri.parse('${_config.apiBaseUrl}$endpoint');

    // Log in dev/staging only
    if (_config.enableLogging) {
      print('🌐 API GET: $url');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${_config.apiKey}',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: _config.apiTimeout));

      if (_config.enableLogging) {
        print('✅ Response: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Log errors (always, even in production)
      print('❌ API Error: $e');
      rethrow;
    }
  }

  /// Makes a POST request to the API
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('${_config.apiBaseUrl}$endpoint');

    if (_config.enableLogging) {
      print('🌐 API POST: $url');
      print('📦 Data: $data');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${_config.apiKey}',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      ).timeout(Duration(seconds: _config.apiTimeout));

      if (_config.enableLogging) {
        print('✅ Response: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error: $e');
      rethrow;
    }
  }
}
```

**Example: Using in a Widget**

```dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  final AppConfig _config = AppConfig.instance;

  String _data = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final result = await _api.get('/users/me');
      setState(() {
        _data = result.toString();
      });
    } catch (e) {
      setState(() {
        _data = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_config.appName),
        backgroundColor: _getFavorColor(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show environment info (helpful in dev/staging)
            _buildEnvironmentBanner(),
            SizedBox(height: 20),

            // Show data
            Text(
              'Data from API:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_data),
          ],
        ),
      ),
    );
  }

  /// Build a banner showing current environment
  Widget _buildEnvironmentBanner() {
    // Only show in dev/staging
    if (_config.flavor.isProd) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getFavorColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getFavorColor(), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔧 ${_config.flavor.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _getFavorColor(),
            ),
          ),
          SizedBox(height: 4),
          Text(
            _config.flavor.description,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 8),
          Text('API: ${_config.apiBaseUrl}', style: TextStyle(fontSize: 10)),
          Text('Timeout: ${_config.apiTimeout}s', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  /// Get color based on flavor
  Color _getFavorColor() {
    switch (_config.flavor) {
      case Flavor.dev:
        return Colors.orange;  // Orange = development
      case Flavor.staging:
        return Colors.purple;  // Purple = staging
      case Flavor.prod:
        return Colors.blue;    // Blue = production
    }
  }
}
```

### Step 6: Configure Flutter to Use Different Entry Points

We need to tell Flutter which entry point to use for each flavor!

**Update Android (`android/app/build.gradle`):**

Find your `productFlavors` section and add:

```gradle
productFlavors {
    dev {
        dimension "app"
        applicationIdSuffix ".dev"
        versionNameSuffix "-dev"
        resValue "string", "app_name", "MyApp DEV"
    }

    staging {
        dimension "app"
        applicationIdSuffix ".staging"
        versionNameSuffix "-staging"
        resValue "string", "app_name", "MyApp STAGING"
    }

    prod {
        dimension "app"
        resValue "string", "app_name", "MyApp"
    }
}
```

**For iOS, update each scheme's Build Settings:**

In Xcode, for each configuration, you can pass the entry point via Flutter's build settings. But Flutter's command-line tool handles this automatically!

### Step 7: Run Your App with Different Flavors

```bash
# Run development (uses lib/main_dev.dart)
flutter run --flavor dev -t lib/main_dev.dart

# Run staging (uses lib/main_staging.dart)
flutter run --flavor staging -t lib/main_staging.dart

# Run production (uses lib/main_prod.dart)
flutter run --flavor prod -t lib/main_prod.dart
```

**What happens:**
1. Flutter reads the `--flavor` flag
2. Loads the corresponding entry file (`-t lib/main_dev.dart`)
3. That file initializes `AppConfig` with the right flavor
4. Your entire app now uses those settings!

## Method 2: Using --dart-define (Advanced & More Secure)

`--dart-define` lets you pass environment variables at **compile time**. This is more secure because values aren't hardcoded in your source code!

### Step 1: Pass Values via Command Line

```bash
flutter run \
  --flavor dev \
  --dart-define=FLAVOR=dev \
  --dart-define=API_URL=https://dev-api.myapp.com \
  --dart-define=API_KEY=dev_key_12345
```

**5-Year-Old Explanation:**
This is like a secret code you whisper to your app when you start it:
- "Hey app, you're in DEV mode"
- "Use THIS API server"
- "Use THIS secret key"

The app remembers these secrets while it's running!

### Step 2: Read Values in Dart

```dart
class AppConfig {
  // Read compile-time constants
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://dev-api.myapp.com',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  // Derived values
  static bool get isDev => flavor == 'dev';
  static bool get isStaging => flavor == 'staging';
  static bool get isProd => flavor == 'prod';
}
```

**Benefits:**
- ✅ Secrets aren't in source code
- ✅ Can't accidentally commit API keys
- ✅ Different developers can use different values
- ✅ CI/CD systems can inject values

**Drawbacks:**
- ⚠️ More complex to set up
- ⚠️ Must remember to pass values every time
- ⚠️ IDE run configurations need setup

### Step 3: Create Run Scripts (Make It Easy)

Create shell scripts to avoid typing long commands!

**Create: `scripts/run_dev.sh`**

```bash
#!/bin/bash
flutter run \
  --flavor dev \
  -t lib/main_dev.dart \
  --dart-define=FLAVOR=dev \
  --dart-define=API_URL=https://dev-api.myapp.com \
  --dart-define=API_KEY=dev_key_12345 \
  --dart-define=ENABLE_LOGGING=true
```

**Create: `scripts/run_staging.sh`**

```bash
#!/bin/bash
flutter run \
  --flavor staging \
  -t lib/main_staging.dart \
  --dart-define=FLAVOR=staging \
  --dart-define=API_URL=https://staging-api.myapp.com \
  --dart-define=API_KEY=staging_key_67890 \
  --dart-define=ENABLE_LOGGING=true
```

**Create: `scripts/run_prod.sh`**

```bash
#!/bin/bash
flutter run \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define=FLAVOR=prod \
  --dart-define=API_URL=https://api.myapp.com \
  --dart-define=API_KEY=${PROD_API_KEY} \  # From environment variable!
  --dart-define=ENABLE_LOGGING=false
```

**Make scripts executable:**
```bash
chmod +x scripts/run_dev.sh
chmod +x scripts/run_staging.sh
chmod +x scripts/run_prod.sh
```

**Now just run:**
```bash
./scripts/run_dev.sh
```

Much easier! 🎉

### Step 4: Use .env Files (Even Better!)

Instead of shell scripts, use a package like `flutter_dotenv` to load from files!

**Add dependency to `pubspec.yaml`:**

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

**Create environment files:**

**.env.dev:**
```env
FLAVOR=dev
API_URL=https://dev-api.myapp.com
API_KEY=dev_key_12345
ENABLE_LOGGING=true
APP_NAME=MyApp DEV
```

**.env.staging:**
```env
FLAVOR=staging
API_URL=https://staging-api.myapp.com
API_KEY=staging_key_67890
ENABLE_LOGGING=true
APP_NAME=MyApp STAGING
```

**.env.prod:**
```env
FLAVOR=prod
API_URL=https://api.myapp.com
API_KEY=prod_key_SECRET_DONT_COMMIT
ENABLE_LOGGING=false
APP_NAME=MyApp
```

**Update `.gitignore`:**
```
# Don't commit production secrets!
.env.prod
```

**Load in your app:**

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load environment file
  await dotenv.load(fileName: ".env.dev");

  // Read values
  final apiUrl = dotenv.env['API_URL'] ?? '';
  final apiKey = dotenv.env['API_KEY'] ?? '';

  runApp(MyApp());
}
```

## Method 3: Combining Both (Professional Setup)

The best approach combines both methods:
- Use **enum-based config** for structure
- Use **--dart-define** for secrets
- Use **.env files** for convenience

**Complete example:**

```dart
import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final String apiKey;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.apiKey,
  });

  factory AppConfig.forFlavor(Flavor flavor) {
    // Get API key from compile-time constant (secure!)
    const apiKey = String.fromEnvironment('API_KEY');

    switch (flavor) {
      case Flavor.dev:
        return AppConfig._(
          flavor: flavor,
          appName: 'MyApp DEV',
          apiBaseUrl: const String.fromEnvironment(
            'API_URL',
            defaultValue: 'https://dev-api.myapp.com',
          ),
          apiKey: apiKey.isEmpty ? 'dev_key_12345' : apiKey,
        );

      case Flavor.staging:
        return AppConfig._(
          flavor: flavor,
          appName: 'MyApp STAGING',
          apiBaseUrl: const String.fromEnvironment(
            'API_URL',
            defaultValue: 'https://staging-api.myapp.com',
          ),
          apiKey: apiKey.isEmpty ? 'staging_key_67890' : apiKey,
        );

      case Flavor.prod:
        return AppConfig._(
          flavor: flavor,
          appName: 'MyApp',
          apiBaseUrl: const String.fromEnvironment(
            'API_URL',
            defaultValue: 'https://api.myapp.com',
          ),
          apiKey: apiKey,  // MUST be provided for production!
        );
    }
  }

  static late AppConfig instance;

  static void initialize(Flavor flavor) {
    instance = AppConfig.forFlavor(flavor);

    // Validate production config
    if (flavor == Flavor.prod && instance.apiKey.isEmpty) {
      throw Exception('Production API key not provided!');
    }
  }
}
```

## Complete Working Example

Let's put it all together with a real food delivery app!

### Project Structure

```
lib/
├── config/
│   ├── flavor.dart
│   └── app_config.dart
├── services/
│   └── api_service.dart
├── screens/
│   └── home_page.dart
├── my_app.dart
├── main_dev.dart
├── main_staging.dart
└── main_prod.dart
```

### Complete Implementation

**lib/config/flavor.dart** (already shown above)

**lib/config/app_config.dart:**

```dart
import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final String apiKey;
  final bool debugMode;
  final bool enableAnalytics;
  final String stripePublicKey;
  final int maxCartItems;
  final double deliveryFee;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.debugMode,
    required this.enableAnalytics,
    required this.stripePublicKey,
    required this.maxCartItems,
    required this.deliveryFee,
  });

  factory AppConfig.forFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return AppConfig._(
          flavor: flavor,
          appName: 'FoodApp DEV',
          apiBaseUrl: 'https://dev-api.foodapp.com',
          apiKey: 'dev_key_12345',
          debugMode: true,
          enableAnalytics: false,  // Don't track test users
          stripePublicKey: 'pk_test_...',  // Stripe test key
          maxCartItems: 100,  // No limit in dev
          deliveryFee: 0.0,  // Free delivery in dev
        );

      case Flavor.staging:
        return AppConfig._(
          flavor: flavor,
          appName: 'FoodApp STAGING',
          apiBaseUrl: 'https://staging-api.foodapp.com',
          apiKey: 'staging_key_67890',
          debugMode: true,
          enableAnalytics: false,  // Don't track QA testing
          stripePublicKey: 'pk_test_...',  // Still using test key
          maxCartItems: 50,  // Realistic limit
          deliveryFee: 2.99,  // Real pricing
        );

      case Flavor.prod:
        return AppConfig._(
          flavor: flavor,
          appName: 'FoodApp',
          apiBaseUrl: 'https://api.foodapp.com',
          apiKey: const String.fromEnvironment('API_KEY'),
          debugMode: false,
          enableAnalytics: true,  // Track real users
          stripePublicKey: const String.fromEnvironment(
            'STRIPE_KEY',
            defaultValue: '',
          ),
          maxCartItems: 50,
          deliveryFee: 2.99,
        );
    }
  }

  static late AppConfig instance;

  static void initialize(Flavor flavor) {
    instance = AppConfig.forFlavor(flavor);
    _validate();
  }

  static void _validate() {
    if (instance.flavor.isProd) {
      if (instance.apiKey.isEmpty) {
        throw Exception('Production API key is required!');
      }
      if (instance.stripePublicKey.isEmpty) {
        throw Exception('Production Stripe key is required!');
      }
    }
  }
}
```

**lib/services/api_service.dart:**

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  final AppConfig _config = AppConfig.instance;

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    final url = Uri.parse('${_config.apiBaseUrl}/restaurants');

    if (_config.debugMode) {
      print('🍔 Fetching restaurants from: $url');
    }

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${_config.apiKey}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<void> placeOrder(Map<String, dynamic> order) async {
    final url = Uri.parse('${_config.apiBaseUrl}/orders');

    if (_config.debugMode) {
      print('📦 Placing order: $order');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${_config.apiKey}',
        'Content-Type': 'application/json',
      },
      body: json.encode(order),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to place order');
    }
  }
}
```

**lib/screens/home_page.dart:**

```dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  final AppConfig _config = AppConfig.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_config.appName),
        backgroundColor: _getFlavorColor(),
        actions: [
          if (_config.debugMode)
            IconButton(
              icon: Icon(Icons.bug_report),
              onPressed: _showDebugInfo,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_config.debugMode) _buildDebugBanner(),
          Expanded(child: _buildRestaurantList()),
        ],
      ),
    );
  }

  Widget _buildDebugBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      color: _getFlavorColor().withOpacity(0.2),
      child: Text(
        '${_config.flavor.name} | ${_config.apiBaseUrl}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _api.getRestaurants(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final restaurant = snapshot.data![index];
              return ListTile(
                title: Text(restaurant['name']),
                subtitle: Text('Delivery: \$${_config.deliveryFee}'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Color _getFlavorColor() {
    switch (_config.flavor) {
      case Flavor.dev:
        return Colors.orange;
      case Flavor.staging:
        return Colors.purple;
      case Flavor.prod:
        return Colors.blue;
    }
  }

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Debug Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flavor: ${_config.flavor.name}'),
            Text('API: ${_config.apiBaseUrl}'),
            Text('Debug Mode: ${_config.debugMode}'),
            Text('Analytics: ${_config.enableAnalytics}'),
            Text('Max Cart: ${_config.maxCartItems}'),
          ],
        ),
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
```

## Common Errors & Solutions

### Error 1: "Late variable 'instance' has not been initialized"

**Error:**
```
LateInitializationError: Field 'instance' has not been initialized.
```

**Solution:**
Make sure you call `AppConfig.initialize()` in your `main()` function BEFORE `runApp()`:

```dart
void main() {
  AppConfig.initialize(Flavor.dev);  // ← Must call this first!
  runApp(MyApp());
}
```

### Error 2: "The argument type 'String' can't be assigned to 'bool'"

**Error when using String.fromEnvironment:**
```
--dart-define=DEBUG=true  // ← This is a STRING "true", not boolean!
```

**Solution:**
Convert to boolean manually:

```dart
static final bool isDebug =
  const String.fromEnvironment('DEBUG', defaultValue: 'false') == 'true';
```

### Error 3: "Multiple entry points"

**Solution:**
Always specify the entry point with `-t`:

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Error 4: "Config values are null"

**Problem:** Using `String.fromEnvironment` but not passing `--dart-define`

**Solution:**
Either pass values:
```bash
flutter run --dart-define=API_KEY=abc123
```

Or provide default values:
```dart
const String apiKey = String.fromEnvironment('API_KEY', defaultValue: 'dev_key');
```

## Verification Checklist

✅ Created `lib/config/flavor.dart` with Flavor enum
✅ Created `lib/config/app_config.dart` with configuration class
✅ Created `lib/main_dev.dart`, `lib/main_staging.dart`, `lib/main_prod.dart`
✅ Each main file calls `AppConfig.initialize()` with correct flavor
✅ Can access `AppConfig.instance` throughout the app
✅ Different API endpoints for each flavor
✅ Different app names for each flavor
✅ Debug features enabled in dev/staging, disabled in prod
✅ Running `flutter run --flavor dev -t lib/main_dev.dart` works
✅ Config values are correct for each flavor

## Pro Tips

### 1. Add Type Safety with Const

Use `const` constructors when possible:

```dart
class ApiEndpoints {
  static const String users = '/api/v1/users';
  static const String orders = '/api/v1/orders';
  static const String restaurants = '/api/v1/restaurants';
}

// Usage:
final url = '${AppConfig.instance.apiBaseUrl}${ApiEndpoints.users}';
```

### 2. Create Helper Extensions

```dart
extension ConfigContext on BuildContext {
  AppConfig get config => AppConfig.instance;
}

// Usage in widgets:
Text('Welcome to ${context.config.appName}')
```

### 3. Validate in Debug Mode

```dart
void main() {
  assert(() {
    // This only runs in debug mode
    if (AppConfig.instance.flavor.isProd) {
      if (AppConfig.instance.apiKey.startsWith('dev_')) {
        throw Exception('Using dev API key in production!');
      }
    }
    return true;
  }());

  runApp(MyApp());
}
```

### 4. Use Different Firebase Projects

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(Flavor.dev);

  // Initialize Firebase with different config per flavor
  if (AppConfig.instance.flavor.isDev) {
    await Firebase.initializeApp(
      options: FirebaseOptions(/* dev config */),
    );
  } else if (AppConfig.instance.flavor.isProd) {
    await Firebase.initializeApp(
      options: FirebaseOptions(/* prod config */),
    );
  }

  runApp(MyApp());
}
```

## Next Lesson

Great job! You now know how to manage environment configuration like a pro! 🎉

In the next lesson, we'll explore **advanced flavor techniques** including:
- Different Firebase projects per flavor
- Feature flags
- Different app icons dynamically
- Environment-specific dependencies
- Secrets management

**You're becoming a configuration master!** 🚀
