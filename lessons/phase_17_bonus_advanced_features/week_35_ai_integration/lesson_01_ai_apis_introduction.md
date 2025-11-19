# Lesson 1: Introduction to AI APIs

## 5-Year-Old Analogy 🎨

Imagine you have a super smart robot friend who lives far away in a big computer building (called a server). You can't see your robot friend, but you can talk to them through a special phone line. When you ask your robot friend questions like "Can you draw me a picture of a cat?" or "Can you help me write a story?", they do it really fast and send it back to you! That's what AI APIs are - special phone lines to talk to very smart robot friends who can help you do amazing things.

Each robot friend is special:
- **ChatGPT** is really good at talking and writing stories
- **Gemini** is good at looking at pictures AND talking about them
- **Claude** is great at understanding long, complicated things
- **Stable Diffusion** is an artist who can draw anything you describe

---

## What Are AI APIs?

**API (Application Programming Interface)** is a way for your Flutter app to talk to AI services running on powerful computers (servers) far away. Instead of building your own AI (which would take years and millions of dollars), you can rent time on already-built AI systems.

### Why Use AI APIs in Your Apps?

1. **No AI Expertise Needed**: You don't need to understand how AI works internally
2. **Powerful Capabilities**: Access to state-of-the-art AI models
3. **Cost-Effective**: Pay only for what you use
4. **Always Improving**: Models get better over time without you changing code
5. **Fast Development**: Build AI features in hours, not months

---

## Major AI API Providers (2025)

### 1. OpenAI (ChatGPT, GPT-4, DALL-E)

**Best For**: Text generation, conversation, code generation, image creation

**Models**:
- **GPT-4 Turbo**: Most capable language model, best reasoning
- **GPT-4o**: Faster, multimodal (text + images)
- **GPT-3.5 Turbo**: Faster, cheaper, good for simple tasks
- **DALL-E 3**: High-quality image generation

**Pricing** (approximate):
- GPT-4 Turbo: $0.01 per 1K input tokens, $0.03 per 1K output tokens
- GPT-3.5 Turbo: $0.0005 per 1K input tokens, $0.0015 per 1K output tokens
- DALL-E 3: $0.04 per image (1024x1024)

**Pros**:
- Most popular, well-documented
- Excellent for creative writing and conversation
- Strong code generation capabilities
- Large ecosystem of tools

**Cons**:
- Can be expensive at scale
- Rate limits on free tier
- Moderation filters can be restrictive

**API Documentation**: https://platform.openai.com/docs/api-reference

---

### 2. Google Gemini (formerly Bard)

**Best For**: Multi-modal AI (text + images + video), long context, Google integration

**Models**:
- **Gemini Pro**: Text and code generation
- **Gemini Pro Vision**: Images + text understanding
- **Gemini Ultra**: Most capable model (limited access)

**Pricing** (approximate):
- Gemini Pro: Free tier available, then $0.00025 per 1K characters
- Gemini Pro Vision: $0.0025 per image

**Pros**:
- Strong multi-modal capabilities (text + images)
- Very long context window (up to 1M tokens)
- Integration with Google services
- Generous free tier

**Cons**:
- Newer, less mature ecosystem
- Fewer third-party integrations
- Documentation can be inconsistent

**API Documentation**: https://ai.google.dev/docs

---

### 3. Anthropic Claude

**Best For**: Long context understanding, safety, complex reasoning, function calling

**Models**:
- **Claude 3.5 Sonnet**: Best balance of speed and capability
- **Claude 3 Opus**: Most powerful, best reasoning
- **Claude 3 Haiku**: Fastest, most affordable

**Pricing** (approximate):
- Claude 3.5 Sonnet: $0.003 per 1K input tokens, $0.015 per 1K output tokens
- Claude 3 Haiku: $0.00025 per 1K input tokens, $0.00125 per 1K output tokens

**Pros**:
- Exceptionally long context (200K tokens)
- Very safe, ethical responses
- Excellent at following instructions
- Function calling (tool use)
- Thinking mode for complex reasoning

**Cons**:
- Smaller ecosystem than OpenAI
- Can be more conservative in responses
- Fewer model options

**API Documentation**: https://docs.anthropic.com/

---

### 4. Hugging Face

**Best For**: Open-source models, custom fine-tuning, specialized tasks

**Models**: Thousands of models including:
- **Llama 2**: Meta's open-source language model
- **Stable Diffusion**: Open-source image generation
- **Whisper**: Speech-to-text
- **BERT**: Text classification and understanding

**Pricing**:
- Many models are free
- Inference API: Pay per compute time
- Can self-host models

**Pros**:
- Largest collection of models
- Open-source options
- Can fine-tune models
- Active community

**Cons**:
- More technical, steeper learning curve
- Performance varies by model
- Self-hosting requires infrastructure

**API Documentation**: https://huggingface.co/docs/api-inference/

---

## Comparison Table

| Feature | OpenAI | Google Gemini | Anthropic Claude | Hugging Face |
|---------|--------|---------------|------------------|--------------|
| **Best For** | Conversation, creativity | Multi-modal, long context | Safety, reasoning | Open-source, customization |
| **Ease of Use** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Cost** | $$$ | $$ | $$$ | $ - $$$ |
| **Context Length** | 128K tokens | 1M tokens | 200K tokens | Varies |
| **Multi-modal** | Text + Images | Text + Images + Video | Text + Images | Varies |
| **Free Tier** | Limited | Generous | Limited | Many free models |
| **Documentation** | Excellent | Good | Excellent | Variable |
| **Speed** | Fast | Very Fast | Fast | Varies |

---

## How AI APIs Work: Request-Response Flow

```
┌─────────────────┐
│  Your Flutter   │
│      App        │
└────────┬────────┘
         │
         │ 1. HTTP Request
         │    (with API key + prompt)
         ▼
┌─────────────────┐
│   AI Provider   │
│     Server      │
│  (OpenAI/etc)   │
└────────┬────────┘
         │
         │ 2. AI processes
         │    your request
         │
         │ 3. HTTP Response
         │    (with AI result)
         ▼
┌─────────────────┐
│  Your Flutter   │
│      App        │
│  (shows result) │
└─────────────────┘
```

### The Request-Response Cycle

1. **Your app sends a request** (HTTP POST)
   - API endpoint URL
   - Authentication (API key)
   - Request body (prompt, settings, etc.)

2. **AI server processes**
   - Validates your API key
   - Runs the AI model
   - Generates response

3. **Server sends response** (HTTP)
   - JSON with AI-generated content
   - Metadata (tokens used, model, etc.)
   - Or streaming chunks for real-time responses

---

## Key Concepts You Need to Know

### 1. Tokens

**What are tokens?** Think of tokens as "word pieces". A token is roughly 4 characters or 0.75 words.

**Examples**:
- "Hello" = 1 token
- "ChatGPT is amazing!" = 4 tokens
- "Hello, how are you today?" = 6 tokens

**Why tokens matter**: AI APIs charge by the token. More tokens = higher cost.

```dart
// Rough token estimation in Dart
int estimateTokens(String text) {
  // Very rough estimate: 1 token ≈ 4 characters
  return (text.length / 4).ceil();
}

void main() {
  String prompt = "Write a short story about a cat";
  print('Estimated tokens: ${estimateTokens(prompt)}'); // ~7 tokens
}
```

### 2. Context Window

The **context window** is how much text the AI can "see" at once (input + output).

**Examples**:
- GPT-3.5 Turbo: 16K tokens (~12,000 words)
- GPT-4 Turbo: 128K tokens (~96,000 words)
- Claude 3: 200K tokens (~150,000 words)
- Gemini Pro: 1M tokens (~750,000 words)

**Why it matters**: You can't send a 1 million word document to GPT-3.5 because it exceeds the context window.

### 3. Temperature

**Temperature** controls randomness in responses (0.0 to 2.0):

- **0.0**: Deterministic, same response every time (good for factual answers)
- **0.7**: Balanced creativity (default for most tasks)
- **1.5**: Very creative, unpredictable (good for creative writing)

```dart
// Example API request with temperature
{
  "model": "gpt-4",
  "messages": [{"role": "user", "content": "Write a joke"}],
  "temperature": 1.2  // More creative jokes
}
```

### 4. System Prompts

**System prompts** set the AI's behavior and personality:

```dart
[
  {
    "role": "system",
    "content": "You are a helpful coding tutor who explains concepts simply."
  },
  {
    "role": "user",
    "content": "What is a variable?"
  }
]
```

### 5. Rate Limits

AI providers limit how many requests you can make:

**OpenAI Free Tier**:
- 3 requests per minute (GPT-4)
- 60 requests per minute (GPT-3.5)

**How to handle**:
- Implement retry logic with exponential backoff
- Queue requests
- Upgrade to paid tier for higher limits

### 6. Streaming vs Non-Streaming

**Non-streaming**: Wait for complete response
- Simpler to implement
- User waits longer
- Good for short responses

**Streaming**: Get response in chunks as it's generated
- Better user experience (like ChatGPT)
- More complex to implement
- Essential for long responses

---

## Choosing the Right AI API for Your App

### Decision Tree

```
Is cost a major concern?
├─ YES → Start with Gemini (free tier) or Hugging Face
└─ NO → Continue...

Do you need multi-modal (images + text)?
├─ YES → Gemini Pro Vision or GPT-4o
└─ NO → Continue...

Do you need very long context (100K+ tokens)?
├─ YES → Claude 3 or Gemini
└─ NO → Continue...

Do you need the best reasoning/quality?
├─ YES → GPT-4 Turbo or Claude 3 Opus
└─ NO → GPT-3.5 Turbo or Claude Haiku (cheaper)
```

### Use Case Recommendations

| Use Case | Best Choice | Reason |
|----------|-------------|--------|
| **Chatbot** | OpenAI GPT-4 or Claude | Best conversation quality |
| **Image Analysis** | Gemini Pro Vision | Multi-modal, good free tier |
| **Long Document Analysis** | Claude 3 or Gemini | Huge context windows |
| **Code Generation** | GPT-4 or Claude | Best at understanding code |
| **Creative Writing** | GPT-4 | Most creative |
| **Budget App** | Gemini or GPT-3.5 | Lowest cost |
| **Image Generation** | DALL-E 3 or Stable Diffusion | Best quality |
| **Speech-to-Text** | Whisper (via Hugging Face) | Best accuracy |

---

## Getting API Keys

### OpenAI

1. Go to https://platform.openai.com/
2. Sign up / Log in
3. Go to API Keys section
4. Click "Create new secret key"
5. **COPY IT IMMEDIATELY** (you can't see it again!)
6. Free tier: $5 credit for first 3 months

### Google Gemini

1. Go to https://ai.google.dev/
2. Sign in with Google account
3. Click "Get API Key"
4. Create API key in new or existing Google Cloud project
5. Free tier: 60 requests per minute

### Anthropic Claude

1. Go to https://www.anthropic.com/
2. Sign up for API access
3. Go to API Keys section
4. Generate new key
5. Free tier: Limited, then pay-as-you-go

### Hugging Face

1. Go to https://huggingface.co/
2. Sign up / Log in
3. Go to Settings → Access Tokens
4. Create new token
5. Many models are free to use

---

## API Key Security Best Practices

### ⛔ NEVER DO THIS

```dart
// ❌ WRONG: Hardcoded API key in source code
const String apiKey = 'sk-proj-abc123xyz789'; // NEVER!

// ❌ WRONG: Committed to Git
// Anyone can see this on GitHub!
```

### ✅ ALWAYS DO THIS

```dart
// ✅ CORRECT: Load from environment variables
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['OPENAI_API_KEY'];
```

**Why?** If your API key leaks:
- Attackers can use your key
- They can rack up thousands in charges
- Your key will be blocked
- Your account may be banned

### Security Rules

1. **Use environment variables** (`.env` file, NOT committed to Git)
2. **Use Flutter Secure Storage** for storing keys on device
3. **Use a backend proxy** (recommended for production)
4. **Rotate keys regularly** (every 3-6 months)
5. **Set usage limits** in API provider dashboard
6. **Monitor usage** daily

---

## Cost Management Strategies

### 1. Use Cheaper Models When Possible

```dart
// For simple tasks, use cheaper models
String chooseModel(String taskComplexity) {
  switch (taskComplexity) {
    case 'simple':
      return 'gpt-3.5-turbo'; // 20x cheaper than GPT-4
    case 'medium':
      return 'gpt-4-turbo';
    case 'complex':
      return 'gpt-4';
    default:
      return 'gpt-3.5-turbo';
  }
}
```

### 2. Limit Token Usage

```dart
// Set max_tokens to prevent runaway costs
{
  "model": "gpt-4",
  "messages": [...],
  "max_tokens": 500  // Limit response length
}
```

### 3. Cache Responses

```dart
// Don't make the same API call twice
final Map<String, String> _cache = {};

Future<String> getCachedResponse(String prompt) async {
  if (_cache.containsKey(prompt)) {
    return _cache[prompt]!; // Free!
  }

  final response = await callAPI(prompt); // Costs money
  _cache[prompt] = response;
  return response;
}
```

### 4. Batch Requests

```dart
// Instead of 10 separate API calls:
// "Translate: Hello"
// "Translate: Goodbye"
// ...

// Make 1 API call:
"Translate these phrases:
1. Hello
2. Goodbye
3. Thank you
..."
```

### 5. Set Budget Alerts

In your API provider dashboard:
- Set monthly budget limit ($10, $50, etc.)
- Get email alerts at 50%, 80%, 100%
- Auto-disable key if limit exceeded

---

## Error Handling Basics

AI APIs can fail for many reasons:

```dart
enum AIError {
  networkError,      // No internet connection
  authError,         // Invalid API key
  rateLimitError,    // Too many requests
  invalidRequest,    // Bad request format
  serverError,       // Provider's servers down
  quotaExceeded,     // Out of credits
}

class AIResponse {
  final String? data;
  final AIError? error;
  final String? errorMessage;

  bool get isSuccess => error == null;
}
```

**Common HTTP Status Codes**:
- `200`: Success
- `400`: Bad request (check your input)
- `401`: Unauthorized (bad API key)
- `429`: Rate limit exceeded (slow down!)
- `500`: Server error (retry later)
- `503`: Service unavailable (retry later)

---

## Performance Considerations

### Latency

AI API calls are SLOW compared to normal code:

```
Local calculation:       0.001 seconds
REST API call:           0.1 seconds
AI API call (streaming): 1-5 seconds
AI API call (complete):  3-30 seconds
```

**User Experience Tips**:
1. Show loading indicators immediately
2. Use streaming when possible (feels faster)
3. Disable submit button during processing
4. Allow cancellation for long requests
5. Cache common requests

### Offline Support

AI APIs require internet. For offline support:

```dart
if (!await hasInternetConnection()) {
  return AIResponse(
    error: AIError.networkError,
    errorMessage: 'No internet connection. AI features require internet.',
  );
}
```

Consider:
- Showing cached previous responses
- Queueing requests for when online
- Using local ML models for basic tasks (ML Kit)

---

## Legal and Ethical Considerations

### 1. User Privacy

**Question**: Where does user data go?

- User input is sent to AI provider's servers
- Providers may use it to improve models (check ToS)
- May be stored temporarily or permanently

**Best Practices**:
- Tell users their data is sent to third-party AI
- Don't send sensitive personal information
- Read provider's privacy policy
- Allow users to opt-out

### 2. Content Moderation

AI providers filter harmful content:
- Hate speech
- Violence
- Illegal activities
- Adult content

**Your Responsibility**:
- Don't try to bypass filters
- Add your own content filtering
- Monitor user-generated prompts
- Have a reporting system

### 3. Attribution

**Do you need to credit the AI?**

Check each provider's terms:
- OpenAI: Must disclose AI-generated content in some cases
- Gemini: Check Google's terms
- Claude: Check Anthropic's terms

### 4. Copyright

**Who owns AI-generated content?**

Generally:
- You own content generated by AI for you
- But AI might produce content similar to others
- Check provider terms for specific details

---

## Testing AI Integrations

### 1. Use Playground First

Before coding, test in provider's playground:
- **OpenAI Playground**: https://platform.openai.com/playground
- **Gemini Playground**: https://ai.google.dev/
- **Claude Playground**: https://console.anthropic.com/

Experiment with:
- Different prompts
- Temperature settings
- System prompts
- Token limits

### 2. Mock Responses for Development

```dart
// During development, use fake responses
class MockAIClient implements AIClient {
  @override
  Future<String> chat(String prompt) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    return "This is a mock response. Real AI would respond here.";
  }
}

// Use real or mock based on environment
final aiClient = kDebugMode ? MockAIClient() : RealAIClient();
```

### 3. Unit Testing

```dart
test('AI client handles rate limit error', () async {
  final mockClient = MockAIClient();
  mockClient.shouldReturnRateLimitError = true;

  final result = await mockClient.chat('Hello');

  expect(result.error, equals(AIError.rateLimitError));
});
```

---

## Next Steps

In the upcoming lessons, we'll dive deep into:

1. **Lesson 2**: Setting up HTTP clients, managing API keys securely
2. **Lesson 3**: Building a full OpenAI GPT integration
3. **Lesson 4**: Multi-modal AI with Google Gemini
4. **Lesson 5**: Advanced features with Anthropic Claude
5. **Lesson 6**: Creating beautiful chat interfaces
6. **Lesson 7**: Image generation and vision AI
7. **Lesson 8**: Production-ready features and optimization

---

## Quick Reference

### Essential Flutter Packages

```yaml
dependencies:
  http: ^1.1.0                    # HTTP requests
  flutter_dotenv: ^5.1.0          # Environment variables
  flutter_secure_storage: ^9.0.0  # Secure API key storage
  shared_preferences: ^2.2.2      # Caching
```

### Typical API Request Structure

```dart
final response = await http.post(
  Uri.parse('https://api.openai.com/v1/chat/completions'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  },
  body: jsonEncode({
    'model': 'gpt-4',
    'messages': [
      {'role': 'user', 'content': 'Hello!'}
    ],
    'temperature': 0.7,
    'max_tokens': 500,
  }),
);
```

### Cost Estimation Formula

```dart
double estimateCost({
  required int inputTokens,
  required int outputTokens,
  required double inputPricePerK,
  required double outputPricePerK,
}) {
  return (inputTokens / 1000 * inputPricePerK) +
         (outputTokens / 1000 * outputPricePerK);
}

// Example
final cost = estimateCost(
  inputTokens: 500,
  outputTokens: 200,
  inputPricePerK: 0.01,  // GPT-4 input
  outputPricePerK: 0.03, // GPT-4 output
);
print('Estimated cost: \$${cost.toStringAsFixed(4)}');
// Output: Estimated cost: $0.0110
```

---

## Summary

You now understand:
- ✅ What AI APIs are and why they're useful
- ✅ Major AI providers and their strengths
- ✅ How to choose the right AI for your needs
- ✅ Key concepts: tokens, context windows, temperature
- ✅ How to get API keys safely
- ✅ Security best practices
- ✅ Cost management strategies
- ✅ Error handling basics
- ✅ Performance and offline considerations
- ✅ Legal and ethical responsibilities

**In the next lesson**, we'll set up our Flutter project with proper API client architecture, secure key management, and create reusable HTTP utilities for AI integrations!

---

## Practice Exercise

Before moving to the next lesson:

1. **Sign up** for API keys from at least 2 providers (OpenAI, Gemini, or Claude)
2. **Test** them in the web playground (without writing code yet)
3. **Experiment** with:
   - Different prompts
   - Temperature settings (0.1, 0.7, 1.5)
   - System prompts
4. **Calculate** how much 1000 API calls would cost with your chosen provider
5. **Write down** 3 AI features you want to build in your app

**Safety Reminder**: Never commit API keys to Git. Keep them secret!
