# Runnable sample apps

Real Flutter projects — open, `flutter pub get`, `flutter run`.

| Folder | Run | Course link |
|--------|-----|-------------|
| `shop_cart_app` | Provider cart + badge | Level 06 |
| `chat_starter` | Mock chat (+ [FIREBASE_UPGRADE.md](chat_starter/FIREBASE_UPGRADE.md)) | App 04 |
| `ride_hail_starter` | Rider/driver trip machine | App 05 |
| `live_prices_app` | Mock live ticker | App 17 |
| `paywall_saas_app` | Free tier + mock Pro paywall | App 18 / L22 |

```bash
cd sample-apps/<app>
flutter pub get
flutter run
flutter test
```

## CI

GitHub Actions (`.github/workflows/flutter_ci.yml`) analyzes and tests the matrix of sample apps.
