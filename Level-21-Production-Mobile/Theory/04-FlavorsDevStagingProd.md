# Flavors: dev / staging / prod

## Why

Different bundle IDs, API URLs, Firebase projects, icons.

## Minimal approach (good enough to start)

Use `--dart-define=ENV=dev|staging|prod` and a single codebase:

```dart
enum AppEnv { dev, staging, prod }

AppEnv get appEnv {
  switch (const String.fromEnvironment('ENV', defaultValue: 'dev')) {
    case 'prod': return AppEnv.prod;
    case 'staging': return AppEnv.staging;
    default: return AppEnv.dev;
  }
}

String get apiBase {
  switch (appEnv) {
    case AppEnv.prod: return 'https://api.example.com';
    case AppEnv.staging: return 'https://staging.api.example.com';
    case AppEnv.dev: return 'https://dev.api.example.com';
  }
}
```

## Full flavors

Android productFlavors + iOS schemes with different `applicationId` / bundle ID.  
Follow Flutter docs for `flutter run --flavor dev -t lib/main_dev.dart`.

## Rule

Never point a production Firebase project at a random debug build.
