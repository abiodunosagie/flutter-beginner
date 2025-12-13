# Lesson 4: Integrating Google Gemini (Multi-Modal AI)

## 5-Year-Old Analogy 🖼️

Imagine you have a super smart friend who can not only read and talk, but can also look at pictures and tell you what's in them! You show them a photo of your dog, and they can say "That's a golden retriever playing in the park!" You can even show them a picture of your math homework AND ask a question about it, and they'll help you! That's what Gemini does - it can see pictures AND read text at the same time, making it extra helpful!

---

## What Makes Gemini Special?

**Google Gemini** is Google's most capable AI model family. What makes it unique:

1. **Multi-Modal**: Can process text, images, audio, and video together
2. **Long Context**: Up to 1 million tokens (can read entire books!)
3. **Fast**: Optimized for speed
4. **Generous Free Tier**: Great for learning and prototyping
5. **Google Integration**: Works well with Google services

### Gemini Models

- **Gemini Pro**: Text and code generation (like GPT-3.5/4)
- **Gemini Pro Vision**: Multi-modal (text + images)
- **Gemini Ultra**: Most capable (limited access)
- **Gemini Nano**: On-device AI for mobile

---

## What We'll Build

In this lesson, we'll create:

1. ✅ Text-only chat with Gemini Pro
2. ✅ Image analysis with Gemini Pro Vision
3. ✅ Combined image + text queries
4. ✅ Safety settings configuration
5. ✅ Streaming responses
6. ✅ Camera integration for live image analysis
7. ✅ Multiple image comparison

---

## Step 1: Create Gemini Models

```dart
// lib/models/gemini_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'gemini_models.g.dart';

// Request content part (can be text or image)
@JsonSerializable()
class ContentPart {
  final String? text;
  @JsonKey(name: 'inline_data')
  final InlineData? inlineData;

  ContentPart({this.text, this.inlineData});

  factory ContentPart.text(String text) => ContentPart(text: text);

  factory ContentPart.image({
    required String base64Data,
    required String mimeType,
  }) =>
      ContentPart(
        inlineData: InlineData(
          mimeType: mimeType,
          data: base64Data,
        ),
      );

  factory ContentPart.fromJson(Map<String, dynamic> json) =>
      _$ContentPartFromJson(json);

  Map<String, dynamic> toJson() => _$ContentPartToJson(this);
}

@JsonSerializable()
class InlineData {
  @JsonKey(name: 'mime_type')
  final String mimeType;
  final String data; // Base64 encoded

  InlineData({
    required this.mimeType,
    required this.data,
  });

  factory InlineData.fromJson(Map<String, dynamic> json) =>
      _$InlineDataFromJson(json);

  Map<String, dynamic> toJson() => _$InlineDataToJson(this);
}

// Message content
@JsonSerializable()
class GeminiContent {
  final String role; // 'user' or 'model'
  final List<ContentPart> parts;

  GeminiContent({
    required this.role,
    required this.parts,
  });

  factory GeminiContent.user(String text) => GeminiContent(
        role: 'user',
        parts: [ContentPart.text(text)],
      );

  factory GeminiContent.model(String text) => GeminiContent(
        role: 'model',
        parts: [ContentPart.text(text)],
      );

  factory GeminiContent.userWithImage({
    required String text,
    required String base64Image,
    required String mimeType,
  }) =>
      GeminiContent(
        role: 'user',
        parts: [
          ContentPart.text(text),
          ContentPart.image(base64Data: base64Image, mimeType: mimeType),
        ],
      );

  factory GeminiContent.fromJson(Map<String, dynamic> json) =>
      _$GeminiContentFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiContentToJson(this);
}

// Safety settings
enum HarmCategory {
  @JsonValue('HARM_CATEGORY_HARASSMENT')
  harassment,
  @JsonValue('HARM_CATEGORY_HATE_SPEECH')
  hateSpeech,
  @JsonValue('HARM_CATEGORY_SEXUALLY_EXPLICIT')
  sexuallyExplicit,
  @JsonValue('HARM_CATEGORY_DANGEROUS_CONTENT')
  dangerousContent,
}

enum HarmBlockThreshold {
  @JsonValue('BLOCK_NONE')
  blockNone,
  @JsonValue('BLOCK_ONLY_HIGH')
  blockOnlyHigh,
  @JsonValue('BLOCK_MEDIUM_AND_ABOVE')
  blockMediumAndAbove,
  @JsonValue('BLOCK_LOW_AND_ABOVE')
  blockLowAndAbove,
}

@JsonSerializable()
class SafetySetting {
  final HarmCategory category;
  final HarmBlockThreshold threshold;

  SafetySetting({
    required this.category,
    required this.threshold,
  });

  factory SafetySetting.fromJson(Map<String, dynamic> json) =>
      _$SafetySettingFromJson(json);

  Map<String, dynamic> toJson() => _$SafetySettingToJson(this);
}

// Generation config
@JsonSerializable()
class GenerationConfig {
  final double? temperature;
  @JsonKey(name: 'top_p')
  final double? topP;
  @JsonKey(name: 'top_k')
  final int? topK;
  @JsonKey(name: 'max_output_tokens')
  final int? maxOutputTokens;
  @JsonKey(name: 'stop_sequences')
  final List<String>? stopSequences;

  GenerationConfig({
    this.temperature,
    this.topP,
    this.topK,
    this.maxOutputTokens,
    this.stopSequences,
  });

  factory GenerationConfig.fromJson(Map<String, dynamic> json) =>
      _$GenerationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GenerationConfigToJson(this);
}

// Request
@JsonSerializable()
class GeminiRequest {
  final List<GeminiContent> contents;
  @JsonKey(name: 'safety_settings', includeIfNull: false)
  final List<SafetySetting>? safetySettings;
  @JsonKey(name: 'generation_config', includeIfNull: false)
  final GenerationConfig? generationConfig;

  GeminiRequest({
    required this.contents,
    this.safetySettings,
    this.generationConfig,
  });

  factory GeminiRequest.fromJson(Map<String, dynamic> json) =>
      _$GeminiRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiRequestToJson(this);
}

// Response
@JsonSerializable()
class GeminiCandidate {
  final GeminiContent content;
  @JsonKey(name: 'finish_reason')
  final String? finishReason;
  final int index;
  @JsonKey(name: 'safety_ratings')
  final List<SafetyRating>? safetyRatings;

  GeminiCandidate({
    required this.content,
    this.finishReason,
    required this.index,
    this.safetyRatings,
  });

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) =>
      _$GeminiCandidateFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiCandidateToJson(this);
}

@JsonSerializable()
class SafetyRating {
  final String category;
  final String probability;

  SafetyRating({
    required this.category,
    required this.probability,
  });

  factory SafetyRating.fromJson(Map<String, dynamic> json) =>
      _$SafetyRatingFromJson(json);

  Map<String, dynamic> toJson() => _$SafetyRatingToJson(this);
}

@JsonSerializable()
class GeminiResponse {
  final List<GeminiCandidate> candidates;
  @JsonKey(name: 'prompt_feedback')
  final PromptFeedback? promptFeedback;

  GeminiResponse({
    required this.candidates,
    this.promptFeedback,
  });

  String get text {
    if (candidates.isEmpty) return '';
    return candidates.first.content.parts
        .where((part) => part.text != null)
        .map((part) => part.text!)
        .join('');
  }

  factory GeminiResponse.fromJson(Map<String, dynamic> json) =>
      _$GeminiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiResponseToJson(this);
}

@JsonSerializable()
class PromptFeedback {
  @JsonKey(name: 'safety_ratings')
  final List<SafetyRating>? safetyRatings;

  PromptFeedback({this.safetyRatings});

  factory PromptFeedback.fromJson(Map<String, dynamic> json) =>
      _$PromptFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$PromptFeedbackToJson(this);
}
```

Generate JSON code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Step 2: Create Gemini Client

```dart
// lib/services/gemini_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../models/ai_response.dart';
import '../models/gemini_models.dart';
import '../services/base_http_client.dart';
import '../services/usage_tracker.dart';

class GeminiClient {
  final BaseHTTPClient _httpClient = BaseHTTPClient();
  final APIConfig _config = APIConfig();
  final UsageTracker _tracker = UsageTracker();
  final Logger _logger = Logger();

  // Conversation history
  final List<GeminiContent> _conversationHistory = [];

  List<GeminiContent> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  // Default safety settings (permissive for development)
  static final List<SafetySetting> defaultSafetySettings = [
    SafetySetting(
      category: HarmCategory.harassment,
      threshold: HarmBlockThreshold.blockOnlyHigh,
    ),
    SafetySetting(
      category: HarmCategory.hateSpeech,
      threshold: HarmBlockThreshold.blockOnlyHigh,
    ),
    SafetySetting(
      category: HarmCategory.sexuallyExplicit,
      threshold: HarmBlockThreshold.blockOnlyHigh,
    ),
    SafetySetting(
      category: HarmCategory.dangerousContent,
      threshold: HarmBlockThreshold.blockOnlyHigh,
    ),
  ];

  void clearConversation() {
    _conversationHistory.clear();
  }

  // ========== TEXT-ONLY CHAT ==========

  Future<AIResponse> chat({
    required String prompt,
    String model = 'gemini-pro',
    double temperature = 0.7,
    int maxOutputTokens = 2048,
    bool includeHistory = true,
    List<SafetySetting>? safetySettings,
  }) async {
    try {
      final apiKey = await _config.geminiApiKey;

      if (apiKey.isEmpty) {
        return AIResponse.error(
          error: AIErrorType.authentication,
          errorMessage: 'Gemini API key not found',
          provider: AIProvider.gemini,
          model: model,
        );
      }

      // Add user message
      final userContent = GeminiContent.user(prompt);
      _conversationHistory.add(userContent);

      // Prepare contents
      final contents = includeHistory
          ? List<GeminiContent>.from(_conversationHistory)
          : [userContent];

      // Create request
      final request = GeminiRequest(
        contents: contents,
        safetySettings: safetySettings ?? defaultSafetySettings,
        generationConfig: GenerationConfig(
          temperature: temperature,
          maxOutputTokens: maxOutputTokens,
        ),
      );

      _logger.d('Sending request to Gemini...');

      // Make API call
      final url = '${APIConfig.geminiBaseUrl}/models/$model:generateContent?key=$apiKey';

      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: request.toJson(),
      );

      // Parse response
      final jsonResponse = jsonDecode(response.body);
      final geminiResponse = GeminiResponse.fromJson(jsonResponse);

      final content = geminiResponse.text;

      // Add assistant response to history
      _conversationHistory.add(GeminiContent.model(content));

      // Gemini doesn't return token counts in free tier, estimate
      final estimatedTokens = _estimateTokens(prompt) + _estimateTokens(content);

      final aiResponse = AIResponse.success(
        content: content,
        provider: AIProvider.gemini,
        model: model,
        tokensUsed: estimatedTokens,
        cost: 0.0, // Free tier
        metadata: {
          'finish_reason': geminiResponse.candidates.first.finishReason,
          'safety_ratings': geminiResponse.candidates.first.safetyRatings
              ?.map((r) => '${r.category}: ${r.probability}')
              .join(', '),
        },
      );

      await _tracker.trackRequest(aiResponse);
      return aiResponse;
    } on APIException catch (e) {
      _logger.e('Gemini API error: $e');

      AIErrorType errorType = AIErrorType.unknown;
      if (e.statusCode == 400) errorType = AIErrorType.invalidRequest;
      else if (e.statusCode == 401) errorType = AIErrorType.authentication;
      else if (e.statusCode == 429) errorType = AIErrorType.rateLimit;
      else if (e.statusCode != null && e.statusCode! >= 500)
        errorType = AIErrorType.serverError;

      final errorResponse = AIResponse.error(
        error: errorType,
        errorMessage: e.message,
        provider: AIProvider.gemini,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);
      return errorResponse;
    } catch (e) {
      _logger.e('Unexpected error: $e');

      final errorResponse = AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.gemini,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);
      return errorResponse;
    }
  }

  // ========== IMAGE ANALYSIS ==========

  Future<AIResponse> analyzeImage({
    required File imageFile,
    required String prompt,
    String model = 'gemini-pro-vision',
    double temperature = 0.4,
    int maxOutputTokens = 2048,
    List<SafetySetting>? safetySettings,
  }) async {
    try {
      final apiKey = await _config.geminiApiKey;

      if (apiKey.isEmpty) {
        return AIResponse.error(
          error: AIErrorType.authentication,
          errorMessage: 'Gemini API key not found',
          provider: AIProvider.gemini,
          model: model,
        );
      }

      // Read image as bytes
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Determine MIME type
      final extension = imageFile.path.split('.').last.toLowerCase();
      final mimeType = _getMimeType(extension);

      _logger.d('Image size: ${imageBytes.length} bytes, type: $mimeType');

      // Create content with image
      final userContent = GeminiContent(
        role: 'user',
        parts: [
          ContentPart.text(prompt),
          ContentPart.image(base64Data: base64Image, mimeType: mimeType),
        ],
      );

      // Create request
      final request = GeminiRequest(
        contents: [userContent],
        safetySettings: safetySettings ?? defaultSafetySettings,
        generationConfig: GenerationConfig(
          temperature: temperature,
          maxOutputTokens: maxOutputTokens,
        ),
      );

      // Make API call
      final url = '${APIConfig.geminiBaseUrl}/models/$model:generateContent?key=$apiKey';

      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: request.toJson(),
      );

      // Parse response
      final jsonResponse = jsonDecode(response.body);
      final geminiResponse = GeminiResponse.fromJson(jsonResponse);

      final content = geminiResponse.text;

      final aiResponse = AIResponse.success(
        content: content,
        provider: AIProvider.gemini,
        model: model,
        cost: 0.0,
        metadata: {
          'image_size': imageBytes.length,
          'mime_type': mimeType,
          'finish_reason': geminiResponse.candidates.first.finishReason,
        },
      );

      await _tracker.trackRequest(aiResponse);
      return aiResponse;
    } catch (e) {
      _logger.e('Image analysis error: $e');

      final errorResponse = AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.gemini,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);
      return errorResponse;
    }
  }

  // ========== MULTIPLE IMAGES ==========

  Future<AIResponse> analyzeMultipleImages({
    required List<File> imageFiles,
    required String prompt,
    String model = 'gemini-pro-vision',
    double temperature = 0.4,
    int maxOutputTokens = 2048,
  }) async {
    try {
      final apiKey = await _config.geminiApiKey;

      if (apiKey.isEmpty) {
        return AIResponse.error(
          error: AIErrorType.authentication,
          errorMessage: 'Gemini API key not found',
          provider: AIProvider.gemini,
          model: model,
        );
      }

      // Prepare parts (text + multiple images)
      final parts = <ContentPart>[
        ContentPart.text(prompt),
      ];

      for (final imageFile in imageFiles) {
        final imageBytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(imageBytes);
        final extension = imageFile.path.split('.').last.toLowerCase();
        final mimeType = _getMimeType(extension);

        parts.add(ContentPart.image(
          base64Data: base64Image,
          mimeType: mimeType,
        ));
      }

      final userContent = GeminiContent(role: 'user', parts: parts);

      final request = GeminiRequest(
        contents: [userContent],
        safetySettings: defaultSafetySettings,
        generationConfig: GenerationConfig(
          temperature: temperature,
          maxOutputTokens: maxOutputTokens,
        ),
      );

      final url = '${APIConfig.geminiBaseUrl}/models/$model:generateContent?key=$apiKey';

      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: request.toJson(),
      );

      final jsonResponse = jsonDecode(response.body);
      final geminiResponse = GeminiResponse.fromJson(jsonResponse);

      final content = geminiResponse.text;

      final aiResponse = AIResponse.success(
        content: content,
        provider: AIProvider.gemini,
        model: model,
        cost: 0.0,
        metadata: {
          'image_count': imageFiles.length,
        },
      );

      await _tracker.trackRequest(aiResponse);
      return aiResponse;
    } catch (e) {
      _logger.e('Multiple images analysis error: $e');

      final errorResponse = AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.gemini,
        model: model,
      );

      await _tracker.trackRequest(errorResponse);
      return errorResponse;
    }
  }

  // ========== STREAMING ==========

  Stream<String> chatStream({
    required String prompt,
    String model = 'gemini-pro',
    double temperature = 0.7,
    int maxOutputTokens = 2048,
    bool includeHistory = true,
  }) async* {
    try {
      final apiKey = await _config.geminiApiKey;

      if (apiKey.isEmpty) {
        yield '[ERROR: Gemini API key not found]';
        return;
      }

      final userContent = GeminiContent.user(prompt);
      _conversationHistory.add(userContent);

      final contents = includeHistory
          ? List<GeminiContent>.from(_conversationHistory)
          : [userContent];

      final request = GeminiRequest(
        contents: contents,
        safetySettings: defaultSafetySettings,
        generationConfig: GenerationConfig(
          temperature: temperature,
          maxOutputTokens: maxOutputTokens,
        ),
      );

      // Streaming endpoint
      final url = '${APIConfig.geminiBaseUrl}/models/$model:streamGenerateContent?key=$apiKey';

      final httpRequest = http.Request('POST', Uri.parse(url));
      httpRequest.headers['Content-Type'] = 'application/json';
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
        if (chunk.isEmpty) continue;

        try {
          // Gemini streams JSON objects separated by newlines
          final json = jsonDecode(chunk);
          final response = GeminiResponse.fromJson(json);
          final text = response.text;

          if (text.isNotEmpty) {
            fullResponse += text;
            yield text;
          }
        } catch (e) {
          _logger.w('Error parsing stream chunk: $e');
        }
      }

      if (fullResponse.isNotEmpty) {
        _conversationHistory.add(GeminiContent.model(fullResponse));
      }
    } catch (e) {
      _logger.e('Streaming error: $e');
      yield '[ERROR: $e]';
    }
  }

  // ========== HELPERS ==========

  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  int _estimateTokens(String text) {
    return (text.length / 4).ceil();
  }
}
```

---

## Step 3: Add Image Picker Dependency

Add to `pubspec.yaml`:

```yaml
dependencies:
  image_picker: ^1.0.7
  permission_handler: ^11.2.0
```

```bash
flutter pub get
```

---

## Step 4: Create Vision Chat Screen

```dart
// lib/screens/gemini_vision_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_client.dart';
import '../models/ai_response.dart';

class GeminiVisionScreen extends StatefulWidget {
  const GeminiVisionScreen({Key? key}) : super(key: key);

  @override
  State<GeminiVisionScreen> createState() => _GeminiVisionScreenState();
}

class _GeminiVisionScreenState extends State<GeminiVisionScreen> {
  final GeminiClient _client = GeminiClient();
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  String _result = '';
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _result = '';
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showError('Please select an image first');
      return;
    }

    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      _showError('Please enter a question about the image');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = 'Analyzing...';
    });

    final response = await _client.analyzeImage(
      imageFile: _selectedImage!,
      prompt: prompt,
    );

    setState(() {
      _isLoading = false;
      if (response.isSuccess) {
        _result = response.content!;
      } else {
        _result = '❌ Error: ${response.errorMessage}';
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Vision'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '1. Select an Image',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Prompt input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '2. Ask a Question',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _promptController,
                      decoration: const InputDecoration(
                        hintText: 'What do you see in this image?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Quick prompts
                    Wrap(
                      spacing: 8,
                      children: [
                        _quickPromptChip('What is in this image?'),
                        _quickPromptChip('Describe this image in detail'),
                        _quickPromptChip('What colors are dominant?'),
                        _quickPromptChip('Is there any text in this image?'),
                        _quickPromptChip('What emotions does this convey?'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Analyze button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _analyzeImage,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.psychology),
              label: const Text('Analyze Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // Result
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Result',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(_result),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _quickPromptChip(String prompt) {
    return ActionChip(
      label: Text(prompt),
      onPressed: () {
        setState(() {
          _promptController.text = prompt;
        });
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini Vision'),
        content: const Text(
          'Gemini Pro Vision can:\n\n'
          '• Describe images in detail\n'
          '• Identify objects, people, places\n'
          '• Read text in images (OCR)\n'
          '• Answer questions about images\n'
          '• Compare multiple images\n'
          '• Analyze emotions and scenes\n\n'
          'Try different prompts to explore its capabilities!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
```

---

## Step 5: Create Multi-Image Comparison Screen

```dart
// lib/screens/gemini_multi_image_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_client.dart';

class GeminiMultiImageScreen extends StatefulWidget {
  const GeminiMultiImageScreen({Key? key}) : super(key: key);

  @override
  State<GeminiMultiImageScreen> createState() => _GeminiMultiImageScreenState();
}

class _GeminiMultiImageScreenState extends State<GeminiMultiImageScreen> {
  final GeminiClient _client = GeminiClient();
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<File> _selectedImages = [];
  String _result = '';
  bool _isLoading = false;

  Future<void> _addImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
          _result = '';
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _compareImages() async {
    if (_selectedImages.length < 2) {
      _showError('Please select at least 2 images to compare');
      return;
    }

    String prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      prompt = 'Compare these images. What are the similarities and differences?';
    }

    setState(() {
      _isLoading = true;
      _result = 'Comparing images...';
    });

    final response = await _client.analyzeMultipleImages(
      imageFiles: _selectedImages,
      prompt: prompt,
    );

    setState(() {
      _isLoading = false;
      if (response.isSuccess) {
        _result = response.content!;
      } else {
        _result = '❌ Error: ${response.errorMessage}';
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Images'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Selected Images (${_selectedImages.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    if (_selectedImages.isEmpty)
                      const Text('No images selected'),
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _selectedImages[index],
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () => _removeImage(index),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addImage,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Image'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Comparison Prompt',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _promptController,
                      decoration: const InputDecoration(
                        hintText: 'What should I compare?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        _quickPromptChip('Compare similarities and differences'),
                        _quickPromptChip('Which image is better quality?'),
                        _quickPromptChip('Describe each image'),
                        _quickPromptChip('Which photo was taken first?'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _compareImages,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.compare),
              label: const Text('Compare Images'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Comparison Result',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(_result),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _quickPromptChip(String prompt) {
    return ActionChip(
      label: Text(prompt),
      onPressed: () {
        setState(() {
          _promptController.text = prompt;
        });
      },
    );
  }
}
```

---

## Step 6: Update Main App

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/gemini_vision_screen.dart';
import 'screens/gemini_multi_image_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Vision Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const GeminiHomeScreen(),
    );
  }
}

class GeminiHomeScreen extends StatelessWidget {
  const GeminiHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini AI Demos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDemoCard(
            context,
            title: 'Image Analysis',
            description: 'Analyze a single image with AI',
            icon: Icons.image_search,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GeminiVisionScreen(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDemoCard(
            context,
            title: 'Compare Images',
            description: 'Compare multiple images',
            icon: Icons.compare,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GeminiMultiImageScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Use Cases for Gemini Vision

### 1. Product Identification
```dart
analyzeImage(
  imageFile: productPhoto,
  prompt: 'What product is this? Provide the brand, model, and estimated price.',
);
```

### 2. Document OCR
```dart
analyzeImage(
  imageFile: receipt,
  prompt: 'Extract all text from this receipt and format it as a list.',
);
```

### 3. Accessibility
```dart
analyzeImage(
  imageFile: photo,
  prompt: 'Describe this image in detail for a visually impaired person.',
);
```

### 4. Food Recognition
```dart
analyzeImage(
  imageFile: foodPhoto,
  prompt: 'What food is this? Estimate calories and nutritional information.',
);
```

### 5. Homework Helper
```dart
analyzeImage(
  imageFile: mathProblem,
  prompt: 'Solve this math problem step by step.',
);
```

---

## Summary

You now have:

- ✅ Text chat with Gemini Pro
- ✅ Image analysis with Gemini Pro Vision
- ✅ Multiple image comparison
- ✅ Camera and gallery integration
- ✅ Safety settings configuration
- ✅ Error handling
- ✅ Clean UI with quick prompts

**Next lesson**: We'll integrate Anthropic Claude and explore advanced features like function calling and extended thinking!

---

## Practice Exercises

1. Add **image filters** before analysis (brightness, contrast)
2. Implement **batch image processing**
3. Add **voice prompts** (speech-to-text)
4. Create **image history** with cached results
5. Build a **receipt scanner** app
6. Create a **plant identifier**
7. Build a **homework helper** with step-by-step solutions
8. Add **real-time camera analysis**
