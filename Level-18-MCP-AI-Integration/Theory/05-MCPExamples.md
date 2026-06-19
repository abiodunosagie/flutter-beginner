# MCP Practical Examples

## The Big Idea In One Sentence

> Seeing MCP in action makes it click: each example exposes a tool the AI can call (read data, do a task), starting simple and building up, so you can picture using it in your own app.

Let's build real examples that demonstrate MCP concepts in action. These examples progress from simple to complex.

---

## Example 1: Simple MCP Server (Node.js)

This is the most basic MCP server you can build. It has one tool that greets users.

### Project Setup

```bash
# Create project
mkdir my-first-mcp-server
cd my-first-mcp-server

# Initialize Node.js project
npm init -y

# Install MCP SDK
npm install @modelcontextprotocol/sdk

# Create main file
touch index.js
```

### The Code

```javascript
// index.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// Create the server
const server = new Server(
  {
    name: 'greeting-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'greet',
        description: 'Greet a person by name',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'The name of the person to greet',
            },
            language: {
              type: 'string',
              enum: ['english', 'yoruba', 'hausa', 'igbo'],
              description: 'Language for the greeting',
            },
          },
          required: ['name'],
        },
      },
    ],
  };
});

// Implement tool logic
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === 'greet') {
    const { name, language = 'english' } = request.params.arguments;

    const greetings = {
      english: `Hello, ${name}! Welcome!`,
      yoruba: `Bawo, ${name}! Kaabo!`,
      hausa: `Sannu, ${name}! Barka da zuwa!`,
      igbo: `Ndewo, ${name}! Nnoo!`,
    };

    return {
      content: [
        {
          type: 'text',
          text: greetings[language] || greetings.english,
        },
      ],
    };
  }

  throw new Error(`Unknown tool: ${request.params.name}`);
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Greeting MCP server running...');
}

main().catch(console.error);
```

### package.json

```json
{
  "name": "greeting-server",
  "version": "1.0.0",
  "type": "module",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.6.0"
  }
}
```

### Testing the Server

```bash
# Test with echo (simulates client request)
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | node index.js
```

### Configure with Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "greeting": {
      "command": "node",
      "args": ["/path/to/my-first-mcp-server/index.js"]
    }
  }
}
```

---

## Example 2: File Manager MCP Server

A more practical server that manages files in a specific directory.

```javascript
// file-manager-server.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import fs from 'fs/promises';
import path from 'path';

// Configuration - only allow operations in this folder
const ALLOWED_DIRECTORY = process.argv[2] || './managed-files';

const server = new Server(
  {
    name: 'file-manager',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Helper to validate paths
function validatePath(filePath) {
  const fullPath = path.resolve(ALLOWED_DIRECTORY, filePath);
  if (!fullPath.startsWith(path.resolve(ALLOWED_DIRECTORY))) {
    throw new Error('Access denied: Path outside allowed directory');
  }
  return fullPath;
}

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'list_files',
        description: 'List all files in the managed directory',
        inputSchema: {
          type: 'object',
          properties: {
            subfolder: {
              type: 'string',
              description: 'Optional subfolder to list',
            },
          },
        },
      },
      {
        name: 'read_file',
        description: 'Read contents of a file',
        inputSchema: {
          type: 'object',
          properties: {
            filename: {
              type: 'string',
              description: 'Name of the file to read',
            },
          },
          required: ['filename'],
        },
      },
      {
        name: 'write_file',
        description: 'Write content to a file',
        inputSchema: {
          type: 'object',
          properties: {
            filename: {
              type: 'string',
              description: 'Name of the file to write',
            },
            content: {
              type: 'string',
              description: 'Content to write to the file',
            },
          },
          required: ['filename', 'content'],
        },
      },
      {
        name: 'delete_file',
        description: 'Delete a file',
        inputSchema: {
          type: 'object',
          properties: {
            filename: {
              type: 'string',
              description: 'Name of the file to delete',
            },
          },
          required: ['filename'],
        },
      },
      {
        name: 'search_files',
        description: 'Search for files containing specific text',
        inputSchema: {
          type: 'object',
          properties: {
            query: {
              type: 'string',
              description: 'Text to search for',
            },
          },
          required: ['query'],
        },
      },
    ],
  };
});

// Implement tools
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'list_files': {
        const dirPath = validatePath(args.subfolder || '.');
        const files = await fs.readdir(dirPath, { withFileTypes: true });

        const fileList = files.map(f => ({
          name: f.name,
          type: f.isDirectory() ? 'directory' : 'file',
        }));

        return {
          content: [{
            type: 'text',
            text: JSON.stringify(fileList, null, 2),
          }],
        };
      }

      case 'read_file': {
        const filePath = validatePath(args.filename);
        const content = await fs.readFile(filePath, 'utf-8');

        return {
          content: [{
            type: 'text',
            text: content,
          }],
        };
      }

      case 'write_file': {
        const filePath = validatePath(args.filename);
        await fs.writeFile(filePath, args.content, 'utf-8');

        return {
          content: [{
            type: 'text',
            text: `File "${args.filename}" written successfully.`,
          }],
        };
      }

      case 'delete_file': {
        const filePath = validatePath(args.filename);
        await fs.unlink(filePath);

        return {
          content: [{
            type: 'text',
            text: `File "${args.filename}" deleted successfully.`,
          }],
        };
      }

      case 'search_files': {
        const dirPath = validatePath('.');
        const files = await fs.readdir(dirPath);
        const results = [];

        for (const file of files) {
          try {
            const content = await fs.readFile(
              path.join(dirPath, file),
              'utf-8'
            );
            if (content.includes(args.query)) {
              results.push(file);
            }
          } catch (e) {
            // Skip directories and unreadable files
          }
        }

        return {
          content: [{
            type: 'text',
            text: results.length > 0
              ? `Files containing "${args.query}":\n${results.join('\n')}`
              : `No files found containing "${args.query}"`,
          }],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    return {
      content: [{
        type: 'text',
        text: `Error: ${error.message}`,
      }],
      isError: true,
    };
  }
});

// Start server
async function main() {
  // Ensure managed directory exists
  await fs.mkdir(ALLOWED_DIRECTORY, { recursive: true });

  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error(`File Manager MCP server running...`);
  console.error(`Managing directory: ${path.resolve(ALLOWED_DIRECTORY)}`);
}

main().catch(console.error);
```

---

## Example 3: Todo API MCP Server

An MCP server that wraps a REST API (useful pattern for existing backends).

```javascript
// todo-api-server.js
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// In-memory database (replace with real API calls)
let todos = [
  { id: 1, title: 'Learn MCP', completed: false, priority: 'high' },
  { id: 2, title: 'Build Flutter app', completed: false, priority: 'medium' },
];
let nextId = 3;

const server = new Server(
  {
    name: 'todo-api',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'list_todos',
        description: 'Get all todos, optionally filtered by completion status',
        inputSchema: {
          type: 'object',
          properties: {
            completed: {
              type: 'boolean',
              description: 'Filter by completion status',
            },
            priority: {
              type: 'string',
              enum: ['high', 'medium', 'low'],
              description: 'Filter by priority',
            },
          },
        },
      },
      {
        name: 'add_todo',
        description: 'Create a new todo item',
        inputSchema: {
          type: 'object',
          properties: {
            title: {
              type: 'string',
              description: 'The todo title',
            },
            priority: {
              type: 'string',
              enum: ['high', 'medium', 'low'],
              description: 'Priority level',
            },
          },
          required: ['title'],
        },
      },
      {
        name: 'complete_todo',
        description: 'Mark a todo as completed',
        inputSchema: {
          type: 'object',
          properties: {
            id: {
              type: 'number',
              description: 'The todo ID',
            },
          },
          required: ['id'],
        },
      },
      {
        name: 'delete_todo',
        description: 'Delete a todo item',
        inputSchema: {
          type: 'object',
          properties: {
            id: {
              type: 'number',
              description: 'The todo ID',
            },
          },
          required: ['id'],
        },
      },
      {
        name: 'get_stats',
        description: 'Get todo statistics',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'list_todos': {
      let filtered = [...todos];

      if (args.completed !== undefined) {
        filtered = filtered.filter(t => t.completed === args.completed);
      }
      if (args.priority) {
        filtered = filtered.filter(t => t.priority === args.priority);
      }

      if (filtered.length === 0) {
        return {
          content: [{
            type: 'text',
            text: 'No todos found matching the criteria.',
          }],
        };
      }

      const todoList = filtered.map(t =>
        `[${t.completed ? 'x' : ' '}] #${t.id}: ${t.title} (${t.priority})`
      ).join('\n');

      return {
        content: [{
          type: 'text',
          text: `Todos:\n${todoList}`,
        }],
      };
    }

    case 'add_todo': {
      const newTodo = {
        id: nextId++,
        title: args.title,
        completed: false,
        priority: args.priority || 'medium',
      };
      todos.push(newTodo);

      return {
        content: [{
          type: 'text',
          text: `Created todo #${newTodo.id}: "${newTodo.title}" (${newTodo.priority} priority)`,
        }],
      };
    }

    case 'complete_todo': {
      const todo = todos.find(t => t.id === args.id);
      if (!todo) {
        return {
          content: [{
            type: 'text',
            text: `Todo #${args.id} not found.`,
          }],
          isError: true,
        };
      }

      todo.completed = true;

      return {
        content: [{
          type: 'text',
          text: `Completed: "${todo.title}"`,
        }],
      };
    }

    case 'delete_todo': {
      const index = todos.findIndex(t => t.id === args.id);
      if (index === -1) {
        return {
          content: [{
            type: 'text',
            text: `Todo #${args.id} not found.`,
          }],
          isError: true,
        };
      }

      const [deleted] = todos.splice(index, 1);

      return {
        content: [{
          type: 'text',
          text: `Deleted: "${deleted.title}"`,
        }],
      };
    }

    case 'get_stats': {
      const total = todos.length;
      const completed = todos.filter(t => t.completed).length;
      const pending = total - completed;
      const byPriority = {
        high: todos.filter(t => t.priority === 'high' && !t.completed).length,
        medium: todos.filter(t => t.priority === 'medium' && !t.completed).length,
        low: todos.filter(t => t.priority === 'low' && !t.completed).length,
      };

      return {
        content: [{
          type: 'text',
          text: `Todo Statistics:
- Total: ${total}
- Completed: ${completed}
- Pending: ${pending}

Pending by Priority:
- High: ${byPriority.high}
- Medium: ${byPriority.medium}
- Low: ${byPriority.low}`,
        }],
      };
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Todo API MCP server running...');
}

main().catch(console.error);
```

---

## Example 4: MCP Server in Python

The same todo server, but in Python (for those who prefer Python).

```python
# todo_server.py
import asyncio
import json
from mcp.server import Server, NotificationOptions
from mcp.server.models import InitializationOptions
import mcp.server.stdio
import mcp.types as types

# In-memory database
todos = [
    {"id": 1, "title": "Learn MCP", "completed": False, "priority": "high"},
    {"id": 2, "title": "Build Flutter app", "completed": False, "priority": "medium"},
]
next_id = 3

# Create server
server = Server("todo-server")


@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="list_todos",
            description="Get all todos",
            inputSchema={
                "type": "object",
                "properties": {
                    "completed": {
                        "type": "boolean",
                        "description": "Filter by completion status"
                    }
                }
            }
        ),
        types.Tool(
            name="add_todo",
            description="Add a new todo",
            inputSchema={
                "type": "object",
                "properties": {
                    "title": {
                        "type": "string",
                        "description": "The todo title"
                    },
                    "priority": {
                        "type": "string",
                        "enum": ["high", "medium", "low"],
                        "description": "Priority level"
                    }
                },
                "required": ["title"]
            }
        ),
        types.Tool(
            name="complete_todo",
            description="Mark a todo as completed",
            inputSchema={
                "type": "object",
                "properties": {
                    "id": {
                        "type": "integer",
                        "description": "The todo ID"
                    }
                },
                "required": ["id"]
            }
        ),
        types.Tool(
            name="delete_todo",
            description="Delete a todo",
            inputSchema={
                "type": "object",
                "properties": {
                    "id": {
                        "type": "integer",
                        "description": "The todo ID"
                    }
                },
                "required": ["id"]
            }
        ),
    ]


@server.call_tool()
async def handle_call_tool(
    name: str,
    arguments: dict
) -> list[types.TextContent]:
    global next_id

    if name == "list_todos":
        filtered = todos
        if "completed" in arguments:
            filtered = [t for t in todos if t["completed"] == arguments["completed"]]

        if not filtered:
            return [types.TextContent(type="text", text="No todos found.")]

        todo_list = "\n".join([
            f"[{'x' if t['completed'] else ' '}] #{t['id']}: {t['title']} ({t['priority']})"
            for t in filtered
        ])
        return [types.TextContent(type="text", text=f"Todos:\n{todo_list}")]

    elif name == "add_todo":
        new_todo = {
            "id": next_id,
            "title": arguments["title"],
            "completed": False,
            "priority": arguments.get("priority", "medium")
        }
        next_id += 1
        todos.append(new_todo)
        return [types.TextContent(
            type="text",
            text=f"Created todo #{new_todo['id']}: \"{new_todo['title']}\""
        )]

    elif name == "complete_todo":
        todo_id = arguments["id"]
        for todo in todos:
            if todo["id"] == todo_id:
                todo["completed"] = True
                return [types.TextContent(
                    type="text",
                    text=f"Completed: \"{todo['title']}\""
                )]
        return [types.TextContent(type="text", text=f"Todo #{todo_id} not found.")]

    elif name == "delete_todo":
        todo_id = arguments["id"]
        for i, todo in enumerate(todos):
            if todo["id"] == todo_id:
                deleted = todos.pop(i)
                return [types.TextContent(
                    type="text",
                    text=f"Deleted: \"{deleted['title']}\""
                )]
        return [types.TextContent(type="text", text=f"Todo #{todo_id} not found.")]

    raise ValueError(f"Unknown tool: {name}")


async def main():
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="todo-server",
                server_version="1.0.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={}
                )
            )
        )


if __name__ == "__main__":
    asyncio.run(main())
```

### Running the Python Server

```bash
# Install dependencies
pip install mcp

# Run server
python todo_server.py
```

### Configure for Claude Desktop

```json
{
  "mcpServers": {
    "todo": {
      "command": "python",
      "args": ["/path/to/todo_server.py"]
    }
  }
}
```

---

## Example 5: Flutter App with AI Assistant

A complete Flutter app that talks to an AI with tool capabilities.

### Project Setup

```bash
flutter create ai_assistant_app
cd ai_assistant_app
```

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  flutter_riverpod: ^2.4.0
```

### lib/main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
```

### lib/models/message.dart

```dart
enum MessageRole { user, assistant, system }

class Message {
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final List<ToolCall>? toolCalls;
  final String? toolResult;

  Message({
    required this.content,
    required this.role,
    DateTime? timestamp,
    this.toolCalls,
    this.toolResult,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  ToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });
}
```

### lib/services/ai_service.dart

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class AIService {
  final String apiKey;
  final String baseUrl = 'https://api.anthropic.com/v1';

  AIService({required this.apiKey});

  // Define available tools
  final List<Map<String, dynamic>> tools = [
    {
      'name': 'get_weather',
      'description': 'Get current weather for a city',
      'input_schema': {
        'type': 'object',
        'properties': {
          'city': {
            'type': 'string',
            'description': 'City name',
          },
        },
        'required': ['city'],
      },
    },
    {
      'name': 'calculate',
      'description': 'Perform mathematical calculations',
      'input_schema': {
        'type': 'object',
        'properties': {
          'expression': {
            'type': 'string',
            'description': 'Math expression to evaluate',
          },
        },
        'required': ['expression'],
      },
    },
    {
      'name': 'get_time',
      'description': 'Get current time in a timezone',
      'input_schema': {
        'type': 'object',
        'properties': {
          'timezone': {
            'type': 'string',
            'description': 'Timezone (e.g., Africa/Lagos, America/New_York)',
          },
        },
        'required': ['timezone'],
      },
    },
  ];

  Future<Message> chat(List<Message> messages) async {
    // Convert messages to API format
    final apiMessages = messages.map((m) => {
      'role': m.role == MessageRole.user ? 'user' : 'assistant',
      'content': m.content,
    }).toList();

    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-20250514',
        'max_tokens': 1024,
        'tools': tools,
        'messages': apiMessages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['content'] as List;

    // Check if AI wants to use a tool
    for (final block in content) {
      if (block['type'] == 'tool_use') {
        // Execute the tool
        final toolResult = await _executeTool(
          block['name'],
          block['input'],
        );

        // Send tool result back to AI
        return _continueWithToolResult(
          messages,
          block['id'],
          block['name'],
          toolResult,
        );
      }
    }

    // Return text response
    final textBlock = content.firstWhere(
      (b) => b['type'] == 'text',
      orElse: () => {'text': 'No response'},
    );

    return Message(
      content: textBlock['text'],
      role: MessageRole.assistant,
    );
  }

  Future<String> _executeTool(
    String name,
    Map<String, dynamic> args,
  ) async {
    switch (name) {
      case 'get_weather':
        // Simulated weather (replace with real API)
        return jsonEncode({
          'city': args['city'],
          'temperature': 28,
          'condition': 'Partly Cloudy',
          'humidity': 65,
        });

      case 'calculate':
        try {
          // Simple expression evaluation
          final expr = args['expression'] as String;
          // In production, use a proper expression parser
          final result = _evaluateSimpleExpression(expr);
          return jsonEncode({'result': result});
        } catch (e) {
          return jsonEncode({'error': 'Could not evaluate: ${args['expression']}'});
        }

      case 'get_time':
        final now = DateTime.now();
        return jsonEncode({
          'timezone': args['timezone'],
          'time': now.toIso8601String(),
          'formatted': '${now.hour}:${now.minute}',
        });

      default:
        return jsonEncode({'error': 'Unknown tool: $name'});
    }
  }

  double _evaluateSimpleExpression(String expr) {
    // Very basic evaluation - use a proper library in production
    expr = expr.replaceAll(' ', '');

    if (expr.contains('+')) {
      final parts = expr.split('+');
      return double.parse(parts[0]) + double.parse(parts[1]);
    }
    if (expr.contains('-')) {
      final parts = expr.split('-');
      return double.parse(parts[0]) - double.parse(parts[1]);
    }
    if (expr.contains('*')) {
      final parts = expr.split('*');
      return double.parse(parts[0]) * double.parse(parts[1]);
    }
    if (expr.contains('/')) {
      final parts = expr.split('/');
      return double.parse(parts[0]) / double.parse(parts[1]);
    }

    return double.parse(expr);
  }

  Future<Message> _continueWithToolResult(
    List<Message> messages,
    String toolUseId,
    String toolName,
    String result,
  ) async {
    // Add tool result to conversation
    final updatedMessages = [
      ...messages.map((m) => {
        'role': m.role == MessageRole.user ? 'user' : 'assistant',
        'content': m.content,
      }),
      {
        'role': 'user',
        'content': [
          {
            'type': 'tool_result',
            'tool_use_id': toolUseId,
            'content': result,
          }
        ],
      },
    ];

    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-20250514',
        'max_tokens': 1024,
        'tools': tools,
        'messages': updatedMessages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['content'] as List;

    final textBlock = content.firstWhere(
      (b) => b['type'] == 'text',
      orElse: () => {'text': 'Tool executed successfully'},
    );

    return Message(
      content: textBlock['text'],
      role: MessageRole.assistant,
    );
  }
}
```

### lib/providers/chat_provider.dart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';
import '../services/ai_service.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  // Replace with your actual API key (use secure storage in production!)
  return AIService(apiKey: 'your-api-key-here');
});

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.watch(aiServiceProvider));
});

class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;

  ChatNotifier(this._aiService) : super(ChatState());

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = Message(
      content: content,
      role: MessageRole.user,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // Get AI response
      final response = await _aiService.chat(state.messages);

      state = state.copyWith(
        messages: [...state.messages, response],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    state = ChatState();
  }
}
```

### lib/screens/chat_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatProvider.notifier).sendMessage(text);
      _controller.clear();
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
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => ref.read(chatProvider.notifier).clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tool capabilities banner
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade50,
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This AI can: Check weather, Calculate math, Get time',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message = chatState.messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),

          // Loading indicator
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Thinking...'),
                ],
              ),
            ),

          // Error display
          if (chatState.error != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Text(
                chatState.error!,
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  onPressed: chatState.isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
```

---

## Example Conversations

Here's what you can ask the AI assistant:

```
User: "What's the weather in Lagos?"
AI: Uses get_weather tool
AI: "The weather in Lagos is currently 28 degrees with partly cloudy skies
     and 65% humidity."

User: "Calculate 15 * 23"
AI: Uses calculate tool
AI: "15 multiplied by 23 equals 345."

User: "What time is it in Lagos?"
AI: Uses get_time tool
AI: "The current time in Africa/Lagos is 14:30."

User: "What's the weather in Abuja and what's 100 / 4?"
AI: Uses both get_weather and calculate tools
AI: "In Abuja, it's 28 degrees and partly cloudy. And 100 divided by 4
     equals 25."
```

---

## Summary

| Example | Language | Purpose |
|---------|----------|---------|
| Greeting Server | Node.js | Basic MCP server structure |
| File Manager | Node.js | File operations with security |
| Todo API | Node.js | REST API patterns in MCP |
| Todo Server | Python | Python MCP server |
| Flutter App | Dart | Full Flutter app with AI tools |

---

## Quick Quiz

**Q1.** In these examples, what is the AI actually calling?

<details>
<summary>Answer</summary>
Tools exposed by an MCP server, each tool does a real action or returns real data.
</details>

**Q2.** Why start with a simple example before a complex one?

<details>
<summary>Answer</summary>
So you understand the basic request-tool-response flow before adding harder pieces on top.
</details>

**Q3.** What is the AI's job versus the tool's job?

<details>
<summary>Answer</summary>
The AI decides which tool to call and with what input; the tool does the actual work and returns a result.
</details>

---

## Assignment

### Problem 1: Design a tool

You want the AI to tell users the weather. What tool would the MCP server expose, and what input would it take?

### Problem 2: Whose job?

For "What's the weather in Lagos?", what does the AI do and what does the tool do?

### Problem 3: Next step

After these examples, where do you practice what you learned?

---

## Assignment Answers

### Problem 1: Design a tool

A `getWeather` tool that takes a city (and maybe a date) as input and returns the forecast.

### Problem 2: Whose job?

The AI understands the question and calls `getWeather(city: 'Lagos')`. The tool fetches and returns the actual weather data, which the AI then explains to the user.

### Problem 3: Next step

In the exercises: `Exercises/01-MCPExercises.md`.

---

**Next:** Practice what you learned with exercises

**Continue to:** `Exercises/01-MCPExercises.md`
