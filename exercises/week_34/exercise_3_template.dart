/// Exercise 3: Advanced Chat Features (Intermediate)
///
/// Level: Intermediate
/// Estimated Time: 3-4 hours
///
/// Task:
/// Add professional chat features that make your app feel complete:
/// - Typing indicators ("John is typing...")
/// - Read receipts (check marks showing message was read)
/// - Online/offline status for users
/// - Last seen timestamps
/// - Message delivery status
///
/// Requirements:
/// 1. Implement typing indicators that show when someone is typing
/// 2. Add read receipts - single check (delivered), double check (read)
/// 3. Track and display user online/offline status
/// 4. Show "Last seen" timestamp when user is offline
/// 5. Update message status (sent, delivered, read)
///
/// Firestore Structure Updates:
/// users/
///   {userId}/
///     name: string
///     email: string
///     isOnline: bool
///     lastSeen: timestamp
///     typingTo: string? (userId they're typing to, null if not typing)
///
/// messages/
///   {messageId}/
///     text: string
///     senderId: string
///     senderName: string
///     timestamp: timestamp
///     readBy: array<string> (list of userIds who read the message)
///     deliveredTo: array<string> (list of userIds who received it)
///
/// Learning Goals:
/// - Complex state management
/// - Real-time presence detection
/// - Advanced Firestore operations (arrays, updates)
/// - Debouncing user input
/// - Lifecycle management for presence

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
  }
}

// TODO: Create PresenceManager to handle online/offline status
class PresenceManager {
  // TODO: Create method to set user online
  static Future<void> setUserOnline(String userId) async {
    // Update user document: isOnline = true, lastSeen = now
  }

  // TODO: Create method to set user offline
  static Future<void> setUserOffline(String userId) async {
    // Update user document: isOnline = false, lastSeen = now
  }

  // TODO: Create method to update typing status
  static Future<void> setTypingStatus(String userId, String? typingToUserId) async {
    // Update user document: typingTo = typingToUserId (null if stopped typing)
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          // TODO: Set user online when they log in
          // PresenceManager.setUserOnline(snapshot.data!.uid);
          return ChatListScreen();
        }

        return LoginScreen();
      },
    );
  }
}

// TODO: Implement LoginScreen (can reuse from Exercise 2)
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TODO: Implement login/register (same as Exercise 2)
  // Don't forget to create user document with isOnline and lastSeen fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('TODO: Implement login')),
    );
  }
}

// TODO: Create ChatListScreen to show list of users
class ChatListScreen extends StatelessWidget {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // TODO: Set user offline before logging out
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // TODO: Stream all users except current user
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, isNotEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              // TODO: Extract user data
              final name = userData['name'] ?? 'Unknown';
              final isOnline = userData['isOnline'] ?? false;
              final lastSeen = userData['lastSeen'] as Timestamp?;

              return ListTile(
                // TODO: Show avatar with online indicator (green dot)
                leading: Stack(
                  children: [
                    CircleAvatar(child: Text(name[0])),
                    // TODO: Add online indicator (positioned green dot)
                  ],
                ),
                title: Text(name),
                // TODO: Show "Online" or "Last seen..." subtitle
                subtitle: Text('TODO: status'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatPartnerId: userId,
                        chatPartnerName: name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// TODO: Enhanced ChatMessage model
class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final List<String> readBy;
  final List<String> deliveredTo;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.readBy = const [],
    this.deliveredTo = const [],
  });

  // TODO: Create fromFirestore factory
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    // TODO: Parse document including readBy and deliveredTo arrays
    return ChatMessage(
      id: doc.id,
      text: '',
      senderId: '',
      senderName: '',
      timestamp: DateTime.now(),
    );
  }

  // TODO: Create method to check if message was read
  bool isReadBy(String userId) {
    return readBy.contains(userId);
  }

  // TODO: Create method to check if message was delivered
  bool isDeliveredTo(String userId) {
    return deliveredTo.contains(userId);
  }
}

// TODO: Enhanced MessageBubble with read receipts
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.senderId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe) ...[
            CircleAvatar(child: Text(message.senderName[0])),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSentByMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSentByMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),

                      // TODO: Add read receipt indicators for sent messages
                      if (isSentByMe) ...[
                        SizedBox(width: 4),
                        // Show check marks based on message status
                        // Single gray check: sent
                        // Double gray check: delivered
                        // Double blue check: read
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Build read receipt icon
  Widget _buildReadReceipt() {
    // If read by partner: double blue check
    // If delivered: double gray check
    // If just sent: single gray check
    return Icon(Icons.done, size: 14);
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// TODO: Enhanced ChatScreen with typing indicators
class ChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;

  const ChatScreen({
    Key? key,
    required this.chatPartnerId,
    required this.chatPartnerName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _typingTimer;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // TODO: Add observer to detect app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // TODO: Mark messages as read when opening chat
    _markMessagesAsRead();

    // TODO: Listen to text field changes to detect typing
    _messageController.addListener(_onTypingChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    // TODO: Clear typing status
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: Update online status based on app state
    // resumed: online, paused/inactive: offline
  }

  // TODO: Implement typing detection with debouncing
  void _onTypingChanged() {
    // Cancel previous timer
    _typingTimer?.cancel();

    // Set typing status
    // PresenceManager.setTypingStatus(currentUser!.uid, widget.chatPartnerId);

    // Clear typing status after 2 seconds of no typing
    _typingTimer = Timer(Duration(seconds: 2), () {
      // PresenceManager.setTypingStatus(currentUser!.uid, null);
    });
  }

  // TODO: Mark all received messages as read
  Future<void> _markMessagesAsRead() async {
    // Query messages where senderId == chatPartnerId
    // Update readBy array to include current user
  }

  // TODO: Send message with delivery tracking
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // TODO: Create message with deliveredTo array containing chatPartnerId
    // Add message to Firestore
    // Clear typing status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatPartnerName),
            // TODO: Show typing indicator or online status
            _buildStatus(),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // TODO: Stream messages (you might want to filter by chat participants)
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // TODO: Convert to ChatMessage objects
                // TODO: Build ListView with MessageBubble

                return Container();
              },
            ),
          ),

          // TODO: Show typing indicator if partner is typing
          _buildTypingIndicator(),

          Divider(height: 1),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // TODO: Build status widget (online/typing/last seen)
  Widget _buildStatus() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.chatPartnerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null) return SizedBox.shrink();

        final isOnline = data['isOnline'] ?? false;
        final typingTo = data['typingTo'];
        final isTyping = typingTo == currentUser!.uid;

        // TODO: Show "typing..." if user is typing to current user
        // TODO: Show "online" if user is online
        // TODO: Show "last seen ..." if user is offline

        return Text(
          'TODO',
          style: TextStyle(fontSize: 12),
        );
      },
    );
  }

  // TODO: Build typing indicator
  Widget _buildTypingIndicator() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.chatPartnerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final typingTo = data?['typingTo'];
        final isTyping = typingTo == currentUser!.uid;

        if (!isTyping) return SizedBox.shrink();

        // TODO: Show animated typing indicator
        return Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(width: 8),
              Text('${widget.chatPartnerName} is typing'),
              // TODO: Add animated dots
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    // TODO: Same as Exercise 2 but call _sendMessage which includes delivery tracking
    return Container();
  }
}

/*
HINTS:

1. Set user online:
   await FirebaseFirestore.instance.collection('users').doc(userId).update({
     'isOnline': true,
     'lastSeen': FieldValue.serverTimestamp(),
   });

2. Set typing status:
   await FirebaseFirestore.instance.collection('users').doc(userId).update({
     'typingTo': typingToUserId, // or null to clear
   });

3. Add to readBy array:
   await FirebaseFirestore.instance.collection('messages').doc(messageId).update({
     'readBy': FieldValue.arrayUnion([userId]),
   });

4. Format last seen:
   String formatLastSeen(DateTime lastSeen) {
     final now = DateTime.now();
     final difference = now.difference(lastSeen);

     if (difference.inMinutes < 1) return 'just now';
     if (difference.inHours < 1) return '${difference.inMinutes}m ago';
     if (difference.inDays < 1) return '${difference.inHours}h ago';
     return '${difference.inDays}d ago';
   }

5. Read receipts:
   - Not in readBy and not in deliveredTo: single gray check (sent)
   - In deliveredTo but not readBy: double gray check (delivered)
   - In readBy: double blue check (read)

6. Mark messages as read on opening chat:
   final messages = await FirebaseFirestore.instance
       .collection('messages')
       .where('senderId', isEqualTo: chatPartnerId)
       .get();

   for (var doc in messages.docs) {
     if (!(doc.data()['readBy'] as List).contains(currentUser!.uid)) {
       await doc.reference.update({
         'readBy': FieldValue.arrayUnion([currentUser!.uid]),
       });
     }
   }

7. App lifecycle for presence:
   @override
   void didChangeAppLifecycleState(AppLifecycleState state) {
     if (state == AppLifecycleState.resumed) {
       PresenceManager.setUserOnline(currentUser!.uid);
     } else {
       PresenceManager.setUserOffline(currentUser!.uid);
     }
   }

8. Typing debounce pattern:
   Timer? _typingTimer;

   void _onTypingChanged() {
     _typingTimer?.cancel();
     PresenceManager.setTypingStatus(userId, partnerId);

     _typingTimer = Timer(Duration(seconds: 2), () {
       PresenceManager.setTypingStatus(userId, null);
     });
   }
*/
