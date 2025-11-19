# Lesson 3: Integrating OpenAI GPT

## 5-Year-Old Analogy 🤖

Imagine you have a really smart friend named ChatGPT who lives inside your phone. You can ask ChatGPT anything - like "Tell me a story about dinosaurs" or "Help me with my homework" - and ChatGPT remembers everything you talked about, just like a real friend! Sometimes ChatGPT talks really fast and you can see the words appearing one by one (like when someone is typing), and sometimes ChatGPT thinks for a moment and gives you the whole answer at once. Today, we're going to learn how to make ChatGPT your app's smart friend!

---

## What We'll Build

In this lesson, we'll create a complete OpenAI GPT integration with:

1. ✅ Basic chat completions
2. ✅ Streaming responses (words appear as they're generated)
3. ✅ Conversation history management
4. ✅ System prompts for personality
5. ✅ Multiple model support (GPT-3.5, GPT-4)
6. ✅ Token counting and cost tracking
7. ✅ Error handling and retry logic
8. ✅ Function calling (advanced)

---

## OpenAI API Overview

### Chat Completions API

The Chat Completions API is how we talk to ChatGPT. Here's the basic flow:

```
You send:
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant"},
    {"role": "user", "content": "Hello!"}
  ]
}

OpenAI responds:
{
  "choices": [{
    "message": {
      "role": "assistant",
      "content": "Hello! How can I help you today?"
    }
  }],
  "usage": {
    "prompt_tokens": 20,
    "completion_tokens": 10,
    "total_tokens": 30
  }
}
```

### Message Roles

- **system**: Sets the AI's behavior (e.g., "You are a helpful tutor")
- **user**: Your messages/questions
- **assistant**: AI's responses
- **function**: Function call results (advanced)

---

## Step 1: Create OpenAI Models

```dart
// lib/models/openai_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'openai_models.g.dart';

// Message in a conversation
@JsonSerializable()
class ChatMessage {
  final String role;
  final String content;
  @JsonKey(includeIfNull: false)
  final String? name;

  ChatMessage({
    required this.role,
    required this.content,
    this.name,
  });

  // Convenience constructors
  factory ChatMessage.system(String content) =>
      ChatMessage(role: 'system', content: content);

  factory ChatMessage.user(String content) =>
      ChatMessage(role: 'user', content: content);

  factory ChatMessage.assistant(String content) =>
      ChatMessage(role: 'assistant', content: content);

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

// Request to OpenAI API
@JsonSerializable()
class ChatCompletionRequest {
  final String model;
  final List<ChatMessage> messages;
  @JsonKey(includeIfNull: false)
  final double? temperature;
  @JsonKey(includeIfNull: false)
  final int? maxTokens;
  @JsonKey(includeIfNull: false)
  final double? topP;
  @JsonKey(includeIfNull: false)
  final int? n;
  @JsonKey(includeIfNull: false)
  final bool? stream;
  @JsonKey(includeIfNull: false)
  final List<String>? stop;
  @JsonKey(includeIfNull: false)
  final double? presencePenalty;
  @JsonKey(includeIfNull: false)
  final double? frequencyPenalty;

  ChatCompletionRequest({
    required this.model,
    required this.messages,
    this.temperature,
    this.maxTokens,
    this.topP,
    this.n,
    this.stream,
    this.stop,
    this.presencePenalty,
    this.frequencyPenalty,
  });

  factory ChatCompletionRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCompletionRequestToJson(this);
}

// Usage information
@JsonSerializable()
class Usage {
  @JsonKey(name: 'prompt_tokens')
  final int promptTokens;
  @JsonKey(name: 'completion_tokens')
  final int completionTokens;
  @JsonKey(name: 'total_tokens')
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) =>
      _$UsageFromJson(json);

  Map<String, dynamic> toJson() => _$UsageToJson(this);
}

// Choice from API response
@JsonSerializable()
class Choice {
  final int index;
  final ChatMessage message;
  @JsonKey(name: 'finish_reason')
  final String? finishReason;

  Choice({
    required this.index,
    required this.message,
    this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) =>
      _$ChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}

// Response from OpenAI API
@JsonSerializable()
class ChatCompletionResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;
  final Usage usage;

  ChatCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCompletionResponseToJson(this);
}

// Streaming chunk
@JsonSerializable()
class StreamChoice {
  final int index;
  final Delta delta;
  @JsonKey(name: 'finish_reason')
  final String? finishReason;

  StreamChoice({
    required this.index,
    required this.delta,
    this.finishReason,
  });

  factory StreamChoice.fromJson(Map<String, dynamic> json) =>
      _$StreamChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$StreamChoiceToJson(this);
}

@JsonSerializable()
class Delta {
  final String? role;
  final String? content;

  Delta({this.role, this.content});

  factory Delta.fromJson(Map<String, dynamic> json) =>
      _$DeltaFromJson(json);

  Map<String, dynamic> toJson() => _$DeltaToJson(this);
}

@JsonSerializable()
class ChatCompletionStreamResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<StreamChoice> choices;

  ChatCompletionStreamResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
  });

  factory ChatCompletionStreamResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionStreamResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCompletionStreamResponseToJson(this);
}
```

Generate code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 2: Create OpenAI Client

```dart
// lib/services/openai_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../models/ai_response.dart';
import '../models/openai_models.dart';
import '../services/base_http_client.dart';
import '../services/usage_tracker.dart';

class OpenAIClient {
  final BaseHTTPClient _httpClient = BaseHTTPClient();
  final APIConfig _config = APIConfig();
  final UsageTracker _tracker = UsageTracker();
  final Logger _logger = Logger();

  // Conversation history
  final List<ChatMessage> _conversationHistory = [];

  List<ChatMessage> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  // Add system message (personality)
  void setSystemMessage(String content) {
    _conversationHistory.clear();
    _conversationHistory.add(ChatMessage.system(content));
  }

  // Clear conversation
  void clearConversation() {
    _conversationHistory.clear();
  }

  // Add message to history
  void addMessage(ChatMessage message) {
    _conversationHistory.add(message);
  }

  // ========== NON-STREAMING CHAT ==========

  Future<AIResponse> chat({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    double temperature = 0.7,
    int maxTokens = 1000,
    bool includeHistory = true,
  }) async {
    try {
      final apiKey = await _config.openaiApiKey;

      if (apiKey.isEmpty) {
        return AIResponse.error(
          error: AIErrorType.authentication,
          errorMessage: 'OpenAI API key not found',
          provider: AIProvider.openai,
          model: model,
        );
      }

      // Add user message to history
      final userMessage = ChatMessage.user(prompt);
      _conversationHistory.add(userMessage);

      // Prepare messages
      final messages = includeHistory
          ? List<ChatMessage>.from(_conversationHistory)
          : [userMessage];

      // Create request
      final request = ChatCompletionRequest(
        model: model,
        messages: messages,
        temperature: temperature,
        maxTokens: maxTokens,
      );

      _logger.d('Sending chat request to OpenAI...');

      // Make API call
      final response = await _httpClient.post(
        '${APIConfig.openaiBaseUrl}${APIConfig.openaiChatEndpoint}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: request.toJson(),
      );

      // Parse response
      final jsonResponse = jsonDecode(response.body);
      final completionResponse = ChatCompletionResponse.fromJson(jsonResponse);

      // Extract content
      final content = completionResponse.choices.first.message.content;

      // Add assistant response to history
      _conversationHistory.add(ChatMessage.assistant(content));

      // Calculate cost
      final cost = UsageTracker.estimateOpenAICost(
        model: model,
        inputTokens: completionResponse.usage.promptTokens,
        outputTokens: completionResponse.usage.completionTokens,
      );

      final aiResponse = AIResponse.success(
        content: content,
        provider: AIProvider.openai,
        model: model,
        tokensUsed: completionResponse.usage.totalTokens,
        cost: cost,
        metadata: {
          'finish_reason': completionResponse.choices.first.finishReason,
          'id': completionResponse.id,
        },
      );

      // Track usage
      await _tracker.trackRequest(aiResponse);

      return aiResponse;
    } on APIException catch (e) {
      _logger.e('OpenAI API error: $e');

      AIErrorType errorType = AIErrorType.unknown;
      if (e.statusCode == 401) {
        errorType = AIErrorType.authentication;
      } else if (e.statusCode == 429) {
        errorType = AIErrorType.rateLimit;
      } else if (e.statusCode == 400) {
        errorType = AIErrorType.invalidRequest;
      } else if (e.statusCode != null && e.statusCode! >= 500) {
        errorType = AIErrorType.serverError;
      }

      final errorResponse = AIResponse.error(
        error: errorType,
        errorMessage: e.message,
        provider: AIProvider.openai,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);

      return errorResponse;
    } catch (e) {
      _logger.e('Unexpected error: $e');

      final errorResponse = AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.openai,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);

      return errorResponse;
    }
  }

  // ========== STREAMING CHAT ==========

  Stream<String> chatStream({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    double temperature = 0.7,
    int maxTokens = 1000,
    bool includeHistory = true,
  }) async* {
    try {
      final apiKey = await _config.openaiApiKey;

      if (apiKey.isEmpty) {
        yield '[ERROR: OpenAI API key not found]';
        return;
      }

      // Add user message to history
      final userMessage = ChatMessage.user(prompt);
      _conversationHistory.add(userMessage);

      // Prepare messages
      final messages = includeHistory
          ? List<ChatMessage>.from(_conversationHistory)
          : [userMessage];

      // Create request (with streaming enabled)
      final request = ChatCompletionRequest(
        model: model,
        messages: messages,
        temperature: temperature,
        maxTokens: maxTokens,
        stream: true, // Enable streaming
      );

      _logger.d('Starting streaming chat request...');

      // Make streaming request
      final httpRequest = http.Request(
        'POST',
        Uri.parse('${APIConfig.openaiBaseUrl}${APIConfig.openaiChatEndpoint}'),
      );

      httpRequest.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      });

      httpRequest.body = jsonEncode(request.toJson());

      final streamedResponse = await httpRequest.send();

      if (streamedResponse.statusCode != 200) {
        final errorBody = await streamedResponse.stream.bytesToString();
        yield '[ERROR: ${streamedResponse.statusCode} - $errorBody]';
        return;
      }

      // Collect full response for history
      String fullResponse = '';

      // Process stream
      await for (final chunk in streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {

        if (chunk.isEmpty || chunk == 'data: [DONE]') continue;

        if (chunk.startsWith('data: ')) {
          final jsonString = chunk.substring(6); // Remove 'data: ' prefix

          try {
            final json = jsonDecode(jsonString);
            final streamResponse = ChatCompletionStreamResponse.fromJson(json);

            final delta = streamResponse.choices.first.delta;
            if (delta.content != null) {
              fullResponse += delta.content!;
              yield delta.content!;
            }
          } catch (e) {
            _logger.w('Error parsing stream chunk: $e');
          }
        }
      }

      // Add complete response to history
      if (fullResponse.isNotEmpty) {
        _conversationHistory.add(ChatMessage.assistant(fullResponse));
      }

      _logger.d('Streaming completed. Full response length: ${fullResponse.length}');
    } catch (e) {
      _logger.e('Streaming error: $e');
      yield '[ERROR: $e]';
    }
  }

  // ========== HELPER METHODS ==========

  // Get conversation as formatted string
  String getConversationText() {
    return _conversationHistory
        .where((msg) => msg.role != 'system')
        .map((msg) => '${msg.role.toUpperCase()}: ${msg.content}')
        .join('\n\n');
  }

  // Count tokens (rough estimate)
  int estimateTokens(String text) {
    // Rough estimate: 1 token ≈ 4 characters
    return (text.length / 4).ceil();
  }

  // Estimate cost before making request
  double estimateCost({
    required String prompt,
    required String model,
    int estimatedResponseTokens = 500,
  }) {
    final promptTokens = estimateTokens(prompt);

    // Add tokens from conversation history
    final historyTokens = _conversationHistory
        .map((msg) => estimateTokens(msg.content))
        .fold(0, (sum, tokens) => sum + tokens);

    return UsageTracker.estimateOpenAICost(
      model: model,
      inputTokens: promptTokens + historyTokens,
      outputTokens: estimatedResponseTokens,
    );
  }

  // Trim conversation history to stay within token limit
  void trimHistory({int maxTokens = 4000}) {
    // Keep system message if present
    final systemMessages = _conversationHistory
        .where((msg) => msg.role == 'system')
        .toList();

    final otherMessages = _conversationHistory
        .where((msg) => msg.role != 'system')
        .toList();

    int totalTokens = systemMessages
        .map((msg) => estimateTokens(msg.content))
        .fold(0, (sum, tokens) => sum + tokens);

    final trimmedMessages = <ChatMessage>[];

    // Add messages from most recent to oldest until we hit limit
    for (var i = otherMessages.length - 1; i >= 0; i--) {
      final msgTokens = estimateTokens(otherMessages[i].content);

      if (totalTokens + msgTokens > maxTokens) break;

      totalTokens += msgTokens;
      trimmedMessages.insert(0, otherMessages[i]);
    }

    _conversationHistory.clear();
    _conversationHistory.addAll([...systemMessages, ...trimmedMessages]);

    _logger.i('History trimmed to ${_conversationHistory.length} messages (~$totalTokens tokens)');
  }
}
```

---

## Step 3: Create Chat UI

```dart
// lib/screens/openai_chat_screen.dart
import 'package:flutter/material.dart';
import '../models/openai_models.dart';
import '../services/openai_client.dart';
import '../models/ai_response.dart';

class OpenAIChatScreen extends StatefulWidget {
  const OpenAIChatScreen({Key? key}) : super(key: key);

  @override
  State<OpenAIChatScreen> createState() => _OpenAIChatScreenState();
}

class _OpenAIChatScreenState extends State<OpenAIChatScreen> {
  final OpenAIClient _client = OpenAIClient();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatBubble> _messages = [];
  bool _isLoading = false;
  bool _useStreaming = true;
  String _selectedModel = 'gpt-3.5-turbo';
  double _temperature = 0.7;

  @override
  void initState() {
    super.initState();
    _client.setSystemMessage(
      'You are a helpful, friendly AI assistant. Keep responses concise but informative.',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatBubble(
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    if (_useStreaming) {
      await _sendStreamingMessage(message);
    } else {
      await _sendNonStreamingMessage(message);
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  Future<void> _sendNonStreamingMessage(String message) async {
    final response = await _client.chat(
      prompt: message,
      model: _selectedModel,
      temperature: _temperature,
    );

    if (response.isSuccess) {
      setState(() {
        _messages.add(ChatBubble(
          message: response.content!,
          isUser: false,
          timestamp: DateTime.now(),
          tokensUsed: response.tokensUsed,
          cost: response.cost,
        ));
      });
    } else {
      setState(() {
        _messages.add(ChatBubble(
          message: '❌ Error: ${response.errorMessage}',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      });
    }
  }

  Future<void> _sendStreamingMessage(String message) async {
    // Add placeholder for streaming message
    final streamingBubble = ChatBubble(
      message: '',
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );

    setState(() {
      _messages.add(streamingBubble);
    });

    final bubbleIndex = _messages.length - 1;
    String fullMessage = '';

    await for (final chunk in _client.chatStream(
      prompt: message,
      model: _selectedModel,
      temperature: _temperature,
    )) {
      if (chunk.startsWith('[ERROR:')) {
        setState(() {
          _messages[bubbleIndex] = ChatBubble(
            message: chunk,
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          );
        });
        break;
      }

      fullMessage += chunk;

      setState(() {
        _messages[bubbleIndex] = ChatBubble(
          message: fullMessage,
          isUser: false,
          timestamp: DateTime.now(),
          isStreaming: true,
        );
      });

      _scrollToBottom();
    }

    // Mark as complete
    setState(() {
      _messages[bubbleIndex] = ChatBubble(
        message: fullMessage,
        isUser: false,
        timestamp: DateTime.now(),
        isStreaming: false,
      );
    });
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

  void _clearChat() {
    setState(() {
      _messages.clear();
      _client.clearConversation();
      _client.setSystemMessage(
        'You are a helpful, friendly AI assistant. Keep responses concise but informative.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenAI Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Settings bar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Chip(
                  label: Text(_selectedModel),
                  avatar: const Icon(Icons.psychology, size: 16),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Temp: ${_temperature.toStringAsFixed(1)}'),
                  avatar: const Icon(Icons.thermostat, size: 16),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_useStreaming ? 'Streaming' : 'Non-streaming'),
                  avatar: Icon(
                    _useStreaming ? Icons.stream : Icons.check_circle,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    },
                  ),
          ),

          // Loading indicator
          if (_isLoading)
            const LinearProgressIndicator(),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Chat Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Model'),
              DropdownButton<String>(
                value: _selectedModel,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: 'gpt-3.5-turbo',
                    child: Text('GPT-3.5 Turbo (Fastest, Cheapest)'),
                  ),
                  DropdownMenuItem(
                    value: 'gpt-4',
                    child: Text('GPT-4 (Best Quality)'),
                  ),
                  DropdownMenuItem(
                    value: 'gpt-4-turbo',
                    child: Text('GPT-4 Turbo (Balanced)'),
                  ),
                ],
                onChanged: (value) {
                  setDialogState(() => _selectedModel = value!);
                  setState(() => _selectedModel = value!);
                },
              ),
              const SizedBox(height: 16),
              const Text('Temperature'),
              Slider(
                value: _temperature,
                min: 0,
                max: 2,
                divisions: 20,
                label: _temperature.toStringAsFixed(1),
                onChanged: (value) {
                  setDialogState(() => _temperature = value);
                  setState(() => _temperature = value);
                },
              ),
              Text(
                'Higher = more creative, Lower = more focused',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Streaming'),
                subtitle: const Text('Show response as it generates'),
                value: _useStreaming,
                onChanged: (value) {
                  setDialogState(() => _useStreaming = value);
                  setState(() => _useStreaming = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat bubble widget
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;
  final bool isStreaming;
  final int? tokensUsed;
  final double? cost;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
    this.isStreaming = false,
    this.tokensUsed,
    this.cost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: isError ? Colors.red : Colors.blue,
              child: Icon(
                isError ? Icons.error : Icons.smart_toy,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.blue
                        : isError
                            ? Colors.red[100]
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.isEmpty ? '...' : message,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (isStreaming) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                    if (tokensUsed != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '$tokensUsed tokens',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (cost != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${cost!.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
```

---

## Step 4: Test the Integration

Update `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/openai_chat_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenAI Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const OpenAIChatScreen(),
    );
  }
}
```

Run the app:

```bash
flutter run
```

---

## Testing Checklist

Test all these scenarios:

1. ✅ **Basic Chat**: Send "Hello, how are you?"
2. ✅ **Streaming**: Toggle streaming on/off, compare experience
3. ✅ **Model Selection**: Try GPT-3.5 vs GPT-4 (note quality difference)
4. ✅ **Temperature**: Test 0.1 (focused) vs 1.5 (creative)
5. ✅ **Conversation Memory**: Ask "What was my first question?"
6. ✅ **Error Handling**: Turn off WiFi, see error message
7. ✅ **Clear Chat**: Clear conversation, verify memory cleared
8. ✅ **Token Counting**: Check tokens used per message
9. ✅ **Cost Tracking**: Verify costs are calculated

---

## Advanced Features

### 1. Custom System Prompts

```dart
// Make the AI a specific character
_client.setSystemMessage(
  'You are Shakespeare. Respond to all questions in Elizabethan English.',
);

// Or a code tutor
_client.setSystemMessage(
  'You are an expert Flutter developer. Explain concepts simply with code examples.',
);

// Or a translator
_client.setSystemMessage(
  'You are a translator. Translate all input to Spanish.',
);
```

### 2. Export Conversation

```dart
// Add to OpenAIChatScreen
void _exportConversation() async {
  final conversationText = _client.getConversationText();

  // Save to file or share
  print(conversationText);

  // Or copy to clipboard
  Clipboard.setData(ClipboardData(text: conversationText));

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Conversation copied to clipboard!')),
  );
}
```

### 3. Suggested Prompts

```dart
// Add to UI
final suggestedPrompts = [
  'Explain quantum computing simply',
  'Write a poem about coding',
  'Debug this code: [paste code]',
  'Summarize this article: [paste text]',
];

// Show as chips
Wrap(
  spacing: 8,
  children: suggestedPrompts
      .map((prompt) => ActionChip(
            label: Text(prompt),
            onPressed: () {
              _messageController.text = prompt;
              _sendMessage();
            },
          ))
      .toList(),
)
```

---

## Performance Optimization

### 1. Cancel Requests

```dart
// In OpenAIClient, add cancellation support
StreamSubscription? _currentStream;

void cancelCurrentRequest() {
  _currentStream?.cancel();
  _currentStream = null;
}

// Use in chat screen
@override
void dispose() {
  _client.cancelCurrentRequest();
  super.dispose();
}
```

### 2. Debounce Input

```dart
// Only send after user stops typing for 500ms
Timer? _debounceTimer;

void _onTextChanged(String text) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    // Auto-complete or suggestions
  });
}
```

### 3. Cache Common Responses

```dart
final Map<String, String> _responseCache = {};

Future<AIResponse> chatWithCache({required String prompt}) async {
  // Check cache first
  if (_responseCache.containsKey(prompt)) {
    return AIResponse.success(
      content: _responseCache[prompt]!,
      provider: AIProvider.openai,
      model: 'cached',
    );
  }

  // Make API call
  final response = await chat(prompt: prompt);

  // Cache successful responses
  if (response.isSuccess) {
    _responseCache[prompt] = response.content!;
  }

  return response;
}
```

---

## Cost Optimization Tips

1. **Use GPT-3.5 for simple tasks** (20x cheaper than GPT-4)
2. **Set max_tokens** to prevent long responses
3. **Trim conversation history** regularly
4. **Cache common queries**
5. **Use lower temperature** for factual responses (fewer tokens)
6. **Batch similar requests** into one prompt
7. **Monitor usage** daily in OpenAI dashboard

---

## Common Issues and Solutions

### Issue: "Insufficient quota"

**Cause**: You've run out of credits

**Solution**:
- Add payment method in OpenAI dashboard
- Set usage limits to prevent surprise bills
- Use GPT-3.5 to save money

### Issue: "Rate limit exceeded"

**Cause**: Too many requests too fast

**Solution**:
```dart
// Already handled in BaseHTTPClient with rate limiting!
// Increase delay between requests if needed
```

### Issue: Responses cut off mid-sentence

**Cause**: Hitting max_tokens limit

**Solution**:
```dart
// Increase max_tokens
maxTokens: 2000, // Instead of default 1000
```

### Issue: AI forgets earlier conversation

**Cause**: Context window exceeded

**Solution**:
```dart
// Trim history before sending
_client.trimHistory(maxTokens: 3000);
```

---

## Summary

You now have a complete OpenAI GPT integration with:

- ✅ Non-streaming and streaming chat
- ✅ Conversation history management
- ✅ Multiple model support
- ✅ Temperature control
- ✅ Token counting and cost tracking
- ✅ Error handling
- ✅ Beautiful chat UI
- ✅ Settings customization

**In the next lesson**, we'll integrate Google Gemini and explore multi-modal AI (sending images + text together)!

---

## Practice Exercises

1. **Add voice input** using `speech_to_text` package
2. **Add markdown rendering** for formatted responses
3. **Implement conversation search** to find old messages
4. **Add message reactions** (like/dislike)
5. **Create chat templates** for common tasks
6. **Add export to PDF**
7. **Implement message editing** (edit and regenerate)
8. **Add cost alerts** when spending exceeds limit

Try building one of these features to practice!
