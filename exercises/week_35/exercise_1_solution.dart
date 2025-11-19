// Exercise 1: Simple AI Chat with OpenAI (Beginner) - SOLUTION
//
// This solution demonstrates basic AI API integration with OpenAI's GPT model.
//
// SETUP INSTRUCTIONS:
// 1. Get your OpenAI API key from: https://platform.openai.com/api-keys
// 2. Create a .env file in your project root with:
//    OPENAI_API_KEY=your_key_here
// 3. Add to pubspec.yaml:
//    dependencies:
//      http: ^1.1.0
//      flutter_dotenv: ^5.1.0
// 4. Add to pubspec.yaml assets section:
//    assets:
//      - .env
// 5. In main.dart, load dotenv before runApp:
//    await dotenv.load(fileName: ".env");
//
// SECURITY WARNING:
// - NEVER commit your .env file to version control
// - Add .env to your .gitignore file
// - For production apps, use a backend proxy server

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
      title: 'Simple AI Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SimpleChatScreen(),
    );
  }
}

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({super.key});

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  /// Sends a message to OpenAI's GPT model and displays the response
  Future<void> _sendMessage(String message) async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      // Get API key from environment variables
      final apiKey = dotenv.env['OPENAI_API_KEY'];

      // Validate API key exists
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'OpenAI API key not found.\n\n'
          'Please:\n'
          '1. Create a .env file in your project root\n'
          '2. Add: OPENAI_API_KEY=your_key_here\n'
          '3. Get your key from: https://platform.openai.com/api-keys',
        );
      }

      // OpenAI Chat Completions endpoint
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');

      // Prepare headers with authorization
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      // Prepare request body
      final body = jsonEncode({
        'model': 'gpt-3.5-turbo', // Using GPT-3.5 for cost efficiency
        'messages': [
          {
            'role': 'user',
            'content': message,
          },
        ],
        'max_tokens': 500, // Limit response length
        'temperature': 0.7, // Control randomness (0-2)
      });

      // Make the API request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out. Please try again.');
        },
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        final data = jsonDecode(response.body);

        // Extract AI message from response
        final aiMessage = data['choices'][0]['message']['content'] as String;

        setState(() {
          _response = aiMessage.trim();
        });
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your .env file.\n'
          'Status: ${response.statusCode}',
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          'Rate limit exceeded. Please wait a moment and try again.\n'
          'Status: ${response.statusCode}',
        );
      } else {
        // Parse error message from response
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']['message'] ?? 'Unknown error';
        throw Exception(
          'API request failed.\n'
          'Status: ${response.statusCode}\n'
          'Message: $errorMessage',
        );
      }
    } on http.ClientException catch (e) {
      setState(() {
        _response = 'Network error: ${e.message}\n\n'
            'Please check your internet connection.';
      });
    } on FormatException catch (e) {
      setState(() {
        _response = 'Error parsing response: $e\n\n'
            'The API response was not in the expected format.';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
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
        title: const Text('Simple AI Chat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Ask AI anything...',
                hintText: 'e.g., Explain quantum computing in simple terms',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.chat),
              ),
              maxLines: 3,
              enabled: !_isLoading,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty && !_isLoading) {
                  _sendMessage(value.trim());
                }
              },
            ),
            const SizedBox(height: 16),

            // Send button
            ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
              icon: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(_isLoading ? 'Thinking...' : 'Send to AI'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Response area header
            Row(
              children: [
                const Icon(Icons.smart_toy, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'AI Response:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_response.isNotEmpty && !_isLoading)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    tooltip: 'Copy response',
                    onPressed: () {
                      // In a real app, implement clipboard copy
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Response copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Response area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'AI is thinking...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          _response.isEmpty
                              ? 'AI response will appear here...\n\n'
                                  'Try asking:\n'
                                  '• Explain a complex topic\n'
                                  '• Write a poem or story\n'
                                  '• Help with coding problems\n'
                                  '• Answer questions'
                              : _response,
                          style: TextStyle(
                            fontSize: 16,
                            color: _response.isEmpty ? Colors.grey : Colors.black87,
                            height: 1.5,
                          ),
                        ),
                ),
              ),
            ),

            // Usage info
            if (!_isLoading && _response.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Using GPT-3.5-Turbo (~\$0.002 per 1K tokens)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
