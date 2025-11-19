/// Exercise 3 Solution: Advanced Chat Features
///
/// This solution demonstrates:
/// - Real-time presence tracking (online/offline)
/// - Typing indicators with debouncing
/// - Read receipts (sent, delivered, read)
/// - Last seen timestamps
/// - App lifecycle management for presence
/// - Complex Firestore queries and updates

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

// PresenceManager to handle online/offline status
class PresenceManager {
  static Future<void> setUserOnline(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> setUserOffline(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> setTypingStatus(String userId, String? typingToUserId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'typingTo': typingToUserId,
    });
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
          // Set user online when logged in
          PresenceManager.setUserOnline(snapshot.data!.uid);
          return ChatListScreen();
        }

        return LoginScreen();
      },
    );
  }
}

// LoginScreen (simplified for this exercise)
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;

  Future<void> _submit() async {
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        await credential.user!.updateDisplayName(_nameController.text.trim());

        // Create user document with presence fields
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
          'typingTo': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isLogin)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            if (!_isLogin) SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? 'Create account' : 'Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// ChatListScreen to show list of users with their online status
class ChatListScreen extends StatelessWidget {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  String formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return 'long ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await PresenceManager.setUserOffline(currentUser!.uid);
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, isNotEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return Center(
              child: Text('No other users yet.\nCreate another account to test!'),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;
              final name = userData['name'] ?? 'Unknown';
              final isOnline = userData['isOnline'] ?? false;
              final lastSeenTimestamp = userData['lastSeen'] as Timestamp?;

              String subtitle;
              if (isOnline) {
                subtitle = 'Online';
              } else if (lastSeenTimestamp != null) {
                subtitle = 'Last seen ${formatLastSeen(lastSeenTimestamp.toDate())}';
              } else {
                subtitle = 'Offline';
              }

              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Online indicator (green dot)
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.grey,
                    fontSize: 13,
                  ),
                ),
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

// Enhanced ChatMessage model
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

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      readBy: List<String>.from(data['readBy'] ?? []),
      deliveredTo: List<String>.from(data['deliveredTo'] ?? []),
    );
  }

  bool isReadBy(String userId) => readBy.contains(userId);
  bool isDeliveredTo(String userId) => deliveredTo.contains(userId);
}

// Enhanced MessageBubble with read receipts
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;
  final String chatPartnerId;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
    required this.chatPartnerId,
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
            CircleAvatar(
              backgroundColor: Colors.blue[300],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue[600] : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: isSentByMe ? Radius.circular(18) : Radius.circular(4),
                  bottomRight: isSentByMe ? Radius.circular(4) : Radius.circular(18),
                ),
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

                      // Read receipt indicators for sent messages
                      if (isSentByMe) ...[
                        SizedBox(width: 4),
                        _buildReadReceipt(),
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

  Widget _buildReadReceipt() {
    // Check if message was read by partner
    if (message.isReadBy(chatPartnerId)) {
      // Double blue check - read
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.done_all, size: 14, color: Colors.blue),
        ],
      );
    }

    // Check if message was delivered to partner
    if (message.isDeliveredTo(chatPartnerId)) {
      // Double gray check - delivered
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.done_all, size: 14, color: Colors.white70),
        ],
      );
    }

    // Single gray check - sent
    return Icon(Icons.done, size: 14, color: Colors.white70);
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// Enhanced ChatScreen with typing indicators
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
    WidgetsBinding.instance.addObserver(this);
    _markMessagesAsRead();
    _messageController.addListener(_onTypingChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    PresenceManager.setTypingStatus(currentUser!.uid, null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PresenceManager.setUserOnline(currentUser!.uid);
    } else if (state == AppLifecycleState.paused ||
               state == AppLifecycleState.inactive) {
      PresenceManager.setUserOffline(currentUser!.uid);
    }
  }

  void _onTypingChanged() {
    _typingTimer?.cancel();

    if (_messageController.text.isNotEmpty) {
      PresenceManager.setTypingStatus(currentUser!.uid, widget.chatPartnerId);

      _typingTimer = Timer(Duration(seconds: 2), () {
        PresenceManager.setTypingStatus(currentUser!.uid, null);
      });
    } else {
      PresenceManager.setTypingStatus(currentUser!.uid, null);
    }
  }

  Future<void> _markMessagesAsRead() async {
    final messages = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', isEqualTo: widget.chatPartnerId)
        .get();

    for (var doc in messages.docs) {
      final readBy = List<String>.from(doc.data()['readBy'] ?? []);
      if (!readBy.contains(currentUser!.uid)) {
        await doc.reference.update({
          'readBy': FieldValue.arrayUnion([currentUser!.uid]),
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': text,
        'senderId': currentUser!.uid,
        'senderName': currentUser!.displayName ?? 'User',
        'timestamp': FieldValue.serverTimestamp(),
        'readBy': [],
        'deliveredTo': [widget.chatPartnerId], // Assume immediate delivery
      });

      _messageController.clear();
      PresenceManager.setTypingStatus(currentUser!.uid, null);

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.chatPartnerName),
            _buildStatus(),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .where((msg) =>
                        (msg.senderId == currentUser!.uid &&
                         msg.senderName == widget.chatPartnerName) ||
                        (msg.senderId == widget.chatPartnerId))
                    .toList();

                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      currentUserId: currentUser!.uid,
                      chatPartnerId: widget.chatPartnerId,
                    );
                  },
                );
              },
            ),
          ),

          _buildTypingIndicator(),

          Divider(height: 1),

          _buildMessageInput(),
        ],
      ),
    );
  }

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

        String statusText;
        Color statusColor;

        if (isTyping) {
          statusText = 'typing...';
          statusColor = Colors.blue;
        } else if (isOnline) {
          statusText = 'online';
          statusColor = Colors.green;
        } else {
          final lastSeen = data['lastSeen'] as Timestamp?;
          if (lastSeen != null) {
            final difference = DateTime.now().difference(lastSeen.toDate());
            if (difference.inMinutes < 1) {
              statusText = 'active just now';
            } else if (difference.inHours < 1) {
              statusText = 'active ${difference.inMinutes}m ago';
            } else if (difference.inDays < 1) {
              statusText = 'active ${difference.inHours}h ago';
            } else {
              statusText = 'active ${difference.inDays}d ago';
            }
          } else {
            statusText = 'offline';
          }
          statusColor = Colors.grey;
        }

        return Text(
          statusText,
          style: TextStyle(fontSize: 12, color: statusColor),
        );
      },
    );
  }

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

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${widget.chatPartnerName} is typing',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
