// Exercise 5: Complete AI Assistant App (Advanced) - SOLUTION
//
// A production-ready AI assistant supporting multiple providers,
// image generation, speech I/O, persistence, and cost tracking.
//
// SETUP:
// 1. Add all API keys to .env:
//    OPENAI_API_KEY=...
//    GEMINI_API_KEY=...
//    ANTHROPIC_API_KEY=...
//
// 2. Add to pubspec.yaml:
//    dependencies:
//      http: ^1.1.0
//      flutter_dotenv: ^5.1.0
//      speech_to_text: ^6.5.1
//      flutter_tts: ^3.8.3
//      shared_preferences: ^2.2.2

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

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
      title: 'AI Assistant Pro',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const AssistantHomeScreen(),
    );
  }
}

/// Supported AI providers
enum AIProvider {
  openai('OpenAI', 'GPT-4', Colors.green),
  gemini('Gemini', 'Google AI', Colors.blue),
  claude('Claude', 'Anthropic', Colors.orange);

  final String name;
  final String description;
  final Color color;

  const AIProvider(this.name, this.description, this.color);
}

/// Chat message model
class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AIProvider? provider;
  final double cost;
  final String? imageUrl;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.provider,
    this.cost = 0.0,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'provider': provider?.index,
        'cost': cost,
        'imageUrl': imageUrl,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        text: json['text'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
        provider: json['provider'] != null
            ? AIProvider.values[json['provider']]
            : null,
        cost: json['cost'] ?? 0.0,
        imageUrl: json['imageUrl'],
      );
}

/// Service for AI interactions
class AIService {
  /// Sends a message to the specified AI provider
  Future<Message> sendMessage(
    String text,
    AIProvider provider,
    List<Message> history,
  ) async {
    switch (provider) {
      case AIProvider.openai:
        return await _sendToOpenAI(text, history);
      case AIProvider.gemini:
        return await _sendToGemini(text, history);
      case AIProvider.claude:
        return await _sendToClaude(text, history);
    }
  }

  /// Generates an image using DALL-E
  Future<Message> generateImage(String prompt) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenAI API key not found');
    }

    final url = Uri.parse('https://api.openai.com/v1/images/generations');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'dall-e-3',
        'prompt': prompt,
        'n': 1,
        'size': '1024x1024',
        'quality': 'standard',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final imageUrl = data['data'][0]['url'];

      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Generated image: $prompt',
        isUser: false,
        timestamp: DateTime.now(),
        provider: AIProvider.openai,
        cost: 0.04, // DALL-E 3 cost
        imageUrl: imageUrl,
      );
    } else {
      throw Exception('Image generation failed: ${response.statusCode}');
    }
  }

  Future<Message> _sendToOpenAI(String text, List<Message> history) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenAI API key not found');
    }

    // Build messages with history
    final messages = [
      {'role': 'system', 'content': 'You are a helpful AI assistant.'},
      ...history
          .where((m) => m.imageUrl == null)
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.text,
              })
          .toList(),
      {'role': 'user', 'content': text},
    ];

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': messages,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final aiText = data['choices'][0]['message']['content'];
      final tokensUsed = data['usage']['total_tokens'];
      final cost = (tokensUsed / 1000) * 0.002; // GPT-3.5 pricing

      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
        provider: AIProvider.openai,
        cost: cost,
      );
    } else {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
  }

  Future<Message> _sendToGemini(String text, List<Message> history) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API key not found');
    }

    // Gemini requires alternating user/model turns
    final contents = <Map<String, dynamic>>[];
    for (var i = 0; i < history.length; i++) {
      final msg = history[i];
      if (msg.imageUrl != null) continue; // Skip image messages

      contents.add({
        'role': msg.isUser ? 'user' : 'model',
        'parts': [
          {'text': msg.text}
        ],
      });
    }
    contents.add({
      'role': 'user',
      'parts': [
        {'text': text}
      ],
    });

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': contents}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final aiText = data['candidates'][0]['content']['parts'][0]['text'];

      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
        provider: AIProvider.gemini,
        cost: 0.0, // Gemini free tier
      );
    } else {
      throw Exception('Gemini API error: ${response.statusCode}');
    }
  }

  Future<Message> _sendToClaude(String text, List<Message> history) async {
    final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Anthropic API key not found');
    }

    final messages = [
      ...history
          .where((m) => m.imageUrl == null)
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.text,
              })
          .toList(),
      {'role': 'user', 'content': text},
    ];

    final url = Uri.parse('https://api.anthropic.com/v1/messages');
    final response = await http.post(
      url,
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-3-5-sonnet-20241022',
        'max_tokens': 1024,
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final aiText = data['content'][0]['text'];
      final inputTokens = data['usage']['input_tokens'];
      final outputTokens = data['usage']['output_tokens'];
      final cost = (inputTokens / 1000000) * 3 + (outputTokens / 1000000) * 15;

      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
        provider: AIProvider.claude,
        cost: cost,
      );
    } else {
      throw Exception('Claude API error: ${response.statusCode}');
    }
  }
}

/// Service for local storage
class StorageService {
  static const String _conversationKey = 'ai_conversation';
  static const String _costKey = 'total_cost';

  Future<void> saveConversation(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = messages.map((m) => m.toJson()).toList();
    await prefs.setString(_conversationKey, jsonEncode(jsonList));
  }

  Future<List<Message>> loadConversation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_conversationKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Message.fromJson(json)).toList();
  }

  Future<void> clearConversation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_conversationKey);
    await prefs.remove(_costKey);
  }

  Future<void> saveTotalCost(double cost) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_costKey, cost);
  }

  Future<double> loadTotalCost() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_costKey) ?? 0.0;
  }
}

/// Service for speech I/O
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize();
    if (_isInitialized) {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
    }
    return _isInitialized;
  }

  Future<String?> listen() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_speech.isAvailable) return null;

    final completer = Completer<String?>();

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );

    return completer.future;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _speech.stop();
    await _tts.stop();
  }

  void dispose() {
    _speech.cancel();
    _tts.stop();
  }
}

class AssistantHomeScreen extends StatefulWidget {
  const AssistantHomeScreen({super.key});

  @override
  State<AssistantHomeScreen> createState() => _AssistantHomeScreenState();
}

class _AssistantHomeScreenState extends State<AssistantHomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];

  final AIService _aiService = AIService();
  final StorageService _storageService = StorageService();
  final SpeechService _speechService = SpeechService();

  AIProvider _selectedProvider = AIProvider.openai;
  bool _isLoading = false;
  bool _isListening = false;
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _speechService.initialize();
  }

  Future<void> _loadData() async {
    final messages = await _storageService.loadConversation();
    final cost = await _storageService.loadTotalCost();

    setState(() {
      _messages.addAll(messages);
      _totalCost = cost;
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _scrollToBottom();
    await _storageService.saveConversation(_messages);

    try {
      final aiMessage = await _aiService.sendMessage(
        text,
        _selectedProvider,
        _messages.where((m) => !m.isUser).take(10).toList(),
      );

      setState(() {
        _messages.add(aiMessage);
        _totalCost += aiMessage.cost;
      });

      await _storageService.saveConversation(_messages);
      await _storageService.saveTotalCost(_totalCost);
    } catch (e) {
      setState(() {
        _messages.add(Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Error: $e',
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

  Future<void> _generateImage(String prompt) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final imageMessage = await _aiService.generateImage(prompt);

      setState(() {
        _messages.add(imageMessage);
        _totalCost += imageMessage.cost;
      });

      await _storageService.saveConversation(_messages);
      await _storageService.saveTotalCost(_totalCost);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image generation failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
    });

    try {
      final text = await _speechService.listen();

      if (text != null && text.isNotEmpty) {
        _messageController.text = text;
        await _sendMessage(text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speech recognition failed: $e')),
      );
    } finally {
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _speakResponse(String text) async {
    await _speechService.speak(text);
  }

  void _clearConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation'),
        content: const Text('Are you sure? This will delete all messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.clearConversation();
              setState(() {
                _messages.clear();
                _totalCost = 0.0;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showImageGenerationDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Image'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Describe the image...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateImage(controller.text);
            },
            child: const Text('Generate (\$0.04)'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant Pro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text('\$${_totalCost.toStringAsFixed(4)}'),
              backgroundColor: Colors.green[100],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearConversation,
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Provider selector
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Row(
              children: AIProvider.values.map((provider) {
                final isSelected = _selectedProvider == provider;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        provider.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: provider.color,
                      onSelected: (_) {
                        setState(() {
                          _selectedProvider = provider;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
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
                            size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
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
                      return MessageBubble(
                        message: _messages[index],
                        onSpeak: _speakResponse,
                      );
                    },
                  ),
          ),

          // Loading
          if (_isLoading)
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
                      color: _selectedProvider.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${_selectedProvider.name} is thinking...'),
                ],
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isLoading ? null : _startListening,
                  color: _isListening ? Colors.red : Colors.grey,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
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
                  icon: const Icon(Icons.image),
                  onPressed: _isLoading ? null : _showImageGenerationDialog,
                  tooltip: 'Generate image',
                ),
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
                  color: _selectedProvider.color,
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
    _speechService.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final Function(String) onSpeak;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.provider?.color ?? Colors.grey,
              child: const Icon(Icons.smart_toy, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Colors.indigo
                        : message.provider?.color.withOpacity(0.1) ??
                            Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            message.imageUrl!,
                            width: 256,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.provider != null)
                      Text(
                        message.provider!.name,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    if (message.cost > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '\$${message.cost.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                    if (!message.isUser) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onSpeak(message.text),
                        child: const Icon(Icons.volume_up, size: 16, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
