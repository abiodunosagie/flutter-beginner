# Level 15 Checkpoint: App Deployment

Before moving to Level 16, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Build Types
What's the difference?

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle
```

<details>
<summary>Check Answers</summary>

- **--debug**: Development build with debugging enabled, larger size
- **--release**: Optimized production build, smaller, faster
- **appbundle**: Android App Bundle for Play Store (recommended)

Use APK for testing, App Bundle for store submission.

</details>

---

### 2. Version Numbers
What does this mean?

```yaml
version: 1.2.3+45
```

<details>
<summary>Check Answer</summary>

- **1.2.3**: Version name (shown to users)
  - 1 = Major version (breaking changes)
  - 2 = Minor version (new features)
  - 3 = Patch version (bug fixes)
- **+45**: Build number (internal, must increment for each store upload)

For Play Store/App Store, the build number must increase with each submission.

</details>

---

### 3. Android Signing
Why is this needed?

```properties
# key.properties
storePassword=xxx
keyPassword=xxx
keyAlias=upload
storeFile=upload-keystore.jks
```

<details>
<summary>Check Answer</summary>

**App signing is required because:**
- Proves you own the app
- Prevents tampering
- Required by Play Store
- Users trust signed apps

**Important:**
- Keep keystore file safe - lose it, lose your app
- Never commit to version control
- Back up securely (not in cloud source control)

</details>

---

### 4. iOS Requirements
What do you need for App Store submission?

<details>
<summary>Check Answer</summary>

**Apple Developer Account** ($99/year):
- Certificates (signing identity)
- App ID (bundle identifier)
- Provisioning profiles

**In Xcode:**
- Set bundle identifier
- Select team
- Configure capabilities
- Set version and build number

**App Store Connect:**
- Create app listing
- Upload screenshots
- Write description
- Submit for review

</details>

---

### 5. Environment Configuration
What's wrong with this?

```dart
class ApiConfig {
  static const apiKey = 'sk_live_abc123xyz';  // 🔴
  static const baseUrl = 'https://api.example.com';
}
```

<details>
<summary>Check Answer</summary>

**Problem:** API key is hardcoded in source code!

**Issues:**
- Key is in git history forever
- Anyone who decompiles app can see it
- If leaked, attackers can use your API

**Solution:** Use environment variables:

```dart
class ApiConfig {
  static String get apiKey => const String.fromEnvironment('API_KEY');
}

// Build with:
// flutter build apk --dart-define=API_KEY=sk_live_abc123xyz
```

</details>

---

### 6. Store Requirements
What's needed for each store?

| Requirement | Play Store | App Store |
|-------------|------------|-----------|
| Screenshots | ___ | ___ |
| Privacy policy | ___ | ___ |
| Age rating | ___ | ___ |
| Review time | ___ | ___ |

<details>
<summary>Check Answers</summary>

| Requirement | Play Store | App Store |
|-------------|------------|-----------|
| Screenshots | 2-8 per device type | 1-10 per device type |
| Privacy policy | Required | Required |
| Age rating | Content rating questionnaire | Age rating questionnaire |
| Review time | Hours to days | 1-3 days typically |

Both require:
- App icon (512x512 for Play, 1024x1024 for App Store)
- Short description
- Full description
- Category selection
- Contact information

</details>

---

## Hands-On Check

### Task 1: Pre-Launch Checklist
Complete this checklist for your app:

```
[ ] Version number updated in pubspec.yaml
[ ] Build number incremented
[ ] App icon set for all sizes
[ ] Splash screen configured
[ ] Release build runs without errors
[ ] API keys use environment variables
[ ] Debug logs/prints removed
[ ] All permissions justified in manifest/plist
[ ] Privacy policy URL ready
[ ] Screenshots captured
```

---

### Task 2: Android Release Build
Build your app for Android release:

```bash
# Steps:
# 1. Create keystore (if first time)
# 2. Configure signing in build.gradle
# 3. Build release
# 4. Test the release build
```

<details>
<summary>Commands</summary>

```bash
# Create keystore (first time only)
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Create key.properties
cat > android/key.properties << EOF
storePassword=your_password
keyPassword=your_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
EOF

# Build App Bundle
flutter build appbundle --release

# Test on device
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

</details>

---

### Task 3: iOS Release Build
Build your app for iOS release:

```bash
# Steps:
# 1. Open in Xcode
# 2. Configure signing
# 3. Archive build
# 4. Upload to App Store Connect
```

<details>
<summary>Steps</summary>

```bash
# Build for iOS
flutter build ipa --release

# Or open in Xcode
open ios/Runner.xcworkspace
```

In Xcode:
1. Select "Any iOS Device" as target
2. Product → Archive
3. Distribute App → App Store Connect
4. Upload

</details>

---

### Task 4: Store Listing
Prepare your store listing content:

```
App Name: _______________
Short Description (80 chars): _______________
Full Description: _______________
Category: _______________
Keywords (App Store): _______________
Privacy Policy URL: _______________
Support Email: _______________
```

---

## Deployment Checklist

### Pre-Build
- [ ] All features complete and tested
- [ ] No TODO comments left in code
- [ ] Dependencies are up to date
- [ ] Sensitive data not in source code

### Android
- [ ] Keystore created and backed up
- [ ] key.properties configured
- [ ] build.gradle configured for signing
- [ ] App bundle builds successfully
- [ ] Release APK tested on real device

### iOS
- [ ] Apple Developer account active
- [ ] Bundle ID matches App Store Connect
- [ ] Signing certificates valid
- [ ] Archive builds successfully
- [ ] TestFlight build tested

### Store Listing
- [ ] App icon (all sizes)
- [ ] Screenshots (all device sizes)
- [ ] Short description
- [ ] Full description
- [ ] Privacy policy
- [ ] Support contact
- [ ] Category selected

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Release build | _________________ |
| App Bundle | _________________ |
| Keystore | _________________ |
| Provisioning profile | _________________ |
| Code signing | _________________ |
| Build number | _________________ |
| Staged rollout | _________________ |

---

## Ready for Level 16?

### I can confidently:
- [ ] Configure app version and build number
- [ ] Create Android keystore for signing
- [ ] Build release APK and App Bundle
- [ ] Configure iOS signing in Xcode
- [ ] Build iOS IPA for App Store
- [ ] Prepare store listing materials
- [ ] Handle environment-specific configuration
- [ ] Remove sensitive data from builds

### Capstone Progress:
- [ ] App icon finalized
- [ ] Splash screen configured
- [ ] Release build works on Android
- [ ] Release build works on iOS
- [ ] Store screenshots captured
- [ ] Store descriptions written

---

## If You're Stuck

**Common issues at this level:**

1. **"Keystore was tampered with"**
   - Wrong password
   - Wrong keystore file
   - Check key.properties paths

2. **iOS signing errors**
   - Certificates expired
   - Wrong team selected
   - Provisioning profile mismatch

3. **Build fails in release but works in debug**
   - ProGuard/R8 stripping needed code
   - Environment variables not set
   - Check for debug-only dependencies

4. **App rejected by store**
   - Read rejection reason carefully
   - Common: missing privacy policy, crashes, incomplete features
   - Fix and resubmit

---

**Ready to level up? Head to Level 16: Professional Patterns!**
