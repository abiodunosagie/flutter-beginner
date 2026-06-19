# MCP Architecture: How It Works

## The Big Idea In One Sentence

> MCP has a client (inside the AI app) talking to a server (which exposes tools, resources, and prompts), so the AI asks the server "what can you do?" and then calls those tools.

Now let's dive into the technical details of how MCP is structured and how the pieces fit together.

---

## The Three Layers of MCP

```
+===============================================+
|                  MCP HOST                     |
|  (The application users interact with)        |
|  Example: Claude Desktop, VS Code, Your App   |
+===============================================+
                      |
                      | Creates and manages
                      v
+===============================================+
|                 MCP CLIENT                    |
|  (Connection manager inside the host)         |
|  - Connects to servers                        |
|  - Routes requests                            |
|  - Handles responses                          |
+===============================================+
                      |
        +-------------+-------------+
        |             |             |
        v             v             v
+===========+  +===========+  +===========+
|MCP SERVER |  |MCP SERVER |  |MCP SERVER |
|  (Files)  |  | (Weather) |  | (Database)|
+===========+  +===========+  +===========+
```

---

## Layer 1: MCP Host

The Host is the main application that users interact with.

### What Hosts Do:

1. **Run the AI model** - Process user queries
2. **Manage MCP clients** - Create and configure clients
3. **Handle user interface** - Display results to users
4. **Coordinate everything** - Orchestrate the flow

### Examples of MCP Hosts:

```
- Claude Desktop (Anthropic's desktop app)
- VS Code with AI extensions
- Custom AI applications you build
- CLI tools with AI capabilities
```

### Host Responsibilities:

```
User types: "Read my project files and summarize them"
                    |
                    v
+-------------------------------------------+
|                MCP HOST                   |
|  1. Receive user input                    |
|  2. Send to AI model                      |
|  3. AI determines tools needed            |
|  4. Route tool calls to MCP client        |
|  5. Receive results                       |
|  6. Display to user                       |
+-------------------------------------------+
```

---

## Layer 2: MCP Client

The Client lives inside the Host and manages connections to servers.

### What Clients Do:

1. **Connect to servers** - Establish communication
2. **Discover capabilities** - Ask "what can you do?"
3. **Route requests** - Send tool calls to right server
4. **Handle responses** - Return results to host

### Client-Server Connection:

```
MCP Client
    |
    +---> Connect to file-server (localhost:3001)
    |         "What tools do you have?"
    |         Response: [read_file, write_file, list_files]
    |
    +---> Connect to weather-server (localhost:3002)
    |         "What tools do you have?"
    |         Response: [get_weather, get_forecast]
    |
    +---> Connect to database-server (localhost:3003)
              "What tools do you have?"
              Response: [query, insert, update, delete]
```

### Connection Types:

MCP supports different ways to connect to servers:

```
1. STDIO (Standard Input/Output)
   - Server runs as a subprocess
   - Communication via stdin/stdout
   - Best for: Local tools

2. HTTP with SSE (Server-Sent Events)
   - Server runs as web service
   - Communication via HTTP
   - Best for: Remote servers

3. WebSocket
   - Persistent bidirectional connection
   - Real-time communication
   - Best for: Interactive tools
```

---

## Layer 3: MCP Servers

Servers provide the actual tools and capabilities.

### What Servers Do:

1. **Declare capabilities** - Tell clients what they can do
2. **Implement tools** - Actually do the work
3. **Return results** - Send data back to client

### Server Components:

```
+-----------------------------------------------+
|                 MCP SERVER                    |
|                                               |
|  +-------------------+                        |
|  |      TOOLS        |  Actions AI can call   |
|  |  - read_file      |                        |
|  |  - write_file     |                        |
|  |  - search_files   |                        |
|  +-------------------+                        |
|                                               |
|  +-------------------+                        |
|  |    RESOURCES      |  Data AI can access    |
|  |  - /files/*       |                        |
|  |  - /config        |                        |
|  +-------------------+                        |
|                                               |
|  +-------------------+                        |
|  |     PROMPTS       |  Templates for tasks   |
|  |  - summarize      |                        |
|  |  - review_code    |                        |
|  +-------------------+                        |
|                                               |
+-----------------------------------------------+
```

---

## Communication Protocol

MCP uses JSON-RPC 2.0 for communication.

### What is JSON-RPC?

JSON-RPC is a simple protocol for remote procedure calls using JSON.

```
Request:
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_weather",
    "arguments": {
      "city": "Lagos"
    }
  }
}

Response:
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "Temperature: 32C, Condition: Sunny"
      }
    ]
  }
}
```

### Message Types:

```
1. Initialize
   Client: "Hello, I'm connecting"
   Server: "Hello, here's my info"

2. List Tools
   Client: "What tools do you have?"
   Server: "[tool1, tool2, tool3]"

3. Call Tool
   Client: "Run tool1 with these arguments"
   Server: "Here's the result"

4. List Resources
   Client: "What data can I access?"
   Server: "[resource1, resource2]"

5. Read Resource
   Client: "Give me resource1"
   Server: "Here's the data"
```

---

## Setting Up MCP (With Claude Desktop)

Let's set up MCP step by step using Claude Desktop as an example.

### Step 1: Install Claude Desktop

Download from: https://claude.ai/download

### Step 2: Find Configuration File

The MCP configuration lives in a JSON file:

**macOS:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:**
```
%APPDATA%\Claude\claude_desktop_config.json
```

### Step 3: Configure MCP Servers

Edit the config file to add servers:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/yourname/Documents"
      ]
    },
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_token_here"
      }
    }
  }
}
```

### Step 4: Restart Claude Desktop

After saving the config, restart Claude Desktop to load the servers.

### Step 5: Verify Connection

In Claude Desktop, you should see the tools available from your servers.

---

## Available MCP Servers

Anthropic and the community provide pre-built servers:

### Official Servers:

```
@modelcontextprotocol/server-filesystem
  - Read/write files
  - Search directories
  - Watch for changes

@modelcontextprotocol/server-github
  - Search repositories
  - Read files
  - Create issues/PRs

@modelcontextprotocol/server-postgres
  - Query PostgreSQL
  - Schema inspection

@modelcontextprotocol/server-sqlite
  - Query SQLite databases

@modelcontextprotocol/server-brave-search
  - Web search via Brave

@modelcontextprotocol/server-fetch
  - HTTP requests
  - Web scraping
```

### Community Servers:

Many more available at: https://github.com/modelcontextprotocol/servers

---

## Building Your Own MCP Server

You can create custom MCP servers. Here's the basic structure:

### Server in TypeScript/Node.js:

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

// Create server
const server = new Server(
  {
    name: 'my-custom-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define a tool
server.setRequestHandler('tools/list', async () => {
  return {
    tools: [
      {
        name: 'greet',
        description: 'Greet someone by name',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name to greet',
            },
          },
          required: ['name'],
        },
      },
    ],
  };
});

// Implement the tool
server.setRequestHandler('tools/call', async (request) => {
  if (request.params.name === 'greet') {
    const name = request.params.arguments.name;
    return {
      content: [
        {
          type: 'text',
          text: `Hello, ${name}! Welcome to MCP!`,
        },
      ],
    };
  }
  throw new Error('Unknown tool');
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Server in Python:

```python
from mcp.server import Server, NotificationOptions
from mcp.server.models import InitializationOptions
import mcp.server.stdio
import mcp.types as types

# Create server
server = Server("my-custom-server")

# Define tools
@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="greet",
            description="Greet someone by name",
            inputSchema={
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": "Name to greet"
                    }
                },
                "required": ["name"]
            }
        )
    ]

# Implement tools
@server.call_tool()
async def handle_call_tool(
    name: str,
    arguments: dict
) -> list[types.TextContent]:
    if name == "greet":
        person_name = arguments["name"]
        return [
            types.TextContent(
                type="text",
                text=f"Hello, {person_name}! Welcome to MCP!"
            )
        ]
    raise ValueError(f"Unknown tool: {name}")

# Run server
async def main():
    async with mcp.server.stdio.stdio_server() as (read, write):
        await server.run(
            read,
            write,
            InitializationOptions(
                server_name="my-custom-server",
                server_version="1.0.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={}
                )
            )
        )

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## MCP Request Flow (Complete Picture)

Let's trace a complete request:

```
1. User Input
   "What files are in my Documents folder?"
         |
         v
2. MCP Host (Claude Desktop)
   - Receives user message
   - Sends to Claude AI model
         |
         v
3. AI Processing
   - Claude understands the request
   - Determines: "I need to list files"
   - Identifies tool: list_files
         |
         v
4. MCP Client
   - Receives tool call request
   - Finds server with list_files tool
   - Sends JSON-RPC request to server
         |
         v
5. MCP Server (Filesystem)
   - Receives list_files request
   - Executes: fs.readdir('/Users/you/Documents')
   - Returns file list
         |
         v
6. MCP Client
   - Receives response
   - Forwards to host
         |
         v
7. AI Processing
   - Receives file list
   - Formats response naturally
         |
         v
8. MCP Host
   - Displays to user:
   "Your Documents folder contains:
    - project1/
    - resume.pdf
    - notes.txt
    ..."
```

---

## Security Considerations

### What MCP Servers Can Access:

```
BE CAREFUL! MCP servers can:
- Read/write files (if you give permission)
- Execute commands
- Access databases
- Make network requests

Only use trusted servers!
```

### Best Practices:

1. **Review server code** before using
2. **Limit permissions** - Only give access to needed folders
3. **Use environment variables** for secrets
4. **Don't expose sensitive data**
5. **Run servers locally** when possible

---

## Configuration Reference

### Full Config Example:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/safe/folder"],
      "env": {}
    },
    "database": {
      "command": "python",
      "args": ["-m", "my_db_server"],
      "env": {
        "DATABASE_URL": "postgresql://localhost/mydb"
      }
    },
    "custom": {
      "command": "node",
      "args": ["./my-server/index.js"],
      "cwd": "/path/to/server"
    }
  }
}
```

### Config Options:

| Option | Description |
|--------|-------------|
| `command` | Program to run (npx, node, python) |
| `args` | Arguments for the command |
| `env` | Environment variables |
| `cwd` | Working directory |

---

## Debugging MCP

### View Logs (macOS):

```bash
# See Claude Desktop logs
tail -f ~/Library/Logs/Claude/mcp*.log
```

### Test Server Manually:

```bash
# Run server directly to test
npx -y @modelcontextprotocol/server-filesystem /tmp/test

# Then send JSON-RPC messages via stdin
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | node your-server.js
```

---

## Summary

| Component | Role | Example |
|-----------|------|---------|
| Host | Main app, runs AI | Claude Desktop |
| Client | Manages connections | Built into host |
| Server | Provides tools | filesystem, github, custom |
| Protocol | Communication format | JSON-RPC 2.0 |
| Transport | How data moves | STDIO, HTTP, WebSocket |

---

## Quick Quiz

**Q1: What are the three main layers of MCP?**
<details>
<summary>Answer</summary>
1. Host - The main application
2. Client - Connection manager
3. Server - Provides tools
</details>

**Q2: What protocol does MCP use for communication?**
<details>
<summary>Answer</summary>
JSON-RPC 2.0 - A simple remote procedure call protocol using JSON.
</details>

**Q3: Where is the Claude Desktop MCP config file on macOS?**
<details>
<summary>Answer</summary>
~/Library/Application Support/Claude/claude_desktop_config.json
</details>

---

## Assignment

### Problem 1: Two sides

Name the two main pieces of MCP and which side each lives on.

### Problem 2: Discover then call

In one line, how does the AI know what a server can do?

### Problem 3: What a server offers

Name one of the things an MCP server can expose to the AI.

---

## Assignment Answers

### Problem 1: Two sides

The **client** (inside the AI application) and the **server** (which provides the tools/data). The client connects to the server.

### Problem 2: Discover then call

It asks the server to list its capabilities (tools/resources), then calls the ones it needs.

### Problem 3: What a server offers

Any of: tools (actions the AI can run), resources (data it can read), or prompts (reusable prompt templates).

---

**Next:** Learn how to integrate MCP with Flutter apps

**Continue to:** `04-MCPWithFlutter.md`
