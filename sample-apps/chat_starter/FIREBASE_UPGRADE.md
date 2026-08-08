# Upgrade chat_starter → real Firebase chat

This sample runs offline with `MockChatRepository`. To match App 04 production:

## 1. Packages

```bash
flutter pub add firebase_core firebase_auth cloud_firestore
# later Level 21:
# flutter pub add firebase_messaging flutter_local_notifications
dart run flutterfire_cli:flutterfire configure
```

## 2. Replace repository

Create `lib/data/firestore_chat_repository.dart` using the course file:

`Full-App-Tutorials/App-04-Realtime-Chat-Firebase/lib_starters/chat_service.dart`

Keep the same methods the UI needs:

- `watchMessages(conversationId)`
- `sendText(conversationId, text)`
- `ensureDm(otherUid)`
- `watchConversations()`

## 3. Auth gate

Wrap home:

```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snap) {
    if (snap.data == null) return LoginPage();
    return ConversationListPage();
  },
);
```

## 4. Security rules

Paste rules from App 04 README. Two-user test is mandatory.

## 5. FCM

After Level 21: `Full-App-Tutorials/App-04-Realtime-Chat-Firebase/fcm/README.md`

## 6. Keep mock for tests

```dart
abstract class ChatRepository { ... }
class MockChatRepository implements ChatRepository { ... }
class FirestoreChatRepository implements ChatRepository { ... }
```

Inject mock in widget tests; live in production.
