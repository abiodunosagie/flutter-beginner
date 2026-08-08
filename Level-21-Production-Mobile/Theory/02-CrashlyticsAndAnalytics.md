# Crashlytics & Analytics

## Crashlytics

```bash
flutter pub add firebase_crashlytics
```

```dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};
```

Log non-fatals for caught errors you care about.

## Analytics (careful with privacy)

- Log screens and key events (`sign_up`, `purchase`, `ride_requested`)  
- Avoid PII in event params  
- Document in privacy policy  

## Practice

Force a test crash in debug **once**, verify it appears in Firebase console (may take minutes).
