# Level 11: Real-World Apps Using These Concepts

See how Firebase powers millions of production applications!

---

## Firebase Authentication

### User Identity Management!

**Any App with Login**
```dart
// Social login options
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email/Password (most common)
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Google Sign-In (Instagram, YouTube, etc.)
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return (await _auth.signInWithCredential(credential)).user;
  }

  // Apple Sign-In (required for iOS App Store)
  Future<User?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    return (await _auth.signInWithCredential(oauthCredential)).user;
  }
}
```

---

## Firestore Database

### Real-Time Data Storage!

**Social Media App (Instagram-style)**
```dart
class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a post
  Future<void> createPost(Post post) async {
    await _firestore.collection('posts').add({
      'userId': post.userId,
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likes': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get feed (real-time)
  Stream<List<Post>> getFeed() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  // Like a post
  Future<void> likePost(String postId, String userId) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }
}
```

**Chat App (WhatsApp-style)**
```dart
class ChatService {
  Stream<List<Message>> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toMap());

    // Update conversation's last message
    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
}
```

---

## Firebase Storage

### File Uploads!

**Photo Sharing App**
```dart
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String userId) async {
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('users/$userId/posts/$filename');

    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<String> uploadProfilePhoto(File image, String userId) async {
    final ref = _storage.ref().child('users/$userId/profile.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
```

---

## Cloud Functions

### Backend Logic Without Servers!

**Triggered on Events**
```javascript
// When a new user signs up
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  // Create user profile document
  await admin.firestore().collection('users').doc(user.uid).set({
    email: user.email,
    displayName: user.displayName,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Send welcome email
  await sendWelcomeEmail(user.email);
});

// When a post is liked
exports.onPostLiked = functions.firestore
  .document('posts/{postId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (after.likes > before.likes) {
      // Send notification to post owner
      await sendPushNotification(after.userId, 'Someone liked your post!');
    }
  });
```

---

## Push Notifications (FCM)

### Engaging Users!

**Notification Service**
```dart
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    final token = await _messaging.getToken();
    await saveTokenToFirestore(token!);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigateToScreen(message.data);
    });
  }
}
```

---

## Real Apps Using Firebase

| App | Firebase Features Used |
|-----|----------------------|
| **Instagram** | Auth, Firestore, Storage, FCM |
| **Uber** | Auth, Realtime DB, Functions |
| **Duolingo** | Auth, Firestore, Analytics |
| **Spotify** | Auth, Remote Config |
| **Alibaba** | Auth, Crashlytics, Analytics |
| **The New York Times** | Auth, Cloud Messaging |

---

## Firebase Security Rules

### Protecting Your Data!

**Firestore Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Anyone can read posts, only owner can edit
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }

    // Only conversation participants can read messages
    match /conversations/{conversationId}/messages/{messageId} {
      allow read, write: if request.auth.uid in
        get(/databases/$(database)/documents/conversations/$(conversationId)).data.participants;
    }
  }
}
```

---

## Offline Support

### Works Without Internet!

**Firestore Offline**
```dart
// Enable offline persistence (automatic on mobile)
await FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);

// Data syncs automatically when back online
// No extra code needed!
```

---

## Analytics & Crashlytics

### Understanding Your Users!

**Event Tracking**
```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> logEvent(String name, Map<String, dynamic> params) async {
    await _analytics.logEvent(name: name, parameters: params);
  }

  void recordError(dynamic error, StackTrace stack) {
    _crashlytics.recordError(error, stack);
  }

  void setUserId(String userId) {
    _analytics.setUserId(id: userId);
    _crashlytics.setUserIdentifier(userId);
  }
}
```

---

## Build It Yourself!

After this level, you could build:

1. **Social Media App** - Posts, likes, comments, follows
2. **Chat App** - Real-time messaging with Firebase
3. **E-commerce** - Products, cart, orders with Firestore
4. **Photo Sharing** - Image uploads with Storage
5. **Team Collaboration** - Real-time document editing

---

**Firebase gives you superpowers - backend functionality without managing servers!**
