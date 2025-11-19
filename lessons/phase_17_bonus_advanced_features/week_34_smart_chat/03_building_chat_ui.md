# Lesson 3: Building Beautiful Chat UI

## 5-Year-Old Analogy 🎈

Imagine you're making a comic book of your conversations with friends:

**Message Bubbles**: Like speech bubbles in comics - your words go on one side, friend's words on the other
**Colors**: Your bubbles are blue, friend's are gray (so you can tell who said what!)
**Scroll**: Like flipping pages - old messages go up, new ones appear at the bottom
**Input Box**: Like a speech bubble you're still drawing in - type your words here!
**Typing Indicator**: Like seeing your friend's pencil moving - they're writing something!

When you text with friends, it should feel like reading a fun comic book - easy to read, pretty to look at, and exciting when new messages appear!

## What We'll Build

In this lesson, we'll create:
- ✅ Beautiful message bubbles (sent & received)
- ✅ Smart scroll behavior (auto-scroll to latest)
- ✅ Message input field with send button
- ✅ Typing indicators
- ✅ Timestamps and read receipts
- ✅ Loading states
- ✅ Empty state UI
- ✅ Professional animations

## Message Bubble Design Principles

### Good Chat UI Should:
1. **Clearly distinguish** sender vs receiver
2. **Auto-scroll** to newest messages
3. **Group messages** by time/sender
4. **Show status** (sent, delivered, read)
5. **Load quickly** and feel smooth
6. **Work on any screen size**

## Step 1: Message Bubble Widget

Create `lib/widgets/message_bubble.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String? senderName;
  final bool showTimestamp;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.senderName,
    this.showTimestamp = true,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Sender name (for group chats)
              if (!isMe && senderName != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 4),
                  child: Text(
                    senderName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              // Message bubble
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message text
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),

                    // Timestamp and status
                    if (showTimestamp) ...[
                      SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.timestamp),
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey[600],
                              fontSize: 11,
                            ),
                          ),
                          if (isMe) ...[
                            SizedBox(width: 4),
                            Icon(
                              message.read
                                  ? Icons.done_all
                                  : Icons.done,
                              size: 14,
                              color: message.read
                                  ? Colors.lightBlue[100]
                                  : Colors.white.withOpacity(0.7),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today - show time
      return DateFormat.jm().format(timestamp); // "2:30 PM"
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday ${DateFormat.jm().format(timestamp)}';
    } else if (difference.inDays < 7) {
      // This week - show day name
      return '${DateFormat.E().format(timestamp)} ${DateFormat.jm().format(timestamp)}';
    } else {
      // Older - show date
      return DateFormat.MMMd().format(timestamp); // "Jan 15"
    }
  }
}
```

## Step 2: Advanced Message Bubble with Media

Create `lib/widgets/advanced_message_bubble.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';

class AdvancedMessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String? senderName;
  final VoidCallback? onLongPress;
  final VoidCallback? onImageTap;

  const AdvancedMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.senderName,
    this.onLongPress,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Sender name (for group chats)
              if (!isMe && senderName != null)
                Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 4),
                  child: Text(
                    senderName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Message bubble
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media content (image, video, etc.)
                    if (message.type != MessageType.text &&
                        message.mediaUrl != null)
                      _buildMediaContent(context),

                    // Text content
                    if (message.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(message.timestamp),
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                                if (isMe) ...[
                                  SizedBox(width: 4),
                                  Icon(
                                    message.read ? Icons.done_all : Icons.done,
                                    size: 14,
                                    color: message.read
                                        ? Colors.lightBlue[100]
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Reactions
              if (message.reactions != null && message.reactions!.isNotEmpty)
                _buildReactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return GestureDetector(
          onTap: onImageTap,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: message.text.isEmpty
                  ? Radius.circular(isMe ? 20 : 4)
                  : Radius.zero,
              bottomRight: message.text.isEmpty
                  ? Radius.circular(isMe ? 4 : 20)
                  : Radius.zero,
            ),
            child: CachedNetworkImage(
              imageUrl: message.mediaUrl!,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.75,
              height: 200,
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[200],
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
        );

      case MessageType.video:
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.videocam, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        );

      case MessageType.file:
        return Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.insert_drive_file,
                  color: isMe ? Colors.white : Colors.grey[700]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'File attachment',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildReactions() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: message.reactions!.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(entry.value, style: TextStyle(fontSize: 16)),
          );
        }).toList(),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat.jm().format(timestamp);
  }
}
```

## Step 3: Message Input Field

Create `lib/widgets/message_input.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendText;
  final Function(XFile)? onSendImage;
  final Function(bool)? onTypingChanged;
  final bool enabled;

  const MessageInput({
    super.key,
    required this.onSendText,
    this.onSendImage,
    this.onTypingChanged,
    this.enabled = true,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isTyping = _controller.text.trim().isNotEmpty;
    if (isTyping != _isTyping) {
      setState(() {
        _isTyping = isTyping;
      });
      widget.onTypingChanged?.call(isTyping);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSendText(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  Future<void> _pickImage() async {
    if (!widget.enabled || widget.onSendImage == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      widget.onSendImage!(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            if (widget.onSendImage != null)
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                color: Colors.grey[700],
                onPressed: widget.enabled ? _pickImage : null,
              ),

            // Text input
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            SizedBox(width: 8),

            // Send button
            _isTyping
                ? IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: widget.enabled ? _sendMessage : null,
                  )
                : IconButton(
                    icon: Icon(Icons.mic),
                    color: Colors.grey[700],
                    onPressed: widget.enabled ? () {} : null,
                  ),
          ],
        ),
      ),
    );
  }
}
```

## Step 4: Typing Indicator

Create `lib/widgets/typing_indicator.dart`:

```dart
import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final String userName;

  const TypingIndicator({
    super.key,
    required this.userName,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4),
                _buildDot(1),
                SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${widget.userName} is typing...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationValue = _controller.value;
        final delay = index * 0.2;
        final dotAnimation = (animationValue + delay) % 1.0;

        final opacity = dotAnimation < 0.5
            ? (dotAnimation * 2)
            : (2 - dotAnimation * 2);

        return Opacity(
          opacity: opacity.clamp(0.3, 1.0),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
```

## Step 5: Chat Screen with Smart Scrolling

Create `lib/screens/chat_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import '../services/firebase_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';

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

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isOtherUserTyping = false;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Mark messages as read when screen opens
    _markMessagesAsRead();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show "scroll to bottom" button if user scrolled up
    final showButton = _scrollController.offset > 100;
    if (showButton != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = showButton;
      });
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients) {
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
  }

  Future<void> _markMessagesAsRead() async {
    // TODO: Implement mark as read functionality
  }

  Future<void> _sendMessage(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': _firebaseService.currentUserId,
        'text': text,
        'type': MessageType.text.name,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      // Update chat's last message
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': _firebaseService.currentUserId,
      });

      // Auto scroll to bottom after sending
      _scrollToBottom();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUserName),
            Text(
              'Online',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // TODO: Implement voice call
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text('Error loading messages'),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map((doc) => Message.fromFirestore(doc))
                    .toList();

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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Auto-scroll when new message arrives
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
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId ==
                            _firebaseService.currentUserId;

                        // Group messages by time
                        final showTimestamp = index == messages.length - 1 ||
                            messages[index + 1]
                                    .timestamp
                                    .difference(message.timestamp)
                                    .inMinutes >
                                5;

                        return MessageBubble(
                          message: message,
                          isMe: isMe,
                          showTimestamp: showTimestamp,
                          onLongPress: () => _showMessageOptions(message),
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
                          child: Icon(Icons.arrow_downward, color: Colors.white),
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
            onTypingChanged: (isTyping) {
              // TODO: Send typing status to other user
            },
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy'),
                onTap: () {
                  // TODO: Copy message
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.reply),
                title: Text('Reply'),
                onTap: () {
                  // TODO: Reply to message
                  Navigator.pop(context);
                },
              ),
              if (message.senderId == _firebaseService.currentUserId)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    // TODO: Delete message
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
```

## Step 6: Date Separator

Create `lib/widgets/date_separator.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatDate(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(date); // "Monday"
    } else {
      return DateFormat.yMMMd().format(date); // "Jan 15, 2024"
    }
  }
}
```

## Step 7: Enhanced Chat Screen with Date Separators

Update `lib/screens/chat_screen.dart` ListView.builder:

```dart
ListView.builder(
  controller: _scrollController,
  reverse: true,
  padding: EdgeInsets.only(bottom: 16),
  itemCount: messages.length,
  itemBuilder: (context, index) {
    final message = messages[index];
    final isMe = message.senderId == _firebaseService.currentUserId;

    // Check if we need to show date separator
    final showDateSeparator = index == messages.length - 1 ||
        !_isSameDay(
          message.timestamp,
          messages[index + 1].timestamp,
        );

    // Group messages by time
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
        if (showDateSeparator) DateSeparator(date: message.timestamp),
      ],
    );
  },
);

// Helper method
bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
```

## Verification Steps

### Step 1: Test Message Bubbles

Run your app and send some messages:
- [ ] Your messages appear on the right (blue)
- [ ] Other messages appear on the left (gray)
- [ ] Timestamps show correctly
- [ ] Read receipts show (single/double check)

### Step 2: Test Scrolling

- [ ] New messages auto-scroll to bottom
- [ ] Can scroll up to see old messages
- [ ] "Scroll to bottom" button appears when scrolled up
- [ ] Button disappears when at bottom

### Step 3: Test Input Field

- [ ] Can type messages
- [ ] Send button appears when typing
- [ ] Mic button shows when empty
- [ ] Messages send successfully

### Step 4: Test Typing Indicator

- [ ] Typing indicator shows/hides correctly
- [ ] Animation is smooth
- [ ] Doesn't interfere with messages

## Common UI Issues and Solutions

### Issue 1: Messages Don't Auto-Scroll

**Problem**: New messages appear but screen doesn't scroll

**Solution**:
```dart
// Add this after ListView.builder
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (_scrollController.hasClients) {
    _scrollController.jumpTo(0);
  }
});
```

### Issue 2: Keyboard Overlaps Input

**Problem**: Keyboard covers the input field

**Solution**:
```dart
// Wrap scaffold body in Column and use resizeToAvoidBottomInset
Scaffold(
  resizeToAvoidBottomInset: true, // Add this
  body: Column(...),
)
```

### Issue 3: Images Load Slowly

**Problem**: Network images take time to load

**Solution**: Use `CachedNetworkImage`:
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## Performance Tips

### 1. Limit Message Loading

```dart
// Load only recent messages
.limit(50)
```

### 2. Use Pagination

```dart
// Load more when scrolled to top
_scrollController.addListener(() {
  if (_scrollController.offset >=
      _scrollController.position.maxScrollExtent &&
      !_isLoading) {
    _loadMoreMessages();
  }
});
```

### 3. Optimize Images

```dart
final XFile? image = await picker.pickImage(
  source: ImageSource.gallery,
  maxWidth: 1920,
  maxHeight: 1080,
  imageQuality: 85, // Compress to 85%
);
```

## UI Best Practices

### 1. Message Grouping

Group consecutive messages from same sender:
```dart
final shouldShowAvatar = index == 0 ||
    messages[index - 1].senderId != message.senderId;
```

### 2. Smart Timestamps

Show timestamps only when needed:
```dart
final shouldShowTime = index == 0 ||
    messages[index - 1].timestamp.difference(message.timestamp).inMinutes > 5;
```

### 3. Read Receipts

Only show for sent messages:
```dart
if (isMe) {
  Icon(message.read ? Icons.done_all : Icons.done)
}
```

## Next Steps

In the next lesson, we'll implement:
1. Real-time message synchronization
2. Message delivery tracking
3. Online/offline status
4. Last seen functionality

## Key Takeaways

1. **Message bubbles** should clearly distinguish sent vs received
2. **Auto-scrolling** keeps users focused on latest messages
3. **Typing indicators** provide real-time feedback
4. **Performance** matters - limit and paginate messages
5. **UX details** like timestamps and read receipts improve the experience
6. **Error handling** prevents frustration when things fail

Remember: A beautiful UI is useless if it's slow or confusing! 🚀
