# Firebase Cloud Functions: Serverless Backend

## Serverless Functions with Firebase

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// HTTP callable function
exports.addMessage = functions.https.onCall(async (data, context) => {
  const text = data.text;
  const result = await admin.firestore().collection('messages').add({text});
  return {id: result.id};
});

// Firestore trigger
exports.onUserCreate = functions.firestore
  .document('users/{userId}')
  .onCreate((snap, context) => {
    const userId = context.params.userId;
    console.log('New user created:', userId);
    // Send welcome email, etc.
  });
```

## Flutter Integration

```dart
import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final functions = FirebaseFunctions.instance;

  Future<String> callAddMessage(String text) async {
    final callable = functions.httpsCallable('addMessage');
    final result = await callable.call({'text': text});
    return result.data['id'];
  }
}
```

You now have serverless backend power! 🚀
