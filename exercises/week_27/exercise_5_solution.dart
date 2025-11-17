/// Week 27, Exercise 5: Real-Time Chat with Firestore
///
/// ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ChatRoomScreen(),
    );
  }
}

class Message {
  final String? id;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Message({
    this.id,
    required this.userId,
    required this.userName,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(String id, Map<String, dynamic> data) {
    return Message(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'])
          : DateTime.now(),
    );
  }
}

class ChatService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mock messages for demo
  final List<Message> _mockMessages = [
    Message(
      id: '1',
      userId: 'user2',
      userName: 'Jane Smith',
      text: 'Hey everyone!',
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    Message(
      id: '2',
      userId: 'user1',
      userName: 'John Doe',
      text: 'Hi Jane! How are you?',
      timestamp: DateTime.now().subtract(Duration(minutes: 9)),
    ),
    Message(
      id: '3',
      userId: 'user2',
      userName: 'Jane Smith',
      text: 'Great! Working on a Flutter project.',
      timestamp: DateTime.now().subtract(Duration(minutes: 8)),
    ),
  ];

  Future<void> sendMessage(
    String roomId,
    String userId,
    String userName,
    String text,
  ) async {
    // await _db.collection('rooms').doc(roomId).collection('messages').add(
    //   Message(userId: userId, userName: userName, text: text).toMap(),
    // );

    await Future.delayed(Duration(milliseconds: 300));
    _mockMessages.add(Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      text: text,
    ));
  }

  Stream<List<Message>> watchMessages(String roomId) {
    // return _db
    //     .collection('rooms')
    //     .doc(roomId)
    //     .collection('messages')
    //     .orderBy('timestamp', descending: false)
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.id, doc.data())).toList());

    return Stream.periodic(
      Duration(milliseconds: 100),
      (_) => List<Message>.from(_mockMessages),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final String roomId = 'general';
  final String currentUserId = 'user1';
  final String currentUserName = 'John Doe';

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _chatService = ChatService();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('General Chat'),
            Text(
              '3 members online',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.watchMessages(roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text('Be the first to say hi!'),
                      ],
                    ),
                  );
                }

                // Auto-scroll to bottom on new messages
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isOwnMessage = message.userId == currentUserId;

                    return MessageBubble(
                      message: message,
                      isOwnMessage: isOwnMessage,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Clear input immediately for better UX
    _messageController.clear();

    try {
      await _chatService.sendMessage(
        roomId,
        currentUserId,
        currentUserName,
        text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isOwnMessage;

  const MessageBubble({
    required this.message,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isOwnMessage ? Colors.teal : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isOwnMessage ? Radius.circular(16) : Radius.circular(4),
            bottomRight: isOwnMessage ? Radius.circular(4) : Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isOwnMessage)
              Text(
                message.userName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            if (!isOwnMessage) SizedBox(height: 4),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: isOwnMessage ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: isOwnMessage ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (messageDate == today) {
      return timeStr;
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday $timeStr';
    } else {
      return '${dateTime.day}/${dateTime.month} $timeStr';
    }
  }
}
