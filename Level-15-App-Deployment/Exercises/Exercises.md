# Level 15: App Deployment - Exercises

Practice preparing and deploying your Flutter app!

---

## Exercise 1: Pre-Release Preparation (Beginner)

**Goal:** Prepare your app for release by cleaning up debug code.

**Tasks:**

### Part A: Remove Debug Code
Find and remove or conditionally hide all debug code:

```dart
// FIND code like this:
print('User data: $userData');
print('API response: $response');
debugPrint('Testing...');

// REPLACE with conditional logging:
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug info here');
}

// OR use a logger package
```

### Part B: Hide Debug Banner
Update your MaterialApp:

```dart
// BEFORE:
MaterialApp(
  title: 'My App',
  home: HomeScreen(),
)

// AFTER:
MaterialApp(
  debugShowCheckedModeBanner: false,  // Add this!
  title: 'My App',
  home: HomeScreen(),
)
```

### Part C: Update Version
Edit pubspec.yaml:

```yaml
# Update version for release
version: 1.0.0+1

# For next update:
version: 1.0.1+2  # Bug fix
version: 1.1.0+3  # New feature
version: 2.0.0+4  # Major update
```

**Checklist:**
- [ ] All print statements removed or conditional
- [ ] Debug banner hidden
- [ ] Version number set correctly
- [ ] Run `flutter analyze` with no issues

---

## Exercise 2: App Icon Setup (Beginner)

**Goal:** Generate all required app icon sizes.

**Tasks:**

### Part A: Create Icon Assets
1. Create a 1024x1024 app icon
2. Save as `assets/icon/app_icon.png`
3. For Android adaptive icons, create:
   - `assets/icon/app_icon_foreground.png` (centered, leave padding)

### Part B: Configure flutter_launcher_icons

```yaml
# Add to pubspec.yaml

dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

  # iOS - remove transparency
  remove_alpha_ios: true

  # Android adaptive icon
  adaptive_icon_background: "#YOUR_BRAND_COLOR"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

### Part C: Generate Icons

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Part D: Verify
- [ ] Check `android/app/src/main/res/mipmap-*` folders
- [ ] Check `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- [ ] Run app on device and verify icon looks correct

---

## Exercise 3: Screenshot Creation (Beginner)

**Goal:** Create professional app store screenshots.

**Tasks:**

### Part A: Capture Raw Screenshots
Run your app and capture screenshots of:
1. Main/home screen
2. Key feature #1
3. Key feature #2
4. Settings or profile
5. Any other notable feature

### Part B: Design Screenshot Template
Create a template with:
- Device frame
- Headline text area
- Brand colors
- Consistent layout

```
┌──────────────────────────┐
│                          │
│   "Headline Text"        │
│                          │
│    ┌────────────────┐    │
│    │                │    │
│    │  [Screenshot]  │    │
│    │                │    │
│    └────────────────┘    │
│                          │
│   Brand color footer     │
│                          │
└──────────────────────────┘
```

### Part C: Create Final Screenshots
Using Figma, Canva, or similar:
1. Apply template to each screenshot
2. Add compelling headlines:
   - "Organize Your Tasks"
   - "Track Your Progress"
   - "Beautiful Dark Mode"
3. Export at correct sizes

**Deliverables:**
- [ ] 5-8 phone screenshots
- [ ] 2+ tablet screenshots (if supporting tablets)
- [ ] Feature graphic (Android, 1024x500)

---

## Exercise 4: Store Listing Copy (Intermediate)

**Goal:** Write compelling store listing text.

**Tasks:**

### Part A: App Name
Create 3 options and choose the best:
```
Option 1: _______________
Option 2: _______________
Option 3: _______________

Chosen: _______________

Criteria:
- [ ] Short and memorable
- [ ] Easy to spell
- [ ] Hints at function
- [ ] Not taken by competitors
```

### Part B: Short Description (80 characters)
Write 3 versions:
```
1. ________________________________ (__ chars)
2. ________________________________ (__ chars)
3. ________________________________ (__ chars)

Best: ________________________________
```

### Part C: Full Description
Write your full description (up to 4000 chars):

```
[HOOK - First 2-3 lines, make them count!]
________________________________
________________________________

[KEY FEATURES]
✓ Feature 1: _______________
✓ Feature 2: _______________
✓ Feature 3: _______________
✓ Feature 4: _______________
✓ Feature 5: _______________

[WHO IT'S FOR]
Perfect for:
• _______________
• _______________
• _______________

[CALL TO ACTION]
________________________________
```

### Part D: Keywords (100 characters for iOS)
Research and list keywords:
```
Primary keywords: _______________
Secondary keywords: _______________

Final keyword string (comma-separated):
________________________________
```

---

## Exercise 5: Privacy Policy Creation (Intermediate)

**Goal:** Create and host a privacy policy.

**Tasks:**

### Part A: Determine Data Collection
Answer these questions:
```
Does your app collect:
[ ] Name or email?
[ ] Photos or files?
[ ] Location?
[ ] Contacts?
[ ] Device information?
[ ] Usage analytics?
[ ] Crash reports?

Third-party services used:
[ ] Firebase Analytics?
[ ] Crashlytics?
[ ] AdMob?
[ ] Facebook SDK?
[ ] Others: _______________
```

### Part B: Generate Policy
Use a tool like Termly.io or create your own covering:
1. What data you collect
2. How you use it
3. Third-party sharing
4. User rights
5. Contact information

### Part C: Host Your Policy
Options:
- GitHub Pages
- Your website
- Google Sites
- Notion (public page)

Final URL: ________________________________

### Part D: Verify
- [ ] URL is publicly accessible
- [ ] Page loads on mobile
- [ ] All sections are complete
- [ ] Contact info is correct

---

## Exercise 6: Android Build & Sign (Intermediate)

**Goal:** Create a signed release build for Android.

**Tasks:**

### Part A: Create Keystore

```bash
keytool -genkey -v \
  -keystore ~/my-app-release.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias my-app-key
```

Record your passwords securely:
```
Keystore password: _______________
Key password: _______________
Keystore location: _______________
```

### Part B: Create key.properties

```properties
# android/key.properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=my-app-key
storeFile=/path/to/your/keystore.jks
```

### Part C: Update build.gradle
Add signing configuration to `android/app/build.gradle`

### Part D: Build Release

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### Part E: Verify
- [ ] Build completes without errors
- [ ] AAB file exists at expected location
- [ ] File size is reasonable (< 100 MB typically)

---

## Exercise 7: iOS Build & Archive (Intermediate)

**Goal:** Create an archive for iOS App Store.

**Prerequisite:** Mac with Xcode, Apple Developer account

**Tasks:**

### Part A: Configure Xcode
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Select your team
5. Set bundle identifier

### Part B: Build Release

```bash
flutter clean
flutter pub get
flutter build ios --release
```

### Part C: Archive

1. In Xcode, select "Any iOS Device"
2. Product → Archive
3. Wait for completion

### Part D: Verify
- [ ] No signing errors in Xcode
- [ ] Archive appears in Organizer
- [ ] Ready to distribute

---

## Exercise 8: Complete Deployment Walkthrough (Advanced)

**Goal:** Complete a full deployment to Google Play (Internal Testing).

**Tasks:**

### Part A: Google Play Console Setup
1. Create developer account (if needed)
2. Create new app
3. Complete all dashboard items

### Part B: Upload Build
1. Build app bundle
2. Create internal testing release
3. Upload AAB
4. Add release notes

### Part C: Complete Listing
Fill in all required information:
- [ ] Store listing (name, description, icon, screenshots)
- [ ] Content rating
- [ ] Target audience
- [ ] Data safety
- [ ] Privacy policy

### Part D: Internal Testing
1. Add test email addresses
2. Submit for internal testing
3. Test on real device
4. Note any issues

### Part E: Documentation
Create deployment documentation:
```markdown
# [App Name] Deployment Notes

## Build Info
- Version: ___
- Build Number: ___
- Build Date: ___

## Keystore Location
- Path: ___
- Backup: ___

## Store Listings
- Google Play: [URL]
- App Store: [URL]

## Test Accounts
- Email: ___

## Known Issues
- ___

## Post-Launch Checklist
- [ ] Monitor crash reports
- [ ] Check user reviews
- [ ] Prepare v1.0.1 fixes
```

---

## Deployment Checklist Template

Copy and use for your deployments:

```
APP DEPLOYMENT CHECKLIST

App Name: _______________
Version: _______________
Date: _______________

PRE-BUILD:
[ ] Debug code removed
[ ] Version number updated
[ ] All features tested
[ ] No console errors

ASSETS:
[ ] App icon (all sizes)
[ ] Screenshots (all required sizes)
[ ] Feature graphic (Android)
[ ] Privacy policy URL works

SIGNING:
[ ] Android keystore created
[ ] Key.properties configured
[ ] iOS signing configured
[ ] Keys backed up securely

BUILD:
[ ] flutter clean
[ ] flutter pub get
[ ] flutter analyze (no issues)
[ ] flutter test (all pass)
[ ] flutter build appbundle --release
[ ] flutter build ios --release

STORE LISTING:
[ ] App name
[ ] Short description
[ ] Full description
[ ] Category selected
[ ] Content rating done
[ ] Data safety completed

SUBMISSION:
[ ] Build uploaded
[ ] Release notes added
[ ] Submitted for review

POST-LAUNCH:
[ ] Download and test from store
[ ] Monitor crash reports
[ ] Respond to reviews
[ ] Plan next update
```

---

## Quick Reference

```
ANDROID COMMANDS:
flutter build apk                    # Debug APK
flutter build apk --release          # Release APK
flutter build appbundle --release    # Release AAB (for Play Store)
flutter build apk --split-per-abi    # Split APKs

iOS COMMANDS:
flutter build ios                    # Debug build
flutter build ios --release          # Release build
# Then archive in Xcode

ANALYSIS:
flutter analyze                      # Check for issues
flutter test                         # Run tests
flutter build apk --analyze-size     # Check APK size

CLEANING:
flutter clean                        # Clean build files
cd ios && pod install               # Reinstall iOS pods
```

---

**Congratulations!** You've completed Level 15!

You now know how to deploy your Flutter app to both the Google Play Store and Apple App Store.

**Next Level:** Level 16 - Professional Patterns (Architecture & Best Practices)
