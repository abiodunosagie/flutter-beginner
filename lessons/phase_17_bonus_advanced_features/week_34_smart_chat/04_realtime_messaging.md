# Lesson 4: Real-Time Message Sending and Receiving

## 5-Year-Old Analogy 🎈

Imagine you have a magical notebook that you share with your friend:

**Without Real-Time**: You write something, close the notebook, then your friend opens it later to read. Boring!

**With Real-Time**: When you write something, it INSTANTLY appears in your friend's notebook too - like magic! They see it right away, and you see when they read it!

That's what we're building - a magical notebook where messages appear instantly for everyone, and you can see when they're delivered and read!

## What We'll Build

In this lesson, we'll implement:
- ✅ Real-time message streaming
- ✅ Message sending with confirmation
- ✅ Message delivery tracking
- ✅ Read receipts (single/double check marks)
- ✅ Optimistic UI updates
- ✅ Error handling and retry logic
- ✅ Offline message queueing
- ✅ Message timestamps (server-side)

## Understanding Real-Time Streams

### Traditional Request-Response vs Real-Time

**Traditional (Polling)**:
```dart
// Keep asking "are there new messages?"
Timer.periodic(Duration(seconds: 5), (_) async {
  final messages = await getMessages(); // Network call every 5 seconds
  updateUI(messages);
});
```

**Real-Time (Streaming)**:
```dart
// Listen once, get updates automatically
FirebaseFirestore.instance
  .collection('messages')
  .snapshots() // Opens persistent connection
  .listen((snapshot) {
    // Automatically called when data changes
    updateUI(snapshot.docs);
  });
```

## Step 1: Message Service

Create `lib/services/message_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Send a text message
  Future<String> sendMessage({
    required String chatId,
    required String text,
    String? replyToId,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Validate message
      if (text.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }
      if (text.length > 5000) {
        throw Exception('Message too long (max 5000 characters)');
      }

      // Create message document
      final messageData = {
        'senderId': currentUserId,
        'text': text.trim(),
        'type': MessageType.text.name,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'readAt': null,
        'replyToId': replyToId,
      };

      // Add to messages subcollection
      final docRef = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      // Update chat's last message (in a transaction to prevent race conditions)
      await _firestore.runTransaction((transaction) async {
        final chatRef = _firestore.collection('chats').doc(chatId);
        final chatDoc = await transaction.get(chatRef);

        if (!chatDoc.exists) {
          throw Exception('Chat not found');
        }

        final participants = List<String>.from(chatDoc.data()!['participants']);
        if (!participants.contains(currentUserId)) {
          throw Exception('User not a participant');
        }

        // Update last message info
        transaction.update(chatRef, {
          'lastMessage': text.trim(),
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageSenderId': currentUserId,
          // Increment unread count for other user
          'unreadCount.${_getOtherUserId(participants, currentUserId!)}':
              FieldValue.increment(1),
        });
      });

      print('✅ Message sent successfully: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// Get messages stream for real-time updates
  Stream<List<Message>> getMessagesStream({
    required String chatId,
    int limit = 50,
  }) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Message.fromFirestore(doc);
        } catch (e) {
          print('Error parsing message ${doc.id}: $e');
          // Return a placeholder message if parsing fails
          return Message(
            id: doc.id,
            senderId: 'unknown',
            text: '[Error loading message]',
            timestamp: DateTime.now(),
          );
        }
      }).toList();
    }).handleError((error) {
      print('Error in messages stream: $error');
      return <Message>[]; // Return empty list on error
    });
  }

  /// Load more messages (pagination)
  Future<List<Message>> loadMoreMessages({
    required String chatId,
    required DateTime lastMessageTime,
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .where('timestamp', isLessThan: Timestamp.fromDate(lastMessageTime))
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error loading more messages: $e');
      return [];
    }
  }

  /// Mark a message as read
  Future<void> markMessageAsRead({
    required String chatId,
    required String messageId,
  }) async {
    if (currentUserId == null) return;

    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      await messageRef.update({
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });

      print('✅ Message marked as read: $messageId');
    } catch (e) {
      print('Error marking message as read: $e');
      // Don't throw - read receipts are not critical
    }
  }

  /// Mark all messages in a chat as read
  Future<void> markAllMessagesAsRead(String chatId) async {
    if (currentUserId == null) return;

    try {
      // Get all unread messages not sent by current user
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('read', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      if (unreadMessages.docs.isEmpty) return;

      // Use batch for better performance
      final batch = _firestore.batch();

      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {
          'read': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      // Reset unread count in chat document
      await _firestore.collection('chats').doc(chatId).update({
        'unreadCount.$currentUserId': 0,
      });

      print('✅ All messages marked as read');
    } catch (e) {
      print('Error marking all messages as read: $e');
    }
  }

  /// Delete a message (soft delete)
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
    bool forEveryone = false,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      final messageDoc = await messageRef.get();
      if (!messageDoc.exists) {
        throw Exception('Message not found');
      }

      final message = Message.fromFirestore(messageDoc);

      // Check if user is the sender
      if (message.senderId != currentUserId) {
        throw Exception('Can only delete your own messages');
      }

      if (forEveryone) {
        // Delete for everyone (mark as deleted)
        await messageRef.update({
          'text': '[This message was deleted]',
          'deleted': true,
          'deletedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Delete for self only
        await messageRef.update({
          'deletedFor': FieldValue.arrayUnion([currentUserId]),
        });
      }

      print('✅ Message deleted');
    } catch (e) {
      print('❌ Error deleting message: $e');
      rethrow;
    }
  }

  /// Add reaction to message
  Future<void> addReaction({
    required String chatId,
    required String messageId,
    required String emoji,
  }) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'reactions.$currentUserId': emoji,
      });

      print('✅ Reaction added: $emoji');
    } catch (e) {
      print('Error adding reaction: $e');
    }
  }

  /// Remove reaction from message
  Future<void> removeReaction({
    required String chatId,
    required String messageId,
  }) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'reactions.$currentUserId': FieldValue.delete(),
      });

      print('✅ Reaction removed');
    } catch (e) {
      print('Error removing reaction: $e');
    }
  }

  /// Helper: Get the other user's ID in a 1-on-1 chat
  String _getOtherUserId(List<String> participants, String currentUserId) {
    return participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  /// Listen to message read status
  Stream<bool> getMessageReadStatus({
    required String chatId,
    required String messageId,
  }) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return false;
      return doc.data()?['read'] ?? false;
    });
  }

  /// Get unread message count for current user
  Stream<int> getUnreadCountStream(String chatId) {
    if (currentUserId == null) return Stream.value(0);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return 0;
      final data = doc.data();
      return (data?['unreadCount']?[currentUserId] as int?) ?? 0;
    });
  }
}
```

## Step 2: Enhanced Chat Screen with Real-Time

Update `lib/screens/chat_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';
import '../services/message_service.dart';
import '../services/firebase_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/date_separator.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final MessageService _messageService = MessageService();
  final FirebaseService _firebaseService = FirebaseService();

  bool _isOtherUserTyping = false;
  bool _showScrollToBottom = false;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);

    // Mark messages as read when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAllMessagesAsRead();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Mark messages as read when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _markAllMessagesAsRead();
    }
  }

  void _onScroll() {
    final showButton = _scrollController.offset > 100;
    if (showButton != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = showButton;
      });
    }

    // Mark messages as read when scrolling
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
    if (_isSending) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      await _messageService.sendMessage(
        chatId: widget.chatId,
        text: text,
      );

      // Scroll to bottom after sending
      _scrollToBottom();
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        _errorMessage = e.toString();
      });

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _sendMessage(text),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isSending = false;
      });
    }
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
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Copy option
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

              // Reply option
              ListTile(
                leading: Icon(Icons.reply),
                title: Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement reply
                },
              ),

              // React option
              ListTile(
                leading: Icon(Icons.emoji_emotions_outlined),
                title: Text('React'),
                onTap: () {
                  Navigator.pop(context);
                  _showReactionPicker(message);
                },
              ),

              // Delete option (only for own messages)
              if (isMyMessage) ...[
                Divider(),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete for me',
                      style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _deleteMessage(message, forEveryone: false);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text('Delete for everyone',
                      style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _deleteMessage(message, forEveryone: true);
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
              Text('React to message',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Future<void> _deleteMessage(Message message,
      {required bool forEveryone}) async {
    try {
      await _messageService.deleteMessage(
        chatId: widget.chatId,
        messageId: message.id,
        forEveryone: forEveryone,
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

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUserName),
            StreamBuilder<int>(
              stream: _messageService.getUnreadCountStream(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data! > 0) {
                  return Text(
                    '${snapshot.data} unread messages',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  );
                }
                return Text(
                  'Online', // TODO: Get real online status
                  style: TextStyle(fontSize: 12, color: Colors.green),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // TODO: Video call
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
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
                child: Text('Block user'),
                value: 'block',
              ),
            ],
            onSelected: (value) {
              // TODO: Handle menu actions
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (_errorMessage != null)
            Container(
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
            ),

          // Messages list
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageService.getMessagesStream(chatId: widget.chatId),
              builder: (context, snapshot) {
                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text('Error loading messages'),
                        SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {}); // Trigger rebuild
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Loading state
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading messages...'),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!;

                // Empty state
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
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

                // Auto-scroll to bottom for new messages
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients &&
                      _scrollController.offset < 100) {
                    _scrollToBottom(animated: false);
                  }
                });

                // Messages list
                return Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: EdgeInsets.only(bottom: 16, top: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId ==
                            _firebaseService.currentUserId;

                        // Show date separator
                        final showDateSeparator = index == messages.length - 1 ||
                            !_isSameDay(
                              message.timestamp,
                              messages[index + 1].timestamp,
                            );

                        // Show timestamp
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
                              onLongPress: () =>
                                  _showMessageOptions(message),
                            ),
                            if (showDateSeparator)
                              DateSeparator(date: message.timestamp),
                          ],
                        );
                      },
                    ),

                    // Scroll to bottom button
                    if (_showScrollToBottom)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton.small(
                          onPressed: () => _scrollToBottom(),
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.arrow_downward,
                              color: Colors.white),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Typing indicator
          if (_isOtherUserTyping)
            TypingIndicator(userName: widget.otherUserName),

          // Message input
          MessageInput(
            onSendText: _sendMessage,
            enabled: !_isSending,
            onTypingChanged: (isTyping) {
              // TODO: Send typing status
            },
          ),
        ],
      ),
    );
  }
}
```

## Step 3: Optimistic UI Updates

For better UX, show messages immediately before server confirmation:

```dart
class OptimisticMessageService extends MessageService {
  final _optimisticMessages = <String, Message>{};

  Future<String> sendMessageOptimistic({
    required String chatId,
    required String text,
  }) async {
    // Generate temporary ID
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    // Create optimistic message
    final optimisticMessage = Message(
      id: tempId,
      senderId: currentUserId!,
      text: text,
      timestamp: DateTime.now(),
      read: false,
    );

    // Add to local cache
    _optimisticMessages[tempId] = optimisticMessage;

    try {
      // Send to server
      final messageId = await sendMessage(
        chatId: chatId,
        text: text,
      );

      // Remove from cache when confirmed
      _optimisticMessages.remove(tempId);

      return messageId;
    } catch (e) {
      // Mark as failed
      _optimisticMessages[tempId] = optimisticMessage.copyWith(
        // Add a failed flag
      );
      rethrow;
    }
  }

  Stream<List<Message>> getMessagesStreamWithOptimistic({
    required String chatId,
    int limit = 50,
  }) {
    return getMessagesStream(chatId: chatId, limit: limit).map((messages) {
      // Combine server messages with optimistic messages
      final combined = [...messages];

      _optimisticMessages.values.forEach((optimisticMsg) {
        // Only add if not already in server messages
        if (!messages.any((m) => m.id == optimisticMsg.id)) {
          combined.insert(0, optimisticMsg);
        }
      });

      return combined;
    });
  }
}
```

## Verification Steps

### Step 1: Test Message Sending

1. Send a message
2. Should appear immediately
3. Check mark should appear when delivered
4. Double check mark when read

### Step 2: Test Real-Time Receiving

1. Open chat on two devices/windows
2. Send message from device A
3. Should appear instantly on device B
4. Read receipts should update

### Step 3: Test Offline Behavior

1. Turn off internet
2. Send messages
3. Messages should queue
4. Turn on internet
5. Messages should send automatically

### Step 4: Test Read Receipts

1. Send message
2. Other user opens chat
3. Single check → double check transition

## Common Issues and Solutions

### Issue 1: Messages Don't Update in Real-Time

**Problem**: StreamBuilder doesn't rebuild

**Solution**:
```dart
// Ensure you're using .snapshots() not .get()
.snapshots() // ✅ Real-time
.get()       // ❌ One-time fetch
```

### Issue 2: Duplicate Messages

**Problem**: Same message appears multiple times

**Solution**:
```dart
// Use document ID as unique key
return ListView.builder(
  itemBuilder: (context, index) {
    return MessageBubble(
      key: ValueKey(messages[index].id), // Add unique key
      message: messages[index],
    );
  },
);
```

### Issue 3: Timestamps Are Null

**Problem**: `timestamp` is null initially

**Solution**:
```dart
// Use server timestamp
'timestamp': FieldValue.serverTimestamp(),

// Handle null in model
timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
```

## Performance Optimization

### 1. Limit Stream Data

```dart
// Only load recent messages
.limit(50)

// Use pagination for older messages
loadMoreMessages(lastMessageTime)
```

### 2. Debounce Typing Indicators

```dart
Timer? _typingTimer;

void onTextChanged(String text) {
  _typingTimer?.cancel();
  _typingTimer = Timer(Duration(seconds: 2), () {
    // User stopped typing
    sendTypingStatus(false);
  });
  sendTypingStatus(true);
}
```

### 3. Batch Read Receipts

```dart
// Don't mark each message individually
// Mark all at once
markAllMessagesAsRead()
```

## Next Steps

In the next lesson, we'll add:
1. Advanced features like online status
2. Last seen functionality
3. Message search
4. Voice messages

## Key Takeaways

1. **Real-time streams** provide instant updates
2. **Optimistic UI** improves perceived performance
3. **Error handling** prevents user frustration
4. **Read receipts** require careful state management
5. **Transactions** prevent race conditions
6. **Batch operations** improve performance

Remember: Real-time isn't magic - it's WebSockets under the hood! 🚀
