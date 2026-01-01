# Level 11 Checkpoint: Firebase Integration

Before moving to Level 12, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Firebase Services
Match the Firebase service to its purpose:

| Service | Purpose |
|---------|---------|
| Firebase Auth | ___ |
| Cloud Firestore | ___ |
| Firebase Storage | ___ |
| Cloud Functions | ___ |
| Firebase Messaging | ___ |

<details>
<summary>Check Answers</summary>

| Service | Purpose |
|---------|---------|
| Firebase Auth | User authentication (login, signup) |
| Cloud Firestore | NoSQL cloud database |
| Firebase Storage | File storage (images, files) |
| Cloud Functions | Server-side code |
| Firebase Messaging | Push notifications |

</details>

---

### 2. Authentication
What does this code do?

```dart
Future<UserCredential> signIn(String email, String password) async {
  try {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        throw AuthException('No user found with this email');
      case 'wrong-password':
        throw AuthException('Invalid password');
      default:
        throw AuthException('Sign in failed');
    }
  }
}
```

<details>
<summary>Check Answer</summary>

This function:
1. Attempts to sign in with email/password
2. Returns `UserCredential` on success
3. Catches Firebase-specific errors
4. Translates error codes to user-friendly messages
5. Throws custom `AuthException` for UI to handle

</details>

---

### 3. Firestore Operations
What does each operation do?

```dart
// A
await FirebaseFirestore.instance.collection('products').doc('abc').get();

// B
await FirebaseFirestore.instance.collection('products').add(data);

// C
await FirebaseFirestore.instance.collection('products').doc('abc').update(data);

// D
await FirebaseFirestore.instance.collection('products').doc('abc').delete();

// E
FirebaseFirestore.instance.collection('orders').snapshots();
```

<details>
<summary>Check Answers</summary>

- **A**: Get single document by ID
- **B**: Add new document with auto-generated ID
- **C**: Update existing document
- **D**: Delete document
- **E**: Stream of real-time updates (listens for changes)

</details>

---

### 4. Firestore Query
What does this query return?

```dart
FirebaseFirestore.instance
    .collection('products')
    .where('category', isEqualTo: 'electronics')
    .where('price', isLessThan: 100)
    .orderBy('price', descending: true)
    .limit(10)
    .snapshots();
```

<details>
<summary>Check Answer</summary>

Returns a stream of:
- Products in 'electronics' category
- With price under $100
- Sorted by price (highest first)
- Limited to 10 results
- Updates in real-time when data changes

</details>

---

### 5. Security Rules
What does this security rule allow?

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null &&
                   request.auth.token.admin == true;
    }
  }
}
```

<details>
<summary>Check Answer</summary>

- **users/{userId}**: Only authenticated user can read/write their own document
- **products**: Anyone can read, only admins can write

This is a common pattern:
- Users can only access their own data
- Products are public read, admin write

</details>

---

### 6. Auth State Listener
What does this code do?

```dart
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

<details>
<summary>Check Answer</summary>

This listens to authentication state changes:
1. Shows loading while checking auth state
2. If user is logged in (`hasData`), shows HomeScreen
3. If user is not logged in, shows LoginScreen

This auto-updates when user logs in/out - the app reacts to auth changes automatically.

</details>

---

## Hands-On Check

### Task 1: Implement Auth Service
Create an auth service with signup, login, and logout:

```dart
class AuthService {
  // Implement:
  // - signUp(email, password)
  // - signIn(email, password)
  // - signOut()
  // - currentUser getter
  // - authStateChanges stream
}
```

<details>
<summary>Example Solution</summary>

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AuthException _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('No user found');
      case 'wrong-password':
        return AuthException('Invalid password');
      case 'email-already-in-use':
        return AuthException('Email already registered');
      case 'weak-password':
        return AuthException('Password is too weak');
      default:
        return AuthException('Authentication failed');
    }
  }
}
```

</details>

---

### Task 2: Firestore Data Service
Create a service to manage orders:

```dart
class OrderService {
  // Implement:
  // - createOrder(order) → String (returns order ID)
  // - getOrder(id) → Order
  // - getUserOrders(userId) → Stream<List<Order>>
  // - updateOrderStatus(id, status)
}
```

<details>
<summary>Example Solution</summary>

```dart
class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _orders => _db.collection('orders');

  Future<String> createOrder(Order order) async {
    final doc = await _orders.add(order.toJson());
    return doc.id;
  }

  Future<Order> getOrder(String id) async {
    final doc = await _orders.doc(id).get();
    if (!doc.exists) throw NotFoundException('Order not found');
    return Order.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return _orders
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList());
  }

  Future<void> updateOrderStatus(String id, OrderStatus status) async {
    await _orders.doc(id).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
```

</details>

---

### Task 3: Security Rules
Write security rules for ShopEase:

```javascript
// Rules needed:
// - Anyone can read products
// - Only authenticated users can create orders
// - Users can only read their own orders
// - Only the order owner can update their order
```

<details>
<summary>Example Solution</summary>

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Products - public read, no client write
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Only through admin/backend
    }

    // Orders - user-specific access
    match /orders/{orderId} {
      // Can create if authenticated
      allow create: if request.auth != null &&
                    request.resource.data.userId == request.auth.uid;

      // Can read own orders
      allow read: if request.auth != null &&
                  resource.data.userId == request.auth.uid;

      // Can update own orders (limited fields)
      allow update: if request.auth != null &&
                    resource.data.userId == request.auth.uid &&
                    request.resource.data.userId == request.auth.uid;

      // No delete
      allow delete: if false;
    }

    // User profiles
    match /users/{userId} {
      allow read, write: if request.auth != null &&
                         request.auth.uid == userId;
    }
  }
}
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Firebase | _________________ |
| Authentication | _________________ |
| Firestore | _________________ |
| Document | _________________ |
| Collection | _________________ |
| Security Rules | _________________ |
| Real-time listener | _________________ |
| UserCredential | _________________ |

---

## Ready for Level 12?

### I can confidently:
- [ ] Set up Firebase in a Flutter project
- [ ] Implement email/password authentication
- [ ] Handle auth errors with user-friendly messages
- [ ] Listen to auth state changes
- [ ] Create, read, update, delete Firestore documents
- [ ] Query Firestore with filters and ordering
- [ ] Set up real-time listeners with snapshots
- [ ] Write security rules for data protection

### Capstone Progress:
- [ ] User can sign up and sign in
- [ ] Auth state is persisted
- [ ] Orders are saved to Firestore
- [ ] User can view their order history
- [ ] Security rules protect user data

---

## If You're Stuck

**Common issues at this level:**

1. **"Missing google-services.json"**
   - Download from Firebase Console
   - Place in android/app/
   - For iOS: GoogleService-Info.plist in ios/Runner/

2. **"Permission denied" errors**
   - Check security rules in Firebase Console
   - Make sure user is authenticated
   - Verify rules match your queries

3. **Queries failing**
   - Create composite indexes when prompted
   - Check field names match exactly
   - Verify data types match

4. **Auth not persisting**
   - Firebase Auth persists by default
   - Check authStateChanges stream setup
   - Verify no accidental signOut calls

---

**Ready to level up? Head to Level 12: Platform Features!**
