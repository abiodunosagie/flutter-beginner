# Preparing for Release

## The Big Idea In One Sentence

> Before publishing, you turn your "in-progress" app into a real product: set a proper app name, icon, version number, and remove debug leftovers, so it is ready for real users.

## The Simple Explanation

Before sending your app to the store, you need to clean it up! It's like cleaning your room before guests arrive - hide the messy stuff, make everything look nice, and make sure nothing is broken.

```
┌─────────────────────────────────────────────────────────────┐
│              DEBUG MODE vs RELEASE MODE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DEBUG MODE (Development):                                   │
│  ├── "DEBUG" banner in corner                               │
│  ├── Hot reload enabled                                     │
│  ├── Extra logging and checks                               │
│  ├── Slower performance                                     │
│  └── Larger app size                                        │
│                                                              │
│  RELEASE MODE (Production):                                  │
│  ├── No debug banner                                        │
│  ├── Optimized and fast                                     │
│  ├── Smaller app size                                       │
│  ├── No debug tools                                         │
│  └── Ready for users!                                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 1: Remove Debug Code

### Remove Print Statements

```dart
// ❌ DON'T leave these in production
void fetchData() {
  print('Fetching data...');  // Remove this!
  print('User ID: $userId');  // Remove this!
}

// ✅ DO use conditional logging
import 'package:flutter/foundation.dart';

void fetchData() {
  if (kDebugMode) {
    print('Fetching data...');  // Only in debug mode
  }
}

// ✅ EVEN BETTER: Use a logging package
import 'package:logger/logger.dart';

final logger = Logger();

void fetchData() {
  logger.d('Fetching data...');  // Debug level log
}
```

### Remove Debug Banner

```dart
MaterialApp(
  // Remove the DEBUG banner
  debugShowCheckedModeBanner: false,  // Add this!

  title: 'My App',
  home: HomeScreen(),
)
```

---

## Step 2: Update App Configuration

### pubspec.yaml

```yaml
# pubspec.yaml

name: my_awesome_app
description: A new Flutter application.

# VERSION NUMBER - Very Important!
# Format: major.minor.patch+buildNumber
version: 1.0.0+1

# Breakdown:
# 1.0.0 = Version shown to users
# +1    = Build number (increment for each upload)

# Next release examples:
# Bug fix:      1.0.1+2
# New feature:  1.1.0+3
# Major update: 2.0.0+4
```

```
VERSION NUMBER EXPLAINED:

  1.0.0+1
  │ │ │ │
  │ │ │ └── Build number (internal, always increases)
  │ │ └──── Patch (bug fixes)
  │ └────── Minor (new features, backwards compatible)
  └──────── Major (big changes, may break things)

EXAMPLES:
  1.0.0+1  → First release
  1.0.1+2  → Bug fix
  1.1.0+3  → Added new feature
  1.1.1+4  → Bug fix after feature
  2.0.0+5  → Major redesign
```

---

## Step 3: Android Configuration

### android/app/build.gradle

```gradle
android {
    compileSdkVersion 34  // Use latest stable

    defaultConfig {
        // IMPORTANT: This is your app's unique ID
        // Cannot change after publishing!
        applicationId "com.yourcompany.yourapp"

        minSdkVersion 21      // Android 5.0 minimum
        targetSdkVersion 34   // Target latest

        // From pubspec.yaml
        versionCode 1         // Build number
        versionName "1.0.0"   // Display version
    }

    buildTypes {
        release {
            // Enable code shrinking
            minifyEnabled true
            shrinkResources true

            proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'
            ), 'proguard-rules.pro'
        }
    }
}
```

```
APPLICATION ID EXPLAINED:

  com.yourcompany.yourapp
  │   │           │
  │   │           └── Your app name
  │   └────────────── Your company name
  └────────────────── Domain (reversed)

EXAMPLES:
  com.google.maps
  com.facebook.messenger
  com.yourname.todoapp

⚠️  IMPORTANT:
  • Choose carefully - can't change after publishing!
  • Must be unique across all Android apps
  • Use lowercase, letters, numbers, dots only
```

---

## Step 4: iOS Configuration

### ios/Runner/Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Name (shown under icon) -->
    <key>CFBundleName</key>
    <string>My App</string>

    <!-- Display Name (shown on home screen) -->
    <key>CFBundleDisplayName</key>
    <string>My App</string>

    <!-- Bundle ID (like Android's applicationId) -->
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>

    <!-- Version shown to users -->
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>

    <!-- Build number -->
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>

    <!-- Required permissions - only include what you use! -->

    <!-- Camera permission -->
    <key>NSCameraUsageDescription</key>
    <string>We need camera access to take photos</string>

    <!-- Photo library permission -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to save and select photos</string>

    <!-- Location permission -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to show nearby places</string>
</dict>
</plist>
```

```
iOS PERMISSIONS:

⚠️  Apple is STRICT about permissions!

RULES:
1. Only request permissions you actually use
2. Explain WHY you need each permission
3. Generic messages = rejection

❌ BAD:
  "This app needs camera access"

✅ GOOD:
  "We need camera access to take profile photos
   and share moments with friends"
```

---

## Step 5: App Icons

```
APP ICON REQUIREMENTS:

ANDROID:
├── mipmap-mdpi/    → 48x48 px
├── mipmap-hdpi/    → 72x72 px
├── mipmap-xhdpi/   → 96x96 px
├── mipmap-xxhdpi/  → 144x144 px
├── mipmap-xxxhdpi/ → 192x192 px
└── Play Store      → 512x512 px

iOS:
├── 20x20, 29x29, 40x40, 58x58, 60x60
├── 76x76, 80x80, 87x87, 120x120
├── 152x152, 167x167, 180x180
└── App Store       → 1024x1024 px

EASY WAY: Use flutter_launcher_icons package!
```

### Using flutter_launcher_icons

```yaml
# pubspec.yaml

dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  # Your high-res icon (at least 1024x1024)
  image_path: "assets/icon/app_icon.png"

  # Optional: Different icon for iOS
  # image_path_ios: "assets/icon/app_icon_ios.png"

  # Android adaptive icon (Android 8+)
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

```bash
# Generate all icon sizes automatically!
flutter pub run flutter_launcher_icons
```

```
ICON DESIGN TIPS:

✅ DO:
  • Simple, recognizable shape
  • Works at small sizes
  • Consistent with your brand
  • Unique and memorable

❌ DON'T:
  • Text in the icon (hard to read when small)
  • Too many details
  • Transparent backgrounds (iOS)
  • Copyright/trademark symbols
```

---

## Step 6: Splash Screen

### Using flutter_native_splash

```yaml
# pubspec.yaml

dev_dependencies:
  flutter_native_splash: ^2.3.0

flutter_native_splash:
  color: "#FFFFFF"  # Background color
  image: assets/splash/splash_logo.png

  # Android 12+ specific
  android_12:
    color: "#FFFFFF"
    image: assets/splash/splash_logo.png

  # iOS specific
  ios: true
```

```bash
# Generate splash screens
flutter pub run flutter_native_splash:create
```

---

## Step 7: Performance Optimization

### Reduce App Size

```yaml
# pubspec.yaml

flutter:
  # Don't include unused assets
  assets:
    - assets/images/  # Only needed images

  fonts:
    - family: CustomFont
      fonts:
        - asset: fonts/CustomFont-Regular.ttf
        # Only include weights you actually use!
```

```dart
// Use const constructors where possible
const MyWidget()  // ✅ Better performance

// Lazy load heavy resources
late final _expensiveData = loadExpensiveData();
```

### Build Size Comparison

```
DEBUG BUILD:
├── Includes all debug tools
├── No optimization
└── Size: ~100-200 MB

RELEASE BUILD:
├── Optimized code
├── Minified
└── Size: ~15-30 MB (much smaller!)
```

---

## Step 8: Testing Before Release

```
PRE-RELEASE TESTING CHECKLIST:

FUNCTIONALITY:
□ All screens load correctly
□ All buttons work
□ Forms validate properly
□ Data saves/loads correctly
□ Network errors handled gracefully

PERFORMANCE:
□ App launches quickly (< 3 seconds)
□ Scrolling is smooth
□ No memory leaks
□ Battery usage reasonable

EDGE CASES:
□ No internet connection
□ Low storage space
□ Background/foreground switching
□ Different screen sizes
□ Dark mode (if supported)

PLATFORMS:
□ Tested on real Android device
□ Tested on real iOS device
□ Multiple screen sizes tested
```

---

## Release Checklist

```
BEFORE BUILDING:

□ Debug code removed (print statements)
□ debugShowCheckedModeBanner: false
□ Version number updated in pubspec.yaml
□ App icons generated for all sizes
□ Splash screen configured
□ All permissions have proper descriptions
□ Unused packages removed from pubspec.yaml
□ Unused assets removed
□ App tested in release mode

COMMANDS TO VERIFY:

# Test in release mode
flutter run --release

# Analyze for issues
flutter analyze

# Check package health
flutter pub outdated
```

---

## Common Pre-Release Issues

```
ISSUE: App crashes only in release mode
CAUSE: Obfuscation removing needed code
FIX: Check ProGuard/R8 rules

ISSUE: Images not loading in release
CAUSE: Asset not in pubspec.yaml
FIX: Verify all assets are listed

ISSUE: App too large
CAUSE: Unused assets/packages
FIX: Remove unused dependencies, compress images

ISSUE: Slow startup
CAUSE: Too much initialization
FIX: Defer heavy operations, use lazy loading
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           PREPARING FOR RELEASE SUMMARY                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  CLEAN UP:                                                   │
│  ├── Remove debug code and print statements                │
│  ├── Set debugShowCheckedModeBanner: false                  │
│  └── Remove unused packages and assets                      │
│                                                              │
│  CONFIGURE:                                                  │
│  ├── Update version number                                  │
│  ├── Set application ID (can't change later!)              │
│  └── Add permission descriptions                            │
│                                                              │
│  ASSETS:                                                     │
│  ├── Generate app icons (all sizes)                        │
│  ├── Configure splash screen                                │
│  └── Optimize images                                        │
│                                                              │
│  TEST:                                                       │
│  ├── Run in release mode                                    │
│  ├── Test on real devices                                   │
│  └── Check edge cases                                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Name two things you should set before releasing an app.

<details>
<summary>Answer</summary>
Any two: a real app name, a proper app icon, the version number, and removing debug code/test data.
</details>

**Q2.** What is a version number like `1.0.0+1` for?

<details>
<summary>Answer</summary>
It identifies this build. The name (`1.0.0`) is shown to users; the `+1` build number increases each upload to the store.
</details>

**Q3.** Why remove debug prints and test data before release?

<details>
<summary>Answer</summary>
They can leak information, clutter logs, and make the app look unfinished. Production should be clean.
</details>

---

## Assignment

### Problem 1: Release checklist

List three items you would check off before submitting version 1.0.

### Problem 2: Bump the version

You shipped `1.0.0+1` and fixed a bug. What might the next version be?

### Problem 3: Debug leftovers

Name one kind of debug leftover to remove before release.

---

## Assignment Answers

### Problem 1: Release checklist

Examples: proper app name and icon set, version number set, debug prints/test data removed, app tested on a real device, permissions and store text ready.

### Problem 2: Bump the version

Something like `1.0.1+2` (patch version up, build number up). Any sensible bump with a higher build number is fine.

### Problem 3: Debug leftovers

Any of: `print` statements, test/sample data, a debug banner, hardcoded test accounts, or pointing at a dev server instead of production.

---

**Next:** `02-AppSigning.md` - Security certificates and signing
