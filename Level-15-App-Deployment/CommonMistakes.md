# Level 15: Common Mistakes

Learn from these common deployment errors!

---

## Mistake #1: Debug Mode in Production

```bash
# ❌ WRONG - Debug build for store
flutter build apk  # Defaults to debug!

# ✅ RIGHT
flutter build apk --release
flutter build appbundle --release
flutter build ipa --release
```

---

## Mistake #2: Not Incrementing Build Number

```yaml
# ❌ WRONG - Same build number for update
version: 1.0.0+1  # Upload rejected if 1 was already used!

# ✅ RIGHT - Increment for each upload
version: 1.0.0+2  # New build number
version: 1.0.1+3  # Can also update version name
```

---

## Mistake #3: Lost Keystore

```
# ❌ WRONG - Can't find keystore
Error: Keystore file not found

# After losing keystore:
# - Can't update existing app
# - Must publish as NEW app
# - Lose all reviews and downloads

# ✅ RIGHT - Backup immediately
# 1. Store keystore in secure location (NOT git!)
# 2. Store passwords in password manager
# 3. Keep backup in multiple locations
```

---

## Mistake #4: Hardcoded API Keys

```dart
// ❌ WRONG - Keys in source code
class Config {
  static const apiKey = 'sk_live_xxx123';  // Anyone can extract this!
}

// ✅ RIGHT - Use dart-define
class Config {
  static String get apiKey => const String.fromEnvironment('API_KEY');
}

// Build with:
// flutter build apk --dart-define=API_KEY=sk_live_xxx123
```

---

## Mistake #5: Wrong Package Name

```groovy
// ❌ WRONG - Generic or test package name
android {
  defaultConfig {
    applicationId "com.example.myapp"  // Can't change after publishing!
  }
}

// ✅ RIGHT - Use your domain (reversed)
android {
  defaultConfig {
    applicationId "com.yourcompany.shopease"
  }
}
```

---

## Mistake #6: Missing Permissions

```xml
<!-- ❌ WRONG - App crashes when trying to use camera -->
<!-- No permissions declared -->

<!-- ✅ RIGHT - Declare all needed permissions -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

```xml
<!-- iOS Info.plist -->
<key>NSCameraUsageDescription</key>
<string>Required for taking photos</string>
```

---

## Mistake #7: Debug Prints in Release

```dart
// ❌ WRONG - Debug statements in production
void processPayment() {
  print('Processing payment: $amount');  // Visible in logs!
  print('Card number: $cardNumber');  // Security issue!
}

// ✅ RIGHT - Remove or use kDebugMode
import 'package:flutter/foundation.dart';

void processPayment() {
  if (kDebugMode) {
    print('Processing payment: $amount');
  }
  // Or use a proper logging library with levels
}
```

---

## Mistake #8: Missing ProGuard Rules

```
# ❌ WRONG - Release crashes but debug works
# Caused by R8/ProGuard stripping needed code

# ✅ RIGHT - Add keep rules in android/app/proguard-rules.pro
-keep class io.flutter.** { *; }
-keep class com.google.firebase.** { *; }
```

---

## Mistake #9: Wrong Screenshots

```
# ❌ WRONG
- Screenshots with debug banner
- Screenshots with personal data
- Wrong device sizes
- Different language than listing

# ✅ RIGHT
- Hide debug banner: MaterialApp(debugShowCheckedModeBanner: false)
- Use dummy/test data
- Correct sizes for each store
- Screenshots match listing language
```

---

## Mistake #10: No Privacy Policy

```
# ❌ WRONG - Submission rejected
"Your app must have a privacy policy"

# ✅ RIGHT
1. Create privacy policy (use generator or lawyer)
2. Host it online (website, GitHub pages, etc.)
3. Add URL to store listing
4. Add link in app (Settings > Privacy Policy)
```

---

## Deployment Checklist

| Task | Android | iOS |
|------|---------|-----|
| Build number incremented | ✓ | ✓ |
| Signing configured | Keystore | Certificates |
| Debug code removed | ✓ | ✓ |
| API keys secured | ✓ | ✓ |
| Permissions declared | Manifest | Info.plist |
| Icons all sizes | ✓ | ✓ |
| Screenshots ready | ✓ | ✓ |
| Privacy policy URL | ✓ | ✓ |

---

**Still stuck? Re-read the Theory files or ask for help!**
