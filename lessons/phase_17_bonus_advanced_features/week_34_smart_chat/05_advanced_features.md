# Lesson 5: Advanced Chat Features

## 5-Year-Old Analogy 🎈

Imagine your toy walkie-talkie has special features:

**Online Status**: A green light shows when your friend is holding their walkie-talkie
**Last Seen**: "Last played: 5 minutes ago" - you know when they last used it
**Read Receipts**: When your friend listens to your message, their walkie-talkie sends back "Message heard!"
**Reactions**: Instead of saying words, you can press emoji buttons - ❤️ 😂 👍
**Typing Indicator**: The walkie-talkie beeps when your friend is about to speak

These features make chatting more fun and let you know what's happening with your friends!

## What We'll Build

In this lesson, we'll implement:
- ✅ Online/Offline status (real-time presence)
- ✅ Last seen timestamp
- ✅ Read receipts (delivered/read)
- ✅ Message reactions (emoji)
- ✅ Typing indicators
- ✅ User blocking
- ✅ Message forwarding
- ✅ Message pinning

## Step 1: Presence Service (Online Status)

Create `lib/services/presence_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PresenceService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDb = FirebaseDatabase.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Initialize presence tracking
  /// Uses Firebase Realtime Database for real-time presence
  Future<void> initializePresence() async {
    if (currentUserId == null) return;

    try {
      final presenceRef = _realtimeDb.ref('presence/$currentUserId');

      // Set online status
      await presenceRef.set({
        'status': 'online',
        'lastSeen': ServerValue.timestamp,
      });

      // Update Firestore as well (for queries)
      await _firestore.collection('users').doc(currentUserId).update({
        'status': 'online',
        'lastSeen': FieldValue.serverTimestamp(),
      });

      // Set up automatic offline status on disconnect
      presenceRef.onDisconnect().set({
        'status': 'offline',
        'lastSeen': ServerValue.timestamp,
      }).then((_) {
        print('✅ Presence tracking initialized');
      });

      // Also update Firestore on disconnect
      final firestoreRef = _firestore.collection('users').doc(currentUserId);
      // Note: Firestore doesn't have onDisconnect, so we use RTDB as source of truth
      // and sync to Firestore periodically or on app state changes

    } catch (e) {
      print('❌ Error initializing presence: $e');
    }
  }

  /// Update user status
  Future<void> updateStatus(String status) async {
    if (currentUserId == null) return;

    try {
      // Update Realtime Database
      await _realtimeDb.ref('presence/$currentUserId').update({
        'status': status,
        'lastSeen': ServerValue.timestamp,
      });

      // Update Firestore
      await _firestore.collection('users').doc(currentUserId).update({
        'status': status,
        'lastSeen': FieldValue.serverTimestamp(),
      });

      print('✅ Status updated: $status');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  /// Get user's online status stream
  Stream<Map<String, dynamic>> getUserPresence(String userId) {
    return _realtimeDb
        .ref('presence/$userId')
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return {
          'status': 'offline',
          'lastSeen': null,
        };
      }

      return {
        'status': data['status'] ?? 'offline',
        'lastSeen': data['lastSeen'],
      };
    });
  }

  /// Check if user is online (one-time check)
  Future<bool> isUserOnline(String userId) async {
    try {
      final snapshot = await _realtimeDb.ref('presence/$userId').get();
      if (!snapshot.exists) return false;

      final data = snapshot.value as Map<dynamic, dynamic>;
      return data['status'] == 'online';
    } catch (e) {
      print('Error checking online status: $e');
      return false;
    }
  }

  /// Get last seen timestamp
  Future<DateTime?> getLastSeen(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      final data = doc.data();
      final lastSeen = data?['lastSeen'] as Timestamp?;
      return lastSeen?.toDate();
    } catch (e) {
      print('Error getting last seen: $e');
      return null;
    }
  }

  /// Set user as online
  Future<void> goOnline() => updateStatus('online');

  /// Set user as offline
  Future<void> goOffline() => updateStatus('offline');

  /// Set user as away
  Future<void> goAway() => updateStatus('away');

  /// Clean up presence tracking
  Future<void> dispose() async {
    if (currentUserId == null) return;

    try {
      await goOffline();
    } catch (e) {
      print('Error disposing presence: $e');
    }
  }
}
```

## Step 2: Typing Indicator Service

Create `lib/services/typing_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class TypingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Timer? _typingTimer;

  /// Send typing status
  Future<void> setTyping({
    required String chatId,
    required bool isTyping,
  }) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('typing')
          .doc(currentUserId)
          .set({
        'isTyping': isTyping,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Auto-clear typing status after 3 seconds
      if (isTyping) {
        _typingTimer?.cancel();
        _typingTimer = Timer(Duration(seconds: 3), () {
          setTyping(chatId: chatId, isTyping: false);
        });
      }
    } catch (e) {
      print('Error setting typing status: $e');
    }
  }

  /// Get typing status for other users in chat
  Stream<List<String>> getTypingUsers({
    required String chatId,
  }) {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('typing')
        .where('isTyping', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUserId) // Exclude self
          .where((doc) {
            // Only include recent typing indicators (< 5 seconds old)
            final timestamp = doc.data()['timestamp'] as Timestamp?;
            if (timestamp == null) return false;

            final age = DateTime.now().difference(timestamp.toDate());
            return age.inSeconds < 5;
          })
          .map((doc) => doc.id)
          .toList();
    });
  }

  /// Clear typing status
  Future<void> clearTyping(String chatId) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('typing')
          .doc(currentUserId)
          .delete();

      _typingTimer?.cancel();
    } catch (e) {
      print('Error clearing typing status: $e');
    }
  }

  void dispose() {
    _typingTimer?.cancel();
  }
}
```

## Step 3: Block User Service

Create `lib/services/block_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlockService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Block a user
  Future<void> blockUser(String userId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    if (userId == currentUserId) {
      throw Exception('Cannot block yourself');
    }

    try {
      await _firestore
          .collection('blockedUsers')
          .doc(currentUserId)
          .collection('blocked')
          .doc(userId)
          .set({
        'blockedAt': FieldValue.serverTimestamp(),
      });

      print('✅ User blocked: $userId');
    } catch (e) {
      print('❌ Error blocking user: $e');
      rethrow;
    }
  }

  /// Unblock a user
  Future<void> unblockUser(String userId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('blockedUsers')
          .doc(currentUserId)
          .collection('blocked')
          .doc(userId)
          .delete();

      print('✅ User unblocked: $userId');
    } catch (e) {
      print('❌ Error unblocking user: $e');
      rethrow;
    }
  }

  /// Check if a user is blocked
  Future<bool> isBlocked(String userId) async {
    if (currentUserId == null) return false;

    try {
      final doc = await _firestore
          .collection('blockedUsers')
          .doc(currentUserId)
          .collection('blocked')
          .doc(userId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking block status: $e');
      return false;
    }
  }

  /// Check if current user is blocked by another user
  Future<bool> isBlockedBy(String userId) async {
    if (currentUserId == null) return false;

    try {
      final doc = await _firestore
          .collection('blockedUsers')
          .doc(userId)
          .collection('blocked')
          .doc(currentUserId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if blocked by user: $e');
      return false;
    }
  }

  /// Get list of blocked users
  Stream<List<String>> getBlockedUsers() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('blockedUsers')
        .doc(currentUserId)
        .collection('blocked')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  /// Get count of blocked users
  Future<int> getBlockedUserCount() async {
    if (currentUserId == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('blockedUsers')
          .doc(currentUserId)
          .collection('blocked')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting blocked user count: $e');
      return 0;
    }
  }
}
```

## Step 4: Enhanced Chat Screen with All Features

Update `lib/screens/chat_screen.dart` to include all features:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';
import '../services/message_service.dart';
import '../services/presence_service.dart';
import '../services/typing_service.dart';
import '../services/block_service.dart';
import '../services/firebase_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/date_separator.dart';
import 'package:intl/intl.dart';

class EnhancedChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const EnhancedChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<EnhancedChatScreen> createState() => _EnhancedChatScreenState();
}

class _EnhancedChatScreenState extends State<EnhancedChatScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final MessageService _messageService = MessageService();
  final PresenceService _presenceService = PresenceService();
  final TypingService _typingService = TypingService();
  final BlockService _blockService = BlockService();
  final FirebaseService _firebaseService = FirebaseService();

  bool _showScrollToBottom = false;
  bool _isSending = false;
  bool _isBlocked = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    _checkBlockStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAllMessagesAsRead();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _typingService.clearTyping(widget.chatId);
    _typingService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _markAllMessagesAsRead();
    } else if (state == AppLifecycleState.paused) {
      _typingService.clearTyping(widget.chatId);
    }
  }

  Future<void> _checkBlockStatus() async {
    final blocked = await _blockService.isBlocked(widget.otherUserId);
    final blockedBy = await _blockService.isBlockedBy(widget.otherUserId);

    setState(() {
      _isBlocked = blocked || blockedBy;
    });
  }

  void _onScroll() {
    final showButton = _scrollController.offset > 100;
    if (showButton != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = showButton;
      });
    }

    if (_scrollController.offset < 50) {
      _markAllMessagesAsRead();
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;

    if (animated) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _markAllMessagesAsRead() async {
    try {
      await _messageService.markAllMessagesAsRead(widget.chatId);
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_isSending || _isBlocked) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      await _messageService.sendMessage(
        chatId: widget.chatId,
        text: text,
      );

      // Clear typing indicator
      _typingService.clearTyping(widget.chatId);

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _handleTypingChanged(bool isTyping) {
    _typingService.setTyping(
      chatId: widget.chatId,
      isTyping: isTyping,
    );
  }

  String _formatLastSeen(int? timestamp) {
    if (timestamp == null) return 'Last seen recently';

    final lastSeen = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'Last seen just now';
    } else if (difference.inMinutes < 60) {
      return 'Last seen ${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return 'Last seen ${difference.inHours} hours ago';
    } else {
      return 'Last seen ${DateFormat.yMMMd().format(lastSeen)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Map<String, dynamic>>(
          stream: _presenceService.getUserPresence(widget.otherUserId),
          builder: (context, snapshot) {
            final presence = snapshot.data;
            final isOnline = presence?['status'] == 'online';
            final lastSeen = presence?['lastSeen'] as int?;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.otherUserName),
                    if (isOnline) ...[
                      SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  isOnline ? 'Online' : _formatLastSeen(lastSeen),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOnline ? Colors.green : Colors.grey[600],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _isBlocked ? null : () {
              // TODO: Video call
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: _isBlocked ? null : () {
              // TODO: Voice call
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('View profile'),
                value: 'profile',
              ),
              PopupMenuItem(
                child: Text('Mute notifications'),
                value: 'mute',
              ),
              PopupMenuItem(
                child: Text(_isBlocked ? 'Unblock user' : 'Block user'),
                value: 'block',
              ),
              PopupMenuItem(
                child: Text('Clear chat', style: TextStyle(color: Colors.red)),
                value: 'clear',
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'block':
                  await _handleBlockUser();
                  break;
                case 'clear':
                  await _handleClearChat();
                  break;
                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: _isBlocked
          ? _buildBlockedUI()
          : Column(
              children: [
                if (_errorMessage != null) _buildErrorBanner(),
                Expanded(child: _buildMessagesList()),
                _buildTypingIndicator(),
                MessageInput(
                  onSendText: _sendMessage,
                  enabled: !_isSending,
                  onTypingChanged: _handleTypingChanged,
                ),
              ],
            ),
    );
  }

  Widget _buildBlockedUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'User Blocked',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You cannot send or receive messages',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleBlockUser,
            child: Text('Unblock User'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.red[100],
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[900]),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<List<Message>>(
      stream: _messageService.getMessagesStream(chatId: widget.chatId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Error loading messages'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!;

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Send a message to start the conversation',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients &&
              _scrollController.offset < 100) {
            _scrollToBottom(animated: false);
          }
        });

        return Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.only(bottom: 16, top: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == _firebaseService.currentUserId;

                final showDateSeparator = index == messages.length - 1 ||
                    !_isSameDay(
                      message.timestamp,
                      messages[index + 1].timestamp,
                    );

                final showTimestamp = index == messages.length - 1 ||
                    messages[index + 1]
                            .timestamp
                            .difference(message.timestamp)
                            .inMinutes >
                        5;

                return Column(
                  children: [
                    MessageBubble(
                      message: message,
                      isMe: isMe,
                      showTimestamp: showTimestamp,
                      onLongPress: () => _showMessageOptions(message),
                    ),
                    if (showDateSeparator)
                      DateSeparator(date: message.timestamp),
                  ],
                );
              },
            ),
            if (_showScrollToBottom)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: () => _scrollToBottom(),
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.arrow_downward, color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return StreamBuilder<List<String>>(
      stream: _typingService.getTypingUsers(chatId: widget.chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }

        return TypingIndicator(userName: widget.otherUserName);
      },
    );
  }

  void _showMessageOptions(Message message) {
    final isMyMessage = message.senderId == _firebaseService.currentUserId;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.text));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Message copied')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.emoji_emotions_outlined),
                title: Text('React'),
                onTap: () {
                  Navigator.pop(context);
                  _showReactionPicker(message);
                },
              ),
              ListTile(
                leading: Icon(Icons.reply),
                title: Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.forward),
                title: Text('Forward'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (isMyMessage) ...[
                Divider(),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _deleteMessage(message);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showReactionPicker(Message message) {
    final reactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'React to message',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: reactions.map((emoji) {
                  return GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      await _messageService.addReaction(
                        chatId: widget.chatId,
                        messageId: message.id,
                        emoji: emoji,
                      );
                    },
                    child: Text(emoji, style: TextStyle(fontSize: 40)),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteMessage(Message message) async {
    try {
      await _messageService.deleteMessage(
        chatId: widget.chatId,
        messageId: message.id,
        forEveryone: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete message'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleBlockUser() async {
    try {
      if (_isBlocked) {
        await _blockService.unblockUser(widget.otherUserId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User unblocked')),
        );
      } else {
        await _blockService.blockUser(widget.otherUserId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User blocked')),
        );
      }
      await _checkBlockStatus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to ${_isBlocked ? "unblock" : "block"} user'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleClearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear chat?'),
        content: Text('This will delete all messages. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // TODO: Implement clear chat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chat cleared')),
      );
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
```

## Verification Steps

### Test Online Status
1. Open app on two devices
2. Online indicator should show green
3. Close app on one device
4. "Last seen" should appear

### Test Typing Indicator
1. Start typing on device A
2. Should show "typing..." on device B
3. Stop typing - indicator disappears

### Test Read Receipts
1. Send message
2. Single check appears (delivered)
3. Recipient opens chat
4. Double check appears (read)

### Test Reactions
1. Long-press message
2. Select reaction emoji
3. Emoji appears below message

### Test Blocking
1. Block user
2. Cannot send/receive messages
3. Unblock to restore chat

## Key Takeaways

1. **Presence** requires Firebase Realtime Database for true real-time updates
2. **Typing indicators** should auto-expire to avoid stale state
3. **Read receipts** improve communication transparency
4. **Reactions** provide quick, expressive responses
5. **Blocking** is essential for user safety

Remember: Advanced features make your app feel professional! 🚀
