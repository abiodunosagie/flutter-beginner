# Platform Aware Code: One App, Three Personalities

## The Big Idea In One Sentence

> Check `kIsWeb` **before** anything from `dart:io`, use `defaultTargetPlatform` for look and feel, and keep platform decisions in one small file instead of scattered `if`s.

---

## The Four Ways To Ask "Where Am I?"

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   kIsWeb                    compile time constant    │
│   from flutter/foundation   true only on web         │
│                                                      │
│   Platform.isAndroid/isIOS  runtime, from dart:io    │
│   ...isMacOS/isWindows      CRASHES ON WEB           │
│   ...isLinux/isFuchsia                               │
│                                                      │
│   defaultTargetPlatform     what the UI should       │
│   from flutter/foundation   look like; web safe;     │
│                             overridable in tests     │
│                                                      │
│   Theme.of(context).platform   same, but respects    │
│                                any app level override│
│                                                      │
└──────────────────────────────────────────────────────┘
```

### The one bug everyone ships once

```dart
// CRASHES on web with "Unsupported operation: Platform._operatingSystem"
if (Platform.isIOS) { ... }

// Correct: kIsWeb is a const, so the compiler removes the dead branch
if (!kIsWeb && Platform.isIOS) { ... }
```

`kIsWeb` is a compile time constant, so on web the compiler deletes everything after `&&`, and `dart:io` is never touched. Order matters: `Platform.isIOS && !kIsWeb` still crashes.

### Behaviour vs appearance

```dart
// Appearance question: which design language should I draw?
// Use defaultTargetPlatform. It is web safe and it can be overridden
// (a browser on a Mac reports macOS, which is usually what you want).
final useCupertino = defaultTargetPlatform == TargetPlatform.iOS;

// Capability question: can I write a file here?
// Use Platform, guarded by kIsWeb, because this is about the real OS.
final canWriteFiles = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
```

---

## One File To Rule Them All

Do not sprinkle platform checks through your widgets. Put them in one place, give them names that describe **the capability**, not the platform, and the rest of the app reads cleanly.

```dart
// lib/core/platform/app_platform.dart
import 'package:flutter/foundation.dart';

class AppPlatform {
  const AppPlatform._();

  static bool get isWeb => kIsWeb;

  static bool get isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  static bool get isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  // Name the CAPABILITY, not the platform
  static bool get supportsBiometrics => isMobile;
  static bool get supportsFileSystem => !isWeb;
  static bool get supportsPushNotifications => isMobile || isWeb;
  static bool get supportsHapticFeedback => isMobile;
}
```

Now a widget says `if (AppPlatform.supportsBiometrics)` instead of `if (Platform.isIOS || Platform.isAndroid)`. When you add desktop biometrics next year, you change one line, not forty.

---

## Adaptive Look And Feel

Flutter ships two design languages. You have three choices, and the interviewer wants to hear that you know the trade offs.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. MATERIAL EVERYWHERE                             │
│      One design, one codebase, brand consistent.     │
│      What most product teams actually ship.          │
│                                                      │
│   2. .adaptive CONSTRUCTORS                          │
│      Material by default, Cupertino on Apple for     │
│      a handful of controls. Cheap, low risk.         │
│      Switch.adaptive, Slider.adaptive,               │
│      CircularProgressIndicator.adaptive,             │
│      showAdaptiveDialog, AlertDialog.adaptive        │
│                                                      │
│   3. FULLY PLATFORM SPECIFIC UI                      │
│      CupertinoApp on iOS, MaterialApp elsewhere.     │
│      Twice the UI work, best native feel.            │
│      Justified for utility apps, rarely for brands.  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Some things are already adaptive without you doing anything: page transitions (`MaterialApp` uses a Cupertino sliding transition on iOS), the back button icon, scroll physics (bouncing on iOS, glowing overscroll on Android), and long press text selection behaviour.

```dart
// A small adaptive wrapper, the pragmatic middle ground
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (AppPlatform.isApple) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(title)),
        child: SafeArea(child: body),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
```

---

## Platform Specific Configuration Files

Knowing where platform settings live is half of "comfort working with iOS and Android code".

```
android/
├── app/
│   ├── build.gradle.kts        minSdk, targetSdk, signing, flavors
│   └── src/main/
│       ├── AndroidManifest.xml permissions, deep links, app name
│       ├── kotlin/.../MainActivity.kt    native entry point
│       └── res/                icons, splash, strings
└── build.gradle.kts            project wide gradle config

ios/
├── Runner/
│   ├── Info.plist              permissions text, URL schemes, app name
│   ├── AppDelegate.swift       native entry point
│   └── Assets.xcassets/        icons, splash
├── Runner.xcodeproj            build settings, capabilities
└── Podfile                     CocoaPods dependencies

web/
├── index.html                  scripts, meta tags, base href
├── manifest.json               PWA name, icons, theme colour
└── favicon.png
```

### Permissions: the number one cause of "works on Android, rejected by Apple"

Android declares permissions:

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

iOS declares permissions **with a human readable reason**, and the App Store rejects a missing or lazy reason:

```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>We use the camera so you can add a photo to your listing.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We use your location to show nearby stores.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo access so you can choose an existing picture.</string>
```

Write the reason as a sentence a user would accept. "Required for app functionality" is a classic rejection.

---

## Minimum Versions

```kotlin
// android/app/build.gradle.kts
android {
    compileSdk = 35
    defaultConfig {
        minSdk = 23          // raise this only with a reason; it drops devices
        targetSdk = 35       // must be current for Play Store submissions
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

```
# ios/Podfile
platform :ios, '13.0'
```

Interview ready fact: `minSdk` decides which Android devices can install the app at all, `targetSdk` tells Android which behaviour rules to apply, and Google Play requires a recent `targetSdk` for new submissions.

---

## Platform Aware Behaviour In Practice

```dart
// Haptics: real on mobile, a no-op elsewhere
void tapFeedback() {
  if (AppPlatform.supportsHapticFeedback) {
    HapticFeedback.selectionClick();
  }
}

// Storage: three different homes for a token
Future<void> saveToken(String token) async {
  if (AppPlatform.isWeb) return webStore.save(token);        // localStorage
  return secureStorage.write(key: 'token', value: token);    // Keychain/Keystore
}

// Exiting: allowed on Android, forbidden by Apple's guidelines
void closeApp() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    SystemNavigator.pop();
  }
}
```

---

## Testing Platform Branches Without Devices

```dart
testWidgets('shows a Cupertino switch on iOS', (tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);

  await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

  expect(find.byType(CupertinoSwitch), findsOneWidget);
});
```

`debugDefaultTargetPlatformOverride` changes what `defaultTargetPlatform` reports, so both branches of your adaptive UI can be tested on one machine. Always reset it in a tear down, or the override leaks into later tests.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • kIsWeb FIRST, then anything from dart:io         │
│   • defaultTargetPlatform for look and feel          │
│   • Platform.isX for real OS capabilities            │
│   • One AppPlatform file, named by capability        │
│   • Material everywhere, plus .adaptive controls,    │
│     is the usual production answer                   │
│   • Permissions: Manifest on Android, Info.plist     │
│     with a real reason on iOS                        │
│   • minSdk = who can install, targetSdk = rules      │
│   • debugDefaultTargetPlatformOverride in tests      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why does `if (Platform.isIOS)` crash on web, and what is the fix?

<details>
<summary>Answer</summary>
`Platform` comes from `dart:io`, which does not exist on web. Guard it with the compile time constant first: `if (!kIsWeb && Platform.isIOS)`, so the compiler removes the branch entirely on web.
</details>

**Q2.** When do you use `defaultTargetPlatform` instead of `Platform.isIOS`?

<details>
<summary>Answer</summary>
For appearance and behaviour decisions. It is web safe, it can be overridden in tests, and it reflects the design language the user expects rather than the literal operating system.
</details>

**Q3.** Where do camera permissions go on each platform?

<details>
<summary>Answer</summary>
Android: a `<uses-permission android:name="android.permission.CAMERA" />` line in `AndroidManifest.xml`. iOS: an `NSCameraUsageDescription` key in `Info.plist` with a human readable reason, which Apple reviews.
</details>

---

## Assignment

### Problem 1: Fix the crash

```dart
final isPhone = Platform.isAndroid || Platform.isIOS;
```

Rewrite it so it is safe on web.

### Problem 2: Name the capability

Rewrite `if (Platform.isIOS || Platform.isAndroid)` (used to decide whether to show a "scan document" button) as a well named getter.

### Problem 3: Permission checklist

Your app adds photo upload from the gallery. List what you must add on Android and on iOS.

### Problem 4: Test both looks

Write the two lines that make a widget test render the iOS branch of your adaptive UI.

---

## Assignment Answers

### Problem 1: Fix the crash

```dart
final isPhone = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
```

Or, for a look and feel decision, avoid `dart:io` completely:

```dart
final isPhone = !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
     defaultTargetPlatform == TargetPlatform.iOS);
```

### Problem 2: Name the capability

```dart
static bool get supportsDocumentScanning => AppPlatform.isMobile;
```

The call site becomes `if (AppPlatform.supportsDocumentScanning)`, which still reads correctly the day desktop gains a scanner.

### Problem 3: Permission checklist

- Android: `READ_MEDIA_IMAGES` on API 33 and above (`READ_EXTERNAL_STORAGE` for older), declared in `AndroidManifest.xml`, plus a runtime request.
- iOS: `NSPhotoLibraryUsageDescription` in `Info.plist` with a real explanation, plus `NSPhotoLibraryAddUsageDescription` if you also save images back.

### Problem 4: Test both looks

```dart
debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
addTearDown(() => debugDefaultTargetPlatformOverride = null);
```

---

## Navigation

⬅️ **Previous:** [Redirects, Guards, and Deep Links](03d-RedirectsAndGuards.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Method Channels](04b-MethodChannels.md)
