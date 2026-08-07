# App 04: Realtime Chat (Firebase) — Full Tutorial

> Build a WhatsApp-style messaging app employers recognize: **auth, conversations, live messages, presence-ready architecture**.

**Time:** 12–20 hours  
**Minimum level:** 11 (Firebase) + 06 (state) + 07 (navigation)  
**Stack:** Flutter + Firebase Auth + Cloud Firestore + (optional) Storage  

---

## 1. Product brief

| Role | Can do |
|------|--------|
| User | Sign up/in, see chat list, open thread, send/receive live text |
| User | Start DM by email/uid search (MVP: paste other uid) |
| Stretch | Images, typing indicator, FCM push, group chats |

**Non-goals MVP:** E2E encryption, voice/video, disappearing messages.

---

## 2. Why this app gets interviews

- Streams / realtime listeners  
- Security rules mindset  
- List + detail navigation  
- Optimistic UI + errors  
- Clean data models  

---

## 3. Architecture

```
lib/
  main.dart
  app.dart
  core/
    firebase_options.dart   # flutterfire configure
    theme.dart
  models/
    app_user.dart
    conversation.dart
    message.dart
  services/
    auth_service.dart
    chat_service.dart
    user_service.dart
  providers/   # or riverpod/
    auth_provider.dart
    chat_provider.dart
  features/
    auth/
      login_page.dart
      register_page.dart
    conversations/
      conversation_list_page.dart
      new_chat_page.dart
    chat/
      chat_page.dart
      message_bubble.dart
      message_input.dart
  widgets/
    loading.dart
    error_view.dart
```

**Data flow:**

```
UI → Provider/Riverpod → ChatService → Firestore
              ↑ live StreamBuilder / StreamProvider
```

---

## 4. Firebase setup (do fully)

1. Create Firebase project  
2. `dart pub global activate flutterfire_cli`  
3. `flutterfire configure`  
4. Enable **Email/Password** Auth  
5. Create Firestore (production mode)  
6. Paste rules from section 7  
7. Dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  provider: ^6.1.0   # or flutter_riverpod
  intl: ^0.19.0
```

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatApp());
}
```

---

## 5. Data model (Firestore)

### `users/{uid}`

```json
{
  "uid": "abc",
  "email": "a@x.com",
  "displayName": "Ada",
  "photoUrl": null,
  "createdAt": "<timestamp>"
}
```

### `conversations/{conversationId}`

```json
{
  "id": "conv_...",
  "memberIds": ["uidA", "uidB"],
  "lastMessage": "See you soon",
  "lastMessageAt": "<timestamp>",
  "createdAt": "<timestamp>"
}
```

**Conversation id strategy (DM):** sort two uids and join:

```dart
String dmId(String a, String b) {
  final ids = [a, b]..sort();
  return '${ids[0]}_${ids[1]}';
}
```

### `conversations/{id}/messages/{messageId}`

```json
{
  "id": "...",
  "senderId": "uidA",
  "text": "Hello",
  "createdAt": "<timestamp>",
  "type": "text"
}
```

---

## 6. Models (Dart)

```dart
// models/message.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return ChatMessage(
      id: doc.id,
      senderId: d['senderId'] as String,
      text: d['text'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'text',
      };
}
```

```dart
// models/conversation.dart
class Conversation {
  final String id;
  final List<String> memberIds;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  Conversation({
    required this.id,
    required this.memberIds,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory Conversation.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Conversation(
      id: doc.id,
      memberIds: List<String>.from(d['memberIds'] ?? []),
      lastMessage: d['lastMessage'] as String?,
      lastMessageAt: (d['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  String otherUserId(String me) =>
      memberIds.firstWhere((id) => id != me, orElse: () => me);
}
```

---

## 7. Security rules (non-negotiable)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function signedIn() { return request.auth != null; }
    function isMember(convId) {
      return signedIn() &&
        request.auth.uid in get(/databases/$(database)/documents/conversations/$(convId)).data.memberIds;
    }

    match /users/{userId} {
      allow read: if signedIn();
      allow create, update: if signedIn() && request.auth.uid == userId;
    }

    match /conversations/{convId} {
      allow read: if signedIn() && request.auth.uid in resource.data.memberIds;
      allow create: if signedIn()
        && request.auth.uid in request.resource.data.memberIds
        && request.resource.data.memberIds.size() == 2;
      allow update: if isMember(convId);

      match /messages/{msgId} {
        allow read: if isMember(convId);
        allow create: if isMember(convId)
          && request.resource.data.senderId == request.auth.uid
          && request.resource.data.text is string
          && request.resource.data.text.size() > 0
          && request.resource.data.text.size() < 4000;
      }
    }
  }
}
```

Test with two Firebase Auth users before adding polish.

---

## 8. Services

### AuthService

```dart
class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<User?> authState() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> register(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user!.updateDisplayName(name);
    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'email': email,
      'displayName': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() => _auth.signOut();
}
```

### ChatService

```dart
class ChatService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  String dmIdFor(String otherUid) {
    final ids = [uid, otherUid]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Stream<List<Conversation>> watchConversations() {
    return _db
        .collection('conversations')
        .where('memberIds', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Conversation.fromDoc(d)).toList());
  }

  Stream<List<ChatMessage>> watchMessages(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .limitToLast(100)
        .snapshots()
        .map((s) => s.docs.map((d) => ChatMessage.fromDoc(d)).toList());
  }

  Future<String> ensureDm(String otherUid) async {
    final id = dmIdFor(otherUid);
    final ref = _db.collection('conversations').doc(id);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'memberIds': [uid, otherUid],
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return id;
  }

  Future<void> sendText(String conversationId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final batch = _db.batch();
    final msgRef = _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();
    batch.set(msgRef, {
      'senderId': uid,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'text',
    });
    final convRef = _db.collection('conversations').doc(conversationId);
    batch.update(convRef, {
      'lastMessage': trimmed,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }
}
```

**Index:** Firestore may ask you to create a composite index for `memberIds` + `lastMessageAt`. Click the link in the error.

---

## 9. UI screens (behavior)

### Auth gate

```dart
StreamBuilder<User?>(
  stream: AuthService().authState(),
  builder: (context, snap) {
    if (snap.connectionState == ConnectionState.waiting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (snap.data == null) return const LoginPage();
    return const ConversationListPage();
  },
);
```

### Conversation list

- `StreamBuilder` on `watchConversations()`
- Empty: “Start a chat”
- Tile: last message + time
- FAB → New chat (TextField other uid → `ensureDm` → push ChatPage)

### Chat page

- `ListView` of bubbles (`Align` left/right by `senderId == me`)
- Auto-scroll on new messages (`ScrollController`)
- Input bar: TextField + send
- Disable send while empty
- Show errors via SnackBar

### Message bubble

```dart
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  const MessageBubble({super.key, required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue.shade600 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isMine ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
```

---

## 10. Implementation order (checklist)

1. [ ] Firebase configure + rules  
2. [ ] Auth register/login/logout + users doc  
3. [ ] Conversation list stream (may be empty)  
4. [ ] ensureDm + navigate  
5. [ ] Message stream + bubbles  
6. [ ] sendText + batch lastMessage  
7. [ ] Two-device / two-account live test  
8. [ ] Empty/error/loading states  
9. [ ] Stretch: image messages (Storage)  
10. [ ] Stretch: FCM when backgrounded  

---

## 11. Two-user test script (mandatory)

1. Create users A and B  
2. A starts DM with B’s uid  
3. A sends “hello” — B sees without pull  
4. B replies — A sees live  
5. C (not member) cannot read conversation (rules)  

---

## 12. Stretch roadmap

| Feature | How |
|---------|-----|
| Display names in list | Join `users` docs by other uid |
| Image messages | Storage `chats/{convId}/{msgId}.jpg` + type image |
| Typing | Realtime DB or ephemeral Firestore doc |
| Push | FCM + Cloud Function on message create |
| Groups | `memberIds` length > 2 + admin field |

---

## 13. Portfolio blurb (copy)

> Realtime Flutter chat with Firebase Auth, Firestore security rules, batch writes for conversation previews, and live streams. Demonstrates multi-user data modeling and production-minded client architecture.

---

## Big idea

Chat is **membership + ordered messages + streams + rules**. UI is the easy part once data and security are right.
