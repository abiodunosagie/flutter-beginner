# Firebase Cloud Messaging (FCM) — Push End-to-End

## Flow

```
1. User grants notification permission
2. App gets FCM device token
3. App saves token to backend under user_id
4. Server/Cloud Function sends message
5. Device shows notification (or data message handled in app)
```

## Flutter packages

```bash
flutter pub add firebase_messaging flutter_local_notifications
```

## Core client steps

1. `FirebaseMessaging.instance.requestPermission()`  
2. `getToken()` → POST to your API / Firestore `users/{uid}/tokens`  
3. `onMessage` for foreground  
4. `onMessageOpenedApp` for taps  
5. Background handler (top-level function, registered early)  

## Server side (concept)

- Use **Admin SDK** or Cloud Functions — never put server keys in the app  
- Remove stale tokens when FCM returns NotRegistered  

## Wire into Chat

When a message is created for a conversation, a Cloud Function loads other members’ tokens and sends data+notification payload.

See `Full-App-Tutorials/App-04-Realtime-Chat-Firebase/fcm/README.md`.
