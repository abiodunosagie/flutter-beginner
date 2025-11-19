# Firebase Cloud Functions: Your App's Robot Helpers

## What Are Cloud Functions? (Explained Like You're 5)

Imagine you have a magical robot helper that lives in the cloud (up in the sky where all computers talk to each other). This robot is SUPER smart and can do jobs for you automatically!

**Here's a story:**
- You run a lemonade stand (your Flutter app)
- When someone buys lemonade (a user does something)
- A magical robot wakes up and does helpful things automatically!
  - It sends a "Thank You!" card (email)
  - It counts how much lemonade is left (updates database)
  - It makes the lemonade picture smaller for your menu (resizes images)
  - Then... the robot goes back to sleep!

**The BEST part?** You only pay for the robot when it's working! If no one buys lemonade, the robot sleeps and costs nothing. That's why we call it "serverless" - you don't need to keep a robot awake 24/7 just waiting around.

**Real-World Magic:**
- User creates account → Robot sends welcome email automatically
- User uploads photo → Robot makes it smaller automatically
- User makes purchase → Robot processes payment automatically
- Database changes → Robot updates search index automatically

You write the robot's instructions once, and it runs in Google's super-powerful computers forever!

---

## Why Do We Need Cloud Functions?

Think about your Flutter app like a restaurant:
- Your Flutter app = The dining room where customers eat
- Firestore = The refrigerator storing ingredients
- Cloud Functions = The kitchen where food gets prepared

**Things Your App Can't/Shouldn't Do:**
1. **Send Emails** - Your phone app can't send emails directly (security!)
2. **Process Payments** - Credit cards need secure, trusted servers
3. **Heavy Work** - Resizing 100 images would drain your phone's battery
4. **Secret Operations** - Some code needs to hide secret keys
5. **Scheduled Tasks** - Your app can't run when the user closes it

**Cloud Functions to the Rescue!**
They run on Google's servers, so they can:
- Access secret API keys safely
- Run heavy computations without draining batteries
- Work 24/7 even when users aren't using your app
- Handle sensitive operations like payments securely

---

## Setting Up Cloud Functions: Step-by-Step

### Step 1: Install Node.js (The Robot's Language)

Cloud Functions speak JavaScript (Node.js), not Dart!

**Download Node.js:**
```bash
# Check if you already have it
node --version

# If not, download from: https://nodejs.org
# Get the LTS version (Long Term Support)
```

After installing, check:
```bash
node --version    # Should show: v18.x.x or higher
npm --version     # Should show: 9.x.x or higher
```

Think of Node.js like teaching your robot to speak - it needs to understand JavaScript!

### Step 2: Install Firebase CLI (Command Line Tools)

This is like giving yourself a remote control for Firebase!

```bash
# Install Firebase tools globally
npm install -g firebase-tools

# Check it worked
firebase --version
```

### Step 3: Login to Firebase

```bash
# This opens your browser to login
firebase login

# You'll see:
# ✔ Success! Logged in as your.email@gmail.com
```

### Step 4: Initialize Cloud Functions in Your Project

**Navigate to your Flutter project:**
```bash
cd /path/to/your/flutter/project
```

**Initialize Functions:**
```bash
firebase init functions
```

**You'll see questions - here's what to choose:**

```
? Please select an option: (Use arrow keys)
  ❯ Use an existing project

? Select a default Firebase project:
  ❯ your-app-name (your-app)

? What language would you like to use? (Use arrow keys)
  ❯ JavaScript
    TypeScript

? Do you want to use ESLint? (y/N)
  ❯ Y  (Yes - helps catch mistakes!)

? Do you want to install dependencies now? (Y/n)
  ❯ Y  (Yes - downloads everything needed)
```

**What Just Happened?**
Firebase created a new folder called `functions/` in your project:

```
your-flutter-project/
├── android/
├── ios/
├── lib/
├── functions/              ← NEW! This is where robots live
│   ├── node_modules/       ← Robot's tools (don't touch!)
│   ├── index.js            ← YOUR ROBOT CODE GOES HERE!
│   ├── package.json        ← List of robot's dependencies
│   └── .eslintrc.js        ← Code quality checker
└── pubspec.yaml
```

### Step 5: Understand the Functions Folder

Open `functions/index.js` - this is your robot's brain!

```javascript
const functions = require('firebase-functions');

// This is where you'll write your robot instructions!
```

---

## Your First Cloud Function: Hello World

Let's create the simplest possible robot!

**Edit `functions/index.js`:**

```javascript
const functions = require('firebase-functions');

// Robot that says "Hello!" when you call it
exports.helloWorld = functions.https.onRequest((request, response) => {
  // This robot responds to web requests
  response.send("Hello from Firebase! 🤖");
});
```

**Deploy (Send to Cloud):**

```bash
cd functions
firebase deploy --only functions
```

You'll see:
```
✔  functions[helloWorld(us-central1)] Successful create operation.
Function URL: https://us-central1-your-app.cloudfunctions.net/helloWorld
```

**Test It:**
Copy that URL and paste it in your browser. You'll see: "Hello from Firebase! 🤖"

**What Just Happened?**
1. You wrote robot instructions in `index.js`
2. You sent those instructions to Google's cloud
3. Google created a special URL for your robot
4. When you visit that URL, the robot wakes up and says hello!

---

## Understanding Function Types

Cloud Functions are like different types of robot workers:

### 1. HTTP Functions (Web Robots)
- Triggered when someone visits a URL
- Like a doorbell - someone rings, robot answers
- **Use for:** APIs, webhooks, public endpoints

### 2. Callable Functions (App Robots)
- Triggered when your Flutter app calls them
- Like a direct phone line to your robot
- **Use for:** App-specific tasks that need authentication

### 3. Firestore Triggers (Database Robots)
- Triggered when database changes
- Like a security guard watching for changes
- **Use for:** Automatic updates, notifications, cleanup

### 4. Authentication Triggers (User Robots)
- Triggered when users sign up/sign in/delete
- Like a greeter at a store entrance
- **Use for:** Welcome emails, setup user profiles

### 5. Storage Triggers (File Robots)
- Triggered when files are uploaded/deleted
- Like a librarian organizing books
- **Use for:** Image processing, file validation

### 6. Scheduled Functions (Alarm Clock Robots)
- Triggered at specific times
- Like a scheduled alarm
- **Use for:** Daily reports, cleanup, reminders

---

## 10+ Complete Code Examples

### Example 1: HTTP Request Function (Public API)

```javascript
const functions = require('firebase-functions');

// Anyone can call this by visiting the URL
exports.getServerTime = functions.https.onRequest((request, response) => {
  const currentTime = new Date().toISOString();

  response.json({
    time: currentTime,
    message: "This is the server time!"
  });
});
```

**What it does:** Returns current server time when you visit the URL.

**Test:** Visit the function URL in browser.

---

### Example 2: Callable Function (App-Only)

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Only authenticated users from your app can call this
exports.addUserScore = functions.https.onCall(async (data, context) => {
  // Check if user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be logged in!'
    );
  }

  const userId = context.auth.uid;
  const score = data.score;

  // Validate the score
  if (typeof score !== 'number' || score < 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Score must be a positive number!'
    );
  }

  // Add score to Firestore
  await admin.firestore().collection('scores').add({
    userId: userId,
    score: score,
    timestamp: admin.firestore.FieldValue.serverTimestamp()
  });

  return {
    success: true,
    message: `Score ${score} added for user ${userId}`
  };
});
```

**What it does:** Lets authenticated users add their game scores securely.

**Why in Cloud Function?** Users can't fake their scores - the server validates everything!

**Call from Flutter:**

```dart
import 'package:cloud_functions/cloud_functions.dart';

Future<void> submitScore(int score) async {
  try {
    final callable = FirebaseFunctions.instance.httpsCallable('addUserScore');
    final result = await callable.call({'score': score});

    print(result.data['message']);
  } on FirebaseFunctionsException catch (e) {
    print('Error: ${e.code} - ${e.message}');
  }
}
```

---

### Example 3: Firestore Trigger - Welcome New Users

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Triggers when a new user document is created
exports.onUserCreate = functions.firestore
  .document('users/{userId}')
  .onCreate(async (snapshot, context) => {
    // Get the user ID from the path
    const userId = context.params.userId;

    // Get the user data
    const userData = snapshot.data();

    console.log(`New user created: ${userId}`);
    console.log(`Name: ${userData.name}`);
    console.log(`Email: ${userData.email}`);

    // Create a welcome message in another collection
    await admin.firestore().collection('messages').add({
      userId: userId,
      title: 'Welcome!',
      body: `Hi ${userData.name}! Welcome to our amazing app!`,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isRead: false
    });

    // Update user stats
    await admin.firestore().collection('stats').doc('global').update({
      totalUsers: admin.firestore.FieldValue.increment(1)
    });

    console.log('Welcome message created!');
  });
```

**What it does:**
1. Watches for new users in the `users` collection
2. Creates a welcome message automatically
3. Updates global statistics

**When it runs:** The moment someone adds a document to `users/`

---

### Example 4: Firestore Trigger - Update on Changes

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Triggers when a user document is updated
exports.onUserUpdate = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    // Get before and after data
    const beforeData = change.before.data();
    const afterData = change.after.data();

    const userId = context.params.userId;

    // Check if the name changed
    if (beforeData.name !== afterData.name) {
      console.log(`User ${userId} changed name from ${beforeData.name} to ${afterData.name}`);

      // Log the change
      await admin.firestore().collection('nameChanges').add({
        userId: userId,
        oldName: beforeData.name,
        newName: afterData.name,
        changedAt: admin.firestore.FieldValue.serverTimestamp()
      });
    }

    // Check if email verified status changed
    if (!beforeData.emailVerified && afterData.emailVerified) {
      console.log(`User ${userId} just verified their email!`);

      // Give them a bonus for verifying
      await admin.firestore().collection('users').doc(userId).update({
        points: admin.firestore.FieldValue.increment(100),
        badges: admin.firestore.FieldValue.arrayUnion('email-verified')
      });
    }
  });
```

**What it does:** Watches for changes to user documents and reacts accordingly.

---

### Example 5: Firestore Trigger - Clean Up on Delete

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Triggers when a user document is deleted
exports.onUserDelete = functions.firestore
  .document('users/{userId}')
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const userData = snapshot.data();

    console.log(`User ${userId} was deleted. Cleaning up...`);

    // Delete all the user's messages
    const messagesSnapshot = await admin.firestore()
      .collection('messages')
      .where('userId', '==', userId)
      .get();

    const batch = admin.firestore().batch();
    messagesSnapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });

    await batch.commit();
    console.log(`Deleted ${messagesSnapshot.size} messages for user ${userId}`);

    // Delete user's scores
    const scoresSnapshot = await admin.firestore()
      .collection('scores')
      .where('userId', '==', userId)
      .get();

    const scoreBatch = admin.firestore().batch();
    scoresSnapshot.docs.forEach(doc => {
      scoreBatch.delete(doc.ref);
    });

    await scoreBatch.commit();
    console.log(`Deleted ${scoresSnapshot.size} scores for user ${userId}`);

    // Update global stats
    await admin.firestore().collection('stats').doc('global').update({
      totalUsers: admin.firestore.FieldValue.increment(-1)
    });
  });
```

**What it does:** When a user is deleted, automatically cleans up all their data.

**Why it's important:** Prevents orphaned data cluttering your database!

---

### Example 6: Authentication Trigger - New User Setup

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Triggers when a user creates an account
exports.onAuthUserCreate = functions.auth.user().onCreate(async (user) => {
  const userId = user.uid;
  const email = user.email;
  const displayName = user.displayName || 'New User';

  console.log(`New authentication user: ${userId}`);

  // Create a user profile in Firestore
  await admin.firestore().collection('users').doc(userId).set({
    email: email,
    displayName: displayName,
    photoURL: user.photoURL || null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    points: 0,
    level: 1,
    badges: [],
    settings: {
      notifications: true,
      darkMode: false
    }
  });

  console.log(`Created Firestore profile for ${userId}`);

  // Note: In a real app, you'd send a welcome email here
  // We'll show email example later!
});
```

**What it does:** Automatically creates a Firestore profile when someone signs up.

**Why it's useful:** Every user gets a consistent starting profile!

---

### Example 7: Authentication Trigger - User Deleted

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Triggers when a user deletes their account
exports.onAuthUserDelete = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;

  console.log(`User ${userId} deleted their account. Cleaning up...`);

  // Delete their Firestore profile
  await admin.firestore().collection('users').doc(userId).delete();

  // Delete their storage folder (if they uploaded files)
  const bucket = admin.storage().bucket();
  await bucket.deleteFiles({
    prefix: `users/${userId}/`
  });

  console.log(`Cleaned up all data for ${userId}`);
});
```

**What it does:** When someone deletes their account, removes all their data.

---

### Example 8: Storage Trigger - Image Upload Processing

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const path = require('path');
const os = require('os');
const fs = require('fs');
const { Storage } = require('@google-cloud/storage');
const sharp = require('sharp'); // Image processing library

const storage = new Storage();

// Triggers when a file is uploaded to Storage
exports.onImageUpload = functions.storage.object().onFinalize(async (object) => {
  const filePath = object.name; // File path in storage
  const contentType = object.contentType; // File type
  const bucket = object.bucket;

  // Exit if not an image
  if (!contentType.startsWith('image/')) {
    console.log('Not an image. Skipping.');
    return null;
  }

  // Exit if already a thumbnail
  if (filePath.includes('_thumb')) {
    console.log('Already a thumbnail. Skipping.');
    return null;
  }

  console.log(`Processing image: ${filePath}`);

  // Download file to temporary directory
  const tempFilePath = path.join(os.tmpdir(), path.basename(filePath));
  const bucketObj = storage.bucket(bucket);

  await bucketObj.file(filePath).download({
    destination: tempFilePath
  });

  console.log('Image downloaded to', tempFilePath);

  // Create thumbnail
  const thumbFileName = `${path.basename(filePath, path.extname(filePath))}_thumb${path.extname(filePath)}`;
  const thumbFilePath = path.join(os.tmpdir(), thumbFileName);

  await sharp(tempFilePath)
    .resize(200, 200, {
      fit: 'inside',
      withoutEnlargement: true
    })
    .toFile(thumbFilePath);

  console.log('Thumbnail created at', thumbFilePath);

  // Upload thumbnail
  const thumbPath = path.join(path.dirname(filePath), thumbFileName);
  await bucketObj.upload(thumbFilePath, {
    destination: thumbPath,
    metadata: {
      contentType: contentType
    }
  });

  console.log('Thumbnail uploaded to', thumbPath);

  // Clean up temp files
  fs.unlinkSync(tempFilePath);
  fs.unlinkSync(thumbFilePath);

  return null;
});
```

**What it does:** When users upload images, automatically creates thumbnails!

**Setup needed:**
```bash
cd functions
npm install sharp
```

---

### Example 9: Scheduled Function - Daily Cleanup

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Runs every day at midnight (UTC)
exports.dailyCleanup = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('America/New_York') // Set your timezone
  .onRun(async (context) => {
    console.log('Running daily cleanup...');

    // Delete old messages (older than 30 days)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const oldMessages = await admin.firestore()
      .collection('messages')
      .where('createdAt', '<', thirtyDaysAgo)
      .get();

    const batch = admin.firestore().batch();
    oldMessages.docs.forEach(doc => {
      batch.delete(doc.ref);
    });

    await batch.commit();
    console.log(`Deleted ${oldMessages.size} old messages`);

    // Create daily report
    const totalUsers = await admin.firestore().collection('users').count().get();
    const totalMessages = await admin.firestore().collection('messages').count().get();

    await admin.firestore().collection('dailyReports').add({
      date: admin.firestore.FieldValue.serverTimestamp(),
      totalUsers: totalUsers.data().count,
      totalMessages: totalMessages.data().count,
      messagesDeleted: oldMessages.size
    });

    console.log('Daily cleanup complete!');
    return null;
  });
```

**What it does:** Runs automatically every night to clean old data and create reports.

**Schedule format:**
```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)

Examples:
'0 0 * * *'     = Every day at midnight
'0 9 * * 1'     = Every Monday at 9 AM
'*/15 * * * *'  = Every 15 minutes
'0 0 1 * *'     = First day of every month at midnight
```

---

### Example 10: Send Email Function (Real-World!)

First, enable email sending:
```bash
cd functions
npm install nodemailer
```

Set up email config:
```bash
firebase functions:config:set gmail.email="your-email@gmail.com" gmail.password="your-app-password"
```

**Note:** Use an App Password, not your regular Gmail password!
Go to: Google Account → Security → App Passwords

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

// Configure email
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailEmail,
    pass: gmailPassword
  }
});

// Send welcome email when user signs up
exports.sendWelcomeEmail = functions.auth.user().onCreate(async (user) => {
  const email = user.email;
  const displayName = user.displayName || 'friend';

  const mailOptions = {
    from: `Your App <${gmailEmail}>`,
    to: email,
    subject: 'Welcome to Our Amazing App!',
    html: `
      <h1>Welcome, ${displayName}!</h1>
      <p>Thanks for joining our app. We're excited to have you!</p>
      <p>Here are some things you can do:</p>
      <ul>
        <li>Complete your profile</li>
        <li>Connect with friends</li>
        <li>Explore awesome features</li>
      </ul>
      <p>Happy exploring!</p>
      <p><strong>The Team</strong></p>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Welcome email sent to ${email}`);
  } catch (error) {
    console.error('Error sending email:', error);
  }
});

// Callable function to send custom emails
exports.sendCustomEmail = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  }

  const { to, subject, message } = data;

  const mailOptions = {
    from: gmailEmail,
    to: to,
    subject: subject,
    text: message
  };

  try {
    await transporter.sendMail(mailOptions);
    return { success: true, message: 'Email sent!' };
  } catch (error) {
    throw new functions.https.HttpsError('internal', error.message);
  }
});
```

---

### Example 11: Process Payment (Stripe Integration)

```bash
cd functions
npm install stripe
```

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe.secret_key);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  // Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  }

  const amount = data.amount; // Amount in cents
  const currency = data.currency || 'usd';

  // Validate amount
  if (!amount || amount < 50) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Amount must be at least $0.50'
    );
  }

  try {
    // Create payment intent with Stripe
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
      metadata: {
        userId: context.auth.uid
      }
    });

    // Log payment in Firestore
    await admin.firestore().collection('payments').add({
      userId: context.auth.uid,
      amount: amount,
      currency: currency,
      status: 'pending',
      paymentIntentId: paymentIntent.id,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // Return client secret to complete payment in app
    return {
      clientSecret: paymentIntent.client_secret
    };
  } catch (error) {
    console.error('Payment error:', error);
    throw new functions.https.HttpsError('internal', error.message);
  }
});

// Webhook to handle payment confirmations
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const endpointSecret = functions.config().stripe.webhook_secret;

  let event;

  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  if (event.type === 'payment_intent.succeeded') {
    const paymentIntent = event.data.object;
    const userId = paymentIntent.metadata.userId;

    console.log(`Payment succeeded for user ${userId}`);

    // Update payment status in Firestore
    const paymentsSnapshot = await admin.firestore()
      .collection('payments')
      .where('paymentIntentId', '==', paymentIntent.id)
      .get();

    if (!paymentsSnapshot.empty) {
      await paymentsSnapshot.docs[0].ref.update({
        status: 'completed',
        completedAt: admin.firestore.FieldValue.serverTimestamp()
      });

      // Give user their purchase (coins, premium, etc.)
      await admin.firestore().collection('users').doc(userId).update({
        isPremium: true,
        premiumActivatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
    }
  }

  res.json({ received: true });
});
```

---

### Example 12: Moderate Content (AI Integration)

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Triggers when a new message is created
exports.moderateMessage = functions.firestore
  .document('messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data();
    const messageText = messageData.text;

    // Simple bad word filter (in real app, use AI service)
    const badWords = ['badword1', 'badword2', 'badword3'];
    const containsBadWords = badWords.some(word =>
      messageText.toLowerCase().includes(word)
    );

    if (containsBadWords) {
      console.log('Bad words detected! Flagging message.');

      // Flag the message
      await snapshot.ref.update({
        flagged: true,
        flagReason: 'Inappropriate content',
        moderatedAt: admin.firestore.FieldValue.serverTimestamp()
      });

      // Notify admin
      await admin.firestore().collection('moderationQueue').add({
        messageId: context.params.messageId,
        userId: messageData.userId,
        reason: 'Bad words detected',
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });

      // Send notification to user
      await admin.firestore().collection('notifications').add({
        userId: messageData.userId,
        title: 'Message Flagged',
        body: 'Your message was flagged for review.',
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });
    }
  });
```

---

## Error Handling and Best Practices

### 1. Always Handle Errors

**Bad (No Error Handling):**
```javascript
exports.badFunction = functions.https.onCall(async (data, context) => {
  const result = await admin.firestore().collection('users').doc(data.userId).get();
  return result.data();
});
```

**Good (With Error Handling):**
```javascript
exports.goodFunction = functions.https.onCall(async (data, context) => {
  try {
    // Validate input
    if (!data.userId) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'userId is required'
      );
    }

    // Perform operation
    const result = await admin.firestore()
      .collection('users')
      .doc(data.userId)
      .get();

    // Check if document exists
    if (!result.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'User not found'
      );
    }

    return result.data();

  } catch (error) {
    console.error('Error in goodFunction:', error);

    // Re-throw HttpsError
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }

    // Wrap other errors
    throw new functions.https.HttpsError('internal', error.message);
  }
});
```

### 2. Use Proper Error Codes

Available error codes:
- `invalid-argument` - Client sent invalid data
- `unauthenticated` - User not logged in
- `permission-denied` - User lacks permission
- `not-found` - Resource doesn't exist
- `already-exists` - Resource already exists
- `resource-exhausted` - Quota exceeded
- `failed-precondition` - Wrong state for operation
- `internal` - Server error
- `unavailable` - Service unavailable

### 3. Validate All Input

```javascript
exports.validateExample = functions.https.onCall((data, context) => {
  // Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Must be logged in');
  }

  // Validate required fields
  if (!data.name || typeof data.name !== 'string') {
    throw new functions.https.HttpsError('invalid-argument', 'name must be a string');
  }

  // Validate data types
  if (!data.age || typeof data.age !== 'number') {
    throw new functions.https.HttpsError('invalid-argument', 'age must be a number');
  }

  // Validate ranges
  if (data.age < 0 || data.age > 150) {
    throw new functions.https.HttpsError('invalid-argument', 'age must be between 0 and 150');
  }

  // Validate string length
  if (data.name.length > 100) {
    throw new functions.https.HttpsError('invalid-argument', 'name too long');
  }

  // All validation passed!
  return { success: true };
});
```

### 4. Use Logging Wisely

```javascript
exports.loggingExample = functions.https.onCall(async (data, context) => {
  // Info logging
  console.log('Function called by user:', context.auth?.uid);
  console.log('Input data:', JSON.stringify(data));

  // Warning logging
  if (!data.optionalField) {
    console.warn('Optional field not provided, using default');
  }

  // Error logging
  try {
    await someOperation();
  } catch (error) {
    console.error('Operation failed:', error);
    throw error;
  }

  return { success: true };
});
```

**View logs:**
```bash
firebase functions:log
```

### 5. Avoid Infinite Loops

**Bad (Infinite Loop!):**
```javascript
// DON'T DO THIS!
exports.badTrigger = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    // This will trigger itself infinitely!
    await change.after.ref.update({
      lastModified: admin.firestore.FieldValue.serverTimestamp()
    });
  });
```

**Good (Safe Update):**
```javascript
exports.goodTrigger = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const afterData = change.after.data();

    // Only update if lastModified doesn't exist
    if (!afterData.lastModified) {
      await change.after.ref.update({
        lastModified: admin.firestore.FieldValue.serverTimestamp()
      });
    }
  });
```

### 6. Use Batched Operations

**Bad (Multiple Operations):**
```javascript
// Slow and expensive!
for (let i = 0; i < 100; i++) {
  await admin.firestore().collection('items').add({ value: i });
}
```

**Good (Batched):**
```javascript
const batch = admin.firestore().batch();

for (let i = 0; i < 100; i++) {
  const ref = admin.firestore().collection('items').doc();
  batch.set(ref, { value: i });
}

await batch.commit(); // One operation!
```

### 7. Set Timeouts

```javascript
exports.longFunction = functions
  .runWith({ timeoutSeconds: 300 }) // 5 minutes (default is 60s)
  .https.onCall(async (data, context) => {
    // Long-running operation
  });
```

### 8. Allocate Proper Memory

```javascript
exports.memoryIntensive = functions
  .runWith({ memory: '1GB' }) // Default is 256MB
  .https.onCall(async (data, context) => {
    // Memory-intensive operation like image processing
  });
```

---

## Testing Cloud Functions

### Local Testing (Before Deploying)

**1. Install Firebase Emulators:**
```bash
firebase init emulators
```

Select: Functions, Firestore, Authentication

**2. Start Emulators:**
```bash
firebase emulators:start
```

You'll see:
```
✔  functions: Emulator started at http://localhost:5001
✔  firestore: Emulator started at http://localhost:8080
✔  auth: Emulator started at http://localhost:9099
```

**3. Test Functions Locally:**

Your functions now run on your computer! Test them at:
```
http://localhost:5001/your-project/us-central1/functionName
```

### Unit Testing Functions

**Install testing tools:**
```bash
cd functions
npm install --save-dev mocha chai firebase-functions-test
```

**Create test file `functions/test/index.test.js`:**

```javascript
const { expect } = require('chai');
const test = require('firebase-functions-test')();

describe('Cloud Functions Tests', () => {

  // Test callable function
  it('should add two numbers', async () => {
    const myFunctions = require('../index');
    const wrapped = test.wrap(myFunctions.addNumbers);

    const result = await wrapped({ a: 5, b: 3 });
    expect(result.sum).to.equal(8);
  });

  // Test with authentication
  it('should require authentication', async () => {
    const myFunctions = require('../index');
    const wrapped = test.wrap(myFunctions.secureFunction);

    try {
      await wrapped({}, { auth: null });
      expect.fail('Should have thrown error');
    } catch (error) {
      expect(error.code).to.equal('unauthenticated');
    }
  });

});
```

**Run tests:**
```bash
cd functions
npm test
```

---

## Deployment

### Deploy All Functions

```bash
firebase deploy --only functions
```

### Deploy Specific Function

```bash
firebase deploy --only functions:functionName
```

### Deploy Multiple Functions

```bash
firebase deploy --only functions:func1,functions:func2
```

### Delete a Function

```bash
firebase functions:delete functionName
```

### View Deployed Functions

```bash
firebase functions:list
```

---

## Monitoring and Debugging

### View Logs

```bash
# View all logs
firebase functions:log

# View specific function
firebase functions:log --only functionName

# Follow logs in real-time
firebase functions:log --follow
```

### Firebase Console

Visit: https://console.firebase.google.com

Go to: Functions → Dashboard

You'll see:
- Invocations (how many times functions ran)
- Execution time
- Memory usage
- Errors
- Detailed logs

### Check Function Health

In Firebase Console → Functions, you can see:
- Success rate
- Error rate
- Average execution time
- Memory usage over time

---

## Cost Optimization

### Free Tier Includes:
- 2,000,000 invocations/month
- 400,000 GB-seconds of compute time
- 200,000 GB-seconds of memory
- 5 GB outbound network data

### Tips to Save Money:

**1. Use Appropriate Memory:**
```javascript
// Don't use 2GB for simple functions!
exports.simple = functions
  .runWith({ memory: '128MB' }) // Smallest option
  .https.onCall(async (data, context) => {
    return { message: 'Hello' };
  });
```

**2. Avoid Unnecessary Triggers:**
```javascript
// Don't trigger on every single change
// Use specific paths
exports.specific = functions.firestore
  .document('importantDocs/{docId}') // Not 'everything/{anything}'
  .onWrite(async (change, context) => {
    // Handle change
  });
```

**3. Clean Up Old Functions:**
```bash
# Delete functions you don't use
firebase functions:delete oldFunction
```

**4. Use Batching:**
Batch operations instead of triggering functions many times.

---

## Complete Flutter Integration Example

### Flutter Side:

```dart
import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  final functions = FirebaseFunctions.instance;

  // Call a simple function
  Future<String> getServerTime() async {
    try {
      final callable = functions.httpsCallable('getServerTime');
      final result = await callable.call();
      return result.data['time'];
    } on FirebaseFunctionsException catch (e) {
      print('Error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // Call function with parameters
  Future<void> addScore(int score) async {
    try {
      final callable = functions.httpsCallable('addUserScore');
      final result = await callable.call({'score': score});
      print(result.data['message']);
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'unauthenticated') {
        print('You must be logged in!');
      } else if (e.code == 'invalid-argument') {
        print('Invalid score!');
      } else {
        print('Error: ${e.message}');
      }
    }
  }

  // Send email
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String message,
  }) async {
    try {
      final callable = functions.httpsCallable('sendCustomEmail');
      final result = await callable.call({
        'to': to,
        'subject': subject,
        'message': message,
      });
      return result.data['success'];
    } catch (e) {
      print('Failed to send email: $e');
      return false;
    }
  }

  // Process payment
  Future<String?> createPaymentIntent(int amountInCents) async {
    try {
      final callable = functions.httpsCallable('createPaymentIntent');
      final result = await callable.call({
        'amount': amountInCents,
        'currency': 'usd',
      });
      return result.data['clientSecret'];
    } catch (e) {
      print('Payment failed: $e');
      return null;
    }
  }
}
```

### Using in Your App:

```dart
class MyApp extends StatelessWidget {
  final functionsService = CloudFunctionsService();

  Future<void> handleScoreSubmit(int score) async {
    try {
      await functionsService.addScore(score);
      // Show success message
    } catch (e) {
      // Show error message
    }
  }

  Future<void> handlePayment() async {
    final clientSecret = await functionsService.createPaymentIntent(1999); // $19.99
    if (clientSecret != null) {
      // Use Stripe SDK to complete payment
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () => handleScoreSubmit(100),
          child: Text('Submit Score'),
        ),
      ),
    );
  }
}
```

---

## Common Pitfalls and Solutions

### Problem 1: Function Times Out

**Symptom:** Function stops after 60 seconds

**Solution:** Increase timeout
```javascript
exports.longTask = functions
  .runWith({ timeoutSeconds: 300 })
  .https.onCall(async (data, context) => {
    // Your long task
  });
```

### Problem 2: "Permission Denied" Error

**Symptom:** Can't access Firestore from function

**Solution:** Initialize Admin SDK
```javascript
const admin = require('firebase-admin');
admin.initializeApp(); // Add this!
```

### Problem 3: Function Not Deploying

**Symptom:** Deploy fails with syntax error

**Solution:** Test locally first
```bash
cd functions
node index.js  # Check for syntax errors
firebase emulators:start  # Test locally
```

### Problem 4: Can't Call Function from Flutter

**Symptom:** "Function not found" error

**Solution:** Check function name matches exactly
```dart
// Flutter
final callable = functions.httpsCallable('addUserScore');

// Must match functions/index.js
exports.addUserScore = functions.https.onCall(...);
```

---

## Quick Reference

### Function Types Cheat Sheet

```javascript
// HTTP Request (public URL)
exports.name = functions.https.onRequest((req, res) => {});

// Callable (from app)
exports.name = functions.https.onCall(async (data, context) => {});

// Firestore Create
exports.name = functions.firestore.document('path/{id}')
  .onCreate(async (snap, context) => {});

// Firestore Update
exports.name = functions.firestore.document('path/{id}')
  .onUpdate(async (change, context) => {});

// Firestore Delete
exports.name = functions.firestore.document('path/{id}')
  .onDelete(async (snap, context) => {});

// Firestore Any Change
exports.name = functions.firestore.document('path/{id}')
  .onWrite(async (change, context) => {});

// Auth User Created
exports.name = functions.auth.user()
  .onCreate(async (user) => {});

// Auth User Deleted
exports.name = functions.auth.user()
  .onDelete(async (user) => {});

// Storage File Uploaded
exports.name = functions.storage.object()
  .onFinalize(async (object) => {});

// Storage File Deleted
exports.name = functions.storage.object()
  .onDelete(async (object) => {});

// Scheduled (cron)
exports.name = functions.pubsub
  .schedule('0 0 * * *')
  .onRun(async (context) => {});
```

---

## Summary: You're Now a Cloud Functions Expert!

**You learned:**
1. What Cloud Functions are (magical robot helpers!)
2. How to set up Cloud Functions from scratch
3. 12+ real-world function examples
4. All trigger types (HTTP, Firestore, Auth, Storage, Scheduled)
5. Error handling and best practices
6. Testing locally and with unit tests
7. Deployment and monitoring
8. Flutter integration

**Your Cloud Functions can now:**
- Send emails automatically
- Process payments securely
- Resize images when uploaded
- Clean up data on schedules
- Moderate content
- Welcome new users
- And so much more!

Remember: Cloud Functions are like having a team of robot helpers that work 24/7 in the cloud, doing tasks your app can't or shouldn't do itself. They make your app more powerful, more secure, and more professional!

Now go build something amazing with your new serverless superpowers!
