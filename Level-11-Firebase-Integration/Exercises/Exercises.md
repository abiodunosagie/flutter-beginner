# Level 11 Exercises: Firebase Integration

## Exercise 1: User Registration System

**Objective:** Build a complete user registration and profile system.

```
FEATURES:
□ Sign up with email/password
□ Log in with email/password
□ Display user profile
□ Update display name
□ Log out functionality
□ Password reset via email
```

### Requirements

1. Create `AuthService` class with all auth methods
2. Use `StreamBuilder` with `authStateChanges()` for navigation
3. Show friendly error messages for auth errors
4. Store additional user data in Firestore after signup

### Hints

```dart
// After creating user, store extra info in Firestore
await FirebaseAuth.instance.createUserWithEmailAndPassword(...);
await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  'name': name,
  'email': email,
  'createdAt': FieldValue.serverTimestamp(),
});
```

---

## Exercise 2: Notes App with Firestore

**Objective:** Build a note-taking app with real-time sync.

```
FEATURES:
□ Create notes with title and content
□ View all notes in a list
□ Edit existing notes
□ Delete notes
□ Notes sync in real-time
□ User can only see their own notes
```

### Data Structure

```
notes (Collection)
├── {noteId} (Document)
│   ├── userId: "user123"
│   ├── title: "My Note"
│   ├── content: "Note content..."
│   ├── createdAt: Timestamp
│   └── updatedAt: Timestamp
```

### Starter Code

```dart
class NotesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  // TODO: Implement these methods
  Stream<List<Note>> getNotesStream() { }
  Future<void> addNote(String title, String content) { }
  Future<void> updateNote(String id, String title, String content) { }
  Future<void> deleteNote(String id) { }
}
```

---

## Exercise 3: Shopping List with Real-time Sharing

**Objective:** Create a shopping list that multiple users can edit together.

```
FEATURES:
□ Create shopping list items
□ Check off items when purchased
□ Delete items
□ Real-time updates (all users see changes)
□ Show who added each item
□ Show when item was checked off
```

### Challenge

Multiple users should be able to:
1. Share the same shopping list
2. See each other's changes instantly
3. Know who added/checked each item

### Hints

```dart
// Single shared list with real-time updates
FirebaseFirestore.instance
    .collection('shopping_lists')
    .doc('family_list')  // Shared list ID
    .collection('items')
    .snapshots();
```

---

## Exercise 4: Profile Picture Upload

**Objective:** Add profile picture functionality with Firebase Storage.

```
FEATURES:
□ Pick image from gallery or camera
□ Show upload progress
□ Save image to Firebase Storage
□ Update user profile with photo URL
□ Display profile picture
□ Handle errors gracefully
```

### Requirements

1. Compress images before upload (max 512x512)
2. Store in `profile_pictures/{userId}.jpg`
3. Update Firebase Auth profile with `updatePhotoURL()`
4. Show loading indicator during upload

### Starter Code

```dart
class ProfileService {
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> uploadProfilePicture(File image) async {
    final userId = _auth.currentUser!.uid;
    final ref = _storage.ref('profile_pictures/$userId.jpg');

    // TODO: Upload file with progress tracking
    // TODO: Get download URL
    // TODO: Update user profile
    // TODO: Return URL
  }
}
```

---

## Exercise 5: Chat Room

**Objective:** Build a simple chat room with Firebase.

```
FEATURES:
□ Send messages
□ View messages in real-time
□ Show sender name and timestamp
□ Auto-scroll to new messages
□ Show "typing" indicator (bonus)
```

### Data Structure

```
messages (Collection)
├── {messageId} (Document)
│   ├── text: "Hello!"
│   ├── senderId: "user123"
│   ├── senderName: "John"
│   ├── timestamp: Timestamp
```

### Requirements

1. Messages appear instantly for all users
2. Show newest messages at bottom
3. Limit to last 100 messages
4. Display time nicely (e.g., "2:30 PM")

---

## Exercise 6: Favorites with Cloud Sync

**Objective:** Add favorites feature that syncs across devices.

```
FEATURES:
□ Mark items as favorites
□ View all favorites
□ Remove from favorites
□ Favorites sync across devices
□ Show favorite count
```

### Scenario

Users can favorite recipes/products/articles. Their favorites should:
- Persist when app restarts
- Sync across all their devices
- Load quickly on app start

### Hints

```dart
// Store favorites in user's subcollection
FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('favorites')
    .doc(itemId)
    .set({'addedAt': FieldValue.serverTimestamp()});
```

---

## Exercise 7: Image Gallery with Storage

**Objective:** Build an image gallery with upload/delete functionality.

```
FEATURES:
□ Upload multiple images
□ Display in grid view
□ View full-screen image
□ Delete images
□ Show upload progress for each
□ Display total storage used
```

### Requirements

1. Store images in `galleries/{userId}/`
2. Generate unique filenames
3. Handle upload cancellation
4. Show thumbnails in grid
5. Lazy load images for performance

---

## Exercise 8: Complete Firebase App

**Objective:** Build a full app combining Auth + Firestore + Storage.

### App: Simple Social Feed

```
FEATURES:
□ User authentication (sign up/login)
□ Create posts with text and optional image
□ View feed of all posts
□ Like posts
□ Delete own posts
□ User profile with picture
```

### Data Structure

```
users/{userId}
├── name
├── email
├── photoURL
└── createdAt

posts/{postId}
├── userId
├── userName
├── userPhoto
├── text
├── imageUrl (optional)
├── likes: []
├── createdAt

Storage:
├── profile_pictures/{userId}.jpg
└── post_images/{postId}.jpg
```

### Grading Criteria

```
BASIC (60%):
□ Auth works (sign up, login, logout)
□ Can create text posts
□ Can view all posts

GOOD (80%):
□ All basic features
□ Can upload images with posts
□ Profile picture works
□ Can delete own posts

EXCELLENT (100%):
□ All good features
□ Like functionality
□ Real-time updates
□ Loading states
□ Error handling
□ Clean UI
```

---

## Bonus Challenge: Offline Support

**Objective:** Make your app work offline with Firestore persistence.

```dart
// Enable offline persistence
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

### Features to Implement

1. Data loads from cache when offline
2. Changes queue and sync when online
3. Show online/offline indicator
4. Handle conflicts gracefully

---

## Tips for Success

```
1. TEST AUTHENTICATION FIRST
   Make sure login/logout work before adding features.

2. USE SECURITY RULES
   Protect user data from other users.

3. HANDLE ERRORS
   Network errors, auth errors, permission errors.

4. OPTIMIZE QUERIES
   Use limits, don't fetch unnecessary data.

5. CLEAN UP
   Delete test data from Firebase Console.
```

---

## Resources

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Docs](https://firebase.google.com/docs/firestore)
- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [Firebase Storage Docs](https://firebase.google.com/docs/storage)

Good luck! 🔥
