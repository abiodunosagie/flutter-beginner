# Week 34: Smart Chat App

## Overview
Build a complete, production-ready chat application with Firebase integration. This week focuses on real-time messaging, media sharing, and advanced chat features like typing indicators, read receipts, and push notifications.

## Prerequisites
- Flutter SDK installed
- Firebase account (free tier is sufficient)
- Basic understanding of Flutter widgets and state management
- Familiarity with asynchronous programming (Futures, Streams)

## Firebase Setup Instructions

Before starting these exercises, set up Firebase for your Flutter app:

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: "flutter-chat-app"
4. Follow the setup wizard

### 2. Add Firebase to Flutter
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter app
flutterfire configure
```

### 3. Add Dependencies
Add these to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  firebase_storage: ^11.5.0
  firebase_messaging: ^14.7.0

  # Image/Video handling
  image_picker: ^1.0.4
  video_player: ^2.8.1
  image: ^4.1.3

  # UI
  cached_network_image: ^3.3.0
  intl: ^0.18.1

  # State Management (optional)
  provider: ^6.1.1
```

### 4. Enable Firebase Services
In Firebase Console, enable:
- **Authentication**: Email/Password and Google Sign-In
- **Cloud Firestore**: Start in test mode (update rules later)
- **Storage**: Start in test mode (update rules later)
- **Cloud Messaging**: For push notifications

### 5. Android Setup
Add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Required for Firebase
    }
}
```

### 6. iOS Setup
Update `ios/Podfile`:
```ruby
platform :ios, '12.0'  # Required for Firebase
```

## Exercise Structure

Each exercise builds on the previous one:

### Exercise 1: Basic Chat UI (Beginner)
**Time:** 1-2 hours
**Difficulty:** ⭐ Beginner

Build the chat interface without backend:
- Message bubble widgets (sent/received)
- Text input field with send button
- Message list with auto-scroll
- User avatars
- Timestamp display

**Learning Goals:**
- Widget composition
- ListView builders
- Custom widgets
- UI layout

### Exercise 2: Firebase Chat Basics (Beginner-Intermediate)
**Time:** 2-3 hours
**Difficulty:** ⭐⭐ Beginner-Intermediate

Connect to Firebase and enable real-time messaging:
- Firestore database structure
- Send messages to Firestore
- Receive messages in real-time (Streams)
- User authentication
- Timestamp handling

**Learning Goals:**
- Firebase integration
- Stream builders
- Real-time data
- Authentication

### Exercise 3: Advanced Chat Features (Intermediate)
**Time:** 3-4 hours
**Difficulty:** ⭐⭐⭐ Intermediate

Add professional chat features:
- Typing indicators ("John is typing...")
- Read receipts (single/double check marks)
- Online/offline status
- Last seen timestamps
- Message delivery status

**Learning Goals:**
- Complex state management
- Real-time presence
- Advanced Firestore queries
- Status indicators

### Exercise 4: Media Messages (Intermediate-Advanced)
**Time:** 3-4 hours
**Difficulty:** ⭐⭐⭐⭐ Intermediate-Advanced

Enable sharing images and videos:
- Camera and gallery integration
- Firebase Storage upload
- Image compression
- Upload progress indicators
- Video thumbnail generation
- Media viewer

**Learning Goals:**
- File handling
- Cloud storage
- Image processing
- Progress tracking

### Exercise 5: Complete Chat App (Advanced)
**Time:** 4-6 hours
**Difficulty:** ⭐⭐⭐⭐⭐ Advanced

Build a production-ready chat app:
- Everything from previous exercises
- Push notifications (FCM)
- Message search functionality
- Group chats with admin controls
- User blocking/reporting
- Message reactions (emoji)
- Reply to messages
- Delete/edit messages
- Voice messages (optional)

**Learning Goals:**
- Production patterns
- Push notifications
- Complex features
- User moderation
- Performance optimization

## Firestore Database Structure

Here's the recommended database structure:

```
users/
  {userId}/
    name: string
    email: string
    photoUrl: string
    isOnline: bool
    lastSeen: timestamp
    typingTo: string (userId they're typing to)
    fcmToken: string (for notifications)

chats/
  {chatId}/
    participants: array<string> (userIds)
    lastMessage: string
    lastMessageTime: timestamp
    lastMessageSenderId: string
    isGroupChat: bool
    groupName: string (if group)
    groupPhotoUrl: string (if group)

messages/
  {chatId}/
    messages/
      {messageId}/
        senderId: string
        text: string
        imageUrl: string (optional)
        videoUrl: string (optional)
        timestamp: timestamp
        readBy: array<string> (userIds)
        reactions: map<string, string> (userId -> emoji)
        replyTo: string (messageId, optional)
        edited: bool
        deleted: bool
```

## Security Rules

Don't forget to update your Firestore security rules for production:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }

    // Users can read chats they're part of
    match /chats/{chatId} {
      allow read: if request.auth != null &&
        request.auth.uid in resource.data.participants;
      allow write: if request.auth != null &&
        request.auth.uid in resource.data.participants;
    }

    // Users can read/write messages in chats they're part of
    match /messages/{chatId}/messages/{messageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Running the Exercises

1. Start with Exercise 1 and complete it fully
2. Test your implementation thoroughly
3. Compare with the solution file
4. Move to the next exercise
5. Build progressively - each exercise adds features

## Testing Your App

Test these scenarios:
- [ ] Send messages between two users
- [ ] Messages appear in real-time
- [ ] Typing indicators work
- [ ] Read receipts update correctly
- [ ] Images upload and display
- [ ] Videos play correctly
- [ ] Notifications arrive when app is background
- [ ] Search finds messages
- [ ] Group chats work with multiple users
- [ ] Blocking prevents message delivery

## Common Issues

### Firebase Not Connecting
- Check `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in correct location
- Run `flutter clean` and rebuild
- Verify Firebase initialization in `main.dart`

### Images Not Uploading
- Check Firebase Storage rules
- Verify internet permissions in AndroidManifest.xml
- Check iOS Info.plist for camera/photo permissions

### Messages Not Real-time
- Verify Firestore rules allow read access
- Check Stream listener is active
- Ensure internet connection is stable

## Additional Resources

- [Firebase Flutter Documentation](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)
- [Firestore Data Modeling](https://firebase.google.com/docs/firestore/data-model)
- [FCM Flutter Guide](https://firebase.google.com/docs/cloud-messaging/flutter/client)

## Solutions

Solution files are provided for reference:
- `exercise_1_solution.dart`
- `exercise_2_solution.dart`
- `exercise_3_solution.dart`
- `exercise_4_solution.dart`
- `exercise_5_solution.dart`

**Important:** Try to complete each exercise yourself before checking the solution. Struggling and problem-solving is how you learn!

## Next Steps

After completing these exercises:
1. Deploy your app to TestFlight or Google Play (beta)
2. Add more features (voice messages, video calls, stories)
3. Implement end-to-end encryption
4. Add analytics to track usage
5. Optimize performance for large chat histories

## Need Help?

- Review the lesson content for Week 34
- Check Firebase documentation
- Test with Firebase Emulator Suite for debugging
- Use Flutter DevTools to inspect widget tree and network calls

---

**Happy Coding! Build something amazing! 🚀💬**
