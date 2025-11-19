/// Exercise 5: Complete Chat App (Advanced)
///
/// Level: Advanced
/// Estimated Time: 4-6 hours
///
/// Task:
/// Build a production-ready chat application with all features from previous
/// exercises plus additional professional features:
/// - Push notifications for new messages (FCM)
/// - Message search functionality
/// - Group chats with admin controls
/// - User blocking and reporting
/// - Message reactions (emoji)
/// - Reply to messages
/// - Delete and edit messages
/// - Message forwarding
///
/// This is the culmination of all previous exercises!
///
/// Requirements:
/// 1. All features from Exercises 1-4
/// 2. Push notifications using Firebase Cloud Messaging
/// 3. Search messages by text
/// 4. Create and manage group chats
/// 5. Block/unblock users
/// 6. React to messages with emojis
/// 7. Reply to specific messages
/// 8. Edit sent messages (within 15 minutes)
/// 9. Delete messages (for everyone or just yourself)
/// 10. Forward messages to other chats
///
/// Dependencies (add to pubspec.yaml):
/// firebase_messaging: ^14.7.0
/// flutter_local_notifications: ^16.2.0
///
/// Firestore Structure (Complete):
/// users/
///   {userId}/
///     name: string
///     email: string
///     photoUrl: string?
///     isOnline: bool
///     lastSeen: timestamp
///     typingTo: string?
///     fcmToken: string
///     blockedUsers: array<string>
///
/// chats/
///   {chatId}/
///     participants: array<string>
///     participantNames: map<string, string>
///     lastMessage: string
///     lastMessageTime: timestamp
///     lastMessageSenderId: string
///     isGroupChat: bool
///     groupName: string?
///     groupPhotoUrl: string?
///     admins: array<string> (for group chats)
///     createdBy: string
///     createdAt: timestamp
///
/// messages/
///   {chatId}/
///     messages/
///       {messageId}/
///         text: string
///         senderId: string
///         senderName: string
///         timestamp: timestamp
///         mediaType: string?
///         mediaUrl: string?
///         thumbnailUrl: string?
///         readBy: array<string>
///         deliveredTo: array<string>
///         reactions: map<string, string> (userId -> emoji)
///         replyTo: string? (messageId)
///         replyToText: string?
///         replyToSender: string?
///         edited: bool
///         editedAt: timestamp?
///         deleted: bool
///         deletedBy: array<string>
///
/// Learning Goals:
/// - Production-ready architecture
/// - Push notifications
/// - Complex data modeling
/// - User moderation features
/// - Message management
/// - Group chat logic
/// - Search implementation

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // TODO: Initialize push notifications
  // await initializeNotifications();

  runApp(MyApp());
}

// TODO: Initialize Firebase Cloud Messaging
Future<void> initializeNotifications() async {
  // Request permission for iOS
  // Setup FCM handlers
  // Get FCM token and save to Firestore
}

// TODO: Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Same as previous exercises
    return Container();
  }
}

// TODO: Enhanced ChatMessage model (complete version)
class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String? mediaType;
  final String? mediaUrl;
  final List<String> readBy;
  final Map<String, String> reactions; // userId -> emoji
  final String? replyTo;
  final String? replyToText;
  final String? replyToSender;
  final bool edited;
  final DateTime? editedAt;
  final bool deleted;
  final List<String> deletedBy;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.mediaType,
    this.mediaUrl,
    this.readBy = const [],
    this.reactions = const {},
    this.replyTo,
    this.replyToText,
    this.replyToSender,
    this.edited = false,
    this.editedAt,
    this.deleted = false,
    this.deletedBy = const [],
  });

  // TODO: Create fromFirestore factory with all fields

  bool isDeletedFor(String userId) => deletedBy.contains(userId);
}

// TODO: Chat model
class Chat {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final bool isGroupChat;
  final String? groupName;
  final String? groupPhotoUrl;
  final List<String> admins;

  Chat({
    required this.id,
    required this.participants,
    required this.participantNames,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    required this.isGroupChat,
    this.groupName,
    this.groupPhotoUrl,
    this.admins = const [],
  });

  // TODO: Create fromFirestore factory

  bool isAdmin(String userId) => admins.contains(userId);
}

// TODO: ChatListScreen with chats list
class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // TODO: Setup FCM listener for foreground messages
    _setupPushNotifications();
  }

  Future<void> _setupPushNotifications() async {
    // TODO: Request permission
    // TODO: Get FCM token
    // TODO: Save token to Firestore
    // TODO: Listen to foreground messages
  }

  // TODO: Create new one-on-one chat
  Future<void> _createOneOnOneChat(String partnerId, String partnerName) async {
    // Check if chat already exists
    // If not, create new chat document
    // Navigate to chat screen
  }

  // TODO: Create group chat
  void _showCreateGroupDialog() {
    // Show dialog to select users and enter group name
    // Create group chat document with admins
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          // TODO: Search icon
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          // TODO: More options (logout, settings)
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // TODO: Stream chats where current user is participant
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUser!.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // TODO: Build list of chats
          return Container();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // TODO: New group chat button
          FloatingActionButton(
            heroTag: 'group',
            child: Icon(Icons.group_add),
            onPressed: _showCreateGroupDialog,
          ),
          SizedBox(height: 16),
          // TODO: New chat button
          FloatingActionButton(
            heroTag: 'chat',
            child: Icon(Icons.message),
            onPressed: () {
              // Show user list to start chat
            },
          ),
        ],
      ),
    );
  }
}

// TODO: Enhanced MessageBubble with reactions, reply, actions
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;
  final Chat chat;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
    required this.chat,
  }) : super(key: key);

  // TODO: Show message actions (React, Reply, Forward, Edit, Delete)
  void _showMessageActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: React
              ListTile(
                leading: Icon(Icons.emoji_emotions),
                title: Text('React'),
                onTap: () {},
              ),
              // TODO: Reply
              ListTile(
                leading: Icon(Icons.reply),
                title: Text('Reply'),
                onTap: () {},
              ),
              // TODO: Forward
              ListTile(
                leading: Icon(Icons.forward),
                title: Text('Forward'),
                onTap: () {},
              ),
              // TODO: Edit (only for own messages, within 15 min)
              // TODO: Delete
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if message is deleted for current user
    if (message.isDeletedFor(currentUserId)) {
      return SizedBox.shrink();
    }

    final isSentByMe = message.senderId == currentUserId;

    return GestureDetector(
      onLongPress: () => _showMessageActions(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // TODO: Build message bubble with:
            // - Reply indicator if message is a reply
            // - Media content
            // - Text content
            // - Edited indicator
            // - Reactions
            // - Timestamp
          ],
        ),
      ),
    );
  }
}

// TODO: Enhanced ChatScreen (complete version)
class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatMessage? _replyingTo;
  String? _editingMessageId;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  // TODO: Send message (with reply support)
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessageId != null) {
      // Edit message
      await _editMessage(text);
    } else {
      // Send new message
      await _sendNewMessage(text);
    }
  }

  // TODO: Send new message
  Future<void> _sendNewMessage(String text) async {
    // Create message with replyTo if replying
    // Update chat's lastMessage
    // Send push notification to other participants
  }

  // TODO: Edit message
  Future<void> _editMessage(String newText) async {
    // Update message text, set edited flag
  }

  // TODO: Delete message
  Future<void> _deleteMessage(String messageId, {bool forEveryone = false}) async {
    if (forEveryone) {
      // Set deleted flag
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.chat.id)
          .collection('messages')
          .doc(messageId)
          .update({'deleted': true});
    } else {
      // Add current user to deletedBy array
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.chat.id)
          .collection('messages')
          .doc(messageId)
          .update({
        'deletedBy': FieldValue.arrayUnion([currentUser!.uid]),
      });
    }
  }

  // TODO: Add reaction to message
  Future<void> _addReaction(String messageId, String emoji) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chat.id)
        .collection('messages')
        .doc(messageId)
        .update({
      'reactions.${currentUser!.uid}': emoji,
    });
  }

  // TODO: Search messages
  void _showSearchDialog() {
    // Show dialog with search field
    // Search through messages
  }

  // TODO: Show group info (if group chat)
  void _showGroupInfo() {
    // Show group members
    // Add/remove members (if admin)
    // Leave group
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.isGroupChat
            ? widget.chat.groupName ?? 'Group Chat'
            : widget.chat.participantNames.values.first),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: _showSearchDialog),
          if (widget.chat.isGroupChat)
            IconButton(icon: Icon(Icons.info), onPressed: _showGroupInfo),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(widget.chat.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                // TODO: Build messages list
                return Container();
              },
            ),
          ),

          // Reply indicator
          if (_replyingTo != null) _buildReplyIndicator(),

          // Edit indicator
          if (_editingMessageId != null) _buildEditIndicator(),

          Divider(height: 1),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(Icons.reply, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${_replyingTo!.senderName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _replyingTo!.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() => _replyingTo = null),
          ),
        ],
      ),
    );
  }

  Widget _buildEditIndicator() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.orange[50],
      child: Row(
        children: [
          Icon(Icons.edit, size: 20),
          SizedBox(width: 8),
          Text('Editing message'),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() => _editingMessageId = null);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    // TODO: Same as previous exercises but with reply/edit support
    return Container();
  }
}

// TODO: NotificationService
class NotificationService {
  // TODO: Send push notification to user
  static Future<void> sendNotification({
    required String recipientId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    // Get recipient's FCM token from Firestore
    // Send notification using Firebase Cloud Messaging
    // (Usually done via Cloud Functions for security)
  }
}

/*
IMPLEMENTATION GUIDE:

1. Push Notifications Setup:
   - Add firebase_messaging to pubspec.yaml
   - Request permission: FirebaseMessaging.instance.requestPermission()
   - Get token: FirebaseMessaging.instance.getToken()
   - Save token to Firestore user document
   - Listen to foreground messages:
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       // Show local notification
     })

2. Group Chat Creation:
   await FirebaseFirestore.instance.collection('chats').add({
     'participants': [userId1, userId2, userId3],
     'participantNames': {userId1: name1, userId2: name2, ...},
     'isGroupChat': true,
     'groupName': 'My Group',
     'admins': [currentUserId],
     'createdBy': currentUserId,
     'createdAt': FieldValue.serverTimestamp(),
   });

3. Message Reactions:
   await messageRef.update({
     'reactions.$userId': emoji,
   });

   Display:
   message.reactions.entries.map((e) =>
     Text('${e.value} by ${e.key}')
   )

4. Reply to Message:
   When sending:
   {
     ...otherFields,
     'replyTo': replyToMessageId,
     'replyToText': replyToMessage.text,
     'replyToSender': replyToMessage.senderName,
   }

5. Edit Message:
   Check if message was sent within 15 minutes:
   final canEdit = DateTime.now().difference(message.timestamp).inMinutes < 15;

   Update:
   await messageRef.update({
     'text': newText,
     'edited': true,
     'editedAt': FieldValue.serverTimestamp(),
   });

6. Delete Message:
   For everyone (only if you sent it):
   await messageRef.update({'deleted': true});

   For yourself only:
   await messageRef.update({
     'deletedBy': FieldValue.arrayUnion([currentUserId]),
   });

7. Search Messages:
   // Client-side search (for small chats)
   final searchTerm = 'hello';
   final filteredMessages = allMessages.where((msg) =>
     msg.text.toLowerCase().contains(searchTerm.toLowerCase())
   ).toList();

   // For production, use Algolia or Elasticsearch

8. Block User:
   await FirebaseFirestore.instance
       .collection('users')
       .doc(currentUserId)
       .update({
     'blockedUsers': FieldValue.arrayUnion([userIdToBlock]),
   });

   Then filter chats/messages where sender is not in blockedUsers

9. Firebase Security Rules for Group Chats:
   match /chats/{chatId} {
     allow read, write: if request.auth.uid in resource.data.participants;
   }

   match /messages/{chatId}/messages/{messageId} {
     allow read: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
     allow write: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
   }

10. Cloud Function for Push Notifications (example):
    exports.sendMessageNotification = functions.firestore
      .document('messages/{chatId}/messages/{messageId}')
      .onCreate(async (snap, context) => {
        const message = snap.data();
        const chatId = context.params.chatId;

        // Get chat to find recipients
        const chat = await admin.firestore().collection('chats').doc(chatId).get();
        const recipients = chat.data().participants.filter(id => id !== message.senderId);

        // Get FCM tokens for recipients
        // Send notifications
      });
*/
