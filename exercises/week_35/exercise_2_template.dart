// Exercise 2: Conversational AI (Beginner-Intermediate)
//
// Build a real chat experience with conversation history and streaming responses.
//
// Learning Objectives:
// - Maintain conversation history
// - Implement streaming responses (typewriter effect)
// - Use system prompts to give AI personality
// - Build a chat UI with message bubbles
// - Manage scroll position
//
// Prerequisites: Same as Exercise 1 (OpenAI API key in .env)

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversational AI',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

// TODO: Create a Message model class
// Properties needed:
// - String text
// - bool isUser
// - DateTime timestamp
class Message {
  // TODO: Implement Message class
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  // System prompt to give AI a personality
  final String _systemPrompt = '''You are a friendly and helpful AI assistant named "Buddy".
You are enthusiastic, supportive, and explain things clearly.
You use emojis occasionally to be more engaging.
Keep responses concise but informative.''';

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(Message(
      text: "Hi! I'm Buddy, your AI assistant! How can I help you today? 😊",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  // TODO: Implement method to send message with conversation history
  // This should:
  // 1. Add user message to _messages list
  // 2. Create messages array including system prompt and conversation history
  // 3. Make API request with streaming enabled
  // 4. Process the stream and update UI progressively
  // 5. Add complete AI response to _messages list
  //
  // For streaming, use: "stream": true in the request body
  // The response will be Server-Sent Events (SSE) format
  Future<void> _sendMessage(String userMessage) async {
    // TODO: Implement this method

    // Add user message
    setState(() {
      _messages.add(Message(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    // TODO: Scroll to bottom after adding message
    _scrollToBottom();

    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found');
      }

      // TODO: Build messages array for API
      // Include system prompt and all conversation history
      final messages = [
        // System message
        // All previous messages from _messages list
      ];

      // TODO: Make streaming request
      // Use http.Client for streaming
      // Parse SSE (Server-Sent Events) format
      // Update UI progressively as tokens arrive

      // TODO: Add the complete AI response to _messages list

    } catch (e) {
      // TODO: Handle errors
      setState(() {
        _messages.add(Message(
          text: "Sorry, I encountered an error: $e",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // TODO: Implement method to scroll to bottom
  void _scrollToBottom() {
    // TODO: Scroll to bottom of the list
    // Use _scrollController.animateTo or jumpTo
  }

  // TODO: Implement method to clear conversation
  void _clearConversation() {
    // TODO: Clear all messages except welcome message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Buddy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // TODO: Add clear conversation button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Show confirmation dialog
              // Then call _clearConversation()
            },
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Buddy is typing...'),
                ],
              ),
            ),

          // Input area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    enabled: !_isLoading,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty && !_isLoading) {
                        _sendMessage(value.trim());
                        _messageController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading
                      ? null
                      : () {
                          final text = _messageController.text.trim();
                          if (text.isNotEmpty) {
                            _sendMessage(text);
                            _messageController.clear();
                          }
                        },
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// TODO: Create MessageBubble widget to display individual messages
// Should show:
// - Different alignment for user vs AI messages
// - Different colors for user vs AI
// - Timestamp
// - User icon vs AI icon
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement chat bubble UI
    return Container(); // Replace with actual implementation
  }
}
