# Level 15 Capstone: Deploy ShopEase to App Stores

## What You're Building

In this level, you'll prepare ShopEase for **production deployment** to both the Google Play Store and Apple App Store!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 15 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase Deployment Pipeline                               │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   Development          Build           Release      │   │
│   │   ┌─────────┐      ┌─────────┐      ┌─────────┐    │   │
│   │   │  Code   │ ───▶ │ flutter │ ───▶ │  .apk   │    │   │
│   │   │  Base   │      │  build  │      │  .aab   │    │   │
│   │   └─────────┘      └─────────┘      │  .ipa   │    │   │
│   │                                      └────┬────┘    │   │
│   │                                           │         │   │
│   │                                           ▼         │   │
│   │   ┌─────────────────────────────────────────────┐  │   │
│   │   │                                             │  │   │
│   │   │  ┌──────────────┐    ┌──────────────┐      │  │   │
│   │   │  │ Google Play  │    │  App Store   │      │  │   │
│   │   │  │    Store     │    │   Connect    │      │  │   │
│   │   │  │   ▶ 📱       │    │    🍎 📱     │      │  │   │
│   │   │  └──────────────┘    └──────────────┘      │  │   │
│   │   │                                             │  │   │
│   │   └─────────────────────────────────────────────┘  │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: App Configuration

Update app metadata for production:

```dart
// lib/config/app_config.dart

class AppConfig {
  static const String appName = 'ShopEase';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // Environment-specific configs
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');

  static String get apiBaseUrl => isProduction
      ? 'https://api.shopease.com'
      : 'https://staging-api.shopease.com';

  static String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
```

```yaml
# pubspec.yaml
name: shopease
description: Your one-stop shopping destination
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'
```

### Task 2: Android Configuration

```groovy
// android/app/build.gradle

android {
    namespace "com.yourcompany.shopease"
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.yourcompany.shopease"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

```properties
# android/key.properties (DO NOT commit to git!)
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=shopease
storeFile=/path/to/your/keystore.jks
```

### Task 3: iOS Configuration

```xml
<!-- ios/Runner/Info.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>ShopEase</string>
    <key>CFBundleDisplayName</key>
    <string>ShopEase</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>

    <!-- Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>ShopEase needs camera access to add photos to your reviews</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>ShopEase needs photo library access to select images for reviews</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>ShopEase needs your location to show nearby stores</string>
</dict>
</plist>
```

### Task 4: App Icons and Splash Screen

```yaml
# pubspec.yaml - Add flutter_launcher_icons
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

```yaml
# pubspec.yaml - Add flutter_native_splash
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash_logo.png
  android_12:
    icon_background_color: "#FFFFFF"
    image: assets/splash/splash_logo.png
```

### Task 5: Build Scripts

```bash
#!/bin/bash
# scripts/build_android.sh

echo "🔨 Building ShopEase for Android..."

# Clean previous builds
flutter clean
flutter pub get

# Build release APK
flutter build apk --release --dart-define=PRODUCTION=true

# Build release App Bundle (for Play Store)
flutter build appbundle --release --dart-define=PRODUCTION=true

echo "✅ Android build complete!"
echo "📦 APK: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 AAB: build/app/outputs/bundle/release/app-release.aab"
```

```bash
#!/bin/bash
# scripts/build_ios.sh

echo "🔨 Building ShopEase for iOS..."

# Clean previous builds
flutter clean
flutter pub get

# Build release IPA
flutter build ipa --release --dart-define=PRODUCTION=true

echo "✅ iOS build complete!"
echo "📦 IPA: build/ios/ipa/ShopEase.ipa"
```

### Task 6: Pre-Launch Checklist

```dart
// lib/utils/pre_launch_checklist.dart

class PreLaunchChecklist {
  static final List<ChecklistItem> items = [
    // Functionality
    ChecklistItem('All features work correctly', category: 'Functionality'),
    ChecklistItem('Error handling displays user-friendly messages', category: 'Functionality'),
    ChecklistItem('Offline mode gracefully handled', category: 'Functionality'),

    // Performance
    ChecklistItem('App launches in under 3 seconds', category: 'Performance'),
    ChecklistItem('Animations run at 60fps', category: 'Performance'),
    ChecklistItem('No memory leaks detected', category: 'Performance'),

    // Security
    ChecklistItem('API keys not hardcoded', category: 'Security'),
    ChecklistItem('HTTPS used for all requests', category: 'Security'),
    ChecklistItem('Sensitive data encrypted', category: 'Security'),

    // Store Requirements
    ChecklistItem('Privacy policy URL added', category: 'Store'),
    ChecklistItem('App screenshots prepared', category: 'Store'),
    ChecklistItem('App description written', category: 'Store'),
    ChecklistItem('Content rating completed', category: 'Store'),

    // Legal
    ChecklistItem('Terms of service drafted', category: 'Legal'),
    ChecklistItem('GDPR compliance if needed', category: 'Legal'),
  ];
}

class ChecklistItem {
  final String description;
  final String category;
  bool isCompleted;

  ChecklistItem(this.description, {required this.category, this.isCompleted = false});
}
```

### Task 7: Store Listing Assets

```
assets/
├── store_listing/
│   ├── screenshots/
│   │   ├── android/
│   │   │   ├── phone_1_home.png      (1080x1920)
│   │   │   ├── phone_2_product.png   (1080x1920)
│   │   │   ├── phone_3_cart.png      (1080x1920)
│   │   │   ├── phone_4_checkout.png  (1080x1920)
│   │   │   └── phone_5_profile.png   (1080x1920)
│   │   │
│   │   └── ios/
│   │       ├── iphone_6.5_1.png      (1284x2778)
│   │       ├── iphone_6.5_2.png      (1284x2778)
│   │       ├── iphone_5.5_1.png      (1242x2208)
│   │       └── ipad_12.9_1.png       (2048x2732)
│   │
│   ├── feature_graphic.png           (1024x500 for Play Store)
│   ├── promo_video.mp4               (optional)
│   │
│   └── descriptions/
│       ├── short_description.txt     (80 chars max)
│       └── full_description.txt      (4000 chars max)
```

---

## Store Descriptions

```text
// short_description.txt (80 chars)
Shop smarter with ShopEase - Your one-stop destination for amazing deals!

// full_description.txt
ShopEase - Your Personal Shopping Companion

Discover thousands of products from top brands, all in one beautiful app.

KEY FEATURES:
• Browse products by category
• Smart search with filters
• Save favorites to your wishlist
• Secure checkout with multiple payment options
• Track your orders in real-time
• Get personalized recommendations

WHY SHOPEASE?
✓ Free shipping on orders over $50
✓ Easy 30-day returns
✓ 24/7 customer support
✓ Secure payment processing

Download now and start shopping smarter!
```

---

## Deployment Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT FLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   1. PREPARE                                                 │
│   ─────────                                                  │
│   • Update version in pubspec.yaml                          │
│   • Run all tests                                            │
│   • Update changelog                                         │
│                                                              │
│   2. BUILD                                                   │
│   ───────                                                    │
│   • flutter build appbundle (Android)                       │
│   • flutter build ipa (iOS)                                 │
│                                                              │
│   3. TEST                                                    │
│   ──────                                                     │
│   • Internal testing (Alpha/TestFlight)                     │
│   • Beta testing with real users                            │
│   • Fix reported issues                                      │
│                                                              │
│   4. SUBMIT                                                  │
│   ────────                                                   │
│   • Upload to Play Console / App Store Connect              │
│   • Fill store listing details                              │
│   • Submit for review                                        │
│                                                              │
│   5. RELEASE                                                 │
│   ─────────                                                  │
│   • Respond to review feedback if needed                    │
│   • Staged rollout (10% → 50% → 100%)                       │
│   • Monitor crash reports and reviews                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Success Criteria

- [ ] App version and build number configured
- [ ] Android signing key created and secured
- [ ] iOS provisioning profiles set up
- [ ] App icons generated for all sizes
- [ ] Splash screen configured
- [ ] Build scripts working
- [ ] Store screenshots captured
- [ ] Store descriptions written
- [ ] Privacy policy URL ready
- [ ] Release build runs without errors

---

## Files to Create/Update

```
shopease/
├── lib/
│   └── config/
│       └── app_config.dart           ◄── Create
│
├── android/
│   ├── app/
│   │   └── build.gradle              ◄── Update
│   └── key.properties                ◄── Create (gitignore!)
│
├── ios/
│   └── Runner/
│       └── Info.plist                ◄── Update
│
├── assets/
│   ├── icon/
│   │   └── app_icon.png              ◄── Create
│   ├── splash/
│   │   └── splash_logo.png           ◄── Create
│   └── store_listing/                ◄── Create folder
│
├── scripts/
│   ├── build_android.sh              ◄── Create
│   └── build_ios.sh                  ◄── Create
│
└── pubspec.yaml                      ◄── Update
```

---

## Security Reminders

```
┌────────────────────────────────────────────────────────────┐
│                 🔒 SECURITY CHECKLIST                       │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  NEVER commit to git:                                       │
│  • key.properties                                           │
│  • *.jks (keystore files)                                  │
│  • *.p12 (iOS certificates)                                │
│  • .env files with secrets                                 │
│  • google-services.json (production)                       │
│  • GoogleService-Info.plist (production)                   │
│                                                             │
│  Add to .gitignore:                                         │
│  android/key.properties                                     │
│  android/*.jks                                              │
│  ios/*.p12                                                  │
│  .env*                                                      │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

---

**Your ShopEase app is ready for the world!**
