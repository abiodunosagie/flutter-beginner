# MCP Exercises

These exercises will help you practice MCP concepts. Start from Exercise 1 and work your way up.

---

## Exercise 1: Understand MCP Concepts (Theory)

Answer these questions in your own words:

### Questions:

1. **What is MCP and why was it created?**

2. **What are the three layers of MCP architecture?**

3. **How does MCP differ from a traditional REST API?**

4. **What is JSON-RPC and why does MCP use it?**

5. **What are MCP "tools" and how do they work?**

6. **Name three connection types MCP supports.**

### Check Your Answers:

<details>
<summary>Answer 1</summary>

MCP (Model Context Protocol) is a standard created by Anthropic for AI assistants to connect with external tools, files, and services. It was created to solve the problem of every AI system having its own way of connecting to tools - MCP provides ONE standard that works everywhere.
</details>

<details>
<summary>Answer 2</summary>

1. **Host** - The main AI application (like Claude Desktop)
2. **Client** - Manages connections to servers (lives inside the host)
3. **Server** - Provides tools and capabilities (like file access, database queries)
</details>

<details>
<summary>Answer 3</summary>

Key differences:
- **API**: Your code decides what to call, stateless, fixed endpoints
- **MCP**: AI decides what tools to use, contextual, dynamic discovery
- MCP allows AI to discover and choose tools based on the conversation context
</details>

<details>
<summary>Answer 4</summary>

JSON-RPC is a simple remote procedure call protocol using JSON. MCP uses it because:
- It's simple and lightweight
- Uses standard JSON format
- Supports request-response pattern
- Easy to implement in any language
</details>

<details>
<summary>Answer 5</summary>

MCP tools are actions that AI can perform. Each tool has:
- A name (like "get_weather")
- A description (what it does)
- An input schema (what parameters it accepts)
- An implementation (the actual code that runs)

The AI discovers available tools, decides which to use, and calls them with appropriate arguments.
</details>

<details>
<summary>Answer 6</summary>

1. **STDIO** - Standard input/output (subprocess communication)
2. **HTTP with SSE** - Server-Sent Events over HTTP
3. **WebSocket** - Persistent bidirectional connection
</details>

---

## Exercise 2: Configure Claude Desktop MCP

**Goal:** Set up a pre-built MCP server with Claude Desktop.

### Prerequisites:
- Claude Desktop installed
- Node.js installed

### Steps:

1. **Find your Claude config file:**

   macOS:
   ```
   ~/Library/Application Support/Claude/claude_desktop_config.json
   ```

   Windows:
   ```
   %APPDATA%\Claude\claude_desktop_config.json
   ```

2. **Create or edit the config file:**

   ```json
   {
     "mcpServers": {
       "filesystem": {
         "command": "npx",
         "args": [
           "-y",
           "@modelcontextprotocol/server-filesystem",
           "/path/to/your/safe/folder"
         ]
       }
     }
   }
   ```

3. **Replace the path** with an actual folder on your computer (e.g., `/Users/yourname/Documents/mcp-test`)

4. **Restart Claude Desktop**

5. **Test it!** Ask Claude:
   - "List the files in my folder"
   - "Create a file called hello.txt with the text 'Hello MCP!'"
   - "Read the contents of hello.txt"

### Verification:
- [ ] Config file created/edited
- [ ] Claude Desktop restarted
- [ ] Claude can list files
- [ ] Claude can create files
- [ ] Claude can read files

<details>
<summary>✅ Solution</summary>

A complete, working config (macOS path shown). Use a REAL folder you create first, e.g. `~/Documents/mcp-test`:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/yourname/Documents/mcp-test"
      ]
    }
  }
}
```

After saving and fully restarting Claude Desktop, you should see a tools/plug indicator showing the server connected. Then "Create a file called hello.txt with 'Hello MCP!'" actually writes the file into that folder, and "Read hello.txt" returns its contents.

Common gotchas: the JSON must be valid (no trailing commas), the folder path must already exist, and you must FULLY quit and reopen Claude Desktop (not just close the window) for it to reload the config. The server can only touch the folder you listed, which is the safety boundary.

</details>

---

## Exercise 3: Build Your First MCP Server

**Goal:** Create a simple MCP server that converts currencies.

### Project Setup:

```bash
mkdir currency-server
cd currency-server
npm init -y
npm install @modelcontextprotocol/sdk
```

### Edit package.json:

```json
{
  "name": "currency-server",
  "version": "1.0.0",
  "type": "module",
  "main": "index.js",
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.6.0"
  }
}
```

### Create index.js:

Implement a server with these tools:

1. **convert_currency** - Convert between currencies
   - Input: `amount` (number), `from` (string), `to` (string)
   - Output: Converted amount

2. **list_currencies** - List supported currencies
   - Input: none
   - Output: List of currency codes

### Starter Code (Complete the TODOs):

```javascript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// Exchange rates (simplified - use real API in production)
const RATES = {
  USD: 1,
  EUR: 0.85,
  GBP: 0.73,
  NGN: 1550,
  JPY: 149,
  CAD: 1.36,
};

const server = new Server(
  {
    name: 'currency-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// TODO: Implement ListToolsRequestSchema handler
// Define two tools: convert_currency and list_currencies
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      // TODO: Define convert_currency tool
      // - name: 'convert_currency'
      // - description: 'Convert amount from one currency to another'
      // - inputSchema with amount, from, to properties

      // TODO: Define list_currencies tool
      // - name: 'list_currencies'
      // - description: 'List all supported currencies'
      // - inputSchema with no required properties
    ],
  };
});

// TODO: Implement CallToolRequestSchema handler
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'convert_currency': {
      // TODO: Implement currency conversion
      // 1. Get amount, from, to from args
      // 2. Validate currencies exist in RATES
      // 3. Convert: (amount / RATES[from]) * RATES[to]
      // 4. Return result
      break;
    }

    case 'list_currencies': {
      // TODO: Return list of supported currencies
      break;
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Currency MCP server running...');
}

main().catch(console.error);
```

### Solution:

<details>
<summary>Click to see complete solution</summary>

```javascript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const RATES = {
  USD: 1,
  EUR: 0.85,
  GBP: 0.73,
  NGN: 1550,
  JPY: 149,
  CAD: 1.36,
};

const server = new Server(
  {
    name: 'currency-server',
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
        name: 'convert_currency',
        description: 'Convert an amount from one currency to another',
        inputSchema: {
          type: 'object',
          properties: {
            amount: {
              type: 'number',
              description: 'Amount to convert',
            },
            from: {
              type: 'string',
              description: 'Source currency code (e.g., USD, EUR, NGN)',
            },
            to: {
              type: 'string',
              description: 'Target currency code (e.g., USD, EUR, NGN)',
            },
          },
          required: ['amount', 'from', 'to'],
        },
      },
      {
        name: 'list_currencies',
        description: 'List all supported currencies with their codes',
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
    case 'convert_currency': {
      const { amount, from, to } = args;

      // Validate currencies
      const fromUpper = from.toUpperCase();
      const toUpper = to.toUpperCase();

      if (!RATES[fromUpper]) {
        return {
          content: [{
            type: 'text',
            text: `Unknown currency: ${from}. Use list_currencies to see supported currencies.`,
          }],
          isError: true,
        };
      }

      if (!RATES[toUpper]) {
        return {
          content: [{
            type: 'text',
            text: `Unknown currency: ${to}. Use list_currencies to see supported currencies.`,
          }],
          isError: true,
        };
      }

      // Convert via USD as base
      const inUSD = amount / RATES[fromUpper];
      const result = inUSD * RATES[toUpper];

      return {
        content: [{
          type: 'text',
          text: `${amount} ${fromUpper} = ${result.toFixed(2)} ${toUpper}`,
        }],
      };
    }

    case 'list_currencies': {
      const currencies = Object.keys(RATES).join(', ');
      return {
        content: [{
          type: 'text',
          text: `Supported currencies: ${currencies}`,
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
  console.error('Currency MCP server running...');
}

main().catch(console.error);
```
</details>

### Test Your Server:

```bash
# Test tools list
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | node index.js

# Test conversion
echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"convert_currency","arguments":{"amount":100,"from":"USD","to":"NGN"}}}' | node index.js
```

---

## Exercise 4: Add MCP Server to Claude Desktop

**Goal:** Connect your currency server to Claude Desktop.

### Steps:

1. **Get the full path to your index.js file:**
   ```bash
   pwd  # In your currency-server folder
   ```

2. **Edit Claude config:**
   ```json
   {
     "mcpServers": {
       "currency": {
         "command": "node",
         "args": ["/full/path/to/currency-server/index.js"]
       }
     }
   }
   ```

3. **Restart Claude Desktop**

4. **Test with these prompts:**
   - "What currencies do you support?"
   - "Convert 100 USD to Naira"
   - "How much is 50 euros in dollars?"
   - "Convert 1000 NGN to GBP"

### Verification Checklist:
- [ ] Server path added to config
- [ ] Claude Desktop restarted
- [ ] Claude lists currencies correctly
- [ ] Claude converts USD to NGN correctly
- [ ] Claude handles invalid currencies gracefully

<details>
<summary>✅ Solution</summary>

Use the ABSOLUTE path from `pwd` (relative paths do not work in the config):

```json
{
  "mcpServers": {
    "currency": {
      "command": "node",
      "args": ["/Users/yourname/projects/currency-server/index.js"]
    }
  }
}
```

After restarting Claude Desktop, the prompts should behave like this:
- "What currencies do you support?" → Claude calls your `list_currencies` tool and reads back the list (USD, NGN, EUR, GBP...).
- "Convert 100 USD to Naira" → Claude calls `convert` with `{from: 'USD', to: 'NGN', amount: 100}` and reports the result.
- "Convert 1000 NGN to GBP" → works the same with different args.
- An unknown currency (e.g. "Convert 5 XYZ to USD") → your tool returns an error message and Claude relays it politely instead of crashing.

If Claude does not see the tool: check the path is absolute and correct, run `node /full/path/index.js` once in a terminal to confirm the server starts without errors, then fully restart Claude Desktop.

</details>

---

## Exercise 5: Build a Python MCP Server

**Goal:** Create the same currency server in Python.

### Setup:

```bash
mkdir currency-server-python
cd currency-server-python
pip install mcp
```

### Create currency_server.py:

```python
import asyncio
from mcp.server import Server, NotificationOptions
from mcp.server.models import InitializationOptions
import mcp.server.stdio
import mcp.types as types

# Exchange rates
RATES = {
    "USD": 1,
    "EUR": 0.85,
    "GBP": 0.73,
    "NGN": 1550,
    "JPY": 149,
    "CAD": 1.36,
}

server = Server("currency-server")


@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    # TODO: Return list of tools
    # Similar to Exercise 3, define convert_currency and list_currencies
    pass


@server.call_tool()
async def handle_call_tool(
    name: str,
    arguments: dict
) -> list[types.TextContent]:
    # TODO: Implement tool logic
    pass


async def main():
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="currency-server",
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

### Solution:

<details>
<summary>Click to see complete solution</summary>

```python
import asyncio
from mcp.server import Server, NotificationOptions
from mcp.server.models import InitializationOptions
import mcp.server.stdio
import mcp.types as types

RATES = {
    "USD": 1,
    "EUR": 0.85,
    "GBP": 0.73,
    "NGN": 1550,
    "JPY": 149,
    "CAD": 1.36,
}

server = Server("currency-server")


@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="convert_currency",
            description="Convert an amount from one currency to another",
            inputSchema={
                "type": "object",
                "properties": {
                    "amount": {
                        "type": "number",
                        "description": "Amount to convert"
                    },
                    "from": {
                        "type": "string",
                        "description": "Source currency code"
                    },
                    "to": {
                        "type": "string",
                        "description": "Target currency code"
                    }
                },
                "required": ["amount", "from", "to"]
            }
        ),
        types.Tool(
            name="list_currencies",
            description="List all supported currencies",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
    ]


@server.call_tool()
async def handle_call_tool(
    name: str,
    arguments: dict
) -> list[types.TextContent]:
    if name == "convert_currency":
        amount = arguments["amount"]
        from_curr = arguments["from"].upper()
        to_curr = arguments["to"].upper()

        if from_curr not in RATES:
            return [types.TextContent(
                type="text",
                text=f"Unknown currency: {from_curr}"
            )]

        if to_curr not in RATES:
            return [types.TextContent(
                type="text",
                text=f"Unknown currency: {to_curr}"
            )]

        in_usd = amount / RATES[from_curr]
        result = in_usd * RATES[to_curr]

        return [types.TextContent(
            type="text",
            text=f"{amount} {from_curr} = {result:.2f} {to_curr}"
        )]

    elif name == "list_currencies":
        currencies = ", ".join(RATES.keys())
        return [types.TextContent(
            type="text",
            text=f"Supported currencies: {currencies}"
        )]

    raise ValueError(f"Unknown tool: {name}")


async def main():
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="currency-server",
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
</details>

---

## Exercise 6: Flutter AI Chat App

**Goal:** Build a Flutter app that talks to an AI with tool capabilities.

### Create Project:

```bash
flutter create ai_chat_exercise
cd ai_chat_exercise
```

### pubspec.yaml:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
```

### Requirements:

Build an app with:

1. **Chat interface** - Messages displayed in bubbles
2. **Text input** - Send messages to AI
3. **Tool support** - AI can use tools you define
4. **Loading state** - Show when AI is thinking

### Implement these tools in your app:

1. **get_joke** - Returns a random joke
2. **roll_dice** - Rolls a dice with N sides
3. **flip_coin** - Returns heads or tails

### Starter Code (lib/main.dart):

```dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // TODO: Define your tools here
  final List<Map<String, dynamic>> _tools = [
    // Define get_joke, roll_dice, flip_coin tools
  ];

  // TODO: Implement tool execution
  String _executeTool(String name, Map<String, dynamic> args) {
    switch (name) {
      case 'get_joke':
        // Return a random joke
        break;
      case 'roll_dice':
        // Roll dice with args['sides'] sides
        break;
      case 'flip_coin':
        // Return heads or tails
        break;
      default:
        return 'Unknown tool';
    }
    return 'Not implemented';
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(content: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    // TODO: Send to AI API and handle response
    // For this exercise, simulate a response

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _messages.add(Message(
        content: 'AI response would go here',
        isUser: false,
      ));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Solution:

<details>
<summary>Click to see complete solution</summary>

```dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  final Random _random = Random();

  final List<String> _jokes = [
    "Why do programmers prefer dark mode? Because light attracts bugs!",
    "Why did the developer go broke? Because he used up all his cache!",
    "There are only 10 types of people: those who understand binary and those who don't.",
    "A SQL query walks into a bar, walks up to two tables and asks: 'Can I join you?'",
    "Why do Java developers wear glasses? Because they can't C#!",
  ];

  final List<Map<String, dynamic>> _tools = [
    {
      'name': 'get_joke',
      'description': 'Get a random programming joke',
      'input_schema': {
        'type': 'object',
        'properties': {},
      },
    },
    {
      'name': 'roll_dice',
      'description': 'Roll a dice with specified number of sides',
      'input_schema': {
        'type': 'object',
        'properties': {
          'sides': {
            'type': 'integer',
            'description': 'Number of sides on the dice (default: 6)',
          },
        },
      },
    },
    {
      'name': 'flip_coin',
      'description': 'Flip a coin and get heads or tails',
      'input_schema': {
        'type': 'object',
        'properties': {},
      },
    },
  ];

  String _executeTool(String name, Map<String, dynamic> args) {
    switch (name) {
      case 'get_joke':
        final joke = _jokes[_random.nextInt(_jokes.length)];
        return jsonEncode({'joke': joke});

      case 'roll_dice':
        final sides = args['sides'] ?? 6;
        final result = _random.nextInt(sides) + 1;
        return jsonEncode({'sides': sides, 'result': result});

      case 'flip_coin':
        final result = _random.nextBool() ? 'heads' : 'tails';
        return jsonEncode({'result': result});

      default:
        return jsonEncode({'error': 'Unknown tool: $name'});
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(content: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    // Simulate AI understanding the request and using tools
    await Future.delayed(const Duration(milliseconds: 500));

    String response;
    final lowerText = text.toLowerCase();

    if (lowerText.contains('joke')) {
      final result = _executeTool('get_joke', {});
      final data = jsonDecode(result);
      response = "Here's a joke for you: ${data['joke']}";
    } else if (lowerText.contains('dice') || lowerText.contains('roll')) {
      // Try to extract number of sides
      final match = RegExp(r'd(\d+)|(\d+)[\s-]?sided').firstMatch(lowerText);
      final sides = match != null
          ? int.tryParse(match.group(1) ?? match.group(2) ?? '6') ?? 6
          : 6;

      final result = _executeTool('roll_dice', {'sides': sides});
      final data = jsonDecode(result);
      response = "Rolling a ${data['sides']}-sided dice... You got ${data['result']}!";
    } else if (lowerText.contains('coin') || lowerText.contains('flip')) {
      final result = _executeTool('flip_coin', {});
      final data = jsonDecode(result);
      response = "Flipping a coin... It's ${data['result']}!";
    } else {
      response = "I can help you with:\n"
          "- Tell me a joke\n"
          "- Roll a dice (or roll a d20)\n"
          "- Flip a coin\n\n"
          "Just ask!";
    }

    setState(() {
      _messages.add(Message(content: response, isUser: false));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _messages.clear()),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade50,
            child: const Text(
              'Try: "Tell me a joke" | "Roll a d20" | "Flip a coin"',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```
</details>

---

## Exercise 7: Design Challenge

**Goal:** Design (on paper or in a document) an MCP server for a specific use case.

### Choose One Scenario:

**A) E-commerce Assistant**
Design tools for an online shopping assistant:
- Search products
- Add to cart
- Check inventory
- Get order status

**B) Fitness Tracker**
Design tools for a fitness app assistant:
- Log workout
- Get workout history
- Calculate calories burned
- Suggest exercises

**C) Study Helper**
Design tools for a study assistant:
- Create flashcard
- Quiz on topic
- Track study time
- Get study statistics

### For Your Design, Document:

1. **List of tools** (at least 4)
2. **For each tool:**
   - Name
   - Description
   - Input parameters (with types)
   - What it returns

### Example Template:

```
Tool: search_products
Description: Search for products by keyword
Input:
  - query (string, required): Search keywords
  - category (string, optional): Filter by category
  - max_price (number, optional): Maximum price filter
Returns:
  - List of products with name, price, description, availability
```

<details>
<summary>✅ Example Solution (Study Helper)</summary>

A complete design for scenario C, four tools fully specified:

```
Tool: create_flashcard
Description: Save a new flashcard for later study
Input:
  - front (string, required): the question or prompt
  - back (string, required): the answer
  - topic (string, optional): subject to group it under
Returns:
  - The created flashcard's id and a success message

Tool: quiz_on_topic
Description: Start a quiz from saved flashcards in a topic
Input:
  - topic (string, required): which topic to quiz on
  - count (number, optional): how many cards (default 10)
Returns:
  - A list of questions (fronts) to ask, without the answers

Tool: log_study_time
Description: Record a study session
Input:
  - topic (string, required): what was studied
  - minutes (number, required): how long
Returns:
  - Confirmation and the new total minutes for that topic

Tool: get_study_stats
Description: Get study statistics
Input:
  - topic (string, optional): limit to one topic, or all if omitted
Returns:
  - Total minutes, number of sessions, and number of flashcards per topic
```

What makes this a good design: each tool does ONE clear thing, every input has a name + type + whether it is required, and the "Returns" line says exactly what the AI gets back so it can phrase a helpful reply. That is the same shape real MCP tool definitions take.

</details>

---

## Exercise 8: Debugging MCP

**Goal:** Find and fix bugs in this MCP server code.

### Buggy Code:

```javascript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const server = new Server(
  {
    name: 'buggy-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// BUG 1: Something wrong with tool definition
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'add_numbers',
        description: 'Add two numbers together',
        inputSchema: {
          type: 'object',
          properties: {
            a: { type: 'number' },
            b: { type: 'number' },
          },
          // BUG: What's missing here?
        },
      },
    ],
  };
});

// BUG 2: Something wrong with tool implementation
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name } = request.params;

  if (name === 'add_numbers') {
    // BUG: How do we get the arguments?
    const result = a + b;

    return {
      content: [{
        type: 'text',
        text: result,  // BUG: What's wrong with this?
      }],
    };
  }
});

// BUG 3: Something missing at the end
```

### Find These Bugs:

1. Tool definition is missing something important
2. Arguments aren't being accessed correctly
3. Return value format is wrong
4. Server startup code is missing

### Solution:

<details>
<summary>Click to see the fixed code</summary>

```javascript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const server = new Server(
  {
    name: 'fixed-server',
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
        name: 'add_numbers',
        description: 'Add two numbers together',
        inputSchema: {
          type: 'object',
          properties: {
            a: { type: 'number', description: 'First number' },
            b: { type: 'number', description: 'Second number' },
          },
          required: ['a', 'b'],  // FIX 1: Added required array
        },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;  // FIX 2: Destructure arguments

  if (name === 'add_numbers') {
    const { a, b } = args;  // FIX 2: Get a and b from args
    const result = a + b;

    return {
      content: [{
        type: 'text',
        text: `${a} + ${b} = ${result}`,  // FIX 3: Convert to string
      }],
    };
  }

  throw new Error(`Unknown tool: ${name}`);  // Added error handling
});

// FIX 4: Added server startup code
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Server running...');
}

main().catch(console.error);
```
</details>

---

## Completion Checklist

Track your progress:

- [ ] Exercise 1: Answered concept questions
- [ ] Exercise 2: Configured Claude Desktop with filesystem server
- [ ] Exercise 3: Built currency MCP server in Node.js
- [ ] Exercise 4: Connected currency server to Claude Desktop
- [ ] Exercise 5: Built currency server in Python
- [ ] Exercise 6: Created Flutter AI chat app
- [ ] Exercise 7: Designed MCP server for a use case
- [ ] Exercise 8: Found and fixed all bugs

---

## What's Next?

After completing these exercises, you should be able to:

1. Explain MCP concepts clearly
2. Set up MCP servers with Claude Desktop
3. Build simple MCP servers in Node.js or Python
4. Design MCP tools for any use case
5. Integrate AI capabilities into Flutter apps

---

**Congratulations on completing the MCP exercises!**

**Return to:** `../README.md` for the full level overview
