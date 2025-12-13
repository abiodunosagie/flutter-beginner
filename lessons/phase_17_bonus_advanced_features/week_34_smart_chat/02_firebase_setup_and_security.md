# Lesson 2: Setting Up Firebase Firestore for Chat

## 5-Year-Old Analogy 🎈

Imagine you're setting up a secret clubhouse for you and your friends:

**Firebase Project**: This is like building the clubhouse
**Firestore Database**: This is like the toy box inside where you keep messages
**Security Rules**: These are the rules like "only club members can come in"
**Indexes**: These are like labels on drawers so you can find toys quickly

You wouldn't let strangers into your clubhouse, right? That's what security rules do - they make sure only the right people can see the right messages!

## What We'll Build

By the end of this lesson, you'll have:
- ✅ A Firebase project configured
- ✅ Firestore database with proper structure
- ✅ Security rules that protect user data
- ✅ Indexes for fast queries
- ✅ Flutter app connected to Firebase

## Step 1: Create Firebase Project

### 1.1 Go to Firebase Console

Visit: https://console.firebase.google.com

Click "Add project" or "Create a project"

### 1.2 Project Configuration

```
Project name: smart-chat-app
(or any name you prefer)

Google Analytics: Enable (recommended)
Analytics account: Default or create new
```

Click "Create project" and wait for it to be ready.

### 1.3 Add Flutter Apps

After project is created:

1. Click the Flutter icon (or Add app → Flutter)
2. Follow the FlutterFire CLI setup (easiest method)

**OR** manually add Android and iOS apps:

**For Android:**
```
Package name: com.yourcompany.smartchat
App nickname: Smart Chat (Android)
```

**For iOS:**
```
Bundle ID: com.yourcompany.smartchat
App nickname: Smart Chat (iOS)
```

## Step 2: Install Firebase in Flutter

### 2.1 Install FlutterFire CLI

```bash
# Install FlutterFire CLI globally
dart pub global activate flutterfire_cli

# Make sure it's in your PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 2.2 Configure Flutter Project

```bash
# Run this in your Flutter project directory
flutterfire configure

# Select your Firebase project
# Select platforms (Android, iOS, Web, etc.)
# This creates lib/firebase_options.dart automatically
```

### 2.3 Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase Core (required)
  firebase_core: ^2.24.0

  # Firebase Auth for authentication
  firebase_auth: ^4.15.0

  # Firestore for database
  cloud_firestore: ^4.13.0

  # Firebase Storage for media files
  firebase_storage: ^11.5.0

  # Firebase Cloud Messaging for push notifications
  firebase_messaging: ^14.7.0

  # State management
  provider: ^6.1.1

  # Image picker for media messages
  image_picker: ^1.0.5

  # Cached network images
  cached_network_image: ^3.3.0

  # Time formatting
  intl: ^0.18.1

  # UUID for generating IDs
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Run:
```bash
flutter pub get
```

### 2.4 Initialize Firebase in Main

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable offline persistence for Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Smart Chat',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

## Step 3: Create Firestore Database

### 3.1 Enable Firestore

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. **Start in production mode** (we'll add rules next)
4. Choose location (closest to your users):
   - `us-central` for North America
   - `europe-west` for Europe
   - `asia-southeast1` for Asia

**Important**: Location cannot be changed later!

### 3.2 Create Collections Structure

Create these collections manually (or they'll be created when first used):

```
Collections to create:
- users
- chats
- groups
- blockedUsers
```

Click "Start collection" and create each one with a dummy document first (can be deleted later).

## Step 4: Firestore Security Rules

### 4.1 Understanding Security Rules

Security rules control:
- **Who** can read/write data
- **What** data they can access
- **When** they can access it
- **How** data should be validated

### 4.2 Complete Production-Ready Rules

Go to Firebase Console → Firestore Database → Rules

Replace with this comprehensive ruleset:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    function isValidString(text, minLen, maxLen) {
      return text is string &&
             text.size() >= minLen &&
             text.size() <= maxLen;
    }

    function isValidTimestamp(timestamp) {
      return timestamp is timestamp &&
             timestamp == request.time;
    }

    // Users Collection
    match /users/{userId} {
      // Anyone authenticated can read user profiles
      allow read: if isSignedIn();

      // Users can only create/update their own profile
      allow create: if isOwner(userId) &&
                      isValidString(request.resource.data.email, 3, 100) &&
                      isValidString(request.resource.data.displayName, 1, 50);

      allow update: if isOwner(userId) &&
                      // Ensure users can't change their email
                      request.resource.data.email == resource.data.email;

      // Users can delete their own profile
      allow delete: if isOwner(userId);
    }

    // Chats Collection
    match /chats/{chatId} {
      // Helper function to check if user is participant
      function isParticipant() {
        return isSignedIn() &&
               request.auth.uid in resource.data.participants;
      }

      function isCreator() {
        return isSignedIn() &&
               request.auth.uid in request.resource.data.participants;
      }

      // Participants can read chat metadata
      allow read: if isParticipant();

      // Users can create chats they're participating in
      allow create: if isCreator() &&
                      request.resource.data.participants.size() == 2 &&
                      request.auth.uid in request.resource.data.participants;

      // Participants can update chat (for lastMessage, etc.)
      allow update: if isParticipant() &&
                      // Participants list cannot be modified
                      request.resource.data.participants == resource.data.participants;

      // No one can delete chats (soft delete instead)
      allow delete: if false;

      // Messages subcollection
      match /messages/{messageId} {
        // Helper function for message access
        function canAccessMessage() {
          return isSignedIn() &&
                 request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
        }

        // Participants can read all messages
        allow read: if canAccessMessage();

        // Users can create messages in chats they're in
        allow create: if canAccessMessage() &&
                        request.resource.data.senderId == request.auth.uid &&
                        isValidString(request.resource.data.text, 1, 5000) &&
                        request.resource.data.timestamp == request.time;

        // Users can update their own messages (for read receipts, reactions)
        allow update: if canAccessMessage();

        // Users can delete their own messages
        allow delete: if canAccessMessage() &&
                        resource.data.senderId == request.auth.uid;
      }
    }

    // Groups Collection
    match /groups/{groupId} {
      function isMember() {
        return isSignedIn() &&
               request.auth.uid in resource.data.memberIds;
      }

      function isAdmin() {
        return isSignedIn() &&
               request.auth.uid in resource.data.adminIds;
      }

      // Members can read group data
      allow read: if isMember();

      // Anyone can create a group
      allow create: if isSignedIn() &&
                      request.auth.uid in request.resource.data.adminIds &&
                      request.auth.uid in request.resource.data.memberIds &&
                      isValidString(request.resource.data.name, 1, 100);

      // Admins can update group
      allow update: if isAdmin();

      // Admins can delete group
      allow delete: if isAdmin();

      // Group messages
      match /messages/{messageId} {
        function canAccessGroupMessage() {
          return isSignedIn() &&
                 request.auth.uid in get(/databases/$(database)/documents/groups/$(groupId)).data.memberIds;
        }

        allow read: if canAccessGroupMessage();
        allow create: if canAccessGroupMessage() &&
                        request.resource.data.senderId == request.auth.uid;
        allow update: if canAccessGroupMessage();
        allow delete: if canAccessGroupMessage() &&
                        resource.data.senderId == request.auth.uid;
      }
    }

    // Blocked Users Collection
    match /blockedUsers/{userId}/blocked/{blockedId} {
      // Users can only manage their own block list
      allow read: if isOwner(userId);
      allow write: if isOwner(userId);
    }
  }
}
```

Click "Publish" to deploy these rules.

### 4.3 Test Security Rules

Firebase provides a rules simulator. Test these scenarios:

**Test 1: User reads their own profile**
```
Type: read
Location: /users/user123
Auth: Authenticated as user123
Expected: Allow ✅
```

**Test 2: User reads another user's profile**
```
Type: read
Location: /users/user456
Auth: Authenticated as user123
Expected: Allow ✅ (profiles are public)
```

**Test 3: User updates another user's profile**
```
Type: update
Location: /users/user456
Auth: Authenticated as user123
Expected: Deny ❌
```

**Test 4: Participant reads chat messages**
```
Type: read
Location: /chats/chat123/messages/msg1
Auth: Authenticated as user123 (participant in chat123)
Expected: Allow ✅
```

## Step 5: Create Firestore Indexes

### 5.1 Why Indexes Matter

Without proper indexes, complex queries will fail:

```dart
// This query needs an index!
FirebaseFirestore.instance
  .collection('chats')
  .where('participants', arrayContains: userId)
  .orderBy('lastMessageTime', descending: true)
```

### 5.2 Create Required Indexes

Go to Firebase Console → Firestore → Indexes

Create these composite indexes:

**Index 1: Chat List Query**
```
Collection: chats
Fields:
  - participants (Array)
  - lastMessageTime (Descending)
```

**Index 2: Message Search**
```
Collection: chats/{chatId}/messages
Fields:
  - senderId (Ascending)
  - timestamp (Descending)
```

**Index 3: Unread Messages**
```
Collection: chats/{chatId}/messages
Fields:
  - read (Ascending)
  - timestamp (Descending)
```

**Index 4: Group Messages**
```
Collection: groups/{groupId}/messages
Fields:
  - timestamp (Descending)
  - senderId (Ascending)
```

### 5.3 Automatic Index Creation

**Better approach**: Let Firebase create indexes automatically!

When you run a query that needs an index, you'll get an error with a link:

```
The query requires an index. You can create it here:
https://console.firebase.google.com/...
```

Click the link and Firebase creates the index for you!

## Step 6: Create Data Models

Create `lib/models/chat_user.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String status; // 'online', 'offline', 'away'
  final DateTime? lastSeen;
  final String? fcmToken;

  ChatUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.status = 'offline',
    this.lastSeen,
    this.fcmToken,
  });

  // Create from Firestore document
  factory ChatUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return ChatUser(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'Unknown User',
      photoUrl: data['photoUrl'],
      status: data['status'] ?? 'offline',
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      fcmToken: data['fcmToken'],
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'status': status,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'fcmToken': fcmToken,
    };
  }

  // Create from map (for local state)
  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'Unknown User',
      photoUrl: map['photoUrl'],
      status: map['status'] ?? 'offline',
      lastSeen: map['lastSeen'] != null
          ? (map['lastSeen'] is DateTime
              ? map['lastSeen']
              : (map['lastSeen'] as Timestamp).toDate())
          : null,
      fcmToken: map['fcmToken'],
    );
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'status': status,
      'lastSeen': lastSeen,
      'fcmToken': fcmToken,
    };
  }

  // Copy with modifications
  ChatUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? status,
    DateTime? lastSeen,
    String? fcmToken,
  }) {
    return ChatUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  String toString() {
    return 'ChatUser(id: $id, email: $email, displayName: $displayName, status: $status)';
  }
}
```

Create `lib/models/message.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  video,
  file,
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final MessageType type;
  final String? mediaUrl;
  final DateTime timestamp;
  final bool read;
  final DateTime? readAt;
  final Map<String, String>? reactions; // userId -> emoji
  final String? replyToId;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    this.type = MessageType.text,
    this.mediaUrl,
    required this.timestamp,
    this.read = false,
    this.readAt,
    this.reactions,
    this.replyToId,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      mediaUrl: data['mediaUrl'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] ?? false,
      readAt: (data['readAt'] as Timestamp?)?.toDate(),
      reactions: data['reactions'] != null
          ? Map<String, String>.from(data['reactions'])
          : null,
      replyToId: data['replyToId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'read': read,
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
      'reactions': reactions,
      'replyToId': replyToId,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? text,
    MessageType? type,
    String? mediaUrl,
    DateTime? timestamp,
    bool? read,
    DateTime? readAt,
    Map<String, String>? reactions,
    String? replyToId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      readAt: readAt ?? this.readAt,
      reactions: reactions ?? this.reactions,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}
```

Create `lib/models/chat.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> participants;
  final Map<String, dynamic>? participantDetails;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final Map<String, int>? unreadCount;
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.participants,
    this.participantDetails,
    this.lastMessage = '',
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCount,
    required this.createdAt,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return Chat(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantDetails: data['participantDetails'] != null
          ? Map<String, dynamic>.from(data['participantDetails'])
          : null,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      lastMessageSenderId: data['lastMessageSenderId'],
      unreadCount: data['unreadCount'] != null
          ? Map<String, int>.from(data['unreadCount'])
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'participantDetails': participantDetails,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : null,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Get the other user's ID in a 1-on-1 chat
  String getOtherUserId(String currentUserId) {
    return participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  // Get unread count for a specific user
  int getUnreadCountForUser(String userId) {
    return unreadCount?[userId] ?? 0;
  }
}
```

## Step 7: Create Firebase Service

Create `lib/services/firebase_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../models/chat.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Initialize user profile
  Future<void> initializeUserProfile({
    required String email,
    required String displayName,
    String? photoUrl,
  }) async {
    if (!isSignedIn) throw Exception('User not signed in');

    try {
      await _firestore.collection('users').doc(currentUserId).set({
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'status': 'online',
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ User profile initialized');
    } catch (e) {
      print('❌ Error initializing user profile: $e');
      rethrow;
    }
  }

  // Update user status
  Future<void> updateUserStatus(String status) async {
    if (!isSignedIn) return;

    try {
      await _firestore.collection('users').doc(currentUserId).update({
        'status': status,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  // Get user profile
  Future<ChatUser?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return ChatUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Search users
  Future<List<ChatUser>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => ChatUser.fromFirestore(doc))
          .where((user) => user.id != currentUserId)
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Test Firestore connection
  Future<bool> testConnection() async {
    try {
      await _firestore.collection('test').doc('connection').set({
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'connected',
      });

      print('✅ Firestore connection successful');
      return true;
    } catch (e) {
      print('❌ Firestore connection failed: $e');
      return false;
    }
  }
}
```

## Step 8: Test Your Setup

Create `lib/screens/test_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<String> _logs = [];
  bool _isTesting = false;

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)} - $message');
    });
  }

  Future<void> _runTests() async {
    setState(() {
      _isTesting = true;
      _logs.clear();
    });

    try {
      // Test 1: Check Firebase initialization
      _addLog('Test 1: Checking Firebase initialization...');
      await Future.delayed(Duration(milliseconds: 500));
      _addLog('✅ Firebase initialized');

      // Test 2: Test Firestore connection
      _addLog('Test 2: Testing Firestore connection...');
      final connected = await _firebaseService.testConnection();
      _addLog(connected ? '✅ Firestore connected' : '❌ Firestore connection failed');

      // Test 3: Test Authentication
      _addLog('Test 3: Checking authentication...');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _addLog('✅ User authenticated: ${user.email}');
      } else {
        _addLog('⚠️ No user authenticated (this is okay for testing)');
      }

      // Test 4: Test Anonymous Auth (if no user)
      if (user == null) {
        _addLog('Test 4: Testing anonymous authentication...');
        try {
          final credential = await FirebaseAuth.instance.signInAnonymously();
          _addLog('✅ Anonymous auth successful: ${credential.user?.uid}');

          // Initialize user profile
          _addLog('Test 5: Initializing user profile...');
          await _firebaseService.initializeUserProfile(
            email: 'test@example.com',
            displayName: 'Test User',
          );
          _addLog('✅ User profile initialized');
        } catch (e) {
          _addLog('❌ Authentication failed: $e');
        }
      }

      _addLog('');
      _addLog('🎉 All tests completed!');
    } catch (e) {
      _addLog('❌ Error during testing: $e');
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Setup Test'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isTesting ? null : _runTests,
              child: _isTesting
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Testing...'),
                      ],
                    )
                  : Text('Run Tests'),
            ),
          ),
          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Text(
                      'Press "Run Tests" to start',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      Color color = Colors.black87;
                      if (log.contains('✅')) color = Colors.green;
                      if (log.contains('❌')) color = Colors.red;
                      if (log.contains('⚠️')) color = Colors.orange;
                      if (log.contains('🎉')) color = Colors.blue;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          log,
                          style: TextStyle(
                            color: color,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
```

Update your `main.dart` to use the test screen:

```dart
home: const TestScreen(), // Instead of SplashScreen
```

## Verification Steps

### Step 1: Run the App

```bash
flutter run
```

Expected: App launches without errors

### Step 2: Run Tests

Press "Run Tests" button

Expected output:
```
✅ Firebase initialized
✅ Firestore connected
✅ Anonymous auth successful
✅ User profile initialized
🎉 All tests completed!
```

### Step 3: Check Firestore Console

Go to Firebase Console → Firestore Database

You should see:
- `test` collection with `connection` document
- `users` collection with your test user

### Step 4: Test Security Rules

Try this in Firebase Console → Firestore → Rules Playground:

```
Authenticated read of /users/someUserId
Expected: Allow ✅

Unauthenticated read of /users/someUserId
Expected: Deny ❌
```

## Common Setup Issues and Solutions

### Issue 1: "Default FirebaseApp is not initialized"

**Solution:**
```dart
// Make sure you have this in main()
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Issue 2: "Platform-specific configuration missing"

**Solution:**
- Run `flutterfire configure` again
- Make sure `firebase_options.dart` exists
- Check that Firebase is configured for all platforms you're building

### Issue 3: "Permission denied" errors

**Solution:**
- Check Firestore rules are published
- Ensure user is authenticated before accessing data
- Verify the user is accessing allowed documents

### Issue 4: Index errors

**Solution:**
- Click the index creation link in the error
- Or manually create indexes in Firebase Console

### Issue 5: Slow queries

**Solution:**
- Create proper indexes
- Limit query results
- Use pagination

## Production Checklist

Before deploying to production:

- [ ] Security rules are properly configured
- [ ] All required indexes are created
- [ ] Offline persistence is enabled
- [ ] Error handling is implemented
- [ ] User authentication is working
- [ ] Data validation is in place
- [ ] Sensitive data is not stored in Firestore
- [ ] Backup strategy is planned
- [ ] Monitoring is set up

## Next Steps

In the next lesson, we'll:
1. Build the chat UI with message bubbles
2. Implement scroll behavior
3. Create the message input field
4. Add typing indicators
5. Style everything beautifully

## Key Takeaways

1. **Firebase setup requires multiple steps** - project creation, app registration, and SDK configuration
2. **Security rules are critical** - they protect your data from unauthorized access
3. **Indexes improve performance** - create them for all complex queries
4. **Offline persistence** makes your app work without internet
5. **Proper data models** make working with Firestore easier and safer
6. **Test everything** before building features

Remember: A solid foundation makes building features much easier! 🚀
