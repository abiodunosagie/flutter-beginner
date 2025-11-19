// Exercise 4: AI with Function Calling (Intermediate-Advanced)
//
// Learn how AI can use tools/functions to perform actions.
// Claude will decide when and how to use weather, calculator, and search tools.
//
// Learning Objectives:
// - Understand function/tool calling concepts
// - Define tool schemas for AI
// - Execute tool calls based on AI decisions
// - Handle multi-turn conversations with tools
// - Display tool usage in UI
//
// SETUP:
// 1. Get Claude API key from: https://console.anthropic.com/
// 2. Add to .env: ANTHROPIC_API_KEY=your_key_here
// 3. For weather tool, get free key from: https://openweathermap.org/api
//    Add to .env: OPENWEATHER_API_KEY=your_key_here

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
      title: 'AI Function Calling',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const FunctionCallingScreen(),
    );
  }
}

// TODO: Create a Message class to represent chat messages
// Include: text, isUser, toolCalls (list of tools used)
class Message {
  // TODO: Implement
}

// TODO: Create a ToolCall class to represent when AI uses a tool
// Include: toolName, input, output
class ToolCall {
  // TODO: Implement
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

  // TODO: Define available tools/functions
  // Each tool needs:
  // - name: identifier for the tool
  // - description: what the tool does (helps AI decide when to use it)
  // - input_schema: JSON schema describing the parameters
  //
  // Example tool definition for calculator:
  // {
  //   "name": "calculator",
  //   "description": "Performs basic arithmetic operations",
  //   "input_schema": {
  //     "type": "object",
  //     "properties": {
  //       "operation": {
  //         "type": "string",
  //         "enum": ["add", "subtract", "multiply", "divide"],
  //         "description": "The arithmetic operation to perform"
  //       },
  //       "a": {"type": "number", "description": "First number"},
  //       "b": {"type": "number", "description": "Second number"}
  //     },
  //     "required": ["operation", "a", "b"]
  //   }
  // }
  List<Map<String, dynamic>> _getToolDefinitions() {
    // TODO: Define tools for:
    // 1. calculator (add, subtract, multiply, divide)
    // 2. get_weather (city name) - uses OpenWeatherMap API
    // 3. search (query) - mock search results
    return [];
  }

  // TODO: Implement calculator tool
  // Takes operation, a, b and returns the result
  Map<String, dynamic> _executecalculator(Map<String, dynamic> input) {
    // TODO: Implement
    return {'result': 0};
  }

  // TODO: Implement weather tool
  // Makes API call to OpenWeatherMap
  // Returns temperature, description, humidity
  Future<Map<String, dynamic>> _executeGetWeather(
      Map<String, dynamic> input) async {
    // TODO: Implement
    // API: https://api.openweathermap.org/data/2.5/weather?q={city}&appid={apiKey}&units=metric
    return {'temperature': 0, 'description': '', 'humidity': 0};
  }

  // TODO: Implement search tool
  // Returns mock search results for the query
  Map<String, dynamic> _executeSearch(Map<String, dynamic> input) {
    // TODO: Implement
    return {
      'results': ['Result 1', 'Result 2', 'Result 3']
    };
  }

  // TODO: Execute a tool based on its name and input
  Future<Map<String, dynamic>> _executeTool(
    String toolName,
    Map<String, dynamic> input,
  ) async {
    // TODO: Call the appropriate tool function based on toolName
    return {};
  }

  // TODO: Send message to Claude with tool definitions
  // Handle tool calls from Claude
  // Execute tools and send results back
  // Continue until Claude provides final response
  //
  // Claude API endpoint: https://api.anthropic.com/v1/messages
  //
  // Request with tools:
  // {
  //   "model": "claude-3-5-sonnet-20241022",
  //   "max_tokens": 1024,
  //   "tools": [...tool definitions...],
  //   "messages": [{"role": "user", "content": "message"}]
  // }
  //
  // Response with tool use:
  // {
  //   "content": [
  //     {"type": "text", "text": "I'll help with that..."},
  //     {
  //       "type": "tool_use",
  //       "id": "tool_call_id",
  //       "name": "calculator",
  //       "input": {"operation": "add", "a": 5, "b": 3}
  //     }
  //   ],
  //   "stop_reason": "tool_use"
  // }
  //
  // Send tool results back:
  // {
  //   "role": "user",
  //   "content": [
  //     {
  //       "type": "tool_result",
  //       "tool_use_id": "tool_call_id",
  //       "content": "8"
  //     }
  //   ]
  // }
  Future<void> _sendMessage(String userMessage) async {
    // TODO: Implement this method
    setState(() {
      _messages.add(Message(
        text: userMessage,
        isUser: true,
        toolCalls: [],
      ));
      _isLoading = true;
    });

    try {
      final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Anthropic API key not found in .env');
      }

      // TODO: Build messages array for Claude
      // TODO: Make initial request with tools
      // TODO: Check if Claude wants to use tools
      // TODO: If yes, execute tools and send results back
      // TODO: Continue until final response
      // TODO: Display AI response and tool usage

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
    }
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
            child: const Row(
              children: [
                Icon(Icons.build, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI has access to: Calculator, Weather, Search',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(width: 12),
                  Text('AI is working...'),
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

// TODO: Create MessageWidget to display messages and tool calls
class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement message display with tool usage indicators
    return Container();
  }
}
