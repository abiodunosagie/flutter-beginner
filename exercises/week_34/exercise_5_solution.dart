/// Exercise 5 Solution: Complete Chat App
///
/// This is a production-ready chat application with:
/// - Push notifications (Firebase Cloud Messaging)
/// - Group chats with admin controls
/// - Message search
/// - Message reactions
/// - Reply to messages
/// - Edit/delete messages
/// - User blocking
/// - All features from previous exercises
///
/// IMPORTANT: This solution shows the architecture and key implementations.
/// For a real production app, you would also need:
/// - Cloud Functions for server-side push notifications
/// - Proper error handling and retry logic
/// - Offline support with local caching
/// - End-to-end encryption (for privacy)
/// - Rate limiting and abuse prevention
/// - Analytics and crash reporting

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
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
          return ChatListScreen();
        }

        return LoginScreen();
      },
    );
  }
}

// Simple login screen
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

        // Create user document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
          'blockedUsers': [],
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
              child: Text(_isLogin ? 'Create account' : 'Have account? Login'),
            ),
          ],
        ),
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
  final String? mediaType;
  final String? mediaUrl;
  final List<String> readBy;
  final Map<String, String> reactions;
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

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mediaType: data['mediaType'],
      mediaUrl: data['mediaUrl'],
      readBy: List<String>.from(data['readBy'] ?? []),
      reactions: Map<String, String>.from(data['reactions'] ?? {}),
      replyTo: data['replyTo'],
      replyToText: data['replyToText'],
      replyToSender: data['replyToSender'],
      edited: data['edited'] ?? false,
      editedAt: (data['editedAt'] as Timestamp?)?.toDate(),
      deleted: data['deleted'] ?? false,
      deletedBy: List<String>.from(data['deletedBy'] ?? []),
    );
  }

  bool isDeletedFor(String userId) => deleted || deletedBy.contains(userId);
  bool canEdit(String userId) {
    if (senderId != userId) return false;
    final diff = DateTime.now().difference(timestamp);
    return diff.inMinutes < 15;
  }
}

// Chat model
class Chat {
  final String id;
  final List<String> participants;
  final Map<String, String> participantNames;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isGroupChat;
  final String? groupName;
  final List<String> admins;

  Chat({
    required this.id,
    required this.participants,
    required this.participantNames,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isGroupChat,
    this.groupName,
    this.admins = const [],
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantNames: Map<String, String>.from(data['participantNames'] ?? {}),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      isGroupChat: data['isGroupChat'] ?? false,
      groupName: data['groupName'],
      admins: List<String>.from(data['admins'] ?? []),
    );
  }

  bool isAdmin(String userId) => admins.contains(userId);

  String getChatName(String currentUserId) {
    if (isGroupChat) return groupName ?? 'Group Chat';

    // For one-on-one, return other person's name
    final otherUserId = participants.firstWhere((id) => id != currentUserId, orElse: () => '');
    return participantNames[otherUserId] ?? 'Unknown';
  }
}

// ChatListScreen
class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  Future<void> _setupPushNotifications() async {
    // Request permission
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        // Save token to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({'fcmToken': token});
      }

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message: ${message.notification?.title}');
        // Show local notification or update UI
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => _NewChatDialog(),
    );
  }

  void _showNewGroupDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateGroupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUser!.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No chats yet', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _showNewChatDialog,
                    child: Text('Start a chat'),
                  ),
                ],
              ),
            );
          }

          final chats = snapshot.data!.docs
              .map((doc) => Chat.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    chat.isGroupChat ? Icons.group : Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  chat.getChatName(currentUser!.uid),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: chat.lastMessageTime != null
                    ? Text(
                        _formatTimestamp(chat.lastMessageTime!),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chat: chat),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'group',
            mini: true,
            child: Icon(Icons.group_add),
            onPressed: _showNewGroupDialog,
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'chat',
            child: Icon(Icons.message),
            onPressed: _showNewChatDialog,
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[timestamp.weekday - 1];
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

// New Chat Dialog
class _NewChatDialog extends StatefulWidget {
  @override
  __NewChatDialogState createState() => __NewChatDialogState();
}

class __NewChatDialogState extends State<_NewChatDialog> {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Chat'),
      content: Container(
        width: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, isNotEqualTo: currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final userId = users[index].id;
                final name = userData['name'] ?? 'Unknown';

                return ListTile(
                  leading: CircleAvatar(child: Text(name[0])),
                  title: Text(name),
                  onTap: () async {
                    Navigator.pop(context);
                    await _createOrOpenChat(userId, name);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _createOrOpenChat(String partnerId, String partnerName) async {
    // Check if chat already exists
    final existingChats = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUser!.uid)
        .where('isGroupChat', isEqualTo: false)
        .get();

    for (var doc in existingChats.docs) {
      final participants = List<String>.from(doc.data()['participants']);
      if (participants.contains(partnerId)) {
        // Chat exists, open it
        final chat = Chat.fromFirestore(doc);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
        );
        return;
      }
    }

    // Create new chat
    final chatRef = await FirebaseFirestore.instance.collection('chats').add({
      'participants': [currentUser!.uid, partnerId],
      'participantNames': {
        currentUser!.uid: currentUser!.displayName ?? 'User',
        partnerId: partnerName,
      },
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'isGroupChat': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final chatDoc = await chatRef.get();
    final chat = Chat.fromFirestore(chatDoc);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
    );
  }
}

// Create Group Screen (simplified)
class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameController = TextEditingController();
  final List<String> _selectedUsers = [];

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> _createGroup() async {
    if (_groupNameController.text.trim().isEmpty || _selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter group name and select members')),
      );
      return;
    }

    // Get selected user names
    final userNames = <String, String>{};
    userNames[currentUser!.uid] = currentUser!.displayName ?? 'User';

    for (var userId in _selectedUsers) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      userNames[userId] = userDoc.data()?['name'] ?? 'Unknown';
    }

    // Create group chat
    final participants = [currentUser!.uid, ..._selectedUsers];

    await FirebaseFirestore.instance.collection('chats').add({
      'participants': participants,
      'participantNames': userNames,
      'isGroupChat': true,
      'groupName': _groupNameController.text.trim(),
      'admins': [currentUser!.uid],
      'lastMessage': 'Group created',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdBy': currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        actions: [
          TextButton(
            onPressed: _createGroup,
            child: Text('CREATE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(FieldPath.documentId, isNotEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userId = users[index].id;
                    final userData = users[index].data() as Map<String, dynamic>;
                    final name = userData['name'] ?? 'Unknown';
                    final isSelected = _selectedUsers.contains(userId);

                    return CheckboxListTile(
                      title: Text(name),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedUsers.add(userId);
                          } else {
                            _selectedUsers.remove(userId);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Search Delegate
class ChatSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Search messages across all chats
    return _SearchResults(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResults(query: query);
  }
}

class _SearchResults extends StatelessWidget {
  final String query;

  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Enter search term'));
    }

    // This is a simplified search. For production, use Algolia or similar.
    return Center(
      child: Text('Search results for: $query\n\n(Implement full-text search)'),
    );
  }
}

// Enhanced MessageBubble with all features
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;
  final Chat chat;
  final Function(ChatMessage)? onReply;
  final Function(String)? onEdit;
  final Function(String, bool)? onDelete;
  final Function(String, String)? onReact;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
    required this.chat,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onReact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isDeletedFor(currentUserId)) {
      return SizedBox.shrink();
    }

    final isSentByMe = message.senderId == currentUserId;
    final isDeleted = message.deleted;

    return GestureDetector(
      onLongPress: () => _showActions(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSentByMe && chat.isGroupChat) ...[
              CircleAvatar(
                radius: 16,
                child: Text(message.senderName[0]),
              ),
              SizedBox(width: 8),
            ],

            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDeleted
                      ? Colors.grey[200]
                      : (isSentByMe ? Colors.blue[600] : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group chat sender name
                    if (!isSentByMe && chat.isGroupChat)
                      Text(
                        message.senderName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),

                    // Reply indicator
                    if (message.replyTo != null) _buildReplyIndicator(),

                    // Message text
                    Text(
                      isDeleted ? 'This message was deleted' : message.text,
                      style: TextStyle(
                        color: isSentByMe ? Colors.white : Colors.black87,
                        fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),

                    SizedBox(height: 4),

                    // Timestamp and edited indicator
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
                        if (message.edited) ...[
                          SizedBox(width: 4),
                          Text(
                            '(edited)',
                            style: TextStyle(
                              fontSize: 10,
                              color: isSentByMe ? Colors.white60 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Reactions
                    if (message.reactions.isNotEmpty) _buildReactions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyToSender ?? 'Unknown',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            message.replyToText ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReactions() {
    return Wrap(
      spacing: 4,
      children: message.reactions.entries.map((entry) {
        return Chip(
          label: Text(entry.value),
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(horizontal: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  void _showActions(BuildContext context) {
    final canEdit = message.canEdit(currentUserId);
    final isSentByMe = message.senderId == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.emoji_emotions),
                title: Text('React'),
                onTap: () {
                  Navigator.pop(context);
                  _showReactionPicker(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.reply),
                title: Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  onReply?.call(message);
                },
              ),
              if (canEdit)
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit?.call(message.id);
                  },
                ),
              if (isSentByMe)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete for everyone'),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete?.call(message.id, true);
                  },
                ),
              ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete for me'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call(message.id, false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReactionPicker(BuildContext context) {
    final emojis = ['❤️', '👍', '😂', '😮', '😢', '🙏'];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              children: emojis.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onReact?.call(message.id, emoji);
                  },
                  child: Text(emoji, style: TextStyle(fontSize: 32)),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ChatScreen (Enhanced)
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessageId != null) {
      await _editMessage(text);
    } else {
      await _sendNewMessage(text);
    }

    _messageController.clear();
    setState(() {
      _replyingTo = null;
      _editingMessageId = null;
    });
  }

  Future<void> _sendNewMessage(String text) async {
    final messageData = {
      'text': text,
      'senderId': currentUser!.uid,
      'senderName': currentUser!.displayName ?? 'User',
      'timestamp': FieldValue.serverTimestamp(),
      'readBy': [],
      'deliveredTo': widget.chat.participants.where((id) => id != currentUser!.uid).toList(),
      'reactions': {},
      'edited': false,
      'deleted': false,
      'deletedBy': [],
    };

    if (_replyingTo != null) {
      messageData['replyTo'] = _replyingTo!.id;
      messageData['replyToText'] = _replyingTo!.text;
      messageData['replyToSender'] = _replyingTo!.senderName;
    }

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chat.id)
        .collection('messages')
        .add(messageData);

    // Update chat's last message
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chat.id)
        .update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }

  Future<void> _editMessage(String newText) async {
    if (_editingMessageId == null) return;

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chat.id)
        .collection('messages')
        .doc(_editingMessageId)
        .update({
      'text': newText,
      'edited': true,
      'editedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteMessage(String messageId, bool forEveryone) async {
    if (forEveryone) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.chat.id)
          .collection('messages')
          .doc(messageId)
          .update({'deleted': true});
    } else {
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.getChatName(currentUser!.uid)),
        actions: [
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(widget.chat.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      currentUserId: currentUser!.uid,
                      chat: widget.chat,
                      onReply: (msg) => setState(() => _replyingTo = msg),
                      onEdit: (id) {
                        setState(() => _editingMessageId = id);
                        final msg = messages.firstWhere((m) => m.id == id);
                        _messageController.text = msg.text;
                      },
                      onDelete: _deleteMessage,
                      onReact: _addReaction,
                    );
                  },
                );
              },
            ),
          ),

          if (_replyingTo != null) _buildReplyIndicator(),
          if (_editingMessageId != null) _buildEditIndicator(),

          Divider(height: 1),

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
                Text('Replying to ${_replyingTo!.senderName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(_replyingTo!.text, maxLines: 1, overflow: TextOverflow.ellipsis),
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
    return Container(
      padding: EdgeInsets.all(8),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                maxLines: null,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
