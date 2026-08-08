# App Check

App Check reduces abuse of your Firebase/Supabase endpoints from non-app clients.

## Idea

Device proves it runs your genuine app (Play Integrity / DeviceCheck / debug providers).

## Flutter

```bash
flutter pub add firebase_app_check
```

Activate **debug** provider in development; production providers in release.

## Policy

Start in monitoring mode, then enforce on Firestore/Storage when stable.
