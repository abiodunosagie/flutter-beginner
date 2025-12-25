# Example 02: iOS Deployment Guide

## Complete Step-by-Step iOS Deployment

This guide walks you through deploying a Flutter app to the Apple App Store.

---

## Prerequisites Checklist

```
BEFORE YOU START:

□ Mac computer (required for iOS!)
□ Xcode installed (latest version)
□ Apple ID
□ $99/year for Apple Developer Program
□ App icon (1024x1024)
□ Screenshots for all device sizes
□ Privacy policy URL
□ App description written
```

---

## Step 1: Apple Developer Account

### Enroll in Developer Program

```
1. Go to: https://developer.apple.com

2. Click "Account" and sign in with Apple ID

3. At the bottom, click "Join the Apple Developer Program"

4. Click "Enroll"

5. Choose enrollment type:
   ├── Individual: Personal apps
   └── Organization: Company apps (needs D-U-N-S number)

6. Pay $99/year

7. Wait for approval:
   ├── Individual: Usually 24-48 hours
   └── Organization: May take longer

You'll receive email when approved.
```

---

## Step 2: Prepare Your App

### Update pubspec.yaml

```yaml
# pubspec.yaml

name: my_awesome_app
description: A helpful description of your app.

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
```

### Generate App Icons

```yaml
# Add to pubspec.yaml

dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  remove_alpha_ios: true  # iOS requires no transparency
```

```bash
flutter pub run flutter_launcher_icons
```

### Update iOS Configuration

Open `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Display Name -->
    <key>CFBundleDisplayName</key>
    <string>My Awesome App</string>

    <!-- Required Permissions (only include what you use!) -->

    <!-- Camera -->
    <key>NSCameraUsageDescription</key>
    <string>We need camera access to take photos for your profile.</string>

    <!-- Photo Library -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to select photos for your posts.</string>

    <!-- Location -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to show nearby places.</string>

    <!-- Other configurations... -->
</dict>
</plist>
```

---

## Step 3: Configure Signing in Xcode

### Open Project in Xcode

```bash
# From your Flutter project root:
open ios/Runner.xcworkspace

# ⚠️ IMPORTANT: Open .xcworkspace, NOT .xcodeproj!
```

### Configure Signing

```
IN XCODE:

1. Click "Runner" in the left sidebar (blue icon)

2. Select "Runner" under TARGETS

3. Go to "Signing & Capabilities" tab

4. Check "Automatically manage signing"

5. Team: Select your Apple Developer Team
   (If not showing, add account in Xcode → Preferences → Accounts)

6. Bundle Identifier: com.yourcompany.myawesomeapp
   (Must be unique across all App Store apps)

7. Xcode will automatically:
   ├── Create App ID
   ├── Create certificates
   └── Create provisioning profiles
```

### Verify Signing

```
GREEN CHECKMARK = Good to go!

If you see errors:
├── "No signing certificate found"
│   └── Add Apple ID in Xcode Preferences
├── "Failed to create provisioning profile"
│   └── Check Bundle ID is unique
└── "Revoke and request new"
    └── Click the button to fix
```

---

## Step 4: Create App in App Store Connect

### Log into App Store Connect

```
1. Go to: https://appstoreconnect.apple.com

2. Sign in with your Apple ID

3. Click "My Apps"

4. Click "+" → "New App"
```

### Fill in App Information

```
NEW APP FORM:

Platforms: ☑️ iOS

Name: My Awesome App
(This appears on App Store)

Primary Language: English (U.S.)

Bundle ID: Select from dropdown
(Must match Xcode Bundle Identifier)

SKU: myawesomeapp-ios-001
(Your internal identifier)

User Access: Full Access
(Who on your team can access)

Click "Create"
```

---

## Step 5: Build and Upload

### Build Release in Terminal

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build iOS release
flutter build ios --release
```

### Archive in Xcode

```
1. In Xcode, select device:
   └── "Any iOS Device (arm64)"
   (Not a simulator!)

2. Menu: Product → Archive

3. Wait for build to complete...
   (May take several minutes)

4. Organizer window opens automatically
   (If not: Window → Organizer)
```

### Upload to App Store Connect

```
IN ORGANIZER:

1. Select your archive

2. Click "Distribute App"

3. Select method:
   └── "App Store Connect"

4. Select destination:
   └── "Upload"

5. Options:
   ☑️ Include bitcode
   ☑️ Upload symbols
   ☑️ Manage version and build

6. Select certificate:
   └── Automatically manage signing

7. Click "Upload"

8. Wait for upload to complete...

⏱️ Processing takes 15-30 minutes
   before appearing in App Store Connect
```

---

## Step 6: Complete App Store Listing

### App Information

```
IN APP STORE CONNECT → APP INFORMATION:

Localizable Information:
├── Name: My Awesome App
├── Subtitle: Organize your life (30 chars max)
└── Privacy Policy URL: https://yoursite.com/privacy

General Information:
├── Bundle ID: (auto-filled)
├── SKU: (auto-filled)
├── Primary Category: Productivity
└── Secondary Category: Lifestyle (optional)

Content Rights:
└── Does not contain third-party content
```

### Pricing and Availability

```
PRICING:
├── Price: Free (or select price tier)
└── In-App Purchases: Configure if applicable

AVAILABILITY:
├── All countries
└── Or select specific countries

PRE-ORDERS:
└── Enable if you want (optional)
```

### Prepare for Submission

```
VERSION INFORMATION:

Screenshots (all required sizes):
├── 6.7" Display: 1290 x 2796 px (iPhone 15 Pro Max)
├── 6.5" Display: 1284 x 2778 px (iPhone 14 Plus)
├── 5.5" Display: 1242 x 2208 px (iPhone 8 Plus)
└── iPad Pro 12.9": 2048 x 2732 px

App Preview (optional):
└── 15-30 second video

Promotional Text:
└── 170 characters (can update without review)

Description:
└── Full description of your app

Keywords:
└── 100 characters, comma-separated
    Example: task,todo,productivity,organize,lists

Support URL:
└── https://yoursite.com/support

Marketing URL:
└── https://yoursite.com (optional)
```

### Select Build

```
BUILD SECTION:

1. Wait for your upload to finish processing
   (Check Activity tab for status)

2. Click "+" next to Build

3. Select your uploaded build

4. Answer compliance question:
   "Does your app use encryption?"

   If you use HTTPS → Select "Yes"
   └── Then select exemption for HTTPS
```

### App Review Information

```
APP REVIEW:

Sign-in Information:
├── Username: test@example.com
├── Password: testpassword123
└── (Required if app has login)

Contact Information:
├── First Name: John
├── Last Name: Doe
├── Phone: +1-555-123-4567
└── Email: developer@yourcompany.com

Notes:
└── Any special instructions for reviewers
```

---

## Step 7: Submit for Review

### Final Check

```
BEFORE SUBMITTING:

□ All screenshots uploaded
□ Description complete
□ Build selected
□ Privacy policy URL works
□ App Review info filled
□ Contact info correct
```

### Submit

```
1. Click "Add for Review"

2. Review the submission summary

3. Click "Submit to App Review"

4. Confirm submission

⏱️ REVIEW TIME:
├── Average: 24-48 hours
├── First app: May take longer
└── Holidays: Expect delays
```

---

## Step 8: After Submission

### Monitor Status

```
STATUS PROGRESSION:

Waiting for Review → In Review → Pending Developer Release → Ready for Sale

You'll receive email at each stage.
```

### If Rejected

```
DON'T PANIC!

1. Read the rejection reason carefully
2. Often it's something simple:
   ├── Missing permission description
   ├── Broken link
   ├── Crash during review
   └── Missing feature mentioned in description

3. Fix the issue

4. Increment build number:
   version: 1.0.0+2

5. Archive and upload again

6. Resubmit for review
```

---

## Common Issues and Fixes

```
ISSUE: "No valid signing identity found"
FIX:
├── Xcode → Preferences → Accounts
├── Add your Apple ID
└── Download certificates

ISSUE: "Provisioning profile doesn't match"
FIX:
├── Enable "Automatically manage signing"
└── Or update profile in Apple Developer Portal

ISSUE: Archive option is grayed out
FIX:
├── Select "Any iOS Device" as target
└── Not a simulator

ISSUE: Build processing stuck
FIX:
├── Wait up to 30 minutes
├── If longer, upload again
└── Check email for processing errors

ISSUE: "Missing compliance"
FIX:
├── Select build in App Store Connect
└── Answer encryption question

ISSUE: Rejected for crashes
FIX:
├── Test thoroughly on real device
├── Check crash logs in Xcode
└── Fix and resubmit
```

---

## Quick Command Reference

```bash
# Full iOS deployment sequence:

# 1. Clean
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Build iOS
flutter build ios --release

# 4. Open Xcode
open ios/Runner.xcworkspace

# In Xcode:
# 5. Select "Any iOS Device"
# 6. Product → Archive
# 7. Distribute App → App Store Connect → Upload
```

---

## Summary Checklist

```
iOS DEPLOYMENT CHECKLIST:

PREREQUISITES:
□ Mac computer available
□ Xcode installed
□ Apple Developer account active ($99/year)

PREPARATION:
□ Version number updated
□ App icons generated (no transparency!)
□ Permission descriptions in Info.plist
□ Tested on real iOS device

XCODE SETUP:
□ Opened .xcworkspace (not .xcodeproj)
□ Team selected
□ Bundle ID set
□ Automatic signing enabled
□ No signing errors

APP STORE CONNECT:
□ App created
□ All metadata filled
□ Screenshots uploaded (all sizes)
□ Privacy policy linked

BUILD & UPLOAD:
□ Archive created in Xcode
□ Upload successful
□ Build processing complete
□ Build selected in App Store Connect

SUBMISSION:
□ App Review info complete
□ Submitted for review
□ Monitoring for approval

🎉 PUBLISHED ON APP STORE!
```
