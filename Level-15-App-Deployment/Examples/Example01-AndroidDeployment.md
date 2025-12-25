# Example 01: Android Deployment Guide

## Complete Step-by-Step Android Deployment

This guide walks you through deploying a Flutter app to the Google Play Store.

---

## Prerequisites Checklist

```
BEFORE YOU START:

□ Flutter app is complete and tested
□ Google account ready
□ $25 for developer fee
□ App icon (512x512 minimum)
□ Screenshots ready
□ Privacy policy URL
□ App description written
```

---

## Step 1: Prepare Your App

### Update pubspec.yaml

```yaml
# pubspec.yaml

name: my_awesome_app
description: A helpful description of your app.

# Version: 1.0.0 (user-facing) + 1 (build number)
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  # ... your dependencies

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    # List all your assets

  # App icons (use flutter_launcher_icons)
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
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

```bash
# Run this command
flutter pub run flutter_launcher_icons
```

### Update Android Configuration

```gradle
// android/app/build.gradle

android {
    compileSdkVersion 34

    defaultConfig {
        // Your unique app ID - CANNOT change after publishing!
        applicationId "com.yourcompany.myawesomeapp"

        minSdkVersion 21
        targetSdkVersion 34

        // From pubspec.yaml
        versionCode flutter.versionCode
        versionName flutter.versionName
    }
}
```

---

## Step 2: Create Signing Key

### Generate Keystore

```bash
# Open terminal and run:

keytool -genkey -v \
  -keystore ~/my-release-key.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias my-key-alias

# Answer the prompts:
# - Keystore password: (create a strong password)
# - Your name: John Doe
# - Organizational unit: Development
# - Organization: Your Company
# - City: Your City
# - State: Your State
# - Country code: US

# SAVE THESE PASSWORDS! You'll need them forever.
```

### Create key.properties

```properties
# android/key.properties
# ⚠️ Add this file to .gitignore!

storePassword=your_keystore_password_here
keyPassword=your_key_password_here
keyAlias=my-key-alias
storeFile=/Users/yourname/my-release-key.jks
```

### Update .gitignore

```gitignore
# Add to .gitignore

# Signing
android/key.properties
*.jks
*.keystore
```

### Configure Gradle for Signing

```gradle
// android/app/build.gradle

// Add at the top, before 'android {'
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...

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

---

## Step 3: Build Release

### Clean and Build

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output location:
# build/app/outputs/bundle/release/app-release.aab
```

### Verify Build

```bash
# Check the output file exists
ls -la build/app/outputs/bundle/release/

# You should see:
# app-release.aab
```

---

## Step 4: Create Play Console Listing

### Create Developer Account

```
1. Go to: https://play.google.com/console
2. Sign in with Google account
3. Accept Developer Agreement
4. Pay $25 registration fee
5. Wait for account verification (up to 48 hours)
```

### Create New App

```
1. Click "Create app"
2. Enter app details:
   - App name: My Awesome App
   - Default language: English
   - App or Game: App
   - Free or Paid: Free
3. Accept declarations
4. Click "Create app"
```

### Complete Dashboard Items

```
STORE PRESENCE:

Main store listing:
├── App name: My Awesome App
├── Short description: (80 chars max)
│   "The best app for organizing your daily tasks efficiently."
├── Full description: (4000 chars max)
│   [Your detailed description]
├── App icon: Upload 512x512 PNG
├── Feature graphic: 1024x500 PNG
└── Screenshots: Upload 2-8 screenshots

Graphics requirements:
├── Phone screenshots: 320-3840 px, 16:9 or 9:16
├── 7" tablet: 320-3840 px
└── 10" tablet: 320-3840 px
```

```
APP CONTENT:

Privacy policy:
└── Enter URL: https://yourwebsite.com/privacy

App access:
├── All functionality available without login
└── OR provide test credentials

Ads:
├── Yes, contains ads
└── No ads

Content rating:
└── Complete questionnaire (takes 5 minutes)

Target audience:
└── Select age groups your app is for

Data safety:
└── Declare what data your app collects
```

---

## Step 5: Upload and Release

### Upload App Bundle

```
1. Go to: Production → Releases
2. Click "Create new release"
3. App signing by Google Play:
   └── "Use Google Play App Signing" (recommended)
4. Upload your AAB:
   └── Drag and drop app-release.aab
5. Add release name: 1.0.0
6. Add release notes:
   └── "Initial release with core features"
```

### Review and Rollout

```
1. Click "Review release"
2. Fix any warnings or errors
3. Click "Start rollout to Production"
4. Confirm the rollout

⏱️ Review typically takes:
   - First app: 3-7 days
   - Updates: Hours to 2 days
```

---

## Step 6: Monitor After Launch

### Check Status

```
IN PLAY CONSOLE:

Dashboard shows:
├── Review status (In review → Published)
├── Install statistics
├── Crash reports
├── User reviews
└── Revenue (if applicable)
```

### Respond to Reviews

```
BEST PRACTICES:

✅ Respond to negative reviews quickly
✅ Thank users for positive feedback
✅ Address issues mentioned
✅ Be professional and helpful
❌ Don't argue with users
❌ Don't share personal information
```

---

## Common Issues and Fixes

```
ISSUE: "You uploaded a debuggable APK or Android App Bundle"
FIX: Make sure you ran: flutter build appbundle --release

ISSUE: "Version code already used"
FIX: Increment versionCode in pubspec.yaml
     version: 1.0.0+2  (change +1 to +2)

ISSUE: "Signing key not found"
FIX: Check key.properties path is correct

ISSUE: "App rejected for policy violation"
FIX: Read rejection email carefully, fix specific issue

ISSUE: "Screenshots wrong size"
FIX: Use recommended dimensions (see above)
```

---

## Quick Command Reference

```bash
# Full deployment sequence:

# 1. Clean
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Run tests
flutter test

# 4. Build release
flutter build appbundle --release

# 5. Locate output
ls build/app/outputs/bundle/release/app-release.aab

# Upload to Play Console manually
```

---

## Summary Checklist

```
ANDROID DEPLOYMENT CHECKLIST:

PREPARATION:
□ Version number updated
□ App icons generated
□ Debug code removed
□ Tested in release mode

SIGNING:
□ Keystore created
□ key.properties configured
□ Gradle updated for signing
□ Keystore backed up securely

BUILD:
□ flutter clean
□ flutter build appbundle --release
□ AAB file verified

PLAY CONSOLE:
□ Developer account created
□ App listing created
□ All required information filled
□ Screenshots uploaded
□ Privacy policy linked

RELEASE:
□ AAB uploaded
□ Release notes added
□ Submitted for review
□ Monitoring for approval

🎉 PUBLISHED!
```
