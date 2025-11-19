// Exercise 5: Complete AI Assistant App (Advanced)
//
// Build a production-ready AI assistant with multiple providers,
// image generation, speech I/O, persistence, and cost tracking.
//
// Learning Objectives:
// - Architecture for multiple AI providers
// - Image generation with DALL-E
// - Speech-to-text and text-to-speech
// - Local data persistence
// - Cost tracking and rate limiting
// - Professional error handling
// - Settings management
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
//      path_provider: ^2.1.1

import 'dart:convert';
import 'dart:io';
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

// TODO: Create enum for AI providers
enum AIProvider {
  openai,
  gemini,
  claude,
}

// TODO: Create Message class with:
// - id, text, isUser, timestamp
// - provider, cost, imageUrl (for image generation)
class Message {
  // TODO: Implement

  // TODO: Add toJson() and fromJson() for persistence
}

// TODO: Create AIService class to handle all AI interactions
// This should:
// - Support multiple providers (OpenAI, Gemini, Claude)
// - Calculate costs per request
// - Handle rate limiting
// - Support streaming responses
class AIService {
  // TODO: Implement methods:
  // - Future<Message> sendMessage(String text, AIProvider provider)
  // - Future<String> generateImage(String prompt)
  // - Stream<String> sendMessageStream(String text, AIProvider provider)
  // - double calculateCost(AIProvider provider, int tokens)
}

// TODO: Create StorageService for conversation persistence
// Use SharedPreferences to save/load conversations
class StorageService {
  // TODO: Implement methods:
  // - Future<void> saveConversation(List<Message> messages)
  // - Future<List<Message>> loadConversation()
  // - Future<void> clearConversation()
  // - Future<void> saveSettings(Map<String, dynamic> settings)
  // - Future<Map<String, dynamic>> loadSettings()
}

// TODO: Create SpeechService for voice I/O
// Handle speech-to-text and text-to-speech
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  // TODO: Implement methods:
  // - Future<bool> initialize()
  // - Future<String?> listen()
  // - Future<void> speak(String text)
  // - void stop()
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

  AIProvider _selectedProvider = AIProvider.openai;
  bool _isLoading = false;
  bool _isListening = false;
  double _totalCost = 0.0;

  // TODO: Initialize services
  // - AIService
  // - StorageService
  // - SpeechService

  @override
  void initState() {
    super.initState();
    // TODO: Load saved conversation and settings
    // TODO: Initialize speech service
  }

  // TODO: Implement _sendMessage method
  // Send text message to selected AI provider
  // Track cost
  // Save conversation
  Future<void> _sendMessage(String text) async {
    // TODO: Implement
  }

  // TODO: Implement _generateImage method
  // Use DALL-E to generate image from prompt
  // Display in chat
  // Track cost
  Future<void> _generateImage(String prompt) async {
    // TODO: Implement
  }

  // TODO: Implement _startListening method
  // Use speech-to-text to capture voice input
  // Send to AI when done
  Future<void> _startListening() async {
    // TODO: Implement
  }

  // TODO: Implement _speakResponse method
  // Use text-to-speech to read AI response
  Future<void> _speakResponse(String text) async {
    // TODO: Implement
  }

  // TODO: Implement _clearConversation method
  // Clear messages and reset cost
  // Clear from storage
  void _clearConversation() {
    // TODO: Implement
  }

  // TODO: Implement _showSettings method
  // Show dialog with:
  // - Provider selection
  // - Voice settings
  // - Cost limits
  // - API key status
  void _showSettings() {
    // TODO: Implement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant Pro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // TODO: Add settings button
          // TODO: Add clear conversation button
          // TODO: Show total cost
        ],
      ),
      body: Column(
        children: [
          // TODO: Provider selector and cost display

          // TODO: Messages list

          // TODO: Loading indicator

          // TODO: Input area with:
          // - Text field
          // - Voice input button
          // - Image generation button
          // - Send button

          Container(
            padding: const EdgeInsets.all(16),
            child: const Text('TODO: Implement UI'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // TODO: Dispose services
    super.dispose();
  }
}

// TODO: Create ProviderSelectorWidget
// Shows available providers with status indicators

// TODO: Create MessageBubbleWidget
// Display message with provider badge, cost, timestamp
// Support image display for DALL-E results
// Voice playback button

// TODO: Create SettingsDialog
// Configure provider preferences, voice settings, cost limits

// TODO: Create ImageGenerationDialog
// Prompt input for DALL-E image generation
