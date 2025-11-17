/// Week 27, Exercise 5: Real-Time Chat with Firestore
///
/// ADVANCED LEVEL
///
/// Create a real-time chat application:
/// 1. Multiple chat rooms/channels
/// 2. Real-time message updates with StreamBuilder
/// 3. Send text messages with timestamp
/// 4. Show sender name and profile
/// 5. Order messages by timestamp
/// 6. Typing indicators (optional)
/// 7. Message read status (optional)
/// 8. Auto-scroll to latest message
/// 9. Format timestamps nicely
/// 10. Handle edge cases (empty, loading, errors)
///
/// Learning objectives:
/// - Real-time data synchronization
/// - Chat UI/UX patterns
/// - Firestore queries with ordering
/// - ScrollController usage

import 'package:flutter/material.dart';
// TODO: Add packages: firebase_core, firebase_auth, cloud_firestore

void main() async {
  // TODO: Initialize Firebase
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: ChatRoomScreen(),
    );
  }
}

// TODO: Create Message model
// class Message {
//   final String? id;
//   final String userId;
//   final String userName;
//   final String text;
//   final DateTime timestamp;
//
//   Message({...});
//
//   Map<String, dynamic> toMap() {}
//   factory Message.fromFirestore(DocumentSnapshot doc) {}
// }

// TODO: Create ChatService
// class ChatService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // Send message
//   Future<void> sendMessage(String roomId, String userId, String userName, String text) async {}
//
//   // Watch messages (real-time)
//   Stream<List<Message>> watchMessages(String roomId) {}
//
//   // Get chat rooms
//   Future<List<String>> getChatRooms() async {}
// }

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final String roomId = 'general'; // For now, one room
  final String currentUserId = 'user1';
  final String currentUserName = 'John Doe';

  // TODO: Add message controller
  // TODO: Add ScrollController for auto-scroll

  @override
  void dispose() {
    // TODO: Dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create ChatService instance

    return Scaffold(
      appBar: AppBar(
        title: Text('General Chat'),
      ),
      body: Column(
        children: [
          // TODO: Messages list with StreamBuilder
          Expanded(
            child: StreamBuilder(
              // stream: chatService.watchMessages(roomId),
              stream: null,
              builder: (context, snapshot) {
                // TODO: Handle loading, error, empty states

                // TODO: Display messages in ListView
                // Use ListView.builder with reverse: true for chat

                return Center(child: Text('No messages'));
              },
            ),
          ),

          // TODO: Message input bar
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              children: [
                // TODO: TextField for message input

                // TODO: Send button
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Implement _sendMessage() method
  // - Get text from controller
  // - Send via ChatService
  // - Clear controller
  // - Auto-scroll to bottom

  // TODO: Implement _scrollToBottom() method
  // Use ScrollController to animate to bottom
}

// TODO: Create MessageBubble widget
// - Different style for own messages vs others
// - Show sender name (if not own message)
// - Show timestamp
// - Align right for own messages, left for others
