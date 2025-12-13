# Lesson 5: Integrating Anthropic Claude (Long Context & Function Calling)

## 5-Year-Old Analogy 🧠

Imagine you have a friend who has an AMAZING memory - they can remember an entire Harry Potter book after reading it once! And not only that, but this friend can use tools too. If you ask "What's the weather?", they don't just guess - they actually use a weather tool to check and give you the real answer. That's Claude! Claude can remember really long conversations (like reading a whole book) and can use special tools (called functions) to get real, accurate information!

---

## What Makes Claude Special?

**Anthropic Claude** stands out for:

1. **Massive Context Window**: 200,000 tokens (~150,000 words = 500 pages!)
2. **Function Calling**: Can use tools/APIs to get real data
3. **Extended Thinking**: Can "think" through complex problems
4. **Safety-First**: Built with Constitutional AI for safe responses
5. **Instruction Following**: Exceptionally good at following complex instructions
6. **Vision**: Claude 3 models can analyze images

### Claude Models (2025)

- **Claude 3.5 Sonnet**: Best balance (speed + capability)
- **Claude 3 Opus**: Most powerful, best reasoning
- **Claude 3 Haiku**: Fastest, most affordable
- **Claude 3 Sonnet**: Previous generation

---

## What We'll Build

1. ✅ Basic Claude chat integration
2. ✅ Long document analysis (entire books!)
3. ✅ Function calling (weather, calculator, database queries)
4. ✅ Extended thinking for complex problems
5. ✅ Vision capabilities
6. ✅ Multi-turn conversations with context

---

## Step 1: Create Claude Models

```dart
// lib/models/claude_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'claude_models.g.dart';

// Message in conversation
@JsonSerializable()
class ClaudeMessage {
  final String role; // 'user' or 'assistant'
  final dynamic content; // Can be String or List<ContentBlock>

  ClaudeMessage({
    required this.role,
    required this.content,
  });

  factory ClaudeMessage.user(String text) => ClaudeMessage(
        role: 'user',
        content: text,
      );

  factory ClaudeMessage.assistant(String text) => ClaudeMessage(
        role: 'assistant',
        content: text,
      );

  factory ClaudeMessage.fromJson(Map<String, dynamic> json) =>
      _$ClaudeMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ClaudeMessageToJson(this);

  String get text {
    if (content is String) return content as String;
    if (content is List) {
      return (content as List)
          .where((block) => block['type'] == 'text')
          .map((block) => block['text'])
          .join('\n');
    }
    return '';
  }
}

// Tool (Function) Definition
@JsonSerializable()
class ClaudeTool {
  final String name;
  final String description;
  @JsonKey(name: 'input_schema')
  final Map<String, dynamic> inputSchema;

  ClaudeTool({
    required this.name,
    required this.description,
    required this.inputSchema,
  });

  factory ClaudeTool.fromJson(Map<String, dynamic> json) =>
      _$ClaudeToolFromJson(json);

  Map<String, dynamic> toJson() => _$ClaudeToolToJson(this);
}

// Request
@JsonSerializable()
class ClaudeRequest {
  final String model;
  final List<ClaudeMessage> messages;
  @JsonKey(name: 'max_tokens')
  final int maxTokens;
  @JsonKey(includeIfNull: false)
  final String? system;
  @JsonKey(includeIfNull: false)
  final double? temperature;
  @JsonKey(includeIfNull: false)
  final List<ClaudeTool>? tools;
  @JsonKey(includeIfNull: false)
  final bool? stream;

  ClaudeRequest({
    required this.model,
    required this.messages,
    required this.maxTokens,
    this.system,
    this.temperature,
    this.tools,
    this.stream,
  });

  factory ClaudeRequest.fromJson(Map<String, dynamic> json) =>
      _$ClaudeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClaudeRequestToJson(this);
}

// Usage
@JsonSerializable()
class ClaudeUsage {
  @JsonKey(name: 'input_tokens')
  final int inputTokens;
  @JsonKey(name: 'output_tokens')
  final int outputTokens;

  ClaudeUsage({
    required this.inputTokens,
    required this.outputTokens,
  });

  int get totalTokens => inputTokens + outputTokens;

  factory ClaudeUsage.fromJson(Map<String, dynamic> json) =>
      _$ClaudeUsageFromJson(json);

  Map<String, dynamic> toJson() => _$ClaudeUsageToJson(this);
}

// Content block in response
@JsonSerializable()
class ContentBlock {
  final String type; // 'text' or 'tool_use'
  final String? text;
  final String? id;
  final String? name;
  final Map<String, dynamic>? input;

  ContentBlock({
    required this.type,
    this.text,
    this.id,
    this.name,
    this.input,
  });

  bool get isText => type == 'text';
  bool get isToolUse => type == 'tool_use';

  factory ContentBlock.fromJson(Map<String, dynamic> json) =>
      _$ContentBlockFromJson(json);

  Map<String, dynamic> toJson() => _$ContentBlockToJson(this);
}

// Response
@JsonSerializable()
class ClaudeResponse {
  final String id;
  final String type;
  final String role;
  final List<ContentBlock> content;
  final String model;
  @JsonKey(name: 'stop_reason')
  final String? stopReason;
  @JsonKey(name: 'stop_sequence')
  final String? stopSequence;
  final ClaudeUsage usage;

  ClaudeResponse({
    required this.id,
    required this.type,
    required this.role,
    required this.content,
    required this.model,
    this.stopReason,
    this.stopSequence,
    required this.usage,
  });

  String get text {
    return content
        .where((block) => block.isText)
        .map((block) => block.text ?? '')
        .join('\n');
  }

  List<ContentBlock> get toolUses {
    return content.where((block) => block.isToolUse).toList();
  }

  bool get hasToolUse => stopReason == 'tool_use';

  factory ClaudeResponse.fromJson(Map<String, dynamic> json) =>
      _$ClaudeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClaudeResponseToJson(this);
}
```

Generate code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 2: Create Claude Client

```dart
// lib/services/claude_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../models/ai_response.dart';
import '../models/claude_models.dart';
import '../services/base_http_client.dart';
import '../services/usage_tracker.dart';

class ClaudeClient {
  final BaseHTTPClient _httpClient = BaseHTTPClient();
  final APIConfig _config = APIConfig();
  final UsageTracker _tracker = UsageTracker();
  final Logger _logger = Logger();

  // Conversation history
  final List<ClaudeMessage> _conversationHistory = [];
  String? _systemPrompt;

  List<ClaudeMessage> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  void setSystemPrompt(String prompt) {
    _systemPrompt = prompt;
  }

  void clearConversation() {
    _conversationHistory.clear();
  }

  // ========== BASIC CHAT ==========

  Future<AIResponse> chat({
    required String prompt,
    String model = 'claude-3-haiku-20240307',
    double temperature = 0.7,
    int maxTokens = 4096,
    bool includeHistory = true,
  }) async {
    try {
      final apiKey = await _config.claudeApiKey;

      if (apiKey.isEmpty) {
        return AIResponse.error(
          error: AIErrorType.authentication,
          errorMessage: 'Claude API key not found',
          provider: AIProvider.claude,
          model: model,
        );
      }

      // Add user message
      final userMessage = ClaudeMessage.user(prompt);
      _conversationHistory.add(userMessage);

      // Prepare messages
      final messages = includeHistory
          ? List<ClaudeMessage>.from(_conversationHistory)
          : [userMessage];

      // Create request
      final request = ClaudeRequest(
        model: model,
        messages: messages,
        maxTokens: maxTokens,
        system: _systemPrompt,
        temperature: temperature,
      );

      _logger.d('Sending request to Claude...');

      // Make API call
      final response = await _httpClient.post(
        '${APIConfig.claudeBaseUrl}${APIConfig.claudeMessagesEndpoint}',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: request.toJson(),
      );

      // Parse response
      final jsonResponse = jsonDecode(response.body);
      final claudeResponse = ClaudeResponse.fromJson(jsonResponse);

      final content = claudeResponse.text;

      // Add assistant response to history
      _conversationHistory.add(ClaudeMessage.assistant(content));

      // Calculate cost
      final cost = UsageTracker.estimateClaudeCost(
        model: model,
        inputTokens: claudeResponse.usage.inputTokens,
        outputTokens: claudeResponse.usage.outputTokens,
      );

      final aiResponse = AIResponse.success(
        content: content,
        provider: AIProvider.claude,
        model: model,
        tokensUsed: claudeResponse.usage.totalTokens,
        cost: cost,
        metadata: {
          'stop_reason': claudeResponse.stopReason,
          'id': claudeResponse.id,
        },
      );

      await _tracker.trackRequest(aiResponse);
      return aiResponse;
    } on APIException catch (e) {
      _logger.e('Claude API error: $e');

      AIErrorType errorType = AIErrorType.unknown;
      if (e.statusCode == 401) errorType = AIErrorType.authentication;
      else if (e.statusCode == 429) errorType = AIErrorType.rateLimit;
      else if (e.statusCode == 400) errorType = AIErrorType.invalidRequest;
      else if (e.statusCode != null && e.statusCode! >= 500)
        errorType = AIErrorType.serverError;

      final errorResponse = AIResponse.error(
        error: errorType,
        errorMessage: e.message,
        provider: AIProvider.claude,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);
      return errorResponse;
    } catch (e) {
      _logger.e('Unexpected error: $e');

      final errorResponse = AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.claude,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);
      return errorResponse;
    }
  }

  // ========== LONG DOCUMENT ANALYSIS ==========

  Future<AIResponse> analyzeDocument({
    required String document,
    required String question,
    String model = 'claude-3-haiku-20240307',
    int maxTokens = 4096,
  }) async {
    final prompt = '''Here is a document:

<document>
$document
</document>

Please answer this question about the document:
$question''';

    return chat(
      prompt: prompt,
      model: model,
      maxTokens: maxTokens,
      includeHistory: false, // Don't include history for document analysis
    );
  }

  // ========== FUNCTION CALLING ==========

  Future<AIResponse> chatWithTools({
    required String prompt,
    required List<ClaudeTool> tools,
    required Map<String, Function> toolImplementations,
    String model = 'claude-3-5-sonnet-20241022',
    int maxTokens = 4096,
    int maxIterations = 5,
  }) async {
    try {
      final apiKey = await _config.claudeApiKey;

      if (apiKey.isEmpty) {
        return AIResponse.error(
          error: AIErrorType.authentication,
          errorMessage: 'Claude API key not found',
          provider: AIProvider.claude,
          model: model,
        );
      }

      final userMessage = ClaudeMessage.user(prompt);
      final messages = [userMessage];

      for (int iteration = 0; iteration < maxIterations; iteration++) {
        _logger.d('Tool iteration $iteration...');

        // Make request with tools
        final request = ClaudeRequest(
          model: model,
          messages: messages,
          maxTokens: maxTokens,
          system: _systemPrompt,
          tools: tools,
        );

        final response = await _httpClient.post(
          '${APIConfig.claudeBaseUrl}${APIConfig.claudeMessagesEndpoint}',
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          },
          body: request.toJson(),
        );

        final jsonResponse = jsonDecode(response.body);
        final claudeResponse = ClaudeResponse.fromJson(jsonResponse);

        // Check if Claude wants to use tools
        if (claudeResponse.hasToolUse) {
          // Add assistant's tool use to messages
          messages.add(ClaudeMessage(
            role: 'assistant',
            content: claudeResponse.content.map((c) => c.toJson()).toList(),
          ));

          // Execute each tool
          final toolResults = <Map<String, dynamic>>[];

          for (final toolUse in claudeResponse.toolUses) {
            _logger.d('Executing tool: ${toolUse.name}');

            final implementation = toolImplementations[toolUse.name];
            if (implementation == null) {
              toolResults.add({
                'type': 'tool_result',
                'tool_use_id': toolUse.id,
                'content': 'Error: Tool ${toolUse.name} not found',
                'is_error': true,
              });
              continue;
            }

            try {
              final result = await implementation(toolUse.input ?? {});
              toolResults.add({
                'type': 'tool_result',
                'tool_use_id': toolUse.id,
                'content': result.toString(),
              });
            } catch (e) {
              toolResults.add({
                'type': 'tool_result',
                'tool_use_id': toolUse.id,
                'content': 'Error: $e',
                'is_error': true,
              });
            }
          }

          // Add tool results to messages
          messages.add(ClaudeMessage(
            role: 'user',
            content: toolResults,
          ));
        } else {
          // No more tools needed, return final response
          final cost = UsageTracker.estimateClaudeCost(
            model: model,
            inputTokens: claudeResponse.usage.inputTokens,
            outputTokens: claudeResponse.usage.outputTokens,
          );

          return AIResponse.success(
            content: claudeResponse.text,
            provider: AIProvider.claude,
            model: model,
            tokensUsed: claudeResponse.usage.totalTokens,
            cost: cost,
            metadata: {
              'iterations': iteration + 1,
              'tools_used': toolImplementations.keys.join(', '),
            },
          );
        }
      }

      return AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: 'Max tool iterations ($maxIterations) exceeded',
        provider: AIProvider.claude,
        model: model,
      );
    } catch (e) {
      _logger.e('Tool calling error: $e');

      return AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.claude,
        model: model,
      );
    }
  }

  // ========== STREAMING ==========

  Stream<String> chatStream({
    required String prompt,
    String model = 'claude-3-haiku-20240307',
    double temperature = 0.7,
    int maxTokens = 4096,
    bool includeHistory = true,
  }) async* {
    try {
      final apiKey = await _config.claudeApiKey;

      if (apiKey.isEmpty) {
        yield '[ERROR: Claude API key not found]';
        return;
      }

      final userMessage = ClaudeMessage.user(prompt);
      _conversationHistory.add(userMessage);

      final messages = includeHistory
          ? List<ClaudeMessage>.from(_conversationHistory)
          : [userMessage];

      final request = ClaudeRequest(
        model: model,
        messages: messages,
        maxTokens: maxTokens,
        system: _systemPrompt,
        temperature: temperature,
        stream: true,
      );

      final httpRequest = http.Request(
        'POST',
        Uri.parse('${APIConfig.claudeBaseUrl}${APIConfig.claudeMessagesEndpoint}'),
      );

      httpRequest.headers.addAll({
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      });

      httpRequest.body = jsonEncode(request.toJson());

      final streamedResponse = await httpRequest.send();

      if (streamedResponse.statusCode != 200) {
        final errorBody = await streamedResponse.stream.bytesToString();
        yield '[ERROR: ${streamedResponse.statusCode} - $errorBody]';
        return;
      }

      String fullResponse = '';

      await for (final chunk in streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (chunk.isEmpty || !chunk.startsWith('data: ')) continue;

        final jsonString = chunk.substring(6);

        try {
          final json = jsonDecode(jsonString);
          final type = json['type'];

          if (type == 'content_block_delta') {
            final delta = json['delta'];
            if (delta['type'] == 'text_delta') {
              final text = delta['text'] as String;
              fullResponse += text;
              yield text;
            }
          }
        } catch (e) {
          _logger.w('Error parsing stream chunk: $e');
        }
      }

      if (fullResponse.isNotEmpty) {
        _conversationHistory.add(ClaudeMessage.assistant(fullResponse));
      }
    } catch (e) {
      _logger.e('Streaming error: $e');
      yield '[ERROR: $e]';
    }
  }
}
```

---

## Step 3: Create Tool Definitions

```dart
// lib/services/claude_tools.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/claude_models.dart';

class ClaudeTools {
  // ========== TOOL DEFINITIONS ==========

  static ClaudeTool get weatherTool => ClaudeTool(
        name: 'get_weather',
        description: 'Get the current weather for a location',
        inputSchema: {
          'type': 'object',
          'properties': {
            'location': {
              'type': 'string',
              'description': 'City name, e.g., "London" or "New York"',
            },
          },
          'required': ['location'],
        },
      );

  static ClaudeTool get calculatorTool => ClaudeTool(
        name: 'calculate',
        description: 'Perform a mathematical calculation',
        inputSchema: {
          'type': 'object',
          'properties': {
            'expression': {
              'type': 'string',
              'description': 'Mathematical expression, e.g., "2 + 2" or "sqrt(16)"',
            },
          },
          'required': ['expression'],
        },
      );

  static ClaudeTool get searchTool => ClaudeTool(
        name: 'search_web',
        description: 'Search the web for information',
        inputSchema: {
          'type': 'object',
          'properties': {
            'query': {
              'type': 'string',
              'description': 'Search query',
            },
          },
          'required': ['query'],
        },
      );

  static ClaudeTool get databaseQueryTool => ClaudeTool(
        name: 'query_database',
        description: 'Query a database for information',
        inputSchema: {
          'type': 'object',
          'properties': {
            'table': {
              'type': 'string',
              'description': 'Table name to query',
            },
            'conditions': {
              'type': 'object',
              'description': 'Query conditions as key-value pairs',
            },
          },
          'required': ['table'],
        },
      );

  // ========== TOOL IMPLEMENTATIONS ==========

  static Future<String> getWeather(Map<String, dynamic> input) async {
    final location = input['location'] as String;

    // In production, use a real weather API (OpenWeatherMap, WeatherAPI, etc.)
    // For demo, return mock data
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    return jsonEncode({
      'location': location,
      'temperature': 72,
      'conditions': 'Partly cloudy',
      'humidity': 65,
      'wind_speed': 8,
    });
  }

  static Future<String> calculate(Map<String, dynamic> input) async {
    final expression = input['expression'] as String;

    try {
      // Simple calculator (in production, use math_expressions package)
      final result = _evaluateExpression(expression);
      return result.toString();
    } catch (e) {
      return 'Error: Invalid expression';
    }
  }

  static Future<String> searchWeb(Map<String, dynamic> input) async {
    final query = input['query'] as String;

    // In production, use a real search API (Serper, SerpAPI, etc.)
    await Future.delayed(const Duration(seconds: 1));

    return jsonEncode({
      'query': query,
      'results': [
        {
          'title': 'Example Result 1',
          'snippet': 'This is a mock search result about $query...',
          'url': 'https://example.com/1',
        },
        {
          'title': 'Example Result 2',
          'snippet': 'Another mock result for $query...',
          'url': 'https://example.com/2',
        },
      ],
    });
  }

  static Future<String> queryDatabase(Map<String, dynamic> input) async {
    final table = input['table'] as String;
    final conditions = input['conditions'] as Map<String, dynamic>?;

    // Mock database query
    await Future.delayed(const Duration(milliseconds: 500));

    return jsonEncode({
      'table': table,
      'conditions': conditions,
      'results': [
        {'id': 1, 'name': 'Example Item 1'},
        {'id': 2, 'name': 'Example Item 2'},
      ],
    });
  }

  // Simple expression evaluator (replace with math_expressions in production)
  static double _evaluateExpression(String expr) {
    expr = expr.replaceAll(' ', '');

    // Very basic calculator
    if (expr.contains('+')) {
      final parts = expr.split('+');
      return double.parse(parts[0]) + double.parse(parts[1]);
    } else if (expr.contains('-')) {
      final parts = expr.split('-');
      return double.parse(parts[0]) - double.parse(parts[1]);
    } else if (expr.contains('*')) {
      final parts = expr.split('*');
      return double.parse(parts[0]) * double.parse(parts[1]);
    } else if (expr.contains('/')) {
      final parts = expr.split('/');
      return double.parse(parts[0]) / double.parse(parts[1]);
    }

    return double.parse(expr);
  }

  // Get all available tools
  static List<ClaudeTool> get allTools => [
        weatherTool,
        calculatorTool,
        searchTool,
        databaseQueryTool,
      ];

  // Get tool implementations map
  static Map<String, Function> get toolImplementations => {
        'get_weather': getWeather,
        'calculate': calculate,
        'search_web': searchWeb,
        'query_database': queryDatabase,
      };
}
```

---

## Step 4: Create Claude Demo Screen

```dart
// lib/screens/claude_demo_screen.dart
import 'package:flutter/material.dart';
import '../services/claude_client.dart';
import '../services/claude_tools.dart';

class ClaudeDemoScreen extends StatefulWidget {
  const ClaudeDemoScreen({Key? key}) : super(key: key);

  @override
  State<ClaudeDemoScreen> createState() => _ClaudeDemoScreenState();
}

class _ClaudeDemoScreenState extends State<ClaudeDemoScreen> {
  final ClaudeClient _client = ClaudeClient();
  final TextEditingController _promptController = TextEditingController();

  String _result = '';
  bool _isLoading = false;
  String _demoType = 'chat';

  @override
  void initState() {
    super.initState();
    _client.setSystemPrompt(
      'You are a helpful AI assistant. Provide clear, concise answers.',
    );
  }

  Future<void> _runDemo() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = 'Processing...';
    });

    switch (_demoType) {
      case 'chat':
        await _runBasicChat(prompt);
        break;
      case 'tools':
        await _runToolsDemo(prompt);
        break;
      case 'document':
        await _runDocumentAnalysis(prompt);
        break;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _runBasicChat(String prompt) async {
    final response = await _client.chat(
      prompt: prompt,
      model: 'claude-3-5-sonnet-20241022',
    );

    setState(() {
      if (response.isSuccess) {
        _result = response.content!;
      } else {
        _result = '❌ Error: ${response.errorMessage}';
      }
    });
  }

  Future<void> _runToolsDemo(String prompt) async {
    final response = await _client.chatWithTools(
      prompt: prompt,
      tools: ClaudeTools.allTools,
      toolImplementations: ClaudeTools.toolImplementations,
      model: 'claude-3-5-sonnet-20241022',
    );

    setState(() {
      if (response.isSuccess) {
        final iterations = response.metadata?['iterations'] ?? 'unknown';
        _result = '${response.content!}\n\n'
            '---\n'
            'Tool iterations: $iterations';
      } else {
        _result = '❌ Error: ${response.errorMessage}';
      }
    });
  }

  Future<void> _runDocumentAnalysis(String question) async {
    // Sample long document
    const document = '''
    The Great Gatsby, published in 1925, is a novel by American author F. Scott Fitzgerald.
    Set in the Jazz Age on Long Island, near New York City, the novel depicts first-person
    narrator Nick Carraway's interactions with mysterious millionaire Jay Gatsby and Gatsby's
    obsession to reunite with his former lover, Daisy Buchanan.

    The novel was inspired by a youthful romance Fitzgerald had with socialite Ginevra King,
    and the riotous parties he attended on Long Island's North Shore in 1922. Following a
    move to the French Riviera, Fitzgerald completed a rough draft of the novel in 1924.
    He submitted it to editor Maxwell Perkins, who persuaded Fitzgerald to revise the work
    over the following winter.

    After making revisions, Fitzgerald was satisfied with the text, but remained ambivalent
    about the book's title and considered several alternatives. The final title he desired
    was Under the Red, White, and Blue. Painter Francis Cugat's dust jacket art greatly
    impressed Fitzgerald, and he incorporated its imagery into the novel.
    ''';

    final response = await _client.analyzeDocument(
      document: document,
      question: question,
      model: 'claude-3-5-sonnet-20241022',
    );

    setState(() {
      if (response.isSuccess) {
        _result = response.content!;
      } else {
        _result = '❌ Error: ${response.errorMessage}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claude AI Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _client.clearConversation();
              setState(() {
                _result = '';
                _promptController.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Demo type selector
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'chat',
                  label: Text('Chat'),
                  icon: Icon(Icons.chat),
                ),
                ButtonSegment(
                  value: 'tools',
                  label: Text('Tools'),
                  icon: Icon(Icons.build),
                ),
                ButtonSegment(
                  value: 'document',
                  label: Text('Document'),
                  icon: Icon(Icons.document_scanner),
                ),
              ],
              selected: {_demoType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _demoType = newSelection.first;
                  _result = '';
                });
              },
            ),
            const SizedBox(height: 16),

            // Instructions
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _getInstructions(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: _getHintText(),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Quick prompts
            Wrap(
              spacing: 8,
              children: _getQuickPrompts()
                  .map((prompt) => ActionChip(
                        label: Text(prompt),
                        onPressed: () {
                          setState(() {
                            _promptController.text = prompt;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Submit button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runDemo,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_getDemoButtonText()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // Result
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _result.isEmpty ? 'Results will appear here...' : _result,
                    style: TextStyle(
                      color: _result.isEmpty ? Colors.grey : Colors.black,
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

  String _getInstructions() {
    switch (_demoType) {
      case 'chat':
        return 'Have a conversation with Claude. It remembers context!';
      case 'tools':
        return 'Claude can use tools! Ask about weather, calculations, or searches.';
      case 'document':
        return 'Ask questions about The Great Gatsby (pre-loaded document).';
      default:
        return '';
    }
  }

  String _getHintText() {
    switch (_demoType) {
      case 'chat':
        return 'Ask anything...';
      case 'tools':
        return 'Try: "What\'s the weather in London?"';
      case 'document':
        return 'Ask about The Great Gatsby...';
      default:
        return '';
    }
  }

  String _getDemoButtonText() {
    switch (_demoType) {
      case 'chat':
        return 'Send Message';
      case 'tools':
        return 'Ask with Tools';
      case 'document':
        return 'Analyze Document';
      default:
        return 'Run';
    }
  }

  List<String> _getQuickPrompts() {
    switch (_demoType) {
      case 'chat':
        return [
          'Explain quantum computing',
          'Write a haiku about coding',
          'What\'s your name?',
        ];
      case 'tools':
        return [
          'What\'s the weather in London?',
          'Calculate 123 * 456',
          'Search for Flutter tutorials',
        ];
      case 'document':
        return [
          'Who is the main character?',
          'When was this published?',
          'Summarize the plot',
        ];
      default:
        return [];
    }
  }
}
```

---

## Key Features

### 1. **Long Context Window** (200K tokens)

```dart
// You can send ENTIRE BOOKS to Claude!
final book = await File('entire_book.txt').readAsString();

final response = await _client.analyzeDocument(
  document: book, // Could be 100,000+ words!
  question: 'Summarize the main themes and character arcs',
  model: 'claude-3-5-sonnet-20241022',
);
```

### 2. **Function Calling**

Claude can decide which tools to use:

```dart
// User asks: "What's 15 * 23 and what's the weather in Paris?"

// Claude will:
// 1. Call calculate tool with "15 * 23"
// 2. Call weather tool with "Paris"
// 3. Combine results in natural language response
```

### 3. **Superior Instruction Following**

Claude is excellent at following complex, multi-step instructions:

```dart
_client.setSystemPrompt('''
You are a code reviewer. When reviewing code:
1. Check for bugs
2. Suggest performance improvements
3. Verify best practices
4. Rate code quality 1-10
5. Provide specific line-by-line feedback

Always format your response as:
**Bugs**: [list]
**Performance**: [suggestions]
**Best Practices**: [verification]
**Rating**: X/10
**Detailed Review**: [line by line]
''');
```

---

## Best Practices

### 1. Use XML Tags for Structure

Claude works great with XML tags:

```dart
final prompt = '''
<task>Analyze this code for bugs</task>
<code>
$userCode
</code>
<requirements>
- Find security vulnerabilities
- Check for memory leaks
- Verify error handling
</requirements>
''';
```

### 2. Choose Right Model for Task

- **Haiku**: Simple Q&A, fast responses
- **Sonnet**: Most tasks, balanced
- **Opus**: Complex reasoning, critical decisions

### 3. Leverage Long Context

Instead of multiple API calls, send everything at once:

```dart
// ❌ Bad: Multiple calls
await chat(prompt: 'Summarize chapter 1');
await chat(prompt: 'Summarize chapter 2');
await chat(prompt: 'Summarize chapter 3');

// ✅ Good: One call with all context
await analyzeDocument(
  document: 'Chapter 1\n...\nChapter 2\n...\nChapter 3\n...',
  question: 'Summarize all chapters',
);
```

---

## Summary

You now have Claude integration with:

- ✅ Basic chat with long context
- ✅ Document analysis (up to 500 pages!)
- ✅ Function calling with multiple tools
- ✅ Streaming responses
- ✅ Conversation history
- ✅ Cost tracking

**Next lesson**: Building beautiful AI chat interfaces with markdown, code highlighting, and streaming!
