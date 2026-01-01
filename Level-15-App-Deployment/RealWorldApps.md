# Level 15: Real-World Apps Using These Concepts

See how apps go from development to millions of users!

---

## App Store Optimization

### Getting Discovered!

**Successful App Listings**

**Uber's App Store Presence:**
- Clear, benefit-focused title
- Screenshots showing key features
- Video preview of the experience
- Localized for each country
- Regular updates with release notes

**Instagram's Approach:**
- Simple, recognizable icon
- Action-focused screenshots
- Minimal text, visual focus
- Consistent brand colors
- Regular feature updates

---

## App Configuration

### Production-Ready Setup!

**Environment Configuration**
```dart
// config/app_config.dart
class AppConfig {
  static String get apiBaseUrl {
    if (kDebugMode) {
      return 'https://api-staging.myapp.com';
    }
    return 'https://api.myapp.com';
  }

  static String get analyticsKey {
    return const String.fromEnvironment('ANALYTICS_KEY');
  }

  static bool get enableCrashReporting {
    return !kDebugMode;
  }
}

// Build commands:
// flutter build apk --dart-define=ANALYTICS_KEY=prod_key_123
```

---

## Android Release

### Play Store Deployment!

**Signing Configuration**
```groovy
// android/app/build.gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
        }
    }
}
```

**Build Commands**
```bash
# Generate keystore (one time)
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Build release App Bundle
flutter build appbundle --release

# Build APK (for testing)
flutter build apk --release --split-per-abi
```

---

## iOS Release

### App Store Deployment!

**Xcode Configuration**
- Bundle identifier matches App Store Connect
- Signing certificate from Apple Developer account
- Provisioning profile for distribution
- Version and build number set

**Build Commands**
```bash
# Build iOS archive
flutter build ipa --release

# Or use Xcode
# Product → Archive → Distribute App
```

---

## Versioning Strategy

### How Big Apps Version!

**Semantic Versioning in Practice**
```yaml
# pubspec.yaml

# Major.Minor.Patch+Build
version: 2.5.3+156

# Major (2): Breaking changes, major redesigns
# Minor (5): New features, non-breaking
# Patch (3): Bug fixes
# Build (156): Increments for every store upload
```

**Real Examples:**
- Instagram 275.0.0 → 276.0.0 (Major feature update)
- Uber 3.456.10001 (Different versioning scheme)
- Spotify 8.7.62 (Semantic versioning)

---

## Release Channels

### Gradual Rollouts!

**How Big Apps Release**

**Google's Approach:**
1. Internal testing → Employees
2. Closed testing → Select users
3. Open testing → Anyone can join
4. Production → Staged rollout (1% → 5% → 20% → 100%)

**Netflix:**
- A/B test features in production
- Regional rollouts
- Device-specific releases

---

## Crash Reporting

### Knowing When Things Break!

**Firebase Crashlytics Setup**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Catch Flutter errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Catch async errors
  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}
```

---

## App Updates

### Keeping Users Current!

**In-App Update Prompts**
```dart
class UpdateService {
  Future<void> checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    final minVersion = remoteConfig.getString('min_app_version');
    final currentVersion = (await PackageInfo.fromPlatform()).version;

    if (isVersionLower(currentVersion, minVersion)) {
      showForceUpdateDialog();
    }
  }
}
```

---

## Real Company Deployment Practices

| Company | Practice |
|---------|----------|
| **Uber** | Deploy multiple times per day |
| **Netflix** | Canary deployments |
| **Spotify** | Feature flags + gradual rollout |
| **Airbnb** | A/B testing in production |
| **Instagram** | Regional rollouts |

---

## CI/CD Pipeline

### Automated Releases!

**GitHub Actions Example**
```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2

      - name: Build App Bundle
        run: flutter build appbundle --release
        env:
          KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJson: ${{ secrets.PLAY_STORE_KEY }}
          packageName: com.mycompany.myapp
          releaseFiles: build/app/outputs/bundle/release/*.aab
          track: internal
```

---

## App Store Requirements

### What You Need!

**Play Store Checklist:**
- [ ] App Bundle signed with upload key
- [ ] Privacy policy URL
- [ ] App screenshots (at least 2)
- [ ] Feature graphic (1024x500)
- [ ] Short description (80 chars)
- [ ] Full description
- [ ] Content rating questionnaire

**App Store Checklist:**
- [ ] App signed with distribution certificate
- [ ] Privacy policy URL
- [ ] Screenshots for all device sizes
- [ ] App preview video (optional)
- [ ] Description
- [ ] Keywords
- [ ] Age rating questionnaire

---

## Post-Launch Monitoring

### Keeping Apps Healthy!

**Metrics to Track:**
- Crash-free rate (target: 99.5%+)
- App startup time
- API response times
- User retention
- Review ratings

---

## Build Your Deployment Skills!

After this level, you could:

1. **Deploy to TestFlight** - iOS beta testing
2. **Set up Play Console** - Android releases
3. **Implement crash reporting** - Firebase Crashlytics
4. **Create CI/CD pipeline** - Automated builds
5. **Practice staged rollouts** - Gradual releases

---

**Deployment is where your app meets the real world - do it right!**
