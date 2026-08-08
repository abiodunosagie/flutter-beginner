# GitHub Actions CI for Flutter

## Goals

On every PR:

1. `flutter pub get`  
2. `flutter analyze`  
3. `flutter test`  

## Starter workflow

Create `.github/workflows/flutter_ci.yml`:

```yaml
name: Flutter CI
on:
  push:
    branches: [ main ]
  pull_request:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
        working-directory: sample-apps/shop_cart_app
      - run: flutter analyze
        working-directory: sample-apps/shop_cart_app
      - run: flutter test
        working-directory: sample-apps/shop_cart_app
```

## Expand later

- Build APK artifact  
- Codemagic / Fastlane for store upload  
- Cache pub  

## Course sample

See `tooling/github-actions/flutter_ci.yml` in this repo.
