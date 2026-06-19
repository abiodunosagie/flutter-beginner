# MCP vs API: Understanding the Difference

## The Big Idea In One Sentence

> An API is built for programmers who read docs and write exact calls; MCP is built for AI assistants to discover and use tools on their own, often MCP wraps your existing APIs so an AI can use them.

You've probably worked with APIs before. Now let's understand how MCP is different and when to use each.

---

## Quick Comparison

```
+------------------+----------------------------------+----------------------------------+
|                  |           TRADITIONAL API        |              MCP                 |
+------------------+----------------------------------+----------------------------------+
| Communication    | Request -> Response              | Bidirectional, contextual        |
| State            | Stateless (each call independent)| Can maintain context             |
| Discovery        | Read documentation manually      | AI discovers capabilities        |
| Flexibility      | Fixed endpoints                  | Dynamic tool selection           |
| Who calls it     | Your code calls the API          | AI decides what to call          |
| Learning curve   | Learn each API separately        | Learn MCP once                   |
+------------------+----------------------------------+----------------------------------+
```

---

## What is an API? (Quick Refresher)

API = Application Programming Interface

It's a way for two programs to talk to each other.

### How APIs Work

```
Your App                          External Service
    |                                    |
    |  1. Send Request                   |
    | ---------------------------------> |
    |    GET /weather?city=Lagos         |
    |                                    |
    |  2. Receive Response               |
    | <--------------------------------- |
    |    { "temp": 32, "condition": "sunny" }
    |                                    |
```

### API Characteristics

1. **Request-Response**: You ask, it answers
2. **Stateless**: Each request is independent
3. **Fixed Endpoints**: `/users`, `/products`, `/weather`
4. **You Control Everything**: Your code decides what to call and when

### API Example in Dart

```dart
// Traditional API call
Future<Weather> getWeather(String city) async {
  // You write the URL
  final url = 'https://api.weather.com/v1/weather?city=$city';

  // You make the request
  final response = await http.get(Uri.parse(url));

  // You parse the response
  final json = jsonDecode(response.body);

  // You handle errors
  if (response.statusCode != 200) {
    throw Exception('Failed to load weather');
  }

  return Weather.fromJson(json);
}
```

---

## What is MCP? (In Comparison)

MCP = Model Context Protocol

It's a way for AI to discover and use tools dynamically.

### How MCP Works

```
You                    AI (Claude)               MCP Server
 |                         |                         |
 | "What's the weather     |                         |
 |  in Lagos?"             |                         |
 | ----------------------> |                         |
 |                         |                         |
 |                         | 1. AI discovers tools   |
 |                         | ----------------------> |
 |                         |    "What can you do?"   |
 |                         |                         |
 |                         | <---------------------- |
 |                         |    [get_weather,        |
 |                         |     get_forecast, ...]  |
 |                         |                         |
 |                         | 2. AI chooses tool      |
 |                         | ----------------------> |
 |                         |    get_weather(Lagos)   |
 |                         |                         |
 |                         | <---------------------- |
 |                         |    { temp: 32, ... }    |
 |                         |                         |
 | <---------------------- |                         |
 | "It's 32C and sunny     |                         |
 |  in Lagos!"             |                         |
 |                         |                         |
```

### MCP Characteristics

1. **AI-Driven**: AI decides what tools to use
2. **Discovery**: AI asks "what can you do?" and learns
3. **Contextual**: AI understands the conversation context
4. **Dynamic**: Tools can be added without changing your app code

---

## The Key Differences

### 1. Who Decides What to Call?

**API:**
```dart
// YOU write the code that decides what API to call
if (userWantsWeather) {
  await weatherApi.getWeather(city);
} else if (userWantsNews) {
  await newsApi.getHeadlines();
} else if (userWantsStocks) {
  await stockApi.getPrices();
}
// You must anticipate every case!
```

**MCP:**
```
User: "Tell me about Lagos"

AI thinks: "User wants info about Lagos. I have these tools:
- get_weather: Get weather for a city
- get_news: Get news about a topic
- get_population: Get city population
- get_attractions: Get tourist spots

I'll use multiple tools to give a complete answer."

AI automatically calls relevant tools based on context.
```

### 2. Static vs Dynamic

**API: Static Endpoints**
```
GET  /api/weather/{city}
GET  /api/news/{topic}
POST /api/users
PUT  /api/users/{id}

These endpoints are FIXED. Adding new ones requires code changes.
```

**MCP: Dynamic Discovery**
```
AI: "What tools do you have?"

Server: "I have:
- get_weather(city): Returns weather
- get_forecast(city, days): Returns forecast
- NEW! get_air_quality(city): Returns AQI"

AI learns new tools automatically!
```

### 3. Context Awareness

**API: No Context**
```dart
// Each call is independent
await api.getWeather('Lagos');    // Knows nothing about user
await api.getWeather('Abuja');    // Doesn't know previous call
await api.getWeather('Kano');     // No conversation memory
```

**MCP: Context Preserved**
```
User: "What's the weather in Lagos?"
AI: "It's 32C and sunny in Lagos."

User: "What about tomorrow?"
AI: (Remembers we were talking about Lagos)
    Calls get_forecast(city="Lagos", days=1)
    "Tomorrow in Lagos will be 30C with light rain."

User: "Compare it to Abuja"
AI: (Remembers we're comparing weather)
    Calls get_weather(city="Abuja")
    "Abuja is currently 28C, cooler than Lagos's 32C."
```

### 4. Error Handling

**API: You Handle Everything**
```dart
try {
  final response = await api.getWeather(city);
  if (response.statusCode == 404) {
    return 'City not found';
  } else if (response.statusCode == 429) {
    return 'Too many requests';
  } else if (response.statusCode == 500) {
    return 'Server error';
  }
  // Parse response...
} catch (e) {
  return 'Network error';
}
```

**MCP: AI Handles Gracefully**
```
User: "Weather in Xyzabc" (fake city)

AI: Calls get_weather("Xyzabc")
    Server returns: { error: "City not found" }

AI: "I couldn't find weather data for 'Xyzabc'.
     Did you mean 'Abuja' or another city?
     Or could you check the spelling?"

The AI interprets errors and responds naturally.
```

---

## When to Use API vs MCP

### Use Traditional API When:

1. **Simple, predictable tasks**
   - Fetch a list of products
   - Submit a form
   - CRUD operations

2. **No AI involved**
   - Standard app functionality
   - User clicks button, app does action

3. **Performance critical**
   - APIs have lower latency
   - Direct, no AI processing needed

4. **You need full control**
   - Specific business logic
   - Compliance requirements

### Use MCP When:

1. **AI-powered features**
   - Chatbots
   - AI assistants
   - Natural language interfaces

2. **Dynamic tool selection**
   - User intent varies
   - Multiple possible actions

3. **Context matters**
   - Conversation history
   - User preferences
   - Multi-step tasks

4. **Discoverability needed**
   - Tools change frequently
   - Multiple services

---

## Real-World Comparison

### Scenario: Travel Planning App

**API Approach:**
```dart
class TravelService {
  Future<List<Flight>> searchFlights(String from, String to, DateTime date);
  Future<List<Hotel>> searchHotels(String city, DateTime checkIn, DateTime checkOut);
  Future<Weather> getWeather(String city, DateTime date);
  Future<List<Attraction>> getAttractions(String city);
  Future<void> bookFlight(Flight flight);
  Future<void> bookHotel(Hotel hotel);
}

// In your UI code:
void planTrip() async {
  // YOU must orchestrate everything:
  final flights = await service.searchFlights(...);
  final hotels = await service.searchHotels(...);
  final weather = await service.getWeather(...);
  final attractions = await service.getAttractions(...);

  // YOU must display results
  // YOU must handle user choosing flight
  // YOU must handle booking flow
}
```

**MCP Approach:**
```
User: "Plan a trip from Lagos to London next month"

AI (via MCP):
1. Understands intent: Trip planning
2. Discovers available tools: flights, hotels, weather, attractions
3. Calls flight search tool
4. Calls hotel search tool
5. Calls weather tool for that time
6. Suggests attractions

AI: "I found several options for your Lagos to London trip:

**Flights:**
- British Airways: $800, 6h direct
- Air France: $650, 9h with layover

**Hotels in London:**
- Hilton: $200/night
- Premier Inn: $120/night

**Weather:** London will be 15C, rainy season

**Must-see:** Big Ben, Tower Bridge, British Museum

Would you like me to book anything?"

User: "Book the British Airways flight"

AI: Calls booking tool with context it already has
```

---

## MCP Does NOT Replace APIs

This is important: **MCP and APIs work together!**

```
MCP Server
    |
    +--- Uses Weather API internally
    +--- Uses Flight API internally
    +--- Uses Hotel API internally
    |
    v
Exposes unified interface to AI
```

MCP servers often WRAP existing APIs:

```dart
// Inside an MCP server:
class WeatherMCPServer {
  final WeatherAPI _api = WeatherAPI();  // Uses traditional API!

  // MCP tool definition
  Map<String, dynamic> getWeatherTool() {
    return {
      'name': 'get_weather',
      'description': 'Get current weather for a city',
      'parameters': {
        'city': {'type': 'string', 'description': 'City name'}
      }
    };
  }

  // Tool implementation (uses API internally)
  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await _api.fetchWeather(city);  // API call!
    return {
      'temperature': response.temp,
      'condition': response.condition,
      'humidity': response.humidity,
    };
  }
}
```

---

## Comparison Table

| Aspect | Traditional API | MCP |
|--------|----------------|-----|
| Who calls | Your code | AI decides |
| Learning | Read docs for each API | AI discovers tools |
| Context | Stateless | Maintains conversation context |
| Flexibility | Fixed endpoints | Dynamic tool selection |
| User interface | Buttons, forms | Natural language |
| Error handling | You code it | AI interprets naturally |
| Best for | Predictable tasks | AI-powered features |
| Speed | Faster (direct) | Slower (AI processing) |
| Control | Full control | AI has autonomy |

---

## Think of It This Way

### API = Vending Machine
- Fixed options (A1, A2, B1, B2...)
- You press exactly what you want
- Machine gives you that item
- No conversation, no context

### MCP = Personal Assistant
- You describe what you want
- Assistant understands context
- Assistant chooses the right tools
- Assistant handles the details

---

## Summary

**APIs are:**
- Direct communication between programs
- You control what's called and when
- Stateless, predictable
- Still essential for most app functionality

**MCP is:**
- AI-to-tool communication standard
- AI decides what tools to use
- Contextual, dynamic
- Essential for AI-powered features

**They work together:**
- MCP servers often use APIs internally
- Your app might use both
- Choose based on the use case

---

## Quick Quiz

**Q1: If you're building a simple product listing page, should you use API or MCP?**
<details>
<summary>Answer</summary>
Use traditional API. It's a simple, predictable task that doesn't need AI decision-making.
</details>

**Q2: If you're building an AI assistant that helps users plan their day, should you use API or MCP?**
<details>
<summary>Answer</summary>
Use MCP. The AI needs to understand context, choose relevant tools dynamically (calendar, weather, tasks, etc.), and maintain conversation state.
</details>

**Q3: Can an MCP server use traditional APIs internally?**
<details>
<summary>Answer</summary>
Yes! MCP servers commonly wrap existing APIs, providing a standardized interface for AI while using APIs for actual data fetching.
</details>

---

## Assignment

### Problem 1: Who is it for?

Who is the main "user" of an API, and who is the main "user" of MCP?

### Problem 2: Replace or wrap?

Does MCP replace your existing APIs, or work with them?

### Problem 3: Pick the case

You want your AI assistant to look up orders in your system. Do you expose a plain API or an MCP server, and why?

---

## Assignment Answers

### Problem 1: Who is it for?

An API is for programmers (who write exact calls from docs). MCP is for AI assistants (which discover and call tools on their own).

### Problem 2: Replace or wrap?

It works with them. MCP often wraps existing APIs so an AI can use them through the standard protocol.

### Problem 3: Pick the case

An MCP server (wrapping your order API), so the AI assistant can discover and call the "look up order" tool itself, with the right permissions.

---

**Next:** Learn MCP architecture and how to set it up

**Continue to:** `03-MCPArchitecture.md`
