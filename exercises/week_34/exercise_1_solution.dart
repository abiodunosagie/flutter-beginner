/// Exercise 1 Solution: Basic Chat UI
///
/// This solution demonstrates:
/// - Clean widget composition with custom MessageBubble widget
/// - Proper state management for chat messages
/// - Beautiful UI with proper alignment and styling
/// - Auto-scrolling when new messages are added
/// - Responsive design that works on different screen sizes

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ChatScreen(),
    );
  }
}

// ChatMessage model class
class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final String senderName;
  final String senderAvatar;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    required this.senderName,
    required this.senderAvatar,
  });
}

// MessageBubble widget
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for received messages
          if (!message.isSentByMe) ...[
            buildAvatar(message.senderAvatar),
            SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isSentByMe
                    ? Colors.blue[600]
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: message.isSentByMe
                      ? Radius.circular(18)
                      : Radius.circular(4),
                  bottomRight: message.isSentByMe
                      ? Radius.circular(4)
                      : Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: message.isSentByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Sender name for received messages
                  if (!message.isSentByMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                  // Message text
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: message.isSentByMe ? Colors.white : Colors.black87,
                    ),
                  ),

                  SizedBox(height: 4),

                  // Timestamp
                  Text(
                    formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: message.isSentByMe
                          ? Colors.white70
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Spacer for sent messages to push them right
          if (message.isSentByMe) SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ChatScreen
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Initialize with sample messages
    _messages.addAll([
      ChatMessage(
        text: 'Hey! How are you?',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        senderName: 'John Doe',
        senderAvatar: 'JD',
      ),
      ChatMessage(
        text: 'I\'m good! Thanks for asking!',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 9)),
        senderName: 'Me',
        senderAvatar: 'M',
      ),
      ChatMessage(
        text: 'Are you free this weekend?',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 8)),
        senderName: 'John Doe',
        senderAvatar: 'JD',
      ),
      ChatMessage(
        text: 'Yes! What did you have in mind?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 7)),
        senderName: 'Me',
        senderAvatar: 'M',
      ),
      ChatMessage(
        text: 'Maybe we could grab coffee and work on that Flutter project?',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        senderName: 'John Doe',
        senderAvatar: 'JD',
      ),
    ]);

    // Scroll to bottom after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isSentByMe: true,
          timestamp: DateTime.now(),
          senderName: 'Me',
          senderAvatar: 'M',
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom after adding message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildAvatar('JD'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Online',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
          ),

          Divider(height: 1),

          // Message input
          _buildMessageInput(),
        ],
      ),
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
            // Emoji button
            IconButton(
              icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey[600]),
              onPressed: () {
                // TODO: Show emoji picker
              },
            ),

            // Text field
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            // Attachment button
            IconButton(
              icon: Icon(Icons.attach_file, color: Colors.grey[600]),
              onPressed: () {
                // TODO: Show attachment options
              },
            ),

            // Send button
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

// Helper method to format DateTime as "HH:MM"
String formatTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

// CircleAvatar widget builder
Widget buildAvatar(String avatarText) {
  return CircleAvatar(
    backgroundColor: Colors.blue[600],
    child: Text(
      avatarText,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
