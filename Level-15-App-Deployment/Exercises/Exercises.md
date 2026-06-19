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

<details>
<summary>✅ Example Solution</summary>

```dart
// main.dart - debug logging wrapped, banner hidden
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('App started in debug mode');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false, // banner hidden for release
      title: 'My App',
      home: const HomeScreen(),
    );
  }
}
```

```yaml
# pubspec.yaml - first public release
version: 1.0.0+1
```

`flutter analyze` then reports "No issues found!" Note: the version `name` (1.0.0) is what users see; the `+1` build number must increase on every store upload.

</details>

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

<details>
<summary>✅ Example Solution</summary>

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  remove_alpha_ios: true
  adaptive_icon_background: "#0D47A1"   # your brand color
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

```bash
flutter pub get
dart run flutter_launcher_icons
```

After running, the `mipmap-mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi` folders all contain `ic_launcher.png`, and `AppIcon.appiconset` is filled in. The key gotcha: iOS icons must have **no transparency** (set `remove_alpha_ios: true`), or the App Store rejects the build.

</details>

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

<details>
<summary>✅ Example Solution</summary>

For a habit-tracker app, a good set of 5 framed screenshots with headlines:

1. Home/list - "All your habits in one place"
2. Add habit - "Add a new habit in seconds"
3. Streak view - "Build streaks that keep you going"
4. Stats - "See your progress over time"
5. Dark mode - "Easy on the eyes, day or night"

Each uses the same device frame, the brand color footer, and a short benefit-focused headline (not "Screen 1"). Export phone shots at the store's required size (e.g. 1080x1920 portrait) and the Android feature graphic at exactly 1024x500. The point of the headline is to sell the benefit, not just label the screen.

</details>

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

<details>
<summary>✅ Example Solution</summary>

Worked example for a habit tracker:

```
App name: Streak - Habit Tracker

Short description (under 80 chars):
"Build good habits, break bad ones, and track your daily streaks." (63 chars)

Full description:
Build the habits you actually want to keep.

Streak makes it simple to add a habit, check it off each day, and watch your
streak grow. No clutter, no account required.

KEY FEATURES
✓ Add unlimited habits in seconds
✓ One-tap daily check-off
✓ Streak counter to keep your momentum
✓ Reminders so you never forget
✓ Light and dark themes

PERFECT FOR
• Anyone building a new routine
• Students and busy professionals
• People who love a satisfying streak

Download Streak and start your first streak today!

iOS keywords (under 100 chars):
habit,tracker,streak,routine,daily,goals,reminder,productivity
```

The first 2-3 lines are the hook (many users never tap "more"), the description leads with benefits, and keywords are comma-separated with no spaces to fit the iOS 100-char limit.

</details>

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

<details>
<summary>✅ Example Solution</summary>

Even a simple app usually collects something. Example for a habit tracker that uses crash reporting:

- Collects: crash reports and basic device info (via Crashlytics). No name, email, location, contacts, or photos.
- Uses it for: fixing crashes and improving the app, nothing else.
- Shares with: only the crash-reporting provider (Google), not sold to anyone.
- User rights: users can request deletion by emailing the contact address.
- Contact: support@yourapp.com

Host it free on GitHub Pages: put `privacy.md`/`index.html` in a public repo, enable Pages, and your URL becomes `https://yourname.github.io/yourapp-privacy/`. Both stores REQUIRE a working public privacy policy URL, so test it loads on mobile before submitting.

</details>

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

<details>
<summary>✅ Example Solution</summary>

`android/app/build.gradle` signing config that reads from `key.properties`:

```gradle
// Above android { ... }
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
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
        }
    }
}
```

Then:

```bash
flutter clean && flutter pub get
flutter build appbundle --release
# -> build/app/outputs/bundle/release/app-release.aab
```

Critical: add `key.properties` and the `.jks` to `.gitignore` and back the keystore up safely. If you lose it, you can never update the app under the same identity.

</details>

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

<details>
<summary>✅ Example Solution</summary>

Walkthrough on a Mac with Xcode and a paid Apple Developer account:

1. In Xcode: Runner target → Signing & Capabilities → check "Automatically manage signing", pick your Team, set a unique Bundle Identifier (e.g. `com.yourname.streak`).
2. Build: `flutter clean && flutter pub get && flutter build ipa --release` (or `flutter build ios --release` then archive).
3. In Xcode choose the device target "Any iOS Device (arm64)", then Product → Archive.
4. When the Organizer opens, "Distribute App" → App Store Connect → Upload.

Common blocker: "No signing certificate" means your Apple Developer membership/Team is not selected, fix it in step 1. You cannot archive for the store from a simulator target; it must be a device target.

</details>

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

<details>
<summary>✅ Example Solution</summary>

The smart move for a first release is **Internal Testing**, not Production, so only you and a few testers see it while you shake out bugs.

1. Play Console → Create app → fill the dashboard (app name, default language, app or game, free or paid).
2. Testing → Internal testing → Create new release → upload `app-release.aab` → add release notes ("First internal build").
3. Complete the required sections once: Store listing, Content rating questionnaire, Target audience, Data safety, and the Privacy policy URL. Play will not let you roll out until these are green.
4. Add testers by email (or a Google Group), copy the opt-in link, open it on a real device, and install from the Play Store test track.
5. Record everything (version, build number, keystore path + backup, test emails) in the deployment notes so the next release is repeatable.

Doing internal testing first means a bad build never reaches real users, and you confirm the signed store build actually runs on a real device before going public.

</details>

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
