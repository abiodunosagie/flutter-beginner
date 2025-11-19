# Week 33: App Flavors - Exercises

## Overview

This week focuses on **App Flavors** in Flutter - a critical skill for professional app development. Flavors (also called build variants) allow you to create multiple versions of your app from a single codebase, each with different configurations, features, and settings.

## Why App Flavors Matter

In professional Flutter development, you typically need to maintain multiple versions of your app:
- **Development**: For active development with debug features enabled
- **Staging/QA**: For testing with production-like settings
- **Production**: For end users with all safety measures enabled

App flavors allow you to:
- Use different API endpoints per environment
- Configure different Firebase projects
- Enable/disable features per environment
- Use test vs. live payment keys
- Control logging and analytics
- Customize app appearance per flavor
- Manage secrets securely

## Exercise Structure

This week includes 5 progressive exercises, each building on the previous concepts:

### Exercise 1: Simple Flavor Setup (Beginner)
**File**: `exercise_1_template.dart` / `exercise_1_solution.dart`

**What you'll learn**:
- Basic flavor configuration
- FlavorConfig class implementation
- Displaying current flavor information
- Different app names and colors per flavor

**Key concepts**:
- Enum for flavors
- Singleton configuration pattern
- Runtime flavor detection
- --dart-define usage

**Run with**:
```bash
flutter run --dart-define=FLAVOR=dev
flutter run --dart-define=FLAVOR=staging
flutter run --dart-define=FLAVOR=prod
```

---

### Exercise 2: API Configuration per Flavor (Beginner-Intermediate)
**File**: `exercise_2_template.dart` / `exercise_2_solution.dart`

**What you'll learn**:
- Environment-specific API endpoints
- API configuration management
- HTTP client integration with flavors
- Secure API key handling
- Different timeouts and retry logic per environment

**Key concepts**:
- ApiConfig class
- Environment-specific base URLs
- API key management
- Timeout and retry configuration
- Mock HTTP client implementation

**Run with**:
```bash
flutter run --dart-define=FLAVOR=dev --dart-define=API_KEY=dev_key_123
flutter run --dart-define=FLAVOR=staging --dart-define=API_KEY=staging_key_456
flutter run --dart-define=FLAVOR=prod --dart-define=API_KEY=prod_key_789
```

---

### Exercise 3: Feature Flags System (Intermediate)
**File**: `exercise_3_template.dart` / `exercise_3_solution.dart`

**What you'll learn**:
- Implementing feature flags
- Conditional UI based on flavors
- Debug drawer for development
- Feature toggle management
- Runtime feature flag updates

**Key concepts**:
- FeatureFlags class with ChangeNotifier
- Feature-specific UI rendering
- Debug-only features
- Feature flag viewer
- Gradual feature rollout

**Features demonstrated**:
- New UI feature toggle
- Premium features
- Experimental features
- Debug tools and drawer
- Analytics toggle
- Dark mode

**Run with**:
```bash
flutter run --dart-define=FLAVOR=dev
flutter run --dart-define=FLAVOR=staging
flutter run --dart-define=FLAVOR=prod
```

---

### Exercise 4: Complete E-Commerce App with Flavors (Intermediate-Advanced)
**File**: `exercise_4_template.dart` / `exercise_4_solution.dart`

**What you'll learn**:
- Complete multi-flavor app architecture
- Firebase configuration per flavor
- Payment processing with test/live modes
- Custom themes per flavor
- Shopping cart implementation
- Checkout flow with flavor-aware payment

**Key concepts**:
- FirebaseConfig per flavor
- PaymentConfig with test/live modes
- AppThemeConfig customization
- Complete service layer
- CartService with state management
- PaymentService integration
- Test mode indicators

**Features**:
- Product catalog
- Shopping cart
- Checkout with Stripe (mocked)
- Different Firebase projects
- Environment banners
- Flavor-specific themes

**Run with**:
```bash
flutter run --dart-define=FLAVOR=dev --dart-define=STRIPE_KEY=pk_test_dev
flutter run --dart-define=FLAVOR=staging --dart-define=STRIPE_KEY=pk_test_staging
flutter run --dart-define=FLAVOR=prod --dart-define=STRIPE_KEY=pk_live_prod
```

---

### Exercise 5: Production-Ready Multi-Flavor Setup (Advanced)
**File**: `exercise_5_template.dart` / `exercise_5_solution.dart`

**What you'll learn**:
- Production-grade configuration management
- Comprehensive secrets management
- Complete logging infrastructure
- Analytics integration per flavor
- Crash reporting setup
- Remote config integration
- Configuration validation
- Professional error handling
- CI/CD-ready structure

**Key concepts**:
- EnvConfig interface with implementations
- SecretsManager for secure key handling
- LoggingService with levels and filtering
- AnalyticsService integration
- RemoteConfigService for feature flags
- CrashReportingService setup
- AppInitializer for proper startup
- Global error handlers
- Configuration validation
- Production vs development behaviors

**Services implemented**:
- Logging service with multiple levels
- Analytics service
- Remote configuration service
- Crash reporting service
- Comprehensive initialization

**Run with**:
```bash
flutter run --dart-define=FLAVOR=dev \
  --dart-define=API_KEY=dev_key \
  --dart-define=FIREBASE_API_KEY=dev_firebase_key \
  --dart-define=STRIPE_KEY=pk_test_dev

flutter run --dart-define=FLAVOR=staging \
  --dart-define=API_KEY=staging_key \
  --dart-define=FIREBASE_API_KEY=staging_firebase_key \
  --dart-define=STRIPE_KEY=pk_test_staging

flutter run --dart-define=FLAVOR=prod \
  --dart-define=API_KEY=prod_key \
  --dart-define=FIREBASE_API_KEY=prod_firebase_key \
  --dart-define=STRIPE_KEY=pk_live_prod
```

---

## Progressive Learning Path

1. **Start with Exercise 1**: Understand basic flavor concepts
2. **Move to Exercise 2**: Add API configuration
3. **Progress to Exercise 3**: Implement feature flags
4. **Build Exercise 4**: Create a complete app
5. **Master Exercise 5**: Production-ready setup

Each exercise builds on previous concepts, so follow the order for best results.

## Platform-Specific Configuration

### Android Configuration

Edit `android/app/build.gradle`:

```gradle
android {
    flavorDimensions "environment"

    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp Dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp Staging"
        }
        prod {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }
}
```

### iOS Configuration

For iOS, create schemes in Xcode:
1. Open `ios/Runner.xcworkspace`
2. Product > Scheme > Manage Schemes
3. Create schemes for dev, staging, prod
4. Configure build configurations for each

### Firebase Setup

Create separate Firebase projects:
- `myapp-dev`
- `myapp-staging`
- `myapp-prod`

Place configuration files:
```
android/app/src/dev/google-services.json
android/app/src/staging/google-services.json
android/app/src/prod/google-services.json

ios/Runner/Dev/GoogleService-Info.plist
ios/Runner/Staging/GoogleService-Info.plist
ios/Runner/Prod/GoogleService-Info.plist
```

## Best Practices

### 1. Security
- ✅ Never commit API keys to git
- ✅ Use --dart-define for runtime configuration
- ✅ Store production secrets in CI/CD environment
- ✅ Different keys for each environment
- ✅ Enable SSL pinning in production

### 2. Configuration
- ✅ Validate configuration on startup
- ✅ Provide clear error messages
- ✅ Use type-safe configuration classes
- ✅ Implement configuration inheritance
- ✅ Document all configuration options

### 3. Logging
- ✅ Different log levels per flavor
- ✅ Verbose logging in dev, minimal in prod
- ✅ Filter PII from logs
- ✅ Ship logs to remote service in production
- ✅ Structure logs for searchability

### 4. Features
- ✅ Use feature flags for gradual rollout
- ✅ Keep flags temporary
- ✅ Document each flag's purpose
- ✅ Test with flags both on and off
- ✅ Remove flags after feature is stable

### 5. Testing
- ✅ Test each flavor separately
- ✅ Automated tests for all flavors
- ✅ Integration tests with real services (staging)
- ✅ Performance testing per flavor
- ✅ Security testing in production config

### 6. Build & Deploy
- ✅ Separate CI/CD pipelines per flavor
- ✅ Automated builds for all flavors
- ✅ Different signing configs
- ✅ Proper versioning strategy
- ✅ Automated release notes

## Common Pitfalls to Avoid

❌ **Hardcoding environment values**: Always use configuration
❌ **Committing secrets**: Use .gitignore and CI/CD secrets
❌ **Same Firebase project**: Use separate projects
❌ **Production keys in non-prod**: Validate key types
❌ **Debug features in production**: Use flavor checks
❌ **Insufficient error handling**: Implement global handlers
❌ **Missing validation**: Validate on startup
❌ **Complex flavor logic**: Keep it simple and clear

## Real-World Applications

These exercises prepare you for:
- Professional Flutter development
- Multi-environment app management
- CI/CD pipeline integration
- Feature flag systems
- A/B testing
- Gradual feature rollout
- Beta testing programs
- Enterprise app development

## Additional Resources

### Official Documentation
- [Flutter build flavors](https://docs.flutter.dev/deployment/flavors)
- [Dart --dart-define](https://dart.dev/tools/dart-compile#dart-define)
- [Firebase multi-environment setup](https://firebase.google.com/docs/projects/multiprojects)

### Packages
- `flutter_dotenv`: Environment variable management
- `firebase_core`: Firebase initialization
- `firebase_remote_config`: Remote feature flags
- `firebase_analytics`: Analytics per flavor
- `firebase_crashlytics`: Crash reporting

### Advanced Topics
- Remote configuration
- A/B testing frameworks
- Feature flag platforms (LaunchDarkly, Firebase)
- Secrets management (AWS Secrets Manager, HashiCorp Vault)
- CI/CD integration (GitHub Actions, Codemagic)

## Testing Your Implementation

For each exercise, verify:
1. ✅ App runs with all flavors
2. ✅ Configuration is correct per flavor
3. ✅ Features are enabled/disabled correctly
4. ✅ No secrets in version control
5. ✅ Proper error handling
6. ✅ Logging works as expected
7. ✅ Analytics fires correctly
8. ✅ Crash reporting works

## Getting Help

If you encounter issues:
1. Check the solution files for reference
2. Verify your dart-define arguments
3. Ensure platform-specific configs are correct
4. Review error messages carefully
5. Test with dev flavor first
6. Validate configuration on startup

## Next Steps

After completing these exercises:
- Implement flavors in your own projects
- Set up CI/CD for multiple flavors
- Integrate with remote config services
- Add comprehensive monitoring
- Implement advanced feature flagging
- Set up automated testing per flavor

---

## Quick Reference

### Command Templates

```bash
# Dev
flutter run --dart-define=FLAVOR=dev --dart-define=API_KEY=dev_key

# Staging
flutter run --dart-define=FLAVOR=staging --dart-define=API_KEY=staging_key

# Production
flutter run --dart-define=FLAVOR=prod --dart-define=API_KEY=prod_key

# With multiple defines
flutter run \
  --dart-define=FLAVOR=dev \
  --dart-define=API_KEY=dev_key \
  --dart-define=FIREBASE_KEY=firebase_dev_key \
  --dart-define=STRIPE_KEY=pk_test_dev

# Build APK
flutter build apk --flavor dev -t lib/main_dev.dart

# Build iOS
flutter build ios --flavor dev -t lib/main_dev.dart
```

### Environment File Template

Create `.env.dev`, `.env.staging`, `.env.prod`:

```env
FLAVOR=dev
API_KEY=your_api_key_here
API_BASE_URL=https://dev-api.example.com
FIREBASE_API_KEY=your_firebase_key
STRIPE_KEY=pk_test_your_stripe_key
```

Add to `.gitignore`:
```
.env.*
*.env
```

---

## Summary

App flavors are essential for professional Flutter development. These exercises provide a comprehensive foundation for managing multiple environments, from simple flavor setup to production-ready configurations with complete monitoring and error handling.

Master these concepts to build apps that are:
- **Secure**: Proper secrets management
- **Maintainable**: Clear configuration structure
- **Testable**: Separate environments for testing
- **Observable**: Comprehensive logging and monitoring
- **Professional**: Industry-standard practices

Happy coding! 🚀
