/// Exercise 1: Basic Chat UI (Beginner)
///
/// Level: Beginner
/// Estimated Time: 1-2 hours
///
/// Task:
/// Create a beautiful chat interface without any backend. Focus on the UI/UX:
/// - Create message bubble widgets for sent and received messages
/// - Different styles for sent (right, blue) vs received (left, gray) messages
/// - Message input field at the bottom with send button
/// - List of messages that scrolls
/// - User avatars for received messages
/// - Timestamps for each message
/// - Auto-scroll to bottom when new message is added
///
/// Requirements:
/// 1. Create a ChatMessage model class with:
///    - text: String
///    - isSentByMe: bool
///    - timestamp: DateTime
///    - senderName: String
///    - senderAvatar: String (can be URL or initial)
///
/// 2. Create MessageBubble widget:
///    - Shows message text
///    - Different alignment based on isSentByMe
///    - Shows avatar for received messages
///    - Shows timestamp
///    - Rounded corners, proper padding
///
/// 3. Create ChatScreen with:
///    - AppBar with chat partner info
///    - ListView for messages
///    - TextField for input with send button
///    - Ability to add new messages to the list
///
/// Learning Goals:
/// - Widget composition
/// - ListView builders
/// - Custom widgets
/// - State management with StatefulWidget
/// - Alignment and layout

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ChatScreen(),
    );
  }
}

// TODO: Create ChatMessage model class
class ChatMessage {
  // TODO: Add properties: text, isSentByMe, timestamp, senderName, senderAvatar

  // TODO: Add constructor
}

// TODO: Create MessageBubble widget
class MessageBubble extends StatelessWidget {
  // TODO: Add final ChatMessage message property

  // TODO: Add constructor

  @override
  Widget build(BuildContext context) {
    // TODO: Build message bubble UI
    // Hint: Use Row with MainAxisAlignment based on isSentByMe
    // Hint: Use Container with BoxDecoration for the bubble
    // Hint: Show avatar only for received messages
    // Hint: Format timestamp nicely

    return Container(); // Replace with actual implementation
  }
}

// TODO: Create ChatScreen
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // TODO: Create TextEditingController for message input

  // TODO: Create ScrollController for auto-scrolling

  // TODO: Create list of ChatMessage for storing messages
  // Initialize with a few sample messages

  @override
  void initState() {
    super.initState();
    // TODO: Initialize controllers and sample messages
  }

  @override
  void dispose() {
    // TODO: Dispose controllers
    super.dispose();
  }

  // TODO: Create _sendMessage method
  void _sendMessage() {
    // Get text from controller
    // Create new ChatMessage with isSentByMe: true
    // Add to messages list
    // Clear the text field
    // Scroll to bottom
  }

  // TODO: Create _scrollToBottom method
  void _scrollToBottom() {
    // Animate scroll to the end of the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Add AppBar with chat partner info and avatar
      appBar: AppBar(
        // TODO: Add title with chat partner name
        // TODO: Add avatar in leading
        // TODO: Add actions (video call, phone call icons)
      ),

      body: Column(
        children: [
          // TODO: Create Expanded widget with ListView.builder for messages
          // Hint: Use reverse: false and scroll to bottom when new message added

          // TODO: Create Divider

          // TODO: Create message input area with TextField and IconButton
          // Hint: Use Row with Expanded TextField and IconButton
          // Hint: Add nice decoration to TextField
          // Hint: IconButton should call _sendMessage
        ],
      ),
    );
  }

  // TODO: Build message input widget
  Widget _buildMessageInput() {
    return Container(); // Replace with actual implementation
  }
}

// TODO: Create helper method to format DateTime as "HH:MM"
String formatTime(DateTime dateTime) {
  // TODO: Format as "14:30" or "2:30 PM"
  return '';
}

// TODO: Create CircleAvatar widget builder
Widget buildAvatar(String avatarText) {
  // TODO: Create CircleAvatar with text (initials) or image
  return CircleAvatar();
}

/*
HINTS:
1. For message alignment:
   - Sent messages: MainAxisAlignment.end
   - Received messages: MainAxisAlignment.start

2. For message colors:
   - Sent: Colors.blue[600]
   - Received: Colors.grey[300]

3. For rounded corners:
   - Sent: BorderRadius only(topLeft, bottomLeft, topRight)
   - Received: BorderRadius.only(topRight, bottomRight, bottomLeft)

4. Use EdgeInsets for padding inside bubbles

5. For auto-scroll:
   scrollController.animateTo(
     scrollController.position.maxScrollExtent,
     duration: Duration(milliseconds: 300),
     curve: Curves.easeOut,
   )

6. For timestamp formatting:
   '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'

7. Sample initial messages:
   ChatMessage(
     text: 'Hey! How are you?',
     isSentByMe: false,
     timestamp: DateTime.now().subtract(Duration(minutes: 5)),
     senderName: 'John',
     senderAvatar: 'J',
   ),
*/
