# Building for Production

## The Simple Explanation

Building for production is like baking the final cake. You've tested the recipe (debug mode), now you're making the real thing with all the finishing touches.

```
┌─────────────────────────────────────────────────────────────┐
│                 BUILD TYPES COMPARED                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DEBUG BUILD:                 RELEASE BUILD:                 │
│  ├── For development          ├── For users                 │
│  ├── Includes debug tools     ├── Optimized code            │
│  ├── Larger file size         ├── Smaller file size         │
│  ├── Slower performance       ├── Fast performance          │
│  └── Hot reload works         └── No debug features         │
│                                                              │
│  PROFILE BUILD:                                              │
│  ├── Between debug and release                              │
│  ├── For performance testing                                │
│  └── Has profiling tools                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Android Build Commands

### Building an APK

```bash
# Simple APK (works on any Android device)
flutter build apk

# APK will be at:
# build/app/outputs/flutter-apk/app-release.apk
```

### Building an App Bundle (Recommended!)

```bash
# App Bundle for Google Play (recommended!)
flutter build appbundle

# Bundle will be at:
# build/app/outputs/bundle/release/app-release.aab
```

```
APK vs APP BUNDLE:

APK (Android Package):
├── Single file with everything
├── Works on all devices
├── Larger download size
└── Good for: Direct sharing, testing

APP BUNDLE (AAB):
├── Google creates optimized APKs
├── Smaller downloads for users
├── Required by Google Play (new apps)
└── Good for: Play Store submission

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│         YOUR APP BUNDLE                                      │
│              │                                               │
│              ▼                                               │
│    ┌─────────────────┐                                      │
│    │  Google Play    │                                      │
│    │  Creates:       │                                      │
│    │  ├── APK for Phone A (arm64, hdpi)                    │
│    │  ├── APK for Phone B (arm, xhdpi)                     │
│    │  └── APK for Tablet (x86, xxhdpi)                     │
│    └─────────────────┘                                      │
│                                                              │
│  Each user downloads ONLY what their device needs!          │
│  = Smaller downloads = Happy users                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Split APKs by Architecture

```bash
# Create separate APKs per CPU architecture
flutter build apk --split-per-abi

# Creates:
# app-armeabi-v7a-release.apk  (~7 MB)  - Older devices
# app-arm64-v8a-release.apk    (~7 MB)  - Most modern phones
# app-x86_64-release.apk       (~7 MB)  - Emulators, some devices
```

---

## iOS Build Commands

### Building for iOS

```bash
# Build iOS release
flutter build ios

# This creates the app in:
# build/ios/iphoneos/Runner.app
```

### Creating Archive for App Store

```bash
# Build the release version
flutter build ios --release

# Then open Xcode:
open ios/Runner.xcworkspace
```

```
IN XCODE:

1. Select "Any iOS Device" as target
2. Menu: Product → Archive
3. Wait for build to complete
4. Organizer window opens automatically
5. Click "Distribute App"
6. Choose "App Store Connect"
7. Follow the prompts!
```

---

## Build Flags and Options

### Common Build Options

```bash
# Build with version override
flutter build apk --build-name=1.2.0 --build-number=5

# Build with different flavor
flutter build apk --flavor production

# Build with dart defines
flutter build apk --dart-define=API_URL=https://api.prod.com

# Verbose output (for debugging build issues)
flutter build apk --verbose

# Analyze bundle size
flutter build apk --analyze-size
```

### Build Modes

```bash
# Debug (default for 'flutter run')
flutter run --debug

# Profile (for performance testing)
flutter run --profile

# Release (for production)
flutter run --release
flutter build apk --release  # default
```

---

## Understanding Build Output

### Android Build Output

```
build/
└── app/
    └── outputs/
        ├── flutter-apk/
        │   ├── app-release.apk      ← Single APK
        │   ├── app-armeabi-v7a-release.apk
        │   ├── app-arm64-v8a-release.apk
        │   └── app-x86_64-release.apk
        │
        └── bundle/
            └── release/
                └── app-release.aab  ← App Bundle
```

### iOS Build Output

```
build/
└── ios/
    └── iphoneos/
        └── Runner.app              ← iOS App
```

---

## Reducing App Size

### Check Current Size

```bash
# Analyze what's taking up space
flutter build apk --analyze-size

# Open the analysis in DevTools
# Shows breakdown of:
# - Dart code
# - Native code
# - Assets
# - etc.
```

### Size Optimization Tips

```
┌─────────────────────────────────────────────────────────────┐
│                 SIZE OPTIMIZATION TIPS                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ASSETS:                                                     │
│  ├── Compress images (TinyPNG, ImageOptim)                  │
│  ├── Use WebP format instead of PNG                         │
│  ├── Remove unused assets                                   │
│  └── Use appropriate resolutions                            │
│                                                              │
│  FONTS:                                                      │
│  ├── Only include used weights                              │
│  ├── Subset fonts (remove unused characters)                │
│  └── Consider system fonts                                  │
│                                                              │
│  CODE:                                                       │
│  ├── Remove unused packages                                 │
│  ├── Use tree shaking (automatic in release)                │
│  ├── Avoid large libraries for small features               │
│  └── Enable minification                                    │
│                                                              │
│  NATIVE:                                                     │
│  ├── Use App Bundle (Android)                               │
│  ├── Enable Bitcode (iOS)                                   │
│  └── Strip debug symbols                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Deferred Components (Advanced)

```dart
// Load features on demand, not at startup
import 'package:deferred_library/deferred_library.dart' deferred as lib;

Future<void> loadFeature() async {
  await lib.loadLibrary();
  lib.showFeature();
}
```

---

## Build Troubleshooting

### Common Build Errors

```
ERROR: "Execution failed for task ':app:minifyReleaseWithR8'"
CAUSE: ProGuard/R8 removing needed code
FIX: Add keep rules in proguard-rules.pro

ERROR: "The Xcode build failed"
FIX:
1. flutter clean
2. cd ios && pod install
3. flutter build ios

ERROR: "Signing failed"
CAUSE: Certificate/key issues
FIX: Check signing configuration (see previous lesson)

ERROR: "Out of memory"
FIX: Increase Gradle memory in gradle.properties:
     org.gradle.jvmargs=-Xmx4G
```

### Build Cleanup

```bash
# Clean everything and rebuild
flutter clean
flutter pub get

# iOS specific
cd ios
pod deintegrate
pod install
cd ..

# Android specific
cd android
./gradlew clean
cd ..

# Now rebuild
flutter build apk
flutter build ios
```

---

## CI/CD Builds

### GitHub Actions Example

```yaml
# .github/workflows/build.yml

name: Build and Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Get dependencies
        run: flutter pub get

      - name: Build iOS
        run: flutter build ios --release --no-codesign
```

---

## Build Verification Checklist

```
BEFORE UPLOADING TO STORE:

□ Build completes without errors
□ App launches correctly
□ All features work in release mode
□ No crash on startup
□ Performance is acceptable
□ File size is reasonable

TESTING RELEASE BUILD:

Android:
  flutter build apk
  flutter install  # Install on connected device

iOS:
  flutter build ios
  # Use Xcode to install on device
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│            BUILDING FOR PRODUCTION SUMMARY                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ANDROID COMMANDS:                                           │
│  ├── flutter build apk        → Single APK                  │
│  ├── flutter build appbundle  → For Play Store              │
│  └── --split-per-abi          → Smaller APKs                │
│                                                              │
│  iOS COMMANDS:                                               │
│  ├── flutter build ios        → Build release               │
│  └── Xcode → Archive          → For App Store               │
│                                                              │
│  OPTIMIZATION:                                               │
│  ├── Use App Bundle for Android                             │
│  ├── Compress and optimize assets                           │
│  ├── Remove unused packages                                 │
│  └── Use --analyze-size to check                            │
│                                                              │
│  TROUBLESHOOTING:                                            │
│  ├── flutter clean                                          │
│  ├── Check signing config                                   │
│  └── Review error messages carefully                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Next:** `04-StoreListings.md` - Creating app store listings
