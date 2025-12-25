# Practical API Key Security: A Step-by-Step Guide

## The Problem You're Facing

You're building an Uber-like app. You have:
- Google Maps API Key
- Stripe Payment Key
- Your Backend API Key
- Firebase API Key

**Where do you put them so hackers can't steal them?**

---

## Why the Assets Folder is NOT Safe

```
COMMON MISTAKE - Putting secrets in assets:

my_app/
├── assets/
│   └── config.json        ← ANYONE can extract this!
│       {
│         "google_maps_key": "AIza...",
│         "stripe_key": "sk_live_..."
│       }
```

### Why This is Dangerous

APK and IPA files are just ZIP files. Anyone can:

```bash
# Extract APK
$ unzip -l app.apk | grep assets
  assets/config.json        ← Found!

$ unzip app.apk assets/config.json
$ cat assets/config.json
{"google_maps_key": "AIza..."}  ← KEY EXPOSED!
```

### Never Put Secrets In:
- `assets/` folder
- Any JSON/XML file in your project
- Hardcoded strings in Dart files
- Android `res/values/strings.xml`
- iOS `Info.plist`

---

## Method 1: --dart-define (RECOMMENDED)

This is the best method for most keys. Keys are injected at **build time**, not stored in source code.

### Step 1: Create Your Config Class

Create `lib/config/app_config.dart`:

```dart
/// lib/config/app_config.dart
class AppConfig {
  // Keys are injected at compile time via --dart-define
  // The source code only contains empty strings!

  static const String googleMapsKey = String.fromEnvironment(
    'GOOGLE_MAPS_KEY',
    defaultValue: '',
  );

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_KEY',
    defaultValue: '',
  );

  static const String backendApiKey = String.fromEnvironment(
    'BACKEND_API_KEY',
    defaultValue: '',
  );

  // Helper to check if keys are configured
  static bool get isConfigured {
    return googleMapsKey.isNotEmpty &&
           stripePublishableKey.isNotEmpty &&
           backendApiKey.isNotEmpty;
  }

  // Validate at app startup
  static void validateConfiguration() {
    final missingKeys = <String>[];

    if (googleMapsKey.isEmpty) missingKeys.add('GOOGLE_MAPS_KEY');
    if (stripePublishableKey.isEmpty) missingKeys.add('STRIPE_KEY');
    if (backendApiKey.isEmpty) missingKeys.add('BACKEND_API_KEY');

    if (missingKeys.isNotEmpty) {
      throw Exception(
        'Missing environment variables: ${missingKeys.join(', ')}\n'
        'Run with: flutter run --dart-define=KEY=value'
      );
    }
  }
}
```

### Step 2: Use Keys in Your App

```dart
/// lib/main.dart
import 'package:flutter/material.dart';
import 'config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate configuration before starting app
  try {
    AppConfig.validateConfiguration();
  } catch (e) {
    print('Warning: $e');
  }

  runApp(const MyRideApp());
}
```

```dart
/// lib/services/maps_service.dart
import '../config/app_config.dart';

class MapsService {
  Future<List<dynamic>> searchPlaces(String query) async {
    final apiKey = AppConfig.googleMapsKey;

    if (apiKey.isEmpty) {
      throw Exception('Google Maps API key not configured!');
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$query'
      '&key=$apiKey'
    );

    // Make your request...
    final response = await http.get(url);
    return jsonDecode(response.body)['predictions'];
  }
}
```

### Step 3: Create Run Scripts

Create `run_dev.sh` in your project root:

```bash
#!/bin/bash
# run_dev.sh - Development with test keys (safe to commit)

flutter run \
  --dart-define=GOOGLE_MAPS_KEY=AIzaSyDEV_TEST_KEY_12345 \
  --dart-define=STRIPE_KEY=pk_test_xxxxxxxxxxxxx \
  --dart-define=BACKEND_API_KEY=dev_api_key_12345
```

Create `build_release.sh` (NEVER commit this):

```bash
#!/bin/bash
# build_release.sh - Production build with real keys

# Option 1: Keys from environment variables
flutter build apk --release \
  --obfuscate \
  --split-debug-info=./debug-info \
  --dart-define=GOOGLE_MAPS_KEY=$GOOGLE_MAPS_KEY \
  --dart-define=STRIPE_KEY=$STRIPE_KEY \
  --dart-define=BACKEND_API_KEY=$BACKEND_API_KEY

# Option 2: Keys from a secrets file
# source ~/.my_app_secrets
# flutter build apk --release ...
```

### Step 4: Update .gitignore

```gitignore
# .gitignore

# Production scripts with real keys
build_release.sh
run_prod.sh

# Secret files
*_secrets
*.secrets
```

### Step 5: Running Your App

```bash
# Development (test keys)
chmod +x run_dev.sh
./run_dev.sh

# Or manually:
flutter run \
  --dart-define=GOOGLE_MAPS_KEY=test_key \
  --dart-define=STRIPE_KEY=pk_test_xxx
```

---

## Method 2: flutter_dotenv (Good for Development)

This method uses `.env` files, which is familiar if you've used Node.js.

### Step 1: Add the Package

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0

flutter:
  assets:
    - .env.development
    - .env.production
```

### Step 2: Create Environment Files

**`.env.example`** (Commit this - shows what keys are needed):
```env
# Copy to .env.development or .env.production
GOOGLE_MAPS_KEY=your_key_here
STRIPE_KEY=your_key_here
BACKEND_API_KEY=your_key_here
BACKEND_URL=https://api.yourapp.com
```

**`.env.development`** (Can commit - test keys only):
```env
GOOGLE_MAPS_KEY=AIzaSyDEV_TEST_KEY_12345
STRIPE_KEY=pk_test_51ABC123
BACKEND_API_KEY=dev_key_for_testing
BACKEND_URL=https://dev-api.yourapp.com
```

**`.env.production`** (NEVER commit!):
```env
GOOGLE_MAPS_KEY=AIzaSyPROD_REAL_KEY_67890
STRIPE_KEY=pk_live_51XYZ789
BACKEND_API_KEY=prod_secret_key_abc123
BACKEND_URL=https://api.yourapp.com
```

### Step 3: Update .gitignore

```gitignore
# Environment files
.env.production
.env.local
*.env.local

# Keep these for reference
!.env.example
!.env.development
```

### Step 4: Load Environment in main.dart

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the right .env file based on build mode
  await dotenv.load(
    fileName: kDebugMode ? '.env.development' : '.env.production',
  );

  runApp(const MyApp());
}
```

### Step 5: Create Config Class

```dart
/// lib/config/env_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get googleMapsKey => _getEnv('GOOGLE_MAPS_KEY');
  static String get stripeKey => _getEnv('STRIPE_KEY');
  static String get backendApiKey => _getEnv('BACKEND_API_KEY');
  static String get backendUrl => _getEnv('BACKEND_URL');

  static String _getEnv(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Environment variable $key not found!');
    }
    return value;
  }
}
```

### Step 6: Use in Your Services

```dart
import '../config/env_config.dart';

class MapsService {
  Future<void> searchPlaces(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$query'
      '&key=${EnvConfig.googleMapsKey}'
    );

    // Make request...
  }
}
```

---

## Method 3: Backend Proxy (MOST SECURE)

For sensitive APIs (payments, AI, etc.), the **safest approach** is to keep keys on your server only.

### The Problem with Client-Side Keys

Even with `--dart-define`, a determined hacker can extract keys from a running app using memory inspection tools.

### The Solution

Your app NEVER has the real API key. Your SERVER has it.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                              │
│  TRADITIONAL (Less Secure):                                                 │
│                                                                              │
│  Flutter App ──[Stripe Key]──> Stripe API                                   │
│       │                            │                                        │
│       └── Hacker can extract key ──┘                                        │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  WITH BACKEND PROXY (More Secure):                                          │
│                                                                              │
│  Flutter App ──[User Token]──> Your Backend ──[Stripe Key]──> Stripe        │
│       │                              │                                       │
│       └── Hacker only gets user token (useless for API access)              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Flutter Code (No Stripe Key!)

```dart
/// lib/services/payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String backendUrl;
  final String userAuthToken;

  PaymentService({
    required this.backendUrl,
    required this.userAuthToken,
  });

  /// Create a payment intent - your backend talks to Stripe!
  Future<Map<String, dynamic>> createPaymentIntent({
    required int amountInCents,
    required String currency,
  }) async {
    // Your app calls YOUR backend - NO Stripe key here!
    final response = await http.post(
      Uri.parse('$backendUrl/payments/create-intent'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userAuthToken',  // User's token, not API key!
      },
      body: jsonEncode({
        'amount': amountInCents,
        'currency': currency,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Payment failed: ${response.body}');
    }
  }

  /// Charge for a ride
  Future<Map<String, dynamic>> chargeForRide({
    required String rideId,
    required int fareInCents,
    required String paymentMethodId,
  }) async {
    final response = await http.post(
      Uri.parse('$backendUrl/payments/charge-ride'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userAuthToken',
      },
      body: jsonEncode({
        'ride_id': rideId,
        'amount': fareInCents,
        'payment_method_id': paymentMethodId,
      }),
    );

    return jsonDecode(response.body);
  }
}
```

### Backend Code (Has the Real Key)

**Node.js Example:**

```javascript
// server.js
const express = require('express');
const Stripe = require('stripe');

// Stripe key is ONLY on the server!
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

const app = express();
app.use(express.json());

// Middleware to verify user auth token
const verifyAuth = async (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  // Verify token (use your auth system)
  const userId = await verifyToken(token);
  if (!userId) {
    return res.status(401).json({ error: 'Invalid token' });
  }

  req.userId = userId;
  next();
};

app.post('/payments/create-intent', verifyAuth, async (req, res) => {
  const { amount, currency } = req.body;

  try {
    // Create payment intent using server-side Stripe key
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      metadata: { user_id: req.userId },
    });

    // Only send client_secret to the app (NOT the API key!)
    res.json({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(3000);
```

---

## Method 4: Native Platform Secrets (Google Maps)

Some SDKs (like Google Maps) require keys in native platform files.

### Android: local.properties + Gradle

**Step 1:** Add keys to `android/local.properties`:
```properties
# This file is already in .gitignore by default!
GOOGLE_MAPS_API_KEY=AIzaSy...your_real_key_here
```

**Step 2:** Read in `android/app/build.gradle`:
```groovy
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

android {
    defaultConfig {
        // Inject into manifest
        manifestPlaceholders = [
            googleMapsApiKey: localProperties.getProperty('GOOGLE_MAPS_API_KEY', '')
        ]
    }
}
```

**Step 3:** Use in `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="${googleMapsApiKey}" />
    </application>
</manifest>
```

### iOS: xcconfig Files

**Step 1:** Create `ios/Flutter/Development.xcconfig`:
```
GOOGLE_MAPS_API_KEY=AIzaSyDEV_KEY_12345
```

**Step 2:** Create `ios/Flutter/Production.xcconfig` (gitignored):
```
GOOGLE_MAPS_API_KEY=AIzaSyPROD_KEY_67890
```

**Step 3:** Add to `ios/.gitignore`:
```
Flutter/Production.xcconfig
```

**Step 4:** Reference in `ios/Runner/Info.plist`:
```xml
<key>GoogleMapsApiKey</key>
<string>$(GOOGLE_MAPS_API_KEY)</string>
```

**Step 5:** Use in `ios/Runner/AppDelegate.swift`:
```swift
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsApiKey") as? String ?? ""
        GMSServices.provideAPIKey(apiKey)
        return true
    }
}
```

---

## Complete Project Structure

Here's how your Uber-like app should be structured:

```
uber_clone/
├── .gitignore                    ← Ignores all secret files
├── .env.example                  ← Template (commit this)
├── .env.development              ← Dev keys (can commit test keys)
├── .env.production               ← Real keys (NEVER commit!)
│
├── run_dev.sh                    ← Dev runner script (commit)
├── build_release.sh              ← Production build (gitignored)
│
├── android/
│   ├── local.properties          ← Android secrets (gitignored by default)
│   └── app/
│       ├── build.gradle          ← Reads from local.properties
│       └── src/main/
│           └── AndroidManifest.xml
│
├── ios/
│   ├── Flutter/
│   │   ├── Development.xcconfig  ← Dev keys
│   │   └── Production.xcconfig   ← Real keys (gitignored)
│   └── Runner/
│       ├── Info.plist
│       └── AppDelegate.swift
│
└── lib/
    ├── main.dart
    ├── config/
    │   └── app_config.dart       ← Accesses dart-define values
    │
    └── services/
        ├── maps_service.dart     ← Uses AppConfig.googleMapsKey
        ├── payment_service.dart  ← Calls YOUR backend (no Stripe key!)
        └── api_service.dart      ← Uses AppConfig.backendApiKey
```

---

## Complete .gitignore

```gitignore
# ===== SECRETS =====
# Production environment files
.env.production
.env.local
*.env.local

# Shell scripts with secrets
run_prod.sh
build_release.sh
*_secrets
*.secrets

# ===== ANDROID =====
**/android/local.properties
**/android/key.properties
**/android/*.jks
**/android/*.keystore

# ===== iOS =====
**/ios/Flutter/Production.xcconfig
**/ios/Flutter/Secrets.xcconfig

# ===== DEBUG INFO =====
debug-info/
```

---

## CI/CD: GitHub Actions

When building in CI/CD, keys come from GitHub Secrets.

```yaml
# .github/workflows/release.yml

name: Build Release

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Build APK with secrets
        run: |
          flutter build apk --release \
            --obfuscate \
            --split-debug-info=./debug-info \
            --dart-define=GOOGLE_MAPS_KEY=${{ secrets.GOOGLE_MAPS_KEY }} \
            --dart-define=STRIPE_KEY=${{ secrets.STRIPE_KEY }} \
            --dart-define=BACKEND_API_KEY=${{ secrets.BACKEND_API_KEY }}
```

**To add secrets:**
1. Go to your GitHub repo
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add your keys

---

## Which Method Should You Use?

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     CHOOSING THE RIGHT METHOD                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  GOOGLE MAPS API KEY:                                                        │
│  ├─ Android: local.properties + build.gradle                                │
│  ├─ iOS: xcconfig + Info.plist                                              │
│  └─ Also restrict key in Google Cloud Console!                              │
│                                                                              │
│  STRIPE / PAYMENT KEYS:                                                      │
│  ├─ Publishable key (pk_): --dart-define (safe in app)                      │
│  └─ Secret key (sk_): BACKEND ONLY! Never in app!                           │
│                                                                              │
│  YOUR BACKEND API KEY:                                                       │
│  └─ --dart-define with environment-specific values                          │
│                                                                              │
│  FIREBASE:                                                                   │
│  └─ Use google-services.json / GoogleService-Info.plist                     │
│     (Security comes from Firebase Security Rules, not hiding keys)          │
│                                                                              │
│  OPENAI / SENSITIVE AI APIs:                                                 │
│  └─ BACKEND PROXY ONLY! Never put these in your app!                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Security Level Comparison

```
SECURITY LEVEL:

❌ Hardcoded in code      → 0% secure (anyone can see)
❌ Assets folder          → 0% secure (anyone can extract)
⚠️  .env in assets        → 30% secure (still in APK)
✅ --dart-define          → 60% secure (compiled, harder to find)
✅ Native platform secrets → 70% secure (platform-specific)
✅✅ Backend proxy        → 95% secure (key never leaves server)
```

---

## Quick Start Checklist

```
□ Create lib/config/app_config.dart with String.fromEnvironment
□ Create run_dev.sh with test keys
□ Create build_release.sh with real keys (gitignore it!)
□ Update .gitignore to exclude production secrets
□ For Google Maps: Use local.properties (Android) and xcconfig (iOS)
□ For payments: Use backend proxy (keep secret key on server)
□ For CI/CD: Use GitHub Secrets or similar
□ Restrict API keys in respective consoles (Google Cloud, Stripe, etc.)
□ Enable code obfuscation for release builds
```

---

## Summary

1. **NEVER** put secrets in assets folder or hardcode them
2. **USE** `--dart-define` for most keys (injected at build time)
3. **USE** backend proxy for payment and sensitive API keys
4. **USE** native platform methods for SDK keys (Google Maps)
5. **ALWAYS** gitignore production secret files
6. **RESTRICT** your API keys in their respective consoles

---

[← Back to App Security](./06-AppSecurity.md) | [Back to Level 15 README](../README.md)
