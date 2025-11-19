// Exercise 2: Conversational AI (Beginner-Intermediate) - SOLUTION
//
// A complete chat experience with conversation history and streaming responses.
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

/// Model class representing a chat message
class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  /// Convert message to API format
  Map<String, dynamic> toApiFormat() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': text,
    };
  }
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
  String _streamingMessage = '';

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

  /// Sends a message to OpenAI with full conversation history and streaming
  Future<void> _sendMessage(String userMessage) async {
    // Add user message
    setState(() {
      _messages.add(Message(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _streamingMessage = '';
    });

    // Scroll to show new user message
    _scrollToBottom();

    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found in .env file');
      }

      // Build messages array for API with conversation history
      final apiMessages = [
        // System prompt
        {'role': 'system', 'content': _systemPrompt},
        // All conversation history (excluding the welcome message)
        for (var i = 1; i < _messages.length; i++) _messages[i].toApiFormat(),
      ];

      final url = Uri.parse('https://api.openai.com/v1/chat/completions');

      // Create request with streaming enabled
      final request = http.Request('POST', url);
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': apiMessages,
        'max_tokens': 500,
        'temperature': 0.7,
        'stream': true, // Enable streaming
      });

      // Send request and get stream
      final client = http.Client();
      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        throw Exception(
          'API request failed with status: ${streamedResponse.statusCode}',
        );
      }

      // Process the stream
      final completeMessage = StringBuffer();

      await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
        // Parse Server-Sent Events (SSE) format
        final lines = chunk.split('\n');

        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6); // Remove 'data: ' prefix

            if (data == '[DONE]') {
              // Stream complete
              break;
            }

            try {
              final json = jsonDecode(data);
              final delta = json['choices'][0]['delta'];

              if (delta['content'] != null) {
                final content = delta['content'] as String;
                completeMessage.write(content);

                // Update UI with streaming text
                setState(() {
                  _streamingMessage = completeMessage.toString();
                });

                // Auto-scroll as message appears
                _scrollToBottom();
              }
            } catch (e) {
              // Skip malformed JSON chunks
              continue;
            }
          }
        }
      }

      // Add complete AI response to messages
      if (completeMessage.isNotEmpty) {
        setState(() {
          _messages.add(Message(
            text: completeMessage.toString().trim(),
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _streamingMessage = '';
        });
      }

      client.close();
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "Sorry, I encountered an error: $e",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _streamingMessage = '';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  /// Scrolls to the bottom of the messages list
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Clears all messages except the welcome message
  void _clearConversation() {
    setState(() {
      _messages.removeRange(1, _messages.length);
    });
  }

  /// Shows confirmation dialog before clearing conversation
  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation'),
        content: const Text(
          'Are you sure you want to clear the entire conversation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearConversation();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Buddy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _messages.length > 1 ? _showClearConfirmation : null,
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
              itemCount: _messages.length + (_streamingMessage.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                // Show streaming message as last item
                if (index == _messages.length && _streamingMessage.isNotEmpty) {
                  return MessageBubble(
                    message: Message(
                      text: _streamingMessage,
                      isUser: false,
                      timestamp: DateTime.now(),
                    ),
                    isStreaming: true,
                  );
                }

                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading && _streamingMessage.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Buddy is typing...'),
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
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: _messageController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _messageController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    enabled: !_isLoading,
                    onChanged: (value) => setState(() {}),
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
                  onPressed: _isLoading || _messageController.text.trim().isEmpty
                      ? null
                      : () {
                          final text = _messageController.text.trim();
                          _sendMessage(text);
                          _messageController.clear();
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

/// Widget that displays a single chat message bubble
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isStreaming;

  const MessageBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // AI avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple[100],
              child: const Icon(Icons.smart_toy, size: 18, color: Colors.deepPurple),
            ),
            const SizedBox(width: 8),
          ],
          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.deepPurple : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: isUser ? Colors.white70 : Colors.black45,
                          fontSize: 11,
                        ),
                      ),
                      if (isStreaming) ...[
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 8,
                          height: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            // User avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
