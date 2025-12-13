// Exercise 4: AI with Function Calling (Intermediate-Advanced) - SOLUTION
//
// Complete implementation of AI function calling using Claude.
// Claude decides when to use tools and this app executes them.
//
// SETUP:
// 1. Get Claude API key from: https://console.anthropic.com/
// 2. Add to .env: ANTHROPIC_API_KEY=your_key_here
// 3. For weather tool, get free key from: https://openweathermap.org/api
//    Add to .env: OPENWEATHER_API_KEY=your_key_here

import 'dart:convert';
import 'dart:math';
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
      title: 'AI Function Calling',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const FunctionCallingScreen(),
    );
  }
}

/// Represents a chat message
class Message {
  final String text;
  final bool isUser;
  final List<ToolCall> toolCalls;

  Message({
    required this.text,
    required this.isUser,
    this.toolCalls = const [],
  });
}

/// Represents a tool/function call made by the AI
class ToolCall {
  final String toolName;
  final Map<String, dynamic> input;
  final String output;

  ToolCall({
    required this.toolName,
    required this.input,
    required this.output,
  });
}

class FunctionCallingScreen extends StatefulWidget {
  const FunctionCallingScreen({super.key});

  @override
  State<FunctionCallingScreen> createState() => _FunctionCallingScreenState();
}

class _FunctionCallingScreenState extends State<FunctionCallingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  /// Returns tool definitions that Claude can use
  List<Map<String, dynamic>> _getToolDefinitions() {
    return [
      // Calculator tool
      {
        'name': 'calculator',
        'description':
            'Performs basic arithmetic operations. Use this when the user asks for calculations.',
        'input_schema': {
          'type': 'object',
          'properties': {
            'operation': {
              'type': 'string',
              'enum': ['add', 'subtract', 'multiply', 'divide'],
              'description': 'The arithmetic operation to perform'
            },
            'a': {
              'type': 'number',
              'description': 'The first number'
            },
            'b': {
              'type': 'number',
              'description': 'The second number'
            },
          },
          'required': ['operation', 'a', 'b']
        }
      },

      // Weather tool
      {
        'name': 'get_weather',
        'description':
            'Gets the current weather for a city. Use this when the user asks about weather conditions.',
        'input_schema': {
          'type': 'object',
          'properties': {
            'city': {
              'type': 'string',
              'description': 'The city name to get weather for'
            },
          },
          'required': ['city']
        }
      },

      // Search tool
      {
        'name': 'search',
        'description':
            'Searches for information on a topic. Use this when the user asks questions that require looking up information.',
        'input_schema': {
          'type': 'object',
          'properties': {
            'query': {
              'type': 'string',
              'description': 'The search query'
            },
          },
          'required': ['query']
        }
      },
    ];
  }

  /// Executes the calculator tool
  Map<String, dynamic> _executeCalculator(Map<String, dynamic> input) {
    try {
      final operation = input['operation'] as String;
      final a = (input['a'] as num).toDouble();
      final b = (input['b'] as num).toDouble();

      double result;
      switch (operation) {
        case 'add':
          result = a + b;
          break;
        case 'subtract':
          result = a - b;
          break;
        case 'multiply':
          result = a * b;
          break;
        case 'divide':
          if (b == 0) {
            return {'error': 'Cannot divide by zero'};
          }
          result = a / b;
          break;
        default:
          return {'error': 'Unknown operation: $operation'};
      }

      return {'result': result};
    } catch (e) {
      return {'error': 'Calculator error: $e'};
    }
  }

  /// Executes the weather tool
  Future<Map<String, dynamic>> _executeGetWeather(
      Map<String, dynamic> input) async {
    try {
      final city = input['city'] as String;
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

      // If no API key, return mock data
      if (apiKey == null || apiKey.isEmpty) {
        return {
          'city': city,
          'temperature': 20 + Random().nextInt(15),
          'description': 'Partly cloudy',
          'humidity': 50 + Random().nextInt(30),
          'note': 'Mock data - add OPENWEATHER_API_KEY to .env for real data'
        };
      }

      // Make real API call
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Weather API timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'city': city,
          'temperature': data['main']['temp'],
          'description': data['weather'][0]['description'],
          'humidity': data['main']['humidity'],
        };
      } else if (response.statusCode == 404) {
        return {'error': 'City not found: $city'};
      } else {
        return {'error': 'Weather API error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Weather lookup failed: $e'};
    }
  }

  /// Executes the search tool
  Map<String, dynamic> _executeSearch(Map<String, dynamic> input) {
    final query = input['query'] as String;

    // Mock search results
    return {
      'query': query,
      'results': [
        'Found information about ${query.toLowerCase()}...',
        'Recent updates on $query show...',
        'Experts say about $query that...',
      ],
      'note': 'Mock search results - integrate real search API for production'
    };
  }

  /// Executes a tool based on its name
  Future<Map<String, dynamic>> _executeTool(
    String toolName,
    Map<String, dynamic> input,
  ) async {
    switch (toolName) {
      case 'calculator':
        return _executeCalculator(input);
      case 'get_weather':
        return await _executeGetWeather(input);
      case 'search':
        return _executeSearch(input);
      default:
        return {'error': 'Unknown tool: $toolName'};
    }
  }

  /// Sends message to Claude and handles tool calling loop
  Future<void> _sendMessage(String userMessage) async {
    setState(() {
      _messages.add(Message(
        text: userMessage,
        isUser: true,
        toolCalls: [],
      ));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'Anthropic API key not found.\n\n'
          'Please:\n'
          '1. Create a .env file in your project root\n'
          '2. Add: ANTHROPIC_API_KEY=your_key_here\n'
          '3. Get your key from: https://console.anthropic.com/',
        );
      }

      final url = Uri.parse('https://api.anthropic.com/v1/messages');
      final tools = _getToolDefinitions();

      // Build conversation messages
      final messages = [
        {'role': 'user', 'content': userMessage}
      ];

      final List<ToolCall> toolCalls = [];
      String? finalResponse;

      // Tool calling loop - continue until Claude provides final answer
      while (finalResponse == null) {
        // Make request to Claude
        final response = await http
            .post(
              url,
              headers: {
                'x-api-key': apiKey,
                'anthropic-version': '2023-06-01',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'model': 'claude-3-5-sonnet-20241022',
                'max_tokens': 1024,
                'tools': tools,
                'messages': messages,
              }),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode != 200) {
          final errorData = jsonDecode(response.body);
          throw Exception(
            'Claude API error: ${response.statusCode}\n'
            '${errorData['error']['message'] ?? 'Unknown error'}',
          );
        }

        final data = jsonDecode(response.body);
        final content = data['content'] as List;
        final stopReason = data['stop_reason'];

        // Check if Claude wants to use tools
        if (stopReason == 'tool_use') {
          // Extract tool uses and text
          final assistantMessage = <Map<String, dynamic>>[];
          final toolResults = <Map<String, dynamic>>[];

          for (final block in content) {
            if (block['type'] == 'tool_use') {
              final toolName = block['name'];
              final toolInput = block['input'];
              final toolId = block['id'];

              // Execute the tool
              final toolOutput = await _executeTool(toolName, toolInput);

              // Record tool call
              toolCalls.add(ToolCall(
                toolName: toolName,
                input: toolInput,
                output: jsonEncode(toolOutput),
              ));

              // Add tool result for next request
              toolResults.add({
                'type': 'tool_result',
                'tool_use_id': toolId,
                'content': jsonEncode(toolOutput),
              });

              assistantMessage.add(block);
            } else if (block['type'] == 'text') {
              assistantMessage.add(block);
            }
          }

          // Add assistant's message with tool uses
          messages.add({
            'role': 'assistant',
            'content': assistantMessage,
          });

          // Add user message with tool results
          messages.add({
            'role': 'user',
            'content': toolResults,
          });
        } else {
          // No more tools - extract final text response
          for (final block in content) {
            if (block['type'] == 'text') {
              finalResponse = block['text'];
              break;
            }
          }

          // If no text found, use a default
          finalResponse ??= 'I completed the requested operations.';
        }
      }

      // Add AI response with tool calls
      setState(() {
        _messages.add(Message(
          text: finalResponse!,
          isUser: false,
          toolCalls: toolCalls,
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: 'Error: $e',
          isUser: false,
          toolCalls: [],
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Function Calling'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Available tools info
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.orange[50],
            child: Row(
              children: [
                const Icon(Icons.build, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Claude has access to: Calculator, Weather, Search',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
              ],
            ),
          ),

          // Welcome message
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.smart_toy, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Try these commands:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...['Calculate 234 * 567', 'Weather in London', 'Search for AI trends']
                          .map((example) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Chip(
                                  label: Text(example),
                                  backgroundColor: Colors.orange[50],
                                ),
                              )),
                    ],
                  ),
                ),
              ),
            )
          else
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageWidget(message: _messages[index]);
                },
              ),
            ),

          // Loading indicator
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
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Claude is working...'),
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
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me to calculate, check weather, or search...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
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

/// Widget to display a message with tool calls
class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Main message bubble
          Row(
            mainAxisAlignment:
                message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.smart_toy, size: 18, color: Colors.orange),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.orange : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ],
            ],
          ),

          // Tool calls display
          if (message.toolCalls.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...message.toolCalls.map((toolCall) => Padding(
                  padding: const EdgeInsets.only(left: 40, top: 4),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getToolIcon(toolCall.toolName),
                              size: 16,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '🔧 Used ${toolCall.toolName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.orange[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Input: ${jsonEncode(toolCall.input)}',
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        Text(
                          'Output: ${toolCall.output}',
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  IconData _getToolIcon(String toolName) {
    switch (toolName) {
      case 'calculator':
        return Icons.calculate;
      case 'get_weather':
        return Icons.wb_sunny;
      case 'search':
        return Icons.search;
      default:
        return Icons.build;
    }
  }
}
