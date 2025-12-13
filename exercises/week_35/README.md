# Week 35: AI Integration

This week covers integrating AI models and APIs into Flutter applications, including OpenAI (GPT/DALL-E), Google Gemini, and Anthropic Claude.

## Prerequisites

Before starting these exercises, you'll need:

1. **API Keys** (sign up for free trials):
   - OpenAI: https://platform.openai.com/api-keys
   - Google AI Studio (Gemini): https://makersuite.google.com/app/apikey
   - Anthropic (Claude): https://console.anthropic.com/

2. **Flutter Packages**: Add to `pubspec.yaml`:
   ```yaml
   dependencies:
     http: ^1.1.0
     flutter_dotenv: ^5.1.0
     image_picker: ^1.0.4
     speech_to_text: ^6.5.1
     flutter_tts: ^3.8.3
     path_provider: ^2.1.1
     shared_preferences: ^2.2.2
   ```

3. **Environment Setup**:
   Create a `.env` file in your project root:
   ```
   OPENAI_API_KEY=your_openai_key_here
   GEMINI_API_KEY=your_gemini_key_here
   ANTHROPIC_API_KEY=your_anthropic_key_here
   ```

4. **Security Warning**:
   - NEVER commit API keys to version control
   - Add `.env` to your `.gitignore`
   - For production, use backend proxy or Firebase Functions
   - These exercises are for learning purposes only

## Exercises Overview

### Exercise 1: Simple AI Chat with OpenAI (Beginner)
**File**: `exercise_1_template.dart` / `exercise_1_solution.dart`

Learn the basics of AI integration:
- Set up OpenAI API client
- Send messages to GPT-3.5/4
- Handle API responses
- Display in a simple UI
- Manage API keys securely

**Key Concepts**:
- HTTP requests to OpenAI API
- JSON parsing
- Environment variables
- Error handling

**Estimated Time**: 45 minutes

---

### Exercise 2: Conversational AI (Beginner-Intermediate)
**File**: `exercise_2_template.dart` / `exercise_2_solution.dart`

Build a real chat experience:
- Maintain conversation history
- Streaming responses (typewriter effect)
- System prompts for AI personality
- Chat UI with message bubbles
- Loading indicators

**Key Concepts**:
- State management for chat history
- Stream handling
- Custom widgets
- ScrollController

**Estimated Time**: 1.5 hours

---

### Exercise 3: Multi-modal AI with Gemini (Intermediate)
**File**: `exercise_3_template.dart` / `exercise_3_solution.dart`

Work with text and images:
- Text + image input to Gemini
- Image analysis with Gemini Vision
- Camera/gallery integration
- Display AI analysis results
- Handle multiple image formats

**Key Concepts**:
- Image picker
- Base64 encoding
- Multi-part API requests
- Gemini API specifics

**Estimated Time**: 2 hours

---

### Exercise 4: AI with Function Calling (Intermediate-Advanced)
**File**: `exercise_4_template.dart` / `exercise_4_solution.dart`

Let AI use tools:
- Claude API with function calling
- Implement weather, calculator, search tools
- AI decides which tool to use
- Display tool usage in UI
- Chain multiple tool calls

**Key Concepts**:
- Function/tool definitions
- JSON schemas
- Tool execution
- Multi-turn conversations

**Estimated Time**: 2.5 hours

---

### Exercise 5: Complete AI Assistant App (Advanced)
**File**: `exercise_5_template.dart` / `exercise_5_solution.dart`

Build a production-ready AI assistant:
- Support multiple AI providers (OpenAI, Gemini, Claude)
- Image generation with DALL-E
- Speech-to-text input
- Text-to-speech output
- Conversation persistence (local storage)
- Cost tracking per provider
- Rate limiting
- Professional error handling
- Settings and configuration

**Key Concepts**:
- Architecture for multiple providers
- Local data persistence
- Speech integration
- Image generation
- Cost management
- Error boundaries

**Estimated Time**: 4-5 hours

---

## Getting Started

1. **Set up environment**:
   ```bash
   flutter pub get
   # Copy .env.example to .env and add your keys
   ```

2. **Start with Exercise 1**: Work through exercises sequentially

3. **Run an exercise**:
   ```bash
   flutter run lib/path/to/exercise_1_solution.dart
   ```

4. **Test with templates**: Try completing templates before viewing solutions

---

## API Usage and Costs

### Free Tiers (as of 2024):
- **OpenAI**: $5 free trial credit
  - GPT-3.5-Turbo: ~$0.002 per 1K tokens
  - GPT-4: ~$0.03 per 1K tokens
  - DALL-E 3: ~$0.04 per image

- **Gemini**: Free tier available
  - Gemini Pro: 60 requests/minute free
  - Gemini Pro Vision: 60 requests/minute free

- **Claude**: Free tier limited
  - Claude 3 Haiku: ~$0.25 per million tokens
  - Claude 3 Sonnet: ~$3 per million tokens

**Important**: Monitor your usage to avoid unexpected charges!

---

## Common Issues and Solutions

### Issue: API Key Not Found
**Solution**: Ensure `.env` file exists and is loaded in `main.dart`:
```dart
await dotenv.load(fileName: ".env");
```

### Issue: CORS Errors (Web)
**Solution**: AI APIs typically don't allow direct browser calls. Use:
- Flutter mobile/desktop
- Backend proxy server
- Firebase Cloud Functions

### Issue: Rate Limiting
**Solution**: Implement exponential backoff and request queuing (shown in Exercise 5)

### Issue: Large Response Times
**Solution**: Use streaming responses (Exercise 2) for better UX

---

## Best Practices

1. **Security**:
   - Never expose API keys in client code (production)
   - Use backend proxy for production apps
   - Implement authentication
   - Validate all inputs

2. **User Experience**:
   - Show loading indicators
   - Stream responses when possible
   - Handle errors gracefully
   - Provide clear feedback

3. **Cost Management**:
   - Set token limits
   - Cache responses when appropriate
   - Use cheaper models when possible
   - Track usage

4. **Performance**:
   - Implement request queuing
   - Handle cancellation
   - Optimize image sizes
   - Use appropriate timeout values

---

## Additional Resources

- [OpenAI API Documentation](https://platform.openai.com/docs)
- [Google Gemini API Docs](https://ai.google.dev/docs)
- [Anthropic Claude API Docs](https://docs.anthropic.com/)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Best Practices for AI Apps](https://platform.openai.com/docs/guides/production-best-practices)

---

## Next Steps

After completing these exercises, consider:
- Building a specialized AI assistant (coding, writing, etc.)
- Implementing RAG (Retrieval Augmented Generation)
- Fine-tuning models for specific tasks
- Creating AI-powered features in existing apps
- Exploring local AI models (TensorFlow Lite, ONNX)

---

## Support

If you encounter issues:
1. Check API key configuration
2. Verify internet connectivity
3. Review error messages carefully
4. Check API provider status pages
5. Consult official API documentation

Happy coding!
