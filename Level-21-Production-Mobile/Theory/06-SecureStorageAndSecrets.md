# Secure Storage & Secrets

| Data | Storage |
|------|---------|
| Access tokens | `flutter_secure_storage` / SDK session |
| Feature flags | remote config |
| API base URL | dart-define / flavors |
| Admin keys | **server only** |

```bash
flutter pub add flutter_secure_storage
```

Never log tokens. Never commit `google-services.json` with unrestricted rules and prod secrets into public forks without care.
