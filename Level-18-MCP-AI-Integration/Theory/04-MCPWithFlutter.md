# MCP with Flutter: Building AI-Powered Apps

## The Big Idea In One Sentence

> A Flutter app can be an AI-powered client that talks to an MCP server (often through your own backend), so users chat and the AI uses real tools to answer and act.

Now let's explore how you can integrate MCP concepts into Flutter applications.

---

## Flutter and MCP: The Options

As a Flutter developer, you have several ways to work with MCP:

```
Option 1: Build an MCP Client in Flutter
         Your Flutter app connects directly to MCP servers

Option 2: Use an AI API with MCP support
         Call Claude/OpenAI API, which uses MCP on the backend

Option 3: Build an MCP Server that Flutter talks to
         Your server wraps your Flutter app's functionality

Option 4: Hybrid approach
         Combine traditional APIs with MCP-powered features
```

---

## Option 1: Building an MCP Client in Flutter

Your Flutter app can act as an MCP Host, connecting to MCP servers.

### Basic MCP Client Architecture:

```
+------------------------------------------+
|           YOUR FLUTTER APP               |
|                                          |
|  +------------------------------------+  |
|  |           MCP Client               |  |
|  |  - Connect to servers              |  |
|  |  - Discover tools                  |  |
|  |  - Call tools                      |  |
|  +------------------------------------+  |
|              |                           |
+------------------------------------------+
               |
    +----------+----------+
    |                     |
+--------+          +--------+
| Local  |          | Remote |
| Server |          | Server |
+--------+          +--------+
```

### Implementing MCP Client in Dart:

```dart
import 'dart:convert';
import 'dart:io';

/// Simple MCP Client for Flutter
class MCPClient {
  Process? _serverProcess;
  final List<Map<String, dynamic>> _availableTools = [];

  /// Connect to an MCP server (STDIO transport)
  Future<void> connect(String command, List<String> args) async {
    _serverProcess = await Process.start(command, args);

    // Listen for server responses
    _serverProcess!.stdout
        .transform(utf8.decoder)
        .listen(_handleServerMessage);

    // Initialize connection
    await _sendRequest('initialize', {
      'protocolVersion': '2024-11-05',
      'capabilities': {},
      'clientInfo': {
        'name': 'flutter-mcp-client',
        'version': '1.0.0',
      },
    });

    // Discover available tools
    await _discoverTools();
  }

  /// Discover what tools the server provides
  Future<void> _discoverTools() async {
    final response = await _sendRequest('tools/list', {});
    if (response['tools'] != null) {
      _availableTools.clear();
      _availableTools.addAll(List<Map<String, dynamic>>.from(response['tools']));
    }
  }

  /// Get list of available tools
  List<Map<String, dynamic>> get tools => List.unmodifiable(_availableTools);

  /// Call a tool on the server
  Future<Map<String, dynamic>> callTool(
    String toolName,
    Map<String, dynamic> arguments,
  ) async {
    return await _sendRequest('tools/call', {
      'name': toolName,
      'arguments': arguments,
    });
  }

  /// Send JSON-RPC request to server
  Future<Map<String, dynamic>> _sendRequest(
    String method,
    Map<String, dynamic> params,
  ) async {
    final request = jsonEncode({
      'jsonrpc': '2.0',
      'id': DateTime.now().millisecondsSinceEpoch,
      'method': method,
      'params': params,
    });

    _serverProcess!.stdin.writeln(request);

    // Wait for response (simplified - real implementation needs request tracking)
    // In production, use a Completer and match response IDs
    await Future.delayed(Duration(milliseconds: 100));

    return {}; // Placeholder - handle actual response
  }

  void _handleServerMessage(String message) {
    try {
      final json = jsonDecode(message);
      print('Server response: $json');
    } catch (e) {
      print('Error parsing server message: $e');
    }
  }

  /// Disconnect from server
  void disconnect() {
    _serverProcess?.kill();
    _serverProcess = null;
  }
}
```

### Using the MCP Client in a Flutter App:

```dart
import 'package:flutter/material.dart';

class MCPDemoScreen extends StatefulWidget {
  @override
  _MCPDemoScreenState createState() => _MCPDemoScreenState();
}

class _MCPDemoScreenState extends State<MCPDemoScreen> {
  final MCPClient _client = MCPClient();
  List<Map<String, dynamic>> _tools = [];
  String _result = '';
  bool _isConnected = false;

  Future<void> _connectToServer() async {
    try {
      await _client.connect('npx', [
        '-y',
        '@modelcontextprotocol/server-filesystem',
        '/tmp/test-folder',
      ]);

      setState(() {
        _isConnected = true;
        _tools = _client.tools;
      });
    } catch (e) {
      setState(() {
        _result = 'Error connecting: $e';
      });
    }
  }

  Future<void> _callTool(String toolName) async {
    try {
      final result = await _client.callTool(toolName, {
        'path': '/tmp/test-folder',
      });

      setState(() {
        _result = jsonEncode(result);
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MCP Demo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection status
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Text(_isConnected ? 'Connected' : 'Disconnected'),
              ],
            ),
            SizedBox(height: 16),

            // Connect button
            if (!_isConnected)
              ElevatedButton(
                onPressed: _connectToServer,
                child: Text('Connect to MCP Server'),
              ),

            // Available tools
            if (_isConnected) ...[
              Text('Available Tools:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...tools.map((tool) => Card(
                child: ListTile(
                  title: Text(tool['name']),
                  subtitle: Text(tool['description'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () => _callTool(tool['name']),
                  ),
                ),
              )),
            ],

            // Results
            SizedBox(height: 16),
            Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Text(_result),
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

---

## Option 2: Using AI APIs with MCP (More Common)

Most Flutter apps will use AI APIs that leverage MCP on the backend.

### Architecture:

```
Flutter App
     |
     | HTTP/REST
     v
AI API (Claude API)
     |
     | MCP (backend)
     v
MCP Servers (tools)
```

### Using Claude API with Tool Use:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeService {
  final String apiKey;
  final String baseUrl = 'https://api.anthropic.com/v1';

  ClaudeService({required this.apiKey});

  /// Send message with tool definitions
  Future<ClaudeResponse> sendMessage({
    required String message,
    List<Tool>? tools,
  }) async {
    final body = {
      'model': 'claude-sonnet-4-20250514',
      'max_tokens': 1024,
      'messages': [
        {'role': 'user', 'content': message},
      ],
      if (tools != null) 'tools': tools.map((t) => t.toJson()).toList(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return ClaudeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API error: ${response.body}');
    }
  }
}

/// Tool definition (similar to MCP tool)
class Tool {
  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;

  Tool({
    required this.name,
    required this.description,
    required this.inputSchema,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'input_schema': inputSchema,
  };
}

/// Response from Claude
class ClaudeResponse {
  final String id;
  final List<ContentBlock> content;
  final String? stopReason;

  ClaudeResponse({
    required this.id,
    required this.content,
    this.stopReason,
  });

  factory ClaudeResponse.fromJson(Map<String, dynamic> json) {
    return ClaudeResponse(
      id: json['id'],
      content: (json['content'] as List)
          .map((c) => ContentBlock.fromJson(c))
          .toList(),
      stopReason: json['stop_reason'],
    );
  }

  // Check if AI wants to use a tool
  bool get wantsToUseTool => content.any((c) => c.type == 'tool_use');

  // Get tool use requests
  List<ToolUse> get toolUses => content
      .where((c) => c.type == 'tool_use')
      .map((c) => c.toolUse!)
      .toList();
}

class ContentBlock {
  final String type;
  final String? text;
  final ToolUse? toolUse;

  ContentBlock({required this.type, this.text, this.toolUse});

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'],
      text: json['text'],
      toolUse: json['type'] == 'tool_use'
          ? ToolUse.fromJson(json)
          : null,
    );
  }
}

class ToolUse {
  final String id;
  final String name;
  final Map<String, dynamic> input;

  ToolUse({required this.id, required this.name, required this.input});

  factory ToolUse.fromJson(Map<String, dynamic> json) {
    return ToolUse(
      id: json['id'],
      name: json['name'],
      input: json['input'],
    );
  }
}
```

### Complete Example: AI Assistant with Tools

```dart
import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  @override
  _AIAssistantScreenState createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final ClaudeService _claude = ClaudeService(apiKey: 'your-api-key');
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // Define tools the AI can use
  final List<Tool> _tools = [
    Tool(
      name: 'get_weather',
      description: 'Get current weather for a city',
      inputSchema: {
        'type': 'object',
        'properties': {
          'city': {
            'type': 'string',
            'description': 'The city name',
          },
        },
        'required': ['city'],
      },
    ),
    Tool(
      name: 'calculate',
      description: 'Perform a mathematical calculation',
      inputSchema: {
        'type': 'object',
        'properties': {
          'expression': {
            'type': 'string',
            'description': 'Math expression to evaluate',
          },
        },
        'required': ['expression'],
      },
    ),
  ];

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });
    _controller.clear();

    try {
      // Send to Claude with tools
      var response = await _claude.sendMessage(
        message: text,
        tools: _tools,
      );

      // Check if Claude wants to use a tool
      while (response.wantsToUseTool) {
        for (final toolUse in response.toolUses) {
          // Execute the tool locally
          final result = await _executeTool(toolUse.name, toolUse.input);

          // Send tool result back to Claude
          response = await _claude.sendMessageWithToolResult(
            toolUseId: toolUse.id,
            result: result,
          );
        }
      }

      // Get final text response
      final textContent = response.content
          .where((c) => c.type == 'text')
          .map((c) => c.text!)
          .join();

      setState(() {
        _messages.add(ChatMessage(role: 'assistant', content: textContent));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: 'Error: $e',
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Execute tool locally (this is where you implement tool logic)
  Future<String> _executeTool(String name, Map<String, dynamic> input) async {
    switch (name) {
      case 'get_weather':
        // In real app, call weather API
        final city = input['city'];
        return '{"temperature": 28, "condition": "Sunny", "city": "$city"}';

      case 'calculate':
        // In real app, use math parser
        final expression = input['expression'];
        // Simplified - don't eval in production!
        return '{"result": 42, "expression": "$expression"}';

      default:
        return '{"error": "Unknown tool"}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Assistant')),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          // Input
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});
}
```

---

## Option 3: Building an MCP Server for Your App

You can create an MCP server that exposes your app's functionality.

### Use Case: Expose Flutter App Data to AI

```
AI Assistant (Claude Desktop)
          |
          | MCP Protocol
          v
Your MCP Server (Node.js/Python)
          |
          | HTTP API
          v
Your Flutter Backend
          |
          | Sync
          v
Your Flutter App
```

### Example: MCP Server for a Todo App

```javascript
// todo-mcp-server.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: 'todo-server',
  version: '1.0.0',
}, {
  capabilities: { tools: {} },
});

// In-memory todos (or connect to your Flutter backend)
let todos = [
  { id: 1, title: 'Learn MCP', done: false },
  { id: 2, title: 'Build Flutter app', done: false },
];

// List tools
server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'list_todos',
      description: 'Get all todos',
      inputSchema: { type: 'object', properties: {} },
    },
    {
      name: 'add_todo',
      description: 'Add a new todo',
      inputSchema: {
        type: 'object',
        properties: {
          title: { type: 'string', description: 'Todo title' },
        },
        required: ['title'],
      },
    },
    {
      name: 'complete_todo',
      description: 'Mark a todo as complete',
      inputSchema: {
        type: 'object',
        properties: {
          id: { type: 'number', description: 'Todo ID' },
        },
        required: ['id'],
      },
    },
  ],
}));

// Handle tool calls
server.setRequestHandler('tools/call', async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'list_todos':
      return {
        content: [{
          type: 'text',
          text: JSON.stringify(todos, null, 2),
        }],
      };

    case 'add_todo':
      const newTodo = {
        id: todos.length + 1,
        title: args.title,
        done: false,
      };
      todos.push(newTodo);
      return {
        content: [{
          type: 'text',
          text: `Added todo: "${args.title}"`,
        }],
      };

    case 'complete_todo':
      const todo = todos.find(t => t.id === args.id);
      if (todo) {
        todo.done = true;
        return {
          content: [{
            type: 'text',
            text: `Completed: "${todo.title}"`,
          }],
        };
      }
      return {
        content: [{
          type: 'text',
          text: 'Todo not found',
        }],
      };

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

Now you can ask Claude Desktop:
- "What are my todos?"
- "Add a todo to buy groceries"
- "Mark the first todo as done"

And it interacts with your app's data!

---

## Best Practices for MCP in Flutter

### 1. Error Handling

```dart
Future<void> callMCPTool(String tool, Map<String, dynamic> args) async {
  try {
    final result = await _mcpClient.callTool(tool, args);
    // Handle success
  } on MCPTimeoutException {
    // Handle timeout
    _showError('Tool took too long to respond');
  } on MCPToolNotFoundException {
    // Handle missing tool
    _showError('Tool not available');
  } on MCPConnectionException {
    // Handle connection issues
    _showError('Lost connection to server');
  } catch (e) {
    // Handle unexpected errors
    _showError('Something went wrong: $e');
  }
}
```

### 2. State Management with MCP

```dart
// Using Riverpod for MCP state
final mcpClientProvider = Provider<MCPClient>((ref) {
  final client = MCPClient();
  ref.onDispose(() => client.disconnect());
  return client;
});

final mcpConnectionProvider = FutureProvider<bool>((ref) async {
  final client = ref.watch(mcpClientProvider);
  await client.connect('npx', ['-y', '@modelcontextprotocol/server-filesystem', '/tmp']);
  return true;
});

final availableToolsProvider = FutureProvider<List<Tool>>((ref) async {
  await ref.watch(mcpConnectionProvider.future);
  final client = ref.watch(mcpClientProvider);
  return client.tools;
});
```

### 3. Caching Tool Results

```dart
class CachedMCPClient {
  final MCPClient _client;
  final Map<String, CachedResult> _cache = {};
  final Duration _cacheDuration;

  CachedMCPClient(this._client, {Duration? cacheDuration})
      : _cacheDuration = cacheDuration ?? Duration(minutes: 5);

  Future<Map<String, dynamic>> callTool(
    String name,
    Map<String, dynamic> args, {
    bool useCache = true,
  }) async {
    final cacheKey = '$name:${jsonEncode(args)}';

    if (useCache && _cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      if (DateTime.now().difference(cached.timestamp) < _cacheDuration) {
        return cached.result;
      }
    }

    final result = await _client.callTool(name, args);
    _cache[cacheKey] = CachedResult(result, DateTime.now());
    return result;
  }
}

class CachedResult {
  final Map<String, dynamic> result;
  final DateTime timestamp;

  CachedResult(this.result, this.timestamp);
}
```

---

## Summary

| Approach | Best For | Complexity |
|----------|----------|------------|
| MCP Client in Flutter | Desktop apps, direct tool access | High |
| AI API with tools | Most Flutter apps | Medium |
| MCP Server for Flutter | Exposing app to AI assistants | Medium |
| Hybrid | Complex applications | High |

---

## Key Takeaways

1. **Flutter can be an MCP Host** - Connect directly to MCP servers
2. **AI APIs support tool use** - Similar concept, easier to implement
3. **You can build MCP servers** - Expose your app to AI assistants
4. **MCP is about standards** - Learn once, apply everywhere

---

## Quick Quiz

**Q1.** In an AI-powered Flutter app, what role does the Flutter app usually play?

<details>
<summary>Answer</summary>
The client/UI: the user chats, and the app sends requests to an AI/MCP layer (often via your backend).
</details>

**Q2.** Why route AI/MCP calls through your own backend instead of straight from the app?

<details>
<summary>Answer</summary>
To keep API keys secret and control access, the device should not hold the secret keys (see Level 15 security).
</details>

**Q3.** What does MCP add on top of a normal AI chat in the app?

<details>
<summary>Answer</summary>
The ability for the AI to use real tools/data (not just talk), so it can actually do things for the user.
</details>

---

## Assignment

### Problem 1: The role

In an AI app, is the Flutter app the MCP client or the MCP server?

### Problem 2: Keep keys safe

Where should the secret AI/API key live, and why not in the app?

### Problem 3: Why bother with MCP?

Name one thing MCP lets your AI feature do that plain chat cannot.

---

## Assignment Answers

### Problem 1: The role

The client (the UI that the user talks to). The MCP server side exposes the tools/data.

### Problem 2: Keep keys safe

On your backend server, not in the app. Anything shipped in the app can be extracted, so secret keys must stay server-side.

### Problem 3: Why bother with MCP?

It lets the AI take real actions or fetch real data (look up an order, read a file, run a tool), instead of only generating text.

---

**Next:** See practical examples of MCP in action

**Continue to:** `05-MCPExamples.md`
