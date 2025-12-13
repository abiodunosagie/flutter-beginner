// Exercise 1: Simple AI Chat with OpenAI (Beginner)
//
// In this exercise, you'll build a basic AI chat interface that communicates
// with OpenAI's GPT model. This introduces you to AI API integration basics.
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
//
// Learning Objectives:
// - Make HTTP POST requests to OpenAI API
// - Parse JSON responses
// - Handle async operations
// - Display AI responses in UI
// - Manage API keys securely

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

  // TODO: Create a method to send a message to OpenAI
  // Method signature: Future<void> _sendMessage(String message)
  //
  // Steps:
  // 1. Set _isLoading to true
  // 2. Get API key from dotenv: dotenv.env['OPENAI_API_KEY']
  // 3. Create the API endpoint URL: https://api.openai.com/v1/chat/completions
  // 4. Create headers with Authorization and Content-Type
  // 5. Create request body with model and messages
  // 6. Make POST request using http.post()
  // 7. Parse response and extract the AI's message
  // 8. Update _response with the result
  // 9. Handle errors appropriately
  // 10. Set _isLoading to false
  //
  // Example request body:
  // {
  //   "model": "gpt-3.5-turbo",
  //   "messages": [
  //     {"role": "user", "content": "Your message here"}
  //   ]
  // }
  //
  // Response structure:
  // {
  //   "choices": [
  //     {
  //       "message": {
  //         "content": "AI response here"
  //       }
  //     }
  //   ]
  // }

  Future<void> _sendMessage(String message) async {
    // TODO: Implement this method
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      // TODO: Get API key from environment
      final apiKey = ''; // Get from dotenv

      // TODO: Validate API key
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found. Check your .env file.');
      }

      // TODO: Create API endpoint URL
      final url = Uri.parse(''); // OpenAI chat completions endpoint

      // TODO: Create headers
      final headers = {
        // Add Authorization header with Bearer token
        // Add Content-Type header
      };

      // TODO: Create request body
      final body = jsonEncode({
        // Add model and messages
      });

      // TODO: Make POST request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // TODO: Check response status
      if (response.statusCode == 200) {
        // TODO: Parse JSON response
        final data = jsonDecode(response.body);

        // TODO: Extract AI message from response
        final aiMessage = ''; // Extract from data['choices'][0]['message']['content']

        setState(() {
          _response = aiMessage;
        });
      } else {
        // TODO: Handle error response
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      // TODO: Handle exceptions
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
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Send button
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send to AI'),
            ),
            const SizedBox(height: 24),

            // Response area
            const Text(
              'AI Response:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _response.isEmpty && !_isLoading
                        ? 'AI response will appear here...'
                        : _response,
                    style: TextStyle(
                      fontSize: 16,
                      color: _response.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
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
