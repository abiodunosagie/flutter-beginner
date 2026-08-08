# FCM for Chat (Production Add-on)

## Schema

```
users/{uid}
  fcmTokens: string[]   # or subcollection tokens/{token}
```

## On login / token refresh

```dart
final token = await FirebaseMessaging.instance.getToken();
await FirebaseFirestore.instance.collection('users').doc(uid).set({
  'fcmTokens': FieldValue.arrayUnion([token]),
}, SetOptions(merge: true));
```

## Cloud Function (concept)

```
onCreate messages/{msgId}
  load conversation members
  exclude sender
  fetch tokens
  sendToDevice / sendEachForMulticast
```

## Payload

```json
{
  "notification": { "title": "New message", "body": "..." },
  "data": { "conversationId": "..." }
}
```

## Client

- Foreground: local notification or in-app banner  
- Tap: navigate to conversation  

## Checklist

- [ ] Permission UX  
- [ ] Token saved  
- [ ] Function deployed  
- [ ] Background handler registered  
- [ ] No secrets in app
