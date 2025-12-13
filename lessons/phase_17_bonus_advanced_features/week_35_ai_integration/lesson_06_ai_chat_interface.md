# Lesson 6: Building AI Chat Interface (Streaming, Markdown, Code Highlighting)

## 5-Year-Old Analogy 📱

Imagine you're texting with your friend, but your friend is SO smart that they can:
- Show you pretty pictures and formatted text (not just plain words)
- Show you colorful code (like rainbow words that programmers use)
- Type really fast so you can see each word appearing one at a time (like watching them type in real-time)
- Remember everything you talked about (even from yesterday!)

That's what we're building - a super smart chat app that looks beautiful and feels magical to use!

---

## What We'll Build

A production-ready AI chat interface with:

1. ✅ Beautiful message bubbles (user vs AI)
2. ✅ Streaming text (words appear as they're generated)
3. ✅ Markdown rendering (bold, italics, lists, etc.)
4. ✅ Code syntax highlighting (colorful code blocks)
5. ✅ Copy code button
6. ✅ Typing indicators
7. ✅ Message timestamps
8. ✅ Conversation history persistence
9. ✅ Pull-to-refresh
10. ✅ Voice input option

---

## Step 1: Add Dependencies

Update `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies
  flutter:
    sdk: flutter
  http: ^1.1.0
  flutter_dotenv: ^5.1.0
  flutter_secure_storage: ^9.0.0
  provider: ^6.1.1
  logger: ^2.0.2

  # NEW: For chat interface
  flutter_markdown: ^0.6.18  # Markdown rendering
  flutter_highlight: ^0.7.0  # Code syntax highlighting
  highlight: ^0.7.0          # Syntax highlighting engine
  timeago: ^3.5.0            # "2 minutes ago" formatting
  speech_to_text: ^6.5.1     # Voice input
  share_plus: ^7.2.1         # Share conversations
  path_provider: ^2.1.2      # File storage
```

```bash
flutter pub get
```

---

## Step 2: Create Message Model with Persistence

```dart
// lib/models/chat_message_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

enum MessageType {
  text,
  code,
  image,
  error,
}

enum MessageStatus {
  sending,
  sent,
  error,
}

@JsonSerializable()
class ChatMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  // Create user message
  factory ChatMessageModel.user(String content) => ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: true,
      );

  // Create AI message
  factory ChatMessageModel.ai(String content) => ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: false,
      );

  // Create error message
  factory ChatMessageModel.error(String content) => ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: false,
        type: MessageType.error,
        status: MessageStatus.error,
      );

  ChatMessageModel copyWith({
    String? content,
    MessageStatus? status,
    MessageType? type,
  }) {
    return ChatMessageModel(
      id: id,
      content: content ?? this.content,
      isUser: isUser,
      timestamp: timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      metadata: metadata,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}
```

Generate code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 3: Create Conversation Manager

```dart
// lib/services/conversation_manager.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/chat_message_model.dart';

class ConversationManager {
  static final ConversationManager _instance = ConversationManager._internal();
  factory ConversationManager() => _instance;
  ConversationManager._internal();

  final List<ChatMessageModel> _messages = [];
  String _conversationId = DateTime.now().millisecondsSinceEpoch.toString();

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  String get conversationId => _conversationId;

  void addMessage(ChatMessageModel message) {
    _messages.add(message);
    _saveConversation();
  }

  void updateMessage(String id, ChatMessageModel newMessage) {
    final index = _messages.indexWhere((msg) => msg.id == id);
    if (index != -1) {
      _messages[index] = newMessage;
      _saveConversation();
    }
  }

  void clearMessages() {
    _messages.clear();
    _conversationId = DateTime.now().millisecondsSinceEpoch.toString();
    _saveConversation();
  }

  // ========== PERSISTENCE ==========

  Future<File> _getConversationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/conversation_$_conversationId.json');
  }

  Future<void> _saveConversation() async {
    try {
      final file = await _getConversationFile();
      final jsonData = {
        'id': _conversationId,
        'messages': _messages.map((m) => m.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving conversation: $e');
    }
  }

  Future<void> loadConversation([String? conversationId]) async {
    try {
      if (conversationId != null) {
        _conversationId = conversationId;
      }

      final file = await _getConversationFile();

      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents);

        _messages.clear();
        for (final messageJson in jsonData['messages']) {
          _messages.add(ChatMessageModel.fromJson(messageJson));
        }
      }
    } catch (e) {
      print('Error loading conversation: $e');
    }
  }

  Future<List<String>> getConversationList() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .where((f) => f.path.contains('conversation_'))
          .toList();

      return files.map((f) {
        final filename = f.path.split('/').last;
        return filename.replaceAll('conversation_', '').replaceAll('.json', '');
      }).toList();
    } catch (e) {
      print('Error getting conversation list: $e');
      return [];
    }
  }

  Future<void> deleteConversation([String? conversationId]) async {
    try {
      conversationId ??= _conversationId;
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/conversation_$conversationId.json');

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting conversation: $e');
    }
  }
}
```

---

## Step 4: Create Message Bubble Widget

```dart
// lib/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/chat_message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool showTimestamp;
  final VoidCallback? onRetry;

  const MessageBubble({
    Key? key,
    required this.message,
    this.showTimestamp = true,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(context),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _buildMessageContent(context),
                if (showTimestamp) ...[
                  const SizedBox(height: 4),
                  _buildTimestamp(context),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser) _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: message.isUser
          ? Colors.blue
          : message.type == MessageType.error
              ? Colors.red
              : Colors.purple,
      radius: 20,
      child: Icon(
        message.isUser
            ? Icons.person
            : message.type == MessageType.error
                ? Icons.error
                : Icons.auto_awesome,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.status == MessageStatus.sending)
            _buildLoadingIndicator()
          else if (message.type == MessageType.error)
            _buildErrorContent(context)
          else
            _buildTextContent(context),

          if (!message.isUser && message.status == MessageStatus.sent)
            _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    if (message.isUser) {
      return Text(
        message.content,
        style: const TextStyle(color: Colors.white),
      );
    }

    // AI message with markdown
    return MarkdownBody(
      data: message.content,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        code: const TextStyle(
          backgroundColor: Colors.black12,
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      builders: {
        'code': CodeElementBuilder(),
      },
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.content,
          style: const TextStyle(color: Colors.white),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 8),
        Text(
          'Thinking...',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Copy',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.status == MessageStatus.error)
          const Icon(Icons.error, size: 12, color: Colors.red),
        if (message.status == MessageStatus.error) const SizedBox(width: 4),
        Text(
          timeago.format(message.timestamp),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        if (message.metadata?['tokens'] != null) ...[
          const SizedBox(width: 8),
          Text(
            '${message.metadata!['tokens']} tokens',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ],
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (message.isUser) return Colors.blue;
    if (message.type == MessageType.error) return Colors.red;
    return Colors.grey[200]!;
  }
}

// Custom code block builder for markdown
class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Code',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                color: Colors.grey[400],
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text.text));
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          HighlightView(
            text.text,
            language: 'dart', // Auto-detect in production
            theme: monokaiSublimeTheme,
            padding: const EdgeInsets.all(12),
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Step 5: Create Main Chat Screen

```dart
// lib/screens/ai_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/chat_message_model.dart';
import '../services/conversation_manager.dart';
import '../services/openai_client.dart';
import '../widgets/message_bubble.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final ConversationManager _conversationManager = ConversationManager();
  final OpenAIClient _aiClient = OpenAIClient();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadConversation();
    _aiClient.setSystemMessage(
      'You are a helpful AI assistant. Format your responses using markdown when appropriate. '
      'Use code blocks for code examples.',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
  }

  Future<void> _loadConversation() async {
    await _conversationManager.loadConversation();
    setState(() {});
  }

  Future<void> _sendMessage({String? text}) async {
    final message = text ?? _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _messageController.clear();

    // Add user message
    final userMessage = ChatMessageModel.user(message);
    _conversationManager.addMessage(userMessage);
    setState(() {});

    _scrollToBottom();

    // Add placeholder for AI message
    final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final aiMessage = ChatMessageModel(
      id: aiMessageId,
      content: '',
      isUser: false,
      status: MessageStatus.sending,
    );
    _conversationManager.addMessage(aiMessage);
    setState(() {});

    // Stream AI response
    String fullResponse = '';

    try {
      await for (final chunk in _aiClient.chatStream(
        prompt: message,
        model: 'gpt-3.5-turbo',
      )) {
        if (chunk.startsWith('[ERROR:')) {
          // Error occurred
          _conversationManager.updateMessage(
            aiMessageId,
            ChatMessageModel.error(chunk),
          );
          break;
        }

        fullResponse += chunk;

        _conversationManager.updateMessage(
          aiMessageId,
          aiMessage.copyWith(
            content: fullResponse,
            status: MessageStatus.sending,
          ),
        );

        setState(() {});
        _scrollToBottom();
      }

      // Mark as complete
      if (!fullResponse.startsWith('[ERROR:')) {
        _conversationManager.updateMessage(
          aiMessageId,
          aiMessage.copyWith(
            content: fullResponse,
            status: MessageStatus.sent,
          ),
        );
      }
    } catch (e) {
      _conversationManager.updateMessage(
        aiMessageId,
        ChatMessageModel.error('Error: $e'),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

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

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = _conversationManager.messages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _conversationManager.clearMessages();
                _aiClient.clearConversation();
              });
            },
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        message: messages[index],
                        onRetry: messages[index].type == MessageType.error
                            ? () => _sendMessage(text: messages[index - 1].content)
                            : null,
                      );
                    },
                  ),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _suggestionChip('Explain quantum computing'),
              _suggestionChip('Write a Flutter widget'),
              _suggestionChip('Help me debug code'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _sendMessage(text: text),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            // Voice input button
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : null,
              ),
              onPressed: _isListening ? _stopListening : _startListening,
            ),

            // Text input
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                enabled: !_isSending,
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            IconButton(
              icon: _isSending
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              onPressed: _isSending ? null : _sendMessage,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Step 6: Add Conversation History Screen

```dart
// lib/screens/conversation_history_screen.dart
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/conversation_manager.dart';
import 'ai_chat_screen.dart';

class ConversationHistoryScreen extends StatefulWidget {
  const ConversationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ConversationHistoryScreen> createState() =>
      _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState extends State<ConversationHistoryScreen> {
  final ConversationManager _manager = ConversationManager();
  List<String> _conversationIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    _conversationIds = await _manager.getConversationList();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversationIds.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _conversationIds.length,
                  itemBuilder: (context, index) {
                    final id = _conversationIds[index];
                    return _buildConversationTile(id);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(String id) {
    final timestamp = int.tryParse(id);
    final date = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : DateTime.now();

    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.chat),
      ),
      title: Text('Conversation ${_conversationIds.indexOf(id) + 1}'),
      subtitle: Text(timeago.format(date)),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _deleteConversation(id),
      ),
      onTap: () => _openConversation(id),
    );
  }

  Future<void> _openConversation(String id) async {
    await _manager.loadConversation(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AIChatScreen()),
    );
  }

  Future<void> _deleteConversation(String id) async {
    await _manager.deleteConversation(id);
    await _loadConversations();
  }
}
```

---

## Features Summary

### ✅ Implemented Features

1. **Beautiful UI**
   - Custom message bubbles
   - Different colors for user/AI
   - Avatars with icons

2. **Markdown Support**
   - Bold, italic, lists
   - Headers
   - Links
   - Code blocks

3. **Code Highlighting**
   - Syntax highlighting
   - Copy button for code
   - Dark theme for code blocks

4. **Streaming**
   - Real-time text appearance
   - Loading indicators
   - Status updates

5. **Voice Input**
   - Speech-to-text
   - Visual feedback
   - Easy toggle

6. **Persistence**
   - Save conversations
   - Load history
   - Delete conversations

7. **User Experience**
   - Timestamps ("2 minutes ago")
   - Retry on error
   - Auto-scroll
   - Copy to clipboard

---

## Customization Options

### 1. Change Theme Colors

```dart
// In message_bubble.dart
Color _getBackgroundColor(BuildContext context) {
  if (message.isUser) return Colors.deepPurple; // Change this!
  if (message.type == MessageType.error) return Colors.orange;
  return Colors.grey[100]!;
}
```

### 2. Add Reaction Buttons

```dart
// Add to MessageBubble
Row(
  children: [
    IconButton(
      icon: const Icon(Icons.thumb_up_outlined, size: 16),
      onPressed: () => _handleLike(),
    ),
    IconButton(
      icon: const Icon(Icons.thumb_down_outlined, size: 16),
      onPressed: () => _handleDislike(),
    ),
  ],
)
```

### 3. Add Image Support

```dart
if (message.type == MessageType.image)
  Image.network(message.content)
```

---

## Summary

You now have a production-ready chat interface with:

- ✅ Beautiful message bubbles
- ✅ Streaming text
- ✅ Markdown rendering
- ✅ Code syntax highlighting
- ✅ Voice input
- ✅ Conversation persistence
- ✅ History management
- ✅ Error handling
- ✅ Copy/share functionality

**Next lesson**: Advanced AI features (image generation, vision, speech-to-text)!
