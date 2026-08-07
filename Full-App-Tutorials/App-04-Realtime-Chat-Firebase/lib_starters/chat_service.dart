// Copy into your Flutter project: lib/services/chat_service.dart
// Requires: firebase_auth, cloud_firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  ChatService({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String get uid => _auth.currentUser!.uid;

  String dmIdFor(String otherUid) {
    final ids = [uid, otherUid]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchConversations() {
    return _db
        .collection('conversations')
        .where('memberIds', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMessages(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt')
        .limitToLast(100)
        .snapshots();
  }

  Future<String> ensureDm(String otherUid) async {
    final id = dmIdFor(otherUid);
    final ref = _db.collection('conversations').doc(id);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'memberIds': [uid, otherUid],
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return id;
  }

  Future<void> sendText(String conversationId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final batch = _db.batch();
    final msgRef = _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();

    batch.set(msgRef, {
      'senderId': uid,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    batch.update(_db.collection('conversations').doc(conversationId), {
      'lastMessage': trimmed,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}
