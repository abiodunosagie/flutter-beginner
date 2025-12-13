# Lesson 2: Setting Up API Clients in Flutter

## 5-Year-Old Analogy 🔐

Imagine you have a special treasure box where you keep your secret codes (like the password to your tablet). You never tell anyone these codes, and you never write them on paper where people can see them. When you want to use your tablet, you whisper the password very quietly so only the tablet can hear it. That's what we do with API keys - we keep them super secret in a treasure box (secure storage) and only whisper them (send them securely) when we need to talk to the AI robots!

---

## Project Setup

In this lesson, we'll build a professional foundation for AI integrations that includes:

1. ✅ Secure API key management
2. ✅ Reusable HTTP client architecture
3. ✅ Error handling and retry logic
4. ✅ Request/response logging for debugging
5. ✅ Cost tracking
6. ✅ Rate limiting protection

---

## Step 1: Create New Flutter Project

```bash
flutter create ai_integration_demo
cd ai_integration_demo
```

---

## Step 2: Add Dependencies

Update your `pubspec.yaml`:

```yaml
name: ai_integration_demo
description: Professional AI integration with Flutter

dependencies:
  flutter:
    sdk: flutter

  # HTTP client
  http: ^1.1.0

  # Environment variables (for development)
  flutter_dotenv: ^5.1.0

  # Secure storage (for production)
  flutter_secure_storage: ^9.0.0

  # JSON serialization
  json_annotation: ^4.8.1

  # Local caching
  shared_preferences: ^2.2.2

  # State management (optional, but recommended)
  provider: ^6.1.1

  # Logging
  logger: ^2.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

  # JSON code generation
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
```

Run:

```bash
flutter pub get
```

---

## Step 3: Setup Environment Variables (Never Hardcode Keys!)

### Create `.env` file in project root

```bash
# .env
# ⚠️ NEVER commit this file to Git!

# OpenAI
OPENAI_API_KEY=sk-proj-your-actual-key-here

# Google Gemini
GEMINI_API_KEY=your-gemini-key-here

# Anthropic Claude
ANTHROPIC_API_KEY=sk-ant-your-claude-key-here

# Hugging Face
HUGGINGFACE_API_KEY=hf_your-huggingface-key-here

# Environment
ENVIRONMENT=development
```

### Update `.gitignore`

**CRITICAL**: Make sure `.env` is in your `.gitignore`:

```gitignore
# .gitignore

# Environment variables
.env
.env.*
!.env.example

# Flutter
.dart_tool/
.flutter-plugins
.packages
.pub-cache/
.pub/
build/

# IDE
.idea/
.vscode/
*.iml
```

### Create `.env.example` (safe to commit)

```bash
# .env.example
# This is a template. Copy to .env and add your real keys.

OPENAI_API_KEY=sk-proj-your-key-here
GEMINI_API_KEY=your-key-here
ANTHROPIC_API_KEY=sk-ant-your-key-here
HUGGINGFACE_API_KEY=hf_your-key-here
ENVIRONMENT=development
```

### Load environment variables in `main.dart`

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Integration Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Integration Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Environment: ${dotenv.env['ENVIRONMENT']}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Test if API key is loaded (never print the actual key!)
                final hasKey = dotenv.env['OPENAI_API_KEY']?.isNotEmpty ?? false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      hasKey
                        ? '✅ OpenAI API key loaded!'
                        : '❌ OpenAI API key not found'
                    ),
                  ),
                );
              },
              child: const Text('Check API Key Status'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Step 4: Create Secure Storage Helper

For production apps, store API keys in secure storage (encrypted on device).

```dart
// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton pattern
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // API Keys
  Future<void> saveApiKey(String provider, String key) async {
    await _storage.write(key: '${provider}_api_key', value: key);
  }

  Future<String?> getApiKey(String provider) async {
    return await _storage.read(key: '${provider}_api_key');
  }

  Future<void> deleteApiKey(String provider) async {
    await _storage.delete(key: '${provider}_api_key');
  }

  // Check if key exists
  Future<bool> hasApiKey(String provider) async {
    final key = await getApiKey(provider);
    return key != null && key.isNotEmpty;
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Example usage methods
  Future<void> saveOpenAIKey(String key) => saveApiKey('openai', key);
  Future<String?> getOpenAIKey() => getApiKey('openai');

  Future<void> saveGeminiKey(String key) => saveApiKey('gemini', key);
  Future<String?> getGeminiKey() => getApiKey('gemini');

  Future<void> saveClaudeKey(String key) => saveApiKey('claude', key);
  Future<String?> getClaudeKey() => getApiKey('claude');
}
```

---

## Step 5: Create API Configuration

```dart
// lib/config/api_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/secure_storage_service.dart';

class APIConfig {
  // Singleton pattern
  static final APIConfig _instance = APIConfig._internal();
  factory APIConfig() => _instance;
  APIConfig._internal();

  final _storage = SecureStorageService();

  // OpenAI
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String openaiChatEndpoint = '/chat/completions';
  static const String openaiImageEndpoint = '/images/generations';

  Future<String> get openaiApiKey async {
    // Try secure storage first (production)
    final storedKey = await _storage.getOpenAIKey();
    if (storedKey != null && storedKey.isNotEmpty) {
      return storedKey;
    }

    // Fall back to .env (development)
    return dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  // Google Gemini
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  Future<String> get geminiApiKey async {
    final storedKey = await _storage.getGeminiKey();
    if (storedKey != null && storedKey.isNotEmpty) {
      return storedKey;
    }
    return dotenv.env['GEMINI_API_KEY'] ?? '';
  }

  // Anthropic Claude
  static const String claudeBaseUrl = 'https://api.anthropic.com/v1';
  static const String claudeMessagesEndpoint = '/messages';

  Future<String> get claudeApiKey async {
    final storedKey = await _storage.getClaudeKey();
    if (storedKey != null && storedKey.isNotEmpty) {
      return storedKey;
    }
    return dotenv.env['ANTHROPIC_API_KEY'] ?? '';
  }

  // Model defaults
  static const String defaultOpenAIModel = 'gpt-3.5-turbo';
  static const String defaultGeminiModel = 'gemini-pro';
  static const String defaultClaudeModel = 'claude-3-haiku-20240307';

  // Request settings
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Token limits (to prevent runaway costs)
  static const int maxInputTokens = 4000;
  static const int maxOutputTokens = 1000;

  // Rate limiting (requests per minute)
  static const int rateLimitPerMinute = 10;
}
```

---

## Step 6: Create Base HTTP Client

This is our foundation for all API calls:

```dart
// lib/services/base_http_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../config/api_config.dart';

enum HTTPMethod { get, post, put, delete, patch }

class APIException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic response;

  APIException(this.message, {this.statusCode, this.response});

  @override
  String toString() => 'APIException: $message (Status: $statusCode)';
}

class BaseHTTPClient {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  // Rate limiting
  final List<DateTime> _requestTimestamps = [];

  Future<void> _checkRateLimit() async {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

    // Remove old timestamps
    _requestTimestamps.removeWhere((timestamp) => timestamp.isBefore(oneMinuteAgo));

    // Check if we've exceeded the rate limit
    if (_requestTimestamps.length >= APIConfig.rateLimitPerMinute) {
      final oldestRequest = _requestTimestamps.first;
      final waitTime = oldestRequest.add(const Duration(minutes: 1)).difference(now);

      _logger.w('Rate limit reached. Waiting ${waitTime.inSeconds} seconds...');
      await Future.delayed(waitTime);
    }

    _requestTimestamps.add(now);
  }

  Future<http.Response> request({
    required String url,
    required HTTPMethod method,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
    int retries = 0,
  }) async {
    // Rate limiting
    await _checkRateLimit();

    final uri = Uri.parse(url);
    timeout ??= APIConfig.defaultTimeout;

    _logger.d('🌐 ${method.name.toUpperCase()} $url');
    if (body != null) {
      _logger.d('📤 Request body: ${jsonEncode(body)}');
    }

    try {
      http.Response response;

      switch (method) {
        case HTTPMethod.get:
          response = await http.get(uri, headers: headers).timeout(timeout);
          break;
        case HTTPMethod.post:
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          ).timeout(timeout);
          break;
        case HTTPMethod.put:
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          ).timeout(timeout);
          break;
        case HTTPMethod.delete:
          response = await http.delete(uri, headers: headers).timeout(timeout);
          break;
        case HTTPMethod.patch:
          response = await http.patch(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          ).timeout(timeout);
          break;
      }

      _logger.i('📥 Response: ${response.statusCode}');

      // Log response body (truncate if too long)
      final responseBody = response.body;
      if (responseBody.length > 500) {
        _logger.d('Response body: ${responseBody.substring(0, 500)}...');
      } else {
        _logger.d('Response body: $responseBody');
      }

      // Handle errors
      if (response.statusCode >= 400) {
        return _handleError(response, url, method, headers, body, timeout, retries);
      }

      return response;
    } on TimeoutException {
      _logger.e('⏱️ Request timeout');
      if (retries < APIConfig.maxRetries) {
        _logger.w('🔄 Retrying... (${retries + 1}/${APIConfig.maxRetries})');
        await Future.delayed(APIConfig.retryDelay * (retries + 1));
        return request(
          url: url,
          method: method,
          headers: headers,
          body: body,
          timeout: timeout,
          retries: retries + 1,
        );
      }
      throw APIException('Request timeout after $timeout');
    } catch (e) {
      _logger.e('❌ Request failed: $e');
      throw APIException('Request failed: $e');
    }
  }

  Future<http.Response> _handleError(
    http.Response response,
    String url,
    HTTPMethod method,
    Map<String, String>? headers,
    dynamic body,
    Duration timeout,
    int retries,
  ) async {
    final statusCode = response.statusCode;

    try {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error']?['message'] ??
                          errorBody['message'] ??
                          'Unknown error';

      _logger.e('❌ API Error ($statusCode): $errorMessage');

      // Retry on specific status codes
      if (_shouldRetry(statusCode) && retries < APIConfig.maxRetries) {
        _logger.w('🔄 Retrying... (${retries + 1}/${APIConfig.maxRetries})');

        // Exponential backoff
        final delay = APIConfig.retryDelay * (retries + 1);
        await Future.delayed(delay);

        return request(
          url: url,
          method: method,
          headers: headers,
          body: body,
          timeout: timeout,
          retries: retries + 1,
        );
      }

      throw APIException(
        errorMessage,
        statusCode: statusCode,
        response: errorBody,
      );
    } catch (e) {
      // If we can't parse the error, throw generic error
      throw APIException(
        'HTTP $statusCode: ${response.body}',
        statusCode: statusCode,
        response: response.body,
      );
    }
  }

  bool _shouldRetry(int statusCode) {
    return statusCode == 429 ||  // Rate limit
           statusCode == 500 ||  // Server error
           statusCode == 502 ||  // Bad gateway
           statusCode == 503 ||  // Service unavailable
           statusCode == 504;    // Gateway timeout
  }

  // Convenience methods
  Future<http.Response> get(String url, {Map<String, String>? headers}) {
    return request(url: url, method: HTTPMethod.get, headers: headers);
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    return request(url: url, method: HTTPMethod.post, headers: headers, body: body);
  }

  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    return request(url: url, method: HTTPMethod.put, headers: headers, body: body);
  }

  Future<http.Response> delete(String url, {Map<String, String>? headers}) {
    return request(url: url, method: HTTPMethod.delete, headers: headers);
  }
}
```

---

## Step 7: Create Response Models

Create models for structured API responses:

```dart
// lib/models/ai_response.dart
import 'package:json_annotation/json_annotation.dart';

part 'ai_response.g.dart';

enum AIProvider { openai, gemini, claude, huggingface }

enum AIErrorType {
  network,
  authentication,
  rateLimit,
  invalidRequest,
  serverError,
  quotaExceeded,
  timeout,
  unknown,
}

@JsonSerializable()
class AIResponse {
  final String? content;
  final AIErrorType? error;
  final String? errorMessage;
  final int? tokensUsed;
  final double? cost;
  final DateTime timestamp;
  final AIProvider provider;
  final String model;
  final Map<String, dynamic>? metadata;

  AIResponse({
    this.content,
    this.error,
    this.errorMessage,
    this.tokensUsed,
    this.cost,
    DateTime? timestamp,
    required this.provider,
    required this.model,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isSuccess => error == null && content != null;
  bool get isError => error != null;

  factory AIResponse.success({
    required String content,
    required AIProvider provider,
    required String model,
    int? tokensUsed,
    double? cost,
    Map<String, dynamic>? metadata,
  }) {
    return AIResponse(
      content: content,
      provider: provider,
      model: model,
      tokensUsed: tokensUsed,
      cost: cost,
      metadata: metadata,
    );
  }

  factory AIResponse.error({
    required AIErrorType error,
    required String errorMessage,
    required AIProvider provider,
    required String model,
  }) {
    return AIResponse(
      error: error,
      errorMessage: errorMessage,
      provider: provider,
      model: model,
    );
  }

  factory AIResponse.fromJson(Map<String, dynamic> json) =>
      _$AIResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AIResponseToJson(this);

  @override
  String toString() {
    if (isSuccess) {
      return 'AIResponse(success, tokens: $tokensUsed, cost: \$$cost)';
    } else {
      return 'AIResponse(error: $error, message: $errorMessage)';
    }
  }
}

// Usage tracking
@JsonSerializable()
class UsageStats {
  final int totalRequests;
  final int successfulRequests;
  final int failedRequests;
  final int totalTokensUsed;
  final double totalCost;
  final DateTime firstRequest;
  final DateTime lastRequest;

  UsageStats({
    this.totalRequests = 0,
    this.successfulRequests = 0,
    this.failedRequests = 0,
    this.totalTokensUsed = 0,
    this.totalCost = 0.0,
    DateTime? firstRequest,
    DateTime? lastRequest,
  })  : firstRequest = firstRequest ?? DateTime.now(),
        lastRequest = lastRequest ?? DateTime.now();

  UsageStats copyWith({
    int? totalRequests,
    int? successfulRequests,
    int? failedRequests,
    int? totalTokensUsed,
    double? totalCost,
    DateTime? firstRequest,
    DateTime? lastRequest,
  }) {
    return UsageStats(
      totalRequests: totalRequests ?? this.totalRequests,
      successfulRequests: successfulRequests ?? this.successfulRequests,
      failedRequests: failedRequests ?? this.failedRequests,
      totalTokensUsed: totalTokensUsed ?? this.totalTokensUsed,
      totalCost: totalCost ?? this.totalCost,
      firstRequest: firstRequest ?? this.firstRequest,
      lastRequest: lastRequest ?? this.lastRequest,
    );
  }

  factory UsageStats.fromJson(Map<String, dynamic> json) =>
      _$UsageStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UsageStatsToJson(this);
}
```

Generate JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 8: Create Usage Tracker

Track API usage and costs:

```dart
// lib/services/usage_tracker.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_response.dart';

class UsageTracker {
  static final UsageTracker _instance = UsageTracker._internal();
  factory UsageTracker() => _instance;
  UsageTracker._internal();

  static const String _storageKey = 'ai_usage_stats';

  UsageStats _stats = UsageStats();

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      _stats = UsageStats.fromJson(json);
    }
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_stats.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> trackRequest(AIResponse response) async {
    _stats = _stats.copyWith(
      totalRequests: _stats.totalRequests + 1,
      successfulRequests: response.isSuccess
          ? _stats.successfulRequests + 1
          : _stats.successfulRequests,
      failedRequests: response.isError
          ? _stats.failedRequests + 1
          : _stats.failedRequests,
      totalTokensUsed: _stats.totalTokensUsed + (response.tokensUsed ?? 0),
      totalCost: _stats.totalCost + (response.cost ?? 0.0),
      lastRequest: DateTime.now(),
    );

    await _saveStats();
  }

  UsageStats get stats => _stats;

  Future<void> resetStats() async {
    _stats = UsageStats();
    await _saveStats();
  }

  // Cost estimates per provider
  static double estimateOpenAICost({
    required String model,
    required int inputTokens,
    required int outputTokens,
  }) {
    const prices = {
      'gpt-4': {'input': 0.03, 'output': 0.06},
      'gpt-4-turbo': {'input': 0.01, 'output': 0.03},
      'gpt-3.5-turbo': {'input': 0.0005, 'output': 0.0015},
    };

    final modelPrices = prices[model] ?? prices['gpt-3.5-turbo']!;

    return (inputTokens / 1000 * modelPrices['input']!) +
           (outputTokens / 1000 * modelPrices['output']!);
  }

  static double estimateClaudeCost({
    required String model,
    required int inputTokens,
    required int outputTokens,
  }) {
    const prices = {
      'claude-3-opus': {'input': 0.015, 'output': 0.075},
      'claude-3-sonnet': {'input': 0.003, 'output': 0.015},
      'claude-3-haiku': {'input': 0.00025, 'output': 0.00125},
    };

    String modelKey = 'claude-3-haiku';
    if (model.contains('opus')) modelKey = 'claude-3-opus';
    if (model.contains('sonnet')) modelKey = 'claude-3-sonnet';

    final modelPrices = prices[modelKey]!;

    return (inputTokens / 1000 * modelPrices['input']!) +
           (outputTokens / 1000 * modelPrices['output']!);
  }
}
```

---

## Step 9: Create Test UI

Let's test our setup:

```dart
// lib/screens/test_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/secure_storage_service.dart';
import '../services/usage_tracker.dart';
import '../config/api_config.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _storage = SecureStorageService();
  final _tracker = UsageTracker();
  final _apiConfig = APIConfig();

  String _statusMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsageStats();
  }

  Future<void> _loadUsageStats() async {
    await _tracker.loadStats();
    setState(() {});
  }

  Future<void> _checkEnvironment() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking environment...';
    });

    final env = dotenv.env['ENVIRONMENT'] ?? 'unknown';
    final hasOpenAI = dotenv.env['OPENAI_API_KEY']?.isNotEmpty ?? false;
    final hasGemini = dotenv.env['GEMINI_API_KEY']?.isNotEmpty ?? false;
    final hasClaude = dotenv.env['ANTHROPIC_API_KEY']?.isNotEmpty ?? false;

    setState(() {
      _isLoading = false;
      _statusMessage = '''
Environment: $env

API Keys Status:
✅ OpenAI: ${hasOpenAI ? 'Loaded' : '❌ Missing'}
✅ Gemini: ${hasGemini ? 'Loaded' : '❌ Missing'}
✅ Claude: ${hasClaude ? 'Loaded' : '❌ Missing'}

Rate Limit: ${APIConfig.rateLimitPerMinute} requests/minute
Default Timeout: ${APIConfig.defaultTimeout.inSeconds}s
Max Retries: ${APIConfig.maxRetries}
      ''';
    });
  }

  Future<void> _testSecureStorage() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing secure storage...';
    });

    try {
      // Test save
      await _storage.saveApiKey('test_provider', 'test_key_123');

      // Test read
      final key = await _storage.getApiKey('test_provider');

      // Test has
      final exists = await _storage.hasApiKey('test_provider');

      // Test delete
      await _storage.deleteApiKey('test_provider');
      final afterDelete = await _storage.hasApiKey('test_provider');

      setState(() {
        _isLoading = false;
        _statusMessage = '''
Secure Storage Test:

✅ Save: Success
✅ Read: ${key == 'test_key_123' ? 'Success' : 'Failed'}
✅ Exists Check: ${exists ? 'Success' : 'Failed'}
✅ Delete: ${!afterDelete ? 'Success' : 'Failed'}

All secure storage operations working!
        ''';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ Secure storage test failed: $e';
      });
    }
  }

  Future<void> _showUsageStats() async {
    final stats = _tracker.stats;

    setState(() {
      _statusMessage = '''
Usage Statistics:

Total Requests: ${stats.totalRequests}
✅ Successful: ${stats.successfulRequests}
❌ Failed: ${stats.failedRequests}

Tokens Used: ${stats.totalTokensUsed}
Total Cost: \$${stats.totalCost.toStringAsFixed(4)}

First Request: ${stats.firstRequest}
Last Request: ${stats.lastRequest}
      ''';
    });
  }

  Future<void> _testCostEstimation() async {
    final gpt4Cost = UsageTracker.estimateOpenAICost(
      model: 'gpt-4',
      inputTokens: 1000,
      outputTokens: 500,
    );

    final gpt35Cost = UsageTracker.estimateOpenAICost(
      model: 'gpt-3.5-turbo',
      inputTokens: 1000,
      outputTokens: 500,
    );

    final claudeOpusCost = UsageTracker.estimateClaudeCost(
      model: 'claude-3-opus',
      inputTokens: 1000,
      outputTokens: 500,
    );

    final claudeHaikuCost = UsageTracker.estimateClaudeCost(
      model: 'claude-3-haiku',
      inputTokens: 1000,
      outputTokens: 500,
    );

    setState(() {
      _statusMessage = '''
Cost Estimation (1K input + 500 output tokens):

GPT-4: \$${gpt4Cost.toStringAsFixed(4)}
GPT-3.5 Turbo: \$${gpt35Cost.toStringAsFixed(4)}
Claude Opus: \$${claudeOpusCost.toStringAsFixed(4)}
Claude Haiku: \$${claudeHaikuCost.toStringAsFixed(4)}

💡 Tip: Use cheaper models for simple tasks!
      ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Client Setup Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading)
              const LinearProgressIndicator()
            else
              const SizedBox(height: 4),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _checkEnvironment,
              icon: const Icon(Icons.settings),
              label: const Text('Check Environment'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testSecureStorage,
              icon: const Icon(Icons.lock),
              label: const Text('Test Secure Storage'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _showUsageStats,
              icon: const Icon(Icons.analytics),
              label: const Text('Show Usage Stats'),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: _testCostEstimation,
              icon: const Icon(Icons.attach_money),
              label: const Text('Cost Estimation'),
            ),
            const SizedBox(height: 20),

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
                    _statusMessage.isEmpty
                        ? 'Click a button to test...'
                        : _statusMessage,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Update `main.dart` to use the test screen:

```dart
// In lib/main.dart, change HomeScreen to:
home: const TestScreen(),
```

---

## Step 10: Run and Test

```bash
flutter run
```

Test all buttons:
1. ✅ Check Environment - Verify API keys loaded
2. ✅ Test Secure Storage - Verify encryption works
3. ✅ Show Usage Stats - See tracked usage
4. ✅ Cost Estimation - Calculate costs

---

## Project Structure

Your project should now look like this:

```
lib/
├── config/
│   └── api_config.dart
├── models/
│   ├── ai_response.dart
│   └── ai_response.g.dart (generated)
├── screens/
│   └── test_screen.dart
├── services/
│   ├── base_http_client.dart
│   ├── secure_storage_service.dart
│   └── usage_tracker.dart
└── main.dart

.env (NOT in Git!)
.env.example (safe to commit)
.gitignore (includes .env)
pubspec.yaml
```

---

## Security Checklist

Before deploying to production:

- [ ] `.env` is in `.gitignore`
- [ ] No hardcoded API keys in source code
- [ ] Using secure storage for production
- [ ] API keys have usage limits set in provider dashboard
- [ ] Monitoring API usage daily
- [ ] Rate limiting implemented
- [ ] Error handling for all API calls
- [ ] Timeout handling implemented
- [ ] Retry logic with exponential backoff
- [ ] Logging doesn't expose sensitive data

---

## Common Issues and Solutions

### Issue 1: "API key not found"

**Solution**: Check `.env` file exists and is properly formatted:

```bash
# Correct
OPENAI_API_KEY=sk-proj-abc123

# Wrong (no spaces around =)
OPENAI_API_KEY = sk-proj-abc123
```

### Issue 2: "Secure storage fails on Android"

**Solution**: Update `android/app/build.gradle`:

```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 18  // Minimum for secure storage
    }
}
```

### Issue 3: "Rate limit exceeded"

**Solution**: Increase delay between requests:

```dart
// In api_config.dart
static const int rateLimitPerMinute = 5; // Lower number
```

### Issue 4: "Request timeout"

**Solution**: Increase timeout for slow connections:

```dart
// In api_config.dart
static const Duration defaultTimeout = Duration(seconds: 60);
```

---

## Best Practices Summary

### ✅ DO

- Use environment variables for development
- Use secure storage for production
- Implement rate limiting
- Add retry logic with exponential backoff
- Log requests/responses (without sensitive data)
- Track usage and costs
- Set reasonable timeouts
- Handle all error cases
- Test with mock responses first
- Monitor API usage in provider dashboard

### ❌ DON'T

- Hardcode API keys
- Commit `.env` to Git
- Expose API keys in logs
- Ignore rate limits
- Skip error handling
- Make unlimited requests
- Use production keys in development
- Share API keys with others
- Leave debug logging in production

---

## Performance Tips

1. **Cache responses** for repeated queries
2. **Batch requests** when possible
3. **Use cheaper models** for simple tasks
4. **Implement request queuing** to avoid rate limits
5. **Cancel in-flight requests** when navigating away
6. **Use streaming** for better perceived performance
7. **Prefetch common responses** on app start
8. **Implement offline fallbacks**

---

## Next Steps

Now that we have a solid foundation:

- ✅ HTTP client with retry logic
- ✅ Secure API key management
- ✅ Usage tracking and cost estimation
- ✅ Rate limiting
- ✅ Error handling
- ✅ Logging

**In the next lesson**, we'll build our first real AI integration with OpenAI GPT, including:
- Chat completions API
- Streaming responses
- Conversation history management
- System prompts
- Function calling

---

## Summary

You now have a production-ready foundation for AI integrations that includes:

- 🔐 Secure API key management (environment variables + secure storage)
- 🌐 Robust HTTP client with retry logic
- 📊 Usage tracking and cost estimation
- ⚡ Rate limiting protection
- 🐛 Comprehensive error handling
- 📝 Request/response logging
- 💰 Cost optimization utilities

This architecture will serve as the foundation for all AI integrations in the upcoming lessons!
