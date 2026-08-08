// Example — save FCM token under the signed-in user.
// Not a full app; paste into a Firebase-enabled project after flutterfire configure.

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveFcmToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  final token = await messaging.getToken();
  if (token == null) return;

  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'fcmTokens': FieldValue.arrayUnion([token]),
    'fcmUpdatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcmTokens': FieldValue.arrayUnion([newToken]),
    }, SetOptions(merge: true));
  });
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep lightweight. Heavy UI work belongs in foreground handlers.
}
*/
