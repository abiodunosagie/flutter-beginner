# Android Deployment: Complete Guide to Play Store

## What You'll Learn

- Preparing your app for release
- Creating app signing keys
- Building release APK and App Bundle
- Play Store submission process
- Version management
- Best practices

## Step 1: Prepare Your App

### Update App Information

**android/app/src/main/AndroidManifest.xml:**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.yourapp">

    <application
        android:label="Your App Name"  <!-- User-facing name -->
        android:icon="@mipmap/ic_launcher">  <!-- App icon -->
```

### Update Version

**pubspec.yaml:**

```yaml
version: 1.0.0+1
#        ^^^^^ version name (shown to users)
#            ^ build number (must increment each release)
```

**For updates:**
```yaml
version: 1.0.1+2  # Bug fix
version: 1.1.0+3  # New features
version: 2.0.0+4  # Major release
```

## Step 2: Create App Icon

Use a 512x512 PNG image and generate icons:

### Option 1: flutter_launcher_icons package

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
```

Run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Option 2: Android Studio
- Right-click `res` folder
- New → Image Asset
- Upload 512x512 icon
- Generate all sizes

## Step 3: Create Signing Key

### Generate Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Answer prompts:**
- Password: Choose strong password
- First and last name: Your name or company
- Organizational unit: Your team/department
- Organization: Your company
- City, State, Country: Your location

**IMPORTANT:** Save keystore file and passwords securely!

### Create key.properties

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

**Add to .gitignore:**
```
android/key.properties
*.jks
```

### Configure build.gradle

**android/app/build.gradle:**

```gradle
// Add before android block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config

    // Add signing configs
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
            signingConfig signingConfigs.release  // Add this line

            // Existing minify settings
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

## Step 4: Build Release

### Build App Bundle (Recommended)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

**Why App Bundle?**
- ✅ Smaller download size
- ✅ Dynamic delivery
- ✅ Automatic optimizations
- ✅ Required for new apps on Play Store

### Build APK (Optional)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build Split APKs (Optional)

```bash
flutter build apk --split-per-abi --release
```

Generates separate APKs for each architecture (smaller files).

## Step 5: Test Release Build

### Install on Device

```bash
flutter install --release
```

### Test Thoroughly

✅ All features work
✅ No debug logs/banners
✅ Proper app name and icon
✅ Permissions work correctly
✅ API calls work (not using localhost)
✅ Performance is good
✅ No crashes

## Step 6: Play Console Setup

### Create Google Play Developer Account

1. Go to [play.google.com/console](https://play.google.com/console)
2. Pay $25 one-time fee
3. Complete account verification

### Create App

1. Click "Create app"
2. Fill in app details:
   - App name
   - Default language
   - App or game
   - Free or paid

## Step 7: Store Listing

### App Details

**Short description (80 chars):**
```
Quick summary of your app
```

**Full description (4000 chars):**
```
Detailed description of features and benefits.

Key features:
• Feature 1
• Feature 2
• Feature 3

How to use:
1. Step 1
2. Step 2

Support: support@yourapp.com
```

### Graphics

Required assets:

1. **App icon**: 512x512 PNG
2. **Feature graphic**: 1024x500 PNG
3. **Phone screenshots**: At least 2 (1080x1920 or higher)
4. **7-inch tablet screenshots**: At least 2 (optional but recommended)
5. **10-inch tablet screenshots**: At least 2 (optional)

Optional:
- Promo video (YouTube link)
- TV banner
- Wear OS screenshots

## Step 8: Content Rating

1. Fill out questionnaire
2. Categories: E (Everyone), T (Teen), M (Mature), etc.
3. Submit for rating

## Step 9: Pricing & Distribution

- **Free or Paid**: Choose pricing model
- **Countries**: Select where to distribute
- **Ads**: Declare if app contains ads
- **Target audience**: Select age groups

## Step 10: Release

### Internal Testing (Recommended First)

1. Go to "Internal testing"
2. Create release
3. Upload app-release.aab
4. Add internal testers (emails)
5. Share test link

### Closed Testing (Beta)

1. Create closed track
2. Upload build
3. Add beta testers
4. Get feedback

### Production Release

1. Go to "Production"
2. Create release
3. Upload app-release.aab
4. Add release notes
5. Review and rollout

**Release options:**
- Staged rollout: 5%, 10%, 20%, 50%, 100%
- Full rollout: 100% immediately

## Step 11: Post-Launch

### Monitor

- Install statistics
- Crash reports
- User reviews
- Performance metrics

### Update Checklist

1. Fix bugs/add features
2. Increment version in pubspec.yaml
3. Build new app bundle
4. Upload to Play Console
5. Add release notes
6. Submit for review

## Common Issues & Solutions

### Issue: "Upload failed: You need to use a different version code"

**Solution:** Increment build number in pubspec.yaml
```yaml
version: 1.0.1+2  # Increment the number after +
```

### Issue: "Keystore file not found"

**Solution:** Check path in key.properties is absolute or correct relative path

### Issue: "App not installable"

**Solution:**
- Check minimum SDK version
- Verify signing is configured correctly
- Test on actual device

## Best Practices

✅ Test release build thoroughly before submission
✅ Use semantic versioning (MAJOR.MINOR.PATCH)
✅ Keep keystore file secure (backup in safe place)
✅ Write clear, helpful release notes
✅ Respond to user reviews
✅ Monitor crash reports and fix issues quickly
✅ Use staged rollouts for major updates
✅ Keep screenshots up to date with app
✅ Follow Play Store policies carefully

## Checklists

### Pre-Launch Checklist

- [ ] App icon is 512x512 PNG
- [ ] Version incremented correctly
- [ ] Signing key configured
- [ ] Release build tested
- [ ] All permissions justified
- [ ] Privacy policy added (if collecting data)
- [ ] Screenshots prepared
- [ ] Store listing complete
- [ ] Content rating obtained

### Update Checklist

- [ ] Version incremented
- [ ] Changelog written
- [ ] Tested on multiple devices
- [ ] No critical bugs
- [ ] Build uploaded
- [ ] Release notes added

## Resources

- [Play Console](https://play.google.com/console)
- [Flutter deployment docs](https://docs.flutter.dev/deployment/android)
- [Play Store policies](https://play.google.com/about/developer-content-policy/)

## What's Next

Next: **iOS Deployment** - Publishing to App Store!

You're ready to publish your Android app! 🚀
