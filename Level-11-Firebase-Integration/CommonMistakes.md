# Level 11: Common Mistakes

Learn from these common Firebase errors!

---

## Mistake #1: Missing Firebase Initialization

```dart
// ❌ WRONG - Firebase not initialized
void main() {
  runApp(MyApp());  // Firebase calls will crash!
}

// ✅ RIGHT
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

---

## Mistake #2: Forgetting to Add Config Files

```
// ❌ WRONG - Files missing
android/app/google-services.json  ← Missing!
ios/Runner/GoogleService-Info.plist  ← Missing!

// ✅ RIGHT - Download from Firebase Console
1. Go to Firebase Console
2. Project Settings → Your apps
3. Download config files
4. Place in correct locations
```

---

## Mistake #3: Not Handling Auth State

```dart
// ❌ WRONG - Checking once
if (FirebaseAuth.instance.currentUser != null) {
  return HomeScreen();
}
return LoginScreen();

// ✅ RIGHT - Listen to changes
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingScreen();
    }
    if (snapshot.hasData) {
      return HomeScreen();
    }
    return LoginScreen();
  },
)
```

---

## Mistake #4: Generic Error Messages

```dart
// ❌ WRONG - Unhelpful error
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(...);
} catch (e) {
  showError('Login failed');  // User doesn't know why!
}

// ✅ RIGHT - Specific messages
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(...);
} on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'user-not-found':
      showError('No account found with this email');
      break;
    case 'wrong-password':
      showError('Incorrect password');
      break;
    case 'too-many-requests':
      showError('Too many attempts. Try again later');
      break;
    default:
      showError('Login failed. Please try again');
  }
}
```

---

## Mistake #5: Insecure Security Rules

```javascript
// ❌ WRONG - Anyone can read/write everything!
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // NEVER do this in production!
    }
  }
}

// ✅ RIGHT - Proper rules
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}

match /products/{productId} {
  allow read: if true;
  allow write: if request.auth.token.admin == true;
}
```

---

## Mistake #6: Not Creating Indexes

```dart
// ❌ WRONG - Query fails
FirebaseFirestore.instance
    .collection('products')
    .where('category', isEqualTo: 'electronics')
    .orderBy('price')
    .get();  // Error: Missing index!

// ✅ RIGHT - Create index in Firebase Console
// Check error message for link to create index
// Or create manually in Firestore → Indexes
```

---

## Mistake #7: Storing Sensitive Data

```dart
// ❌ WRONG - Password in Firestore
await users.doc(uid).set({
  'email': email,
  'password': password,  // NEVER store passwords!
});

// ✅ RIGHT - Let Firebase Auth handle passwords
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Only store non-sensitive user data
await users.doc(uid).set({
  'email': email,
  'displayName': name,
  'createdAt': FieldValue.serverTimestamp(),
});
```

---

## Mistake #8: Not Using ServerTimestamp

```dart
// ❌ WRONG - Client time (can be wrong)
await orders.add({
  'createdAt': DateTime.now().toIso8601String(),
});

// ✅ RIGHT - Server time (always correct)
await orders.add({
  'createdAt': FieldValue.serverTimestamp(),
});
```

---

## Mistake #9: Listener Memory Leaks

```dart
// ❌ WRONG - Never cancelled
@override
void initState() {
  FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .listen((snapshot) {
        setState(() => products = snapshot.docs);
      });
}

// ✅ RIGHT - Cancel in dispose
late StreamSubscription _subscription;

@override
void initState() {
  super.initState();
  _subscription = FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .listen((snapshot) {
        setState(() => products = snapshot.docs);
      });
}

@override
void dispose() {
  _subscription.cancel();
  super.dispose();
}
```

---

## Mistake #10: Reading Entire Collections

```dart
// ❌ WRONG - Downloads ALL documents
final snapshot = await FirebaseFirestore.instance
    .collection('products')
    .get();  // Could be millions of documents!

// ✅ RIGHT - Limit and paginate
final snapshot = await FirebaseFirestore.instance
    .collection('products')
    .orderBy('createdAt', descending: true)
    .limit(20)
    .get();

// For next page:
final lastDoc = snapshot.docs.last;
final nextPage = await FirebaseFirestore.instance
    .collection('products')
    .orderBy('createdAt', descending: true)
    .startAfterDocument(lastDoc)
    .limit(20)
    .get();
```

---

## Quick Reference: Firebase Services

| Service | Use For |
|---------|---------|
| Auth | User login/signup |
| Firestore | Structured data (users, orders) |
| Storage | Files (images, documents) |
| Functions | Server-side code |
| Messaging | Push notifications |
| Analytics | Usage tracking |

---

**Still stuck? Re-read the Theory files or ask for help!**
